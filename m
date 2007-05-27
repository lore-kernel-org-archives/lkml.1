Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbXE0Cnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbXE0Cnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXE0Cnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:43:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:49328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXE0Cnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:43:40 -0400
Subject: Re: udev regression? lsusb silent (no output) since 2.6.22-rc2 at
	least
From: Kay Sievers <kay.sievers@vrfy.org>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
In-Reply-To: <20070526201854.GA20758@outpost.ds9a.nl>
References: <20070526201854.GA20758@outpost.ds9a.nl>
Content-Type: text/plain
Date: Sun, 27 May 2007 04:42:35 +0200
Message-Id: <1180233755.3131.4.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19F6GGZSy5+dsg+R4+Cl+qRFdL7neBmkgH0sOg
 i0kp8mvSOgWDxjaixmh3/YYn/v87K18NQ7LNBO2kt9tG/faxfw
 /0zT58aRzB4MT0tFcIcmDmMQdE2s7te
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-26 at 22:18 +0200, bert hubert wrote:
> Today I booted 2.6.22-rc2 on Ubunty Edgy Eft, and lsusb died on me:
> 
> ahu@intel:~$ lsusb
> ahu@intel:~$ sudo lsusb
> ahu@intel:~$ 
> 
> This behaviour persists in rc4. This might be udev related. I'm running:
> ii  udev                                   093-0ubuntu18.0edgy2 
> 
> USB does work fine.
> 
> Bit from strace:
> 
> open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
> fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
> fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
> getdents64(3, /* 4 entries */, 4096)    = 112
> close(3)                                = 0
> open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
> fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
> fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
> getdents64(3, /* 4 entries */, 4096)    = 112
> getdents64(3, /* 0 entries */, 4096)    = 0
> close(3)                                = 0
> (end of program)
> 
> ahu@intel:~$ ls -l /dev/bus/usb -d
> drwxr-xr-x 3 root root 80 2007-05-26 21:58 /dev/bus/usb
> 
> ahu@intel:~$ ls -l /dev/bus/usb/
> total 0
> lrwxrwxrwx 1 root root 14 2007-05-26 21:58 devices -> .usbfs/devices
> 
> ahu@intel:~$ ls -l /dev/bus/usb/devices 
> lrwxrwxrwx 1 root root 14 2007-05-26 21:58 /dev/bus/usb/devices ->
> .usbfs/devices
> 
> ahu@intel:~$ wc -l /dev/bus/usb/devices
> 95 /dev/bus/usb/devices
> 
> On another machine (debian etch), with an older kernel, where lsusb does
> work:
> 
> open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
> fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
> fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
> getdents64(3, /* 4 entries */, 4096)    = 96
> close(3)                                = 0 
> open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
> fstat64(3, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
> fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
> getdents64(3, /* 4 entries */, 4096)    = 96
> getdents64(3, /* 0 entries */, 4096)    = 0 
> close(3)                                = 0 
> open("/dev/bus/usb/001", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
> fstat64(3, {st_mode=S_IFDIR|0755, st_size=60, ...}) = 0
> fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
> getdents64(3, /* 3 entries */, 4096)    = 72
> open("/dev/bus/usb/001/001", O_RDWR)    = -1 EACCES (Permission denied)
> open("/dev/bus/usb/001/001", O_RDONLY)  = 4
> 
> Any clues? Please let me know how I can help solve this problem!

It works fine for me here. Do you have CONFIG_USB_DEVICE_CLASS=y set?

Kay

