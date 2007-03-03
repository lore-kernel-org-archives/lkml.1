Return-Path: <linux-kernel-owner+w=401wt.eu-S1750962AbXCCLAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbXCCLAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 06:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXCCLAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 06:00:37 -0500
Received: from vsmtp14.tin.it ([212.216.176.118]:58309 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbXCCLAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 06:00:36 -0500
Subject: Problem with libata-pata, ATAPI DVD reader and a "copy-protected"
	audio cd
From: GhePeU <ghepeu@virgilio.it>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-arOHUgStt+4x9mvIeQx/"
Date: Sat, 03 Mar 2007 12:00:01 +0100
Message-Id: <1172919624.23576.31.camel@KazeNoTani>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-arOHUgStt+4x9mvIeQx/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

when kernel 2.6.20 was released I switched to the new libata-pata
infrastructure for my EIDE hard disk and ATAPI dvd-reader. 

Until yesterday I didn't have any problem, then I tried to play an audio
CD and my media player hanged. Looking to the logs, I found that the DVD
reader (a Toshiba SD-M1612) was having problems reading the disk and
that the kernel dropped its speed from UDMA/33 to PIO3 before I could
eject the CD. Attached to this mail are the relevant lines of the system
log.

After a careful scrutiny of the box, I noticed that the disk was one of
those "Copy protected" non-standard CD. With the old ide driver I could
play and rip the CD without problems, so from a user point of view this
is a regression.

Besides, with the reduced speed the DVD reader was almost unusable, and
since the new libata layer doesn't support forcing the driver speed with
hdparm, I had to reboot the machine.

So my questions are:

1) it is possible to implement a command to force re-detection of the
better transfer mode available? I suppose that by unloading and
reloading the module, the transfer mode should become again the better
available, but when the driver is compiled in-kernel, this is not
possible.

2) is there a way to access copy protected audio CD again? the only
change here was ide -> libata, so there has to be some difference in the
error handling of the two layer that caused this pseudo-regression.

Thank you in advance

Giacomo

PS. I'm not subscribed to the list. I'm going to regularly check the
archives in the next days to see if there are responses, CC me if you
can. Thank you.



--=-arOHUgStt+4x9mvIeQx/
Content-Disposition: attachment; filename=DMA-drop.txt
Content-Type: text/plain; name=DMA-drop.txt; charset=utf8
Content-Transfer-Encoding: 7bit

SCSI subsystem initialized
libata version 2.00 loaded.
sata_nv 0000:00:07.0: version 3.2
sata_nv 0000:00:07.0: Using ADMA mode
ata1: SATA max UDMA/133 cmd 0xF0804480 ctl 0xF08044A0 bmdma 0xD400 irq 16
ata2: SATA max UDMA/133 cmd 0xF0804580 ctl 0xF08045A0 bmdma 0xD408 irq 16
scsi0 : sata_nv
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA/133, 312581808 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-22N 10.0 PQ: 0 ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
sata_nv 0000:00:08.0: Using ADMA mode
ata3: SATA max UDMA/133 cmd 0xF0806480 ctl 0xF08064A0 bmdma 0xC000 irq 17
ata4: SATA max UDMA/133 cmd 0xF0806580 ctl 0xF08065A0 bmdma 0xC008 irq 17
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
pata_amd 0000:00:06.0: version 0.2.7
ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xE800 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xE808 irq 15
scsi4 : pata_amd
ata5.00: ATA-6, max UDMA/100, 156301488 sectors: LBA 
ata5.00: ata5: dev 0 multi count 16
ata5.01: ATA-5, max UDMA/133, 78177792 sectors: LBA 
ata5.01: ata5: dev 1 multi count 16
ata5.00: configured for UDMA/100
ata5.01: configured for UDMA/133
scsi5 : pata_amd
ata6.00: ATAPI, max UDMA/66
ata6.01: ATAPI, max UDMA/33
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
scsi 4:0:0:0: Direct-Access     ATA      WDC WD800JB-00FM 13.0 PQ: 0 ANSI: 5
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 sdb8 >
sd 4:0:0:0: Attached scsi disk sdb
sd 4:0:0:0: Attached scsi generic sg1 type 0
scsi 4:0:1:0: Direct-Access     ATA      MAXTOR 6L040J2   A93. PQ: 0 ANSI: 5
SCSI device sdc: 78177792 512-byte hdwr sectors (40027 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 78177792 512-byte hdwr sectors (40027 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sdc: sdc1
sd 4:0:1:0: Attached scsi disk sdc
sd 4:0:1:0: Attached scsi generic sg2 type 0
scsi 5:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-111D 1.23 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
sr 5:0:0:0: Attached scsi generic sg3 type 5
scsi 5:0:1:0: CD-ROM            TOSHIBA  DVD-ROM SD-M1612 1806 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 40x/48x cd/rw xa/form2 cdda tray
sr 5:0:1:0: Attached scsi CD-ROM sr1
sr 5:0:1:0: Attached scsi generic sg4 type 5

...

ata6.01: qc timeout (cmd 0xa0)
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 16384 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 16384 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x3 (HSM violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 16384 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 16384 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
sr 5:0:1:0: SCSI error: return code = 0x08000002
sr1: Current [descriptor]: sense key=0x3
ASC=0x13 ASCQ=0x0
Descriptor sense data with sense descriptors (in hex):
72 03 13 00 00 00 00 0e 09 0c 00 51 00 03 00 00 
00 00 00 00 b0 51 
end_request: I/O error, dev sr1, sector 0
Buffer I/O error on device sr1, logical block 0
Buffer I/O error on device sr1, logical block 1
Buffer I/O error on device sr1, logical block 2
Buffer I/O error on device sr1, logical block 3
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 4096 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x3 (HSM violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: limiting speed to UDMA/25
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 4096 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/25
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: limiting speed to UDMA/16
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 4096 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/16
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data 4096 in
res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x3 (HSM violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/16
sr 5:0:1:0: SCSI error: return code = 0x08000002
sr1: Current [descriptor]: sense key=0x3
ASC=0x13 ASCQ=0x0
Descriptor sense data with sense descriptors (in hex):
72 03 13 00 00 00 00 0e 09 0c 00 51 00 03 00 00 
00 00 00 00 b0 51 
end_request: I/O error, dev sr1, sector 0
Buffer I/O error on device sr1, logical block 0
ata6: EH complete
ata6.01: limiting speed to PIO4
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x1b data 0 
res 40/00:03:00:00:20/00:00:00:00:00/b0 Emask 0x4 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
ata6: EH complete
ata6.01: limiting speed to PIO3
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x1b data 0 
res 40/00:03:00:00:20/00:00:00:00:00/b0 Emask 0x4 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO3
ata6: EH complete

--=-arOHUgStt+4x9mvIeQx/--

