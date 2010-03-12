Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab0CLNLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:11:00 -0500
Received: from lucidpixels.com ([75.144.35.66]:51059 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab0CLNK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:10:56 -0500
Date: Fri, 12 Mar 2010 08:10:54 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
 reboots [full dmesg]
In-Reply-To: <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan> <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan> <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan> <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan>
 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Mar 2010, Justin Piszcz wrote:

>
>
> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>
>> 
>> 
>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>> 
>> Problem persists.
>> 
>> Others seem to have similar issues:
>> http://lkml.org/lkml/2010/1/9/157
>> 
>> Some boards not compatible it appears..
>> 
>> Justin.
>> 
>> 
>
> Even with all boards removed:
> [    0.133537] pci 0000:00:00.0: address space collision: [mem 
> 0xe0000000-0xffffffff 64bit] already in use
>
> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual slot 
> PCI-e_GFX and HT3 K8 part
>
>

Hi,

Here is a full dmesg with PCI debugging enabled:

Of interest:
[    0.133515] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xffffffff flags 0x120204] (d=0, p=0)
[    0.133518] pci 0000:00:00.0: address space collision: [mem 0xe0000000-0xffffffff 64bit] already in use
[    0.133522] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]

--

[    0.000000] Linux version 2.6.33 (root@server) (gcc version 4.3.3 (Debian 4.3.3-14) ) #9 SMP Fri Mar 12 08:05:50 EST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fde0000 (usable)
[    0.000000]  BIOS-e820: 000000003fde0000 - 000000003fee0000 (reserved)
[    0.000000]  BIOS-e820: 000000003fee0000 - 000000003fee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fee3000 - 000000003fef0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003ff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3fde0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFFC0000000 write-back
[    0.000000]   1 base 00003FF00000 mask FFFFFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000f60b0 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 3fee3000 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 3fee3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 3fee30c0 0737C (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 3fee0000 00040
[    0.000000] ACPI: SSDT 3feea500 0095E (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 3feeae80 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 3feeaec0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 3feeaf00 0039A (v01 GBT    GBT   B0 5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 3feea440 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 133MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0001000000 - 0001570468]    TEXT DATA BSS ==> [0001000000 - 0001570468]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [0001571000 - 0001577106]              BRK ==> [0001571000 - 0001577106]
[    0.000000]   #5 [0000002000 - 0000003000]       TRAMPOLINE ==> [0000002000 - 0000003000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003fde0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fde0
[    0.000000] On node 0 totalpages: 261503
[    0.000000] free_area_init_node: node 0, pgdat c14c6c00, node_mem_map c1579000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 268 pages used for memmap
[    0.000000]   HighMem zone: 34006 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 3ff00000 (gap: 3ff00000:a0100000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @c2000000 s26776 r0 d22376 u2097152
[    0.000000] pcpu-alloc: s26776 r0 d22376 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259459
[    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.33-9 ro root=842 max_loop=16
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003fde0)
[    0.000000] Memory: 1030752k/1046400k available (3627k kernel code, 14720k reserved, 1281k data, 352k init, 137096k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff91000 - 0xfffff000   ( 440 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc14cc000 - 0xc1524000   ( 352 kB)
[    0.000000]       .data : 0xc138ad03 - 0xc14cb404   (1281 kB)
[    0.000000]       .text : 0xc1000000 - 0xc138ad03   (3627 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2913.466 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5826.93 BogoMIPS (lpj=2913466)
[    0.002037] Mount-cache hash table entries: 512
[    0.002105] CPU: Physical Processor ID: 0
[    0.002107] CPU: Processor Core ID: 0
[    0.002110] mce: CPU supports 6 MCE banks
[    0.002117] using C1E aware idle routine
[    0.002122] Performance Events: AMD PMU driver.
[    0.002126] ... version:                0
[    0.002128] ... bit width:              48
[    0.002130] ... generic registers:      4
[    0.002132] ... value mask:             0000ffffffffffff
[    0.002135] ... max period:             00007fffffffffff
[    0.002137] ... fixed-purpose events:   0
[    0.002139] ... event mask:             000000000000000f
[    0.002143] Checking 'hlt' instruction... OK.
[    0.006214] Freeing SMP alternatives: 15k freed
[    0.006221] ACPI: Core revision 20091214
[    0.014041] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.015249] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025259] CPU0: AMD Athlon(tm) II X2 245 Processor stepping 02
[    0.025999] Booting Node   0, Processors  #1 Ok.
[    0.002999] Initializing CPU#1
[    0.097020] Brought up 2 CPUs
[    0.097023] Total of 2 processors activated (11653.68 BogoMIPS).
[    0.097480] NET: Registered protocol family 16
[    0.097649] ACPI: bus type pci registered
[    0.097716] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.097721] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.097724] PCI: Using MMCONFIG for extended config space
[    0.097726] PCI: Using configuration type 1 for base access
[    0.100005] bio: create slab <bio-0> at 0
[    0.100569] ACPI: EC: Look up EC in DSDT
[    0.107196] ACPI: Interpreter enabled
[    0.107201] ACPI: (supports S0 S5)
[    0.107212] ACPI: Using IOAPIC for interrupt routing
[    0.112078] ACPI: No dock devices found.
[    0.112158] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.112211] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.112346] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.112348] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.112351] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.112353] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.112355] pci_root PNP0A03:00: host bridge window [mem 0x40000000-0xfed0ffff] (ignored)
[    0.112356] pci_bus 0000:00: scanning bus
[    0.112365] pci 0000:00:00.0: found [1002:5956] class 000600 header type 00
[    0.112370] pci 0000:00:00.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.112379] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.112385] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x17d
[    0.112411] pci 0000:00:07.0: found [1002:597d] class 000604 header type 01
[    0.112413] pci 0000:00:07.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.112424] pci 0000:00:07.0: calling quirk_resource_alignment+0x0/0x17d
[    0.112433] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.112435] pci 0000:00:07.0: PME# disabled
[    0.112446] pci 0000:00:09.0: found [1002:597e] class 000604 header type 01
[    0.112448] pci 0000:00:09.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.112459] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x17d
[    0.112467] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.112469] pci 0000:00:09.0: PME# disabled
[    0.112479] pci 0000:00:0a.0: found [1002:597f] class 000604 header type 01
[    0.112482] pci 0000:00:0a.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.112492] pci 0000:00:0a.0: calling quirk_resource_alignment+0x0/0x17d
[    0.112501] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.112503] pci 0000:00:0a.0: PME# disabled
[    0.112525] pci 0000:00:11.0: found [1002:4390] class 000101 header type 00
[    0.112534] pci 0000:00:11.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.112542] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.112548] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.112554] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.112559] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.112565] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.112571] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.112581] pci 0000:00:11.0: calling quirk_amd_ide_mode+0x0/0xcd
[    0.112589] pci 0000:00:11.0: set SATA to AHCI mode
[    0.112592] pci 0000:00:11.0: calling quirk_resource_alignment+0x0/0x17d
[    0.112623] pci 0000:00:12.0: found [1002:4397] class 000c03 header type 00
[    0.112626] pci 0000:00:12.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.112635] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.112665] pci 0000:00:12.0: calling quirk_resource_alignment+0x0/0x17d
[    0.112676] pci 0000:00:12.1: found [1002:4398] class 000c03 header type 00
[    0.112679] pci 0000:00:12.1: calling quirk_no_ata_d3+0x0/0x1e
[    0.112688] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.112717] pci 0000:00:12.1: calling quirk_resource_alignment+0x0/0x17d
[    0.112736] pci 0000:00:12.2: found [1002:4396] class 000c03 header type 00
[    0.112745] pci 0000:00:12.2: calling quirk_no_ata_d3+0x0/0x1e
[    0.112753] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
[    0.112783] pci 0000:00:12.2: calling quirk_resource_alignment+0x0/0x17d
[    0.112802] pci 0000:00:12.2: supports D1 D2
[    0.112803] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.112807] pci 0000:00:12.2: PME# disabled
[    0.112825] pci 0000:00:13.0: found [1002:4397] class 000c03 header type 00
[    0.112829] pci 0000:00:13.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.112837] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.112867] pci 0000:00:13.0: calling quirk_resource_alignment+0x0/0x17d
[    0.112878] pci 0000:00:13.1: found [1002:4398] class 000c03 header type 00
[    0.112881] pci 0000:00:13.1: calling quirk_no_ata_d3+0x0/0x1e
[    0.112889] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.112919] pci 0000:00:13.1: calling quirk_resource_alignment+0x0/0x17d
[    0.112936] pci 0000:00:13.2: found [1002:4396] class 000c03 header type 00
[    0.112945] pci 0000:00:13.2: calling quirk_no_ata_d3+0x0/0x1e
[    0.112953] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.112983] pci 0000:00:13.2: calling quirk_resource_alignment+0x0/0x17d
[    0.113004] pci 0000:00:13.2: supports D1 D2
[    0.113005] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.113008] pci 0000:00:13.2: PME# disabled
[    0.113031] pci 0000:00:14.0: found [1002:4385] class 000c05 header type 00
[    0.113037] pci 0000:00:14.0: calling quirk_no_ata_d3+0x0/0x1e
[    0.113045] pci 0000:00:14.0: calling sb600_disable_hpet_bar+0x0/0x60
[    0.113080] pci 0000:00:14.0: calling force_disable_hpet_msi+0x0/0x10
[    0.113083] pci 0000:00:14.0: calling quirk_resource_alignment+0x0/0x17d
[    0.113110] pci 0000:00:14.1: found [1002:439c] class 000101 header type 00
[    0.113116] pci 0000:00:14.1: calling quirk_no_ata_d3+0x0/0x1e
[    0.113124] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.113130] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.113135] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.113141] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.113147] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.113160] pci 0000:00:14.1: calling quirk_resource_alignment+0x0/0x17d
[    0.113185] pci 0000:00:14.3: found [1002:439d] class 000601 header type 00
[    0.113189] pci 0000:00:14.3: calling quirk_no_ata_d3+0x0/0x1e
[    0.113225] pci 0000:00:14.3: calling quirk_resource_alignment+0x0/0x17d
[    0.113236] pci 0000:00:14.4: found [1002:4384] class 000604 header type 01
[    0.113239] pci 0000:00:14.4: calling quirk_no_ata_d3+0x0/0x1e
[    0.113256] pci 0000:00:14.4: calling quirk_resource_alignment+0x0/0x17d
[    0.113268] pci 0000:00:14.5: found [1002:4399] class 000c03 header type 00
[    0.113271] pci 0000:00:14.5: calling quirk_no_ata_d3+0x0/0x1e
[    0.113279] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
[    0.113309] pci 0000:00:14.5: calling quirk_resource_alignment+0x0/0x17d
[    0.113323] pci 0000:00:18.0: found [1022:1200] class 000600 header type 00
[    0.113331] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x17d
[    0.113336] pci 0000:00:18.1: found [1022:1201] class 000600 header type 00
[    0.113344] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x17d
[    0.113348] pci 0000:00:18.2: found [1022:1202] class 000600 header type 00
[    0.113355] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x17d
[    0.113360] pci 0000:00:18.3: found [1022:1203] class 000600 header type 00
[    0.113368] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x17d
[    0.113374] pci 0000:00:18.4: found [1022:1204] class 000600 header type 00
[    0.113381] pci 0000:00:18.4: calling quirk_resource_alignment+0x0/0x17d
[    0.113392] pci_bus 0000:00: fixups for bus
[    0.113394] pci 0000:00:07.0: scanning behind bridge, config 010100, pass 0
[    0.113397] pci_bus 0000:01: scanning bus
[    0.113410] pci 0000:01:00.0: found [10ec:8168] class 000200 header type 00
[    0.113419] pci 0000:01:00.0: reg 10: [io  0xee00-0xeeff]
[    0.113432] pci 0000:01:00.0: reg 18: [mem 0xfd8ff000-0xfd8fffff 64bit pref]
[    0.113442] pci 0000:01:00.0: reg 20: [mem 0xfd8f8000-0xfd8fbfff 64bit pref]
[    0.113448] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.113452] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x17d
[    0.113476] pci 0000:01:00.0: supports D1 D2
[    0.113478] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113481] pci 0000:01:00.0: PME# disabled
[    0.113530] pci_bus 0000:01: fixups for bus
[    0.113531] pci 0000:00:07.0: PCI bridge to [bus 01-01]
[    0.113535] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.113538] pci 0000:00:07.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.113541] pci 0000:00:07.0:   bridge window [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.113543] pci_bus 0000:01: bus scan returning with max=01
[    0.113545] pci 0000:00:09.0: scanning behind bridge, config 020200, pass 0
[    0.113548] pci_bus 0000:02: scanning bus
[    0.113561] pci 0000:02:00.0: found [10ec:8168] class 000200 header type 00
[    0.113569] pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
[    0.113583] pci 0000:02:00.0: reg 18: [mem 0xfdeff000-0xfdefffff 64bit pref]
[    0.113592] pci 0000:02:00.0: reg 20: [mem 0xfdef8000-0xfdefbfff 64bit pref]
[    0.113598] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.113603] pci 0000:02:00.0: calling quirk_resource_alignment+0x0/0x17d
[    0.113626] pci 0000:02:00.0: supports D1 D2
[    0.113628] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113631] pci 0000:02:00.0: PME# disabled
[    0.113679] pci_bus 0000:02: fixups for bus
[    0.113680] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    0.113684] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.113686] pci 0000:00:09.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.113690] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.113691] pci_bus 0000:02: bus scan returning with max=02
[    0.113693] pci 0000:00:0a.0: scanning behind bridge, config 030300, pass 0
[    0.113697] pci_bus 0000:03: scanning bus
[    0.113710] pci 0000:03:00.0: found [197b:2363] class 000101 header type 00
[    0.113714] pci 0000:03:00.0: calling quirk_jmicron_ata+0x0/0x160
[    0.113755] pci 0000:03:00.0: reg 24: [mem 0xfddfe000-0xfddfffff]
[    0.113765] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x17d
[    0.113785] pci 0000:03:00.0: PME# supported from D3hot
[    0.113789] pci 0000:03:00.0: PME# disabled
[    0.113808] pci 0000:03:00.1: found [197b:2363] class 000101 header type 00
[    0.113815] pci 0000:03:00.1: calling quirk_jmicron_ata+0x0/0x160
[    0.113824] pci 0000:03:00.1: reg 10: [io  0xcf00-0xcf07]
[    0.113830] pci 0000:03:00.1: reg 14: [io  0xce00-0xce03]
[    0.113836] pci 0000:03:00.1: reg 18: [io  0xcd00-0xcd07]
[    0.113843] pci 0000:03:00.1: reg 1c: [io  0xcc00-0xcc03]
[    0.113849] pci 0000:03:00.1: reg 20: [io  0xcb00-0xcb0f]
[    0.113865] pci 0000:03:00.1: calling quirk_resource_alignment+0x0/0x17d
[    0.113927] pci_bus 0000:03: fixups for bus
[    0.113928] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.113932] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
[    0.113934] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.113937] pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.113939] pci_bus 0000:03: bus scan returning with max=03
[    0.113942] pci 0000:00:14.4: scanning behind bridge, config 040400, pass 0
[    0.113946] pci_bus 0000:04: scanning bus
[    0.113993] pci_bus 0000:04: fixups for bus
[    0.113994] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.114014] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.114017] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff]
[    0.114021] pci 0000:00:14.4:   bridge window [mem 0xfd900000-0xfd9fffff pref]
[    0.114023] pci_bus 0000:04: bus scan returning with max=04
[    0.114026] pci 0000:00:07.0: scanning behind bridge, config 010100, pass 1
[    0.114029] pci 0000:00:09.0: scanning behind bridge, config 020200, pass 1
[    0.114032] pci 0000:00:0a.0: scanning behind bridge, config 030300, pass 1
[    0.114036] pci 0000:00:14.4: scanning behind bridge, config 040400, pass 1
[    0.114040] pci_bus 0000:00: bus scan returning with max=04
[    0.114043] pci_bus 0000:00: on NUMA node 0
[    0.114046] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.114240] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.114309] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.114348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.114383] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.132460] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.132529] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.132597] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.132663] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.132730] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.132797] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.132863] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.132930] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.133075] vgaarb: loaded
[    0.133187] SCSI subsystem initialized
[    0.133225] libata version 3.00 loaded.
[    0.133338] usbcore: registered new interface driver usbfs
[    0.133367] usbcore: registered new interface driver hub
[    0.133399] usbcore: registered new device driver usb
[    0.133507] PCI: Using ACPI for IRQ routing
[    0.133510] PCI: pci_cache_line_size set to 64 bytes
[    0.133515] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xffffffff flags 0x120204] (d=0, p=0)
[    0.133518] pci 0000:00:00.0: address space collision: [mem 0xe0000000-0xffffffff 64bit] already in use
[    0.133522] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]
[    0.133529] pci 0000:00:11.0: BAR 0: reserving [io  0xff00-0xff07 flags 0x20101] (d=0, p=0)
[    0.133531] pci 0000:00:11.0: BAR 1: reserving [io  0xfe00-0xfe03 flags 0x20101] (d=0, p=0)
[    0.133534] pci 0000:00:11.0: BAR 2: reserving [io  0xfd00-0xfd07 flags 0x20101] (d=0, p=0)
[    0.133536] pci 0000:00:11.0: BAR 3: reserving [io  0xfc00-0xfc03 flags 0x20101] (d=0, p=0)
[    0.133538] pci 0000:00:11.0: BAR 4: reserving [io  0xfb00-0xfb0f flags 0x20101] (d=0, p=0)
[    0.133540] pci 0000:00:11.0: BAR 5: reserving [mem 0xfe02f000-0xfe02f3ff flags 0x20200] (d=0, p=0)
[    0.133544] pci 0000:00:12.0: BAR 0: reserving [mem 0xfe02e000-0xfe02efff flags 0x20200] (d=0, p=0)
[    0.133548] pci 0000:00:12.1: BAR 0: reserving [mem 0xfe02d000-0xfe02dfff flags 0x20200] (d=0, p=0)
[    0.133552] pci 0000:00:12.2: BAR 0: reserving [mem 0xfe02c000-0xfe02c0ff flags 0x20200] (d=0, p=0)
[    0.133556] pci 0000:00:13.0: BAR 0: reserving [mem 0xfe02b000-0xfe02bfff flags 0x20200] (d=0, p=0)
[    0.133559] pci 0000:00:13.1: BAR 0: reserving [mem 0xfe02a000-0xfe02afff flags 0x20200] (d=0, p=0)
[    0.133563] pci 0000:00:13.2: BAR 0: reserving [mem 0xfe029000-0xfe0290ff flags 0x20200] (d=0, p=0)
[    0.133568] pci 0000:00:14.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.133570] pci 0000:00:14.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.133572] pci 0000:00:14.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.133574] pci 0000:00:14.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.133577] pci 0000:00:14.1: BAR 4: reserving [io  0xfa00-0xfa0f flags 0x20101] (d=0, p=0)
[    0.133583] pci 0000:00:14.5: BAR 0: reserving [mem 0xfe028000-0xfe028fff flags 0x20200] (d=0, p=0)
[    0.133589] pci 0000:01:00.0: BAR 0: reserving [io  0xee00-0xeeff flags 0x20101] (d=0, p=0)
[    0.133591] pci 0000:01:00.0: BAR 2: reserving [mem 0xfd8ff000-0xfd8fffff flags 0x12120c] (d=0, p=0)
[    0.133594] pci 0000:01:00.0: BAR 4: reserving [mem 0xfd8f8000-0xfd8fbfff flags 0x12120c] (d=0, p=0)
[    0.133597] pci 0000:02:00.0: BAR 0: reserving [io  0xde00-0xdeff flags 0x20101] (d=0, p=0)
[    0.133599] pci 0000:02:00.0: BAR 2: reserving [mem 0xfdeff000-0xfdefffff flags 0x12120c] (d=0, p=0)
[    0.133602] pci 0000:02:00.0: BAR 4: reserving [mem 0xfdef8000-0xfdefbfff flags 0x12120c] (d=0, p=0)
[    0.133606] pci 0000:03:00.0: BAR 5: reserving [mem 0xfddfe000-0xfddfffff flags 0x20200] (d=0, p=0)
[    0.133636] pci 0000:03:00.1: BAR 0: reserving [io  0xcf00-0xcf07 flags 0x20101] (d=1, p=1)
[    0.133638] pci 0000:03:00.1: BAR 1: reserving [io  0xce00-0xce03 flags 0x20101] (d=1, p=1)
[    0.133640] pci 0000:03:00.1: BAR 2: reserving [io  0xcd00-0xcd07 flags 0x20101] (d=1, p=1)
[    0.133642] pci 0000:03:00.1: BAR 3: reserving [io  0xcc00-0xcc03 flags 0x20101] (d=1, p=1)
[    0.133644] pci 0000:03:00.1: BAR 4: reserving [io  0xcb00-0xcb0f flags 0x20101] (d=1, p=1)
[    0.133755] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.133760] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.135012] Switching to clocksource tsc
[    0.135040] pnp: PnP ACPI init
[    0.135046] ACPI: bus type pnp registered
[    0.136819] pnp 00:0a: disabling [mem 0x000f0000-0x000f3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.136825] pnp 00:0a: disabling [mem 0x000f4000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.136831] pnp 00:0a: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.136836] pnp 00:0a: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.136841] pnp 00:0a: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.136847] pnp 00:0a: disabling [mem 0x00100000-0x3fedffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.136946] pnp: PnP ACPI: found 11 devices
[    0.136948] ACPI: ACPI bus type pnp unregistered
[    0.136955] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.136958] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.136961] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.136965] system 00:02: [io  0x4100-0x411f] has been reserved
[    0.136968] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.136971] system 00:02: [io  0x040b] has been reserved
[    0.136974] system 00:02: [io  0x04d6] has been reserved
[    0.136978] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.136981] system 00:02: [io  0x0c14] has been reserved
[    0.136984] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.136987] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.136990] system 00:02: [io  0x0c6f] has been reserved
[    0.136993] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.136996] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.136999] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.137002] system 00:02: [io  0x4000-0x40fe] has been reserved
[    0.137005] system 00:02: [io  0x4210-0x4217] has been reserved
[    0.137008] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    0.137011] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    0.137014] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.137020] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.137025] system 00:0a: [mem 0x3fee0000-0x3fefffff] could not be reserved
[    0.137029] system 00:0a: [mem 0xffff0000-0xffffffff] has been reserved
[    0.137032] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.137036] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.137039] system 00:0a: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.171913] pci 0000:01:00.0: BAR 6: assigned [mem 0xfd800000-0xfd81ffff pref]
[    0.171919] pci 0000:00:07.0: PCI bridge to [bus 01-01]
[    0.171923] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.171926] pci 0000:00:07.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.171930] pci 0000:00:07.0:   bridge window [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.171936] pci 0000:02:00.0: BAR 6: assigned [mem 0xfde00000-0xfde1ffff pref]
[    0.171939] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    0.171942] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.171945] pci 0000:00:09.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.171949] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.171954] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.171957] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
[    0.171960] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.171964] pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.171968] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.171972] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.171977] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff]
[    0.171982] pci 0000:00:14.4:   bridge window [mem 0xfd900000-0xfd9fffff pref]
[    0.172001] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.172005] pci 0000:00:07.0: setting latency timer to 64
[    0.172013] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.172017] pci 0000:00:09.0: setting latency timer to 64
[    0.172024] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.172027] pci 0000:00:0a.0: setting latency timer to 64
[    0.172034] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.172035] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.172037] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.172038] pci_bus 0000:01: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.172040] pci_bus 0000:01: resource 2 [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.172042] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.172043] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.172045] pci_bus 0000:02: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.172047] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.172048] pci_bus 0000:03: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.172050] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.172052] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.172053] pci_bus 0000:04: resource 1 [mem 0xfda00000-0xfdafffff]
[    0.172055] pci_bus 0000:04: resource 2 [mem 0xfd900000-0xfd9fffff pref]
[    0.172056] pci_bus 0000:04: resource 3 [io  0x0000-0xffff]
[    0.172058] pci_bus 0000:04: resource 4 [mem 0x00000000-0xffffffff]
[    0.172097] NET: Registered protocol family 2
[    0.172137] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.172261] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.172521] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.172701] TCP: Hash tables configured (established 131072 bind 65536)
[    0.172704] TCP reno registered
[    0.172707] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.172716] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.172777] NET: Registered protocol family 1
[    0.172857] RPC: Registered udp transport module.
[    0.172859] RPC: Registered tcp transport module.
[    0.172861] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.172870] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.172874] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.172876] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xa5
[    0.172880] pci 0000:00:07.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.172883] pci 0000:00:07.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.172885] pci 0000:00:07.0: calling pci_fixup_video+0x0/0xa5
[    0.172888] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.172890] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.172892] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xa5
[    0.172895] pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.172898] pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.172900] pci 0000:00:0a.0: calling pci_fixup_video+0x0/0xa5
[    0.172903] pci 0000:00:11.0: calling quirk_msi_intx_disable_ati_bug+0x0/0x3a
[    0.172907] pci 0000:00:11.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.172909] pci 0000:00:11.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.172911] pci 0000:00:11.0: calling pci_fixup_video+0x0/0xa5
[    0.172915] pci 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.172917] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.196273] pci 0000:00:12.0: calling pci_fixup_video+0x0/0xa5
[    0.196282] pci 0000:00:12.1: calling quirk_cardbus_legacy+0x0/0x40
[    0.196284] pci 0000:00:12.1: calling quirk_usb_early_handoff+0x0/0x62d
[    0.219272] pci 0000:00:12.1: calling pci_fixup_video+0x0/0xa5
[    0.219280] pci 0000:00:12.2: calling quirk_cardbus_legacy+0x0/0x40
[    0.219283] pci 0000:00:12.2: calling quirk_usb_early_handoff+0x0/0x62d
[    0.219298] pci 0000:00:12.2: calling pci_fixup_video+0x0/0xa5
[    0.219302] pci 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.219304] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.242271] pci 0000:00:13.0: calling pci_fixup_video+0x0/0xa5
[    0.242280] pci 0000:00:13.1: calling quirk_cardbus_legacy+0x0/0x40
[    0.242282] pci 0000:00:13.1: calling quirk_usb_early_handoff+0x0/0x62d
[    0.265270] pci 0000:00:13.1: calling pci_fixup_video+0x0/0xa5
[    0.265279] pci 0000:00:13.2: calling quirk_cardbus_legacy+0x0/0x40
[    0.265281] pci 0000:00:13.2: calling quirk_usb_early_handoff+0x0/0x62d
[    0.265297] pci 0000:00:13.2: calling pci_fixup_video+0x0/0xa5
[    0.265300] pci 0000:00:14.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.265303] pci 0000:00:14.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.265305] pci 0000:00:14.0: calling pci_fixup_video+0x0/0xa5
[    0.265309] pci 0000:00:14.1: calling quirk_cardbus_legacy+0x0/0x40
[    0.265311] pci 0000:00:14.1: calling quirk_usb_early_handoff+0x0/0x62d
[    0.265313] pci 0000:00:14.1: calling pci_fixup_video+0x0/0xa5
[    0.265317] pci 0000:00:14.3: calling quirk_cardbus_legacy+0x0/0x40
[    0.265319] pci 0000:00:14.3: calling quirk_usb_early_handoff+0x0/0x62d
[    0.265322] pci 0000:00:14.3: calling pci_fixup_video+0x0/0xa5
[    0.265325] pci 0000:00:14.4: calling quirk_cardbus_legacy+0x0/0x40
[    0.265328] pci 0000:00:14.4: calling quirk_usb_early_handoff+0x0/0x62d
[    0.265330] pci 0000:00:14.4: calling pci_fixup_video+0x0/0xa5
[    0.265333] pci 0000:00:14.5: calling quirk_cardbus_legacy+0x0/0x40
[    0.265336] pci 0000:00:14.5: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288269] pci 0000:00:14.5: calling pci_fixup_video+0x0/0xa5
[    0.288278] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.288280] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288282] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xa5
[    0.288285] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x40
[    0.288287] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288289] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xa5
[    0.288292] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x40
[    0.288294] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288296] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xa5
[    0.288299] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x40
[    0.288301] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288303] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xa5
[    0.288306] pci 0000:00:18.4: calling quirk_cardbus_legacy+0x0/0x40
[    0.288308] pci 0000:00:18.4: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288310] pci 0000:00:18.4: calling pci_fixup_video+0x0/0xa5
[    0.288313] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.288315] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288317] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xa5
[    0.288321] pci 0000:02:00.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.288323] pci 0000:02:00.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288325] pci 0000:02:00.0: calling pci_fixup_video+0x0/0xa5
[    0.288329] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x40
[    0.288331] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288333] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xa5
[    0.288336] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x40
[    0.288339] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x62d
[    0.288341] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xa5
[    0.288344] PCI: CLS 64 bytes, default 64
[    0.288949] highmem bounce pool size: 64 pages
[    0.289120] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.289193] NTFS driver 2.1.29 [Flags: R/O].
[    0.289220] fuse init (API version 7.13)
[    0.289280] SGI XFS with security attributes, large block/inode numbers, debug enabled
[    0.289450] msgmni has been set to 1746
[    0.289550] alg: No test for stdrng (krng)
[    0.289557] io scheduler noop registered
[    0.289571] io scheduler cfq registered (default)
[    0.289646] pcieport 0000:00:07.0: setting latency timer to 64
[    0.289664] pcieport 0000:00:07.0: irq 24 for MSI/MSI-X
[    0.289733] pcieport 0000:00:09.0: setting latency timer to 64
[    0.289748] pcieport 0000:00:09.0: irq 25 for MSI/MSI-X
[    0.289827] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.289842] pcieport 0000:00:0a.0: irq 26 for MSI/MSI-X
[    0.290040] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.290045] ACPI: Power Button [PWRB]
[    0.290120] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.290123] ACPI: Power Button [PWRF]
[    0.291788] Linux agpgart interface v0.103
[    3.247279] floppy0: no floppy controllers found
[    3.248219] loop: module loaded
[    3.248293] ahci 0000:00:11.0: version 3.0
[    3.248310] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.248373] ahci 0000:00:11.0: using 64bit DMA mask
[    3.248375] ahci 0000:00:11.0: using 64bit consistent DMA mask
[    3.248416] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    3.248421] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    3.248622] scsi0 : ahci
[    3.248708] scsi1 : ahci
[    3.248766] scsi2 : ahci
[    3.248819] scsi3 : ahci
[    3.248921] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    3.248927] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    3.248931] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    3.248936] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    3.248958] ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.248993] ahci 0000:03:00.0: using 64bit DMA mask
[    3.248994] ahci 0000:03:00.0: using 64bit consistent DMA mask
[    3.259297] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    3.259305] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    3.259311] ahci 0000:03:00.0: setting latency timer to 64
[    3.259439] scsi4 : ahci
[    3.259529] scsi5 : ahci
[    3.259578] ata5: SATA max UDMA/133 abar m8192@0xfddfe000 port 0xfddfe100 irq 18
[    3.259583] ata6: SATA max UDMA/133 abar m8192@0xfddfe000 port 0xfddfe180 irq 18
[    3.259730] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.259748] pata_atiixp 0000:00:14.1: using 32bit DMA mask
[    3.259750] pata_atiixp 0000:00:14.1: using 32bit consistent DMA mask
[    3.259852] scsi6 : pata_atiixp
[    3.259926] scsi7 : pata_atiixp
[    3.260650] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    3.260654] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    3.260866] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    3.260875] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.260897] pata_jmicron 0000:03:00.1: using 32bit DMA mask
[    3.260898] pata_jmicron 0000:03:00.1: using 32bit consistent DMA mask
[    3.260904] pata_jmicron 0000:03:00.1: enabling bus mastering
[    3.260909] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    3.260975] scsi8 : pata_jmicron
[    3.261059] scsi9 : pata_jmicron
[    3.261107] ata9: PATA max UDMA/100 cmd 0xcf00 ctl 0xce00 bmdma 0xcb00 irq 19
[    3.261110] ata10: PATA max UDMA/100 cmd 0xcd00 ctl 0xcc00 bmdma 0xcb08 irq 19
[    3.261486] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.261501] r8169 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    3.261506] r8169 0000:01:00.0: enabling Mem-Wr-Inval
[    3.261512] r8169 0000:01:00.0: using 32bit DMA mask
[    3.261532] r8169 0000:01:00.0: setting latency timer to 64
[    3.261567] r8169 0000:01:00.0: irq 27 for MSI/MSI-X
[    3.261715] eth0: RTL8168d/8111d at 0xf8088000, 00:24:1d:14:1c:57, XID 081000c0 IRQ 27
[    3.304196] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.304204] r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.304209] r8169 0000:02:00.0: enabling Mem-Wr-Inval
[    3.304212] r8169 0000:02:00.0: using 32bit DMA mask
[    3.304226] r8169 0000:02:00.0: setting latency timer to 64
[    3.304261] r8169 0000:02:00.0: irq 28 for MSI/MSI-X
[    3.304396] eth1: RTL8168d/8111d at 0xf808c000, 00:24:1d:14:1c:55, XID 081000c0 IRQ 28
[    3.346929] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.346943] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.346950] ehci_hcd 0000:00:12.2: enabling bus mastering
[    3.346954] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    3.346972] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    3.346989] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    3.347006] ehci_hcd 0000:00:12.2: debug port 1
[    3.347014] ehci_hcd 0000:00:12.2: enabling Mem-Wr-Inval
[    3.347032] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    3.353023] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    3.353158] hub 1-0:1.0: USB hub found
[    3.353162] hub 1-0:1.0: 6 ports detected
[    3.353213] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.353227] ehci_hcd 0000:00:13.2: enabling bus mastering
[    3.353230] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    3.353237] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    3.353254] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    3.353267] ehci_hcd 0000:00:13.2: debug port 1
[    3.353276] ehci_hcd 0000:00:13.2: enabling Mem-Wr-Inval
[    3.353282] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    3.359024] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    3.359158] hub 2-0:1.0: USB hub found
[    3.359162] hub 2-0:1.0: 6 ports detected
[    3.359243] uhci_hcd: USB Universal Host Controller Interface driver
[    3.359284] Initializing USB Mass Storage driver...
[    3.359311] usbcore: registered new interface driver usb-storage
[    3.359313] USB Mass Storage support registered.
[    3.359362] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.359365] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    3.359520] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.359601] mice: PS/2 mouse device common for all mice
[    3.359704] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    3.359738] rtc_cmos 00:05: RTC can wake from S4
[    3.359770] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    3.359801] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    3.359837] i2c /dev entries driver
[    3.359904] it87: Found IT8720F chip at 0x228, revision 5
[    3.359922] it87: in3 is VCC (+5V)
[    3.360273] cpuidle: using governor ladder
[    3.360777] usbcore: registered new interface driver usbhid
[    3.360780] usbhid: USB HID core driver
[    3.360783] nf_conntrack version 0.5.0 (16114 buckets, 64456 max)
[    3.361111] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.361128] TCP cubic registered
[    3.361131] NET: Registered protocol family 17
[    3.361136] Using IPI Shortcut mode
[    3.361440] rtc_cmos 00:05: setting system clock to 2010-03-12 13:07:12 UTC (1268399232)
[    3.377390] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.435039] ata7.00: HPA detected: current 488395055, native 488397168
[    3.435046] ata7.00: ATA-6: WDC WD2500JB-55GVA0, 08.02D08, max UDMA/100
[    3.435050] ata7.00: 488395055 sectors, multi 16: LBA48 
[    3.436411] ata7.01: ATA-6: WDC WD2000JB-00GVC0, 08.02D08, max UDMA/100
[    3.436417] ata7.01: 390721968 sectors, multi 16: LBA48 
[    3.444022] ata7.00: configured for UDMA/100
[    3.451980] ata7.01: configured for UDMA/100
[    3.554294] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.554322] ata3: SATA link down (SStatus 0 SControl 300)
[    3.554351] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.554374] ata2: SATA link down (SStatus 0 SControl 300)
[    3.555099] ata4.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
[    3.555105] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.555984] ata4.00: configured for UDMA/133
[    3.558571] ata1.00: ATA-6: WDC WD2000JD-00HBB0, 08.02D08, max UDMA/133
[    3.558577] ata1.00: 390721968 sectors, multi 16: LBA48 
[    3.564128] ata1.00: configured for UDMA/133
[    3.564292] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.564323] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.564595] ata6.00: ATA-7: ST3300622AS, 0953, max UDMA/133
[    3.564601] ata6.00: 586072368 sectors, multi 1: LBA48 
[    3.564950] ata6.00: configured for UDMA/133
[    3.575200] ata5.00: ATA-7: ST31000333AS, 0953, max UDMA/133
[    3.575205] ata5.00: 1953525168 sectors, multi 1: LBA48 
[    3.575350] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JD-00H 08.0 PQ: 0 ANSI: 5
[    3.575572] ata5.00: configured for UDMA/133
[    3.575639] scsi 3:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
[    3.575679] sd 0:0:0:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
[    3.575705] sd 0:0:0:0: [sda] Write Protect is off
[    3.575708] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.575738] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.575823]  sda:
[    3.575906] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.575939] sd 3:0:0:0: [sdb] Write Protect is off
[    3.575943] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.575953] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.576043]  sdb:
[    3.586332] scsi 4:0:0:0: Direct-Access     ATA      ST31000333AS     0953 PQ: 0 ANSI: 5
[    3.586525] sd 4:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.586560] sd 4:0:0:0: [sdc] Write Protect is off
[    3.586564] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.586581] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.586628] scsi 5:0:0:0: Direct-Access     ATA      ST3300622AS      0953 PQ: 0 ANSI: 5
[    3.586672]  sdc:
[    3.586759] sd 5:0:0:0: [sdd] 586072368 512-byte logical blocks: (300 GB/279 GiB)
[    3.586783] sd 5:0:0:0: [sdd] Write Protect is off
[    3.586786] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.586795] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.586861]  sdd:
[    3.586919] scsi 6:0:0:0: Direct-Access     ATA      WDC WD2500JB-55G 08.0 PQ: 0 ANSI: 5
[    3.587101] sd 6:0:0:0: [sde] 488395055 512-byte logical blocks: (250 GB/232 GiB)
[    3.587116] scsi 6:0:1:0: Direct-Access     ATA      WDC WD2000JB-00G 08.0 PQ: 0 ANSI: 5
[    3.587132] sd 6:0:0:0: [sde] Write Protect is off
[    3.587137] sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    3.587147] sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.587215] sd 6:0:1:0: [sdf] 390721968 512-byte logical blocks: (200 GB/186 GiB)
[    3.587247] sd 6:0:1:0: [sdf] Write Protect is off
[    3.587258] sd 6:0:1:0: [sdf] Mode Sense: 00 3a 00 00
[    3.587267] sd 6:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.587320]  sdf: sdb1
[    3.589730] sd 3:0:0:0: [sdb] Attached SCSI disk
[    3.595176]  sda1
[    3.595390] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.603142]  sdf1
[    3.603248]  sde: sdd1
[    3.604570] sd 5:0:0:0: [sdd] Attached SCSI disk
[    3.608809]  sdc1
[    3.609018] sd 4:0:0:0: [sdc] Attached SCSI disk
[    3.628267]  sde1 sde2
[    3.628388] sd 6:0:1:0: [sdf] Attached SCSI disk
[    3.628536] sd 6:0:0:0: [sde] Attached SCSI disk
[    3.757500] ata8.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
[    3.757506] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.776509] ata8.00: configured for UDMA/100
[    3.776578] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[    3.776748] sd 7:0:0:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.776781] sd 7:0:0:0: [sdg] Write Protect is off
[    3.776784] sd 7:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    3.776794] sd 7:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.776867]  sdg: sdg1
[    3.785496] sd 7:0:0:0: [sdg] Attached SCSI disk
[    3.953805] UDF-fs: No partition found (1)
[    4.008576] XFS mounting filesystem sde2
[    4.235439] Ending clean XFS mount for filesystem: sde2
[    4.235486] VFS: Mounted root (xfs filesystem) readonly on device 8:66.
[    4.235507] Freeing unused kernel memory: 352k freed
[    4.235621] Write protecting the kernel text: 3628k
[    4.235640] Write protecting the kernel read-only data: 1032k
[    6.655445] udev: renamed network interface eth0_rename to eth1
[    8.935615] Adding 979924k swap on /dev/sde1.  Priority:-1 extents:1 across:979924k 
[   11.585306] r8169: eth0: link up
[   11.585313] r8169: eth0: link up
[   13.625931] r8169: eth1: link up
[   13.625940] r8169: eth1: link up
