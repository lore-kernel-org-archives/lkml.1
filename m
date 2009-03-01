Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZCANsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZCANsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 08:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbZCANsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 08:48:22 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46188 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbZCANsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 08:48:18 -0500
Date: Sun, 1 Mar 2009 13:48:09 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [TIP,regression,i915] /dev/dri/card0 is no longer present
Message-ID: <20090301134809.GA4753@silver.sucs.org>
References: <20090301110455.GA18547@silver.sucs.org> <20090301113948.GA3602@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301113948.GA3602@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 12:39:48PM +0100, Ingo Molnar wrote:
> 
> Thanks, i've reverted the commit for now. Could you please send 
> a 'dmesg' from the bootup with the failed driver? By all 
> likelyhood an ioremap failure causes a driver failure.
> 

See below (drm says it initalized though...):

[    0.000000] Linux version 2.6.29-rc6-00006-g17581ad (@verona) (gcc version 4.2.4) #87 Sun Mar 1 13:42:28 GMT 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] PAT WC disabled due to known CPU erratum.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f780000 (usable)
[    0.000000]  BIOS-e820: 000000003f780000 - 000000003f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f790000 - 000000003f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f7d0000 - 000000003f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000003f7e0000 - 000000003f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x3f780 max_arch_pfn = 0x100000
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] total RAM coverred: 1016M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000090c00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003f780000 (usable)
[    0.000000]  modified: 000000003f780000 - 000000003f790000 (ACPI data)
[    0.000000]  modified: 000000003f790000 - 000000003f7d0000 (ACPI NVS)
[    0.000000]  modified: 000000003f7d0000 - 000000003f7de000 (reserved)
[    0.000000]  modified: 000000003f7e0000 - 000000003f800000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] RAMDISK: 37d91000 - 37fefdae
[    0.000000] Allocated new RAMDISK: 00a04000 - 00c62dae
[    0.000000] Move RAMDISK from 0000000037d91000 - 0000000037fefdad to 00a04000 - 00c62dad
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3F780000, 0034 (r1 A M I  OEMRSDT   9000811 MSFT       97)
[    0.000000] ACPI: FACP 3F780200, 0081 (r1 A M I  OEMFACP   9000811 MSFT       97)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 3F780400, 6109 (r1  A0979 A0979034       34 INTL 20060113)
[    0.000000] ACPI: FACS 3F790000, 0040
[    0.000000] ACPI: APIC 3F780390, 0068 (r1 A M I  OEMAPIC   9000811 MSFT       97)
[    0.000000] ACPI: OEMB 3F790040, 0046 (r1 A M I  AMI_OEM   9000811 MSFT       97)
[    0.000000] ACPI: MCFG 3F786510, 003C (r1 A M I  OEMMCFG   9000811 MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00011000 - 00017f00
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 00009ff9d8]    TEXT DATA BSS ==> [0000100000 - 00009ff9d8]
[    0.000000]   #2 [0000a00000 - 0000a04000]    INIT_PG_TABLE ==> [0000a00000 - 0000a04000]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #5 [0000a04000 - 0000c62dae]      NEW RAMDISK ==> [0000a04000 - 0000c62dae]
[    0.000000]   #6 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x00000090
[    0.000000]     0: 0x00000100 -> 0x0003f780
[    0.000000] On node 0 totalpages: 259841
[    0.000000] free_area_init_node: node 0, pgdat c053c140, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3937 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 256 pages used for memmap
[    0.000000]   HighMem zone: 32386 pages, LIFO batch:7
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f800000:bf600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257809
[    0.000000] Kernel command line: root=UUID=c5c3ceba-1491-47bb-ae0c-04aee21a1a60 cfg80211.ieee80211_regdom=EU pcie_aspm=force pcie_aspm.policy=powersave ro splash slub_debug=- kmemcheck=0
[    0.000000] PCIe ASPM is forcedly enabled
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 900.120 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        8191
[    0.000999] ... CLASSHASH_SIZE:          4096
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000999] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000999] ... CHAINHASH_SIZE:          8192
[    0.000999]  memory used by lock dependency info: 2335 kB
[    0.000999]  per task-struct memory footprint: 1152 bytes
[    0.000999] ------------------------
[    0.000999] | Locking API testsuite:
[    0.000999] ----------------------------------------------------------------------------
[    0.000999]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000999]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000999]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000999]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000999]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq read-recursion/123:  ok  |
[    0.000999]       soft-irq read-recursion/123:  ok  |
[    0.000999]       hard-irq read-recursion/132:  ok  |
[    0.000999]       soft-irq read-recursion/132:  ok  |
[    0.000999]       hard-irq read-recursion/213:  ok  |
[    0.000999]       soft-irq read-recursion/213:  ok  |
[    0.000999]       hard-irq read-recursion/231:  ok  |
[    0.000999]       soft-irq read-recursion/231:  ok  |
[    0.000999]       hard-irq read-recursion/312:  ok  |
[    0.000999]       soft-irq read-recursion/312:  ok  |
[    0.000999]       hard-irq read-recursion/321:  ok  |
[    0.000999]       soft-irq read-recursion/321:  ok  |
[    0.000999] -------------------------------------------------------
[    0.000999] Good, all 218 testcases passed! |
[    0.000999] ---------------------------------
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 1018452k/1039872k available (3029k kernel code, 20644k reserved, 1345k data, 288k init, 130568k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff9e000 - 0xfffff000   ( 388 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc0548000 - 0xc0590000   ( 288 kB)
[    0.000999]       .data : 0xc03f564b - 0xc0545b50   (1345 kB)
[    0.000999]       .text : 0xc0100000 - 0xc03f564b   (3029 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000999] ODEBUG: selftest passed
[    0.001031] Calibrating delay loop (skipped), value calculated using timer frequency.. 1800.24 BogoMIPS (lpj=900120)
[    0.001223] Security Framework initialized
[    0.001337] Mount-cache hash table entries: 512
[    0.003019] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003137] CPU: L2 cache: 512K
[    0.003207] [ds] using Pentium M configuration
[    0.003280] [ds] pebs not available
[    0.003353] Intel machine check architecture supported.
[    0.003432] Intel machine check reporting enabled on CPU#0.
[    0.003518] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.003682] Checking 'hlt' instruction... OK.
[    0.007916] Freeing SMP alternatives: 0k freed
[    0.008008] ACPI: Core revision 20081204
[    0.034507] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045573] net_namespace: 384 bytes
[    0.045897] Time: 13:43:40  Date: 03/01/09
[    0.046297] NET: Registered protocol family 16
[    0.048902] ACPI: bus type pci registered
[    0.049124] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.049208] PCI: Not using MMCONFIG.
[    0.049493] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.049572] PCI: Using configuration type 1 for base access
[    0.072000] bio: create slab <bio-0> at 0
[    0.078774] ACPI: EC: Look up EC in DSDT
[    0.113491] ACPI: Interpreter enabled
[    0.113577] ACPI: (supports S0 S1 S3 S5)
[    0.113929] ACPI: Using IOAPIC for interrupt routing
[    0.114172] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.120944] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.120988] PCI: Using MMCONFIG for extended config space
[    0.152387] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.152475] ACPI: EC: driver started in poll mode
[    0.153511] ACPI: No dock devices found.
[    0.153822] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.154557] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.154572] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.154586] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.154600] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.154712] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.154950] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.155071] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.155158] pci 0000:00:1b.0: PME# disabled
[    0.155370] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.155453] pci 0000:00:1c.0: PME# disabled
[    0.155668] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.155751] pci 0000:00:1c.1: PME# disabled
[    0.155967] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.156067] pci 0000:00:1c.2: PME# disabled
[    0.156253] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.156370] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.156484] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.156597] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.156718] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.156834] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.156988] pci 0000:00:1d.7: PME# disabled
[    0.157326] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.157339] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.157447] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.157534] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 0380-038f
[    0.157681] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.157696] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.157710] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.157725] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.157739] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.157801] pci 0000:00:1f.2: PME# supported from D3hot
[    0.157881] pci 0000:00:1f.2: PME# disabled
[    0.158072] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.158338] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.158403] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.158478] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.158562] pci 0000:03:00.0: PME# disabled
[    0.160295] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.160415] pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
[    0.160990] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.161005] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.161109] pci 0000:00:1e.0: transparent bridge
[    0.161245] pci_bus 0000:00: on NUMA node 0
[    0.161273] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.162093] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.162296] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.162481] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.191578] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.192598] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.193679] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.194715] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.195708] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.196775] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.197883] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.199003] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.201477] SCSI subsystem initialized
[    0.201670] libata version 3.00 loaded.
[    0.202272] usbcore: registered new interface driver usbfs
[    0.202541] usbcore: registered new interface driver hub
[    0.202879] usbcore: registered new device driver usb
[    0.204272] PCI: Using ACPI for IRQ routing
[    0.211441] cfg80211: Using static regulatory domain info
[    0.211523] cfg80211: Regulatory domain: EU
[    0.211596] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.211699] 	(2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.211781] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.211863] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.211944] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.211976] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.212058] 	(5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.212628] hpet clockevent registered
[    0.212635] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.212723] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.212987] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.220001] pnp: PnP ACPI init
[    0.220146] ACPI: bus type pnp registered
[    0.230631] pnp: PnP ACPI: found 13 devices
[    0.230711] ACPI: ACPI bus type pnp unregistered
[    0.230829] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.230945] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.231041] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.231123] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.231204] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.231286] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.231370] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.231487] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.231614] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.231698] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.231800] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.231909] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.232026] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.232111] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.232196] system 00:0c: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.269218] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.269304] pci 0000:00:1c.0:   IO window: disabled
[    0.269387] pci 0000:00:1c.0:   MEM window: disabled
[    0.269467] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.269553] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.269630] pci 0000:00:1c.1:   IO window: disabled
[    0.269712] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.269795] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.269881] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.269967] pci 0000:00:1c.2:   IO window: disabled
[    0.270049] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.270135] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.270248] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.270325] pci 0000:00:1e.0:   IO window: disabled
[    0.270406] pci 0000:00:1e.0:   MEM window: disabled
[    0.270486] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.270602] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.270689] pci 0000:00:1c.0: setting latency timer to 64
[    0.270712] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.270797] pci 0000:00:1c.1: setting latency timer to 64
[    0.270820] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.270905] pci 0000:00:1c.2: setting latency timer to 64
[    0.270921] pci 0000:00:1e.0: setting latency timer to 64
[    0.270931] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.270936] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.270942] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    0.270947] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    0.270960] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    0.270964] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.270969] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.270975] pci_bus 0000:03: resource 1 mem: [0xfbf00000-0xfbffffff]
[    0.270980] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.270984] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.270989] pci_bus 0000:01: resource 0 mem: [0x0-0x0]
[    0.270994] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbefffff]
[    0.271000] pci_bus 0000:01: resource 2 mem: [0xf0000000-0xf6ffffff]
[    0.271005] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.271010] pci_bus 0000:05: resource 0 mem: [0x0-0x0]
[    0.271015] pci_bus 0000:05: resource 1 mem: [0x0-0x0]
[    0.271019] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    0.271024] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.271029] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
[    0.271102] NET: Registered protocol family 2
[    0.282170] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.282754] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.284691] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.299397] TCP: Hash tables configured (established 131072 bind 65536)
[    0.299571] TCP reno registered
[    0.302132] NET: Registered protocol family 1
[    0.303081] Unpacking initramfs... done
[    0.588276] Freeing initrd memory: 2427k freed
[    0.589262] Machine check exception polling timer started.
[    0.593508] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.593622] Scanning for low memory corruption every 60 seconds
[    0.595208] ====[ backtrace testing ]===========
[    0.595288] Testing a backtrace from process context.
[    0.595363] The following trace is a kernel self test and not a bug!
[    0.595444] Pid: 1, comm: swapper Not tainted 2.6.29-rc6-00006-g17581ad #87
[    0.595526] Call Trace:
[    0.595605]  [<c01510d0>] ? backtrace_regression_test+0x0/0xe0
[    0.595687]  [<c0151100>] backtrace_regression_test+0x30/0xe0
[    0.597019]  [<c01bad01>] ? proc_create_data+0x61/0xa0
[    0.597100]  [<c055a9a0>] ? kallsyms_init+0x0/0x30
[    0.597177]  [<c055a9c4>] ? kallsyms_init+0x24/0x30
[    0.597255]  [<c01510d0>] ? backtrace_regression_test+0x0/0xe0
[    0.597335]  [<c010111d>] do_one_initcall+0x2d/0x1d0
[    0.597413]  [<c0148f59>] ? validate_chain+0xe9/0x1150
[    0.597490]  [<c0148f59>] ? validate_chain+0xe9/0x1150
[    0.597568]  [<c0148f59>] ? validate_chain+0xe9/0x1150
[    0.597646]  [<c014b0dd>] ? __lock_acquire+0x33d/0x600
[    0.597725]  [<c0148f59>] ? validate_chain+0xe9/0x1150
[    0.597803]  [<c01469fb>] ? trace_hardirqs_off+0xb/0x10
[    0.597916]  [<c014b0dd>] ? __lock_acquire+0x33d/0x600
[    0.597997]  [<c03f413d>] ? _spin_unlock+0x1d/0x20
[    0.598073]  [<c01babe1>] ? proc_register+0x121/0x1e0
[    0.598150]  [<c01baa73>] ? __proc_create+0xe3/0x100
[    0.598227]  [<c01bad95>] ? create_proc_entry+0x55/0xa0
[    0.598305]  [<c01538ae>] ? register_irq_proc+0x8e/0xa0
[    0.598385]  [<c054888a>] kernel_init+0x9a/0xf0
[    0.598461]  [<c05487f0>] ? kernel_init+0x0/0xf0
[    0.598538]  [<c0103a77>] kernel_thread_helper+0x7/0x10
[    0.598613] Testing a backtrace from irq context.
[    0.598687] The following trace is a kernel self test and not a bug!
[    0.598778] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.29-rc6-00006-g17581ad #87
[    0.598887] Call Trace:
[    0.598958]  [<c01510b8>] backtrace_test_irq_callback+0x8/0x20
[    0.599038]  [<c012c253>] tasklet_action+0x43/0x90
[    0.599115]  [<c012bdd5>] __do_softirq+0x65/0x110
[    0.599190]  [<c012bfa0>] ? ksoftirqd+0x0/0xb0
[    0.599265]  [<c012bec6>] do_softirq+0x46/0x50
[    0.599340]  [<c012bfe5>] ksoftirqd+0x45/0xb0
[    0.599417]  [<c0139bc2>] kthread+0x42/0x70
[    0.599492]  [<c0139b80>] ? kthread+0x0/0x70
[    0.599567]  [<c0103a77>] kernel_thread_helper+0x7/0x10
[    0.599653] Testing a saved backtrace.
[    0.599724] The following trace is a kernel self test and not a bug!
[    0.599810]  [<c010c89b>] save_stack_trace+0x2b/0x50
[    0.600019]  [<c0151188>] backtrace_regression_test+0xb8/0xe0
[    0.600138]  [<c010111d>] do_one_initcall+0x2d/0x1d0
[    0.600252]  [<c054888a>] kernel_init+0x9a/0xf0
[    0.600365]  [<c0103a77>] kernel_thread_helper+0x7/0x10
[    0.600480]  [<ffffffff>] 0xffffffff
[    0.600589] ====[ end of backtrace testing ]====
[    0.601300] highmem bounce pool size: 64 pages
[    0.618319] fuse init (API version 7.11)
[    0.619284] msgmni has been set to 1739
[    0.620541] alg: No test for stdrng (krng)
[    0.620720] io scheduler noop registered
[    0.620795] io scheduler deadline registered
[    0.620931] io scheduler cfq registered (default)
[    0.621069] pci 0000:00:02.0: Boot video device
[    0.622030] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.622176] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.622938] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.623076] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.623814] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.624065] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.626361] ACPI: AC Adapter [AC0] (on-line)
[    0.629484] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.713883] Switched to high resolution mode on CPU 0
[    1.613094] ACPI: Battery Slot [BAT0] (battery present)
[    1.614587] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.614785] ACPI: Power Button (FF) [PWRF]
[    1.615423] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.630345] ACPI: Lid Switch [LID]
[    1.630850] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.630964] ACPI: Sleep Button (CM) [SLPB]
[    1.631436] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[    1.631550] ACPI: Power Button (CM) [PWRB]
[    1.634573] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.635341] processor ACPI_CPU:00: registered as cooling_device0
[    1.635436] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.656131] thermal LNXTHERM:01: registered as thermal_zone0
[    1.672830] ACPI: Thermal Zone [TZ00] (59 C)
[    1.702314] Non-volatile memory driver v1.3
[    1.702395] Linux agpgart interface v0.103
[    1.702527] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    1.703076] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    1.706937] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.707475] [drm] Initialized drm 1.1.0 20060810
[    1.707691] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.707778] pci 0000:00:02.0: setting latency timer to 64
[    1.713446] pci 0000:00:02.0: PCI INT A disabled
[    1.718274] loop: module loaded
[    1.718353] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    1.718429] Copyright (c) 2007 Atheros Corporation.
[    1.718593] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.718688] atl2 0000:03:00.0: setting latency timer to 64
[    1.758152] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.758271] ath5k 0000:01:00.0: setting latency timer to 64
[    1.758418] ath5k 0000:01:00.0: registered as 'phy0'
[    1.825710] wmaster0 (ath5k): not using net_device_ops yet
[    1.826388] phy0: Selected rate control algorithm 'minstrel'
[    1.826866] wlan0 (ath5k): not using net_device_ops yet
[    1.827805] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    1.828124] Linux video capture interface: v2.00
[    1.828811] usbcore: registered new interface driver uvcvideo
[    1.828898] USB Video Class driver (v0.1.0)
[    1.829212] Driver 'sd' needs updating - please use bus_type methods
[    1.829547] ahci 0000:00:1f.2: version 3.0
[    1.829594] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.829722] ahci 0000:00:1f.2: PCI INT B disabled
[    1.829817] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.830175] ata_piix 0000:00:1f.2: version 2.12
[    1.830199] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.830293] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.830692] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.830920] scsi0 : ata_piix
[    1.832103] scsi1 : ata_piix
[    1.842955] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.843056] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    2.162359] ata2.00: CFA: ASUS-PHISON OB SSD, TST2.04P, max UDMA/66
[    2.162444] ata2.00: 7880544 sectors, multi 0: LBA 
[    2.162592] ata2.01: CFA: ASUS-PHISON SSD, TST2.04P, max UDMA/66
[    2.162671] ata2.01: 31522176 sectors, multi 0: LBA 
[    2.166288] ata2.00: configured for UDMA/66
[    2.169283] ata2.01: configured for UDMA/66
[    2.170617] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON OB S TST2 PQ: 0 ANSI: 5
[    2.172540] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: (4.03 GB/3.75 GiB)
[    2.172722] sd 1:0:0:0: [sda] Write Protect is off
[    2.172797] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.172926] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.174321] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: (4.03 GB/3.75 GiB)
[    2.174499] sd 1:0:0:0: [sda] Write Protect is off
[    2.174575] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.174709] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.174821]  sda: sda1 sda2 sda3 sda4
[    2.178787] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.179679] scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
[    2.180739] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: (16.1 GB/15.0 GiB)
[    2.180916] sd 1:0:1:0: [sdb] Write Protect is off
[    2.180993] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    2.181149] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.181552] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: (16.1 GB/15.0 GiB)
[    2.181730] sd 1:0:1:0: [sdb] Write Protect is off
[    2.181806] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    2.181942] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.182207]  sdb: sdb1 sdb2
[    2.184990] sd 1:0:1:0: [sdb] Attached SCSI disk
[    2.185578] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.185757] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.185882] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.185890] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.187965] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.192203] ehci_hcd 0000:00:1d.7: debug port 1
[    2.192288] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.192338] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    2.202063] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.203102] usb usb1: configuration #1 chosen from 1 choice
[    2.203845] hub 1-0:1.0: USB hub found
[    2.204101] hub 1-0:1.0: 8 ports detected
[    2.206245] uhci_hcd: USB Universal Host Controller Interface driver
[    2.206440] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.206537] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.206545] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.206894] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.207114] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    2.207755] usb usb2: configuration #1 chosen from 1 choice
[    2.208149] hub 2-0:1.0: USB hub found
[    2.208368] hub 2-0:1.0: 2 ports detected
[    2.209334] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.209434] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.209442] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.209800] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.209977] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    2.210643] usb usb3: configuration #1 chosen from 1 choice
[    2.211114] hub 3-0:1.0: USB hub found
[    2.211219] hub 3-0:1.0: 2 ports detected
[    2.212076] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.212175] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.212183] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.212520] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.212676] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    2.213430] usb usb4: configuration #1 chosen from 1 choice
[    2.213800] hub 4-0:1.0: USB hub found
[    2.213907] hub 4-0:1.0: 2 ports detected
[    2.214854] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.214956] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.214964] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.215417] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.215595] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    2.216263] usb usb5: configuration #1 chosen from 1 choice
[    2.216635] hub 5-0:1.0: USB hub found
[    2.216744] hub 5-0:1.0: 2 ports detected
[    2.217810] Initializing USB Mass Storage driver...
[    2.219381] usbcore: registered new interface driver usb-storage
[    2.219468] USB Mass Storage support registered.
[    2.220119] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.253311] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.253466] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.254681] mice: PS/2 mouse device common for all mice
[    2.270233] rtc_cmos 00:03: RTC can wake from S4
[    2.270840] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.270970] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    2.272076] cpuidle: using governor ladder
[    2.273715] cpuidle: using governor menu
[    2.273883] eeepc: Eee PC Hotkey Driver
[    2.274396] eeepc: Hotkey init flags 0x41
[    2.276196] eeepc: Get control methods supported: 0x101711
[    2.276696] input: Asus EeePC extra buttons as /devices/virtual/input/input4
[    2.277047] Marking TSC unstable due to TSC halts in idle
[    2.287520] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.292234] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    2.293473] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.293683] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.303269] hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
[    2.303762] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    2.303839]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.303913]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    2.303986]    mono: mono_out=0x0
[    2.304083]    inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
[    2.330129] ALSA device list:
[    2.330209]   #0: HDA Intel at 0xf7eb8000 irq 16
[    2.330394] TCP cubic registered
[    2.330468] NET: Registered protocol family 17
[    2.335094] Using IPI Shortcut mode
[    2.336363]   Magic number: 1:118:735
[    2.336671] rtc_cmos 00:03: setting system clock to 2009-03-01 13:43:42 UTC (1235915022)
[    2.337184] Freeing unused kernel memory: 288k freed
[    2.337824] Write protecting the kernel text: 3032k
[    2.337900] Testing CPA: Reverting c0100000-c03f6000
[    2.338553] Testing CPA: write protecting again
[    2.339400] Write protecting the kernel read-only data: 964k
[    2.339481] Testing CPA: undo c03f6000-c04e7000
[    2.339734] Testing CPA: write protecting again
[    2.508945] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    2.631082] usb 1-5: configuration #1 chosen from 1 choice
[    2.638918] scsi2 : SCSI emulation for USB Mass Storage devices
[    2.648736] usb-storage: device found at 2
[    2.648744] usb-storage: waiting for device to settle before scanning
[    3.712080] Clocksource tsc unstable (delta = -379010849 ns)
[    4.392871] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input6
[    7.654071] usb-storage: device scan complete
[    7.655068] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[    8.198869] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    8.199491] sd 2:0:0:0: [sdc] Write Protect is on
[    8.199499] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    8.199504] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    8.202126] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    8.202862] sd 2:0:0:0: [sdc] Write Protect is on
[    8.202870] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    8.202875] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    8.202883]  sdc: sdc1 sdc2
[    8.206192] sd 2:0:0:0: [sdc] Attached SCSI removable disk
[   16.276209] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   17.840411] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[   18.045797] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   30.594074] CPA self-test:
[   30.594405]  4k 9214 large 213 gb 0 x 9427[c0000000-f77fd000] miss 0
[   30.622808]  4k 190462 large 36 gb 0 x 190498[c0000000-f77fd000] miss 0
[   30.645068]  4k 190462 large 36 gb 0 x 190498[c0000000-f77fd000] miss 0
[   30.645073] ok.
[   40.296069] kjournald starting.  Commit interval 5 seconds
[   40.296536] EXT3-fs: mounted filesystem with ordered data mode.

-- 
Sitsofe | http://sucs.org/~sits/
