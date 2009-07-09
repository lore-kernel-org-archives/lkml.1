Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZGIWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZGIWjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 18:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZGIWjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 18:39:08 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37653 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZGIWjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 18:39:03 -0400
Date: Thu, 9 Jul 2009 15:38:55 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Clock incorrect on 2.6.31-rc2
Message-ID: <20090709153855.6230729e@nehalam>
In-Reply-To: <1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
References: <20090709141000.584d199a@nehalam>
	<1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009 14:58:37 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Thu, Jul 9, 2009 at 2:10 PM, Stephen Hemminger<shemminger@vyatta.com> wrote:
> > My system (desktop Ubuntu 9.0) runs fine with 2.6.30, but with 2.6.31-rc2 it does
> > not keep time correctly. Also ntptime reports an error.
> 
> Can you better describe how it does not keep time? Is time moving too
> slow? too fast?

The clock just seemed to stop, or be wildly stuck in past.


> 
> Could you include output from the following commands with 2.6.31-rc2
> (and 2.6.30 if you have the time).
>  $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>  $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>  $ dmesg
>  $ ntpdc -c peers
>  $ ntpdc -c kerninfo

$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource 
tsc hpet acpi_pm 
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
tsc

# ntpdc -c peers
     remote           local      st poll reach  delay   offset    disp
=======================================================================
*ussprometheus.r 192.168.1.3      2  128  377 0.09094  0.007730 0.06786

# ntpdc -c kerninfo
pll offset:           0.005107 s
pll frequency:        155.028 ppm
maximum error:        0.219122 s
estimated error:      0.007209 s
status:               0001  pll
pll time constant:    7
precision:            1e-06 s
frequency tolerance:  500 ppm


