Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZJDINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZJDINs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZJDINr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 04:13:47 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:45323 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZJDINj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 04:13:39 -0400
Message-ID: <4AC85907.7080805@pardus.org.tr>
Date: Sun, 04 Oct 2009 11:12:55 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com, dri-devel@lists.sf.net
Subject: NULL pointer dereference at cfq_exit_single_io_context
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The attached dmesg is obtained on a 2.6.30.8 with:

- DRM patches mainly gathered from Fedora F-11 branch,
- The following patch from mainline which addresses kernel bugzilla #13401:

From: Jeff Moyer <jmoyer@redhat.com>
Date: Fri, 11 Sep 2009 15:08:59 +0000 (+0200)
Subject: cfq: choose a new next_req when a request is dispatched
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=06d2188644c85c56d243efab914f368d1d23c4a3


The user which sent me the dmesg below tells that consecutive attempts to boot into X with the *nouveau* driver is generally not possible because of random lockups.

I'll have access to the machine in this week so I can try anything you want me to do.

Thanks,
Ozan Caglayan

----

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30.8-127 (pardus@buildfarm) (gcc version 4.3.3 (Pardus Linux) ) #1 SMP Thu Oct 1 13:55:08 EEST 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
[    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff7e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff70 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 120000000 mask FF0000000 write-back
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009e800 (usable)
[    0.000000]  modified: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cff70000 (usable)
[    0.000000]  modified: 00000000cff70000 - 00000000cff7e000 (ACPI data)
[    0.000000]  modified: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  modified: 00000000cffd0000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] RAMDISK: 37b35000 - 37fefb72
[    0.000000] Allocated new RAMDISK: 0070b000 - 00bc5b72
[    0.000000] Move RAMDISK from 0000000037b35000 - 0000000037fefb71 to 0070b000 - 00bc5b71
[    0.000000] ACPI: RSDP 000fb2c0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT cff70000 0003C (v01 A_M_I_ OEMRSDT  08000820 MSFT 00000097)
[    0.000000] ACPI: FACP cff70200 00084 (v02 A_M_I_ OEMFACP  08000820 MSFT 00000097)
[    0.000000] ACPI: DSDT cff70440 0907C (v01  A0985 A0985001 00000001 INTL 20051117)
[    0.000000] ACPI: FACS cff7e000 00040
[    0.000000] ACPI: APIC cff70390 0006C (v01 A_M_I_ OEMAPIC  08000820 MSFT 00000097)
[    0.000000] ACPI: MCFG cff70400 0003C (v01 A_M_I_ OEMMCFG  08000820 MSFT 00000097)
[    0.000000] ACPI: OEMB cff7e040 00081 (v01 A_M_I_ AMI_OEM  08000820 MSFT 00000097)
[    0.000000] ACPI: HPET cff794c0 00038 (v01 A_M_I_ OEMHPET  08000820 MSFT 00000097)
[    0.000000] ACPI: OSFR cff79500 000B0 (v01 A_M_I_ OEMOSFR  08000820 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2439MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00011000 - 00017f00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000706fc4]    TEXT DATA BSS ==> [0000100000 - 0000706fc4]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==> [000009e800 - 0000100000]
[    0.000000]   #5 [0000707000 - 000070a214]              BRK ==> [0000707000 - 000070a214]
[    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #7 [000070b000 - 0000bc5b72]      NEW RAMDISK ==> [000070b000 - 0000bc5b72]
[    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000cff70
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cff70
[    0.000000] On node 0 totalpages: 851710
[    0.000000] free_area_init_node: node 0, pgdat c059d6a0, node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4879 pages used for memmap
[    0.000000]   HighMem zone: 619619 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c2a10000, static data 26972 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 845055
[    0.000000] Kernel command line: root=LABEL=PARDUS_ROOT1 splash=silent quiet vga=0x317
[    0.000000] bootsplash: silent mode.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] NR_IRQS:1280
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2497.515 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] allocated 17036160 bytes of page_cgroup
[    0.000999] please try cgroup_disable=memory option if you don't want
[    0.000999] Initializing HighMem for node 0 (000377fe:000cff70)
[    0.000999] Memory: 3350616k/3407296k available (3090k kernel code, 55372k reserved, 1848k data, 448k init, 2497992k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc05db000 - 0xc064b000   ( 448 kB)
[    0.000999]       .data : 0xc04048a3 - 0xc05d2c6c   (1848 kB)
[    0.000999]       .text : 0xc0100000 - 0xc04048a3   (3090 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4995.03 BogoMIPS (lpj=2497515)
[    0.000999] Security Framework initialized
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] Initializing cgroup subsys ns
[    0.000999] Initializing cgroup subsys cpuacct
[    0.000999] Initializing cgroup subsys memory
[    0.000999] Initializing cgroup subsys devices
[    0.000999] Initializing cgroup subsys freezer
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#0.
[    0.000999] using mwait in idle threads.
[    0.000999] Checking 'hlt' instruction... OK.
[    0.005032] ACPI: Core revision 20090320
[    0.016406] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026955] CPU0: Intel(R) Core(TM)2 Quad CPU    Q8300  @ 2.50GHz stepping 0a
[    0.026995] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4994.91 BogoMIPS (lpj=2497455)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.098362] CPU1: Intel(R) Core(TM)2 Quad CPU    Q8300  @ 2.50GHz stepping 0a
[    0.098374] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.099099] Booting processor 2 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4994.92 BogoMIPS (lpj=2497464)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#2.
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.171348] CPU2: Intel(R) Core(TM)2 Quad CPU    Q8300  @ 2.50GHz stepping 0a
[    0.171360] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.172077] Booting processor 3 APIC 0x3 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 4994.93 BogoMIPS (lpj=2497465)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 3
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#3.
[    0.000999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.244397] CPU3: Intel(R) Core(TM)2 Quad CPU    Q8300  @ 2.50GHz stepping 0a
[    0.244409] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.244998] Brought up 4 CPUs
[    0.245001] Total of 4 processors activated (19979.79 BogoMIPS).
[    0.245051] CPU0 attaching sched-domain:
[    0.245053]  domain 0: span 0-1 level MC
[    0.245055]   groups: 0 1
[    0.245059]   domain 1: span 0-3 level CPU
[    0.245061]    groups: 0-1 2-3
[    0.245064] CPU1 attaching sched-domain:
[    0.245066]  domain 0: span 0-1 level MC
[    0.245068]   groups: 1 0
[    0.245071]   domain 1: span 0-3 level CPU
[    0.245072]    groups: 0-1 2-3
[    0.245075] CPU2 attaching sched-domain:
[    0.245077]  domain 0: span 2-3 level MC
[    0.245079]   groups: 2 3
[    0.245082]   domain 1: span 0-3 level CPU
[    0.245083]    groups: 2-3 0-1
[    0.245087] CPU3 attaching sched-domain:
[    0.245088]  domain 0: span 2-3 level MC
[    0.245090]   groups: 3 2
[    0.245093]   domain 1: span 0-3 level CPU
[    0.245094]    groups: 2-3 0-1
[    0.245190] net_namespace: 1088 bytes
[    0.246002] Booting paravirtualized kernel on bare hardware
[    0.246127] regulator: core version 0.5
[    0.246127] NET: Registered protocol family 16
[    0.246135] EISA bus registered
[    0.246145] ACPI: bus type pci registered
[    0.246199] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.246201] PCI: Not using MMCONFIG.
[    0.246263] PCI: BIOS BUG #0[00000031] found
[    0.246267] PCI: Using configuration type 1 for base access
[    0.247076] bio: create slab <bio-0> at 0
[    0.248060] ACPI: EC: Look up EC in DSDT
[    0.259905] ACPI: Interpreter enabled
[    0.259915] ACPI: (supports S0 S1 S3 S4 S5)
[    0.259934] ACPI: Using IOAPIC for interrupt routing
[    0.259982] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.262532] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.262534] PCI: Using MMCONFIG for extended config space
[    0.269218] ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 24, should be 23 [20090320]
[    0.269340] ACPI: No dock devices found.
[    0.269394] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.269486] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.269488] pci 0000:00:01.0: PME# disabled
[    0.269545] pci 0000:00:1a.0: reg 20 io port: [0xb800-0xb81f]
[    0.269603] pci 0000:00:1a.1: reg 20 io port: [0xb880-0xb89f]
[    0.269659] pci 0000:00:1a.2: reg 20 io port: [0xbc00-0xbc1f]
[    0.269720] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf9fffc00-0xf9ffffff]
[    0.269766] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.269769] pci 0000:00:1a.7: PME# disabled
[    0.269803] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf9ff8000-0xf9ffbfff]
[    0.269837] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.269840] pci 0000:00:1b.0: PME# disabled
[    0.269886] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.269889] pci 0000:00:1c.0: PME# disabled
[    0.269938] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.269941] pci 0000:00:1c.4: PME# disabled
[    0.269991] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.269994] pci 0000:00:1c.5: PME# disabled
[    0.270037] pci 0000:00:1d.0: reg 20 io port: [0xb080-0xb09f]
[    0.270095] pci 0000:00:1d.1: reg 20 io port: [0xb400-0xb41f]
[    0.270152] pci 0000:00:1d.2: reg 20 io port: [0xb480-0xb49f]
[    0.270212] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf9fff800-0xf9fffbff]
[    0.270258] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.270262] pci 0000:00:1d.7: PME# disabled
[    0.270419] pci 0000:00:1f.2: reg 10 io port: [0xac00-0xac07]
[    0.270424] pci 0000:00:1f.2: reg 14 io port: [0xa880-0xa883]
[    0.270429] pci 0000:00:1f.2: reg 18 io port: [0xa800-0xa807]
[    0.270434] pci 0000:00:1f.2: reg 1c io port: [0xa480-0xa483]
[    0.270439] pci 0000:00:1f.2: reg 20 io port: [0xa400-0xa41f]
[    0.270443] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf9ffe800-0xf9ffefff]
[    0.270479] pci 0000:00:1f.2: PME# supported from D3hot
[    0.270482] pci 0000:00:1f.2: PME# disabled
[    0.270505] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf9fff400-0xf9fff4ff]
[    0.270516] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.270554] pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
[    0.270562] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.270569] pci 0000:01:00.0: reg 1c 64bit mmio: [0xfa000000-0xfbffffff]
[    0.270574] pci 0000:01:00.0: reg 24 io port: [0xcc00-0xcc7f]
[    0.270579] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe980000-0xfe9fffff]
[    0.270682] pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
[    0.270685] pci 0000:00:01.0: bridge 32bit mmio: [0xfa000000-0xfe9fffff]
[    0.270688] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.270725] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8f00000-0xf8ffffff]
[    0.270765] pci 0000:03:00.0: reg 10 io port: [0xec00-0xec07]
[    0.270772] pci 0000:03:00.0: reg 14 io port: [0xe880-0xe883]
[    0.270779] pci 0000:03:00.0: reg 18 io port: [0xe800-0xe807]
[    0.270786] pci 0000:03:00.0: reg 1c io port: [0xe480-0xe483]
[    0.270793] pci 0000:03:00.0: reg 20 io port: [0xe400-0xe40f]
[    0.270800] pci 0000:03:00.0: reg 24 32bit mmio: [0xfebffc00-0xfebffdff]
[    0.270836] pci 0000:03:00.0: supports D1
[    0.270838] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.270842] pci 0000:03:00.0: PME# disabled
[    0.270866] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.270931] pci 0000:00:1c.4: bridge io port: [0xe000-0xefff]
[    0.270935] pci 0000:00:1c.4: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.270986] pci 0000:02:00.0: reg 10 64bit mmio: [0xfeac0000-0xfeafffff]
[    0.270994] pci 0000:02:00.0: reg 18 io port: [0xdc00-0xdc7f]
[    0.271045] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.271050] pci 0000:02:00.0: PME# disabled
[    0.271075] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.271141] pci 0000:00:1c.5: bridge io port: [0xd000-0xdfff]
[    0.271145] pci 0000:00:1c.5: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.271188] pci 0000:00:1e.0: transparent bridge
[    0.271210] pci_bus 0000:00: on NUMA node 0
[    0.271215] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.271357] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.271410] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.271505] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.271555] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.271617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.286762] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.286869] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.286978] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.287085] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.287191] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.287297] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.287403] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.287514] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.287650] SCSI subsystem initialized
[    0.287680] usbcore: registered new interface driver usbfs
[    0.287680] usbcore: registered new interface driver hub
[    0.287680] usbcore: registered new device driver usb
[    0.287680] PCI: Using ACPI for IRQ routing
[    0.290970] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.290975] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.296960] pnp: PnP ACPI init
[    0.296967] ACPI: bus type pnp registered
[    0.299648] pnp: PnP ACPI: found 15 devices
[    0.299650] ACPI: ACPI bus type pnp unregistered
[    0.299652] PnPBIOS: Disabled by ACPI PNP
[    0.299659] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.299665] system 00:06: ioport range 0x290-0x29f has been reserved
[    0.299669] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.299672] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.299674] system 00:07: ioport range 0x500-0x57f has been reserved
[    0.299677] system 00:07: iomem range 0xfed08000-0xfed08fff has been reserved
[    0.299679] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.299682] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.299684] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.299689] system 00:0a: iomem range 0xffc00000-0xffefffff has been reserved
[    0.299693] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.299696] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.299700] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.299704] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.299707] system 00:0e: iomem range 0xc0000-0xcffff could not be reserved
[    0.299709] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.299712] system 00:0e: iomem range 0x100000-0xcfffffff could not be reserved
[    0.334514] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.334517] pci 0000:00:01.0:   IO window: 0xc000-0xcfff
[    0.334520] pci 0000:00:01.0:   MEM window: 0xfa000000-0xfe9fffff
[    0.334523] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.334526] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.334528] pci 0000:00:1c.0:   IO window: disabled
[    0.334532] pci 0000:00:1c.0:   MEM window: disabled
[    0.334536] pci 0000:00:1c.0:   PREFETCH window: 0x000000f8f00000-0x000000f8ffffff
[    0.334541] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    0.334543] pci 0000:00:1c.4:   IO window: 0xe000-0xefff
[    0.334547] pci 0000:00:1c.4:   MEM window: 0xfeb00000-0xfebfffff
[    0.334551] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.334556] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
[    0.334559] pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
[    0.334563] pci 0000:00:1c.5:   MEM window: 0xfea00000-0xfeafffff
[    0.334566] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.334571] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.334573] pci 0000:00:1e.0:   IO window: disabled
[    0.334577] pci 0000:00:1e.0:   MEM window: disabled
[    0.334580] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.334590] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.334593] pci 0000:00:01.0: setting latency timer to 64
[    0.334599] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.334603] pci 0000:00:1c.0: setting latency timer to 64
[    0.334608] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.334612] pci 0000:00:1c.4: setting latency timer to 64
[    0.334617] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.334620] pci 0000:00:1c.5: setting latency timer to 64
[    0.334625] pci 0000:00:1e.0: setting latency timer to 64
[    0.334629] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.334631] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.334633] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.334635] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfe9fffff]
[    0.334637] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.334640] pci_bus 0000:04: resource 2 pref mem [0xf8f00000-0xf8ffffff]
[    0.334642] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.334644] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.334646] pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
[    0.334648] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.334651] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.334653] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
[    0.334675] NET: Registered protocol family 2
[    0.343012] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.343242] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.343544] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.343679] TCP: Hash tables configured (established 131072 bind 65536)
[    0.343681] TCP reno registered
[    0.346028] NET: Registered protocol family 1
[    0.346076] Unpacking initramfs...
[    0.465843] Freeing initrd memory: 4842k freed
[    0.467823] cpu0(4) debug files 119
[    0.468198] cpu1(4) debug files 119
[    0.469104] cpu2(4) debug files 119
[    0.470017] cpu3(4) debug files 119
[    0.470020] Machine check exception polling timer started.
[    0.470029] cpufreq-nforce2: No nForce2 chipset.
[    0.470139] Scanning for low memory corruption every 60 seconds
[    0.470222] audit: initializing netlink socket (disabled)
[    0.470233] type=2000 audit(1254500969.469:1): initialized
[    0.477142] highmem bounce pool size: 64 pages
[    0.477146] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.478321] VFS: Disk quotas dquot_6.5.2
[    0.478374] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.478710] fuse init (API version 7.11)
[    0.479033] aufs 2-29
[    0.479037] msgmni has been set to 1676
[    0.479561] alg: No test for stdrng (krng)
[    0.479602] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.479605] io scheduler noop registered
[    0.479607] io scheduler anticipatory registered
[    0.479608] io scheduler deadline registered
[    0.479639] io scheduler cfq registered (default)
[    0.479759] pci 0000:01:00.0: Boot video device
[    0.479834] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.479897] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.479992] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.480071] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.480138] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.480884] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.481130] vesafb: framebuffer at 0xfb000000, mapped to 0xf8080000, using 6144k, total 14336k
[    0.481133] vesafb: mode is 1024x768x16, linelength=2048, pages=1
[    0.481134] vesafb: protected mode interface info at c000:c130
[    0.481136] vesafb: pmi: set display start = c00cc193, set palette = c00cc1ee
[    0.481138] vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
[    0.481146] vesafb: scrolling: redraw
[    0.481149] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.481371] bootsplash 3.1.6-2004/03/31: looking for picture...
[    0.489237] bootsplash: silentjpeg size 23442 bytes
[    0.496622] bootsplash: ...found (1024x768, 37132 bytes, v3).
[    0.500396] Switched to high resolution mode on CPU 1
[    0.500493] Switched to high resolution mode on CPU 2
[    0.500553] Switched to high resolution mode on CPU 3
[    0.500963] Switched to high resolution mode on CPU 0
[    0.523738] Console: switching to colour frame buffer device 128x45
[    0.561887] fb0: VESA VGA frame buffer device
[    0.561979] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.561981] ACPI: Power Button [PWRF]
[    0.562032] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.562034] ACPI: Power Button [PWRB]
[    0.562320] processor ACPI_CPU:00: registered as cooling_device0
[    0.562350] processor ACPI_CPU:01: registered as cooling_device1
[    0.562375] processor ACPI_CPU:02: registered as cooling_device2
[    0.562410] processor ACPI_CPU:03: registered as cooling_device3
[    0.564603] isapnp: Scanning for PnP cards...
[    0.876592] isapnp: No Plug & Play device found
[    0.877474] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.877556] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.877841] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.888032] floppy0: no floppy controllers found
[    3.888333] loop: module loaded
[    3.888363] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    3.888384] Driver 'sd' needs updating - please use bus_type methods
[    3.888391] Driver 'sr' needs updating - please use bus_type methods
[    3.888430] Fixed MDIO Bus: probed
[    3.888449] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.888468] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.888476] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.888479] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.888506] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    3.892404] ehci_hcd 0000:00:1a.7: debug port 1
[    3.892409] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.892421] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9fffc00
[    3.902007] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.902027] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.902030] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.902032] usb usb1: Product: EHCI Host Controller
[    3.902035] usb usb1: Manufacturer: Linux 2.6.30.8-127 ehci_hcd
[    3.902037] usb usb1: SerialNumber: 0000:00:1a.7
[    3.902079] usb usb1: configuration #1 chosen from 1 choice
[    3.902106] hub 1-0:1.0: USB hub found
[    3.902117] hub 1-0:1.0: 6 ports detected
[    3.902208] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.902215] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.902218] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.902233] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    3.906136] ehci_hcd 0000:00:1d.7: debug port 1
[    3.906141] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.906152] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fff800
[    3.916007] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.916020] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.916023] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.916025] usb usb2: Product: EHCI Host Controller
[    3.916028] usb usb2: Manufacturer: Linux 2.6.30.8-127 ehci_hcd
[    3.916030] usb usb2: SerialNumber: 0000:00:1d.7
[    3.916077] usb usb2: configuration #1 chosen from 1 choice
[    3.916104] hub 2-0:1.0: USB hub found
[    3.916109] hub 2-0:1.0: 6 ports detected
[    3.916197] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.916207] uhci_hcd: USB Universal Host Controller Interface driver
[    3.916236] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.916241] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.916243] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.916260] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.916286] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
[    3.916309] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.916311] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.916313] usb usb3: Product: UHCI Host Controller
[    3.916315] usb usb3: Manufacturer: Linux 2.6.30.8-127 uhci_hcd
[    3.916317] usb usb3: SerialNumber: 0000:00:1a.0
[    3.916351] usb usb3: configuration #1 chosen from 1 choice
[    3.916370] hub 3-0:1.0: USB hub found
[    3.916375] hub 3-0:1.0: 2 ports detected
[    3.916432] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.916437] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.916439] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.916458] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.916483] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
[    3.916506] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.916508] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.916510] usb usb4: Product: UHCI Host Controller
[    3.916512] usb usb4: Manufacturer: Linux 2.6.30.8-127 uhci_hcd
[    3.916514] usb usb4: SerialNumber: 0000:00:1a.1
[    3.916546] usb usb4: configuration #1 chosen from 1 choice
[    3.916565] hub 4-0:1.0: USB hub found
[    3.916570] hub 4-0:1.0: 2 ports detected
[    3.916628] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.916633] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.916635] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.916649] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.916670] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000bc00
[    3.916693] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.916695] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.916697] usb usb5: Product: UHCI Host Controller
[    3.916698] usb usb5: Manufacturer: Linux 2.6.30.8-127 uhci_hcd
[    3.916700] usb usb5: SerialNumber: 0000:00:1a.2
[    3.916731] usb usb5: configuration #1 chosen from 1 choice
[    3.916750] hub 5-0:1.0: USB hub found
[    3.916755] hub 5-0:1.0: 2 ports detected
[    3.916810] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.916815] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.916818] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.916834] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.916854] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
[    3.916876] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.916879] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.916880] usb usb6: Product: UHCI Host Controller
[    3.916882] usb usb6: Manufacturer: Linux 2.6.30.8-127 uhci_hcd
[    3.916884] usb usb6: SerialNumber: 0000:00:1d.0
[    3.916921] usb usb6: configuration #1 chosen from 1 choice
[    3.916943] hub 6-0:1.0: USB hub found
[    3.916947] hub 6-0:1.0: 2 ports detected
[    3.917021] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.917026] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.917028] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.917043] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.917069] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
[    3.917092] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.917094] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.917096] usb usb7: Product: UHCI Host Controller
[    3.917097] usb usb7: Manufacturer: Linux 2.6.30.8-127 uhci_hcd
[    3.917099] usb usb7: SerialNumber: 0000:00:1d.1
[    3.917133] usb usb7: configuration #1 chosen from 1 choice
[    3.917152] hub 7-0:1.0: USB hub found
[    3.917156] hub 7-0:1.0: 2 ports detected
[    3.917209] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.917214] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.917217] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.917233] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.917254] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
[    3.917276] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.917278] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.917280] usb usb8: Product: UHCI Host Controller
[    3.917282] usb usb8: Manufacturer: Linux 2.6.30.8-127 uhci_hcd
[    3.917284] usb usb8: SerialNumber: 0000:00:1d.2
[    3.917316] usb usb8: configuration #1 chosen from 1 choice
[    3.917335] hub 8-0:1.0: USB hub found
[    3.917341] hub 8-0:1.0: 2 ports detected
[    3.917436] PNP: No PS/2 controller found. Probing ports directly.
[    3.920130] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.920135] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.920187] mice: PS/2 mouse device common for all mice
[    3.920342] rtc_cmos 00:03: RTC can wake from S4
[    3.920363] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.920384] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.920411] EISA: Probing bus 0 at eisa.0
[    3.920433] EISA: Detected 0 cards.
[    3.920605] cpuidle: using governor ladder
[    3.920606] cpuidle: using governor menu
[    3.920807] usbcore: registered new interface driver hiddev
[    3.920818] usbcore: registered new interface driver usbhid
[    3.920820] usbhid: v2.6:USB HID core driver
[    3.921090] NET: Registered protocol family 17
[    3.921170] Using IPI No-Shortcut mode
[    3.921236] TuxOnIce 3.0.1 (http://tuxonice.net)
[    3.921276] TuxOnIce: Ignoring late initcall, as requested.
[    3.921285] registered taskstats version 1
[    3.921420] rtc_cmos 00:03: setting system clock to 2009-10-02 16:29:34 UTC (1254500974)
[    3.921492] Freeing unused kernel memory: 448k freed
[    3.921643] Write protecting the kernel text: 3092k
[    3.921678] Write protecting the kernel read-only data: 1444k
[    4.003609] libata version 3.00 loaded.
[    4.004916] pata_acpi 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.004940] pata_acpi 0000:03:00.0: setting latency timer to 64
[    4.004950] pata_acpi 0000:03:00.0: PCI INT A disabled
[    4.006706] pata_marvell 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.006728] pata_marvell 0000:03:00.0: setting latency timer to 64
[    4.006791] scsi0 : pata_marvell
[    4.006889] scsi1 : pata_marvell
[    4.006920] ata1: PATA max UDMA/100 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 16
[    4.006922] ata2: DUMMY
[    4.172431] ahci 0000:00:1f.2: version 3.0
[    4.172440] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.172480] ahci: SSS flag set, parallel bus scan disabled
[    4.172509] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.172512] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    4.172516] ahci 0000:00:1f.2: setting latency timer to 64
[    4.178052] scsi2 : ahci
[    4.178134] scsi3 : ahci
[    4.178206] scsi4 : ahci
[    4.178277] scsi5 : ahci
[    4.178347] scsi6 : ahci
[    4.178418] scsi7 : ahci
[    4.178526] ata3: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffe900 irq 19
[    4.178529] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
[    4.178532] ata5: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffea00 irq 19
[    4.178534] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
[    4.178537] ata7: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffeb00 irq 19
[    4.178539] ata8: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffeb80 irq 19
[    4.512016] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    4.636032] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.642350] ata3.00: ATA-7: SAMSUNG HD322HJ, 1AC01113, max UDMA7
[    4.642353] ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.648760] ata3.00: configured for UDMA/133
[    4.659101] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD322HJ  1AC0 PQ: 0 ANSI: 5
[    4.659229] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    4.659286] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    4.659298] sd 2:0:0:0: [sda] Write Protect is off
[    4.659300] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.659318] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.659392]  sda: sda1 sda2 < sda5 >
[    4.687088] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.882694] usb 5-2: New USB device found, idVendor=0a12, idProduct=0001
[    4.882697] usb 5-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    4.882701] usb 5-2: Product: BT2.0
[    4.882761] usb 5-2: configuration #1 chosen from 1 choice
[    5.091015] usb 7-1: new low speed USB device using uhci_hcd and address 2
[    5.254086] usb 7-1: New USB device found, idVendor=046d, idProduct=c044
[    5.254089] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.254093] usb 7-1: Product: USB-PS/2 Optical Mouse
[    5.254095] usb 7-1: Manufacturer: Logitech
[    5.254150] usb 7-1: configuration #1 chosen from 1 choice
[    5.271311] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/input/input3
[    5.271358] generic-usb 0003:046D:C044.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.1-1/input0
[    5.477015] usb 7-2: new low speed USB device using uhci_hcd and address 3
[    5.535259] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.535963] ata4.00: ATAPI: TSSTcorp CDDVDW SH-S223F, SB02, max UDMA/100, ATAPI AN
[    5.536899] ata4.00: configured for UDMA/100
[    5.548548] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223F  SB02 PQ: 0 ANSI: 5
[    5.551902] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.551905] Uniform CD-ROM driver Revision: 3.20
[    5.551962] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    5.552000] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    5.644085] usb 7-2: New USB device found, idVendor=046d, idProduct=c317
[    5.644088] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.644091] usb 7-2: Product: USB Multimedia Keyboard
[    5.644093] usb 7-2: Manufacturer: Logitech
[    5.644147] usb 7-2: configuration #1 chosen from 1 choice
[    5.662310] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input4
[    5.662346] generic-usb 0003:046D:C317.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1d.1-2/input0
[    5.702135] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.1/input/input5
[    5.702177] generic-usb 0003:046D:C317.0003: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1d.1-2/input1
[    5.857013] ata5: SATA link down (SStatus 0 SControl 300)
[    6.744017] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.763458] ata6.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
[    6.763461] ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.765466] ata6.00: configured for UDMA/133
[    6.776081] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[    6.776170] sd 5:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    6.776183] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    6.776198] sd 5:0:0:0: [sdb] Write Protect is off
[    6.776200] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.776217] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.776281]  sdb:
[    6.786469] sd 5:0:0:0: [sdb] Attached SCSI disk
[    7.081012] ata7: SATA link down (SStatus 0 SControl 300)
[    7.397011] ata8: SATA link down (SStatus 0 SControl 300)
[    7.579070] brd: module loaded
[    7.596502] EXT4-fs: INFO: recovery required on readonly filesystem.
[    7.596504] EXT4-fs: write access will be enabled during recovery.
[    7.599211] EXT4-fs: barriers enabled
[    7.653772] kjournald2 starting: pid 128, dev sda5:8, commit interval 5 seconds
[    7.653789] EXT4-fs: delayed allocation enabled
[    7.653792] EXT4-fs: file extents enabled
[    7.661963] EXT4-fs: mballoc enabled
[    7.661973] EXT4-fs: recovery complete.
[    7.662179] EXT4-fs: mounted filesystem sda5 with ordered data mode
[   10.306764] udev: starting version 146
[   11.208427] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   11.227612] iTCO_vendor_support: vendor-support=0
[   11.234497] Linux agpgart interface v0.103
[   11.236469] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   11.236542] iTCO_wdt: Found a ICH10 TCO device (Version=2, TCOBASE=0x0860)
[   11.236592] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   11.264999] ATL1E 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.265010] ATL1E 0000:02:00.0: setting latency timer to 64
[   11.401934] Bluetooth: Core ver 2.15
[   11.402056] NET: Registered protocol family 31
[   11.402058] Bluetooth: HCI device and connection manager initialized
[   11.402060] Bluetooth: HCI socket layer initialized
[   11.422645] [drm] Initialized drm 1.1.0 20060810
[   11.430581] Bluetooth: Generic Bluetooth USB driver ver 0.5
[   11.430642] usbcore: registered new interface driver btusb
[   12.039466] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.039471] pci 0000:01:00.0: setting latency timer to 64
[   12.040835] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x094100a1)
[   12.041765] [drm] Initialized nouveau 0.0.15 20090420 for 0000:01:00.0 on minor 0
[   12.079845] [drm] Module unloaded
[   12.171738] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   12.171770] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.269934] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[   12.830641] EXT4 FS on sda5, internal journal on sda5:8
[   13.027221] EXT3-fs: sda1: couldn't mount because of unsupported optional features (240).
[   13.075185] Adding 307192k swap on /.swap.  Priority:-1 extents:2 across:315384k 
[   15.360958] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   17.528516] NET: Registered protocol family 10
[   17.529056] lo: Disabled Privacy Extensions
[   17.537960] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.557879] platform microcode: firmware: requesting intel-ucode/06-17-0a
[   17.732262] platform microcode: firmware: requesting intel-ucode/06-17-0a
[   17.743675] platform microcode: firmware: requesting intel-ucode/06-17-0a
[   17.747550] platform microcode: firmware: requesting intel-ucode/06-17-0a
[   17.751242] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   17.845901] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   17.846028] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   17.846030] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   17.846032] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   20.546232] Bluetooth: L2CAP ver 2.13
[   20.546234] Bluetooth: L2CAP socket layer initialized
[   21.065742] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   21.065745] Bluetooth: BNEP filters: protocol multicast
[   21.286614] Bridge firewalling registered
[   21.357383] bootsplash: status on console 0 changed to on
[   21.361327] Bluetooth: SCO (Voice Link) ver 0.6
[   21.361329] Bluetooth: SCO socket layer initialized
[   21.489034] [drm] Initialized drm 1.1.0 20060810
[   21.715216] pci 0000:01:00.0: setting latency timer to 64
[   21.716458] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x094100a1)
[   21.717341] [drm] Initialized nouveau 0.0.15 20090420 for 0000:01:00.0 on minor 0
[   21.854327] [TTM] Zone  kernel: Available graphics memory: 429384 kiB.
[   21.854330] [TTM] Zone highmem: Available graphics memory: 1678380 kiB.
[   21.868745] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   21.868868] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[   21.877432] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[   21.998627] Bluetooth: RFCOMM socket layer initialized
[   21.998633] Bluetooth: RFCOMM TTY layer initialized
[   21.998635] Bluetooth: RFCOMM ver 1.11
[   22.291825] BUG: unable to handle kernel NULL pointer dereference at 00000006
[   22.291831] IP: [<c0285d57>] cfq_exit_single_io_context+0x11/0x43
[   22.291839] *pde = 00000000 
[   22.291842] Oops: 0000 [#1] SMP 
[   22.291845] last sysfs file: /sys/module/l2cap/initstate
[   22.291847] Modules linked in: rfcomm nouveau ttm drm_kms_helper drm i2c_algo_bit sco bridge stp bnep l2cap xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_raw iptable_filter microcode ip_tables ipv6 x_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm btusb bluetooth snd_timer snd intel_agp asus_atk0110 soundcore atl1e snd_page_alloc iTCO_wdt agpgart iTCO_vendor_support serio_raw pcspkr brd ata_generic ahci pata_marvell pata_acpi libata [last unloaded: i2c_algo_bit]
[   22.291888] 
[   22.291892] Pid: 519, comm: comar Not tainted (2.6.30.8-127 #1) P5Q SE
[   22.291894] EIP: 0060:[<c0285d57>] EFLAGS: 00010206 CPU: 3
[   22.291896] EIP is at cfq_exit_single_io_context+0x11/0x43
[   22.291898] EAX: f64babd0 EBX: 00000006 ECX: 00000000 EDX: f6be9720
[   22.291900] ESI: f6be9720 EDI: 00000001 EBP: f51a7f60 ESP: f51a7f50
[   22.291902]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   22.291905] Process comar (pid: 519, ti=f51a6000 task=f66ad710 task.ti=f51a6000)
[   22.291906] Stack:
[   22.291908]  f51a7f64 f6be9768 f64babd0 00000001 f51a7f70 c0285da7 f64babd0 f66ad710
[   22.291913]  f51a7f7c c027ea74 00000000 f51a7f90 c013459c f6444240 00000000 00000000
[   22.291917]  f51a7fa4 c013461b 00000000 00000000 b7d4325c f51a7fac c0134655 f51a6000
[   22.291922] Call Trace:
[   22.291924]  [<c0285da7>] ? cfq_exit_io_context+0x1e/0x26
[   22.291927]  [<c027ea74>] ? exit_io_context+0x5f/0x6b
[   22.291931]  [<c013459c>] ? do_exit+0x243/0x261
[   22.291935]  [<c013461b>] ? do_group_exit+0x61/0x88
[   22.291938]  [<c0134655>] ? sys_exit_group+0x13/0x17
[   22.291941]  [<c01031d4>] ? sysenter_do_call+0x12/0x28
[   22.291945] Code: 8b 53 0c 85 d2 74 0e 89 f8 e8 7b ff ff ff c7 43 0c 00 00 00 00 5b 5e 5f 5d c3 55 89 e5 57 56 89 d6 53 83 ec 04 8b 1a 85 db 74 2c <8b> 3b 8b 87 60 01 00 00 e8 20 ad 17 00 83 3e 00 89 45 f0 74 09 
[   22.291971] EIP: [<c0285d57>] cfq_exit_single_io_context+0x11/0x43 SS:ESP 0068:f51a7f50
[   22.291975] CR2: 0000000000000006
[   22.291977] ---[ end trace c1e7e9f7506f391b ]---
[   22.291979] Fixing recursive fault but reboot is needed!
[   22.422731] [drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[   22.429622] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
[   27.895006] eth0: no IPv6 routers present
[   28.382459] [drm] nouveau 0000:01:00.0: PGRAPH_ERROR - nSource: PROTECTION_ERROR DMA_R_PROTECTION, nStatus:
[   28.382468] [drm] nouveau 0000:01:00.0: PGRAPH_ERROR - Ch 2/4 Class 0x8297 Mthd 0x15e0 Data 0x00000000:0x00000000
[   28.382470] [drm] nouveau 0000:01:00.0: magic set 1:
[   28.382472] [drm] nouveau 0000:01:00.0: 	0x00408900: 0x80000000
[   28.382475] [drm] nouveau 0000:01:00.0: 	0x00408904: 0xfcfe7e6f
[   28.382477] [drm] nouveau 0000:01:00.0: 	0x00408908: 0xfd9f7ffb
[   28.382480] [drm] nouveau 0000:01:00.0: 	0x0040890c: 0xc000fdbd
[   28.382482] [drm] nouveau 0000:01:00.0: 	0x00408910: 0xd3be356b
[   28.382485] [drm] nouveau 0000:01:00.0: 	0x00408e08: 0x80000000
[   28.382487] [drm] nouveau 0000:01:00.0: 	0x00408e0c: 0x00000000
[   28.382490] [drm] nouveau 0000:01:00.0: 	0x00408e10: 0x00000000
[   28.382492] [drm] nouveau 0000:01:00.0: 	0x00408e14: 0x00000000
[   28.382494] [drm] nouveau 0000:01:00.0: 	0x00408e18: 0x00000000
[   28.382496] [drm] nouveau 0000:01:00.0: 	0x00408e1c: 0x00000000
[   28.382499] [drm] nouveau 0000:01:00.0: 	0x00408e20: 0x00000000
[   28.382501] [drm] nouveau 0000:01:00.0: 	0x00408e24: 0x00000000
[   28.382503] [drm] nouveau 0000:01:00.0: magic set 2:
[   28.382505] [drm] nouveau 0000:01:00.0: 	0x00409900: 0x80000000
[   28.382508] [drm] nouveau 0000:01:00.0: 	0x00409904: 0xfebf6f0f
[   28.382510] [drm] nouveau 0000:01:00.0: 	0x00409908: 0xdffee7df
[   28.382512] [drm] nouveau 0000:01:00.0: 	0x0040990c: 0xc00016d8
[   28.382515] [drm] nouveau 0000:01:00.0: 	0x00409910: 0x759f36eb
[   28.382518] [drm] nouveau 0000:01:00.0: 	0x00409e08: 0x80000000
[   28.382520] [drm] nouveau 0000:01:00.0: 	0x00409e0c: 0x00000000
[   28.382522] [drm] nouveau 0000:01:00.0: 	0x00409e10: 0x00000000
[   28.382525] [drm] nouveau 0000:01:00.0: 	0x00409e14: 0x00000000
[   28.382527] [drm] nouveau 0000:01:00.0: 	0x00409e18: 0x00000000
[   28.382529] [drm] nouveau 0000:01:00.0: 	0x00409e1c: 0x00000000
[   28.382531] [drm] nouveau 0000:01:00.0: 	0x00409e20: 0x00000000
[   28.382534] [drm] nouveau 0000:01:00.0: 	0x00409e24: 0x00000000


