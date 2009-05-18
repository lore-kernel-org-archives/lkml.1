Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZERImL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZERImL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZERIlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:41:52 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56642 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZERIlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:41:47 -0400
Date: Mon, 18 May 2009 09:41:46 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090518084146.GA25806@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org> <20090513191953.GA10629@sucs.org> <20090516032754.GC12099@dtor-d630.eng.vmware.com> <20090516032924.GD12099@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516032924.GD12099@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 08:29:24PM -0700, Dmitry Torokhov wrote:
> On Fri, May 15, 2009 at 08:27:55PM -0700, Dmitry Torokhov wrote:
> > On Wed, May 13, 2009 at 08:19:53PM +0100, Sitsofe Wheeler wrote:
> > > Hi,
> > > 
> > > > On Tue, May 12, 2009 at 08:20:54PM -0700, Dmitry Torokhov wrote:
> > > > > 
> > > > > Could you try booting with i8042.debug and send me dmesg of the case
> > > 
> > > See below:
> > > 
> > 
> > Thanks. I have an idea what is happening... Could you please attach the
> > debug patch below and give me debug dmesg of the failure again? Thanks!
> > 
> > -- 
> > Dmitry
> 
> And now... *drumroll* ...the patch!

And of course just as soon as I finish building a new kernel the issue
disappears. Even in older kernels that were seemingly showing the
problem all the time. Sigh.

I'm starting to wonder if this is down to flaky hardware because I'm
fairly sure my configuration has not changed (plus I tried reproducing
the problem at various battery levels, with the power plugged
in/unplugged etc and it never came back).

The only thing that comes even close to reproducing the error is if
enter is held down at grub for a few seconds while the kernel is
booting. That produces an auxerr in dmesg as seen in the following
(driver is manually rebound in the dmesg below too):

