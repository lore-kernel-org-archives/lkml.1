Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYJOSp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYJOSp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYJOSps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:45:48 -0400
Received: from ganymede.lunarpages.com ([216.97.232.250]:40187 "EHLO
	ganymede.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYJOSpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:45:47 -0400
X-Greylist: delayed 1841 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 14:45:47 EDT
Message-ID: <48F63324.9000900@kcore.org>
Date: Wed, 15 Oct 2008 20:15:00 +0200
From: Jan De Luyck <ml_linuxkernel_20080830@kcore.org>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.26.6: ata4.00: exception Emask 0x0 SAct 0x8 SErr 0x1800000 action
 0x6 frozen
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ganymede.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kcore.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

When booting my system today the following nice chunk came up in the dmesg:

XFS mounting filesystem sdd1
ata4: EH in SWNCQ mode,QC:qc_active 0x8 sactive 0x8
ata4: SWNCQ:qc_active 0x8 defer_bits 0x0 last_issue_tag 0x3
  dhfis 0x8 dmafis 0x8 sdbfis 0x0
ata4: ATA_REG 0x40 ERR_REG 0x0
ata4: tag : dhfis dmafis sdbfis sacitve
ata4: tag 0x3: 1 1 0 1  
ata4.00: exception Emask 0x0 SAct 0x8 SErr 0x1800000 action 0x6 frozen
ata4: SError: { LinkSeq TrStaTrns }
ata4.00: cmd 60/00:18:d3:d1:a2/04:00:12:00:00/40 tag 3 ncq 524288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: failed to IDENTIFY (I/O error, err_mask=0x3)
ata4.00: revalidation failed (errno=-5)
ata4: failed to recover some devices, retrying in 5 secs
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: failed to IDENTIFY (I/O error, err_mask=0x3)
ata4.00: revalidation failed (errno=-5)
ata4: failed to recover some devices, retrying in 5 secs
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: failed to IDENTIFY (I/O error, err_mask=0x3)
ata4.00: revalidation failed (errno=-5)
ata4.00: disabled
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: EH complete
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 312660435
I/O error in filesystem ("sdd1") meta-data dev sdd1 block 0x12a2c594       ("xlog_bread") error 5 buf count 2097152
XFS: empty log check failed
XFS: log mount/recovery failed: error 5
XFS: log mount failed
end_request: I/O error, dev sdd, sector 0


followed later by:
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
Buffer I/O error on device sdd, logical block 1
Buffer I/O error on device sdd, logical block 2
Buffer I/O error on device sdd, logical block 3
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 63
Buffer I/O error on device sdd1, logical block 0
Buffer I/O error on device sdd1, logical block 1
Buffer I/O error on device sdd1, logical block 2
Buffer I/O error on device sdd1, logical block 3
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 63
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 65
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 67
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 69
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 0
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 8
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 16
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 24
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 0
sd 3:0:0:0: [sdd] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sdd, sector 0

Is my disk dying? Or is just a SWNCQ bug in the disk firmware?

sdd is not accessible at this time.


Motherboard is an Asus M2N-SLI Deluxe.

Disks:

sata_nv 0000:00:05.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APSI] -> GSI 23 (level, low) -> IRQ 23
sata_nv 0000:00:05.0: Using SWNCQ mode
PCI: Setting latency timer of device 0000:00:05.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xdc00 irq 23
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xdc08 irq 23
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST3160812AS, 3.AAH, max UDMA/133
ata1.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: ST3160812AS, 3.AAH, max UDMA/133
ata2.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      ST3160812AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST3160812AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
sd 1:0:0:0: [sdb] Attached SCSI disk
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [APSJ] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:05.1: Using SWNCQ mode
PCI: Setting latency timer of device 0000:00:05.1 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc800 irq 22
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc808 irq 22
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: native sectors (586072368) is smaller than sectors (625142448)
ata3.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata3.00: 625142448 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: native sectors (586072368) is smaller than sectors (625142448)
ata4.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata4.00: 625142448 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 >
sd 2:0:0:0: [sdc] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [ASA2] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:05.2: Using SWNCQ mode
PCI: Setting latency timer of device 0000:00:05.2 to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb400 irq 21
ata6: SATA max UDMA/133 cmd 0xbc00 ctl 0xb800 bmdma 0xb408 irq 21
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
ata5.00: 625142448 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sde] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1 sde2 sde3 sde4 < sde5 >
sd 4:0:0:0: [sde] Attached SCSI disk
pata_amd 0000:00:04.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:04.0 to 64
scsi6 : pata_amd
scsi7 : pata_amd
ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata7.00: ATAPI: _NEC DVD_RW ND-2500A, 1.08, max UDMA/33
ata7.01: ATAPI: BENQ    DVD LS DW1655, BCIB, max UDMA/33
ata7: nv_mode_filter: 0x739f&0x707f->0x701f, BIOS=0x7000 (0xc0c00000) ACPI=0x0
ata7: nv_mode_filter: 0x739f&0x707f->0x701f, BIOS=0x7000 (0xc0c00000) ACPI=0x0
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata8: port disabled. ignoring.
scsi 6:0:0:0: CD-ROM            _NEC     DVD_RW ND-2500A  1.08 PQ: 0 ANSI: 5
scsi 6:0:1:0: CD-ROM            BENQ     DVD LS DW1655    BCIB PQ: 0 ANSI: 5
