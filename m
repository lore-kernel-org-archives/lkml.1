Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbXE0FgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbXE0FgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 01:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXE0FgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 01:36:12 -0400
Received: from mx1.suse.de ([195.135.220.2]:35075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbXE0FgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 01:36:11 -0400
Date: Sat, 26 May 2007 22:37:36 -0700
From: Greg KH <gregkh@suse.de>
To: bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org,
       kay.sievers@vrfy.org
Subject: Re: udev regression? lsusb silent (no output) since 2.6.22-rc2 at
	least
Message-ID: <20070527053736.GA20903@suse.de>
References: <20070526201854.GA20758@outpost.ds9a.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070526201854.GA20758@outpost.ds9a.nl>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 10:18:54PM +0200, bert hubert wrote:
> Greg, Kay, kernel people,
> 
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

What is that kernel version?

This works fine for me here too...

thanks,

greg k-h
