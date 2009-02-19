Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbZBSDZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbZBSDZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZBSDY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:24:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:32162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbZBSDYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:24:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,231,1233561600"; 
   d="scan'208";a="387998071"
Subject: Re: i915 regression in 2.6.29-rc5
From: Zhang Rui <rui.zhang@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "dri_devel@lists.sourceforge.net" <dri_devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200902180953.05364.jbarnes@virtuousgeek.org>
References: <1234927467.4707.15.camel@rzhang-desktop>
	 <200902180953.05364.jbarnes@virtuousgeek.org>
Content-Type: multipart/mixed; boundary="=-QfPdtiHy+tIYIRdh9uj1"
Date: Thu, 19 Feb 2009 11:24:45 +0800
Message-Id: <1235013885.32297.47.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QfPdtiHy+tIYIRdh9uj1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

well, now I can see the cursor when system resumes.
I can even move the cursors but that's all.
screen is blank, and system hangs if I try to do the second suspend.
dmesg attached.

thanks,
rui

On Thu, 2009-02-19 at 01:53 +0800, Jesse Barnes wrote:
> On Tuesday, February 17, 2009 7:24 pm ZhangRui wrote:
> > Hi, all,
> >
> > I got an i915 failure in 2.6.29-rc5.
> >
> > problem description: the screen doesn't come back after suspend/resume.
> > A workaround is to boot with "nomodesetting".
> >
> > I got this error message during i915 driver load time,
> > [   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back
> > new: write-combining [   22.606752] [drm] MTRR allocation failed
> > [   22.606753] .  Graphics performance may suffer.
> >
> > and this during s3 suspend,
> > [ 1093.793257] PM: Syncing filesystems ... done.
> > [ 1093.797692] PM: Preparing system for mem sleep
> > [ 1094.119502] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank
> > count for disabled pipe 1 [ 1094.514290] Freezing user space processes ...
> > (elapsed 0.00 seconds) done. [ 1094.514726] Freezing remaining freezable
> > tasks ... (elapsed 0.02 seconds) done.
> >
> > the problem seems to be related with commit
> > 9880b7a527ffbb52f65c2de0a8d4eea86e24775e
> 
> I posted a test patch for this problem (among others related to KMS 
> suspend/resume), care to give it a try?
> 
> http://lists.freedesktop.org/archives/intel-gfx/2009-February/001406.html
> 

--=-QfPdtiHy+tIYIRdh9uj1
Content-Disposition: attachment; filename=dmesg-drm-failure-2
Content-Type: text/plain; name=dmesg-drm-failure-2; charset=utf-8
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc5 (root@rzhang-desktop) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #52 SMP Thu Feb 19 11:14:27 CST 2009
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
[    0.000000] RAMDISK: 36775000 - 37fef784
[    0.000000] Allocated new RAMDISK: 00a39000 - 022b3784
[    0.000000] Move RAMDISK from 0000000036775000 - 0000000037fef783 to 00a39000 - 022b3783
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
[    0.000000]   #7 [0000a39000 - 00022b3784]      NEW RAMDISK ==> [0000a39000 - 00022b3784]
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
[    0.000000] Detected 2660.163 MHz processor.
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
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.32 BogoMIPS (lpj=10640652)
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
[    0.017728] ACPI: Core revision 20081204
[    0.031692] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.071385] CPU0: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[    0.072001] CPU 1 irqstacks, hard=c089a000 soft=c087a000
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5319.99 BogoMIPS (lpj=10639992)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Intel machine check architecture supported.
[    0.004000] Intel machine check reporting enabled on CPU#1.
[    0.156588] CPU1: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[    0.156599] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160050] Brought up 2 CPUs
[    0.160052] Total of 2 processors activated (10640.32 BogoMIPS).
[    0.160097] CPU0 attaching sched-domain:
[    0.160100]  domain 0: span 0-1 level MC
[    0.160101]   groups: 0 1
[    0.160105] CPU1 attaching sched-domain:
[    0.160107]  domain 0: span 0-1 level MC
[    0.160108]   groups: 1 0
[    0.160141] net_namespace: 780 bytes
[    0.160141] HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
[    0.160141] Booting paravirtualized kernel on bare hardware
[    0.160141] Time:  3:18:08  Date: 02/19/09
[    0.160141] NET: Registered protocol family 16
[    0.160141] ACPI: bus type pci registered
[    0.160141] PCI: MCFG configuration 0: base f4000000 segment 0 buses 0 - 63
[    0.160141] PCI: MCFG area at f4000000 reserved in E820
[    0.160141] PCI: Using MMCONFIG for extended config space
[    0.160141] PCI: Using configuration type 1 for base access
[    0.160141] bio: create slab <bio-0> at 0
[    0.165060] ACPI: EC: Look up EC in DSDT
[    0.175716] ACPI: Interpreter enabled
[    0.175721] ACPI: (supports S0 S3 S4 S5)
[    0.175735] ACPI: Using IOAPIC for interrupt routing
[    0.180674] ACPI: No dock devices found.
[    0.180674] ACPI Error (dsfield-0140): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
[    0.180674] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c16a08), AE_ALREADY_EXISTS
[    0.180674] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.180674] ACPI Warning (nspredef-0328): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 [20081204]
[    0.180674] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.180674] pci 0000:00:02.0: reg 10 32bit mmio: [0xf0100000-0xf017ffff]
[    0.180674] pci 0000:00:02.0: reg 14 io port: [0x1230-0x1237]
[    0.180674] pci 0000:00:02.0: reg 18 32bit mmio: [0xe0000000-0xefffffff]
[    0.180674] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf0000000-0xf00fffff]
[    0.180674] pci 0000:00:02.1: reg 10 32bit mmio: [0xf0180000-0xf01fffff]
[    0.180674] pci 0000:00:03.0: reg 10 64bit mmio: [0xf0226900-0xf022690f]
[    0.180674] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.180674] pci 0000:00:03.0: PME# disabled
[    0.180674] pci 0000:00:03.2: reg 10 io port: [0x1238-0x123f]
[    0.180674] pci 0000:00:03.2: reg 14 io port: [0x1270-0x1273]
[    0.180674] pci 0000:00:03.2: reg 18 io port: [0x1240-0x1247]
[    0.180674] pci 0000:00:03.2: reg 1c io port: [0x1274-0x1277]
[    0.180674] pci 0000:00:03.2: reg 20 io port: [0x11e0-0x11ef]
[    0.180674] pci 0000:00:03.3: reg 10 io port: [0x1248-0x124f]
[    0.180674] pci 0000:00:03.3: reg 14 32bit mmio: [0xf0224000-0xf0224fff]
[    0.180674] pci 0000:00:19.0: reg 10 32bit mmio: [0xf0200000-0xf021ffff]
[    0.180674] pci 0000:00:19.0: reg 14 32bit mmio: [0xf0225000-0xf0225fff]
[    0.180674] pci 0000:00:19.0: reg 18 io port: [0x1100-0x111f]
[    0.180674] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.180674] pci 0000:00:19.0: PME# disabled
[    0.180674] pci 0000:00:1a.0: reg 20 io port: [0x1120-0x113f]
[    0.180674] pci 0000:00:1a.1: reg 20 io port: [0x1140-0x115f]
[    0.180674] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf0226000-0xf02263ff]
[    0.180674] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.180674] pci 0000:00:1a.7: PME# disabled
[    0.180674] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf0220000-0xf0223fff]
[    0.180674] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.180674] pci 0000:00:1b.0: PME# disabled
[    0.180676] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.180680] pci 0000:00:1c.0: PME# disabled
[    0.180727] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.180730] pci 0000:00:1c.1: PME# disabled
[    0.180777] pci 0000:00:1d.0: reg 20 io port: [0x1160-0x117f]
[    0.180834] pci 0000:00:1d.1: reg 20 io port: [0x1180-0x119f]
[    0.180892] pci 0000:00:1d.2: reg 20 io port: [0x11a0-0x11bf]
[    0.180953] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf0226400-0xf02267ff]
[    0.181000] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.181004] pci 0000:00:1d.7: PME# disabled
[    0.181105] pci 0000:00:1f.0: quirk: region f800-f87f claimed by ICH6 ACPI/GPIO/TCO
[    0.181108] pci 0000:00:1f.0: quirk: region fa00-fa3f claimed by ICH6 GPIO
[    0.181111] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0400 (mask 007f)
[    0.181114] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0480 (mask 000f)
[    0.181117] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0cb0 (mask 000f)
[    0.181160] pci 0000:00:1f.2: reg 10 io port: [0x1250-0x1257]
[    0.181165] pci 0000:00:1f.2: reg 14 io port: [0x1278-0x127b]
[    0.181170] pci 0000:00:1f.2: reg 18 io port: [0x1258-0x125f]
[    0.181174] pci 0000:00:1f.2: reg 1c io port: [0x127c-0x127f]
[    0.181179] pci 0000:00:1f.2: reg 20 io port: [0x11f0-0x11ff]
[    0.181183] pci 0000:00:1f.2: reg 24 io port: [0x1200-0x120f]
[    0.181230] pci 0000:00:1f.5: reg 10 io port: [0x1260-0x1267]
[    0.181234] pci 0000:00:1f.5: reg 14 io port: [0x1280-0x1283]
[    0.181239] pci 0000:00:1f.5: reg 18 io port: [0x1268-0x126f]
[    0.181244] pci 0000:00:1f.5: reg 1c io port: [0x1284-0x1287]
[    0.181248] pci 0000:00:1f.5: reg 20 io port: [0x1210-0x121f]
[    0.181253] pci 0000:00:1f.5: reg 24 io port: [0x1220-0x122f]
[    0.181384] pci 0000:00:1e.0: transparent bridge
[    0.181403] pci_bus 0000:00: on NUMA node 0
[    0.181408] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.181619] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.181688] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX2._PRT]
[    0.181760] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.181975] ACPI Error (dsfield-0140): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS
[    0.181979] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c16a08), AE_ALREADY_EXISTS
[    0.182005] ACPI Warning (nspredef-0328): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 [20081204]
[    0.212891] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.212891] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.212891] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.212891] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.212891] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.212891] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.212891] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.212891] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.212891] SCSI subsystem initialized
[    0.212891] libata version 3.00 loaded.
[    0.212891] usbcore: registered new interface driver usbfs
[    0.212891] usbcore: registered new interface driver hub
[    0.212891] usbcore: registered new device driver usb
[    0.212891] PCI: Using ACPI for IRQ routing
[    0.220007] NetLabel: Initializing
[    0.220009] NetLabel:  domain hash size = 128
[    0.220011] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.220022] NetLabel:  unlabeled traffic allowed by default
[    0.220031] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.220036] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.232028] pnp: PnP ACPI init
[    0.232035] ACPI: bus type pnp registered
[    0.234804] pnp 00:0e: io resource (0xf800-0xf81f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.234807] pnp 00:0e: io resource (0xf820-0xf83f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.234810] pnp 00:0e: io resource (0xf840-0xf85f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.234812] pnp 00:0e: io resource (0xf860-0xf87f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
[    0.235566] pnp: PnP ACPI: found 17 devices
[    0.235568] ACPI: ACPI bus type pnp unregistered
[    0.235579] system 00:0e: ioport range 0x400-0x41f has been reserved
[    0.235582] system 00:0e: ioport range 0x420-0x43f has been reserved
[    0.235584] system 00:0e: ioport range 0x440-0x45f has been reserved
[    0.235586] system 00:0e: ioport range 0x460-0x47f has been reserved
[    0.235588] system 00:0e: ioport range 0x480-0x48f has been reserved
[    0.235590] system 00:0e: ioport range 0xfa00-0xfa3f has been reserved
[    0.235593] system 00:0e: ioport range 0xfc00-0xfc7f has been reserved
[    0.235595] system 00:0e: ioport range 0xfc80-0xfcff has been reserved
[    0.235597] system 00:0e: ioport range 0xfe00-0xfe7f has been reserved
[    0.235599] system 00:0e: ioport range 0xfe80-0xfeff has been reserved
[    0.235603] system 00:0f: ioport range 0x4d0-0x4d1 has been reserved
[    0.235609] system 00:10: iomem range 0x0-0x9ffff could not be reserved
[    0.235611] system 00:10: iomem range 0x100000-0xdfffffff could not be reserved
[    0.235614] system 00:10: iomem range 0xe4000-0xfffff could not be reserved
[    0.235616] system 00:10: iomem range 0xfec01000-0xfecfffff has been reserved
[    0.235618] system 00:10: iomem range 0xfed00400-0xfed3ffff has been reserved
[    0.235620] system 00:10: iomem range 0xfed45000-0xffffffff has been reserved
[    0.235623] system 00:10: iomem range 0xf4000000-0xf7ffffff has been reserved
[    0.235625] system 00:10: iomem range 0xcd400-0xe3fff has been reserved
[    0.270442] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:20
[    0.270444] pci 0000:00:1c.0:   IO window: disabled
[    0.270448] pci 0000:00:1c.0:   MEM window: disabled
[    0.270450] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.270455] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:30
[    0.270457] pci 0000:00:1c.1:   IO window: disabled
[    0.270460] pci 0000:00:1c.1:   MEM window: disabled
[    0.270463] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.270468] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
[    0.270470] pci 0000:00:1e.0:   IO window: disabled
[    0.270473] pci 0000:00:1e.0:   MEM window: disabled
[    0.270476] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.270487] pci 0000:00:1c.0: setting latency timer to 64
[    0.270494] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.270497] pci 0000:00:1c.1: setting latency timer to 64
[    0.270502] pci 0000:00:1e.0: setting latency timer to 64
[    0.270505] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.270507] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.270509] pci_bus 0000:20: resource 0 mem: [0x0-0x0]
[    0.270510] pci_bus 0000:20: resource 1 mem: [0x0-0x0]
[    0.270512] pci_bus 0000:20: resource 2 mem: [0x0-0x0]
[    0.270513] pci_bus 0000:20: resource 3 mem: [0x0-0x0]
[    0.270515] pci_bus 0000:30: resource 0 mem: [0x0-0x0]
[    0.270517] pci_bus 0000:30: resource 1 mem: [0x0-0x0]
[    0.270518] pci_bus 0000:30: resource 2 mem: [0x0-0x0]
[    0.270520] pci_bus 0000:30: resource 3 mem: [0x0-0x0]
[    0.270521] pci_bus 0000:07: resource 0 mem: [0x0-0x0]
[    0.270523] pci_bus 0000:07: resource 1 mem: [0x0-0x0]
[    0.270524] pci_bus 0000:07: resource 2 mem: [0x0-0x0]
[    0.270526] pci_bus 0000:07: resource 3 io:  [0x00-0xffff]
[    0.270528] pci_bus 0000:07: resource 4 mem: [0x000000-0xffffffff]
[    0.270536] NET: Registered protocol family 2
[    0.284112] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.284179] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.284478] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.284615] TCP: Hash tables configured (established 131072 bind 65536)
[    0.284617] TCP reno registered
[    0.288147] NET: Registered protocol family 1
[    0.288247] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.504091] Switched to high resolution mode on CPU 0
[    1.048064]  it is
[    1.848444] Freeing initrd memory: 25065k freed
[    1.849182] audit: initializing netlink socket (disabled)
[    1.849195] type=2000 audit(1235013488.848:1): initialized
[    1.853598] highmem bounce pool size: 64 pages
[    1.853602] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.855490] VFS: Disk quotas dquot_6.5.2
[    1.855537] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.855659] msgmni has been set to 1696
[    1.855716] SELinux:  Registering netfilter hooks
[    1.855858] alg: No test for stdrng (krng)
[    1.855931] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.855933] io scheduler noop registered
[    1.855935] io scheduler anticipatory registered
[    1.855936] io scheduler deadline registered
[    1.855945] io scheduler cfq registered (default)
[    1.855955] pci 0000:00:02.0: Boot video device
[    1.856133] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.856180] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    1.856300] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.856343] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    1.856498] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.856892] ACPI: SSDT DEFCD42B, 03AC (r1 COMPAQ  CPU_TM2        1 MSFT  100000E)
[    1.857233] ACPI: SSDT DEFCD2AF, 017C (r1 COMPAQ      CST        1 MSFT  100000E)
[    1.857541] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.857579] processor ACPI_CPU:00: registered as cooling_device0
[    1.857582] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.857826] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    1.857861] processor ACPI_CPU:01: registered as cooling_device1
[    1.857864] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.860238] isapnp: Scanning for PnP cards...
[    2.213022] isapnp: No Plug & Play device found
[    2.215146] Non-volatile memory driver v1.3
[    2.215147] Linux agpgart interface v0.103
[    2.215292] agpgart-intel 0000:00:00.0: Intel Q35 Chipset
[    2.216158] agpgart-intel 0000:00:00.0: detected 6140K stolen memory
[    2.218431] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    2.218577] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.472237] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.472626] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.472765] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.472821] 0000:00:03.3: ttyS1 at I/O 0x1248 (irq = 17) is a 16550A
[    2.473973] brd: module loaded
[    2.474021] ata_piix 0000:00:1f.2: version 2.12
[    2.474030] ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    2.474034] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.628020] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.628079] scsi0 : ata_piix
[    2.628204] scsi1 : ata_piix
[    2.628415] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x11f0 irq 14
[    2.628419] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x11f8 irq 15
[    3.424054] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.424064] ata1.01: SATA link down (SStatus 0 SControl 300)
[    3.432192] ata1.00: ATA-8: WDC WD1600AAJS-60B4A0, 02.03A02, max UDMA/100
[    3.432194] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.440206] ata1.00: configured for UDMA/100
[    3.440270] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-6 02.0 PQ: 0 ANSI: 5
[    4.236052] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.236063] ata2.01: SATA link down (SStatus 0 SControl 300)
[    4.244190] ata2.00: ATAPI: ATAPI   DVD D  DH16D3S, SH37, max UDMA/100
[    4.260210] ata2.00: configured for UDMA/100
[    4.262697] scsi 1:0:0:0: CD-ROM            ATAPI    DVD D  DH16D3S   SH37 PQ: 0 ANSI: 5
[    4.262876] ata_piix 0000:00:1f.5: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    4.262880] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.416017] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.416062] scsi2 : ata_piix
[    4.416164] scsi3 : ata_piix
[    4.416236] ata3: SATA max UDMA/133 cmd 0x1260 ctl 0x1280 bmdma 0x1210 irq 18
[    4.416239] ata4: SATA max UDMA/133 cmd 0x1268 ctl 0x1284 bmdma 0x1218 irq 18
[    4.746570] ata3: SATA link down (SStatus 0 SControl 300)
[    5.074569] ata4: SATA link down (SStatus 0 SControl 300)
[    5.074782] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    5.077486] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.077490] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.077544] mice: PS/2 mouse device common for all mice
[    5.077645] rtc_cmos 00:03: RTC can wake from S4
[    5.077688] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.077710] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.077883] cpuidle: using governor ladder
[    5.078156] cpuidle: using governor menu
[    5.078195] Marking TSC unstable due to TSC halts in idle
[    5.078784] usbcore: registered new interface driver hiddev
[    5.078812] usbcore: registered new interface driver usbhid
[    5.078814] usbhid: v2.6:USB HID core driver
[    5.078869] TCP cubic registered
[    5.078870] Initializing XFRM netlink socket
[    5.078877] NET: Registered protocol family 17
[    5.078884] Using IPI No-Shortcut mode
[    5.078990] registered taskstats version 1
[    5.079693]   Magic number: 13:986:310
[    5.079700] tty tty39: hash matches
[    5.079830] Freeing unused kernel memory: 364k freed
[    5.079889] Write protecting the kernel text: 2536k
[    5.079915] Write protecting the kernel read-only data: 1228k
[    5.854876] input: PS/2 Logitech Mouse as /devices/platform/i8042/serio1/input/input0
[    6.212811] fuse init (API version 7.11)
[    6.346547] uhci_hcd: USB Universal Host Controller Interface driver
[    6.346591] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.346598] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.346602] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.346664] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    6.346693] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001120
[    6.346720] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    6.346722] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.346724] usb usb1: Product: UHCI Host Controller
[    6.346726] usb usb1: Manufacturer: Linux 2.6.29-rc5 uhci_hcd
[    6.346727] usb usb1: SerialNumber: 0000:00:1a.0
[    6.346763] usb usb1: configuration #1 chosen from 1 choice
[    6.346784] hub 1-0:1.0: USB hub found
[    6.346789] hub 1-0:1.0: 2 ports detected
[    6.346858] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.346863] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.346865] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.346897] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    6.346923] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001140
[    6.346946] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.346948] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.346950] usb usb2: Product: UHCI Host Controller
[    6.346951] usb usb2: Manufacturer: Linux 2.6.29-rc5 uhci_hcd
[    6.346953] usb usb2: SerialNumber: 0000:00:1a.1
[    6.346985] usb usb2: configuration #1 chosen from 1 choice
[    6.347006] hub 2-0:1.0: USB hub found
[    6.347011] hub 2-0:1.0: 2 ports detected
[    6.347069] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.347073] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.347075] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.347108] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    6.347128] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001160
[    6.347151] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.347153] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.347155] usb usb3: Product: UHCI Host Controller
[    6.347156] usb usb3: Manufacturer: Linux 2.6.29-rc5 uhci_hcd
[    6.347158] usb usb3: SerialNumber: 0000:00:1d.0
[    6.347196] usb usb3: configuration #1 chosen from 1 choice
[    6.347215] hub 3-0:1.0: USB hub found
[    6.347219] hub 3-0:1.0: 2 ports detected
[    6.347283] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.347288] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.347290] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.347322] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[    6.347342] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001180
[    6.347368] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.347370] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.347371] usb usb4: Product: UHCI Host Controller
[    6.347373] usb usb4: Manufacturer: Linux 2.6.29-rc5 uhci_hcd
[    6.347375] usb usb4: SerialNumber: 0000:00:1d.1
[    6.347406] usb usb4: configuration #1 chosen from 1 choice
[    6.347425] hub 4-0:1.0: USB hub found
[    6.347429] hub 4-0:1.0: 2 ports detected
[    6.347491] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    6.347496] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.347498] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.347532] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
[    6.347557] uhci_hcd 0000:00:1d.2: irq 22, io base 0x000011a0
[    6.347579] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.347581] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.347583] usb usb5: Product: UHCI Host Controller
[    6.347585] usb usb5: Manufacturer: Linux 2.6.29-rc5 uhci_hcd
[    6.347586] usb usb5: SerialNumber: 0000:00:1d.2
[    6.347620] usb usb5: configuration #1 chosen from 1 choice
[    6.347639] hub 5-0:1.0: USB hub found
[    6.347643] hub 5-0:1.0: 2 ports detected
[    6.355570] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.355572] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    6.355597] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    6.355645] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.355648] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.355702] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[    6.359589] ehci_hcd 0000:00:1a.7: debug port 1
[    6.359594] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.359601] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xf0226000
[    6.372521] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.372538] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    6.372540] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.372543] usb usb6: Product: EHCI Host Controller
[    6.372544] usb usb6: Manufacturer: Linux 2.6.29-rc5 ehci_hcd
[    6.372546] usb usb6: SerialNumber: 0000:00:1a.7
[    6.372591] usb usb6: configuration #1 chosen from 1 choice
[    6.372613] hub 6-0:1.0: USB hub found
[    6.372618] hub 6-0:1.0: 4 ports detected
[    6.372688] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.372702] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.372704] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.372742] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    6.376626] ehci_hcd 0000:00:1d.7: debug port 1
[    6.376631] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.376895] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf0226400
[    6.380813] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    6.380832] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    6.392511] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.392527] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    6.392529] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.392531] usb usb7: Product: EHCI Host Controller
[    6.392533] usb usb7: Manufacturer: Linux 2.6.29-rc5 ehci_hcd
[    6.392534] usb usb7: SerialNumber: 0000:00:1d.7
[    6.392576] usb usb7: configuration #1 chosen from 1 choice
[    6.392598] hub 7-0:1.0: USB hub found
[    6.392603] hub 7-0:1.0: 6 ports detected
[    6.412060] Driver 'sd' needs updating - please use bus_type methods
[    6.412130] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    6.412141] sd 0:0:0:0: [sda] Write Protect is off
[    6.412143] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.412159] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.412209] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    6.412219] sd 0:0:0:0: [sda] Write Protect is off
[    6.412222] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.412238] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.412241]  sda:<4>Driver 'sr' needs updating - please use bus_type methods
[    6.421973]  sda1 sda2 sda3 sda4
[    6.435301] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.443909] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    6.443912] Uniform CD-ROM driver Revision: 3.20
[    6.443967] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.446423] FDC 0 is a post-1991 82077
[    7.000035] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    7.180144] PM: Starting manual resume from disk
[    7.180146] PM: Resume from partition 8:2
[    7.180147] PM: Checking hibernation image.
[    7.182600] usb 5-1: New USB device found, idVendor=045e, idProduct=0040
[    7.182603] usb 5-1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    7.182606] usb 5-1: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
[    7.182608] usb 5-1: Manufacturer: Microsoft
[    7.182682] usb 5-1: configuration #1 chosen from 1 choice
[    7.184691] PM: Resume from disk failed.
[    7.200802] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.2/usb5/5-1/5-1:1.0/input/input1
[    7.203752] EXT3-fs: INFO: recovery required on readonly filesystem.
[    7.203755] EXT3-fs: write access will be enabled during recovery.
[    7.212547] generic-usb 0003:045E:0040.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.2-1/input0
[    7.452149] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    7.629602] usb 5-2: New USB device found, idVendor=04b3, idProduct=301a
[    7.629605] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.629608] usb 5-2: Product: USB 1.1 2port downstream low power hub
[    7.629610] usb 5-2: Manufacturer: Lite-On Technology
[    7.629687] usb 5-2: configuration #1 chosen from 1 choice
[    7.637617] hub 5-2:1.0: USB hub found
[    7.638597] hub 5-2:1.0: 3 ports detected
[    7.917601] usb 5-2.1: new full speed USB device using uhci_hcd and address 4
[    8.065601] usb 5-2.1: New USB device found, idVendor=04b3, idProduct=301b
[    8.065604] usb 5-2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    8.065606] usb 5-2.1: Product: USB Productivity Option Keyboard( has the hub in # 1 )
[    8.065609] usb 5-2.1: Manufacturer: Lite-On Technology
[    8.065663] usb 5-2.1: configuration #1 chosen from 1 choice
[    8.075787] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.2/usb5/5-2/5-2.1/5-2.1:1.0/input/input2
[    8.084587] generic-usb 0003:04B3:301B.0002: input,hidraw1: USB HID v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.2-2.1/input0
[    8.088639] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.2/usb5/5-2/5-2.1/5-2.1:1.1/input/input3
[    8.097236] generic-usb 0003:04B3:301B.0003: input,hidraw2: USB HID v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.2-2.1/input1
[    9.899828] kjournald starting.  Commit interval 5 seconds
[    9.899842] EXT3-fs: recovery complete.
[    9.900246] EXT3-fs: mounted filesystem with ordered data mode.
[   13.257554] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[   13.257556] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   13.257595] e1000e 0000:00:19.0: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.257602] e1000e 0000:00:19.0: setting latency timer to 64
[   13.257782] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   13.458718] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:0f:fe:ec:06:36
[   13.458721] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   13.458742] 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: 1062ff-0ff
[   13.476838] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   13.509122] ACPI: WMI: Mapper loaded
[   13.512557] ACPI: Power Button (FF) [PWRF]
[   13.512622] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
[   13.535964] ACPI: Power Button (CM) [PBTN]
[   13.602750] tpm_inf_pnp 00:0b: Found TPM with ID IFX0102
[   13.602786] tpm_inf_pnp 00:0b: TPM found: config base 0x4e, data base 0xcb0, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   13.648439] ACPI Exception (video-1658): AE_NOT_FOUND, Evaluating _DOD [20081204]
[   13.648516] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1d/input/input6
[   13.664906] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[   13.753682] iTCO_vendor_support: vendor-support=0
[   13.767122] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   13.767268] iTCO_wdt: Found a ICH9DO TCO device (Version=2, TCOBASE=0xf860)
[   13.767323] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   13.804533] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   13.979866] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   13.979931] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.996563] Adding 7815612k swap on /dev/sda2.  Priority:-1 extents:1 across:7815612k 
[   15.534447] EXT3 FS on sda1, internal journal
[   16.377069] kjournald starting.  Commit interval 5 seconds
[   16.377343] EXT3 FS on sda3, internal journal
[   16.377348] EXT3-fs: mounted filesystem with ordered data mode.
[   16.537478] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.863376] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   18.898296] Bluetooth: Core ver 2.14
[   18.898894] NET: Registered protocol family 31
[   18.898896] Bluetooth: HCI device and connection manager initialized
[   18.898899] Bluetooth: HCI socket layer initialized
[   18.937968] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   18.938071] Bluetooth: L2CAP ver 2.11
[   18.938073] Bluetooth: L2CAP socket layer initialized
[   18.987553] Bluetooth: RFCOMM socket layer initialized
[   18.987561] Bluetooth: RFCOMM TTY layer initialized
[   18.987563] Bluetooth: RFCOMM ver 1.10
[   18.992071] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   20.528881] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   20.528885] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   21.649418] [drm] Initialized drm 1.1.0 20060810
[   21.700086] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   21.700092] pci 0000:00:02.0: setting latency timer to 64
[   21.701117] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   21.701120] [drm] MTRR allocation failed
[   21.701121] .  Graphics performance may suffer.
[   21.701137] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   21.701153] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   21.715541] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   22.157458] set status page addr 0x00033000
[   88.203048] PM: Syncing filesystems ... done.
[   88.206036] PM: Preparing system for mem sleep
[   88.520181] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
[   88.915022] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   88.920009] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   88.932010] PM: Entering mem sleep
[   88.932021] Suspending console(s) (use no_console_suspend to debug)
[   89.417922] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   89.418122] sd 0:0:0:0: [sda] Stopping disk
[   89.958767] serial 00:08: disabled
[   89.958898] ata_piix 0000:00:1f.5: PCI INT B disabled
[   89.972053] ACPI: Cannot set device to a higher-powered state than parent
[   89.972115] ACPI: Cannot set device to a higher-powered state than parent
[   89.972191] ata_piix 0000:00:1f.2: PCI INT B disabled
[   89.988084] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[   89.988124] ehci_hcd 0000:00:1d.7: PME# disabled
[   90.004024] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   90.004057] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   90.004091] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   90.020315] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   90.020351] ACPI handle has no context!
[   90.036030] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[   90.036069] ehci_hcd 0000:00:1a.7: PME# disabled
[   90.052025] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[   90.052059] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[   90.222445] e1000e 0000:00:19.0: PME# enabled
[   90.222453] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   90.222457] e1000e 0000:00:19.0: PME# enabled
[   90.222459] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   90.225755] e1000e 0000:00:19.0: PCI INT B disabled
[   90.240045] ACPI handle has no context!
[   90.256629] ACPI: Preparing to enter system sleep state S3
[   90.258046] Disabling non-boot CPUs ...
[   90.260243] CPU 1 is now offline
[   90.260245] SMP alternatives: switching to UP code
[   90.345823] CPU0 attaching NULL sched-domain.
[   90.345826] CPU1 attaching NULL sched-domain.
[   90.345851] CPU0 attaching NULL sched-domain.
[   90.345937] CPU1 is down
[   90.345941] Intel machine check architecture supported.
[   90.345941] Intel machine check reporting enabled on CPU#0.
[   90.345941] Back to C!
[   90.345941] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[   90.345941] pci 0000:00:03.0: restoring config space at offset 0x1 (was 0x100006, writing 0x180006)
[   90.345941] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x200, writing 0x205)
[   90.345941] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x1101)
[   90.345941] e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xf0225000)
[   90.345941] e1000e 0000:00:19.0: restoring config space at offset 0x4 (was 0x0, writing 0xf0200000)
[   90.345941] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[   90.345941] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0xfef00000, writing 0xf0226000)
[   90.345941] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[   90.345941] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xf0220004)
[   90.345941] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[   90.345941] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100102)
[   90.345941] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0xfef00000, writing 0xf0226400)
[   90.345941] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00001, writing 0x2b00005)
[   90.345941] ata_piix 0000:00:1f.5: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
[   90.345941] Enabling non-boot CPUs ...
[   90.345941] SMP alternatives: switching to SMP code
[   90.428416] CPU 1 irqstacks, hard=c089a000 soft=c087a000
[   90.428420] Booting processor 1 APIC 0x1 ip 0x6000
[   90.345729] Initializing CPU#1
[   90.345729] Calibrating delay using timer specific routine.. 5320.05 BogoMIPS (lpj=10640111)
[   90.345729] CPU: L1 I cache: 32K, L1 D cache: 32K
[   90.345729] CPU: L2 cache: 4096K
[   90.345729] [ds] using Core 2/Atom configuration
[   90.345729] CPU: Physical Processor ID: 0
[   90.345729] CPU: Processor Core ID: 1
[   90.345729] Intel machine check architecture supported.
[   90.345729] Intel machine check reporting enabled on CPU#1.
[   90.516569] CPU1: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[   90.516647] CPU0 attaching NULL sched-domain.
[   90.520523] Switched to high resolution mode on CPU 1
[   90.524264] CPU0 attaching sched-domain:
[   90.524266]  domain 0: span 0-1 level MC
[   90.524267]   groups: 0 1
[   90.524270] CPU1 attaching sched-domain:
[   90.524271]  domain 0: span 0-1 level MC
[   90.524272]   groups: 1 0
[   90.528513] CPU1 is up
[   90.528514] ACPI: Waking up from system sleep state S3
[   90.529489] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
[   90.529503] pci 0000:00:02.0: PME# disabled
[   90.529505] pci 0000:00:02.1: PME# disabled
[   90.529508] pci 0000:00:03.0: PME# disabled
[   90.529511] pci 0000:00:03.2: PME# disabled
[   90.529567] e1000e 0000:00:19.0: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   90.529571] e1000e 0000:00:19.0: setting latency timer to 64
[   90.529573] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   90.529576] e1000e 0000:00:19.0: PME# disabled
[   90.529578] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   90.529581] e1000e 0000:00:19.0: PME# disabled
[   90.529602] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
[   90.808157] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   90.808162] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   90.808183] usb usb1: root hub lost power or was reset
[   90.808222] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   90.808227] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   90.808246] usb usb2: root hub lost power or was reset
[   90.808296] ehci_hcd 0000:00:1a.7: PME# disabled
[   90.808299] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   90.808305] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   90.808310] ehci_hcd 0000:00:1a.7: PME# disabled
[   90.808324] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   90.808329] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   91.000018] Clocksource tsc unstable (delta = -500012682 ns)
[   91.240083] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[   91.240093] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[   91.240131] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   91.240136] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   91.240155] usb usb3: root hub lost power or was reset
[   91.240200] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   91.240205] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   91.240227] usb usb4: root hub lost power or was reset
[   91.240276] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   91.240281] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   91.240300] usb usb5: root hub lost power or was reset
[   91.240368] ehci_hcd 0000:00:1d.7: PME# disabled
[   91.240372] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   91.240381] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   91.240387] ehci_hcd 0000:00:1d.7: PME# disabled
[   91.240394] pci 0000:00:1e.0: setting latency timer to 64
[   91.240435] ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   91.240442] ata_piix 0000:00:1f.2: setting latency timer to 64
[   91.242362] ata_piix 0000:00:1f.5: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   91.242366] ata_piix 0000:00:1f.5: setting latency timer to 64
[   91.243077] serial 00:08: activated
[   91.243153] sd 0:0:0:0: [sda] Starting disk
[   91.570612] ata3: SATA link down (SStatus 0 SControl 300)
[   91.581224] ata4: SATA link down (SStatus 0 SControl 300)
[   92.048066] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   92.048077] ata2.01: SATA link down (SStatus 0 SControl 300)
[   92.056196] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[   92.056199] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[   92.056201] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[   92.072217] ata2.00: configured for UDMA/100
[   92.213365] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   92.213368] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   95.976563] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   95.976573] ata1.01: SATA link down (SStatus 0 SControl 300)
[   95.984698] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[   95.984700] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[   95.985463] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[   95.985828] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 succeeded
[   95.985830] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
[   95.985833] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[   95.985835] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[   96.008215] ata1.00: configured for UDMA/100
[   96.032215] ata1.00: configured for UDMA/100
[   96.032218] ata1: EH complete
[   96.057825] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[   96.057843] sd 0:0:0:0: [sda] Write Protect is off
[   96.057845] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   96.057869] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   96.057894] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[   96.057908] sd 0:0:0:0: [sda] Write Protect is off
[   96.057910] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   96.057933] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   96.644023] usb 5-1: reset low speed USB device using uhci_hcd and address 2
[   97.064030] usb 5-2: reset full speed USB device using uhci_hcd and address 3
[   97.505048] usb 5-2.1: reset full speed USB device using uhci_hcd and address 4
[   97.627092] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
[   97.627108] pci 0000:00:02.0: setting latency timer to 64
[   97.628652] PM: Finishing wakeup.
[   97.628654] Restarting tasks ... done.

--=-QfPdtiHy+tIYIRdh9uj1--

