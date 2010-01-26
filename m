Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603Ab0AZPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0AZPz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581Ab0AZPz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:55:27 -0500
Received: from rrzmta5.rz.uni-regensburg.de ([194.94.155.56]:56559 "EHLO
	rrzmta5.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528Ab0AZPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:55:24 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 10:55:23 EST
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg
To: linux-kernel@vger.kernel.org
Date: Tue, 26 Jan 2010 16:46:22 +0100
MIME-Version: 1.0
Subject: 2.6.31.8 (OpenSUSE): BUG: scheduling while atomic: swapper/0/0x10000002
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Message-Id: <20100126154652.AD7BABF1@rrzmta5.rz.uni-regensburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

maybe it's reported to death already, but I saw a few bugs during boot 
with the "current" kernel for openSUSE 11.2. The machine has an AMD 
Athlon II DUal Core processor:

klogd 1.4.1, log source = ksyslog started.
<5>[    0.000000] Linux version 2.6.31.8-0.1-desktop (geeko@buildhost) 
(gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #1 
SMP PREEMPT 2009-12-15 23:55:40 +0100
<6>[    0.000000] KERNEL supported cpus:
<6>[    0.000000]   Intel GenuineIntel
<6>[    0.000000]   AMD AuthenticAMD
<6>[    0.000000]   NSC Geode by NSC
<6>[    0.000000]   Cyrix CyrixInstead
<6>[    0.000000]   Centaur CentaurHauls
<6>[    0.000000]   Transmeta GenuineTMx86
<6>[    0.000000]   Transmeta TransmetaCPU
<6>[    0.000000]   UMC UMC UMC UMC
<6>[    0.000000] BIOS-provided physical RAM map:
<6>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 
(usable)
<6>[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 
(reserved)
<6>[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 
(reserved)
<6>[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 
(usable)
<6>[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI 
NVS)
<6>[    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI 
data)
<6>[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 
(reserved)
<6>[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 
(reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 
(reserved)
<6>[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 
(usable)
<6>[    0.000000] DMI 2.4 present.
<6>[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x1000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-C7FFF write-protect
<7>[    0.000000]   C8000-FFFFF uncachable
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
<7>[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
<7>[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
<7>[    0.000000]   3 base 0000CFF00000 mask FFFFFFF00000 uncachable
<7>[    0.000000]   4 base 000100000000 mask FFFFE0000000 write-back
<7>[    0.000000]   5 base 000120000000 mask FFFFF0000000 write-back
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<7>[    0.000000] TOM2: 0000000130000000 aka 4864M
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
<7>[    0.000000] e820 update range: 00000000cff00000 - 
0000000100000000 (usable) ==> (reserved)
<7>[    0.000000] e820 update range: 0000000000002000 - 
0000000000006000 (usable) ==> (reserved)
<6>[    0.000000] Scanning 1 areas for low memory corruption
<6>[    0.000000] modified physical RAM map:
<6>[    0.000000]  modified: 0000000000000000 - 0000000000002000 
(usable)
<6>[    0.000000]  modified: 0000000000002000 - 0000000000006000 
(reserved)
<6>[    0.000000]  modified: 0000000000006000 - 000000000009f800 
(usable)
<6>[    0.000000]  modified: 000000000009f800 - 00000000000a0000 
(reserved)
<6>[    0.000000]  modified: 00000000000f0000 - 0000000000100000 
(reserved)
<6>[    0.000000]  modified: 0000000000100000 - 00000000cfee0000 
(usable)
<6>[    0.000000]  modified: 00000000cfee0000 - 00000000cfee3000 (ACPI 
NVS)
<6>[    0.000000]  modified: 00000000cfee3000 - 00000000cfef0000 (ACPI 
data)
<6>[    0.000000]  modified: 00000000cfef0000 - 00000000cff00000 
(reserved)
<6>[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 
(reserved)
<6>[    0.000000]  modified: 00000000fec00000 - 0000000100000000 
(reserved)
<6>[    0.000000]  modified: 0000000100000000 - 0000000130000000 
(usable)
<7>[    0.000000] initial memory mapped : 0 - 01000000
<6>[    0.000000] init_memory_mapping: 0000000000000000-
0000000036ffe000
<6>[    0.000000] NX (Execute Disable) protection: active
<7>[    0.000000]  0000000000 - 0000200000 page 4k
<7>[    0.000000]  0000200000 - 0036e00000 page 2M
<7>[    0.000000]  0036e00000 - 0036ffe000 page 4k
<7>[    0.000000] kernel direct mapping tables up to 36ffe000 @ 7000-
12000
<6>[    0.000000] RAMDISK: 37863000 - 37feffbb
<6>[    0.000000] Allocated new RAMDISK: 00af9000 - 01285fbb
<6>[    0.000000] Move RAMDISK from 0000000037863000 - 0000000037feffba 
to 00af9000 - 01285fba
<4>[    0.000000] ACPI: RSDP 000f6fb0 00014 (v00 GBT   )
<4>[    0.000000] ACPI: RSDT cfee3000 0003C (v01 GBT    GBTUACPI 
42302E31 GBTU 01010101)
<4>[    0.000000] ACPI: FACP cfee3040 00074 (v01 GBT    GBTUACPI 
42302E31 GBTU 01010101)
<4>[    0.000000] ACPI: DSDT cfee30c0 05E23 (v01 GBT    GBTUACPI 
00001000 MSFT 03000000)
<4>[    0.000000] ACPI: FACS cfee0000 00040
<4>[    0.000000] ACPI: SSDT cfee8fc0 0095E (v01 PTLTD  POWERNOW 
00000001  LTP 00000001)
<4>[    0.000000] ACPI: HPET cfee9940 00038 (v01 GBT    GBTUACPI 
42302E31 GBTU 00000098)
<4>[    0.000000] ACPI: MCFG cfee9980 0003C (v01 GBT    GBTUACPI 
42302E31 GBTU 01010101)
<4>[    0.000000] ACPI: TAMG cfee99c0 002FA (v01 GBT    GBT   B0 
5455312E BG 53450101)
<4>[    0.000000] ACPI: APIC cfee8f00 00084 (v01 GBT    GBTUACPI 
42302E31 GBTU 01010101)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] could not find any ACPI SRAT memory areas.
<3>[    0.000000] failed to get NUMA memory information from SRAT table
<7>[    0.000000] NUMA - single node, flat memory mode
<6>[    0.000000] Node: 0, start_pfn: 0, end_pfn: 130000
<7>[    0.000000]   Setting physnode_map array to node 0 for pfns:
<7>[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 
24000 28000 2c000 30000 34000 38000 3c000 40000 44000 48000 4c000 50000 
54000 58000 5c000 60000 64000 68000 6c000 70000 74000 78000 7c000 80000 
84000 88000 8c000 90000 94000 98000 9c000 a0000 a4000 a8000 ac000 b0000 
b4000 b8000 bc000 c0000 c4000 c8000 cc000 d0000 d4000 d8000 dc000 e0000 
e4000 e8000 ec000 f0000 f4000 f8000 fc000 100000 104000 108000 10c000 
110000 114000 118000 11c000 120000 124000 128000 12c000 
<7>[    0.000000] node 0 pfn: [0 - 130000]
<7>[    0.000000] Reserving 10240 pages of KVA for lmem_map of node 0 
at 12d800
<7>[    0.000000] remove_active_range (0, 1234944, 1245184)
<6>[    0.000000] Reserving total of 2800 pages for numa KVA remap
<6>[    0.000000] kva_start_pfn ~ 34600 max_low_pfn ~ 36ffe
<6>[    0.000000] max_pfn = 130000
<5>[    0.000000] 3984MB HIGHMEM available.
<5>[    0.000000] 879MB LOWMEM available.
<7>[    0.000000] max_low_pfn = 36ffe, highstart_pfn = 36ffe
<7>[    0.000000] Low memory ends at vaddr f6ffe000
<7>[    0.000000] node 0 will remap to vaddr f4600000 - f6e00000
<7>[    0.000000] allocate_pgdat: node 0 NODE_DATA f4600000
<7>[    0.000000] remap_numa_kva: node 0
<7>[    0.000000] remap_numa_kva: f4600000 to pfn 0012d800
<7>[    0.000000] remap_numa_kva: f4800000 to pfn 0012da00
<7>[    0.000000] remap_numa_kva: f4a00000 to pfn 0012dc00
<7>[    0.000000] remap_numa_kva: f4c00000 to pfn 0012de00
<7>[    0.000000] remap_numa_kva: f4e00000 to pfn 0012e000
<7>[    0.000000] remap_numa_kva: f5000000 to pfn 0012e200
<7>[    0.000000] remap_numa_kva: f5200000 to pfn 0012e400
<7>[    0.000000] remap_numa_kva: f5400000 to pfn 0012e600
<7>[    0.000000] remap_numa_kva: f5600000 to pfn 0012e800
<7>[    0.000000] remap_numa_kva: f5800000 to pfn 0012ea00
<7>[    0.000000] remap_numa_kva: f5a00000 to pfn 0012ec00
<7>[    0.000000] remap_numa_kva: f5c00000 to pfn 0012ee00
<7>[    0.000000] remap_numa_kva: f5e00000 to pfn 0012f000
<7>[    0.000000] remap_numa_kva: f6000000 to pfn 0012f200
<7>[    0.000000] remap_numa_kva: f6200000 to pfn 0012f400
<7>[    0.000000] remap_numa_kva: f6400000 to pfn 0012f600
<7>[    0.000000] remap_numa_kva: f6600000 to pfn 0012f800
<7>[    0.000000] remap_numa_kva: f6800000 to pfn 0012fa00
<7>[    0.000000] remap_numa_kva: f6a00000 to pfn 0012fc00
<7>[    0.000000] remap_numa_kva: f6c00000 to pfn 0012fe00
<7>[    0.000000] High memory starts at vaddr f6ffe000
<6>[    0.000000]   mapped low ram: 0 - 36ffe000
<6>[    0.000000]   low ram: 0 - 36ffe000
<6>[    0.000000]   node 0 low ram: 00000000 - 36ffe000
<6>[    0.000000]   node 0 bootmap 0000f000 - 00015e00
<6>[    0.000000] (11 early reservations) ==> bootmem [0000000000 - 
0036ffe000]
<6>[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
<6>[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
<6>[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
<6>[    0.000000]   #3 [0000200000 - 0000aefab0]    TEXT DATA BSS ==> 
[0000200000 - 0000aefab0]
<6>[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> 
[000009f800 - 0000100000]
<6>[    0.000000]   #5 [0000af0000 - 0000af80fe]              BRK ==> 
[0000af0000 - 0000af80fe]
<6>[    0.000000]   #6 [0000007000 - 000000f000]          PGTABLE ==> 
[0000007000 - 000000f000]
<6>[    0.000000]   #7 [0000af9000 - 0001285fbb]      NEW RAMDISK ==> 
[0000af9000 - 0001285fbb]
<6>[    0.000000]   #8 [012d800000 - 0130000000]          KVA RAM
<6>[    0.000000]   #9 [0034600000 - 0036e00000]           KVA PG ==> 
[0034600000 - 0036e00000]
<6>[    0.000000]   #10 [000000f000 - 0000016000]          BOOTMAP ==> 
[000000f000 - 0000016000]
<6>[    0.000000] found SMP MP-table at [c00f55a0] f55a0
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA      0x00000000 -> 0x00001000
<4>[    0.000000]   Normal   0x00001000 -> 0x00036ffe
<4>[    0.000000]   HighMem  0x00036ffe -> 0x00130000
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[4] active PFN ranges
<4>[    0.000000]     0: 0x00000000 -> 0x00000002
<4>[    0.000000]     0: 0x00000006 -> 0x0000009f
<4>[    0.000000]     0: 0x00000100 -> 0x000cfee0
<4>[    0.000000]     0: 0x00100000 -> 0x0012d800
<7>[    0.000000] On node 0 totalpages: 1037947
<7>[    0.000000] free_area_init_node: node 0, pgdat f4600000, 
node_mem_map f4602000
<7>[    0.000000]   DMA zone: 32 pages used for memmap
<7>[    0.000000]   DMA zone: 0 pages reserved
<7>[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
<7>[    0.000000]   Normal zone: 1728 pages used for memmap
<7>[    0.000000]   Normal zone: 219454 pages, LIFO batch:31
<7>[    0.000000]   HighMem zone: 7889 pages used for memmap
<7>[    0.000000]   HighMem zone: 804881 pages, LIFO batch:31
<6>[    0.000000] Using APIC driver default
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x4008
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] 
gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, 
GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl 
dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low 
level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<6>[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
<6>[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
<7>[    0.000000] nr_irqs_gsi: 24
<6>[    0.000000] PM: Registered nosave memory: 0000000000002000 - 
0000000000006000
<6>[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
<6>[    0.000000] Allocating PCI resources starting at cff00000 (gap: 
cff00000:10100000)
<6>[    0.000000] NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 
nr_node_ids:8
<6>[    0.000000] PERCPU: Embedded 14 pages at c1296000, static data 
34204 bytes
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping 
on.  Total pages: 1028298
<4>[    0.000000] Policy zone: HighMem
<5>[    0.000000] Kernel command line: root=/dev/sda8 
resume=/dev/sysVG/swapLV splash=silent vga=0x317
<6>[    0.000000] bootsplash: silent mode.
<4>[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
<6>[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 
524288 bytes)
<6>[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 
262144 bytes)
<6>[    0.000000] Enabling fast FPU save and restore... done.
<6>[    0.000000] Enabling unmasked SIMD FPU exception support... done.
<6>[    0.000000] Initializing CPU#0
<6>[    0.000000] Initializing HighMem for node 0 (00036ffe:0012d800)
<6>[    0.000000] Memory: 4092768k/4980736k available (4720k kernel 
code, 59016k reserved, 2951k data, 464k init, 3251080k highmem)
<6>[    0.000000] virtual kernel memory layout:
<6>[    0.000000]     fixmap  : 0xff5b5000 - 0xfffff000   (10536 kB)
<6>[    0.000000]     pkmap   : 0xff000000 - 0xff200000   (2048 kB)
<6>[    0.000000]     vmalloc : 0xf77fe000 - 0xfeffe000   ( 120 MB)
<6>[    0.000000]     lowmem  : 0xc0000000 - 0xf6ffe000   ( 879 MB)
<6>[    0.000000]       .init : 0xc097f000 - 0xc09f3000   ( 464 kB)
<6>[    0.000000]       .data : 0xc069c1b2 - 0xc097e0c8   (2951 kB)
<6>[    0.000000]       .text : 0xc0200000 - 0xc069c1b2   (4720 kB)
<6>[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] NR_IRQS:2304 nr_irqs:440
<4>[    0.000000] Fast TSC calibration using PIT
<4>[    0.000000] Detected 2812.665 MHz processor.
<4>[    0.000055] Console: colour dummy device 80x25
<6>[    0.000057] console [tty0] enabled
<7>[    0.000482] hpet clockevent registered
<7>[    0.000487]   alloc irq_desc for 24 on node 0
<7>[    0.000489]   alloc kstat_irqs on node 0
<6>[    0.000495] HPET: 4 timers in total, 1 timers will be used for 
per-cpu timer
<6>[    0.001006] Calibrating delay loop (skipped), value calculated 
using timer frequency.. 5625.33 BogoMIPS (lpj=2812665)
<4>[    0.006162] kdb version 4.4 by Keith Owens, Scott Lurndal. 
Copyright SGI, All Rights Reserved
<6>[    0.006230] Security Framework initialized
<6>[    0.006243] AppArmor: AppArmor initialized
<4>[    0.006260] Mount-cache hash table entries: 512
<6>[    0.006355] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
<6>[    0.006360] CPU: L2 Cache: 1024K (64 bytes/line)
<6>[    0.006364] CPU: Physical Processor ID: 0
<6>[    0.006366] CPU: Processor Core ID: 0
<6>[    0.006370] mce: CPU supports 6 MCE banks
<6>[    0.006378] using C1E aware idle routine
<6>[    0.006383] Performance Counters: AMD PMU driver.
<6>[    0.006388] ... version:                 0
<6>[    0.006391] ... bit width:               48
<6>[    0.006393] ... generic counters:        4
<6>[    0.006396] ... value mask:              0000ffffffffffff
<6>[    0.006400] ... max period:              00007fffffffffff
<6>[    0.006403] ... fixed-purpose counters:  0
<6>[    0.006406] ... counter mask:            000000000000000f
<6>[    0.006411] Checking 'hlt' instruction... OK.
<6>[    0.010745] Unpacking initramfs...
<3>[    0.018131] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.018138] Modules linked in:
<4>[    0.018143] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.018147] Call Trace:
<4>[    0.018159]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.018166]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.018172]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.018178]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.018184]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.018190]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.018196]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.018201]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.018206]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.018212]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.018218]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.018224]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.018229]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.018235]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.018240]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.018245]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.018250]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.018255]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.018261]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.018266]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.018272]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.018277]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.018282]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.027082] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.027089] Modules linked in:
<4>[    0.027093] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.027097] Call Trace:
<4>[    0.027108]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.027115]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.027120]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.027126]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.027132]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.027138]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.027143]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.027149]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.027154]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.027160]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.027166]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.027171]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.027177]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.027183]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.027188]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.027193]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.027199]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.027204]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.027209]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.027215]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.027220]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.027225]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.027230]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.036220] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.036226] Modules linked in:
<4>[    0.036231] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.036235] Call Trace:
<4>[    0.036246]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.036253]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.036258]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.036264]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.036269]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.036275]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.036281]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.036287]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.036292]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.036297]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.036303]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.036309]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.036315]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.036320]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.036325]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.036330]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.036336]  [<c09815c3>] do_copy+0x3d/0xe6
<4>[    0.036341]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.036346]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.036352]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.036357]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.036362]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.036367]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.045219] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.045227] Modules linked in:
<4>[    0.045231] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.045235] Call Trace:
<4>[    0.045247]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.045253]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.045259]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.045264]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.045270]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.045276]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.045281]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.045287]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.045292]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.045298]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.045303]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.045309]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.045315]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.045320]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.045326]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.045330]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.045336]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.045341]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.045347]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.045352]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.045357]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.045362]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.045368]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.054226] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.054232] Modules linked in:
<4>[    0.054237] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.054241] Call Trace:
<4>[    0.054251]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.054258]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.054263]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.054269]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.054275]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.054281]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.054286]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.054292]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.054297]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.054303]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.054309]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.054314]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.054320]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.054326]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.054331]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.054336]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.054341]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.054346]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.054352]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.054357]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.054363]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.054368]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.054373]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.063082] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.063088] Modules linked in:
<4>[    0.063092] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.063096] Call Trace:
<4>[    0.063106]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.063112]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.063118]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.063123]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.063129]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.063135]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.063141]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.063146]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.063151]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.063157]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.063163]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.063168]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.063174]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.063180]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.063185]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.063190]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.063196]  [<c09815c3>] do_copy+0x3d/0xe6
<4>[    0.063201]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.063206]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.063212]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.063217]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.063222]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.063228]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.072153] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.072159] Modules linked in:
<4>[    0.072164] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.072168] Call Trace:
<4>[    0.072179]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.072185]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.072191]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.072196]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.072202]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.072208]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.072214]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.072220]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.072225]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.072230]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.072236]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.072242]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.072248]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.072253]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.072259]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.072263]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.072269]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.072274]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.072279]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.072285]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.072290]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.072295]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.072300]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.081111] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.081118] Modules linked in:
<4>[    0.081122] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.081126] Call Trace:
<4>[    0.081137]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.081143]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.081149]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.081155]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.081161]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.081167]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.081172]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.081178]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.081183]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.081188]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.081194]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.081200]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.081206]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.081211]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.081216]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.081221]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.081227]  [<c09815c3>] do_copy+0x3d/0xe6
<4>[    0.081232]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.081238]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.081243]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.081248]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.081253]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.081259]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.090140] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.090147] Modules linked in:
<4>[    0.090151] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.090155] Call Trace:
<4>[    0.090166]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.090173]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.090178]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.090184]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.090190]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.090196]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.090201]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.090207]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.090212]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.090218]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.090223]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.090229]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.090235]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.090241]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.090246]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.090251]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.090256]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.090261]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.090267]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.090272]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.090278]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.090283]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.090288]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.100080] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.100086] Modules linked in:
<4>[    0.100091] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.100095] Call Trace:
<4>[    0.100106]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.100113]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.100118]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.100124]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.100130]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.100135]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.100141]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.100147]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.100152]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.100157]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.100163]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.100169]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.100175]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.100180]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.100186]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.100190]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.100196]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.100201]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.100207]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.100212]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.100217]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.100222]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.100228]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.109088] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.109095] Modules linked in:
<4>[    0.109100] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.109104] Call Trace:
<4>[    0.109115]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.109121]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.109127]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.109133]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.109138]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.109144]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.109150]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.109156]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.109161]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.109167]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.109173]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.109178]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.109184]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.109190]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.109195]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.109200]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.109206]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.109211]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.109216]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.109222]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.109227]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.109232]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.109238]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.118041] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.118048] Modules linked in:
<4>[    0.118052] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.118056] Call Trace:
<4>[    0.118066]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.118073]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.118079]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.118084]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.118090]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.118096]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.118102]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.118107]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.118112]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.118118]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.118124]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.118130]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.118135]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.118141]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.118146]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.118151]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.118157]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.118162]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.118167]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.118173]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.118178]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.118183]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.118188]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.127070] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.127076] Modules linked in:
<4>[    0.127080] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.127085] Call Trace:
<4>[    0.127095]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.127102]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.127107]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.127113]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.127118]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.127124]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.127130]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.127136]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.127141]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.127146]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.127152]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.127158]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.127164]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.127169]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.127175]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.127180]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.127185]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.127190]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.127196]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.127201]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.127206]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.127211]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.127217]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.135994] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.136001] Modules linked in:
<4>[    0.136005] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.136009] Call Trace:
<4>[    0.136020]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.136026]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.136032]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.136037]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.136043]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.136050]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.136055]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.136061]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.136066]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.136071]  [<c02d3adc>] generic_perform_write+0x13c/0x1e0
<4>[    0.136077]  [<c02d3bfb>] generic_file_buffered_write+0x7b/0x150
<4>[    0.136083]  [<c02d55c3>] 
__generic_file_aio_write_nolock+0x213/0x530
<4>[    0.136089]  [<c02d5a15>] generic_file_aio_write+0x65/0xe0
<4>[    0.136094]  [<c031538c>] do_sync_write+0xdc/0x130
<4>[    0.136100]  [<c03156ba>] vfs_write+0xba/0x1b0
<4>[    0.136105]  [<c03160c3>] sys_write+0x53/0xa0
<4>[    0.136110]  [<c0981627>] do_copy+0xa1/0xe6
<4>[    0.136115]  [<c0980f6b>] flush_buffer+0x81/0xb8
<4>[    0.136121]  [<c09a770d>] gunzip+0x374/0x428
<4>[    0.136127]  [<c098147b>] unpack_to_rootfs+0x29f/0x3aa
<4>[    0.136132]  [<c0981ef9>] populate_rootfs+0x59/0x87
<4>[    0.136137]  [<c097fcd3>] start_kernel+0x38d/0x3ae
<4>[    0.136143]  [<c097f087>] i386_start_kernel+0x87/0x9f
<6>[    0.141362] Freeing initrd memory: 7731k freed
<6>[    0.143213] ACPI: Core revision 20090521
<3>[    0.148749] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.148753] Modules linked in:
<4>[    0.148757] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.148761] Call Trace:
<4>[    0.148773]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.148780]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.148785]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.148791]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.148797]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.148803]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.148809]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.148814]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.148819]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.148826]  [<c048c574>] acpi_ps_complete_op+0x229/0x249
<4>[    0.148833]  [<c048c9bb>] acpi_ps_parse_loop+0x2e4/0x331
<4>[    0.148839]  [<c048b9d8>] acpi_ps_parse_aml+0xdd/0x33e
<4>[    0.148845]  [<c048a890>] acpi_ns_one_complete_parse+0x11c/0x149
<4>[    0.148851]  [<c048a8ff>] acpi_ns_parse_table+0x42/0x8f
<4>[    0.148857]  [<c0487059>] acpi_ns_load_table+0x69/0xf8
<4>[    0.148863]  [<c048ef1c>] acpi_tb_load_namespace+0x6e/0x136
<4>[    0.148869]  [<c048effa>] acpi_load_tables+0x16/0x4b
<4>[    0.148875]  [<c09abfe7>] acpi_early_init+0x7e/0x11d
<4>[    0.148881]  [<c097fcd8>] start_kernel+0x392/0x3ae
<4>[    0.148887]  [<c097f087>] i386_start_kernel+0x87/0x9f
<3>[    0.149006] BUG: scheduling while atomic: swapper/0/0x10000002
<4>[    0.149010] Modules linked in:
<4>[    0.149014] Pid: 0, comm: swapper Not tainted 2.6.31.8-0.1-
desktop #1
<4>[    0.149017] Call Trace:
<4>[    0.149023]  [<c020845a>] try_stack_unwind+0x17a/0x1a0
<4>[    0.149028]  [<c020708c>] dump_trace+0x6c/0x130
<4>[    0.149034]  [<c0208008>] show_trace_log_lvl+0x58/0x80
<4>[    0.149039]  [<c0208056>] show_trace+0x26/0x40
<4>[    0.149044]  [<c0692e53>] dump_stack+0x79/0x91
<4>[    0.149049]  [<c023f137>] __schedule_bug+0x87/0x90
<4>[    0.149054]  [<c0693b88>] schedule+0x688/0x7a0
<4>[    0.149060]  [<c02480eb>] __cond_resched+0x2b/0x60
<4>[    0.149065]  [<c0693dfd>] _cond_resched+0x3d/0x50
<4>[    0.149070]  [<c048c574>] acpi_ps_complete_op+0x229/0x249
<4>[    0.149076]  [<c048c9bb>] acpi_ps_parse_loop+0x2e4/0x331
<4>[    0.149083]  [<c048b9d8>] acpi_ps_parse_aml+0xdd/0x33e
<4>[    0.149088]  [<c048a890>] acpi_ns_one_complete_parse+0x11c/0x149
<4>[    0.149095]  [<c048a8ff>] acpi_ns_parse_table+0x42/0x8f
<4>[    0.149100]  [<c0487059>] acpi_ns_load_table+0x69/0xf8
<4>[    0.149105]  [<c048ef1c>] acpi_tb_load_namespace+0x6e/0x136
<4>[    0.149111]  [<c048effa>] acpi_load_tables+0x16/0x4b
<4>[    0.149116]  [<c09abfe7>] acpi_early_init+0x7e/0x11d
<4>[    0.149121]  [<c097fcd8>] start_kernel+0x392/0x3ae
<4>[    0.149126]  [<c097f087>] i386_start_kernel+0x87/0x9f
<6>[    0.153296] Mapping cpu 0 to node 0
<6>[    0.154164] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.164172] CPU0: AMD Athlon(tm) II X2 240 Processor stepping 02
<6>[    0.164974] Booting processor 1 APIC 0x1 ip 0x6000
<6>[    0.000999] Initializing CPU#1
<6>[    0.000999] Mapping cpu 1 to node 0
<6>[    0.000999] Calibrating delay using timer specific routine.. 
5625.44 BogoMIPS (lpj=2812722)
<6>[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
<6>[    0.000999] CPU: L2 Cache: 1024K (64 bytes/line)
<6>[    0.000999] CPU: Physical Processor ID: 0
<6>[    0.000999] CPU: Processor Core ID: 1
<6>[    0.000999] mce: CPU supports 6 MCE banks
<6>[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106
<6>[    0.235481] CPU1: AMD Athlon(tm) II X2 240 Processor stepping 02
<6>[    0.235508] checking TSC synchronization [CPU#0 -> CPU#1]: 
passed.
<6>[    0.235983] Brought up 2 CPUs
<6>[    0.235991] Total of 2 processors activated (11250.77 BogoMIPS).
<7>[    0.236113] CPU0 attaching sched-domain:
<7>[    0.236115]  domain 0: span 0-1 level MC
<7>[    0.236117]   groups: 0 1
<7>[    0.236121]   domain 1: span 0-1 level NODE
<7>[    0.236123]    groups: 0-1
<7>[    0.236126] CPU1 attaching sched-domain:
<7>[    0.236128]  domain 0: span 0-1 level MC
<7>[    0.236130]   groups: 1 0
<7>[    0.236132]   domain 1: span 0-1 level NODE
<7>[    0.236134]    groups: 0-1
<6>[    0.238031] devtmpfs: initialized
<6>[    0.238131] Booting paravirtualized kernel on bare hardware
<6>[    0.238131] regulator: core version 0.5
<4>[    0.238131] Time: 20:18:12  Date: 01/23/10
[...]

Regards,
Ulrich Windl

