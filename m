Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbZDAOTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbZDAOTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932802AbZDAOOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:14:00 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53970 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798AbZDAONv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:13:51 -0400
Date: Wed, 1 Apr 2009 17:13:47 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: strange MTRR on 2.6.29-git
Message-ID: <Pine.SOC.4.64.0904011711210.5672@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this on todays 2.6.29 + git. The same address range has both WB 
and UC MTRR-s.

reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
reg01: base=0x020000000 (  512MB), size=    1MB, count=1: write-back
reg02: base=0x020000000 (  512MB), size=    1MB, count=1: uncachable
reg03: base=0x0f2000000 ( 3872MB), size=   32MB, count=2: write-combining
reg04: base=0x0f8000000 ( 3968MB), size=   64MB, count=1: write-combining

lspci -vvvnnn:

00:00.0 Host bridge [0600]: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub [8086:1130] (rev 02)
	Subsystem: Intel Corporation D815EEA2 mainboard [8086:4532]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [88] Vendor Specific Information <?>
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x2
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge [0604]: Intel Corporation 82815 815 Chipset AGP Bridge [8086:1131] (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fda00000-feafffff
	Prefetchable memory behind bridge: f1700000-f57fffff
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fd900000-fd9fffff
	Prefetchable memory behind bridge: f1600000-f16fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1f.0 ISA bridge [0601]: Intel Corporation 82801BA ISA Bridge (LPC) [8086:2440] (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:1f.1 IDE interface [0101]: Intel Corporation 82801BA IDE U100 Controller [8086:244b] (rev 02) (prog-if 80 [Master])
	Subsystem: Intel Corporation D815EEA2 mainboard [8086:4532]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at ffa0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 USB Controller [0c03]: Intel Corporation 82801BA/BAM USB Controller #1 [8086:2442] (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation D815EEA2 mainboard [8086:4532]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at ef40 [size=32]
	Kernel driver in use: uhci_hcd

00:1f.3 SMBus [0c05]: Intel Corporation 82801BA/BAM SMBus Controller [8086:2443] (rev 02)
	Subsystem: Intel Corporation D815EEA2 mainboard [8086:4532]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 10
	Region 4: I/O ports at efa0 [size=16]
	Kernel driver in use: i801_smbus

00:1f.4 USB Controller [0c03]: Intel Corporation 82801BA/BAM USB Controller #1 [8086:2444] (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation D815EEA2 mainboard [8086:4532]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 4: I/O ports at ef80 [size=32]
	Kernel driver in use: uhci_hcd

00:1f.5 Multimedia audio controller [0401]: Intel Corporation 82801BA/BAM AC'97 Audio Controller [8086:2445] (rev 02)
	Subsystem: Intel Corporation Device [8086:4656]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 10
	Region 0: I/O ports at e800 [size=256]
	Region 1: I/O ports at ef00 [size=64]
	Kernel driver in use: Intel ICH

01:08.0 Ethernet controller [0200]: Intel Corporation 82801BA/BAM/CA/CAM Ethernet Controller [8086:2449] (rev 01)
	Subsystem: Intel Corporation EtherExpress PRO/100 VE [8086:3013]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fd9f9000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at df00 [size=64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: e100

01:09.0 Token ring network controller [0201]: 3Com Corporation 3c339 TokenLink Velocity [10b7:3390]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (250ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at df40 [size=32]
	Region 1: Memory at fd9fe400 (32-bit, non-prefetchable) [size=32]
	Expansion ROM at f1600000 [disabled] [size=64K]
	Kernel driver in use: tmspci

01:0a.0 SCSI storage controller [0100]: QLogic Corp. QLA2100 64-bit Fibre Channel Adapter [1077:2100] (rev 03)
	Subsystem: QLogic Corp. QLA2100 64-bit Fibre Channel Adapter [1077:0001]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at fd9ff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at f1610000 [disabled] [size=64K]
	Kernel driver in use: qla2xxx

01:0b.0 Parallel controller [0701]: Lava Computer mfg Inc Lava Parallel [1407:8000] (prog-if 01 [BiDir])
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at dff0 [size=8]
	Kernel driver in use: parport_pc

01:0c.0 Fibre Channel [0c04]: Emulex Corporation LP8000 Fibre Channel Host Adapter [10df:f800] (rev 02)
	Subsystem: Compaq Computer Corporation Device [0e11:f800]
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 248 (63750ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fd9fd000 (64-bit, non-prefetchable) [size=4K]
	Region 2: Memory at fd9fe800 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at d400 [size=256]
	Kernel driver in use: lpfc

01:0d.0 Token ring network controller [0201]: 3Com Corporation 3c339 TokenLink Velocity [10b7:3390]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (250ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at df80 [size=32]
	Region 1: Memory at fd9fec00 (32-bit, non-prefetchable) [size=32]
	Expansion ROM at f1620000 [disabled] [size=64K]
	Kernel driver in use: tmspci

02:00.0 VGA compatible controller [0300]: Matrox Graphics, Inc. MGA G550 AGP [102b:2527] (rev 01) (prog-if 00 [VGA controller])
	Subsystem: Matrox Graphics, Inc. Millennium G550 Dual Head DDR 32Mb [102b:0f84]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2000000 (32-bit, prefetchable) [size=32M]
	Region 1: Memory at feafc000 (32-bit, non-prefetchable) [size=16K]
	Region 2: Memory at fe000000 (32-bit, non-prefetchable) [size=8M]
	Expansion ROM at feac0000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x2



Full dmesg:
[    0.000000] Linux version 2.6.29-06608-g15f7176-dirty (mroos@rhn) (gcc version 4.3.3 (Debian 4.3.3-5) ) #195 PREEMPT Tue Mar 31 13:57:57 EEST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffc0000 (usable)
[    0.000000]  BIOS-e820: 000000001ffc0000 - 000000001fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x1ffc0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FE0000000 write-back
[    0.000000]   1 base 020000000 mask FFFF00000 write-back
[    0.000000]   2 base 020000000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[    0.000000]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[    0.000000]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[    0.000000] init_memory_mapping: 0000000000000000-000000001ffc0000
[    0.000000]  0000000000 - 001ffc0000 page 4k
[    0.000000] kernel direct mapping tables up to 1ffc0000 @ 7000-8a000
[    0.000000] ACPI: RSDP 000FF980, 0014 (r0 AMI   )
[    0.000000] ACPI: RSDT 1FFF0000, 002C (r1 D815EA D815EEA2 20021106 MSFT     1011)
[    0.000000] ACPI: FACP 1FFF1000, 0074 (r1 D815EA EA81510A 20021106 MSFT     1011)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 1FFE0000, 30E4 (r1 D815E2 EA81520A       23 MSFT  100000B)
[    0.000000] ACPI: FACS 1FFF8000, 0040
[    0.000000] ACPI: SSDT 1FFE30E4, 0035 (r1 D815EA EA81510A       15 MSFT  100000B)
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1ffc0000
[    0.000000]   low ram: 0 - 1ffc0000
[    0.000000]   node 0 low ram: 00000000 - 1ffc0000
[    0.000000]   node 0 bootmap 00001000 - 00004ff8
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 001ffc0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 0000db84a0]    TEXT DATA BSS ==> [0000100000 - 0000db84a0]
[    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #3 [0000db9000 - 0000dbd140]              BRK ==> [0000db9000 - 0000dbd140]
[    0.000000]   #4 [0000007000 - 0000083000]          PGTABLE ==> [0000007000 - 0000083000]
[    0.000000]   #5 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001ffc0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001ffc0
[    0.000000] On node 0 totalpages: 130911
[    0.000000] free_area_init_node: node 0, pgdat c07d1cdc, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125920 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] Found and enabled local APIC!
[    0.000000] nr_irqs_gsi: 16
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dfb80000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129887
[    0.000000] Kernel command line: root=/dev/sda3 ro
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=c08cf000 soft=c08d0000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 897.004 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:          4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 3103 kB
[    0.004000]  per task-struct memory footprint: 1920 bytes
[    0.004000] ------------------------
[    0.004000] | Locking API testsuite:
[    0.004000] ----------------------------------------------------------------------------
[    0.004000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.004000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.004000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.004000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.004000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.004000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.004000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.004000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.004000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq read-recursion/123:  ok  |
[    0.004000]       soft-irq read-recursion/123:  ok  |
[    0.004000]       hard-irq read-recursion/132:  ok  |
[    0.004000]       soft-irq read-recursion/132:  ok  |
[    0.004000]       hard-irq read-recursion/213:  ok  |
[    0.004000]       soft-irq read-recursion/213:  ok  |
[    0.004000]       hard-irq read-recursion/231:  ok  |
[    0.004000]       soft-irq read-recursion/231:  ok  |
[    0.004000]       hard-irq read-recursion/312:  ok  |
[    0.004000]       soft-irq read-recursion/312:  ok  |
[    0.004000]       hard-irq read-recursion/321:  ok  |
[    0.004000]       soft-irq read-recursion/321:  ok  |
[    0.004000] -------------------------------------------------------
[    0.004000] Good, all 218 testcases passed! |
[    0.004000] ---------------------------------
[    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.004000] Memory: 505360k/524032k available (3507k kernel code, 18124k reserved, 4521k data, 300k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
[    0.004000]     vmalloc : 0xe07c0000 - 0xfffaa000   ( 503 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xdffc0000   ( 511 MB)
[    0.004000]       .init : 0xc08d9000 - 0xc0924000   ( 300 kB)
[    0.004000]       .data : 0xc046ce53 - 0xc08d7540   (4521 kB)
[    0.004000]       .text : 0xc0100000 - 0xc046ce53   (3507 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.004085] Calibrating delay loop (skipped), value calculated using timer frequency.. 1794.00 BogoMIPS (lpj=3588016)
[    0.004925] Mount-cache hash table entries: 512
[    0.010611] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.010789] CPU: L2 cache: 128K
[    0.010899] Intel machine check architecture supported.
[    0.011010] Intel machine check reporting enabled on CPU#0.
[    0.011168] CPU: Intel Celeron (Coppermine) stepping 0a
[    0.011486] Checking 'hlt' instruction... OK.
[    0.024716] ACPI: Core revision 20081204
[    0.081210] ACPI: setting ELCR to 0200 (from 0e00)
[    0.082613] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.082767] ftrace: allocating 11613 entries in 46 pages
[    0.100001] net_namespace: 1288 bytes
[    0.104259] khelper used greatest stack depth: 2940 bytes left
[    0.107240] NET: Registered protocol family 16
[    0.114064] ACPI: bus type pci registered
[    0.117579] PCI: PCI BIOS revision 2.10 entry at 0xfda95, last bus=2
[    0.117726] PCI: Using configuration type 1 for base access
[    0.141310] bio: create slab <bio-0> at 0
[    0.158755] khelper used greatest stack depth: 2788 bytes left
[    0.177438] ACPI: EC: Look up EC in DSDT
[    0.293238] ACPI: Interpreter enabled
[    0.293376] ACPI: (supports S0 S5)
[    0.293762] ACPI: Using PIC for interrupt routing
[    0.397781] ACPI: No dock devices found.
[    0.398256] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.400127] pci 0000:00:00.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
[    0.401149] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[    0.401343] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH4 GPIO
[    0.401786] pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
[    0.402086] pci 0000:00:1f.2: reg 20 io port: [0xef40-0xef5f]
[    0.402370] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefaf]
[    0.402653] pci 0000:00:1f.4: reg 20 io port: [0xef80-0xef9f]
[    0.402851] pci 0000:00:1f.5: reg 10 io port: [0xe800-0xe8ff]
[    0.402891] pci 0000:00:1f.5: reg 14 io port: [0xef00-0xef3f]
[    0.403295] pci 0000:02:00.0: reg 10 32bit mmio: [0xf2000000-0xf3ffffff]
[    0.403337] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeafc000-0xfeafffff]
[    0.403377] pci 0000:02:00.0: reg 18 32bit mmio: [0xfe000000-0xfe7fffff]
[    0.403479] pci 0000:02:00.0: reg 30 32bit mmio: [0xfeac0000-0xfeadffff]
[    0.403829] pci 0000:00:01.0: bridge 32bit mmio: [0xfda00000-0xfeafffff]
[    0.403859] pci 0000:00:01.0: bridge 32bit mmio pref: [0xf1700000-0xf57fffff]
[    0.404211] pci 0000:01:08.0: reg 10 32bit mmio: [0xfd9f9000-0xfd9f9fff]
[    0.404254] pci 0000:01:08.0: reg 14 io port: [0xdf00-0xdf3f]
[    0.404462] pci 0000:01:08.0: supports D1 D2
[    0.404476] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.404621] pci 0000:01:08.0: PME# disabled
[    0.404858] pci 0000:01:09.0: reg 10 io port: [0xdf40-0xdf5f]
[    0.404899] pci 0000:01:09.0: reg 14 32bit mmio: [0xfd9fe400-0xfd9fe41f]
[    0.405026] pci 0000:01:09.0: reg 30 32bit mmio: [0xfd9c0000-0xfd9cffff]
[    0.405184] pci 0000:01:0a.0: reg 10 io port: [0xd800-0xd8ff]
[    0.405225] pci 0000:01:0a.0: reg 14 32bit mmio: [0xfd9ff000-0xfd9fffff]
[    0.405352] pci 0000:01:0a.0: reg 30 32bit mmio: [0xfd9e0000-0xfd9effff]
[    0.405511] pci 0000:01:0b.0: reg 10 io port: [0xdff0-0xdff7]
[    0.405821] pci 0000:01:0c.0: reg 10 64bit mmio: [0xfd9fd000-0xfd9fdfff]
[    0.405883] pci 0000:01:0c.0: reg 18 64bit mmio: [0xfd9fe800-0xfd9fe8ff]
[    0.405924] pci 0000:01:0c.0: reg 20 io port: [0xd400-0xd4ff]
[    0.406120] pci 0000:01:0d.0: reg 10 io port: [0xdf80-0xdf9f]
[    0.406161] pci 0000:01:0d.0: reg 14 32bit mmio: [0xfd9fec00-0xfd9fec1f]
[    0.406288] pci 0000:01:0d.0: reg 30 32bit mmio: [0xfd9d0000-0xfd9dffff]
[    0.406448] pci 0000:00:1e.0: transparent bridge
[    0.406577] pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
[    0.406605] pci 0000:00:1e.0: bridge 32bit mmio: [0xfd900000-0xfd9fffff]
[    0.406634] pci 0000:00:1e.0: bridge 32bit mmio pref: [0xf1600000-0xf16fffff]
[    0.406704] pci_bus 0000:00: on NUMA node 0
[    0.406839] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.409154] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.454062] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.456718] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12)
[    0.459233] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
[    0.462012] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.464664] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.467178] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.469831] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12)
[    0.472469] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11 12)
[    0.474913] ACPI: Power Resource [FDDP] (off)
[    0.475903] ACPI: Power Resource [URP1] (off)
[    0.477505] ACPI: Power Resource [URP2] (off)
[    0.478360] ACPI: Power Resource [LPTP] (off)
[    0.483297] SCSI subsystem initialized
[    0.572247] khelper used greatest stack depth: 2768 bytes left
[    0.661357] libata version 3.00 loaded.
[    0.666850] PCI: Using ACPI for IRQ routing
[    0.677263] pnp: PnP ACPI init
[    0.677728] ACPI: bus type pnp registered
[    0.746003] pnp: PnP ACPI: found 13 devices
[    0.746142] ACPI: ACPI bus type pnp unregistered
[    0.746560] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.746720] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.746867] system 00:0c: iomem range 0x100000-0x1fffffff could not be reserved
[    0.788355] pci 0000:00:01.0: PCI bridge, secondary bus 0000:02
[    0.788496] pci 0000:00:01.0:   IO window: disabled
[    0.788629] pci 0000:00:01.0:   MEM window: 0xfda00000-0xfeafffff
[    0.788757] pci 0000:00:01.0:   PREFETCH window: 0x000000f1700000-0x000000f57fffff
[    0.789001] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    0.789129] pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
[    0.789260] pci 0000:00:1e.0:   MEM window: 0xfd900000-0xfd9fffff
[    0.789390] pci 0000:00:1e.0:   PREFETCH window: 0x000000f1600000-0x000000f16fffff
[    0.789643] pci 0000:00:1e.0: setting latency timer to 64
[    0.789669] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.789684] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.789699] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.789712] pci_bus 0000:02: resource 1 mem: [0xfda00000-0xfeafffff]
[    0.789726] pci_bus 0000:02: resource 2 mem: [0xf1700000-0xf57fffff]
[    0.789740] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.789754] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.789768] pci_bus 0000:01: resource 1 mem: [0xfd900000-0xfd9fffff]
[    0.789783] pci_bus 0000:01: resource 2 mem: [0xf1600000-0xf16fffff]
[    0.789796] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.789810] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
[    0.790387] NET: Registered protocol family 2
[    0.792438] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.797743] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.799030] TCP bind hash table entries: 16384 (order: 7, 655360 bytes)
[    0.806245] TCP: Hash tables configured (established 16384 bind 16384)
[    0.806612] TCP reno registered
[    0.808301] NET: Registered protocol family 1
[    0.913189] Initializing RT-Tester: OK
[    1.073837] VFS: Disk quotas dquot_6.5.2
[    1.075783] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.088150] msgmni has been set to 987
[    1.115730] alg: No test for stdrng (krng)
[    1.116342] io scheduler noop registered
[    1.118877] io scheduler cfq registered (default)
[    1.119339] pci 0000:02:00.0: Boot video device
[    1.119486] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    1.124586] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.125046] ACPI: Power Button (FF) [PWRF]
[    1.126570] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.126804] ACPI: Power Button (CM) [PBTN]
[    1.130816] processor ACPI_CPU:00: registered as cooling_device0
[    1.173353] Non-volatile memory driver v1.3
[    1.173497] Linux agpgart interface v0.103
[    1.174094] agpgart-intel 0000:00:00.0: Intel i815 Chipset
[    1.180292] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
[    1.180889] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    1.181062] Hangcheck: Using get_cycles().
[    1.181704] [drm] Initialized drm 1.1.0 20060810
[    1.181830] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.288278] Switched to high resolution mode on CPU 0
[    1.353181] khelper used greatest stack depth: 2744 bytes left
[    1.445839] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.705705] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.711751] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.713904] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.716414] Floppy drive(s): fd0 is 1.44M
[    1.720959] khelper used greatest stack depth: 2716 bytes left
[    1.737015] FDC 0 is a post-1991 82077
[    1.741966] Driver 'sd' needs updating - please use bus_type methods
[    1.742607] ata_piix 0000:00:1f.1: version 2.12
[    1.743270] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.746975] scsi0 : ata_piix
[    1.754809] scsi1 : ata_piix
[    1.792731] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.792882] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.793676] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.793805] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.796834] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
[    1.796987] PCI: setting IRQ 11 as level-triggered
[    1.797009] e100 0000:01:08.0: PCI INT A -> Link[LNKE] -> GSI 11 (level, low) -> IRQ 11
[    1.822642] e100 0000:01:08.0: PME# disabled
[    1.827263] e100: eth0: e100_probe: addr 0xfd9f9000, irq 11, MAC addr 00:03:47:a4:64:d5
[    1.830019] console [netcon0] enabled
[    1.830172] netconsole: network logging started
[    1.831560] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.862516] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.862874] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.865427] mice: PS/2 mouse device common for all mice
[    1.870906] cpuidle: using governor ladder
[    1.871062] cpuidle: using governor menu
[    1.885035] TCP cubic registered
[    1.885191] NET: Registered protocol family 17
[    1.885563] Using IPI Shortcut mode
[    1.892304] khelper used greatest stack depth: 2668 bytes left
[    1.907089] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    2.052972] ata1.00: ATA-6: ST380011A, 3.06, max UDMA/100
[    2.053111] ata1.00: 156301488 sectors, multi 16: LBA48 
[    2.068735] ata1.00: configured for UDMA/100
[    2.072164] scsi 0:0:0:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
[    2.079475] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    2.080296] sd 0:0:0:0: [sda] Write Protect is off
[    2.080434] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.081346] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.086143]  sda: sda1 sda2 sda3 sda4
[    2.121012] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.232825] ata2.00: ATAPI: CDU5211, YYS2, max UDMA/33, CDB intr
[    2.233840] ata2.00: configured for UDMA/33
[    2.236240] scsi 1:0:0:0: CD-ROM            SONY     CDU5211          YYS2 PQ: 0 ANSI: 5
[    2.857780] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    2.884989] kjournald starting.  Commit interval 5 seconds
[    2.886102] EXT3-fs: mounted filesystem with ordered data mode.
[    2.886753] VFS: Mounted root (ext3 filesystem) readonly on device 259:786432.
[    2.887380] debug: unmapping init memory c08d9000..c0924000
[    2.887770] Write protecting the kernel read-only data: 1992k
[    3.120140] async/0 used greatest stack depth: 2240 bytes left
[    3.824781] modprobe used greatest stack depth: 1908 bytes left
[    4.462751] stty used greatest stack depth: 1648 bytes left
[   18.721756] parport_pc 00:0a: reported by Plug and Play ACPI
[   18.722296] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   18.836570] parport0: Printer, Hewlett-Packard HP LaserJet 1100
[   18.845483] rtc_cmos 00:02: RTC can wake from S4
[   18.847381] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[   18.847654] rtc0: alarms up to one month, 114 bytes nvram
[   18.878213] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   18.878373] parport_pc 0000:01:0b.0: PCI INT A -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
[   18.878554] PCI parallel port detected: 1407:8000, I/O at 0xdff0(0x0), IRQ 11
[   18.878654] parport1: PC-style at 0xdff0, irq 11 [PCSPP,TRISTATE,EPP]
[   18.995384] modprobe used greatest stack depth: 1556 bytes left
[   19.654637] tms380tr.c: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler
[   19.677005] tmspci.c: v1.02 23/11/2000 by Adam Fritzler
[   19.680658] ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
[   19.680816] tmspci 0000:01:09.0: PCI INT A -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
[   19.681135] tr%d: 3Com Token Link Velocity
[   19.681256] tr%d:    IO: 0xdf40  IRQ: 11
[   19.681367] tr%d:    Ring Station Address: 00:a0:24:61:c4:df
[   19.690363] tmspci 0000:01:0d.0: PCI INT A -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
[   19.690725] tr%d: 3Com Token Link Velocity
[   19.690847] tr%d:    IO: 0xdf80  IRQ: 11
[   19.690959] tr%d:    Ring Station Address: 00:a0:24:61:bd:96
[   19.691208] ------------[ cut here ]------------
[   19.691327] WARNING: at fs/proc/generic.c:590 proc_register+0x215/0x258()
[   19.691441] Hardware name:         
[   19.691540] proc_dir_entry '11/tr%d' already registered
[   19.691645] Modules linked in: tmspci(+) tms380tr tr scsi_transport_fc scsi_tgt rtc_cmos rtc_core rtc_lib parport_pc parport evdev
[   19.692449] Pid: 1061, comm: modprobe Not tainted 2.6.29-06608-g15f7176-dirty #195
[   19.692607] Call Trace:
[   19.692730]  [<c01303ba>] warn_slowpath+0xb0/0xf1
[   19.692847]  [<c0161dff>] ? __lock_acquire+0x135a/0x1380
[   19.692970]  [<c021f817>] ? proc_register+0x1db/0x258
[   19.693085]  [<c015fe59>] ? trace_hardirqs_on_caller+0x12b/0x166
[   19.693203]  [<c015fe00>] ? trace_hardirqs_on_caller+0xd2/0x166
[   19.693323]  [<c021f817>] ? proc_register+0x1db/0x258
[   19.693438]  [<c015e71c>] ? put_lock_stats+0x18/0x3d
[   19.693553]  [<c021f817>] ? proc_register+0x1db/0x258
[   19.693669]  [<c021f851>] proc_register+0x215/0x258
[   19.694185]  [<c021fb57>] proc_mkdir_mode+0x45/0x82
[   19.694325]  [<c021fbb6>] proc_mkdir+0x22/0x35
[   19.694445]  [<c01731cd>] register_handler_proc+0xe2/0x101
[   19.694568]  [<c01710aa>] __setup_irq+0x25e/0x2f1
[   19.694685]  [<c0171315>] request_irq+0x123/0x1b6
[   19.694834]  [<e08d3b74>] ? tms380tr_interrupt+0x0/0xfde [tms380tr]
[   19.694971]  [<e08df40e>] tms_pci_attach+0x20b/0x2aa [tmspci]
[   19.695097]  [<c02bc85e>] local_pci_probe+0x22/0x35
[   19.695215]  [<c02bccf2>] pci_device_probe+0x60/0xc4
[   19.695348]  [<c034b4f7>] driver_probe_device+0xdb/0x1be
[   19.695468]  [<c034b64e>] __driver_attach+0x74/0xc2
[   19.695586]  [<c034b5da>] ? __driver_attach+0x0/0xc2
[   19.695702]  [<c034aaf6>] bus_for_each_dev+0x5d/0xa8
[   19.695820]  [<c034b2da>] driver_attach+0x27/0x3a
[   19.695937]  [<c034b5da>] ? __driver_attach+0x0/0xc2
[   19.696240]  [<c034a1ac>] bus_add_driver+0xdd/0x293
[   19.696373]  [<c034ba65>] driver_register+0xeb/0x1a6
[   19.696493]  [<c02bd005>] __pci_register_driver+0x5c/0xc7
[   19.696623]  [<e08e3000>] ? tms_pci_init+0x0/0x38 [tmspci]
[   19.696745]  [<e08e3025>] tms_pci_init+0x25/0x38 [tmspci]
[   19.696865]  [<c0101082>] _stext+0x82/0x1ee
[   19.696986]  [<c011deb9>] ? __change_page_attr_set_clr+0x8e8/0x978
[   19.697114]  [<c0161dff>] ? __lock_acquire+0x135a/0x1380
[   19.697243]  [<c017873f>] ? tracepoint_update_probe_range+0x2a/0xf5
[   19.697369]  [<c015e71c>] ? put_lock_stats+0x18/0x3d
[   19.697487]  [<c015e84a>] ? lock_release_holdtime+0x109/0x122
[   19.697611]  [<c01297eb>] ? sub_preempt_count+0x87/0xa7
[   19.697731]  [<c015fb73>] ? mark_held_locks+0x4e/0x78
[   19.697849]  [<c015fe59>] ? trace_hardirqs_on_caller+0x12b/0x166
[   19.697968]  [<c015e71c>] ? put_lock_stats+0x18/0x3d
[   19.698081]  [<c015e84a>] ? lock_release_holdtime+0x109/0x122
[   19.698199]  [<c01297eb>] ? sub_preempt_count+0x87/0xa7
[   19.698315]  [<c015e84a>] ? lock_release_holdtime+0x109/0x122
[   19.698434]  [<c01512de>] ? up_read+0x29/0x4f
[   19.698548]  [<c01523da>] ? __blocking_notifier_call_chain+0x5c/0x83
[   19.698671]  [<c0152422>] ? blocking_notifier_call_chain+0x21/0x37
[   19.698803]  [<c016ec22>] sys_init_module+0xdd/0x21f
[   19.698921]  [<c010370f>] sysenter_do_call+0x12/0x36
[   19.699033] ---[ end trace 6da0056ff36dd234 ]---
[   20.284589] Emulex LightPulse Fibre Channel SCSI driver 8.3.0
[   20.284742] Copyright(c) 2004-2008 Emulex.  All rights reserved.
[   20.371301] modprobe used greatest stack depth: 1224 bytes left
[   20.394333] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   20.394482] PCI: setting IRQ 10 as level-triggered
[   20.394504] lpfc 0000:01:0c.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[   20.417338] QLogic Fibre Channel HBA Driver: 8.03.00-k4
[   20.760895] scsi2 :  on PCI bus 01 device 60 irq 10
[   21.274384] usbcore: registered new interface driver usbfs
[   21.274922] usbcore: registered new interface driver hub
[   21.275852] usbcore: registered new device driver usb
[   21.312979] i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[   21.440173] Driver 'sr' needs updating - please use bus_type methods
[   21.446536] sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
[   21.446697] Uniform CD-ROM driver Revision: 3.20
[   21.448628] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   21.745101] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   21.898277] uhci_hcd: USB Universal Host Controller Interface driver
[   21.901877] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   21.902034] uhci_hcd 0000:00:1f.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
[   21.902260] uhci_hcd 0000:00:1f.2: setting latency timer to 64
[   21.902281] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[   21.902933] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
[   21.903351] uhci_hcd 0000:00:1f.2: irq 11, io base 0x0000ef40
[   21.996362] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   21.996513] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   21.996669] usb usb1: Product: UHCI Host Controller
[   21.996773] usb usb1: Manufacturer: Linux 2.6.29-06608-g15f7176-dirty uhci_hcd
[   21.996927] usb usb1: SerialNumber: 0000:00:1f.2
[   21.998338] usb usb1: configuration #1 chosen from 1 choice
[   21.999067] hub 1-0:1.0: USB hub found
[   21.999319] hub 1-0:1.0: 2 ports detected
[   22.001835] uhci_hcd 0000:00:1f.4: PCI INT C -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
[   22.002087] uhci_hcd 0000:00:1f.4: setting latency timer to 64
[   22.002108] uhci_hcd 0000:00:1f.4: UHCI Host Controller
[   22.002769] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
[   22.003094] uhci_hcd 0000:00:1f.4: irq 11, io base 0x0000ef80
[   22.003853] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   22.003992] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.108176] usb usb2: Product: UHCI Host Controller
[   22.108317] usb usb2: Manufacturer: Linux 2.6.29-06608-g15f7176-dirty uhci_hcd
[   22.108467] usb usb2: SerialNumber: 0000:00:1f.4
[   22.109587] usb usb2: configuration #1 chosen from 1 choice
[   22.110387] hub 2-0:1.0: USB hub found
[   22.110663] hub 2-0:1.0: 2 ports detected
[   22.331678] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   22.338836] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   24.656786] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
[   24.657092] Intel ICH 0000:00:1f.5: setting latency timer to 64
[   25.276268] intel8x0_measure_ac97_clock: measured 53658 usecs
[   25.276638] intel8x0: clocking to 41154
[   35.268546] BLKGRD allocated 1024 pages for _dump_buf_data at 0xdb800000
[   35.288461] BLKGRD allocated 1024 pages for _dump_buf_dif at 0xdb400000
[   35.310814] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 9
[   35.310963] PCI: setting IRQ 9 as level-triggered
[   35.310985] qla2xxx 0000:01:0a.0: PCI INT A -> Link[LNKG] -> GSI 9 (level, low) -> IRQ 9
[   35.311449] qla2xxx 0000:01:0a.0: Found an ISP2100, irq 9, iobase 0xe0d08000
[   35.313599] IRQ 9/qla2xxx: IRQF_DISABLED is not guaranteed on shared IRQs
[   35.313863] qla2xxx 0000:01:0a.0: Configuring PCI space...
[   35.314219] qla2xxx 0000:01:0a.0: Configure NVRAM parameters...
[   35.446081] qla2xxx 0000:01:0a.0: Verifying loaded RISC code...
[   35.460139] qla2xxx 0000:01:0a.0: firmware: requesting ql2100_fw.bin
[   35.828366] qla2xxx 0000:01:0a.0: Allocated (132 KB) for firmware dump...
[   35.972506] scsi3 : qla2xxx
[   40.980178] qla2xxx 0000:01:0a.0: 
[   40.980184]  QLogic Fibre Channel HBA Driver: 8.03.00-k4
[   40.980189]   QLogic QLA2100 - 
[   40.980192]   ISP2100: PCI (33 MHz) @ 0000:01:0a.0 hdma-, host#=3, fw=1.19.25 TP
[   43.629323] Adding 1004052k swap on /dev/sda2.  Priority:-1 extents:1 across:1004052k 
[   44.376366] EXT3 FS on sda3, internal journal
[   46.323891] NTFS driver 2.1.29 [Flags: R/W MODULE].
[   46.876436] usual_tables: module license 'unspecified' taints kernel.
[   46.897207] usbcore: registered new interface driver libusual
[   46.966834] Initializing USB Mass Storage driver...
[   46.967449] usbcore: registered new interface driver usb-storage
[   46.967607] USB Mass Storage support registered.
[   47.093043] smsc47m1: Found SMSC LPC47M10x/LPC47M112/LPC47M13x
[   47.093588] ACPI: I/O resource smsc47m1 [0x800-0x87f] conflicts with ACPI region RNT4 [0x80a-0x80a]
[   47.093763] ACPI: Device needs an ACPI driver
[   47.093903] smsc47m1.2048: use which platform_data?
[   48.582904] fuse init (API version 7.11)
[   48.923416] kjournald starting.  Commit interval 5 seconds
[   48.924696] EXT3 FS on sda4, internal journal
[   48.924765] EXT3-fs: mounted filesystem with ordered data mode.
[   54.816172] e100: eth0 NIC Link is Up 100 Mbps Full Duplex
[   58.190402] qla2xxx 0000:01:0a.0: Cable is unplugged...
[   90.971408] NET: Registered protocol family 10
[   91.039559] lo: Disabled Privacy Extensions
[   95.131471] RPC: Registered udp transport module.
[   95.131502] RPC: Registered tcp transport module.
[   95.709750] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  101.772085] eth0: no IPv6 routers present
[  103.486912] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  103.498955] NFSD: starting 90-second grace period
[  130.415148] lp0: using parport0 (interrupt-driven).
[  130.415956] lp1: using parport1 (interrupt-driven).
[  130.505753] ppdev: user-space parallel port driver
[  137.203488]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.203528]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.203551]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.210032]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.210071]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.210093]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.210222]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.210241]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.210257]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.210274]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.210290]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.210305]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.211418]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.211459]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.211481]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.211503]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  137.211968]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.211992]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.234640]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.234664]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  137.234680]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  137.245671]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.245710]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.245732]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.246711]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.246751]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.246773]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.246889]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.246908]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.246924]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.246941]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.246957]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.246972]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.264169]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.264205]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.264227]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.264249]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  137.265065]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  137.265103]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  137.265126]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  137.265147]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  138.301121]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  138.301162]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  138.301185]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  138.301206]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  138.301603]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  138.301637]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  138.301659]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  138.301680]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  138.316686]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  138.316726]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  138.316748]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  138.316770]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.455053]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.455092]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.455115]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.455137]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.486294]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.486322]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.486337]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.486353]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.486369]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.609920]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.609958]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.609980]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.610972]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.611012]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.611035]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.611151]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.611170]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.611185]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.611203]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.611219]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.611234]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.630587]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.630624]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.630646]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.630668]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.631394]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.631431]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.631453]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.631475]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.907666] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[  140.907704] pci 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[  140.907958]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.907982]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.907998]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.917592]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.917619]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.917636]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.917651]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.917667]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.919153] [drm] Initialized mga 3.2.1 20051102 for 0000:02:00.0 on minor 0
[  140.953635]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[  140.953663]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[  140.953679]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[  140.953694]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[  140.955583] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[  140.955710] agpgart-intel 0000:00:00.0: putting AGP V2 device into 2x mode
[  140.955897] pci 0000:02:00.0: putting AGP V2 device into 2x mode
[  140.974864] [drm] Initialized card for AGP DMA.
[29004.517202]   get_mtrr: cpu0 reg00 base=0000000000 size=0000020000 write-back
[29004.517239]   get_mtrr: cpu0 reg01 base=0000020000 size=0000000100 write-back
[29004.517259]   get_mtrr: cpu0 reg02 base=0000020000 size=0000000100 uncachable
[29004.517278]   get_mtrr: cpu0 reg03 base=00000f2000 size=0000002000 write-combining
[29004.517298]   get_mtrr: cpu0 reg04 base=00000f8000 size=0000004000 write-combining


-- 
Meelis Roos (mroos@linux.ee)
