Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbZGWAGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbZGWAGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZGWAGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:06:52 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:62463 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZGWAGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=ZTm7ipZ5l/pDrFlCqEgvc33WYjTwftBkz0Rd3GXXIbqqjj7xbHhrPqU1gg4M/Hy6Oh
         6FXR5o5lO+wM4aZQAPxO6GpD+v5n1tpKQ/r0sCBZkcMdEAwEfla7C3604dcWqRLNuMVk
         dEGzhEmhw1/IJg/I+lLOucNmYtuPvQzHspPjY=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Alberto Gonzalez <alberto6674@gmail.com>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Thu, 23 Jul 2009 02:06:36 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <20090722124436.0daa2079@jbarnes-g45> <200907222200.21792.info@gnebu.es>
In-Reply-To: <200907222200.21792.info@gnebu.es>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Mm6ZKNulzHTDV1K"
Message-Id: <200907230206.36544.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Mm6ZKNulzHTDV1K
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 22 July 2009 22:00:21 Alberto Gonzalez wrote:
> On Wednesday 22 July 2009 21:44:36 Jesse Barnes wrote:
> > Hm, so this type of interrupt problem is *supposed* to be handled by
> > setting of the PEG_BAND_GAP_DATA reg (low bits set to 0xd).  Do you
> > have that in your tree?  Does git master have this problem?
>
> The problem started with 2.6.30 on a standard distro kernel (Arch Linux).
> Latest tests were with vanilla 2.6.30.1 and a cut down config (attached). I
> haven't tested .31.
>
> I'll try to test latest git as soon as I can and let you know if the
> problem exists there.

I've tested 2.6.31 from git and I can reproduce the problem. Attached is the 
dmesg with the debug patch applied.

>
> > Maybe we need to add a patch to 2.6.30.x to set PEG_BAND_GAP_DATA as a
> > workaround (git master already has code to do this properly for HDMI
> > and DP outputs afaict).


