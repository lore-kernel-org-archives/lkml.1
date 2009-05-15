Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbZEORlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbZEORlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZEORlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:41:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbZEORlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:41:05 -0400
Date: Fri, 15 May 2009 19:40:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
       a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 2.6.30_rc5] Null pointer dereference in rtc-cmos driver
Message-ID: <20090515174056.GD29647@elte.hu>
References: <4A0C43C3.9090404@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A0C43C3.9090404@pardus.org.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:s added)

* Ozan Çağlayan <ozan@pardus.org.tr> wrote:

> Hi,
> 
> I don't know if the following scenario should be handled by kernel but
> here's the steps to reproduce the problem:
> 
> 1. Make rtc-cmos module built-in, compile the kernel and install it onto
> system,
> 2. Keep the rtc-cmos.ko which is ABI compatible with the current kernel
> in /lib/modules/* so that it could be probed by udev,
> 3. Reboot the system. Kernel synchronizes the system clock from hardware
> clock as it could access /dev/rtc0,
> 4. Udev (141) starts, the default rule for rtc* is processed which then
> tries to modprobe rtc-cmos.ko which is still available in /lib/modules,
> 5. rtc-cmos.ko ooopses, the keyboard is dead, etc.
> 
> dmesg output is attached.
> 
> Thanks,
> Ozan Caglayan
> 

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.30_rc5-116 (pardus@buildfarm) (gcc version 4.3.3 (Pardus Linux) ) #1 SMP Thu May 14 00:01:55 EEST 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000006fee0000 (usable)
> [    0.000000]  BIOS-e820: 000000006fee0000 - 000000006fee3000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000006fee3000 - 000000006fef0000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000006fef0000 - 000000006ff00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] DMI 2.5 present.
> [    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0x6fee0 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-C7FFF write-protect
> [    0.000000]   C8000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask FFC0000000 write-back
> [    0.000000]   1 base 0040000000 mask FFE0000000 write-back
> [    0.000000]   2 base 0060000000 mask FFF0000000 write-back
> [    0.000000]   3 base 006FF00000 mask FFFFF00000 uncachable
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scanning 0 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009f400 (usable)
> [    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 000000006fee0000 (usable)
> [    0.000000]  modified: 000000006fee0000 - 000000006fee3000 (ACPI NVS)
> [    0.000000]  modified: 000000006fee3000 - 000000006fef0000 (ACPI data)
> [    0.000000]  modified: 000000006fef0000 - 000000006ff00000 (reserved)
> [    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
> [    0.000000]  0000000000 - 0000400000 page 4k
> [    0.000000]  0000400000 - 0037400000 page 2M
> [    0.000000]  0037400000 - 00377fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
> [    0.000000] RAMDISK: 37b3e000 - 37fef75a
> [    0.000000] Allocated new RAMDISK: 006ad000 - 00b5e75a
> [    0.000000] Move RAMDISK from 0000000037b3e000 - 0000000037fef759 to 006ad000 - 00b5e759
> [    0.000000] ACPI: RSDP 000f7cd0 00024 (v02 RS690 )
> [    0.000000] ACPI: XSDT 6fee3080 00044 (v01 RS690  AWRDACPI 42302E31 AWRD 00000000)
> [    0.000000] ACPI: FACP 6fee7b40 000F4 (v03 RS690  AWRDACPI 42302E31 AWRD 00000000)
> [    0.000000] ACPI: DSDT 6fee3200 04915 (v01 RS690  AWRDACPI 00001000 MSFT 03000000)
> [    0.000000] ACPI: FACS 6fee0000 00040
> [    0.000000] ACPI: HPET 6fee7cc0 00038 (v01 RS690  AWRDACPI 42302E31 AWRD 00000098)
> [    0.000000] ACPI: MCFG 6fee7d00 0003C (v01 RS690  AWRDACPI 42302E31 AWRD 00000000)
> [    0.000000] ACPI: APIC 6fee7c40 00068 (v01 RS690  AWRDACPI 42302E31 AWRD 00000000)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 902MB HIGHMEM available.
> [    0.000000] 887MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 377fe000
> [    0.000000]   low ram: 0 - 377fe000
> [    0.000000]   node 0 low ram: 00000000 - 377fe000
> [    0.000000]   node 0 bootmap 00011000 - 00017f00
> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
> [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
> [    0.000000]   #3 [0000100000 - 00006a8e04]    TEXT DATA BSS ==> [0000100000 - 00006a8e04]
> [    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
> [    0.000000]   #5 [00006a9000 - 00006ac0c2]              BRK ==> [00006a9000 - 00006ac0c2]
> [    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
> [    0.000000]   #7 [00006ad000 - 0000b5e75a]      NEW RAMDISK ==> [00006ad000 - 0000b5e75a]
> [    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
> [    0.000000] found SMP MP-table at [c00f3b80] f3b80
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000377fe
> [    0.000000]   HighMem  0x000377fe -> 0x0006fee0
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0006fee0
> [    0.000000] On node 0 totalpages: 458351
> [    0.000000] free_area_init_node: node 0, pgdat c05570e0, node_mem_map c1000200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1744 pages used for memmap
> [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 1806 pages used for memmap
> [    0.000000]   HighMem zone: 229332 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] ACPI: PM-Timer IO Port: 0x4008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 70000000 (gap: 6ff00000:70100000)
> [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 12 pages at c1e07000, static data 26940 bytes
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 454769
> [    0.000000] Kernel command line: root=LABEL=PARDUS_ROOT1 vga=791 splash=verbose mudur=debug
> [    0.000000] bootsplash: verbose mode.
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] NR_IRQS:1280
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2510.786 MHz processor.
> [    0.000999] Console: colour dummy device 80x25
> [    0.000999] console [tty0] enabled
> [    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000999] allocated 9168960 bytes of page_cgroup
> [    0.000999] please try cgroup_disable=memory option if you don't want
> [    0.000999] Initializing HighMem for node 0 (000377fe:0006fee0)
> [    0.000999] Memory: 1797692k/1833856k available (2943k kernel code, 34856k reserved, 1711k data, 372k init, 924552k highmem)
> [    0.000999] virtual kernel memory layout:
> [    0.000999]     fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
> [    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
> [    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
> [    0.000999]       .init : 0xc0592000 - 0xc05ef000   ( 372 kB)
> [    0.000999]       .data : 0xc03dfcff - 0xc058bc8c   (1711 kB)
> [    0.000999]       .text : 0xc0100000 - 0xc03dfcff   (2943 kB)
> [    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000999] hpet clockevent registered
> [    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.001008] Calibrating delay loop (skipped), value calculated using timer frequency.. 5021.57 BogoMIPS (lpj=2510786)
> [    0.001034] Security Framework initialized
> [    0.001044] Mount-cache hash table entries: 512
> [    0.001156] Initializing cgroup subsys ns
> [    0.001162] Initializing cgroup subsys cpuacct
> [    0.001167] Initializing cgroup subsys memory
> [    0.001174] Initializing cgroup subsys devices
> [    0.001178] Initializing cgroup subsys freezer
> [    0.001193] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.001197] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.001200] CPU: Physical Processor ID: 0
> [    0.001203] CPU: Processor Core ID: 0
> [    0.001208] Intel machine check architecture supported.
> [    0.001213] Intel machine check reporting enabled on CPU#0.
> [    0.001217] using C1E aware idle routine
> [    0.001225] Checking 'hlt' instruction... OK.
> [    0.006670] ACPI: Core revision 20090320
> [    0.016135] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.026142] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ stepping 02
> [    0.026995] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.000999] Initializing CPU#1
> [    0.000999] Calibrating delay using timer specific routine.. 5022.47 BogoMIPS (lpj=2511239)
> [    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.000999] CPU: Physical Processor ID: 0
> [    0.000999] CPU: Processor Core ID: 1
> [    0.000999] Intel machine check architecture supported.
> [    0.000999] Intel machine check reporting enabled on CPU#1.
> [    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [    0.097473] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ stepping 02
> [    0.097598] Brought up 2 CPUs
> [    0.097602] Total of 2 processors activated (10044.05 BogoMIPS).
> [    0.097707] CPU0 attaching sched-domain:
> [    0.097709]  domain 0: span 0-1 level CPU
> [    0.097712]   groups: 0 1
> [    0.097716] CPU1 attaching sched-domain:
> [    0.097718]  domain 0: span 0-1 level CPU
> [    0.097720]   groups: 1 0
> [    0.097774] net_namespace: 1088 bytes
> [    0.097993] Booting paravirtualized kernel on bare hardware
> [    0.098138] regulator: core version 0.5
> [    0.098138] NET: Registered protocol family 16
> [    0.098147] ACPI: bus type pci registered
> [    0.098216] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.098221] PCI: MCFG area at e0000000 reserved in E820
> [    0.098225] PCI: Using MMCONFIG for extended config space
> [    0.098229] PCI: Using configuration type 1 for base access
> [    0.098768] bio: create slab <bio-0> at 0
> [    0.099418] ACPI: EC: Look up EC in DSDT
> [    0.105117] ACPI: Interpreter enabled
> [    0.105129] ACPI: (supports S0 S1 S4 S5)
> [    0.105156] ACPI: Using IOAPIC for interrupt routing
> [    0.109308] ACPI: No dock devices found.
> [    0.109319] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.109405] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
> [    0.109411] pci 0000:00:04.0: PME# disabled
> [    0.109469] pci 0000:00:12.0: reg 10 io port: [0xff00-0xff07]
> [    0.109476] pci 0000:00:12.0: reg 14 io port: [0xfe00-0xfe03]
> [    0.109483] pci 0000:00:12.0: reg 18 io port: [0xfd00-0xfd07]
> [    0.109490] pci 0000:00:12.0: reg 1c io port: [0xfc00-0xfc03]
> [    0.109497] pci 0000:00:12.0: reg 20 io port: [0xfb00-0xfb0f]
> [    0.109504] pci 0000:00:12.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
> [    0.109522] pci 0000:00:12.0: set SATA to AHCI mode
> [    0.109569] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
> [    0.109623] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
> [    0.109678] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe02c000-0xfe02cfff]
> [    0.109732] pci 0000:00:13.3: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
> [    0.109786] pci 0000:00:13.4: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
> [    0.109858] pci 0000:00:13.5: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
> [    0.109909] pci 0000:00:13.5: supports D1 D2
> [    0.109912] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
> [    0.109918] pci 0000:00:13.5: PME# disabled
> [    0.109963] pci 0000:00:14.0: reg 10 io port: [0xb00-0xb0f]
> [    0.109970] pci 0000:00:14.0: reg 14 32bit mmio: [0xfed00000-0xfed003ff]
> [    0.110046] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
> [    0.110053] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
> [    0.110060] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
> [    0.110067] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
> [    0.110073] pci 0000:00:14.1: reg 20 io port: [0xf900-0xf90f]
> [    0.110146] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
> [    0.110193] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
> [    0.110200] pci 0000:00:14.2: PME# disabled
> [    0.110372] pci 0000:01:05.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
> [    0.110377] pci 0000:01:05.0: reg 18 64bit mmio: [0xfdfe0000-0xfdfeffff]
> [    0.110381] pci 0000:01:05.0: reg 20 io port: [0xde00-0xdeff]
> [    0.110385] pci 0000:01:05.0: reg 24 32bit mmio: [0xfde00000-0xfdefffff]
> [    0.110395] pci 0000:01:05.0: supports D1 D2
> [    0.110412] pci 0000:01:05.2: reg 10 64bit mmio: [0xfdffc000-0xfdffffff]
> [    0.110443] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
> [    0.110446] pci 0000:00:01.0: bridge 32bit mmio: [0xfde00000-0xfdffffff]
> [    0.110450] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
> [    0.110492] pci 0000:02:00.0: reg 10 io port: [0xee00-0xeeff]
> [    0.110509] pci 0000:02:00.0: reg 18 64bit mmio: [0xfddff000-0xfddfffff]
> [    0.110526] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> [    0.110562] pci 0000:02:00.0: supports D1 D2
> [    0.110564] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
> [    0.110570] pci 0000:02:00.0: PME# disabled
> [    0.110597] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.110686] pci 0000:00:04.0: bridge io port: [0xe000-0xefff]
> [    0.110689] pci 0000:00:04.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
> [    0.110693] pci 0000:00:04.0: bridge 64bit mmio pref: [0xfdc00000-0xfdcfffff]
> [    0.110750] pci 0000:00:14.4: transparent bridge
> [    0.110756] pci 0000:00:14.4: bridge io port: [0xc000-0xcfff]
> [    0.110761] pci 0000:00:14.4: bridge 32bit mmio: [0xfdb00000-0xfdbfffff]
> [    0.110765] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfda00000-0xfdafffff]
> [    0.110777] pci_bus 0000:00: on NUMA node 0
> [    0.110782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.110938] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
> [    0.111002] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
> [    0.111050] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> [    0.131899] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132003] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132101] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132198] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132294] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132391] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132488] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132585] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.132712] usbcore: registered new interface driver usbfs
> [    0.132712] usbcore: registered new interface driver hub
> [    0.132712] usbcore: registered new device driver usb
> [    0.132712] PCI: Using ACPI for IRQ routing
> [    0.135996] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.136004] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
> [    0.139990] Switched to high resolution mode on CPU 0
> [    0.140606] Switched to high resolution mode on CPU 1
> [    0.142013] pnp: PnP ACPI init
> [    0.142021] ACPI: bus type pnp registered
> [    0.144625] pnp 00:0c: mem resource (0xfed00000-0xfed000ff) overlaps 0000:00:14.0 BAR 1 (0xfed00000-0xfed003ff), disabling
> [    0.144670] pnp: PnP ACPI: found 13 devices
> [    0.144674] ACPI: ACPI bus type pnp unregistered
> [    0.144679] PnPBIOS: Disabled by ACPI PNP
> [    0.144688] system 00:01: ioport range 0x4100-0x411f has been reserved
> [    0.144693] system 00:01: ioport range 0x228-0x22f has been reserved
> [    0.144698] system 00:01: ioport range 0x40b-0x40b has been reserved
> [    0.144702] system 00:01: ioport range 0x4d6-0x4d6 has been reserved
> [    0.144707] system 00:01: ioport range 0xc00-0xc01 has been reserved
> [    0.144712] system 00:01: ioport range 0xc14-0xc14 has been reserved
> [    0.144716] system 00:01: ioport range 0xc50-0xc52 has been reserved
> [    0.144721] system 00:01: ioport range 0xc6c-0xc6d has been reserved
> [    0.144725] system 00:01: ioport range 0xc6f-0xc6f has been reserved
> [    0.144730] system 00:01: ioport range 0xcd0-0xcd1 has been reserved
> [    0.144734] system 00:01: ioport range 0xcd2-0xcd3 has been reserved
> [    0.144739] system 00:01: ioport range 0xcd4-0xcdf has been reserved
> [    0.144744] system 00:01: ioport range 0x4000-0x40fe has been reserved
> [    0.144748] system 00:01: ioport range 0x4210-0x4217 has been reserved
> [    0.144753] system 00:01: ioport range 0xb10-0xb1f has been reserved
> [    0.144761] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
> [    0.144766] system 00:07: ioport range 0x800-0x805 has been reserved
> [    0.144773] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
> [    0.144780] system 00:0c: iomem range 0xf0000-0xfffff could not be reserved
> [    0.144785] system 00:0c: iomem range 0x6ff00000-0x6fffffff has been reserved
> [    0.144790] system 00:0c: iomem range 0x6fee0000-0x6fefffff could not be reserved
> [    0.144796] system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
> [    0.144801] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
> [    0.144807] system 00:0c: iomem range 0x100000-0x6fedffff could not be reserved
> [    0.144813] system 00:0c: iomem range 0x70000000-0x7fffffff has been reserved
> [    0.144818] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
> [    0.144823] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
> [    0.144829] system 00:0c: iomem range 0xfff80000-0xfffeffff has been reserved
> [    0.179578] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [    0.179584] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
> [    0.179589] pci 0000:00:01.0:   MEM window: 0xfde00000-0xfdffffff
> [    0.179594] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
> [    0.179603] pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
> [    0.179607] pci 0000:00:04.0:   IO window: 0xe000-0xefff
> [    0.179612] pci 0000:00:04.0:   MEM window: 0xfdd00000-0xfddfffff
> [    0.179616] pci 0000:00:04.0:   PREFETCH window: 0x000000fdc00000-0x000000fdcfffff
> [    0.179623] pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
> [    0.179628] pci 0000:00:14.4:   IO window: 0xc000-0xcfff
> [    0.179636] pci 0000:00:14.4:   MEM window: 0xfdb00000-0xfdbfffff
> [    0.179642] pci 0000:00:14.4:   PREFETCH window: 0x000000fda00000-0x000000fdafffff
> [    0.179657] pci 0000:00:04.0: setting latency timer to 64
> [    0.179665] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.179667] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> [    0.179670] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
> [    0.179672] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdffffff]
> [    0.179675] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
> [    0.179677] pci_bus 0000:02: resource 0 io:  [0xe000-0xefff]
> [    0.179680] pci_bus 0000:02: resource 1 mem: [0xfdd00000-0xfddfffff]
> [    0.179682] pci_bus 0000:02: resource 2 pref mem [0xfdc00000-0xfdcfffff]
> [    0.179685] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
> [    0.179687] pci_bus 0000:03: resource 1 mem: [0xfdb00000-0xfdbfffff]
> [    0.179690] pci_bus 0000:03: resource 2 pref mem [0xfda00000-0xfdafffff]
> [    0.179692] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
> [    0.179695] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffff]
> [    0.179721] NET: Registered protocol family 2
> [    0.188061] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.188363] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.189080] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.189438] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.189443] TCP reno registered
> [    0.192098] NET: Registered protocol family 1
> [    0.192156] Unpacking initramfs...
> [    0.330093] Freeing initrd memory: 4805k freed
> [    0.333288] cpu0(2) debug files 130
> [    0.334039] cpu1(2) debug files 130
> [    0.334045] Machine check exception polling timer started.
> [    0.334058] cpufreq-nforce2: No nForce2 chipset.
> [    0.334155] Scanning for low memory corruption every 60 seconds
> [    0.334246] audit: initializing netlink socket (disabled)
> [    0.334260] type=2000 audit(1242304852.334:1): initialized
> [    0.340296] highmem bounce pool size: 64 pages
> [    0.340305] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    0.341438] VFS: Disk quotas dquot_6.5.2
> [    0.341488] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.341850] fuse init (API version 7.11)
> [    0.342109] aufs 2-29
> [    0.342115] msgmni has been set to 1716
> [    0.342446] alg: No test for stdrng (krng)
> [    0.342502] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.342511] io scheduler noop registered
> [    0.342514] io scheduler anticipatory registered
> [    0.342518] io scheduler deadline registered
> [    0.342553] io scheduler cfq registered (default)
> [    0.458065] pci 0000:01:05.0: Boot video device
> [    0.458166] pcieport-driver 0000:00:04.0: setting latency timer to 64
> [    0.458220] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.458245] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.458452] vesafb: framebuffer at 0xd0000000, mapped to 0xf8080000, using 6144k, total 16384k
> [    0.458458] vesafb: mode is 1024x768x16, linelength=2048, pages=9
> [    0.458462] vesafb: protected mode interface info at c000:a008
> [    0.458467] vesafb: pmi: set display start = c00ca092, set palette = c00ca150
> [    0.458471] vesafb: scrolling: redraw
> [    0.458475] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> [    0.459386] bootsplash 3.1.6-2004/03/31: looking for picture...
> [    0.476361] bootsplash: silentjpeg size 38809 bytes
> [    0.476371] bootsplash: ...found (1024x768, 133910 bytes, v3).
> [    0.493836] Console: switching to colour frame buffer device 128x45
> [    0.555024] fb0: VESA VGA frame buffer device
> [    0.555502] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    0.556116] ACPI: Power Button [PWRF]
> [    0.556479] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    0.557155] ACPI: Power Button [PWRB]
> [    0.557505] fan PNP0C0B:00: registered as cooling_device0
> [    0.557949] ACPI: Fan [FAN] (on)
> [    0.558453] processor ACPI_CPU:00: registered as cooling_device1
> [    0.558978] processor ACPI_CPU:01: registered as cooling_device2
> [    0.561646] thermal LNXTHERM:01: registered as thermal_zone0
> [    0.562124] ACPI: Thermal Zone [THRM] (40 C)
> [    0.562526] isapnp: Scanning for PnP cards...
> [    0.875607] isapnp: No Plug & Play device found
> [    0.876906] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.877535] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.878323] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.878925] Floppy drive(s): fd0 is 1.44M
> [    3.890050] floppy0: no floppy controllers found
> [    3.890735] loop: module loaded
> [    3.891055] input: Macintosh mouse button emulation as /devices/virtual/input/input2
> [    3.907509] Fixed MDIO Bus: probed
> [    3.923711] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.940186] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    3.956947] ehci_hcd 0000:00:13.5: EHCI Host Controller
> [    3.973705] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
> [    3.990678] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
> [    4.007625] ehci_hcd 0000:00:13.5: debug port 1
> [    4.024232] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
> [    4.046020] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
> [    4.062550] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.079544] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.096707] usb usb1: Product: EHCI Host Controller
> [    4.113773] usb usb1: Manufacturer: Linux 2.6.30_rc5-116 ehci_hcd
> [    4.130862] usb usb1: SerialNumber: 0000:00:13.5
> [    4.147742] usb usb1: configuration #1 chosen from 1 choice
> [    4.164426] hub 1-0:1.0: USB hub found
> [    4.180859] hub 1-0:1.0: 10 ports detected
> [    4.197261] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    4.213730] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    4.230298] ohci_hcd 0000:00:13.0: OHCI Host Controller
> [    4.246794] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
> [    4.263370] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
> [    4.334046] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.350758] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.367391] usb usb2: Product: OHCI Host Controller
> [    4.383865] usb usb2: Manufacturer: Linux 2.6.30_rc5-116 ohci_hcd
> [    4.400274] usb usb2: SerialNumber: 0000:00:13.0
> [    4.416439] usb usb2: configuration #1 chosen from 1 choice
> [    4.432351] hub 2-0:1.0: USB hub found
> [    4.447887] hub 2-0:1.0: 2 ports detected
> [    4.463355] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    4.479071] ohci_hcd 0000:00:13.1: OHCI Host Controller
> [    4.494614] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
> [    4.510584] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
> [    4.577075] hub 1-0:1.0: unable to enumerate USB device on port 3
> [    4.581051] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.581053] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.581055] usb usb3: Product: OHCI Host Controller
> [    4.581057] usb usb3: Manufacturer: Linux 2.6.30_rc5-116 ohci_hcd
> [    4.581059] usb usb3: SerialNumber: 0000:00:13.1
> [    4.581117] usb usb3: configuration #1 chosen from 1 choice
> [    4.581141] hub 3-0:1.0: USB hub found
> [    4.581151] hub 3-0:1.0: 2 ports detected
> [    4.581235] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    4.581249] ohci_hcd 0000:00:13.2: OHCI Host Controller
> [    4.581272] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
> [    4.581304] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
> [    4.636034] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.636036] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.636038] usb usb4: Product: OHCI Host Controller
> [    4.636040] usb usb4: Manufacturer: Linux 2.6.30_rc5-116 ohci_hcd
> [    4.636042] usb usb4: SerialNumber: 0000:00:13.2
> [    4.636079] usb usb4: configuration #1 chosen from 1 choice
> [    4.636099] hub 4-0:1.0: USB hub found
> [    4.636108] hub 4-0:1.0: 2 ports detected
> [    4.636173] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    4.636181] ohci_hcd 0000:00:13.3: OHCI Host Controller
> [    4.636197] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
> [    4.636214] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
> [    4.691033] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.691035] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.691037] usb usb5: Product: OHCI Host Controller
> [    4.691039] usb usb5: Manufacturer: Linux 2.6.30_rc5-116 ohci_hcd
> [    4.691041] usb usb5: SerialNumber: 0000:00:13.3
> [    4.691080] usb usb5: configuration #1 chosen from 1 choice
> [    4.691101] hub 5-0:1.0: USB hub found
> [    4.691109] hub 5-0:1.0: 2 ports detected
> [    4.691175] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    4.691182] ohci_hcd 0000:00:13.4: OHCI Host Controller
> [    4.691198] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
> [    4.691215] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
> [    4.746033] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.746036] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.746037] usb usb6: Product: OHCI Host Controller
> [    4.746039] usb usb6: Manufacturer: Linux 2.6.30_rc5-116 ohci_hcd
> [    4.746041] usb usb6: SerialNumber: 0000:00:13.4
> [    4.746076] usb usb6: configuration #1 chosen from 1 choice
> [    4.746099] hub 6-0:1.0: USB hub found
> [    4.746107] hub 6-0:1.0: 2 ports detected
> [    4.746176] uhci_hcd: USB Universal Host Controller Interface driver
> [    4.746244] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    4.746246] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [    4.746533] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    4.746581] mice: PS/2 mouse device common for all mice
> [    4.746697] rtc_cmos 00:04: RTC can wake from S4
> [    4.746729] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> [    4.746764] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
> [    4.746810] cpuidle: using governor ladder
> [    4.746812] cpuidle: using governor menu
> [    4.747020] usbcore: registered new interface driver hiddev
> [    4.747031] usbcore: registered new interface driver usbhid
> [    4.747033] usbhid: v2.6:USB HID core driver
> [    4.747335] NET: Registered protocol family 17
> [    5.470151] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ processors (2 cpu cores) (version 2.20.00)
> [    5.485715] ------------[ cut here ]------------
> [    5.501011] WARNING: at arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1257 powernowk8_cpu_init+0xf3/0x312()
> [    5.517154] Hardware name: Unknow
> [    5.533185] [Firmware Bug]: powernow-k8: Your BIOS does not provide ACPI _PSS objects in a way that Linux understands. Please report this to the Linux ACPI maintainers and complain to your BIOS vendor.
> [    5.567627] Modules linked in:
> [    5.568338] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    5.602790] Pid: 1, comm: swapper Not tainted 2.6.30_rc5-116 #1
> [    5.620811] Call Trace:
> [    5.638635]  [<c01316d1>] warn_slowpath_fmt+0x72/0xa1
> [    5.656519]  [<c02cb743>] ? acpi_ns_get_node+0x7c/0x86
> [    5.674366]  [<c03dc0c2>] ? _spin_lock_irq+0x15/0x18
> [    5.692062]  [<c03db0e3>] ? wait_for_common+0x102/0x11a
> [    5.709777]  [<c02cbbbb>] ? acpi_get_handle+0x6c/0x91
> [    5.727365]  [<c02d7fb2>] ? acpi_processor_register_performance+0x105/0x11f
> [    5.745216]  [<c010fbbf>] ? powernow_k8_cpu_init_acpi+0x1d/0x3bf
> [    5.763081]  [<c010f200>] ? check_supported_cpu+0x19c/0x1a6
> [    5.781086]  [<c03d7948>] ? powernowk8_cpu_init+0x3e/0x312
> [    5.798959]  [<c03d79fd>] powernowk8_cpu_init+0xf3/0x312
> [    5.816775]  [<c034e3d5>] ? lock_policy_rwsem_write+0x33/0x5b
> [    5.834643]  [<c034e591>] cpufreq_add_dev+0x15f/0x51a
> [    5.852474]  [<c0135ee5>] ? irq_exit+0x34/0x57
> [    5.870041]  [<c0116b19>] ? smp_apic_timer_interrupt+0x6f/0x7d
> [    5.887736]  [<c0103b26>] ? apic_timer_interrupt+0x2a/0x30
> [    5.905293]  [<c011d9f9>] ? default_spin_lock_flags+0x8/0xb
> [    5.906263] usb 3-1: new low speed USB device using ohci_hcd and address 2
> [    5.940677]  [<c01320a1>] ? vprintk+0x272/0x299
> [    5.958492]  [<c0302422>] sysdev_driver_register+0x94/0xe3
> [    5.976381]  [<c034dc3e>] cpufreq_register_driver+0x7e/0x10f
> [    5.994443]  [<c03d78fb>] powernowk8_init+0x65/0x74
> [    6.012357]  [<c0101137>] do_one_initcall+0x4a/0x115
> [    6.030100]  [<c03d7896>] ? powernowk8_init+0x0/0x74
> [    6.047568]  [<c016b64d>] ? register_irq_proc+0x7f/0x9b
> [    6.064693]  [<c05922dd>] kernel_init+0x87/0xd5
> [    6.081749]  [<c0592256>] ? kernel_init+0x0/0xd5
> [    6.098684]  [<c0103c77>] kernel_thread_helper+0x7/0x10
> [    6.110092] usb 3-1: New USB device found, idVendor=093a, idProduct=2510
> [    6.110095] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    6.110097] usb 3-1: Product: USB OPTICAL MOUSE
> [    6.110098] usb 3-1: Manufacturer: PIXART
> [    6.110143] usb 3-1: configuration #1 chosen from 1 choice
> [    6.119337] input: PIXART USB OPTICAL MOUSE as /devices/pci0000:00/0000:00:13.1/usb3/3-1/3-1:1.0/input/input4
> [    6.119385] generic-usb 0003:093A:2510.0001: input,hidraw0: USB HID v1.10 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:13.1-1/input0
> [    6.257112] ---[ end trace f84fb6df27bb6bf8 ]---
> [    6.275198] Using IPI No-Shortcut mode
> [    6.292693] registered taskstats version 1
> [    6.309977] rtc_cmos 00:04: setting system clock to 2009-05-14 12:40:59 UTC (1242304859)
> [    6.327319] Freeing unused kernel memory: 372k freed
> [    6.344319] Write protecting the kernel text: 2944k
> [    6.360904] Write protecting the kernel read-only data: 1320k
> [    6.456783] SCSI subsystem initialized
> [    6.473414] libata version 3.00 loaded.
> [    6.474846] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    6.474979] scsi0 : pata_atiixp
> [    6.475075] scsi1 : pata_atiixp
> [    6.475990] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
> [    6.475993] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf908 irq 15
> [    6.784068] ahci 0000:00:12.0: version 3.0
> [    6.784093] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [    6.784115] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
> [    6.784216] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> [    6.784219] ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio 
> [    6.784674] scsi2 : ahci
> [    6.784750] scsi3 : ahci
> [    6.784794] scsi4 : ahci
> [    6.784839] scsi5 : ahci
> [    6.784940] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
> [    6.784944] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
> [    6.784947] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
> [    6.784951] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
> [    7.089053] ata4: SATA link down (SStatus 0 SControl 300)
> [    7.089104] ata6: SATA link down (SStatus 0 SControl 300)
> [    7.242039] ata3: softreset failed (device not ready)
> [    7.242042] ata3: failed due to HW bug, retry pmp=0
> [    7.242057] ata5: softreset failed (device not ready)
> [    7.242060] ata5: failed due to HW bug, retry pmp=0
> [    7.395047] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    7.395068] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    7.407782] ata5.00: ATAPI: Optiarc DVD RW AD-7191S, 1.01, max UDMA/100
> [    7.407799] ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
> [    7.416929] ata3.00: ATA-8: WDC WD1600AAJS-22WAA0, 58.01D58, max UDMA/133
> [    7.416932] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    7.416949] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
> [    7.417738] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
> [    7.417741] ata3.00: configured for UDMA/133
> [    7.417839] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-2 58.0 PQ: 0 ANSI: 5
> [    7.421182] ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
> [    7.421184] ata5.00: configured for UDMA/100
> [    7.424612] scsi 4:0:0:0: CD-ROM            Optiarc  DVD RW AD-7191S  1.01 PQ: 0 ANSI: 5
> [    7.497367] Driver 'sr' needs updating - please use bus_type methods
> [    7.503475] sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
> [    7.503479] Uniform CD-ROM driver Revision: 3.20
> [    7.503551] sr 4:0:0:0: Attached scsi CD-ROM sr0
> [    7.510426] Driver 'sd' needs updating - please use bus_type methods
> [    7.510523] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
> [    7.510535] sd 2:0:0:0: [sda] Write Protect is off
> [    7.510538] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    7.510555] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    7.510625]  sda: sda1 sda2 < sda5 >
> [    7.533068] sd 2:0:0:0: [sda] Attached SCSI disk
> [    7.612956] brd: module loaded
> [    7.655127] kjournald starting.  Commit interval 5 seconds
> [    7.655137] EXT3-fs: mounted filesystem with writeback data mode.
> [   10.050599] udev: starting version 141
> [   10.354707] Linux agpgart interface v0.103
> [   10.356678] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [   10.383509] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
> [   10.392508] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
> [   10.415510] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [   10.415550] sr 4:0:0:0: Attached scsi generic sg1 type 5
> [   10.428691] Error: Driver 'rtc_cmos' is already registered, aborting...
> [   10.428728] BUG: unable to handle kernel NULL pointer dereference at 00000018
> [   10.432460] IP: [<c01e16ba>] sysfs_remove_file+0x1/0xf
> [   10.459009] *pde = 00000000 
> [   10.459009] Oops: 0000 [#1] SMP 
> [   10.459009] last sysfs file: /sys/devices/pci0000:00/0000:00:12.0/host2/target2:0:0/2:0:0:0/type
> [   10.459009] Modules linked in: rtc_cmos(+) sg ati_agp k8temp hwmon i2c_piix4 shpchp agpgart i2c_core mii brd sd_mod crc_t10dif sr_mod cdrom ata_generic pata_acpi ahci pata_atiixp libata scsi_mod
> [   10.459009] 
> [   10.459009] Pid: 633, comm: modprobe Tainted: G        W  (2.6.30_rc5-116 #1) Unknow
> [   10.459009] EIP: 0060:[<c01e16ba>] EFLAGS: 00210282 CPU: 1
> [   10.459009] EIP is at sysfs_remove_file+0x1/0xf
> [   10.459009] EAX: 00000000 EBX: f885a2ec ECX: c1e1a664 EDX: c054d1a0
> [   10.459009] ESI: 00000000 EDI: 00000000 EBP: f6bcdf08 ESP: f6bcdf00
> [   10.459009]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   10.459009] Process modprobe (pid: 633, ti=f6bcc000 task=f6a8d710 task.ti=f6bcc000)
> [   10.459009] Stack:
> [   10.459009]  f6bcdf08 c03037e6 f6bcdf1c c0302809 00000000 f885a2ec 00000000 f6bcdf2c
> [   10.459009]  c030367d ffffffed fffffffc f6bcdf34 c02dcf14 f6bcdf40 f885d038 f885a38c
> [   10.459009]  f6bcdf9c c0101137 f885d000 00000000 f885a38c 00000001 00000000 c0536a04
> [   10.459009] Call Trace:
> [   10.459009]  [<c03037e6>] ? driver_remove_file+0xf/0x11
> [   10.459009]  [<c0302809>] ? bus_remove_driver+0x1a/0x89
> [   10.459009]  [<c030367d>] ? driver_unregister+0x2a/0x2e
> [   10.459009]  [<c02dcf14>] ? pnp_unregister_driver+0xb/0xd
> [   10.459009]  [<f885d038>] ? cmos_init+0x38/0x3d [rtc_cmos]
> [   10.459009]  [<c0101137>] ? do_one_initcall+0x4a/0x115
> [   10.459009]  [<f885d000>] ? cmos_init+0x0/0x3d [rtc_cmos]
> [   10.459009]  [<c0145a65>] ? __blocking_notifier_call_chain+0x40/0x4c
> [   10.459009]  [<c01538d0>] ? sys_init_module+0x87/0x18b
> [   10.459009]  [<c01031d4>] ? sysenter_do_call+0x12/0x28
> [   10.459009] Code: 43 04 89 42 04 89 10 b8 08 9f 53 c0 c7 46 e8 00 01 10 00 c7 43 04 00 02 20 00 e8 1e 9e 1f 00 89 d8 e8 fa ba fb ff 5b 5e 5d c3 55 <8b> 40 18 8b 12 89 e5 e8 12 f5 ff ff 5d c3 55 85 c9 89 e5 57 89 
> [   10.459009] EIP: [<c01e16ba>] sysfs_remove_file+0x1/0xf SS:ESP 0068:f6bcdf00
> [   10.459009] CR2: 0000000000000018
> [   10.460008] ---[ end trace f84fb6df27bb6bfa ]---
> [   10.515873] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [   10.515889] r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   10.515907] r8169 0000:02:00.0: setting latency timer to 64
> [   10.515950] r8169 0000:02:00.0: no MSI. Back to INTx.
> [   10.516195] eth0: RTL8168b/8111b at 0xf8878000, 00:30:18:a2:26:76, XID 38500000 IRQ 16
> [   11.265850] parport_pc 00:09: reported by Plug and Play ACPI
> [   11.284094] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> [   11.385775] lp0: using parport0 (interrupt-driven).
> [   11.469571] ppdev: user-space parallel port driver
> [   11.661072] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   11.786410] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> [   11.810095] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input5
> [   11.834989] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [   12.696340] EXT3 FS on sda5, internal journal
> [   13.006366] EXT4-fs: barriers enabled
> [   13.019171] kjournald2 starting: pid 849, dev sda1:8, commit interval 5 seconds
> [   13.019386] EXT4 FS on sda1, internal journal on sda1:8
> [   13.019388] EXT4-fs: delayed allocation enabled
> [   13.019389] EXT4-fs: file extents enabled
> [   13.019496] EXT4-fs: mballoc enabled
> [   13.019510] EXT4-fs: mounted filesystem sda1 with ordered data mode
> [   13.569118] Adding 307192k swap on /.swap.  Priority:-1 extents:79 across:321904k 
> [   16.077883] r8169: eth0: link up
> [   16.077908] r8169: eth0: link up
> [   17.896736] NET: Registered protocol family 10
> [   17.897221] lo: Disabled Privacy Extensions
> [   28.835034] eth0: no IPv6 routers present

