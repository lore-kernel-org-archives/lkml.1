Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZBRDXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZBRDXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZBRDX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:23:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:10143 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZBRDXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:23:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,226,1233561600"; 
   d="scan'208";a="431833675"
Subject: i915 regression in 2.6.29-rc5
From: ZhangRui <rui.zhang@intel.com>
To: dri_devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Cc: jbarnes@virtuousgeek.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: multipart/mixed; boundary="=-xOwEP0txwlRippdKmePX"
Date: Wed, 18 Feb 2009 11:24:27 +0800
Message-Id: <1234927467.4707.15.camel@rzhang-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xOwEP0txwlRippdKmePX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, all,

I got an i915 failure in 2.6.29-rc5.

problem description: the screen doesn't come back after suspend/resume.
A workaround is to boot with "nomodesetting".

I got this error message during i915 driver load time, 
[   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   22.606752] [drm] MTRR allocation failed
[   22.606753] .  Graphics performance may suffer.

and this during s3 suspend,
[ 1093.793257] PM: Syncing filesystems ... done.
[ 1093.797692] PM: Preparing system for mem sleep
[ 1094.119502] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
[ 1094.514290] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 1094.514726] Freezing remaining freezable tasks ... (elapsed 0.02 seconds) done.

the problem seems to be related with commit 9880b7a527ffbb52f65c2de0a8d4eea86e24775e

thanks,
rui


