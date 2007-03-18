Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbXCRKuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbXCRKuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbXCRKuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:50:32 -0400
Received: from tag.witbe.net ([81.88.96.48]:36086 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbXCRKub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:50:31 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sun, 18 Mar 2007 11:50:18 +0100
Organization: AS2917.net
Message-ID: <00ee01c7694b$382b6460$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <45FD16E3.4090509@gmail.com>
Thread-Index: AcdpSbmOVLxRdgqUQZiO4C+v/kDnmwAAPRKA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This is NCQ protocol violation on the drive's side shown on some early
> drives.  No need to worry too much about it.  The drive will just get
> blacklisted for NCQ and should work fine.
> 

Thx.

Also, remember one of the problem I have, with ata2 going to timeout
because this port of the ICH7 is connected to a PMT ?
You suggested me to connect a disk to one of the SATA port of the PMT,
and reboot the machine to see if the timeout would vanish... I've just
done it, and here is the relevant part of the boot log :

....
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xffffc2000008e900 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata2: SATA max UDMA/133 cmd 0xffffc2000008e980 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata3: SATA max UDMA/133 cmd 0xffffc2000008ea00 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata4: SATA max UDMA/133 cmd 0xffffc2000008ea80 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-6: External Disk 0, RGL10364, max UDMA/133
ata2.00: 1 sectors, multi 1: LBA48 
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
ata3.00: configured for UDMA/133
scsi3 : ahci
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3500641AS, 3.AAB, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      External Disk 0  RGL1 PQ: 0 ANSI: 5
SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdb: unknown partition table
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdc: sdc1 sdc2
sd 2:0:0:0: Attached scsi disk sdc
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: Attached scsi disk sdd
sd 3:0:0:0: Attached scsi generic sg3 type 0
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
...

The good news is that there is no more timeout, which is excellent !
The bad news is that the disk is not detected... but maybe I should do
something in the BIOS configuration. I'll try to have a look at this,
because connecting a disk to avoid TO without being able to use it is not
that good ;)

Regards,
Paul

