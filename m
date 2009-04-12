Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZDMBUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZDMBUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZDMBUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:20:17 -0400
Received: from mango.safe-mail.net ([213.8.192.71]:50052 "EHLO
	mango.safe-mail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZDMBUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:20:15 -0400
X-Greylist: delayed 8420 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2009 21:20:15 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
	s=N1-0105; d=Safe-mail.net;
	b=tC/q9PpP5FliRUPe5SGMuANw8ElIdosGp69xOTlHGT92nCBPTYfC5Hk/4rGpzW+W
	Jj21VFPAAjaedPponUtNR8oSbT9BeTJPe0kzK0qKWv5hLTbxHU3TjEu2KrXaR0ym
	Dr41NQFslkRQxjchR3S+H/dbKqyYkJtwrj+QVEftCRI=;
Subject: Unknown initrd commands
Date: Sun, 12 Apr 2009 15:59:36 -0700
From: stonee@Safe-mail.net
To: linux-kernel@vger.kernel.org
CC: stonee@Safe-mail.net
X-SMType: Regular
X-SMRef: N1N-uRW2YWBw5x
Message-Id: <N1N-uRW2YWBw5x@Safe-mail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SMSignature: H+4oMZdWtGCDrS9RwEbNDD0YatwZtmXMFxoor//sFJx4dj248HMvTG8G96vgy5u6
	RkFMRZoNGG9e7cE53Q20j1uZ9Rfcv4x55aRstK8J7BUF0zAKiziXsHeKcfnq3+KP
	qQyjY70G3/f76ca5yLZySNsYtXX24vSsV9MWoVLIX/M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been digging around a few times online, and have not been able to find where some commands invoked from the Fedora init script are located.

The contents of the script are as follows along with some notes that I've added:

--------------------------------------------------------------------------------------------

#!/bin/nash

mount -t proc /proc /proc

setquiet
   # nash: cause any late echos in this start script not to be displayed

echo Mounting proc filesystem
echo Mounting sysfs filesystem
mount -t sysfs /sys /sys
echo Creating /dev
mount -o mode=0755 -t tmpfs /dev /dev
mkdir /dev/pts
mount -t devpts -o gid=5,mode=620 /dev/pts /dev/pts
mkdir /dev/shm
mkdir /dev/mapper
echo Creating initial device nodes
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mknod /dev/systty c 4 0
mknod /dev/tty c 5 0
mknod /dev/console c 5 1
mknod /dev/ptmx c 5 2
mknod /dev/tty0 c 4 0
mknod /dev/tty1 c 4 1
mknod /dev/tty2 c 4 2
mknod /dev/tty3 c 4 3
mknod /dev/tty4 c 4 4
mknod /dev/tty5 c 4 5
mknod /dev/tty6 c 4 6
mknod /dev/tty7 c 4 7
mknod /dev/tty8 c 4 8
mknod /dev/tty9 c 4 9
mknod /dev/tty10 c 4 10
mknod /dev/tty11 c 4 11
mknod /dev/tty12 c 4 12
mknod /dev/ttyS0 c 4 64
mknod /dev/ttyS1 c 4 65
mknod /dev/ttyS2 c 4 66
mknod /dev/ttyS3 c 4 67
echo Setting up hotplug.

hotplug
   # /etc/sysconfig/network-scripts/net.hotplug
   # /lib/modules/2.6.25-14.fc9.i686/kernel/drivers/pci/hotplug/
   # 

echo Creating block device nodes.

mkblkdevs
   # ? 

echo "Loading ehci-hcd module"
modprobe -q ehci-hcd
echo "Loading ohci-hcd module"
modprobe -q ohci-hcd
echo "Loading uhci-hcd module"
modprobe -q uhci-hcd
mount -t usbfs /proc/bus/usb /proc/bus/usb
echo "Loading pata_via module"
modprobe -q pata_via
echo Waiting for driver initialization.

stabilized --hash --interval 250 /proc/scsi/scsi
   # ?

mkblkdevs
   # ?

resume /dev/sda2
   # ?

echo Creating root device.
mkrootdev -t ext3 -o defaults,ro /dev/sda1
echo Mounting root filesystem.
mount /sysroot
echo Setting up other filesystems.

setuproot
   # ?

loadpolicy
   # ?

echo Switching to new root and running init.

switchroot
   # nash command

echo Booting has failed.
sleep -1

--------------------------------------------------------------------------------------------

Where are these commands documented? Also, do initrd/nash have a home page? 

Thanks! 

By the way, please include my safemail e-mail in responses as I am not subscribed to the list.


stonee
