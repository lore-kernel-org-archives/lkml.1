Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYEQBDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYEQBDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYEQBDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:03:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2383 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754710AbYEQBDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:03:02 -0400
Date: Fri, 16 May 2008 21:03:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
In-Reply-To: <8db1092f0805160755u54914884ibe1ed8a23b8e1015@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0805162056230.13416-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Maciej Rutecki wrote:

> I have external drive connected via USB to computer. In 2.6.25.4 when
> I plug into computer works fine, and have this messages in dmesg:
> usb 5-1: new high speed USB device using ehci_hcd and address 4
> usb 5-1: configuration #1 chosen from 1 choice
> Initializing USB Mass Storage driver...
> scsi2 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device found at 4
> usb-storage: waiting for device to settle before scanning
> scsi 2:0:0:0: Direct-Access     Initio   MHV2080BH PL     3.01 PQ: 0 ANSI: 0
> usb-storage: device scan complete
> Driver 'sd' needs updating - please use bus_type methods
> sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
> sd 2:0:0:0: [sda] Assuming drive cache: write through
> sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
> sd 2:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1
> sd 2:0:0:0: [sda] Attached SCSI disk
> 
> Works fine:
> maciek@zlom:~/kernel.org/2.6.25.4$ ntfsmount /dev/sda1 ~/mnt/ntfs/
> maciek@zlom:~/kernel.org/2.6.25.4$ mount | grep fuse
> fusectl on /sys/fs/fuse/connections type fusectl (rw)
> /dev/sda1 on /home/maciek/mnt/ntfs type fuseblk
> (rw,nosuid,nodev,default_permissions,allow_other,blksize=4096,user=maciek)
> 
> But on 2.6.26-rc* sometimes I have messages "Write protect is on", e.g.:
> sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 2:0:0:0: [sda] Write Protect is on
> sd 2:0:0:0: [sda] Mode Sense: 09 50 f8 af
> sd 2:0:0:0: [sda] Assuming drive cache: write through
> sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
> sd 2:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1
> sd 2:0:0:0: [sda] Attached SCSI disk
> 
> or:
> sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 2:0:0:0: [sda] Write Protect is on
> sd 2:0:0:0: [sda] Mode Sense: 09 50 f8 af
> sd 2:0:0:0: [sda] Assuming drive cache: write through
> sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> sd 2:0:0:0: [sda] Write Protect is on
> sd 2:0:0:0: [sda] Mode Sense: 09 50 f8 af
> sd 2:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1
> sd 2:0:0:0: [sda] Attached SCSI disk
> 
> Then mount fails:
> maciek@zlom:~/kernel.org/2.6.26-rc2$ ntfsmount /dev/sda1 ~/mnt/ntfs/
> Error opening partition device: System plików wyłącznie do odczytu.
> Failed to startup volume: System plików wyłącznie do odczytu.
> Failed to mount '/dev/sda1': System plików wyłącznie do odczytu.
> Mount failed.
> 
> "System plików wyłącznie do odczytu." means "filesystem readonly"
> 
> Tested on two computers PC and laptop.
> 
> Dmesg and config:
> 2.6.25.4: http://unixy.pl/maciek/download/kernel/2.6.25.4/
> 2.6.26-rc1: http://unixy.pl/maciek/download/kernel/2.6.26-rc1/
> 2.6.26-rc2: http://unixy.pl/maciek/download/kernel/2.6.26-rc2/

The best way to gather more data is to use usbmon and trace what
happens when you plug in the drive (see Documentation/usb/usbmon.txt).  
If you collect traces under both 2.6.25.4 and 2.6.26-rc2 then we can
compare them to see what has changed.

You don't have to trace the mount command; the activity at plug-in time
will be sufficient.

Alan Stern

