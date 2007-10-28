Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXJ1SgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXJ1SgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXJ1SgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:36:11 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31264 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXJ1SgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:36:09 -0400
Date: Sun, 28 Oct 2007 12:37:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Major SATA / EXT3 Issue?
In-reply-to: <fa.g6cnSE4eZYP/DJbEoDA1gYUnPfo@ifi.uio.no>
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Message-id: <4724D6DF.4090602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.g6cnSE4eZYP/DJbEoDA1gYUnPfo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Holvenstot wrote:
> I am curious if anyone else has had major problems with SATA drives on
> the current series of kernels.  I have (or rather had) two SATA drives
> on my system - the first was a Maxtor MaxLine 500 and the second was a
> Maxtor MaxLine 250.
> 
> Both of these drives were plugged to the 1.5 Gigabyte / second mode.
> 
> My SATA controller is integrated on my MSI motherboard and sports four
> ports.  It is implemented using the Nvidia CK804 chipset.  My processor
> is an AMD64 X2 4600+ running the 32 bit version of Linux.  
> 
> I have had these drives up and running for about six months.
> 
> The first drive "failed" about 10 days ago - and unfortunately I focused
> on hardware error and after several attempts to get the drive back
> online I physically pulled it from the system.  This drive was used for
> backups and thus was not critical to day-to-day operations.  
> 
> However, tonight I "lost" a second SATA drive, this one I use on a daily
> basis for my kernel build and test processes.  It failed in the same
> manner as the first, which makes me a little suspicious.
> 
> 
> The first drive “failed” while I was running a modified Ubuntu 7.04
> system. Because I focused on hardware as the reason for the failure I
> did not collect specific information about the version of the kernel
> being used, but it was likely to be 2.6.24-git8.
> 
> 
> The second drive “failed” tonight on what is, except for the kernel, a
> fairly standard Ubuntu 7.10 system (the same hardware - I upgraded my OS
> this past week) – the kernel in use tonight at the time of the second
> failure was 2.6.24-rc1-git1
> 
> 
> In each case the failure mode appears to have been the same – the system
> appears to lock up. When rebooted I get a long string of messages like:
> 
> 
> Oct 26 20:07:37 localhost kernel: [ 101.581091] ata2: timeout waiting
> for ADMA IDLE, stat=0x440
> 
> Oct 26 20:07:37 localhost kernel: [ 101.581096] sd 1:0:0:0: [sda] Write
> Protect is off
> 
> Oct 26 20:07:37 localhost kernel: [ 101.581174] res
> 71/04:08:00:00:00/04:00:1d:00:00/e0 Emask 0x1 (device error)
> 
> Oct 26 20:07:37 localhost kernel: [ 101.644992] ata2.00: configured for
> UDMA/33
> 
> Oct 26 20:07:37 localhost kernel: [ 101.644994] ata2: EH complete
> 
> Oct 26 20:07:37 localhost kernel: [ 101.645006] sd 1:0:0:0: [sda] Write
> cache: disabled, read cache: enabled, doesn't support DPO or FUA

You should try and get some output from dmesg and not from the messages 
log, as the log daemon seems to have a nasty habit of discarding 
critical output from these errors. In this case the failing command is 
missing and the message ordering even seems off.

> 
> 
> The hardware appears to be correctly identified by the BIOS during the
> power up sequence. 
> 
> 
> Not much is seen in the dmesg log excpet for:
> 
> 
> [ 43.649673] scsi0 : sata_nv
> 
> [ 43.649722] scsi1 : sata_nv
> 
> [ 43.649776] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xcc00
> irq 19
> 
> [ 43.649778] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xcc08
> irq 19

There should be more than this at the very least.. As above, please try 
to get output from dmesg itself.

> 
> 
> When I try to run a file system check on these devices I get:
> 
> 
> 
> 
> e2fsck 1.40.2 (12-Jul-2007)
> 
> fsck.ext2: No such file or directory while trying to open /dev/sdb1
> 
> The superblock could not be read or does not describe a correct ext2
> 
> filesystem. If the device is valid and it really contains an ext2
> 
> filesystem (and not swap or ufs or something else), then the superblock
> 
> is corrupt, and you might try running e2fsck with an alternate
> superblock:
> 
> e2fsck -b 8193 <device>
> 
> 
> I have a gut feeling that when the system appears to lock up what is
> really going on is that the contents of the drive are being trashed. But
> I have no proof of that.

I don't think that is the case, more like the drives have not been 
detected at all. If this happens after a reboot when they were working 
before, that sounds like some kind of a hardware issue most likely..

> 
> 
> When I try to do a parted to see what the system thinks is on the drive
> I get the error message:
> 
> 
> Error: Error opening /dev/sdb: No medium found 
> 
> 
> I am not having any problems with my EXT3 file systems located on
> “standard” IDE / PATA drives.
> 
> 
> My config file, which has not changed in months beyond taking the
> defaults during make oldconfig looks like:

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

