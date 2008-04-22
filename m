Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbYDVKik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbYDVKik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbYDVKic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:38:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48161 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbYDVKia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:38:30 -0400
Date: Tue, 22 Apr 2008 12:38:29 +0200
From: Jan Kara <jack@suse.cz>
To: Toralf =?iso-8859-2?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ./fs/partitions/check.c: off-by-one error ?
Message-ID: <20080422103829.GC21922@atrey.karlin.mff.cuni.cz>
References: <200804201235.46552.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804201235.46552.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Inserting an 2 GB SD Card into my digikam and mounting it as an USB drive I've
> in my system log :
> 
> Apr 20 12:27:54 n22 usb 2-2: new full speed USB device using uhci_hcd and address 4
> Apr 20 12:27:54 n22 usb 2-2: configuration #1 chosen from 1 choice
> Apr 20 12:27:54 n22 SCSI subsystem initialized
> Apr 20 12:27:54 n22 Initializing USB Mass Storage driver...
> Apr 20 12:27:54 n22 scsi0 : SCSI emulation for USB Mass Storage devices
> Apr 20 12:27:54 n22 usbcore: registered new interface driver usb-storage
> Apr 20 12:27:54 n22 USB Mass Storage support registered.
> Apr 20 12:27:54 n22 usb-storage: device found at 4
> Apr 20 12:27:54 n22 usb-storage: waiting for device to settle before scanning
> Apr 20 12:27:59 n22 scsi 0:0:0:0: Direct-Access     MATSHITA DMC-TZ3          0100 PQ: 0 ANSI: 2
> Apr 20 12:27:59 n22 usb-storage: device scan complete
> Apr 20 12:27:59 n22 Driver 'sd' needs updating - please use bus_type methods
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] 3902463 512-byte hardware sectors (1998 MB)
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Write Protect is off
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Mode Sense: 04 00 00 00
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Assuming drive cache: write through
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] 3902463 512-byte hardware sectors (1998 MB)
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Write Protect is off
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Mode Sense: 04 00 00 00
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Assuming drive cache: write through
> Apr 20 12:27:59 n22 sda: sda1
> Apr 20 12:27:59 n22 sda: p1 exceeds device capacity
> Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Attached SCSI removable disk
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> Apr 20 12:27:59 n22 attempt to access beyond end of device
> Apr 20 12:27:59 n22 sda: rw=0, want=3902464, limit=3902463
> Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
> 
> My system is a :
> 
> tfoerste@n22 ~/devel/linux-2.6/fs/partitions $ uname -a
> Linux n22 2.6.24-gentoo-r4 #4 Sun Apr 20 12:16:18 CEST 2008 i686 Intel(R)
> Pentium(R) M processor 1700MHz GenuineIntel GNU/Linux
> 
> I already re-formatted the card under Linux as well as under Windows XP and got
> always the same behaviour.
  This looks more like a strange interaction of your device size (it
claims to have 3902463 sectors) and your partitioning programs which
create partition ending at sector 3902464. Can you send the partition
table you have on the device? E.g:
  fdisk /dev/sda
  x
  p

  will print detailed information about the partition table.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
