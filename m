Return-Path: <linux-kernel-owner+w=401wt.eu-S1765888AbXHHMRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765888AbXHHMRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbXHHMRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:17:23 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:46058 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbXHHMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:17:21 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 08:17:20 EDT
Date: Wed, 8 Aug 2007 14:08:04 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Subject: sata_nv + ADMA + Samsung disk problem
Message-ID: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I have upgraded to 2.6.22.1 from 2.6.20 I have problems with
Samsung disks. Sometimes the disks stall for about half a minute and
then I have these messages in the logs:

Aug  6 20:10:11 twister kernel: ata7: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
Aug  6 20:10:12 twister kernel: ata7: CPB 0: ctl_flags 0x9, resp_flags 0x0
Aug  6 20:10:12 twister kernel: ata7: timeout waiting for ADMA IDLE, stat=0x400
Aug  6 20:10:12 twister kernel: ata7: timeout waiting for ADMA LEGACY, stat=0x400
Aug  6 20:10:12 twister kernel: ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Aug  6 20:10:12 twister kernel: ata7.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
Aug  6 20:10:12 twister kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Aug  6 20:10:12 twister kernel: ata7: soft resetting port
Aug  6 20:10:12 twister kernel: ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  6 20:10:12 twister kernel: ata7.00: configured for UDMA/133
Aug  6 20:10:12 twister kernel: ata7: EH complete
Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] Write Protect is off
Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  6 20:20:25 twister kernel: ata8: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
Aug  6 20:20:25 twister kernel: ata8: CPB 0: ctl_flags 0x9, resp_flags 0x0
Aug  6 20:20:25 twister kernel: ata8: timeout waiting for ADMA IDLE, stat=0x400
Aug  6 20:20:25 twister kernel: ata8: timeout waiting for ADMA LEGACY, stat=0x400
Aug  6 20:20:25 twister kernel: ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Aug  6 20:20:25 twister kernel: ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
Aug  6 20:20:25 twister kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Aug  6 20:20:25 twister kernel: ata8: soft resetting port
Aug  6 20:20:25 twister kernel: ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  6 20:20:25 twister kernel: ata8.00: configured for UDMA/133
Aug  6 20:20:25 twister kernel: ata8: EH complete
Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] Write Protect is off
Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

I also have two Maxtor disks on the same controller but they are working
correctly in ADMA mode. I now disabled ADMA mode and that seems to help.

hdparm -I output for the misbehaving disks (they're identical):

/dev/sdc:

ATA device, with non-removable media
	Model Number:       SAMSUNG SP2504C                         
	Serial Number:      XXXXXXXXXXXXXX      
	Firmware Revision:  VT100-33
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 4a 
	Supported: 7 6 5 4 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  488397168
	device size with M = 1024*1024:      238475 MBytes
	device size with M = 1000*1000:      250059 MBytes (250 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 16
	Recommended acoustic management value: 254, current value: 128
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 udma7 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	    	SET_MAX security extension
	   *	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Phy event counters
	    	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	   *	Software settings preservation
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
		supported: enhanced erase
	120min for SECURITY ERASE UNIT. 120min for ENHANCED SECURITY ERASE UNIT.
Checksum: correct

sata_nv related dmesg excerpt:

sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 23 (level, low) -> IRQ 23
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xffffc2000000c480 ctl 0xffffc2000000c4a0 bmdma 0x000000000001c800 irq 23
ata6: SATA max UDMA/133 cmd 0xffffc2000000c580 ctl 0xffffc2000000c5a0 bmdma 0x000000000001c808 irq 23
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATA-7: Maxtor 6B250S0, BANC1G10, max UDMA/133
ata5.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6.00: ATA-7: Maxtor 6B250S0, BANC1G10, max UDMA/133
ata6.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata6.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6B250S0   BANC PQ: 0 ANSI: 5
ata5: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 4:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
sd 4:0:0:0: [sda] Attached SCSI disk
scsi 5:0:0:0: Direct-Access     ATA      Maxtor 6B250S0   BANC PQ: 0 ANSI: 5
ata6: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 sdb8 >
sd 5:0:0:0: [sdb] Attached SCSI disk
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi6 : sata_nv
scsi7 : sata_nv
ata7: SATA max UDMA/133 cmd 0xffffc2000000e480 ctl 0xffffc2000000e4a0 bmdma 0x000000000001dc00 irq 22
ata8: SATA max UDMA/133 cmd 0xffffc2000000e580 ctl 0xffffc2000000e5a0 bmdma 0x000000000001dc08 irq 22
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: ATA-7: SAMSUNG SP2504C, VT100-33, max UDMA7
ata7.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata7.00: configured for UDMA/133
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: ATA-7: SAMSUNG SP2504C, VT100-33, max UDMA7
ata8.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata8.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
ata7: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 6:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
sd 6:0:0:0: [sdc] Write Protect is off
sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
sd 6:0:0:0: [sdc] Write Protect is off
sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 sdc8 >
sd 6:0:0:0: [sdc] Attached SCSI disk
scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
ata8: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 7:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
sd 7:0:0:0: [sdd] Write Protect is off
sd 7:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 7:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
sd 7:0:0:0: [sdd] Write Protect is off
sd 7:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 sdd8 >
sd 7:0:0:0: [sdd] Attached SCSI disk

The controller in question is

00:07.0 IDE interface [0101]: nVidia Corporation CK804 Serial ATA Controller [10de:0054] (rev f3) (prog-if 85 [Master SecO PriO])
00:08.0 IDE interface [0101]: nVidia Corporation CK804 Serial ATA Controller [10de:0055] (rev f3) (prog-if 85 [Master SecO PriO])

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