--=-xOwEP0txwlRippdKmePX
Content-Disposition: attachment; filename=dmesg-drm-failure
Content-Type: text/plain; name=dmesg-drm-failure; charset=UTF-8
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc5-idle (root@rzhang-desktop) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #44 SMP Wed Feb 18 10:18:53 CST 2009
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
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000defafe00 (usable)
[    0.000000]  BIOS-e820: 00000000defafe00 - 00000000defb1ea0 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000defb1ea0 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed40000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed45000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011c000000 (usable)
[    0.000000] DMI 2.5 present.
[    0.000000] last_pfn = 0xdefaf max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 373fe000 @ 7000-d000
[    0.000000] RAMDISK: 36775000 - 37fefca6
[    0.000000] Allocated new RAMDISK: 00a39000 - 022b3ca6
[    0.000000] Move RAMDISK from 0000000036775000 - 0000000037fefca5 to 00a39000 - 022b3ca5
[    0.000000] ACPI: RSDP 000E5C10, 0014 (r0 COMPAQ)
[    0.000000] ACPI: RSDT DEFC1E40, 0044 (r1 HPQOEM SLIC-BPC 20070718             0)
[    0.000000] ACPI: FACP DEFC1EE8, 0074 (r1 COMPAQ BEARLAKE        1             0)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT DEFC2427, A370 (r1 COMPAQ DSDT_PRJ        1 MSFT  100000E)
[    0.000000] ACPI: FACS DEFC1E00, 0040
[    0.000000] ACPI: APIC DEFC1F5C, 0084 (r1 COMPAQ BEARLAKE        1             0)
[    0.000000] ACPI: ASF! DEFC1FE0, 0063 (r32 COMPAQ BEARLAKE        1             0)
[    0.000000] ACPI: MCFG DEFC2043, 003C (r1 COMPAQ BEARLAKE        1             0)
[    0.000000] ACPI: TCPA DEFC207F, 0032 (r1 COMPAQ BEARLAKE        1             0)
[    0.000000] ACPI: SLIC DEFC20B1, 0176 (r1 HPQOEM SLIC-BPC        1             0)
[    0.000000] ACPI: HPET DEFC2227, 0038 (r1 COMPAQ BEARLAKE        1             0)
[    0.000000] ACPI: DMAR DEFC225F, 01A8 (r1 COMPAQ BEARLAKE        1             0)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2683MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 00000000 - 373fe000
[    0.000000]   bootmap 00008000 - 0000ee80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000400000 - 0000a34a30]    TEXT DATA BSS ==> [0000400000 - 0000a34a30]
[    0.000000]   #4 [0000a35000 - 0000a39000]    INIT_PG_TABLE ==> [0000a35000 - 0000a39000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000a39000 - 00022b3ca6]      NEW RAMDISK ==> [0000a39000 - 00022b3ca6]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00f9bf0] 000f9bf0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x000defaf
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000defaf
[    0.000000] On node 0 totalpages: 913230
[    0.000000] free_area_init_node: node 0, pgdat c07da800, node_mem_map c22b4000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 5368 pages used for memmap
[    0.000000]   HighMem zone: 681657 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:14000000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 40960 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 906094
[    0.000000] Kernel command line: root=UUID=4dac41d0-44bf-4fa8-88c9-d6d8f0b95ae2 ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0899000 soft=c0879000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2659.758 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 3590948k/3653308k available (2534k kernel code, 61096k reserved, 1648k data, 364k init, 2748100k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffc58000 - 0xfffff000   (3740 kB)
[    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.004000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.004000]       .init : 0xc081b000 - 0xc0876000   ( 364 kB)
[    0.004000]       .data : 0xc0679b4c - 0xc0815d68   (1648 kB)
[    0.004000]       .text : 0xc0400000 - 0xc0679b4c   (2534 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5319.51 BogoMIPS (lpj=10639032)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Initializing.
[    0.004000] SELinux:  Starting in permissive mode
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Intel machine check architecture supported.
[    0.004000] Intel machine check reporting enabled on CPU#0.
[    0.004000] using mwait in idle threads.
[    0.004000] Checking 'hlt' instruction... OK.
[    0.017723] ACPI: Core revision 20081204
[    0.031688] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.071375] CPU0: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[    0.072001] CPU 1 irqstacks, hard=c089a000 soft=c087a000
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5319.99 BogoMIPS (lpj=10639985)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Intel machine check architecture supported.
[    0.004000] Intel machine check reporting enabled on CPU#1.
[    0.156570] CPU1: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[    0.156582] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160051] Brought up 2 CPUs
[    0.160053] Total of 2 processors activated (10639.50 BogoMIPS).
[    0.160098] CPU0 attaching sched-domain:
[    0.160100]  domain 0: span 0-1 level MC
[    0.160102]   groups: 0 1
[    0.160106] CPU1 attaching sched-domain:
[    0.160107]  domain 0: span 0-1 level MC
[    0.160109]   groups: 1 0
[    0.160141] net_namespace: 780 bytes
[    0.160141] HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
[    0.160141] Booting paravirtualized kernel on bare hardware
[    0.160141] Time:  2:23:28  Date: 02/18/09
[    0.160141] NET: Registered protocol family 16
[    0.160141] ACPI: bus type pci registered
[    0.160141] PCI: MCFG configuration 0: base f4000000 segment 0 buses 0 - 63
[    0.160141] PCI: MCFG area at f4000000 reserved in E820
[    0.160141] PCI: Using MMCONFIG for extended config space
[    0.160141] PCI: Using configuration type 1 for base access
[    0.160141] bio: create slab <bio-0> at 0
[    0.165038] ACPI: EC: Look up EC in DSDT
[    0.175714] ACPI: Interpreter enabled
[    0.175718] ACPI: (supports S0 S3 S4 S5)
[    0.175733] ACPI: Using IOAPIC for interrupt routing
[    0.180665] ACPI: No dock devices found.
[    0.180665] ACPI Error (dsfield-0140): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
[    0.180665] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c16a08), AE_ALREADY_EXISTS
[    0.180665] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.180665] ACPI Warning (nspredef-0328): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 [20081204]
[    0.180665] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.180665] pci 0000:00:02.0: reg 10 32bit mmio: [0xf0100000-0xf017ffff]
[    0.180665] pci 0000:00:02.0: reg 14 io port: [0x1230-0x1237]
[    0.180665] pci 0000:00:02.0: reg 18 32bit mmio: [0xe0000000-0xefffffff]
[    0.180665] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf0000000-0xf00fffff]
[    0.180665] pci 0000:00:02.1: reg 10 32bit mmio: [0xf0180000-0xf01fffff]
[    0.180665] pci 0000:00:03.0: reg 10 64bit mmio: [0xf0226900-0xf022690f]
[    0.180665] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.180665] pci 0000:00:03.0: PME# disabled
[    0.180665] pci 0000:00:03.2: reg 10 io port: [0x1238-0x123f]
[    0.180665] pci 0000:00:03.2: reg 14 io port: [0x1270-0x1273]
[    0.180665] pci 0000:00:03.2: reg 18 io port: [0x1240-0x1247]
[    0.180665] pci 0000:00:03.2: reg 1c io port: [0x1274-0x1277]
[    0.180665] pci 0000:00:03.2: reg 20 io port: [0x11e0-0x11ef]
[    0.180665] pci 0000:00:03.3: reg 10 io port: [0x1248-0x124f]
[    0.180665] pci 0000:00:03.3: reg 14 32bit mmio: [0xf0224000-0xf0224fff]
[    0.180665] pci 0000:00:19.0: reg 10 32bit mmio: [0xf0200000-0xf021ffff]
[    0.180665] pci 0000:00:19.0: reg 14 32bit mmio: [0xf0225000-0xf0225fff]
[    0.180665] pci 0000:00:19.0: reg 18 io port: [0x1100-0x111f]
[    0.180665] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.180665] pci 0000:00:19.0: PME# disabled
[    0.180665] pci 0000:00:1a.0: reg 20 io port: [0x1120-0x113f]
[    0.180665] pci 0000:00:1a.1: reg 20 io port: [0x1140-0x115f]
[    0.180665] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf0226000-0xf02263ff]
[    0.180665] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.180665] pci 0000:00:1a.7: PME# disabled
[    0.180665] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf0220000-0xf0223fff]
[    0.180665] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.180665] pci 0000:00:1b.0: PME# disabled
[    0.180677] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.180680] pci 0000:00:1c.0: PME# disabled
[    0.180727] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.180730] pci 0000:00:1c.1: PME# disabled
[    0.180777] pci 0000:00:1d.0: reg 20 io port: [0x1160-0x117f]
[    0.180835] pci 0000:00:1d.1: reg 20 io port: [0x1180-0x119f]
[    0.180892] pci 0000:00:1d.2: reg 20 io port: [0x11a0-0x11bf]
[    0.180953] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf0226400-0xf02267ff]
[    0.181000] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.181004] pci 0000:00:1d.7: PME# disabled
[    0.181106] pci 0000:00:1f.0: quirk: region f800-f87f claimed by ICH6 ACPI/GPIO/TCO
[    0.181109] pci 0000:00:1f.0: quirk: region fa00-fa3f claimed by ICH6 GPIO
[    0.181112] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0400 (mask 007f)
[    0.181115] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0480 (mask 000f)
[    0.181118] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0cb0 (mask 000f)
[    0.181161] pci 0000:00:1f.2: reg 10 io port: [0x1250-0x1257]
[    0.181166] pci 0000:00:1f.2: reg 14 io port: [0x1278-0x127b]
[    0.181171] pci 0000:00:1f.2: reg 18 io port: [0x1258-0x125f]
[    0.181175] pci 0000:00:1f.2: reg 1c io port: [0x127c-0x127f]
[    0.181180] pci 0000:00:1f.2: reg 20 io port: [0x11f0-0x11ff]
[    0.181185] pci 0000:00:1f.2: reg 24 io port: [0x1200-0x120f]
[    0.181231] pci 0000:00:1f.5: reg 10 io port: [0x1260-0x1267]
[    0.181236] pci 0000:00:1f.5: reg 14 io port: [0x1280-0x1283]
[    0.181240] pci 0000:00:1f.5: reg 18 io port: [0x1268-0x126f]
[    0.181245] pci 0000:00:1f.5: reg 1c io port: [0x1284-0x1287]
[    0.181249] pci 0000:00:1f.5: reg 20 io port: [0x1210-0x121f]
[    0.181254] pci 0000:00:1f.5: reg 24 io port: [0x1220-0x122f]
[    0.181385] pci 0000:00:1e.0: transparent bridge
[    0.181404] pci_bus 0000:00: on NUMA node 0
[    0.181409] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.181620] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.181690] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX2._PRT]
[    0.181761] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.181974] ACPI Error (dsfield-0140): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
[    0.181979] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c16a08), AE_ALREADY_EXISTS
[    0.182005] ACPI Warning (nspredef-0328): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 [20081204]
[    0.212918] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.212918] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.212918] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.212918] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.212918] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.212918] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.212918] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.212918] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.212918] SCSI subsystem initialized
[    0.212918] libata version 3.00 loaded.
[    0.212918] usbcore: registered new interface driver usbfs
[    0.212918] usbcore: registered new interface driver hub
[    0.212918] usbcore: registered new device driver usb
[    0.212918] PCI: Using ACPI for IRQ routing
[    0.220007] NetLabel: Initializing
[    0.220009] NetLabel:  domain hash size = 128
[    0.220011] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.220022] NetLabel:  unlabeled traffic allowed by default
[    0.220030] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.220036] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.232029] pnp: PnP ACPI init
[    0.232036] ACPI: bus type pnp registered
[    0.234819] pnp 00:0e: io resource (0xf800-0xf81f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.234821] pnp 00:0e: io resource (0xf820-0xf83f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.234824] pnp 00:0e: io resource (0xf840-0xf85f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.234826] pnp 00:0e: io resource (0xf860-0xf87f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.235580] pnp: PnP ACPI: found 17 devices
[    0.235581] ACPI: ACPI bus type pnp unregistered
[    0.235593] system 00:0e: ioport range 0x400-0x41f has been reserved
[    0.235595] system 00:0e: ioport range 0x420-0x43f has been reserved
[    0.235598] system 00:0e: ioport range 0x440-0x45f has been reserved
[    0.235600] system 00:0e: ioport range 0x460-0x47f has been reserved
[    0.235602] system 00:0e: ioport range 0x480-0x48f has been reserved
[    0.235604] system 00:0e: ioport range 0xfa00-0xfa3f has been reserved
[    0.235606] system 00:0e: ioport range 0xfc00-0xfc7f has been reserved
[    0.235608] system 00:0e: ioport range 0xfc80-0xfcff has been reserved
[    0.235610] system 00:0e: ioport range 0xfe00-0xfe7f has been reserved
[    0.235613] system 00:0e: ioport range 0xfe80-0xfeff has been reserved
[    0.235617] system 00:0f: ioport range 0x4d0-0x4d1 has been reserved
[    0.235623] system 00:10: iomem range 0x0-0x9ffff could not be reserved
[    0.235625] system 00:10: iomem range 0x100000-0xdfffffff could not be reserved
[    0.235627] system 00:10: iomem range 0xe4000-0xfffff could not be reserved
[    0.235629] system 00:10: iomem range 0xfec01000-0xfecfffff has been reserved
[    0.235632] system 00:10: iomem range 0xfed00400-0xfed3ffff has been reserved
[    0.235634] system 00:10: iomem range 0xfed45000-0xffffffff has been reserved
[    0.235636] system 00:10: iomem range 0xf4000000-0xf7ffffff has been reserved
[    0.235638] system 00:10: iomem range 0xcd400-0xe3fff has been reserved
[    0.270452] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:20
[    0.270453] pci 0000:00:1c.0:   IO window: disabled
[    0.270457] pci 0000:00:1c.0:   MEM window: disabled
[    0.270460] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.270465] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:30
[    0.270466] pci 0000:00:1c.1:   IO window: disabled
[    0.270470] pci 0000:00:1c.1:   MEM window: disabled
[    0.270473] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.270478] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
[    0.270479] pci 0000:00:1e.0:   IO window: disabled
[    0.270483] pci 0000:00:1e.0:   MEM window: disabled
[    0.270486] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.270496] pci 0000:00:1c.0: setting latency timer to 64
[    0.270504] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.270507] pci 0000:00:1c.1: setting latency timer to 64
[    0.270512] pci 0000:00:1e.0: setting latency timer to 64
[    0.270515] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.270517] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.270519] pci_bus 0000:20: resource 0 mem: [0x0-0x0]
[    0.270520] pci_bus 0000:20: resource 1 mem: [0x0-0x0]
[    0.270522] pci_bus 0000:20: resource 2 mem: [0x0-0x0]
[    0.270523] pci_bus 0000:20: resource 3 mem: [0x0-0x0]
[    0.270525] pci_bus 0000:30: resource 0 mem: [0x0-0x0]
[    0.270526] pci_bus 0000:30: resource 1 mem: [0x0-0x0]
[    0.270528] pci_bus 0000:30: resource 2 mem: [0x0-0x0]
[    0.270529] pci_bus 0000:30: resource 3 mem: [0x0-0x0]
[    0.270531] pci_bus 0000:07: resource 0 mem: [0x0-0x0]
[    0.270533] pci_bus 0000:07: resource 1 mem: [0x0-0x0]
[    0.270534] pci_bus 0000:07: resource 2 mem: [0x0-0x0]
[    0.270536] pci_bus 0000:07: resource 3 io:  [0x00-0xffff]
[    0.270537] pci_bus 0000:07: resource 4 mem: [0x000000-0xffffffff]
[    0.270545] NET: Registered protocol family 2
[    0.284120] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.284190] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.284487] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.284625] TCP: Hash tables configured (established 131072 bind 65536)
[    0.284627] TCP reno registered
[    0.288157] NET: Registered protocol family 1
[    0.288260] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.504133] Switched to high resolution mode on CPU 0
[    1.048058]  it is
[    1.848684] Freeing initrd memory: 25067k freed
[    1.849423] audit: initializing netlink socket (disabled)
[    1.849435] type=2000 audit(1234923808.848:1): initialized
[    1.853846] highmem bounce pool size: 64 pages
[    1.853850] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.855788] VFS: Disk quotas dquot_6.5.2
[    1.855834] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.855959] msgmni has been set to 1696
[    1.856018] SELinux:  Registering netfilter hooks
[    1.856164] alg: No test for stdrng (krng)
[    1.856236] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.856239] io scheduler noop registered
[    1.856240] io scheduler anticipatory registered
[    1.856242] io scheduler deadline registered
[    1.856250] io scheduler cfq registered (default)
[    1.856260] pci 0000:00:02.0: Boot video device
[    1.856434] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.856481] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    1.856614] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.856657] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    1.856829] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.857220] ACPI: SSDT DEFCD42B, 03AC (r1 COMPAQ  CPU_TM2        1 MSFT  100000E)
[    1.857560] ACPI: SSDT DEFCD2AF, 017C (r1 COMPAQ      CST        1 MSFT  100000E)
[    1.857864] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.857900] processor ACPI_CPU:00: registered as cooling_device0
[    1.857903] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.858146] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    1.858184] processor ACPI_CPU:01: registered as cooling_device1
[    1.858187] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.860563] isapnp: Scanning for PnP cards...
[    2.213399] isapnp: No Plug & Play device found
[    2.215522] Non-volatile memory driver v1.3
[    2.215524] Linux agpgart interface v0.103
[    2.215667] agpgart-intel 0000:00:00.0: Intel Q35 Chipset
[    2.216545] agpgart-intel 0000:00:00.0: detected 6140K stolen memory
[    2.218808] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    2.218954] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.472250] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.472640] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.472780] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.472834] 0000:00:03.3: ttyS1 at I/O 0x1248 (irq = 17) is a 16550A
[    2.473993] brd: module loaded
[    2.474041] ata_piix 0000:00:1f.2: version 2.12
[    2.474051] ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    2.474055] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.628033] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.628092] scsi0 : ata_piix
[    2.628218] scsi1 : ata_piix
[    2.628432] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x11f0 irq 14
[    2.628436] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x11f8 irq 15
[    3.424078] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.424088] ata1.01: SATA link down (SStatus 0 SControl 300)
[    3.432193] ata1.00: ATA-8: WDC WD1600AAJS-60B4A0, 02.03A02, max UDMA/100
[    3.432196] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.448212] ata1.00: configured for UDMA/100
[    3.448276] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-6 02.0 PQ: 0 ANSI: 5
[    4.244065] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.244076] ata2.01: SATA link down (SStatus 0 SControl 300)
[    4.252196] ata2.00: ATAPI: ATAPI   DVD D  DH16D3S, SH37, max UDMA/100
[    4.268211] ata2.00: configured for UDMA/100
[    4.270713] scsi 1:0:0:0: CD-ROM            ATAPI    DVD D  DH16D3S   SH37 PQ: 0 ANSI: 5
[    4.270894] ata_piix 0000:00:1f.5: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    4.270897] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.424030] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.424074] scsi2 : ata_piix
[    4.424177] scsi3 : ata_piix
[    4.424252] ata3: SATA max UDMA/133 cmd 0x1260 ctl 0x1280 bmdma 0x1210 irq 18
[    4.424255] ata4: SATA max UDMA/133 cmd 0x1268 ctl 0x1284 bmdma 0x1218 irq 18
[    4.754573] ata3: SATA link down (SStatus 0 SControl 300)
[    5.082573] ata4: SATA link down (SStatus 0 SControl 300)
[    5.082787] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    5.085496] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.085501] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.085550] mice: PS/2 mouse device common for all mice
[    5.085651] rtc_cmos 00:03: RTC can wake from S4
[    5.085695] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.085718] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.085884] cpuidle: using governor ladder
[    5.086151] cpuidle: using governor menu
[    5.086191] Marking TSC unstable due to TSC halts in idle
[    5.086771] usbcore: registered new interface driver hiddev
[    5.086800] usbcore: registered new interface driver usbhid
[    5.086802] usbhid: v2.6:USB HID core driver
[    5.086855] TCP cubic registered
[    5.086856] Initializing XFRM netlink socket
[    5.086863] NET: Registered protocol family 17
[    5.086871] Using IPI No-Shortcut mode
[    5.086976] registered taskstats version 1
[    5.087678]   Magic number: 13:358:359
[    5.087685] misc agpgart: hash matches
[    5.087816] Freeing unused kernel memory: 364k freed
[    5.087874] Write protecting the kernel text: 2536k
[    5.087900] Write protecting the kernel read-only data: 1228k
[    5.883035] input: PS/2 Logitech Mouse as /devices/platform/i8042/serio1/input/input0
[    6.220944] fuse init (API version 7.11)
[    6.360163] uhci_hcd: USB Universal Host Controller Interface driver
[    6.360207] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.360214] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.360217] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.360278] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    6.360307] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001120
[    6.360336] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    6.360338] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.360340] usb usb1: Product: UHCI Host Controller
[    6.360342] usb usb1: Manufacturer: Linux 2.6.29-rc5-idle uhci_hcd
[    6.360343] usb usb1: SerialNumber: 0000:00:1a.0
[    6.360382] usb usb1: configuration #1 chosen from 1 choice
[    6.360403] hub 1-0:1.0: USB hub found
[    6.360408] hub 1-0:1.0: 2 ports detected
[    6.360478] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.360483] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.360485] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.360519] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    6.360545] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001140
[    6.360568] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.360570] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.360572] usb usb2: Product: UHCI Host Controller
[    6.360573] usb usb2: Manufacturer: Linux 2.6.29-rc5-idle uhci_hcd
[    6.360575] usb usb2: SerialNumber: 0000:00:1a.1
[    6.360608] usb usb2: configuration #1 chosen from 1 choice
[    6.360627] hub 2-0:1.0: USB hub found
[    6.360632] hub 2-0:1.0: 2 ports detected
[    6.360692] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.360697] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.360699] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.360734] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    6.360754] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001160
[    6.360776] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.360778] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.360780] usb usb3: Product: UHCI Host Controller
[    6.360781] usb usb3: Manufacturer: Linux 2.6.29-rc5-idle uhci_hcd
[    6.360783] usb usb3: SerialNumber: 0000:00:1d.0
[    6.360817] usb usb3: configuration #1 chosen from 1 choice
[    6.360836] hub 3-0:1.0: USB hub found
[    6.360841] hub 3-0:1.0: 2 ports detected
[    6.360901] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.360905] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.360908] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.360946] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[    6.360967] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001180
[    6.360990] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.360992] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.360994] usb usb4: Product: UHCI Host Controller
[    6.360995] usb usb4: Manufacturer: Linux 2.6.29-rc5-idle uhci_hcd
[    6.360997] usb usb4: SerialNumber: 0000:00:1d.1
[    6.361030] usb usb4: configuration #1 chosen from 1 choice
[    6.361049] hub 4-0:1.0: USB hub found
[    6.361053] hub 4-0:1.0: 2 ports detected
[    6.361112] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    6.361117] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.361120] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.361152] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
[    6.361178] uhci_hcd 0000:00:1d.2: irq 22, io base 0x000011a0
[    6.361201] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.361203] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.361205] usb usb5: Product: UHCI Host Controller
[    6.361206] usb usb5: Manufacturer: Linux 2.6.29-rc5-idle uhci_hcd
[    6.361208] usb usb5: SerialNumber: 0000:00:1d.2
[    6.361241] usb usb5: configuration #1 chosen from 1 choice
[    6.361260] hub 5-0:1.0: USB hub found
[    6.361264] hub 5-0:1.0: 2 ports detected
[    6.366478] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.366480] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    6.366501] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    6.366547] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.366550] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.366597] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[    6.370505] ehci_hcd 0000:00:1a.7: debug port 1
[    6.370510] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.370516] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xf0226000
[    6.384017] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.384034] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    6.384037] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.384039] usb usb6: Product: EHCI Host Controller
[    6.384040] usb usb6: Manufacturer: Linux 2.6.29-rc5-idle ehci_hcd
[    6.384042] usb usb6: SerialNumber: 0000:00:1a.7
[    6.384090] usb usb6: configuration #1 chosen from 1 choice
[    6.384111] hub 6-0:1.0: USB hub found
[    6.384117] hub 6-0:1.0: 4 ports detected
[    6.384191] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.384207] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.384210] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.384250] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    6.388151] ehci_hcd 0000:00:1d.7: debug port 1
[    6.388155] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.388162] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf0226400
[    6.394150] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    6.394171] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    6.405600] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.405627] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    6.405629] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.405631] usb usb7: Product: EHCI Host Controller
[    6.405633] usb usb7: Manufacturer: Linux 2.6.29-rc5-idle ehci_hcd
[    6.405634] usb usb7: SerialNumber: 0000:00:1d.7
[    6.405684] usb usb7: configuration #1 chosen from 1 choice
[    6.405705] hub 7-0:1.0: USB hub found
[    6.405711] hub 7-0:1.0: 6 ports detected
[    6.405811] Driver 'sd' needs updating - please use bus_type methods
[    6.405992] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    6.406004] sd 0:0:0:0: [sda] Write Protect is off
[    6.406006] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.406022] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.406069] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    6.406079] sd 0:0:0:0: [sda] Write Protect is off
[    6.406081] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.406098] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.406101]  sda:<4>Driver 'sr' needs updating - please use bus_type methods
[    6.424488]  sda1 sda2 sda3 sda4
[    6.441851] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.448864] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    6.448867] Uniform CD-ROM driver Revision: 3.20
[    6.448928] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.462428] FDC 0 is a post-1991 82077
[    7.064017] PM: Starting manual resume from disk
[    7.064019] PM: Resume from partition 8:2
[    7.064021] PM: Checking hibernation image.
[    7.068680] PM: Resume from disk failed.
[    7.082290] EXT3-fs: INFO: recovery required on readonly filesystem.
[    7.082292] EXT3-fs: write access will be enabled during recovery.
[    7.088528] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    7.263219] usb 5-1: New USB device found, idVendor=03f0, idProduct=0324
[    7.263222] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.263225] usb 5-1: Product: HP Basic USB Keyboard
[    7.263227] usb 5-1: Manufacturer: LiteON
[    7.263316] usb 5-1: configuration #1 chosen from 1 choice
[    7.281480] input: LiteON HP Basic USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb5/5-1/5-1:1.0/input/input1
[    7.287316] generic-usb 0003:03F0:0324.0001: input,hidraw0: USB HID v1.00 Keyboard [LiteON HP Basic USB Keyboard] on usb-0000:00:1d.2-1/input0
[    7.524025] usb 5-2: new low speed USB device using uhci_hcd and address 3
[    7.691216] usb 5-2: New USB device found, idVendor=04b3, idProduct=310c
[    7.691219] usb 5-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    7.691222] usb 5-2: Product: USB Optical Mouse
[    7.691298] usb 5-2: configuration #1 chosen from 1 choice
[    7.706415] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.2/usb5/5-2/5-2:1.0/input/input2
[    7.710430] generic-usb 0003:04B3:310C.0002: input,hidraw1: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.2-2/input0
[   10.032234] kjournald starting.  Commit interval 5 seconds
[   10.032249] EXT3-fs: recovery complete.
[   10.032681] EXT3-fs: mounted filesystem with ordered data mode.
[   14.263039] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[   14.263042] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   14.263080] e1000e 0000:00:19.0: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   14.263087] e1000e 0000:00:19.0: setting latency timer to 64
[   14.263265] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   14.305736] iTCO_vendor_support: vendor-support=0
[   14.321018] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   14.321113] iTCO_wdt: Found a ICH9DO TCO device (Version=2, TCOBASE=0xf860)
[   14.321169] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   14.331856] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   14.356555] ACPI: Power Button (FF) [PWRF]
[   14.356620] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[   14.392747] ACPI: Power Button (CM) [PBTN]
[   14.443842] ACPI: WMI: Mapper loaded
[   14.474211] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:0f:fe:ec:06:36
[   14.474214] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   14.474235] 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: 1062ff-0ff
[   14.566337] tpm_inf_pnp 00:0b: Found TPM with ID IFX0102
[   14.566372] tpm_inf_pnp 00:0b: TPM found: config base 0x4e, data base 0xcb0, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   14.734699] ACPI Exception (video-1658): AE_NOT_FOUND, Evaluating _DOD [20081204]
[   14.734761] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1d/input/input5
[   14.772066] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[   14.855341] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   15.295029] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   15.295139] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.986712] Adding 7815612k swap on /dev/sda2.  Priority:-1 extents:1 across:7815612k 
[   16.522468] EXT3 FS on sda1, internal journal
[   17.376376] kjournald starting.  Commit interval 5 seconds
[   17.376653] EXT3 FS on sda3, internal journal
[   17.376657] EXT3-fs: mounted filesystem with ordered data mode.
[   17.542231] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.775843] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   19.808523] Bluetooth: Core ver 2.14
[   19.809128] NET: Registered protocol family 31
[   19.809130] Bluetooth: HCI device and connection manager initialized
[   19.809133] Bluetooth: HCI socket layer initialized
[   19.847889] Bluetooth: L2CAP ver 2.11
[   19.847892] Bluetooth: L2CAP socket layer initialized
[   19.860196] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   19.890944] Bluetooth: RFCOMM socket layer initialized
[   19.890951] Bluetooth: RFCOMM TTY layer initialized
[   19.890953] Bluetooth: RFCOMM ver 1.10
[   19.916062] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   21.416861] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   21.416865] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   22.560661] [drm] Initialized drm 1.1.0 20060810
[   22.605762] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.605768] pci 0000:00:02.0: setting latency timer to 64
[   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   22.606752] [drm] MTRR allocation failed
[   22.606753] .  Graphics performance may suffer.
[   22.606768] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   22.606784] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   22.623630] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   23.085175] set status page addr 0x00033000
[ 1093.793257] PM: Syncing filesystems ... done.
[ 1093.797692] PM: Preparing system for mem sleep
[ 1094.119502] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
[ 1094.514290] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 1094.514726] Freezing remaining freezable tasks ... (elapsed 0.02 seconds) done.
[ 1094.537510] PM: Entering mem sleep
[ 1094.537522] Suspending console(s) (use no_console_suspend to debug)
[ 1095.009051] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1095.009247] sd 0:0:0:0: [sda] Stopping disk
[ 1095.597965] serial 00:08: disabled
[ 1095.598095] ata_piix 0000:00:1f.5: PCI INT B disabled
[ 1095.612062] ACPI: Cannot set device to a higher-powered state than parent
[ 1095.612128] ACPI: Cannot set device to a higher-powered state than parent
[ 1095.612203] ata_piix 0000:00:1f.2: PCI INT B disabled
[ 1095.628079] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[ 1095.628120] ehci_hcd 0000:00:1d.7: PME# disabled
[ 1095.644030] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 1095.644063] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 1095.644096] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 1095.660305] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 1095.660341] ACPI handle has no context!
[ 1095.676029] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[ 1095.676069] ehci_hcd 0000:00:1a.7: PME# disabled
[ 1095.692034] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 1095.692067] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 1095.862455] e1000e 0000:00:19.0: PME# enabled
[ 1095.862463] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 1095.862467] e1000e 0000:00:19.0: PME# enabled
[ 1095.862469] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 1095.865764] e1000e 0000:00:19.0: PCI INT B disabled
[ 1095.880044] ACPI handle has no context!
[ 1095.896617] ACPI: Preparing to enter system sleep state S3
[ 1095.898027] Disabling non-boot CPUs ...
[ 1095.900243] CPU 1 is now offline
[ 1095.900245] SMP alternatives: switching to UP code
[ 1095.972344] CPU0 attaching NULL sched-domain.
[ 1095.972347] CPU1 attaching NULL sched-domain.
[ 1095.972516] CPU0 attaching NULL sched-domain.
[ 1095.972630] CPU1 is down
[ 1095.972635] Intel machine check architecture supported.
[ 1095.972635] Intel machine check reporting enabled on CPU#0.
[ 1095.972635] Back to C!
[ 1095.972635] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[ 1095.972635] pci 0000:00:03.0: restoring config space at offset 0x1 (was 0x100006, writing 0x180006)
[ 1095.972635] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x200, writing 0x205)
[ 1095.972635] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x1101)
[ 1095.972635] e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xf0225000)
[ 1095.972635] e1000e 0000:00:19.0: restoring config space at offset 0x4 (was 0x0, writing 0xf0200000)
[ 1095.972635] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[ 1095.972635] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0xfef00000, writing 0xf0226000)
[ 1095.972635] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[ 1095.972635] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xf0220004)
[ 1095.972635] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[ 1095.972635] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100102)
[ 1095.972635] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0xfef00000, writing 0xf0226400)
[ 1095.972635] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00001, writing 0x2b00005)
[ 1095.972635] ata_piix 0000:00:1f.5: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
[ 1095.972635] Enabling non-boot CPUs ...
[ 1095.972635] SMP alternatives: switching to SMP code
[ 1096.054701] CPU 1 irqstacks, hard=c089a000 soft=c087a000
[ 1096.054704] Booting processor 1 APIC 0x1 ip 0x6000
[ 1095.972233] Initializing CPU#1
[ 1095.972233] Calibrating delay using timer specific routine.. 5320.04 BogoMIPS (lpj=10640095)
[ 1095.972233] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 1095.972233] CPU: L2 cache: 4096K
[ 1095.972233] [ds] using Core 2/Atom configuration
[ 1095.972233] CPU: Physical Processor ID: 0
[ 1095.972233] CPU: Processor Core ID: 1
[ 1095.972233] Intel machine check architecture supported.
[ 1095.972233] Intel machine check reporting enabled on CPU#1.
[ 1096.144523] CPU1: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[ 1096.144602] CPU0 attaching NULL sched-domain.
[ 1096.148523] Switched to high resolution mode on CPU 1
[ 1096.152263] CPU0 attaching sched-domain:
[ 1096.152265]  domain 0: span 0-1 level MC
[ 1096.152267]   groups: 0 1
[ 1096.152270] CPU1 attaching sched-domain:
[ 1096.152271]  domain 0: span 0-1 level MC
[ 1096.152272]   groups: 1 0
[ 1096.156511] CPU1 is up
[ 1096.156513] ACPI: Waking up from system sleep state S3
[ 1096.157492] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
[ 1096.157506] pci 0000:00:02.0: PME# disabled
[ 1096.157509] pci 0000:00:02.1: PME# disabled
[ 1096.157512] pci 0000:00:03.0: PME# disabled
[ 1096.157514] pci 0000:00:03.2: PME# disabled
[ 1096.157570] e1000e 0000:00:19.0: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[ 1096.157574] e1000e 0000:00:19.0: setting latency timer to 64
[ 1096.157576] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 1096.157579] e1000e 0000:00:19.0: PME# disabled
[ 1096.157581] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 1096.157584] e1000e 0000:00:19.0: PME# disabled
[ 1096.157606] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[ 1096.436159] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 1096.436165] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1096.436185] usb usb1: root hub lost power or was reset
[ 1096.436225] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 1096.436229] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 1096.436249] usb usb2: root hub lost power or was reset
[ 1096.436299] ehci_hcd 0000:00:1a.7: PME# disabled
[ 1096.436302] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 1096.436308] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 1096.436313] ehci_hcd 0000:00:1a.7: PME# disabled
[ 1096.436327] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[ 1096.436332] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 1096.500018] Clocksource tsc unstable (delta = -500002780 ns)
[ 1096.868095] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[ 1096.868103] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[ 1096.868141] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 1096.868145] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 1096.868165] usb usb3: root hub lost power or was reset
[ 1096.868209] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 1096.868214] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 1096.868236] usb usb4: root hub lost power or was reset
[ 1096.868286] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 1096.868291] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 1096.868310] usb usb5: root hub lost power or was reset
[ 1096.868378] ehci_hcd 0000:00:1d.7: PME# disabled
[ 1096.868382] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 1096.868391] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 1096.868396] ehci_hcd 0000:00:1d.7: PME# disabled
[ 1096.868407] pci 0000:00:1e.0: setting latency timer to 64
[ 1096.868444] ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[ 1096.868451] ata_piix 0000:00:1f.2: setting latency timer to 64
[ 1096.870378] ata_piix 0000:00:1f.5: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[ 1096.870382] ata_piix 0000:00:1f.5: setting latency timer to 64
[ 1096.871095] serial 00:08: activated
[ 1096.871172] sd 0:0:0:0: [sda] Starting disk
[ 1097.198613] ata3: SATA link down (SStatus 0 SControl 300)
[ 1097.209225] ata4: SATA link down (SStatus 0 SControl 300)
[ 1097.676067] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1097.676077] ata2.01: SATA link down (SStatus 0 SControl 300)
[ 1097.684197] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[ 1097.684199] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[ 1097.684201] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 1097.700218] ata2.00: configured for UDMA/100
[ 1097.909366] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[ 1097.909368] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[ 1101.604563] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1101.604573] ata1.01: SATA link down (SStatus 0 SControl 300)
[ 1101.612698] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[ 1101.612701] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[ 1101.613191] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[ 1101.613557] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 succeeded
[ 1101.613559] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
[ 1101.613562] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 1101.613564] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 1101.636216] ata1.00: configured for UDMA/100
[ 1101.660215] ata1.00: configured for UDMA/100
[ 1101.660218] ata1: EH complete
[ 1101.690314] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[ 1101.690331] sd 0:0:0:0: [sda] Write Protect is off
[ 1101.690334] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1101.690357] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1101.690383] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[ 1101.690397] sd 0:0:0:0: [sda] Write Protect is off
[ 1101.690399] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1101.690422] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1102.480030] usb 5-1: reset low speed USB device using uhci_hcd and address 2
[ 1103.456029] usb 5-2: reset low speed USB device using uhci_hcd and address 3
[ 1103.766094] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
[ 1103.766110] pci 0000:00:02.0: setting latency timer to 64
[ 1103.767672] PM: Finishing wakeup.
[ 1103.767674] Restarting tasks ... done.

--=-xOwEP0txwlRippdKmePX--

