Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbYHHRtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbYHHRtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYHHRtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:49:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:37634 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYHHRtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:49:03 -0400
Message-Id: <5D4D272F-5546-4C02-852A-80849A42EC1F@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: issues with sata hotplug?
Date: Fri, 8 Aug 2008 12:49:01 -0500
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a system with a nvidia chipset running fedora 9 (2.6.25.11)

00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev  
a3) (prog-if 85 [Master SecO PriO])
	Subsystem: Sun Microsystems Computer Corp. Unknown device 534d
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
	I/O ports at 34c0 [size=8]
	I/O ports at 34b4 [size=4]
	I/O ports at 34b8 [size=8]
	I/O ports at 34b0 [size=4]
	I/O ports at 3490 [size=16]
	Memory at d0006000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+  
Queue=0/2 Enable-
	Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: sata_nv
	Kernel modules: ata_generic, sata_nv, pata_acpi

00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev  
a3) (prog-if 85 [Master SecO PriO])
	Subsystem: Sun Microsystems Computer Corp. Unknown device 534d
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
	I/O ports at 34d8 [size=8]
	I/O ports at 34cc [size=4]
	I/O ports at 34d0 [size=8]
	I/O ports at 34c8 [size=4]
	I/O ports at 34a0 [size=16]
	Memory at d0007000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+  
Queue=0/2 Enable-
	Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: sata_nv
	Kernel modules: ata_generic, sata_nv, pata_acpi

I've connected a SATA to eSATA adapter on an internal port and  
connected the eSATA port to a Thermaltake docking station:

http://www.thermaltakeusa.com/Product.aspx?C=1346&ID=1731

When I "eject" the drive I see no dmesg output related to hotplug.  I  
also don't see anything when I plug a drive in.

scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x34c0 ctl 0x34b4 bmdma 0x3490 irq 21
ata2: SATA max UDMA/133 cmd 0x34b8 ctl 0x34b0 bmdma 0x3498 irq 21
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: HITACHI HDS7225SCSUN250G 0721BA6TRD, V5DOA7BA, max  
UDMA/133
ata1.00: 488390625 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      HITACHI HDS7225S V5DO PQ: 0  
ANSI: 5
sd 0:0:0:0: [sda] 488390625 512-byte hardware sectors (250056 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 0:0:0:0: [sda] 488390625 512-byte hardware sectors (250056 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
  sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSI1] -> GSI 20 (level,  
low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:05.1 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x34d8 ctl 0x34cc bmdma 0x34a0 irq 20
ata4: SATA max UDMA/133 cmd 0x34d0 ctl 0x34c8 bmdma 0x34a8 irq 20
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: ST3808110AS, 3.AAE, max UDMA/133
ata4.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      ST3808110AS      3.AA PQ: 0  
ANSI: 5
sd 3:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 3:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
  sdb: sdb1 sdb2 sdb3 sdb4
sd 3:0:0:0: [sdb] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds

Is there something I'm doing wrong w/regards to SATA hotplug support?

- k
