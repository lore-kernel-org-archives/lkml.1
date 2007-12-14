Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbXLNPov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbXLNPov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbXLNPol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:44:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53397 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752884AbXLNPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:44:40 -0500
Date: Fri, 14 Dec 2007 10:44:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <mdharm-usb@one-eyed-alien.net>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: 2.6.24-rc5-mm1
In-Reply-To: <a8e1da0712132132t6bcef833vc492e4164c22705a@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0712141039050.4768-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Dave Young wrote:

> Hi,
> The behaviour of my mp3 player (also act as usb-storage device) seems
> changed from rc5 to rc5-mm1.

This can't be considered a bug, right?  It's just that the player 
changed from one slightly non-standard behavior to a different slightly 
non-standard behavior.

> <dmesg output under rc5>:
> =========
> usb 1-7: new high speed USB device using ehci_hcd and address 7
> usb 1-7: configuration #1 chosen from 1 choice
> scsi4 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 7
> usb-storage: waiting for device to settle before scanning
> scsi 4:0:0:0: Direct-Access                   Newman mp3       PQ: 0 ANSI: 0 CCS
> sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> sd 4:0:0:0: [sdb] Write Protect is on
> sd 4:0:0:0: [sdb] Mode Sense: 03 00 80 00
> sd 4:0:0:0: [sdb] Assuming drive cache: write through
> sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> sd 4:0:0:0: [sdb] Write Protect is on
> sd 4:0:0:0: [sdb] Mode Sense: 03 00 80 00
> sd 4:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1
> sd 4:0:0:0: [sdb] Attached SCSI removable disk
> sd 4:0:0:0: Attached scsi generic sg1 type 0
> usb-storage: device scan complete
> 
> ==========
> try mount it (or just blockdev --rereadpt), then write protect become off:
> ==========
> 
> sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sdb] Assuming drive cache: write through
> sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
> sd 4:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1

This output won't appear if you simply mount the device.  So how do you 
know that mounting turns off write protect?

> But under rc5-mm1, after mount command being executed, it is just
> mouted as read only partition without set the write-protect to off
> 
> I tried "blockdev --rereadpt", it do set the write-protect to off as rc5 kernel.
> 
> Below is the output of dmesg under rc5-mm1
> ==========
> usb 1-8: new high speed USB device using ehci_hcd and address 6
> usb 1-8: configuration #1 chosen from 1 choice
> scsi3 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 6
> usb-storage: waiting for device to settle before scanning
> scsi 3:0:0:0: Direct-Access                   Newman mp3       PQ: 0 ANSI: 0 CCS
> sd 3:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> sd 3:0:0:0: [sdb] Write Protect is on
> sd 3:0:0:0: [sdb] Mode Sense: 03 00 80 00
> sd 3:0:0:0: [sdb] Assuming drive cache: write through
> sd 3:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
> sd 3:0:0:0: [sdb] Write Protect is on
> sd 3:0:0:0: [sdb] Mode Sense: 03 00 80 00
> sd 3:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1

This looks exactly the same as the output above (except for various 
port, device, and bus numbers).

If you turn on CONFIG_USB_STORAGE_DEBUG for both kernels and compare 
the dmesg output for the mount command, that might highlight the 
difference.

Alan Stern

