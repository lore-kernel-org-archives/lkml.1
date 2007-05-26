Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbXEZUtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbXEZUtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbXEZUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:49:18 -0400
Received: from outpost.ds9a.nl ([213.244.168.210]:51116 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777AbXEZUtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:49:17 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 May 2007 16:49:17 EDT
Date: Sat, 26 May 2007 22:18:54 +0200
From: bert hubert <bert.hubert@netherlabs.nl>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: kay.sievers@vrfy.org
Subject: udev regression? lsusb silent (no output) since 2.6.22-rc2 at least
Message-ID: <20070526201854.GA20758@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	linux-kernel@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Kay, kernel people,

Today I booted 2.6.22-rc2 on Ubunty Edgy Eft, and lsusb died on me:

ahu@intel:~$ lsusb
ahu@intel:~$ sudo lsusb
ahu@intel:~$ 

This behaviour persists in rc4. This might be udev related. I'm running:
ii  udev                                   093-0ubuntu18.0edgy2 

USB does work fine.

Bit from strace:

open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 4 entries */, 4096)    = 112
close(3)                                = 0
open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 4 entries */, 4096)    = 112
getdents64(3, /* 0 entries */, 4096)    = 0
close(3)                                = 0
(end of program)

ahu@intel:~$ ls -l /dev/bus/usb -d
drwxr-xr-x 3 root root 80 2007-05-26 21:58 /dev/bus/usb

ahu@intel:~$ ls -l /dev/bus/usb/
total 0
lrwxrwxrwx 1 root root 14 2007-05-26 21:58 devices -> .usbfs/devices

ahu@intel:~$ ls -l /dev/bus/usb/devices 
lrwxrwxrwx 1 root root 14 2007-05-26 21:58 /dev/bus/usb/devices ->
.usbfs/devices

ahu@intel:~$ wc -l /dev/bus/usb/devices
95 /dev/bus/usb/devices

On another machine (debian etch), with an older kernel, where lsusb does
work:

open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 4 entries */, 4096)    = 96
close(3)                                = 0 
open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 4 entries */, 4096)    = 96
getdents64(3, /* 0 entries */, 4096)    = 0 
close(3)                                = 0 
open("/dev/bus/usb/001", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=60, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 3 entries */, 4096)    = 72
open("/dev/bus/usb/001/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/001", O_RDONLY)  = 4

Any clues? Please let me know how I can help solve this problem!

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
