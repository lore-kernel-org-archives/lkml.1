Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYFVSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYFVSBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYFVSBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:01:08 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:39510 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYFVSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:01:05 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP S.A.L.
To: linux-kernel@vger.kernel.org
Subject: none-<NULL> interrupt, handle_bad_irq/no_irq_chip during TSC sync check
Date: Sun, 22 Jun 2008 21:00:17 +0300
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806222100.17505.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if it's matter, if it is not important - just ignore it and dont answer.

Vanilla 2.6.25.4

dmesg

[    0.000000] Linux version 2.6.25.4-devel2 (root@visp-1) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #1 SMP Wed May 28 23:19:46 EEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffa8000 (usable)
[    0.000000]  BIOS-e820: 000000003ffa8000 - 000000003ffb7c00 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffb7c00 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00fe710] 000fe710
[    0.000000] Entering add_active_range(0, 0, 262056) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262056
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262056
[    0.000000] On node 0 totalpages: 262056
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4044 pages, LIFO batch:0
[    0.000000]   Normal zone: 2860 pages used for memmap
[    0.000000]   Normal zone: 222420 pages, LIFO batch:31
[    0.000000]   HighMem zone: 414 pages used for memmap
[    0.000000]   HighMem zone: 32266 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000F2620, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 000F26A0, 004C (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: FACP 000F27A8, 00F4 (r3 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: DSDT 3FFA8000, 3C53 (r1 DELL   PE_SC3          1 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFB7C00, 0040
[    0.000000] ACPI: APIC 000F289C, 00E0 (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: SPCR 000F297D, 0050 (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: HPET 000F29CD, 0038 (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: MCFG 000F2A05, 003C (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: DMI detected: Dell PE 1950
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] Processor #2 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec80000] gsi_base[32])
[    0.000000] IOAPIC[1]: apic_id 5, version 32, address 0xfec80000, GSI 32-55
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec81000] gsi_base[64])
[    0.000000] IOAPIC[2]: apic_id 6, version 32, address 0xfec81000, GSI 64-87
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec82000] gsi_base[96])
[    0.000000] IOAPIC[3]: apic_id 7, version 32, address 0xfec82000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 4 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258730
[    0.000000] Kernel command line: root=/dev/sda3 panic=5
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] mapped IOAPIC to ffff9000 (fec80000)
[    0.000000] mapped IOAPIC to ffff8000 (fec81000)
[    0.000000] mapped IOAPIC to ffff7000 (fec82000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c050d000 soft=c04ed000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 3192.132 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        2048
[    0.000999] ... CLASSHASH_SIZE:           1024
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000999] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000999] ... CHAINHASH_SIZE:          8192
[    0.000999]  memory used by lock dependency info: 992 kB
[    0.000999]  per task-struct memory footprint: 1920 bytes
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 1027560k/1048224k available (2466k kernel code, 20080k reserved, 1259k data, 260k init, 130720k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xffe14000 - 0xfffff000   (1964 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000999]       .init : 0xc04a9000 - 0xc04ea000   ( 260 kB)
[    0.000999]       .data : 0xc03688a7 - 0xc04a36d0   (1259 kB)
[    0.000999]       .text : 0xc0100000 - 0xc03688a7   (2466 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=12, HWalign=128, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[    0.000999] hpet clockevent registered
[    0.060993] Calibrating delay using timer specific routine.. 6388.35 BogoMIPS (lpj=3194176)
[    0.061277] Mount-cache hash table entries: 512
[    0.061558] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.061740] CPU: L2 cache: 2048K
[    0.061870] CPU: Physical Processor ID: 0
[    0.061993] CPU: Processor Core ID: 0
[    0.062124] Intel machine check architecture supported.
[    0.062261] Intel machine check reporting enabled on CPU#0.
[    0.062395] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.062531] CPU0: Thermal monitoring enabled
[    0.062665] Compat vDSO mapped to ffffe000.
[    0.062802] Checking 'hlt' instruction... OK.
[    0.066414] Freeing SMP alternatives: 13k freed
[    0.066547] ACPI: Core revision 20070126
[    0.074143] Parsing all Control Methods:
[    0.074255] Table [DSDT](id 0001) - 295 Objects with 44 Devices 111 Methods 8 Regions
[    0.074589]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.074902] evxfevnt-0079 [00] enable                : System is already in ACPI mode
[    0.075228] CPU0: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
[    0.075474] lockdep: fixing up alternatives.
[    0.075605] Booting processor 1/1 ip 2000
[    0.075736] CPU 1 irqstacks, hard=c050e000 soft=c04ee000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 6383.73 BogoMIPS (lpj=3191866)
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.000999] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.000999] CPU1: Thermal monitoring enabled
[    0.147425] CPU1: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
[    0.149002] lockdep: fixing up alternatives.
[    0.149136] Booting processor 2/2 ip 2000
[    0.149269] CPU 2 irqstacks, hard=c050f000 soft=c04ef000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 6383.79 BogoMIPS (lpj=3191898)
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#2.
[    0.000999] CPU2: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.000999] CPU2: Thermal monitoring enabled
[    0.220448] CPU2: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
[    0.221980] lockdep: fixing up alternatives.
[    0.222114] Booting processor 3/3 ip 2000
[    0.222246] CPU 3 irqstacks, hard=c0510000 soft=c04f0000
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 6383.77 BogoMIPS (lpj=3191887)
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#3.
[    0.000999] CPU3: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.000999] CPU3: Thermal monitoring enabled
[    0.293440] CPU3: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
[    0.294994] Total of 4 processors activated (25539.65 BogoMIPS).
[    0.295488] ENABLING IO-APIC IRQs
[    0.295813] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.306953] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.307002] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.000999] irq 66, desc: c049ae80, depth: 1, count: 0, unhandled: 0
[    0.308003] checking TSC synchronization [CPU#0 -> CPU#3]:->handle_irq():  c013dd3a, handle_bad_irq+0x0/0x1a6
[    0.000999] ->chip(): c0471760, no_irq_chip+0x0/0x40
[    0.000999] ->action(): 00000000
[    0.000999]   IRQ_DISABLED set
[    0.000999] unexpected IRQ trap at vector 42
[    0.308953]  passed.
[    0.308960] Brought up 4 CPUs
[    0.309114] CPU0 attaching sched-domain:
[    0.309118]  domain 0: span 00000003
[    0.309121]   groups: 00000001 00000002
[    0.309125]   domain 1: span 0000000f
[    0.309127]    groups: 00000003 0000000c
[    0.309132] CPU1 attaching sched-domain:
[    0.309134]  domain 0: span 00000003
[    0.309136]   groups: 00000002 00000001
[    0.309139]   domain 1: span 0000000f
[    0.309142]    groups: 00000003 0000000c
[    0.309145] CPU2 attaching sched-domain:
[    0.309147]  domain 0: span 0000000c
[    0.309149]   groups: 00000004 00000008
[    0.309153]   domain 1: span 0000000f
[    0.309155]    groups: 0000000c 00000003
[    0.309159] CPU3 attaching sched-domain:
[    0.309161]  domain 0: span 0000000c
[    0.309163]   groups: 00000008 00000004
[    0.309166]   domain 1: span 0000000f
[    0.309168]    groups: 0000000c 00000003
[    0.310188] net_namespace: 512 bytes
[    0.310536] NET: Registered protocol family 16
[    0.311046] No dock devices found.
[    0.311244] ACPI: bus type pci registered
[    0.312038] PCI: Using MMCONFIG for extended config space
[    0.312173] PCI: Using configuration type 1
[    0.312305] PCI: Dell PowerEdge 1950 detected, enabling pci=bfsort.
[    0.312448] Setting up standard PCI resources
[    0.316378] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[    0.317100] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 0 Runtime GPEs in this block
[    0.317416] ACPI: EC: Look up EC in DSDT
[    0.319972] Completing Region/Field/Buffer/Package initialization:.................
[    0.321213] Initialized 5/8 Regions 0/0 Fields 9/9 Buffers 3/4 Packages (304 nodes)
[    0.321548] Initializing Device/Processor/Thermal objects by executing _INI methods:.
[    0.322290] Executed 1 _INI methods requiring 0 _STA executions (examined 54 objects)
[    0.322642] ACPI: Interpreter enabled
[    0.322772] ACPI: (supports S0 S5)
[    0.322953] ACPI: Using IOAPIC for interrupt routing
[    0.330130] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.350759] pci 0000:01:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.351146] pci 0000:0b:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.351888] PCI: Transparent bridge - 0000:00:1e.0
[    0.351992] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.353034] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.353326] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.UPST._PRT]
[    0.353534] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.UPST.DWN1._PRT]
[    0.353823] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.UPST.DWN2._PRT]
[    0.354119] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.PE2X._PRT]
[    0.354573] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.354860] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3.PE2P._PRT]
[    0.355117] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.355406] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4.PE2P._PRT]
[    0.355693] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SBEX._PRT]
[    0.355988] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.COMP._PRT]
[    0.361945] ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.362745] ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.363695] ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.364644] ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.365595] ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.366547] ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.367502] ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.368453] ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.369390] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.369549] pnp: PnP ACPI init
[    0.369686] ACPI: bus type pnp registered
[    0.375600] pnp: PnP ACPI: found 12 devices
[    0.375733] ACPI: ACPI bus type pnp unregistered
[    0.376098] SCSI subsystem initialized
[    0.376289] libata version 3.00 loaded.
[    0.376371] usbcore: registered new interface driver usbfs
[    0.376536] usbcore: registered new interface driver hub
[    0.376972] usbcore: registered new device driver usb
[    0.377231] PCI: Using ACPI for IRQ routing
[    0.377363] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.121298] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.121302] hpet0: 3 64-bit timers, 14318180 Hz
[    0.124610] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.124610] system 00:08: ioport range 0x880-0x8bf has been reserved
[    0.124610] system 00:08: ioport range 0x8c0-0x8df has been reserved
[    0.124610] system 00:08: ioport range 0x8e0-0x8e3 has been reserved
[    0.124610] system 00:08: ioport range 0xc00-0xc7f has been reserved
[    0.124610] system 00:08: ioport range 0xca0-0xca7 has been reserved
[    0.124610] system 00:08: ioport range 0xca9-0xcab has been reserved
[    0.124610] system 00:08: ioport range 0xcad-0xcaf has been reserved
[    0.124618] system 00:09: ioport range 0xca8-0xca8 has been reserved
[    0.124754] system 00:09: ioport range 0xcac-0xcac has been reserved
[    0.124895] system 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.415508] PCI: Bridge: 0000:07:00.0
[    0.415639]   IO window: disabled.
[    0.415892]   MEM window: 0xf4000000-0xf7ffffff
[    0.416074]   PREFETCH window: disabled.
[    0.416349] PCI: Bridge: 0000:06:00.0
[    0.416390]   IO window: disabled.
[    0.416625]   MEM window: 0xf4000000-0xf7ffffff
[    0.416807]   PREFETCH window: disabled.
[    0.417082] PCI: Bridge: 0000:06:01.0
[    0.417211]   IO window: disabled.
[    0.417494]   MEM window: disabled.
[    0.417678]   PREFETCH window: disabled.
[    0.417953] PCI: Bridge: 0000:05:00.0
[    0.418082]   IO window: disabled.
[    0.418319]   MEM window: 0xf4000000-0xf7ffffff
[    0.418439]   PREFETCH window: disabled.
[    0.418714] PCI: Bridge: 0000:05:00.3
[    0.418843]   IO window: disabled.
[    0.419080]   MEM window: disabled.
[    0.419390]   PREFETCH window: disabled.
[    0.419661] PCI: Bridge: 0000:00:02.0
[    0.419791]   IO window: disabled.
[    0.419923]   MEM window: 0xf2000000-0xf7ffffff
[    0.420055]   PREFETCH window: disabled.
[    0.420189] PCI: Bridge: 0000:01:00.0
[    0.420320]   IO window: e000-efff
[    0.420393]   MEM window: 0xfc500000-0xfc6fffff
[    0.420526]   PREFETCH window: disabled.
[    0.420661] PCI: Bridge: 0000:00:03.0
[    0.420791]   IO window: e000-efff
[    0.420923]   MEM window: 0xfc400000-0xfc6fffff
[    0.421055]   PREFETCH window: disabled.
[    0.421188] PCI: Bridge: 0000:0b:00.0
[    0.421317]   IO window: disabled.
[    0.421392]   MEM window: disabled.
[    0.421524]   PREFETCH window: disabled.
[    0.421658] PCI: Bridge: 0000:00:04.0
[    0.421788]   IO window: disabled.
[    0.421920]   MEM window: 0xfc300000-0xfc3fffff
[    0.422052]   PREFETCH window: disabled.
[    0.422184] PCI: Bridge: 0000:00:05.0
[    0.422389]   IO window: disabled.
[    0.422521]   MEM window: disabled.
[    0.422652]   PREFETCH window: disabled.
[    0.422786] PCI: Bridge: 0000:00:06.0
[    0.422915]   IO window: disabled.
[    0.423046]   MEM window: disabled.
[    0.423177]   PREFETCH window: disabled.
[    0.423310] PCI: Bridge: 0000:00:07.0
[    0.423389]   IO window: disabled.
[    0.423521]   MEM window: disabled.
[    0.423653]   PREFETCH window: disabled.
[    0.423787] PCI: Bridge: 0000:03:00.0
[    0.423916]   IO window: disabled.
[    0.424050]   MEM window: 0xf8000000-0xfbffffff
[    0.424183]   PREFETCH window: disabled.
[    0.424394] PCI: Bridge: 0000:00:1c.0
[    0.424524]   IO window: disabled.
[    0.424657]   MEM window: 0xf8000000-0xfbffffff
[    0.424790]   PREFETCH window: disabled.
[    0.424924] PCI: Bridge: 0000:00:1e.0
[    0.425055]   IO window: d000-dfff
[    0.425188]   MEM window: 0xfc100000-0xfc2fffff
[    0.425322]   PREFETCH window: 0x00000000d8000000-0x00000000dfffffff
[    0.425408] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.425672] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.426044] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.426445] PCI: Setting latency timer of device 0000:05:00.0 to 64
[    0.426996] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.427315] PCI: Setting latency timer of device 0000:06:00.0 to 64
[    0.427981] PCI: Setting latency timer of device 0000:07:00.0 to 64
[    0.428524] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.428843] PCI: Setting latency timer of device 0000:06:01.0 to 64
[    0.429389] PCI: Setting latency timer of device 0000:05:00.3 to 64
[    0.429438] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.429699] PCI: Setting latency timer of device 0000:00:03.0 to 64
[    0.429717] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    0.429728] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.429988] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.430005] PCI: Setting latency timer of device 0000:0b:00.0 to 64
[    0.430014] ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.430274] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    0.430283] ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.430390] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.430401] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    0.430420] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.430681] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.430704] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    0.430716] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.430726] NET: Registered protocol family 2
[    0.435388] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.435388] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.435727] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.439909] TCP: Hash tables configured (established 131072 bind 65536)
[    0.440052] TCP reno registered
[    0.141980] Machine check exception polling timer started.
[    0.142885] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[    0.143897] highmem bounce pool size: 64 pages
[    0.144033] Total HugeTLB memory allocated, 0
[    0.148432] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.148816] io scheduler noop registered
[    0.148962] io scheduler cfq registered (default)
[    0.149193] pci 0000:10:0d.0: Boot video device
[    0.149326] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.149363] assign_interrupt_mode Found MSI capability
[    0.149525] Allocate Port Service[0000:00:02.0:pcie00]
[    0.149631] Allocate Port Service[0000:00:02.0:pcie01]
[    0.149731] PCI: Setting latency timer of device 0000:00:03.0 to 64
[    0.149764] assign_interrupt_mode Found MSI capability
[    0.149923] Allocate Port Service[0000:00:03.0:pcie00]
[    0.149978] Allocate Port Service[0000:00:03.0:pcie01]
[    0.150086] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.150120] assign_interrupt_mode Found MSI capability
[    0.150278] Allocate Port Service[0000:00:04.0:pcie00]
[    0.150333] Allocate Port Service[0000:00:04.0:pcie01]
[    0.150435] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    0.150468] assign_interrupt_mode Found MSI capability
[    0.150601] Allocate Port Service[0000:00:05.0:pcie00]
[    0.150655] Allocate Port Service[0000:00:05.0:pcie01]
[    0.150758] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.150791] assign_interrupt_mode Found MSI capability
[    0.150949] Allocate Port Service[0000:00:06.0:pcie00]
[    0.151008] Allocate Port Service[0000:00:06.0:pcie01]
[    0.151115] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    0.151148] assign_interrupt_mode Found MSI capability
[    0.151306] Allocate Port Service[0000:00:07.0:pcie00]
[    0.151362] Allocate Port Service[0000:00:07.0:pcie01]
[    0.151468] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.151575] assign_interrupt_mode Found MSI capability
[    0.151742] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.151797] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.152165] PCI: Setting latency timer of device 0000:05:00.0 to 64
[    0.153535] Allocate Port Service[0000:05:00.0:pcie11]
[    0.155664] PCI: Setting latency timer of device 0000:06:00.0 to 64
[    0.157030] assign_interrupt_mode Found MSI capability
[    0.158443] Allocate Port Service[0000:06:00.0:pcie21]
[    0.160488] PCI: Setting latency timer of device 0000:06:01.0 to 64
[    0.161846] assign_interrupt_mode Found MSI capability
[    0.163259] Allocate Port Service[0000:06:01.0:pcie21]
[    0.167606] AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
[    0.169789] AER service couldn't init device 0000:00:03.0:pcie01 - no _OSC support
[    0.171966] AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
[    0.174147] AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
[    0.176241] AER service couldn't init device 0000:00:06.0:pcie01 - no _OSC support
[    0.178440] AER service couldn't init device 0000:00:07.0:pcie01 - no _OSC support
[    0.178857] input: Power Button (FF) as /class/input/input0
[    0.178993] ACPI: Power Button (FF) [PWRF]
[    0.179604] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.179985] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.180372] ACPI: ACPI0007:02 is registered as cooling_device2
[    0.180632] ACPI: ACPI0007:03 is registered as cooling_device3
[    0.247538] Switched to high resolution mode on CPU 1
[    0.225281] Switched to high resolution mode on CPU 2
[    0.201498] Switched to high resolution mode on CPU 3
[    0.503488] Switched to high resolution mode on CPU 0
[    0.239530] Real Time Clock Driver v1.12ac
[    0.239870] hpet_resources: 0xfed00000 is busy
[    0.240080] intel_rng: FWH not detected
[    0.240252] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.240939] Hangcheck: Using get_cycles().
[    0.241072] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    0.241453] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.242096] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.242800] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.243215] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.253832] floppy0: no floppy controllers found
[    3.255033] brd: module loaded
[    3.255701] loop: module loaded
[    3.255850] Intel(R) Gigabit Ethernet Network Driver - version 1.0.8-k2
[    3.255985] Copyright (c) 2007 Intel Corporation.
[    3.256882] Loading iSCSI transport class v2.0-869.
[    3.257594] Driver 'sd' needs updating - please use bus_type methods
[    3.257779] Driver 'sr' needs updating - please use bus_type methods
[    3.258023] Fusion MPT base driver 3.04.06
[    3.258155] Copyright (c) 1999-2007 LSI Corporation
[    3.258294] Fusion MPT SPI Host driver 3.04.06
[    3.258492] Fusion MPT FC Host driver 3.04.06
[    3.258851] Fusion MPT SAS Host driver 3.04.06
[    3.259025] ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 64 (level, low) -> IRQ 64
[    3.259299] mptbase: ioc0: Initiating bringup
[    3.534173] ioc0: LSISAS1068 B0: Capabilities={Initiator}
[    4.845863] scsi0 : ioc0: LSISAS1068 B0, FwRev=00062800h, Ports=1, MaxQ=511, IRQ=64
[    4.875938] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JD-75MS 1E04 PQ: 0 ANSI: 5
[    4.575370] sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
[    4.877927] sd 0:0:0:0: [sda] Write Protect is off
[    4.878064] sd 0:0:0:0: [sda] Mode Sense: 67 00 00 08
[    4.624857] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.578891] sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
[    4.592345] sd 0:0:0:0: [sda] Write Protect is off
[    4.592345] sd 0:0:0:0: [sda] Mode Sense: 67 00 00 08
[    4.581543] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.581543]  sda: sda1 sda2 sda3
[    4.903006] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.903154] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.604456] Fusion MPT misc device (ioctl) driver 3.04.06
[    4.604482] mptctl: Registered with Fusion MPT base driver
[    4.604617] mptctl: /dev/mptctl @ (major,minor=10,220)
[    4.604775] usbmon: debugfs is not available
[    4.604937] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 21
[    4.605205] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    4.605209] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.605422] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    4.609542] ehci_hcd 0000:00:1d.7: debug port 1
[    4.609678] PCI: cache line size of 128 is not supported by device 0000:00:1d.7
[    4.609689] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xfc700000
[    4.619857] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.619981] usb usb1: configuration #1 chosen from 1 choice
[    4.620180] hub 1-0:1.0: USB hub found
[    4.620317] hub 1-0:1.0: 6 ports detected
[    4.721547] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.721547] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.721550] usb usb1: Product: EHCI Host Controller
[    4.721682] usb usb1: Manufacturer: Linux 2.6.25.4-devel2 ehci_hcd
[    4.721816] usb usb1: SerialNumber: 0000:00:1d.7
[    4.722010] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.722083] USB Universal Host Controller Interface driver v3.0
[    4.722248] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 21
[    4.722555] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    4.722559] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.722764] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.722999] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000cce0
[    4.735065] usb usb2: configuration #1 chosen from 1 choice
[    4.735273] hub 2-0:1.0: USB hub found
[    4.735414] hub 2-0:1.0: 2 ports detected
[    4.836294] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.836298] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.836510] usb usb2: Product: UHCI Host Controller
[    4.836643] usb usb2: Manufacturer: Linux 2.6.25.4-devel2 uhci_hcd
[    4.836777] usb usb2: SerialNumber: 0000:00:1d.0
[    4.836932] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 20 (level, low) -> IRQ 20
[    4.837198] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    4.837201] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.837378] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    4.837619] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000ccc0
[    4.837955] usb usb3: configuration #1 chosen from 1 choice
[    4.838152] hub 3-0:1.0: USB hub found
[    4.838303] hub 3-0:1.0: 2 ports detected
[    4.928771] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    4.939866] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.939866] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.939866] usb usb3: Product: UHCI Host Controller
[    4.939866] usb usb3: Manufacturer: Linux 2.6.25.4-devel2 uhci_hcd
[    4.939866] usb usb3: SerialNumber: 0000:00:1d.1
[    4.939866] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 21
[    4.939866] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    4.939866] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.939928] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    4.939965] uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000cca0
[    4.940254] usb usb4: configuration #1 chosen from 1 choice
[    4.940340] hub 4-0:1.0: USB hub found
[    4.940359] hub 4-0:1.0: 2 ports detected
[    5.042279] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.042279] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.042283] usb usb4: Product: UHCI Host Controller
[    5.042416] usb usb4: Manufacturer: Linux 2.6.25.4-devel2 uhci_hcd
[    5.042551] usb usb4: SerialNumber: 0000:00:1d.2
[    5.043996] usb 1-5: configuration #1 chosen from 1 choice
[    5.044252] hub 1-5:1.0: USB hub found
[    5.057286] hub 1-5:1.0: 4 ports detected
[    5.451381] usb 1-5: New USB device found, idVendor=04b4, idProduct=6560
[    5.451381] usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.263698] usbcore: registered new interface driver usblp
[    5.263778] PNP: No PS/2 controller found. Probing ports directly.
[    5.253832] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.253973] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.254308] mice: PS/2 mouse device common for all mice
[    5.310379] EDAC MC: Ver: 2.1.0 May 28 2008
[    5.311625] EDAC MC0: Giving out device to 'i5000_edac.c' 'I5000': DEV 0000:00:10.0
[    5.311939] EDAC PCI0: Giving out device to module 'i5000_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
[    5.312994] cpuidle: using governor ladder
[    5.313129] cpuidle: using governor menu
[    5.313322] usbcore: registered new interface driver usbhid
[    5.313379] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    5.313379] TCP cubic registered
[    5.313379] NET: Registered protocol family 1
[    5.313379] NET: Registered protocol family 17
[    5.313662] RPC: Registered udp transport module.
[    5.313795] RPC: Registered tcp transport module.
[    5.313930] Using IPI Shortcut mode
[    5.467412] EXT3-fs: INFO: recovery required on readonly filesystem.
[    5.467418] EXT3-fs: write access will be enabled during recovery.
[    7.282216] kjournald starting.  Commit interval 5 seconds
[    7.589165] EXT3-fs: sda3: orphan cleanup on readonly fs
[    7.370847] ext3_orphan_cleanup: deleting unreferenced inode 1736869
[    7.321153] ext3_orphan_cleanup: deleting unreferenced inode 1736866
[    7.332383] ext3_orphan_cleanup: deleting unreferenced inode 1754536
[    7.384079] ext3_orphan_cleanup: deleting unreferenced inode 1754537
[    7.384079] ext3_orphan_cleanup: deleting unreferenced inode 1754542
[    7.646977] ext3_orphan_cleanup: deleting unreferenced inode 1788036
[    7.363014] ext3_orphan_cleanup: deleting unreferenced inode 1736858
[    7.671323] ext3_orphan_cleanup: deleting unreferenced inode 1736756
[    7.369284] ext3_orphan_cleanup: deleting unreferenced inode 1754830
[    7.369284] ext3_orphan_cleanup: deleting unreferenced inode 1754831
[    7.420898] ext3_orphan_cleanup: deleting unreferenced inode 1754877
[    7.681489] ext3_orphan_cleanup: deleting unreferenced inode 1803914
[    7.437199] EXT3-fs: sda3: 12 orphan inodes deleted
[    7.437199] EXT3-fs: recovery complete.
[    7.441994] EXT3-fs: mounted filesystem with ordered data mode.
[    7.441994] VFS: Mounted root (ext3 filesystem) readonly.
[    7.441994] Freeing unused kernel memory: 260k freed
[   10.350622] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   10.350756] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x0860)
[   10.350800] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   10.400125] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[   10.400188] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   10.406736] ata_piix 0000:00:1f.1: version 2.12
[   10.406754] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[   10.406821] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   10.407469] scsi1 : ata_piix
[   10.408580] scsi2 : ata_piix
[   10.408644] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[   10.408650] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[   11.056356] ata1.00: ATAPI: TEAC CD-ROM CD-224E-N, 3.AB, max UDMA/33
[   11.213038] ata1.00: configured for UDMA/33
[   10.938554] ata2: port disabled. ignoring.
[   10.882640] scsi 1:0:0:0: CD-ROM            TEAC     CD-ROM CD-224E-N 3.AB PQ: 0 ANSI: 5
[   11.223268] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   11.223268] Uniform CD-ROM driver Revision: 3.20
[   11.223268] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   11.223268] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   11.892060] EXT3 FS on sda3, internal journal
[   12.116283] ipmi message handler version 39.1
[   12.069632] IPMI System Interface driver.
[   12.069639] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca8, slave address 0x20, irq 0
[   12.099653] ipmi: Found new BMC (man_id: 0x0002a2,  prod_id: 0x0100, dev_id: 0x20)
[   12.099653] IPMI kcs interface initialized
[   12.186950] ipmi device interface
[   12.136729] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.4 (February 18, 2008)
[   12.136768] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   12.494097] eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B1) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 16, node addr 00:13:72:f8:73:ac
[   12.494485] ACPI: PCI Interrupt 0000:08:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   12.830514] eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B1) PCI-X 64-bit 133MHz found at mem f4000000, IRQ 16, node addr 00:13:72:f8:73:ae
[   13.964984] Unable to find swap-space signature


