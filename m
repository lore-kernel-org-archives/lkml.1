Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbZERJt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbZERJt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZERJmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:42:16 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35455 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbZERJmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:42:10 -0400
Date: Mon, 18 May 2009 10:42:10 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090518094209.GA21150@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org> <20090513191953.GA10629@sucs.org> <20090516032754.GC12099@dtor-d630.eng.vmware.com> <20090516032924.GD12099@dtor-d630.eng.vmware.com> <20090518084146.GA25806@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518084146.GA25806@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 09:41:46AM +0100, Sitsofe Wheeler wrote:
> 
> And of course just as soon as I finish building a new kernel the issue
> disappears. Even in older kernels that were seemingly showing the
> problem all the time. Sigh.

After numerous reboots I finally managed to reproduce the problem the
original way with your patch installed. I have no idea what the
necessary triggers are but I suspect it involves suspend to ram...

dmesg below:

[    0.000000] Linux version 2.6.30-rc6-00026-g0f6f49a-dirty (@milan) (gcc version 4.2.4) #141 Sun May 17 16:30:00 BST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
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
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 03F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] total RAM coverred: 1016M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003f780000 (usable)
[    0.000000]  modified: 000000003f780000 - 000000003f790000 (ACPI data)
[    0.000000]  modified: 000000003f790000 - 000000003f7d0000 (ACPI NVS)
[    0.000000]  modified: 000000003f7d0000 - 000000003f7de000 (reserved)
[    0.000000]  modified: 000000003f7e0000 - 000000003f800000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] ACPI: RSDP 000fbe60 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 3f780000 00034 (v01 A M I  OEMRSDT  09000811 MSFT 00000097)
[    0.000000] ACPI: FACP 3f780200 00081 (v01 A M I  OEMFACP  09000811 MSFT 00000097)
[    0.000000] ACPI: DSDT 3f780400 06109 (v01  A0979 A0979034 00000034 INTL 20060113)
[    0.000000] ACPI: FACS 3f790000 00040
[    0.000000] ACPI: APIC 3f780390 00068 (v01 A M I  OEMAPIC  09000811 MSFT 00000097)
[    0.000000] ACPI: OEMB 3f790040 00046 (v01 A M I  AMI_OEM  09000811 MSFT 00000097)
[    0.000000] ACPI: MCFG 3f786510 0003C (v01 A M I  OEMMCFG  09000811 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00011000 - 00017f00
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 0000aec0d8]    TEXT DATA BSS ==> [0000100000 - 0000aec0d8]
[    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #3 [0000aed000 - 0000af11f8]              BRK ==> [0000aed000 - 0000af11f8]
[    0.000000]   #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #5 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f780
[    0.000000] On node 0 totalpages: 259856
[    0.000000] free_area_init_node: node 0, pgdat c05a5840, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3952 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 256 pages used for memmap
[    0.000000]   HighMem zone: 32386 pages, LIFO batch:7
[    0.000000] Using APIC driver default
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
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257824
[    0.000000] Kernel command line: root=/dev/sdb2 cfg80211.ieee80211_regdom=GB usb_storage.delay_use=0 cfg80211 pcie_aspm=force pcie_aspm.policy=powersave fastboot ro rootfstype=ext2 i8042.debug single
[    0.000000] PCIe ASPM is forcedly enabled
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:288
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 899.984 MHz processor.
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
[    0.000999]  memory used by lock dependency info: 2847 kB
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
[    0.000999] Initializing HighMem for node 0 (000377fe:0003f780)
[    0.000999] Memory: 1019988k/1039872k available (3290k kernel code, 19168k reserved, 1506k data, 308k init, 130568k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc05b2000 - 0xc05ff000   ( 308 kB)
[    0.000999]       .data : 0xc04369a5 - 0xc05af4b8   (1506 kB)
[    0.000999]       .text : 0xc0100000 - 0xc04369a5   (3290 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000999] ODEBUG: 4 of 4 active objects replaced
[    0.000999] ODEBUG: selftest passed
[    0.001040] Calibrating delay loop (skipped), value calculated using timer frequency.. 1799.96 BogoMIPS (lpj=899984)
[    0.001346] Security Framework initialized
[    0.001519] Mount-cache hash table entries: 512
[    0.004029] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004152] CPU: L2 cache: 512K
[    0.004226] Intel machine check architecture supported.
[    0.004306] Intel machine check reporting enabled on CPU#0.
[    0.004394] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.004579] Checking 'hlt' instruction... OK.
[    0.008938] ACPI: Core revision 20090320
[    0.061022] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.061113] ftrace: allocating 14721 entries in 29 pages
[    0.064990] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.077594] net_namespace: 396 bytes
[    0.078808] Time:  9:03:23  Date: 05/18/09
[    0.080346] NET: Registered protocol family 16
[    0.085437] ACPI: bus type pci registered
[    0.085583] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.085667] PCI: Not using MMCONFIG.
[    0.085952] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.086137] PCI: Using configuration type 1 for base access
[    0.133937] bio: create slab <bio-0> at 0
[    0.141898] ACPI: EC: Look up EC in DSDT
[    0.216388] ACPI: Interpreter enabled
[    0.216483] ACPI: (supports S0 S1 S3 S5)
[    0.216993] ACPI: Using IOAPIC for interrupt routing
[    0.217419] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.231512] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.231597] PCI: Using MMCONFIG for extended config space
[    0.293925] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.294017] ACPI: EC: driver started in poll mode
[    0.297310] ACPI: No dock devices found.
[    0.297777] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.298865] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.298883] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.298899] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.298914] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.299075] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.299364] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.299474] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.299561] pci 0000:00:1b.0: PME# disabled
[    0.299788] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.299872] pci 0000:00:1c.0: PME# disabled
[    0.300212] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.300299] pci 0000:00:1c.1: PME# disabled
[    0.300528] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.300613] pci 0000:00:1c.2: PME# disabled
[    0.300809] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.300935] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.301073] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.301199] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.301334] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.301451] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.301537] pci 0000:00:1d.7: PME# disabled
[    0.301880] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.301895] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.301964] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.302054] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 0380-038f
[    0.302217] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.302233] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.302249] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.302265] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.302281] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.302345] pci 0000:00:1f.2: PME# supported from D3hot
[    0.302426] pci 0000:00:1f.2: PME# disabled
[    0.302600] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.302976] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.303043] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.303121] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.303206] pci 0000:03:00.0: PME# disabled
[    0.305396] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.305535] pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
[    0.306139] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.306156] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.306289] pci 0000:00:1e.0: transparent bridge
[    0.306427] pci_bus 0000:00: on NUMA node 0
[    0.306474] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.308462] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.308861] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.309242] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.367738] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.369107] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.370429] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.371745] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.373079] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.374503] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.376017] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.377477] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.381423] SCSI subsystem initialized
[    0.381710] libata version 3.00 loaded.
[    0.383208] usbcore: registered new interface driver usbfs
[    0.383691] usbcore: registered new interface driver hub
[    0.384445] usbcore: registered new device driver usb
[    0.387450] PCI: Using ACPI for IRQ routing
[    0.391754] cfg80211: Using static regulatory domain info
[    0.391839] cfg80211: Regulatory domain: US
[    0.391912] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.392127] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.392211] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.392293] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.392376] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.392458] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.392540] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.392945] cfg80211: Calling CRDA for country: GB
[    0.393847] hpet clockevent registered
[    0.393859] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.394108] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.394341] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.402243] pnp: PnP ACPI init
[    0.402414] ACPI: bus type pnp registered
[    0.422205] pnp: PnP ACPI: found 13 devices
[    0.422288] ACPI: ACPI bus type pnp unregistered
[    0.422440] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.422566] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.422652] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.422736] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.422822] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.422908] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.423008] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.423142] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.423276] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.423363] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.423472] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.423600] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.423715] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.423806] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.423897] system 00:0c: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.463396] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.463483] pci 0000:00:1c.0:   IO window: disabled
[    0.463568] pci 0000:00:1c.0:   MEM window: disabled
[    0.463649] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.463736] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.463814] pci 0000:00:1c.1:   IO window: disabled
[    0.463899] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.463983] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.464080] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.464159] pci 0000:00:1c.2:   IO window: disabled
[    0.464242] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.464327] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.464442] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.464520] pci 0000:00:1e.0:   IO window: disabled
[    0.464602] pci 0000:00:1e.0:   MEM window: disabled
[    0.464682] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.464802] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.464892] pci 0000:00:1c.0: setting latency timer to 64
[    0.464915] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.465011] pci 0000:00:1c.1: setting latency timer to 64
[    0.465034] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.465121] pci 0000:00:1c.2: setting latency timer to 64
[    0.465138] pci 0000:00:1e.0: setting latency timer to 64
[    0.465150] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.465157] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.465165] pci_bus 0000:03: resource 1 mem: [0xfbf00000-0xfbffffff]
[    0.465172] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbefffff]
[    0.465179] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf6ffffff]
[    0.465186] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.465193] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
[    0.465291] NET: Registered protocol family 2
[    0.465741] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.466783] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.468960] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.483553] TCP: Hash tables configured (established 131072 bind 65536)
[    0.483742] TCP reno registered
[    0.484262] NET: Registered protocol family 1
[    0.487489] Machine check exception polling timer started.
[    0.492010] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.492123] Scanning for low memory corruption every 60 seconds
[    0.494845] ====[ backtrace testing ]===========
[    0.494924] Testing a backtrace from process context.
[    0.495146] The following trace is a kernel self test and not a bug!
[    0.495230] Pid: 1, comm: swapper Not tainted 2.6.30-rc6-00026-g0f6f49a-dirty #141
[    0.495334] Call Trace:
[    0.495415]  [<c0153860>] ? backtrace_regression_test+0x0/0xe0
[    0.495497]  [<c0153895>] backtrace_regression_test+0x35/0xe0
[    0.495580]  [<c01d0cd6>] ? proc_create_data+0x66/0xb0
[    0.495660]  [<c05c3a00>] ? kallsyms_init+0x0/0x30
[    0.495738]  [<c05c3a24>] ? kallsyms_init+0x24/0x30
[    0.495816]  [<c0153860>] ? backtrace_regression_test+0x0/0xe0
[    0.497142]  [<c0101122>] do_one_initcall+0x32/0x1d0
[    0.497225]  [<c014ca69>] ? validate_chain+0xe9/0xfd0
[    0.497305]  [<c014dc89>] ? __lock_acquire+0x339/0x5e0
[    0.497387]  [<c014dc89>] ? __lock_acquire+0x339/0x5e0
[    0.497469]  [<c018ee26>] ? check_bytes_and_report+0x26/0xd0
[    0.497551]  [<c018f2f4>] ? slab_pad_check+0x74/0x110
[    0.497631]  [<c014ca69>] ? validate_chain+0xe9/0xfd0
[    0.497710]  [<c018feaf>] ? check_object+0xef/0x1f0
[    0.497790]  [<c014dc89>] ? __lock_acquire+0x339/0x5e0
[    0.497869]  [<c01d0441>] ? proc_register+0x121/0x1e0
[    0.497953]  [<c0435672>] ? _spin_unlock+0x22/0x30
[    0.498039]  [<c01d0441>] ? proc_register+0x121/0x1e0
[    0.498117]  [<c01d0c5b>] ? __proc_create+0xeb/0x100
[    0.498197]  [<c01d0d7a>] ? create_proc_entry+0x5a/0xa0
[    0.498280]  [<c0156752>] ? register_irq_proc+0x92/0xb0
[    0.498362]  [<c05b288a>] kernel_init+0x9a/0xf0
[    0.498439]  [<c05b27f0>] ? kernel_init+0x0/0xf0
[    0.498518]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.498593] Testing a backtrace from irq context.
[    0.498667] The following trace is a kernel self test and not a bug!
[    0.498761] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.30-rc6-00026-g0f6f49a-dirty #141
[    0.498865] Call Trace:
[    0.498938]  [<c014c66b>] ? trace_hardirqs_on_caller+0x5b/0x180
[    0.499068]  [<c015384d>] backtrace_test_irq_callback+0xd/0x20
[    0.499151]  [<c012d624>] tasklet_action+0x44/0x90
[    0.499230]  [<c012d105>] __do_softirq+0x75/0x1a0
[    0.499307]  [<c012d360>] ? ksoftirqd+0x0/0xb0
[    0.499384]  [<c012d285>] do_softirq+0x55/0x60
[    0.499460]  [<c012d3a5>] ksoftirqd+0x45/0xb0
[    0.499539]  [<c013bda2>] kthread+0x52/0x80
[    0.499616]  [<c013bd50>] ? kthread+0x0/0x80
[    0.499692]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.499779] Testing a saved backtrace.
[    0.499850] The following trace is a kernel self test and not a bug!
[    0.499937]  [<c010bb00>] save_stack_trace+0x30/0x50
[    0.500175]  [<c015391d>] backtrace_regression_test+0xbd/0xe0
[    0.500294]  [<c0101122>] do_one_initcall+0x32/0x1d0
[    0.500409]  [<c05b288a>] kernel_init+0x9a/0xf0
[    0.500524]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.500641]  [<ffffffff>] 0xffffffff
[    0.500751] ====[ end of backtrace testing ]====
[    0.501911] highmem bounce pool size: 64 pages
[    0.555415] fuse init (API version 7.11)
[    0.557179] msgmni has been set to 1737
[    0.559120] alg: No test for stdrng (krng)
[    0.559331] io scheduler noop registered
[    0.559407] io scheduler deadline registered
[    0.560865] io scheduler cfq registered (default)
[    0.561045] pci 0000:00:02.0: Boot video device
[    0.562558] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.562594] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.564225] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.564260] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.565748] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.565782] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.571120] ACPI: AC Adapter [AC0] (on-line)
[    0.573202] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.573417] ACPI: Power Button [PWRF]
[    0.574392] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.576009] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.582335] ACPI: Lid Switch [LID]
[    0.583143] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.583260] ACPI: Sleep Button [SLPB]
[    0.583960] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[    0.584095] ACPI: Power Button [PWRB]
[    0.587912] Marking TSC unstable due to TSC halts in idle
[    0.588896] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3]<7>Switched to high resolution mode on CPU 0
[    0.589403] )
[    0.590376] processor ACPI_CPU:00: registered as cooling_device0
[    0.590478] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.612314] thermal LNXTHERM:01: registered as thermal_zone0
[    0.612482] ACPI: Thermal Zone [TZ00] (53 C)
[    0.859722] Non-volatile memory driver v1.3
[    0.859807] Linux agpgart interface v0.103
[    0.859957] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    0.860849] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.865094] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.866421] [drm] Initialized drm 1.1.0 20060810
[    0.866682] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.866770] pci 0000:00:02.0: setting latency timer to 64
[    0.873248] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[    0.873422] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.090077] loop: module loaded
[    1.090564] Driver 'sd' needs updating - please use bus_type methods
[    1.091289] ahci 0000:00:1f.2: version 3.0
[    1.091338] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.091483] ahci 0000:00:1f.2: PCI INT B disabled
[    1.091591] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.092159] ata_piix 0000:00:1f.2: version 2.13
[    1.092184] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.092278] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.092705] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.093217] scsi0 : ata_piix
[    1.096468] scsi1 : ata_piix
[    1.120067] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.120157] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.120775] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    1.120855] Copyright (c) 2007 Atheros Corporation.
[    1.121070] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.121168] atl2 0000:03:00.0: setting latency timer to 64
[    3.020696] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.020807] ath5k 0000:01:00.0: setting latency timer to 64
[    3.020891] ath5k 0000:01:00.0: registered as 'phy0'
[    3.097308] phy0: Selected rate control algorithm 'minstrel'
[    3.098662] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    3.099253] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.099470] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.099594] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.099604] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.102605] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.106826] ehci_hcd 0000:00:1d.7: debug port 1
[    3.106913] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.106987] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    3.117077] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.118638] usb usb1: configuration #1 chosen from 1 choice
[    3.120704] hub 1-0:1.0: USB hub found
[    3.120992] hub 1-0:1.0: 8 ports detected
[    3.124771] uhci_hcd: USB Universal Host Controller Interface driver
[    3.125512] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.125623] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.125633] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.126380] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.126574] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    3.127669] usb usb2: configuration #1 chosen from 1 choice
[    3.128442] hub 2-0:1.0: USB hub found
[    3.128698] hub 2-0:1.0: 2 ports detected
[    3.130523] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.130634] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.130645] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.131299] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.131527] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    3.132714] usb usb3: configuration #1 chosen from 1 choice
[    3.133365] hub 3-0:1.0: USB hub found
[    3.133487] hub 3-0:1.0: 2 ports detected
[    3.135100] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.135210] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.135220] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.135801] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.135979] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    3.137317] usb usb4: configuration #1 chosen from 1 choice
[    4.147734] hub 4-0:1.0: USB hub found
[    4.147872] hub 4-0:1.0: 2 ports detected
[    4.149470] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    4.149584] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    4.149594] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.150218] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    4.150432] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    4.151636] usb usb5: configuration #1 chosen from 1 choice
[    4.152277] hub 5-0:1.0: USB hub found
[    4.152404] hub 5-0:1.0: 2 ports detected
[    4.154239] Initializing USB Mass Storage driver...
[    4.154742] usbcore: registered new interface driver usb-storage
[    4.154831] USB Mass Storage support registered.
[    4.155898] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    4.157170] drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
[    4.157182] drivers/input/serio/i8042.c: 65 <- i8042 (return) [3]
[    4.157220] drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
[    4.158014] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [3]
[    4.159075] drivers/input/serio/i8042.c: d3 -> i8042 (command) [4]
[    4.159075] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [4]
[    4.159075] drivers/input/serio/i8042.c: 5a <- i8042 (return) [4]
[    4.162334] drivers/input/serio/i8042.c: a7 -> i8042 (command) [8]
[    4.163013] drivers/input/serio/i8042.c: 20 -> i8042 (command) [8]
[    4.163013] drivers/input/serio/i8042.c: 74 <- i8042 (return) [8]
[    4.163517] drivers/input/serio/i8042.c: a8 -> i8042 (command) [9]
[    4.164508] drivers/input/serio/i8042.c: 20 -> i8042 (command) [9]
[    4.164508] drivers/input/serio/i8042.c: 54 <- i8042 (return) [9]
[    4.166244] drivers/input/serio/i8042.c: 60 -> i8042 (command) [12]
[    4.167194] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [12]
[    4.168463] drivers/input/serio/i8042.c: d3 -> i8042 (command) [13]
[    4.168463] drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [13]
[    4.173360] drivers/input/serio/i8042.c: 60 -> i8042 (command) [19]
[    4.174010] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [19]
[    4.177444] drivers/input/serio/i8042.c: d3 -> i8042 (command) [22]
[    4.177444] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [22]
[    4.177444] drivers/input/serio/i8042.c: f0 <- i8042 (return) [22]
[    4.183982] drivers/input/serio/i8042.c: d3 -> i8042 (command) [29]
[    4.184684] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [29]
[    4.184684] drivers/input/serio/i8042.c: 56 <- i8042 (return) [29]
[    4.187554] drivers/input/serio/i8042.c: d3 -> i8042 (command) [33]
[    4.188233] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [33]
[    4.188233] drivers/input/serio/i8042.c: a4 <- i8042 (return) [33]
[    4.190439] drivers/input/serio/i8042.c: Interrupt 12, without any data [36]
[    4.190763] drivers/input/serio/i8042.c: 60 -> i8042 (command) [36]
[    4.191390] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [36]
[    4.192039] drivers/input/serio/i8042.c: Interrupt 1, without any data [38]
[    4.192053] drivers/input/serio/i8042.c: Interrupt 1, without any data [38]
[    4.193012] drivers/input/serio/i8042.c: 60 -> i8042 (command) [38]
[    4.193012] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [38]
[    4.195469] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.195632] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.198167] mice: PS/2 mouse device common for all mice
[    4.201881] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [47]
[    4.202635] rtc_cmos 00:03: RTC can wake from S4
[    4.203739] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    4.203879] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    4.204574] Linux video capture interface: v2.00
[    4.205987] usbcore: registered new interface driver uvcvideo
[    4.206106] USB Video Class driver (v0.1.0)
[    4.208266] cpuidle: using governor ladder
[    4.212082] ACPI: Battery Slot [BAT0] (battery present)
[    4.213037] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [59]
[    4.214070] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [60]
[    4.216170] cpuidle: using governor menu
[    4.216351] eeepc: Eee PC Hotkey Driver
[    4.217073] eeepc: Hotkey init flags 0x41
[    4.217160] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [63]
[    4.219576] eeepc: Get control methods supported: 0x101711
[    4.220054] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [66]
[    4.220373] input: Asus EeePC extra buttons as /devices/virtual/input/input4
[    4.226234] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [72]
[    4.229566] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [75]
[    4.232490] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [78]
[    4.232533] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [78]
[    4.233815] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    4.235581] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.235802] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.237209] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [83]
[    4.237281] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [83]
[    4.243975] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [89]
[    4.244042] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [90]
[    4.249562] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [95]
[    4.250660] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    4.251650] drivers/input/serio/i8042.c: d4 -> i8042 (command) [97]
[    4.252017] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [97]
[    4.263873] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [109]
[    4.266201] hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
[    4.266368] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    4.266467]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.266543]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    4.266616]    mono: mono_out=0x0
[    4.266687]    inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
[    4.267050] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [113]
[    4.270440] drivers/input/serio/i8042.c: d4 -> i8042 (command) [116]
[    4.271016] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [116]
[    4.274883] ALSA device list:
[    4.274963]   #0: HDA Intel at 0xf7eb8000 irq 16
[    4.275258] TCP cubic registered
[    4.276597] NET: Registered protocol family 17
[    4.276802] Using IPI Shortcut mode
[    4.279191]   Magic number: 9:810:70
[    4.279548] rtc_cmos 00:03: setting system clock to 2009-05-18 09:03:27 UTC (1242637407)
[    4.281412] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [127]
[    4.283338] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [129]
[    5.406620] libps2: errorneously fail 754 command
[    5.412384] ata2.00: CFA: ASUS-PHISON OB SSD, TST2.04P, max UDMA/66
[    5.412468] ata2.00: 7880544 sectors, multi 0: LBA 
[    5.412617] ata2.01: CFA: ASUS-PHISON SSD, TST2.04P, max UDMA/66
[    5.412697] ata2.01: 31522176 sectors, multi 0: LBA 
[    5.416319] ata2.00: configured for UDMA/66
[    5.419416] ata2.01: configured for UDMA/66
[    5.420806] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON OB S TST2 PQ: 0 ANSI: 5
[    5.425842] scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
[    5.428258] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: (4.03 GB/3.75 GiB)
[    5.428471] sd 1:0:0:0: [sda] Write Protect is off
[    5.428548] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.428736] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.429957]  sda: sda1 sda2 sda3 sda4
[    5.434227] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: (16.1 GB/15.0 GiB)
[    5.434441] sd 1:0:1:0: [sdb] Write Protect is off
[    5.434518] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    5.434707] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.435537]  sdb: sdb1 sdb2
[    5.442845] sd 1:0:1:0: [sdb] Attached SCSI disk
[    5.443249] sd 1:0:0:0: [sda] Attached SCSI disk
[    5.448147] EXT2-fs warning (device sdb2): ext2_fill_super: mounting ext3 filesystem as ext2
[    5.448559] VFS: Mounted root (ext2 filesystem) readonly on device 8:18.
[    5.448835] Freeing unused kernel memory: 308k freed
[    5.449922] Write protecting the kernel text: 3292k
[    5.450037] Testing CPA: Reverting c0100000-c0437000
[    5.450723] Testing CPA: write protecting again
[    5.451643] Write protecting the kernel read-only data: 1108k
[    5.451728] Testing CPA: undo c0437000-c054c000
[    5.452036] Testing CPA: write protecting again
[    5.628141] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    5.746226] usb 1-5: configuration #1 chosen from 1 choice
[    5.749232] scsi2 : SCSI emulation for USB Mass Storage devices
[    5.756692] usb-storage: device found at 2
[    5.757384] usb-storage: device scan complete
[    5.758534] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[    5.893045] Clocksource tsc unstable (delta = -125052842 ns)
[    6.304373] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    6.305088] sd 2:0:0:0: [sdc] Write Protect is on
[    6.305169] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    6.305175] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    6.309334] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    6.309460]  sdc: sdc1 sdc2
[    6.316659] sd 2:0:0:0: [sdc] Attached SCSI removable disk
[   17.311968] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [13157]
[   17.315226] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [13161]
[   17.418399] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [13264]
[   17.422965] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [13268]
[   17.487371] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [13333]
[   17.490538] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [13336]
[   17.590392] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [13436]
[   17.594934] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [13440]
[   17.917153] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [13763]
[   18.025255] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [13871]
[   18.378129] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [14224]
[   18.380531] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [14226]
[   18.481050] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [14327]
[   18.485641] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [14331]
[   18.566358] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [14412]
[   18.569816] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [14415]
[   18.636537] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [14482]
[   18.641163] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [14487]
[   19.336030] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [15182]
[   19.339276] drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [15185]
[   19.442418] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [15288]
[   19.447008] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [15292]
[   19.910757] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [15756]
[   20.052248] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [15898]
[   28.035061] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [23881]
[   28.247286] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [24093]
[   28.352789] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [24198]
[   29.090598] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [24936]
[   29.160843] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [25006]
[   29.230654] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [25076]
[   29.394823] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [25240]
[   29.500592] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [25346]
[   29.670173] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [25516]
[   29.739340] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [25585]
[   29.775344] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [25621]
[   29.809773] drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 0, 1) [25655]
[   29.845395] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [25691]
[   29.949493] drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 0, 1) [25795]
[   30.377098] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [26223]
[   30.481153] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [26327]
[   30.492087] CPA self-test:
[   30.492277]  4k 4094 large 218 gb 0 x 4312[c0000000-f77fd000] miss 0
[   30.520397]  4k 194558 large 32 gb 0 x 194590[c0000000-f77fd000] miss 0
[   30.543425]  4k 194558 large 32 gb 0 x 194590[c0000000-f77fd000] miss 0
[   30.543431] ok.
[   32.686766] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [28532]
[   32.766745] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [28612]
[   32.792008] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [28637]
[   32.931149] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [28777]
[   32.953929] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [28799]
[   33.061340] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [28907]
[   33.096989] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [28942]
[   33.166981] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [29012]
[   33.170290] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [29016]
[   33.201067] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [29047]
[   33.332126] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [29178]
[   33.540822] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [29386]
[   33.614626] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [29460]
[   33.825572] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [29671]
[   34.002889] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [29848]
[   34.038426] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [29884]
[   34.107661] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [29953]
[   34.142604] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [29988]
[   34.511614] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [30357]
[   34.582090] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [30428]
[   34.584459] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [30430]
[   34.721646] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [30567]
[   34.757042] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [30603]
[   34.861035] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [30707]
[   34.897827] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [30743]
[   34.968542] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [30814]
[   34.971721] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [30817]
[   35.037919] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [30883]
[   37.908523] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [33754]
[   38.050925] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [33896]
[   38.956417] drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 0, 1) [34802]
[   39.098163] drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 0, 1) [34944]
[   39.103888] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [34949]
[   39.211045] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [35057]
[   39.760878] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 0, 1) [35606]
[   39.902984] drivers/input/serio/i8042.c: 83 <- i8042 (interrupt, 0, 1) [35748]
[   40.101448] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [35947]

-- 
Sitsofe | http://sucs.org/~sits/
