Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYB0Sie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYB0Sie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYB0SiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:38:24 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:34968 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbYB0SiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:38:22 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
X-Message-Flag: Warning: May contain useful information
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 10:38:07 -0800
In-Reply-To: <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de> (Thomas Gleixner's message of "Wed, 27 Feb 2008 19:14:40 +0100 (CET)")
Message-ID: <ada1w6y1bzk.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Feb 2008 18:38:08.0378 (UTC) FILETIME=[E5CC95A0:01C8796F]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Can you provide a full boot log please ?

Sure, below.

For this boot I blacklisted the hpwdt module and then loaded it by
hand at the very end, so the oops is the last thing.

[    0.000000] Linux version 2.6.25-rc3 (rdreier@roland-xeon-1) (gcc version 4.2.3 (Debian 4.2.3-1)) #51 SMP Tue Feb 26 22:59:43 PST 2008
[    0.000000] Command line: root=/dev/cciss/c0d0p6 ro console=ttyS0,57600 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe56000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe56000 - 00000000bfe5e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfe5e000 - 00000000bfe5f000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe5f000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001bffff000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 786006) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 786014, 786015) 2 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1835007) 3 entries of 3200 used
[    0.000000] end_pfn_map = 1835007
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F4F00, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT BFE567C0, 0074 (r1 HP     ProLiant        2   Ò     162E)
[    0.000000] ACPI: FACP BFE56840, 00F4 (r3 HP     ProLiant        2   Ò     162E)
[    0.000000] ACPI: DSDT BFE56940, 22E7 (r1 HP         DSDT        1 INTL 20030228)
[    0.000000] ACPI: FACS BFE56100, 0040
[    0.000000] ACPI: SPCR BFE56140, 0050 (r1 HP     SPCRRBSU        1   Ò     162E)
[    0.000000] ACPI: MCFG BFE561C0, 003C (r1 HP     ProLiant        1             0)
[    0.000000] ACPI: HPET BFE56200, 0038 (r1 HP     ProLiant        2   Ò     162E)
[    0.000000] ACPI: SPMI BFE56240, 0040 (r5 HP     ProLiant        1   Ò     162E)
[    0.000000] ACPI: ERST BFE56280, 01D0 (r1 HP     ProLiant        1   Ò     162E)
[    0.000000] ACPI: APIC BFE56480, 009E (r1 HP     ProLiant        2             0)
[    0.000000] ACPI: FFFF BFE56540, 0176 (r1 HP     ProLiant        1   Ò     162E)
[    0.000000] ACPI: BERT BFE566C0, 0030 (r1 HP     ProLiant        1   Ò     162E)
[    0.000000] ACPI: HEST BFE56700, 00BC (r1 HP     ProLiant        1   Ò     162E)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001bffff000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 786006) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 786014, 786015) 2 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1835007) 3 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-00000001bffff000
[    0.000000]   NODE_DATA [0000000000010000 - 0000000000016fff]
[    0.000000]   bootmap [0000000000017000 -  000000000004efff] pages 38
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-9dce87] TEXT DATA BSS
[    0.000000] early res: 3 [9f400-a03ff] EBDA
[    0.000000] early res: 4 [8000-ffff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001400000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001c00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810002c00000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003000000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003400000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003800000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004400000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810004800000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810004c00000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005000000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006000000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810006400000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810006800000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810007800000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810007c00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810008000000 on node 0
[    0.000000]  [ffffe20005800000-ffffe200059fffff] PMD ->ffff810008400000 on node 0
[    0.000000]  [ffffe20005a00000-ffffe20005bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20005c00000-ffffe20005dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20005e00000-ffffe20005ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20006000000-ffffe200061fffff] PMD ->ffff810009000000 on node 0
[    0.000000]  [ffffe20006200000-ffffe200063fffff] PMD ->ffff810009400000 on node 0
[    0.000000]  [ffffe20006400000-ffffe200065fffff] PMD ->ffff810009800000 on node 0
[    0.000000]  [ffffe20006600000-ffffe200067fffff] PMD ->ffff810009c00000 on node 0
[    0.000000]  [ffffe20006800000-ffffe200069fffff] PMD ->ffff810009e00000 on node 0
[    0.000000]  [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff81000a200000 on node 0
[    0.000000]  [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff81000a600000 on node 0
[    0.000000]  [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff81000aa00000 on node 0
[    0.000000]  [ffffe20007000000-ffffe200071fffff] PMD ->ffff81000ac00000 on node 0
[    0.000000]  [ffffe20007200000-ffffe200073fffff] PMD ->ffff81000b000000 on node 0
[    0.000000]  [ffffe20007400000-ffffe200075fffff] PMD ->ffff81000b400000 on node 0
[    0.000000]  [ffffe20007600000-ffffe200077fffff] PMD ->ffff81000b600000 on node 0
[    0.000000]  [ffffe20007800000-ffffe200079fffff] PMD ->ffff81000ba00000 on node 0
[    0.000000]  [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff81000be00000 on node 0
[    0.000000]  [ffffe20007c00000-ffffe20007dfffff] PMD ->ffff81000c200000 on node 0
[    0.000000]  [ffffe20007e00000-ffffe20007ffffff] PMD ->ffff81000c400000 on node 0
[    0.000000]  [ffffe20008000000-ffffe200081fffff] PMD ->ffff81000c800000 on node 0
[    0.000000]  [ffffe20008200000-ffffe200083fffff] PMD ->ffff81000cc00000 on node 0
[    0.000000]  [ffffe20008400000-ffffe200085fffff] PMD ->ffff81000d000000 on node 0
[    0.000000]  [ffffe20008600000-ffffe200087fffff] PMD ->ffff81000d200000 on node 0
[    0.000000]  [ffffe20008800000-ffffe200089fffff] PMD ->ffff81000d600000 on node 0
[    0.000000]  [ffffe20008a00000-ffffe20008bfffff] PMD ->ffff81000da00000 on node 0
[    0.000000]  [ffffe20008c00000-ffffe20008dfffff] PMD ->ffff81000dc00000 on node 0
[    0.000000]  [ffffe20008e00000-ffffe20008ffffff] PMD ->ffff81000e000000 on node 0
[    0.000000]  [ffffe20009000000-ffffe200091fffff] PMD ->ffff81000e400000 on node 0
[    0.000000]  [ffffe20009200000-ffffe200093fffff] PMD ->ffff81000e800000 on node 0
[    0.000000]  [ffffe20009400000-ffffe200095fffff] PMD ->ffff81000ea00000 on node 0
[    0.000000]  [ffffe20009600000-ffffe200097fffff] PMD ->ffff81000ee00000 on node 0
[    0.000000]  [ffffe20009800000-ffffe200099fffff] PMD ->ffff81000f200000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1835007
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   786006
[    0.000000]     0:   786014 ->   786015
[    0.000000]     0:  1048576 ->  1835007
[    0.000000] On node 0 totalpages: 1572341
[    0.000000]   DMA zone: 88 pages used for memmap
[    0.000000]   DMA zone: 2026 pages reserved
[    0.000000]   DMA zone: 1885 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 22440 pages used for memmap
[    0.000000]   DMA32 zone: 759471 pages, LIFO batch:31
[    0.000000]   Normal zone: 16895 pages used for memmap
[    0.000000]   Normal zone: 769536 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] Processor #6
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] Processor #7
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
[    0.000000] PERCPU: Allocating 34848 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1530892
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/cciss/c0d0p6 ro console=ttyS0,57600 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000002] time.c: Detected 3000.010 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [ttyS0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        2048
[    0.004000] ... CLASSHASH_SIZE:           1024
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 1648 kB
[    0.004000]  per task-struct memory footprint: 2688 bytes
[    0.004000] Checking aperture...
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0xf483000 - 0x13483000
[    0.004000] Memory: 6079208k/7340028k available (2193k kernel code, 210156k reserved, 1289k data, 320k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[    0.004000] hpet clockevent registered
[    0.080007] Calibrating delay using timer specific routine.. 6005.34 BogoMIPS (lpj=12010692)
[    0.088699] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.096199] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.104343] Mount-cache hash table entries: 256
[    0.108414] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.116009] CPU: L2 cache: 4096K
[    0.120011] CPU 0/0 -> Node 0
[    0.124010] CPU: Physical Processor ID: 0
[    0.128010] CPU: Processor Core ID: 0
[    0.132014] CPU0: Thermal monitoring enabled (TM2)
[    0.136011] using mwait in idle threads.
[    0.140018] Freeing SMP alternatives: 22k freed
[    0.144027] ACPI: Core revision 20070126
[    0.194208] Using local APIC timer interrupts.
[    0.200014] APIC timer calibration result 20833408
[    0.200015] Detected 20.833 MHz APIC timer.
[    0.204233] lockdep: fixing up alternatives.
[    0.208069] Booting processor 1/4 APIC 0x6
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 6000.15 BogoMIPS (lpj=12000301)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/6 -> Node 0
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    0.300664] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.304123] lockdep: fixing up alternatives.
[    0.308036] Booting processor 2/4 APIC 0x1
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 6000.11 BogoMIPS (lpj=12000237)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 2/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU2: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    0.404455] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.408167] lockdep: fixing up alternatives.
[    0.412061] Booting processor 3/4 APIC 0x7
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 6000.18 BogoMIPS (lpj=12000364)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 3/7 -> Node 0
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU3: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
[    0.504688] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.508059] Brought up 4 CPUs
[    0.512136] CPU0 attaching sched-domain:
[    0.512138]  domain 0: span 05
[    0.512139]   groups: 01 04
[    0.512141]   domain 1: span 0f
[    0.512142]    groups: 05 0a
[    0.512144]    domain 2: span 0f
[    0.512145]     groups: 0f
[    0.512148] CPU1 attaching sched-domain:
[    0.512149]  domain 0: span 0a
[    0.512150]   groups: 02 08
[    0.512152]   domain 1: span 0f
[    0.512153]    groups: 0a 05
[    0.512154]    domain 2: span 0f
[    0.512156]     groups: 0f
[    0.512158] CPU2 attaching sched-domain:
[    0.512159]  domain 0: span 05
[    0.512160]   groups: 04 01
[    0.512162]   domain 1: span 0f
[    0.512163]    groups: 05 0a
[    0.512165]    domain 2: span 0f
[    0.512166]     groups: 0f
[    0.512168] CPU3 attaching sched-domain:
[    0.512169]  domain 0: span 0a
[    0.512170]   groups: 08 02
[    0.512172]   domain 1: span 0f
[    0.512173]    groups: 0a 05
[    0.512175]    domain 2: span 0f
[    0.512176]     groups: 0f
[    0.227144] net_namespace: 520 bytes
[    0.228344] NET: Registered protocol family 16
[    0.232459] ACPI: bus type pci registered
[    0.236211] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.240026] PCI: Not using MMCONFIG.
[    0.244026] PCI: Using configuration type 1
[    0.250399] ACPI: EC: Look up EC in DSDT
[    0.251877] ACPI: Interpreter enabled
[    0.252027] ACPI: (supports S0 S5)
[    0.257087] ACPI: Using IOAPIC for interrupt routing
[    0.268969] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.303594] PCI: Transparent bridge - 0000:00:1e.0
[    0.304086] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.304348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    0.304488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPTA._PRT]
[    0.304580] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPTB._PRT]
[    0.304672] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02._PRT]
[    0.304740] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4._PRT]
[    0.304877] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4.IPE1._PRT]
[    0.305053] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4.IPE2._PRT]
[    0.305229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4.IPE3._PRT]
[    0.305384] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT03._PRT]
[    0.305562] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT04._PRT]
[    0.305739] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT06._PRT]
[    0.313999] ACPI: PCI Interrupt Link [LNKA] (IRQs *5 7 10 11)
[    0.321200] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *7 10 11)
[    0.329196] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 *10 11)
[    0.336669] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.344144] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, disabled.
[    0.352486] ACPI: PCI Interrupt Link [LNKF] (IRQs *5 7 10 11)
[    0.361728] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
[    0.369200] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
[    0.377044] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.380104] pnp: PnP ACPI init
[    0.384048] ACPI: bus type pnp registered
[    0.388231] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.388441]  00:01: calling quirk 0xffffffff803708e6: quirk_supermicro_h8dce_system+0x0/0xe1()
[    0.388553] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.388665] pnp 00:02: Plug and Play ACPI device, IDs IPI0001 (active)
[    0.388816] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.388920] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.389022] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.779506] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.779644] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.779756] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.780222] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.780617] pnp: PnP ACPI: found 10 devices
[    0.784068] ACPI: ACPI bus type pnp unregistered
[    0.788377] usbcore: registered new interface driver usbfs
[    0.792196] usbcore: registered new interface driver hub
[    0.800131] usbcore: registered new device driver usb
[    0.804366] PCI: Using ACPI for IRQ routing
[    0.808069] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.836111] PCI-GART: No AMD northbridge found.
[    0.840074] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.846221] hpet0: 3 64-bit timers, 14318180 Hz
[    0.851882] Time: tsc clocksource has been installed.
[    0.848066] Switched to high resolution mode on CPU 1
[    0.404041] Switched to high resolution mode on CPU 3
[    0.856079] Switched to high resolution mode on CPU 0
[    0.528058] Switched to high resolution mode on CPU 2
[    0.868081] pnp: the driver 'system' has been registered
[    0.868094] system 00:01: ioport range 0x408-0x40f has been reserved
[    0.872074] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.876074] system 00:01: ioport range 0x700-0x71f has been reserved
[    0.880074] system 00:01: ioport range 0x800-0x83f has been reserved
[    0.884074] system 00:01: ioport range 0x900-0x97f has been reserved
[    0.888074] system 00:01: ioport range 0xc80-0xc83 has been reserved
[    0.892075] system 00:01: ioport range 0xcd4-0xcd7 has been reserved
[    0.896075] system 00:01: ioport range 0xf50-0xf58 has been reserved
[    0.900075] system 00:01: ioport range 0xca0-0xca1 has been reserved
[    0.904075] system 00:01: ioport range 0xca4-0xca5 has been reserved
[    0.908076] system 00:01: ioport range 0x2f8-0x2ff has been reserved
[    0.912076] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.916076] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
[    0.920077] system 00:01: driver attached
[    0.921724] PCI: Bridge: 0000:0a:00.0
[    0.924076]   IO window: disabled.
[    0.928169]   MEM window: disabled.
[    0.932123]   PREFETCH window: disabled.
[    0.936215] PCI: Bridge: 0000:0f:04.0
[    0.940077]   IO window: disabled.
[    0.944170]   MEM window: disabled.
[    0.948124]   PREFETCH window: disabled.
[    0.952216] PCI: Bridge: 0000:0e:00.0
[    0.956080]   IO window: 4000-4fff
[    0.960170]   MEM window: 0xfde00000-0xfdefffff
[    0.964125]   PREFETCH window: disabled.
[    0.968216] PCI: Bridge: 0000:0a:01.0
[    0.972079]   IO window: 4000-4fff
[    0.976171]   MEM window: 0xfde00000-0xfdefffff
[    0.980125]   PREFETCH window: disabled.
[    0.984218] PCI: Bridge: 0000:0a:02.0
[    0.988079]   IO window: disabled.
[    0.992172]   MEM window: disabled.
[    0.996126]   PREFETCH window: disabled.
[    1.000218] PCI: Bridge: 0000:09:00.0
[    1.004081]   IO window: 4000-4fff
[    1.008173]   MEM window: 0xfde00000-0xfdefffff
[    1.012127]   PREFETCH window: disabled.
[    1.016219] PCI: Bridge: 0000:09:00.3
[    1.020081]   IO window: disabled.
[    1.024174]   MEM window: disabled.
[    1.028128]   PREFETCH window: disabled.
[    1.032220] PCI: Bridge: 0000:00:02.0
[    1.036083]   IO window: 4000-4fff
[    1.040085]   MEM window: 0xfdd00000-0xfdefffff
[    1.044084]   PREFETCH window: disabled.
[    1.048086] PCI: Bridge: 0000:00:03.0
[    1.052083]   IO window: disabled.
[    1.056087]   MEM window: disabled.
[    1.060085]   PREFETCH window: disabled.
[    1.064087] PCI: Bridge: 0000:00:04.0
[    1.068084]   IO window: disabled.
[    1.072087]   MEM window: 0xfdf00000-0xfdffffff
[    1.076087]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    1.080088] PCI: Bridge: 0000:00:05.0
[    1.084085]   IO window: disabled.
[    1.088088]   MEM window: disabled.
[    1.092087]   PREFETCH window: disabled.
[    1.096089] PCI: Bridge: 0000:00:06.0
[    1.100086]   IO window: disabled.
[    1.104089]   MEM window: disabled.
[    1.108088]   PREFETCH window: disabled.
[    1.112090] PCI: Bridge: 0000:00:07.0
[    1.116087]   IO window: disabled.
[    1.120090]   MEM window: disabled.
[    1.124089]   PREFETCH window: disabled.
[    1.128091] PCI: Bridge: 0000:02:00.0
[    1.132088]   IO window: disabled.
[    1.136093]   MEM window: 0xf8000000-0xf9ffffff
[    1.140092]   PREFETCH window: disabled.
[    1.144095] PCI: Bridge: 0000:00:1c.0
[    1.148089]   IO window: disabled.
[    1.152093]   MEM window: 0xf8000000-0xf9ffffff
[    1.156092]   PREFETCH window: disabled.
[    1.160094] PCI: Bridge: 0000:04:00.0
[    1.164090]   IO window: disabled.
[    1.168095]   MEM window: 0xfa000000-0xfbffffff
[    1.172094]   PREFETCH window: disabled.
[    1.176097] PCI: Bridge: 0000:00:1c.1
[    1.180091]   IO window: disabled.
[    1.184095]   MEM window: 0xfa000000-0xfbffffff
[    1.188095]   PREFETCH window: disabled.
[    1.192097] PCI: Bridge: 0000:00:1e.0
[    1.196093]   IO window: 2000-3fff
[    1.200096]   MEM window: 0xf7e00000-0xf7ffffff
[    1.204095]   PREFETCH window: 0x00000000c8000000-0x00000000cfffffff
[    1.208108] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    1.208569] PCI: Setting latency timer of device 0000:09:00.0 to 64
[    1.209121] ACPI: PCI Interrupt 0000:0a:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.216141] PCI: Setting latency timer of device 0000:0a:00.0 to 64
[    1.216691] ACPI: PCI Interrupt 0000:0a:01.0[A] -> GSI 17 (level, low) -> IRQ 17
[    1.224141] PCI: Setting latency timer of device 0000:0a:01.0 to 64
[    1.228184] PCI: Setting latency timer of device 0000:0e:00.0 to 64
[    1.229055] ACPI: PCI Interrupt 0000:0a:02.0[A] -> GSI 18 (level, low) -> IRQ 18
[    1.236142] PCI: Setting latency timer of device 0000:0a:02.0 to 64
[    1.240368] PCI: Setting latency timer of device 0000:09:00.3 to 64
[    1.240421] PCI: Setting latency timer of device 0000:00:03.0 to 64
[    1.240430] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    1.240439] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    1.240448] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    1.240456] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    1.240472] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.248098] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.248120] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    1.248137] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    1.256098] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.256120] PCI: Setting latency timer of device 0000:04:00.0 to 64
[    1.256131] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    1.256141] NET: Registered protocol family 2
[    1.304433] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.312526] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.323370] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    1.328265] TCP: Hash tables configured (established 524288 bind 65536)
[    1.332129] TCP reno registered
[    1.348600] sysctl table check failed: /kernel/vsyscall64  No proc_handler
[    1.360103] Pid: 1, comm: swapper Not tainted 2.6.25-rc3 #51
[    1.364104] 
[    1.364104] Call Trace:
[    1.368108]  [<ffffffff802442eb>] set_fail+0x3f/0x47
[    1.372105]  [<ffffffff802447a5>] sysctl_check_table+0x4b2/0x501
[    1.376105]  [<ffffffff802447bf>] sysctl_check_table+0x4cc/0x501
[    1.380106]  [<ffffffff80234d3f>] __register_sysctl_paths+0xea/0x142
[    1.384107]  [<ffffffff805a1aca>] vsyscall_init+0x49/0x62
[    1.388106]  [<ffffffff8059b6cd>] kernel_init+0x159/0x2c8
[    1.392108]  [<ffffffff8041e1fa>] trace_hardirqs_on_thunk+0x35/0x3a
[    1.396106]  [<ffffffff8024a6be>] trace_hardirqs_on+0xef/0x113
[    1.400107]  [<ffffffff8020cda8>] child_rip+0xa/0x12
[    1.404107]  [<ffffffff8020c4bf>] restore_args+0x0/0x30
[    1.408107]  [<ffffffff8059b574>] kernel_init+0x0/0x2c8
[    1.412107]  [<ffffffff8020cd9e>] child_rip+0x0/0x12
[    1.416106] 
[    1.513556] audit: initializing netlink socket (disabled)
[    1.516129] type=2000 audit(1204128294.981:1): initialized
[    1.520691] Total HugeTLB memory allocated, 0
[    1.529894] io scheduler noop registered
[    1.532102] io scheduler anticipatory registered (default)
[    1.536101] io scheduler deadline registered
[    1.540290] io scheduler cfq registered
[    1.560157] pci 0000:01:03.0: Boot video device
[    1.561200] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    1.561239] assign_interrupt_mode Found MSI capability
[    1.564130] Allocate Port Service[0000:00:02.0:pcie00]
[    1.564264] PCI: Setting latency timer of device 0000:00:03.0 to 64
[    1.564303] assign_interrupt_mode Found MSI capability
[    1.568127] Allocate Port Service[0000:00:03.0:pcie00]
[    1.568260] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    1.568298] assign_interrupt_mode Found MSI capability
[    1.572128] Allocate Port Service[0000:00:04.0:pcie00]
[    1.572260] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    1.572299] assign_interrupt_mode Found MSI capability
[    1.576128] Allocate Port Service[0000:00:05.0:pcie00]
[    1.576263] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    1.576301] assign_interrupt_mode Found MSI capability
[    1.580127] Allocate Port Service[0000:00:06.0:pcie00]
[    1.580257] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    1.580296] assign_interrupt_mode Found MSI capability
[    1.584128] Allocate Port Service[0000:00:07.0:pcie00]
[    1.584263] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.584301] assign_interrupt_mode Found MSI capability
[    1.588136] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.588270] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.588307] assign_interrupt_mode Found MSI capability
[    1.592136] Allocate Port Service[0000:00:1c.1:pcie00]
[    1.592505] PCI: Setting latency timer of device 0000:09:00.0 to 64
[    1.596285] PCI: Setting latency timer of device 0000:0a:00.0 to 64
[    1.597566] assign_interrupt_mode Found MSI capability
[    1.607169] PCI: Setting latency timer of device 0000:0a:01.0 to 64
[    1.608423] assign_interrupt_mode Found MSI capability
[    1.618026] PCI: Setting latency timer of device 0000:0a:02.0 to 64
[    1.619307] assign_interrupt_mode Found MSI capability
[    1.625787] vga16fb: initializing
[    1.625790] vga16fb: mapped to 0xffff8100000a0000
[    1.818777] Console: switching to colour frame buffer device 80x30
[    1.828120] fb0: VGA16 VGA frame buffer device
[    1.696484] Real Time Clock Driver v1.12ac
[    1.700440] hpet_resources: 0xfed00000 is busy
[    1.700722] intel_rng: FWH not detected
[    1.892183] Linux agpgart interface v0.103
[    1.896172] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.729127] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.732329] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.736493] pnp: the driver 'serial' has been registered
[    1.737018] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.740212] serial 00:09: driver attached
[    1.741923] brd: module loaded
[    1.744114] HP CISS Driver (v 3.6.14)
[    1.748483] ACPI: PCI Interrupt 0000:0f:08.0[A] -> GSI 17 (level, low) -> IRQ 17
[    1.768430] cciss0: <0x3238> at PCI 0000:0f:08.0 IRQ 500 using DAC
[    1.784121]       blocks= 143305920 block_size= 512
[    1.792121]       heads=255, sectors=32, cylinders=17562
[    1.792122] 
[    1.800121]       blocks= 143305920 block_size= 512
[    1.808122]       heads=255, sectors=32, cylinders=17562
[    1.808123] 
[    1.812361]       blocks= 143305920 block_size= 512
[    1.816256]       heads=255, sectors=32, cylinders=17562
[    1.816257] 
[    1.820121]  cciss/c0d0: p2 < p5 p6 >
[    1.829411]       blocks= 143305920 block_size= 512
[    1.832264]       heads=255, sectors=32, cylinders=17562
[    1.832265] 
[    1.836123]  cciss/c0d1: unknown partition table
[    1.852299] console [netcon0] enabled
[    1.860143] netconsole: network logging started
[    1.860145] pnp: the driver 'i8042 kbd' has been registered
[    1.864134] i8042 kbd 00:06: driver attached
[    1.864204] pnp: the driver 'i8042 aux' has been registered
[    1.864220] i8042 aux 00:07: driver attached
[    1.864290] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    5.535092] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.536381] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.540642] mice: PS/2 mouse device common for all mice
[    5.544535] usbcore: registered new interface driver usbhid
[    5.548366] /scratch/Ksrc/linux-git/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    5.552751] TCP bic registered
[    5.556494] NET: Registered protocol family 1
[    5.560378] NET: Registered protocol family 17
[    1.960126] kjournald starting.  Commit interval 5 seconds
[    2.228143] EXT3-fs: mounted filesystem with ordered data mode.
[    2.228143] VFS: Mounted root (ext3 filesystem) readonly.
[    2.228143] Freeing unused kernel memory: 320k freed
[    3.194476] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    6.763225] Uniform Multi-Platform E-IDE driver
[    6.764447] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    6.800398] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 16 (level, low) -> IRQ 16
[    6.804456] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    6.804460] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.809424] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    6.817250] ehci_hcd 0000:00:1d.7: debug port 1
[    6.820453] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    6.820469] ehci_hcd 0000:00:1d.7: irq 16, io mem 0xf7df0000
[    3.198464] USB Universal Host Controller Interface driver v3.0
[    6.844454] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    6.844895] usb usb1: configuration #1 chosen from 1 choice
[    6.845090] hub 1-0:1.0: USB hub found
[    6.845182] hub 1-0:1.0: 8 ports detected
[    3.248456] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[    3.256244] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    3.256249] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.260307] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.264237] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001000
[    3.268409] usb usb2: configuration #1 chosen from 1 choice
[    3.272252] hub 2-0:1.0: USB hub found
[    3.276292] hub 2-0:1.0: 2 ports detected
[    7.071027] input: Power Button (FF) as /devices/virtual/input/input1
[    7.092474] ACPI: Power Button (FF) [PWRF]
[    3.368327] ACPI: ACPI0007:00 is registered as cooling_device0
[    3.372298] ACPI: ACPI0007:01 is registered as cooling_device1
[    3.376419] ACPI: ACPI0007:06 is registered as cooling_device2
[    3.802987] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[    3.803001] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.803005] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.803092] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.803131] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001020
[    3.803325] usb usb3: configuration #1 chosen from 1 choice
[    3.803366] hub 3-0:1.0: USB hub found
[    3.803376] hub 3-0:1.0: 2 ports detected
[    3.380350] ACPI: ACPI0007:07 is registered as cooling_device3
[    3.904445] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.912259] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.912262] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.916604] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.920290] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
[    3.928342] usb usb4: configuration #1 chosen from 1 choice
[    3.932279] hub 4-0:1.0: USB hub found
[    3.936257] hub 4-0:1.0: 2 ports detected
[    7.300901] ipmi message handler version 39.1
[    6.652425] IPMI System Interface driver.
[    6.652430] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[    4.016457] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
[    4.016472] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    4.016475] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.016530] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    4.016568] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001060
[    4.016702] usb usb5: configuration #1 chosen from 1 choice
[    4.016730] hub 5-0:1.0: USB hub found
[    4.016737] hub 5-0:1.0: 2 ports detected
[    4.120436] ACPI: PCI Interrupt 0000:01:04.4[B] -> GSI 22 (level, low) -> IRQ 22
[    4.128272] uhci_hcd 0000:01:04.4: UHCI Host Controller
[    4.132318] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
[    4.136275] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
[    4.141136] uhci_hcd 0000:01:04.4: irq 22, io base 0x00003800
[    4.144619] usb usb6: configuration #1 chosen from 1 choice
[    4.148306] hub 6-0:1.0: USB hub found
[    4.152274] hub 6-0:1.0: 2 ports detected
[    7.649203] ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
[    7.656537] IPMI kcs interface initialized
[    7.660512] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    4.260515] ESB2: IDE controller (0x8086:0x269e rev 0x09) at  PCI slot 0000:00:1f.1
[    4.260528] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 17 (level, low) -> IRQ 17
[    4.260538] ESB2: not 100% native mode: will probe irqs later
[    4.260556]     ide0: BM-DMA at 0x0500-0x0507, BIOS settings: hda:DMA, hdb:PIO
[    4.260569]     ide1: BM-DMA at 0x0508-0x050f, BIOS settings: hdc:PIO, hdd:PIO
[    4.260578] Probing IDE interface ide0...
[    7.664540] ipmi_si: duplicate interface
[    3.938311] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    3.940419] ACPI: Thermal Zone [THM0] (8 C)
[    4.080334] usb 6-1: new full speed USB device using uhci_hcd and address 2
[    4.103056] usb 6-1: configuration #1 chosen from 1 choice
[    7.920905] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.0/input/input2
[    7.960562] input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
[    7.975689] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.1/input/input3
[    8.024609] input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
[    8.268548] usb 6-2: new full speed USB device using uhci_hcd and address 3
[    4.928583] hda: HL-DT-STDVD-ROM GDR-8084N, ATAPI CD/DVD-ROM drive
[    4.937745] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.940534] hda: UDMA/33 mode selected
[    4.948566] Probing IDE interface ide1...
[    4.816319] usb 6-2: new full speed USB device using uhci_hcd and address 4
[    4.876309] usb 6-2: configuration #1 chosen from 1 choice
[    4.880321] hub 6-2:1.0: USB hub found
[    4.890148] hub 6-2:1.0: 7 ports detected
[    5.372692] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.129606] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.4 (February 18, 2008)
[    8.096515] ib_mthca: Mellanox InfiniBand HCA driver v0.08 (February 14, 2006)
[    8.096515] ib_mthca: Initializing 0000:13:00.0
[    8.096515] ACPI: PCI Interrupt 0000:13:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[    8.096515] PCI: Setting latency timer of device 0000:13:00.0 to 64
[    5.132363] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    5.620925] eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B1) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 16, node addr 00:17:a4:47:2d:6e
[    5.624396] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[    6.024769] eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B1) PCI-X 64-bit 133MHz found at mem fa000000, IRQ 17, node addr 00:17:a4:47:2d:6c
[    9.159266] ib_mthca 0000:13:00.0: HCA FW version 5.1.400 is old (5.3.000 is current).
[    9.160584] ib_mthca 0000:13:00.0: If you have problems, try updating your HCA FW.
[    9.190121] ACPI: PCI Interrupt 0000:01:04.6[A] -> GSI 21 (level, low) -> IRQ 21
[    9.196588] ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7ef0000, slave address 0x0, irq 21
[    9.284668]   Using irq 21
[   10.176653] ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: 0x11)
[   10.176678] IPMI kcs interface initialized
[    9.437541] hda: ATAPI 24X DVD-ROM drive, 2048kB Cache
[    9.447381] Uniform CD-ROM driver Revision: 3.20
[    7.070327] Adding 2931820k swap on /dev/cciss/c0d0p5.  Priority:-1 extents:1 across:2931820k
[   10.184646] EXT3 FS on cciss/c0d0p6, internal journal
[    8.240321] loop: module loaded
[    8.198109] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   12.018913] fuse init (API version 7.9)
[    8.932576] bnx2: eth1: using MSI
[    9.200587] bnx2: eth0: using MSI
[   12.423214] NET: Registered protocol family 10
[   12.429057] lo: Disabled Privacy Extensions
[   12.434391] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.437208] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   10.078646] bnx2: eth1 NIC Copper Link is Up, 100 Mbps full duplex, receive & transmit flow control ON
[   10.094122] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   13.244838] bnx2: eth0 NIC Copper Link is Up, 100 Mbps full duplex
[   13.249800] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.455984] RPC: Registered udp transport module.
[   12.456790] RPC: Registered tcp transport module.
[   15.080954] eth1: no IPv6 routers present
[   21.545362] eth0: no IPv6 routers present
[ 1404.978545] ADDRCONF(NETDEV_UP): ib0: link is not ready
[ 2974.004057] ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
[ 2980.970490] ib0: no IPv6 routers present
[ 4313.025931] bnx2: eth1 NIC Copper Link is Down
[ 7336.422963] bnx2: eth1 NIC Copper Link is Up, 100 Mbps full duplex, receive & transmit flow control ON
[ 8425.910898] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 21 (level, low) -> IRQ 21
[ 8425.915097] hpwdt: New timer passed in is 30 seconds.
[ 8425.915139] BUG: unable to handle kernel paging request at ffffc20001a0a000
[ 8425.919087] IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
[ 8425.919087] PGD 1bf80e067 PUD 1bf80f067 PMD 1bb497067 PTE 80000047000ee17b
[ 8425.919087] Oops: 0009 [1] SMP 
[ 8425.919087] CPU 0 
[ 8425.919087] Modules linked in: hpwdt(+) rdma_ucm rdma_cm iw_cm ib_addr ib_uverbs ib_ipoib ib_cm ib_sa nfs lockd nfs_acl sunrpc fan ac battery ipv6 fuse dm_snapshot dm_mirror dm_mod loop ide_cd_mod cdrom ide_pci_generic ib_mthca thermal ib_mad bnx2 piix evdev zlib_inflate ipmi_si ipmi_msghandler container processor button ib_core uhci_hcd ehci_hcd ide_core serio_raw psmouse pcspkr
[ 8425.919087] Pid: 3508, comm: modprobe Not tainted 2.6.25-rc3 #51
[ 8425.919087] RIP: 0010:[<ffffffff8021dacc>]  [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
[ 8425.919087] RSP: 0000:ffff8101b5c25bc0  EFLAGS: 00010293
[ 8425.919087] RAX: ffff8101bb497050 RBX: 0000000000000000 RCX: 00000001bb497001
[ 8425.919087] RDX: ffffc20001a0afff RSI: 0000000000001000 RDI: ffffc20001a0a000
[ 8425.919087] RBP: ffffc20001a0a000 R08: ffff810000000000 R09: 00003ffffffff000
[ 8425.919087] R10: ffffc20001a0a000 R11: 000000008827b350 R12: ffff8101b5c25bf4
[ 8425.919087] R13: 0000000000000000 R14: 0000000000000001 R15: 800000000000017b
[ 8425.919087] FS:  00007f0136de96e0(0000) GS:ffffffff80567000(0000) knlGS:0000000000000000
[ 8425.919087] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8425.919087] CR2: ffffc20001a0a000 CR3: 00000001b659c000 CR4: 00000000000006e0
[ 8425.919087] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8425.919087] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8425.919087] Process modprobe (pid: 3508, threadinfo ffff8101b5c24000, task ffff8101b99d8000)
[ 8425.919087] Stack:  ffffffff8021e60b ffffc20001a0b000 0000000000000018 0000000000000000
[ 8425.919087]  0000000100000001 00000000047000ee 0000000100001000 0000000000001000
[ 8425.919087]  ffffc20001a0a000 00240047000ee000 ffff8101bb4c5c80 00240047000ee000
[ 8425.919087] Call Trace:
[ 8425.919087]  [<ffffffff8021e60b>] ? change_page_attr_set_clr+0x140/0x18b
[ 8425.919087]  [<ffffffff8021d94c>] ? __ioremap+0x197/0x1cd
[ 8425.919087]  [<ffffffff88279566>] ? :hpwdt:hpwdt_init_one+0x1c3/0x386
[ 8425.919087]  [<ffffffff803351fe>] ? pci_device_probe+0xb3/0xfb
[ 8425.919087]  [<ffffffff80393ffe>] ? driver_probe_device+0xb5/0x132
[ 8425.919087]  [<ffffffff8039411d>] ? __driver_attach+0x0/0x93
[ 8425.919087]  [<ffffffff80394177>] ? __driver_attach+0x5a/0x93
[ 8425.919087]  [<ffffffff803933fa>] ? bus_for_each_dev+0x47/0x72
[ 8425.919087]  [<ffffffff80393c1e>] ? bus_add_driver+0xb1/0x1fb
[ 8425.919087]  [<ffffffff80394391>] ? driver_register+0x59/0xce
[ 8425.919087]  [<ffffffff80335487>] ? __pci_register_driver+0x5a/0x8b
[ 8425.919087]  [<ffffffff802526a1>] ? sys_init_module+0x18ff/0x1a08
[ 8425.919087]  [<ffffffff8023ea31>] ? param_get_int+0x0/0x14
[ 8425.919087]  [<ffffffff8024a6be>] ? trace_hardirqs_on+0xef/0x113
[ 8425.919087]  [<ffffffff8041e1fa>] ? trace_hardirqs_on_thunk+0x35/0x3a
[ 8425.919087]  [<ffffffff8020be5b>] ? system_call_after_swapgs+0x7b/0x80
[ 8425.919087] 
[ 8425.919087] 
[ 8425.919087] Code: 00 e8 de 09 02 00 31 d2 48 85 c0 74 0d 48 8b 40 08 b2 01 48 89 83 80 00 00 00 5b 89 d0 c3 90 89 f6 48 8d 54 37 ff 0f ae f0 eb 0d <0f> ae 3f 0f b7 05 4e ce 36 00 48 01 c7 48 39 d7 72 ee 0f ae 3a 
[ 8425.919087] RIP  [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
[ 8425.919087]  RSP <ffff8101b5c25bc0>
[ 8425.919087] CR2: ffffc20001a0a000
[ 8425.927907] ---[ end trace d0c1967e01c1d63f ]---
