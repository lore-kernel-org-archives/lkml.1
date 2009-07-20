Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZGTWtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZGTWtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZGTWtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:49:08 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:34695 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZGTWs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=gBvcJNSbCNa2HzezrQjJdIaE0y9xc+K/pxNZQ3QjBMFfihVS9cxK91nxKTyAnnazpy
         U5DvdQCdpx5U6t0LyRqZTnPgSRfDDxHqTdpEU5f2UH9rXVd+mN2GifAJ6xUkjaFfHD3k
         fp/c8x2MsMkSaLhXI56MoqpkfQ3OS2Xt7rW0Q=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Alberto Gonzalez <alberto6674@gmail.com>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Tue, 21 Jul 2009 00:48:36 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <20090720111010.28bf7b76@jbarnes-g45> <200907202306.52305.info@gnebu.es>
In-Reply-To: <200907202306.52305.info@gnebu.es>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FRPZKJAZyWPSkuP"
Message-Id: <200907210048.37432.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_FRPZKJAZyWPSkuP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 20 July 2009 23:06:51 Alberto Gonzalez wrote:
> On Monday 20 July 2009 20:10:10 Jesse Barnes wrote:
> > Alberto Gonzalez <alberto6674@gmail.com> wrote:
> > > I now tried a vanilla 2.6.30.1 kernel with a custom config (so I
> > > don't have to wait 45 minutes for it to compile) and I still see the
> > > problem. This is what I get in dmesg:
> > >
> > > [   83.506496] ------------[ cut here ]------------
> > > [   83.506500] WARNING: at drivers/gpu/drm/drm_sysfs.c:452
> > > drm_sysfs_hotplug_event+0x2b/0x63()
> > > [   83.506502] Hardware name: Studio 540
> > > [   83.506503] hotplug uevent
> > > [   83.506504] Modules linked in:
> > > [   83.506506] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
> > > [   83.506507] Call Trace:
> > > [   83.506511]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
> > > [   83.506514]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
> > > [   83.506517]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
> > > [   83.506520]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
> > > [   83.506523]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
> > > [   83.506525]  [<c1032f28>] worker_thread+0x131/0x1ab
> > > [   83.506528]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
> > > [   83.506531]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
> > > [   83.506534]  [<c1032df7>] ? worker_thread+0x0/0x1ab
> > > [   83.506536]  [<c1035c84>] kthread+0x46/0x6a
> > > [   83.506538]  [<c1035c3e>] ? kthread+0x0/0x6a
> > > [   83.506541]  [<c10033cf>] kernel_thread_helper+0x7/0x10
> > > [   83.506542] ---[ end trace 08f91010f92f7c3c ]---
> >
> > Sorry I missed this update; what about the register dump part of the
> > patch?  Presumably you get a ton of these in your log, but with some
> > IIR register info beforehand?
>
> The problem is that when this happens I get these messages at a very high
> rate, so they flood my dmesg in a few seconds. Is there a way I could
> access that register dump that should precede them?

I've managed to get something hopefully more meaningful. First is the normal 
boot log with just a few of these messages at the end (this is before the 
"storm" starts). Then the dmesg once the problem triggers.

If what you need is the exact lines just before the "storm" starts let me know 
and I'll keep trying, but it's not easy because I'll have to be very fast in 
detecting the problem has started and logging the output of dmesg.

>
> Thanks,
> Alberto.


--Boundary-00=_FRPZKJAZyWPSkuP
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg1.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30.1 (root@localhost) (gcc version 4.4.0 20090630 (prerelease) (GCC) ) #1 SMP Sat Jul 4 22:19:30 CEST 2009
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
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37fa0000 - 37fefc1e
[    0.000000] Allocated new RAMDISK: 00008000 - 00057c1e
[    0.000000] Move RAMDISK from 0000000037fa0000 - 0000000037fefc1d to 00008000 - 00057c1d
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
[    0.000000]   #3 [0001000000 - 00016f1500]    TEXT DATA BSS ==> [0001000000 - 00016f1500]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [00016f2000 - 00016f90e0]              BRK ==> [00016f2000 - 00016f90e0]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 0000057c1e]      NEW RAMDISK ==> [0000008000 - 0000057c1e]
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
[    0.000000] free_area_init_node: node 0, pgdat c15d6500, node_mem_map c16fa000
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
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages at c300a000, static data 23772 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 812079
[    0.000000] Kernel command line: root=/dev/disk/by-uuid/2bfe816c-08ba-4962-9cb7-f54396fba685 ro init 3 enable_mtrr_cleanup
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2499.967 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Initializing HighMem for node 0 (000377fe:000c7d90)
[    0.000999] Memory: 3238812k/3274304k available (3880k kernel code, 34196k reserved, 2157k data, 344k init, 2365000k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc15ed000 - 0xc1643000   ( 344 kB)
[    0.000999]       .data : 0xc13ca3d9 - 0xc15e5b4c   (2157 kB)
[    0.000999]       .text : 0xc1000000 - 0xc13ca3d9   (3880 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4999.93 BogoMIPS (lpj=2499967)
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
[    0.001008] Intel machine check architecture supported.
[    0.001077] Intel machine check reporting enabled on CPU#0.
[    0.001147] using mwait in idle threads.
[    0.001217] Checking 'hlt' instruction... OK.
[    0.005485] ACPI: Core revision 20090320
[    0.013361] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023711] CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.023996] APIC calibration not consistent with PM-Timer: 119ms instead of 100ms
[    0.023996] APIC delta adjusted to PM-Timer: 1250043 (1500035)
[    0.023996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 5000.03 BogoMIPS (lpj=2500015)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.095343] CPU1: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
[    0.096138] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.097003] Brought up 2 CPUs
[    0.097987] Total of 2 processors activated (9999.96 BogoMIPS).
[    0.098130] khelper used greatest stack depth: 7048 bytes left
[    0.098130] net_namespace: 1028 bytes
[    0.098130] Time:  0:31:07  Date: 07/21/09
[    0.098130] NET: Registered protocol family 16
[    0.099008] ACPI: bus type pci registered
[    0.099080] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.099089] PCI: Not using MMCONFIG.
[    0.099289] PCI: Using configuration type 1 for base access
[    0.104154] bio: create slab <bio-0> at 0
[    0.105516] ACPI: EC: Look up EC in DSDT
[    0.111422] ACPI: Interpreter enabled
[    0.111489] ACPI: (supports S0 S1 S3 S4 S5)
[    0.111665] ACPI: Using IOAPIC for interrupt routing
[    0.111778] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.113224] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.113298] PCI: Using MMCONFIG for extended config space
[    0.120522] ACPI: No dock devices found.
[    0.120771] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.120863] pci 0000:00:02.0: reg 10 64bit mmio: [0xfe400000-0xfe7fffff]
[    0.120863] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.120863] pci 0000:00:02.0: reg 20 io port: [0xdc00-0xdc07]
[    0.120863] pci 0000:00:02.1: reg 10 64bit mmio: [0xfe800000-0xfe8fffff]
[    0.121056] pci 0000:00:1a.0: reg 20 io port: [0xd880-0xd89f]
[    0.121119] pci 0000:00:1a.1: reg 20 io port: [0xd800-0xd81f]
[    0.121180] pci 0000:00:1a.2: reg 20 io port: [0xd480-0xd49f]
[    0.121245] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe9fbc00-0xfe9fbfff]
[    0.121295] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.121368] pci 0000:00:1a.7: PME# disabled
[    0.121469] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe9f4000-0xfe9f7fff]
[    0.121506] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.121579] pci 0000:00:1b.0: PME# disabled
[    0.121695] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.121768] pci 0000:00:1c.0: PME# disabled
[    0.121884] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.121956] pci 0000:00:1c.2: PME# disabled
[    0.122034] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.122106] pci 0000:00:1c.5: PME# disabled
[    0.122218] pci 0000:00:1d.0: reg 20 io port: [0xd400-0xd41f]
[    0.122280] pci 0000:00:1d.1: reg 20 io port: [0xd080-0xd09f]
[    0.122342] pci 0000:00:1d.2: reg 20 io port: [0xd000-0xd01f]
[    0.122407] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe9fb800-0xfe9fbbff]
[    0.122457] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.122529] pci 0000:00:1d.7: PME# disabled
[    0.122703] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.122816] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.122890] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.123029] pci 0000:00:1f.2: reg 10 io port: [0xcc00-0xcc07]
[    0.123035] pci 0000:00:1f.2: reg 14 io port: [0xc880-0xc883]
[    0.123040] pci 0000:00:1f.2: reg 18 io port: [0xc800-0xc807]
[    0.123045] pci 0000:00:1f.2: reg 1c io port: [0xc480-0xc483]
[    0.123050] pci 0000:00:1f.2: reg 20 io port: [0xc400-0xc40f]
[    0.123055] pci 0000:00:1f.2: reg 24 io port: [0xc080-0xc08f]
[    0.123096] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe9fb400-0xfe9fb4ff]
[    0.123108] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.123146] pci 0000:00:1f.5: reg 10 io port: [0xbc00-0xbc07]
[    0.123152] pci 0000:00:1f.5: reg 14 io port: [0xb880-0xb883]
[    0.123157] pci 0000:00:1f.5: reg 18 io port: [0xb800-0xb807]
[    0.123162] pci 0000:00:1f.5: reg 1c io port: [0xb480-0xb483]
[    0.123167] pci 0000:00:1f.5: reg 20 io port: [0xb400-0xb40f]
[    0.123172] pci 0000:00:1f.5: reg 24 io port: [0xb080-0xb08f]
[    0.123283] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.123294] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.123320] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.123330] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.123421] pci 0000:00:1c.2: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.123467] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.123486] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]
[    0.123499] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.123506] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.123543] pci 0000:03:00.0: supports D1 D2
[    0.123544] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.123619] pci 0000:03:00.0: PME# disabled
[    0.123731] pci 0000:00:1c.5: bridge io port: [0xe000-0xefff]
[    0.123735] pci 0000:00:1c.5: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.123740] pci 0000:00:1c.5: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.123783] pci 0000:00:1e.0: transparent bridge
[    0.123871] pci_bus 0000:00: on NUMA node 0
[    0.123876] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.124063] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.124127] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.124177] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.124224] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.140107] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.140442] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.141024] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.141405] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.141786] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.142153] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.142534] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.142916] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.143254] SCSI subsystem initialized
[    0.143254] libata version 3.00 loaded.
[    0.143254] usbcore: registered new interface driver usbfs
[    0.143254] usbcore: registered new interface driver hub
[    0.143254] usbcore: registered new device driver usb
[    0.143996] PCI: Using ACPI for IRQ routing
[    0.146987] NetLabel: Initializing
[    0.147059] NetLabel:  domain hash size = 128
[    0.147134] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.147209] NetLabel:  unlabeled traffic allowed by default
[    0.147285] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.147285] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.154988] pnp: PnP ACPI init
[    0.155068] ACPI: bus type pnp registered
[    0.157087] pnp: PnP ACPI: found 12 devices
[    0.157154] ACPI: ACPI bus type pnp unregistered
[    0.157229] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.157303] system 00:01: iomem range 0xfed90000-0xfed93fff has been reserved
[    0.157381] system 00:06: ioport range 0xa00-0xadf has been reserved
[    0.157455] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.157527] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.157599] system 00:07: ioport range 0x500-0x57f could not be reserved
[    0.157672] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.157747] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.157822] system 00:07: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.157898] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.157973] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.158053] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.158130] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.158204] system 00:0b: iomem range 0xc0000-0xcffff could not be reserved
[    0.158277] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
[    0.158351] system 00:0b: iomem range 0x100000-0xc7dfffff could not be reserved
[    0.158463] system 00:0b: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.193506] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.193576] pci 0000:00:1c.0:   IO window: disabled
[    0.193647] pci 0000:00:1c.0:   MEM window: disabled
[    0.193716] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.193789] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.193859] pci 0000:00:1c.2:   IO window: disabled
[    0.193930] pci 0000:00:1c.2:   MEM window: 0xfea00000-0xfeafffff
[    0.194005] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.194078] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:03
[    0.194150] pci 0000:00:1c.5:   IO window: 0xe000-0xefff
[    0.194221] pci 0000:00:1c.5:   MEM window: 0xfeb00000-0xfebfffff
[    0.194293] pci 0000:00:1c.5:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.194408] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.194477] pci 0000:00:1e.0:   IO window: disabled
[    0.194547] pci 0000:00:1e.0:   MEM window: disabled
[    0.194617] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.194696]   alloc irq_desc for 17 on cpu 0 node 0
[    0.194697]   alloc kstat_irqs on cpu 0 node 0
[    0.194701] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.194777] pci 0000:00:1c.0: setting latency timer to 64
[    0.194783]   alloc irq_desc for 18 on cpu 0 node 0
[    0.194784]   alloc kstat_irqs on cpu 0 node 0
[    0.194787] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.194860] pci 0000:00:1c.2: setting latency timer to 64
[    0.194866]   alloc irq_desc for 16 on cpu 0 node 0
[    0.194867]   alloc kstat_irqs on cpu 0 node 0
[    0.194870] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.194944] pci 0000:00:1c.5: setting latency timer to 64
[    0.194949] pci 0000:00:1e.0: setting latency timer to 64
[    0.194952] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.194954] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.194957] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.194959] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.194961] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.194963] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.194965] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.194967] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffff]
[    0.194992] NET: Registered protocol family 2
[    0.204061] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.204338] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.204818] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.205092] TCP: Hash tables configured (established 131072 bind 65536)
[    0.205164] TCP reno registered
[    0.207094] NET: Registered protocol family 1
[    0.207213] Trying to unpack rootfs image as initramfs...
[    0.215429] Freeing initrd memory: 319k freed
[    0.215975] Machine check exception polling timer started.
[    0.216456] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.216568] Scanning for low memory corruption every 60 seconds
[    0.216884] audit: initializing netlink socket (disabled)
[    0.216965] type=2000 audit(1248136266.216:1): initialized
[    0.226911] highmem bounce pool size: 64 pages
[    0.226981] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.229215] VFS: Disk quotas dquot_6.5.2
[    0.229346] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.230311] msgmni has been set to 1709
[    0.230463] SELinux:  Registering netfilter hooks
[    0.230739] alg: No test for stdrng (krng)
[    0.230889] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.231007] io scheduler noop registered
[    0.231072] io scheduler anticipatory registered
[    0.231139] io scheduler deadline registered
[    0.231256] io scheduler cfq registered (default)
[    0.231333] pci 0000:00:02.0: Boot video device
[    0.231339] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.231341] pci 0000:00:1a.0: Performing full reset
[    0.231356] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.231358] pci 0000:00:1a.1: Performing full reset
[    0.231372] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.231373] pci 0000:00:1a.2: Performing full reset
[    0.231406] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.231407] pci 0000:00:1d.0: Performing full reset
[    0.231421] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.231423] pci 0000:00:1d.1: Performing full reset
[    0.231436] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.231438] pci 0000:00:1d.2: Performing full reset
[    0.231579]   alloc irq_desc for 24 on cpu 0 node 0
[    0.231580]   alloc kstat_irqs on cpu 0 node 0
[    0.231589] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.231601] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.231758]   alloc irq_desc for 25 on cpu 0 node 0
[    0.231760]   alloc kstat_irqs on cpu 0 node 0
[    0.231766] pcieport-driver 0000:00:1c.2: irq 25 for MSI/MSI-X
[    0.231777] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.231930]   alloc irq_desc for 26 on cpu 0 node 0
[    0.231932]   alloc kstat_irqs on cpu 0 node 0
[    0.231937] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.231948] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.232145] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.232438] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.232548] ACPI: Power Button [PWRF]
[    0.232683] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.232795] ACPI: Power Button [PWRB]
[    0.233271] ACPI: SSDT c7da00f0 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.233666] ACPI: SSDT c7da05f0 004B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.234063] Monitor-Mwait will be used to enter C-1 state
[    0.234082] Monitor-Mwait will be used to enter C-2 state
[    0.234089] Marking TSC unstable due to TSC halts in idle
[    0.234174] Switched to high resolution mode on CPU 0
[    0.234204] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    0.234366] processor ACPI_CPU:00: registered as cooling_device0
[    0.234714] ACPI: SSDT c7da0370 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[    0.234956] Switched to high resolution mode on CPU 1
[    0.235107] ACPI: SSDT c7da0ab0 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    0.235589] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    0.235748] processor ACPI_CPU:01: registered as cooling_device1
[    0.240240] Non-volatile memory driver v1.3
[    0.240387] Linux agpgart interface v0.103
[    0.240503] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    0.241255] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    0.243252] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.243414] [drm] Initialized drm 1.1.0 20060810
[    0.243532] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.243605] pci 0000:00:02.0: setting latency timer to 64
[    0.244697] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    0.244815] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.244902]   alloc irq_desc for 27 on cpu 0 node 0
[    0.244904]   alloc kstat_irqs on cpu 0 node 0
[    0.244912] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.244926] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.245021] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.247023] brd: module loaded
[    0.247757] loop: module loaded
[    0.247918] Driver 'sd' needs updating - please use bus_type methods
[    0.248058] Driver 'sr' needs updating - please use bus_type methods
[    0.248255] ata_piix 0000:00:1f.2: version 2.13
[    0.248271]   alloc irq_desc for 19 on cpu 0 node 0
[    0.248272]   alloc kstat_irqs on cpu 0 node 0
[    0.248277] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.248352] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.248547] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.248598] scsi0 : ata_piix
[    0.248790] scsi1 : ata_piix
[    0.250099] ata1: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    0.250179] ata2: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    0.250268] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.250354] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    0.250541] ata_piix 0000:00:1f.5: setting latency timer to 64
[    0.250587] scsi2 : ata_piix
[    0.250734] scsi3 : ata_piix
[    0.251761] ata3: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    0.252547] ata4: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    0.252813] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    0.252885] Copyright (c) 1999-2006 Intel Corporation.
[    0.252990] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    0.253068] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    0.253178] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.253249] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.253392] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.253470] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.253553] r8169 0000:03:00.0: setting latency timer to 64
[    0.253615]   alloc irq_desc for 28 on cpu 0 node 0
[    0.253617]   alloc kstat_irqs on cpu 0 node 0
[    0.253627] r8169 0000:03:00.0: irq 28 for MSI/MSI-X
[    0.253839] eth0: RTL8168c/8111c at 0xf8056000, 00:21:70:4c:c3:ac, XID 3c4000c0 IRQ 28
[    0.256738] console [netcon0] enabled
[    0.256802] netconsole: network logging started
[    0.256997] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.257075] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    0.257090] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.257174] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.257177] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.257293] drivers/usb/core/inode.c: creating file 'devices'
[    0.257296] drivers/usb/core/inode.c: creating file '001'
[    0.257340] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.257456] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.257460] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.257476] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.261353] ehci_hcd 0000:00:1a.7: debug port 1
[    0.261423] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.261425] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.261435] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe9fbc00
[    0.261507] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.265375] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.272012] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.272126] usb usb1: default language 0x0409
[    0.272139] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.272212] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.272321] usb usb1: Product: EHCI Host Controller
[    0.272390] usb usb1: Manufacturer: Linux 2.6.30.1 ehci_hcd
[    0.272459] usb usb1: SerialNumber: 0000:00:1a.7
[    0.272552] usb usb1: uevent
[    0.272587] usb usb1: usb_probe_device
[    0.272589] usb usb1: configuration #1 chosen from 1 choice
[    0.272662] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.272673] usb 1-0:1.0: uevent
[    0.272706] hub 1-0:1.0: usb_probe_interface
[    0.272707] hub 1-0:1.0: usb_probe_interface - got id
[    0.272709] hub 1-0:1.0: USB hub found
[    0.272778] hub 1-0:1.0: 6 ports detected
[    0.272843] hub 1-0:1.0: standalone hub
[    0.272844] hub 1-0:1.0: no power switching (usb 1.0)
[    0.272846] hub 1-0:1.0: individual port over-current protection
[    0.272848] hub 1-0:1.0: power on to power good time: 20ms
[    0.272851] hub 1-0:1.0: local power source is good
[    0.272853] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.272943] drivers/usb/core/inode.c: creating file '001'
[    0.272998]   alloc irq_desc for 23 on cpu 0 node 0
[    0.273000]   alloc kstat_irqs on cpu 0 node 0
[    0.273008] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.273088] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.273091] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.273198] drivers/usb/core/inode.c: creating file '002'
[    0.273244] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.273357] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.273361] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.273372] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.277251] ehci_hcd 0000:00:1d.7: debug port 1
[    0.277321] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.277323] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    0.277332] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe9fb800
[    0.277404] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.281275] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.287013] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.287111] usb usb2: default language 0x0409
[    0.287122] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.287205] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.287316] usb usb2: Product: EHCI Host Controller
[    0.287384] usb usb2: Manufacturer: Linux 2.6.30.1 ehci_hcd
[    0.287454] usb usb2: SerialNumber: 0000:00:1d.7
[    0.287546] usb usb2: uevent
[    0.287579] usb usb2: usb_probe_device
[    0.287581] usb usb2: configuration #1 chosen from 1 choice
[    0.287654] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    0.287665] usb 2-0:1.0: uevent
[    0.287696] hub 2-0:1.0: usb_probe_interface
[    0.287697] hub 2-0:1.0: usb_probe_interface - got id
[    0.287699] hub 2-0:1.0: USB hub found
[    0.287767] hub 2-0:1.0: 6 ports detected
[    0.287833] hub 2-0:1.0: standalone hub
[    0.287834] hub 2-0:1.0: no power switching (usb 1.0)
[    0.287835] hub 2-0:1.0: individual port over-current protection
[    0.287837] hub 2-0:1.0: power on to power good time: 20ms
[    0.287840] hub 2-0:1.0: local power source is good
[    0.287842] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    0.287899] drivers/usb/core/inode.c: creating file '001'
[    0.287976] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.288054] ohci_hcd: block sizes: ed 64 td 64
[    0.288089] uhci_hcd: USB Universal Host Controller Interface driver
[    0.288185] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.288261] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.288264] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.288373] drivers/usb/core/inode.c: creating file '003'
[    0.288414] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.288527] uhci_hcd 0000:00:1a.0: detected 2 ports
[    0.288598] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.288599] uhci_hcd 0000:00:1a.0: Performing full reset
[    0.288612] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    0.288621] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
[    0.288712] usb usb3: default language 0x0409
[    0.288717] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.288790] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.288900] usb usb3: Product: UHCI Host Controller
[    0.288969] usb usb3: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.289053] usb usb3: SerialNumber: 0000:00:1a.0
[    0.289145] usb usb3: uevent
[    0.289174] usb usb3: usb_probe_device
[    0.289176] usb usb3: configuration #1 chosen from 1 choice
[    0.289248] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    0.289259] usb 3-0:1.0: uevent
[    0.289288] hub 3-0:1.0: usb_probe_interface
[    0.289290] hub 3-0:1.0: usb_probe_interface - got id
[    0.289292] hub 3-0:1.0: USB hub found
[    0.289360] hub 3-0:1.0: 2 ports detected
[    0.289425] hub 3-0:1.0: standalone hub
[    0.289427] hub 3-0:1.0: no power switching (usb 1.0)
[    0.289428] hub 3-0:1.0: individual port over-current protection
[    0.289430] hub 3-0:1.0: power on to power good time: 2ms
[    0.289433] hub 3-0:1.0: local power source is good
[    0.289434] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    0.289480] drivers/usb/core/inode.c: creating file '001'
[    0.289537]   alloc irq_desc for 21 on cpu 0 node 0
[    0.289538]   alloc kstat_irqs on cpu 0 node 0
[    0.289541] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.289619] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.289621] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.289724] drivers/usb/core/inode.c: creating file '004'
[    0.289765] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.289878] uhci_hcd 0000:00:1a.1: detected 2 ports
[    0.289948] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.289950] uhci_hcd 0000:00:1a.1: Performing full reset
[    0.289962] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    0.289971] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[    0.290068] usb usb4: default language 0x0409
[    0.290073] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.290149] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.290259] usb usb4: Product: UHCI Host Controller
[    0.290327] usb usb4: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.290398] usb usb4: SerialNumber: 0000:00:1a.1
[    0.290492] usb usb4: uevent
[    0.290521] usb usb4: usb_probe_device
[    0.290523] usb usb4: configuration #1 chosen from 1 choice
[    0.290596] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    0.290607] usb 4-0:1.0: uevent
[    0.290637] hub 4-0:1.0: usb_probe_interface
[    0.290639] hub 4-0:1.0: usb_probe_interface - got id
[    0.290640] hub 4-0:1.0: USB hub found
[    0.290708] hub 4-0:1.0: 2 ports detected
[    0.290774] hub 4-0:1.0: standalone hub
[    0.290775] hub 4-0:1.0: no power switching (usb 1.0)
[    0.290776] hub 4-0:1.0: individual port over-current protection
[    0.290778] hub 4-0:1.0: power on to power good time: 2ms
[    0.290781] hub 4-0:1.0: local power source is good
[    0.290782] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    0.290827] drivers/usb/core/inode.c: creating file '001'
[    0.290883] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    0.290960] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.290962] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.291071] drivers/usb/core/inode.c: creating file '005'
[    0.291119] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.291236] uhci_hcd 0000:00:1a.2: detected 2 ports
[    0.291306] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.291308] uhci_hcd 0000:00:1a.2: Performing full reset
[    0.291320] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    0.291324] uhci_hcd 0000:00:1a.2: irq 21, io base 0x0000d480
[    0.291414] usb usb5: default language 0x0409
[    0.291419] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.291492] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.291602] usb usb5: Product: UHCI Host Controller
[    0.291670] usb usb5: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.291741] usb usb5: SerialNumber: 0000:00:1a.2
[    0.291833] usb usb5: uevent
[    0.291863] usb usb5: usb_probe_device
[    0.291865] usb usb5: configuration #1 chosen from 1 choice
[    0.291938] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    0.291949] usb 5-0:1.0: uevent
[    0.291979] hub 5-0:1.0: usb_probe_interface
[    0.291980] hub 5-0:1.0: usb_probe_interface - got id
[    0.291982] hub 5-0:1.0: USB hub found
[    0.292057] hub 5-0:1.0: 2 ports detected
[    0.292123] hub 5-0:1.0: standalone hub
[    0.292124] hub 5-0:1.0: no power switching (usb 1.0)
[    0.292126] hub 5-0:1.0: individual port over-current protection
[    0.292127] hub 5-0:1.0: power on to power good time: 2ms
[    0.292130] hub 5-0:1.0: local power source is good
[    0.292132] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    0.292177] drivers/usb/core/inode.c: creating file '001'
[    0.292237] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.292313] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.292316] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.292420] drivers/usb/core/inode.c: creating file '006'
[    0.292461] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.292575] uhci_hcd 0000:00:1d.0: detected 2 ports
[    0.292644] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.292646] uhci_hcd 0000:00:1d.0: Performing full reset
[    0.292658] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    0.292662] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[    0.292750] usb usb6: default language 0x0409
[    0.292755] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.292829] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.292939] usb usb6: Product: UHCI Host Controller
[    0.293013] usb usb6: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.293084] usb usb6: SerialNumber: 0000:00:1d.0
[    0.293179] usb usb6: uevent
[    0.293209] usb usb6: usb_probe_device
[    0.293211] usb usb6: configuration #1 chosen from 1 choice
[    0.293283] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    0.293295] usb 6-0:1.0: uevent
[    0.293325] hub 6-0:1.0: usb_probe_interface
[    0.293326] hub 6-0:1.0: usb_probe_interface - got id
[    0.293328] hub 6-0:1.0: USB hub found
[    0.293396] hub 6-0:1.0: 2 ports detected
[    0.293462] hub 6-0:1.0: standalone hub
[    0.293463] hub 6-0:1.0: no power switching (usb 1.0)
[    0.293464] hub 6-0:1.0: individual port over-current protection
[    0.293466] hub 6-0:1.0: power on to power good time: 2ms
[    0.293469] hub 6-0:1.0: local power source is good
[    0.293470] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    0.293516] drivers/usb/core/inode.c: creating file '001'
[    0.293571]   alloc irq_desc for 20 on cpu 0 node 0
[    0.293573]   alloc kstat_irqs on cpu 0 node 0
[    0.293576] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    0.293652] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.293655] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.293756] drivers/usb/core/inode.c: creating file '007'
[    0.293797] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.293911] uhci_hcd 0000:00:1d.1: detected 2 ports
[    0.293980] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.293982] uhci_hcd 0000:00:1d.1: Performing full reset
[    0.293994] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    0.294009] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000d080
[    0.294097] usb usb7: default language 0x0409
[    0.294102] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.294178] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.294288] usb usb7: Product: UHCI Host Controller
[    0.294356] usb usb7: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.294426] usb usb7: SerialNumber: 0000:00:1d.1
[    0.294520] usb usb7: uevent
[    0.294550] usb usb7: usb_probe_device
[    0.294552] usb usb7: configuration #1 chosen from 1 choice
[    0.294624] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    0.294634] usb 7-0:1.0: uevent
[    0.294664] hub 7-0:1.0: usb_probe_interface
[    0.294665] hub 7-0:1.0: usb_probe_interface - got id
[    0.294667] hub 7-0:1.0: USB hub found
[    0.294734] hub 7-0:1.0: 2 ports detected
[    0.294800] hub 7-0:1.0: standalone hub
[    0.294801] hub 7-0:1.0: no power switching (usb 1.0)
[    0.294802] hub 7-0:1.0: individual port over-current protection
[    0.294804] hub 7-0:1.0: power on to power good time: 2ms
[    0.294807] hub 7-0:1.0: local power source is good
[    0.294808] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    0.294855] drivers/usb/core/inode.c: creating file '001'
[    0.294914] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.294990] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.294992] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.295107] drivers/usb/core/inode.c: creating file '008'
[    0.295166] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.295279] uhci_hcd 0000:00:1d.2: detected 2 ports
[    0.295349] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.295350] uhci_hcd 0000:00:1d.2: Performing full reset
[    0.295363] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    0.295367] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[    0.295456] usb usb8: default language 0x0409
[    0.295461] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.295534] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.295644] usb usb8: Product: UHCI Host Controller
[    0.295712] usb usb8: Manufacturer: Linux 2.6.30.1 uhci_hcd
[    0.295782] usb usb8: SerialNumber: 0000:00:1d.2
[    0.295874] usb usb8: uevent
[    0.295910] usb usb8: usb_probe_device
[    0.295911] usb usb8: configuration #1 chosen from 1 choice
[    0.295984] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    0.295996] usb 8-0:1.0: uevent
[    0.296035] hub 8-0:1.0: usb_probe_interface
[    0.296036] hub 8-0:1.0: usb_probe_interface - got id
[    0.296038] hub 8-0:1.0: USB hub found
[    0.296107] hub 8-0:1.0: 2 ports detected
[    0.296176] hub 8-0:1.0: standalone hub
[    0.296177] hub 8-0:1.0: no power switching (usb 1.0)
[    0.296178] hub 8-0:1.0: individual port over-current protection
[    0.296180] hub 8-0:1.0: power on to power good time: 2ms
[    0.296183] hub 8-0:1.0: local power source is good
[    0.296185] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    0.296231] drivers/usb/core/inode.c: creating file '001'
[    0.296348] usbcore: registered new interface driver usblp
[    0.296418] Initializing USB Mass Storage driver...
[    0.296533] usbcore: registered new interface driver usb-storage
[    0.296604] USB Mass Storage support registered.
[    0.296718] usbcore: registered new interface driver libusual
[    0.296909] PNP: No PS/2 controller found. Probing ports directly.
[    0.299260] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.299336] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.299479] mice: PS/2 mouse device common for all mice
[    0.299726] rtc_cmos 00:03: RTC can wake from S4
[    0.299842] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.299932] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.300046] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.300429] cpuidle: using governor ladder
[    0.300819] cpuidle: using governor menu
[    0.301687] usbcore: registered new interface driver hiddev
[    0.301789] usbcore: registered new interface driver usbhid
[    0.301859] usbhid: v2.6:USB HID core driver
[    0.301965] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.302715]   alloc irq_desc for 22 on cpu 0 node 0
[    0.302717]   alloc kstat_irqs on cpu 0 node 0
[    0.302722] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.302860] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.337124] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    0.363159] ALSA device list:
[    0.363223]   #0: HDA Intel at 0xfe9f4000 irq 22
[    0.363332] Netfilter messages via NETLINK v0.30.
[    0.363417] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.363687] ctnetlink v0.93: registering with nfnetlink.
[    0.364255] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.364345] TCP cubic registered
[    0.364408] Initializing XFRM netlink socket
[    0.364730] NET: Registered protocol family 10
[    0.365585] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.365699] IPv6 over IPv4 tunneling driver
[    0.366270] NET: Registered protocol family 17
[    0.366504] RPC: Registered udp transport module.
[    0.366571] RPC: Registered tcp transport module.
[    0.367172] Using IPI No-Shortcut mode
[    0.367375] PM: Resume from disk failed.
[    0.367385] registered taskstats version 1
[    0.367564]   Magic number: 1:59:507
[    0.372071] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
[    0.372078] hub 1-0:1.0: port 5: status 0501 change 0001
[    0.372089] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
[    0.372094] hub 1-0:1.0: port 6: status 0501 change 0001
[    0.387028] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[    0.387034] hub 2-0:1.0: port 3: status 0501 change 0001
[    0.389043] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.390046] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.392029] uhci_hcd 0000:00:1a.2: port 1 portsc 008a,00
[    0.392044] uhci_hcd 0000:00:1a.2: port 2 portsc 008a,00
[    0.393044] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.394042] uhci_hcd 0000:00:1d.1: port 1 portsc 0082,00
[    0.396044] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    0.472040] hub 1-0:1.0: state 7 ports 6 chg 0060 evt 0000
[    0.472050] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    0.472060] ehci_hcd 0000:00:1a.7: port 5 low speed --> companion
[    0.523026] ehci_hcd 0000:00:1a.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[    0.523049] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    0.523056] ehci_hcd 0000:00:1a.7: port 6 low speed --> companion
[    0.567809] ata3: SATA link down (SStatus 0 SControl 300)
[    0.574032] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[    0.574051] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[    0.574060] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[    0.574067] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    0.625301] ehci_hcd 0000:00:1d.7: port 3 high speed
[    0.625304] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    0.676028] usb 2-3: new high speed USB device using ehci_hcd and address 2
[    1.022083] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.022186] ata1.01: SATA link down (SStatus 0 SControl 300)
[    1.052661] ata1.00: ATA-8: ST3320613AS, DE13, max UDMA/133
[    1.052744] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.101624] ata1.00: configured for UDMA/133
[    1.101793] scsi 0:0:0:0: Direct-Access     ATA      ST3320613AS      DE13 PQ: 0 ANSI: 5
[    1.102138] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.102143] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.102154] sd 0:0:0:0: [sda] Write Protect is off
[    1.102156] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.102171] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.102242]  sda: sda1 sda2 sda3 sda4
[    1.168805] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.237300] ehci_hcd 0000:00:1d.7: port 3 high speed
[    1.237304] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.361696] usb 2-3: default language 0x0409
[    1.367198] usb 2-3: New USB device found, idVendor=0bda, idProduct=0151
[    1.367280] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.367364] usb 2-3: Product: USB2.0-CRW
[    1.367431] usb 2-3: Manufacturer: Generic
[    1.367497] usb 2-3: SerialNumber: 20060413092100000
[    1.367598] usb 2-3: uevent
[    1.367645] usb 2-3: usb_probe_device
[    1.367647] usb 2-3: configuration #1 chosen from 1 choice
[    1.368321] usb 2-3: adding 2-3:1.0 (config #1, interface 0)
[    1.369074] usb 2-3:1.0: uevent
[    1.369150] usb-storage 2-3:1.0: usb_probe_interface
[    1.369154] usb-storage 2-3:1.0: usb_probe_interface - got id
[    1.369203] scsi4 : SCSI emulation for USB Mass Storage devices
[    1.369381] usb-storage: device found at 2
[    1.369383] usb-storage: waiting for device to settle before scanning
[    1.369473] drivers/usb/core/inode.c: creating file '002'
[    1.369526] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    1.369531] uhci_hcd 0000:00:1a.2: port 1 portsc 01a3,00
[    1.369536] hub 5-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    1.454028] usb usb3: suspend_rh (auto-stop)
[    1.454049] usb usb4: suspend_rh (auto-stop)
[    1.454069] usb usb6: suspend_rh (auto-stop)
[    1.454089] usb usb8: suspend_rh (auto-stop)
[    1.454117] usb usb7: suspend_rh (auto-stop)
[    1.473031] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    1.575025] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    1.745435] usb 5-1: skipped 1 descriptor after interface
[    1.745440] usb 5-1: skipped 1 descriptor after interface
[    1.751429] usb 5-1: default language 0x0409
[    1.775430] usb 5-1: New USB device found, idVendor=0d62, idProduct=2106
[    1.775511] usb 5-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    1.775594] usb 5-1: Product: USB Multimedia Keyboard
[    1.775689] usb 5-1: uevent
[    1.775727] usb 5-1: usb_probe_device
[    1.775729] usb 5-1: configuration #1 chosen from 1 choice
[    1.778433] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    1.778459] usb 5-1:1.0: uevent
[    1.778547] usbhid 5-1:1.0: usb_probe_interface
[    1.778549] usbhid 5-1:1.0: usb_probe_interface - got id
[    1.809733] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input2
[    1.809856] uhci_hcd 0000:00:1a.2: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    1.809949] generic-usb 0003:0D62:2106.0001: input,hidraw0: USB HID v1.10 Keyboard [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input0
[    1.810143] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[    1.810155] usb 5-1:1.1: uevent
[    1.810196] usbhid 5-1:1.1: usb_probe_interface
[    1.810198] usbhid 5-1:1.1: usb_probe_interface - got id
[    1.849561] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.1/input/input3
[    1.849682] uhci_hcd 0000:00:1a.2: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    1.849772] generic-usb 0003:0D62:2106.0002: input,hidraw1: USB HID v1.10 Device [USB Multimedia Keyboard] on usb-0000:00:1a.2-1/input1
[    1.849953] drivers/usb/core/inode.c: creating file '002'
[    1.850019] uhci_hcd 0000:00:1a.2: port 2 portsc 01a3,00
[    1.850024] hub 5-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    1.863203] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.863294] ata2.01: SATA link down (SStatus 0 SControl 300)
[    1.866222] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GH30N, A102, max UDMA/100
[    1.872236] ata2.00: configured for UDMA/100
[    1.873879] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GH30N    A102 PQ: 0 ANSI: 5
[    1.877656] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.877780] Uniform CD-ROM driver Revision: 3.20
[    1.877969] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.878068] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.954038] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    2.056026] usb 5-2: new low speed USB device using uhci_hcd and address 3
[    2.102027] async/1 used greatest stack depth: 6972 bytes left
[    2.168025] async/4 used greatest stack depth: 6828 bytes left
[    2.193816] ata4: SATA link down (SStatus 0 SControl 300)
[    2.193911] Freeing unused kernel memory: 344k freed
[    2.194158] Write protecting the kernel text: 3884k
[    2.194259] Write protecting the kernel read-only data: 1708k
[    2.201426] usb 5-2: skipped 1 descriptor after interface
[    2.205423] usb 5-2: default language 0x0409
[    2.212492] usb usb3: uevent
[    2.212507] usb 3-0:1.0: uevent
[    2.212579] usb usb4: uevent
[    2.212593] usb 4-0:1.0: uevent
[    2.212663] usb usb5: uevent
[    2.212677] usb 5-0:1.0: uevent
[    2.212710] usb 5-1: uevent
[    2.212724] usb 5-1:1.0: uevent
[    2.212823] usb 5-1:1.1: uevent
[    2.212970] usb usb1: uevent
[    2.212984] usb 1-0:1.0: uevent
[    2.213421] usb usb6: uevent
[    2.213435] usb 6-0:1.0: uevent
[    2.213506] usb usb7: uevent
[    2.213520] usb 7-0:1.0: uevent
[    2.213590] usb usb8: uevent
[    2.213605] usb 8-0:1.0: uevent
[    2.213677] usb usb2: uevent
[    2.213691] usb 2-0:1.0: uevent
[    2.213719] usb 2-3: uevent
[    2.213733] usb 2-3:1.0: uevent
[    2.220426] usb 5-2: New USB device found, idVendor=413c, idProduct=3012
[    2.220539] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.220613] usb 5-2: Product: Dell USB Optical Mouse
[    2.220682] usb 5-2: Manufacturer: Dell
[    2.220811] usb 5-2: uevent
[    2.220823] usb 5-2: usb_probe_device
[    2.220826] usb 5-2: configuration #1 chosen from 1 choice
[    2.223433] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    2.223461] usb 5-2:1.0: uevent
[    2.223483] usbhid 5-2:1.0: usb_probe_interface
[    2.223485] usbhid 5-2:1.0: usb_probe_interface - got id
[    2.231407] load-modules.sh used greatest stack depth: 6692 bytes left
[    2.236626] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input4
[    2.236831] generic-usb 0003:413C:3012.0003: input,hidraw2: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.2-2/input0
[    2.236992] drivers/usb/core/inode.c: creating file '003'
[    2.237028] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.237033] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.266568] udevd used greatest stack depth: 6516 bytes left
[    2.680821] kjournald starting.  Commit interval 5 seconds
[    2.680908] EXT3-fs: mounted filesystem with writeback data mode.
[    2.701035] hub 3-0:1.0: hub_suspend
[    2.701044] usb usb3: bus auto-suspend
[    2.701049] usb usb3: suspend_rh
[    2.701067] hub 4-0:1.0: hub_suspend
[    2.701071] usb usb4: bus auto-suspend
[    2.701074] usb usb4: suspend_rh
[    2.701090] hub 6-0:1.0: hub_suspend
[    2.701094] usb usb6: bus auto-suspend
[    2.701097] usb usb6: suspend_rh
[    2.701113] hub 8-0:1.0: hub_suspend
[    2.701117] usb usb8: bus auto-suspend
[    2.701120] usb usb8: suspend_rh
[    2.701145] hub 1-0:1.0: hub_suspend
[    2.701147] usb usb1: bus auto-suspend
[    2.701149] ehci_hcd 0000:00:1a.7: suspend root hub
[    3.209914] stty used greatest stack depth: 6376 bytes left
[    4.109802] udev: starting version 141
[    4.149069] usb usb3: uevent
[    4.149086] usb 3-0:1.0: uevent
[    4.149161] usb usb4: uevent
[    4.149177] usb 4-0:1.0: uevent
[    4.149249] usb usb5: uevent
[    4.149263] usb 5-0:1.0: uevent
[    4.149291] usb 5-1: uevent
[    4.149307] usb 5-1:1.0: uevent
[    4.149410] usb 5-1:1.1: uevent
[    4.149512] usb 5-2: uevent
[    4.149526] usb 5-2:1.0: uevent
[    4.149680] usb usb1: uevent
[    4.149696] usb 1-0:1.0: uevent
[    4.150129] usb usb6: uevent
[    4.150144] usb 6-0:1.0: uevent
[    4.150215] usb usb7: uevent
[    4.150230] usb 7-0:1.0: uevent
[    4.150302] usb usb8: uevent
[    4.150315] usb 8-0:1.0: uevent
[    4.150386] usb usb2: uevent
[    4.150400] usb 2-0:1.0: uevent
[    4.150428] usb 2-3: uevent
[    4.150444] usb 2-3:1.0: uevent
[    4.152694] udevadm used greatest stack depth: 6172 bytes left
[    4.657581] usb 5-2:1.0: uevent
[    4.657660] usb 5-2: uevent
[    4.658296] usb 5-1:1.0: uevent
[    4.658374] usb 5-1: uevent
[    4.659027] usb 5-1:1.1: uevent
[    4.659102] usb 5-1: uevent
[    4.659693] usb 5-2:1.0: uevent
[    4.659764] usb 5-2: uevent
[    4.701151] hub 7-0:1.0: hub_suspend
[    4.701159] usb usb7: bus auto-suspend
[    4.701162] usb usb7: suspend_rh
[    5.359256] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    5.359694] EXT3 FS on sda3, internal journal
[    5.772923] EXT4-fs: barriers enabled
[    5.774326] kjournald2 starting: pid 3227, dev sda2:8, commit interval 5 seconds
[    5.774340] EXT4-fs: delayed allocation enabled
[    5.774345] EXT4-fs: file extents enabled
[    5.785745] EXT4-fs: mballoc enabled
[    5.785757] EXT4-fs: mounted filesystem sda2 with ordered data mode
[    5.810682] Adding 8426084k swap on /dev/sda4.  Priority:-1 extents:1 across:8426084k 
[    6.375466] scsi 4:0:0:0: Direct-Access     Generic- Compact Flash    1.00 PQ: 0 ANSI: 0 CCS
[    6.375583] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    6.375785] usb-storage: device scan complete
[    6.377260] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    6.378721] usb 2-3:1.0: uevent
[    6.378811] usb 2-3: uevent
[    7.644239] loadkeys used greatest stack depth: 6104 bytes left
[   10.159560] usb usb3: uevent
[   10.159621] usb 3-0:1.0: uevent
[   10.159830] usb usb4: uevent
[   10.159876] usb 4-0:1.0: uevent
[   10.160276] usb usb5: uevent
[   10.160323] usb 5-0:1.0: uevent
[   10.160416] usb 5-1: uevent
[   10.160464] usb 5-1:1.0: uevent
[   10.160750] usb 5-1:1.1: uevent
[   10.161209] usb 5-2: uevent
[   10.161257] usb 5-2:1.0: uevent
[   10.161774] usb usb1: uevent
[   10.161820] usb 1-0:1.0: uevent
[   10.163142] usb usb6: uevent
[   10.163189] usb 6-0:1.0: uevent
[   10.163409] usb usb7: uevent
[   10.163455] usb 7-0:1.0: uevent
[   10.163658] usb usb8: uevent
[   10.163704] usb 8-0:1.0: uevent
[   10.163922] usb usb2: uevent
[   10.163968] usb 2-0:1.0: uevent
[   10.164254] usb 2-3: uevent
[   10.164302] usb 2-3:1.0: uevent
[   10.704729] r8169: eth0: link up
[   10.704737] r8169: eth0: link up
[   21.117022] eth0: no IPv6 routers present
[   46.587569] ------------[ cut here ]------------
[   46.587583] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[   46.587587] Hardware name: Studio 540      
[   46.587589] hotplug uevent
[   46.587592] Modules linked in:
[   46.587598] Pid: 7, comm: events/0 Not tainted 2.6.30.1 #1
[   46.587601] Call Trace:
[   46.587610]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[   46.587617]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[   46.587623]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[   46.587629]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[   46.587636]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[   46.587643]  [<c1032f28>] worker_thread+0x131/0x1ab
[   46.587649]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[   46.587655]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[   46.587661]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[   46.587665]  [<c1035c84>] kthread+0x46/0x6a
[   46.587670]  [<c1035c3e>] ? kthread+0x0/0x6a
[   46.587676]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[   46.587684] ---[ end trace ed36ea6940856580 ]---
[   47.337035] uhci_hcd 0000:00:1a.2: reserve dev 3 ep81-INT, period 8, phase 4, 99 us
[   96.254444] python used greatest stack depth: 5800 bytes left
[  250.285244] kwrite used greatest stack depth: 5536 bytes left
[  261.240321] ------------[ cut here ]------------
[  261.240335] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  261.240339] Hardware name: Studio 540      
[  261.240341] hotplug uevent
[  261.240344] Modules linked in:
[  261.240350] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  261.240353] Call Trace:
[  261.240363]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  261.240369]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  261.240375]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  261.240381]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  261.240388]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  261.240395]  [<c1032f28>] worker_thread+0x131/0x1ab
[  261.240401]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  261.240407]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  261.240412]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  261.240417]  [<c1035c84>] kthread+0x46/0x6a
[  261.240422]  [<c1035c3e>] ? kthread+0x0/0x6a
[  261.240431]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  261.240433] ---[ end trace ed36ea6940856581 ]---
[  265.100408] ------------[ cut here ]------------
[  265.100417] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  265.100420] Hardware name: Studio 540      
[  265.100421] hotplug uevent
[  265.100422] Modules linked in:
[  265.100425] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  265.100427] Call Trace:
[  265.100433]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  265.100436]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  265.100439]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  265.100442]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  265.100445]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  265.100449]  [<c1032f28>] worker_thread+0x131/0x1ab
[  265.100452]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  265.100455]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  265.100458]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  265.100460]  [<c1035c84>] kthread+0x46/0x6a
[  265.100462]  [<c1035c3e>] ? kthread+0x0/0x6a
[  265.100466]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  265.100468] ---[ end trace ed36ea6940856582 ]---
[  267.065312] ------------[ cut here ]------------
[  267.065325] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  267.065330] Hardware name: Studio 540      
[  267.065332] hotplug uevent
[  267.065334] Modules linked in:
[  267.065340] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  267.065343] Call Trace:
[  267.065352]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  267.065359]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  267.065365]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  267.065371]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  267.065378]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  267.065385]  [<c1032f28>] worker_thread+0x131/0x1ab
[  267.065391]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  267.065397]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  267.065402]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  267.065407]  [<c1035c84>] kthread+0x46/0x6a
[  267.065411]  [<c1035c3e>] ? kthread+0x0/0x6a
[  267.065417]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  267.065421] ---[ end trace ed36ea6940856583 ]---

