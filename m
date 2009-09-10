Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZIJFMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZIJFMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZIJFMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:12:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbZIJFMg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:12:36 -0400
Date: Wed, 9 Sep 2009 22:12:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stevan Silva <tevost@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Nvidia IDE MCP78S not syncing: Fatal exception in interrupt
Message-Id: <20090909221234.daea7525.akpm@linux-foundation.org>
In-Reply-To: <d6592cfc0909061317k2dd1989did35ec4d1d68e80f9@mail.gmail.com>
References: <d6592cfc0909061317k2dd1989did35ec4d1d68e80f9@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-ide)

null-pointer deref in ide_complete_rq().

On Sun, 6 Sep 2009 17:17:08 -0300 Stevan Silva <tevost@gmail.com> wrote:

> I recently bought an ASUS M4N78 PRO motherboard, that is based in the
> nvidia's geforce 8300 chipset and updated my system kernel to 2.6.30
> version.
> Everything was OK untill I replace and old LG DVD-ROM IDE drive
> working as SLAVE to a newer GSA-4166B DVD-RW; same ide cable, same
> slave ide mode.
> After that, system started to crash with a
> Kernel panic - not syncing: Fatal exception in interrupt
> Pid: 0, comm: swapper Tainted: G      D    2.6.30 #2
> 
> Also, the system is booting up normally with an older kernel 2.6.24,
> windows XP and Windows 7.
> DVD drive works normally under these systems.
> What I found is that on .24 dmesg's, the IDE controller are detected
> as NFORCE-MCP77: IDE controller, but in the .30 its shown as amd74xx.
> Follows below the full kernel message in debug level.
> Also, the pci devices listing.
> As this is my first post to linux kernel mail list, I am sorry if I am
> disrespecting any well conduction rule.
> If it's possible, I would like to follow the discussion about this
> topic over CCs to this email.
> If there are some additional information that could help, please contact me.
> 
> Best regards,
> 
> Stevan Silva.
> 
> Linux version 2.6.30 (root@darkstar) (gcc version 4.2.3) #2 SMP Tue
> Aug 11 00:20:28 BRT 2009
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000006ff90000 (usable)
>  BIOS-e820: 000000006ff90000 - 000000006ffa8000 (ACPI data)
>  BIOS-e820: 000000006ffa8000 - 000000006ffe0000 (ACPI NVS)
>  BIOS-e820: 000000006ffe0000 - 0000000070000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
>  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> DMI present.
> AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> last_pfn = 0x6ff90 max_arch_pfn = 0x100000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-EFFFF uncachable
>   F0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 0000000000 mask FFC0000000 write-back
>   1 base 0040000000 mask FFE0000000 write-back
>   2 base 0060000000 mask FFF0000000 write-back
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> init_memory_mapping: 0000000000000000-00000000377fe000
>  0000000000 - 0000400000 page 4k
>  0000400000 - 0037400000 page 2M
>  0037400000 - 00377fe000 page 4k
> kernel direct mapping tables up to 377fe000 @ 10000-15000
> ACPI: RSDP 000fbbb0 00024 (v02 ACPIAM)
> ACPI: XSDT 6ff90100 00064 (v01 071009 XSDT1726 20090710 MSFT 00000097)
> ACPI: FACP 6ff90290 000F4 (v03 071009 FACP1726 20090710 MSFT 00000097)
> ACPI: DSDT 6ff90450 0BF1B (v01  A1191 A1191001 00000001 INTL 20060113)
> ACPI: FACS 6ffa8000 00040
> ACPI: APIC 6ff90390 00080 (v01 071009 APIC1726 20090710 MSFT 00000097)
> ACPI: MCFG 6ff90410 0003C (v01 071009 OEMMCFG  20090710 MSFT 00000097)
> ACPI: OEMB 6ffa8040 00073 (v01 071009 OEMB1726 20090710 MSFT 00000097)
> ACPI: HPET 6ff9c370 00038 (v01 071009 OEMHPET0 20090710 MSFT 00000097)
> ACPI: INFO 6ffa80c0 00124 (v01 071009 AMDINFO  20090710 MSFT 00000097)
> ACPI: NVHD 6ffa81f0 00284 (v01 071009  NVHDCP  20090710 MSFT 00000097)
> ACPI: SSDT 6ff9c3b0 0028A (v01 A M I  POWERNOW 00000001 AMD  00000001)
> ACPI: Local APIC address 0xfee00000
> 903MB HIGHMEM available.
> 887MB LOWMEM available.
>   mapped low ram: 0 - 377fe000
>   low ram: 0 - 377fe000
>   node 0 low ram: 00000000 - 377fe000
>   node 0 bootmap 00011000 - 00017f00
> (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
>   #3 [0000100000 - 00005b4e44]    TEXT DATA BSS ==> [0000100000 - 00005b4e44]
>   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
>   #5 [00005b5000 - 00005b722c]              BRK ==> [00005b5000 - 00005b722c]
>   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
>   #7 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
> found SMP MP-table at [c00ff780] ff780
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   0x00001000 -> 0x000377fe
>   HighMem  0x000377fe -> 0x0006ff90
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x0006ff90
> On node 0 totalpages: 458527
> free_area_init_node: node 0, pgdat c050d2c0, node_mem_map c1000200
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3951 pages, LIFO batch:0
>   Normal zone: 1744 pages used for memmap
>   Normal zone: 221486 pages, LIFO batch:31
>   HighMem zone: 1808 pages used for memmap
>   HighMem zone: 229506 pages, LIFO batch:31
> Using APIC driver default
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x2008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> ACPI: IRQ14 used by override.
> ACPI: IRQ15 used by override.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x10de8201 base: 0xfed00000
> SMP: Allowing 4 CPUs, 2 hotplug CPUs
> nr_irqs_gsi: 24
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000e3000
> PM: Registered nosave memory: 00000000000e3000 - 0000000000100000
> Allocating PCI resources starting at 80000000 (gap: 70000000:8ec00000)
> NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
> PERCPU: Embedded 11 pages at c1e07000, static data 20828 bytes
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 454943
> Kernel command line: BOOT_IMAGE=BlackB2-6-30 ro root=302 debug
> log_level=7 console=ttyS0,38400N1
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> NR_IRQS:512
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Extended CMOS year: 2000
> Fast TSC calibration using PIT
> Detected 2500.048 MHz processor.
> spurious 8259A interrupt: IRQ7.
> Console: colour dummy device 80x25
> console [ttyS0] enabled
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Initializing HighMem for node 0 (000377fe:0006ff90)
> Memory: 1812932k/1834560k available (3003k kernel code, 20192k
> reserved, 1249k data, 332k init, 925256k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
>     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
>       .init : 0xc052e000 - 0xc0581000   ( 332 kB)
>       .data : 0xc03eedf6 - 0xc0527408   (1249 kB)
>       .text : 0xc0100000 - 0xc03eedf6   (3003 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> hpet clockevent registered
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 5000.09 BogoMIPS (lpj=10000192)
> Security Framework initialized
> Mount-cache hash table entries: 512
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> using C1E aware idle routine
> Checking 'hlt' instruction... OK.
> ACPI: Core revision 20090320
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
> Booting processor 1 APIC 0x1 ip 0x6000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 4999.96 BogoMIPS (lpj=9999938)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#1.
> CPU1: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
> Brought up 2 CPUs
> System has AMD C1E enabled
> Switch to broadcast mode on CPU1
> Total of 2 processors activated (10000.06 BogoMIPS).
> Switch to broadcast mode on CPU0
> net_namespace: 992 bytes
> regulator: core version 0.5
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> PCI: Not using MMCONFIG.
> PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> PCI: Using MMCONFIG for extended config space
> ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - BB,
> should be B2 [20090320]
> ACPI: No dock devices found.
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:01.0: reg 10 io port: [0x2f00-0x2fff]
> pci 0000:00:01.1: reg 10 io port: [0x2900-0x293f]
> pci 0000:00:01.1: reg 20 io port: [0x2d00-0x2d3f]
> pci 0000:00:01.1: reg 24 io port: [0x2e00-0x2e3f]
> pci 0000:00:01.1: PME# supported from D3hot D3cold
> pci 0000:00:01.1: PME# disabled
> pci 0000:00:01.3: reg 10 32bit mmio: [0xfad80000-0xfadfffff]
> pci 0000:00:02.0: reg 10 32bit mmio: [0xfad7e000-0xfad7efff]
> pci 0000:00:02.0: supports D1 D2
> pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.0: PME# disabled
> pci 0000:00:02.1: reg 10 32bit mmio: [0xfad7fc00-0xfad7fcff]
> pci 0000:00:02.1: supports D1 D2
> pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.1: PME# disabled
> pci 0000:00:04.0: reg 10 32bit mmio: [0xfad7d000-0xfad7dfff]
> pci 0000:00:04.0: supports D1 D2
> pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:04.0: PME# disabled
> pci 0000:00:04.1: reg 10 32bit mmio: [0xfad7f800-0xfad7f8ff]
> pci 0000:00:04.1: supports D1 D2
> pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:04.1: PME# disabled
> pci 0000:00:06.0: reg 20 io port: [0xffa0-0xffaf]
> pci 0000:00:07.0: reg 10 32bit mmio: [0xfad78000-0xfad7bfff]
> pci 0000:00:07.0: PME# supported from D3hot D3cold
> pci 0000:00:07.0: PME# disabled
> pci 0000:00:09.0: reg 10 io port: [0xc480-0xc487]
> pci 0000:00:09.0: reg 14 io port: [0xc400-0xc403]
> pci 0000:00:09.0: reg 18 io port: [0xc080-0xc087]
> pci 0000:00:09.0: reg 1c io port: [0xc000-0xc003]
> pci 0000:00:09.0: reg 20 io port: [0xbc00-0xbc0f]
> pci 0000:00:09.0: reg 24 32bit mmio: [0xfad76000-0xfad77fff]
> pci 0000:00:0a.0: reg 10 32bit mmio: [0xfad7c000-0xfad7cfff]
> pci 0000:00:0a.0: reg 14 io port: [0xb880-0xb887]
> pci 0000:00:0a.0: reg 18 32bit mmio: [0xfad7f400-0xfad7f4ff]
> pci 0000:00:0a.0: reg 1c 32bit mmio: [0xfad7f000-0xfad7f00f]
> pci 0000:00:0a.0: supports D1 D2
> pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.0: PME# disabled
> pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0b.0: PME# disabled
> pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:10.0: PME# disabled
> pci 0000:00:13.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:13.0: PME# disabled
> pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:14.0: PME# disabled
> pci 0000:01:06.0: reg 10 io port: [0xdc00-0xdc7f]
> pci 0000:01:06.0: reg 14 32bit mmio: [0xfaeffc00-0xfaeffc7f]
> pci 0000:01:06.0: reg 30 32bit mmio: [0xfaec0000-0xfaedffff]
> pci 0000:01:06.0: supports D1 D2
> pci 0000:01:06.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:01:06.0: PME# disabled
> pci 0000:01:07.0: reg 10 32bit mmio: [0xfaeff000-0xfaeff7ff]
> pci 0000:01:07.0: supports D1 D2
> pci 0000:00:08.0: transparent bridge
> pci 0000:00:08.0: bridge io port: [0xd000-0xdfff]
> pci 0000:00:08.0: bridge 32bit mmio: [0xfae00000-0xfaefffff]
> pci 0000:02:00.0: reg 10 32bit mmio: [0xfb000000-0xfbffffff]
> pci 0000:02:00.0: reg 14 64bit mmio: [0xf0000000-0xf7ffffff]
> pci 0000:02:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
> pci 0000:02:00.0: reg 24 io port: [0xec00-0xec7f]
> pci 0000:02:00.0: reg 30 32bit mmio: [0xfafe0000-0xfaffffff]
> pci 0000:00:0b.0: bridge io port: [0xe000-0xefff]
> pci 0000:00:0b.0: bridge 32bit mmio: [0xfaf00000-0xfbffffff]
> pci 0000:00:0b.0: bridge 64bit mmio pref: [0xf0000000-0xf9ffffff]
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MXR0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *10
> ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *11
> ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN0A] (IRQs 16 17 18 19) *10
> ACPI: PCI Interrupt Link [LN0B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN0C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN0D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN1A] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN1B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN1C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN1D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN2A] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN2B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN2C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN2D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN3A] (IRQs 16 17 18 19) *11
> ACPI: PCI Interrupt Link [LN3B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN3C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN3D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN4A] (IRQs 16 17 18 19) *15
> ACPI: PCI Interrupt Link [LN4B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN4C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN4D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN5A] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN5B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN5C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN5D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN6A] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN6B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN6C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN6D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN7A] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN7B] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN7C] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LN7D] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
> ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *15
> ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
> ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *15
> ACPI: PCI Interrupt Link [SGRU] (IRQs 20 21 22 23) *7
> ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *10
> ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
> ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *11
> ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *10
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 1
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 13 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:05: ioport range 0x4d0-0x4d1 has been reserved
> system 00:05: ioport range 0x800-0x80f has been reserved
> system 00:05: ioport range 0x2000-0x207f has been reserved
> system 00:05: ioport range 0x2080-0x20ff has been reserved
> system 00:05: ioport range 0x2400-0x247f has been reserved
> system 00:05: ioport range 0x2480-0x24ff has been reserved
> system 00:05: ioport range 0x2800-0x287f has been reserved
> system 00:05: ioport range 0x2880-0x28ff has been reserved
> system 00:05: iomem range 0xfed04000-0xfed04fff has been reserved
> system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
> system 00:08: ioport range 0xc00-0xc0f has been reserved
> system 00:08: ioport range 0xd00-0xd0f has been reserved
> system 00:08: ioport range 0xa20-0xa2f has been reserved
> system 00:08: ioport range 0xa30-0xa3f has been reserved
> system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
> system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
> system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
> system 00:0c: iomem range 0x0-0x9ffff could not be reserved
> system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
> system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
> system 00:0c: iomem range 0x100000-0x7fffffff could not be reserved
> system 00:0c: iomem range 0xfec00000-0xffffffff could not be reserved
> pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
> pci 0000:00:08.0:   IO window: 0xd000-0xdfff
> pci 0000:00:08.0:   MEM window: 0xfae00000-0xfaefffff
> pci 0000:00:08.0:   PREFETCH window: 0x00000080000000-0x000000800fffff
> pci 0000:00:0b.0: PCI bridge, secondary bus 0000:02
> pci 0000:00:0b.0:   IO window: 0xe000-0xefff
> pci 0000:00:0b.0:   MEM window: 0xfaf00000-0xfbffffff
> pci 0000:00:0b.0:   PREFETCH window: 0x000000f0000000-0x000000f9ffffff
> pci 0000:00:10.0: PCI bridge, secondary bus 0000:03
> pci 0000:00:10.0:   IO window: disabled
> pci 0000:00:10.0:   MEM window: disabled
> pci 0000:00:10.0:   PREFETCH window: disabled
> pci 0000:00:13.0: PCI bridge, secondary bus 0000:04
> pci 0000:00:13.0:   IO window: disabled
> pci 0000:00:13.0:   MEM window: disabled
> pci 0000:00:13.0:   PREFETCH window: disabled
> pci 0000:00:14.0: PCI bridge, secondary bus 0000:05
> pci 0000:00:14.0:   IO window: disabled
> pci 0000:00:14.0:   MEM window: disabled
> pci 0000:00:14.0:   PREFETCH window: disabled
> pci 0000:00:08.0: setting latency timer to 64
> pci 0000:00:0b.0: setting latency timer to 64
> ACPI: PCI Interrupt Link [LN0A] enabled at IRQ 19
> pci 0000:00:10.0: PCI INT A -> Link[LN0A] -> GSI 19 (level, low) -> IRQ 19
> pci 0000:00:10.0: setting latency timer to 64
> ACPI: PCI Interrupt Link [LN3A] enabled at IRQ 18
> pci 0000:00:13.0: PCI INT A -> Link[LN3A] -> GSI 18 (level, low) -> IRQ 18
> pci 0000:00:13.0: setting latency timer to 64
> ACPI: PCI Interrupt Link [LN4A] enabled at IRQ 17
> pci 0000:00:14.0: PCI INT A -> Link[LN4A] -> GSI 17 (level, low) -> IRQ 17
> pci 0000:00:14.0: setting latency timer to 64
> pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
> pci_bus 0000:01: resource 1 mem: [0xfae00000-0xfaefffff]
> pci_bus 0000:01: resource 2 pref mem [0x80000000-0x800fffff]
> pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
> pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
> pci_bus 0000:02: resource 0 io:  [0xe000-0xefff]
> pci_bus 0000:02: resource 1 mem: [0xfaf00000-0xfbffffff]
> pci_bus 0000:02: resource 2 pref mem [0xf0000000-0xf9ffffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> highmem bounce pool size: 64 pages
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> msgmni has been set to 1735
> alg: No test for stdrng (krng)
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> pci 0000:02:00.0: Boot video device
> pcieport-driver 0000:00:10.0: setting latency timer to 64
> pcieport-driver 0000:00:13.0: setting latency timer to 64
> pcieport-driver 0000:00:14.0: setting latency timer to 64
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> vesafb: framebuffer at 0xf9000000, mapped to 0xf8080000, using 3072k,
> total 14336k
> vesafb: mode is 1024x768x16, linelength=2048, pages=1
> vesafb: protected mode interface info at c000:ba00
> vesafb: pmi: set display start = c00cba63, set palette = c00cbabe
> vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc
> 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
> vesafb: scrolling: redraw
> vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> Console: switching to colour frame buffer device 128x48
> fb0: VESA VGA frame buffer device
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> brd: module loaded
> loop: module loaded
> Uniform Multi-Platform E-IDE driver
> amd74xx 0000:00:06.0: UDMA133 controller
> amd74xx 0000:00:06.0: IDE controller (0x10de:0x0759 rev 0xa1)
> amd74xx 0000:00:06.0: IDE port disabled
> amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. Enabling workaround.
> amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xffa0-0xffa7
> Probing IDE interface ide0...
> hda: ST380215A, ATA DISK drive
> hdb: HL-DT-STDVDRRW GSA-4166B, ATAPI CD/DVD-ROM drive
> hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/100 mode selected
> hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> hdb: UDMA/66 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide_generic: please use "probe_mask=0x3f" module parameter for probing
> all legacy ISA IDE ports
> ide-gd driver 1.18
> hda: max request size: 512KiB
> hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63
> hda: cache flushes supported
>  hda: hda1 hda2 hda3
> ide-cd driver 5.00
> ide-cd: hdb: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
> Uniform CD-ROM driver Revision: 3.20
> BUG: unable to handle kernel NULL pointer dereference at 00000024
> IP: [<c02b7cdf>] ide_complete_rq+0x1f/0x60
> *pde = 00000000
> Oops: 0000 [#1] SMP
> last sysfs file:
> Modules linked in:
> 
> Pid: 0, comm: swapper Not tainted (2.6.30 #2) System Product Name
> EIP: 0060:[<c02b7cdf>] EFLAGS: 00010292 CPU: 1
> EIP is at ide_complete_rq+0x1f/0x60
> EAX: f69c9000 EBX: 00000000 ECX: 00000200 EDX: fffffffb
> ESI: fffffffb EDI: f69f0c00 EBP: f706fe30 ESP: f706fe1c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=f706e000 task=f705e720 task.ti=f706e000)
> Stack:
>  00000022 f69c9000 f6a0c680 00000000 00000000 f706fe80 c02cb4a1 00000000
>  f706fe44 c0116b0d f706fe60 f69f0c00 0006fe78 00000050 0006fe6c f69c9000
>  f69c9094 f6a0c680 00000000 00000000 f706fe80 03120022 f69e6c40 f69c9000
> Call Trace:
>  [<c02cb4a1>] ? cdrom_newpc_intr+0x2b1/0x8d0
>  [<c0116b0d>] ? read_hpet+0xd/0x20
>  [<c02b7a90>] ? ide_intr+0x1a0/0x1f0
>  [<c0143c19>] ? tick_dev_program_event+0x79/0xb0
>  [<c02cb1f0>] ? cdrom_newpc_intr+0x0/0x8d0
>  [<c01519f7>] ? handle_IRQ_event+0x37/0xc0
>  [<c01540a4>] ? move_native_irq+0x14/0x50
>  [<c0153673>] ? handle_edge_irq+0xb3/0x120
>  [<c010520a>] ? handle_irq+0x1a/0x30
>  [<c01049e6>] ? do_IRQ+0x46/0xa0
>  [<c0103329>] ? common_interrupt+0x29/0x30
>  [<c01097d8>] ? default_idle+0x38/0x50
>  [<c0109b10>] ? c1e_idle+0x90/0xf0
>  [<c0101da5>] ? cpu_idle+0x35/0x60
>  [<c03e9a42>] ? start_secondary+0x172/0x1e0
> Code: 00 eb db 89 f6 8d bc 27 00 00 00 00 55 89 e5 83 ec 14 89 75 f8
> 89 7d fc 89 c7 89 5d f4 8b 40 28 89 d6 89 45 f0 8b 98 d0 01 00 00 <f6>
> 43 24 0e 0f 95 c2 85 f6 0f 9e c0 84 c2 74 06 8b 4b 44 c1 e1
> EIP: [<c02b7cdf>] ide_complete_rq+0x1f/0x60 SS:ESP 0068:f706fe1c
> CR2: 0000000000000024
> ---[ end trace fa721a14f0610390 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> Pid: 0, comm: swapper Tainted: G      D    2.6.30 #2
> Call Trace:
>  [<c0126016>] panic+0x46/0xf0
>  [<c0106174>] oops_end+0x84/0x90
>  [<c0117c87>] no_context+0x117/0x150
>  [<c0117db8>] __bad_area_nosemaphore+0x48/0x130
>  [<c011c9a8>] ? __wake_up_common+0x48/0x70
>  [<c0117f42>] bad_area_nosemaphore+0x12/0x20
>  [<c0118098>] do_page_fault+0x88/0x240
>  [<c0118010>] ? do_page_fault+0x0/0x240
>  [<c03ee2ed>] error_code+0x6d/0x74
>  [<c0118010>] ? do_page_fault+0x0/0x240
>  [<c02b7cdf>] ? ide_complete_rq+0x1f/0x60
>  [<c02cb4a1>] cdrom_newpc_intr+0x2b1/0x8d0
>  [<c0116b0d>] ? read_hpet+0xd/0x20
>  [<c02b7a90>] ide_intr+0x1a0/0x1f0
>  [<c0143c19>] ? tick_dev_program_event+0x79/0xb0
>  [<c02cb1f0>] ? cdrom_newpc_intr+0x0/0x8d0
>  [<c01519f7>] handle_IRQ_event+0x37/0xc0
>  [<c01540a4>] ? move_native_irq+0x14/0x50
>  [<c0153673>] handle_edge_irq+0xb3/0x120
>  [<c010520a>] handle_irq+0x1a/0x30
>  [<c01049e6>] do_IRQ+0x46/0xa0
>  [<c0103329>] common_interrupt+0x29/0x30
>  [<c01097d8>] ? default_idle+0x38/0x50
>  [<c0109b10>] c1e_idle+0x90/0xf0
>  [<c0101da5>] cpu_idle+0x35/0x60
>  [<c03e9a42>] start_secondary+0x172/0x1e0
> 
> 
> 00:00.0 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory
> Controller (rev a2)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         Capabilities: [94] HyperTransport: #1a
>         Capabilities: [60] HyperTransport: Retry Mode
>         Capabilities: [44] HyperTransport: Slave or Primary Interface
>         Capabilities: [d0] HyperTransport: #1c
> 
> 00:01.0 ISA bridge: nVidia Corporation MCP78S [GeForce 8200] LPC Bridge (rev a2)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         I/O ports at 2f00 [size=256]
> 
> 00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SMBus (rev a1)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: 66MHz, fast devsel, IRQ 11
>         I/O ports at 2900 [size=64]
>         I/O ports at 2d00 [size=64]
>         I/O ports at 2e00 [size=64]
>         Capabilities: [44] Power Management version 2
>         Kernel modules: i2c-nforce2
> 
> 00:01.2 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory
> Controller (rev a1)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: 66MHz, fast devsel
> 
> 00:01.3 Co-processor: nVidia Corporation MCP78S [GeForce 8200]
> Co-Processor (rev a2)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
>         Memory at fad80000 (32-bit, non-prefetchable) [size=512K]
> 
> 00:01.4 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory
> Controller (rev a1)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: 66MHz, fast devsel
> 
> 00:02.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI
> USB 1.1 Controller (rev a1) (prog-if 10 [OHCI])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
>         Memory at fad7e000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [44] Power Management version 2
>         Kernel driver in use: ohci_hcd
>         Kernel modules: ohci-hcd
> 
> 00:02.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI
> USB 2.0 Controller (rev a1) (prog-if 20 [EHCI])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
>         Memory at fad7fc00 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [44] Debug port: BAR=1 offset=00a0
>         Capabilities: [80] Power Management version 2
>         Kernel driver in use: ehci_hcd
>         Kernel modules: ehci-hcd
> 
> 00:04.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI
> USB 1.1 Controller (rev a1) (prog-if 10 [OHCI])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
>         Memory at fad7d000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [44] Power Management version 2
>         Kernel driver in use: ohci_hcd
>         Kernel modules: ohci-hcd
> 
> 00:04.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI
> USB 2.0 Controller (rev a1) (prog-if 20 [EHCI])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
>         Memory at fad7f800 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [44] Debug port: BAR=1 offset=00a0
>         Capabilities: [80] Power Management version 2
>         Kernel driver in use: ehci_hcd
>         Kernel modules: ehci-hcd
> 
> 00:06.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] IDE
> (rev a1) (prog-if 8a [Master SecP PriP])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
> [disabled] [size=8]
>         [virtual] Memory at 000003f0 (type 3, non-prefetchable)
> [disabled] [size=1]
>         [virtual] Memory at 00000170 (32-bit, non-prefetchable)
> [disabled] [size=8]
>         [virtual] Memory at 00000370 (type 3, non-prefetchable)
> [disabled] [size=1]
>         I/O ports at ffa0 [size=16]
>         Capabilities: [44] Power Management version 2
>         Kernel driver in use: AMD_IDE
> 
> 00:07.0 Audio device: nVidia Corporation MCP72XE/MCP72P/MCP78U/MCP78S
> High Definition Audio (rev a1)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 836c
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
>         Memory at fad78000 (32-bit, non-prefetchable) [size=16K]
>         Capabilities: [44] Power Management version 2
>         Kernel driver in use: HDA Intel
>         Kernel modules: snd-hda-intel
> 
> 00:08.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Bridge (rev a1) (prog-if 01 [Subtractive decode])
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
>         I/O behind bridge: 0000d000-0000dfff
>         Memory behind bridge: fae00000-faefffff
>         Prefetchable memory behind bridge: 80000000-800fffff
>         Capabilities: [b8] Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
> 
> 00:09.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] SATA
> Controller (non-AHCI mode) (rev a2) (prog-if 85 [Master SecO PriO])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
>         I/O ports at c480 [size=8]
>         I/O ports at c400 [size=4]
>         I/O ports at c080 [size=8]
>         I/O ports at c000 [size=4]
>         I/O ports at bc00 [size=16]
>         Memory at fad76000 (32-bit, non-prefetchable) [size=8K]
>         Capabilities: [44] Power Management version 2
>         Capabilities: [8c] SATA HBA <?>
>         Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/3 Enable-
>         Capabilities: [ec] HyperTransport: MSI Mapping Enable- Fixed+
>         Kernel driver in use: ahci
> 
> 00:0a.0 Ethernet controller: nVidia Corporation MCP77 Ethernet (rev a2)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
>         Memory at fad7c000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at b880 [size=8]
>         Memory at fad7f400 (32-bit, non-prefetchable) [size=256]
>         Memory at fad7f000 (32-bit, non-prefetchable) [size=16]
>         Capabilities: [44] Power Management version 2
>         Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+
> Queue=0/4 Enable-
>         Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
>         Kernel driver in use: forcedeth
>         Kernel modules: forcedeth
> 
> 00:0b.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Express Bridge (rev a1) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>         I/O behind bridge: 0000e000-0000efff
>         Memory behind bridge: faf00000-fbffffff
>         Prefetchable memory behind bridge: 00000000f0000000-00000000f9ffffff
>         Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Capabilities: [48] Power Management version 2
>         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>         Kernel modules: shpchp
> 
> 00:10.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Express Bridge (rev a1) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>         Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Capabilities: [48] Power Management version 3
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/1 Enable-
>         Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
>         Capabilities: [80] Express Root Port (Slot+), MSI 00
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:13.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Bridge (rev a1) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>         Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Capabilities: [48] Power Management version 3
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/1 Enable-
>         Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
>         Capabilities: [80] Express Root Port (Slot+), MSI 00
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:14.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Bridge (rev a1) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>         Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Capabilities: [48] Power Management version 3
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/1 Enable-
>         Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
>         Capabilities: [80] Express Root Port (Slot+), MSI 00
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] HyperTransport Technology Configuration
>         Flags: fast devsel
>         Capabilities: [80] HyperTransport: Host or Secondary Interface
> 
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] Address Map
>         Flags: fast devsel
> 
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] DRAM Controller
>         Flags: fast devsel
> 
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] Miscellaneous Control
>         Flags: fast devsel
>         Capabilities: [f0] Secure device <?>
>         Kernel driver in use: k8temp
>         Kernel modules: k8temp
> 
> 01:06.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 74)
>         Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink for
> PC Management NIC
>         Flags: bus master, medium devsel, latency 32, IRQ 16
>         I/O ports at dc00 [size=128]
>         Memory at faeffc00 (32-bit, non-prefetchable) [size=128]
>         Expansion ROM at 80000000 [disabled] [size=128K]
>         Capabilities: [dc] Power Management version 2
>         Kernel driver in use: 3c59x
>         Kernel modules: 3c59x
> 
> 01:07.0 Multimedia controller: Philips Semiconductors
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
>         Subsystem: Pinnacle Systems Inc. PCTV 110i (saa7133)
>         Flags: bus master, medium devsel, latency 32, IRQ 11
>         Memory at faeff000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [40] Power Management version 2
>         Kernel modules: saa7134
> 
> 02:00.0 VGA compatible controller: nVidia Corporation C77 [GeForce
> 8300] (rev a2) (prog-if 00 [VGA controller])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 82e2
>         Flags: bus master, fast devsel, latency 0, IRQ 20
>         Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
>         Memory at f0000000 (64-bit, prefetchable) [size=128M]
>         Memory at f8000000 (64-bit, prefetchable) [size=32M]
>         I/O ports at ec00 [size=128]
>         [virtual] Expansion ROM at fafe0000 [disabled] [size=128K]
>         Capabilities: [60] Power Management version 2
>         Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>         Kernel driver in use: nvidia
>         Kernel modules: nvidiafb, nvidia