$ dmesg
[    0.000000] Linux version 2.6.31-rc2 (shemminger@nehalam) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #149 SMP Tue Jul 7 18:22:50 PDT 2009
[    0.000000] Command line: root=/dev/sda1 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
[    0.000000]  BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e5000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  BIOS-e820: 00000000bf780000 - 00000000bf798000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] DMI 2.5 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x1c0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E3FFF write-protect
[    0.000000]   E4000-EBFFF write-through
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask E00000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf780 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf780000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf780000 page 4k
[    0.000000] kernel direct mapping tables up to bf780000 @ 10000-15000
[    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
[    0.000000]  0100000000 - 01c0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1c0000000 @ 13000-1b000
[    0.000000] RAMDISK: 36c2e000 - 37fefab2
[    0.000000] ACPI: RSDP 00000000000fb320 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bf780000 00044 (v01 121808 RSDT1124 20081218 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf780200 00084 (v01 121808 FACP1124 20081218 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7804b0 0B181 (v01  A1087 A1087001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bf798000 00040
[    0.000000] ACPI: APIC 00000000bf780390 000D8 (v01 121808 APIC1124 20081218 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf780470 0003C (v01 121808 OEMMCFG  20081218 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf798040 00072 (v01 121808 OEMB1124 20081218 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf78f4b0 00038 (v01 121808 OEMHPET  20081218 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf7980c0 00138 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf78f4f0 000B0 (v01 121808 OEMOSFR  20081218 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf79aa30 0249F (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001c0000000
[    0.000000] Bootmem setup node 0 0000000000000000-00000001c0000000
[    0.000000]   NODE_DATA [0000000000016000 - 0000000000019fff]
[    0.000000]   bootmap [000000000001a000 -  0000000000051fff] pages 38
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 01c0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001681e90]    TEXT DATA BSS ==> [0001000000 - 0001681e90]
[    0.000000]   #3 [0036c2e000 - 0037fefab2]          RAMDISK ==> [0036c2e000 - 0037fefab2]
[    0.000000]   #4 [000009b800 - 0000100000]    BIOS reserved ==> [000009b800 - 0000100000]
[    0.000000]   #5 [0001682000 - 0001682290]              BRK ==> [0001682000 - 0001682290]
[    0.000000]   #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]   #7 [0000013000 - 0000016000]          PGTABLE ==> [0000013000 - 0000016000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea0006ffffff] PMD -> [ffff880028600000-ffff88002e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000bf780
[    0.000000]     0: 0x00100000 -> 0x001c0000
[    0.000000] On node 0 totalpages: 1570571
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 109 pages reserved
[    0.000000]   DMA zone: 3806 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 763840 pages, LIFO batch:31
[    0.000000]   Normal zone: 12288 pages used for memmap
[    0.000000]   Normal zone: 774144 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e5000
[    0.000000] PM: Registered nosave memory: 00000000000e5000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf780000 - 00000000bf798000
[    0.000000] PM: Registered nosave memory: 00000000bf798000 - 00000000bf7dc000
[    0.000000] PM: Registered nosave memory: 00000000bf7dc000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages at ffff880028054000, static data 75872 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1541790
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 6089856k/7340032k available (3252k kernel code, 1057748k absent, 192428k reserved, 2135k data, 496k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] NR_IRQS:512
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2673.143 MHz processor.
[    0.003787] Console: colour VGA+ 80x25
[    0.003788] console [tty0] enabled
[    0.019748] hpet clockevent registered
[    0.019751] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.019889] Calibrating delay loop (skipped), value calculated using timer frequency.. 5346.28 BogoMIPS (lpj=2673143)
[    0.020165] Security Framework initialized
[    0.020296] SELinux:  Disabled at boot.
[    0.020835] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.022505] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.023266] Mount-cache hash table entries: 256
[    0.023496] CPU: Physical Processor ID: 0
[    0.023626] CPU: Processor Core ID: 0
[    0.023764] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.023921] CPU: L2 cache: 256K
[    0.024050] CPU: L3 cache: 8192K
[    0.024179] CPU 0/0x0 -> Node 0
[    0.024308] mce: CPU supports 9 MCE banks
[    0.024444] CPU0: Thermal monitoring enabled (TM1)
[    0.024577] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.024878] using mwait in idle threads.
[    0.025019] ACPI: Core revision 20090521
[    0.176199] Setting APIC routing to flat
[    0.176774] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.186909] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.288738] Booting processor 1 APIC 0x2 ip 0x6000
[    0.299129] Initializing CPU#1
[    0.359628] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337)
[    0.359633] CPU: Physical Processor ID: 0
[    0.359634] CPU: Processor Core ID: 1
[    0.359635] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.359637] CPU: L2 cache: 256K
[    0.359637] CPU: L3 cache: 8192K
[    0.359639] CPU 1/0x2 -> Node 0
[    0.359641] mce: CPU supports 9 MCE banks
[    0.359648] CPU1: Thermal monitoring enabled (TM1)
[    0.359651] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.360205] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.360686] CPU1: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.365442] Skipping synchronization checks as TSC is reliable.
[    0.365627] Booting processor 2 APIC 0x4 ip 0x6000
[    0.376116] Initializing CPU#2
[    0.436590] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672339)
[    0.436595] CPU: Physical Processor ID: 0
[    0.436596] CPU: Processor Core ID: 2
[    0.436598] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.436599] CPU: L2 cache: 256K
[    0.436600] CPU: L3 cache: 8192K
[    0.436601] CPU 2/0x4 -> Node 0
[    0.436603] mce: CPU supports 9 MCE banks
[    0.436611] CPU2: Thermal monitoring enabled (TM1)
[    0.436613] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.437168] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.437676] CPU2: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.439521] Skipping synchronization checks as TSC is reliable.
[    0.439708] Booting processor 3 APIC 0x6 ip 0x6000
[    0.450195] Initializing CPU#3
[    0.510554] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672336)
[    0.510559] CPU: Physical Processor ID: 0
[    0.510560] CPU: Processor Core ID: 3
[    0.510562] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.510563] CPU: L2 cache: 256K
[    0.510564] CPU: L3 cache: 8192K
[    0.510565] CPU 3/0x6 -> Node 0
[    0.510567] mce: CPU supports 9 MCE banks
[    0.510575] CPU3: Thermal monitoring enabled (TM1)
[    0.510577] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.511132] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.511661] CPU3: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.516579] Skipping synchronization checks as TSC is reliable.
[    0.516761] Booting processor 4 APIC 0x1 ip 0x6000
[    0.527249] Initializing CPU#4
[    0.587516] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672335)
[    0.587522] CPU: Physical Processor ID: 0
[    0.587523] CPU: Processor Core ID: 0
[    0.587525] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.587527] CPU: L2 cache: 256K
[    0.587528] CPU: L3 cache: 8192K
[    0.587530] CPU 4/0x1 -> Node 0
[    0.587532] mce: CPU supports 9 MCE banks
[    0.587540] CPU4: Thermal monitoring enabled (TM1)
[    0.587542] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.588201] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.588929] CPU4: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.590777] Skipping synchronization checks as TSC is reliable.
[    0.590964] Booting processor 5 APIC 0x3 ip 0x6000
[    0.601451] Initializing CPU#5
[    0.663480] Calibrating delay using timer specific routine.. 5558.45 BogoMIPS (lpj=2779229)
[    0.663486] CPU: Physical Processor ID: 0
[    0.663487] CPU: Processor Core ID: 1
[    0.663488] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.663490] CPU: L2 cache: 256K
[    0.663490] CPU: L3 cache: 8192K
[    0.663492] CPU 5/0x3 -> Node 0
[    0.663494] mce: CPU supports 9 MCE banks
[    0.663501] CPU5: Thermal monitoring enabled (TM1)
[    0.663504] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.664207] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    0.664919] CPU5: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.666764] Skipping synchronization checks as TSC is reliable.
[    0.666947] Booting processor 6 APIC 0x5 ip 0x6000
[    0.677434] Initializing CPU#6
[    0.737443] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337)
[    0.737448] CPU: Physical Processor ID: 0
[    0.737449] CPU: Processor Core ID: 2
[    0.737450] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.737451] CPU: L2 cache: 256K
[    0.737452] CPU: L3 cache: 8192K
[    0.737454] CPU 6/0x5 -> Node 0
[    0.737456] mce: CPU supports 9 MCE banks
[    0.737463] CPU6: Thermal monitoring enabled (TM1)
[    0.737465] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.738168] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    0.738895] CPU6: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.740740] Skipping synchronization checks as TSC is reliable.
[    0.740922] Booting processor 7 APIC 0x7 ip 0x6000
[    0.751410] Initializing CPU#7
[    0.811406] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337)
[    0.811412] CPU: Physical Processor ID: 0
[    0.811412] CPU: Processor Core ID: 3
[    0.811414] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.811415] CPU: L2 cache: 256K
[    0.811416] CPU: L3 cache: 8192K
[    0.811418] CPU 7/0x7 -> Node 0
[    0.811420] mce: CPU supports 9 MCE banks
[    0.811427] CPU7: Thermal monitoring enabled (TM1)
[    0.811429] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.812131] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    0.812872] CPU7: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.814717] Skipping synchronization checks as TSC is reliable.
[    0.814857] Brought up 8 CPUs
[    0.814986] Total of 8 processors activated (42972.78 BogoMIPS).
[    0.815561] NET: Registered protocol family 16
[    0.815926] ACPI: bus type pci registered
[    0.816146] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.816282] PCI: Not using MMCONFIG.
[    0.816413] PCI: Using configuration type 1 for base access
[    0.818061] bio: create slab <bio-0> at 0
[    0.818962] ACPI: EC: Look up EC in DSDT
[    0.854058] ACPI: Interpreter enabled
[    0.854190] ACPI: (supports S0 S1 S3 S4 S5)
[    0.854476] ACPI: Using IOAPIC for interrupt routing
[    0.854654] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.856873] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.863205] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.871465] ACPI Warning: Incorrect checksum in table [OEMB] - 7C, should be 74 20090521 tbutils-246
[    0.871895] ACPI: No dock devices found.
[    0.872151] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.872365] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.872503] pci 0000:00:00.0: PME# disabled
[    0.875629] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.875765] pci 0000:00:01.0: PME# disabled
[    0.875947] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.876081] pci 0000:00:03.0: PME# disabled
[    0.876269] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.876405] pci 0000:00:07.0: PME# disabled
[    0.876645] pci 0000:00:13.0: reg 10 32bit mmio: [0xfec8a000-0xfec8afff]
[    0.876673] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    0.876808] pci 0000:00:13.0: PME# disabled
[    0.877140] pci 0000:00:1a.0: reg 20 io port: [0x6800-0x681f]
[    0.877201] pci 0000:00:1a.1: reg 20 io port: [0x6880-0x689f]
[    0.877263] pci 0000:00:1a.2: reg 20 io port: [0x6c00-0x6c1f]
[    0.877331] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfadff000-0xfadff3ff]
[    0.877381] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.877518] pci 0000:00:1a.7: PME# disabled
[    0.877683] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfadf8000-0xfadfbfff]
[    0.877720] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.877856] pci 0000:00:1b.0: PME# disabled
[    0.878036] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.878171] pci 0000:00:1c.0: PME# disabled
[    0.878354] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.878490] pci 0000:00:1c.2: PME# disabled
[    0.878672] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.878808] pci 0000:00:1c.3: PME# disabled
[    0.878991] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.879126] pci 0000:00:1c.4: PME# disabled
[    0.879308] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.879444] pci 0000:00:1c.5: PME# disabled
[    0.879622] pci 0000:00:1d.0: reg 20 io port: [0x6080-0x609f]
[    0.879684] pci 0000:00:1d.1: reg 20 io port: [0x6400-0x641f]
[    0.879746] pci 0000:00:1d.2: reg 20 io port: [0x6480-0x649f]
[    0.879812] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfadfe000-0xfadfe3ff]
[    0.879862] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.879997] pci 0000:00:1d.7: PME# disabled
[    0.880235] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.880470] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.880607] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.880842] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
[    0.881120] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.881125] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.881130] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.881135] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.881140] pci 0000:00:1f.2: reg 20 io port: [0xff90-0xff9f]
[    0.881144] pci 0000:00:1f.2: reg 24 io port: [0xffa0-0xffaf]
[    0.881185] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfadfd000-0xfadfd0ff]
[    0.881197] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.881235] pci 0000:00:1f.5: reg 10 io port: [0x6000-0x6007]
[    0.881240] pci 0000:00:1f.5: reg 14 io port: [0x5c00-0x5c03]
[    0.881245] pci 0000:00:1f.5: reg 18 io port: [0x5880-0x5887]
[    0.881250] pci 0000:00:1f.5: reg 1c io port: [0x5800-0x5803]
[    0.881254] pci 0000:00:1f.5: reg 20 io port: [0x5480-0x548f]
[    0.881259] pci 0000:00:1f.5: reg 24 io port: [0x5400-0x540f]
[    0.881338] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.881475] pci 0000:01:00.0: PME# disabled
[    0.883457] pci 0000:00:01.0: bridge io port: [0x7000-0x8fff]
[    0.883464] pci 0000:00:01.0: bridge 32bit mmio: [0xfae00000-0xfb8fffff]
[    0.883522] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    0.883658] pci 0000:02:02.0: PME# disabled
[    0.883849] pci 0000:02:04.0: PME# supported from D0 D3hot D3cold
[    0.883985] pci 0000:02:04.0: PME# disabled
[    0.884156] pci 0000:01:00.0: bridge io port: [0x7000-0x8fff]
[    0.884160] pci 0000:01:00.0: bridge 32bit mmio: [0xfae00000-0xfb8fffff]
[    0.884211] pci 0000:03:00.0: reg 10 32bit mmio: [0xfb3a0000-0xfb3bffff]
[    0.884218] pci 0000:03:00.0: reg 14 32bit mmio: [0xfae00000-0xfaffffff]
[    0.884225] pci 0000:03:00.0: reg 18 io port: [0x7880-0x789f]
[    0.884232] pci 0000:03:00.0: reg 1c 32bit mmio: [0xfb3d8000-0xfb3dbfff]
[    0.884342] pci 0000:03:00.1: reg 10 32bit mmio: [0xfb3e0000-0xfb3fffff]
[    0.884349] pci 0000:03:00.1: reg 14 32bit mmio: [0xfb000000-0xfb1fffff]
[    0.884356] pci 0000:03:00.1: reg 18 io port: [0x7c00-0x7c1f]
[    0.884363] pci 0000:03:00.1: reg 1c 32bit mmio: [0xfb3dc000-0xfb3dffff]
[    0.886478] pci 0000:02:02.0: bridge io port: [0x7000-0x7fff]
[    0.886482] pci 0000:02:02.0: bridge 32bit mmio: [0xfae00000-0xfb3fffff]
[    0.886536] pci 0000:04:00.0: reg 10 32bit mmio: [0xfb8a0000-0xfb8bffff]
[    0.886543] pci 0000:04:00.0: reg 14 32bit mmio: [0xfb400000-0xfb5fffff]
[    0.886550] pci 0000:04:00.0: reg 18 io port: [0x8880-0x889f]
[    0.886557] pci 0000:04:00.0: reg 1c 32bit mmio: [0xfb8d8000-0xfb8dbfff]
[    0.886668] pci 0000:04:00.1: reg 10 32bit mmio: [0xfb8e0000-0xfb8fffff]
[    0.886675] pci 0000:04:00.1: reg 14 32bit mmio: [0xfb600000-0xfb7fffff]
[    0.886682] pci 0000:04:00.1: reg 18 io port: [0x8c00-0x8c1f]
[    0.886689] pci 0000:04:00.1: reg 1c 32bit mmio: [0xfb8dc000-0xfb8dffff]
[    0.888482] pci 0000:02:04.0: bridge io port: [0x8000-0x8fff]
[    0.888485] pci 0000:02:04.0: bridge 32bit mmio: [0xfb400000-0xfb8fffff]
[    0.888532] pci 0000:05:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.888539] pci 0000:05:00.0: reg 18 64bit mmio: [0xfb9e0000-0xfb9effff]
[    0.888544] pci 0000:05:00.0: reg 20 io port: [0x9000-0x90ff]
[    0.888551] pci 0000:05:00.0: reg 30 32bit mmio: [0xfb9c0000-0xfb9dffff]
[    0.888567] pci 0000:05:00.0: supports D1 D2
[    0.888594] pci 0000:05:00.1: reg 10 64bit mmio: [0xfb9f0000-0xfb9fffff]
[    0.888622] pci 0000:05:00.1: supports D1 D2
[    0.888638] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.888913] pci 0000:00:03.0: bridge io port: [0x9000-0x9fff]
[    0.888916] pci 0000:00:03.0: bridge 32bit mmio: [0xfb900000-0xfb9fffff]
[    0.888920] pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.888985] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf9f00000-0xf9ffffff]
[    0.889040] pci 0000:0a:00.0: reg 10 64bit mmio: [0xfbdfc000-0xfbdfffff]
[    0.889047] pci 0000:0a:00.0: reg 18 io port: [0xd800-0xd8ff]
[    0.889071] pci 0000:0a:00.0: reg 30 32bit mmio: [0xfbdc0000-0xfbddffff]
[    0.889109] pci 0000:0a:00.0: supports D1 D2
[    0.889110] pci 0000:0a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.889248] pci 0000:0a:00.0: PME# disabled
[    0.891496] pci 0000:00:1c.2: bridge io port: [0xd000-0xdfff]
[    0.891500] pci 0000:00:1c.2: bridge 32bit mmio: [0xfbd00000-0xfbdfffff]
[    0.891556] pci 0000:09:00.0: reg 18 io port: [0xcc00-0xcc7f]
[    0.891574] pci 0000:09:00.0: reg 20 64bit mmio: [0xfbcff000-0xfbcfffff]
[    0.891582] pci 0000:09:00.0: reg 30 32bit mmio: [0xfbc80000-0xfbcbffff]
[    0.891613] pci 0000:09:00.0: supports D1
[    0.891614] pci 0000:09:00.0: PME# supported from D0 D1 D3hot
[    0.891750] pci 0000:09:00.0: PME# disabled
[    0.891905] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.892198] pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
[    0.892201] pci 0000:00:1c.3: bridge 32bit mmio: [0xfbc00000-0xfbcfffff]
[    0.892246] pci 0000:08:00.0: reg 10 io port: [0xbc00-0xbc07]
[    0.892253] pci 0000:08:00.0: reg 14 io port: [0xb880-0xb883]
[    0.892260] pci 0000:08:00.0: reg 18 io port: [0xb800-0xb807]
[    0.892267] pci 0000:08:00.0: reg 1c io port: [0xb480-0xb483]
[    0.892274] pci 0000:08:00.0: reg 20 io port: [0xb400-0xb40f]
[    0.892281] pci 0000:08:00.0: reg 24 32bit mmio: [0xfbbffc00-0xfbbfffff]
[    0.892319] pci 0000:08:00.0: supports D1
[    0.892320] pci 0000:08:00.0: PME# supported from D0 D1 D3hot
[    0.892457] pci 0000:08:00.0: PME# disabled
[    0.892612] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.892905] pci 0000:00:1c.4: bridge io port: [0xb000-0xbfff]
[    0.892909] pci 0000:00:1c.4: bridge 32bit mmio: [0xfbb00000-0xfbbfffff]
[    0.892966] pci 0000:07:00.0: reg 10 64bit mmio: [0xfbafc000-0xfbafffff]
[    0.892974] pci 0000:07:00.0: reg 18 io port: [0xa800-0xa8ff]
[    0.892998] pci 0000:07:00.0: reg 30 32bit mmio: [0xfbac0000-0xfbadffff]
[    0.893035] pci 0000:07:00.0: supports D1 D2
[    0.893036] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.893173] pci 0000:07:00.0: PME# disabled
[    0.894497] pci 0000:00:1c.5: bridge io port: [0xa000-0xafff]
[    0.894501] pci 0000:00:1c.5: bridge 32bit mmio: [0xfba00000-0xfbafffff]
[    0.894538] pci 0000:0c:02.0: reg 10 32bit mmio: [0xfbeff000-0xfbeff7ff]
[    0.894544] pci 0000:0c:02.0: reg 14 io port: [0xec00-0xec7f]
[    0.894584] pci 0000:0c:02.0: supports D2
[    0.894585] pci 0000:0c:02.0: PME# supported from D2 D3hot D3cold
[    0.894721] pci 0000:0c:02.0: PME# disabled
[    0.894890] pci 0000:00:1e.0: transparent bridge
[    0.895023] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
[    0.895026] pci 0000:00:1e.0: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
[    0.895067] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.895367] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.895471] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.895525] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.895575] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.895624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.895674] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.895723] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.895773] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.895823] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.923077] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.923606] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.923916] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.924443] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.924969] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.925494] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.926017] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.926542] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.927160] SCSI subsystem initialized
[    0.927360] libata version 3.00 loaded.
[    0.927420] usbcore: registered new interface driver usbfs
[    0.927574] usbcore: registered new interface driver hub
[    0.927730] usbcore: registered new device driver usb
[    0.927972] PCI: Using ACPI for IRQ routing
[    0.932441] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.932711] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.939410] Switched to high resolution mode on CPU 0
[    0.939449] Switched to high resolution mode on CPU 1
[    0.939452] Switched to high resolution mode on CPU 3
[    0.939455] Switched to high resolution mode on CPU 2
[    0.939742] Switched to high resolution mode on CPU 4
[    0.939799] Switched to high resolution mode on CPU 7
[    0.939800] Switched to high resolution mode on CPU 6
[    0.939804] Switched to high resolution mode on CPU 5
[    0.942413] pnp: PnP ACPI init
[    0.942553] ACPI: bus type pnp registered
[    0.945432] pnp: PnP ACPI: found 15 devices
[    0.945563] ACPI: ACPI bus type pnp unregistered
[    0.945701] system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
[    0.945837] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
[    0.945973] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
[    0.946109] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
[    0.946248] system 00:07: ioport range 0x290-0x29f has been reserved
[    0.946384] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.946520] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.946655] system 00:08: ioport range 0x500-0x57f could not be reserved
[    0.946792] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.946928] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.947064] system 00:08: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.947202] system 00:0b: iomem range 0xffc00000-0xffdfffff has been reserved
[    0.950415] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.950552] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.950694] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.950833] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.950969] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.951105] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.951241] system 00:0e: iomem range 0x100000-0xbfffffff could not be reserved
[    0.951478] system 00:0e: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.956557] pci 0000:02:02.0: PCI bridge, secondary bus 0000:03
[    0.956693] pci 0000:02:02.0:   IO window: 0x7000-0x7fff
[    0.956829] pci 0000:02:02.0:   MEM window: 0xfae00000-0xfb3fffff
[    0.956965] pci 0000:02:02.0:   PREFETCH window: disabled
[    0.957099] pci 0000:02:04.0: PCI bridge, secondary bus 0000:04
[    0.957234] pci 0000:02:04.0:   IO window: 0x8000-0x8fff
[    0.957370] pci 0000:02:04.0:   MEM window: 0xfb400000-0xfb8fffff
[    0.957507] pci 0000:02:04.0:   PREFETCH window: disabled
[    0.957641] pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
[    0.957776] pci 0000:01:00.0:   IO window: 0x7000-0x8fff
[    0.957912] pci 0000:01:00.0:   MEM window: 0xfae00000-0xfb8fffff
[    0.958047] pci 0000:01:00.0:   PREFETCH window: disabled
[    0.958182] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.958316] pci 0000:00:01.0:   IO window: 0x7000-0x8fff
[    0.958451] pci 0000:00:01.0:   MEM window: 0xfae00000-0xfb8fffff
[    0.958586] pci 0000:00:01.0:   PREFETCH window: disabled
[    0.958721] pci 0000:00:03.0: PCI bridge, secondary bus 0000:05
[    0.958855] pci 0000:00:03.0:   IO window: 0x9000-0x9fff
[    0.958990] pci 0000:00:03.0:   MEM window: 0xfb900000-0xfb9fffff
[    0.959125] pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.959360] pci 0000:00:07.0: PCI bridge, secondary bus 0000:06
[    0.959494] pci 0000:00:07.0:   IO window: disabled
[    0.959627] pci 0000:00:07.0:   MEM window: disabled
[    0.959760] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.959894] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.960027] pci 0000:00:1c.0:   IO window: disabled
[    0.960161] pci 0000:00:1c.0:   MEM window: disabled
[    0.960294] pci 0000:00:1c.0:   PREFETCH window: 0x000000f9f00000-0x000000f9ffffff
[    0.960531] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:0a
[    0.960665] pci 0000:00:1c.2:   IO window: 0xd000-0xdfff
[    0.960800] pci 0000:00:1c.2:   MEM window: 0xfbd00000-0xfbdfffff
[    0.960935] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.961069] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:09
[    0.961203] pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
[    0.961338] pci 0000:00:1c.3:   MEM window: 0xfbc00000-0xfbcfffff
[    0.961474] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.961608] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:08
[    0.961743] pci 0000:00:1c.4:   IO window: 0xb000-0xbfff
[    0.961877] pci 0000:00:1c.4:   MEM window: 0xfbb00000-0xfbbfffff
[    0.962012] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.962146] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:07
[    0.962280] pci 0000:00:1c.5:   IO window: 0xa000-0xafff
[    0.962416] pci 0000:00:1c.5:   MEM window: 0xfba00000-0xfbafffff
[    0.962551] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.962686] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.962820] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
[    0.962954] pci 0000:00:1e.0:   MEM window: 0xfbe00000-0xfbefffff
[    0.963089] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.963228] pci 0000:00:01.0: setting latency timer to 64
[    0.963237] pci 0000:01:00.0: setting latency timer to 64
[    0.963245] pci 0000:02:02.0: setting latency timer to 64
[    0.963254] pci 0000:02:04.0: setting latency timer to 64
[    0.963260] pci 0000:00:03.0: setting latency timer to 64
[    0.963266] pci 0000:00:07.0: setting latency timer to 64
[    0.963274] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.963412] pci 0000:00:1c.0: setting latency timer to 64
[    0.963419] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.963556] pci 0000:00:1c.2: setting latency timer to 64
[    0.963563] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.963700] pci 0000:00:1c.3: setting latency timer to 64
[    0.963706] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.963843] pci 0000:00:1c.4: setting latency timer to 64
[    0.963850] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.963987] pci 0000:00:1c.5: setting latency timer to 64
[    0.963992] pci 0000:00:1e.0: setting latency timer to 64
[    0.963995] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.963997] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.963999] pci_bus 0000:01: resource 0 io:  [0x7000-0x8fff]
[    0.964000] pci_bus 0000:01: resource 1 mem: [0xfae00000-0xfb8fffff]
[    0.964002] pci_bus 0000:02: resource 0 io:  [0x7000-0x8fff]
[    0.964004] pci_bus 0000:02: resource 1 mem: [0xfae00000-0xfb8fffff]
[    0.964006] pci_bus 0000:03: resource 0 io:  [0x7000-0x7fff]
[    0.964007] pci_bus 0000:03: resource 1 mem: [0xfae00000-0xfb3fffff]
[    0.964009] pci_bus 0000:04: resource 0 io:  [0x8000-0x8fff]
[    0.964011] pci_bus 0000:04: resource 1 mem: [0xfb400000-0xfb8fffff]
[    0.964012] pci_bus 0000:05: resource 0 io:  [0x9000-0x9fff]
[    0.964014] pci_bus 0000:05: resource 1 mem: [0xfb900000-0xfb9fffff]
[    0.964016] pci_bus 0000:05: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.964018] pci_bus 0000:0b: resource 2 pref mem [0xf9f00000-0xf9ffffff]
[    0.964019] pci_bus 0000:0a: resource 0 io:  [0xd000-0xdfff]
[    0.964021] pci_bus 0000:0a: resource 1 mem: [0xfbd00000-0xfbdfffff]
[    0.964023] pci_bus 0000:09: resource 0 io:  [0xc000-0xcfff]
[    0.964024] pci_bus 0000:09: resource 1 mem: [0xfbc00000-0xfbcfffff]
[    0.964026] pci_bus 0000:08: resource 0 io:  [0xb000-0xbfff]
[    0.964028] pci_bus 0000:08: resource 1 mem: [0xfbb00000-0xfbbfffff]
[    0.964029] pci_bus 0000:07: resource 0 io:  [0xa000-0xafff]
[    0.964031] pci_bus 0000:07: resource 1 mem: [0xfba00000-0xfbafffff]
[    0.964033] pci_bus 0000:0c: resource 0 io:  [0xe000-0xefff]
[    0.964034] pci_bus 0000:0c: resource 1 mem: [0xfbe00000-0xfbefffff]
[    0.964036] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
[    0.964038] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.964059] NET: Registered protocol family 2
[    0.964347] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.965314] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.966822] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.967387] TCP: Hash tables configured (established 524288 bind 65536)
[    0.967525] TCP reno registered
[    0.967733] NET: Registered protocol family 1
[    0.967897] Trying to unpack rootfs image as initramfs...
[    1.371398] Freeing initrd memory: 20230k freed
[    1.375558] audit: initializing netlink socket (disabled)
[    1.375700] type=2000 audit(1247173664.089:1): initialized
[    1.382005] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.384290] msgmni has been set to 11933
[    1.387695] alg: No test for stdrng (krng)
[    1.387833] io scheduler noop registered
[    1.387963] io scheduler anticipatory registered
[    1.388094] io scheduler deadline registered
[    1.388273] io scheduler cfq registered (default)
[    1.388546] pci 0000:03:00.0: Disabling L0s
[    1.388678] pci 0000:03:00.1: Disabling L0s
[    1.388809] pci 0000:04:00.0: Disabling L0s
[    1.388941] pci 0000:04:00.1: Disabling L0s
[    1.389074] pci 0000:05:00.0: Boot video device
[    1.389221] pcieport-driver 0000:00:01.0: irq 48 for MSI/MSI-X
[    1.389228] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.389364] pcieport-driver 0000:00:03.0: irq 49 for MSI/MSI-X
[    1.389369] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    1.389501] pcieport-driver 0000:00:07.0: irq 50 for MSI/MSI-X
[    1.389506] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    1.389632] pcieport-driver 0000:00:1c.0: irq 51 for MSI/MSI-X
[    1.389638] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.389786] pcieport-driver 0000:00:1c.2: irq 52 for MSI/MSI-X
[    1.389792] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.389941] pcieport-driver 0000:00:1c.3: irq 53 for MSI/MSI-X
[    1.389948] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    1.390092] pcieport-driver 0000:00:1c.4: irq 54 for MSI/MSI-X
[    1.390099] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    1.390244] pcieport-driver 0000:00:1c.5: irq 55 for MSI/MSI-X
[    1.390251] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.390394] pcieport-driver 0000:01:00.0: setting latency timer to 64
[    1.390523] pcieport-driver 0000:02:02.0: irq 56 for MSI/MSI-X
[    1.390532] pcieport-driver 0000:02:02.0: setting latency timer to 64
[    1.390679] pcieport-driver 0000:02:04.0: irq 57 for MSI/MSI-X
[    1.390687] pcieport-driver 0000:02:04.0: setting latency timer to 64
[    1.390814] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.390820] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.390824] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.390829] aer 0000:02:02.0:pcie22: AER service couldn't init device: no _OSC support
[    1.390833] aer 0000:02:04.0:pcie22: AER service couldn't init device: no _OSC support
[    1.391067] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.391302] ACPI: Power Button [PWRF]
[    1.391492] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.391727] ACPI: Power Button [PWRB]
[    1.392350] ACPI: SSDT 00000000bf798200 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    1.393045] ACPI: SSDT 00000000bf79a280 003B2 (v01  PmRef  P001Cst 00003001 INTL 20060113)
[    1.393625] Monitor-Mwait will be used to enter C-1 state
[    1.393639] Monitor-Mwait will be used to enter C-2 state
[    1.393650] Monitor-Mwait will be used to enter C-3 state
[    1.393679] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.393946] processor LNXCPU:00: registered as cooling_device0
[    1.394504] ACPI: SSDT 00000000bf798610 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
[    1.395132] ACPI: SSDT 00000000bf79a640 00085 (v01  PmRef  P002Cst 00003000 INTL 20060113)
[    1.395784] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.396046] processor LNXCPU:01: registered as cooling_device1
[    1.396597] ACPI: SSDT 00000000bf798a20 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
[    1.397231] ACPI: SSDT 00000000bf79a6d0 00085 (v01  PmRef  P003Cst 00003000 INTL 20060113)
[    1.397884] ACPI: CPU2 (power states: C1[C1] C2[C2] C3[C3])
[    1.398146] processor LNXCPU:02: registered as cooling_device2
[    1.398706] ACPI: SSDT 00000000bf798e30 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
[    1.399343] ACPI: SSDT 00000000bf79a760 00085 (v01  PmRef  P004Cst 00003000 INTL 20060113)
[    1.399993] ACPI: CPU3 (power states: C1[C1] C2[C2] C3[C3])
[    1.400256] processor LNXCPU:03: registered as cooling_device3
[    1.400817] ACPI: SSDT 00000000bf799240 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
[    1.401458] ACPI: SSDT 00000000bf79a7f0 00085 (v01  PmRef  P005Cst 00003000 INTL 20060113)
[    1.402115] ACPI: CPU4 (power states: C1[C1] C2[C2] C3[C3])
[    1.402380] processor LNXCPU:04: registered as cooling_device4
[    1.402932] ACPI: SSDT 00000000bf799650 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
[    1.403575] ACPI: SSDT 00000000bf79a880 00085 (v01  PmRef  P006Cst 00003000 INTL 20060113)
[    1.404223] ACPI: CPU5 (power states: C1[C1] C2[C2] C3[C3])
[    1.404490] processor LNXCPU:05: registered as cooling_device5
[    1.405052] ACPI: SSDT 00000000bf799a60 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
[    1.405697] ACPI: SSDT 00000000bf79a910 00085 (v01  PmRef  P007Cst 00003000 INTL 20060113)
[    1.406345] ACPI: CPU6 (power states: C1[C1] C2[C2] C3[C3])
[    1.406609] processor LNXCPU:06: registered as cooling_device6
[    1.407167] ACPI: SSDT 00000000bf799e70 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
[    1.407807] ACPI: SSDT 00000000bf79a9a0 00085 (v01  PmRef  P008Cst 00003000 INTL 20060113)
[    1.408459] ACPI: CPU7 (power states: C1[C1] C2[C2] C3[C3])
[    1.408723] processor LNXCPU:07: registered as cooling_device7
[    1.429222] Linux agpgart interface v0.103
[    1.429379] [drm] Initialized drm 1.1.0 20060810
[    1.429511] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.429859] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[    1.431349] brd: module loaded
[    1.431646] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.431804] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.431954] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.431957] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.432134] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.436266] ehci_hcd 0000:00:1a.7: debug port 1
[    1.436402] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.436413] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfadff000
[    1.446319] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.446525] usb usb1: configuration #1 chosen from 1 choice
[    1.446691] hub 1-0:1.0: USB hub found
[    1.446823] hub 1-0:1.0: 6 ports detected
[    1.447011] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.447154] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.447156] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.447333] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.451459] ehci_hcd 0000:00:1d.7: debug port 1
[    1.451593] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.451603] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfadfe000
[    1.461316] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.461516] usb usb2: configuration #1 chosen from 1 choice
[    1.461680] hub 2-0:1.0: USB hub found
[    1.461812] hub 2-0:1.0: 6 ports detected
[    1.462000] uhci_hcd: USB Universal Host Controller Interface driver
[    1.462156] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.462295] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.462297] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.462472] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.462731] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00006800
[    1.462937] usb usb3: configuration #1 chosen from 1 choice
[    1.463100] hub 3-0:1.0: USB hub found
[    1.463232] hub 3-0:1.0: 2 ports detected
[    1.463412] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.466624] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.466627] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.466805] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.467062] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006880
[    1.467268] usb usb4: configuration #1 chosen from 1 choice
[    1.467438] hub 4-0:1.0: USB hub found
[    1.467570] hub 4-0:1.0: 2 ports detected
[    1.467747] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.467885] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.467888] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.468062] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.468323] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00006c00
[    1.468531] usb usb5: configuration #1 chosen from 1 choice
[    1.468697] hub 5-0:1.0: USB hub found
[    1.468829] hub 5-0:1.0: 2 ports detected
[    1.469004] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.469143] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.469145] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.469320] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.469571] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080
[    1.469777] usb usb6: configuration #1 chosen from 1 choice
[    1.469939] hub 6-0:1.0: USB hub found
[    1.470071] hub 6-0:1.0: 2 ports detected
[    1.470249] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.470391] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.470394] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.470568] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.470821] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006400
[    1.471026] usb usb7: configuration #1 chosen from 1 choice
[    1.471189] hub 7-0:1.0: USB hub found
[    1.471325] hub 7-0:1.0: 2 ports detected
[    1.471501] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.471641] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.471643] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.471819] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.472071] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006480
[    1.472276] usb usb8: configuration #1 chosen from 1 choice
[    1.472443] hub 8-0:1.0: USB hub found
[    1.472577] hub 8-0:1.0: 2 ports detected
[    1.472795] usbcore: registered new interface driver libusual
[    1.473004] PNP: No PS/2 controller found. Probing ports directly.
[    1.473146] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    1.475668] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.475806] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.476024] mice: PS/2 mouse device common for all mice
[    1.476735] cpuidle: using governor ladder
[    1.477932] cpuidle: using governor menu
[    1.478381] TCP cubic registered
[    1.478515] NET: Registered protocol family 17
[    1.478805] PM: Resume from disk failed.
[    1.478813] registered taskstats version 1
[    1.479091] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.479249] Initalizing network drop monitor service
[    1.479398] Freeing unused kernel memory: 496k freed
[    1.557242] fuse init (API version 7.12)
[    1.608772] Platform driver 'floppy' needs updating - please use dev_pm_ops
[    1.608953] Floppy drive(s): fd0 is 1.44M
[    1.613407] dca service started, version 1.8
[    1.616923] Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
[    1.617060] Copyright (c) 2007-2009 Intel Corporation.
[    1.617254] igb 0000:03:00.0: PCI INT A -> GSI 41 (level, low) -> IRQ 41
[    1.617417] igb 0000:03:00.0: setting latency timer to 64
[    1.617721] igb 0000:03:00.0: irq 58 for MSI/MSI-X
[    1.617725] igb 0000:03:00.0: irq 59 for MSI/MSI-X
[    1.617728] igb 0000:03:00.0: irq 60 for MSI/MSI-X
[    1.617732] igb 0000:03:00.0: irq 61 for MSI/MSI-X
[    1.617735] igb 0000:03:00.0: irq 62 for MSI/MSI-X
[    1.617739] igb 0000:03:00.0: irq 63 for MSI/MSI-X
[    1.617742] igb 0000:03:00.0: irq 64 for MSI/MSI-X
[    1.617745] igb 0000:03:00.0: irq 65 for MSI/MSI-X
[    1.617748] igb 0000:03:00.0: irq 66 for MSI/MSI-X
[    1.623661] sky2 driver version 1.23
[    1.623963] sky2 0000:0a:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.624113] sky2 0000:0a:00.0: setting latency timer to 64
[    1.624144] sky2 0000:0a:00.0: Yukon-2 EC Ultra chip revision 3
[    1.624264] FDC 0 is a post-1991 82077
[    1.624558] sky2 0000:0a:00.0: irq 67 for MSI/MSI-X
[    1.624842] sky2 eth0: addr 00:23:54:91:08:c2
[    1.625230] sky2 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.625380] sky2 0000:07:00.0: setting latency timer to 64
[    1.625398] sky2 0000:07:00.0: Yukon-2 EC Ultra chip revision 3
[    1.625616] sky2 0000:07:00.0: irq 68 for MSI/MSI-X
[    1.625861] sky2 eth1: addr 00:23:54:91:08:c1
[    1.629445] ahci 0000:08:00.0: version 3.0
[    1.634460] ata_piix 0000:00:1f.2: version 2.13
[    1.634482] ata_piix 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.634627] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.634946] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.635337] scsi0 : ata_piix
[    1.637937] scsi1 : ata_piix
[    1.639610] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff90 irq 14
[    1.639757] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff98 irq 15
[    1.641678] pata_marvell 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.641952] pata_marvell 0000:08:00.0: setting latency timer to 64
[    1.642358] scsi2 : pata_marvell
[    1.642527] ata_piix 0000:00:1f.5: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.642702] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    1.643005] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.643038] scsi3 : pata_marvell
[    1.643194] scsi4 : ata_piix
[    1.643374] ata3: PATA max UDMA/100 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 16
[    1.643515] ata4: PATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 16
[    1.643729] scsi5 : ata_piix
[    1.645296] ata5: SATA max UDMA/133 cmd 0x6000 ctl 0x5c00 bmdma 0x5480 irq 20
[    1.645442] ata6: SATA max UDMA/133 cmd 0x5880 ctl 0x5800 bmdma 0x5488 irq 20
[    1.749385] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    1.797714] ata3.00: ATAPI: SONY    DVD RW DW-U18A, UYS1, max UDMA/33
[    1.803309] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.803478] igb 0000:03:00.0: eth2: (PCIe:2.5Gb/s:Width x4) 00:1b:21:06:2a:d8
[    1.803698] igb 0000:03:00.0: eth2: PBA No: d96950-002
[    1.803835] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.803945] ata3.00: configured for UDMA/33
[    1.804353] igb 0000:03:00.1: PCI INT B -> GSI 47 (level, low) -> IRQ 47
[    1.804521] igb 0000:03:00.1: setting latency timer to 64
[    1.804852] igb 0000:03:00.1: irq 69 for MSI/MSI-X
[    1.804854] igb 0000:03:00.1: irq 70 for MSI/MSI-X
[    1.804856] igb 0000:03:00.1: irq 71 for MSI/MSI-X
[    1.804859] igb 0000:03:00.1: irq 72 for MSI/MSI-X
[    1.804861] igb 0000:03:00.1: irq 73 for MSI/MSI-X
[    1.804863] igb 0000:03:00.1: irq 74 for MSI/MSI-X
[    1.804865] igb 0000:03:00.1: irq 75 for MSI/MSI-X
[    1.804867] igb 0000:03:00.1: irq 76 for MSI/MSI-X
[    1.804870] igb 0000:03:00.1: irq 77 for MSI/MSI-X
[    1.863835] usb 1-5: configuration #1 chosen from 1 choice
[    1.864131] hub 1-5:1.0: USB hub found
[    1.864380] hub 1-5:1.0: 4 ports detected
[    1.961455] ata5: SATA link down (SStatus 0 SControl 300)
[    1.972791] ata6: SATA link down (SStatus 0 SControl 300)
[    1.972794] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.988335] igb 0000:03:00.1: Intel(R) Gigabit Ethernet Network Connection
[    1.988472] igb 0000:03:00.1: eth3: (PCIe:2.5Gb/s:Width x4) 00:1b:21:06:2a:d9
[    1.988688] igb 0000:03:00.1: eth3: PBA No: d96950-002
[    1.988820] igb 0000:03:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.989176] igb 0000:04:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    1.989393] igb 0000:04:00.0: setting latency timer to 64
[    1.989658] igb 0000:04:00.0: irq 78 for MSI/MSI-X
[    1.989660] igb 0000:04:00.0: irq 79 for MSI/MSI-X
[    1.989662] igb 0000:04:00.0: irq 80 for MSI/MSI-X
[    1.989665] igb 0000:04:00.0: irq 81 for MSI/MSI-X
[    1.989667] igb 0000:04:00.0: irq 82 for MSI/MSI-X
[    1.989669] igb 0000:04:00.0: irq 83 for MSI/MSI-X
[    1.989672] igb 0000:04:00.0: irq 84 for MSI/MSI-X
[    1.989674] igb 0000:04:00.0: irq 85 for MSI/MSI-X
[    1.989676] igb 0000:04:00.0: irq 86 for MSI/MSI-X
[    2.086658] usb 2-1: configuration #1 chosen from 1 choice
[    2.086950] hub 2-1:1.0: USB hub found
[    2.087225] hub 2-1:1.0: 4 ports detected
[    2.173321] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
[    2.173458] igb 0000:04:00.0: eth4: (PCIe:2.5Gb/s:Width x4) 00:1b:21:06:2a:dc
[    2.173674] igb 0000:04:00.0: eth4: PBA No: d96950-002
[    2.173806] igb 0000:04:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    2.174164] igb 0000:04:00.1: PCI INT B -> GSI 40 (level, low) -> IRQ 40
[    2.174330] igb 0000:04:00.1: setting latency timer to 64
[    2.174596] igb 0000:04:00.1: irq 87 for MSI/MSI-X
[    2.174599] igb 0000:04:00.1: irq 88 for MSI/MSI-X
[    2.174601] igb 0000:04:00.1: irq 89 for MSI/MSI-X
[    2.174603] igb 0000:04:00.1: irq 90 for MSI/MSI-X
[    2.174605] igb 0000:04:00.1: irq 91 for MSI/MSI-X
[    2.174607] igb 0000:04:00.1: irq 92 for MSI/MSI-X
[    2.174609] igb 0000:04:00.1: irq 93 for MSI/MSI-X
[    2.174611] igb 0000:04:00.1: irq 94 for MSI/MSI-X
[    2.174614] igb 0000:04:00.1: irq 95 for MSI/MSI-X
[    2.260135] ata2.00: SATA link down (SStatus 0 SControl 300)
[    2.260309] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.271273] ata1.00: SATA link down (SStatus 0 SControl 300)
[    2.271415] ata1.01: SATA link down (SStatus 0 SControl 301)
[    2.272631] scsi 2:0:0:0: CD-ROM            SONY     DVD RW DW-U18A   UYS1 PQ: 0 ANSI: 5
[    2.360369] usb 2-1.1: new low speed USB device using ehci_hcd and address 3
[    2.375217] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
[    2.375354] igb 0000:04:00.1: eth5: (PCIe:2.5Gb/s:Width x4) 00:1b:21:06:2a:dd
[    2.375584] igb 0000:04:00.1: eth5: PBA No: d96950-002
[    2.375716] igb 0000:04:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    2.440925] mvsas 0000:09:00.0: mvsas: driver version 0.8.2
[    2.441083] mvsas 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.441234] mvsas 0000:09:00.0: setting latency timer to 64
[    2.442150] mvsas 0000:09:00.0: mvsas: PCI-E x1, Bandwidth Usage: 2.5 Gbps
[    2.448073] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    2.448215] Uniform CD-ROM driver Revision: 3.20
[    2.448438] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.450907] sr 2:0:0:0: Attached scsi generic sg0 type 5
[    2.451781] usb 2-1.1: configuration #1 chosen from 1 choice
[    2.457408] usbcore: registered new interface driver hiddev
[    2.457651] usbcore: registered new interface driver usbhid
[    2.457794] usbhid: v2.6:USB HID core driver
[    2.463878] input: Belkin Corporation Flip CC as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.1/2-1.1:1.0/input/input2
[    2.464234] belkin 0003:050D:3201.0001: input,hiddev96,hidraw0: USB HID v1.10 Device [Belkin Corporation Flip CC] on usb-0000:00:1d.7-1.1/input0
[    2.526314] usb 2-1.3: new low speed USB device using ehci_hcd and address 4
[    2.617231] usb 2-1.3: configuration #1 chosen from 1 choice
[    2.619653] input: Kensington      USB/PS2 Wheel Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.3/2-1.3:1.0/input/input3
[    2.619940] generic-usb 0003:047D:1029.0002: input,hidraw1: USB HID v1.10 Mouse [Kensington      USB/PS2 Wheel Mouse] on usb-0000:00:1d.7-1.3/input0
[    2.693257] usb 2-1.4: new low speed USB device using ehci_hcd and address 5
[    2.785799] usb 2-1.4: configuration #1 chosen from 1 choice
[    2.803155] input: Key Tronic Keytronic USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.4/2-1.4:1.0/input/input4
[    2.803472] generic-usb 0003:03F9:0100.0003: input,hidraw2: USB HID v1.10 Keyboard [Key Tronic Keytronic USB Keyboard] on usb-0000:00:1d.7-1.4/input0
[    5.000766] scsi6 : mvsas
[    5.001228] drivers/scsi/mvsas/mv_sas.c 1250:set wide port phy map 1
[    5.012251] scsi 6:0:0:0: Direct-Access     FUJITSU  MBA3147RC        0103 PQ: 0 ANSI: 5
[    6.001744] sd 6:0:0:0: Attached scsi generic sg1 type 0
[    6.191196] sd 6:0:0:0: [sda] 287277984 512-byte logical blocks: (147 GB/136 GiB)
[    6.430591] sd 6:0:0:0: [sda] Write Protect is off
[    6.430787] sd 6:0:0:0: [sda] Mode Sense: bf 00 00 08
[    6.432080] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.437403]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    6.500196] sd 6:0:0:0: [sda] Attached SCSI disk
[   11.830746] kjournald starting.  Commit interval 5 seconds
[   11.830752] EXT3-fs: mounted filesystem with writeback data mode.
[   14.305882] udev: starting version 141
[   14.512407] IPv4 FIB: Using LC-trie version 0.408
[   14.516163] ACPI: WMI: Mapper loaded
[   14.596483] rtc_cmos 00:03: RTC can wake from S4
[   14.596677] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   14.596833] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   14.630668] Platform driver 'pcspkr' needs updating - please use dev_pm_ops
[   14.630844] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   15.109551] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   15.109899] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.500672] hda_codec: Unknown model for AD1988, trying auto-probe from BIOS...
[   15.611381] Adding 1060280k swap on /dev/sda2.  Priority:-1 extents:1 across:1060280k 
[   15.757706] EXT3 FS on sda1, internal journal
[   16.043147] EXT4-fs (sda3): barriers enabled
[   16.047231] kjournald2 starting: pid 4776, dev sda3:8, commit interval 5 seconds
[   16.047503] EXT4-fs (sda3): internal journal on sda3:8
[   16.047506] EXT4-fs (sda3): delayed allocation enabled
[   16.047508] EXT4-fs: file extents enabled
[   16.048108] EXT4-fs: mballoc enabled
[   16.048118] EXT4-fs (sda3): mounted filesystem with ordered data mode
[   16.564004] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x020b0001
[   17.245831] NET: Registered protocol family 10
[   17.246186] lo: Disabled Privacy Extensions
[   18.107505] Bridge firewalling registered
[   18.124812] virbr0: starting userspace STP failed, starting kernel STP
[   18.287453] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.451520] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   18.688530] virbr3: starting userspace STP failed, starting kernel STP
[   18.726066] virbr4: starting userspace STP failed, starting kernel STP
[   18.755625] virbr2: starting userspace STP failed, starting kernel STP
[   18.777510] virbr1: starting userspace STP failed, starting kernel STP
[   20.087783] pci 0000:05:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[   24.285950] sky2 eth1: enabling interface
[   24.286864] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   24.290566] sky2 eth0: enabling interface
[   24.291567] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.313003] ADDRCONF(NETDEV_UP): eth5: link is not ready
[   24.326627] ADDRCONF(NETDEV_UP): eth4: link is not ready
[   24.339791] ADDRCONF(NETDEV_UP): eth3: link is not ready
[   24.352864] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   26.754544] sky2 eth1: Link is up at 1000 Mbps, full duplex, flow control both
[   26.755496] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   28.367408] virbr0: no IPv6 routers present
[   29.010256] virbr1: no IPv6 routers present
[   29.137267] virbr2: no IPv6 routers present
[   29.301231] virbr4: no IPv6 routers present
[   29.506194] virbr3: no IPv6 routers present
[   37.333717] eth1: no IPv6 routers present
[ 2402.706067] tun: Universal TUN/TAP device driver, 1.6
[ 2402.706070] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[ 2402.707593] device vnet0 entered promiscuous mode
[ 2402.708585] virbr0: topology change detected, propagating
[ 2402.708589] virbr0: port 1(vnet0) entering forwarding state
[ 2413.346614] vnet0: no IPv6 routers present
[ 2586.373657] device vnet1 entered promiscuous mode
[ 2586.374762] virbr0: topology change detected, propagating
[ 2586.374767] virbr0: port 2(vnet1) entering forwarding state
[ 2597.311968] vnet1: no IPv6 routers present
[ 2661.394421] virbr0: port 2(vnet1) entering disabled state
[ 2661.398597] device vnet1 left promiscuous mode
[ 2661.398603] virbr0: port 2(vnet1) entering disabled state
[ 2685.630391] device vnet1 entered promiscuous mode
[ 2685.631429] virbr0: topology change detected, propagating
[ 2685.631434] virbr0: port 2(vnet1) entering forwarding state
[ 2696.432735] vnet1: no IPv6 routers present

