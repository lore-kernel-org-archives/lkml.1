Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZBOCOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZBOCOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 21:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZBOCOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 21:14:43 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:36935 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZBOCOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 21:14:40 -0500
MIME-Version: 1.0
Date: Sat, 14 Feb 2009 18:14:38 -0800
Message-ID: <f488382f0902141814r352b1b59t598c220b665b8507@mail.gmail.com>
Subject: [2.6.29-rc5] drm: "possible circular locking dependency" and other 
	issues
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, dmesg screamed about a possible circular locking
dependency (see below dmesg). This is specific to 2.6.29-rc* (I didn't
test earlier RCs, but I suppose it doesn't matter much).

Second, I'm getting some strange problems when using X11. While using
X, sometimes things will just completely lock up. I can still SSH to
the machine and reboot it, but I can't do much else with it. I suspect
it's related to the "freeing invalid memtype" or "conflicting memory
types" things in the dmesg. I've seen this problem on 2.6.27.x,
2.6.28.x, and 2.6.29-rc5. It could occur on others, I don't know.

- Steven



[    0.000000] Linux version 2.6.29-rc5 (root@alcarin) (gcc version
4.3.3 (Gentoo 4.3.3 p1.0, pie-10.1.5) ) #1 SMP PREEMPT Sat Feb 14
13:10:06 PST 2009
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
[    0.000000]  BIOS-e820: 0000000000000100 - 0000000000002000 (usable)
[    0.000000]  BIOS-e820: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  BIOS-e820: 0000000000006000 - 0000000000007000 (usable)
[    0.000000]  BIOS-e820: 0000000000007000 - 0000000000010000 (reserved)
[    0.000000]  BIOS-e820: 0000000000010000 - 0000000000092c00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf07b000 (usable)
[    0.000000]  BIOS-e820: 00000000bf07b000 - 00000000bf27c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf27c000 - 00000000bfebe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfebe000 - 00000000bfeef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfeef000 - 00000000bff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0xbf07b max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000100 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000007000 (usable)
[    0.000000]  modified: 0000000000007000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092c00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf07b000 (usable)
[    0.000000]  modified: 00000000bf07b000 - 00000000bf27c000 (ACPI NVS)
[    0.000000]  modified: 00000000bf27c000 - 00000000bfebe000 (ACPI data)
[    0.000000]  modified: 00000000bfebe000 - 00000000bfeef000 (ACPI NVS)
[    0.000000]  modified: 00000000bfeef000 - 00000000bff00000 (ACPI data)
[    0.000000]  modified: 00000000bff00000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT BFEFD1C0, 0074 (r1 APPLE   Apple00       A5
     1000013)
[    0.000000] ACPI: FACP BFEFB000, 00F4 (r3 APPLE   Apple00       A5
Loki       5F)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match
PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT BFEF0000, 48D1 (r1 APPLE  MacBookP    20002
INTL 20050309)
[    0.000000] ACPI: FACS BFEC0000, 0040
[    0.000000] ACPI: HPET BFEFA000, 0038 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: APIC BFEF9000, 0068 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: MCFG BFEF8000, 003C (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ASF! BFEF7000, 00A0 (r32 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SBST BFEF6000, 0030 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ECDT BFEF5000, 0053 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SSDT BFEEF000, 04DC (r1 APPLE     CpuPm     3000
INTL 20050309)
[    0.000000] ACPI: SSDT BFEBD000, 064F (r1 SataRe  SataPri     1000
INTL 20050309)
[    0.000000] ACPI: SSDT BFEBC000, 069C (r1 SataRe  SataSec     1000
INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2168MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00011000 - 00017f00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000bbe670]    TEXT DATA BSS ==>
[0000100000 - 0000bbe670]
[    0.000000]   #4 [0000bbf000 - 0000bc3000]    INIT_PG_TABLE ==>
[0000bbf000 - 0000bc3000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==>
[0000010000 - 0000011000]
[    0.000000]   #7 [0000011000 - 0000018000]          BOOTMAP ==>
[0000011000 - 0000018000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000bf07b
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x00000007
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x000bf07b
[    0.000000] On node 0 totalpages: 782335
[    0.000000] free_area_init_node: node 0, pgdat c0731700,
node_mem_map c1000034
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   Normal zone: 2834 pages used for memmap
[    0.000000]   Normal zone: 220396 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7048 pages used for memmap
[    0.000000]   HighMem zone: 548085 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 0000000000007000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at c4000000 (gap:
c0000000:30000000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 36864 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 772401
[    0.000000] Kernel command line: root=/dev/sda5
video=uvesafb:1440x900-32,mtrr:3,ywrap,nocrtc nmi_watchdog=1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2327.618 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
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
[    0.000999]                                  | spin |wlock |rlock
|mutex | wsem | rsem |
[    0.000999]
--------------------------------------------------------------------------
[    0.000999]                      A-A deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]                     double unlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]                   initialize held:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]                  bad unlock order:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]
--------------------------------------------------------------------------
[    0.000999]               recursive read-lock:             |  ok  |
            |  ok  |
[    0.000999]            recursive read-lock #2:             |  ok  |
            |  ok  |
[    0.000999]             mixed read-write-lock:             |  ok  |
            |  ok  |
[    0.000999]             mixed write-read-lock:             |  ok  |
            |  ok  |
[    0.000999]
--------------------------------------------------------------------------
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
[    0.000999] Memory: 3076652k/3129836k available (4427k kernel code,
51880k reserved, 2002k data, 332k init, 2220532k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff85000 - 0xfffff000   ( 488 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc074f000 - 0xc07a2000   ( 332 kB)
[    0.000999]       .data : 0xc0552c43 - 0xc0747830   (2002 kB)
[    0.000999]       .text : 0xc0100000 - 0xc0552c43   (4427 kB)
[    0.000999] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.001033] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4655.23 BogoMIPS (lpj=2327618)
[    0.001134] Mount-cache hash table entries: 512
[    0.002562] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.002578] CPU: L2 cache: 4096K
[    0.002590] [ds] using Core 2/Atom configuration
[    0.002603] CPU: Physical Processor ID: 0
[    0.002613] CPU: Processor Core ID: 0
[    0.002628] Intel machine check architecture supported.
[    0.002644] Intel machine check reporting enabled on CPU#0.
[    0.002657] using mwait in idle threads.
[    0.002681] Checking 'hlt' instruction... OK.
[    0.006750] ACPI: Core revision 20081204
[    0.025993] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036041] CPU0: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
[    0.036994] APIC timer registered as dummy, due to nmi_watchdog=1!
[    0.039087] Testing tracer nop: PASSED
[    0.039484] lockdep: fixing up alternatives.
[    0.039644] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine..
4655.05 BogoMIPS (lpj=2327527)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] [ds] using Core 2/Atom configuration
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#1.
[    0.000999] x86 PAT enabled: cpu 1, old 0x7010600070106, new 0x7010600070106
[    0.114028] CPU1: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
[    0.114145] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.115097] Brought up 2 CPUs
[    0.115110] Total of 2 processors activated (9310.29 BogoMIPS).
[    0.115199] Testing NMI watchdog ... OK.
[    0.135477] CPU0 attaching sched-domain:
[    0.135484]  domain 0: span 0-1 level MC
[    0.135490]   groups: 0 1
[    0.135526] CPU1 attaching sched-domain:
[    0.135531]  domain 0: span 0-1 level MC
[    0.135538]   groups: 1 0
[    0.137296] net_namespace: 1112 bytes
[    0.138307] NET: Registered protocol family 16
[    0.140163] ACPI: bus type pci registered
[    0.140223] dca service started, version 1.8
[    0.141053] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
[    0.141074] PCI: MCFG area at f0000000 reserved in E820
[    0.141087] PCI: updated MCFG configuration 0: base f0000000
segment 0 buses 0 - 63
[    0.141106] PCI: Using MMCONFIG for extended config space
[    0.141119] PCI: Using configuration type 1 for base access
[    0.156099] bio: create slab <bio-0> at 0
[    0.162157] ACPI: EC: EC description table is found, configuring boot EC
[    0.162644] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.172300] ACPI: BIOS _OSI(Linux) query ignored
[    0.173883] ACPI: Interpreter enabled
[    0.173903] ACPI: (supports S0 S3 S4 S5)
[    0.174025] ACPI: Using IOAPIC for interrupt routing
[    0.210480] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.210498] ACPI: EC: driver started in interrupt mode
[    0.211484] ACPI: No dock devices found.
[    0.212143] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.212342] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.212363] pci 0000:00:01.0: PME# disabled
[    0.212455] pci 0000:00:07.0: reg 10 32bit mmio: [0xd8404000-0xd8404fff]
[    0.213122] pci 0000:00:1b.0: reg 10 64bit mmio: [0xd8400000-0xd8403fff]
[    0.213247] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.213268] pci 0000:00:1b.0: PME# disabled
[    0.213444] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.213465] pci 0000:00:1c.0: PME# disabled
[    0.213646] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.213666] pci 0000:00:1c.1: PME# disabled
[    0.213847] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.213868] pci 0000:00:1c.2: PME# disabled
[    0.214019] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
[    0.214149] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
[    0.214282] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
[    0.214411] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
[    0.214546] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd8405400-0xd84057ff]
[    0.214673] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.214695] pci 0000:00:1d.7: PME# disabled
[    0.215031] pci 0000:00:1f.0: quirk: region 0400-047f claimed by
ICH6 ACPI/GPIO/TCO
[    0.215055] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.215074] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0680 (mask 000f)
[    0.215096] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
1640 (mask 000f)
[    0.215121] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at
0300 (mask 001f)
[    0.215229] pci 0000:00:1f.1: reg 10 io port: [0x40d8-0x40df]
[    0.215247] pci 0000:00:1f.1: reg 14 io port: [0x40ec-0x40ef]
[    0.215263] pci 0000:00:1f.1: reg 18 io port: [0x40d0-0x40d7]
[    0.215280] pci 0000:00:1f.1: reg 1c io port: [0x40e8-0x40eb]
[    0.215297] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
[    0.215409] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
[    0.215426] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
[    0.215443] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
[    0.215460] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
[    0.215476] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
[    0.215493] pci 0000:00:1f.2: reg 24 32bit mmio: [0xd8405000-0xd84053ff]
[    0.215555] pci 0000:00:1f.2: PME# supported from D3hot
[    0.215574] pci 0000:00:1f.2: PME# disabled
[    0.215692] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.215875] pci 0000:01:00.0: reg 10 32bit mmio: [0xc0000000-0xcfffffff]
[    0.215901] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.215927] pci 0000:01:00.0: reg 18 32bit mmio: [0xd8300000-0xd830ffff]
[    0.216029] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.216132] pci 0000:01:00.0: supports D1 D2
[    0.216274] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.216285] pci 0000:00:01.0: bridge 32bit mmio: [0xd8300000-0xd83fffff]
[    0.216299] pci 0000:00:01.0: bridge 64bit mmio pref: [0xc0000000-0xcfffffff]
[    0.216437] pci 0000:02:00.0: reg 10 64bit mmio: [0xd8200000-0xd8203fff]
[    0.216456] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.216517] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.216612] pci 0000:02:00.0: supports D1 D2
[    0.216617] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.216639] pci 0000:02:00.0: PME# disabled
[    0.216767] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.216779] pci 0000:00:1c.0: bridge 32bit mmio: [0xd8200000-0xd82fffff]
[    0.216796] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xd8500000-0xd85fffff]
[    0.216919] pci 0000:03:00.0: reg 10 64bit mmio: [0xd8100000-0xd810ffff]
[    0.217093] pci 0000:03:00.0: supports D1
[    0.217098] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.217119] pci 0000:03:00.0: PME# disabled
[    0.217271] pci 0000:00:1c.1: bridge 32bit mmio: [0xd8100000-0xd81fffff]
[    0.217401] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
[    0.217413] pci 0000:00:1c.2: bridge 32bit mmio: [0xd4100000-0xd80fffff]
[    0.217430] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xd0000000-0xd3ffffff]
[    0.217535] pci 0000:0c:03.0: reg 10 32bit mmio: [0xd4004000-0xd40047ff]
[    0.217553] pci 0000:0c:03.0: reg 14 32bit mmio: [0xd4000000-0xd4003fff]
[    0.217669] pci 0000:0c:03.0: supports D1 D2
[    0.217674] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.217695] pci 0000:0c:03.0: PME# disabled
[    0.217808] pci 0000:00:1e.0: transparent bridge
[    0.217832] pci 0000:00:1e.0: bridge 32bit mmio: [0xd4000000-0xd40fffff]
[    0.217906] pci_bus 0000:00: on NUMA node 0
[    0.217925] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.218670] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.218943] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.219225] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.219485] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.219788] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.252407] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.252795] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.253332] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.253718] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.254122] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.254502] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.254880] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.255282] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.257161] SCSI subsystem initialized
[    0.257161] libata version 3.00 loaded.
[    0.258038] usbcore: registered new interface driver usbfs
[    0.258052] usbcore: registered new interface driver hub
[    0.258191] usbcore: registered new device driver usb
[    0.259714] PCI: Using ACPI for IRQ routing
[    0.262982] Bluetooth: Core ver 2.14
[    0.263030] NET: Registered protocol family 31
[    0.263034] Bluetooth: HCI device and connection manager initialized
[    0.263083] Bluetooth: HCI socket layer initialized
[    0.265058] cfg80211: Calling CRDA to update world regulatory domain
[    0.265077] cfg80211: calling CRDA failed - unable to update world
regulatory domain, using static definition
[    0.265077] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.265077] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.269985] pnp: PnP ACPI init
[    0.270044] ACPI: bus type pnp registered
[    0.276429] pnp 00:07: io resource (0x1640-0x164f) overlaps
0000:00:1c.2 BAR 7 (0x1000-0x1fff), disabling
[    0.281942] pnp: PnP ACPI: found 9 devices
[    0.281974] ACPI: ACPI bus type pnp unregistered
[    0.282015] system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.282034] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.282052] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.282070] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.282087] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.282105] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.282143] system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.282177] system 00:07: ioport range 0x680-0x6ef has been reserved
[    0.282194] system 00:07: ioport range 0x800-0x80f has been reserved
[    0.282210] system 00:07: ioport range 0x810-0x817 has been reserved
[    0.282234] system 00:07: ioport range 0x400-0x47f has been reserved
[    0.282251] system 00:07: ioport range 0x500-0x53f has been reserved
[    0.318820] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.318840] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.318861] pci 0000:00:01.0:   MEM window: 0xd8300000-0xd83fffff
[    0.318881] pci 0000:00:01.0:   PREFETCH window:
0x000000c0000000-0x000000cfffffff
[    0.318911] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.318929] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.318968] pci 0000:00:1c.0:   MEM window: 0xd8200000-0xd82fffff
[    0.318989] pci 0000:00:1c.0:   PREFETCH window:
0x000000d8500000-0x000000d85fffff
[    0.319019] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.319034] pci 0000:00:1c.1:   IO window: disabled
[    0.319055] pci 0000:00:1c.1:   MEM window: 0xd8100000-0xd81fffff
[    0.319075] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.319100] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.319118] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.319140] pci 0000:00:1c.2:   MEM window: 0xd4100000-0xd80fffff
[    0.319160] pci 0000:00:1c.2:   PREFETCH window:
0x000000d0000000-0x000000d3ffffff
[    0.319191] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.319205] pci 0000:00:1e.0:   IO window: disabled
[    0.319226] pci 0000:00:1e.0:   MEM window: 0xd4000000-0xd40fffff
[    0.319246] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.319298]   alloc irq_desc for 16 on cpu 0 node 0
[    0.319305]   alloc kstat_irqs on cpu 0 node 0
[    0.319318] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.319340] pci 0000:00:01.0: setting latency timer to 64
[    0.319360]   alloc irq_desc for 17 on cpu 0 node 0
[    0.319366]   alloc kstat_irqs on cpu 0 node 0
[    0.319376] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.319398] pci 0000:00:1c.0: setting latency timer to 64
[    0.319418] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.319439] pci 0000:00:1c.1: setting latency timer to 64
[    0.319460]   alloc irq_desc for 18 on cpu 0 node 0
[    0.319465]   alloc kstat_irqs on cpu 0 node 0
[    0.319475] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.319497] pci 0000:00:1c.2: setting latency timer to 64
[    0.320381] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.320408] pci 0000:00:1e.0: setting latency timer to 64
[    0.320418] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.320425] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.320431] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
[    0.320437] pci_bus 0000:01: resource 1 mem: [0xd8300000-0xd83fffff]
[    0.320443] pci_bus 0000:01: resource 2 mem: [0xc0000000-0xcfffffff]
[    0.320448] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.320454] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.320460] pci_bus 0000:02: resource 1 mem: [0xd8200000-0xd82fffff]
[    0.320465] pci_bus 0000:02: resource 2 mem: [0xd8500000-0xd85fffff]
[    0.320471] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.320476] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.320482] pci_bus 0000:03: resource 1 mem: [0xd8100000-0xd81fffff]
[    0.320487] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.320493] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.320498] pci_bus 0000:04: resource 0 io:  [0x1000-0x1fff]
[    0.320504] pci_bus 0000:04: resource 1 mem: [0xd4100000-0xd80fffff]
[    0.320510] pci_bus 0000:04: resource 2 mem: [0xd0000000-0xd3ffffff]
[    0.320515] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.320520] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.320526] pci_bus 0000:0c: resource 1 mem: [0xd4000000-0xd40fffff]
[    0.320532] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.320537] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
[    0.320543] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffff]
[    0.320660] NET: Registered protocol family 2
[    0.327248] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.328622] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.329395] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.344036] TCP: Hash tables configured (established 131072 bind 65536)
[    0.344090] TCP reno registered
[    0.346192] NET: Registered protocol family 1
[    0.352026] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.352048] Scanning for low memory corruption every 60 seconds
[    0.353627] Testing tracer sched_switch: PASSED
[    0.454099] Testing tracer sysprof: <6>Clockevents: could not
switch to one-shot mode:<6>Clockevents: could not switch to one-shot
mode: lapic is not functional.
[    0.500960] Could not switch to high resolution mode on CPU 1
[    0.500986]  lapic is not functional.
[    0.500997] Could not switch to high resolution mode on CPU 0
[    0.554969] PASSED
[    0.554986] Testing tracer function: PASSED
[    0.673239] Testing tracer irqsoff: PASSED
[    0.673472] Testing tracer preemptoff: PASSED
[    0.673637] Testing tracer preemptirqsoff: PASSED
[    0.673981] Testing tracer wakeup: PASSED
[    0.977612] highmem bounce pool size: 64 pages
[    0.977636] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.989752] DLM (built Feb 14 2009 13:03:37) installed
[    0.994623] NTFS driver 2.1.29 [Flags: R/O].
[    0.995991] JFS: nTxBlock = 8192, nTxLock = 65536
[    1.003612] SGI XFS with ACLs, security attributes, no debug enabled
[    1.005802] msgmni has been set to 1673
[    1.006617] alg: No test for cipher_null (cipher_null-generic)
[    1.006813] alg: No test for digest_null (digest_null-generic)
[    1.006907] alg: No test for compress_null (compress_null-generic)
[    1.009754] alg: No test for fcrypt (fcrypt-generic)
[    1.014296] alg: No test for stdrng (krng)
[    1.014380] alg: No test for stdrng (ansi_cprng)
[    1.014461] io scheduler noop registered
[    1.014474] io scheduler anticipatory registered
[    1.014487] io scheduler deadline registered
[    1.014541] io scheduler cfq registered (default)
[    1.014834] pci 0000:01:00.0: Boot video device
[    1.015352] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.015540]   alloc irq_desc for 24 on cpu 0 node 0
[    1.015547]   alloc kstat_irqs on cpu 0 node 0
[    1.015565] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.016031] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.016179]   alloc irq_desc for 25 on cpu 0 node 0
[    1.016185]   alloc kstat_irqs on cpu 0 node 0
[    1.016202] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    1.016838] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.017000]   alloc irq_desc for 26 on cpu 0 node 0
[    1.017006]   alloc kstat_irqs on cpu 0 node 0
[    1.017023] pcieport-driver 0000:00:1c.1: irq 26 for MSI/MSI-X
[    1.017646] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.017796]   alloc irq_desc for 27 on cpu 0 node 0
[    1.017802]   alloc kstat_irqs on cpu 0 node 0
[    1.017819] pcieport-driver 0000:00:1c.2: irq 27 for MSI/MSI-X
[    1.021718] uvesafb: (C) 1988-2005, ATI Technologies Inc. , M56P,
01.00, OEM: ATI ATOMBIOS, VBE v3.0
[    1.230709] uvesafb: protected mode interface info at c000:ad0c
[    1.230726] uvesafb: pmi: set display start = c00cad94, set palette
= c00cae50
[    2.163707] uvesafb: VBIOS/hardware supports DDC2 transfers
[    3.099727] uvesafb: monitor limits: vf = 60 Hz, hf = 55 kHz, clk = 96 MHz
[    3.100030] uvesafb: scrolling: ywrap using protected mode
interface, yres_virtual=1728
[    3.246185] Console: switching to colour frame buffer device 144x54
[    3.255731] uvesafb: framebuffer at 0xc0000000, mapped to
0xf8580000, using 7776k, total 16384k
[    3.255896] fb0: VESA VGA frame buffer device
[    3.256590] ACPI: AC Adapter [ADP1] (on-line)
[    3.388802] ACPI: Battery Slot [BAT0] (battery present)
[    3.389741] input: Power Button (FF) as /class/input/input0
[    3.389965] ACPI: Power Button (FF) [PWRF]
[    3.390511] input: Lid Switch as /class/input/input1
[    3.391114] ACPI: Lid Switch [LID0]
[    3.391717] input: Power Button (CM) as /class/input/input2
[    3.391878] ACPI: Power Button (CM) [PWRB]
[    3.392319] input: Sleep Button (CM) as /class/input/input3
[    3.392427] ACPI: Sleep Button (CM) [SLPB]
[    3.394749] ACPI: SSDT BFEB8A90, 02F0 (r1 APPLE   Cpu0Ist     3000
INTL 20050309)
[    3.396641] ACPI: SSDT BFEB6C10, 02A0 (r1 APPLE   Cpu0Cst     3001
INTL 20050309)
[    3.398604] Monitor-Mwait will be used to enter C-1 state
[    3.398789] Monitor-Mwait will be used to enter C-2 state
[    3.398819] Monitor-Mwait will be used to enter C-3 state
[    3.399303] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.399862] processor ACPI_CPU:00: registered as cooling_device0
[    3.400020] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.401303] ACPI: SSDT BFEB7F10, 0087 (r1 APPLE   Cpu1Ist     3000
INTL 20050309)
[    3.403151] ACPI: SSDT BFEB6F10, 0085 (r1 APPLE   Cpu1Cst     3000
INTL 20050309)
[    3.405545] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.406120] processor ACPI_CPU:01: registered as cooling_device1
[    3.406275] ACPI: Processor [CPU1] (supports 8 throttling states)
[    3.540792] Non-volatile memory driver v1.3
[    3.541451] intel_rng: FWH not detected
[    3.545481] Linux agpgart interface v0.103
[    3.549516] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    3.553472] Hangcheck: Using get_cycles().
[    3.560504] loop: module loaded
[    3.564450] Uniform Multi-Platform E-IDE driver
[    3.568553] ide-cd driver 5.00
[    3.572894] Driver 'sd' needs updating - please use bus_type methods
[    3.576943] Driver 'sr' needs updating - please use bus_type methods
[    3.581368] ata_piix 0000:00:1f.1: version 2.12
[    3.581515] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    3.585440] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.589496] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.589700] scsi0 : ata_piix
[    3.594160] scsi1 : ata_piix
[    3.600249] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    3.604250] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    3.778192] ata1.00: ATAPI: HL-DT-ST DVDRW GWA4080MA, AE39, max UDMA/33
[    3.788098] ata1.00: configured for UDMA/33
[    3.797494] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRW
GWA4080MA  AE39 PQ: 0 ANSI: 5
[    3.812709] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    3.816657] Uniform CD-ROM driver Revision: 3.20
[    3.821508] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.822747] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    3.989243]   alloc irq_desc for 19 on cpu 0 node 0
[    3.989250]   alloc kstat_irqs on cpu 0 node 0
[    3.989264] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.993197] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    3.997209] ata_piix 0000:00:1f.2: setting latency timer to 64
[    3.997348] scsi2 : ata_piix
[    4.001444] scsi3 : ata_piix
[    4.008594] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    4.012369] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    4.181204] ata3.01: ATA-7: ST9200420AS, 3.AAA, max UDMA/133
[    4.184853] ata3.01: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.195235] ata3.01: configured for UDMA/133
[    4.199191] scsi 2:0:1:0: Direct-Access     ATA      ST9200420AS
  3.AA PQ: 0 ANSI: 5
