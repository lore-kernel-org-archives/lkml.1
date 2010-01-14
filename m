Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415Ab0ANNGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0ANNGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201Ab0ANNGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:06:03 -0500
Received: from twilight.fidra.de ([88.198.14.164]:46353 "EHLO
	twilight.fidra.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab0ANNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:05:57 -0500
From: Volker Lanz <vl@fidra.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Thu, 14 Jan 2010 14:05:53 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31-17-generic; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200912071856.48125.vl@fidra.de> <201001131904.39254.vl@fidra.de> <4B4E25A1.5010303@kernel.org>
In-Reply-To: <4B4E25A1.5010303@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001141405.53256.vl@fidra.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010 20:57:21 Yinghai Lu wrote:
> so e820_update_range does right job...
> 
> please you try to disable
> 
> X86_CHECK_BIOS_CORRUPTION
> 
> and
> 
> CONFIG_X86_RESERVE_LOW_64K

I did a checkout of master and built with these two settings disabled. Here's 
how it went when I booted that and suspended/resumed (I have no idea why the 
file system went crazy):

-----------------------------------------------------------------------------

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32 (vl@trevor) (gcc version 4.4.1 (Ubuntu 
4.4.1-4ubuntu8) ) #3 SMP Thu Jan 14 13:14:22 CET 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32 
root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro debug nosplash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee2000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001a0000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1a0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 100000000 mask F00000000 write-back
[    0.000000]   3 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 1A0000000 mask FE0000000 uncachable
[    0.000000]   5 base 0DFF00000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0xdfee0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfee0000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfee0000 page 4k
[    0.000000] kernel direct mapping tables up to dfee0000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-00000001a0000000
[    0.000000]  0100000000 - 01a0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1a0000000 @ c000-14000
[    0.000000] RAMDISK: 33b14000 - 37fef9ee
[    0.000000] ACPI: RSDP 00000000000f7280 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000dfee2040 0004C (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: FACP 00000000dfee20c0 00074 (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000dfee2180 04CD9 (v01 GBT    GBTUACPI 00001000 
MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000dfee0000 00040
[    0.000000] ACPI: EUDS 00000000dfee7580 00500 (v01 GBT             00000000      
00000000)
[    0.000000] ACPI: HPET 00000000dfee74c0 00038 (v01 GBT    GBTUACPI 42302E31 
GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000dfee7540 0003C (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: APIC 00000000dfee6ec0 00084 (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000dfee83b0 0018A (v01  PmRef  Cpu0Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000dfee8540 0018A (v01  PmRef  Cpu1Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000dfee86d0 0018A (v01  PmRef  Cpu2Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000dfee8860 0018A (v01  PmRef  Cpu3Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000dfee89f0 003AB (v01  PmRef    CpuPm 00003000 
INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 01a0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]
[    0.000000]   #2 [0001000000 - 0001ac2584]    TEXT DATA BSS ==> [0001000000 
- 0001ac2584]
[    0.000000]   #3 [0033b14000 - 0037fef9ee]          RAMDISK ==> [0033b14000 
- 0037fef9ee]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 
- 0000100000]
[    0.000000]   #5 [0001ac3000 - 0001ac30f6]              BRK ==> [0001ac3000 
- 0001ac30f6]
[    0.000000]   #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 
- 000000c000]
[    0.000000]   #7 [000000c000 - 000000f000]          PGTABLE ==> [000000c000 
- 000000f000]
[    0.000000] found SMP MP-table at [ffff8800000f5890] f5890
[    0.000000]  [ffffea0000000000-ffffea0005bfffff] PMD -> [ffff880028600000-
ffff88002dbfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001a0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfee0
[    0.000000]     0: 0x00100000 -> 0x001a0000
[    0.000000] On node 0 totalpages: 1572479
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 106 pages reserved
[    0.000000]   DMA zone: 3837 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898840 pages, LIFO batch:31
[    0.000000]   Normal zone: 8960 pages used for memmap
[    0.000000]   Normal zone: 646400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfee0000 - 
00000000dfee2000
[    0.000000] PM: Registered nosave memory: 00000000dfee2000 - 
00000000dfef0000
[    0.000000] PM: Registered nosave memory: 00000000dfef0000 - 
00000000dff00000
[    0.000000] PM: Registered nosave memory: 00000000dff00000 - 
00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 
00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at dff00000 (gap: 
dff00000:10100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s90200 r8192 
d24488 u524288
[    0.000000] pcpu-alloc: s90200 r8192 d24488 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1549077
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32 
root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro debug nosplash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 6040356k/6815744k available (5307k kernel code, 525828k 
absent, 248644k reserved, 3593k data, 548k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want 
memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2833.327 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5666.65 BogoMIPS (lpj=11333308)
[    0.004101] Security Framework initialized
[    0.004149] SELinux:  Disabled at boot.
[    0.004192] Mount-cache hash table entries: 256
[    0.004349] Initializing cgroup subsys ns
[    0.004390] Initializing cgroup subsys cpuacct
[    0.004430] Initializing cgroup subsys memory
[    0.004472] Initializing cgroup subsys freezer
[    0.004525] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004590] CPU: L2 cache: 6144K
[    0.004629] CPU: Physical Processor ID: 0
[    0.004666] CPU: Processor Core ID: 0
[    0.004705] using mwait in idle threads.
[    0.004742] Performance Events: Core2 events, Intel PMU driver.
[    0.005425] ... version:                2
[    0.005462] ... bit width:              40
[    0.005500] ... generic registers:      2
[    0.005538] ... value mask:             000000ffffffffff
[    0.005577] ... max period:             000000007fffffff
[    0.005616] ... fixed-purpose events:   3
[    0.005654] ... event mask:             0000000700000003
[    0.008746] ACPI: Core revision 20090903
[    0.016058] Setting APIC routing to flat
[    0.016453] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.056999] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.060001] Booting processor 1 APIC 0x3 ip 0x6000
[    0.008000] Initializing CPU#1
[    0.008000] Calibrating delay using timer specific routine.. 5665.98 
BogoMIPS (lpj=11331967)
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 6144K
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 3
[    0.144085] CPU1: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.144413] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.148121] Booting processor 2 APIC 0x2 ip 0x6000
[    0.008000] Initializing CPU#2
[    0.008000] Calibrating delay using timer specific routine.. 5665.98 
BogoMIPS (lpj=11331966)
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 6144K
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 2
[    0.236093] CPU2: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.236421] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.240118] Booting processor 3 APIC 0x1 ip 0x6000
[    0.008000] Initializing CPU#3
[    0.008000] Calibrating delay using timer specific routine.. 5665.95 
BogoMIPS (lpj=11331900)
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 6144K
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 1
[    0.328098] CPU3: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.328427] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.332078] Brought up 4 CPUs
[    0.332117] Total of 4 processors activated (22664.57 BogoMIPS).
[    0.334338] CPU0 attaching sched-domain:
[    0.334377]  domain 0: span 0,3 level MC
[    0.334442]   groups: 0 3
[    0.334560]   domain 1: span 0-3 level CPU
[    0.334625]    groups: 0,3 (cpu_power = 2048) 1-2 (cpu_power = 2048)
[    0.334801] CPU1 attaching sched-domain:
[    0.334839]  domain 0: span 1-2 level MC
[    0.334903]   groups: 1 2
[    0.335020]   domain 1: span 0-3 level CPU
[    0.335085]    groups: 1-2 (cpu_power = 2048) 0,3 (cpu_power = 2048)
[    0.335260] CPU2 attaching sched-domain:
[    0.335298]  domain 0: span 1-2 level MC
[    0.335362]   groups: 2 1
[    0.335480]   domain 1: span 0-3 level CPU
[    0.336041]    groups: 1-2 (cpu_power = 2048) 0,3 (cpu_power = 2048)
[    0.336216] CPU3 attaching sched-domain:
[    0.336254]  domain 0: span 0,3 level MC
[    0.336318]   groups: 3 0
[    0.336446]   domain 1: span 0-3 level CPU
[    0.336511]    groups: 0,3 (cpu_power = 2048) 1-2 (cpu_power = 2048)
[    0.336797] regulator: core version 0.5
[    0.336797] Time: 13:30:58  Date: 01/14/10
[    0.336797] NET: Registered protocol family 16
[    0.336797] ACPI: bus type pci registered
[    0.336797] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.336797] PCI: MCFG area at f0000000 reserved in E820
[    0.337417] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.337456] PCI: Using configuration type 1 for base access
[    0.338023] bio: create slab <bio-0> at 0
[    0.340356] ACPI: EC: Look up EC in DSDT
[    0.344001] ACPI: Interpreter enabled
[    0.344001] ACPI: (supports S0 S3 S4 S5)
[    0.344001] ACPI: Using IOAPIC for interrupt routing
[    0.349209] ACPI: No dock devices found.
[    0.349320] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.349430] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.349471] pci 0000:00:01.0: PME# disabled
[    0.349563] pci 0000:00:1a.0: reg 20 io port: [0xe200-0xe21f]
[    0.349655] pci 0000:00:1a.1: reg 20 io port: [0xe000-0xe01f]
[    0.349747] pci 0000:00:1a.2: reg 20 io port: [0xe100-0xe11f]
[    0.349832] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf8205000-0xf82053ff]
[    0.349934] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf8200000-0xf8203fff]
[    0.350005] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.350046] pci 0000:00:1b.0: PME# disabled
[    0.350130] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.350171] pci 0000:00:1c.0: PME# disabled
[    0.350257] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.350298] pci 0000:00:1c.3: PME# disabled
[    0.350382] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.350424] pci 0000:00:1c.4: PME# disabled
[    0.350502] pci 0000:00:1d.0: reg 20 io port: [0xe300-0xe31f]
[    0.350594] pci 0000:00:1d.1: reg 20 io port: [0xe400-0xe41f]
[    0.350687] pci 0000:00:1d.2: reg 20 io port: [0xe500-0xe51f]
[    0.350771] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf8204000-0xf82043ff]
[    0.350976] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.351019] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.351061] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.351103] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.351145] pci 0000:00:1f.2: reg 20 io port: [0xf000-0xf00f]
[    0.351188] pci 0000:00:1f.2: reg 24 io port: [0xf100-0xf10f]
[    0.351261] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf8206000-0xf82060ff]
[    0.351310] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.351381] pci 0000:00:1f.5: reg 10 io port: [0xe700-0xe707]
[    0.351423] pci 0000:00:1f.5: reg 14 io port: [0xe800-0xe803]
[    0.351466] pci 0000:00:1f.5: reg 18 io port: [0xe900-0xe907]
[    0.351508] pci 0000:00:1f.5: reg 1c io port: [0xea00-0xea03]
[    0.351551] pci 0000:00:1f.5: reg 20 io port: [0xeb00-0xeb0f]
[    0.351603] pci 0000:00:1f.5: reg 24 io port: [0xec00-0xec0f]
[    0.351685] pci 0000:01:00.0: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
[    0.351731] pci 0000:01:00.0: reg 14 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.351778] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf4000000-0xf5ffffff]
[    0.351821] pci 0000:01:00.0: reg 24 io port: [0xc000-0xc07f]
[    0.351863] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.351949] pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
[    0.351989] pci 0000:00:01.0: bridge 32bit mmio: [0xf4000000-0xf7ffffff]
[    0.352005] pci 0000:00:01.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.352163] pci 0000:03:00.0: reg 24 32bit mmio: [0xf8000000-0xf8001fff]
[    0.352236] pci 0000:03:00.0: PME# supported from D3hot
[    0.352278] pci 0000:03:00.0: PME# disabled
[    0.352359] pci 0000:03:00.1: reg 10 io port: [0xd000-0xd007]
[    0.352405] pci 0000:03:00.1: reg 14 io port: [0xd100-0xd103]
[    0.352451] pci 0000:03:00.1: reg 18 io port: [0xd200-0xd207]
[    0.352496] pci 0000:03:00.1: reg 1c io port: [0xd300-0xd303]
[    0.352542] pci 0000:03:00.1: reg 20 io port: [0xd400-0xd40f]
[    0.352656] pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
[    0.352698] pci 0000:00:1c.3: bridge 32bit mmio: [0xf8000000-0xf80fffff]
[    0.352808] pci 0000:05:07.0: reg 10 32bit mmio: [0xf8104000-0xf81047ff]
[    0.352853] pci 0000:05:07.0: reg 14 32bit mmio: [0xf8100000-0xf8103fff]
[    0.352927] pci 0000:05:07.0: supports D1 D2
[    0.352966] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.353007] pci 0000:05:07.0: PME# disabled
[    0.353075] pci 0000:00:1e.0: transparent bridge
[    0.353116] pci 0000:00:1e.0: bridge 32bit mmio: [0xf8100000-0xf81fffff]
[    0.353173] pci_bus 0000:00: on NUMA node 0
[    0.353213] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.353348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.353427] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.353510] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.353587] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.365767] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 
15)
[    0.366229] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.366743] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 
15)
[    0.367203] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 
15)
[    0.367672] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.368201] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 
15)
[    0.368661] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 
15)
[    0.369121] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 
15)
[    0.369579] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.369629] vgaarb: loaded
[    0.369735] SCSI subsystem initialized
[    0.369785] libata version 3.00 loaded.
[    0.369785] usbcore: registered new interface driver usbfs
[    0.369785] usbcore: registered new interface driver hub
[    0.369785] usbcore: registered new device driver usb
[    0.369785] ACPI: WMI: Mapper loaded
[    0.369785] PCI: Using ACPI for IRQ routing
[    0.369785] Bluetooth: Core ver 2.15
[    0.369785] NET: Registered protocol family 31
[    0.369785] Bluetooth: HCI device and connection manager initialized
[    0.369785] Bluetooth: HCI socket layer initialized
[    0.369785] NET: Registered protocol family 8
[    0.369785] NET: Registered protocol family 20
[    0.369785] NetLabel: Initializing
[    0.369785] NetLabel:  domain hash size = 128
[    0.369785] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.369785] NetLabel:  unlabeled traffic allowed by default
[    0.369785] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.369785] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.376015] Switching to clocksource tsc
[    0.377240] pnp: PnP ACPI init
[    0.377294] ACPI: bus type pnp registered
[    0.379017] pnp: PnP ACPI: found 12 devices
[    0.379056] ACPI: ACPI bus type pnp unregistered
[    0.379102] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.379142] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.379183] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.379224] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.379265] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.379305] system 00:01: ioport range 0x4c0-0x4ff could not be reserved
[    0.379349] system 00:08: ioport range 0x400-0x4bf has been reserved
[    0.379392] system 00:09: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.379435] system 00:0a: iomem range 0xccc00-0xcffff has been reserved
[    0.379476] system 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
[    0.379517] system 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
[    0.379558] system 00:0a: iomem range 0xfc000-0xfffff could not be reserved
[    0.379600] system 00:0a: iomem range 0xdfee0000-0xdfefffff could not be 
reserved
[    0.379653] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[    0.379699] system 00:0a: iomem range 0x100000-0xdfedffff could not be 
reserved
[    0.379756] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[    0.379805] system 00:0a: iomem range 0xfed10000-0xfed1dfff has been 
reserved
[    0.379847] system 00:0a: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.379888] system 00:0a: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.379929] system 00:0a: iomem range 0xffb00000-0xffb7ffff has been reserved
[    0.379971] system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
[    0.380012] system 00:0a: iomem range 0xe0000-0xeffff has been reserved
[    0.384664] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.384705] pci 0000:00:01.0:   IO window: 0xc000-0xcfff
[    0.384745] pci 0000:00:01.0:   MEM window: 0xf4000000-0xf7ffffff
[    0.384786] pci 0000:00:01.0:   PREFETCH window: 
0x000000e0000000-0x000000efffffff
[    0.384836] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.384877] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    0.384918] pci 0000:00:1c.0:   MEM window: 0xf8300000-0xf84fffff
[    0.384960] pci 0000:00:1c.0:   PREFETCH window: 
0x000000f8500000-0x000000f86fffff
[    0.385012] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    0.385052] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    0.385093] pci 0000:00:1c.3:   MEM window: 0xf8000000-0xf80fffff
[    0.385135] pci 0000:00:1c.3:   PREFETCH window: 
0x000000f8700000-0x000000f88fffff
[    0.385186] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.385227] pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
[    0.385268] pci 0000:00:1c.4:   MEM window: 0xf8900000-0xf8afffff
[    0.385309] pci 0000:00:1c.4:   PREFETCH window: 
0x000000f8b00000-0x000000f8cfffff
[    0.385361] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.385401] pci 0000:00:1e.0:   IO window: disabled
[    0.385442] pci 0000:00:1e.0:   MEM window: 0xf8100000-0xf81fffff
[    0.385483] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.385529] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.385571] pci 0000:00:01.0: setting latency timer to 64
[    0.385615] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.385656] pci 0000:00:1c.0: setting latency timer to 64
[    0.385701] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.385743] pci 0000:00:1c.3: setting latency timer to 64
[    0.385786] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.385828] pci 0000:00:1c.4: setting latency timer to 64
[    0.385870] pci 0000:00:1e.0: setting latency timer to 64
[    0.385911] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.385951] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.385992] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.386032] pci_bus 0000:01: resource 1 mem: [0xf4000000-0xf7ffffff]
[    0.386072] pci_bus 0000:01: resource 2 pref mem [0xe0000000-0xefffffff]
[    0.386113] pci_bus 0000:02: resource 0 io:  [0x1000-0x1fff]
[    0.386152] pci_bus 0000:02: resource 1 mem: [0xf8300000-0xf84fffff]
[    0.386193] pci_bus 0000:02: resource 2 pref mem [0xf8500000-0xf86fffff]
[    0.386233] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.386273] pci_bus 0000:03: resource 1 mem: [0xf8000000-0xf80fffff]
[    0.386313] pci_bus 0000:03: resource 2 pref mem [0xf8700000-0xf88fffff]
[    0.386354] pci_bus 0000:04: resource 0 io:  [0x2000-0x2fff]
[    0.386394] pci_bus 0000:04: resource 1 mem: [0xf8900000-0xf8afffff]
[    0.386434] pci_bus 0000:04: resource 2 pref mem [0xf8b00000-0xf8cfffff]
[    0.386475] pci_bus 0000:05: resource 1 mem: [0xf8100000-0xf81fffff]
[    0.386515] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.386555] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.386618] NET: Registered protocol family 2
[    0.386715] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.387142] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[    0.388327] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.388826] TCP: Hash tables configured (established 262144 bind 65536)
[    0.388867] TCP reno registered
[    0.388972] NET: Registered protocol family 1
[    0.389159] pci 0000:01:00.0: Boot video device
[    0.389239] Trying to unpack rootfs image as initramfs...
[    1.528694] Freeing initrd memory: 70510k freed
[    1.562166] audit: initializing netlink socket (disabled)
[    1.562221] type=2000 audit(1263475858.561:1): initialized
[    1.569545] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.570627] VFS: Disk quotas dquot_6.5.2
[    1.570700] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.571149] fuse init (API version 7.13)
[    1.571238] msgmni has been set to 11937
[    1.571657] alg: No test for stdrng (krng)
[    1.571710] io scheduler noop registered
[    1.571753] io scheduler anticipatory registered
[    1.571792] io scheduler deadline registered
[    1.571837] io scheduler cfq registered (default)
[    1.572010] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.572052] pcieport 0000:00:01.0: setting latency timer to 64
[    1.572161] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    1.572205] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.572329] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    1.572372] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.572518] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    1.572562] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.572661] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.572768] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.572915] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.572966] ACPI: Power Button [PWRB]
[    1.573051] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.573100] ACPI: Power Button [PWRF]
[    1.573512] ACPI: SSDT 00000000dfee7ad0 0022A (v01  PmRef  Cpu0Ist 00003000 
INTL 20040311)
[    1.573789] Marking TSC unstable due to TSC halts in idle
[    1.573859] processor LNXCPU:00: registered as cooling_device0
[    1.574077] ACPI: SSDT 00000000dfee7f90 00152 (v01  PmRef  Cpu1Ist 00003000 
INTL 20040311)
[    1.574400] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU1._PDC] (Node ffff88019f815ee0), AE_ALREADY_EXISTS
[    1.574536] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.574702] Switching to clocksource hpet
[    1.574784] processor LNXCPU:01: registered as cooling_device1
[    1.575099] ACPI: SSDT 00000000dfee80f0 00152 (v01  PmRef  Cpu2Ist 00003000 
INTL 20040311)
[    1.575417] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU2._PDC] (Node ffff88019f815f60), AE_ALREADY_EXISTS
[    1.575552] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.575766] processor LNXCPU:02: registered as cooling_device2
[    1.575980] ACPI: SSDT 00000000dfee8250 00152 (v01  PmRef  Cpu3Ist 00003000 
INTL 20040311)
[    1.576317] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU3._PDC] (Node ffff88019f815fe0), AE_ALREADY_EXISTS
[    1.576451] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.576666] processor LNXCPU:03: registered as cooling_device3
[    1.578347] XENFS: not registering filesystem on non-xen platform
[    1.579157] Linux agpgart interface v0.103
[    1.579198] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.580058] brd: module loaded
[    1.580400] loop: module loaded
[    1.580483] input: Macintosh mouse button emulation as 
/devices/virtual/input/input2
[    1.580603] ahci 0000:03:00.0: version 3.0
[    1.580654] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.593534] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 
impl SATA mode
[    1.593586] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    1.593636] ahci 0000:03:00.0: setting latency timer to 64
[    1.593828] scsi0 : ahci
[    1.593955] scsi1 : ahci
[    1.594057] ata1: SATA max UDMA/133 abar m8192@0xf8000000 port 0xf8000100 
irq 19
[    1.594107] ata2: SATA max UDMA/133 abar m8192@0xf8000000 port 0xf8000180 
irq 19
[    1.594192] ata_piix 0000:00:1f.2: version 2.13
[    1.594248] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    1.594291] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.594490] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.594600] scsi2 : ata_piix
[    1.594708] scsi3 : ata_piix
[    1.595288] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    1.595331] ata4: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    1.595403] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    1.595467] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    1.595667] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.595761] scsi4 : ata_piix
[    1.595873] scsi5 : ata_piix
[    1.596284] ata5: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xeb00 irq 
19
[    1.596326] ata6: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 0xeb08 irq 
19
[    1.597270] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    1.597313] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> 
IRQ 16
[    1.597382] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    1.597479] scsi6 : pata_jmicron
[    1.597595] scsi7 : pata_jmicron
[    1.598112] ata7: PATA max UDMA/100 cmd 0xd000 ctl 0xd100 bmdma 0xd400 irq 
16
[    1.598153] ata8: PATA max UDMA/100 cmd 0xd200 ctl 0xd300 bmdma 0xd408 irq 
16
[    1.598429] Fixed MDIO Bus: probed
[    1.598469] PPP generic driver version 2.4.2
[    1.598561] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.598614] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    1.598661] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.598701] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.598765] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 1
[    1.602726] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.602774] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8205000
[    1.617510] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.617624] usb usb1: configuration #1 chosen from 1 choice
[    1.617682] hub 1-0:1.0: USB hub found
[    1.617723] hub 1-0:1.0: 6 ports detected
[    1.617802] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    1.617848] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.617889] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.617947] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 2
[    1.621892] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.621940] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8204000
[    1.636012] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.636106] usb usb2: configuration #1 chosen from 1 choice
[    1.636171] hub 2-0:1.0: USB hub found
[    1.636212] hub 2-0:1.0: 6 ports detected
[    1.636287] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.636337] uhci_hcd: USB Universal Host Controller Interface driver
[    1.636407] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    1.636450] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.636491] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.636553] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 3
[    1.636619] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e200
[    1.636707] usb usb3: configuration #1 chosen from 1 choice
[    1.636762] hub 3-0:1.0: USB hub found
[    1.636803] hub 3-0:1.0: 2 ports detected
[    1.636874] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    1.636918] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.636958] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.637016] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 4
[    1.637087] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e000
[    1.637175] usb usb4: configuration #1 chosen from 1 choice
[    1.637229] hub 4-0:1.0: USB hub found
[    1.637270] hub 4-0:1.0: 2 ports detected
[    1.637338] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    1.637381] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.637422] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.637479] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 5
[    1.637552] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e100
[    1.637644] usb usb5: configuration #1 chosen from 1 choice
[    1.637700] hub 5-0:1.0: USB hub found
[    1.637741] hub 5-0:1.0: 2 ports detected
[    1.637809] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    1.637853] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.637893] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.637950] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 6
[    1.638015] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    1.638102] usb usb6: configuration #1 chosen from 1 choice
[    1.638156] hub 6-0:1.0: USB hub found
[    1.638197] hub 6-0:1.0: 2 ports detected
[    1.638264] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    1.638307] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.638348] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.638407] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 7
[    1.638472] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    1.638559] usb usb7: configuration #1 chosen from 1 choice
[    1.638615] hub 7-0:1.0: USB hub found
[    1.638655] hub 7-0:1.0: 2 ports detected
[    1.638723] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    1.638767] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.638807] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.638863] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 8
[    1.638928] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    1.639016] usb usb8: configuration #1 chosen from 1 choice
[    1.639074] hub 8-0:1.0: USB hub found
[    1.639115] hub 8-0:1.0: 2 ports detected
[    1.639207] usbcore: registered new interface driver libusual
[    1.639276] PNP: No PS/2 controller found. Probing ports directly.
[    1.639654] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.639699] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.639807] mice: PS/2 mouse device common for all mice
[    1.639904] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    1.639968] rtc_cmos 00:04: RTC can wake from S4
[    1.640043] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.640101] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.640215] device-mapper: uevent: version 1.0.3
[    1.640340] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: 
dm-devel@redhat.com
[    1.640578] device-mapper: multipath: version 1.1.0 loaded
[    1.640643] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.641169] cpuidle: using governor ladder
[    1.641361] cpuidle: using governor menu
[    1.641632] TCP cubic registered
[    1.641747] NET: Registered protocol family 10
[    1.642088] lo: Disabled Privacy Extensions
[    1.642314] NET: Registered protocol family 17
[    1.642363] Bluetooth: L2CAP ver 2.14
[    1.642401] Bluetooth: L2CAP socket layer initialized
[    1.642441] Bluetooth: SCO (Voice Link) ver 0.6
[    1.642479] Bluetooth: SCO socket layer initialized
[    1.642553] Bluetooth: RFCOMM TTY layer initialized
[    1.642601] Bluetooth: RFCOMM socket layer initialized
[    1.642640] Bluetooth: RFCOMM ver 1.11
[    1.647910] PM: Resume from disk failed.
[    1.647959] registered taskstats version 1
[    1.648305]   Magic number: 10:874:533
[    1.648361] bdi 1:11: hash matches
[    1.648473] rtc_cmos 00:04: setting system clock to 2010-01-14 13:30:59 UTC 
(1263475859)
[    1.648547] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.648590] EDD information not available.
[    1.912048] ata1: SATA link down (SStatus 0 SControl 300)
[    1.912130] ata2: SATA link down (SStatus 0 SControl 300)
[    1.927603] ata5: SATA link down (SStatus 0 SControl 300)
[    1.938182] ata6: SATA link down (SStatus 0 SControl 300)
[    2.216039] usb 2-2: new high speed USB device using ehci_hcd and address 2
[    2.350715] usb 2-2: configuration #1 chosen from 1 choice
[    2.404092] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.404156] ata3.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.405575] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.405642] ata4.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.437841] ata4.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    2.437884] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.437945] ata4.01: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
[    2.445853] ata4.00: configured for UDMA/133
[    2.446267] ata3.00: HPA detected: current 1953523055, native 1953525168
[    2.446312] ata3.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    2.446368] ata3.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.446581] ata3.01: ATA-7: ST3300831AS, 3.02, max UDMA/133
[    2.446624] ata3.01: 586072368 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.460251] ata4.01: configured for UDMA/100
[    2.502283] ata3.00: configured for UDMA/133
[    2.516368] ata3.01: configured for UDMA/133
[    2.516525] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 
PQ: 0 ANSI: 5
[    2.516672] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    2.516710] sd 2:0:0:0: [sda] 1953523055 512-byte logical blocks: (1.00 
TB/931 GiB)
[    2.516740] sd 2:0:0:0: [sda] Write Protect is off
[    2.516742] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.516757] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.516852]  sda: sda1
[    2.530520] scsi 2:0:1:0: Direct-Access     ATA      ST3300831AS      3.02 
PQ: 0 ANSI: 5
[    2.530611] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    2.530614] sd 2:0:1:0: [sdb] 586072368 512-byte logical blocks: (300 
GB/279 GiB)
[    2.530648] sd 2:0:1:0: [sdb] Write Protect is off
[    2.530650] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    2.530665] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[    2.530667] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.530743] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    2.530932]  sda2 <
[    2.531375] sd 3:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    2.531986] scsi 3:0:1:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 
PQ: 0 ANSI: 5
[    2.534442] sd 3:0:0:0: [sdc] Write Protect is off
[    2.534489] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.535718] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 
cdda tray
[    2.536401] Uniform CD-ROM driver Revision: 3.20
[    2.536423] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.536522]  sdc:
[    2.536550] sr 3:0:1:0: Attached scsi CD-ROM sr0
[    2.536585] sr 3:0:1:0: Attached scsi generic sg3 type 5
[    2.543010]  sdb: sda5 sdb1
[    2.574475] sd 2:0:1:0: [sdb] Attached SCSI disk
[    2.574522]  sda6 sda7 sdc2 < sdc5 sda8 sda9 >
[    2.620082] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.622684]  sdc6 sdc7 > sdc3
[    2.664544] sd 3:0:0:0: [sdc] Attached SCSI disk
[    2.703445] Freeing unused kernel memory: 548k freed
[    2.703580] Write protecting the kernel read-only data: 7632k
[    2.756037] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    2.807702] Floppy drive(s): fd0 is 1.44M
[    2.826271] FDC 0 is a post-1991 82077
[    2.826442] ohci1394 0000:05:07.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    2.881641] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  
MMIO=[f8104000-f81047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.042804] usb 3-1: configuration #1 chosen from 1 choice
[    3.284044] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    3.453695] usb 5-1: configuration #1 chosen from 1 choice
[    3.518522] EXT3-fs: INFO: recovery required on readonly filesystem.
[    3.518565] EXT3-fs: write access will be enabled during recovery.
[    3.696538] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    3.864739] usb 5-2: configuration #1 chosen from 1 choice
[    4.104037] usb 8-1: new full speed USB device using uhci_hcd and address 2
[    4.152427] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007c2d6400001fd0]
[    4.278110] usb 8-1: configuration #1 chosen from 1 choice
[    4.280065] hub 8-1:1.0: USB hub found
[    4.282018] hub 8-1:1.0: 4 ports detected
[    4.528048] usb 8-2: new low speed USB device using uhci_hcd and address 3
[    4.703095] usb 8-2: configuration #1 chosen from 1 choice
[    4.709940] usbcore: registered new interface driver hiddev
[    4.728379] input: Logitech USB RECEIVER as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
[    4.728556] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.2-2/input0
[    4.728636] usbcore: registered new interface driver usbhid
[    4.728704] usbhid: v2.6:USB HID core driver
[    4.783020] usb 8-1.4: new low speed USB device using uhci_hcd and address 
4
[    4.923116] usb 8-1.4: configuration #1 chosen from 1 choice
[    4.950242] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.0/input/input4
[    4.950344] generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 
Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input0
[    4.978292] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.1/input/input5
[    4.978389] generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 
Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input1
[   13.504143] kjournald starting.  Commit interval 5 seconds
[   13.504170] EXT3-fs: sda8: orphan cleanup on readonly fs
[   13.504176] ext3_orphan_cleanup: deleting unreferenced inode 860297
[   13.504206] ext3_orphan_cleanup: deleting unreferenced inode 860290
[   13.533775] ext3_orphan_cleanup: deleting unreferenced inode 860268
[   13.533829] ext3_orphan_cleanup: deleting unreferenced inode 860258
[   13.540044] ext3_orphan_cleanup: deleting unreferenced inode 860254
[   13.540094] ext3_orphan_cleanup: deleting unreferenced inode 860252
[   13.542952] ext3_orphan_cleanup: deleting unreferenced inode 860203
[   13.549223] ext3_orphan_cleanup: deleting unreferenced inode 860179
[   13.560210] EXT3-fs: sda8: 8 orphan inodes deleted
[   13.560251] EXT3-fs: recovery complete.
[   13.581521] EXT3-fs: mounted filesystem with writeback data mode.
[   20.765269] udev: starting version 147
[   20.952447] lp: driver loaded but no devices found
[   22.063222] nvidia: module license 'NVIDIA' taints kernel.
[   22.063226] Disabling lock debugging due to kernel taint
[   22.337606] ip_tables: (C) 2000-2006 Netfilter Core Team
[   22.528018] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.528024] nvidia 0000:01:00.0: setting latency timer to 64
[   22.528277] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.36  Fri 
Aug 14 17:35:21 PDT 2009
[   22.579815] Linux video capture interface: v2.00
[   22.761716] pwc: Philips webcam module version 10.0.13 loaded.
[   22.761718] pwc: Supports Philips PCA645/646, PCVC675/680/690, 
PCVC720[40]/730/740/750 & PCVC830/840.
[   22.761719] pwc: Also supports the Askey VC010, various Logitech Quickcams, 
Samsung MPC-C10 and MPC-C30,
[   22.761721] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and 
Visionite VCS-UC300 and VCS-UM100.
[   22.761742] pwc: Logitech QuickCam 4000 Pro USB webcam detected.
[   22.762711] pwc: Registered as /dev/video0.
[   22.765769] input: PWC snapshot button as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/input/input6
[   22.765844] usbcore: registered new interface driver Philips webcam
[   22.861723] it87: Found IT8718F chip at 0x290, revision 5
[   22.861732] it87: in3 is VCC (+5V)
[   23.394182] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22
[   23.394376] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   23.591994] usbcore: registered new interface driver snd-usb-audio
[   23.946600] Intel AES-NI instructions are not detected.
[   24.085846] padlock: VIA PadLock not detected.
[   24.320389] padlock: VIA PadLock Hash Engine not detected.
[   24.393876] Adding 6562544k swap on /dev/mapper/cryptoswap.  Priority:-1 
extents:1 across:6562544k 
[   24.504721] EXT3 FS on sda8, internal journal
[   24.667044] kjournald starting.  Commit interval 5 seconds
[   24.667057] EXT3-fs: mounted filesystem with writeback data mode.
[   24.690847] kjournald starting.  Commit interval 5 seconds
[   24.691125] EXT3 FS on sda6, internal journal
[   24.691129] EXT3-fs: mounted filesystem with writeback data mode.
[   24.889948] kjournald starting.  Commit interval 5 seconds
[   24.890234] EXT3 FS on sdc5, internal journal
[   24.890239] EXT3-fs: mounted filesystem with writeback data mode.
[   24.919298] kjournald starting.  Commit interval 5 seconds
[   24.919563] EXT3 FS on sdc6, internal journal
[   24.919567] EXT3-fs: mounted filesystem with writeback data mode.
[   36.851649] kjournald starting.  Commit interval 5 seconds
[   36.851656] EXT3-fs warning: maximal mount count reached, running e2fsck is 
recommended
[   36.853411] EXT3 FS on dm-1, internal journal
[   36.853414] EXT3-fs: mounted filesystem with writeback data mode.
[   41.713695] CPUFREQ: Per core ondemand sysfs interface is deprecated - 
up_threshold
[  105.902182] kjournald starting.  Commit interval 5 seconds
[  105.902223] EXT3-fs warning: maximal mount count reached, running e2fsck is 
recommended
[  105.905178] EXT3 FS on dm-1, internal journal
[  105.905182] EXT3-fs: mounted filesystem with writeback data mode.
[  132.141209] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[  132.141212] vboxdrv: Successfully done.
[  132.141213] vboxdrv: Found 4 processor cores.
[  132.141525] VBoxDrv: dbg - g_abExecMemory=ffffffffa0cbb0e0
[  132.141611] vboxdrv: fAsync=0 offMin=0x39e offMax=0x7b51
[  132.141996] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 
'normal'.
[  132.141999] vboxdrv: Successfully loaded version 3.1.2 (interface 
0x00100001).
[  132.505707] ppdev: user-space parallel port driver
[  390.693702] PM: Syncing filesystems ... done.
[  390.821528] PM: Preparing system for mem sleep
[  390.821533] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  390.822220] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) 
done.
[  390.822254] PM: Entering mem sleep
[  390.822268] Suspending console(s) (use no_console_suspend to debug)
[  391.005552] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[  391.006010] sd 3:0:0:0: [sdc] Stopping disk
[  391.429533] sd 2:0:1:0: [sdb] Synchronizing SCSI cache
[  391.429681] sd 2:0:1:0: [sdb] Stopping disk
[  391.429822] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[  391.430025] sd 2:0:0:0: [sda] Stopping disk
[  391.968178] ACPI handle has no context!
[  391.968233] ACPI handle has no context!
[  391.984207] pata_jmicron 0000:03:00.1: PCI INT B disabled
[  392.032274] ahci 0000:03:00.0: PCI INT A disabled
[  392.099861] ata_piix 0000:00:1f.5: PCI INT B disabled
[  392.112201] ata_piix 0000:00:1f.2: PCI INT B disabled
[  392.128112] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  392.128118] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  392.128123] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  392.128129] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  392.232198] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  392.248109] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[  392.248115] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  392.248120] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  392.248126] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  392.248186] PM: suspend devices took 1.428 seconds
[  392.280646] ACPI: Preparing to enter system sleep state S3
[  392.284305] Disabling non-boot CPUs ...
[  392.286565] CPU 1 is now offline
[  392.286823] CPU0 attaching NULL sched-domain.
[  392.286825] CPU1 attaching NULL sched-domain.
[  392.286827] CPU2 attaching NULL sched-domain.
[  392.286829] CPU3 attaching NULL sched-domain.
[  392.320016] CPU0 attaching sched-domain:
[  392.320018]  domain 0: span 0,3 level MC
[  392.320019]   groups: 0 3
[  392.320022]   domain 1: span 0,2-3 level CPU
[  392.320023]    groups: 0,3 (cpu_power = 2048) 2
[  392.320026] CPU2 attaching sched-domain:
[  392.320028]  domain 0: span 0,2-3 level CPU
[  392.320029]   groups: 2 0,3 (cpu_power = 2048)
[  392.320032] CPU3 attaching sched-domain:
[  392.320033]  domain 0: span 0,3 level MC
[  392.320034]   groups: 3 0
[  392.320036]   domain 1: span 0,2-3 level CPU
[  392.320038]    groups: 0,3 (cpu_power = 2048) 2
[  392.320374] CPU1 is down
[  392.424006] CPU 2 is now offline
[  392.424160] CPU0 attaching NULL sched-domain.
[  392.424162] CPU2 attaching NULL sched-domain.
[  392.424163] CPU3 attaching NULL sched-domain.
[  392.456012] CPU0 attaching sched-domain:
[  392.456013]  domain 0: span 0,3 level MC
[  392.456014]   groups: 0 3
[  392.456017] CPU3 attaching sched-domain:
[  392.456018]  domain 0: span 0,3 level MC
[  392.456019]   groups: 3 0
[  392.456224] CPU2 is down
[  392.560012] CPU 3 is now offline
[  392.560015] SMP alternatives: switching to UP code
[  392.564674] CPU0 attaching NULL sched-domain.
[  392.564676] CPU3 attaching NULL sched-domain.
[  392.564680] CPU0 attaching NULL sched-domain.
[  392.564821] CPU3 is down
[  392.564827] Back to C!
[  392.564827] Enabling non-boot CPUs ...
[  392.564827] SMP alternatives: switching to SMP code
[  392.569509] Booting processor 1 APIC 0x3 ip 0x6000
[  392.286700] Initializing CPU#1
[  392.286700] Calibrating delay using timer specific routine.. 5666.01 
BogoMIPS (lpj=11332026)
[  392.286700] CPU: L1 I cache: 32K, L1 D cache: 32K
[  392.286700] CPU: L2 cache: 6144K
[  392.286700] CPU: Physical Processor ID: 0
[  392.286700] CPU: Processor Core ID: 3
[  392.660038] CPU1: Intel 06/17 stepping 0a
[  392.660098] CPU0 attaching NULL sched-domain.
[  392.672010] CPU0 attaching sched-domain:
[  392.672012]  domain 0: span 0-1 level CPU
[  392.672013]   groups: 0 1
[  392.672016] CPU1 attaching sched-domain:
[  392.672017]  domain 0: span 0-1 level CPU
[  392.672019]   groups: 1 0
[  392.672274] CPU1 is up
[  392.672469] Booting processor 2 APIC 0x2 ip 0x6000
[  392.424063] Initializing CPU#2
[  392.424063] Calibrating delay using timer specific routine.. 5666.00 
BogoMIPS (lpj=11332002)
[  392.424063] CPU: L1 I cache: 32K, L1 D cache: 32K
[  392.424063] CPU: L2 cache: 6144K
[  392.424063] CPU: Physical Processor ID: 0
[  392.424063] CPU: Processor Core ID: 2
[  392.760018] CPU2: Intel 06/17 stepping 0a
[  392.760107] CPU0 attaching NULL sched-domain.
[  392.760109] CPU1 attaching NULL sched-domain.
[  392.780011] CPU0 attaching sched-domain:
[  392.780012]  domain 0: span 0-2 level CPU
[  392.780014]   groups: 0 1-2 (cpu_power = 2048)
[  392.780017] CPU1 attaching sched-domain:
[  392.780018]  domain 0: span 1-2 level MC
[  392.780019]   groups: 1 2
[  392.780021]   domain 1: span 0-2 level CPU
[  392.780023]    groups: 1-2 (cpu_power = 2048) 0
[  392.780026] CPU2 attaching sched-domain:
[  392.780027]  domain 0: span 1-2 level MC
[  392.780028]   groups: 2 1
[  392.780030]   domain 1: span 0-2 level CPU
[  392.780031]    groups: 1-2 (cpu_power = 2048) 0
[  392.780359] CPU2 is up
[  392.780588] Booting processor 3 APIC 0x1 ip 0x6000
[  392.564563] Initializing CPU#3
[  392.564563] Calibrating delay using timer specific routine.. 5665.94 
BogoMIPS (lpj=11331884)
[  392.564563] CPU: L1 I cache: 32K, L1 D cache: 32K
[  392.564563] CPU: L2 cache: 6144K
[  392.564563] CPU: Physical Processor ID: 0
[  392.564563] CPU: Processor Core ID: 1
[  392.868037] CPU3: Intel 06/17 stepping 0a
[  392.868128] CPU0 attaching NULL sched-domain.
[  392.868130] CPU1 attaching NULL sched-domain.
[  392.868132] CPU2 attaching NULL sched-domain.
[  392.884012] CPU0 attaching sched-domain:
[  392.884014]  domain 0: span 0,3 level MC
[  392.884015]   groups: 0 3
[  392.884017]   domain 1: span 0-3 level CPU
[  392.884019]    groups: 0,3 (cpu_power = 2048) 1-2 (cpu_power = 2048)
[  392.884022] CPU1 attaching sched-domain:
[  392.884024]  domain 0: span 1-2 level MC
[  392.884025]   groups: 1 2
[  392.884027]   domain 1: span 0-3 level CPU
[  392.884028]    groups: 1-2 (cpu_power = 2048) 0,3 (cpu_power = 2048)
[  392.884031] CPU2 attaching sched-domain:
[  392.884033]  domain 0: span 1-2 level MC
[  392.884034]   groups: 2 1
[  392.884036]   domain 1: span 0-3 level CPU
[  392.884037]    groups: 1-2 (cpu_power = 2048) 0,3 (cpu_power = 2048)
[  392.884040] CPU3 attaching sched-domain:
[  392.884041]  domain 0: span 0,3 level MC
[  392.884043]   groups: 3 0
[  392.884045]   domain 1: span 0-3 level CPU
[  392.884046]    groups: 0,3 (cpu_power = 2048) 1-2 (cpu_power = 2048)
[  392.884508] CPU3 is up
[  392.886642] ACPI: Waking up from system sleep state S3
[  392.888073] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 
0x100, writing 0x105)
[  392.888084] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 
0x4, writing 0xf8200004)
[  392.888088] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 
0x0, writing 0x8)
[  392.888091] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 
0x100000, writing 0x100002)
[  392.888108] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 
0x100, writing 0x10a)
[  392.888115] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 
0x10001, writing 0xf861f851)
[  392.888118] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 
0x0, writing 0xf840f830)
[  392.888121] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 
0x20000000, writing 0x1010)
[  392.888126] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 
0x810000, writing 0x810008)
[  392.888129] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 
0x100000, writing 0x100407)
[  392.888154] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 
0x400, writing 0x40b)
[  392.888160] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 
0x10001, writing 0xf881f871)
[  392.888163] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 
0x0, writing 0xf800f800)
[  392.888166] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 
0x0, writing 0xd0d0)
[  392.888171] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 
0x810000, writing 0x810008)
[  392.888175] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 
0x100000, writing 0x100407)
[  392.888199] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 
0x100, writing 0x10a)
[  392.888205] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 
0x10001, writing 0xf8c1f8b1)
[  392.888208] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 
0x0, writing 0xf8a0f890)
[  392.888211] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 
0x2000f0f0, writing 0x2020)
[  392.888216] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 
0x810000, writing 0x810008)
[  392.888220] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 
0x100003, writing 0x100407)
[  392.888419] ata_piix 0000:00:1f.5: restoring config space at offset 0x1 (was 
0x2b00003, writing 0x2b00007)
[  392.888435] nvidia 0000:01:00.0: restoring config space at offset 0xf (was 
0x100, writing 0x10a)
[  392.888441] nvidia 0000:01:00.0: restoring config space at offset 0x9 (was 
0x1, writing 0xc001)
[  392.888444] nvidia 0000:01:00.0: restoring config space at offset 0x7 (was 
0x4, writing 0xf4000004)
[  392.888447] nvidia 0000:01:00.0: restoring config space at offset 0x5 (was 
0xc, writing 0xe000000c)
[  392.888450] nvidia 0000:01:00.0: restoring config space at offset 0x4 (was 
0x0, writing 0xf6000000)
[  392.888454] nvidia 0000:01:00.0: restoring config space at offset 0x1 (was 
0x100000, writing 0x100007)
[  392.888483] ahci 0000:03:00.0: restoring config space at offset 0xf (was 
0x100, writing 0x10b)
[  392.888497] ahci 0000:03:00.0: restoring config space at offset 0x8 (was 
0xd401, writing 0x0)
[  392.888502] ahci 0000:03:00.0: restoring config space at offset 0x7 (was 
0xd301, writing 0x0)
[  392.888506] ahci 0000:03:00.0: restoring config space at offset 0x6 (was 
0xd201, writing 0x0)
[  392.888511] ahci 0000:03:00.0: restoring config space at offset 0x5 (was 
0xd101, writing 0x0)
[  392.888515] ahci 0000:03:00.0: restoring config space at offset 0x4 (was 
0xd001, writing 0x0)
[  392.888520] ahci 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, 
writing 0x800008)
[  392.888524] ahci 0000:03:00.0: restoring config space at offset 0x2 (was 
0x1018502, writing 0x1060102)
[  392.888568] pata_jmicron 0000:03:00.1: restoring config space at offset 0x8 
(was 0x1, writing 0xd401)
[  392.888573] pata_jmicron 0000:03:00.1: restoring config space at offset 0x7 
(was 0x1, writing 0xd301)
[  392.888577] pata_jmicron 0000:03:00.1: restoring config space at offset 0x6 
(was 0x1, writing 0xd201)
[  392.888582] pata_jmicron 0000:03:00.1: restoring config space at offset 0x5 
(was 0x1, writing 0xd101)
[  392.888586] pata_jmicron 0000:03:00.1: restoring config space at offset 0x4 
(was 0x1, writing 0xd001)
[  392.888594] pata_jmicron 0000:03:00.1: restoring config space at offset 0x1 
(was 0x100000, writing 0x100005)
[  392.888611] ohci1394 0000:05:07.0: restoring config space at offset 0xf (was 
0x4020100, writing 0x4020107)
[  392.888624] ohci1394 0000:05:07.0: restoring config space at offset 0x5 (was 
0x0, writing 0xf8100000)
[  392.888627] ohci1394 0000:05:07.0: restoring config space at offset 0x4 (was 
0x0, writing 0xf8104000)
[  392.888631] ohci1394 0000:05:07.0: restoring config space at offset 0x3 (was 
0x0, writing 0x2008)
[  392.888635] ohci1394 0000:05:07.0: restoring config space at offset 0x1 (was 
0x2100000, writing 0x2100006)
[  392.888770] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[  392.888774] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  392.888792] usb usb3: root hub lost power or was reset
[  392.888822] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[  392.888825] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  392.888842] usb usb4: root hub lost power or was reset
[  392.888854] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[  392.888858] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[  392.888874] usb usb5: root hub lost power or was reset
[  392.888894] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[  392.888898] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  392.888904] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22
[  392.888908] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  392.984271] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[  392.984276] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  392.984296] usb usb6: root hub lost power or was reset
[  392.984316] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[  392.984319] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  392.984338] usb usb7: root hub lost power or was reset
[  392.984359] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[  392.984363] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  392.984382] usb usb8: root hub lost power or was reset
[  392.984412] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[  392.984421] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  392.984428] pci 0000:00:1e.0: setting latency timer to 64
[  392.984433] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[  392.984437] ata_piix 0000:00:1f.2: setting latency timer to 64
[  392.985757] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[  392.985760] ata_piix 0000:00:1f.5: setting latency timer to 64
[  393.434970] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  393.434976] ahci 0000:03:00.0: setting latency timer to 64
[  393.448157] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> 
IRQ 16
[  393.448168] pata_jmicron 0000:03:00.1: setting latency timer to 64
[  393.504121] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  
MMIO=[f8104000-f81047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[  393.550661] ata6: SATA link down (SStatus 4 SControl 300)
[  393.561259] ata5: SATA link down (SStatus 4 SControl 300)
[  393.768048] ata1: SATA link down (SStatus 0 SControl 300)
[  393.768075] ata2: SATA link down (SStatus 0 SControl 300)
[  394.028100] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  394.028125] ata4.01: SATA link down (SStatus 0 SControl 123)
[  394.028129] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  394.028142] ata3.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  394.036345] ata4.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered 
out
[  394.036356] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered 
out
[  394.036366] ata4.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered 
out
[  394.036374] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered 
out
[  394.036383] ata4.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered 
out
[  394.036391] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered 
out
[  394.044215] ata4.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered 
out
[  394.044217] ata4.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered 
out
[  394.044220] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered 
out
[  394.044348] ata4.00: n_sectors mismatch 976773168 != 976771055
[  394.044350] ata4.00: revalidation failed (errno=-19)
[  394.044353] ata4.00: limiting SATA link speed to 1.5 Gbps
[  394.044711] ata3.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered 
out
[  394.044713] ata3.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered 
out
[  394.044716] ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered 
out
[  394.130264] ata3.00: configured for UDMA/133
[  394.136855] ata3.01: configured for UDMA/133
[  396.576622] sd 2:0:0:0: [sda] Starting disk
[  396.590335] sd 2:0:1:0: [sdb] Starting disk
[  396.610677] sd 3:0:0:0: [sdc] Starting disk
[  399.824075] ata4.00: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  399.824087] ata4.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  399.856340] ata4.00: n_sectors mismatch 976773168 != 976771055
[  399.856342] ata4.00: revalidation failed (errno=-19)
[  399.856344] ata4.00: disabled
[  399.860026] sd 3:0:0:0: rejecting I/O to offline device
[  399.860033] sd 3:0:0:0: rejecting I/O to offline device
[  399.860058] sd 3:0:0:0: [sdc] START_STOP FAILED
[  399.860060] sd 3:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK
[  399.860065] PM: Device 3:0:0:0 failed to resume: error 65536
[  400.656594] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  400.656606] ata4.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  400.688844] ata4.00: HPA detected: current 976771055, native 976773168
[  400.688848] ata4.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[  400.688850] ata4.00: 976771055 sectors, multi 0: LBA48 NCQ (depth 0/32)
[  400.700336] ata4.00: configured for UDMA/133
[  400.712739] ata4.01: configured for UDMA/100
[  400.713798] sd 3:0:0:0: [sdc] 976771055 512-byte logical blocks: (500 
GB/465 GiB)
[  400.713877] sdc: detected capacity change from 500107862016 to 500106780160
[  400.714096] ata4.00: detaching (SCSI 3:0:0:0)
[  402.860034] 
[  402.860035] floppy driver state
[  402.860036] -------------------
[  402.860039] now=4294993011 last interrupt=4294898622 diff=94389 last called 
handler=ffffffffa00147f0
[  402.860040] timeout_message=lock fdc
[  402.860041] last output bytes:
[  402.860043]  8 80 4294893002
[  402.860044]  8 80 4294893002
[  402.860046]  8 80 4294893002
[  402.860047]  8 80 4294893002
[  402.860048] 12 80 4294898620
[  402.860049]  0 90 4294898620
[  402.860051] 13 90 4294898620
[  402.860052]  0 90 4294898620
[  402.860053] 1a 90 4294898620
[  402.860054]  0 90 4294898620
[  402.860055]  3 90 4294898620
[  402.860057] c1 90 4294898620
[  402.860058] 10 90 4294898620
[  402.860059]  7 90 4294898620
[  402.860060]  0 90 4294898620
[  402.860062]  8 81 4294898621
[  402.860063]  f 80 4294898621
[  402.860064]  0 90 4294898621
[  402.860065]  1 91 4294898621
[  402.860067]  8 81 4294898622
[  402.860068] last result at 4294898622
[  402.860069] last redo_fd_request at 4294898627
[  402.860070] 20  1 
[  402.860076] status=0
[  402.860077] fdc_busy=1
[  402.860078] do_floppy=ffffffffa0010740
[  402.860079] cont=ffffffffa0017900
[  402.860081] current_req=(null)
[  402.860082] command_status=-1
[  402.860083] 
[  402.860085] floppy0: floppy timeout called
[  402.972034] usb 3-1: reset full speed USB device using uhci_hcd and address 
2
[  403.611363] snd-usb-audio 3-1:1.1: no reset_resume for driver snd-usb-
audio?
[  403.611365] snd-usb-audio 3-1:1.2: no reset_resume for driver snd-usb-
audio?
[  403.868037] usb 5-1: reset low speed USB device using uhci_hcd and address 
2
[  404.280032] usb 5-2: reset full speed USB device using uhci_hcd and address 
3
[  404.540032] usb 8-1: reset full speed USB device using uhci_hcd and address 
2
[  405.164033] usb 8-2: reset low speed USB device using uhci_hcd and address 
3
[  405.471835] input input3: event field not found
[  405.471837] input input3: event field not found
[  405.471838] input input3: event field not found
[  405.471840] input input3: event field not found
[  405.471841] input input3: event field not found
[  405.471842] input input3: event field not found
[  405.471844] input input3: event field not found
[  405.733842] usb 8-1.4: reset low speed USB device using uhci_hcd and 
address 4
[  406.051468] pwc: Logitech QuickCam 4000 Pro USB webcam detected.
[  406.051506] pwc: Registered as /dev/video0.
[  406.054456] input: PWC snapshot button as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/input/input7
[  406.289780] PM: resume devices took 13.400 seconds
[  406.289781] ------------[ cut here ]------------
[  406.289786] WARNING: at kernel/power/suspend_test.c:53 
suspend_test_finish+0x83/0x90()
[  406.289788] Hardware name: EP45-UD3
[  406.289789] Component: resume devices, time: 13400
[  406.289790] Modules linked in: binfmt_misc ppdev vboxnetadp vboxnetflt 
vboxdrv sha256_generic cryptd aes_x86_64 aes_generic dm_crypt 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_usb_audio snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_usb_lib snd_hwdep snd_seq_oss 
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device 
it87 snd iptable_filter hwmon_vid pwc videodev soundcore coretemp psmouse 
ip_tables v4l1_compat snd_page_alloc nvidia(P) serio_raw x_tables 
v4l2_compat_ioctl32 lp parport usbhid ohci1394 ieee1394 floppy intel_agp
[  406.289812] Pid: 6339, comm: pm-suspend Tainted: P           2.6.32 #3
[  406.289813] Call Trace:
[  406.289817]  [<ffffffff810599e8>] warn_slowpath_common+0x78/0xb0
[  406.289819]  [<ffffffff81059a7c>] warn_slowpath_fmt+0x3c/0x40
[  406.289822]  [<ffffffff81092eb3>] suspend_test_finish+0x83/0x90
[  406.289824]  [<ffffffff81092ae1>] suspend_devices_and_enter+0xb1/0x220
[  406.289826]  [<ffffffff81092d7a>] enter_state+0x12a/0x150
[  406.289828]  [<ffffffff81092391>] state_store+0x91/0x100
[  406.289831]  [<ffffffff8126a957>] kobj_attr_store+0x17/0x20
[  406.289834]  [<ffffffff8117dc70>] sysfs_write_file+0xe0/0x160
[  406.289836]  [<ffffffff81118ce8>] vfs_write+0xb8/0x1a0
[  406.289838]  [<ffffffff81116c18>] ? filp_close+0x58/0x90
[  406.289840]  [<ffffffff8111978c>] sys_write+0x4c/0x80
[  406.289843]  [<ffffffff81011ec2>] system_call_fastpath+0x16/0x1b
[  406.289844] ---[ end trace 7a7c8001a337e95c ]---
[  406.290057] PM: Finishing wakeup.
[  406.290058] Restarting tasks ... done.
[  406.313243] Aborting journal on device sdc5.
[  406.313301] journal commit I/O error
[  406.318748] ext3_abort called.
[  406.318793] EXT3-fs error (device sdc5): ext3_journal_start_sb: Detected 
aborted journal
[  406.318907] Remounting filesystem read-only
[  406.377115] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[  406.377543] sd 3:0:0:0: [sdc] Stopping disk
[  406.410829] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#2100332 offset 0
[  406.413649] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#8716647 offset 0
[  406.413712] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#8716647 offset 0
[  406.790299] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[  406.790408] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  406.790502] sd 3:0:0:0: [sdd] 976771055 512-byte logical blocks: (500 
GB/465 GiB)
[  406.790535] sd 3:0:0:0: [sdd] Write Protect is off
[  406.790537] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[  406.790552] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[  406.790676]  sdd:
[  406.838755] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  406.846527] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1703951 offset 0
[  406.851860] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949711 offset 0
[  406.864289] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  407.221932] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  407.222095] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671411 offset 0
[  407.223168] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949711 offset 0
[  407.224119] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949711 offset 0
[  408.229724] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7996256 offset 0
[  408.230823] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671408 offset 0
[  408.480617] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  409.383987]  sdd2 < sdd5 sdd6 sdd7 > sdd3
[  409.461329] sd 3:0:0:0: [sdd] Attached SCSI disk
[  410.097822] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  410.097894] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671411 offset 0
[  410.098465] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671411 offset 0
[  410.098488] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  417.256286] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671408 offset 0
[  417.265994] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7996256 offset 0
[  417.266011] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7996256 offset 0
[  417.316199] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  417.338127] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671408 offset 0
[  417.371663] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671707 offset 0
[  417.453656] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.453676] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.457121] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.457168] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.458331] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.458369] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.459514] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.459552] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.460717] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.460755] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.462003] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.462042] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.463215] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.463253] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.464389] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.464427] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.465591] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.465635] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.466786] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.466825] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.468004] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.468040] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.469181] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.469219] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.470395] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671663 offset 0
[  417.470440] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#7949840 offset 0
[  417.471850] EXT3-fs error (device sdc5): ext3_find_entry: reading directory 
#1671411 offset 0


-----------------------------------------------------------------------------

This was before I began a disk-io-intenstive task (on / as /home was read-
only) which then froze the machine instantly.


Volker


-- 
Volker Lanz
http://www.volker-lanz.de
