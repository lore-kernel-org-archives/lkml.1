Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbYDUNt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbYDUNt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbYDUNtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:49:43 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:36332 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759349AbYDUNtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:49:42 -0400
Message-ID: <480C9B74.2060302@blueyonder.co.uk>
Date: Mon, 21 Apr 2008 14:49:40 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1pre (X11/2007120104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap)partitions
 on a SATA drive]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this earlier message didn't get through.
Sid.

-------- Original Message --------
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 
(swap)partitions on a SATA drive
Date: Mon, 21 Apr 2008 12:55:04 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
To: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Sid Boyce wrote:
>> 2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3.
>> With xfs it can't find these and drops into a shell.
>> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part2 swap
>> swap defaults 0 0
>> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 /
>> xfs defaults 1 1
>>
>> From my .config
>> CONFIG_XFS_FS=m
>> CONFIG_XFS_QUOTA=y
>> CONFIG_XFS_POSIX_ACL=y
>> CONFIG_XFS_RT=y
>>
>> The other boxes are configure pretty much the same, but I can diff the
>> .config's if required.

> Does it not find the device, or does it not find the filesystem? What's
> the relevant message? Does it enumerate the partitions it finds, and is
> your partition in the list? Do you see the xfs module initialization
> message go by before the error to indicate that it really did get loaded?

> -Eric

It doesn't find the device either with 2.6.25-git1 or 2.6.25-git2. I've
tried a new kernel with xfs compiled in rather than as a module. The odd
thing is that other boxes with ext3, jfs and reiserfs are fine, 2 of
them with SATA drives are working with 2.6.25-git2.
The BIOS settings (it's the latest BIOS), but it's OK on 2.6.25, just a
problem from 2.6.25-git1.
Primary IDE Master     [Optiarc DVD RW A]
SATA 1                 [WDC WD5000AAKS-0]
SATA2 to SATA6 [None]

(Onboard Device Configuration)
Silicon SATAII Controller [SATA Mode]

Here goes the messages on boot for 2.6.25-git2.
-----------------------------------------------
scsi0 : sata_sil24
scsi1 : sata_sil24
ata1: SATA max UDMA/100 host n128@0xfdef8000 port 0xfdef8000 irq 16
ata2: SATA max UDMA/100 host n128@0xfdeff000 port 0xfdefa000 irq 16
ata1: SATA link down (SStatus 0 SControl 0)
ata2: SATA link down (SStatus 0 SControl 0)
sata_nv 0000:00:0d.0  using SUNCQ mode
scsi2: sata_nv
--- ditto to scsi16 ----
FATAL: Module xfs not found ### I have it built-in this time ###
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Creating device nodes with udev

<<< USB STUFF NOT INCLUDED >>>>
Trying normal resume from /dev/sda2
resume device /dev/sda2 not found (ignoring)
Trying manual resume from /dev/sda2
resume device /dev/sda2 not found (ignoring)
Waiting for device
/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 to appear
could not find
/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1
Want me to fall back to
/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1? (Y/n) y
Waiting for device
/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 to appear
not found -- exiting to /bin/sh
$
-----------------------------------
There is no /dev/disk directory, /sys/block/ is empty


 From 2.6.25 dmesg
==================
scsi0 : sata_sil24
scsi1 : sata_sil24
ata1: SATA max UDMA/100 host m128@0xfdeff000 port 0xfdef8000 irq 16
ata2: SATA max UDMA/100 host m128@0xfdeff000 port 0xfdefa000 irq 16
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input2
ata1: SATA link down (SStatus 0 SControl 0)
ata2: SATA link down (SStatus 0 SControl 0)
sata_nv 0000:00:0d.0: version 3.5
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xe000 irq 23
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xe008 irq 23
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: WDC WD5000AAKS-00YGA0, 12.01C02, max UDMA/133
ata3.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5


Driver 'sd' needs updating - please use bus_type methods
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
usbcore: registered new device driver usb
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
  sda: sda1 sda2

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks



-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

