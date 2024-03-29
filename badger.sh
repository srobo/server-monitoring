#!/bin/sh

if [ "$SSH_ORIGINAL_COMMAND" == "" ]; then
	COMMAND="$1"
else
	COMMAND="$SSH_ORIGINAL_COMMAND"
fi

case $COMMAND in
#-------------------
#generic checks
#-------------------
	"check_users")
		/usr/lib64/nagios/plugins/check_users -w 20 -c 30
		;;
	"check_load")
		/usr/lib64/nagios/plugins/check_load --warning='5.0,4.0,3.0' --critical='10.0,6.0,4.0'
		;;
	"check_disk")
		/usr/lib64/nagios/plugins/check_disk -w '20%' -c '10%' -e
		;;
	"check_procs")
		/usr/lib64/nagios/plugins/check_procs -w '250' -c '400'
		;;
	"check_procs_z")
		/usr/lib64/nagios/plugins/check_procs -w '1' -c '1' -s Z
		;;
	"check_uptime")
		/srv/monitoring/commands/check_uptime -w 120
		;;
	"check_swap")
		/usr/lib64/nagios/plugins/check_swap -w 75% -c 50%
		;;
	"check_mem")
		/srv/monitoring/commands/check_mem 100 50
		;;
	"check_packages")
		/usr/lib64/nagios/plugins/check_updates
		;;

#-------------------
#other checks
#-------------------
	"check_mysql")
		/usr/lib64/nagios/plugins/check_mysql
		;;
	"check_ldap")
		/usr/lib64/nagios/plugins/check_ldap -H localhost -b "ou=users,o=sr" -3 -v
		;;
	"check_puppet")
		sudo /srv/monitoring/commands/check_puppet_agent -w 90000 -c 90000 2> /dev/null
		;;
	"check_git_repos")
		/srv/monitoring/commands/check_git_repos --diverged-criticial --ahead-criticial /srv/backup/.git/ /srv/monitoring/.git/ /etc/puppet/.git/
		;;



#-------------------
#fallback
#-------------------
	"motd")
		cat /etc/motd
		;;
        *)
                echo "Unknown command"
esac
