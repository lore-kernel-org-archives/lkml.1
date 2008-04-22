Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYDVPeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYDVPeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYDVPeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:34:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23684 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYDVPeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:34:03 -0400
Date: Tue, 22 Apr 2008 08:32:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Kara <jack@suse.cz>, linux-usb@vger.kernel.org
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: ./fs/partitions/check.c: off-by-one error ?
Message-Id: <20080422083214.cbfa3786.randy.dunlap@oracle.com>
In-Reply-To: <20080422103829.GC21922@atrey.karlin.mff.cuni.cz>
References: <200804201235.46552.toralf.foerster@gmx.de>
	<20080422103829.GC21922@atrey.karlin.mff.cuni.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 12:38:29 +0200 Jan Kara wrote:

> > Inserting an 2 GB SD Card into my digikam and mounting it as an USB drive I've
> > in my system log :
> > 
> > Apr 20 12:27:54 n22 usb 2-2: new full speed USB device using uhci_hcd and address 4
> > Apr 20 12:27:54 n22 usb 2-2: configuration #1 chosen from 1 choice
> > Apr 20 12:27:54 n22 SCSI subsystem initialized
> > Apr 20 12:27:54 n22 Initializing USB Mass Storage driver...
> > Apr 20 12:27:54 n22 scsi0 : SCSI emulation for USB Mass Storage devices
> > Apr 20 12:27:54 n22 usbcore: registered new interface driver usb-storage
> > Apr 20 12:27:54 n22 USB Mass Storage support registered.
> > Apr 20 12:27:54 n22 usb-storage: device found at 4
> > Apr 20 12:27:54 n22 usb-storage: waiting for device to settle before scanning
> > Apr 20 12:27:59 n22 scsi 0:0:0:0: Direct-Access     MATSHITA DMC-TZ3          0100 PQ: 0 ANSI: 2
> > Apr 20 12:27:59 n22 usb-storage: device scan complete
> > Apr 20 12:27:59 n22 Driver 'sd' needs updating - please use bus_type methods
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] 3902463 512-byte hardware sectors (1998 MB)
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Write Protect is off
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Mode Sense: 04 00 00 00
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Assuming drive cache: write through
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] 3902463 512-byte hardware sectors (1998 MB)
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Write Protect is off
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Mode Sense: 04 00 00 00
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Assuming drive cache: write through
> > Apr 20 12:27:59 n22 sda: sda1
> > Apr 20 12:27:59 n22 sda: p1 exceeds device capacity
> > Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Attached SCSI removable disk
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > Apr 20 12:27:59 n22 attempt to access beyond end of device
> > Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> > Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> > 
> > My system is a :
> > 
> > tfoerste@n22 ~/devel/linux-2.6/fs/partitions $ uname -a
> > Linux n22 2.6.24-gentoo-r4 #4 Sun Apr 20 12:16:18 CEST 2008 i686 Intel(R)
> > Pentium(R) M processor 1700MHz GenuineIntel GNU/Linux
> > 
> > I already re-formatted the card under Linux as well as under Windows XP and got
> > always the same behaviour.
>   This looks more like a strange interaction of your device size (it
> claims to have 3902463 sectors) and your partitioning programs which
> create partition ending at sector 3902464. Can you send the partition
> table you have on the device? E.g:
>   fdisk /dev/sda
>   x
>   p
> 
>   will print detailed information about the partition table.

Is this something that using US_FL_FIX_CAPACITY will fix?

US_FL_FIX_CAPACITY -> sets ->fix_capacity, then:

	/* Some devices return the total number of sectors, not the
	 * highest sector number.  Make the necessary adjustment. */
	if (sdp->fix_capacity) {
		--sdkp->capacity;


---
~Randy