--Boundary-00=_FRPZKJAZyWPSkuP
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg2.log"

[  328.045649] hotplug uevent
[  328.045651] Modules linked in:
[  328.045657] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.045660] Call Trace:
[  328.045668]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.045674]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.045680]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.045686]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.045693]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.045699]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.045705]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.045711]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.045716]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.045721]  [<c1035c84>] kthread+0x46/0x6a
[  328.045726]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.045731]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.045735] ---[ end trace ed36ea69408569ba ]---
[  328.059596] ------------[ cut here ]------------
[  328.059605] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.059609] Hardware name: Studio 540      
[  328.059611] hotplug uevent
[  328.059614] Modules linked in:
[  328.059619] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.059622] Call Trace:
[  328.059630]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.059636]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.059642]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.059648]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.059655]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.059661]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.059667]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.059673]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.059678]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.059683]  [<c1035c84>] kthread+0x46/0x6a
[  328.059688]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.059693]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.059697] ---[ end trace ed36ea69408569bb ]---
[  328.076808] ------------[ cut here ]------------
[  328.076817] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.076821] Hardware name: Studio 540      
[  328.076823] hotplug uevent
[  328.076825] Modules linked in:
[  328.076830] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.076833] Call Trace:
[  328.076841]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.076847]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.076854]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.076860]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.076867]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.076873]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.076879]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.076885]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.076890]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.076895]  [<c1035c84>] kthread+0x46/0x6a
[  328.076900]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.076906]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.076909] ---[ end trace ed36ea69408569bc ]---
[  328.080007] ------------[ cut here ]------------
[  328.080017] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.080021] Hardware name: Studio 540      
[  328.080023] hotplug uevent
[  328.080025] Modules linked in:
[  328.080031] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.080034] Call Trace:
[  328.080042]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.080049]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.080055]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.080061]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.080067]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.080073]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.080079]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.080085]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.080090]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.080095]  [<c1035c84>] kthread+0x46/0x6a
[  328.080100]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.080106]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.080109] ---[ end trace ed36ea69408569bd ]---
[  328.087376] ------------[ cut here ]------------
[  328.087386] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.087390] Hardware name: Studio 540      
[  328.087392] hotplug uevent
[  328.087394] Modules linked in:
[  328.087399] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.087402] Call Trace:
[  328.087410]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.087417]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.087423]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.087429]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.087436]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.087442]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.087448]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.087451] ------------[ cut here ]------------
[  328.087460] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.087464] Hardware name: Studio 540      
[  328.087466] hotplug uevent
[  328.087469] Modules linked in:
[  328.087473] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.087479]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.087485]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.087488] Call Trace:
[  328.087493]  [<c1035c84>] kthread+0x46/0x6a
[  328.087499]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.087506]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.087511]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.087518]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.087524]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.087530]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.087534] ---[ end trace ed36ea69408569be ]---
[  328.087541]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.087547]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.087553]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.087559]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.087565]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.087570]  [<c1035c84>] kthread+0x46/0x6a
[  328.087574]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.087580]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.087585] ---[ end trace ed36ea69408569bf ]---
[  328.093373] ------------[ cut here ]------------
[  328.093383] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.093387] Hardware name: Studio 540      
[  328.093389] hotplug uevent
[  328.093391] Modules linked in:
[  328.093397] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.093400] Call Trace:
[  328.093408]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.093414]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.093420]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.093426]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.093433]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.093439]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.093445]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.093451]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.093456]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.093461]  [<c1035c84>] kthread+0x46/0x6a
[  328.093465]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.093471]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.093475] ---[ end trace ed36ea69408569c0 ]---
[  328.277722] ------------[ cut here ]------------
[  328.277735] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.277740] Hardware name: Studio 540      
[  328.277742] hotplug uevent
[  328.277744] Modules linked in:
[  328.277750] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.277754] Call Trace:
[  328.277763]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.277769]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.277776]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.277782]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.277789]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.277795]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.277801]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.277807]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.277813]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.277817]  [<c1035c84>] kthread+0x46/0x6a
[  328.277822]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.277828]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.277832] ---[ end trace ed36ea69408569c1 ]---
[  328.298910] ------------[ cut here ]------------
[  328.298920] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.298924] Hardware name: Studio 540      
[  328.298926] hotplug uevent
[  328.298928] Modules linked in:
[  328.298934] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.298937] Call Trace:
[  328.298945]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.298952]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.298958]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.298964]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.298970]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.298977]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.298983]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.298988]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.298994]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.298999]  [<c1035c84>] kthread+0x46/0x6a
[  328.299015]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.299021]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.299025] ---[ end trace ed36ea69408569c2 ]---
[  328.559796] ------------[ cut here ]------------
[  328.559808] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.559812] Hardware name: Studio 540      
[  328.559815] hotplug uevent
[  328.559817] Modules linked in:
[  328.559823] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.559826] Call Trace:
[  328.559835]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.559841]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.559848]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.559854]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.559861]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.559867]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.559873]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.559879]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.559885]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.559890]  [<c1035c84>] kthread+0x46/0x6a
[  328.559894]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.559900]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.559904] ---[ end trace ed36ea69408569c3 ]---
[  328.563785] ------------[ cut here ]------------
[  328.563795] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.563799] Hardware name: Studio 540      
[  328.563801] hotplug uevent
[  328.563803] Modules linked in:
[  328.563809] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.563812] Call Trace:
[  328.563820]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.563827]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.563833]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.563838]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.563845]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.563851]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.563857]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.563863]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.563868]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.563873]  [<c1035c84>] kthread+0x46/0x6a
[  328.563878]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.563884]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.563887] ---[ end trace ed36ea69408569c4 ]---
[  328.581195] ------------[ cut here ]------------
[  328.581205] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.581209] Hardware name: Studio 540      
[  328.581212] hotplug uevent
[  328.581214] Modules linked in:
[  328.581219] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.581222] Call Trace:
[  328.581230]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.581236]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.581242]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.581248]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.581255]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.581261]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.581268]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.581273]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.581279]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.581284]  [<c1035c84>] kthread+0x46/0x6a
[  328.581288]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.581294]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.581298] ---[ end trace ed36ea69408569c5 ]---
[  328.585147] ------------[ cut here ]------------
[  328.585156] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.585160] Hardware name: Studio 540      
[  328.585162] hotplug uevent
[  328.585165] Modules linked in:
[  328.585170] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.585173] Call Trace:
[  328.585181]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.585187]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.585193]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.585199]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.585206]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.585212]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.585219]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.585224]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.585230]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.585234]  [<c1035c84>] kthread+0x46/0x6a
[  328.585239]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.585245]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.585249] ---[ end trace ed36ea69408569c6 ]---
[  328.869272] ------------[ cut here ]------------
[  328.869286] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.869290] Hardware name: Studio 540      
[  328.869292] hotplug uevent
[  328.869294] Modules linked in:
[  328.869301] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.869304] Call Trace:
[  328.869313]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.869320]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.869326]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.869332]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.869339]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.869346]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.869352]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.869358]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.869363]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.869368]  [<c1035c84>] kthread+0x46/0x6a
[  328.869372]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.869378]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.869382] ---[ end trace ed36ea69408569c7 ]---
[  328.874830] ------------[ cut here ]------------
[  328.874840] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.874844] Hardware name: Studio 540      
[  328.874846] hotplug uevent
[  328.874848] Modules linked in:
[  328.874854] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.874857] Call Trace:
[  328.874864]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.874871]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.874877]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.874883]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.874890]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.874896]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.874902]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.874908]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.874913]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.874918]  [<c1035c84>] kthread+0x46/0x6a
[  328.874923]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.874928]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.874932] ---[ end trace ed36ea69408569c8 ]---
[  328.875257] ------------[ cut here ]------------
[  328.875266] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.875269] Hardware name: Studio 540      
[  328.875272] hotplug uevent
[  328.875274] Modules linked in:
[  328.875279] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.875282] Call Trace:
[  328.875289]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.875296]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.875302]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.875308]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.875314]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.875320]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.875326]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.875332]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.875337]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.875342]  [<c1035c84>] kthread+0x46/0x6a
[  328.875347]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.875353]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.875356] ---[ end trace ed36ea69408569c9 ]---
[  328.895399] ------------[ cut here ]------------
[  328.895412] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.895417] Hardware name: Studio 540      
[  328.895419] hotplug uevent
[  328.895421] Modules linked in:
[  328.895427] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.895431] Call Trace:
[  328.895440]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.895447]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.895453]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.895459]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.895466]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.895473]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.895479]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.895486]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.895491]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.895496]  [<c1035c84>] kthread+0x46/0x6a
[  328.895501]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.895507]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.895511] ---[ end trace ed36ea69408569ca ]---
[  328.922326] ------------[ cut here ]------------
[  328.922336] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.922340] Hardware name: Studio 540      
[  328.922342] hotplug uevent
[  328.922344] Modules linked in:
[  328.922350] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.922353] Call Trace:
[  328.922361]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.922368]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.922374]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.922380]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.922387]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.922393]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.922399]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.922404]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.922410]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.922415]  [<c1035c84>] kthread+0x46/0x6a
[  328.922419]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.922425]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.922429] ---[ end trace ed36ea69408569cb ]---
[  328.924731] ------------[ cut here ]------------
[  328.924741] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.924745] Hardware name: Studio 540      
[  328.924747] hotplug uevent
[  328.924749] Modules linked in:
[  328.924755] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.924758] Call Trace:
[  328.924767]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.924773]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.924779]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.924785]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.924792]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.924798]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.924804]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.924810]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.924815]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.924820]  [<c1035c84>] kthread+0x46/0x6a
[  328.924825]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.924831]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.924834] ---[ end trace ed36ea69408569cc ]---
[  328.927836] ------------[ cut here ]------------
[  328.927845] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.927849] Hardware name: Studio 540      
[  328.927852] hotplug uevent
[  328.927854] Modules linked in:
[  328.927859] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.927862] Call Trace:
[  328.927870]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.927877]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.927883]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.927889]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.927896]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.927902]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.927909]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.927914]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.927920]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.927924]  [<c1035c84>] kthread+0x46/0x6a
[  328.927929]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.927935]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.927938] ---[ end trace ed36ea69408569cd ]---
[  328.932322] ------------[ cut here ]------------
[  328.932332] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.932335] Hardware name: Studio 540      
[  328.932338] hotplug uevent
[  328.932340] Modules linked in:
[  328.932345] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.932348] Call Trace:
[  328.932356]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.932363]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.932369]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.932375]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.932382]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.932388]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.932394]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.932399]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.932405]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.932410]  [<c1035c84>] kthread+0x46/0x6a
[  328.932414]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.932420]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.932424] ---[ end trace ed36ea69408569ce ]---
[  328.932872] ------------[ cut here ]------------
[  328.932880] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.932884] Hardware name: Studio 540      
[  328.932886] hotplug uevent
[  328.932889] Modules linked in:
[  328.932894] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.932897] Call Trace:
[  328.932904]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.932910]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.932916]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.932922]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.932929]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.932935]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.932941]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.932946]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.932952]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.932957]  [<c1035c84>] kthread+0x46/0x6a
[  328.932961]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.932967]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.932970] ---[ end trace ed36ea69408569cf ]---
[  328.934190] ------------[ cut here ]------------
[  328.934198] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.934202] Hardware name: Studio 540      
[  328.934204] hotplug uevent
[  328.934206] Modules linked in:
[  328.934211] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.934214] Call Trace:
[  328.934221]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.934227]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.934233]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.934239]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.934246]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.934252]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.934258]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.934263]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.934269]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.934274]  [<c1035c84>] kthread+0x46/0x6a
[  328.934278]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.934284]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.934288] ---[ end trace ed36ea69408569d0 ]---
[  328.936463] ------------[ cut here ]------------
[  328.936472] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.936476] Hardware name: Studio 540      
[  328.936478] hotplug uevent
[  328.936480] Modules linked in:
[  328.936485] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  328.936488] Call Trace:
[  328.936495]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.936501]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.936507]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.936514]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.936520]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.936526]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.936532]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.936538]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.936543]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.936548]  [<c1035c84>] kthread+0x46/0x6a
[  328.936553]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.936558]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.936562] ---[ end trace ed36ea69408569d1 ]---
[  328.942968] ------------[ cut here ]------------
[  328.942979] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.942983] Hardware name: Studio 540      
[  328.942985] hotplug uevent
[  328.942987] Modules linked in:
[  328.942992] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.942995] Call Trace:
[  328.943003]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.943021]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.943027]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.943033]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.943042]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.943049]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.943057]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.943064]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.943071]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.943078]  [<c1035c84>] kthread+0x46/0x6a
[  328.943084]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.943092]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.943097] ---[ end trace ed36ea69408569d2 ]---
[  328.952398] ------------[ cut here ]------------
[  328.952407] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  328.952411] Hardware name: Studio 540      
[  328.952413] hotplug uevent
[  328.952415] Modules linked in:
[  328.952420] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  328.952424] Call Trace:
[  328.952431]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  328.952438]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  328.952444]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  328.952450]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  328.952456]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  328.952462]  [<c1032f28>] worker_thread+0x131/0x1ab
[  328.952468]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  328.952474]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  328.952479]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  328.952484]  [<c1035c84>] kthread+0x46/0x6a
[  328.952488]  [<c1035c3e>] ? kthread+0x0/0x6a
[  328.952494]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  328.952498] ---[ end trace ed36ea69408569d3 ]---
[  329.004424] ------------[ cut here ]------------
[  329.004435] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.004440] Hardware name: Studio 540      
[  329.004442] hotplug uevent
[  329.004444] Modules linked in:
[  329.004450] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.004453] Call Trace:
[  329.004462]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.004469]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.004475]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.004481]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.004488]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.004494]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.004500]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.004506]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.004511]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.004516]  [<c1035c84>] kthread+0x46/0x6a
[  329.004521]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.004527]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.004531] ---[ end trace ed36ea69408569d4 ]---
[  329.009751] ------------[ cut here ]------------
[  329.009761] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.009765] Hardware name: Studio 540      
[  329.009767] hotplug uevent
[  329.009769] Modules linked in:
[  329.009775] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.009778] Call Trace:
[  329.009785]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.009792]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.009798]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.009804]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.009811]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.009817]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.009823]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.009828]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.009834]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.009839]  [<c1035c84>] kthread+0x46/0x6a
[  329.009843]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.009849]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.009853] ---[ end trace ed36ea69408569d5 ]---
[  329.010640] ------------[ cut here ]------------
[  329.010649] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.010653] Hardware name: Studio 540      
[  329.010655] hotplug uevent
[  329.010657] Modules linked in:
[  329.010662] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.010665] Call Trace:
[  329.010672]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.010679]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.010685]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.010691]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.010697]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.010703]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.010709]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.010715]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.010720]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.010725]  [<c1035c84>] kthread+0x46/0x6a
[  329.010729]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.010735]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.010738] ---[ end trace ed36ea69408569d6 ]---
[  329.019072] ------------[ cut here ]------------
[  329.019082] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.019086] Hardware name: Studio 540      
[  329.019089] hotplug uevent
[  329.019091] Modules linked in:
[  329.019096] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.019099] Call Trace:
[  329.019107]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.019113]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.019119]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.019125]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.019142]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.019148]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.019154]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.019161]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.019168]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.019174]  [<c1035c84>] kthread+0x46/0x6a
[  329.019180]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.019188]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.019193] ---[ end trace ed36ea69408569d7 ]---
[  329.028069] ------------[ cut here ]------------
[  329.028078] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.028082] Hardware name: Studio 540      
[  329.028084] hotplug uevent
[  329.028086] Modules linked in:
[  329.028091] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.028094] Call Trace:
[  329.028102]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.028108]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.028114]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.028120]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.028127]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.028143]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.028150]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.028156]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.028162]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.028168]  [<c1035c84>] kthread+0x46/0x6a
[  329.028174]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.028181]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.028186] ---[ end trace ed36ea69408569d8 ]---
[  329.086062] ------------[ cut here ]------------
[  329.086072] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.086075] Hardware name: Studio 540      
[  329.086078] hotplug uevent
[  329.086080] Modules linked in:
[  329.086085] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.086088] Call Trace:
[  329.086096]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.086102]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.086108]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.086114]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.086121]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.086127]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.086146]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.086152]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.086157]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.086163]  [<c1035c84>] kthread+0x46/0x6a
[  329.086169]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.086176]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.086180] ---[ end trace ed36ea69408569d9 ]---
[  329.089490] ------------[ cut here ]------------
[  329.089501] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.089505] Hardware name: Studio 540      
[  329.089507] hotplug uevent
[  329.089509] Modules linked in:
[  329.089514] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.089518] Call Trace:
[  329.089526]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.089533]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.089539]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.089545]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.089552]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.089558]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.089564]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.089570]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.089575]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.089580]  [<c1035c84>] kthread+0x46/0x6a
[  329.089584]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.089590]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.089594] ---[ end trace ed36ea69408569da ]---
[  329.102789] ------------[ cut here ]------------
[  329.102801] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.102805] Hardware name: Studio 540      
[  329.102808] hotplug uevent
[  329.102810] Modules linked in:
[  329.102815] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.102819] Call Trace:
[  329.102827]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.102834]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.102840]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.102846]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.102853]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.102859]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.102865]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.102871]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.102877]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.102882]  [<c1035c84>] kthread+0x46/0x6a
[  329.102886]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.102892]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.102896] ---[ end trace ed36ea69408569db ]---
[  329.176540] ------------[ cut here ]------------
[  329.176551] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.176555] Hardware name: Studio 540      
[  329.176557] hotplug uevent
[  329.176560] Modules linked in:
[  329.176565] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.176568] Call Trace:
[  329.176577]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.176583]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.176589]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.176596]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.176603]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.176609]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.176616]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.176621]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.176627]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.176632]  [<c1035c84>] kthread+0x46/0x6a
[  329.176636]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.176642]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.176646] ---[ end trace ed36ea69408569dc ]---
[  329.183657] ------------[ cut here ]------------
[  329.183670] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.183674] Hardware name: Studio 540      
[  329.183677] hotplug uevent
[  329.183679] Modules linked in:
[  329.183685] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.183688] Call Trace:
[  329.183697]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.183704]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.183710]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.183716]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.183723]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.183729]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.183735]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.183741]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.183747]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.183752]  [<c1035c84>] kthread+0x46/0x6a
[  329.183756]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.183762]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.183766] ---[ end trace ed36ea69408569dd ]---
[  329.184971] ------------[ cut here ]------------
[  329.184981] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.184985] Hardware name: Studio 540      
[  329.184987] hotplug uevent
[  329.184989] Modules linked in:
[  329.184995] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.184998] Call Trace:
[  329.185018]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.185024]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.185031]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.185037]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.185044]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.185050]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.185057]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.185062]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.185068]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.185073]  [<c1035c84>] kthread+0x46/0x6a
[  329.185077]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.185083]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.185087] ---[ end trace ed36ea69408569de ]---
[  329.258187] ------------[ cut here ]------------
[  329.258200] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.258204] Hardware name: Studio 540      
[  329.258206] hotplug uevent
[  329.258209] Modules linked in:
[  329.258215] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.258218] Call Trace:
[  329.258227]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.258233]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.258240]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.258246]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.258253]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.258259]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.258265]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.258272]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.258277]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.258282]  [<c1035c84>] kthread+0x46/0x6a
[  329.258286]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.258292]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.258296] ---[ end trace ed36ea69408569df ]---
[  329.661445] ------------[ cut here ]------------
[  329.661459] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.661463] Hardware name: Studio 540      
[  329.661465] hotplug uevent
[  329.661468] Modules linked in:
[  329.661474] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.661477] Call Trace:
[  329.661487]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.661493]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.661499]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.661505]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.661512]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.661519]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.661525]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.661531]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.661536]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.661541]  [<c1035c84>] kthread+0x46/0x6a
[  329.661546]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.661552]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.661556] ---[ end trace ed36ea69408569e0 ]---
[  329.723145] ------------[ cut here ]------------
[  329.723155] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.723159] Hardware name: Studio 540      
[  329.723161] hotplug uevent
[  329.723163] Modules linked in:
[  329.723169] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.723172] Call Trace:
[  329.723180]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.723186]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.723192]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.723198]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.723205]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.723211]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.723217]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.723223]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.723229]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.723233]  [<c1035c84>] kthread+0x46/0x6a
[  329.723238]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.723244]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.723247] ---[ end trace ed36ea69408569e1 ]---
[  329.734624] ------------[ cut here ]------------
[  329.734633] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.734637] Hardware name: Studio 540      
[  329.734639] hotplug uevent
[  329.734641] Modules linked in:
[  329.734646] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.734649] Call Trace:
[  329.734657]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.734664]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.734670]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.734676]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.734683]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.734690]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.734696]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.734702]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.734707]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.734712]  [<c1035c84>] kthread+0x46/0x6a
[  329.734717]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.734722]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.734726] ---[ end trace ed36ea69408569e2 ]---
[  329.755877] ------------[ cut here ]------------
[  329.755888] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.755892] Hardware name: Studio 540      
[  329.755894] hotplug uevent
[  329.755896] Modules linked in:
[  329.755902] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.755905] Call Trace:
[  329.755913]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.755919]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.755925]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.755931]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.755938]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.755944]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.755950]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.755956]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.755961]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.755966]  [<c1035c84>] kthread+0x46/0x6a
[  329.755971]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.755976]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.755980] ---[ end trace ed36ea69408569e3 ]---
[  329.798119] ------------[ cut here ]------------
[  329.798128] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.798144] Hardware name: Studio 540      
[  329.798146] hotplug uevent
[  329.798148] Modules linked in:
[  329.798154] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.798157] Call Trace:
[  329.798165]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.798173]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.798181]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.798188]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.798197]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.798205]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.798213]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.798221]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.798228]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.798235]  [<c1035c84>] kthread+0x46/0x6a
[  329.798241]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.798249]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.798254] ---[ end trace ed36ea69408569e4 ]---
[  329.809942] ------------[ cut here ]------------
[  329.809955] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.809959] Hardware name: Studio 540      
[  329.809961] hotplug uevent
[  329.809963] Modules linked in:
[  329.809969] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.809972] Call Trace:
[  329.809981]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.809988]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.809994]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.810000]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.810019]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.810025]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.810031]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.810037]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.810042]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.810047]  [<c1035c84>] kthread+0x46/0x6a
[  329.810052]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.810058]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.810062] ---[ end trace ed36ea69408569e5 ]---
[  329.823976] ------------[ cut here ]------------
[  329.823989] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.823993] Hardware name: Studio 540      
[  329.823995] hotplug uevent
[  329.823998] Modules linked in:
[  329.824015] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.824019] Call Trace:
[  329.824027]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.824034]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.824040]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.824046]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.824053]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.824060]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.824067]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.824073]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.824078]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.824083]  [<c1035c84>] kthread+0x46/0x6a
[  329.824088]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.824094]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.824098] ---[ end trace ed36ea69408569e6 ]---
[  329.864316] ------------[ cut here ]------------
[  329.864326] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.864330] Hardware name: Studio 540      
[  329.864332] hotplug uevent
[  329.864334] Modules linked in:
[  329.864340] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  329.864343] Call Trace:
[  329.864351]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.864357]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.864363]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.864369]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.864376]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.864382]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.864389]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.864394]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.864400]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.864404]  [<c1035c84>] kthread+0x46/0x6a
[  329.864409]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.864415]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.864418] ---[ end trace ed36ea69408569e7 ]---
[  329.869654] ------------[ cut here ]------------
[  329.869664] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  329.869668] Hardware name: Studio 540      
[  329.869670] hotplug uevent
[  329.869672] Modules linked in:
[  329.869677] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  329.869681] Call Trace:
[  329.869688]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  329.869695]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  329.869701]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  329.869707]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  329.869714]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  329.869720]  [<c1032f28>] worker_thread+0x131/0x1ab
[  329.869726]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  329.869732]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  329.869737]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  329.869742]  [<c1035c84>] kthread+0x46/0x6a
[  329.869747]  [<c1035c3e>] ? kthread+0x0/0x6a
[  329.869752]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  329.869756] ---[ end trace ed36ea69408569e8 ]---
[  330.042212] ------------[ cut here ]------------
[  330.042223] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.042227] Hardware name: Studio 540      
[  330.042229] hotplug uevent
[  330.042231] Modules linked in:
[  330.042237] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.042240] Call Trace:
[  330.042249]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.042255]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.042261]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.042268]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.042275]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.042281]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.042287]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.042293]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.042298]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.042303]  [<c1035c84>] kthread+0x46/0x6a
[  330.042307]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.042313]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.042317] ---[ end trace ed36ea69408569e9 ]---
[  330.074838] ------------[ cut here ]------------
[  330.074848] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.074852] Hardware name: Studio 540      
[  330.074855] hotplug uevent
[  330.074857] Modules linked in:
[  330.074863] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.074866] Call Trace:
[  330.074874]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.074881]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.074887]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.074893]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.074899]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.074906]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.074912]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.074917]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.074923]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.074927]  [<c1035c84>] kthread+0x46/0x6a
[  330.074932]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.074938]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.074942] ---[ end trace ed36ea69408569ea ]---
[  330.096602] ------------[ cut here ]------------
[  330.096612] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.096615] Hardware name: Studio 540      
[  330.096618] hotplug uevent
[  330.096620] Modules linked in:
[  330.096625] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.096628] Call Trace:
[  330.096636]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.096642]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.096648]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.096654]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.096661]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.096668]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.096674]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.096679]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.096685]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.096690]  [<c1035c84>] kthread+0x46/0x6a
[  330.096694]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.096700]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.096704] ---[ end trace ed36ea69408569eb ]---
[  330.202318] ------------[ cut here ]------------
[  330.202331] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.202335] Hardware name: Studio 540      
[  330.202337] hotplug uevent
[  330.202340] Modules linked in:
[  330.202346] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.202349] Call Trace:
[  330.202358]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.202365]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.202371]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.202377]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.202384]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.202391]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.202397]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.202403]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.202408]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.202413]  [<c1035c84>] kthread+0x46/0x6a
[  330.202418]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.202424]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.202428] ---[ end trace ed36ea69408569ec ]---
[  330.207622] ------------[ cut here ]------------
[  330.207633] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.207637] Hardware name: Studio 540      
[  330.207639] hotplug uevent
[  330.207641] Modules linked in:
[  330.207647] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.207650] Call Trace:
[  330.207658]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.207664]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.207670]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.207676]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.207683]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.207689]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.207696]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.207701]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.207707]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.207711]  [<c1035c84>] kthread+0x46/0x6a
[  330.207716]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.207722]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.207726] ---[ end trace ed36ea69408569ed ]---
[  330.209238] ------------[ cut here ]------------
[  330.209247] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.209251] Hardware name: Studio 540      
[  330.209254] hotplug uevent
[  330.209256] Modules linked in:
[  330.209261] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.209264] Call Trace:
[  330.209272]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.209278]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.209284]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.209290]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.209297]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.209303]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.209309]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.209315]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.209320]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.209325]  [<c1035c84>] kthread+0x46/0x6a
[  330.209330]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.209335]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.209339] ---[ end trace ed36ea69408569ee ]---
[  330.211033] ------------[ cut here ]------------
[  330.211042] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.211046] Hardware name: Studio 540      
[  330.211049] hotplug uevent
[  330.211051] Modules linked in:
[  330.211056] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.211059] Call Trace:
[  330.211067]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.211074]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.211080]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.211086]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.211092]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.211098]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.211104]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.211110]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.211115]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.211120]  [<c1035c84>] kthread+0x46/0x6a
[  330.211125]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.211130]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.211139] ---[ end trace ed36ea69408569ef ]---
[  330.213775] ------------[ cut here ]------------
[  330.213784] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.213788] Hardware name: Studio 540      
[  330.213790] hotplug uevent
[  330.213792] Modules linked in:
[  330.213797] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.213801] Call Trace:
[  330.213809]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.213815]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.213821]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.213828]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.213834]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.213840]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.213846]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.213852]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.213857]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.213862]  [<c1035c84>] kthread+0x46/0x6a
[  330.213867]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.213872]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.213876] ---[ end trace ed36ea69408569f0 ]---
[  330.214482] ------------[ cut here ]------------
[  330.214486] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.214488] Hardware name: Studio 540      
[  330.214489] hotplug uevent
[  330.214490] Modules linked in:
[  330.214493] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.214494] Call Trace:
[  330.214498]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.214501]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.214504]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.214507]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.214510]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.214513]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.214516]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.214519]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.214521]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.214524]  [<c1035c84>] kthread+0x46/0x6a
[  330.214526]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.214529]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.214530] ---[ end trace ed36ea69408569f1 ]---
[  330.216255] ------------[ cut here ]------------
[  330.216265] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.216268] Hardware name: Studio 540      
[  330.216271] hotplug uevent
[  330.216273] Modules linked in:
[  330.216278] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.216281] Call Trace:
[  330.216289]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.216296]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.216302]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.216308]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.216314]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.216321]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.216327]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.216332]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.216338]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.216342]  [<c1035c84>] kthread+0x46/0x6a
[  330.216347]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.216352]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.216356] ---[ end trace ed36ea69408569f2 ]---
[  330.306226] ------------[ cut here ]------------
[  330.306237] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.306241] Hardware name: Studio 540      
[  330.306243] hotplug uevent
[  330.306246] Modules linked in:
[  330.306251] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.306254] Call Trace:
[  330.306262]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.306269]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.306275]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.306281]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.306288]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.306295]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.306301]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.306306]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.306312]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.306316]  [<c1035c84>] kthread+0x46/0x6a
[  330.306321]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.306327]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.306330] ---[ end trace ed36ea69408569f3 ]---
[  330.319973] ------------[ cut here ]------------
[  330.319983] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.319987] Hardware name: Studio 540      
[  330.319990] hotplug uevent
[  330.319992] Modules linked in:
[  330.319997] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.320000] Call Trace:
[  330.320008]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.320015]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.320021]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.320027]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.320034]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.320040]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.320047]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.320052]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.320058]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.320063]  [<c1035c84>] kthread+0x46/0x6a
[  330.320067]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.320073]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.320077] ---[ end trace ed36ea69408569f4 ]---
[  330.323429] ------------[ cut here ]------------
[  330.323439] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.323443] Hardware name: Studio 540      
[  330.323446] hotplug uevent
[  330.323448] Modules linked in:
[  330.323453] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.323456] Call Trace:
[  330.323465]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.323471]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.323477]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.323483]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.323490]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.323496]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.323502]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.323508]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.323513]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.323518]  [<c1035c84>] kthread+0x46/0x6a
[  330.323523]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.323528]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.323532] ---[ end trace ed36ea69408569f5 ]---
[  330.328399] ------------[ cut here ]------------
[  330.328409] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.328413] Hardware name: Studio 540      
[  330.328415] hotplug uevent
[  330.328417] Modules linked in:
[  330.328422] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.328425] Call Trace:
[  330.328433]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.328439]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.328445]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.328452]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.328458]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.328464]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.328470]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.328476]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.328481]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.328486]  [<c1035c84>] kthread+0x46/0x6a
[  330.328491]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.328496]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.328500] ---[ end trace ed36ea69408569f6 ]---
[  330.342124] ------------[ cut here ]------------
[  330.342145] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.342149] Hardware name: Studio 540      
[  330.342151] hotplug uevent
[  330.342153] Modules linked in:
[  330.342160] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.342164] Call Trace:
[  330.342173]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.342181]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.342188]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.342196]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.342205]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.342213]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.342221]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.342229]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.342236]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.342243]  [<c1035c84>] kthread+0x46/0x6a
[  330.342250]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.342257]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.342262] ---[ end trace ed36ea69408569f7 ]---
[  330.343392] ------------[ cut here ]------------
[  330.343401] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.343405] Hardware name: Studio 540      
[  330.343407] hotplug uevent
[  330.343410] Modules linked in:
[  330.343415] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.343418] Call Trace:
[  330.343425]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.343431]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.343438]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.343444]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.343450]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.343456]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.343462]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.343468]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.343474]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.343478]  [<c1035c84>] kthread+0x46/0x6a
[  330.343483]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.343488]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.343492] ---[ end trace ed36ea69408569f8 ]---
[  330.348845] ------------[ cut here ]------------
[  330.348855] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.348859] Hardware name: Studio 540      
[  330.348861] hotplug uevent
[  330.348863] Modules linked in:
[  330.348869] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.348872] Call Trace:
[  330.348880]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.348886]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.348892]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.348899]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.348905]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.348911]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.348917]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.348923]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.348928]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.348933]  [<c1035c84>] kthread+0x46/0x6a
[  330.348938]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.348944]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.348947] ---[ end trace ed36ea69408569f9 ]---
[  330.354325] ------------[ cut here ]------------
[  330.354334] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.354338] Hardware name: Studio 540      
[  330.354340] hotplug uevent
[  330.354342] Modules linked in:
[  330.354347] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.354350] Call Trace:
[  330.354358]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.354370]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.354376]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.354382]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.354389]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.354395]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.354401]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.354407]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.354412]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.354417]  [<c1035c84>] kthread+0x46/0x6a
[  330.354422]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.354427]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.354431] ---[ end trace ed36ea69408569fa ]---
[  330.362462] ------------[ cut here ]------------
[  330.362471] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.362475] Hardware name: Studio 540      
[  330.362477] hotplug uevent
[  330.362479] Modules linked in:
[  330.362485] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.362488] Call Trace:
[  330.362496]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.362502]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.362508]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.362514]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.362521]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.362527]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.362534]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.362539]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.362545]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.362550]  [<c1035c84>] kthread+0x46/0x6a
[  330.362554]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.362560]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.362564] ---[ end trace ed36ea69408569fb ]---
[  330.364460] ------------[ cut here ]------------
[  330.364469] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.364473] Hardware name: Studio 540      
[  330.364476] hotplug uevent
[  330.364478] Modules linked in:
[  330.364483] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.364486] Call Trace:
[  330.364494]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.364501]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.364507]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.364513]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.364520]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.364526]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.364532]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.364537]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.364543]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.364548]  [<c1035c84>] kthread+0x46/0x6a
[  330.364552]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.364558]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.364562] ---[ end trace ed36ea69408569fc ]---
[  330.365626] ------------[ cut here ]------------
[  330.365634] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.365638] Hardware name: Studio 540      
[  330.365640] hotplug uevent
[  330.365642] Modules linked in:
[  330.365648] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.365651] Call Trace:
[  330.365658]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.365664]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.365670]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.365676]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.365683]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.365689]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.365696]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.365701]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.365707]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.365712]  [<c1035c84>] kthread+0x46/0x6a
[  330.365716]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.365722]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.365726] ---[ end trace ed36ea69408569fd ]---
[  330.366301] ------------[ cut here ]------------
[  330.366310] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.366314] Hardware name: Studio 540      
[  330.366316] hotplug uevent
[  330.366318] Modules linked in:
[  330.366323] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.366326] Call Trace:
[  330.366334]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.366340]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.366346]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.366352]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.366359]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.366365]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.366371]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.366376]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.366382]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.366386]  [<c1035c84>] kthread+0x46/0x6a
[  330.366391]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.366396]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.366400] ---[ end trace ed36ea69408569fe ]---
[  330.390076] ------------[ cut here ]------------
[  330.390085] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.390089] Hardware name: Studio 540      
[  330.390092] hotplug uevent
[  330.390094] Modules linked in:
[  330.390099] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.390102] Call Trace:
[  330.390110]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.390116]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.390123]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.390139]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.390147]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.390153]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.390160]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.390167]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.390174]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.390180]  [<c1035c84>] kthread+0x46/0x6a
[  330.390186]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.390194]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.390200] ---[ end trace ed36ea69408569ff ]---
[  330.394393] ------------[ cut here ]------------
[  330.394403] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.394407] Hardware name: Studio 540      
[  330.394409] hotplug uevent
[  330.394411] Modules linked in:
[  330.394417] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.394420] Call Trace:
[  330.394428]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.394435]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.394441]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.394447]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.394453]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.394460]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.394466]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.394471]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.394477]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.394481]  [<c1035c84>] kthread+0x46/0x6a
[  330.394486]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.394492]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.394495] ---[ end trace ed36ea6940856a00 ]---
[  330.418237] ------------[ cut here ]------------
[  330.418249] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.418253] Hardware name: Studio 540      
[  330.418255] hotplug uevent
[  330.418257] Modules linked in:
[  330.418263] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.418266] Call Trace:
[  330.418275]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.418281]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.418287]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.418293]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.418300]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.418306]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.418313]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.418318]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.418324]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.418329]  [<c1035c84>] kthread+0x46/0x6a
[  330.418333]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.418339]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.418343] ---[ end trace ed36ea6940856a01 ]---
[  330.420214] ------------[ cut here ]------------
[  330.420224] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.420228] Hardware name: Studio 540      
[  330.420231] hotplug uevent
[  330.420234] Modules linked in:
[  330.420241] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.420245] Call Trace:
[  330.420253]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.420261]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.420269]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.420277]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.420285]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.420293]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.420301]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.420308]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.420316]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.420323]  [<c1035c84>] kthread+0x46/0x6a
[  330.420329]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.420336]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.420342] ---[ end trace ed36ea6940856a02 ]---
[  330.428478] ------------[ cut here ]------------
[  330.428488] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.428491] Hardware name: Studio 540      
[  330.428494] hotplug uevent
[  330.428496] Modules linked in:
[  330.428502] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.428505] Call Trace:
[  330.428514]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.428520]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.428526]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.428532]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.428539]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.428545]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.428551]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.428557]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.428563]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.428567]  [<c1035c84>] kthread+0x46/0x6a
[  330.428572]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.428578]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.428581] ---[ end trace ed36ea6940856a03 ]---
[  330.430477] ------------[ cut here ]------------
[  330.430486] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.430490] Hardware name: Studio 540      
[  330.430493] hotplug uevent
[  330.430495] Modules linked in:
[  330.430500] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.430503] Call Trace:
[  330.430510]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.430517]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.430523]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.430529]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.430536]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.430542]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.430548]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.430554]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.430559]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.430564]  [<c1035c84>] kthread+0x46/0x6a
[  330.430569]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.430574]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.430578] ---[ end trace ed36ea6940856a04 ]---
[  330.446978] ------------[ cut here ]------------
[  330.446987] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.446991] Hardware name: Studio 540      
[  330.446993] hotplug uevent
[  330.446995] Modules linked in:
[  330.447001] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.447014] Call Trace:
[  330.447023]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.447029]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.447036]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.447042]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.447048]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.447055]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.447061]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.447066]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.447072]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.447077]  [<c1035c84>] kthread+0x46/0x6a
[  330.447081]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.447087]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.447091] ---[ end trace ed36ea6940856a05 ]---
[  330.485599] ------------[ cut here ]------------
[  330.485608] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.485612] Hardware name: Studio 540      
[  330.485614] hotplug uevent
[  330.485617] Modules linked in:
[  330.485622] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.485625] Call Trace:
[  330.485633]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.485640]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.485646]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.485652]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.485659]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.485665]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.485671]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.485676]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.485682]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.485687]  [<c1035c84>] kthread+0x46/0x6a
[  330.485691]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.485697]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.485701] ---[ end trace ed36ea6940856a06 ]---
[  330.485811] ------------[ cut here ]------------
[  330.485820] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.485823] Hardware name: Studio 540      
[  330.485826] hotplug uevent
[  330.485828] Modules linked in:
[  330.485833] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.485836] Call Trace:
[  330.485843]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.485849]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.485855]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.485862]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.485868]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.485874]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.485881]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.485887]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.485892]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.485897]  [<c1035c84>] kthread+0x46/0x6a
[  330.485902]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.485908]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.485911] ---[ end trace ed36ea6940856a07 ]---
[  330.486336] ------------[ cut here ]------------
[  330.486343] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.486346] Hardware name: Studio 540      
[  330.486349] hotplug uevent
[  330.486351] Modules linked in:
[  330.486355] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.486358] Call Trace:
[  330.486365]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.486371]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.486377]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.486383]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.486390]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.486396]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.486402]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.486407]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.486413]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.486418]  [<c1035c84>] kthread+0x46/0x6a
[  330.486422]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.486428]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.486431] ---[ end trace ed36ea6940856a08 ]---
[  330.598497] ------------[ cut here ]------------
[  330.598511] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.598515] Hardware name: Studio 540      
[  330.598517] hotplug uevent
[  330.598520] Modules linked in:
[  330.598526] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.598529] Call Trace:
[  330.598538]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.598545]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.598551]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.598557]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.598564]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.598570]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.598576]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.598583]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.598588]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.598593]  [<c1035c84>] kthread+0x46/0x6a
[  330.598598]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.598603]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.598607] ---[ end trace ed36ea6940856a09 ]---
[  330.605939] ------------[ cut here ]------------
[  330.605950] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.605954] Hardware name: Studio 540      
[  330.605956] hotplug uevent
[  330.605958] Modules linked in:
[  330.605964] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.605967] Call Trace:
[  330.605975]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.605982]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.605988]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.605994]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.606001]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.606017]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.606023]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.606029]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.606036]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.606042]  [<c1035c84>] kthread+0x46/0x6a
[  330.606048]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.606056]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.606060] ---[ end trace ed36ea6940856a0a ]---
[  330.611960] ------------[ cut here ]------------
[  330.611970] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.611974] Hardware name: Studio 540      
[  330.611976] hotplug uevent
[  330.611979] Modules linked in:
[  330.611984] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.611987] Call Trace:
[  330.611995]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.612001]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.612017]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.612024]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.612031]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.612038]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.612046]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.612053]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.612060]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.612067]  [<c1035c84>] kthread+0x46/0x6a
[  330.612073]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.612080]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.612084] ---[ end trace ed36ea6940856a0b ]---
[  330.615512] ------------[ cut here ]------------
[  330.615522] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.615526] Hardware name: Studio 540      
[  330.615528] hotplug uevent
[  330.615530] Modules linked in:
[  330.615535] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.615538] Call Trace:
[  330.615546]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.615553]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.615559]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.615565]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.615571]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.615578]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.615584]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.615590]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.615595]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.615600]  [<c1035c84>] kthread+0x46/0x6a
[  330.615604]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.615610]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.615614] ---[ end trace ed36ea6940856a0c ]---
[  330.621023] ------------[ cut here ]------------
[  330.621033] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.621037] Hardware name: Studio 540      
[  330.621039] hotplug uevent
[  330.621042] Modules linked in:
[  330.621048] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.621051] Call Trace:
[  330.621059]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.621066]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.621072]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.621078]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.621085]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.621091]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.621097]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.621102]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.621108]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.621113]  [<c1035c84>] kthread+0x46/0x6a
[  330.621117]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.621123]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.621137] ---[ end trace ed36ea6940856a0d ]---
[  330.636383] ------------[ cut here ]------------
[  330.636393] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.636397] Hardware name: Studio 540      
[  330.636400] hotplug uevent
[  330.636402] Modules linked in:
[  330.636408] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.636411] Call Trace:
[  330.636420]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.636426]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.636432]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.636438]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.636445]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.636452]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.636458]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.636463]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.636469]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.636474]  [<c1035c84>] kthread+0x46/0x6a
[  330.636478]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.636484]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.636488] ---[ end trace ed36ea6940856a0e ]---
[  330.643399] ------------[ cut here ]------------
[  330.643410] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.643414] Hardware name: Studio 540      
[  330.643416] hotplug uevent
[  330.643419] Modules linked in:
[  330.643424] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.643427] Call Trace:
[  330.643435]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.643442]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.643448]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.643454]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.643461]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.643467]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.643473]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.643479]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.643484]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.643489]  [<c1035c84>] kthread+0x46/0x6a
[  330.643494]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.643499]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.643503] ---[ end trace ed36ea6940856a0f ]---
[  330.724303] ------------[ cut here ]------------
[  330.724315] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.724319] Hardware name: Studio 540      
[  330.724322] hotplug uevent
[  330.724324] Modules linked in:
[  330.724329] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.724333] Call Trace:
[  330.724342]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.724348]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.724355]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.724361]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.724368]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.724374]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.724380]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.724385]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.724391]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.724396]  [<c1035c84>] kthread+0x46/0x6a
[  330.724401]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.724407]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.724411] ---[ end trace ed36ea6940856a10 ]---
[  330.726642] ------------[ cut here ]------------
[  330.726652] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.726656] Hardware name: Studio 540      
[  330.726659] hotplug uevent
[  330.726661] Modules linked in:
[  330.726666] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.726669] Call Trace:
[  330.726678]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.726684]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.726690]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.726696]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.726703]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.726709]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.726715]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.726721]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.726726]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.726731]  [<c1035c84>] kthread+0x46/0x6a
[  330.726736]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.726741]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.726745] ---[ end trace ed36ea6940856a11 ]---
[  330.728829] ------------[ cut here ]------------
[  330.728838] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.728842] Hardware name: Studio 540      
[  330.728844] hotplug uevent
[  330.728846] Modules linked in:
[  330.728851] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.728854] Call Trace:
[  330.728862]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.728869]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.728875]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.728881]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.728888]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.728894]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.728900]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.728905]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.728911]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.728916]  [<c1035c84>] kthread+0x46/0x6a
[  330.728920]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.728926]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.728929] ---[ end trace ed36ea6940856a12 ]---
[  330.730577] ------------[ cut here ]------------
[  330.730586] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.730590] Hardware name: Studio 540      
[  330.730592] hotplug uevent
[  330.730594] Modules linked in:
[  330.730600] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.730603] Call Trace:
[  330.730610]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.730617]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.730623]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.730629]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.730636]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.730642]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.730648]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.730654]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.730660]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.730664]  [<c1035c84>] kthread+0x46/0x6a
[  330.730669]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.730675]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.730679] ---[ end trace ed36ea6940856a13 ]---
[  330.732319] ------------[ cut here ]------------
[  330.732328] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.732332] Hardware name: Studio 540      
[  330.732334] hotplug uevent
[  330.732336] Modules linked in:
[  330.732342] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.732345] Call Trace:
[  330.732352]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.732361]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.732368]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.732377]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.732385]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.732393]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.732401]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.732409]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.732417]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.732423]  [<c1035c84>] kthread+0x46/0x6a
[  330.732427]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.732430] ------------[ cut here ]------------
[  330.732440] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.732444] Hardware name: Studio 540      
[  330.732446] hotplug uevent
[  330.732448] Modules linked in:
[  330.732455]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.732459] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.732462] Call Trace:
[  330.732467] ---[ end trace ed36ea6940856a14 ]---
[  330.732473]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.732480]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.732486]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.732492]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.732499]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.732505]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.732511]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.732516]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.732522]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.732527]  [<c1035c84>] kthread+0x46/0x6a
[  330.732531]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.732537]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.732541] ---[ end trace ed36ea6940856a15 ]---
[  330.732556] ------------[ cut here ]------------
[  330.732563] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.732568] Hardware name: Studio 540      
[  330.732571] hotplug uevent
[  330.732574] Modules linked in:
[  330.732580] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.732584] Call Trace:
[  330.732591]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.732598]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.732606]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.732613]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.732622]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.732629]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.732637]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.732645]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.732653]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.732659]  [<c1035c84>] kthread+0x46/0x6a
[  330.732666]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.732673]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.732678] ---[ end trace ed36ea6940856a16 ]---
[  330.732832] ------------[ cut here ]------------
[  330.732838] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.732842] Hardware name: Studio 540      
[  330.732844] hotplug uevent
[  330.732846] Modules linked in:
[  330.732851] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.732854] Call Trace:
[  330.732860]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.732866]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.732872]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.732878]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.732885]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.732891]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.732897]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.732902]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.732908]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.732913]  [<c1035c84>] kthread+0x46/0x6a
[  330.732918]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.732923]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.732927] ---[ end trace ed36ea6940856a17 ]---
[  330.733081] ------------[ cut here ]------------
[  330.733089] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.733094] Hardware name: Studio 540      
[  330.733097] hotplug uevent
[  330.733100] Modules linked in:
[  330.733106] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.733110] Call Trace:
[  330.733117]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.733125]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.733140]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.733148]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.733157]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.733164]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.733172]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.733179]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.733187]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.733194]  [<c1035c84>] kthread+0x46/0x6a
[  330.733200]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.733208]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.733213] ---[ end trace ed36ea6940856a18 ]---
[  330.733289] ------------[ cut here ]------------
[  330.733295] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.733299] Hardware name: Studio 540      
[  330.733301] hotplug uevent
[  330.733303] Modules linked in:
[  330.733308] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.733311] Call Trace:
[  330.733317]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.733323]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.733329]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.733335]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.733342]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.733347]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.733353]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.733359]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.733364]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.733369]  [<c1035c84>] kthread+0x46/0x6a
[  330.733374]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.733379]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.733382] ---[ end trace ed36ea6940856a19 ]---
[  330.733765] ------------[ cut here ]------------
[  330.733773] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.733776] Hardware name: Studio 540      
[  330.733779] hotplug uevent
[  330.733781] Modules linked in:
[  330.733785] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.733788] Call Trace:
[  330.733795]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.733801]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.733807]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.733813]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.733820]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.733826]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.733832]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.733837]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.733843]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.733848]  [<c1035c84>] kthread+0x46/0x6a
[  330.733852]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.733858]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.733861] ---[ end trace ed36ea6940856a1a ]---
[  330.738384] ------------[ cut here ]------------
[  330.738392] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.738395] Hardware name: Studio 540      
[  330.738398] hotplug uevent
[  330.738400] Modules linked in:
[  330.738405] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.738408] Call Trace:
[  330.738415]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.738421]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.738428]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.738434]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.738440]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.738446]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.738453]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.738458]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.738464]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.738469]  [<c1035c84>] kthread+0x46/0x6a
[  330.738473]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.738479]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.738482] ---[ end trace ed36ea6940856a1b ]---
[  330.738765] ------------[ cut here ]------------
[  330.738772] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.738775] Hardware name: Studio 540      
[  330.738778] hotplug uevent
[  330.738780] Modules linked in:
[  330.738784] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.738787] Call Trace:
[  330.738793]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.738801]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.738808]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.738816]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.738824]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.738831]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.738839]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.738846]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.738853]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.738860]  [<c1035c84>] kthread+0x46/0x6a
[  330.738867]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.738874]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.738879] ---[ end trace ed36ea6940856a1c ]---
[  330.739971] ------------[ cut here ]------------
[  330.739978] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.739982] Hardware name: Studio 540      
[  330.739984] hotplug uevent
[  330.739986] Modules linked in:
[  330.739990] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.739993] Call Trace:
[  330.740000]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.740006]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.740012]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.740018]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.740025]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.740031]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.740037]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.740042]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.740048]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.740053]  [<c1035c84>] kthread+0x46/0x6a
[  330.740057]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.740063]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.740066] ---[ end trace ed36ea6940856a1d ]---
[  330.745214] ------------[ cut here ]------------
[  330.745220] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.745222] Hardware name: Studio 540      
[  330.745223] hotplug uevent
[  330.745224] Modules linked in:
[  330.745227] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.745229] Call Trace:
[  330.745233]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.745237]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.745240]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.745242]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.745246]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.745249]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.745252]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.745255]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.745257]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.745260]  [<c1035c84>] kthread+0x46/0x6a
[  330.745262]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.745265]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.745267] ---[ end trace ed36ea6940856a1e ]---
[  330.750527] ------------[ cut here ]------------
[  330.750538] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.750543] Hardware name: Studio 540      
[  330.750545] hotplug uevent
[  330.750547] Modules linked in:
[  330.750553] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.750556] Call Trace:
[  330.750564]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.750571]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.750577]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.750583]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.750590]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.750596]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.750602]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.750608]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.750613]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.750618]  [<c1035c84>] kthread+0x46/0x6a
[  330.750622]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.750628]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.750632] ---[ end trace ed36ea6940856a1f ]---
[  330.755344] ------------[ cut here ]------------
[  330.755353] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.755357] Hardware name: Studio 540      
[  330.755359] hotplug uevent
[  330.755361] Modules linked in:
[  330.755367] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.755370] Call Trace:
[  330.755378]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.755384]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.755390]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.755396]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.755403]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.755409]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.755415]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.755420]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.755426]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.755431]  [<c1035c84>] kthread+0x46/0x6a
[  330.755435]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.755441]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.755444] ---[ end trace ed36ea6940856a20 ]---
[  330.770043] ------------[ cut here ]------------
[  330.770056] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.770060] Hardware name: Studio 540      
[  330.770062] hotplug uevent
[  330.770064] Modules linked in:
[  330.770070] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.770074] Call Trace:
[  330.770083]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.770089]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.770095]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.770101]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.770109]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.770115]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.770121]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.770127]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.770144]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.770149]  [<c1035c84>] kthread+0x46/0x6a
[  330.770154]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.770160]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.770164] ---[ end trace ed36ea6940856a21 ]---
[  330.771372] ------------[ cut here ]------------
[  330.771382] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.771386] Hardware name: Studio 540      
[  330.771388] hotplug uevent
[  330.771390] Modules linked in:
[  330.771395] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.771399] Call Trace:
[  330.771406]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.771413]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.771419]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.771425]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.771432]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.771437]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.771443]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.771449]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.771454]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.771459]  [<c1035c84>] kthread+0x46/0x6a
[  330.771464]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.771469]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.771473] ---[ end trace ed36ea6940856a22 ]---
[  330.777607] ------------[ cut here ]------------
[  330.777618] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.777622] Hardware name: Studio 540      
[  330.777624] hotplug uevent
[  330.777626] Modules linked in:
[  330.777632] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.777635] Call Trace:
[  330.777643]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.777649]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.777655]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.777662]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.777668]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.777675]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.777681]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.777686]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.777692]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.777697]  [<c1035c84>] kthread+0x46/0x6a
[  330.777701]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.777707]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.777711] ---[ end trace ed36ea6940856a23 ]---
[  330.779221] ------------[ cut here ]------------
[  330.779230] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.779234] Hardware name: Studio 540      
[  330.779236] hotplug uevent
[  330.779238] Modules linked in:
[  330.779243] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.779247] Call Trace:
[  330.779254]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.779260]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.779266]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.779272]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.779279]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.779285]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.779291]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.779297]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.779302]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.779307]  [<c1035c84>] kthread+0x46/0x6a
[  330.779312]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.779317]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.779321] ---[ end trace ed36ea6940856a24 ]---
[  330.781463] ------------[ cut here ]------------
[  330.781472] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.781476] Hardware name: Studio 540      
[  330.781479] hotplug uevent
[  330.781481] Modules linked in:
[  330.781486] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.781489] Call Trace:
[  330.781497]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.781503]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.781509]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.781515]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.781522]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.781529]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.781535]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.781540]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.781546]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.781551]  [<c1035c84>] kthread+0x46/0x6a
[  330.781556]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.781561]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.781565] ---[ end trace ed36ea6940856a25 ]---
[  330.785840] ------------[ cut here ]------------
[  330.785851] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.785855] Hardware name: Studio 540      
[  330.785857] hotplug uevent
[  330.785859] Modules linked in:
[  330.785865] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.785868] Call Trace:
[  330.785876]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.785883]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.785889]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.785895]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.785902]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.785908]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.785914]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.785920]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.785925]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.785930]  [<c1035c84>] kthread+0x46/0x6a
[  330.785935]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.785940]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.785944] ---[ end trace ed36ea6940856a26 ]---
[  330.785956] ------------[ cut here ]------------
[  330.785965] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.785969] Hardware name: Studio 540      
[  330.785971] hotplug uevent
[  330.785973] Modules linked in:
[  330.785978] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.785981] Call Trace:
[  330.785988]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.785995]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.786001]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.786018]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.786024]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.786031]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.786037]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.786042]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.786048]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.786053]  [<c1035c84>] kthread+0x46/0x6a
[  330.786058]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.786063]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.786067] ---[ end trace ed36ea6940856a27 ]---
[  330.856878] ------------[ cut here ]------------
[  330.856891] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.856895] Hardware name: Studio 540      
[  330.856897] hotplug uevent
[  330.856899] Modules linked in:
[  330.856905] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.856909] Call Trace:
[  330.856917]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.856924]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.856930]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.856936]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.856943]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.856949]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.856955]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.856961]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.856966]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.856971]  [<c1035c84>] kthread+0x46/0x6a
[  330.856976]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.856982]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.856986] ---[ end trace ed36ea6940856a28 ]---
[  330.868063] ------------[ cut here ]------------
[  330.868076] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.868080] Hardware name: Studio 540      
[  330.868082] hotplug uevent
[  330.868085] Modules linked in:
[  330.868091] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.868094] Call Trace:
[  330.868103]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.868110]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.868116]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.868122]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.868141]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.868148]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.868154]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.868160]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.868166]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.868170]  [<c1035c84>] kthread+0x46/0x6a
[  330.868176]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.868184]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.868189] ---[ end trace ed36ea6940856a29 ]---
[  330.872975] ------------[ cut here ]------------
[  330.872985] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.872989] Hardware name: Studio 540      
[  330.872992] hotplug uevent
[  330.872994] Modules linked in:
[  330.872999] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  330.873012] Call Trace:
[  330.873021]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.873028]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.873034]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.873040]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.873047]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.873053]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.873059]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.873064]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.873070]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.873075]  [<c1035c84>] kthread+0x46/0x6a
[  330.873079]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.873085]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.873088] ---[ end trace ed36ea6940856a2a ]---
[  330.910719] ------------[ cut here ]------------
[  330.910730] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  330.910734] Hardware name: Studio 540      
[  330.910736] hotplug uevent
[  330.910738] Modules linked in:
[  330.910744] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  330.910747] Call Trace:
[  330.910755]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  330.910762]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  330.910768]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  330.910774]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  330.910781]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  330.910787]  [<c1032f28>] worker_thread+0x131/0x1ab
[  330.910793]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  330.910798]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  330.910804]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  330.910809]  [<c1035c84>] kthread+0x46/0x6a
[  330.910813]  [<c1035c3e>] ? kthread+0x0/0x6a
[  330.910819]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  330.910823] ---[ end trace ed36ea6940856a2b ]---
[  331.054933] ------------[ cut here ]------------
[  331.054945] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.054949] Hardware name: Studio 540      
[  331.054951] hotplug uevent
[  331.054953] Modules linked in:
[  331.054959] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  331.054963] Call Trace:
[  331.054972]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.054978]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.054984]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.054990]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.054997]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.055004]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.055010]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.055016]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.055021]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.055026]  [<c1035c84>] kthread+0x46/0x6a
[  331.055031]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.055037]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.055041] ---[ end trace ed36ea6940856a2c ]---
[  331.058023] ------------[ cut here ]------------
[  331.058033] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.058037] Hardware name: Studio 540      
[  331.058039] hotplug uevent
[  331.058041] Modules linked in:
[  331.058047] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  331.058050] Call Trace:
[  331.058058]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.058064]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.058070]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.058076]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.058083]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.058089]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.058095]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.058100]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.058106]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.058111]  [<c1035c84>] kthread+0x46/0x6a
[  331.058115]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.058121]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.058125] ---[ end trace ed36ea6940856a2d ]---
[  331.064854] ------------[ cut here ]------------
[  331.064864] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.064868] Hardware name: Studio 540      
[  331.064870] hotplug uevent
[  331.064873] Modules linked in:
[  331.064878] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  331.064881] Call Trace:
[  331.064889]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.064896]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.064902]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.064908]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.064915]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.064921]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.064927]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.064933]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.064938]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.064943]  [<c1035c84>] kthread+0x46/0x6a
[  331.064947]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.064953]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.064957] ---[ end trace ed36ea6940856a2e ]---
[  331.331411] ------------[ cut here ]------------
[  331.331424] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.331428] Hardware name: Studio 540      
[  331.331430] hotplug uevent
[  331.331433] Modules linked in:
[  331.331439] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  331.331442] Call Trace:
[  331.331452]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.331458]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.331464]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.331470]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.331477]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.331484]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.331490]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.331496]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.331502]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.331507]  [<c1035c84>] kthread+0x46/0x6a
[  331.331511]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.331517]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.331521] ---[ end trace ed36ea6940856a2f ]---
[  331.447834] ------------[ cut here ]------------
[  331.447847] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.447851] Hardware name: Studio 540      
[  331.447854] hotplug uevent
[  331.447856] Modules linked in:
[  331.447862] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  331.447866] Call Trace:
[  331.447875]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.447882]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.447888]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.447894]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.447901]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.447907]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.447913]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.447919]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.447925]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.447930]  [<c1035c84>] kthread+0x46/0x6a
[  331.447934]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.447940]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.447949] ---[ end trace ed36ea6940856a30 ]---
[  331.580061] ------------[ cut here ]------------
[  331.580073] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.580077] Hardware name: Studio 540      
[  331.580080] hotplug uevent
[  331.580082] Modules linked in:
[  331.580088] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  331.580091] Call Trace:
[  331.580100]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.580107]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.580113]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.580119]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.580126]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.580146]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.580152]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.580158]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.580164]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.580170]  [<c1035c84>] kthread+0x46/0x6a
[  331.580176]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.580183]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.580188] ---[ end trace ed36ea6940856a31 ]---
[  331.601650] ------------[ cut here ]------------
[  331.601660] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.601664] Hardware name: Studio 540      
[  331.601666] hotplug uevent
[  331.601668] Modules linked in:
[  331.601673] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  331.601677] Call Trace:
[  331.601685]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.601691]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.601697]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.601703]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.601710]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.601717]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.601723]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.601728]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.601734]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.601739]  [<c1035c84>] kthread+0x46/0x6a
[  331.601743]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.601749]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.601753] ---[ end trace ed36ea6940856a32 ]---
[  331.618972] ------------[ cut here ]------------
[  331.618982] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.618985] Hardware name: Studio 540      
[  331.618988] hotplug uevent
[  331.618990] Modules linked in:
[  331.618995] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  331.618998] Call Trace:
[  331.619016]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.619023]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.619029]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.619035]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.619042]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.619048]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.619054]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.619059]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.619065]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.619070]  [<c1035c84>] kthread+0x46/0x6a
[  331.619074]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.619081]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.619084] ---[ end trace ed36ea6940856a33 ]---
[  331.692488] ------------[ cut here ]------------
[  331.692500] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.692504] Hardware name: Studio 540      
[  331.692507] hotplug uevent
[  331.692509] Modules linked in:
[  331.692515] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  331.692518] Call Trace:
[  331.692527]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.692534]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.692540]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.692546]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.692553]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.692560]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.692566]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.692572]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.692577]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.692582]  [<c1035c84>] kthread+0x46/0x6a
[  331.692587]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.692592]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.692596] ---[ end trace ed36ea6940856a34 ]---
[  331.717984] ------------[ cut here ]------------
[  331.717993] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.717997] Hardware name: Studio 540      
[  331.718000] hotplug uevent
[  331.718002] Modules linked in:
[  331.718007] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  331.718010] Call Trace:
[  331.718018]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.718025]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.718031]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.718037]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.718044]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.718050]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.718056]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.718061]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.718067]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.718072]  [<c1035c84>] kthread+0x46/0x6a
[  331.718076]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.718082]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.718086] ---[ end trace ed36ea6940856a35 ]---
[  331.729935] ------------[ cut here ]------------
[  331.729944] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.729948] Hardware name: Studio 540      
[  331.729951] hotplug uevent
[  331.729953] Modules linked in:
[  331.729958] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  331.729961] Call Trace:
[  331.729969]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.729975]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.729981]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.729987]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.729994]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.730000]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.730006]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.730012]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.730017]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.730022]  [<c1035c84>] kthread+0x46/0x6a
[  331.730027]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.730032]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.730036] ---[ end trace ed36ea6940856a36 ]---
[  331.752413] ------------[ cut here ]------------
[  331.752422] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  331.752426] Hardware name: Studio 540      
[  331.752429] hotplug uevent
[  331.752431] Modules linked in:
[  331.752436] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  331.752439] Call Trace:
[  331.752447]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  331.752454]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  331.752460]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  331.752466]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  331.752473]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  331.752480]  [<c1032f28>] worker_thread+0x131/0x1ab
[  331.752486]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  331.752492]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  331.752497]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  331.752502]  [<c1035c84>] kthread+0x46/0x6a
[  331.752507]  [<c1035c3e>] ? kthread+0x0/0x6a
[  331.752513]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  331.752516] ---[ end trace ed36ea6940856a37 ]---
[  332.020145] ------------[ cut here ]------------
[  332.020158] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.020162] Hardware name: Studio 540      
[  332.020164] hotplug uevent
[  332.020167] Modules linked in:
[  332.020173] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.020176] Call Trace:
[  332.020185]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.020192]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.020198]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.020204]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.020211]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.020217]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.020223]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.020229]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.020235]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.020240]  [<c1035c84>] kthread+0x46/0x6a
[  332.020244]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.020250]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.020254] ---[ end trace ed36ea6940856a38 ]---
[  332.063756] ------------[ cut here ]------------
[  332.063766] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.063770] Hardware name: Studio 540      
[  332.063772] hotplug uevent
[  332.063774] Modules linked in:
[  332.063780] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.063783] Call Trace:
[  332.063792]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.063798]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.063804]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.063810]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.063817]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.063823]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.063829]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.063835]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.063841]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.063845]  [<c1035c84>] kthread+0x46/0x6a
[  332.063850]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.063856]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.063859] ---[ end trace ed36ea6940856a39 ]---
[  332.068905] ------------[ cut here ]------------
[  332.068916] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.068920] Hardware name: Studio 540      
[  332.068923] hotplug uevent
[  332.068925] Modules linked in:
[  332.068930] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.068934] Call Trace:
[  332.068942]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.068949]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.068955]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.068961]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.068968]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.068974]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.068980]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.068986]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.068992]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.068997]  [<c1035c84>] kthread+0x46/0x6a
[  332.069001]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.069017]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.069021] ---[ end trace ed36ea6940856a3a ]---
[  332.077165] ------------[ cut here ]------------
[  332.077175] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.077179] Hardware name: Studio 540      
[  332.077181] hotplug uevent
[  332.077184] Modules linked in:
[  332.077189] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.077192] Call Trace:
[  332.077200]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.077207]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.077213]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.077219]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.077226]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.077233]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.077239]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.077244]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.077250]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.077255]  [<c1035c84>] kthread+0x46/0x6a
[  332.077259]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.077265]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.077268] ---[ end trace ed36ea6940856a3b ]---
[  332.091047] ------------[ cut here ]------------
[  332.091058] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.091062] Hardware name: Studio 540      
[  332.091064] hotplug uevent
[  332.091066] Modules linked in:
[  332.091072] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.091075] Call Trace:
[  332.091083]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.091090]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.091096]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.091102]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.091109]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.091115]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.091121]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.091127]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.091143]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.091148]  [<c1035c84>] kthread+0x46/0x6a
[  332.091152]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.091158]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.091162] ---[ end trace ed36ea6940856a3c ]---
[  332.137330] ------------[ cut here ]------------
[  332.137341] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.137345] Hardware name: Studio 540      
[  332.137347] hotplug uevent
[  332.137349] Modules linked in:
[  332.137355] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.137358] Call Trace:
[  332.137366]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.137373]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.137379]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.137385]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.137391]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.137398]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.137404]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.137410]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.137415]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.137420]  [<c1035c84>] kthread+0x46/0x6a
[  332.137425]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.137431]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.137434] ---[ end trace ed36ea6940856a3d ]---
[  332.140928] ------------[ cut here ]------------
[  332.140939] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.140943] Hardware name: Studio 540      
[  332.140945] hotplug uevent
[  332.140947] Modules linked in:
[  332.140953] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.140956] Call Trace:
[  332.140964]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.140971]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.140977]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.140983]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.140990]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.140996]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.141014]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.141020]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.141026]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.141031]  [<c1035c84>] kthread+0x46/0x6a
[  332.141035]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.141041]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.141045] ---[ end trace ed36ea6940856a3e ]---
[  332.142399] ------------[ cut here ]------------
[  332.142408] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.142412] Hardware name: Studio 540      
[  332.142414] hotplug uevent
[  332.142416] Modules linked in:
[  332.142421] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.142424] Call Trace:
[  332.142432]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.142438]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.142444]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.142450]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.142457]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.142463]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.142469]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.142475]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.142480]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.142485]  [<c1035c84>] kthread+0x46/0x6a
[  332.142490]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.142495]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.142499] ---[ end trace ed36ea6940856a3f ]---
[  332.149847] ------------[ cut here ]------------
[  332.149858] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.149862] Hardware name: Studio 540      
[  332.149864] hotplug uevent
[  332.149866] Modules linked in:
[  332.149872] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.149875] Call Trace:
[  332.149883]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.149890]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.149896]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.149902]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.149909]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.149915]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.149921]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.149927]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.149933]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.149937]  [<c1035c84>] kthread+0x46/0x6a
[  332.149942]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.149948]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.149951] ---[ end trace ed36ea6940856a40 ]---
[  332.157011] ------------[ cut here ]------------
[  332.157022] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.157026] Hardware name: Studio 540      
[  332.157028] hotplug uevent
[  332.157030] Modules linked in:
[  332.157036] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.157039] Call Trace:
[  332.157048]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.157055]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.157061]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.157067]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.157074]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.157080]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.157086]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.157092]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.157098]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.157103]  [<c1035c84>] kthread+0x46/0x6a
[  332.157107]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.157113]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.157117] ---[ end trace ed36ea6940856a41 ]---
[  332.159925] ------------[ cut here ]------------
[  332.159934] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.159938] Hardware name: Studio 540      
[  332.159941] hotplug uevent
[  332.159943] Modules linked in:
[  332.159948] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.159951] Call Trace:
[  332.159959]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.159966]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.159972]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.159978]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.159985]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.159991]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.159997]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.160019]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.160024]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.160029]  [<c1035c84>] kthread+0x46/0x6a
[  332.160033]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.160039]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.160043] ---[ end trace ed36ea6940856a42 ]---
[  332.185576] ------------[ cut here ]------------
[  332.185590] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.185594] Hardware name: Studio 540      
[  332.185597] hotplug uevent
[  332.185599] Modules linked in:
[  332.185605] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.185608] Call Trace:
[  332.185617]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.185624]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.185630]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.185636]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.185643]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.185649]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.185655]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.185661]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.185667]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.185672]  [<c1035c84>] kthread+0x46/0x6a
[  332.185676]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.185682]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.185686] ---[ end trace ed36ea6940856a43 ]---
[  332.207930] ------------[ cut here ]------------
[  332.207943] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.207948] Hardware name: Studio 540      
[  332.207950] hotplug uevent
[  332.207952] Modules linked in:
[  332.207958] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.207961] Call Trace:
[  332.207970]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.207977]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.207983]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.207989]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.207996]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.208002]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.208027]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.208033]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.208039]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.208044]  [<c1035c84>] kthread+0x46/0x6a
[  332.208048]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.208054]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.208058] ---[ end trace ed36ea6940856a44 ]---
[  332.222572] ------------[ cut here ]------------
[  332.222583] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.222587] Hardware name: Studio 540      
[  332.222589] hotplug uevent
[  332.222591] Modules linked in:
[  332.222597] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.222600] Call Trace:
[  332.222608]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.222615]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.222621]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.222627]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.222634]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.222640]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.222647]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.222652]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.222658]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.222663]  [<c1035c84>] kthread+0x46/0x6a
[  332.222668]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.222674]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.222677] ---[ end trace ed36ea6940856a45 ]---
[  332.224323] ------------[ cut here ]------------
[  332.224332] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.224336] Hardware name: Studio 540      
[  332.224339] hotplug uevent
[  332.224341] Modules linked in:
[  332.224346] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.224349] Call Trace:
[  332.224356]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.224363]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.224369]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.224375]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.224381]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.224387]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.224393]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.224399]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.224404]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.224409]  [<c1035c84>] kthread+0x46/0x6a
[  332.224414]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.224419]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.224423] ---[ end trace ed36ea6940856a46 ]---
[  332.226625] ------------[ cut here ]------------
[  332.226635] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.226639] Hardware name: Studio 540      
[  332.226641] hotplug uevent
[  332.226643] Modules linked in:
[  332.226649] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.226652] Call Trace:
[  332.226660]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.226666]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.226672]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.226678]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.226685]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.226691]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.226698]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.226703]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.226709]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.226713]  [<c1035c84>] kthread+0x46/0x6a
[  332.226718]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.226724]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.226727] ---[ end trace ed36ea6940856a47 ]---
[  332.230139] ------------[ cut here ]------------
[  332.230148] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.230152] Hardware name: Studio 540      
[  332.230154] hotplug uevent
[  332.230156] Modules linked in:
[  332.230162] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.230165] Call Trace:
[  332.230173]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.230179]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.230185]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.230191]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.230198]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.230204]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.230210]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.230216]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.230221]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.230226]  [<c1035c84>] kthread+0x46/0x6a
[  332.230230]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.230236]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.230240] ---[ end trace ed36ea6940856a48 ]---
[  332.231307] ------------[ cut here ]------------
[  332.231315] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.231319] Hardware name: Studio 540      
[  332.231321] hotplug uevent
[  332.231323] Modules linked in:
[  332.231328] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.231331] Call Trace:
[  332.231338]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.231344]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.231350]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.231357]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.231363]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.231369]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.231375]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.231381]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.231386]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.231391]  [<c1035c84>] kthread+0x46/0x6a
[  332.231396]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.231401]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.231405] ---[ end trace ed36ea6940856a49 ]---
[  332.232395] ------------[ cut here ]------------
[  332.232403] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.232407] Hardware name: Studio 540      
[  332.232409] hotplug uevent
[  332.232411] Modules linked in:
[  332.232416] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.232419] Call Trace:
[  332.232426]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.232432]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.232439]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.232445]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.232451]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.232457]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.232463]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.232468]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.232474]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.232479]  [<c1035c84>] kthread+0x46/0x6a
[  332.232483]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.232489]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.232492] ---[ end trace ed36ea6940856a4a ]---
[  332.232499] ------------[ cut here ]------------
[  332.232508] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.232512] Hardware name: Studio 540      
[  332.232514] hotplug uevent
[  332.232516] Modules linked in:
[  332.232521] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.232524] Call Trace:
[  332.232531]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.232538]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.232544]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.232550]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.232557]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.232563]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.232569]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.232575]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.232580]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.232585]  [<c1035c84>] kthread+0x46/0x6a
[  332.232590]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.232596]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.232599] ---[ end trace ed36ea6940856a4b ]---
[  332.233173] ------------[ cut here ]------------
[  332.233180] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.233184] Hardware name: Studio 540      
[  332.233186] hotplug uevent
[  332.233188] Modules linked in:
[  332.233193] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.233196] Call Trace:
[  332.233202]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.233208]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.233214]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.233220]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.233227]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.233233]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.233239]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.233244]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.233250]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.233255]  [<c1035c84>] kthread+0x46/0x6a
[  332.233259]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.233265]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.233268] ---[ end trace ed36ea6940856a4c ]---
[  332.233528] ------------[ cut here ]------------
[  332.233536] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.233540] Hardware name: Studio 540      
[  332.233542] hotplug uevent
[  332.233544] Modules linked in:
[  332.233549] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.233552] Call Trace:
[  332.233559]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.233565]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.233571]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.233577]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.233584]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.233590]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.233596]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.233601]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.233607]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.233611]  [<c1035c84>] kthread+0x46/0x6a
[  332.233616]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.233621]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.233625] ---[ end trace ed36ea6940856a4d ]---
[  332.234113] ------------[ cut here ]------------
[  332.234120] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.234136] Hardware name: Studio 540      
[  332.234138] hotplug uevent
[  332.234140] Modules linked in:
[  332.234145] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.234148] Call Trace:
[  332.234155]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.234161]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.234167]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.234174]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.234180]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.234186]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.234192]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.234195] ------------[ cut here ]------------
[  332.234202] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.234206] Hardware name: Studio 540      
[  332.234208] hotplug uevent
[  332.234211] Modules linked in:
[  332.234215] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.234221]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.234227]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.234232]  [<c1035c84>] kthread+0x46/0x6a
[  332.234235] Call Trace:
[  332.234240]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.234247]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.234253]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.234260]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.234266]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.234270] ---[ end trace ed36ea6940856a4e ]---
[  332.234277]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.234284]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.234290]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.234297]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.234304]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.234312]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.234318]  [<c1035c84>] kthread+0x46/0x6a
[  332.234325]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.234332]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.234338] ---[ end trace ed36ea6940856a4f ]---
[  332.234563] ------------[ cut here ]------------
[  332.234570] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.234573] Hardware name: Studio 540      
[  332.234575] hotplug uevent
[  332.234577] Modules linked in:
[  332.234582] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.234585] Call Trace:
[  332.234591]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.234598]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.234604]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.234610]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.234616]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.234622]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.234628]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.234633]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.234639]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.234644]  [<c1035c84>] kthread+0x46/0x6a
[  332.234648]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.234654]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.234657] ---[ end trace ed36ea6940856a50 ]---
[  332.234774] ------------[ cut here ]------------
[  332.234782] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.234787] Hardware name: Studio 540      
[  332.234791] hotplug uevent
[  332.234794] Modules linked in:
[  332.234799] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.234804] Call Trace:
[  332.234811]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.234819]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.234827]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.234835]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.234843]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.234851]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.234859]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.234866]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.234874]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.234881]  [<c1035c84>] kthread+0x46/0x6a
[  332.234887]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.234895]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.234900] ---[ end trace ed36ea6940856a51 ]---
[  332.234944] ------------[ cut here ]------------
[  332.234950] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.234954] Hardware name: Studio 540      
[  332.234956] hotplug uevent
[  332.234958] Modules linked in:
[  332.234962] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.234965] Call Trace:
[  332.234971]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.234977]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.234983]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.234989]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.234996]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.235001]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.235007]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.235013]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.235019]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.235023]  [<c1035c84>] kthread+0x46/0x6a
[  332.235028]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.235033]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.235037] ---[ end trace ed36ea6940856a52 ]---
[  332.235065] ------------[ cut here ]------------
[  332.235071] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.235074] Hardware name: Studio 540      
[  332.235077] hotplug uevent
[  332.235079] Modules linked in:
[  332.235083] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.235086] Call Trace:
[  332.235092]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.235098]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.235104]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.235110]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.235117]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.235122]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.235138]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.235144]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.235149]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.235154]  [<c1035c84>] kthread+0x46/0x6a
[  332.235159]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.235164]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.235168] ---[ end trace ed36ea6940856a53 ]---
[  332.236223] ------------[ cut here ]------------
[  332.236231] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.236234] Hardware name: Studio 540      
[  332.236237] hotplug uevent
[  332.236239] Modules linked in:
[  332.236243] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.236246] Call Trace:
[  332.236253]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.236259]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.236265]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.236272]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.236279]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.236285]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.236291]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.236296]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.236302]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.236307]  [<c1035c84>] kthread+0x46/0x6a
[  332.236312]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.236317]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.236321] ---[ end trace ed36ea6940856a54 ]---
[  332.236459] ------------[ cut here ]------------
[  332.236466] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.236469] Hardware name: Studio 540      
[  332.236472] hotplug uevent
[  332.236474] Modules linked in:
[  332.236478] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.236481] Call Trace:
[  332.236487]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.236493]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.236499]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.236505]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.236512]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.236518]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.236524]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.236529]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.236535]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.236539]  [<c1035c84>] kthread+0x46/0x6a
[  332.236544]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.236549]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.236553] ---[ end trace ed36ea6940856a55 ]---
[  332.237802] ------------[ cut here ]------------
[  332.237809] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.237813] Hardware name: Studio 540      
[  332.237815] hotplug uevent
[  332.237817] Modules linked in:
[  332.237821] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.237824] Call Trace:
[  332.237830]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.237836]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.237842]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.237848]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.237855]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.237861]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.237867]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.237872]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.237878]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.237883]  [<c1035c84>] kthread+0x46/0x6a
[  332.237887]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.237893]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.237896] ---[ end trace ed36ea6940856a56 ]---
[  332.240331] ------------[ cut here ]------------
[  332.240337] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.240341] Hardware name: Studio 540      
[  332.240343] hotplug uevent
[  332.240345] Modules linked in:
[  332.240350] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.240353] Call Trace:
[  332.240359]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.240365]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.240371]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.240377]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.240384]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.240389]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.240396]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.240401]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.240407]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.240412]  [<c1035c84>] kthread+0x46/0x6a
[  332.240416]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.240422]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.240425] ---[ end trace ed36ea6940856a57 ]---
[  332.451528] ------------[ cut here ]------------
[  332.451542] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.451546] Hardware name: Studio 540      
[  332.451548] hotplug uevent
[  332.451551] Modules linked in:
[  332.451557] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.451560] Call Trace:
[  332.451569]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.451575]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.451581]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.451587]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.451595]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.451601]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.451607]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.451613]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.451618]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.451623]  [<c1035c84>] kthread+0x46/0x6a
[  332.451628]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.451634]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.451638] ---[ end trace ed36ea6940856a58 ]---
[  332.477080] ------------[ cut here ]------------
[  332.477090] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.477094] Hardware name: Studio 540      
[  332.477097] hotplug uevent
[  332.477099] Modules linked in:
[  332.477104] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.477107] Call Trace:
[  332.477115]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.477122]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.477138]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.477144]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.477151]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.477157]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.477163]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.477169]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.477175]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.477179]  [<c1035c84>] kthread+0x46/0x6a
[  332.477184]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.477190]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.477194] ---[ end trace ed36ea6940856a59 ]---
[  332.479633] ------------[ cut here ]------------
[  332.479643] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.479647] Hardware name: Studio 540      
[  332.479649] hotplug uevent
[  332.479652] Modules linked in:
[  332.479657] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.479660] Call Trace:
[  332.479668]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.479675]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.479681]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.479687]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.479694]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.479700]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.479706]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.479712]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.479717]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.479722]  [<c1035c84>] kthread+0x46/0x6a
[  332.479727]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.479732]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.479736] ---[ end trace ed36ea6940856a5a ]---
[  332.480904] ------------[ cut here ]------------
[  332.480912] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.480916] Hardware name: Studio 540      
[  332.480918] hotplug uevent
[  332.480920] Modules linked in:
[  332.480925] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.480928] Call Trace:
[  332.480936]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.480942]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.480948]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.480954]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.480961]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.480966]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.480972]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.480978]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.480983]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.480988]  [<c1035c84>] kthread+0x46/0x6a
[  332.480993]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.480999]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.481016] ---[ end trace ed36ea6940856a5b ]---
[  332.482150] ------------[ cut here ]------------
[  332.482159] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.482163] Hardware name: Studio 540      
[  332.482165] hotplug uevent
[  332.482168] Modules linked in:
[  332.482173] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.482176] Call Trace:
[  332.482183]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.482190]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.482196]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.482202]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.482209]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.482215]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.482221]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.482227]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.482232]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.482237]  [<c1035c84>] kthread+0x46/0x6a
[  332.482241]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.482247]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.482251] ---[ end trace ed36ea6940856a5c ]---
[  332.482683] ------------[ cut here ]------------
[  332.482691] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.482694] Hardware name: Studio 540      
[  332.482696] hotplug uevent
[  332.482698] Modules linked in:
[  332.482703] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.482706] Call Trace:
[  332.482713]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.482719]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.482726]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.482732]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.482738]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.482744]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.482751]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.482757]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.482762]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.482767]  [<c1035c84>] kthread+0x46/0x6a
[  332.482772]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.482777]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.482781] ---[ end trace ed36ea6940856a5d ]---
[  332.500215] ------------[ cut here ]------------
[  332.500225] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.500229] Hardware name: Studio 540      
[  332.500231] hotplug uevent
[  332.500234] Modules linked in:
[  332.500239] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.500242] Call Trace:
[  332.500250]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.500257]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.500263]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.500269]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.500276]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.500282]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.500288]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.500294]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.500299]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.500304]  [<c1035c84>] kthread+0x46/0x6a
[  332.500308]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.500314]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.500318] ---[ end trace ed36ea6940856a5e ]---
[  332.503852] ------------[ cut here ]------------
[  332.503862] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.503865] Hardware name: Studio 540      
[  332.503868] hotplug uevent
[  332.503870] Modules linked in:
[  332.503875] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.503878] Call Trace:
[  332.503886]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.503892]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.503898]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.503904]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.503911]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.503917]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.503923]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.503928]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.503934]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.503939]  [<c1035c84>] kthread+0x46/0x6a
[  332.503943]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.503949]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.503953] ---[ end trace ed36ea6940856a5f ]---
[  332.505466] ------------[ cut here ]------------
[  332.505474] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.505478] Hardware name: Studio 540      
[  332.505480] hotplug uevent
[  332.505482] Modules linked in:
[  332.505487] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.505490] Call Trace:
[  332.505497]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.505503]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.505509]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.505515]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.505522]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.505528]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.505534]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.505539]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.505545]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.505550]  [<c1035c84>] kthread+0x46/0x6a
[  332.505554]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.505560]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.505564] ---[ end trace ed36ea6940856a60 ]---
[  332.507141] ------------[ cut here ]------------
[  332.507150] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.507154] Hardware name: Studio 540      
[  332.507156] hotplug uevent
[  332.507158] Modules linked in:
[  332.507164] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.507167] Call Trace:
[  332.507175]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.507181]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.507188]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.507194]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.507201]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.507207]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.507213]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.507219]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.507224]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.507229]  [<c1035c84>] kthread+0x46/0x6a
[  332.507235]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.507242]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.507247] ---[ end trace ed36ea6940856a61 ]---
[  332.508398] ------------[ cut here ]------------
[  332.508408] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.508412] Hardware name: Studio 540      
[  332.508414] hotplug uevent
[  332.508417] Modules linked in:
[  332.508422] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.508425] Call Trace:
[  332.508433]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.508440]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.508446]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.508452]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.508458]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.508464]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.508470]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.508476]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.508481]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.508486]  [<c1035c84>] kthread+0x46/0x6a
[  332.508491]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.508496]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.508500] ---[ end trace ed36ea6940856a62 ]---
[  332.511267] ------------[ cut here ]------------
[  332.511277] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.511281] Hardware name: Studio 540      
[  332.511283] hotplug uevent
[  332.511285] Modules linked in:
[  332.511291] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.511294] Call Trace:
[  332.511302]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.511308]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.511314]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.511320]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.511327]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.511333]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.511339]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.511344]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.511350]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.511355]  [<c1035c84>] kthread+0x46/0x6a
[  332.511359]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.511365]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.511369] ---[ end trace ed36ea6940856a63 ]---
[  332.519472] ------------[ cut here ]------------
[  332.519485] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.519489] Hardware name: Studio 540      
[  332.519492] hotplug uevent
[  332.519494] Modules linked in:
[  332.519500] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.519503] Call Trace:
[  332.519512]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.519519]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.519525]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.519531]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.519538]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.519545]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.519551]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.519557]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.519562]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.519567]  [<c1035c84>] kthread+0x46/0x6a
[  332.519572]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.519578]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.519582] ---[ end trace ed36ea6940856a64 ]---
[  332.540832] ------------[ cut here ]------------
[  332.540844] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.540849] Hardware name: Studio 540      
[  332.540851] hotplug uevent
[  332.540853] Modules linked in:
[  332.540859] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.540862] Call Trace:
[  332.540872]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.540878]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.540884]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.540890]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.540897]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.540904]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.540910]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.540916]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.540922]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.540927]  [<c1035c84>] kthread+0x46/0x6a
[  332.540931]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.540937]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.540941] ---[ end trace ed36ea6940856a65 ]---
[  332.545526] ------------[ cut here ]------------
[  332.545536] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.545539] Hardware name: Studio 540      
[  332.545542] hotplug uevent
[  332.545544] Modules linked in:
[  332.545549] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.545552] Call Trace:
[  332.545560]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.545566]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.545572]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.545579]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.545586]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.545592]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.545598]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.545604]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.545610]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.545614]  [<c1035c84>] kthread+0x46/0x6a
[  332.545619]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.545625]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.545628] ---[ end trace ed36ea6940856a66 ]---
[  332.547972] ------------[ cut here ]------------
[  332.547982] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.547986] Hardware name: Studio 540      
[  332.547988] hotplug uevent
[  332.547991] Modules linked in:
[  332.547996] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.547999] Call Trace:
[  332.548007]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.548014]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.548020]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.548026]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.548033]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.548039]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.548046]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.548051]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.548057]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.548062]  [<c1035c84>] kthread+0x46/0x6a
[  332.548066]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.548072]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.548076] ---[ end trace ed36ea6940856a67 ]---
[  332.550937] ------------[ cut here ]------------
[  332.550947] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.550951] Hardware name: Studio 540      
[  332.550953] hotplug uevent
[  332.550955] Modules linked in:
[  332.550961] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.550964] Call Trace:
[  332.550972]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.550978]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.550984]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.550990]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.550997]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.551015]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.551021]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.551027]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.551033]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.551037]  [<c1035c84>] kthread+0x46/0x6a
[  332.551042]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.551048]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.551052] ---[ end trace ed36ea6940856a68 ]---
[  332.554169] ------------[ cut here ]------------
[  332.554178] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.554182] Hardware name: Studio 540      
[  332.554184] hotplug uevent
[  332.554186] Modules linked in:
[  332.554191] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.554194] Call Trace:
[  332.554202]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.554209]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.554215]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.554221]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.554227]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.554234]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.554240]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.554245]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.554251]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.554255]  [<c1035c84>] kthread+0x46/0x6a
[  332.554260]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.554266]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.554269] ---[ end trace ed36ea6940856a69 ]---
[  332.559718] ------------[ cut here ]------------
[  332.559728] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.559732] Hardware name: Studio 540      
[  332.559734] hotplug uevent
[  332.559736] Modules linked in:
[  332.559742] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.559745] Call Trace:
[  332.559753]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.559759]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.559765]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.559771]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.559778]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.559784]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.559790]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.559796]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.559801]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.559806]  [<c1035c84>] kthread+0x46/0x6a
[  332.559811]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.559816]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.559820] ---[ end trace ed36ea6940856a6a ]---
[  332.602929] ------------[ cut here ]------------
[  332.602939] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.602943] Hardware name: Studio 540      
[  332.602946] hotplug uevent
[  332.602948] Modules linked in:
[  332.602954] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.602957] Call Trace:
[  332.602965]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.602972]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.602978]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.602984]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.602991]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.602997]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.603003]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.603009]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.603014]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.603019]  [<c1035c84>] kthread+0x46/0x6a
[  332.603024]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.603029]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.603033] ---[ end trace ed36ea6940856a6b ]---
[  332.766921] ------------[ cut here ]------------
[  332.766935] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.766939] Hardware name: Studio 540      
[  332.766941] hotplug uevent
[  332.766944] Modules linked in:
[  332.766950] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.766953] Call Trace:
[  332.766963]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.766969]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.766975]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.766981]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.766988]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.766995]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.767001]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.767019]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.767025]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.767030]  [<c1035c84>] kthread+0x46/0x6a
[  332.767034]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.767041]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.767044] ---[ end trace ed36ea6940856a6c ]---
[  332.780435] ------------[ cut here ]------------
[  332.780448] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.780452] Hardware name: Studio 540      
[  332.780454] hotplug uevent
[  332.780457] Modules linked in:
[  332.780463] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.780466] Call Trace:
[  332.780475]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.780482]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.780488]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.780494]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.780501]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.780507]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.780513]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.780519]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.780525]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.780529]  [<c1035c84>] kthread+0x46/0x6a
[  332.780534]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.780540]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.780544] ---[ end trace ed36ea6940856a6d ]---
[  332.790954] ------------[ cut here ]------------
[  332.790967] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.790971] Hardware name: Studio 540      
[  332.790973] hotplug uevent
[  332.790975] Modules linked in:
[  332.790981] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.790984] Call Trace:
[  332.790993]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.791000]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.791006]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.791012]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.791019]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.791025]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.791031]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.791037]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.791042]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.791047]  [<c1035c84>] kthread+0x46/0x6a
[  332.791052]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.791058]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.791062] ---[ end trace ed36ea6940856a6e ]---
[  332.792342] ------------[ cut here ]------------
[  332.792350] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.792354] Hardware name: Studio 540      
[  332.792356] hotplug uevent
[  332.792359] Modules linked in:
[  332.792364] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.792367] Call Trace:
[  332.792375]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.792383]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.792390]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.792398]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.792406]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.792414]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.792422]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.792429]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.792437]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.792443]  [<c1035c84>] kthread+0x46/0x6a
[  332.792450]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.792457]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.792461] ---[ end trace ed36ea6940856a6f ]---
[  332.794257] ------------[ cut here ]------------
[  332.794269] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.794273] Hardware name: Studio 540      
[  332.794275] hotplug uevent
[  332.794277] Modules linked in:
[  332.794283] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.794286] Call Trace:
[  332.794295]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.794301]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.794307]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.794313]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.794320]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.794327]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.794333]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.794339]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.794344]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.794349]  [<c1035c84>] kthread+0x46/0x6a
[  332.794354]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.794360]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.794363] ---[ end trace ed36ea6940856a70 ]---
[  332.804148] ------------[ cut here ]------------
[  332.804161] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.804165] Hardware name: Studio 540      
[  332.804167] hotplug uevent
[  332.804170] Modules linked in:
[  332.804176] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.804179] Call Trace:
[  332.804188]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.804194]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.804200]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.804206]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.804214]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.804220]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.804226]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.804232]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.804237]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.804242]  [<c1035c84>] kthread+0x46/0x6a
[  332.804247]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.804253]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.804257] ---[ end trace ed36ea6940856a71 ]---
[  332.807154] ------------[ cut here ]------------
[  332.807165] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.807169] Hardware name: Studio 540      
[  332.807172] hotplug uevent
[  332.807174] Modules linked in:
[  332.807179] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  332.807183] Call Trace:
[  332.807191]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.807198]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.807204]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.807210]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.807217]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.807223]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.807229]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.807234]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.807240]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.807245]  [<c1035c84>] kthread+0x46/0x6a
[  332.807249]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.807255]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.807259] ---[ end trace ed36ea6940856a72 ]---
[  332.807267] ------------[ cut here ]------------
[  332.807275] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.807279] Hardware name: Studio 540      
[  332.807282] hotplug uevent
[  332.807284] Modules linked in:
[  332.807289] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.807292] Call Trace:
[  332.807299]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.807306]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.807312]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.807319]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.807326]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.807332]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.807338]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.807344]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.807350]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.807355]  [<c1035c84>] kthread+0x46/0x6a
[  332.807359]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.807365]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.807368] ---[ end trace ed36ea6940856a73 ]---
[  332.810382] ------------[ cut here ]------------
[  332.810391] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  332.810395] Hardware name: Studio 540      
[  332.810397] hotplug uevent
[  332.810399] Modules linked in:
[  332.810405] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  332.810408] Call Trace:
[  332.810416]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  332.810422]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  332.810428]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  332.810434]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  332.810441]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  332.810448]  [<c1032f28>] worker_thread+0x131/0x1ab
[  332.810454]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  332.810460]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  332.810465]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  332.810470]  [<c1035c84>] kthread+0x46/0x6a
[  332.810475]  [<c1035c3e>] ? kthread+0x0/0x6a
[  332.810481]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  332.810484] ---[ end trace ed36ea6940856a74 ]---
[  333.033869] ------------[ cut here ]------------
[  333.033882] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.033887] Hardware name: Studio 540      
[  333.033889] hotplug uevent
[  333.033891] Modules linked in:
[  333.033897] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.033901] Call Trace:
[  333.033911]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.033917]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.033923]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.033929]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.033936]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.033943]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.033949]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.033955]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.033961]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.033965]  [<c1035c84>] kthread+0x46/0x6a
[  333.033970]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.033976]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.033980] ---[ end trace ed36ea6940856a75 ]---
[  333.228942] ------------[ cut here ]------------
[  333.228955] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.228960] Hardware name: Studio 540      
[  333.228962] hotplug uevent
[  333.228964] Modules linked in:
[  333.228970] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.228974] Call Trace:
[  333.228983]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.228990]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.228996]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.229002]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.229024]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.229031]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.229038]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.229044]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.229055]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.229058]  [<c1035c84>] kthread+0x46/0x6a
[  333.229062]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.229066]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.229068] ---[ end trace ed36ea6940856a76 ]---
[  333.245591] ------------[ cut here ]------------
[  333.245604] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.245608] Hardware name: Studio 540      
[  333.245611] hotplug uevent
[  333.245613] Modules linked in:
[  333.245619] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.245623] Call Trace:
[  333.245632]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.245638]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.245644]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.245651]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.245657]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.245664]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.245670]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.245676]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.245681]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.245686]  [<c1035c84>] kthread+0x46/0x6a
[  333.245690]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.245696]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.245700] ---[ end trace ed36ea6940856a77 ]---
[  333.390243] ------------[ cut here ]------------
[  333.390254] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.390258] Hardware name: Studio 540      
[  333.390261] hotplug uevent
[  333.390263] Modules linked in:
[  333.390269] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.390272] Call Trace:
[  333.390281]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.390287]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.390293]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.390299]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.390306]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.390312]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.390318]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.390324]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.390329]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.390334]  [<c1035c84>] kthread+0x46/0x6a
[  333.390339]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.390344]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.390348] ---[ end trace ed36ea6940856a78 ]---
[  333.621620] ------------[ cut here ]------------
[  333.621633] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.621637] Hardware name: Studio 540      
[  333.621640] hotplug uevent
[  333.621642] Modules linked in:
[  333.621648] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.621651] Call Trace:
[  333.621660]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.621667]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.621673]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.621679]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.621686]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.621693]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.621699]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.621705]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.621710]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.621715]  [<c1035c84>] kthread+0x46/0x6a
[  333.621720]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.621726]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.621729] ---[ end trace ed36ea6940856a79 ]---
[  333.637636] ------------[ cut here ]------------
[  333.637646] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.637650] Hardware name: Studio 540      
[  333.637653] hotplug uevent
[  333.637655] Modules linked in:
[  333.637660] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.637664] Call Trace:
[  333.637672]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.637679]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.637685]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.637691]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.637698]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.637705]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.637711]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.637717]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.637722]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.637727]  [<c1035c84>] kthread+0x46/0x6a
[  333.637732]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.637738]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.637741] ---[ end trace ed36ea6940856a7a ]---
[  333.833122] ------------[ cut here ]------------
[  333.833147] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.833151] Hardware name: Studio 540      
[  333.833154] hotplug uevent
[  333.833156] Modules linked in:
[  333.833162] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.833165] Call Trace:
[  333.833174]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.833181]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.833187]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.833193]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.833200]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.833206]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.833212]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.833218]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.833224]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.833229]  [<c1035c84>] kthread+0x46/0x6a
[  333.833233]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.833239]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.833243] ---[ end trace ed36ea6940856a7b ]---
[  333.853135] ------------[ cut here ]------------
[  333.853146] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.853150] Hardware name: Studio 540      
[  333.853152] hotplug uevent
[  333.853154] Modules linked in:
[  333.853160] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.853163] Call Trace:
[  333.853171]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.853177]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.853184]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.853190]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.853197]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.853203]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.853209]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.853215]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.853220]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.853225]  [<c1035c84>] kthread+0x46/0x6a
[  333.853229]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.853235]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.853239] ---[ end trace ed36ea6940856a7c ]---
[  333.860265] ------------[ cut here ]------------
[  333.860276] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.860280] Hardware name: Studio 540      
[  333.860282] hotplug uevent
[  333.860284] Modules linked in:
[  333.860289] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.860293] Call Trace:
[  333.860301]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.860307]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.860313]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.860319]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.860326]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.860332]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.860339]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.860345]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.860350]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.860355]  [<c1035c84>] kthread+0x46/0x6a
[  333.860360]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.860366]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.860370] ---[ end trace ed36ea6940856a7d ]---
[  333.865077] ------------[ cut here ]------------
[  333.865087] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.865091] Hardware name: Studio 540      
[  333.865093] hotplug uevent
[  333.865095] Modules linked in:
[  333.865101] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.865104] Call Trace:
[  333.865112]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.865118]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.865124]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.865140]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.865147]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.865154]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.865162]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.865169]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.865176]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.865182]  [<c1035c84>] kthread+0x46/0x6a
[  333.865188]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.865195]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.865200] ---[ end trace ed36ea6940856a7e ]---
[  333.888617] ------------[ cut here ]------------
[  333.888626] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.888630] Hardware name: Studio 540      
[  333.888632] hotplug uevent
[  333.888634] Modules linked in:
[  333.888640] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.888643] Call Trace:
[  333.888651]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.888657]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.888663]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.888669]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.888676]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.888682]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.888688]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.888693]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.888699]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.888704]  [<c1035c84>] kthread+0x46/0x6a
[  333.888708]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.888714]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.888717] ---[ end trace ed36ea6940856a7f ]---
[  333.890755] ------------[ cut here ]------------
[  333.890765] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.890769] Hardware name: Studio 540      
[  333.890772] hotplug uevent
[  333.890774] Modules linked in:
[  333.890779] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.890782] Call Trace:
[  333.890790]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.890797]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.890803]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.890809]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.890816]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.890822]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.890828]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.890833]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.890839]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.890844]  [<c1035c84>] kthread+0x46/0x6a
[  333.890848]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.890854]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.890857] ------------[ cut here ]------------
[  333.890866] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.890870] Hardware name: Studio 540      
[  333.890873] hotplug uevent
[  333.890875] Modules linked in:
[  333.890881] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.890884] ---[ end trace ed36ea6940856a80 ]---
[  333.890888] Call Trace:
[  333.890895]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.890902]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.890908]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.890914]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.890921]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.890927]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.890933]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.890940]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.890945]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.890950]  [<c1035c84>] kthread+0x46/0x6a
[  333.890955]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.890961]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.890964] ---[ end trace ed36ea6940856a81 ]---
[  333.893346] ------------[ cut here ]------------
[  333.893355] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.893359] Hardware name: Studio 540      
[  333.893362] hotplug uevent
[  333.893364] Modules linked in:
[  333.893369] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.893372] Call Trace:
[  333.893380]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.893386]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.893392]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.893398]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.893405]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.893411]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.893417]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.893422]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.893428]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.893433]  [<c1035c84>] kthread+0x46/0x6a
[  333.893437]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.893443]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.893446] ---[ end trace ed36ea6940856a82 ]---
[  333.904993] ------------[ cut here ]------------
[  333.905003] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.905017] Hardware name: Studio 540      
[  333.905020] hotplug uevent
[  333.905022] Modules linked in:
[  333.905028] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.905031] Call Trace:
[  333.905040]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.905048]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.905056]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.905064]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.905072]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.905079]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.905088]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.905095]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.905103]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.905110]  [<c1035c84>] kthread+0x46/0x6a
[  333.905116]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.905124]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.905129] ---[ end trace ed36ea6940856a83 ]---
[  333.907605] ------------[ cut here ]------------
[  333.907613] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.907617] Hardware name: Studio 540      
[  333.907619] hotplug uevent
[  333.907622] Modules linked in:
[  333.907627] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.907630] Call Trace:
[  333.907637]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.907644]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.907650]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.907656]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.907663]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.907669]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.907675]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.907681]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.907686]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.907691]  [<c1035c84>] kthread+0x46/0x6a
[  333.907696]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.907701]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.907705] ---[ end trace ed36ea6940856a84 ]---
[  333.908008] ------------[ cut here ]------------
[  333.908017] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.908021] Hardware name: Studio 540      
[  333.908023] hotplug uevent
[  333.908025] Modules linked in:
[  333.908030] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.908033] Call Trace:
[  333.908040]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.908047]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.908053]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.908059]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.908066]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.908072]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.908078]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.908083]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.908089]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.908093]  [<c1035c84>] kthread+0x46/0x6a
[  333.908098]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.908103]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.908107] ---[ end trace ed36ea6940856a85 ]---
[  333.908139] ------------[ cut here ]------------
[  333.908145] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.908149] Hardware name: Studio 540      
[  333.908151] hotplug uevent
[  333.908153] Modules linked in:
[  333.908158] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.908161] Call Trace:
[  333.908167]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.908173]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.908179]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.908185]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.908191]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.908197]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.908203]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.908209]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.908214]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.908219]  [<c1035c84>] kthread+0x46/0x6a
[  333.908224]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.908229]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.908232] ---[ end trace ed36ea6940856a86 ]---
[  333.908407] ------------[ cut here ]------------
[  333.908417] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.908422] Hardware name: Studio 540      
[  333.908426] hotplug uevent
[  333.908428] Modules linked in:
[  333.908435] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.908439] Call Trace:
[  333.908447]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.908455]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.908462]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.908470]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.908479]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.908486]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.908495]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.908502]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.908510]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.908516]  [<c1035c84>] kthread+0x46/0x6a
[  333.908523]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.908530]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.908536] ---[ end trace ed36ea6940856a87 ]---
[  333.912955] ------------[ cut here ]------------
[  333.912963] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.912967] Hardware name: Studio 540      
[  333.912969] hotplug uevent
[  333.912971] Modules linked in:
[  333.912976] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.912980] Call Trace:
[  333.912987]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.912993]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.912999]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.913005]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.913012]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.913018]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.913024]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.913030]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.913035]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.913040]  [<c1035c84>] kthread+0x46/0x6a
[  333.913045]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.913050]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.913054] ---[ end trace ed36ea6940856a88 ]---
[  333.914236] ------------[ cut here ]------------
[  333.914244] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.914248] Hardware name: Studio 540      
[  333.914250] hotplug uevent
[  333.914252] Modules linked in:
[  333.914257] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.914260] Call Trace:
[  333.914267]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.914273]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.914279]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.914285]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.914292]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.914299]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.914306]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.914314]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.914321]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.914327]  [<c1035c84>] kthread+0x46/0x6a
[  333.914333]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.914340]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.914344] ---[ end trace ed36ea6940856a89 ]---
[  333.915383] ------------[ cut here ]------------
[  333.915390] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.915394] Hardware name: Studio 540      
[  333.915396] hotplug uevent
[  333.915398] Modules linked in:
[  333.915403] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.915406] Call Trace:
[  333.915413]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.915419]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.915425]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.915431]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.915437]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.915443]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.915449]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.915452] ------------[ cut here ]------------
[  333.915461] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.915465] Hardware name: Studio 540      
[  333.915467] hotplug uevent
[  333.915470] Modules linked in:
[  333.915474] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.915480]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.915487]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.915492]  [<c1035c84>] kthread+0x46/0x6a
[  333.915497]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.915500] Call Trace:
[  333.915508]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.915514]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.915518] ---[ end trace ed36ea6940856a8a ]---
[  333.915524]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.915531]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.915537]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.915544]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.915550]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.915556]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.915562]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.915567]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.915570] ------------[ cut here ]------------
[  333.915578] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.915582] Hardware name: Studio 540      
[  333.915584] hotplug uevent
[  333.915587] Modules linked in:
[  333.915591] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.915596]  [<c1035c84>] kthread+0x46/0x6a
[  333.915601]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.915607]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.915611] Call Trace:
[  333.915617]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.915620] ---[ end trace ed36ea6940856a8b ]---
[  333.915627]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.915634]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.915640]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.915642] ------------[ cut here ]------------
[  333.915649] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.915653] Hardware name: Studio 540      
[  333.915655] hotplug uevent
[  333.915658] Modules linked in:
[  333.915662] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.915669]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.915675]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.915678] Call Trace:
[  333.915684]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.915691]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.915697]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.915703]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.915709]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.915714]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.915720]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.915728]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.915734]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.915739]  [<c1035c84>] kthread+0x46/0x6a
[  333.915744]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.915750]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.915756]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.915762]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.915766] ---[ end trace ed36ea6940856a8c ]---
[  333.915772]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.915777]  [<c1035c84>] kthread+0x46/0x6a
[  333.915782]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.915787]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.915791] ---[ end trace ed36ea6940856a8d ]---
[  333.917681] ------------[ cut here ]------------
[  333.917689] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.917693] Hardware name: Studio 540      
[  333.917695] hotplug uevent
[  333.917697] Modules linked in:
[  333.917702] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.917705] Call Trace:
[  333.917712]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.917718]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.917724]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.917730]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.917737]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.917742]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.917749]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.917754]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.917760]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.917764]  [<c1035c84>] kthread+0x46/0x6a
[  333.917769]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.917774]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.917778] ---[ end trace ed36ea6940856a8e ]---
[  333.919151] ------------[ cut here ]------------
[  333.919159] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.919163] Hardware name: Studio 540      
[  333.919165] hotplug uevent
[  333.919168] Modules linked in:
[  333.919173] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.919176] Call Trace:
[  333.919183]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.919189]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.919195]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.919201]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.919208]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.919214]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.919220]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.919225]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.919231]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.919235]  [<c1035c84>] kthread+0x46/0x6a
[  333.919240]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.919245]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.919249] ---[ end trace ed36ea6940856a8f ]---
[  333.919433] ------------[ cut here ]------------
[  333.919441] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.919444] Hardware name: Studio 540      
[  333.919447] hotplug uevent
[  333.919449] Modules linked in:
[  333.919453] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.919456] Call Trace:
[  333.919463]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.919469]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.919475]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.919481]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.919488]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.919493]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.919499]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.919502] ------------[ cut here ]------------
[  333.919510] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.919514] Hardware name: Studio 540      
[  333.919517] hotplug uevent
[  333.919519] Modules linked in:
[  333.919523] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.919527] Call Trace:
[  333.919532]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.919538]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.919544]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.919551]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.919557]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.919562]  [<c1035c84>] kthread+0x46/0x6a
[  333.919567]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.919573]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.919578]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.919585]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.919589] ---[ end trace ed36ea6940856a90 ]---
[  333.919595]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.919600]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.919606]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.919612]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.919617]  [<c1035c84>] kthread+0x46/0x6a
[  333.919621]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.919627]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.919630] ---[ end trace ed36ea6940856a91 ]---
[  333.945698] ------------[ cut here ]------------
[  333.945709] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.945713] Hardware name: Studio 540      
[  333.945716] hotplug uevent
[  333.945718] Modules linked in:
[  333.945723] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  333.945727] Call Trace:
[  333.945735]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.945741]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.945747]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.945753]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.945760]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.945766]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.945773]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.945778]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.945784]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.945789]  [<c1035c84>] kthread+0x46/0x6a
[  333.945794]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.945800]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.945803] ---[ end trace ed36ea6940856a92 ]---
[  333.951142] ------------[ cut here ]------------
[  333.951152] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  333.951156] Hardware name: Studio 540      
[  333.951159] hotplug uevent
[  333.951161] Modules linked in:
[  333.951166] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  333.951169] Call Trace:
[  333.951177]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  333.951184]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  333.951190]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  333.951196]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  333.951203]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  333.951209]  [<c1032f28>] worker_thread+0x131/0x1ab
[  333.951215]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  333.951220]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  333.951226]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  333.951231]  [<c1035c84>] kthread+0x46/0x6a
[  333.951235]  [<c1035c3e>] ? kthread+0x0/0x6a
[  333.951241]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  333.951245] ---[ end trace ed36ea6940856a93 ]---
[  334.135375] ------------[ cut here ]------------
[  334.135386] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  334.135391] Hardware name: Studio 540      
[  334.135393] hotplug uevent
[  334.135395] Modules linked in:
[  334.135401] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  334.135404] Call Trace:
[  334.135413]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  334.135419]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  334.135425]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  334.135431]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  334.135438]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  334.135445]  [<c1032f28>] worker_thread+0x131/0x1ab
[  334.135451]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  334.135457]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  334.135462]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  334.135467]  [<c1035c84>] kthread+0x46/0x6a
[  334.135472]  [<c1035c3e>] ? kthread+0x0/0x6a
[  334.135478]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  334.135481] ---[ end trace ed36ea6940856a94 ]---
[  334.137660] ------------[ cut here ]------------
[  334.137671] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  334.137675] Hardware name: Studio 540      
[  334.137677] hotplug uevent
[  334.137679] Modules linked in:
[  334.137685] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  334.137688] Call Trace:
[  334.137696]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  334.137703]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  334.137709]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  334.137715]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  334.137722]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  334.137728]  [<c1032f28>] worker_thread+0x131/0x1ab
[  334.137734]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  334.137740]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  334.137745]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  334.137750]  [<c1035c84>] kthread+0x46/0x6a
[  334.137755]  [<c1035c3e>] ? kthread+0x0/0x6a
[  334.137761]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  334.137764] ---[ end trace ed36ea6940856a95 ]---
[  334.362657] ------------[ cut here ]------------
[  334.362669] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  334.362673] Hardware name: Studio 540      
[  334.362676] hotplug uevent
[  334.362678] Modules linked in:
[  334.362684] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  334.362687] Call Trace:
[  334.362696]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  334.362703]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  334.362709]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  334.362715]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  334.362722]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  334.362729]  [<c1032f28>] worker_thread+0x131/0x1ab
[  334.362735]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  334.362741]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  334.362747]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  334.362751]  [<c1035c84>] kthread+0x46/0x6a
[  334.362756]  [<c1035c3e>] ? kthread+0x0/0x6a
[  334.362762]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  334.362766] ---[ end trace ed36ea6940856a96 ]---
[  334.366945] ------------[ cut here ]------------
[  334.366956] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  334.366960] Hardware name: Studio 540      
[  334.366963] hotplug uevent
[  334.366965] Modules linked in:
[  334.366970] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  334.366973] Call Trace:
[  334.366982]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  334.366988]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  334.366994]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  334.367000]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  334.367017]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  334.367023]  [<c1032f28>] worker_thread+0x131/0x1ab
[  334.367030]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  334.367037]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  334.367044]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  334.367051]  [<c1035c84>] kthread+0x46/0x6a
[  334.367057]  [<c1035c3e>] ? kthread+0x0/0x6a
[  334.367065]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  334.367071] ---[ end trace ed36ea6940856a97 ]---
[  334.390457] ------------[ cut here ]------------
[  334.390470] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  334.390474] Hardware name: Studio 540      
[  334.390477] hotplug uevent
[  334.390479] Modules linked in:
[  334.390485] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  334.390488] Call Trace:
[  334.390498]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  334.390504]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  334.390510]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  334.390516]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  334.390523]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  334.390530]  [<c1032f28>] worker_thread+0x131/0x1ab
[  334.390536]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  334.390542]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  334.390547]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  334.390552]  [<c1035c84>] kthread+0x46/0x6a
[  334.390557]  [<c1035c3e>] ? kthread+0x0/0x6a
[  334.390563]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  334.390566] ---[ end trace ed36ea6940856a98 ]---
[  334.431698] ------------[ cut here ]------------
[  334.431711] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  334.431715] Hardware name: Studio 540      
[  334.431718] hotplug uevent
[  334.431720] Modules linked in:
[  334.431726] Pid: 8, comm: events/1 Tainted: G        W  2.6.30.1 #1
[  334.431729] Call Trace:
[  334.431739]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  334.431745]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  334.431751]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  334.431757]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  334.431765]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  334.431771]  [<c1032f28>] worker_thread+0x131/0x1ab
[  334.431777]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  334.431783]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  334.431789]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  334.431794]  [<c1035c84>] kthread+0x46/0x6a
[  334.431799]  [<c1035c3e>] ? kthread+0x0/0x6a
[  334.431805]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  334.431809] ---[ end trace ed36ea6940856a99 ]---
[  334.608714] ------------[ cut here ]------------
[  334.608724] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x2b/0x63()
[  334.608726] Hardware name: Studio 540      
[  334.608727] hotplug uevent
[  334.608728] Modules linked in:
[  334.608732] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[  334.608734] Call Trace:
[  334.608740]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[  334.608743]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[  334.608746]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[  334.608749]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[  334.608752]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[  334.608756]  [<c1032f28>] worker_thread+0x131/0x1ab
[  334.608759]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[  334.608762]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[  334.608765]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[  334.608767]  [<c1035c84>] kthread+0x46/0x6a
[  334.608770]  [<c1035c3e>] ? kthread+0x0/0x6a
[  334.608773]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[  334.608775] ---[ end trace ed36ea6940856a9a ]---

--Boundary-00=_FRPZKJAZyWPSkuP--