--Boundary-00=_Mm6ZKNulzHTDV1K
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg-2.6.31.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-2.6.31.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc3 (root@localhost) (gcc version 4.4.0 20090630 (prerelease) (GCC) ) #1 SMP Thu Jul 23 01:44:51 CEST 2009
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
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7d90000 (usable)
[    0.000000]  BIOS-e820: 00000000c7d90000 - 00000000c7d9e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7d9e000 - 00000000c7de0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7de0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0xc7d90 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 120000000 mask FF0000000 write-back
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 base 0C7E00000 mask FFFE00000 uncachable
[    0.000000]   6 base 0C8000000 mask FF8000000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c7e00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7d90000 (usable)
[    0.000000]  modified: 00000000c7d90000 - 00000000c7d9e000 (ACPI data)
[    0.000000]  modified: 00000000c7d9e000 - 00000000c7de0000 (ACPI NVS)
[    0.000000]  modified: 00000000c7de0000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37fa0000 - 37fefc28
[    0.000000] Allocated new RAMDISK: 00008000 - 00057c28
[    0.000000] Move RAMDISK from 0000000037fa0000 - 0000000037fefc27 to 00008000 - 00057c27
[    0.000000] ACPI: RSDP 000f9cd0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT c7d90000 00044 (v01 DELL    AS09    20090511 MSFT 00000097)
[    0.000000] ACPI: FACP c7d90200 00084 (v01 051109 FACP1620 20090511 MSFT 00000097)
[    0.000000] ACPI: DSDT c7d905c0 05270 (v01  1ADXP 1ADXP005 00000005 INTL 20051117)
[    0.000000] ACPI: FACS c7d9e000 00040
[    0.000000] ACPI: APIC c7d90390 0006C (v01 051109 APIC1620 20090511 MSFT 00000097)
[    0.000000] ACPI: MCFG c7d90400 0003C (v01 051109 OEMMCFG  20090511 MSFT 00000097)
[    0.000000] ACPI: SLIC c7d90440 00176 (v01 DELL    AS09    20090511 MSFT 00000097)
[    0.000000] ACPI: OEMB c7d9e040 00072 (v01 051109 OEMB1620 20090511 MSFT 00000097)
[    0.000000] ACPI: HPET c7d985c0 00038 (v01 051109 OEMHPET  20090511 MSFT 00000097)
[    0.000000] ACPI: GSCI c7d9e0c0 02024 (v01 051109 GMCHSCI  20090511 MSFT 00000097)
[    0.000000] ACPI: SSDT c7da0b40 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2309MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00058000 - 0005ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 000173a868]    TEXT DATA BSS ==> [0001000000 - 000173a868]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [000173b000 - 00017420e0]              BRK ==> [000173b000 - 00017420e0]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 0000057c28]      NEW RAMDISK ==> [0000008000 - 0000057c28]
[    0.000000]   #8 [0000058000 - 000005f000]          BOOTMAP ==> [0000058000 - 000005f000]
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000c7d90
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000c7d90
[    0.000000] On node 0 totalpages: 818475
[    0.000000] free_area_init_node: node 0, pgdat c161d180, node_mem_map c1743000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4620 pages used for memmap
[    0.000000]   HighMem zone: 586630 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ee00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c3053000, static data 28380 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 812079
[    0.000000] Kernel command line: root=/dev/disk/by-uuid/2bfe816c-08ba-4962-9cb7-f54396fba685 ro i915.modeset=$
[    0.000000] Booting kernel: `$' invalid for parameter `i915.modeset'
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:000c7d90)
[    0.000000] Memory: 3238556k/3274304k available (4067k kernel code, 34432k reserved, 2259k data, 360k init, 2365000k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1635000 - 0xc168f000   ( 360 kB)
[    0.000000]       .data : 0xc13f8d45 - 0xc162dc54   (2259 kB)
[    0.000000]       .text : 0xc1000000 - 0xc13f8d45   (4067 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2500.417 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.83 BogoMIPS (lpj=2500417)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] Initializing cgroup subsys ns
[    0.000999] Initializing cgroup subsys cpuacct
[    0.000999] Initializing cgroup subsys freezer
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.001006] mce: CPU supports 6 MCE banks
[    0.001077] CPU0: Thermal monitoring enabled (TM2)
[    0.001147] using mwait in idle threads.
[    0.001218] Checking 'hlt' instruction... OK.
[    0.005497] ACPI: Core revision 20090521
[    0.013352] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023669] CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.023996] APIC calibration not consistent with PM-Timer: 119ms instead of 100ms
[    0.023996] APIC delta adjusted to PM-Timer: 1250041 (1500036)
[    0.023996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 5000.03 BogoMIPS (lpj=2500015)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.095333] CPU1: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.096138] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.097005] Brought up 2 CPUs
[    0.097071] Total of 2 processors activated (10000.86 BogoMIPS).
[    0.097241] khelper used greatest stack depth: 7008 bytes left
[    0.097241] Time:  1:48:58  Date: 07/23/09
[    0.098024] NET: Registered protocol family 16
[    0.098104] ACPI: bus type pci registered
[    0.099024] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.099079] PCI: Not using MMCONFIG.
[    0.099286] PCI: Using configuration type 1 for base access
[    0.104078] bio: create slab <bio-0> at 0
[    0.105433] ACPI: EC: Look up EC in DSDT
[    0.110878] ACPI: Interpreter enabled
[    0.110947] ACPI: (supports S0 S1 S3 S4 S5)
[    0.111111] ACPI: Using IOAPIC for interrupt routing
[    0.111220] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.112532] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.112606] PCI: Using MMCONFIG for extended config space
[    0.119204] ACPI: No dock devices found.
[    0.119522] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.119610] pci 0000:00:02.0: reg 10 64bit mmio: [0xfe400000-0xfe7fffff]
[    0.119610] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.119610] pci 0000:00:02.0: reg 20 io port: [0xdc00-0xdc07]
[    0.119610] pci 0000:00:02.1: reg 10 64bit mmio: [0xfe800000-0xfe8fffff]
[    0.119610] pci 0000:00:1a.0: reg 20 io port: [0xd880-0xd89f]
[    0.119610] pci 0000:00:1a.1: reg 20 io port: [0xd800-0xd81f]
[    0.119610] pci 0000:00:1a.2: reg 20 io port: [0xd480-0xd49f]
[    0.120003] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe9fbc00-0xfe9fbfff]
[    0.120054] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.120128] pci 0000:00:1a.7: PME# disabled
[    0.120229] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe9f4000-0xfe9f7fff]
[    0.120267] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.120340] pci 0000:00:1b.0: PME# disabled
[    0.120456] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.120529] pci 0000:00:1c.0: PME# disabled
[    0.120647] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.120720] pci 0000:00:1c.2: PME# disabled
[    0.120838] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.120911] pci 0000:00:1c.5: PME# disabled
[    0.121028] pci 0000:00:1d.0: reg 20 io port: [0xd400-0xd41f]
[    0.121091] pci 0000:00:1d.1: reg 20 io port: [0xd080-0xd09f]
[    0.121153] pci 0000:00:1d.2: reg 20 io port: [0xd000-0xd01f]
[    0.121219] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe9fb800-0xfe9fbbff]
[    0.121269] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.121343] pci 0000:00:1d.7: PME# disabled
[    0.121518] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.121631] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.121706] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.121865] pci 0000:00:1f.2: reg 10 io port: [0xcc00-0xcc07]
[    0.121870] pci 0000:00:1f.2: reg 14 io port: [0xc880-0xc883]
[    0.121876] pci 0000:00:1f.2: reg 18 io port: [0xc800-0xc807]
[    0.121881] pci 0000:00:1f.2: reg 1c io port: [0xc480-0xc483]
[    0.121886] pci 0000:00:1f.2: reg 20 io port: [0xc400-0xc40f]
[    0.121891] pci 0000:00:1f.2: reg 24 io port: [0xc080-0xc08f]
[    0.121932] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe9fb400-0xfe9fb4ff]
[    0.121945] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.121986] pci 0000:00:1f.5: reg 10 io port: [0xbc00-0xbc07]
[    0.121991] pci 0000:00:1f.5: reg 14 io port: [0xb880-0xb883]
[    0.121996] pci 0000:00:1f.5: reg 18 io port: [0xb800-0xb807]
[    0.122001] pci 0000:00:1f.5: reg 1c io port: [0xb480-0xb483]
[    0.122007] pci 0000:00:1f.5: reg 20 io port: [0xb400-0xb40f]
[    0.122012] pci 0000:00:1f.5: reg 24 io port: [0xb080-0xb08f]
[    0.122123] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.122134] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.122160] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.122170] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.122262] pci 0000:00:1c.2: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.122308] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.122327] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]
[    0.122340] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.122347] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.122384] pci 0000:03:00.0: supports D1 D2
[    0.122386] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.122461] pci 0000:03:00.0: PME# disabled
[    0.122575] pci 0000:00:1c.5: bridge io port: [0xe000-0xefff]
[    0.122578] pci 0000:00:1c.5: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.122583] pci 0000:00:1c.5: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.122626] pci 0000:00:1e.0: transparent bridge
[    0.122715] pci_bus 0000:00: on NUMA node 0
[    0.122719] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.122839] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.122909] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.122958] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.123005] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.136416] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.137064] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.137272] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.137639] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.138035] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.138403] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.138770] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.139137] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.139459] SCSI subsystem initialized
[    0.139459] libata version 3.00 loaded.
[    0.139459] usbcore: registered new interface driver usbfs
[    0.139995] usbcore: registered new interface driver hub
[    0.140058] usbcore: registered new device driver usb
[    0.140058] PCI: Using ACPI for IRQ routing
[    0.141988] NetLabel: Initializing
[    0.142061] NetLabel:  domain hash size = 128
[    0.142138] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.142214] NetLabel:  unlabeled traffic allowed by default
[    0.142291] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.142291] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.148989] pnp: PnP ACPI init
[    0.149074] ACPI: bus type pnp registered
[    0.151016] pnp: PnP ACPI: found 12 devices
[    0.151083] ACPI: ACPI bus type pnp unregistered
[    0.151158] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.151232] system 00:01: iomem range 0xfed90000-0xfed93fff has been reserved
[    0.151310] system 00:06: ioport range 0xa00-0xadf has been reserved
[    0.151385] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.151458] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.151530] system 00:07: ioport range 0x500-0x57f could not be reserved
[    0.151604] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.151679] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.151753] system 00:07: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.151830] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.151941] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.152021] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.152098] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.152171] system 00:0b: iomem range 0xc0000-0xcffff could not be reserved
[    0.152245] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
[    0.152319] system 00:0b: iomem range 0x100000-0xc7dfffff could not be reserved
[    0.152430] system 00:0b: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.187557] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.187628] pci 0000:00:1c.0:   IO window: disabled
[    0.187699] pci 0000:00:1c.0:   MEM window: disabled
[    0.187769] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.187841] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.187911] pci 0000:00:1c.2:   IO window: disabled
[    0.187987] pci 0000:00:1c.2:   MEM window: 0xfea00000-0xfeafffff
[    0.188060] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.188131] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:03
[    0.188203] pci 0000:00:1c.5:   IO window: 0xe000-0xefff
[    0.188276] pci 0000:00:1c.5:   MEM window: 0xfeb00000-0xfebfffff
[    0.188349] pci 0000:00:1c.5:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.188463] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.188534] pci 0000:00:1e.0:   IO window: disabled
[    0.188605] pci 0000:00:1e.0:   MEM window: disabled
[    0.188675] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.188753]   alloc irq_desc for 17 on node -1
[    0.188755]   alloc kstat_irqs on node -1
[    0.188759] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.188835] pci 0000:00:1c.0: setting latency timer to 64
[    0.188841]   alloc irq_desc for 18 on node -1
[    0.188842]   alloc kstat_irqs on node -1
[    0.188845] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.188919] pci 0000:00:1c.2: setting latency timer to 64
[    0.188925]   alloc irq_desc for 16 on node -1
[    0.188926]   alloc kstat_irqs on node -1
[    0.188928] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.189006] pci 0000:00:1c.5: setting latency timer to 64
[    0.189011] pci 0000:00:1e.0: setting latency timer to 64
[    0.189015] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.189017] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.189019] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.189021] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.189023] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.189025] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.189027] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.189029] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffff]
[    0.189053] NET: Registered protocol family 2
[    0.189181] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.189475] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.189994] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.190247] TCP: Hash tables configured (established 131072 bind 65536)
[    0.190320] TCP reno registered
[    0.190447] NET: Registered protocol family 1
[    0.190568] Trying to unpack rootfs image as initramfs...
[    0.198910] Freeing initrd memory: 319k freed
[    0.199891] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
[    0.199967] microcode: CPU1 sig=0x10676, pf=0x1, revision=0x60c
[    0.200083] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.200195] Scanning for low memory corruption every 60 seconds
[    0.200516] audit: initializing netlink socket (disabled)
[    0.200596] type=2000 audit(1248313738.199:1): initialized
[    0.211075] highmem bounce pool size: 64 pages
[    0.211145] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.213373] VFS: Disk quotas dquot_6.5.2
[    0.213501] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.215113] msgmni has been set to 1708
[    0.215331] SELinux:  Registering netfilter hooks
[    0.215615] alg: No test for stdrng (krng)
[    0.215762] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.215874] io scheduler noop registered
[    0.215940] io scheduler anticipatory registered
[    0.216029] io scheduler deadline registered
[    0.216144] io scheduler cfq registered (default)
[    0.216222] pci 0000:00:02.0: Boot video device
[    0.216229] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.216230] pci 0000:00:1a.0: Performing full reset
[    0.216245] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.216246] pci 0000:00:1a.1: Performing full reset
[    0.216260] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.216262] pci 0000:00:1a.2: Performing full reset
[    0.216294] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.216296] pci 0000:00:1d.0: Performing full reset
[    0.216310] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.216311] pci 0000:00:1d.1: Performing full reset
[    0.216325] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.216327] pci 0000:00:1d.2: Performing full reset
[    0.216465]   alloc irq_desc for 24 on node -1
[    0.216467]   alloc kstat_irqs on node -1
[    0.216475] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.216483] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.216641]   alloc irq_desc for 25 on node -1
[    0.216642]   alloc kstat_irqs on node -1
[    0.216648] pcieport-driver 0000:00:1c.2: irq 25 for MSI/MSI-X
[    0.216655] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.216812]   alloc irq_desc for 26 on node -1
[    0.216814]   alloc kstat_irqs on node -1
[    0.216819] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.216826] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.217005] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.217294] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.217406] ACPI: Power Button [PWRF]
[    0.217539] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.217653] ACPI: Power Button [PWRB]
[    0.218180] ACPI: SSDT c7da00f0 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.218694] ACPI: SSDT c7da05f0 004B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.219078] Monitor-Mwait will be used to enter C-1 state
[    0.219096] Monitor-Mwait will be used to enter C-2 state
[    0.219101] Marking TSC unstable due to TSC halts in idle
[    0.219187] Switched to high resolution mode on CPU 0
[    0.219231] ACPI: CPU0 (power states:
[    0.219244] Switched to high resolution mode on CPU 1
[    0.219319]  C1[C1] C2[C2])
[    0.219458] processor LNXCPU:00: registered as cooling_device0
[    0.219872] ACPI: SSDT c7da0370 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[    0.220261] ACPI: SSDT c7da0ab0 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    0.220710] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    0.220872] processor LNXCPU:01: registered as cooling_device1
[    0.225193] Non-volatile memory driver v1.3
[    0.225341] Linux agpgart interface v0.103
[    0.225460] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    0.226238] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    0.228251] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.228416] [drm] Initialized drm 1.1.0 20060810
[    0.228534] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.228609] pci 0000:00:02.0: setting latency timer to 64
[    0.229701] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    0.229819] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.229911]   alloc irq_desc for 27 on node -1
[    0.229913]   alloc kstat_irqs on node -1
[    0.229921] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.229934] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.230054] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.230372] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[    0.232342] brd: module loaded
[    0.233184] loop: module loaded
[    0.233492] ata_piix 0000:00:1f.2: version 2.13
[    0.233507]   alloc irq_desc for 19 on node -1
[    0.233509]   alloc kstat_irqs on node -1
[    0.233516] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.233593] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.233788] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.233833] scsi0 : ata_piix
[    0.234022] scsi1 : ata_piix
[    0.235264] ata1: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    0.235340] ata2: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    0.235429] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.235505] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    0.235696] ata_piix 0000:00:1f.5: setting latency timer to 64
[    0.235764] scsi2 : ata_piix
[    0.235918] scsi3 : ata_piix
[    0.236917] ata3: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    0.236993] ata4: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    0.237291] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    0.237363] Copyright (c) 1999-2006 Intel Corporation.
[    0.237471] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    0.237541] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    0.237649] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.237721] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.237871] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.238676] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.238760] r8169 0000:03:00.0: setting latency timer to 64
[    0.238818]   alloc irq_desc for 28 on node -1
[    0.238819]   alloc kstat_irqs on node -1
[    0.238830] r8169 0000:03:00.0: irq 28 for MSI/MSI-X
[    0.239041] eth0: RTL8168c/8111c at 0xf8056000, 00:21:70:4c:c3:ac, XID 3c4000c0 IRQ 28
[    0.241959] console [netcon0] enabled
[    0.242030] netconsole: network logging started
[    0.242228] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.242301] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    0.242316] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.242397] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.242400] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.242485] drivers/usb/core/inode.c: creating file 'devices'
[    0.242488] drivers/usb/core/inode.c: creating file '001'
[    0.242531] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.242646] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.242650] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.242664] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.246546] ehci_hcd 0000:00:1a.7: debug port 1
[    0.246617] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.246618] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.246629] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe9fbc00
[    0.246701] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.250598] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.257012] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.257140] usb usb1: default language 0x0409
[    0.257146] usb usb1: udev 1, busnum 1, minor = 0
[    0.257148] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.257221] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.257331] usb usb1: Product: EHCI Host Controller
[    0.257399] usb usb1: Manufacturer: Linux 2.6.31-rc3 ehci_hcd
[    0.257469] usb usb1: SerialNumber: 0000:00:1a.7
[    0.257564] usb usb1: uevent
[    0.257598] usb usb1: usb_probe_device
[    0.257600] usb usb1: configuration #1 chosen from 1 choice
[    0.257674] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.257686] usb 1-0:1.0: uevent
[    0.257718] hub 1-0:1.0: usb_probe_interface
[    0.257720] hub 1-0:1.0: usb_probe_interface - got id
[    0.257721] hub 1-0:1.0: USB hub found
[    0.257795] hub 1-0:1.0: 6 ports detected
[    0.257861] hub 1-0:1.0: standalone hub
[    0.257862] hub 1-0:1.0: no power switching (usb 1.0)
[    0.257864] hub 1-0:1.0: individual port over-current protection
[    0.257865] hub 1-0:1.0: power on to power good time: 20ms
[    0.257869] hub 1-0:1.0: local power source is good
[    0.257870] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.257894] drivers/usb/core/inode.c: creating file '001'
[    0.257917]   alloc irq_desc for 23 on node -1
[    0.257918]   alloc kstat_irqs on node -1
[    0.257922] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.258007] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.258010] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.258083] drivers/usb/core/inode.c: creating file '002'
[    0.258125] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.258243] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.258247] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.258262] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.262140] ehci_hcd 0000:00:1d.7: debug port 1
[    0.262211] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.262213] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    0.262222] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe9fb800
[    0.262294] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.266162] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.273012] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.273113] usb usb2: default language 0x0409
[    0.273123] usb usb2: udev 1, busnum 2, minor = 128
[    0.273127] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.273211] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.273322] usb usb2: Product: EHCI Host Controller
[    0.273390] usb usb2: Manufacturer: Linux 2.6.31-rc3 ehci_hcd
[    0.273460] usb usb2: SerialNumber: 0000:00:1d.7
[    0.273553] usb usb2: uevent
[    0.273589] usb usb2: usb_probe_device
[    0.273591] usb usb2: configuration #1 chosen from 1 choice
[    0.273664] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    0.273675] usb 2-0:1.0: uevent
[    0.273707] hub 2-0:1.0: usb_probe_interface
[    0.273709] hub 2-0:1.0: usb_probe_interface - got id
[    0.273710] hub 2-0:1.0: USB hub found
[    0.273779] hub 2-0:1.0: 6 ports detected
[    0.273844] hub 2-0:1.0: standalone hub
[    0.273846] hub 2-0:1.0: no power switching (usb 1.0)
[    0.273847] hub 2-0:1.0: individual port over-current protection
[    0.273849] hub 2-0:1.0: power on to power good time: 20ms
[    0.273852] hub 2-0:1.0: local power source is good
[    0.273853] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    0.273877] drivers/usb/core/inode.c: creating file '001'
[    0.273922] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.273994] ohci_hcd: block sizes: ed 64 td 64
[    0.274036] uhci_hcd: USB Universal Host Controller Interface driver
[    0.274130] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.274208] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.274210] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.274282] drivers/usb/core/inode.c: creating file '003'
[    0.274328] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.274442] uhci_hcd 0000:00:1a.0: detected 2 ports
[    0.274513] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.274515] uhci_hcd 0000:00:1a.0: Performing full reset
[    0.274527] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    0.274537] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
[    0.274628] usb usb3: default language 0x0409
[    0.274633] usb usb3: udev 1, busnum 3, minor = 256
[    0.274634] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.274708] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.274818] usb usb3: Product: UHCI Host Controller
[    0.274886] usb usb3: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    0.274957] usb usb3: SerialNumber: 0000:00:1a.0
[    0.275058] usb usb3: uevent
[    0.275090] usb usb3: usb_probe_device
[    0.275092] usb usb3: configuration #1 chosen from 1 choice
[    0.275168] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    0.275179] usb 3-0:1.0: uevent
[    0.275210] hub 3-0:1.0: usb_probe_interface
[    0.275212] hub 3-0:1.0: usb_probe_interface - got id
[    0.275213] hub 3-0:1.0: USB hub found
[    0.275282] hub 3-0:1.0: 2 ports detected
[    0.275347] hub 3-0:1.0: standalone hub
[    0.275349] hub 3-0:1.0: no power switching (usb 1.0)
[    0.275350] hub 3-0:1.0: individual port over-current protection
[    0.275352] hub 3-0:1.0: power on to power good time: 2ms
[    0.275355] hub 3-0:1.0: local power source is good
[    0.275356] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    0.275368] drivers/usb/core/inode.c: creating file '001'
[    0.275391]   alloc irq_desc for 21 on node -1
[    0.275393]   alloc kstat_irqs on node -1
[    0.275396] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.275473] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.275476] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.275547] drivers/usb/core/inode.c: creating file '004'
[    0.275595] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.275710] uhci_hcd 0000:00:1a.1: detected 2 ports
[    0.275780] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.275781] uhci_hcd 0000:00:1a.1: Performing full reset
[    0.275793] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    0.275803] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[    0.275893] usb usb4: default language 0x0409
[    0.275899] usb usb4: udev 1, busnum 4, minor = 384
[    0.275900] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.275974] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.276095] usb usb4: Product: UHCI Host Controller
[    0.276166] usb usb4: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    0.276237] usb usb4: SerialNumber: 0000:00:1a.1
[    0.276334] usb usb4: uevent
[    0.276364] usb usb4: usb_probe_device
[    0.276366] usb usb4: configuration #1 chosen from 1 choice
[    0.276439] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    0.276450] usb 4-0:1.0: uevent
[    0.276480] hub 4-0:1.0: usb_probe_interface
[    0.276482] hub 4-0:1.0: usb_probe_interface - got id
[    0.276483] hub 4-0:1.0: USB hub found
[    0.276552] hub 4-0:1.0: 2 ports detected
[    0.276618] hub 4-0:1.0: standalone hub
[    0.276619] hub 4-0:1.0: no power switching (usb 1.0)
[    0.276621] hub 4-0:1.0: individual port over-current protection
[    0.276622] hub 4-0:1.0: power on to power good time: 2ms
[    0.276625] hub 4-0:1.0: local power source is good
[    0.276627] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    0.276638] drivers/usb/core/inode.c: creating file '001'
[    0.276660] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    0.276737] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.276740] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.276811] drivers/usb/core/inode.c: creating file '005'
[    0.276856] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.276970] uhci_hcd 0000:00:1a.2: detected 2 ports
[    0.277045] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.277047] uhci_hcd 0000:00:1a.2: Performing full reset
[    0.277059] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    0.277063] uhci_hcd 0000:00:1a.2: irq 21, io base 0x0000d480
[    0.277156] usb usb5: default language 0x0409
[    0.277162] usb usb5: udev 1, busnum 5, minor = 512
[    0.277163] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.277237] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.277347] usb usb5: Product: UHCI Host Controller
[    0.277415] usb usb5: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    0.277486] usb usb5: SerialNumber: 0000:00:1a.2
[    0.277579] usb usb5: uevent
[    0.277611] usb usb5: usb_probe_device
[    0.277612] usb usb5: configuration #1 chosen from 1 choice
[    0.277685] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    0.277696] usb 5-0:1.0: uevent
[    0.277726] hub 5-0:1.0: usb_probe_interface
[    0.277728] hub 5-0:1.0: usb_probe_interface - got id
[    0.277729] hub 5-0:1.0: USB hub found
[    0.277797] hub 5-0:1.0: 2 ports detected
[    0.277863] hub 5-0:1.0: standalone hub
[    0.277864] hub 5-0:1.0: no power switching (usb 1.0)
[    0.277866] hub 5-0:1.0: individual port over-current protection
[    0.277867] hub 5-0:1.0: power on to power good time: 2ms
[    0.277870] hub 5-0:1.0: local power source is good
[    0.277872] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    0.277883] drivers/usb/core/inode.c: creating file '001'
[    0.277905] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.277982] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.277985] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.278062] drivers/usb/core/inode.c: creating file '006'
[    0.278107] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.278224] uhci_hcd 0000:00:1d.0: detected 2 ports
[    0.278295] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.278296] uhci_hcd 0000:00:1d.0: Performing full reset
[    0.278308] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    0.278312] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[    0.278402] usb usb6: default language 0x0409
[    0.278407] usb usb6: udev 1, busnum 6, minor = 640
[    0.278409] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.278482] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.278593] usb usb6: Product: UHCI Host Controller
[    0.278661] usb usb6: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    0.278731] usb usb6: SerialNumber: 0000:00:1d.0
[    0.278824] usb usb6: uevent
[    0.278856] usb usb6: usb_probe_device
[    0.278858] usb usb6: configuration #1 chosen from 1 choice
[    0.278930] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    0.278941] usb 6-0:1.0: uevent
[    0.278973] hub 6-0:1.0: usb_probe_interface
[    0.278975] hub 6-0:1.0: usb_probe_interface - got id
[    0.278976] hub 6-0:1.0: USB hub found
[    0.279051] hub 6-0:1.0: 2 ports detected
[    0.279116] hub 6-0:1.0: standalone hub
[    0.279118] hub 6-0:1.0: no power switching (usb 1.0)
[    0.279119] hub 6-0:1.0: individual port over-current protection
[    0.279121] hub 6-0:1.0: power on to power good time: 2ms
[    0.279124] hub 6-0:1.0: local power source is good
[    0.279125] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    0.279136] drivers/usb/core/inode.c: creating file '001'
[    0.279160]   alloc irq_desc for 20 on node -1
[    0.279162]   alloc kstat_irqs on node -1
[    0.279165] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    0.279241] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.279244] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.279316] drivers/usb/core/inode.c: creating file '007'
[    0.279359] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.279474] uhci_hcd 0000:00:1d.1: detected 2 ports
[    0.279544] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.279546] uhci_hcd 0000:00:1d.1: Performing full reset
[    0.279558] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    0.279568] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000d080
[    0.279661] usb usb7: default language 0x0409
[    0.279666] usb usb7: udev 1, busnum 7, minor = 768
[    0.279668] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.279741] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.279851] usb usb7: Product: UHCI Host Controller
[    0.279920] usb usb7: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    0.279990] usb usb7: SerialNumber: 0000:00:1d.1
[    0.280088] usb usb7: uevent
[    0.280120] usb usb7: usb_probe_device
[    0.280122] usb usb7: configuration #1 chosen from 1 choice
[    0.280198] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    0.280208] usb 7-0:1.0: uevent
[    0.280239] hub 7-0:1.0: usb_probe_interface
[    0.280240] hub 7-0:1.0: usb_probe_interface - got id
[    0.280242] hub 7-0:1.0: USB hub found
[    0.280310] hub 7-0:1.0: 2 ports detected
[    0.280376] hub 7-0:1.0: standalone hub
[    0.280377] hub 7-0:1.0: no power switching (usb 1.0)
[    0.280378] hub 7-0:1.0: individual port over-current protection
[    0.280380] hub 7-0:1.0: power on to power good time: 2ms
[    0.280383] hub 7-0:1.0: local power source is good
[    0.280385] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    0.280397] drivers/usb/core/inode.c: creating file '001'
[    0.280421] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.280497] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.280500] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.280571] drivers/usb/core/inode.c: creating file '008'
[    0.280617] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.280732] uhci_hcd 0000:00:1d.2: detected 2 ports
[    0.280802] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.280804] uhci_hcd 0000:00:1d.2: Performing full reset
[    0.280816] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    0.280820] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[    0.280910] usb usb8: default language 0x0409
[    0.280915] usb usb8: udev 1, busnum 8, minor = 896
[    0.280917] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.280991] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.281107] usb usb8: Product: UHCI Host Controller
[    0.281178] usb usb8: Manufacturer: Linux 2.6.31-rc3 uhci_hcd
[    0.281249] usb usb8: SerialNumber: 0000:00:1d.2
[    0.281341] usb usb8: uevent
[    0.281371] usb usb8: usb_probe_device
[    0.281373] usb usb8: configuration #1 chosen from 1 choice
[    0.281446] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    0.281459] usb 8-0:1.0: uevent
[    0.281490] hub 8-0:1.0: usb_probe_interface
[    0.281492] hub 8-0:1.0: usb_probe_interface - got id
[    0.281493] hub 8-0:1.0: USB hub found
[    0.281561] hub 8-0:1.0: 2 ports detected
[    0.281627] hub 8-0:1.0: standalone hub
[    0.281628] hub 8-0:1.0: no power switching (usb 1.0)
[    0.281630] hub 8-0:1.0: individual port over-current protection
[    0.281631] hub 8-0:1.0: power on to power good time: 2ms
[    0.281634] hub 8-0:1.0: local power source is good
[    0.281636] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    0.281647] drivers/usb/core/inode.c: creating file '001'
[    0.281732] usbcore: registered new interface driver usblp
[    0.281803] Initializing USB Mass Storage driver...
[    0.281923] usbcore: registered new interface driver usb-storage
[    0.281994] USB Mass Storage support registered.
[    0.282120] usbcore: registered new interface driver libusual
[    0.282328] PNP: No PS/2 controller found. Probing ports directly.
[    0.282472] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    0.284556] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.284628] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.284763] mice: PS/2 mouse device common for all mice
[    0.285052] rtc_cmos 00:03: RTC can wake from S4
[    0.285173] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.285264] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.285384] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.285804] cpuidle: using governor ladder
[    0.286260] cpuidle: using governor menu
[    0.287453] usbcore: registered new interface driver hiddev
[    0.287566] usbcore: registered new interface driver usbhid
[    0.287637] usbhid: v2.6:USB HID core driver
[    0.287754] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.288623]   alloc irq_desc for 22 on node -1
[    0.288625]   alloc kstat_irqs on node -1
[    0.288630] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.288764] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.323151] hda_codec: Unknown model for ALC888, trying auto-probe from BIOS...
[    0.349167] ALSA device list:
[    0.349232]   #0: HDA Intel at 0xfe9f4000 irq 22
[    0.349342] Netfilter messages via NETLINK v0.30.
[    0.349423] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.349691] ctnetlink v0.93: registering with nfnetlink.
[    0.350269] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.350355] TCP cubic registered
[    0.350419] Initializing XFRM netlink socket
[    0.350750] NET: Registered protocol family 10
[    0.351626] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.351743] IPv6 over IPv4 tunneling driver
[    0.352343] NET: Registered protocol family 17
[    0.352574] RPC: Registered udp transport module.
[    0.352643] RPC: Registered tcp transport module.
[    0.353209] Using IPI No-Shortcut mode
[    0.353411] PM: Resume from disk failed.
[    0.353421] registered taskstats version 1
[    0.353599]   Magic number: 1:624:812
[    0.358040] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
[    0.358046] hub 1-0:1.0: port 5: status 0501 change 0001
[    0.358057] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
[    0.358062] hub 1-0:1.0: port 6: status 0501 change 0001
[    0.374029] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[    0.374035] hub 2-0:1.0: port 3: status 0501 change 0001
[    0.375042] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.376038] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.377024] uhci_hcd 0000:00:1a.2: port 1 portsc 008a,00
[    0.377039] uhci_hcd 0000:00:1a.2: port 2 portsc 008a,00
[    0.379045] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.380024] uhci_hcd 0000:00:1d.1: port 1 portsc 0082,00
[    0.381038] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.457032] hub 1-0:1.0: state 7 ports 6 chg 0060 evt 0000
[    0.457042] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    0.457052] ehci_hcd 0000:00:1a.7: port 5 low speed --> companion
[    0.508038] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[    0.508061] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    0.508068] ehci_hcd 0000:00:1a.7: port 6 low speed --> companion
[    0.554696] ata4: SATA link down (SStatus 0 SControl 300)
[    0.565439] ata3: SATA link down (SStatus 0 SControl 300)
[    0.565443] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[    0.565458] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    0.565462] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[    0.565466] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    0.616313] ehci_hcd 0000:00:1d.7: port 3 high speed
[    0.616316] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    0.667031] usb 2-3: new high speed USB device using ehci_hcd and address 2
[    0.996080] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.996174] ata1.01: SATA link down (SStatus 0 SControl 300)
[    0.996408] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.996491] ata2.01: SATA link down (SStatus 0 SControl 300)
[    0.999393] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GH30N, A102, max UDMA/100
[    1.006236] ata2.00: configured for UDMA/100
[    1.027761] ata1.00: ATA-8: ST3320613AS, DE13, max UDMA/133
[    1.027844] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.076657] ata1.00: configured for UDMA/133
[    1.076824] scsi 0:0:0:0: Direct-Access     ATA      ST3320613AS      DE13 PQ: 0 ANSI: 5
[    1.077154] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.077302] sd 0:0:0:0: [sda] Write Protect is off
[    1.077372] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.077388] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.077595]  sda:
[    1.077711] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.079114] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GH30N    A102 PQ: 0 ANSI: 5
[    1.082929] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.083071] Uniform CD-ROM driver Revision: 3.20
[    1.083259] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.083348] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.110395]  sda1 sda2 sda3 sda4
[    1.146562] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.146653] Freeing unused kernel memory: 360k freed
[    1.146897] Write protecting the kernel text: 4068k
[    1.147012] Write protecting the kernel read-only data: 1788k
[    1.163338] usb usb3: uevent
[    1.163353] usb 3-0:1.0: uevent
[    1.163393] usb usb4: uevent
[    1.163407] usb 4-0:1.0: uevent
[    1.163446] usb usb5: uevent
[    1.163461] usb 5-0:1.0: uevent
[    1.163500] usb usb1: uevent
[    1.163516] usb 1-0:1.0: uevent
[    1.163907] usb usb6: uevent
[    1.163921] usb 6-0:1.0: uevent
[    1.163960] usb usb7: uevent
[    1.163974] usb 7-0:1.0: uevent
[    1.164023] usb usb8: uevent
[    1.164038] usb 8-0:1.0: uevent
[    1.164077] usb usb2: uevent
[    1.164093] usb 2-0:1.0: uevent
[    1.211050] udevd used greatest stack depth: 6500 bytes left
[    1.228441] ehci_hcd 0000:00:1d.7: port 3 high speed
[    1.228446] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.353710] usb 2-3: default language 0x0409
[    1.359211] usb 2-3: udev 2, busnum 2, minor = 129
[    1.359215] usb 2-3: New USB device found, idVendor=0bda, idProduct=0151
[    1.359303] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.359387] usb 2-3: Product: USB2.0-CRW
[    1.359454] usb 2-3: Manufacturer: Generic
[    1.359521] usb 2-3: SerialNumber: 20060413092100000
[    1.359649] usb 2-3: uevent
[    1.359664] usb 2-3: usb_probe_device
[    1.359667] usb 2-3: configuration #1 chosen from 1 choice
[    1.360334] usb 2-3: adding 2-3:1.0 (config #1, interface 0)
[    1.361084] usb 2-3:1.0: uevent
[    1.361113] usb-storage 2-3:1.0: usb_probe_interface
[    1.361121] usb-storage 2-3:1.0: usb_probe_interface - got id
[    1.361366] scsi4 : SCSI emulation for USB Mass Storage devices
[    1.361804] usb-storage: device found at 2
[    1.361805] usb-storage: waiting for device to settle before scanning
[    1.361822] drivers/usb/core/inode.c: creating file '002'
[    1.361839] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    1.361846] uhci_hcd 0000:00:1a.2: port 1 portsc 01a3,00
[    1.361852] hub 5-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    1.454030] usb usb3: suspend_rh (auto-stop)
[    1.454053] usb usb4: suspend_rh (auto-stop)
[    1.454074] usb usb6: suspend_rh (auto-stop)
[    1.454096] usb usb8: suspend_rh (auto-stop)
[    1.454126] usb usb7: suspend_rh (auto-stop)
[    1.465036] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    1.567031] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    1.642488] kjournald starting.  Commit interval 5 seconds
[    1.642508] EXT3-fs: mounted filesystem with writeback data mode.
[    1.737182] usb 5-1: skipped 1 descriptor after interface
[    1.737187] usb 5-1: skipped 1 descriptor after interface
[    1.743174] usb 5-1: default language 0x0409
[    1.767176] usb 5-1: udev 2, busnum 5, minor = 513
[    1.767180] usb 5-1: New USB device found, idVendor=0d62, idProduct=2106
[    1.767264] usb 5-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    1.767348] usb 5-1: Product: USB Multimedia Keyboard
[    1.767472] usb 5-1: uevent
[    1.767484] usb 5-1: usb_probe_device
[    1.767486] usb 5-1: configuration #1 chosen from 1 choice
[    1.770181] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    1.770210] usb 5-1:1.0: uevent
[    1.770242] usbhid 5-1:1.0: usb_probe_interface
[    1.770245] usbhid 5-1:1.0: usb_probe_interface - got id
[    1.801438] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input2
[    1.801564] uhci_hcd 0000:00:1a.2: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    1.801601] generic-usb 0003:0D62:2106.0001: input,hidraw0: USB HID v1.10 Keyboard [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input0
[    1.801733] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[    1.801746] usb 5-1:1.1: uevent
[    1.801760] usbhid 5-1:1.1: usb_probe_interface
[    1.801762] usbhid 5-1:1.1: usb_probe_interface - got id
[    1.841258] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.1/input/input3
[    1.841390] uhci_hcd 0000:00:1a.2: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    1.841422] generic-usb 0003:0D62:2106.0002: input,hidraw1: USB HID v1.10 Device [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input1
[    1.841554] drivers/usb/core/inode.c: creating file '002'
[    1.841572] uhci_hcd 0000:00:1a.2: port 2 portsc 01a3,00
[    1.841577] hub 5-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    1.945036] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    2.047029] usb 5-2: new low speed USB device using uhci_hcd and address 3
[    2.083045] async/1 used greatest stack depth: 6492 bytes left
[    2.180038] stty used greatest stack depth: 6236 bytes left
[    2.188180] usb 5-2: skipped 1 descriptor after interface
[    2.193173] usb 5-2: default language 0x0409
[    2.208177] usb 5-2: udev 3, busnum 5, minor = 514
[    2.208182] usb 5-2: New USB device found, idVendor=413c, idProduct=3012
[    2.208267] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.208350] usb 5-2: Product: Dell USB Optical Mouse
[    2.208419] usb 5-2: Manufacturer: Dell
[    2.208538] usb 5-2: uevent
[    2.208550] usb 5-2: usb_probe_device
[    2.208552] usb 5-2: configuration #1 chosen from 1 choice
[    2.211177] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    2.211202] usb 5-2:1.0: uevent
[    2.211231] usbhid 5-2:1.0: usb_probe_interface
[    2.211235] usbhid 5-2:1.0: usb_probe_interface - got id
[    2.224392] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input4
[    2.224561] generic-usb 0003:413C:3012.0003: input,hidraw2: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.2-2/input0
[    2.224694] drivers/usb/core/inode.c: creating file '003'
[    2.224710] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.224714] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.701039] hub 3-0:1.0: hub_suspend
[    2.701049] usb usb3: bus auto-suspend
[    2.701053] usb usb3: suspend_rh
[    2.701070] hub 4-0:1.0: hub_suspend
[    2.701074] usb usb4: bus auto-suspend
[    2.701077] usb usb4: suspend_rh
[    2.701093] hub 6-0:1.0: hub_suspend
[    2.701098] usb usb6: bus auto-suspend
[    2.701101] usb usb6: suspend_rh
[    2.701116] hub 8-0:1.0: hub_suspend
[    2.701120] usb usb8: bus auto-suspend
[    2.701123] usb usb8: suspend_rh
[    2.701146] hub 1-0:1.0: hub_suspend
[    2.701149] usb usb1: bus auto-suspend
[    2.701151] ehci_hcd 0000:00:1a.7: suspend root hub
[    3.645823] udevd used greatest stack depth: 6192 bytes left
[    3.645847] udev: starting version 141
[    3.662914] usb usb3: uevent
[    3.662931] usb 3-0:1.0: uevent
[    3.662975] usb usb4: uevent
[    3.662989] usb 4-0:1.0: uevent
[    3.663048] usb usb5: uevent
[    3.663062] usb 5-0:1.0: uevent
[    3.663080] usb 5-1: uevent
[    3.663095] usb 5-1:1.0: uevent
[    3.663191] usb 5-1:1.1: uevent
[    3.663276] usb 5-2: uevent
[    3.663291] usb 5-2:1.0: uevent
[    3.663408] usb usb1: uevent
[    3.663423] usb 1-0:1.0: uevent
[    3.663822] usb usb6: uevent
[    3.663836] usb 6-0:1.0: uevent
[    3.663875] usb usb7: uevent
[    3.663889] usb 7-0:1.0: uevent
[    3.663931] usb usb8: uevent
[    3.663945] usb 8-0:1.0: uevent
[    3.663985] usb usb2: uevent
[    3.664018] usb 2-0:1.0: uevent
[    3.664037] usb 2-3: uevent
[    3.664052] usb 2-3:1.0: uevent
[    3.767241] scsi_id used greatest stack depth: 5984 bytes left
[    4.216317] usb 5-2:1.0: uevent
[    4.216402] usb 5-2: uevent
[    4.217115] usb 5-2:1.0: uevent
[    4.217206] usb 5-2: uevent
[    4.221545] usb 5-1:1.0: uevent
[    4.221632] usb 5-1: uevent
[    4.222617] usb 5-1:1.1: uevent
[    4.222699] usb 5-1: uevent
[    4.701152] hub 7-0:1.0: hub_suspend
[    4.701158] usb usb7: bus auto-suspend
[    4.701160] usb usb7: suspend_rh
[    4.730192] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    4.756083] EXT3 FS on sda3, internal journal
[    4.880196] EXT4-fs (sda2): barriers enabled
[    4.890826] kjournald2 starting: pid 3021, dev sda2:8, commit interval 5 seconds
[    4.890840] EXT4-fs (sda2): delayed allocation enabled
[    4.890845] EXT4-fs: file extents enabled
[    4.902943] EXT4-fs: mballoc enabled
[    4.902956] EXT4-fs (sda2): mounted filesystem with ordered data mode
[    4.922371] Adding 8426084k swap on /dev/sda4.  Priority:-1 extents:1 across:8426084k 
[    6.367478] scsi 4:0:0:0: Direct-Access     Generic- Compact Flash    1.00 PQ: 0 ANSI: 0 CCS
[    6.367599] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    6.367769] usb-storage: device scan complete
[    6.370841] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    6.371383] usb 2-3:1.0: uevent
[    6.371478] usb 2-3: uevent
[    9.712352] usb usb3: uevent
[    9.712415] usb 3-0:1.0: uevent
[    9.712532] usb usb4: uevent
[    9.712796] usb 4-0:1.0: uevent
[    9.712909] usb usb5: uevent
[    9.712955] usb 5-0:1.0: uevent
[    9.712997] usb 5-1: uevent
[    9.713060] usb 5-1:1.0: uevent
[    9.713325] usb 5-1:1.1: uevent
[    9.713562] usb 5-2: uevent
[    9.713611] usb 5-2:1.0: uevent
[    9.714018] usb usb1: uevent
[    9.714067] usb 1-0:1.0: uevent
[    9.715210] usb usb6: uevent
[    9.715258] usb 6-0:1.0: uevent
[    9.715384] usb usb7: uevent
[    9.715432] usb 7-0:1.0: uevent
[    9.715545] usb usb8: uevent
[    9.715592] usb 8-0:1.0: uevent
[    9.715704] usb usb2: uevent
[    9.715751] usb 2-0:1.0: uevent
[    9.715792] usb 2-3: uevent
[    9.715841] usb 2-3:1.0: uevent
[   10.324861] r8169: eth0: link up
[   10.324866] r8169: eth0: link up
[   12.681063] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18040300
[   13.345036] uhci_hcd 0000:00:1a.2: reserve dev 3 ep81-INT, period 8, phase 4, 99 us
[   21.099012] eth0: no IPv6 routers present
[   24.856272] kbuildsycoca4 used greatest stack depth: 5932 bytes left
[  647.863666] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  647.885671] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  648.260648] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  656.139414] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  656.204819] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  656.947160] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  660.352317] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  660.357268] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  660.361393] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  660.363695] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  660.368054] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  660.370975] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  660.374293] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  660.396250] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  675.657325] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  675.824246] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  675.871964] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  676.467500] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  676.485221] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  676.508445] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  677.686706] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  677.731035] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  678.128193] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  678.212792] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  678.887924] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  678.980665] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  678.982497] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  679.238602] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  679.241093] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  681.611027] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  682.473950] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  682.493363] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  682.510793] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  683.167314] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  683.169524] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  683.327292] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  683.464032] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  683.517369] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  683.524216] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  683.742244] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  684.194065] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  684.195705] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  684.427169] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  684.759288] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  684.918269] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  684.933086] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  684.934791] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  684.936825] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  685.065607] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  685.076453] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  685.536887] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  685.692553] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  687.879713] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  687.981080] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  688.004782] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  688.575674] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  688.604505] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  688.832754] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  688.834547] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  688.837744] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  688.928431] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  688.931023] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.073285] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.396707] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.399360] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.423194] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.475548] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  689.481255] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.485468] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.490422] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.494559] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  689.617688] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  690.013301] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  690.126736] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  690.324112] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  690.404508] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  690.408701] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  690.886157] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  690.968433] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.218419] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.224472] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.231118] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.233029] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.250880] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.253499] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.256401] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.263500] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.267485] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.271893] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.275512] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.361010] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  691.572444] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.575114] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.603741] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.631105] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.713413] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  691.729269] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.737771] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  691.740330] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.748603] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.751137] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  691.753316] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.762086] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.765936] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.767952] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.772001] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.773590] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.773895] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  691.775020] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  691.778892] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.782003] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.811378] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.835917] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.836980] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  691.842113] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  691.845760] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.135159] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.180229] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.272932] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.420974] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.459281] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.473393] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.834610] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  692.898867] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  692.900855] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  693.555056] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  694.036736] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  694.038886] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  694.044803] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  694.047507] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  694.050457] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  694.053374] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  694.072999] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  694.095058] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  694.116814] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  694.322999] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  694.356875] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  694.363456] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  694.364733] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  694.856074] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  695.131046] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  695.860581] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  695.975725] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  695.977936] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  696.188775] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  696.585293] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  696.596346] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  696.600958] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  696.604774] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  696.786745] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  696.805615] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  696.827006] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  697.216062] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  697.675391] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  697.677993] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  697.681003] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  697.692645] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  697.695763] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  697.766158] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  697.768656] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  697.771024] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  697.772421] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  697.777719] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  697.818274] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  698.020908] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  698.156274] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  698.217320] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  698.223086] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  698.225867] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  698.238880] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x18200300
[  698.312466] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  698.315852] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  698.936984] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  699.112996] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300
[  699.121130] [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat 0x10200300

--Boundary-00=_Mm6ZKNulzHTDV1K--
