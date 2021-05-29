#!/bin/bash
PATH=/bin:/usr/bin
THISFILENAME="$(openssl rand -hex 8).txt"
THISSTRING="\n*****************************************************************\n"

echo "Maintenance for $HOSTNAME" >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

gpu=$(/opt/vc/bin/vcgencmd measure_temp | awk -F "[=\']" '{print $2}')
cpu=$(</sys/class/thermal/thermal_zone0/temp)
cpu=$(echo "$cpu / 100 * 0.1" | bc)
cpuf=$(echo "(1.8 * $cpu) + 32" |bc)
gpuf=$(echo "(1.8 * $gpu) + 32" |bc)

echo "[Starting]" 2>&1 | ts >> ~/$THISFILENAME

################# ONLY NEEDED IF USING A READ ONLY SYSTEM ################
echo "[Changing File System to read/write]" 2>&1 | ts >> ~/$THISFILENAME
sudo mount -o remount,rw /boot 2>&1 | >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME
##########################################################################

echo "[Current GPU Temp] GPU => $gpu'C ($gpuf'F)" 2>&1 | ts >> ~/$THISFILENAME
echo "[Current CPU Temp] CPU => $cpu'C ($cpuf'F)" 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

echo "[Running Update]" 2>&1 | ts >> ~/$THISFILENAME
apt-get update -y 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

echo "[Running Upgrade]" 2>&1 | ts >> ~/$THISFILENAME
apt-get upgrade -y 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

echo "[Running Dist-Upgrade]" 2>&1 | ts >> ~/$THISFILENAME
apt-get dist-upgrade -y 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

echo "[Running Autoremove]" 2>&1 | ts >> ~/$THISFILENAME
apt-get autoremove -y 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

echo "[Running Autoclean]" 2>&1 | ts >> ~/$THISFILENAME
apt-get autoclean -y 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

echo "[Showing Free Space Information]" 2>&1 | ts >> ~/$THISFILENAME
sudo df 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

################# ONLY NEEDED IF USING A READ ONLY SYSTEM ################
echo "[Changing File System to read only]" 2>&1 | ts >> ~/$THISFILENAME
sudo mount -o remount,ro /boot 2>&1 | >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME
##########################################################################

echo "[Finishing and rebooting: sudo reboot now]" 2>&1 | ts >> ~/$THISFILENAME
echo -e $THISSTRING >> ~/$THISFILENAME

#cat ~/$THISFILENAME | gpg -ear "<address1@mail.com>" | mail -a "Subject: Monthly Maintenance" -a "X-Custom-Header: yes" "address2@mail.com"

srm -vz  ~/$THISFILENAME
unset THISFILENAME
sudo reboot now

exit 0
