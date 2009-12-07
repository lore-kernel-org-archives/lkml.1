Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZLGS2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZLGS2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbZLGS2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:28:39 -0500
Received: from snt0-omc3-s2.snt0.hotmail.com ([65.55.90.141]:40744 "EHLO
	snt0-omc3-s2.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbZLGS2g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:28:36 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2009 13:28:36 EST
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS95808AE2188197E753E02A7900@phx.gbl>
From: "Ioannis Kyriakopoulos" <johnkyr83@hotmail.com>
To: "'Christoph Lameter'" <cl@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
References: <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl> <alpine.DEB.2.00.0912070959310.1208@router.home>
In-Reply-To: <alpine.DEB.2.00.0912070959310.1208@router.home>
Subject: RE: timer interrupt stucks using tickless kernel
Date: Mon, 7 Dec 2009 18:22:19 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acp3Vz1urvpcxRLdSbO47GFGqa+m2QAEY4tA
Content-Language: en-gb
X-OriginalArrivalTime: 07 Dec 2009 18:22:25.0935 (UTC) FILETIME=[3A26F1F0:01CA776A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> I have configured my kernel (2.6.31.6) so that I get periodic ticks from
>> the timer interrupt (i.e. tickless is not configured) with a rate
determined
>> by the HZ value. I've also checked the "high resolution timer support"
>> and also SMP support. The posblem is that the timer is getting
incremented
>> very slowly (way slower than the HZ value), just like it would be if the
>> kernel was tickless. Is there an explanation for that? How can I get
>> periodic
>> timer ticks? 
>
>This is what platform? Embedded? Timer is referring to the system time
>running slow? kernel boot log would be useful.

It's on a dual-core atom on an Intel's motherboard. The problem is that the 
system timer is not running periodically at HZ frequency.

That's my kernel boot log:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31.6 (limp@ubuntu) (gcc version 4.4.1
(Ubuntu 4.4.1-4ubuntu8) ) #8 SMP Fri Dec 4 16:11:14 GMT 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f525000 (usable)
[    0.000000]  BIOS-e820: 000000001f525000 - 000000001f52d000 (reserved)
[    0.000000]  BIOS-e820: 000000001f52d000 - 000000001f5bd000 (usable)
[    0.000000]  BIOS-e820: 000000001f5bd000 - 000000001f5c1000 (reserved)
[    0.000000]  BIOS-e820: 000000001f5c1000 - 000000001f656000 (usable)
[    0.000000]  BIOS-e820: 000000001f656000 - 000000001f6f0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f6f0000 - 000000001f6f2000 (usable)
[    0.000000]  BIOS-e820: 000000001f6f2000 - 000000001f6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f6ff000 - 000000001f700000 (usable)
[    0.000000]  BIOS-e820: 000000001f700000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1f700 max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000008f000 (usable)
[    0.000000]  modified: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000001f525000 (usable)
[    0.000000]  modified: 000000001f525000 - 000000001f52d000 (reserved)
[    0.000000]  modified: 000000001f52d000 - 000000001f5bd000 (usable)
[    0.000000]  modified: 000000001f5bd000 - 000000001f5c1000 (reserved)
[    0.000000]  modified: 000000001f5c1000 - 000000001f656000 (usable)
[    0.000000]  modified: 000000001f656000 - 000000001f6f0000 (ACPI NVS)
[    0.000000]  modified: 000000001f6f0000 - 000000001f6f2000 (usable)
[    0.000000]  modified: 000000001f6f2000 - 000000001f6ff000 (ACPI data)
[    0.000000]  modified: 000000001f6ff000 - 000000001f700000 (usable)
[    0.000000]  modified: 000000001f700000 - 0000000020000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-000000001f700000
[    0.000000] RAMDISK: 1f25f000 - 1f524599
[    0.000000] ACPI: RSDP 000fe020 00014 (v00 INTEL )
[    0.000000] ACPI: RSDT 1f6fd038 0003C (v01 INTEL  D945GLF2 00000063
01000013)
[    0.000000] ACPI: FACP 1f6fc000 00074 (v01 INTEL  D945GLF2 00000063 MSFT
01000013)
[    0.000000] ACPI: DSDT 1f6f7000 04787 (v01 INTEL  D945GLF2 00000063 MSFT
01000013)
[    0.000000] ACPI: FACS 1f6a3000 00040
[    0.000000] ACPI: APIC 1f6f6000 00078 (v01 INTEL  D945GLF2 00000063 MSFT
01000013)
[    0.000000] ACPI: WDDT 1f6f5000 00040 (v01 INTEL  D945GLF2 00000063 MSFT
01000013)
[    0.000000] ACPI: MCFG 1f6f4000 0003C (v01 INTEL  D945GLF2 00000063 MSFT
01000013)
[    0.000000] ACPI: ASF! 1f6f3000 000A6 (v32 INTEL  D945GLF2 00000063 MSFT
01000013)
[    0.000000] ACPI: HPET 1f6f2000 00038 (v01 INTEL  D945GLF2 00000063 MSFT
01000013)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f700000
[    0.000000]   low ram: 0 - 1f700000
[    0.000000]   node 0 low ram: 00000000 - 1f700000
[    0.000000]   node 0 bootmap 00008000 - 0000bee0
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 001f700000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00017f6e28]    TEXT DATA BSS ==>
[0001000000 - 00017f6e28]
[    0.000000]   #4 [001f25f000 - 001f524599]          RAMDISK ==>
[001f25f000 - 001f524599]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #6 [00017f7000 - 00017fe16e]              BRK ==>
[00017f7000 - 00017fe16e]
[    0.000000]   #7 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #8 [0000008000 - 000000c000]          BOOTMAP ==>
[0000008000 - 000000c000]
[    0.000000] found SMP MP-table at [c00fe200] fe200
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f700
[    0.000000]   HighMem  0x0001f700 -> 0x0001f700
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000008f
[    0.000000]     0: 0x00000100 -> 0x0001f525
[    0.000000]     0: 0x0001f52d -> 0x0001f5bd
[    0.000000]     0: 0x0001f5c1 -> 0x0001f656
[    0.000000]     0: 0x0001f6f0 -> 0x0001f6f2
[    0.000000]     0: 0x0001f6ff -> 0x0001f700
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000002000 -
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000008f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
[    0.000000] PM: Registered nosave memory: 000000001f525000 -
000000001f52d000
[    0.000000] PM: Registered nosave memory: 000000001f5bd000 -
000000001f5c1000
[    0.000000] PM: Registered nosave memory: 000000001f656000 -
000000001f6f0000
[    0.000000] PM: Registered nosave memory: 000000001f6f2000 -
000000001f6ff000
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
20000000:d0000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c1bf2000, static data 33436
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 127466
[    0.000000] Kernel command line: console=tty0 console=ttyS0,115200n8
initrd=/boot/ramdisk.gz ramdisk_size=8192 root=/dev/ram0 rw autoexec=xconf
BOOT_IMAGE=/boot/bzImage
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072
bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 497544k/515072k available (4432k kernel code, 15724k
reserved, 2626k data, 380k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xdff00000 - 0xff7fe000   ( 504 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf700000   ( 503 MB)
[    0.000000]       .init : 0xc16e5000 - 0xc1744000   ( 380 kB)
[    0.000000]       .data : 0xc1454167 - 0xc16e4ba8   (2626 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1454167   (4432 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1596.183 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] console [ttyS0] enabled
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu
timer
[    0.001009] Calibrating delay loop (skipped), value calculated using
timer frequency.. 3192.36 BogoMIPS (lpj=1596183)
[    0.003025] Security Framework initialized
[    0.004009] SELinux:  Initializing.
[    0.005028] Mount-cache hash table entries: 512
[    0.006223] Initializing cgroup subsys ns
[    0.007010] Initializing cgroup subsys cpuacct
[    0.008011] Initializing cgroup subsys freezer
[    0.009031] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.011004] CPU: L2 cache: 512K
[    0.012006] CPU: Physical Processor ID: 0
[    0.013004] CPU: Processor Core ID: 0
[    0.014006] mce: CPU supports 5 MCE banks
[    0.015012] CPU0: Thermal monitoring enabled (TM1)
[    0.016006] using mwait in idle threads.
[    0.017010] Performance Counters: Atom events, Intel PMU driver.
[    0.020013] ... version:                 3
[    0.021004] ... bit width:               40
[    0.022004] ... generic counters:        2
[    0.023004] ... value mask:              000000ffffffffff
[    0.024004] ... max period:              000000007fffffff
[    0.025004] ... fixed-purpose counters:  3
[    0.026004] ... counter mask:            0000000700000003
[    0.027007] Checking 'hlt' instruction... OK.
[    0.033083] ACPI: Core revision 20090521
[    0.043452] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054934] CPU0: Intel(R) Atom(TM) CPU  330   @ 1.60GHz stepping 02
[    0.057999] Booting processor 1 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3192.25
BogoMIPS (lpj=1596128)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.000999] CPU: L2 cache: 512K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 5 MCE banks
[    0.000999] CPU1: Thermal monitoring enabled (TM1)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new
0x7010600070106
[    0.130845] CPU1: Intel(R) Atom(TM) CPU  330   @ 1.60GHz stepping 02
[    0.133010] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.133999] Measured 72 cycles TSC warp between CPUs, turning off TSC
clock.
[    0.133999] Marking TSC unstable due to check_tsc_sync_source failed
[    0.134158] Booting processor 2 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 3192.19
BogoMIPS (lpj=1596099)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.000999] CPU: L2 cache: 512K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] mce: CPU supports 5 MCE banks
[    0.000999] CPU2: Thermal monitoring enabled (TM1)
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new
0x7010600070106
[    0.208351] CPU2: Intel(R) Atom(TM) CPU  330   @ 1.60GHz stepping 02
[    0.212145] Booting processor 3 APIC 0x3 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 3192.24
BogoMIPS (lpj=1596121)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.000999] CPU: L2 cache: 512K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 5 MCE banks
[    0.000999] CPU3: Thermal monitoring enabled (TM1)
[    0.000999] x86 PAT enabled: cpu 3, old 0x7040600070406, new
0x7010600070106
[    0.287484] CPU3: Intel(R) Atom(TM) CPU  330   @ 1.60GHz stepping 02
[    0.290041] Brought up 4 CPUs
[    0.291006] Total of 4 processors activated (12769.06 BogoMIPS).
[    0.292530] khelper used greatest stack depth: 7020 bytes left
[    0.299753] Time: 19:14:14  Date: 12/07/09
[    0.301031] NET: Registered protocol family 16
[    0.303607] ACPI: bus type pci registered
[    0.304278] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 -
127
[    0.305006] PCI: MCFG area at f0000000 reserved in E820
[    0.306004] PCI: Using MMCONFIG for extended config space
[    0.307003] PCI: Using configuration type 1 for base access
[    0.328187] bio: create slab <bio-0> at 0
[    0.335695] ACPI: Interpreter enabled
[    0.336008] ACPI: (supports S0 S1 S3 S4 S5)
[    0.338642] ACPI: Using IOAPIC for interrupt routing
[    0.350349] ACPI: No dock devices found.
[    0.353469] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.354399] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.355007] pci 0000:00:1b.0: PME# disabled
[    0.356076] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.357006] pci 0000:00:1c.0: PME# disabled
[    0.358081] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.359007] pci 0000:00:1c.2: PME# disabled
[    0.360074] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.361006] pci 0000:00:1c.3: PME# disabled
[    0.362364] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.363007] pci 0000:00:1d.7: PME# disabled
[    0.364140] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6
ACPI/GPIO/TCO
[    0.365009] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6
GPIO
[    0.366006] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680
(mask 007f)
[    0.367224] pci 0000:00:1f.2: PME# supported from D3hot
[    0.368006] pci 0000:00:1f.2: PME# disabled
[    0.369252] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.370007] pci 0000:01:00.0: PME# disabled
[    0.371238] pci 0000:00:1e.0: transparent bridge
[    0.382671] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.385563] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) *0,
disabled.
[    0.390193] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)
[    0.394203] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.398433] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0,
disabled.
[    0.402438] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0,
disabled.
[    0.407198] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.411198] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    0.416031] SCSI subsystem initialized
[    0.418784] usbcore: registered new interface driver usbfs
[    0.419107] usbcore: registered new interface driver hub
[    0.420155] usbcore: registered new device driver usb
[    0.421804] PCI: Using ACPI for IRQ routing
[    0.441149] cfg80211: Using static regulatory domain info
[    0.442004] cfg80211: Regulatory domain: US
[    0.443003]  (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
[    0.444005]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.445006]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.446005]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.447008]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.448005]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.449005]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.450014] cfg80211: Calling CRDA for country: US
[    0.451099] NetLabel: Initializing
[    0.452003] NetLabel:  domain hash size = 128
[    0.453002] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.454026] NetLabel:  unlabeled traffic allowed by default
[    0.455245] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.457246] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.468034] pnp: PnP ACPI init
[    0.471199] ACPI: bus type pnp registered
[    0.481858] pnp: PnP ACPI: found 12 devices
[    0.486123] ACPI: ACPI bus type pnp unregistered
[    0.490834] system 00:01: iomem range 0xf0000000-0xf3ffffff has been
reserved
[    0.498040] system 00:01: iomem range 0xfed13000-0xfed13fff has been
reserved
[    0.505251] system 00:01: iomem range 0xfed14000-0xfed17fff has been
reserved
[    0.512461] system 00:01: iomem range 0xfed18000-0xfed18fff has been
reserved
[    0.519667] system 00:01: iomem range 0xfed19000-0xfed19fff has been
reserved
[    0.526870] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been
reserved
[    0.534073] system 00:01: iomem range 0xfed20000-0xfed3ffff has been
reserved
[    0.541281] system 00:01: iomem range 0xfed45000-0xfed99fff has been
reserved
[    0.548484] system 00:01: iomem range 0xc0000-0xdffff could not be
reserved
[    0.555514] system 00:01: iomem range 0xe0000-0xfffff could not be
reserved
[    0.562555] system 00:06: ioport range 0x500-0x53f has been reserved
[    0.568975] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.575400] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.617803] pci 0000:01:00.0: BAR 6: no parent found for of device
[0xfffe0000-0xffffffff]
[    0.626218] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.632209] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    0.637587] pci 0000:00:1c.0:   MEM window: 0x30100000-0x301fffff
[    0.643748] pci 0000:00:1c.0:   PREFETCH window:
0x00000030000000-0x000000300fffff
[    0.651419] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.657405] pci 0000:00:1c.2:   IO window: disabled
[    0.662350] pci 0000:00:1c.2:   MEM window: disabled
[    0.667382] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.672849] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    0.678832] pci 0000:00:1c.3:   IO window: disabled
[    0.683776] pci 0000:00:1c.3:   MEM window: disabled
[    0.688808] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.694275] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.700259] pci 0000:00:1e.0:   IO window: disabled
[    0.705211] pci 0000:00:1e.0:   MEM window: disabled
[    0.710243] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.715741] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.722537] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.729336] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.736243] NET: Registered protocol family 2
[    0.740861] IP route cache hash table entries: 4096 (order: 2, 16384
bytes)
[    0.748516] TCP established hash table entries: 16384 (order: 5, 131072
bytes)
[    0.755969] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.762759] TCP: Hash tables configured (established 16384 bind 16384)
[    0.769352] TCP reno registered
[    0.772743] NET: Registered protocol family 1
[    0.777315] Trying to unpack rootfs image as initramfs...
[    0.783378] rootfs image is not initramfs (no cpio magic); looks like an
initrd
[    0.796567] Freeing initrd memory: 2837k freed
[    0.808626] microcode: CPU0 sig=0x106c2, pf=0x8, revision=0x20d
[    0.814641] microcode: CPU1 sig=0x106c2, pf=0x8, revision=0x20d
[    0.820639] microcode: CPU2 sig=0x106c2, pf=0x8, revision=0x20d
[    0.826635] microcode: CPU3 sig=0x106c2, pf=0x8, revision=0x20d
[    0.832753] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>,
Peter Oruba
[    0.840690] Scanning for low memory corruption every 60 seconds
[    0.847462] audit: initializing netlink socket (disabled)
[    0.852955] type=2000 audit(1260213252.852:1): initialized
[    0.876434] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.889907] VFS: Disk quotas dquot_6.5.2
[    0.894124] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.910113] NTFS driver 2.1.29 [Flags: R/O].
[    0.914891] msgmni has been set to 978
[    0.920213] alg: No test for stdrng (krng)
[    0.924790] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 252)
[    0.932295] io scheduler noop registered
[    0.936283] io scheduler anticipatory registered
[    0.940965] io scheduler deadline registered
[    0.945496] io scheduler cfq registered (default)
[    0.952378] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.958771] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.966285] ACPI: Power Button [PWRF]
[    0.970230] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.978518] ACPI: Sleep Button [SLPB]
[    0.982772] processor LNXCPU:00: registered as cooling_device0
[    0.988826] processor LNXCPU:01: registered as cooling_device1
[    0.994880] processor LNXCPU:02: registered as cooling_device2
[    1.000937] processor LNXCPU:03: registered as cooling_device3
[    1.018723] Non-volatile memory driver v1.3
[    1.023167] intel_rng: Firmware space is locked read-only. If you can't
or
[    1.023171] intel_rng: don't want to disable this in firmware setup, and
if
[    1.023174] intel_rng: you are certain that your system has a functional
[    1.023177] intel_rng: RNG, try using the 'no_fwh_detect' option.
[    1.050859] Linux agpgart interface v0.103
[    1.055182] agpgart-intel 0000:00:00.0: Intel 945G Chipset
[    1.061095] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    1.070352] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x20000000
[    1.077485] [drm] Initialized drm 1.1.0 20060810
[    1.082230] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.092653] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on
minor 0
[    1.099924] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    1.350357] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.357380] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.363882] brd: module loaded
[    1.369203] loop: module loaded
[    1.372631] input: Macintosh mouse button emulation as
/devices/virtual/input/input2
[    1.381291] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) ->
IRQ 18
[    1.388744] scsi0 : ata_piix
[    1.392048] scsi1 : ata_piix
[    1.396155] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x20b0 irq
14
[    1.403192] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x20b8 irq
15
[    1.410364] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) ->
IRQ 19
[    1.417570] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.423144] scsi2 : ata_piix
[    1.426415] scsi3 : ata_piix
[    1.429773] ata3: SATA max UDMA/133 cmd 0x20c8 ctl 0x20ec bmdma 0x20a0
irq 19
[    1.436975] ata4: SATA max UDMA/133 cmd 0x20c0 ctl 0x20e8 bmdma 0x20a8
irq 19
[    1.444988] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    1.451498] Copyright (c) 1999-2006 Intel Corporation.
[    1.456817] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    1.462816] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.468927] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.475086] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.480946] sky2 driver version 1.23
[    1.484919] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.490583] r8169 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    1.498268] eth0: RTL8168c/8111c at 0xdff48000, 00:1c:c0:a9:2b:49, XID
3c4000c0 IRQ 27
[    1.509279] console [netcon0] enabled
[    1.513009] netconsole: network logging started
[    1.518004] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.524664] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) ->
IRQ 23
[    1.531891] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.537390] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus
number 1
[    1.548830] ehci_hcd 0000:00:1d.7: debug port 1
[    1.553469] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x302c4000
[    1.564714] ata1.00: CFA: InnoDisk Corp. - EDC4000 1GB, 071220b, max
UDMA/66
[    1.569273] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.569355] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.569360] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.569365] usb usb1: Product: EHCI Host Controller
[    1.569370] usb usb1: Manufacturer: Linux 2.6.31.6 ehci_hcd
[    1.569374] usb usb1: SerialNumber: 0000:00:1d.7
[    1.569619] usb usb1: configuration #1 chosen from 1 choice
[    1.569814] hub 1-0:1.0: USB hub found
[    1.569831] hub 1-0:1.0: 8 ports detected
[    1.570109] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.570288] uhci_hcd: USB Universal Host Controller Interface driver
[    1.570373] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) ->
IRQ 23
[    1.570398] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.570598] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus
number 2
[    1.570612] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.570660] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    1.570756] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.570761] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.570766] usb usb2: Product: UHCI Host Controller
[    1.570771] usb usb2: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.570775] usb usb2: SerialNumber: 0000:00:1d.0
[    1.570982] usb usb2: configuration #1 chosen from 1 choice
[    1.571189] hub 2-0:1.0: USB hub found
[    1.571206] hub 2-0:1.0: 2 ports detected
[    1.571348] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) ->
IRQ 19
[    1.571368] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.571571] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus
number 3
[    1.571584] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.571629] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    1.571726] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.571731] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.571736] usb usb3: Product: UHCI Host Controller
[    1.571741] usb usb3: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.571745] usb usb3: SerialNumber: 0000:00:1d.1
[    1.571966] usb usb3: configuration #1 chosen from 1 choice
[    1.572157] hub 3-0:1.0: USB hub found
[    1.572174] hub 3-0:1.0: 2 ports detected
[    1.572326] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) ->
IRQ 18
[    1.572346] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.572531] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus
number 4
[    1.572546] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.572613] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    1.572709] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.572714] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.572719] usb usb4: Product: UHCI Host Controller
[    1.572724] usb usb4: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.572728] usb usb4: SerialNumber: 0000:00:1d.2
[    1.572945] usb usb4: configuration #1 chosen from 1 choice
[    1.573123] hub 4-0:1.0: USB hub found
[    1.573139] hub 4-0:1.0: 2 ports detected
[    1.573289] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) ->
IRQ 16
[    1.573311] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.573506] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus
number 5
[    1.573519] uhci_hcd 0000:00:1d.3: detected 2 ports
[    1.573580] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
[    1.573685] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.573691] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.573696] usb usb5: Product: UHCI Host Controller
[    1.573701] usb usb5: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.573705] usb usb5: SerialNumber: 0000:00:1d.3
[    1.573917] usb usb5: configuration #1 chosen from 1 choice
[    1.574099] hub 5-0:1.0: USB hub found
[    1.574115] hub 5-0:1.0: 2 ports detected
[    1.574526] usbcore: registered new interface driver usblp
[    1.574533] Initializing USB Mass Storage driver...
[    1.574696] usbcore: registered new interface driver usb-storage
[    1.574702] USB Mass Storage support registered.
[    1.574857] usbcore: registered new interface driver libusual
[    1.575127] usbcore: registered new interface driver usbserial
[    1.575131] usbserial: USB Serial Driver core
[    1.575616] PNP: No PS/2 controller found. Probing ports directly.
[    1.578722] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.578737] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.579032] mice: PS/2 mouse device common for all mice
[    1.580056] rtc_cmos 00:03: RTC can wake from S4
[    1.580250] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.580306] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.580474] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) ->
IRQ 19
[    1.580485] ACPI: I/O resource 0000:00:1f.3 [0x2000-0x201f] conflicts
with ACPI region SMB1 [0x2000-0x2016]
[    1.580490] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    1.581303] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:
dm-devel@redhat.com
[    1.581664] cpuidle: using governor ladder
[    1.585421] usbcore: registered new interface driver hiddev
[    1.585551] usbcore: registered new interface driver usbhid
[    1.585559] usbhid: v2.6:USB HID core driver
[    1.585979] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    1.586947] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) ->
IRQ 22
[    1.619119] hda_codec: Unknown model for ALC662 rev1, trying auto-probe
from BIOS...
[    1.624464] ALSA device list:
[    1.624470]   #0: HDA Intel at 0x302c0000 irq 22
[    1.624578] Netfilter messages via NETLINK v0.30.
[    1.624616] nf_conntrack version 0.5.0 (8048 buckets, 32192 max)
[    1.625202] ctnetlink v0.93: registering with nfnetlink.
[    1.626874] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.626930] TCP cubic registered
[    1.626933] Initializing XFRM netlink socket
[    1.627872] NET: Registered protocol family 10
[    1.630553] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.630711] IPv6 over IPv4 tunneling driver
[    1.632535] NET: Registered protocol family 17
[    1.633165] RPC: Registered udp transport module.
[    1.633170] RPC: Registered tcp transport module.
[    1.633275] Using IPI No-Shortcut mode
[    1.633791] registered taskstats version 1
[    1.634107]   Magic number: 5:745:242
[    1.922157] usb 1-5: new high speed USB device using ehci_hcd and address
3
[    2.038660] usb 1-5: New USB device found, idVendor=058f, idProduct=6387
[    2.038665] usb 1-5: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    2.038670] usb 1-5: Product: Mass Storage Device
[    2.038675] usb 1-5: Manufacturer: Generic
[    2.038679] usb 1-5: SerialNumber: UZIHOJOMGNG8D5JOPKOZ
[    2.038953] usb 1-5: configuration #1 chosen from 1 choice
[    2.039494] scsi4 : SCSI emulation for USB Mass Storage devices
[    2.203879] ata1.00: 2047248 sectors, multi 2: LBA
[    2.209371] ata1.00: configured for UDMA/66
[    2.213839] scsi 0:0:0:0: Direct-Access     ATA      InnoDisk Corp. -
0712 PQ: 0 ANSI: 5
[    2.222781] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.226884] sd 0:0:0:0: [sda] 2047248 512-byte logical blocks: (1.04
GB/999 MiB)
[    2.226997] sd 0:0:0:0: [sda] Write Protect is off
[    2.227068] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled,
doesn't support DPO or FUA
[    2.227419]  sda: sda1
[    2.252869] usb 3-1: new low speed USB device using uhci_hcd and address
2
[    2.254461] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.264552] md: Waiting for all devices to be available before autodetect
[    2.271428] md: If you don't use raid, use raid=noautodetect
[    2.277562] md: Autodetecting RAID arrays.
[    2.281741] md: Scanned 0 and added 0 devices.
[    2.286257] md: autorun ...
[    2.289114] md: ... autorun DONE.
[    2.292551] RAMDISK: gzip image found at block 0
[    2.436123] usb 3-1: New USB device found, idVendor=0a81, idProduct=0101
[    2.442911] usb 3-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    2.450115] usb 3-1: Product: USB Keyboard
[    2.454313] usb 3-1: Manufacturer: CHESEN
[    2.458756] usb 3-1: configuration #1 chosen from 1 choice
[    2.482624] input: CHESEN USB Keyboard as
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input3
[    2.492680] generic-usb 0003:0A81:0101.0001: input,hidraw0: USB HID v1.10
Keyboard [CHESEN USB Keyboard] on usb-0000:00:1d.1-1/input0
[    2.504916] EXT2-fs warning: mounting unchecked fs, running e2fsck is
recommended
[    2.512539] VFS: Mounted root (ext2 filesystem) on device 1:0.
[    2.518504] Freeing unused kernel memory: 380k freed
[    2.523828] Write protecting the kernel text: 4436k
[    2.528864] Write protecting the kernel read-only data: 2132k
[    2.533401] input: CHESEN USB Keyboard as
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.1/input/input4
[    2.536616] hotplug used greatest stack depth: 6260 bytes left
[    2.539600] generic-usb 0003:0A81:0101.0002: input,hidraw1: USB HID v1.10
Device [CHESEN USB Keyboard] on usb-0000:00:1d.1-1/input1
[    2.572158] r8169: eth0: link down
[    2.575748] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.040030] scsi 4:0:0:0: Direct-Access     FLASH    Drive AU_USB20
8.07 PQ: 0 ANSI: 2
[    7.050646] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    7.057238] sd 4:0:0:0: [sdb] 2037760 512-byte logical blocks: (1.04
GB/995 MiB)
[    7.065234] sd 4:0:0:0: [sdb] Write Protect is off
[    7.070116] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    7.078354] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    7.084530]  sdb: sdb1
[    7.273482] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    7.279652] sd 4:0:0:0: [sdb] Attached SCSI removable disk