visp-1 ~ # cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:       2084       1748       1732       1738   IO-APIC-edge      timer
  1:          1          0          1          0   IO-APIC-edge      i8042
  8:          0          1          0          4   IO-APIC-edge      rtc
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          1          1          0          2   IO-APIC-edge      i8042
 14:         10         10          9         10   IO-APIC-edge      ata_piix
 15:          0          0          0          0   IO-APIC-edge      ata_piix
 20:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21:          6          5          7          5   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb4
 64:    2121905    2123049    2120752    2121833   IO-APIC-fasteoi   ioc0
 66:          0          0          1          0      none-<NULL> <--- what is this?
212:    1501725    1500763    1500902    1501504   PCI-MSI-edge      eth1
213: 3054979339 3054980671 3054984007 3054981140   PCI-MSI-edge      eth0
214:          0          1          1          1   PCI-MSI-edge
NMI:          0          0          0          0   Non-maskable interrupts
LOC: 1435754798 1055023775 1191132379  908665109   Local timer interrupts
RES:    5441439    5896908    4572913    4428931   Rescheduling interrupts
CAL:     139367     139339     139376       1636   function call interrupts
TLB:     659682     662366     679061     654062   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
SPU:          0          0          0          0   Spurious interrupts

-- 
------
Technical Manager
Virtual ISP S.A.L.
Lebanon