[    4.203771] sd 2:0:1:0: [sda] 390721968 512-byte hardware sectors:
(200 GB/186 GiB)
[    4.207685] sd 2:0:1:0: [sda] Write Protect is off
[    4.211533] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    4.211637] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.216331] sd 2:0:1:0: [sda] 390721968 512-byte hardware sectors:
(200 GB/186 GiB)
[    4.220294] sd 2:0:1:0: [sda] Write Protect is off
[    4.224135] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    4.224240] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.228163]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9
sda10 sda11 sda12
[    4.304552] sd 2:0:1:0: [sda] Attached SCSI disk
[    4.308960] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    4.476014] PNP: No PS/2 controller found. Probing ports directly.
[    4.480928] i8042.c: No controller found.
[    4.485193] mice: PS/2 mouse device common for all mice
[    4.497303] I2O subsystem v1.325
[    4.501278] i2o: max drivers = 8
[    4.505847] I2O Configuration OSM v1.323
[    4.510037] I2O Bus Adapter OSM v1.317
[    4.513972] I2O Block Device OSM v1.325
[    4.518214] I2O SCSI Peripheral OSM v1.316
[    4.522103] I2O ProcFS OSM v1.316
[    4.526086] rtc_cmos 00:08: RTC can wake from S4
[    4.530201] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    4.533997] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    4.537905] i2c /dev entries driver
[    4.541946] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    4.545810] ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf]
conflicts with ACPI region SMBI [0xefa0-0xefaf]
[    4.549760] ACPI: Device needs an ACPI driver
[    4.554974] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
[    4.559361] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device
(Version=2, TCOBASE=0x0460)
[    4.563663] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.568983] cpuidle: using governor ladder
[    4.569963] Marking TSC unstable due to TSC halts in idle
[    4.577694] Clockevents: could not switch to one-shot
mode:<6>Clockevents: could not switch to one-shot mode: lapic is not
functional.
[    4.577708] Could not switch to high resolution mode on CPU 1
[    4.578688]  lapic is not functional.
[    4.590364] Could not switch to high resolution mode on CPU 0
[    4.596352] cpuidle: using governor menu
[    4.600706] sdhci: Secure Digital Host Controller Interface driver
[    4.604896] sdhci: Copyright(c) Pierre Ossman
[    4.610016] Netfilter messages via NETLINK v0.30.
[    4.614262] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.619328] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[    4.623599] nf_conntrack.acct=1 kernel paramater, acct=1
nf_conntrack module option or
[    4.628016] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    4.632663] ctnetlink v0.93: registering with nfnetlink.
[    4.637105] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    4.641499] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    4.646101] xt_time: kernel timezone is -0000
[    4.653448] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.658001] ClusterIP Version 0.8 loaded successfully
[    4.662413] arp_tables: (C) 2002 David S. Miller
[    4.666783] TCP cubic registered
[    4.670987] Initializing XFRM netlink socket
[    4.676449] NET: Registered protocol family 10
[    4.684983] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.689460] IPv6 over IPv4 tunneling driver
[    4.696783] NET: Registered protocol family 17
[    4.700903] NET: Registered protocol family 15
[    4.732245] SCTP: Hash tables configured (established 65536 bind 65536)
[    4.741078] lib80211: common routines for IEEE802.11 drivers
[    4.745138] lib80211_crypt: registered algorithm 'NULL'
[    4.748515] Using IPI No-Shortcut mode
[    4.753778] rtc_cmos 00:08: setting system clock to 2009-02-15
02:03:19 UTC (1234663399)
[    4.809312] EXT3-fs: mounted filesystem with ordered data mode.
[    4.813587] VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
[    4.818231] Freeing unused kernel memory: 332k freed
[    4.822490] kjournald starting.  Commit interval 5 seconds
[    4.827486] Write protecting the kernel text: 4428k
[    4.832060] Write protecting the kernel read-only data: 1696k
[    6.923287] applesmc: Apple MacBook Pro detected:
[    6.923292] applesmc:  - Model with accelerometer
[    6.923295] applesmc:  - Model with light sensors and backlight
[    6.923299] applesmc:  - Model with 12 temperature sensors
[    6.924083] applesmc: device has already been initialized (0xe0, 0xf8).
[    6.924088] applesmc: device successfully initialized.
[    6.924923] applesmc: 2 fans found.
[    6.926459] input: applesmc as /class/input/input4
[    6.928454] Registered led device: smc::kbd_backlight
[    6.928600] applesmc: driver successfully loaded.
[    7.675055] ath9k: 0.1
[    7.675121] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.675137] ath9k 0000:03:00.0: setting latency timer to 64
[    7.813377] wmaster0 (ath9k): not using net_device_ops yet
[    7.815456] phy0: Selected rate control algorithm 'ath9k_rate_control'
[    7.818705] wlan0 (ath9k): not using net_device_ops yet
[    7.821035] Registered led device: ath9k-phy0:radio
[    7.821081] Registered led device: ath9k-phy0:assoc
[    7.821123] Registered led device: ath9k-phy0:tx
[    7.821165] Registered led device: ath9k-phy0:rx
[    7.821198] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81:
mem=0xf9040000, irq=17
[    7.861589] sky2 driver version 1.22
[    7.861684] sky2 0000:02:00.0: enabling device (0000 -> 0003)
[    7.861694] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.861712] sky2 0000:02:00.0: setting latency timer to 64
[    7.861772] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    7.894000] sky2 0000:02:00.0: Marvell Yukon 88E8053 Gigabit
Ethernet Controller
[    7.894004]  Part Number: Yukon 88E8053
[    7.894007]  Engineering Level: Rev. 2.2
[    7.894010]  Manufacturer: Marvell
[    7.894090]   alloc irq_desc for 28 on cpu 0 node 0
[    7.894094]   alloc kstat_irqs on cpu 0 node 0
[    7.894109] sky2 0000:02:00.0: irq 28 for MSI/MSI-X
[    7.894461] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.894522]   alloc irq_desc for 23 on cpu 0 node 0
[    7.894526]   alloc kstat_irqs on cpu 0 node 0
[    7.894534] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    7.894563] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.894568] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.895456] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    7.899383] ehci_hcd 0000:00:1d.7: debug port 1
[    7.899393] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    7.899423] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd8405400
[    7.905871] sky2 eth0: addr 00:17:f2:df:a4:2e
[    7.908672] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.909199] usb usb1: configuration #1 chosen from 1 choice
[    7.909440] hub 1-0:1.0: USB hub found
[    7.909522] hub 1-0:1.0: 8 ports detected
[    8.049913] uhci_hcd: USB Universal Host Controller Interface driver
[    8.050010] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    8.050024] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.050030] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    8.050115] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    8.050167] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    8.050467] usb usb2: configuration #1 chosen from 1 choice
[    8.050539] hub 2-0:1.0: USB hub found
[    8.050631] hub 2-0:1.0: 2 ports detected
[    8.050914] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    8.050927] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    8.050933] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    8.051037] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    8.051100] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    8.051291] usb usb3: configuration #1 chosen from 1 choice
[    8.051365] hub 3-0:1.0: USB hub found
[    8.051378] hub 3-0:1.0: 2 ports detected
[    8.051595] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.051607] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    8.051612] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    8.051698] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    8.051758] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    8.052007] usb usb4: configuration #1 chosen from 1 choice
[    8.052077] hub 4-0:1.0: USB hub found
[    8.052089] hub 4-0:1.0: 2 ports detected
[    8.052308] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    8.052318] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    8.052324] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    8.052379] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    8.052433] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    8.052621] usb usb5: configuration #1 chosen from 1 choice
[    8.052706] hub 5-0:1.0: USB hub found
[    8.052719] hub 5-0:1.0: 2 ports detected
[    8.076789] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.125036]   alloc irq_desc for 22 on cpu 0 node 0
[    8.125040]   alloc kstat_irqs on cpu 0 node 0
[    8.125049] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    8.125151] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.128752] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[d4004000-d40047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[    8.159902] hda_codec: STAC922x, Apple subsys_id=106b1e00
[    8.188672] input: HDA Intel at 0xd8400000 irq 22 Line In at Ext
Rear Jack as /class/input/input5
[    8.189931] input: HDA Intel at 0xd8400000 irq 22 HP Out at Ext
Rear Jack as /class/input/input6
[    8.313667] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    8.428714] usb 1-4: configuration #1 chosen from 1 choice
[    8.563671] EXT3 FS on sda5, internal journal
[    8.838664] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    9.018687] usb 2-2: configuration #1 chosen from 1 choice
[    9.117551] usbcore: registered new interface driver hiddev
[    9.118066] usbcore: registered new interface driver usbhid
[    9.118076] usbhid: v2.6:USB HID core driver
[    9.162238] appletouch: Geyser mode initialized.
[    9.162433] input: appletouch as /class/input/input7
[    9.168827] usbcore: registered new interface driver appletouch
[    9.235673] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    9.306533] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input8
[    9.318358] apple 0003:05AC:021A.0001: input: USB HID v1.11
Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input0
[    9.322424] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input9
[    9.325769] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device
[Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input2
[    9.394269] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe9de076]
[    9.408112] usb 4-2: configuration #1 chosen from 1 choice
[    9.419555] generic-usb 0003:05AC:8240.0003: hiddev96: USB HID
v1.11 Device [Apple Computer, Inc. IR Receiver] on
usb-0000:00:1d.2-2/input0
[    9.625669] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    9.798649] usb 5-1: configuration #1 chosen from 1 choice
[    9.823955] input: HID 05ac:1000 as /class/input/input10
[    9.833524] generic-usb 0003:05AC:1000.0004: input: USB HID v1.11
Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[    9.852082] input: HID 05ac:1000 as /class/input/input11
[    9.862027] generic-usb 0003:05AC:1000.0005: input: USB HID v1.11
Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[   10.777858] tun: Universal TUN/TAP device driver, 1.6
[   10.777865] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   14.748644] kjournald starting.  Commit interval 5 seconds
[   14.749897] EXT3 FS on sda6, internal journal
[   14.749917] EXT3-fs: mounted filesystem with ordered data mode.
[   14.785433] ReiserFS: sda7: found reiserfs format "3.6" with standard journal
[   14.785518] ReiserFS: sda7: using ordered data mode
[   14.795127] ReiserFS: sda7: journal params: device sda7, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
[   14.795647] ReiserFS: sda7: checking transaction log (sda7)
[   14.828605] ReiserFS: sda7: Using r5 hash to sort names
[   14.895392] ReiserFS: sda8: found reiserfs format "3.6" with standard journal
[   14.895421] ReiserFS: sda8: using ordered data mode
[   14.895924] ReiserFS: sda8: journal params: device sda8, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
[   14.896481] ReiserFS: sda8: checking transaction log (sda8)
[   14.915927] ReiserFS: sda8: Using r5 hash to sort names
[   14.949604] kjournald starting.  Commit interval 5 seconds
[   14.950823] EXT3 FS on sda9, internal journal
[   14.950843] EXT3-fs: mounted filesystem with ordered data mode.
[   14.991786] kjournald starting.  Commit interval 5 seconds
[   14.993859] EXT3 FS on sda12, internal journal
[   14.993879] EXT3-fs: mounted filesystem with ordered data mode.
[   15.214143] Adding 2096472k swap on /dev/sda11.  Priority:-1
extents:1 across:2096472k
[   29.989135] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   32.021686] sky2 eth0: enabling interface
[   32.022058] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.518308] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow
control both
[   34.519069] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   53.488109] eth0: no IPv6 routers present
[   81.063386] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   81.137468] [drm] Initialized drm 1.1.0 20060810
[   81.155545] pci 0000:01:00.0: setting latency timer to 64
[   81.158454] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   81.574632]
[   81.574635] =======================================================
[   81.574643] [ INFO: possible circular locking dependency detected ]
[   81.574650] 2.6.29-rc5 #1
[   81.574654] -------------------------------------------------------
[   81.574660] X/5165 is trying to acquire lock:
[   81.574665]  (&dev->struct_mutex){--..}, at: [<f8da46a6>]
drm_mmap+0x2a/0x44 [drm]
[   81.574706]
[   81.574708] but task is already holding lock:
[   81.574713]  (&mm->mmap_sem){----}, at: [<c0106773>] sys_mmap2+0x49/0x80
[   81.574734]
[   81.574735] which lock already depends on the new lock.
[   81.574737]
[   81.574740]
[   81.574740] the existing dependency chain (in reverse order) is:
[   81.574740]
[   81.574740] -> #4 (&mm->mmap_sem){----}:
[   81.574740]        [<c014d125>] __lock_acquire+0xfc6/0x12ed
[   81.574740]        [<c014d494>] lock_acquire+0x48/0x64
[   81.574740]        [<c017b299>] might_fault+0x6d/0x8d
[   81.574740]        [<c0348969>] copy_to_user+0x31/0x100
[   81.574740]        [<c019c04c>] filldir64+0x9c/0xd2
[   81.574740]        [<c01cb610>] sysfs_readdir+0x11c/0x150
[   81.574740]        [<c019c25b>] vfs_readdir+0x5b/0x87
[   81.574740]        [<c019c2ef>] sys_getdents64+0x68/0xa5
[   81.574740]        [<c0102f85>] sysenter_do_call+0x12/0x35
[   81.574740]        [<ffffffff>] 0xffffffff
[   81.574740]
[   81.574740] -> #3 (sysfs_mutex){--..}:
[   81.574740]        [<c014d125>] __lock_acquire+0xfc6/0x12ed
[   81.574740]        [<c014d494>] lock_acquire+0x48/0x64
[   81.574740]        [<c054ff2c>] mutex_lock_nested+0xe4/0x278
[   81.574740]        [<c01cb855>] sysfs_addrm_start+0x28/0x9a
[   81.574740]        [<c01cbd23>] create_dir+0x3f/0x77
[   81.574740]        [<c01cbd8d>] sysfs_create_dir+0x32/0x46
[   81.574740]        [<c0343a09>] kobject_add_internal+0xb7/0x158
[   81.574740]        [<c0343b55>] kobject_add_varg+0x35/0x41
[   81.574740]        [<c0343b81>] kobject_init_and_add+0x20/0x22
[   81.574740]        [<c018ea34>] sysfs_slab_add+0xe0/0x14d
[   81.574740]        [<c018ead2>] sysfs_add_func+0x31/0x53
[   81.574740]        [<c013b019>] run_workqueue+0xdc/0x1b7
[   81.574740]        [<c013b1b0>] worker_thread+0xbc/0xc8
[   81.574740]        [<c013e3ec>] kthread+0x40/0x66
[   81.574740]        [<c0103803>] kernel_thread_helper+0x7/0x10
[   81.574740]        [<ffffffff>] 0xffffffff
[   81.574740]
[   81.574740] -> #2 (slub_lock){----}:
[   81.574740]        [<c014d125>] __lock_acquire+0xfc6/0x12ed
[   81.574740]        [<c014d494>] lock_acquire+0x48/0x64
[   81.574740]        [<c05506bf>] down_read+0x2f/0x43
[   81.574740]        [<c054d70c>] slab_cpuup_callback+0x47/0x1ab
[   81.574740]        [<c01421db>] notifier_call_chain+0x2b/0x4a
[   81.574740]        [<c0142266>] __raw_notifier_call_chain+0x13/0x15
[   81.574740]        [<c054ca3b>] _cpu_up+0x62/0x102
[   81.574740]        [<c054cb2c>] cpu_up+0x51/0x66
[   81.574740]        [<c074f29a>] kernel_init+0x9f/0x155
[   81.574740]        [<c0103803>] kernel_thread_helper+0x7/0x10
[   81.574740]        [<ffffffff>] 0xffffffff
[   81.574740]
[   81.574740] -> #1 (&cpu_hotplug.lock){--..}:
[   81.574740]        [<c014d125>] __lock_acquire+0xfc6/0x12ed
[   81.574740]        [<c014d494>] lock_acquire+0x48/0x64
[   81.574740]        [<c054ff2c>] mutex_lock_nested+0xe4/0x278
[   81.574740]        [<c012e3c8>] get_online_cpus+0x31/0x45
[   81.574740]        [<c010d8d7>] mtrr_del_page+0x33/0x117
[   81.574740]        [<c010d9ef>] mtrr_del+0x34/0x3d
[   81.574740]        [<f8d9e08e>] drm_rmmap_locked+0xb6/0x168 [drm]
[   81.574740]        [<f8da3bff>] drm_master_destroy+0x74/0x131 [drm]
[   81.574740]        [<c034437c>] kref_put+0x3c/0x4a
[   81.574740]        [<f8da3b33>] drm_master_put+0x17/0x20 [drm]
[   81.574740]        [<f8d9fee2>] drm_release+0x31e/0x3e0 [drm]
[   81.574740]        [<c0191d52>] __fput+0xcf/0x173
[   81.574740]        [<c0191e14>] fput+0x1e/0x20
[   81.574740]        [<c018f5ea>] filp_close+0x56/0x60
[   81.574740]        [<c018f663>] sys_close+0x6f/0xa9
[   81.574740]        [<c0102f85>] sysenter_do_call+0x12/0x35
[   81.574740]        [<ffffffff>] 0xffffffff
[   81.574740]
[   81.574740] -> #0 (&dev->struct_mutex){--..}:
[   81.574740]        [<c014ce4f>] __lock_acquire+0xcf0/0x12ed
[   81.574740]        [<c014d494>] lock_acquire+0x48/0x64
[   81.574740]        [<c054ff2c>] mutex_lock_nested+0xe4/0x278
[   81.574740]        [<f8da46a6>] drm_mmap+0x2a/0x44 [drm]
[   81.574740]        [<c018132d>] mmap_region+0x27a/0x414
[   81.574740]        [<c01816b0>] do_mmap_pgoff+0x1e9/0x232
[   81.574740]        [<c0106789>] sys_mmap2+0x5f/0x80
[   81.574740]        [<c0102f85>] sysenter_do_call+0x12/0x35
[   81.574740]        [<ffffffff>] 0xffffffff
[   81.574740]
[   81.574740] other info that might help us debug this:
[   81.574740]
[   81.574740] 1 lock held by X/5165:
[   81.574740]  #0:  (&mm->mmap_sem){----}, at: [<c0106773>] sys_mmap2+0x49/0x80
[   81.574740]
[   81.574740] stack backtrace:
[   81.574740] Pid: 5165, comm: X Not tainted 2.6.29-rc5 #1
[   81.574740] Call Trace:
[   81.574740]  [<c054e6fd>] ? printk+0x14/0x16
[   81.574740]  [<c014be21>] print_circular_bug_tail+0xaa/0xb5
[   81.574740]  [<c014ce4f>] __lock_acquire+0xcf0/0x12ed
[   81.574740]  [<c014d494>] lock_acquire+0x48/0x64
[   81.574740]  [<f8da46a6>] ? drm_mmap+0x2a/0x44 [drm]
[   81.574740]  [<c054ff2c>] mutex_lock_nested+0xe4/0x278
[   81.574740]  [<f8da46a6>] ? drm_mmap+0x2a/0x44 [drm]
[   81.574740]  [<f8da46a6>] ? drm_mmap+0x2a/0x44 [drm]
[   81.574740]  [<f8da46a6>] drm_mmap+0x2a/0x44 [drm]
[   81.574740]  [<c018132d>] mmap_region+0x27a/0x414
[   81.574740]  [<c01816b0>] do_mmap_pgoff+0x1e9/0x232
[   81.574740]  [<c0106789>] sys_mmap2+0x5f/0x80
[   81.574740]  [<c0102f85>] sysenter_do_call+0x12/0x35
[   81.633885] [drm] Setting GART location based on new memory map
[   81.635561] [drm] Loading R500 Microcode
[   81.635634] [drm] Num pipes: 1
[   81.635653] [drm] writeback test succeeded in 1 usecs
[   81.914352] X:5165 conflicting memory types c0000000-d0000000
write-combining<->uncached-minus
[   81.914362] reserve_memtype failed 0xc0000000-0xd0000000, track
write-combining, req write-combining
[   82.664627] X:5165 conflicting memory types c0000000-d0000000
write-combining<->uncached-minus
[   82.664637] reserve_memtype failed 0xc0000000-0xd0000000, track
write-combining, req write-combining
[   82.957593] X:5165 conflicting memory types c0000000-d0000000
write-combining<->uncached-minus
[   82.957601] reserve_memtype failed 0xc0000000-0xd0000000, track
write-combining, req write-combining
[   83.014618] X:5188 freeing invalid memtype c0000000-d0000000
[  112.175525] [drm] Num pipes: 1
[  114.217707] X:5165 freeing invalid memtype c0000000-d0000000
[  114.228995] X:5165 freeing invalid memtype c0000000-d0000000
