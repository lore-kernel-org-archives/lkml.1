Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZKXIHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZKXIHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbZKXIG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:06:59 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:36422 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbZKXIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:06:57 -0500
Message-ID: <4B0B9578.90703@pardus.org.tr>
Date: Tue, 24 Nov 2009 10:12:40 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUG 2.6.30.9] Soft lockup CPU#X stuck for Y seconds!
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've hit soft lockups on a 2.6.30.9 KVM guest over an HP DL580-G5 host
running a 2.6.30.9 kernel as well. After the soft lockups, system time
skewed back in time:

~ $ LC_ALL=C date
Mon Feb  1 00:10:58 EET 1954

I'm attaching the dmesg containing the two consecutive soft lockups. One
seems related to cpuidle and the other to the virtio network stuff.

Thanks.
Ozan
------

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30.9-128 (pardus@buildfarm) (gcc
version 4.3.3 (Pardus Linux) ) #1 SMP Thu Nov 5 09:31:27 EET 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fef0000 (usable)
[    0.000000]  BIOS-e820: 000000007fef0000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7fef0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFFFFFFFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fef0000 (usable)
[    0.000000]  modified: 000000007fef0000 - 000000007ff00000 (ACPI data)
[    0.000000]  modified: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37b98000 - 37fefc72
[    0.000000] Allocated new RAMDISK: 0070b000 - 00b62c72
[    0.000000] Move RAMDISK from 0000000037b98000 - 0000000037fefc71 to
0070b000 - 00b62c71
[    0.000000] ACPI: RSDP 000fbf90 00014 (v00 QEMU  )
[    0.000000] ACPI: RSDT 7fef0000 0002C (v01 QEMU   QEMURSDT 00000001
QEMU 00000001)
[    0.000000] ACPI: FACP 7fef002c 00074 (v01 QEMU   QEMUFACP 00000001
QEMU 00000001)
[    0.000000] ACPI: DSDT 7fef0100 02540 (v01   BXPC   BXDSDT 00000001
INTL 20061109)
[    0.000000] ACPI: FACS 7fef00c0 00040
[    0.000000] ACPI: APIC 7fef2640 000E0 (v01 QEMU   QEMUAPIC 00000001
QEMU 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1158MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000706fc4]    TEXT DATA BSS ==>
[0000100000 - 0000706fc4]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #5 [0000707000 - 000070a03d]              BRK ==>
[0000707000 - 000070a03d]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #7 [000070b000 - 0000b62c72]      NEW RAMDISK ==>
[000070b000 - 0000b62c72]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==>
[0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00fbd10] fbd10
[    0.000000] kvm-clock: cpu 0, msr 0:64a3e1, boot clock
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007fef0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fef0
[    0.000000] On node 0 totalpages: 523915
[    0.000000] free_area_init_node: node 0, pgdat c059d6a0, node_mem_map
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2318 pages used for memmap
[    0.000000]   HighMem zone: 294372 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
[    0.000000] Overriding APIC driver with bigsmp
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 10, version 17, address 0xfec00000,
GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Enabling APIC mode:  Physflat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 16 CPUs, 6 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 -
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 -
0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
7ff00000:800bc000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c200a000, static data 26972
bytes
[    0.000000] kvm-clock: cpu 0, msr 0:20103e1, primary cpu clock
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 519821
[    0.000000] Kernel command line: root=LABEL=PARDUS_ROOT splash=silent
quiet vga=0x314 mudur=virtio
[    0.000000] bootsplash: silent mode.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:1280
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2667.088 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000999] allocated 10480320 bytes of page_cgroup
[    0.000999] please try cgroup_disable=memory option if you don't want
[    0.000999] Initializing HighMem for node 0 (000377fe:0007fef0)
[    0.000999] Memory: 2055624k/2096064k available (3089k kernel code,
38892k reserved, 1849k data, 448k init, 1186760k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc05db000 - 0xc064b000   ( 448 kB)
[    0.000999]       .data : 0xc04047f3 - 0xc05d2c6c   (1849 kB)
[    0.000999]       .text : 0xc0100000 - 0xc04047f3   (3089 kB)
[    0.000999] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=16, Nodes=1
[    0.001019] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.001115] Security Framework initialized
[    0.001139] Mount-cache hash table entries: 512
[    0.001622] Initializing cgroup subsys ns
[    0.001641] Initializing cgroup subsys cpuacct
[    0.001645] Initializing cgroup subsys memory
[    0.001660] Initializing cgroup subsys devices
[    0.001662] Initializing cgroup subsys freezer
[    0.001725] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001727] CPU: L2 cache: 2048K
[    0.001736] Intel machine check architecture supported.
[    0.001742] Intel machine check reporting enabled on CPU#0.
[    0.009087] ACPI: Core revision 20090320
[    0.011230] Leaving ESR disabled.
[    0.011710] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.021719] CPU0: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.025234] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.036646] CPU1: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.060916] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.000999] kvm-clock: cpu 1, msr 0:20203e1, secondary cpu clock
[    0.068055] Booting processor 2 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#2.
[    0.079512] CPU2: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.108326] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.110071] kvm-clock: cpu 2, msr 0:20303e1, secondary cpu clock
[    0.117203] Booting processor 3 APIC 0x3 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#3.
[    0.128676] CPU3: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.156612] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.000999] kvm-clock: cpu 3, msr 0:20403e1, secondary cpu clock
[    0.165913] Booting processor 4 APIC 0x4 ip 0x6000
[    0.000999] Initializing CPU#4
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#4.
[    0.177404] CPU4: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.208195] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.209984] kvm-clock: cpu 4, msr 0:20503e1, secondary cpu clock
[    0.219049] Booting processor 5 APIC 0x5 ip 0x6000
[    0.000999] Initializing CPU#5
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#5.
[    0.230481] CPU5: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.262077] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    0.263978] kvm-clock: cpu 5, msr 0:20603e1, secondary cpu clock
[    0.273348] Booting processor 6 APIC 0x6 ip 0x6000
[    0.000999] Initializing CPU#6
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#6.
[    0.284801] CPU6: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.317759] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    0.319015] kvm-clock: cpu 6, msr 0:20703e1, secondary cpu clock
[    0.329370] Booting processor 7 APIC 0x7 ip 0x6000
[    0.000999] Initializing CPU#7
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#7.
[    0.340842] CPU7: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.375024] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    0.377068] kvm-clock: cpu 7, msr 0:20803e1, secondary cpu clock
[    0.386494] Booting processor 8 APIC 0x8 ip 0x6000
[    0.000999] Initializing CPU#8
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#8.
[    0.398150] CPU8: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.434186] checking TSC synchronization [CPU#0 -> CPU#8]: passed.
[    0.436016] kvm-clock: cpu 8, msr 0:20903e1, secondary cpu clock
[    0.445542] Booting processor 9 APIC 0x9 ip 0x6000
[    0.000999] Initializing CPU#9
[    0.000999] Leaving ESR disabled.
[    0.000999] Calibrating delay loop (skipped) preset value.. 5334.17
BogoMIPS (lpj=2667088)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#9.
[    0.456971] CPU9: Intel QEMU Virtual CPU version 0.10.0 stepping 03
[    0.487732] checking TSC synchronization [CPU#0 -> CPU#9]: passed.
[    0.489064] kvm-clock: cpu 9, msr 0:20a03e1, secondary cpu clock
[    0.489091] Brought up 10 CPUs
[    0.489094] Total of 10 processors activated (53341.76 BogoMIPS).
[    0.490403] CPU0 attaching sched-domain:
[    0.490411]  domain 0: span 0-9 level CPU
[    0.490413]   groups: 0 1 2 3 4 5 6 7 8 9
[    0.490422] CPU1 attaching sched-domain:
[    0.490423]  domain 0: span 0-9 level CPU
[    0.490425]   groups: 1 2 3 4 5 6 7 8 9 0
[    0.490432] CPU2 attaching sched-domain:
[    0.490434]  domain 0: span 0-9 level CPU
[    0.490435]   groups: 2 3 4 5 6 7 8 9 0 1
[    0.490442] CPU3 attaching sched-domain:
[    0.490444]  domain 0: span 0-9 level CPU
[    0.490446]   groups: 3 4 5 6 7 8 9 0 1 2
[    0.490452] CPU4 attaching sched-domain:
[    0.490454]  domain 0: span 0-9 level CPU
[    0.490456]   groups: 4 5 6 7 8 9 0 1 2 3
[    0.490462] CPU5 attaching sched-domain:
[    0.490464]  domain 0: span 0-9 level CPU
[    0.490466]   groups: 5 6 7 8 9 0 1 2 3 4
[    0.490472] CPU6 attaching sched-domain:
[    0.490474]  domain 0: span 0-9 level CPU
[    0.490476]   groups: 6 7 8 9 0 1 2 3 4 5
[    0.490483] CPU7 attaching sched-domain:
[    0.490484]  domain 0: span 0-9 level CPU
[    0.490486]   groups: 7 8 9 0 1 2 3 4 5 6
[    0.490493] CPU8 attaching sched-domain:
[    0.490494]  domain 0: span 0-9 level CPU
[    0.490496]   groups: 8 9 0 1 2 3 4 5 6 7
[    0.490503] CPU9 attaching sched-domain:
[    0.490504]  domain 0: span 0-9 level CPU
[    0.490506]   groups: 9 0 1 2 3 4 5 6 7 8
[    0.492212] net_namespace: 1088 bytes
[    0.492261] Booting paravirtualized kernel on KVM
[    0.493088] regulator: core version 0.5
[    0.493238] NET: Registered protocol family 16
[    0.493456] EISA bus registered
[    0.493482] ACPI: bus type pci registered
[    0.493655] PCI: PCI BIOS revision 2.10 entry at 0xfb510, last bus=0
[    0.493657] PCI: Using configuration type 1 for base access
[    0.494379] bio: create slab <bio-0> at 0
[    0.497407] ACPI: EC: Look up EC in DSDT
[    0.500021] ACPI: Interpreter enabled
[    0.500024] ACPI: (supports S0 S3 S4 S5)
[    0.500080] ACPI: Using IOAPIC for interrupt routing
[    0.503151] ACPI: No dock devices found.
[    0.503162] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.504027] pci 0000:00:01.1: reg 20 io port: [0xc000-0xc00f]
[    0.504451] pci 0000:00:01.3: quirk: region b000-b03f claimed by
PIIX4 ACPI
[    0.504461] pci 0000:00:01.3: quirk: region b100-b10f claimed by
PIIX4 SMB
[    0.508188] pci 0000:00:02.0: reg 10 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.512144] pci 0000:00:02.0: reg 14 32bit mmio: [0xf2000000-0xf2000fff]
[    0.531391] pci 0000:00:03.0: reg 10 io port: [0xc020-0xc03f]
[    0.532040] pci 0000:00:04.0: reg 10 io port: [0xc040-0xc07f]
[    0.532359] pci 0000:00:05.0: reg 10 io port: [0xc080-0xc09f]
[    0.532783] pci_bus 0000:00: on NUMA node 0
[    0.532857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.535304] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.535396] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.535479] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.535561] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.536067] SCSI subsystem initialized
[    0.536324] usbcore: registered new interface driver usbfs
[    0.536324] usbcore: registered new interface driver hub
[    0.536324] usbcore: registered new device driver usb
[    0.536324] PCI: Using ACPI for IRQ routing
[    0.541061] Switched to high resolution mode on CPU 0
[    0.541130] Switched to high resolution mode on CPU 1
[    0.541206] Switched to high resolution mode on CPU 7
[    0.541262] Switched to high resolution mode on CPU 5
[    0.541312] Switched to high resolution mode on CPU 8
[    0.541416] Switched to high resolution mode on CPU 4
[    0.541703] Switched to high resolution mode on CPU 2
[    0.541965] Switched to high resolution mode on CPU 6
[    0.541985] Switched to high resolution mode on CPU 3
[    0.542021] Switched to high resolution mode on CPU 9
[    0.543042] pnp: PnP ACPI init
[    0.543068] ACPI: bus type pnp registered
[    0.543822] pnp: PnP ACPI: found 7 devices
[    0.543824] ACPI: ACPI bus type pnp unregistered
[    0.543830] PnPBIOS: Disabled
[    0.580161] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.580164] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.580194] NET: Registered protocol family 2
[    0.589194] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[    0.589686] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.591601] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.592553] TCP: Hash tables configured (established 131072 bind 65536)
[    0.592556] TCP reno registered
[    0.595287] NET: Registered protocol family 1
[    0.595395] Unpacking initramfs...
[    0.750917] Freeing initrd memory: 4447k freed
[    0.752634] cpu0(16) debug files 3
[    0.752649] cpu1(16) debug files 3
[    0.752693] cpu2(16) debug files 3
[    0.752706] cpu3(16) debug files 3
[    0.752718] cpu4(16) debug files 3
[    0.752738] cpu5(16) debug files 3
[    0.752751] cpu6(16) debug files 3
[    0.752763] cpu7(16) debug files 3
[    0.752805] cpu8(16) debug files 3
[    0.752825] cpu9(16) debug files 3
[    0.752830] Machine check exception polling timer started.
[    0.752849] cpufreq-nforce2: No nForce2 chipset.
[    0.753197] Scanning for low memory corruption every 60 seconds
[    0.753363] audit: initializing netlink socket (disabled)
[    0.753384] type=2000 audit(1257855044.753:1): initialized
[    0.762053] highmem bounce pool size: 64 pages
[    0.762059] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.764836] VFS: Disk quotas dquot_6.5.2
[    0.764879] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.765449] fuse init (API version 7.11)
[    0.766196] aufs 2-29
[    0.766212] msgmni has been set to 1707
[    0.769453] alg: No test for stdrng (krng)
[    0.769547] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    0.769557] io scheduler noop registered
[    0.769559] io scheduler anticipatory registered
[    0.769562] io scheduler deadline registered
[    0.769598] io scheduler cfq registered (default)
[    0.769626] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.769664] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.769683] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.769698] pci 0000:00:02.0: Boot video device
[    0.769752] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.769772] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.772248] vesafb: framebuffer at 0xf0000000, mapped to 0xf8080000,
using 3750k, total 4096k
[    0.772250] vesafb: mode is 800x600x16, linelength=1600, pages=3
[    0.772252] vesafb: scrolling: redraw
[    0.772255] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.774287] bootsplash 3.1.6-2004/03/31: looking for picture...
[    0.781093] bootsplash: silentjpeg size 34362 bytes
[    0.787257] bootsplash: ...found (800x600, 26696 bytes, v3).
[    0.798984] Console: switching to colour frame buffer device 100x34
[    0.810922] fb0: VESA VGA frame buffer device
[    0.811145] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.811147] ACPI: Power Button [PWRF]
[    0.811635] processor ACPI_CPU:00: registered as cooling_device0
[    0.811748] processor ACPI_CPU:01: registered as cooling_device1
[    0.811849] processor ACPI_CPU:02: registered as cooling_device2
[    0.811986] processor ACPI_CPU:03: registered as cooling_device3
[    0.812120] processor ACPI_CPU:04: registered as cooling_device4
[    0.812227] processor ACPI_CPU:05: registered as cooling_device5
[    0.812331] processor ACPI_CPU:06: registered as cooling_device6
[    0.812438] processor ACPI_CPU:07: registered as cooling_device7
[    0.812540] processor ACPI_CPU:08: registered as cooling_device8
[    0.812642] processor ACPI_CPU:09: registered as cooling_device9
[    0.814313] isapnp: Scanning for PnP cards...
[    1.132936] isapnp: No Plug & Play device found
[    1.133882] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.134199] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.134632] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.145399] FDC 0 is a S82078B
[    1.145884] loop: module loaded
[    1.145918] input: Macintosh mouse button emulation as
/devices/virtual/input/input1
[    1.145944] Driver 'sd' needs updating - please use bus_type methods
[    1.145951] Driver 'sr' needs updating - please use bus_type methods
[    1.146036] Fixed MDIO Bus: probed
[    1.146057] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.146083] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.146102] uhci_hcd: USB Universal Host Controller Interface driver
[    1.146151] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at
0x60,0x64 irq 1,12
[    1.146853] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.146875] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.146957] mice: PS/2 mouse device common for all mice
[    1.147723] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.147924] rtc0: alarms up to one day, 114 bytes nvram
[    1.147951] EISA: Probing bus 0 at eisa.0
[    1.148150] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[    1.148211] EISA: Detected 0 cards.
[    1.150406] cpuidle: using governor ladder
[    1.150408] cpuidle: using governor menu
[    1.151291] usbcore: registered new interface driver hiddev
[    1.151301] usbcore: registered new interface driver usbhid
[    1.151302] usbhid: v2.6:USB HID core driver
[    1.152063] NET: Registered protocol family 17
[    1.153068] Using IPI No-Shortcut mode
[    1.153305] TuxOnIce 3.0.1 (http://tuxonice.net)
[    1.153375] TuxOnIce: Ignoring late initcall, as requested.
[    1.153385] registered taskstats version 1
[    1.153558] psmouse serio1: ID: 10 00 64
[    1.153812] rtc_cmos 00:01: setting system clock to 2009-11-10
12:10:43 UTC (1257855043)
[    1.154442] Freeing unused kernel memory: 448k freed
[    1.167651] Write protecting the kernel text: 3092k
[    1.173187] Write protecting the kernel read-only data: 1444k
[    1.558224] input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input3
[    2.089215] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    2.089258] virtio-pci 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI
11 (level, high) -> IRQ 11
[    2.089500] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    2.089521] virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI
10 (level, high) -> IRQ 10
[    2.089709] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    2.089712] virtio-pci 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI
10 (level, high) -> IRQ 10
[    2.114900] libata version 3.00 loaded.
[    2.117535] ata_piix 0000:00:01.1: version 2.13
[    2.117687] ata_piix 0000:00:01.1: setting latency timer to 64
[    2.118214] scsi0 : ata_piix
[    2.118514] scsi1 : ata_piix
[    2.118571] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
[    2.118573] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
[    2.421476] ata2.01: NODEV after polling detection
[    2.421787] ata2.00: ATAPI: QEMU DVD-ROM, 0.10.0, max UDMA/100
[    2.422371] ata2.00: configured for MWDMA2
[    2.423523] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM    
0.10 PQ: 0 ANSI: 5
[    2.425747] sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
[    2.425758] Uniform CD-ROM driver Revision: 3.20
[    2.425860] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.425932] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    2.475231]  vda: vda1
[    2.519362] brd: module loaded
[    3.758402] EXT4-fs: barriers enabled
[    3.763918] kjournald2 starting: pid 229, dev vda1:8, commit interval
5 seconds
[    3.763948] EXT4-fs: delayed allocation enabled
[    3.763950] EXT4-fs: file extents enabled
[    3.773524] EXT4-fs: mballoc enabled
[    3.773537] EXT4-fs: mounted filesystem vda1 with ordered data mode
[    6.421525] udev: starting version 146
[    6.943955] piix4_smbus 0000:00:01.3: SMBus Host Controller at
0xb100, revision 0
[    6.951640] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    8.174315] parport_pc 00:05: reported by Plug and Play ACPI
[    8.174489] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    8.261518] lp0: using parport0 (interrupt-driven).
[    8.339160] ppdev: user-space parallel port driver
[    9.338879] EXT4 FS on vda1, internal journal on vda1:8
[   10.075897] Adding 307192k swap on /.swap.  Priority:-1 extents:2
across:315384k SS
[   14.715951] JBD: barrier-based sync failed on vda1:8 - disabling barriers
[   16.748619] NET: Registered protocol family 10
[   16.753682] lo: Disabled Privacy Extensions
[   18.548590] mtrr: no MTRR for f0000000,100000 found
[   19.134074] bootsplash: status on console 0 changed to on
[   27.500044] eth0: no IPv6 routers present
[468044.486305] PPP generic driver version 2.4.2
[468044.501532] NET: Registered protocol family 24
[785560.993888] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[1267812575.161101] BUG: soft lockup - CPU#2 stuck for 1179833091s!
[swapper:0]
[1267812575.161105] Modules linked in: edd pppoe pppox ppp_generic slhc
ipv6 ppdev parport_pc lp parport pcspkr i2c_piix4 brd virtio_net
virtio_blk virtio_balloon ata_generic pata_acpi ata_piix libata virtio_pci
[1267812575.161125]
[1267812575.161139] Pid: 0, comm: swapper Not tainted (2.6.30.9-128 #1)
[1267812575.161141] EIP: 0060:[<c0135829>] EFLAGS: 00000206 CPU: 2
[1267812575.161151] EIP is at __do_softirq+0x3e/0x133
[1267812575.161153] EAX: 00000002 EBX: 00000046 ECX: 11982cd1 EDX: 00000102
[1267812575.161155] ESI: 00000000 EDI: 00037811 EBP: f7093f20 ESP: f7093f04
[1267812575.161157]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1267812575.161161] CR0: 8005003b CR2: b7fe4be8 CR3: 3657f000 CR4: 000006d0
[1267812575.161171] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1267812575.161177] DR6: ffff0ff0 DR7: 00000400
[1267812575.161179] Call Trace:
[1267812575.161185]  [<c013594f>] do_softirq+0x31/0x3c
[1267812575.161188]  [<c0135a3a>] irq_exit+0x29/0x57
[1267812575.161193]  [<c01167a9>] smp_apic_timer_interrupt+0x6f/0x7d
[1267812575.161198]  [<c0103b26>] apic_timer_interrupt+0x2a/0x30
[1267812575.161209]  [<c01400d8>] ? uevent_filter+0xb/0x11
[1267812575.161215]  [<c014c711>] ? tick_nohz_restart_sched_tick+0xa7/0xb1
[1267812575.161218]  [<c01024c3>] cpu_idle+0x5b/0x64
[1267812575.161224]  [<c03fd033>] start_secondary+0xc6/0xc8
[1267812575.162037] BUG: soft lockup - CPU#0 stuck for 1179837187s!
[ata/0:148]
[1267812575.162037] Modules linked in: edd pppoe pppox ppp_generic slhc
ipv6 ppdev parport_pc lp parport pcspkr i2c_piix4 brd virtio_net
virtio_blk virtio_balloon ata_generic pata_acpi ata_piix libata virtio_pci
[1267812575.162037] Pid: 148, comm: ata/0 Not tainted (2.6.30.9-128 #1)
[1267812575.162037] EIP: 0060:[<c0290fff>] EFLAGS: 00000206 CPU: 0
[1267812575.162037] EIP is at ioread8+0x19/0x2f
[1267812575.162037] EAX: 0001c001 EBX: c05a8020 ECX: 019c6000 EDX: 0000c033
[1267812575.162037] ESI: f6afc000 EDI: 00000000 EBP: f690fd1c ESP: f690fd1c
[1267812575.162037]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1267812575.162037] CR0: 8005003b CR2: 0cd5d000 CR3: 36578000 CR4: 000006d0
[1267812575.162037] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1267812575.162037] DR6: ffff0ff0 DR7: 00000400
[1267812575.162037] Call Trace:
[1267812575.162037]  [<f801f3d9>] vp_interrupt+0x1e/0x99 [virtio_pci]
[1267812575.162037]  [<c018b400>] ? __alloc_pages_internal+0xa1/0x387
[1267812575.162037]  [<c0174c0b>] handle_IRQ_event+0x52/0x108
[1267812575.162037]  [<c017600a>] handle_fasteoi_irq+0x69/0x9b
[1267812575.162037]  [<c0104cdb>] handle_irq+0x3b/0x48
[1267812575.162037]  [<c0104648>] do_IRQ+0x40/0x83
[1267812575.162037]  [<c0103889>] common_interrupt+0x29/0x30
[1267812575.162037]  [<c01a84cc>] ? __kmalloc_track_caller+0xbc/0x105
[1267812575.162037]  [<c038ee74>] ? __netdev_alloc_skb+0x17/0x34
[1267812575.162037]  [<c038e489>] __alloc_skb+0x49/0x114
[1267812575.162037]  [<c038ee74>] __netdev_alloc_skb+0x17/0x34
[1267812575.162037]  [<f848cd69>] try_fill_recv+0x39/0x11b [virtio_net]
[1267812575.162037]  [<f848d801>] virtnet_poll+0x7d/0xcc [virtio_net]
[1267812575.162037]  [<c0394192>] net_rx_action+0x92/0x16b
[1267812575.162037]  [<c0135878>] __do_softirq+0x8d/0x133
[1267812575.162037]  [<c013594f>] do_softirq+0x31/0x3c
[1267812575.162037]  [<c0135a3a>] irq_exit+0x29/0x57
[1267812575.162037]  [<c0104675>] do_IRQ+0x6d/0x83
[1267812575.162037]  [<c0103889>] common_interrupt+0x29/0x30
[1267812575.162037]  [<c0400af2>] ? _spin_unlock_irqrestore+0x9/0xf
[1267812575.162037]  [<f843aabd>] ata_sff_hsm_move+0x237/0x49d [libata]
[1267812575.162037]  [<f843aff3>] ata_pio_task+0x8e/0x9e [libata]
[1267812575.162037]  [<c013e8ad>] run_workqueue+0x8a/0x107
[1267812575.162037]  [<f843af65>] ? ata_pio_task+0x0/0x9e [libata]
[1267812575.162037]  [<c013e9e0>] worker_thread+0xb6/0xc2
[1267812575.162037]  [<c0141a53>] ? autoremove_wake_function+0x0/0x33
[1267812575.162037]  [<c013e92a>] ? worker_thread+0x0/0xc2
[1267812575.162037]  [<c014175a>] kthread+0x45/0x6b
[1267812575.162037]  [<c0141715>] ? kthread+0x0/0x6b
[1267812575.162037]  [<c0103c77>] kernel_thread_helper+0x7/0x10
[1267987394.820065] Clocksource tsc unstable (delta = 237368126 ns)