[    0.000000] Linux version 2.6.30-rc6-00026-g0f6f49a-dirty (sw612@milan) (gcc version 4.2.4) #141 Sun May 17 16:30:00 BST 2009
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
[    0.000000] Detected 900.089 MHz processor.
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
[    0.001041] Calibrating delay loop (skipped), value calculated using timer frequency.. 1800.17 BogoMIPS (lpj=900089)
[    0.001341] Security Framework initialized
[    0.001512] Mount-cache hash table entries: 512
[    0.003983] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004074] CPU: L2 cache: 512K
[    0.004148] Intel machine check architecture supported.
[    0.004228] Intel machine check reporting enabled on CPU#0.
[    0.004316] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.004500] Checking 'hlt' instruction... OK.
[    0.008930] ACPI: Core revision 20090320
[    0.061025] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.061114] ftrace: allocating 14721 entries in 29 pages
[    0.064942] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.077592] net_namespace: 396 bytes
[    0.078806] Time:  8:23:08  Date: 05/18/09
[    0.079482] NET: Registered protocol family 16
[    0.084508] ACPI: bus type pci registered
[    0.084659] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.084743] PCI: Not using MMCONFIG.
[    0.085146] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.085228] PCI: Using configuration type 1 for base access
[    0.132931] bio: create slab <bio-0> at 0
[    0.140907] ACPI: EC: Look up EC in DSDT
[    0.215942] ACPI: Interpreter enabled
[    0.215985] ACPI: (supports S0 S1 S3 S5)
[    0.216512] ACPI: Using IOAPIC for interrupt routing
[    0.217014] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.231044] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.231129] PCI: Using MMCONFIG for extended config space
[    0.293398] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.293489] ACPI: EC: driver started in poll mode
[    0.295862] ACPI: No dock devices found.
[    0.296464] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.297547] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.297565] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.297580] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.297596] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.297739] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.298123] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.298233] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.298320] pci 0000:00:1b.0: PME# disabled
[    0.298547] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.298631] pci 0000:00:1c.0: PME# disabled
[    0.298887] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.298965] pci 0000:00:1c.1: PME# disabled
[    0.299197] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.299283] pci 0000:00:1c.2: PME# disabled
[    0.299478] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.299604] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.299731] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.299856] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.300025] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.300143] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.300228] pci 0000:00:1d.7: PME# disabled
[    0.300573] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.300587] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.300696] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.300786] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 0380-038f
[    0.300946] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.300970] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.300986] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.301002] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.301018] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.301082] pci 0000:00:1f.2: PME# supported from D3hot
[    0.301164] pci 0000:00:1f.2: PME# disabled
[    0.301340] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.301657] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.301723] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.301801] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.301886] pci 0000:03:00.0: PME# disabled
[    0.304333] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.304477] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.304494] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.304627] pci 0000:00:1e.0: transparent bridge
[    0.304768] pci_bus 0000:00: on NUMA node 0
[    0.304816] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.306840] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.307248] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.307611] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.365701] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.367086] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.368402] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.369714] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.371040] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.372454] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.373856] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.375391] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.379302] SCSI subsystem initialized
[    0.379593] libata version 3.00 loaded.
[    0.381088] usbcore: registered new interface driver usbfs
[    0.381570] usbcore: registered new interface driver hub
[    0.382355] usbcore: registered new device driver usb
[    0.385349] PCI: Using ACPI for IRQ routing
[    0.389666] cfg80211: Using static regulatory domain info
[    0.389750] cfg80211: Regulatory domain: US
[    0.389823] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.389928] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.390106] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.390188] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.390270] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.390353] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.390435] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.390838] cfg80211: Calling CRDA for country: GB
[    0.391769] hpet clockevent registered
[    0.391782] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.391877] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.392207] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.400280] pnp: PnP ACPI init
[    0.400451] ACPI: bus type pnp registered
[    0.420254] pnp: PnP ACPI: found 13 devices
[    0.420338] ACPI: ACPI bus type pnp unregistered
[    0.420475] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.420602] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.420688] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.420773] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.420858] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.420945] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.421046] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.421181] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.421317] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.421405] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.421515] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.421626] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.421764] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.421856] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.421948] system 00:0c: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.461435] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.461520] pci 0000:00:1c.0:   IO window: disabled
[    0.461604] pci 0000:00:1c.0:   MEM window: disabled
[    0.461684] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.461772] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.461850] pci 0000:00:1c.1:   IO window: disabled
[    0.461936] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.462029] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.462117] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.462196] pci 0000:00:1c.2:   IO window: disabled
[    0.462279] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.462364] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.462479] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.462557] pci 0000:00:1e.0:   IO window: disabled
[    0.462639] pci 0000:00:1e.0:   MEM window: disabled
[    0.462719] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.462836] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.462924] pci 0000:00:1c.0: setting latency timer to 64
[    0.462948] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.463045] pci 0000:00:1c.1: setting latency timer to 64
[    0.463069] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.463155] pci 0000:00:1c.2: setting latency timer to 64
[    0.463173] pci 0000:00:1e.0: setting latency timer to 64
[    0.463184] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.463192] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.463199] pci_bus 0000:03: resource 1 mem: [0xfbf00000-0xfbffffff]
[    0.463207] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbefffff]
[    0.463214] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf6ffffff]
[    0.463221] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.463228] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
[    0.463323] NET: Registered protocol family 2
[    0.463770] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.464761] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.466924] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.481515] TCP: Hash tables configured (established 131072 bind 65536)
[    0.481704] TCP reno registered
[    0.482193] NET: Registered protocol family 1
[    0.485436] Machine check exception polling timer started.
[    0.489932] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.490065] Scanning for low memory corruption every 60 seconds
[    0.492819] ====[ backtrace testing ]===========
[    0.492899] Testing a backtrace from process context.
[    0.493083] The following trace is a kernel self test and not a bug!
[    0.493169] Pid: 1, comm: swapper Not tainted 2.6.30-rc6-00026-g0f6f49a-dirty #141
[    0.493274] Call Trace:
[    0.493358]  [<c0153860>] ? backtrace_regression_test+0x0/0xe0
[    0.493440]  [<c0153895>] backtrace_regression_test+0x35/0xe0
[    0.493523]  [<c01d0cd6>] ? proc_create_data+0x66/0xb0
[    0.493604]  [<c05c3a00>] ? kallsyms_init+0x0/0x30
[    0.493682]  [<c05c3a24>] ? kallsyms_init+0x24/0x30
[    0.493760]  [<c0153860>] ? backtrace_regression_test+0x0/0xe0
[    0.495086]  [<c0101122>] do_one_initcall+0x32/0x1d0
[    0.495169]  [<c014ca69>] ? validate_chain+0xe9/0xfd0
[    0.495248]  [<c014dc89>] ? __lock_acquire+0x339/0x5e0
[    0.495329]  [<c014dc89>] ? __lock_acquire+0x339/0x5e0
[    0.495411]  [<c018ee26>] ? check_bytes_and_report+0x26/0xd0
[    0.495493]  [<c018f2f4>] ? slab_pad_check+0x74/0x110
[    0.495573]  [<c014ca69>] ? validate_chain+0xe9/0xfd0
[    0.495652]  [<c018feaf>] ? check_object+0xef/0x1f0
[    0.495732]  [<c014dc89>] ? __lock_acquire+0x339/0x5e0
[    0.495811]  [<c01d0441>] ? proc_register+0x121/0x1e0
[    0.495894]  [<c0435672>] ? _spin_unlock+0x22/0x30
[    0.495980]  [<c01d0441>] ? proc_register+0x121/0x1e0
[    0.496059]  [<c01d0c5b>] ? __proc_create+0xeb/0x100
[    0.496137]  [<c01d0d7a>] ? create_proc_entry+0x5a/0xa0
[    0.496218]  [<c0156752>] ? register_irq_proc+0x92/0xb0
[    0.496299]  [<c05b288a>] kernel_init+0x9a/0xf0
[    0.496377]  [<c05b27f0>] ? kernel_init+0x0/0xf0
[    0.496455]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.496530] Testing a backtrace from irq context.
[    0.496604] The following trace is a kernel self test and not a bug!
[    0.496698] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.30-rc6-00026-g0f6f49a-dirty #141
[    0.496802] Call Trace:
[    0.496875]  [<c014c66b>] ? trace_hardirqs_on_caller+0x5b/0x180
[    0.496957]  [<c015384d>] backtrace_test_irq_callback+0xd/0x20
[    0.497087]  [<c012d624>] tasklet_action+0x44/0x90
[    0.497165]  [<c012d105>] __do_softirq+0x75/0x1a0
[    0.497243]  [<c012d360>] ? ksoftirqd+0x0/0xb0
[    0.497320]  [<c012d285>] do_softirq+0x55/0x60
[    0.497397]  [<c012d3a5>] ksoftirqd+0x45/0xb0
[    0.497476]  [<c013bda2>] kthread+0x52/0x80
[    0.497552]  [<c013bd50>] ? kthread+0x0/0x80
[    0.497629]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.497716] Testing a saved backtrace.
[    0.497788] The following trace is a kernel self test and not a bug!
[    0.497875]  [<c010bb00>] save_stack_trace+0x30/0x50
[    0.498116]  [<c015391d>] backtrace_regression_test+0xbd/0xe0
[    0.498237]  [<c0101122>] do_one_initcall+0x32/0x1d0
[    0.498352]  [<c05b288a>] kernel_init+0x9a/0xf0
[    0.498467]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.498583]  [<ffffffff>] 0xffffffff
[    0.498693] ====[ end of backtrace testing ]====
[    0.499867] highmem bounce pool size: 64 pages
[    0.552440] fuse init (API version 7.11)
[    0.554211] msgmni has been set to 1737
[    0.556156] alg: No test for stdrng (krng)
[    0.556378] io scheduler noop registered
[    0.556453] io scheduler deadline registered
[    0.557602] io scheduler cfq registered (default)
[    0.557759] pci 0000:00:02.0: Boot video device
[    0.559296] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.559332] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.560899] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.560934] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.562520] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.562555] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.567741] ACPI: AC Adapter [AC0] (on-line)
[    0.569787] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.570200] ACPI: Power Button [PWRF]
[    0.571048] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.573414] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.580170] ACPI: Lid Switch [LID]
[    0.580941] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.581077] ACPI: Sleep Button [SLPB]
[    0.581798] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[    0.581916] ACPI: Power Button [PWRB]
[    0.585775] Marking TSC unstable due to TSC halts in idle
[    0.585950] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3]<7>Switched to high resolution mode on CPU 0
[    0.587259] )
[    0.588210] processor ACPI_CPU:00: registered as cooling_device0
[    0.588312] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.609043] thermal LNXTHERM:01: registered as thermal_zone0
[    0.609222] ACPI: Thermal Zone [TZ00] (52 C)
[    0.611560] ACPI: Battery Slot [BAT0] (battery absent)
[    0.646728] Non-volatile memory driver v1.3
[    0.646812] Linux agpgart interface v0.103
[    0.646959] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    0.647611] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.651824] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.652793] [drm] Initialized drm 1.1.0 20060810
[    0.653390] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.653482] pci 0000:00:02.0: setting latency timer to 64
[    0.659709] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[    0.659878] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.669502] loop: module loaded
[    0.669990] Driver 'sd' needs updating - please use bus_type methods
[    0.670550] ahci 0000:00:1f.2: version 3.0
[    0.670598] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.670744] ahci 0000:00:1f.2: PCI INT B disabled
[    0.670850] ahci: probe of 0000:00:1f.2 failed with error -22
[    0.671586] ata_piix 0000:00:1f.2: version 2.13
[    0.671610] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.671704] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    0.672162] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.672488] scsi0 : ata_piix
[    0.675879] scsi1 : ata_piix
[    0.702473] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.702563] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.703472] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    0.703556] Copyright (c) 2007 Atheros Corporation.
[    0.703727] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.703824] atl2 0000:03:00.0: setting latency timer to 64
[    0.744079] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.744281] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.744417] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.744427] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.746984] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.751230] ehci_hcd 0000:00:1d.7: debug port 1
[    0.751316] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.751386] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    0.761071] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.762590] usb usb1: configuration #1 chosen from 1 choice
[    0.763650] hub 1-0:1.0: USB hub found
[    0.763926] hub 1-0:1.0: 8 ports detected
[    0.767427] uhci_hcd: USB Universal Host Controller Interface driver
[    0.768193] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.768306] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.768316] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.768884] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.769177] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    0.770451] usb usb2: configuration #1 chosen from 1 choice
[    0.771104] hub 2-0:1.0: USB hub found
[    0.771357] hub 2-0:1.0: 2 ports detected
[    0.772950] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.773090] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.773100] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.773672] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.773883] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    0.775241] usb usb3: configuration #1 chosen from 1 choice
[    0.775853] hub 3-0:1.0: USB hub found
[    0.775977] hub 3-0:1.0: 2 ports detected
[    0.777501] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.777612] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.777622] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.778283] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.778491] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    0.779572] usb usb4: configuration #1 chosen from 1 choice
[    0.780344] hub 4-0:1.0: USB hub found
[    0.780470] hub 4-0:1.0: 2 ports detected
[    0.781994] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.782224] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.782234] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.782867] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.783104] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    0.784290] usb usb5: configuration #1 chosen from 1 choice
[    0.784937] hub 5-0:1.0: USB hub found
[    0.785090] hub 5-0:1.0: 2 ports detected
[    0.786929] Initializing USB Mass Storage driver...
[    0.787461] usbcore: registered new interface driver usb-storage
[    0.787557] USB Mass Storage support registered.
[    0.788628] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.788924] drivers/input/serio/i8042.c: 1c <- i8042 (flush, kbd) [1]
[    0.789758] drivers/input/serio/i8042.c: 20 -> i8042 (command) [2]
[    0.789770] drivers/input/serio/i8042.c: 65 <- i8042 (return) [2]
[    0.789807] drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
[    0.790017] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [2]
[    0.791788] drivers/input/serio/i8042.c: 1c <- i8042 (flush, kbd) [4]
[    0.792598] drivers/input/serio/i8042.c: d3 -> i8042 (command) [4]
[    0.792598] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [4]
[    0.792598] drivers/input/serio/i8042.c:      -- i8042 (auxerr) [4]
[    0.796508] drivers/input/serio/i8042.c: a9 -> i8042 (command) [8]
[    0.796519] drivers/input/serio/i8042.c: 1c <- i8042 (return) [8]
[    0.796584] drivers/input/serio/i8042.c: Interrupt 1, without any data [9]
[    0.796618] drivers/input/serio/i8042.c: Interrupt 1, without any data [9]
[    0.797533] drivers/input/serio/i8042.c: 60 -> i8042 (command) [9]
[    0.797533] drivers/input/serio/i8042.c: 65 -> i8042 (parameter) [9]
[    0.799826] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.800485] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 0, 1) [13]
[    0.801313] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [14]
[    0.801809] mice: PS/2 mouse device common for all mice
[    0.804058] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [17]
[    0.805714] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [18]
[    0.805955] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [18]
[    0.806554] rtc_cmos 00:03: RTC can wake from S4
[    0.807499] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.807635] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.808259] Linux video capture interface: v2.00
[    0.809378] usbcore: registered new interface driver uvcvideo
[    0.809469] USB Video Class driver (v0.1.0)
[    0.810687] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [23]
[    0.811366] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [24]
[    0.811902] cpuidle: using governor ladder
[    0.812048] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [25]
[    0.812271] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [25]
[    0.815567] cpuidle: using governor menu
[    0.815655] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [28]
[    0.815765] eeepc: Eee PC Hotkey Driver
[    0.816750] eeepc: Hotkey init flags 0x41
[    0.817035] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [30]
[    0.819207] eeepc: Get control methods supported: 0x101711
[    0.819620] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [32]
[    0.819940] input: Asus EeePC extra buttons as /devices/virtual/input/input4
[    0.821210] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [34]
[    0.823465] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [36]
[    0.824213] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [37]
[    0.826511] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [39]
[    0.829584] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [42]
[    0.831236] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [44]
[    0.831302] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [44]
[    0.831642] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.833484] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.833702] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.834817] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [47]
[    0.836126] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    0.836363] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [49]
[    0.838183] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [51]
[    0.839942] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [52]
[    0.841981] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [54]
[    0.844700] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [57]
[    0.846577] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [59]
[    0.849524] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [62]
[    0.851338] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [64]
[    0.864886] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [77]
[    0.865903] hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
[    0.866044] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [79]
[    0.866082] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    0.866160]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.866236]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    0.866309]    mono: mono_out=0x0
[    0.866380]    inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
[    0.868580] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [81]
[    0.870480] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [83]
[    0.872667] ALSA device list:
[    0.872748]   #0: HDA Intel at 0xf7eb8000 irq 16
[    0.872957] TCP cubic registered
[    0.873059] NET: Registered protocol family 17
[    0.873244] Using IPI Shortcut mode
[    0.873408] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [86]
[    0.875503]   Magic number: 9:16:372
[    0.875869] rtc_cmos 00:03: setting system clock to 2009-05-18 08:23:09 UTC (1242634989)
[    0.888136] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [101]
[    0.919050] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [132]
[    0.950263] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [163]
[    0.981517] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [194]
[    1.012814] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [225]
[    1.022422] ata2.00: CFA: ASUS-PHISON OB SSD, TST2.04P, max UDMA/66
[    1.022510] ata2.00: 7880544 sectors, multi 0: LBA 
[    1.022660] ata2.01: CFA: ASUS-PHISON SSD, TST2.04P, max UDMA/66
[    1.022740] ata2.01: 31522176 sectors, multi 0: LBA 
[    1.026355] ata2.00: configured for UDMA/66
[    1.029344] ata2.01: configured for UDMA/66
[    1.030678] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON OB S TST2 PQ: 0 ANSI: 5
[    1.033872] scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
[    1.034864] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: (4.03 GB/3.75 GiB)
[    1.035103] sd 1:0:0:0: [sda] Write Protect is off
[    1.035181] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.035366] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.036651]  sda: sda1 sda2 sda3 sda4
[    1.040990] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: (16.1 GB/15.0 GiB)
[    1.041228] sd 1:0:1:0: [sdb] Write Protect is off
[    1.041306] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    1.041492] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.042417]  sdb: sdb1 sdb2
[    1.044874] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [257]
[    1.049676] sd 1:0:1:0: [sdb] Attached SCSI disk
[    1.050226] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.054915] EXT2-fs warning (device sdb2): ext2_fill_super: mounting ext3 filesystem as ext2
[    1.055359] VFS: Mounted root (ext2 filesystem) readonly on device 8:18.
[    1.055632] Freeing unused kernel memory: 308k freed
[    1.056757] Write protecting the kernel text: 3292k
[    1.056838] Testing CPA: Reverting c0100000-c0437000
[    1.057550] Testing CPA: write protecting again
[    1.058469] Write protecting the kernel read-only data: 1108k
[    1.058554] Testing CPA: undo c0437000-c054c000
[    1.058840] Testing CPA: write protecting again
[    1.067183] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    1.075289] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [288]
[    1.106590] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [319]
[    1.138655] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [351]
[    1.169192] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [382]
[    1.183654] usb 1-5: configuration #1 chosen from 1 choice
[    1.185318] scsi2 : SCSI emulation for USB Mass Storage devices
[    1.189614] usb-storage: device found at 2
[    1.190575] usb-storage: device scan complete
[    1.192749] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[    1.200316] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [413]
[    1.213753] sd 2:0:0:0: [sdc] Attached SCSI removable disk
[    1.232428] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [445]
[    1.262808] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [475]
[    1.294049] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [507]
[    1.325992] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [538]
[    1.356631] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [569]
[    1.387866] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [600]
[    1.391041] Clocksource tsc unstable (delta = -215847062 ns)
[    1.417459] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [630]
[   11.080731] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [10293]
[   11.083430] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [10296]
[   11.218923] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [10431]
[   11.222792] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [10435]
[   11.363733] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [10576]
[   11.365874] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [10578]
[   11.465088] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [10678]
[   11.468860] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [10681]
[   11.635919] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [10848]
[   11.739533] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [10952]
[   12.378345] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [11591]
[   12.481811] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [11694]
[   12.623698] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [11836]
[   12.626659] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [11839]
[   12.915155] drivers/input/serio/i8042.c: 2f <- i8042 (interrupt, 0, 1) [12128]
[   13.021847] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [12234]
[   13.092665] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [12305]
[   13.127370] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 0, 1) [12340]
[   15.196069] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [14409]
[   15.437147] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [14650]
[   15.468489] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [14681]
[   15.475330] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [14688]
[   15.615637] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [14828]
[   15.826080] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [15039]
[   15.932943] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [15145]
[   16.388675] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [15601]
[   16.460391] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [15673]
[   16.495060] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [15708]
[   16.614953] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 0, 1) [15827]
[   16.756156] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [15969]
[   16.826904] drivers/input/serio/i8042.c: 91 <- i8042 (interrupt, 0, 1) [16039]
[   16.861950] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [16074]
[   16.898213] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [16111]
[   16.932532] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [16145]
[   17.306429] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [16519]
[   17.412370] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [16625]
[   22.696829] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [21909]
[   22.938780] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22151]
[   22.970099] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22183]
[   23.001372] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22214]
[   23.032545] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22245]
[   23.064602] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22277]
[   23.095020] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22308]
[   23.126393] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22339]
[   23.158323] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22371]
[   23.188752] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22401]
[   23.220018] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22433]
[   23.252101] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22465]
[   23.282549] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22495]
[   23.313812] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22526]
[   23.345953] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22558]
[   23.376432] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22589]
[   23.407537] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22620]
[   23.439559] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22652]
[   23.470137] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22683]
[   23.501411] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22714]
[   23.532981] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [22745]
[   23.539101] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [22752]
[   23.715865] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [22928]
[   23.750886] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [22963]
[   29.330006] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [28542]
[   29.541115] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [28754]
[   29.646181] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [28859]
[   29.681130] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [28894]
[   29.845601] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [29058]
[   29.985679] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [29198]
[   30.030717] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [29243]
[   30.098934] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [29311]
[   30.490099] CPA self-test:
[   30.490293]  4k 4094 large 218 gb 0 x 4312[c0000000-f77fd000] miss 0
[   30.518158]  4k 189438 large 37 gb 0 x 189475[c0000000-f77fd000] miss 0
[   30.541052]  4k 189438 large 37 gb 0 x 189475[c0000000-f77fd000] miss 0
[   30.541057] ok.
[   30.692570] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [29905]
[   30.799187] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [30012]
[   31.015167] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [30228]
[   31.224414] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [30437]
[   31.331018] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [30544]
[   31.334752] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [30547]
[   31.518807] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [30731]
[   31.658722] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [30871]
[   31.758353] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [30971]
[   31.866608] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [31079]
[   31.868441] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [31081]
[   31.935562] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [31148]
[   32.006157] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [31219]
[   32.040968] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [31253]
[   32.486591] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [31699]
[   32.498274] drivers/input/serio/i8042.c: Interrupt 1, without any data [31711]
[   32.498294] drivers/input/serio/i8042.c: 60 -> i8042 (command) [31711]
[   32.499014] drivers/input/serio/i8042.c: 65 -> i8042 (parameter) [31711]
[   32.500049] drivers/input/serio/i8042.c: 20 -> i8042 (command) [31712]
[   32.500049] drivers/input/serio/i8042.c: 65 <- i8042 (return) [31712]
[   32.500607] drivers/input/serio/i8042.c: 60 -> i8042 (command) [31713]
[   32.501445] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [31713]
[   32.502302] drivers/input/serio/i8042.c: d3 -> i8042 (command) [31714]
[   32.502460] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [31714]
[   32.502460] drivers/input/serio/i8042.c: 5a <- i8042 (return) [31714]
[   32.504059] drivers/input/serio/i8042.c: a7 -> i8042 (command) [31716]
[   32.505073] drivers/input/serio/i8042.c: 20 -> i8042 (command) [31717]
[   32.505073] drivers/input/serio/i8042.c: 74 <- i8042 (return) [31717]
[   32.505774] drivers/input/serio/i8042.c: a8 -> i8042 (command) [31718]
[   32.506764] drivers/input/serio/i8042.c: 20 -> i8042 (command) [31718]
[   32.506764] drivers/input/serio/i8042.c: 54 <- i8042 (return) [31718]
[   32.507564] drivers/input/serio/i8042.c: 60 -> i8042 (command) [31720]
[   32.508466] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [31720]
[   32.509576] drivers/input/serio/i8042.c: d3 -> i8042 (command) [31721]
[   32.509576] drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [31721]
[   32.516430] drivers/input/serio/i8042.c: 60 -> i8042 (command) [31729]
[   32.517018] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [31729]
[   32.518272] drivers/input/serio/i8042.c: d3 -> i8042 (command) [31730]
[   32.518553] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [31730]
[   32.518553] drivers/input/serio/i8042.c: f0 <- i8042 (return) [31730]
[   32.521752] drivers/input/serio/i8042.c: d3 -> i8042 (command) [31734]
[   32.522419] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [31734]
[   32.522419] drivers/input/serio/i8042.c: 56 <- i8042 (return) [31734]
[   32.525374] drivers/input/serio/i8042.c: d3 -> i8042 (command) [31738]
[   32.526053] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [31738]
[   32.526053] drivers/input/serio/i8042.c: a4 <- i8042 (return) [31738]
[   32.532581] drivers/input/serio/i8042.c: Interrupt 12, without any data [31745]
[   32.532599] drivers/input/serio/i8042.c: 60 -> i8042 (command) [31745]
[   32.533037] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [31745]
[   32.533412] drivers/input/serio/i8042.c: Interrupt 1, without any data [31746]
[   32.534356] drivers/input/serio/i8042.c: 60 -> i8042 (command) [31746]
[   32.534356] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [31746]
[   32.536215] serio: i8042 KBD port at 0x60,0x64 irq 1
[   32.536284] serio: i8042 AUX port at 0x60,0x64 irq 12
[   32.537197] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [31749]
[   32.542611] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [31755]
[   32.543325] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [31756]
[   32.544804] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [31757]
[   32.544849] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [31757]
[   32.547198] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [31760]
[   32.547238] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [31760]
[   32.550192] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [31763]
[   32.550239] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [31763]
[   32.552551] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [31765]
[   32.552590] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [31765]
[   32.555572] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [31768]
[   32.555611] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [31768]
[   32.558301] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [31771]
[   32.558927] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio1/input/input6
[   32.559650] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31772]
[   32.560019] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [31772]
[   32.569229] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31782]
[   32.569926] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [31782]
[   32.570608] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31783]
[   32.571020] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [31783]
[   32.579069] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31792]
[   32.579796] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [31792]
[   32.579844] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31792]
[   32.580018] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [31792]
[   32.585008] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31797]
[   32.585102] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31798]
[   32.586046] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31798]
[   32.590935] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31803]
[   32.590982] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31803]
[   32.591017] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [31803]
[   32.596741] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31809]
[   32.596798] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31809]
[   32.597015] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [31809]
[   32.599507] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [31812]
[   32.603692] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31816]
[   32.603749] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31816]
[   32.604020] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [31816]
[   32.608889] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31821]
[   32.608945] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31821]
[   32.609019] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31821]
[   32.614165] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31827]
[   32.614216] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31827]
[   32.615017] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [31827]
[   32.619583] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31832]
[   32.621492] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31834]
[   32.622030] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31834]
[   32.626767] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31839]
[   32.626803] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31839]
[   32.627757] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [31839]
[   32.633306] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31846]
[   32.633349] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31846]
[   32.634293] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31846]
[   32.638601] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31851]
[   32.638637] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31851]
[   32.639589] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [31851]
[   32.643876] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31856]
[   32.643917] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31856]
[   32.644864] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31856]
[   32.649177] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31862]
[   32.649212] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31862]
[   32.650165] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [31862]
[   32.654539] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31867]
[   32.654579] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31867]
[   32.655527] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31867]
[   32.659922] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31872]
[   32.659957] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31872]
[   32.660910] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [31872]
[   32.664775] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31877]
[   32.664815] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31877]
[   32.665763] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31877]
[   32.670085] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31883]
[   32.670120] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31883]
[   32.671073] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [31883]
[   32.675898] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31888]
[   32.675939] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31888]
[   32.676886] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31888]
[   32.682510] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31895]
[   32.682546] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31895]
[   32.683498] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [31895]
[   32.687625] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31900]
[   32.687665] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31900]
[   32.688613] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31900]
[   32.692938] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31905]
[   32.692974] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31905]
[   32.693927] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [31905]
[   32.698325] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31911]
[   32.698366] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31911]
[   32.699313] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [31911]
[   32.703612] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31916]
[   32.703648] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31916]
[   32.704601] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [31916]
[   32.708983] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31921]
[   32.709043] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31922]
[   32.709972] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [31922]
[   32.716990] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31929]
[   32.717690] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [31930]
[   32.717731] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31930]
[   32.718680] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [31930]
[   32.723060] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31936]
[   32.723096] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31936]
[   32.724048] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [31936]
[   32.728412] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31941]
[   32.728453] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31941]
[   32.729401] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [31941]
[   32.733749] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31946]
[   32.733785] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31946]
[   32.734738] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [31946]
[   32.738657] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31951]
[   32.738697] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31951]
[   32.739645] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [31951]
[   32.743982] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31956]
[   32.744034] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31957]
[   32.744970] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [31957]
[   32.749807] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31962]
[   32.749847] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31962]
[   32.750795] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [31962]
[   32.756338] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31969]
[   32.756374] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31969]
[   32.757326] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [31969]
[   32.761567] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31974]
[   32.761608] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31974]
[   32.762555] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [31974]
[   32.773202] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31986]
[   32.773828] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [31986]
[   32.774610] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [31987]
[   32.776130] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 1, 12) [31989]
[   32.776169] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31989]
[   32.777119] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [31989]
[   32.781357] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31994]
[   32.781397] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31994]
[   32.782345] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [31994]
[   32.786675] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [31999]
[   32.786710] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31999]
[   32.787663] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [31999]
[   32.792061] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32005]
[   32.792102] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32005]
[   32.793050] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32005]
[   32.797541] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32010]
[   32.797581] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32010]
[   32.798529] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32010]
[   32.802767] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32015]
[   32.802807] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32015]
[   32.803755] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32015]
[   32.808103] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32021]
[   32.808144] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32021]
[   32.809091] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [32021]
[   32.820359] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32033]
[   32.821123] drivers/input/serio/i8042.c: 3c <- i8042 (interrupt, 1, 12) [32034]
[   32.821839] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [32034]
[   32.822605] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 1, 12) [32035]
[   32.822643] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32035]
[   32.823593] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32035]
[   32.828430] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32041]
[   32.828466] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32041]
[   32.829418] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [32041]
[   32.834259] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32047]
[   32.834299] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32047]
[   32.835247] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32047]
[   32.840164] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32053]
[   32.840205] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32053]
[   32.841152] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32053]
[   32.845461] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32058]
[   32.845501] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32058]
[   32.846449] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32058]
[   32.850827] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32063]
[   32.850867] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32063]
[   32.851815] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [32063]
[   32.861973] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32074]
[   32.862669] drivers/input/serio/i8042.c: 3c <- i8042 (interrupt, 1, 12) [32075]
[   32.863367] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [32076]
[   32.864932] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 1, 12) [32077]
[   32.864972] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32077]
[   32.865921] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32077]
[   32.870186] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32083]
[   32.870226] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32083]
[   32.871174] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32083]
[   32.875561] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32088]
[   32.875597] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32088]
[   32.876549] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [32088]
[   32.880898] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32093]
[   32.880938] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32093]
[   32.881886] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32093]
[   32.886212] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32099]
[   32.886248] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32099]
[   32.887200] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [32099]
[   32.891100] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32104]
[   32.891140] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32104]
[   32.892088] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32104]
[   32.895996] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32108]
[   32.896033] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32109]
[   32.896984] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [32109]
[   32.901287] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32114]
[   32.901327] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32114]
[   32.902275] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32114]
[   32.907118] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32120]
[   32.907155] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32120]
[   32.908107] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [32120]
[   32.912982] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32125]
[   32.913037] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32126]
[   32.913970] drivers/input/serio/i8042.c: eb -> i8042 (parameter) [32126]
[   32.919283] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32132]
[   33.419106] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32632]
[   33.419841] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [32632]
[   33.424352] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32637]
[   33.424393] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32637]
[   33.425340] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32637]
[   33.430756] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32643]
[   33.430792] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32643]
[   33.431745] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [32643]
[   33.436105] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32649]
[   33.436146] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32649]
[   33.437093] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32649]
[   33.441392] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32654]
[   33.441428] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32654]
[   33.442380] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [32654]
[   33.446714] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32659]
[   33.446754] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32659]
[   33.447702] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32659]
[   33.452133] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32665]
[   33.452169] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32665]
[   33.453122] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [32665]
[   33.457402] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32670]
[   33.457442] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32670]
[   33.458390] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [32670]
[   33.462760] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32675]
[   33.462795] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32675]
[   33.463748] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [32675]
[   33.468600] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32681]
[   33.468640] drivers/input/serio/i8042.c: d4 -> i8042 (command) [32681]
[   33.469588] drivers/input/serio/i8042.c: eb -> i8042 (parameter) [32681]
[   33.475065] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [32688]
[   33.975105] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33188]
[   33.975840] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [33188]
[   33.980450] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33193]
[   33.980490] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33193]
[   33.981438] drivers/input/serio/i8042.c: ff -> i8042 (parameter) [33193]
[   33.987077] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33200]
[   34.371459] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 1, 12) [33584]
[   34.372101] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [33585]
[   34.372140] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33585]
[   34.373089] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33585]
[   34.378394] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33591]
[   34.378430] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33591]
[   34.379382] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [33591]
[   34.383689] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33596]
[   34.383729] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33596]
[   34.384677] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33596]
[   34.388987] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33601]
[   34.389027] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33602]
[   34.389975] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [33602]
[   34.394294] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33607]
[   34.394334] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33607]
[   34.395282] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33607]
[   34.399690] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33612]
[   34.399726] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33612]
[   34.400678] drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [33612]
[   34.404975] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33617]
[   34.405032] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33618]
[   34.406009] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [33618]
[   34.413269] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33626]
[   34.414003] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [33626]
[   34.414046] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33627]
[   34.414994] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33627]
[   34.419581] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33632]
[   34.419617] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33632]
[   34.420569] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [33632]
[   34.425002] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33637]
[   34.425045] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33638]
[   34.425991] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33638]
[   34.430747] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33643]
[   34.430782] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33643]
[   34.431735] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [33643]
[   34.437473] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33650]
[   34.437514] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33650]
[   34.438462] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33650]
[   34.442895] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33655]
[   34.442931] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33655]
[   34.443884] drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [33655]
[   34.448244] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33661]
[   34.448284] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33661]
[   34.449232] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [33661]
[   34.455554] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33668]
[   34.457059] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [33670]
[   34.457100] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33670]
[   34.458048] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33670]
[   34.462377] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33675]
[   34.462413] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33675]
[   34.463366] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [33675]
[   34.467676] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33680]
[   34.467716] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33680]
[   34.468664] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33680]
[   34.473012] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33686]
[   34.473048] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33686]
[   34.474001] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [33686]
[   34.478350] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33691]
[   34.478390] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33691]
[   34.479338] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33691]
[   34.483683] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33696]
[   34.483719] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33696]
[   34.484672] drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [33696]
[   34.488598] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33701]
[   34.488638] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33701]
[   34.489586] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [33701]
[   34.496488] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33709]
[   34.497133] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [33710]
[   34.497179] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33710]
[   34.498122] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [33710]
[   34.502659] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33715]
[   34.502695] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33715]
[   34.503647] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [33715]
[   34.508057] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33721]
[   34.508097] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33721]
[   34.509045] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [33721]
[   34.512899] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33725]
[   34.512934] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33725]
[   34.513887] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [33725]
[   34.518178] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33731]
[   34.518219] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33731]
[   34.519167] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [33731]
[   34.523066] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33736]
[   34.535994] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio2/input/input7
[   34.536796] drivers/input/serio/i8042.c: d4 -> i8042 (command) [33749]
[   34.537021] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [33749]
[   34.541419] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [33754]
[   34.925065] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [34138]
[   35.100771] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [34313]
[   35.171718] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [34384]
[   35.206524] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [34419]
[   35.392515] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 0, 1) [34605]
[   35.565872] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [34778]
[   35.636854] drivers/input/serio/i8042.c: 91 <- i8042 (interrupt, 0, 1) [34849]
[   35.639725] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [34852]
[   35.671216] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [34884]
[   35.741784] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [34954]
[   36.012399] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [35225]
[   36.152163] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [35365]
[   37.432502] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [36645]
[   37.435044] drivers/input/serio/i8042.c: e9 <- i8042 (interrupt, 1, 12) [36648]
[   37.437294] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [36650]
[   37.439966] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36652]
[   37.445522] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36658]
[   37.447454] drivers/input/serio/i8042.c: ee <- i8042 (interrupt, 1, 12) [36660]
[   37.449826] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36662]
[   37.451792] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36664]
[   37.457652] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36670]
[   37.459794] drivers/input/serio/i8042.c: e7 <- i8042 (interrupt, 1, 12) [36672]
[   37.461933] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36674]
[   37.464594] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36677]
[   37.469697] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36682]
[   37.471643] drivers/input/serio/i8042.c: eb <- i8042 (interrupt, 1, 12) [36684]
[   37.473555] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36686]
[   37.475663] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36688]
[   37.481787] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36694]
[   37.484256] drivers/input/serio/i8042.c: e6 <- i8042 (interrupt, 1, 12) [36697]
[   37.486591] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36699]
[   37.489194] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36702]
[   37.494132] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36707]
[   37.496240] drivers/input/serio/i8042.c: ed <- i8042 (interrupt, 1, 12) [36709]
[   37.499069] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36712]
[   37.501131] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36714]
[   37.505466] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36718]
[   37.507371] drivers/input/serio/i8042.c: e6 <- i8042 (interrupt, 1, 12) [36720]
[   37.509582] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36722]
[   37.511736] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36724]
[   37.518751] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36731]
[   37.520901] drivers/input/serio/i8042.c: ed <- i8042 (interrupt, 1, 12) [36733]
[   37.523685] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36736]
[   37.525735] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36738]
[   37.529591] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36742]
[   37.531533] drivers/input/serio/i8042.c: e9 <- i8042 (interrupt, 1, 12) [36744]
[   37.533591] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36746]
[   37.535872] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36748]
[   37.542170] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36755]
[   37.544269] drivers/input/serio/i8042.c: f0 <- i8042 (interrupt, 1, 12) [36757]
[   37.546504] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36759]
[   37.548623] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36761]
[   37.553757] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36766]
[   37.555677] drivers/input/serio/i8042.c: ec <- i8042 (interrupt, 1, 12) [36768]
[   37.558088] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36771]
[   37.560054] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36773]
[   37.566282] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36779]
[   37.568375] drivers/input/serio/i8042.c: f2 <- i8042 (interrupt, 1, 12) [36781]
[   37.570667] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36783]
[   37.572866] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36785]
[   37.578031] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36791]
[   37.580296] drivers/input/serio/i8042.c: ef <- i8042 (interrupt, 1, 12) [36793]
[   37.582723] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36795]
[   37.584796] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36797]
[   37.590003] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36802]
[   37.592560] drivers/input/serio/i8042.c: f5 <- i8042 (interrupt, 1, 12) [36805]
[   37.594791] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36807]
[   37.597498] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36810]
[   37.602443] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36815]
[   37.604493] drivers/input/serio/i8042.c: f4 <- i8042 (interrupt, 1, 12) [36817]
[   37.606405] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36819]
[   37.608344] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36821]
[   37.614615] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36827]
[   37.617229] drivers/input/serio/i8042.c: f8 <- i8042 (interrupt, 1, 12) [36830]
[   37.619449] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36832]
[   37.622109] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36835]
[   37.626214] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36839]
[   37.628341] drivers/input/serio/i8042.c: f7 <- i8042 (interrupt, 1, 12) [36841]
[   37.630606] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36843]
[   37.632499] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36845]
[   37.638797] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36851]
[   37.640697] drivers/input/serio/i8042.c: fb <- i8042 (interrupt, 1, 12) [36853]
[   37.642824] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36855]
[   37.645066] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36858]
[   37.650381] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36863]
[   37.652481] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [36865]
[   37.654746] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36867]
[   37.656877] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36869]
[   37.662479] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36875]
[   37.664387] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [36877]
[   37.666457] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [36879]
[   37.668749] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36881]
[   37.674628] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36887]
[   37.676927] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [36889]
[   37.678847] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36891]
[   37.681209] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36894]
[   37.698180] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36911]
[   37.700879] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [36913]
[   37.703025] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36916]
[   37.704930] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36917]
[   37.722346] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [36935]
[   37.724247] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [36937]
[   37.726378] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36939]
[   37.728643] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36941]
[   37.867019] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37080]
[   37.869230] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [37082]
[   37.871353] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37084]
[   37.873484] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37086]
[   37.879613] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [37092]
[   37.881517] drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 1, 12) [37094]
[   37.883728] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37096]
[   37.885863] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37098]
[   37.891677] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [37104]
[   37.893788] drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 1, 12) [37106]
[   37.895984] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37108]
[   37.898139] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37111]
[   37.904213] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37117]
[   37.906175] drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 1, 12) [37119]
[   37.908068] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37121]
[   37.910030] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37123]
[   37.916323] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [37129]
[   37.918246] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 1, 12) [37131]
[   37.920136] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37133]
[   37.922409] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37135]
[   37.928414] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37141]
[   37.930760] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 1, 12) [37143]
[   37.932864] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37145]
[   37.935133] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37148]
[   37.940006] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37152]
[   37.942144] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 1, 12) [37155]
[   37.944295] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37157]
[   37.947017] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37160]
[   37.952561] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37165]
[   37.954465] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 1, 12) [37167]
[   37.956838] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37169]
[   37.958816] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37171]
[   37.964626] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37177]
[   37.966752] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 1, 12) [37179]
[   37.968960] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37181]
[   37.971621] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37184]
[   37.976578] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37189]
[   37.978613] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 1, 12) [37191]
[   37.980586] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37193]
[   37.982725] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37195]
[   37.988780] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37201]
[   37.991334] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 1, 12) [37204]
[   37.993599] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37206]
[   37.996260] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37209]
[   38.001274] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37214]
[   38.003271] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 1, 12) [37216]
[   38.005183] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37218]
[   38.007406] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37220]
[   38.012908] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37225]
[   38.014824] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 1, 12) [37227]
[   38.017032] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37230]
[   38.019170] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37232]
[   38.024519] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37237]
[   38.026638] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 1, 12) [37239]
[   38.028865] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37241]
[   38.031240] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37244]
[   38.036580] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37249]
[   38.038454] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 1, 12) [37251]
[   38.040519] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37253]
[   38.042801] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37255]
[   38.049144] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37262]
[   38.051247] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 1, 12) [37264]
[   38.053466] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37266]
[   38.055597] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37268]
[   38.060727] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37273]
[   38.062692] drivers/input/serio/i8042.c: 0c <- i8042 (interrupt, 1, 12) [37275]
[   38.065165] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [37278]
[   38.067484] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37280]
[   38.072852] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37285]
[   38.075006] drivers/input/serio/i8042.c: 06 <- i8042 (interrupt, 1, 12) [37287]
[   38.077225] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37290]
[   38.079928] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37292]
[   38.084902] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37297]
[   38.086809] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [37299]
[   38.088771] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37301]
[   38.090986] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37303]
[   38.096942] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37309]
[   38.099614] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [37312]
[   38.101818] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37314]
[   38.104548] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37317]
[   38.109505] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [37322]
[   38.111413] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [37324]
[   38.113425] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37326]
[   38.115552] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37328]
[   38.121159] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [37334]
[   38.123062] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [37336]
[   38.124986] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37337]
[   38.126936] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37339]
[   38.134094] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [37347]
[   38.136128] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [37349]
[   38.138010] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37351]
[   38.140129] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37353]
[   38.193151] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [37406]
[   38.195416] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [37408]
[   38.198084] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37411]
[   38.200250] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37413]
[   38.208233] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [37421]
[   38.210482] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37423]
[   38.212913] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [37425]
[   38.215274] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [37428]
[   40.913462] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [40126]
[   41.154735] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [40367]
[   41.185904] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [40398]
[   41.193695] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [40406]
[   41.333768] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [40546]
[   41.438182] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [40651]
[   42.470859] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [41683]
[   42.575429] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [41788]
[   42.645690] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [41858]
[   42.649635] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [41862]
[   42.686322] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [41899]
[   42.790776] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [42003]
[   43.048792] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [42261]
[   43.153446] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [42366]
[   43.158710] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [42371]
[   43.263580] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [42476]
[   43.290223] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [42503]
[   43.397026] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [42610]
[   43.502613] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [42715]
[   43.506715] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [42719]
[   43.509360] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [42722]
[   43.571413] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [42784]
[   43.608154] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [42821]
[   43.713170] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [42926]
[   43.806165] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [43019]
[   43.911339] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [43124]
[   44.018408] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [43231]
[   44.088280] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [43301]
[   44.092112] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [43305]
[   44.157731] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [43370]
[   44.203956] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [43416]
[   44.306860] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [43519]
[   44.346306] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [43559]
[   44.451471] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [43664]
[   44.518815] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [43731]
[   44.693292] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [43906]
[   44.870393] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [44083]

-- 
Sitsofe | http://sucs.org/~sits/
