echo Input root password if not already root

if [[ $EUID -ne 0 ]]; then
  sudo -v
fi

read -p "Enter the username you created earlier: " username
read -p "Enter the password you would to decrypt your home folder like and WRITE IT DOWN: " password

echo Encrypting our hidden partition:
sleep 3s
zuluCrypt-cli -c -d /dev/vdb -z ext4 -t luks2 -p "$password"
echo Unlocking out hidden partition:
sleep 3s
zuluCrypt-cli -o -d /dev/vdb -M vdb -e rw -p "$password"

cd /run/media/public/vdb/

echo Adding your username to the sytem:
sleep 3s
useradd -s /usr/bin/zsh -d /run/media/public/vdb/.swap -m "$username"

echo input a password for your login:
passwd "$username"

echo Adding user to specified groups
sleep 3s
usermod -a -G cdrom,floppy,sudo,audio,dip,video,plugdev,users,netdev,console,debian-tor "$username"

echo Change ownership of home directory
sleep 3s
chown -R "$username":"$username" /run/media/public/vdb/.swap

echo Create home directory for your account:
sleep 3s
mkdir /home/"$username"

echo Mount the home directory from external volume to /home/:
sleep 3s
mount --bind --verbose /run/media/public/vdb/.swap/ /home/"$username"
