Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbXCMMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbXCMMN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965711AbXCMMN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:13:27 -0400
Received: from vsmtp3.tin.it ([212.216.176.223]:44673 "EHLO vsmtp3.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965715AbXCMMNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:13:25 -0400
Date: Tue, 13 Mar 2007 13:13:12 +0100 (CET)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: alan@lxorguk.ukuu.org.uk, htejun@gmail.com
cc: linux-kernel@vger.kernel.org
Subject: IDE disk runs just in DMA/33 with 2.6.20.2 on nVidia CK804 controller
Message-ID: <Pine.LNX.4.64.0703131125270.24498@Phoenix.oltrelinux.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I reported this also for 2.6.20 kernel.
new libata with controller nVidia CK804 initializes the disk in DMA/33,
with with 2.6.19.5 and previous the disk is correctly inizialized in 
DMA/100.
Tha cable is OK, and with older kernels the disks runs without troubles.

The sistem has two sata disks on nvidia CK804 controllers, and then a disk 
as primary master, and a dvd writer (DMA/33) as secondary master)

here is lspci -vxxx
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a 
[Master SecP PriP])
         Subsystem: Unknown device f043:815a
         Flags: bus master, 66MHz, fast devsel, latency 0
         I/O ports at f000 [size=16]
         Capabilities: [44] Power Management version 2
00: de 10 53 00 05 00 b0 00 f2 8a 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 f0 00 00 00 00 00 00 00 00 00 00 43 f0 5a 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01
40: 43 f0 5a 81 01 00 02 00 00 00 00 00 00 00 00 00
50: 03 f0 01 00 00 00 00 00 a8 20 a8 20 22 00 20 20
60: 00 c0 00 c6 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 50 96 29 00 00 04 20 00 9e 4f 00
90: 00 00 02 30 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 ff ff ff 0a 11 30 07

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev 
f3) (prog-if 85 [Master SecO PriO])
         Subsystem: ASUSTeK Computer Inc. Unknown device 815a
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
         I/O ports at 09f0 [size=8]
         I/O ports at 0bf0 [size=4]
         I/O ports at 0970 [size=8]
         I/O ports at 0b70 [size=4]
         I/O ports at d800 [size=16]
         Memory at d5002000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [44] Power Management version 2
00: de 10 54 00 07 00 b0 00 f3 85 01 01 00 00 00 00
10: f1 09 00 00 f1 0b 00 00 71 09 00 00 71 0b 00 00
20: 01 d8 00 00 00 20 00 d5 00 00 00 00 43 10 5a 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 03 01
40: 43 10 5a 81 01 00 02 00 00 00 00 00 00 00 00 00
50: 17 00 00 15 00 00 00 00 a8 20 a8 20 66 00 20 20
60: 00 c0 00 c6 11 0c 00 00 08 0f 06 42 00 00 00 00
70: 2c 78 c4 40 01 10 00 00 01 10 00 00 20 00 20 00
80: 00 00 00 40 00 50 4a 7f 00 00 02 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 06 00 06 10 00 00 01 01
a0: 50 01 00 7c 00 00 00 00 00 00 00 00 33 bb aa 02
b0: 05 cc 84 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 0a 00 0a 00 08 00 02 a8
d0: 01 00 02 0d 42 00 00 00 00 00 00 00 0f 00 d0 87
e0: 01 00 02 0d 42 00 00 00 00 00 00 00 f7 e0 e2 01
f0: 00 00 00 00 00 00 00 00 00 ff ff ff 0f 36 32 07

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev 
f3) (prog-if 85 [Master SecO PriO])
         Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
         I/O ports at 09e0 [size=8]
         I/O ports at 0be0 [size=4]
         I/O ports at 0960 [size=8]
         I/O ports at 0b60 [size=4]
         I/O ports at c400 [size=16]
         Memory at d5001000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [44] Power Management version 2
00: de 10 55 00 07 00 b0 00 f3 85 01 01 00 00 00 00
10: e1 09 00 00 e1 0b 00 00 61 09 00 00 61 0b 00 00
20: 01 c4 00 00 00 10 00 d5 00 00 00 00 43 10 5a 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 0a 01 03 01
40: 43 10 5a 81 01 00 02 00 00 00 00 00 00 00 00 00
50: 17 00 00 15 00 00 00 00 a8 20 a8 20 66 00 20 20
60: 00 c0 00 c6 11 0c 00 00 08 0f 06 42 00 00 00 00
70: 2c 78 c4 40 01 10 00 00 01 10 00 00 20 00 20 00
80: 00 00 00 40 00 a0 4a 7f 00 00 02 2c 00 00 00 00
90: 00 00 00 00 00 00 00 00 06 00 06 10 00 00 01 01
a0: 50 01 00 7c 00 00 00 00 00 00 00 00 33 bb aa 02
b0: 05 cc 84 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 0a 00 0a 00 08 00 02 a8
d0: 01 00 02 0d 42 00 00 00 00 00 00 00 ea 9f f6 80
e0: 01 00 02 0d 42 00 00 00 00 00 00 00 50 80 00 00
f0: 00 00 00 00 00 00 00 00 00 ff ff ff 11 3f 32 07

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if 
01 [Subtractive decode])
         Flags: bus master, 66MHz, fast devsel, latency 0
         Bus: primary=00, secondary=05, subordinate=05, sec-latency=128
         I/O behind bridge: 0000a000-0000afff
         Memory behind bridge: d3000000-d4ffffff
         Prefetchable memory behind bridge: 88000000-880fffff
