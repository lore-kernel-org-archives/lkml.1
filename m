Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZLDPlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZLDPlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZLDPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:41:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47165 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZLDPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:41:05 -0500
Date: Fri, 4 Dec 2009 10:41:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       David Rientjes <rientjes@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel problem
Message-ID: <20091204154109.GB1716@goodmis.org>
References: <web-100877149@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <web-100877149@zbackend1.aha.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Cc's of people that may be interested in this ]

On Thu, Dec 03, 2009 at 03:40:29AM -0400, werner wrote:
> problem during booting with 2.6.32-rc8-git5, whole dmesg below
> w.landgraf@ru.ru
> 
> ------------[ cut here ]------------
> WARNING: at mm/page_alloc.c:1805
> __alloc_pages_nodemask+0x127/0x48f()
> Hardware name: System Product Name
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.32-rc8-git5 #1
> Call Trace:
>  [<c103d94b>] warn_slowpath_common+0x65/0x95
>  [<c103d98d>] warn_slowpath_null+0x12/0x15
>  [<c109550c>] __alloc_pages_nodemask+0x127/0x48f
>  [<c10be964>] ? get_slab+0x8/0x50
>  [<c10b8979>] alloc_page_interleave+0x2e/0x6e
>  [<c10b8a10>] alloc_pages_current+0x57/0x99
>  [<c2083a4a>] ? xd_init+0x0/0x482
>  [<c1094c38>] __get_free_pages+0xd/0x1e
>  [<c2083a94>] xd_init+0x4a/0x482
>  [<c2082df0>] ? loop_init+0x104/0x16a
>  [<c169162d>] ? loop_probe+0x0/0xaf
>  [<c2083a4a>] ? xd_init+0x0/0x482
>  [<c1001143>] do_one_initcall+0x51/0x13f
>  [<c204a307>] kernel_init+0x10b/0x15f
>  [<c204a1fc>] ? kernel_init+0x0/0x15f
>  [<c1004347>] kernel_thread_helper+0x7/0x10
> ---[ end trace 686db6333ade6e7a ]---
> 
> ===========================================
> 
> Linux version 2.6.32-rc8-git5 (root@werner) (gcc version 4.3.3 (GCC)
> ) #1 SMP Thu Dec 3 04:14:36 GFT 2009
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000bfee0000 (usable)
>  BIOS-e820: 00000000bfee0000 - 00000000bfee3000 (ACPI NVS)
>  BIOS-e820: 00000000bfee3000 - 00000000bfef0000 (ACPI data)
>  BIOS-e820: 00000000bfef0000 - 00000000bff00000 (reserved)
>  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
> DMI 2.4 present.
> Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
> (reserved)
> last_pfn = 0x240000 max_arch_pfn = 0x1000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-C7FFF write-protect
>   C8000-FFFFF uncachable
> MTRR variable ranges enabled:
>   0 base 0000000000 mask FF80000000 write-back
>   1 base 0080000000 mask FFC0000000 write-back
>   2 base 0100000000 mask FF00000000 write-back
>   3 base 0200000000 mask FFC0000000 write-back
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> TOM2: 0000000240000000 aka 9216M
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==>
> (reserved)
> Scanning 0 areas for low memory corruption
> modified physical RAM map:
>  modified: 0000000000000000 - 0000000000010000 (reserved)
>  modified: 0000000000010000 - 000000000009f000 (usable)
>  modified: 000000000009f000 - 00000000000a0000 (reserved)
>  modified: 00000000000f0000 - 0000000000100000 (reserved)
>  modified: 0000000000100000 - 00000000bfee0000 (usable)
>  modified: 00000000bfee0000 - 00000000bfee3000 (ACPI NVS)
>  modified: 00000000bfee3000 - 00000000bfef0000 (ACPI data)
>  modified: 00000000bfef0000 - 00000000bff00000 (reserved)
>  modified: 00000000f0000000 - 00000000f4000000 (reserved)
>  modified: 00000000fec00000 - 0000000100000000 (reserved)
>  modified: 0000000100000000 - 0000000240000000 (usable)
> initial memory mapped : 0 - 02600000
> init_memory_mapping: 0000000000000000-00000000377fe000
> NX (Execute Disable) protection: active
>  0000000000 - 0000200000 page 4k
>  0000200000 - 0037600000 page 2M
>  0037600000 - 00377fe000 page 4k
> kernel direct mapping tables up to 377fe000 @ 10000-17000
> ACPI: RSDP 000f6fd0 00024 (v02 Nvidia)
> ACPI: XSDT bfee30c0 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD
> 00000000)
> ACPI: FACP bfeeb840 000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD
> 00000000)
> ACPI: DSDT bfee3240 08581 (v01 NVIDIA ASUSACPI 00001000 MSFT
> 03000000)
> ACPI: FACS bfee0000 00040
> ACPI: MCFG bfeeba40 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD
> 00000000)
> ACPI: APIC bfeeb980 0007C (v01 Nvidia ASUSACPI 42302E31 AWRD
> 00000000)
> found SMP MP-table at [c00f5440] f5440
> Intel MultiProcessor Specification v1.4
>     Virtual Wire compatibility mode.
> MPTABLE: OEM ID: OEM00000
> MPTABLE: Product ID: PROD00000000
> MPTABLE: APIC at: 0xFEE00000
> Warning! Not a NUMA-Q system!
> could not find any ACPI SRAT memory areas.
> failed to get NUMA memory information from SRAT table
> NUMA - single node, flat memory mode
> Node: 0, start_pfn: 0, end_pfn: 240000
>   Setting physnode_map array to node 0 for pfns:
>   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000 2c000
> 30000 34000 38000 3c000 40000 44000 48000 4c000 50000 54000 58000
> 5c000 60000 64000 68000 6c000 70000 74000 78000 7c000 80000 84000
> 88000 8c000 90000 94000 98000 9c000 a0000 a4000 a8000 ac000 b0000
> b4000 b8000 bc000 c0000 c4000 c8000 cc000 d0000 d4000 d8000 dc000
> e0000 e4000 e8000 ec000 f0000 f4000 f8000 fc000 100000 104000 108000
> 10c000 110000 114000 118000 11c000 120000 124000 128000 12c000
> 130000 134000 138000 13c000 140000 144000 148000 14c000 150000
> 154000 158000 15c000 160000 164000 168000 16c000 170000 174000
> 178000 17c000 180000 184000 188000 18c000 190000 194000 198000
> 19c000 1a0000 1a4000 1a8000 1ac000 1b0000 1b4000 1b8000 1bc000
> 1c0000 1c4000 1c8000 1cc000 1d0000 1d4000 1d8000 1dc000 1e0000
> 1e4000 1e8000 1ec000 1f0000 1f4000 1f8000 1fc000 200000 204000
> 208000 20c000 210000 214000 218000 21c000 220000 224000 228000
> 22c000 230000 234000 238000 23c000
> node 0 pfn: [0 - 240000]
> Reserving 18944 pages of KVA for lmem_map of node 0 at 23b600
> remove_active_range (0, 2340352, 2359296)
> Reserving total of 4a00 pages for numa KVA remap
> kva_start_pfn ~ 32c00 max_low_pfn ~ 377fe
> max_pfn = 240000
> 8328MB HIGHMEM available.
> 887MB LOWMEM available.
> max_low_pfn = 377fe, highstart_pfn = 377fe
> Low memory ends at vaddr f77fe000
> node 0 will remap to vaddr f2c00000 - f7600000
> allocate_pgdat: node 0 NODE_DATA f2c00000
> remap_numa_kva: node 0
> remap_numa_kva: f2c00000 to pfn 0023b600
> remap_numa_kva: f2e00000 to pfn 0023b800
> remap_numa_kva: f3000000 to pfn 0023ba00
> remap_numa_kva: f3200000 to pfn 0023bc00
> remap_numa_kva: f3400000 to pfn 0023be00
> remap_numa_kva: f3600000 to pfn 0023c000
> remap_numa_kva: f3800000 to pfn 0023c200
> remap_numa_kva: f3a00000 to pfn 0023c400
> remap_numa_kva: f3c00000 to pfn 0023c600
> remap_numa_kva: f3e00000 to pfn 0023c800
> remap_numa_kva: f4000000 to pfn 0023ca00
> remap_numa_kva: f4200000 to pfn 0023cc00
> remap_numa_kva: f4400000 to pfn 0023ce00
> remap_numa_kva: f4600000 to pfn 0023d000
> remap_numa_kva: f4800000 to pfn 0023d200
> remap_numa_kva: f4a00000 to pfn 0023d400
> remap_numa_kva: f4c00000 to pfn 0023d600
> remap_numa_kva: f4e00000 to pfn 0023d800
> remap_numa_kva: f5000000 to pfn 0023da00
> remap_numa_kva: f5200000 to pfn 0023dc00
> remap_numa_kva: f5400000 to pfn 0023de00
> remap_numa_kva: f5600000 to pfn 0023e000
> remap_numa_kva: f5800000 to pfn 0023e200
> remap_numa_kva: f5a00000 to pfn 0023e400
> remap_numa_kva: f5c00000 to pfn 0023e600
> remap_numa_kva: f5e00000 to pfn 0023e800
> remap_numa_kva: f6000000 to pfn 0023ea00
> remap_numa_kva: f6200000 to pfn 0023ec00
> remap_numa_kva: f6400000 to pfn 0023ee00
> remap_numa_kva: f6600000 to pfn 0023f000
> remap_numa_kva: f6800000 to pfn 0023f200
> remap_numa_kva: f6a00000 to pfn 0023f400
> remap_numa_kva: f6c00000 to pfn 0023f600
> remap_numa_kva: f6e00000 to pfn 0023f800
> remap_numa_kva: f7000000 to pfn 0023fa00
> remap_numa_kva: f7200000 to pfn 0023fc00
> remap_numa_kva: f7400000 to pfn 0023fe00
> High memory starts at vaddr f77fe000
>   mapped low ram: 0 - 377fe000
>   low ram: 0 - 377fe000
>   node 0 low ram: 00000000 - 377fe000
>   node 0 bootmap 00014000 - 0001af00
> (10 early reservations) ==> bootmem [0000000000 - 00377fe000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
> 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 -
> 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 -
> 0000007000]
>   #3 [0001000000 - 0002217fa8]    TEXT DATA BSS ==> [0001000000 -
> 0002217fa8]
>   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 -
> 0000100000]
>   #5 [0002218000 - 000222b14d]              BRK ==> [0002218000 -
> 000222b14d]
>   #6 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 -
> 0000014000]
>   #7 [023b600000 - 0240000000]          KVA RAM
>   #8 [0032c00000 - 0037600000]           KVA PG ==> [0032c00000 -
> 0037600000]
>   #9 [0000014000 - 000001b000]          BOOTMAP ==> [0000014000 -
> 000001b000]
> found SMP MP-table at [c00f5440] f5440
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   0x00001000 -> 0x000377fe
>   HighMem  0x000377fe -> 0x00240000
> Movable zone start PFN for each node
> early_node_map[3] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x000bfee0
>     0: 0x00100000 -> 0x0023b600
> On node 0 totalpages: 2077807
> free_area_init_node: node 0, pgdat f2c00000, node_mem_map f2c02200
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3951 pages, LIFO batch:0
>   Normal zone: 1744 pages used for memmap
>   Normal zone: 221486 pages, LIFO batch:31
>   HighMem zone: 16509 pages used for memmap
>   HighMem zone: 1834085 pages, LIFO batch:31
> Using APIC driver default
> Nvidia board detected. Ignoring ACPI timer override.
> If you got timer trouble try acpi_use_timer_override
> ACPI: No APIC-table, disabling MPS
> SFI: Simple Firmware Interface v0.7 http://simplefirmware.org
> SMP: Allowing 1 CPUs, 0 hotplug CPUs
> APIC: disable apic facility
> nr_irqs_gsi: 16
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> Allocating PCI resources starting at bff00000 (gap:
> bff00000:30100000)
> Booting paravirtualized kernel on bare hardware
> NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:16
> PERCPU: Embedded 14 pages/cpu @c2400000 s35128 r0 d22216 u2097152
> pcpu-alloc: s35128 r0 d22216 u2097152 alloc=1*2097152
> pcpu-alloc: [0] 0
> Built 1 zonelists in Zone order, mobility grouping on. Total pages:
> 2059522
> Policy zone: HighMem
> Kernel command line: BOOT_IMAGE=2632rc8git5 ro root=801 4
> root=/dev/sda1 devfs=nomount noapic nolapic acpi=ht rootwait
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> Initializing HighMem for node 0 (000377fe:0023b600)
> Memory: 8215892k/9437184k available (12244k kernel code, 95336k
> reserved, 4434k data, 852k init, 7402376k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffd55000 - 0xfffff000   (2728 kB)
>     pkmap   : 0xff800000 - 0xffa00000   (2048 kB)
>     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
>     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
>       .init : 0xc204a000 - 0xc211f000   ( 852 kB)
>       .data : 0xc1bf50d9 - 0xc2049bc8   (4434 kB)
>       .text : 0xc1000000 - 0xc1bf50d9   (12244 kB)
> Checking if this processor honours the WP bit even in supervisor
> mode...Ok.
> SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=1,
> Nodes=16
> Hierarchical RCU implementation.
> NR_IRQS:2304 nr_irqs:256
> Extended CMOS year: 2000
> spurious 8259A interrupt: IRQ7.
> Console: colour dummy device 80x25
> console [tty0] enabled
> Fast TSC calibration using PIT
> Detected 2511.710 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 5023.42 BogoMIPS (lpj=2511710)
> Security Framework initialized
> Mount-cache hash table entries: 512
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> mce: CPU supports 5 MCE banks
> using C1E aware idle routine
> Performance Events: AMD PMU driver.
> ... version:                0
> ... bit width:              48
> ... generic registers:      4
> ... value mask:             0000ffffffffffff
> ... max period:             00007fffffffffff
> ... fixed-purpose events:   0
> ... event mask:             000000000000000f
> Checking 'hlt' instruction... OK.
> SMP alternatives: switching to UP code
> Freeing SMP alternatives: 41k freed
> weird, boot CPU (#0) not listed by the BIOS.
> SMP motherboard not detected.
> Mapping cpu 0 to node 0
> Apic disabled
> Local APIC not detected. Using dummy APIC emulation.
> SMP disabled
> Mapping cpu 0 to node 0
> Brought up 1 CPUs
> Total of 1 processors activated (5023.42 BogoMIPS).
> devtmpfs: initialized
> xor: automatically using best checksumming function: pIII_sse
>    pIII_sse  :  6784.000 MB/sec
> xor: using function: pIII_sse (6784.000 MB/sec)
> regulator: core version 0.5
> NET: Registered protocol family 16
> EISA bus registered
> PCI: PCI BIOS revision 3.00 entry at 0xf1e10, last bus=4
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: Interpreter disabled.
> vgaarb: loaded
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> raid6: int32x1    640 MB/s
> raid6: int32x2    863 MB/s
> raid6: int32x4    730 MB/s
> raid6: int32x8    554 MB/s
> raid6: mmxx1     2050 MB/s
> raid6: mmxx2     3722 MB/s
> raid6: sse1x1    1949 MB/s
> raid6: sse1x2    3285 MB/s
> raid6: sse2x1    3347 MB/s
> raid6: sse2x2    4332 MB/s
> raid6: using algorithm sse2x2 (4332 MB/s)
> PCI: Probing PCI hardware
> PCI: Probing PCI hardware (bus 00)
> pci 0000:00:01.1: reg 10 io port: [0xfc00-0xfc3f]
> pci 0000:00:01.1: reg 20 io port: [0x1c00-0x1c3f]
> pci 0000:00:01.1: reg 24 io port: [0x1c40-0x1c7f]
> pci 0000:00:01.1: PME# supported from D3hot D3cold
> pci 0000:00:01.1: PME# disabled
> pci 0000:00:02.0: reg 10 32bit mmio: [0xfe02f000-0xfe02ffff]
> pci 0000:00:02.0: supports D1 D2
> pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.0: PME# disabled
> pci 0000:00:02.1: reg 10 32bit mmio: [0xfe02e000-0xfe02e0ff]
> pci 0000:00:02.1: supports D1 D2
> pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.1: PME# disabled
> pci 0000:00:05.0: reg 10 32bit mmio: [0xfe024000-0xfe027fff]
> pci 0000:00:05.0: PME# supported from D3hot D3cold
> pci 0000:00:05.0: PME# disabled
> pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
> pci 0000:00:07.0: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
> pci 0000:00:07.0: reg 14 io port: [0xec00-0xec07]
> pci 0000:00:07.0: supports D1 D2
> pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:07.0: PME# disabled
> pci 0000:00:08.0: reg 10 io port: [0x9f0-0x9f7]
> pci 0000:00:08.0: reg 14 io port: [0xbf0-0xbf3]
> pci 0000:00:08.0: reg 18 io port: [0x970-0x977]
> pci 0000:00:08.0: reg 1c io port: [0xb70-0xb73]
> pci 0000:00:08.0: reg 20 io port: [0xd800-0xd80f]
> pci 0000:00:08.0: reg 24 32bit mmio: [0xfe02c000-0xfe02cfff]
> pci 0000:00:08.1: reg 10 io port: [0x9e0-0x9e7]
> pci 0000:00:08.1: reg 14 io port: [0xbe0-0xbe3]
> pci 0000:00:08.1: reg 18 io port: [0x960-0x967]
> pci 0000:00:08.1: reg 1c io port: [0xb60-0xb63]
> pci 0000:00:08.1: reg 20 io port: [0xc400-0xc40f]
> pci 0000:00:08.1: reg 24 32bit mmio: [0xfe02b000-0xfe02bfff]
> pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:09.0: PME# disabled
> pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0b.0: PME# disabled
> pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0c.0: PME# disabled
> pci 0000:01:08.0: reg 10 io port: [0xbc00-0xbcff]
> pci 0000:01:08.0: reg 14 32bit mmio: [0x000000-0x0000ff]
> pci 0000:01:08.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
> pci 0000:00:04.0: transparent bridge
> pci 0000:00:04.0: bridge io port: [0xb000-0xbfff]
> pci 0000:00:04.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
> pci 0000:00:04.0: bridge 32bit mmio pref: [0xfde00000-0xfdefffff]
> pci 0000:02:00.0: reg 10 64bit mmio pref: [0xe0000000-0xefffffff]
> pci 0000:02:00.0: reg 18 64bit mmio: [0xfddf0000-0xfddfffff]
> pci 0000:02:00.0: reg 20 io port: [0xac00-0xacff]
> pci 0000:02:00.0: reg 30 32bit mmio pref: [0xfddc0000-0xfdddffff]
> pci 0000:02:00.0: supports D1 D2
> pci 0000:02:00.1: reg 10 64bit mmio: [0xfdde0000-0xfddeffff]
> pci 0000:02:00.1: supports D1 D2
> pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device. You can
> enable it with 'pcie_aspm=force'
> pci 0000:00:09.0: bridge io port: [0xa000-0xafff]
> pci 0000:00:09.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
> pci 0000:00:09.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
> pci 0000:03:00.0: reg 24 32bit mmio: [0xfdcfe000-0xfdcfffff]
> pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfdce0000-0xfdceffff]
> pci 0000:03:00.0: PME# supported from D3hot
> pci 0000:03:00.0: PME# disabled
> pci 0000:03:00.1: reg 10 io port: [0x9c00-0x9c07]
> pci 0000:03:00.1: reg 14 io port: [0x9800-0x9803]
> pci 0000:03:00.1: reg 18 io port: [0x9400-0x9407]
> pci 0000:03:00.1: reg 1c io port: [0x9000-0x9003]
> pci 0000:03:00.1: reg 20 io port: [0x8c00-0x8c0f]
> pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device. You can
> enable it with 'pcie_aspm=force'
> pci 0000:00:0b.0: bridge io port: [0x8000-0x9fff]
> pci 0000:00:0b.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
> pci 0000:00:0b.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
> pci 0000:00:0c.0: bridge io port: [0x7000-0x7fff]
> pci 0000:00:0c.0: bridge 32bit mmio: [0xfda00000-0xfdafffff]
> pci 0000:00:0c.0: bridge 64bit mmio pref: [0xfd900000-0xfd9fffff]
> vgaarb: device added:
> PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
> pci 0000:00:00.0: default IRQ router [10de:03ea]
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
> NetLabel:  protocols = UNLABELED CIPSOv4
> NetLabel:  unlabeled traffic allowed by default
> Switching to clocksource tsc
> Slow work thread pool: Starting up
> Slow work thread pool: Ready
> FS-Cache: Loaded
> CacheFiles: Loaded
> pnp: PnP ACPI: disabled
> PnPBIOS: Scanning system for PnP BIOS support...
> PnPBIOS: Found PnP BIOS installation structure at 0xc00fc6b0
> PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc6e0, dseg 0xf0000
> PnPBIOS: 12 nodes reported by PnP BIOS; 12 recorded by driver
> system 00:07: iomem range 0x0-0x9ffff could not be reserved
> system 00:07: iomem range 0xfffffffffffe0000-0xffffffffffffffff has
> been reserved
> system 00:07: iomem range 0xfffffffffec00000-0xfffffffffec0ffff has
> been reserved
> system 00:07: iomem range 0xfffffffffee00000-0xfffffffffeefffff has
> been reserved
> system 00:07: iomem range 0xfffffffffefff000-0xfffffffffefff3ff has
> been reserved
> system 00:07: iomem range 0x100000-0xffffff could not be reserved
> system 00:08: iomem range 0xf0000-0xf3fff could not be reserved
> system 00:08: iomem range 0xf4000-0xf7fff could not be reserved
> system 00:08: iomem range 0xf8000-0xfffff could not be reserved
> system 00:08: iomem range 0xd2800-0xd3fff has been reserved
> pci 0000:01:08.0: BAR 1: error updating (0xfdf00000 != 0xf9f00000)
> pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
> pci 0000:00:04.0:   IO window: 0xb000-0xbfff
> pci 0000:00:04.0:   MEM window: 0xfdf00000-0xfdffffff
> pci 0000:00:04.0:   PREFETCH window: 0xfde00000-0xfdefffff
> pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
> pci 0000:00:09.0:   IO window: 0xa000-0xafff
> pci 0000:00:09.0:   MEM window: 0xfdd00000-0xfddfffff
> pci 0000:00:09.0:   PREFETCH window:
> 0x000000e0000000-0x000000efffffff
> pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
> pci 0000:00:0b.0:   IO window: 0x8000-0x9fff
> pci 0000:00:0b.0:   MEM window: 0xfdc00000-0xfdcfffff
> pci 0000:00:0b.0:   PREFETCH window:
> 0x000000fdb00000-0x000000fdbfffff
> pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
> pci 0000:00:0c.0:   IO window: 0x7000-0x7fff
> pci 0000:00:0c.0:   MEM window: 0xfda00000-0xfdafffff
> pci 0000:00:0c.0:   PREFETCH window:
> 0x000000fd900000-0x000000fd9fffff
> pci 0000:00:04.0: setting latency timer to 64
> pci 0000:00:09.0: setting latency timer to 64
> pci 0000:00:0b.0: setting latency timer to 64
> pci 0000:00:0c.0: setting latency timer to 64
> pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
> pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
> pci_bus 0000:01: resource 1 mem: [0xfdf00000-0xfdffffff]
> pci_bus 0000:01: resource 2 pref mem [0xfde00000-0xfdefffff]
> pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
> pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
> pci_bus 0000:02: resource 0 io:  [0xa000-0xafff]
> pci_bus 0000:02: resource 1 mem: [0xfdd00000-0xfddfffff]
> pci_bus 0000:02: resource 2 pref mem [0xe0000000-0xefffffff]
> pci_bus 0000:03: resource 0 io:  [0x8000-0x9fff]
> pci_bus 0000:03: resource 1 mem: [0xfdc00000-0xfdcfffff]
> pci_bus 0000:03: resource 2 pref mem [0xfdb00000-0xfdbfffff]
> pci_bus 0000:04: resource 0 io:  [0x7000-0x7fff]
> pci_bus 0000:04: resource 1 mem: [0xfda00000-0xfdafffff]
> pci_bus 0000:04: resource 2 pref mem [0xfd900000-0xfd9fffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> pci 0000:02:00.0: Boot video device
> Machine check injector initialized
> elanfreq: error: no Elan processor found!
> cpufreq-nforce2: No nForce2 chipset.
> apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
> scx200: NatSemi SCx200 Driver
> microcode: CPU0: AMD CPU family 0xf not supported
> Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter
> Oruba
> Scanning for low memory corruption every 60 seconds
> audit: initializing netlink socket (disabled)
> type=2000 audit(1259814914.268:1): initialized
> highmem bounce pool size: 64 pages
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> DLM (built Dec  3 2009 03:09:28) installed
> squashfs: version 4.0 (2009/01/31) Phillip Lougher
> FS-Cache: Netfs 'nfs' registered for caching
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> NTFS driver 2.1.29 [Flags: R/W].
> EFS: 1.0a - http://aeschi.ch.eu.org/efs/
> JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
> ROMFS MTD (C) 2007 Red Hat, Inc.
> QNX4 filesystem 0.2.3 registered.
> fuse init (API version 7.13)
> JFS: nTxBlock = 8192, nTxLock = 65536
> SGI XFS with ACLs, security attributes, realtime, large block/inode
> numbers, no debug enabled
> SGI XFS Quota Management subsystem
> BeFS version: 0.9.3
> OCFS2 1.5.0
> ocfs2: Registered cluster interface o2cb
> ocfs2: Registered cluster interface user
> OCFS2 Node Manager 1.5.0
> OCFS2 DLM 1.5.0
> OCFS2 DLMFS 1.5.0
> OCFS2 User DLM kernel interface loaded
> Btrfs loaded
> GFS2 (built Dec  3 2009 03:11:14) installed
> msgmni has been set to 1588
> alg: No test for cipher_null (cipher_null-generic)
> alg: No test for ecb(cipher_null) (ecb-cipher_null)
> alg: No test for digest_null (digest_null-generic)
> alg: No test for compress_null (compress_null-generic)
> alg: No test for fcrypt (fcrypt-generic)
> alg: No test for stdrng (krng)
> async_tx: api initialized (async)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
> ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
> cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
> cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version:
> 0.1
> cpcihp_generic: not configured, disabling.
> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> mdacon: MDA with 8K of memory detected.
> Console: switching consoles 13-16 to MDA-2
> VIA Graphics Intergration Chipset framebuffer 2.4 initializing
> vmlfb: initializing
> Could not find Carillo Ranch MCH device.
> no IO addresses supplied
> hgafb: HGA card not detected.
> hgafb: probe of hgafb.0 failed with error -22
> uvesafb: failed to execute /sbin/v86d
> uvesafb: make sure that the v86d helper is installed and executable
> uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
> uvesafb: vbe_init() failed with -22
> uvesafb: probe of uvesafb.0 failed with error -22
> vesafb: framebuffer at 0xe0000000, mapped to 0xf8580000, using
> 3072k, total 16384k
> vesafb: mode is 1024x768x16, linelength=2048, pages=9
> vesafb: protected mode interface info at c000:a2da
> vesafb: pmi: set display start = c00ca362, set palette = c00ca41e
> vesafb: scrolling: redraw
> vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> Console: switching to colour frame buffer device 128x48
> fb0: VESA VGA frame buffer device
> vga16fb: initializing
> vga16fb: mapped to 0xc00a0000
> fb1: VGA16 VGA frame buffer device
> isapnp: Scanning for PnP cards...
> isapnp: No Plug & Play device found
> Non-volatile memory driver v1.3
> toshiba: not a supported Toshiba laptop
> Linux agpgart interface v0.103
> [drm] Initialized drm 1.1.0 20060810
> [drm] radeon defaulting to userspace modesetting.
> pci 0000:02:00.0: setting latency timer to 64
> [drm] Initialized radeon 1.31.0 20080528 for 0000:02:00.0 on minor 0
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> parport_pc 00:0d: reported by Plug and Play BIOS
> parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> floppy0: no floppy controllers found
> brd: module loaded
> loop: module loaded
> ------------[ cut here ]------------
> WARNING: at mm/page_alloc.c:1805
> __alloc_pages_nodemask+0x127/0x48f()
> Hardware name: System Product Name
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.32-rc8-git5 #1
> Call Trace:
>  [<c103d94b>] warn_slowpath_common+0x65/0x95
>  [<c103d98d>] warn_slowpath_null+0x12/0x15
>  [<c109550c>] __alloc_pages_nodemask+0x127/0x48f
>  [<c10be964>] ? get_slab+0x8/0x50
>  [<c10b8979>] alloc_page_interleave+0x2e/0x6e
>  [<c10b8a10>] alloc_pages_current+0x57/0x99
>  [<c2083a4a>] ? xd_init+0x0/0x482
>  [<c1094c38>] __get_free_pages+0xd/0x1e
>  [<c2083a94>] xd_init+0x4a/0x482
>  [<c2082df0>] ? loop_init+0x104/0x16a
>  [<c169162d>] ? loop_probe+0x0/0xaf
>  [<c2083a4a>] ? xd_init+0x0/0x482
>  [<c1001143>] do_one_initcall+0x51/0x13f
>  [<c204a307>] kernel_init+0x10b/0x15f
>  [<c204a1fc>] ? kernel_init+0x0/0x15f
>  [<c1004347>] kernel_thread_helper+0x7/0x10
> ---[ end trace 686db6333ade6e7a ]---
> xd: Out of memory.
> Compaq SMART2 Driver (v 2.6.0)
> HP CISS Driver (v 3.6.20)
> MM: desc_per_page = 128
> nbd: registered device at major 43
> usbcore: registered new interface driver ub
> ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> Phantom Linux Driver, version n0.9.8, init OK
> Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> c2port c2port0: C2 port uc added
> c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes
> total)
> input: Macintosh mouse button emulation as
> /devices/virtual/input/input0
> Uniform Multi-Platform E-IDE driver
> amd74xx 0000:00:06.0: UDMA133 controller
> amd74xx 0000:00:06.0: IDE controller (0x10de:0x03ec rev 0xa2)
> amd74xx 0000:00:06.0: IDE port disabled
> amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. Enabling
> workaround.
> amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xf000-0xf007
> Probing IDE interface ide0...
> hda: Hitachi HDT725050VLAT80, ATA DISK drive
> hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/133 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 0x03)
> JMicron IDE 0000:03:00.1: enabling device (0000 -> 0001)
> JMicron IDE 0000:03:00.1: can't find IRQ for PCI INT B; please try
> using pci=biosirq
> jmicron 0000:03:00.1: bad irq (0): will probe later
> JMicron IDE 0000:03:00.1: setting latency timer to 64
>     ide1: BM-DMA at 0x8c00-0x8c07
>     ide2: BM-DMA at 0x8c08-0x8c0f
> Probing IDE interface ide1...
> Probing IDE interface ide2...
> ide1: disabled, no IRQ
> ide1: failed to initialize IDE interface
> ide1: disabling port
> ide2: disabled, no IRQ
> ide2: failed to initialize IDE interface
> ide2: disabling port
> JMicron IDE: probe of 0000:03:00.1 failed with error -1
> ide_generic: please use "probe_mask=0x3f" module parameter for
> probing all legacy ISA IDE ports
> ide-gd driver 1.18
> hda: max request size: 512KiB
> hda: 976773168 sectors (500107 MB) w/7372KiB Cache, CHS=60801/255/63
> hda: cache flushes supported
>  hda: hda2 hda3 hda4
> ide-cd driver 5.00
> Loading iSCSI transport class v2.0-870.
> rdac: device handler registered
> hp_sw: device handler registered
> emc: device handler registered
> alua: device handler registered
> fnic: Cisco FCoE HBA Driver, ver 1.0.0.1121
> iscsi: registered transport (tcp)
> Loading Adaptec I2O RAID: Version 2.4 Build 5go
> Detecting Adaptec I2O RAID controllers...
> Adaptec aacraid driver 1.1-5[2461]-ms
> aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
> scsi: <fdomain> Detection failed (no card)
> NCR53c406a: no available ports found
> sym53c416.c: Version 1.0.0-ac
> qlogicfas: no cards were found, please specify I/O address and IRQ
> using iobase= and irq= options
> QLogic Fibre Channel HBA Driver: 8.03.01-k6
> iscsi: registered transport (qla4xxx)
> QLogic iSCSI HBA Driver
> Emulex LightPulse Fibre Channel SCSI driver 8.3.4
> Copyright(c) 2004-2009 Emulex.  All rights reserved.
> Brocade BFA FC/FCOE SCSI driver - version: 2.0.0.0
> Failed initialization of WD-7000 SCSI card!
> DC390: clustering now enabled by default. If you get problems load
>        with "disable_clustering=1" and report to maintainers
> megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
> mpt2sas version 02.100.03.00 loaded
> GDT-HA: Storage RAID Controller Driver. Version: 3.05
> 3ware Storage Controller device driver for Linux v1.26.02.002.
> 3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
> ppa: Version 2.07 (for Linux 2.4.x)
> imm: Version 2.05 (for Linux 2.4.0)
> nsp32: loading...
> ipr: IBM Power RAID SCSI Device Driver version: 2.4.3 (June 10,
> 2009)
> RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
> stex: Promise SuperTrak EX Driver version: 4.6.0000.3
> cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
> iscsi: registered transport (cxgb3i)
> Broadcom NetXtreme II iSCSI Driver bnx2i v2.0.1e (June 22, 2009)
> iscsi: registered transport (bnx2i)
> iscsi: registered transport (be2iscsi)
> st: Version 20081215, fixed bufsize 32768, s/g segs 256
> osst :I: Tape driver with OnStream support version 0.99.4
> osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> SCSI Media Changer driver v0.25
> osd: LOADED open-osd 0.1.0
> ahci 0000:03:00.0: version 3.0
> ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl
> SATA mode
> ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
> ahci 0000:03:00.0: setting latency timer to 64
> scsi2 : ahci
> scsi3 : ahci
> ata1: SATA max UDMA/133 abar m8192@0xfdcfe000 port 0xfdcfe100 irq 5
> ata2: SATA max UDMA/133 abar m8192@0xfdcfe000 port 0xfdcfe180 irq 5
> sata_nv 0000:00:08.0: version 3.5
> sata_nv 0000:00:08.0: setting latency timer to 64
> scsi4 : sata_nv
> scsi5 : sata_nv
> ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 10
> ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 10
> sata_nv 0000:00:08.1: setting latency timer to 64
> scsi6 : sata_nv
> scsi7 : sata_nv
> ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 11
> ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 11
> pata_jmicron 0000:03:00.1: BAR 0: can't reserve I/O region
> [0x9c00-0x9c07]
> pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 0
> (errno=-16)
> pata_jmicron 0000:03:00.1: BAR 2: can't reserve I/O region
> [0x9400-0x9407]
> pata_jmicron 0000:03:00.1: failed to request/iomap BARs for port 1
> (errno=-16)
> pata_jmicron 0000:03:00.1: no available native port
> Error: Driver 'pata_platform' is already registered, aborting...
> pata_acpi 0000:03:00.1: BAR 0: can't reserve I/O region
> [0x9c00-0x9c07]
> pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 0
> (errno=-16)
> pata_acpi 0000:03:00.1: BAR 2: can't reserve I/O region
> [0x9400-0x9407]
> pata_acpi 0000:03:00.1: failed to request/iomap BARs for port 1
> (errno=-16)
> pata_acpi 0000:03:00.1: no available native port
> SSFDC read-only Flash Translation layer
> L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot
> continue
> device id = 2440
> device id = 2480
> device id = 24c0
> device id = 24d0
> device id = 25a1
> device id = 2670
> physmap-flash.0: failed to claim resource 0
> SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
> Could not find PAR responsible for SC520CDP Flash Bank #0
> Trying default address 0x8400000
> Could not find PAR responsible for SC520CDP Flash Bank #1
> Trying default address 0x8c00000
> Could not find PAR responsible for SC520CDP DIL Flash
> Trying default address 0x9400000
> SC520 CDP flash device: 0x800000 at 0x8400000
> Failed to ioremap_nocache
> NetSc520 flash device: 0x100000 at 0x200000
> Failed to ioremap_nocache
> Failed to ioremap_nocache
> scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
> SNAPGEAR: failed to ioremap() BOOTCS
> Generic platform RAM MTD, (c) 2004 Simtec Electronics
> No recognised DiskOnChip devices found
> slram: not enough parameters.
> Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel
> Networks.
> pmc551: not detected
> ftl_cs: FTL header not found.
> No valid DiskOnChip devices found
> NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 8MiB
> 1,8V 8-bit)
> flash size: 8 MiB
> page size: 512 bytes
> OOB area size: 16 bytes
> sector size: 8 KiB
> pages number: 16384
> pages per sector: 16
> bus width: 8
> bits in sector size: 13
> bits in page size: 9
> bits in OOB size: 4
> flash size with OOB: 8448 KiB
> page address bytes: 3
> sector address bytes: 2
> options: 0x62
> Scanning device for bad blocks
> Creating 1 MTD partitions on "NAND 8MiB 1,8V 8-bit":
> 0x000000000000-0x000000800000 : "NAND simulator partition 0"
> ftl_cs: FTL header not found.
> usbcore: registered new interface driver alauda
> OneNAND Manufacturer: Samsung (0xec)
> OneNAND 16MB 1.8V 16-bit (0x04)
> OneNAND version = 0x001e
> Lock scheme is Continuous Lock
> Scanning device for bad blocks
> Creating 1 MTD partitions on "OneNAND simulator":
> 0x000000000000-0x000001000000 : "OneNAND simulator partition"
> ftl_cs: FTL header not found.
> Fixed MDIO Bus: probed
> Atheros(R) L2 Ethernet Driver - version 2.2.3
> Copyright (c) 2007 Atheros Corporation.
> e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> Broadcom NetXtreme II CNIC Driver cnic v2.0.1 (Oct 01, 2009)
> D-Link DE-620 pocket adapter io 0x378, which is busy.
> PPP generic driver version 2.4.2
> PPP Deflate Compression module registered
> PPP BSD Compression module registered
> PPP MPPE Compression module registered
> NET: Registered protocol family 24
> PPPoL2TP kernel driver, V1.0
> SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6
> bit encapsulation enabled).
> CSLIP: code copyright 1989 Regents of the University of California.
> SLIP linefill/keepalive option.
> DE600: port 0x378 busy
> atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
> I2O subsystem v1.325
> i2o: max drivers = 8
> I2O Configuration OSM v1.323
> I2O Bus Adapter OSM v1.317
> I2O Block Device OSM v1.325
> I2O SCSI Peripheral OSM v1.316
> I2O ProcFS OSM v1.316
> Fusion MPT base driver 3.04.12
> Copyright (c) 1999-2008 LSI Corporation
> Fusion MPT SPI Host driver 3.04.12
> Fusion MPT FC Host driver 3.04.12
> Fusion MPT SAS Host driver 3.04.12
> Fusion MPT misc device (ioctl) driver 3.04.12
> mptctl: Registered with Fusion MPT base driver
> mptctl: /dev/mptctl @ (major,minor=10,220)
> Fusion MPT LAN driver 3.04.12
> video1394: Installed video1394 module
> ieee1394: raw1394: /dev/raw1394 device initialized
> Intel ISA PCIC probe: not found.
> Databook TCIC-2 PCMCIA probe: not found.
> aoe: AoE v47 initialised.
> paride: aten registered as protocol 0
> paride: bpck registered as protocol 1
> paride: comm registered as protocol 2
> paride: dstr registered as protocol 3
> paride: k951 registered as protocol 4
> paride: k971 registered as protocol 5
> paride: epat registered as protocol 6
> paride: epia registered as protocol 7
> paride: frpw registered as protocol 8
> paride: friq registered as protocol 9
> paride: fit2 registered as protocol 10
> paride: fit3 registered as protocol 11
> paride: on20 registered as protocol 12
> paride: on26 registered as protocol 13
> paride: ktti registered as protocol 14
> bpck6: BACKPACK Protocol Driver V2.0.2
> bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. USA
> paride: bpck6 registered as protocol 15
> pd: pd version 1.05, major 45, cluster 64, nice 0
> Clocksource tsc unstable (delta = 479803194 ns)
> pda: Autoprobe failed
> pd: no valid drive found
> pcd: pcd version 1.07, major 46, nice 0
> pcd0: Autoprobe failed
> pcd: No CD-ROM drive found
> pf: pf version 1.04, major 47, cluster 64, nice 0
> pf: No ATAPI disk detected
> pt: pt version 1.04, major 96
> pt0: Autoprobe failed
> pt: No ATAPI tape drive detected
> pg: pg version 1.02, major 97
> pga: Autoprobe failed
> pg: No ATAPI device detected
> Switching to clocksource pit
> usbcore: registered new interface driver hwa-rc
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci_hcd 0000:00:02.1: setting latency timer to 64
> ehci_hcd 0000:00:02.1: EHCI Host Controller
> ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:02.1: debug port 1
> ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
> ehci_hcd 0000:00:02.1: irq 10, io mem 0xfe02e000
> ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.32-rc8-git5 ehci_hcd
> usb usb1: SerialNumber: 0000:00:02.1
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 10 ports detected
> 116x: driver isp116x-hcd, 03 Nov 2005
> driver isp1362-hcd, 2005-04-04
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci_hcd 0000:00:02.0: setting latency timer to 64
> ohci_hcd 0000:00:02.0: OHCI Host Controller
> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:02.0: irq 5, io mem 0xfe02f000
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: OHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.32-rc8-git5 ohci_hcd
> usb usb2: SerialNumber: 0000:00:02.0
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 10 ports detected
> uhci_hcd: USB Universal Host Controller Interface driver
> sl811: driver sl811-hcd, 19 May 2005
> r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
> usbcore: registered new interface driver hwa-hc
> usbcore: registered new interface driver wusb-cbaf
> usbcore: registered new interface driver cdc_acm
> cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and
> ISDN adapters
> usbcore: registered new interface driver usblp
> usbcore: registered new interface driver cdc_wdm
> Initializing USB Mass Storage driver...
> ata5: SATA link down (SStatus 0 SControl 300)
> ata1: SATA link down (SStatus 0 SControl 300)
> ata2: SATA link down (SStatus 0 SControl 300)
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usbcore: registered new interface driver ums-alauda
> usbcore: registered new interface driver ums-cypress
> usbcore: registered new interface driver ums-datafab
> usbcore: registered new interface driver ums-freecom
> usbcore: registered new interface driver ums-isd200
> usbcore: registered new interface driver ums-jumpshot
> usbcore: registered new interface driver ums-karma
> usbcore: registered new interface driver ums-onetouch
> usbcore: registered new interface driver ums-sddr09
> usbcore: registered new interface driver ums-sddr55
> usbcore: registered new interface driver ums-usbat
> PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
> PNP: PS/2 appears to have AUX port disabled, if this is incorrect
> please boot with i8042.nopnp
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: PARKBD AT adapter on parport0
> mice: PS/2 mouse device common for all mice
> usbcore: registered new interface driver appletouch
> usbcore: registered new interface driver bcm5974
> inport.c: Didn't find InPort mouse at 0x23c
> logibm.c: Didn't find Logitech busmouse at 0x23c
> usbcore: registered new interface driver usb_acecad
> acecad: v3.2:USB Acecad Flair tablet driver
> usbcore: registered new interface driver aiptek
> aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux
> 2.6.x)
> aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
> usbcore: registered new interface driver gtco
> GTCO usb driver version: 2.00.0006
> usbcore: registered new interface driver kbtab
> kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
> usbcore: registered new interface driver wacom
> wacom: v1.51:USB Wacom Graphire and Wacom Intuos tablet driver
> input: PC Speaker as /devices/platform/pcspkr/input/input1
> i2c /dev entries driver
> input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input2
> Linux video capture interface: v2.00
> usbcore: registered new interface driver dabusb
> dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
> md: linear personality registered for level -1
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> md: raid10 personality registered for level 10
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> md: multipath personality registered for level -4
> md: faulty personality registered for level -5
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:
> dm-devel@redhat.com
> device-mapper: multipath: version 1.1.0 loaded
> device-mapper: multipath round-robin: version 1.0.0 loaded
> EDAC MC: Ver: 2.1.0 Dec  3 2009
> EISA: Probing bus 0 at eisa.0
> Cannot allocate resource for EISA slot 1
> Cannot allocate resource for EISA slot 7
> Cannot allocate resource for EISA slot 8
> EISA: Detected 0 cards.
> cpuidle: using governor ladder
> sdhci: Secure Digital Host Controller Interface driver
> sdhci: Copyright(c) Pierre Ossman
> ricoh-mmc: Ricoh MMC Controller disabling driver
> ricoh-mmc: Copyright(c) Philip Langdale
> wbsd: Winbond W83L51xD SD/MMC card interface driver
> wbsd: Copyright(c) Pierre Ossman
> via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies,
> Inc.
> usbcore: registered new interface driver hiddev
> usbcore: registered new interface driver usbhid
> usbhid: v2.6:USB HID core driver
> dell-wmi: No known WMI GUID found
> oprofile: using timer interrupt.
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 17
> NET: Registered protocol family 33
> lib80211: common routines for IEEE802.11 drivers
> lib80211_crypt: registered algorithm 'NULL'
> lib80211_crypt: registered algorithm 'WEP'
> lib80211_crypt: registered algorithm 'CCMP'
> lib80211_crypt: registered algorithm 'TKIP'
> powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4800+
> processors (1 cpu cores) (version 2.20.00)
> [Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
> Using IPI No-Shortcut mode
> ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata3.00: ATA-7: SAMSUNG HD753LJ, 1AA01104, max UDMA7
> ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata3.00: configured for UDMA/133
> scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ 1AA0 PQ: 0
> ANSI: 5
> sd 4:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698
> GiB)
> sd 4:0:0:0: [sda] Write Protect is off
> sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda:
> sd 4:0:0:0: Attached scsi generic sg0 type 0
>  sda1 sda3 sda4
> sd 4:0:0:0: [sda] Attached SCSI disk
> usb 1-5: new high speed USB device using ehci_hcd and address 4
> usb 1-5: New USB device found, idVendor=0bda, idProduct=8187
> usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-5: Product: RTL8187_Wireless
> usb 1-5: Manufacturer: Manufacturer_Realtek_RTL8187_
> usb 1-5: SerialNumber: 0015AF2347F2
> usb 1-5: configuration #1 chosen from 1 choice
> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-H66N, CB00, max UDMA/100
> ata4.00: configured for UDMA/100
> scsi 5:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H66N CB00 PQ: 0
> ANSI: 5
> sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda
> tray
> Uniform CD-ROM driver Revision: 3.20
> sr 5:0:0:0: Attached scsi CD-ROM sr0
> sr 5:0:0:0: Attached scsi generic sg1 type 5
> usb 2-2: new full speed USB device using ohci_hcd and address 2
> usb 2-2: device descriptor read/64, error -62
> ata6: SATA link down (SStatus 0 SControl 300)
> kAFS: Red Hat AFS client v0.1 registering.
> raid6test: testing the 4-disk case...
> raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D) OK
> raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P) OK
> raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q) OK
> raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P) OK
> raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q) OK
> raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q) OK
> raid6test: testing the 5-disk case...
> raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D) OK
> raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D) OK
> raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P) OK
> raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q) OK
> raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D) OK
> raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P) OK
> raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q) OK
> raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P) OK
> raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q) OK
> raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q) OK
> raid6test: testing the 16-disk case...
> raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D) OK
> raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D) OK
> raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D) OK
> raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D) OK
> raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D) OK
> raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D) OK
> raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D) OK
> raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D) OK
> raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D) OK
> raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D) OK
> raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D) OK
> raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D) OK
> raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D) OK
> raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P) OK
> raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q) OK
> raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D) OK
> raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D) OK
> raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D) OK
> raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D) OK
> raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D) OK
> raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D) OK
> raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D) OK
> raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D) OK
> raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D) OK
> raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D) OK
> raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D) OK
> raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D) OK
> raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P) OK
> raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q) OK
> raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D) OK
> raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D) OK
> raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D) OK
> raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D) OK
> raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D) OK
> raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D) OK
> raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D) OK
> raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D) OK
> raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D) OK
> raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D) OK
> raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D) OK
> raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P) OK
> raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q) OK
> raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D) OK
> raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D) OK
> raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D) OK
> raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D) OK
> raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D) OK
> raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D) OK
> raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D) OK
> raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D) OK
> raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D) OK
> raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D) OK
> raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P) OK
> raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q) OK
> raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D) OK
> raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D) OK
> raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D) OK
> raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D) OK
> raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D) OK
> raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D) OK
> raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D) OK
> raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D) OK
> raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D) OK
> raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P) OK
> raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q) OK
> raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D) OK
> raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D) OK
> raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D) OK
> raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D) OK
> raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D) OK
> raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D) OK
> raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D) OK
> raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D) OK
> raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P) OK
> raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q) OK
> raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D) OK
> raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D) OK
> raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D) OK
> raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D) OK
> raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D) OK
> raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D) OK
> raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D) OK
> raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P) OK
> raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q) OK
> raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D) OK
> raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D) OK
> raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D) OK
> raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D) OK
> raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D) OK
> raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D) OK
> raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P) OK
> raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q) OK
> raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D) OK
> raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D) OK
> raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D) OK
> raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D) OK
> raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D) OK
> raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P) OK
> raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q) OK
> raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D) OK
> raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D) OK
> raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D) OK
> raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D) OK
> raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P) OK
> raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q) OK
> raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D) OK
> raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D) OK
> raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D) OK
> raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P) OK
> raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q) OK
> raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D) OK
> raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D) OK
> raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P) OK
> raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q) OK
> raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D) OK
> raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P) OK
> raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q) OK
> raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P) OK
> raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q) OK
> raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q) OK
> raid6test:
> raid6test: complete (136 tests, 0 failures)
> register_blkdev: cannot get major 3 for hd
> BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> usb 2-2: device descriptor read/64, error -62
> devtmpfs: mounted
> Freeing unused kernel memory: 852k freed
> usb 2-2: new full speed USB device using ohci_hcd and address 3
> usb 2-2: device descriptor read/64, error -62
> usb 2-2: device descriptor read/64, error -62
> usb 2-2: new full speed USB device using ohci_hcd and address 4
> usb 2-2: device not accepting address 4, error -62
> usb 2-2: new full speed USB device using ohci_hcd and address 5
> usb 2-2: device not accepting address 5, error -62
> hub 2-0:1.0: unable to enumerate USB device on port 2
> usb 2-4: new low speed USB device using ohci_hcd and address 6
> usb 2-4: New USB device found, idVendor=05e3, idProduct=1205
> usb 2-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> usb 2-4: Product: USB Mouse
> usb 2-4: configuration #1 chosen from 1 choice
> input: USB Mouse               as
> /devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.0/input/input3
> generic-usb 0003:05E3:1205.0001: input,hidraw0: USB HID v1.10 Mouse
> [USB Mouse              ] on usb-0000:00:02.0-4/input0
> forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
> forcedeth 0000:00:07.0: setting latency timer to 64
> forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x50ef @ 1, addr
> 00:1d:60:19:59:cc
> forcedeth 0000:00:07.0: highdma pwrctl mgmt gbit lnktim msi desc-v3
> i2c i2c-0: nForce2 SMBus adapter at 0x1c00
> i2c i2c-1: nForce2 SMBus adapter at 0x1c40
> k8temp 0000:00:18.3: Temperature readouts might be wrong - check
> erratum #141
> 8139too Fast Ethernet driver 0.9.28
> 8139too 0000:01:08.0: Chip not responding, ignoring board
> 8139too: probe of 0000:01:08.0 failed with error -5
> cfg80211: Using static regulatory domain info
> cfg80211: Regulatory domain: US
> 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> cfg80211: Calling CRDA for country: US
> Driver 'rtc_cmos' needs updating - please use bus_type methods
> rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one day, 114 bytes nvram
> HDA Intel 0000:00:05.0: setting latency timer to 64
> phy0: Selected rate control algorithm 'minstrel'
> phy0: hwaddr 00:15:af:23:47:f2, RTL8187vB (default) V1 + rtl8225z2
> rtl8187: Customer ID is 0x00
> Registered led device: rtl8187-phy0::tx
> Registered led device: rtl8187-phy0::rx
> rtl8187: wireless switch is on
> usbcore: registered new interface driver rtl8187
> hda_codec: AD1988: BIOS auto-probing.
> input: HDA Digital PCBeep as
> /devices/pci0000:00/0000:00:05.0/input/input4
> EXT3 FS on sda1, internal journal
> parport0: no more devices allowed
> lp: driver loaded but no devices found
> usbcore: registered new interface driver uvcvideo
> USB Video Class driver (v0.1.0)
> rt2860sta: module is from the staging directory, the quality is
> unknown, you have been warned.
> usbcore: registered new interface driver snd-usb-audio
> ---
> Professional hosting for everyone - http://www.host.ru
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