>> AFAI understand, the HPET timer is used through the IO-APIC controller to
>> trigger the processors (N.B. if the "High Resolution Timer Support"
option
>> wasn't checked, the timer used would  be PIT, right?) and each
processor's
>> LAPIC timer is used for time keeping. Please correct me if I am wrong.
>>
>> Another question is how the LAPIC timner's rate is determined? In my
case,
>> it seams that an interurpt by LAPIC timer is generated very appoximately
>> 0.25 sec (that is HZ which is 1000 * 4) but I can't understand why.
>
>You could have 4 processors that each need a timer interrupt at
>1000 HZ?

I really can’t get your point. My question is how the LAPIC's timer rate
is determined.

Thanks,

John K

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Christoph Lameter
Sent: 07 December 2009 16:06
To: Ioannis Kyriakopoulos
Cc: linux-kernel@vger.kernel.org; John Stultz; Thomas Gleixner
Subject: Re: timer interrupt stucks using tickless kernel

On Mon, 7 Dec 2009, Ioannis Kyriakopoulos wrote:

> I have configured my kernel (2.6.31.6) so that I get periodic ticks from
> the timer interrupt (i.e. tickless is not configured) with a rate
determined
> by the HZ value. I've also checked the "high resolution timer support"
> and also SMP support. The posblem is that the timer is getting incremented
> very slowly (way slower than the HZ value), just like it would be if the
> kernel was tickless. Is there an explanation for that? How can I get
> periodic
> timer ticks?

This is what platform? Embedded? Timer is referring to the system time
running slow? kernel boot log would be useful.

> AFAI understand, the HPET timer is used through the IO-APIC controller to
> trigger the processors (N.B. if the "High Resolution Timer Support" option
> wasn't checked, the timer used would  be PIT, right?) and each processor's
> LAPIC timer is used for time keeping. Please correct me if I am wrong.
>
> Another question is how the LAPIC timner's rate is determined? In my case,
> it seams that an interurpt by LAPIC timer is generated very appoximately
> 0.25 sec (that is HZ which is 1000 * 4) but I can't understand why.

You could have 4 processors that each need a timer interrupt at
1000 HZ?

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