00: de 10 5c 00 07 01 a0 00 a2 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 05 05 80 a0 a0 80 a2
20: 00 d3 f0 d4 00 88 00 88 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 06
40: 00 00 07 00 01 00 02 00 07 00 00 00 00 00 44 01
50: 00 00 fe 7f 00 00 00 00 ff 1f ff 1f 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 0c 00 00 0c 00 00 d4 00 00 00 00 08 00 00 a8
90: 00 00 e0 fe 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00



here is the dmesg with 2.6.19.5

sata_nv 0000:00:07.0: version 2.0
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 23 (level, low) 
-> IRQ
  23
PCI: Setting latency timer of device 0000:00:07.0 to 64
ata1: SATA max UDMA/133 cmd 0x9F0 ctl 0xBF2 bmdma 0xD800 irq 23
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xB72 bmdma 0xD808 irq 23
scsi0 : sata_nv
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 1
ata1.00: configured for UDMA/133
scsi1 : sata_nv
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 ANSI: 5
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 22 (level, low) 
-> IRQ 22
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata3: SATA max UDMA/133 cmd 0x9E0 ctl 0xBE2 bmdma 0xC400 irq 22
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xB62 bmdma 0xC408 irq 22
scsi2 : sata_nv
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 156250000 sectors: LBA48 NCQ (depth 0/32)
ata3.00: ata3: dev 0 multi count 1
ata3.00: configured for UDMA/133
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6V080E0   VA13 PQ: 0 ANSI: 5
SCSI device sdb: 156250000 512-byte hdwr sectors (80000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 156250000 512-byte hdwr sectors (80000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
sd 2:0:0:0: Attached scsi disk sdb
pata_amd 0000:00:06.0: version 0.2.4
PCI: Setting latency timer of device 0000:00:06.0 to 64
ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
scsi4 : pata_amd
ata5.00: ATA-7, max UDMA/100, 156368016 sectors: LBA48
ata5.00: ata5: dev 0 multi count 1
ata5.00: configured for UDMA/100
scsi5 : pata_amd
ata6.00: ATAPI, max UDMA/33
ata6.00: configured for UDMA/33
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG SP0822N  WA10 PQ: 0 ANSI: 5
SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
  sdc: sdc1 sdc2 sdc3
sd 4:0:0:0: Attached scsi disk sdc
scsi 5:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S162A TS01 PQ: 0 ANSI: 5


here is dmesg with 2.6.20.2:
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 23 (level, low) -> IRQ 23
sata_nv 0000:00:07.0: Using ADMA mode
ata1: SATA max UDMA/133 cmd 0xFFFFC20000004480 ctl 0xFFFFC200000044A0 
bmdma 0xD800 irq 23
ata2: SATA max UDMA/133 cmd 0xFFFFC20000004580 ctl 0xFFFFC200000045A0 
bmdma 0xD808 irq 23
scsi0 : sata_nv
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 1
ata1.00: configured for UDMA/133
scsi1 : sata_nv
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:08.0: Using ADMA mode
ata3: SATA max UDMA/133 cmd 0xFFFFC20000006480 ctl 0xFFFFC200000064A0 bmdma 0xC400 irq 22
ata4: SATA max UDMA/133 cmd 0xFFFFC20000006580 ctl 0xFFFFC200000065A0 bmdma 0xC408 irq 22
scsi2 : sata_nv
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 156250000 sectors: LBA48 NCQ (depth 31/32)
ata3.00: ata3: dev 0 multi count 1
ata3.00: configured for UDMA/133
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6V080E0   VA13 PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sdb: 156250000 512-byte hdwr sectors (80000 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 156250000 512-byte hdwr sectors (80000 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
sd 2:0:0:0: Attached scsi disk sdb
ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
scsi4 : pata_amd
ata5.00: ATA-7, max UDMA/100, 156368016 sectors: LBA48
ata5.00: ata5: dev 0 multi count 1
ata5.00: configured for UDMA/33
scsi5 : pata_amd
ata6.00: ATAPI, max UDMA/33
ata6.00: configured for UDMA/33
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG SP0822N  WA10 PQ: 0 ANSI: 5
SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   sdc: sdc1 sdc2 sdc3
sd 4:0:0:0: Attached scsi disk sdc
scsi 5:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S162A TS01 PQ: 0 ANSI: 5


Please, tell me if you need further details

Luigi Genoni



