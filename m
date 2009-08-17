Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbZHQJ3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbZHQJ3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245AbZHQJ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:29:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbZHQJ26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:28:58 -0400
Date: Mon, 17 Aug 2009 11:28:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [circular locking bug] Re: [patch 00/15] clocksource / timekeeping
	rework V4 (resend V3 + bug fix)
Message-ID: <20090817092807.GA10460@elte.hu>
References: <20090814134717.859098725@de.ibm.com> <1250300765.8269.29.camel@localhost.localdomain> <alpine.LFD.2.00.0908151057500.1283@localhost.localdomain> <20090815095221.GA15831@elte.hu> <alpine.LFD.2.00.0908151207000.1283@localhost.localdomain> <20090817094042.03fe5d38@skybase> <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


-tip testing still triggers lockdep troubles with latest 
timers/core. I think timekeeping_notify() might be involved.

Bootlog below, config attached.

	Ingo

[    0.000000] Linux version 2.6.31-rc6-tip-01039-ge54d9cb-dirty (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #4937 SMP Mon Aug 17 11:04:54 CEST 2009
[    0.000000] Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 100000-302000
[    0.000000] ACPI: RSDP 00000000000f76f0 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 000000003fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000003fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000003fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000003fff0000 00040
[    0.000000] ACPI: SRAT 000000003fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
[    0.000000] ACPI: MCFG 000000003fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 000000003fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-40000000
[    0.000000] NUMA: Allocated memnodemap from 10000 - 10840
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [0000000000010840 - 000000000001583f]
[    0.000000]   bootmap [0000000000016000 -  000000000001dfff] pages 8
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00029d0658]    TEXT DATA BSS ==> [0001000000 - 00029d0658]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [00029d1000 - 00029d1149]              BRK ==> [00029d1000 - 00029d1149]
[    0.000000]   #5 [0000100000 - 0000300000]          PGTABLE ==> [0000100000 - 0000300000]
[    0.000000]   #6 [0000010000 - 0000010840]       MEMNODEMAP ==> [0000010000 - 0000010840]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 611 pages reserved
[    0.000000]   DMA zone: 3268 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6552 pages used for memmap
[    0.000000]   DMA32 zone: 251480 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 479 pages at ffff8800029ea000, static data 1929760 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 254748
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] Memory: 923412k/1048512k available (8687k kernel code, 452k absent, 124648k reserved, 4619k data, 2572k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.588 MHz processor.
[    0.000071] spurious 8259A interrupt: IRQ7.
[    0.006622] Console: colour VGA+ 80x25
[    0.010000] console [ttyS0] enabled, bootconsole disabled
[    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.010000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.010000] ... MAX_LOCK_DEPTH:          48
[    0.010000] ... MAX_LOCKDEP_KEYS:        8191
[    0.010000] ... CLASSHASH_SIZE:          4096
[    0.010000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.010000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.010000] ... CHAINHASH_SIZE:          16384
[    0.010000]  memory used by lock dependency info: 6367 kB
[    0.010000]  per task-struct memory footprint: 2688 bytes
[    0.010000] ------------------------
[    0.010000] | Locking API testsuite:
[    0.010000] ----------------------------------------------------------------------------
[    0.010000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.010000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.010000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.010000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.010000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.010000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.010000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.010000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.010000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.010000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.010000]       hard-irq read-recursion/123:  ok  |
[    0.010000]       soft-irq read-recursion/123:  ok  |
[    0.010000]       hard-irq read-recursion/132:  ok  |
[    0.010000]       soft-irq read-recursion/132:  ok  |
[    0.010000]       hard-irq read-recursion/213:  ok  |
[    0.010000]       soft-irq read-recursion/213:  ok  |
[    0.010000]       hard-irq read-recursion/231:  ok  |
[    0.010000]       soft-irq read-recursion/231:  ok  |
[    0.010000]       hard-irq read-recursion/312:  ok  |
[    0.010000]       soft-irq read-recursion/312:  ok  |
[    0.010000]       hard-irq read-recursion/321:  ok  |
[    0.010000]       soft-irq read-recursion/321:  ok  |
[    0.010000] -------------------------------------------------------
[    0.010000] Good, all 218 testcases passed! |
[    0.010000] ---------------------------------
[    0.010042] Calibrating delay loop (skipped), value calculated using timer frequency.. 4021.17 BogoMIPS (lpj=20105880)
[    0.020210] Security Framework initialized
[    0.024956] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.030859] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.040392] Mount-cache hash table entries: 256
[    0.046889] Initializing cgroup subsys ns
[    0.050023] Initializing cgroup subsys cpuacct
[    0.054477] Initializing cgroup subsys freezer
[    0.060057] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.067182] CPU: L2 Cache: 512K (64 bytes/line)
[    0.070008] CPU 0/0x0 -> Node 0
[    0.073146] tseg: 0000000000
[    0.076051] CPU: Physical Processor ID: 0
[    0.080005] CPU: Processor Core ID: 0
[    0.083659] mce: CPU supports 5 MCE banks
[    0.087670] numa_add_cpu cpu 0 node 0: mask now 0
[    0.091052] ACPI: Core revision 20090521
[    0.139363] Setting APIC routing to flat
[    0.140012] enabled ExtINT on CPU#0
[    0.143656] ENABLING IO-APIC IRQs
[    0.150006] init IO_APIC IRQs
[    0.153013] IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.160020] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.167327] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.170016] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.180016] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.187326] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.190016] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.200016] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.210016] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.217327] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.220016] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.230016] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.240016] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.247500] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.250016] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.260009]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.270139] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.377786] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.381237] Using local APIC timer interrupts.
[    0.381238] calibrating APIC timer ...
[    0.400000] ... lapic delta = 1256460
[    0.400000] ... PM-Timer delta = 357960
[    0.400000] ... PM-Timer result ok
[    0.400000] ..... delta 1256460
[    0.400000] ..... mult: 53964546
[    0.400000] ..... calibration result: 2010336
[    0.400000] ..... CPU clock speed is 2010.3360 MHz.
[    0.400000] ..... host bus clock speed is 201.0336 MHz.
[    0.400025] calling  migration_init+0x0/0x7f @ 1
[    0.404907] initcall migration_init+0x0/0x7f returned 0 after 0 usecs
[    0.410007] calling  spawn_ksoftirqd+0x0/0x7f @ 1
[    0.414801] initcall spawn_ksoftirqd+0x0/0x7f returned 0 after 0 usecs
[    0.420008] calling  init_call_single_data+0x0/0xde @ 1
[    0.425233] initcall init_call_single_data+0x0/0xde returned 0 after 0 usecs
[    0.430006] calling  relay_init+0x0/0x3b @ 1
[    0.434279] initcall relay_init+0x0/0x3b returned 0 after 0 usecs
[    0.440484] lockdep: fixing up alternatives.
[    0.450308] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] masked ExtINT on CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4020.72 BogoMIPS (lpj=20103606)
[    0.010000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.010000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.010000] CPU 1/0x1 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] mce: CPU supports 5 MCE banks
[    0.010000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.610120] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.631261] Brought up 2 CPUs
[    0.634225] Total of 2 processors activated (8041.89 BogoMIPS).
[    0.640664] device: 'platform': device_add
[    0.644297] PM: Adding info for No Bus:platform
[    0.650141] khelper used greatest stack depth: 4592 bytes left
[    0.650160] bus: 'platform': registered
[    0.660012] Registering sysdev class 'cpu'
[    0.664144] calling  init_cpufreq_transition_notifier_list+0x0/0x42 @ 1
[    0.670012] initcall init_cpufreq_transition_notifier_list+0x0/0x42 returned 0 after 0 usecs
[    0.680006] calling  net_ns_init+0x0/0x10e @ 1
[    0.684543] initcall net_ns_init+0x0/0x10e returned 0 after 0 usecs
[    0.690007] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.694363] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.700005] calling  pci_reboot_init+0x0/0x3b @ 1
[    0.704702] initcall pci_reboot_init+0x0/0x3b returned 0 after 0 usecs
[    0.710009] calling  init_lapic_sysfs+0x0/0x52 @ 1
[    0.720004] Registering sysdev class 'lapic'
[    0.724320] Registering sys device of class 'lapic'
[    0.724896] Registering sys device 'lapic0'
[    0.730096] initcall init_lapic_sysfs+0x0/0x52 returned 0 after 9765 usecs
[    0.740005] calling  print_banner+0x0/0xe @ 1
[    0.744355] Booting paravirtualized kernel on bare hardware
[    0.750005] initcall print_banner+0x0/0xe returned 0 after 9765 usecs
[    0.756434] calling  init_smp_flush+0x0/0x5f @ 1
[    0.760006] initcall init_smp_flush+0x0/0x5f returned 0 after 0 usecs
[    0.766437] calling  alloc_frozen_cpus+0x0/0x45 @ 1
[    0.770010] initcall alloc_frozen_cpus+0x0/0x45 returned 0 after 0 usecs
[    0.776704] calling  sysctl_init+0x0/0x3d @ 1
[    0.780011] initcall sysctl_init+0x0/0x3d returned 0 after 0 usecs
[    0.790005] calling  ksysfs_init+0x0/0xe4 @ 1
[    0.794439] initcall ksysfs_init+0x0/0xe4 returned 0 after 0 usecs
[    0.800006] calling  async_init+0x0/0x69 @ 1
[    0.804268] initcall async_init+0x0/0x69 returned 0 after 0 usecs
[    0.810005] calling  init_jiffies_clocksource+0x0/0x39 @ 1
[    0.815515] initcall init_jiffies_clocksource+0x0/0x39 returned 0 after 0 usecs
[    0.820005] calling  pm_init+0x0/0x5b @ 1
[    0.824028] initcall pm_init+0x0/0x5b returned 0 after 0 usecs
[    0.830006] calling  init_hw_breakpoint+0x0/0x39 @ 1
[    0.834981] initcall init_hw_breakpoint+0x0/0x39 returned 0 after 0 usecs
[    0.840009] calling  filelock_init+0x0/0x55 @ 1
[    0.850015] initcall filelock_init+0x0/0x55 returned 0 after 0 usecs
[    0.856365] calling  init_misc_binfmt+0x0/0x67 @ 1
[    0.860027] initcall init_misc_binfmt+0x0/0x67 returned 0 after 0 usecs
[    0.866632] calling  init_script_binfmt+0x0/0x3b @ 1
[    0.870006] initcall init_script_binfmt+0x0/0x3b returned 0 after 0 usecs
[    0.880006] calling  init_elf_binfmt+0x0/0x3b @ 1
[    0.884710] initcall init_elf_binfmt+0x0/0x3b returned 0 after 0 usecs
[    0.890005] calling  init_compat_elf_binfmt+0x0/0x3b @ 1
[    0.895308] initcall init_compat_elf_binfmt+0x0/0x3b returned 0 after 0 usecs
[    0.900006] calling  debugfs_init+0x0/0x80 @ 1
[    0.904450] initcall debugfs_init+0x0/0x80 returned 0 after 0 usecs
[    0.910006] calling  random32_init+0x0/0xf3 @ 1
[    0.914530] initcall random32_init+0x0/0xf3 returned 0 after 0 usecs
[    0.920008] calling  gnttab_init+0x0/0x1a3 @ 1
[    0.924451] initcall gnttab_init+0x0/0x1a3 returned -19 after 0 usecs
[    0.930006] calling  regulator_init+0x0/0x53 @ 1
[    0.940004] regulator: core version 0.5
[    0.943835] device class 'regulator': registering
[    0.948584] initcall regulator_init+0x0/0x53 returned 0 after 0 usecs
[    0.950008] calling  early_resume_init+0x0/0x3a @ 1
[    0.960022] Time: 15:03:49  Date: 08/17/09
[    0.964112] initcall early_resume_init+0x0/0x3a returned 0 after 0 usecs
[    0.970006] calling  cpufreq_core_init+0x0/0x9f @ 1
[    0.974878] initcall cpufreq_core_init+0x0/0x9f returned 0 after 0 usecs
[    0.980005] calling  cpuidle_init+0x0/0x66 @ 1
[    0.984455] initcall cpuidle_init+0x0/0x66 returned 0 after 0 usecs
[    0.990007] calling  sock_init+0x0/0x85 @ 1
[    0.994510] initcall sock_init+0x0/0x85 returned 0 after 0 usecs
[    1.000005] calling  net_inuse_init+0x0/0x4d @ 1
[    1.004641] initcall net_inuse_init+0x0/0x4d returned 0 after 0 usecs
[    1.010005] calling  netpoll_init+0x0/0x69 @ 1
[    1.020005] initcall netpoll_init+0x0/0x69 returned 0 after 0 usecs
[    1.026262] calling  netlink_proto_init+0x0/0x169 @ 1
[    1.030098] NET: Registered protocol family 16
[    1.034653] initcall netlink_proto_init+0x0/0x169 returned 0 after 0 usecs
[    1.040005] calling  bdi_class_init+0x0/0x68 @ 1
[    1.044616] device class 'bdi': registering
[    1.050303] initcall bdi_class_init+0x0/0x68 returned 0 after 9765 usecs
[    1.056993] calling  kobject_uevent_init+0x0/0x7b @ 1
[    1.060026] initcall kobject_uevent_init+0x0/0x7b returned 0 after 0 usecs
[    1.070004] calling  pcibus_class_init+0x0/0x40 @ 1
[    1.074876] device class 'pci_bus': registering
[    1.080097] initcall pcibus_class_init+0x0/0x40 returned 0 after 9765 usecs
[    1.086972] calling  pci_driver_init+0x0/0x39 @ 1
[    1.090073] bus: 'pci': registered
[    1.093457] initcall pci_driver_init+0x0/0x39 returned 0 after 0 usecs
[    1.100007] calling  backlight_class_init+0x0/0x84 @ 1
[    1.105143] device class 'backlight': registering
[    1.110066] initcall backlight_class_init+0x0/0x84 returned 0 after 9765 usecs
[    1.117233] calling  xenbus_probe_init+0x0/0x124 @ 1
[    1.120006] initcall xenbus_probe_init+0x0/0x124 returned -19 after 0 usecs
[    1.130005] calling  tty_class_init+0x0/0x58 @ 1
[    1.134616] device class 'tty': registering
[    1.140065] initcall tty_class_init+0x0/0x58 returned 0 after 9765 usecs
[    1.146712] calling  vtconsole_class_init+0x0/0xe8 @ 1
[    1.150006] device class 'vtconsole': registering
[    1.154763] device: 'vtcon0': device_add
[    1.160053] PM: Adding info for No Bus:vtcon0
[    1.164458] initcall vtconsole_class_init+0x0/0xe8 returned 0 after 9765 usecs
[    1.170007] calling  register_node_type+0x0/0xa4 @ 1
[    1.174969] Registering sysdev class 'node'
[    1.180060] initcall register_node_type+0x0/0xa4 returned 0 after 9765 usecs
[    1.187074] calling  spi_init+0x0/0xf4 @ 1
[    1.190063] bus: 'spi': registered
[    1.193446] device class 'spi_master': registering
[    1.200078] initcall spi_init+0x0/0xf4 returned 0 after 9765 usecs
[    1.206199] calling  i2c_init+0x0/0x8c @ 1
[    1.210064] bus: 'i2c': registered
[    1.213446] device class 'i2c-adapter': registering
[    1.220068] bus: 'i2c': add driver dummy
[    1.224019] i2c-core: driver [dummy] registered
[    1.230045] initcall i2c_init+0x0/0x8c returned 0 after 19531 usecs
[    1.236304] calling  amd_postcore_init+0x0/0xdc @ 1
[    1.240008] node 0 link 0: io port [1000, fffff]
[    1.244625] TOM: 0000000040000000 aka 1024M
[    1.250005] node 0 link 0: mmio [e0000000, efffffff]
[    1.254978] node 0 link 0: mmio [feb00000, fec0ffff]
[    1.260201] node 0 link 0: mmio [a0000, bffff]
[    1.264660] node 0 link 0: mmio [40000000, fed3ffff]
[    1.269638] bus: [00,ff] on node 0 link 0
[    1.270006] bus: 00 index 0 io port: [0, ffff]
[    1.274443] bus: 00 index 1 mmio: [40000000, fcffffffff]
[    1.280004] bus: 00 index 2 mmio: [feb00000, fec0ffff]
[    1.285134] bus: 00 index 3 mmio: [a0000, bffff]
[    1.290005] initcall amd_postcore_init+0x0/0xdc returned 0 after 48828 usecs
[    1.300005] calling  arch_kdebugfs_init+0x0/0x55 @ 1
[    1.305019] initcall arch_kdebugfs_init+0x0/0x55 returned 0 after 0 usecs
[    1.310081] calling  ffh_cstate_init+0x0/0x51 @ 1
[    1.314780] initcall ffh_cstate_init+0x0/0x51 returned -1 after 0 usecs
[    1.320006] initcall ffh_cstate_init+0x0/0x51 returned with error code -1 
[    1.330004] calling  acpi_pci_init+0x0/0x81 @ 1
[    1.334569] ACPI: bus type pci registered
[    1.338573] initcall acpi_pci_init+0x0/0x81 returned 0 after 0 usecs
[    1.340005] calling  setup_vcpu_hotplug_event+0x0/0x49 @ 1
[    1.350007] initcall setup_vcpu_hotplug_event+0x0/0x49 returned -19 after 0 usecs
[    1.357483] calling  dmi_id_init+0x0/0x11c @ 1
[    1.360006] device class 'dmi': registering
[    1.364247] device: 'id': device_add
[    1.370105] PM: Adding info for No Bus:id
[    1.374215] initcall dmi_id_init+0x0/0x11c returned 0 after 9765 usecs
[    1.380005] calling  dma_bus_init+0x0/0x66 @ 1
[    1.384441] device class 'dma': registering
[    1.390066] initcall dma_bus_init+0x0/0x66 returned 0 after 9765 usecs
[    1.396539] calling  dma_channel_table_init+0x0/0x137 @ 1
[    1.400022] initcall dma_channel_table_init+0x0/0x137 returned 0 after 0 usecs
[    1.407229] calling  dca_init+0x0/0x45 @ 1
[    1.410003] dca service started, version 1.8
[    1.414270] device class 'dca': registering
[    1.420065] initcall dca_init+0x0/0x45 returned 0 after 9765 usecs
[    1.426195] calling  pci_arch_init+0x0/0x67 @ 1
[    1.430010] PCI: Using configuration type 1 for base access
[    1.435583] initcall pci_arch_init+0x0/0x67 returned 0 after 0 usecs
[    1.440005] calling  topology_init+0x0/0xec @ 1
[    1.444528] Registering sys device of class 'node'
[    1.450010] Registering sys device 'node0'
[    1.454152] Registering sys device of class 'cpu'
[    1.460012] Registering sys device 'cpu0'
[    1.464066] Registering sys device of class 'cpu'
[    1.470010] Registering sys device 'cpu1'
[    1.474067] initcall topology_init+0x0/0xec returned 0 after 29296 usecs
[    1.480007] calling  param_sysfs_init+0x0/0xf6 @ 1
[    1.560223] initcall param_sysfs_init+0x0/0xf6 returned 0 after 78125 usecs
[    1.570464] calling  pm_sysrq_init+0x0/0x40 @ 1
[    1.575020] initcall pm_sysrq_init+0x0/0x40 returned 0 after 0 usecs
[    1.580636] calling  audit_watch_init+0x0/0x56 @ 1
[    1.590554] initcall audit_watch_init+0x0/0x56 returned 0 after 0 usecs
[    1.597160] calling  init_slow_work+0x0/0x5f @ 1
[    1.600006] initcall init_slow_work+0x0/0x5f returned 0 after 0 usecs
[    1.606443] calling  default_bdi_init+0x0/0x5e @ 1
[    1.610031] device: 'default': device_add
[    1.614073] PM: Adding info for No Bus:default
[    1.620109] initcall default_bdi_init+0x0/0x5e returned 0 after 9765 usecs
[    1.630207] calling  init_bio+0x0/0x100 @ 1
[    1.634550] bio: create slab <bio-0> at 0
[    1.638655] initcall init_bio+0x0/0x100 returned 0 after 0 usecs
[    1.640537] calling  fsnotify_init+0x0/0x39 @ 1
[    1.645069] initcall fsnotify_init+0x0/0x39 returned 0 after 0 usecs
[    1.650582] calling  fsnotify_notification_init+0x0/0x129 @ 1
[    1.660171] initcall fsnotify_notification_init+0x0/0x129 returned 0 after 0 usecs
[    1.670010] calling  cryptomgr_init+0x0/0x39 @ 1
[    1.674624] initcall cryptomgr_init+0x0/0x39 returned 0 after 0 usecs
[    1.680006] calling  blk_settings_init+0x0/0x51 @ 1
[    1.684876] initcall blk_settings_init+0x0/0x51 returned 0 after 0 usecs
[    1.690005] calling  blk_ioc_init+0x0/0x51 @ 1
[    1.694450] initcall blk_ioc_init+0x0/0x51 returned 0 after 0 usecs
[    1.700006] calling  blk_softirq_init+0x0/0xd3 @ 1
[    1.704792] initcall blk_softirq_init+0x0/0xd3 returned 0 after 0 usecs
[    1.710007] calling  genhd_device_init+0x0/0x8c @ 1
[    1.720004] device class 'block': registering
[    1.724472] initcall genhd_device_init+0x0/0x8c returned 0 after 0 usecs
[    1.730252] calling  gpiolib_debugfs_init+0x0/0x4b @ 1
[    1.735406] initcall gpiolib_debugfs_init+0x0/0x4b returned 0 after 0 usecs
[    1.740042] calling  max7301_init+0x0/0x39 @ 1
[    1.744487] bus: 'spi': add driver max7301
[    1.750115] initcall max7301_init+0x0/0x39 returned 0 after 9765 usecs
[    1.756544] calling  pca953x_init+0x0/0x3b @ 1
[    1.760253] bus: 'i2c': add driver pca953x
[    1.764485] i2c-core: driver [pca953x] registered
[    1.770090] initcall pca953x_init+0x0/0x3b returned 0 after 9765 usecs
[    1.776607] calling  pci_slot_init+0x0/0x6e @ 1
[    1.780015] initcall pci_slot_init+0x0/0x6e returned 0 after 0 usecs
[    1.790005] calling  fbmem_init+0x0/0xb8 @ 1
[    1.794317] device class 'graphics': registering
[    1.798993] initcall fbmem_init+0x0/0xb8 returned 0 after 0 usecs
[    1.800050] calling  acpi_init+0x0/0x149 @ 1
[    1.815101] ACPI: EC: Look up EC in DSDT
[    1.877234] ACPI: Interpreter enabled
[    1.880009] ACPI: (supports S0 S5)
[    1.883517] ACPI: Using IOAPIC for interrupt routing
[    1.888796] bus: 'acpi': registered
[    1.890153] device: 'LNXSYSTM:00': device_add
[    1.894549] bus: 'acpi': add device LNXSYSTM:00
[    1.900026] PM: Adding info for acpi:LNXSYSTM:00
[    1.904697] device: 'LNXPWRBN:00': device_add
[    1.910016] bus: 'acpi': add device LNXPWRBN:00
[    1.914565] PM: Adding info for acpi:LNXPWRBN:00
[    1.920099] device: 'LNXCPU:00': device_add
[    1.924294] bus: 'acpi': add device LNXCPU:00
[    1.928677] PM: Adding info for acpi:LNXCPU:00
[    1.930110] device: 'LNXCPU:01': device_add
[    1.934302] bus: 'acpi': add device LNXCPU:01
[    1.940024] PM: Adding info for acpi:LNXCPU:01
[    1.944518] device: 'device:00': device_add
[    1.950015] bus: 'acpi': add device device:00
[    1.954400] PM: Adding info for acpi:device:00
[    1.960028] device: 'device:00': dev_uevent: bus uevent() returned -12
[    1.966935] device: 'PNP0C0C:00': device_add
[    1.970015] bus: 'acpi': add device PNP0C0C:00
[    1.974469] PM: Adding info for acpi:PNP0C0C:00
[    1.980622] device: 'PNP0A08:00': device_add
[    1.984899] bus: 'acpi': add device PNP0A08:00
[    1.990028] PM: Adding info for acpi:PNP0A08:00
[    1.994606] device: 'PNP0C02:00': device_add
[    2.000011] bus: 'acpi': add device PNP0C02:00
[    2.004476] PM: Adding info for acpi:PNP0C02:00
[    2.009090] device: 'device:01': device_add
[    2.010016] bus: 'acpi': add device device:01
[    2.014391] PM: Adding info for acpi:device:01
[    2.020027] device: 'device:01': dev_uevent: bus uevent() returned -12
[    2.026745] device: 'device:02': device_add
[    2.030014] bus: 'acpi': add device device:02
[    2.034380] PM: Adding info for acpi:device:02
[    2.040027] device: 'device:02': dev_uevent: bus uevent() returned -12
[    2.046729] device: 'device:03': device_add
[    2.050016] bus: 'acpi': add device device:03
[    2.054399] PM: Adding info for acpi:device:03
[    2.060028] device: 'device:03': dev_uevent: bus uevent() returned -12
[    2.066733] device: 'device:04': device_add
[    2.070014] bus: 'acpi': add device device:04
[    2.074393] PM: Adding info for acpi:device:04
[    2.080028] device: 'device:04': dev_uevent: bus uevent() returned -12
[    2.086729] device: 'device:05': device_add
[    2.090016] bus: 'acpi': add device device:05
[    2.094392] PM: Adding info for acpi:device:05
[    2.100027] device: 'device:05': dev_uevent: bus uevent() returned -12
[    2.106728] device: 'device:06': device_add
[    2.110014] bus: 'acpi': add device device:06
[    2.114390] PM: Adding info for acpi:device:06
[    2.120028] device: 'device:06': dev_uevent: bus uevent() returned -12
[    2.126728] device: 'device:07': device_add
[    2.130016] bus: 'acpi': add device device:07
[    2.134391] PM: Adding info for acpi:device:07
[    2.140030] device: 'device:07': dev_uevent: bus uevent() returned -12
[    2.146763] device: 'device:08': device_add
[    2.150014] bus: 'acpi': add device device:08
[    2.154383] PM: Adding info for acpi:device:08
[    2.160028] device: 'device:08': dev_uevent: bus uevent() returned -12
[    2.166729] device: 'device:09': device_add
[    2.170016] bus: 'acpi': add device device:09
[    2.174392] PM: Adding info for acpi:device:09
[    2.180028] device: 'device:09': dev_uevent: bus uevent() returned -12
[    2.186720] device: 'device:0a': device_add
[    2.190024] bus: 'acpi': add device device:0a
[    2.194400] PM: Adding info for acpi:device:0a
[    2.200028] device: 'device:0a': dev_uevent: bus uevent() returned -12
[    2.206717] device: 'device:0b': device_add
[    2.210015] bus: 'acpi': add device device:0b
[    2.214385] PM: Adding info for acpi:device:0b
[    2.220028] device: 'device:0b': dev_uevent: bus uevent() returned -12
[    2.226716] device: 'device:0c': device_add
[    2.230014] bus: 'acpi': add device device:0c
[    2.234384] PM: Adding info for acpi:device:0c
[    2.240027] device: 'device:0c': dev_uevent: bus uevent() returned -12
[    2.246732] device: 'device:0d': device_add
[    2.250015] bus: 'acpi': add device device:0d
[    2.254400] PM: Adding info for acpi:device:0d
[    2.258863] device: 'device:0d': dev_uevent: bus uevent() returned -12
[    2.260166] device: 'device:0e': device_add
[    2.270014] bus: 'acpi': add device device:0e
[    2.274381] PM: Adding info for acpi:device:0e
[    2.278846] device: 'device:0e': dev_uevent: bus uevent() returned -12
[    2.280162] device: 'device:0f': device_add
[    2.290015] bus: 'acpi': add device device:0f
[    2.294383] PM: Adding info for acpi:device:0f
[    2.298848] device: 'device:0f': dev_uevent: bus uevent() returned -12
[    2.300162] device: 'device:10': device_add
[    2.310030] bus: 'acpi': add device device:10
[    2.314419] PM: Adding info for acpi:device:10
[    2.318880] device: 'device:10': dev_uevent: bus uevent() returned -12
[    2.320162] device: 'device:11': device_add
[    2.324353] bus: 'acpi': add device device:11
[    2.330026] PM: Adding info for acpi:device:11
[    2.334491] device: 'device:11': dev_uevent: bus uevent() returned -12
[    2.340156] device: 'device:12': device_add
[    2.344347] bus: 'acpi': add device device:12
[    2.350024] PM: Adding info for acpi:device:12
[    2.354483] device: 'device:12': dev_uevent: bus uevent() returned -12
[    2.360230] device: 'device:13': device_add
[    2.364415] bus: 'acpi': add device device:13
[    2.370035] PM: Adding info for acpi:device:13
[    2.374499] device: 'device:13': dev_uevent: bus uevent() returned -12
[    2.380228] device: 'device:14': device_add
[    2.384418] bus: 'acpi': add device device:14
[    2.390025] PM: Adding info for acpi:device:14
[    2.394490] device: 'device:14': dev_uevent: bus uevent() returned -12
[    2.400312] device: 'device:15': device_add
[    2.404502] bus: 'acpi': add device device:15
[    2.410027] PM: Adding info for acpi:device:15
[    2.414490] device: 'device:15': dev_uevent: bus uevent() returned -12
[    2.420304] device: 'device:16': device_add
[    2.424496] bus: 'acpi': add device device:16
[    2.430077] PM: Adding info for acpi:device:16
[    2.434542] device: 'device:16': dev_uevent: bus uevent() returned -12
[    2.440258] device: 'device:17': device_add
[    2.444464] bus: 'acpi': add device device:17
[    2.450038] PM: Adding info for acpi:device:17
[    2.454499] device: 'device:17': dev_uevent: bus uevent() returned -12
[    2.460221] device: 'device:18': device_add
[    2.464409] bus: 'acpi': add device device:18
[    2.470025] PM: Adding info for acpi:device:18
[    2.474490] device: 'device:18': dev_uevent: bus uevent() returned -12
[    2.480561] device: 'device:19': device_add
[    2.484747] bus: 'acpi': add device device:19
[    2.490027] PM: Adding info for acpi:device:19
[    2.494490] device: 'device:19': dev_uevent: bus uevent() returned -12
[    2.500687] device: 'device:1a': device_add
[    2.504876] bus: 'acpi': add device device:1a
[    2.510035] PM: Adding info for acpi:device:1a
[    2.514497] device: 'device:1a': dev_uevent: bus uevent() returned -12
[    2.520288] device: 'device:1b': device_add
[    2.524475] bus: 'acpi': add device device:1b
[    2.530038] PM: Adding info for acpi:device:1b
[    2.534499] device: 'device:1b': dev_uevent: bus uevent() returned -12
[    2.540398] device: 'device:1c': device_add
[    2.544590] bus: 'acpi': add device device:1c
[    2.550026] PM: Adding info for acpi:device:1c
[    2.554489] device: 'device:1c': dev_uevent: bus uevent() returned -12
[    2.560400] device: 'device:1d': device_add
[    2.564589] bus: 'acpi': add device device:1d
[    2.570038] PM: Adding info for acpi:device:1d
[    2.574499] device: 'device:1d': dev_uevent: bus uevent() returned -12
[    2.580430] device: 'ATK0110:00': device_add
[    2.584703] bus: 'acpi': add device ATK0110:00
[    2.590025] PM: Adding info for acpi:ATK0110:00
[    2.594617] device: 'PNP0C0F:00': device_add
[    2.600017] bus: 'acpi': add device PNP0C0F:00
[    2.604478] PM: Adding info for acpi:PNP0C0F:00
[    2.610492] device: 'PNP0C0F:01': device_add
[    2.614770] bus: 'acpi': add device PNP0C0F:01
[    2.620037] PM: Adding info for acpi:PNP0C0F:01
[    2.624615] device: 'PNP0C0F:02': device_add
[    2.630017] bus: 'acpi': add device PNP0C0F:02
[    2.634478] PM: Adding info for acpi:PNP0C0F:02
[    2.640503] device: 'PNP0C0F:03': device_add
[    2.644776] bus: 'acpi': add device PNP0C0F:03
[    2.649237] PM: Adding info for acpi:PNP0C0F:03
[    2.650508] device: 'PNP0C0F:04': device_add
[    2.654781] bus: 'acpi': add device PNP0C0F:04
[    2.660029] PM: Adding info for acpi:PNP0C0F:04
[    2.664606] device: 'PNP0C0F:05': device_add
[    2.670017] bus: 'acpi': add device PNP0C0F:05
[    2.674480] PM: Adding info for acpi:PNP0C0F:05
[    2.680491] device: 'PNP0C0F:06': device_add
[    2.684767] bus: 'acpi': add device PNP0C0F:06
[    2.690038] PM: Adding info for acpi:PNP0C0F:06
[    2.694615] device: 'PNP0C0F:07': device_add
[    2.700017] bus: 'acpi': add device PNP0C0F:07
[    2.704479] PM: Adding info for acpi:PNP0C0F:07
[    2.710476] device: 'PNP0C0F:08': device_add
[    2.714761] bus: 'acpi': add device PNP0C0F:08
[    2.719219] PM: Adding info for acpi:PNP0C0F:08
[    2.720484] device: 'PNP0C0F:09': device_add
[    2.724774] bus: 'acpi': add device PNP0C0F:09
[    2.730027] PM: Adding info for acpi:PNP0C0F:09
[    2.734607] device: 'PNP0C0F:0a': device_add
[    2.740017] bus: 'acpi': add device PNP0C0F:0a
[    2.744481] PM: Adding info for acpi:PNP0C0F:0a
[    2.750475] device: 'PNP0C0F:0b': device_add
[    2.754752] bus: 'acpi': add device PNP0C0F:0b
[    2.760038] PM: Adding info for acpi:PNP0C0F:0b
[    2.764616] device: 'PNP0C0F:0c': device_add
[    2.770017] bus: 'acpi': add device PNP0C0F:0c
[    2.774479] PM: Adding info for acpi:PNP0C0F:0c
[    2.780484] device: 'PNP0C0F:0d': device_add
[    2.784764] bus: 'acpi': add device PNP0C0F:0d
[    2.789225] PM: Adding info for acpi:PNP0C0F:0d
[    2.790473] device: 'PNP0C0F:0e': device_add
[    2.794751] bus: 'acpi': add device PNP0C0F:0e
[    2.800048] PM: Adding info for acpi:PNP0C0F:0e
[    2.804623] device: 'PNP0C0F:0f': device_add
[    2.810017] bus: 'acpi': add device PNP0C0F:0f
[    2.814479] PM: Adding info for acpi:PNP0C0F:0f
[    2.820618] device: 'PNP0C0F:10': device_add
[    2.824898] bus: 'acpi': add device PNP0C0F:10
[    2.830027] PM: Adding info for acpi:PNP0C0F:10
[    2.834605] device: 'PNP0C0F:11': device_add
[    2.840017] bus: 'acpi': add device PNP0C0F:11
[    2.844478] PM: Adding info for acpi:PNP0C0F:11
[    2.850769] device: 'PNP0C0F:12': device_add
[    2.855051] bus: 'acpi': add device PNP0C0F:12
[    2.859511] PM: Adding info for acpi:PNP0C0F:12
[    2.860597] device: 'PNP0C0F:13': device_add
[    2.864872] bus: 'acpi': add device PNP0C0F:13
[    2.870048] PM: Adding info for acpi:PNP0C0F:13
[    2.874625] device: 'PNP0C0F:14': device_add
[    2.880018] bus: 'acpi': add device PNP0C0F:14
[    2.884479] PM: Adding info for acpi:PNP0C0F:14
[    2.890598] device: 'PNP0C0F:15': device_add
[    2.894872] bus: 'acpi': add device PNP0C0F:15
[    2.900027] PM: Adding info for acpi:PNP0C0F:15
[    2.904606] device: 'PNP0C0F:16': device_add
[    2.910027] bus: 'acpi': add device PNP0C0F:16
[    2.914490] PM: Adding info for acpi:PNP0C0F:16
[    2.920587] device: 'PNP0C0F:17': device_add
[    2.924862] bus: 'acpi': add device PNP0C0F:17
[    2.929322] PM: Adding info for acpi:PNP0C0F:17
[    2.930579] device: 'PNP0C0F:18': device_add
[    2.934853] bus: 'acpi': add device PNP0C0F:18
[    2.940037] PM: Adding info for acpi:PNP0C0F:18
[    2.944616] device: 'PNP0C0F:19': device_add
[    2.950018] bus: 'acpi': add device PNP0C0F:19
[    2.954480] PM: Adding info for acpi:PNP0C0F:19
[    2.960588] device: 'PNP0C0F:1a': device_add
[    2.964867] bus: 'acpi': add device PNP0C0F:1a
[    2.970028] PM: Adding info for acpi:PNP0C0F:1a
[    2.974605] device: 'PNP0C0F:1b': device_add
[    2.980017] bus: 'acpi': add device PNP0C0F:1b
[    2.984489] PM: Adding info for acpi:PNP0C0F:1b
[    2.990575] device: 'PNP0C0F:1c': device_add
[    2.994855] bus: 'acpi': add device PNP0C0F:1c
[    3.000028] PM: Adding info for acpi:PNP0C0F:1c
[    3.004606] device: 'PNP0C0F:1d': device_add
[    3.004844] bus: 'acpi': add device PNP0C0F:1d
[    3.010027] PM: Adding info for acpi:PNP0C0F:1d
[    3.014606] device: 'PNP0C0F:1e': device_add
[    3.020018] bus: 'acpi': add device PNP0C0F:1e
[    3.024480] PM: Adding info for acpi:PNP0C0F:1e
[    3.030562] device: 'PNP0C0F:1f': device_add
[    3.034852] bus: 'acpi': add device PNP0C0F:1f
[    3.040029] PM: Adding info for acpi:PNP0C0F:1f
[    3.044606] device: 'PNP0C02:01': device_add
[    3.050017] bus: 'acpi': add device PNP0C02:01
[    3.054488] PM: Adding info for acpi:PNP0C02:01
[    3.060181] device: 'PNP0000:00': device_add
[    3.064456] bus: 'acpi': add device PNP0000:00
[    3.068918] PM: Adding info for acpi:PNP0000:00
[    3.070174] device: 'PNP0200:00': device_add
[    3.074446] bus: 'acpi': add device PNP0200:00
[    3.080027] PM: Adding info for acpi:PNP0200:00
[    3.084606] device: 'PNP0100:00': device_add
[    3.090027] bus: 'acpi': add device PNP0100:00
[    3.094489] PM: Adding info for acpi:PNP0100:00
[    3.100168] device: 'PNP0B00:00': device_add
[    3.104448] bus: 'acpi': add device PNP0B00:00
[    3.110027] PM: Adding info for acpi:PNP0B00:00
[    3.114605] device: 'PNP0800:00': device_add
[    3.114605] bus: 'acpi': add device PNP0800:00
[    3.120048] PM: Adding info for acpi:PNP0800:00
[    3.124626] device: 'PNP0C04:00': device_add
[    3.130018] bus: 'acpi': add device PNP0C04:00
[    3.134481] PM: Adding info for acpi:PNP0C04:00
[    3.141236] device: 'PNP0700:00': device_add
[    3.145514] bus: 'acpi': add device PNP0700:00
[    3.150028] PM: Adding info for acpi:PNP0700:00
[    3.154607] device: 'PNP0501:00': device_add
[    3.160018] bus: 'acpi': add device PNP0501:00
[    3.164489] PM: Adding info for acpi:PNP0501:00
[    3.173104] device: 'PNP0401:00': device_add
[    3.177385] bus: 'acpi': add device PNP0401:00
[    3.180031] PM: Adding info for acpi:PNP0401:00
[    3.184608] device: 'PNP0F13:00': device_add
[    3.190017] bus: 'acpi': add device PNP0F13:00
[    3.194493] PM: Adding info for acpi:PNP0F13:00
[    3.200561] device: 'PNP0303:00': device_add
[    3.204839] bus: 'acpi': add device PNP0303:00
[    3.210028] PM: Adding info for acpi:PNP0303:00
[    3.214606] device: 'PNPB006:00': device_add
[    3.220017] bus: 'acpi': add device PNPB006:00
[    3.224482] PM: Adding info for acpi:PNPB006:00
[    3.231310] device: 'PNPB02F:00': device_add
[    3.235590] bus: 'acpi': add device PNPB02F:00
[    3.240038] PM: Adding info for acpi:PNPB02F:00
[    3.244616] device: 'PNP0C02:02': device_add
[    3.250018] bus: 'acpi': add device PNP0C02:02
[    3.254481] PM: Adding info for acpi:PNP0C02:02
[    3.260244] device: 'PNP0C01:00': device_add
[    3.264518] bus: 'acpi': add device PNP0C01:00
[    3.268981] PM: Adding info for acpi:PNP0C01:00
[    3.270122] device: 'LNXTHERM:00': device_add
[    3.274499] bus: 'acpi': add device LNXTHERM:00
[    3.280027] PM: Adding info for acpi:LNXTHERM:00
[    3.284694] device: 'PNP0C0B:00': device_add
[    3.290015] bus: 'acpi': add device PNP0C0B:00
[    3.294482] PM: Adding info for acpi:PNP0C0B:00
[    3.300123] device: 'LNXTHERM:01': device_add
[    3.304483] bus: 'acpi': add device LNXTHERM:01
[    3.310042] PM: Adding info for acpi:LNXTHERM:01
[    3.314710] bus: 'acpi': add driver ec
[    3.320134] bus: 'acpi': add driver power
[    3.324155] initcall acpi_init+0x0/0x149 returned 0 after 1474609 usecs
[    3.330007] calling  dock_init+0x0/0xb4 @ 1
[    3.335077] ACPI: No dock devices found.
[    3.340005] initcall dock_init+0x0/0xb4 returned 0 after 9765 usecs
[    3.346260] calling  acpi_pci_root_init+0x0/0x4f @ 1
[    3.350004] bus: 'acpi': add driver pci_root
[    3.354282] bus: 'acpi': driver_probe_device: matched device PNP0A08:00 with driver pci_root
[    3.360004] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A08:00
[    3.370423] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    3.375362] device: 'pci0000:00': device_add
[    3.380053] PM: Adding info for No Bus:pci0000:00
[    3.384756] device: '0000:00': device_add
[    3.390037] PM: Adding info for No Bus:0000:00
[    3.394533] HPET not enabled in BIOS. You might try hpet=force boot option
[    3.400063] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    3.405821] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    3.410009] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    3.415773] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    3.420007] pci 0000:00:01.1: PME# disabled
[    3.430097] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    3.436832] pci 0000:00:02.0: supports D1 D2
[    3.440010] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.446617] pci 0000:00:02.0: PME# disabled
[    3.450069] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    3.456816] pci 0000:00:02.1: supports D1 D2
[    3.460004] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    3.466610] pci 0000:00:02.1: PME# disabled
[    3.470082] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    3.475823] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    3.480011] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    3.490041] pci 0000:00:04.0: supports D1 D2
[    3.494380] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    3.500145] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    3.506845] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    3.510046] pci 0000:00:0a.0: supports D1 D2
[    3.514311] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.520008] pci 0000:00:0a.0: PME# disabled
[    3.530017] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.536626] pci 0000:00:0b.0: PME# disabled
[    3.540161] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.546763] pci 0000:00:0c.0: PME# disabled
[    3.550110] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.556721] pci 0000:00:0d.0: PME# disabled
[    3.560111] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.566713] pci 0000:00:0e.0: PME# disabled
[    3.570484] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    3.576233] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    3.580056] pci 0000:05:07.0: supports D1 D2
[    3.590004] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    3.595743] pci 0000:05:07.0: PME# disabled
[    3.600080] pci 0000:00:09.0: transparent bridge
[    3.604696] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    3.610006] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    3.617111] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    3.620010] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    3.630010] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    3.636726] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    3.640035] pci 0000:01:00.0: supports D1 D2
[    3.644367] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    3.650065] pci 0000:01:00.1: supports D1 D2
[    3.654450] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.660161] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    3.670006] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    3.680010] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    3.687175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    3.692632] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    3.702062] device: '0000:00:00.0': device_add
[    3.726870] bus: 'pci': add device 0000:00:00.0
[    3.730090] PM: Adding info for pci:0000:00:00.0
[    3.734772] device: '0000:00:01.0': device_add
[    3.756866] bus: 'pci': add device 0000:00:01.0
[    3.760086] PM: Adding info for pci:0000:00:01.0
[    3.764759] device: '0000:00:01.1': device_add
[    3.786740] bus: 'pci': add device 0000:00:01.1
[    3.790086] PM: Adding info for pci:0000:00:01.1
[    3.794756] device: '0000:00:02.0': device_add
[    3.816507] bus: 'pci': add device 0000:00:02.0
[    3.820086] PM: Adding info for pci:0000:00:02.0
[    3.824759] device: '0000:00:02.1': device_add
[    3.846173] bus: 'pci': add device 0000:00:02.1
[    3.850086] PM: Adding info for pci:0000:00:02.1
[    3.854758] device: '0000:00:04.0': device_add
[    3.877862] bus: 'pci': add device 0000:00:04.0
[    3.880096] PM: Adding info for pci:0000:00:04.0
[    3.884766] device: '0000:00:06.0': device_add
[    3.909444] bus: 'pci': add device 0000:00:06.0
[    3.910086] PM: Adding info for pci:0000:00:06.0
[    3.914758] device: '0000:00:09.0': device_add
[    3.940927] bus: 'pci': add device 0000:00:09.0
[    3.945531] PM: Adding info for pci:0000:00:09.0
[    3.950062] device: '0000:00:0a.0': device_add
[    3.972303] bus: 'pci': add device 0000:00:0a.0
[    3.976912] PM: Adding info for pci:0000:00:0a.0
[    3.980061] device: '0000:00:0b.0': device_add
[    4.003580] bus: 'pci': add device 0000:00:0b.0
[    4.008188] PM: Adding info for pci:0000:00:0b.0
[    4.010062] device: '0000:00:0c.0': device_add
[    4.034754] bus: 'pci': add device 0000:00:0c.0
[    4.039351] PM: Adding info for pci:0000:00:0c.0
[    4.040060] device: '0000:00:0d.0': device_add
[    4.065829] bus: 'pci': add device 0000:00:0d.0
[    4.070077] PM: Adding info for pci:0000:00:0d.0
[    4.074746] device: '0000:00:0e.0': device_add
[    4.096812] bus: 'pci': add device 0000:00:0e.0
[    4.100076] PM: Adding info for pci:0000:00:0e.0
[    4.104748] device: '0000:00:18.0': device_add
[    4.127658] bus: 'pci': add device 0000:00:18.0
[    4.130135] PM: Adding info for pci:0000:00:18.0
[    4.134801] device: '0000:00:18.1': device_add
[    4.158466] bus: 'pci': add device 0000:00:18.1
[    4.160120] PM: Adding info for pci:0000:00:18.1
[    4.164793] device: '0000:00:18.2': device_add
[    4.189178] bus: 'pci': add device 0000:00:18.2
[    4.190087] PM: Adding info for pci:0000:00:18.2
[    4.194757] device: '0000:00:18.3': device_add
[    4.219784] bus: 'pci': add device 0000:00:18.3
[    4.220097] PM: Adding info for pci:0000:00:18.3
[    4.224765] device: '0000:05:07.0': device_add
[    4.230022] bus: 'pci': add device 0000:05:07.0
[    4.234625] PM: Adding info for pci:0000:05:07.0
[    4.240061] device: '0000:05': device_add
[    4.244065] PM: Adding info for No Bus:0000:05
[    4.250060] device: '0000:04': device_add
[    4.254079] PM: Adding info for No Bus:0000:04
[    4.260059] device: '0000:03': device_add
[    4.264081] PM: Adding info for No Bus:0000:03
[    4.268577] device: '0000:02': device_add
[    4.270040] PM: Adding info for No Bus:0000:02
[    4.274536] device: '0000:01:00.0': device_add
[    4.280021] bus: 'pci': add device 0000:01:00.0
[    4.284625] PM: Adding info for pci:0000:01:00.0
[    4.290060] device: '0000:01:00.1': device_add
[    4.294479] bus: 'pci': add device 0000:01:00.1
[    4.300086] PM: Adding info for pci:0000:01:00.1
[    4.304756] device: '0000:01': device_add
[    4.304756] PM: Adding info for No Bus:0000:01
[    4.310137] driver: 'PNP0A08:00': driver_bound: bound to device 'pci_root'
[    4.320006] bus: 'acpi': really_probe: bound device PNP0A08:00 to driver pci_root
[    4.327621] initcall acpi_pci_root_init+0x0/0x4f returned 0 after 947265 usecs
[    4.330006] calling  acpi_pci_link_init+0x0/0x6a @ 1
[    4.340006] bus: 'acpi': add driver pci_link
[    4.344300] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    4.350004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    4.360528] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.370321] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    4.377187] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    4.380008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    4.390004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    4.400406] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    4.407778] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    4.410005] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    4.420008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    4.430004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    4.440404] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    4.447772] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    4.450005] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    4.460007] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    4.470004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    4.478205] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.484019] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    4.490005] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    4.500008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    4.510004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    4.518201] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.524011] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    4.530005] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    4.540007] bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
[    4.548434] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
[    4.550443] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.564015] driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
[    4.570005] bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
[    4.580007] bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
[    4.588426] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
[    4.590404] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.604017] driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
[    4.610005] bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
[    4.620007] bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
[    4.628435] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
[    4.630416] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    4.642857] driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
[    4.650005] bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
[    4.657477] bus: 'acpi': driver_probe_device: matched device PNP0C0F:08 with driver pci_link
[    4.660004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:08
[    4.670415] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    4.682856] driver: 'PNP0C0F:08': driver_bound: bound to device 'pci_link'
[    4.689723] bus: 'acpi': really_probe: bound device PNP0C0F:08 to driver pci_link
[    4.690008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:09 with driver pci_link
[    4.700004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:09
[    4.710402] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.722510] driver: 'PNP0C0F:09': driver_bound: bound to device 'pci_link'
[    4.729377] bus: 'acpi': really_probe: bound device PNP0C0F:09 to driver pci_link
[    4.730008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0a with driver pci_link
[    4.740005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0a
[    4.750418] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.761957] driver: 'PNP0C0F:0a': driver_bound: bound to device 'pci_link'
[    4.768825] bus: 'acpi': really_probe: bound device PNP0C0F:0a to driver pci_link
[    4.770008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0b with driver pci_link
[    4.780004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0b
[    4.790408] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.801681] driver: 'PNP0C0F:0b': driver_bound: bound to device 'pci_link'
[    4.808548] bus: 'acpi': really_probe: bound device PNP0C0F:0b to driver pci_link
[    4.810008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0c with driver pci_link
[    4.820004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0c
[    4.830407] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.841337] driver: 'PNP0C0F:0c': driver_bound: bound to device 'pci_link'
[    4.848198] bus: 'acpi': really_probe: bound device PNP0C0F:0c to driver pci_link
[    4.850008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0d with driver pci_link
[    4.860004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0d
[    4.870417] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.880367] driver: 'PNP0C0F:0d': driver_bound: bound to device 'pci_link'
[    4.887229] bus: 'acpi': really_probe: bound device PNP0C0F:0d to driver pci_link
[    4.890008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0e with driver pci_link
[    4.900004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0e
[    4.910405] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.920367] driver: 'PNP0C0F:0e': driver_bound: bound to device 'pci_link'
[    4.927230] bus: 'acpi': really_probe: bound device PNP0C0F:0e to driver pci_link
[    4.930008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:0f with driver pci_link
[    4.940004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0f
[    4.950405] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    4.960136] driver: 'PNP0C0F:0f': driver_bound: bound to device 'pci_link'
[    4.967003] bus: 'acpi': really_probe: bound device PNP0C0F:0f to driver pci_link
[    4.970008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:10 with driver pci_link
[    4.980004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:10
[    4.990606] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    4.997082] driver: 'PNP0C0F:10': driver_bound: bound to device 'pci_link'
[    5.000009] bus: 'acpi': really_probe: bound device PNP0C0F:10 to driver pci_link
[    5.010008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:11 with driver pci_link
[    5.020004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:11
[    5.028414] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    5.030985] driver: 'PNP0C0F:11': driver_bound: bound to device 'pci_link'
[    5.040129] bus: 'acpi': really_probe: bound device PNP0C0F:11 to driver pci_link
[    5.047604] bus: 'acpi': driver_probe_device: matched device PNP0C0F:12 with driver pci_link
[    5.050004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:12
[    5.060600] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    5.070983] driver: 'PNP0C0F:12': driver_bound: bound to device 'pci_link'
[    5.077844] bus: 'acpi': really_probe: bound device PNP0C0F:12 to driver pci_link
[    5.080010] bus: 'acpi': driver_probe_device: matched device PNP0C0F:13 with driver pci_link
[    5.090004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:13
[    5.100597] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    5.107072] driver: 'PNP0C0F:13': driver_bound: bound to device 'pci_link'
[    5.110005] bus: 'acpi': really_probe: bound device PNP0C0F:13 to driver pci_link
[    5.120009] bus: 'acpi': driver_probe_device: matched device PNP0C0F:14 with driver pci_link
[    5.130004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:14
[    5.140049] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    5.146333] driver: 'PNP0C0F:14': driver_bound: bound to device 'pci_link'
[    5.150005] bus: 'acpi': really_probe: bound device PNP0C0F:14 to driver pci_link
[    5.160009] bus: 'acpi': driver_probe_device: matched device PNP0C0F:15 with driver pci_link
[    5.168434] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:15
[    5.170662] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    5.182787] driver: 'PNP0C0F:15': driver_bound: bound to device 'pci_link'
[    5.190005] bus: 'acpi': really_probe: bound device PNP0C0F:15 to driver pci_link
[    5.197483] bus: 'acpi': driver_probe_device: matched device PNP0C0F:16 with driver pci_link
[    5.200005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:16
[    5.210671] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    5.222786] driver: 'PNP0C0F:16': driver_bound: bound to device 'pci_link'
[    5.230005] bus: 'acpi': really_probe: bound device PNP0C0F:16 to driver pci_link
[    5.237475] bus: 'acpi': driver_probe_device: matched device PNP0C0F:17 with driver pci_link
[    5.240005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:17
[    5.250655] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    5.260987] driver: 'PNP0C0F:17': driver_bound: bound to device 'pci_link'
[    5.267854] bus: 'acpi': really_probe: bound device PNP0C0F:17 to driver pci_link
[    5.270009] bus: 'acpi': driver_probe_device: matched device PNP0C0F:18 with driver pci_link
[    5.280005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:18
[    5.290655] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    5.296984] driver: 'PNP0C0F:18': driver_bound: bound to device 'pci_link'
[    5.300005] bus: 'acpi': really_probe: bound device PNP0C0F:18 to driver pci_link
[    5.310012] bus: 'acpi': driver_probe_device: matched device PNP0C0F:19 with driver pci_link
[    5.320005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:19
[    5.330030] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    5.337330] driver: 'PNP0C0F:19': driver_bound: bound to device 'pci_link'
[    5.340005] bus: 'acpi': really_probe: bound device PNP0C0F:19 to driver pci_link
[    5.350008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1a with driver pci_link
[    5.360005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1a
[    5.368480] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    5.372785] driver: 'PNP0C0F:1a': driver_bound: bound to device 'pci_link'
[    5.380005] bus: 'acpi': really_probe: bound device PNP0C0F:1a to driver pci_link
[    5.390008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1b with driver pci_link
[    5.398433] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1b
[    5.400652] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    5.412784] driver: 'PNP0C0F:1b': driver_bound: bound to device 'pci_link'
[    5.420005] bus: 'acpi': really_probe: bound device PNP0C0F:1b to driver pci_link
[    5.427475] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1c with driver pci_link
[    5.430004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1c
[    5.440652] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    5.452824] driver: 'PNP0C0F:1c': driver_bound: bound to device 'pci_link'
[    5.459689] bus: 'acpi': really_probe: bound device PNP0C0F:1c to driver pci_link
[    5.460008] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1d with driver pci_link
[    5.470004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1d
[    5.480651] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    5.491714] driver: 'PNP0C0F:1d': driver_bound: bound to device 'pci_link'
[    5.498581] bus: 'acpi': really_probe: bound device PNP0C0F:1d to driver pci_link
[    5.500009] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1e with driver pci_link
[    5.510004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1e
[    5.520652] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    5.530363] driver: 'PNP0C0F:1e': driver_bound: bound to device 'pci_link'
[    5.537230] bus: 'acpi': really_probe: bound device PNP0C0F:1e to driver pci_link
[    5.540009] bus: 'acpi': driver_probe_device: matched device PNP0C0F:1f with driver pci_link
[    5.550004] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1f
[    5.560650] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    5.567954] driver: 'PNP0C0F:1f': driver_bound: bound to device 'pci_link'
[    5.570006] bus: 'acpi': really_probe: bound device PNP0C0F:1f to driver pci_link
[    5.580097] initcall acpi_pci_link_init+0x0/0x6a returned 0 after 1210937 usecs
[    5.590006] calling  pnp_init+0x0/0x39 @ 1
[    5.594156] bus: 'pnp': registered
[    5.594156] initcall pnp_init+0x0/0x39 returned 0 after 0 usecs
[    5.600006] calling  setup_shutdown_event+0x0/0x3b @ 1
[    5.605144] initcall setup_shutdown_event+0x0/0x3b returned 0 after 0 usecs
[    5.610005] calling  balloon_init+0x0/0x170 @ 1
[    5.620005] initcall balloon_init+0x0/0x170 returned -19 after 0 usecs
[    5.626521] calling  regulator_fixed_voltage_init+0x0/0x39 @ 1
[    5.630007] bus: 'platform': add driver reg-fixed-voltage
[    5.635466] initcall regulator_fixed_voltage_init+0x0/0x39 returned 0 after 0 usecs
[    5.640006] calling  misc_init+0x0/0xd6 @ 1
[    5.650020] device class 'misc': registering
[    5.654350] initcall misc_init+0x0/0xd6 returned 0 after 0 usecs
[    5.660008] calling  cn_init+0x0/0x115 @ 1
[    5.664204] initcall cn_init+0x0/0x115 returned 0 after 0 usecs
[    5.670006] calling  tifm_init+0x0/0xab @ 1
[    5.674276] bus: 'tifm': registered
[    5.674276] device class 'tifm_adapter': registering
[    5.680068] initcall tifm_init+0x0/0xab returned 0 after 9765 usecs
[    5.690006] calling  wm8400_module_init+0x0/0x59 @ 1
[    5.694970] bus: 'i2c': add driver WM8400
[    5.700074] i2c-core: driver [WM8400] registered
[    5.704633] initcall wm8400_module_init+0x0/0x59 returned 0 after 9765 usecs
[    5.710006] calling  da903x_init+0x0/0x3b @ 1
[    5.714354] bus: 'i2c': add driver da903x
[    5.720073] i2c-core: driver [da903x] registered
[    5.724635] initcall da903x_init+0x0/0x3b returned 0 after 9765 usecs
[    5.730006] calling  pcf50633_init+0x0/0x3b @ 1
[    5.734529] bus: 'i2c': add driver pcf50633
[    5.740073] i2c-core: driver [pcf50633] registered
[    5.744806] initcall pcf50633_init+0x0/0x3b returned 0 after 9765 usecs
[    5.750006] calling  ab3100_i2c_init+0x0/0x3b @ 1
[    5.754709] bus: 'i2c': add driver ab3100
[    5.760073] i2c-core: driver [ab3100] registered
[    5.764633] initcall ab3100_i2c_init+0x0/0x3b returned 0 after 9765 usecs
[    5.770006] calling  init_scsi+0x0/0xb7 @ 1
[    5.774687] device class 'scsi_host': registering
[    5.780139] bus: 'scsi': registered
[    5.783551] device class 'scsi_device': registering
[    5.790113] SCSI subsystem initialized
[    5.793864] initcall init_scsi+0x0/0xb7 returned 0 after 19531 usecs
[    5.800006] calling  ata_init+0x0/0xb4 @ 1
[    5.804204] libata version 3.00 loaded.
[    5.804204] initcall ata_init+0x0/0xb4 returned 0 after 0 usecs
[    5.810006] calling  phy_init+0x0/0x57 @ 1
[    5.814095] device class 'mdio_bus': registering
[    5.820137] bus: 'mdio_bus': registered
[    5.823881] bus: 'mdio_bus': add driver Generic PHY
[    5.830078] initcall phy_init+0x0/0x57 returned 0 after 19531 usecs
[    5.836286] calling  init_pcmcia_cs+0x0/0x5d @ 1
[    5.840004] device class 'pcmcia_socket': registering
[    5.845110] initcall init_pcmcia_cs+0x0/0x5d returned 0 after 0 usecs
[    5.850006] calling  usb_init+0x0/0x1d8 @ 1
[    5.860178] bus: 'usb': registered
[    5.863451] bus: 'usb': add driver usbfs
[    5.867479] usbcore: registered new interface driver usbfs
[    5.870016] device class 'usb_device': registering
[    5.874867] bus: 'usb': add driver hub
[    5.880087] usbcore: registered new interface driver hub
[    5.885390] bus: 'usb': add driver usb
[    5.890087] usbcore: registered new device driver usb
[    5.895068] initcall usb_init+0x0/0x1d8 returned 0 after 29296 usecs
[    5.900006] calling  serio_init+0x0/0xb2 @ 1
[    5.904335] bus: 'serio': registered
[    5.910066] initcall serio_init+0x0/0xb2 returned 0 after 9765 usecs
[    5.916355] calling  gameport_init+0x0/0xb2 @ 1
[    5.920065] bus: 'gameport': registered
[    5.923949] initcall gameport_init+0x0/0xb2 returned 0 after 0 usecs
[    5.930006] calling  input_init+0x0/0x15d @ 1
[    5.934362] device class 'input': registering
[    5.940070] initcall input_init+0x0/0x15d returned 0 after 9765 usecs
[    5.946483] calling  hwmon_init+0x0/0x6e @ 1
[    5.950027] device class 'hwmon': registering
[    5.954443] initcall hwmon_init+0x0/0x6e returned 0 after 0 usecs
[    5.960006] calling  thermal_init+0x0/0x7e @ 1
[    5.964441] device class 'thermal': registering
[    5.970067] initcall thermal_init+0x0/0x7e returned 0 after 9765 usecs
[    5.976542] calling  mmc_init+0x0/0x9c @ 1
[    5.980141] bus: 'mmc': registered
[    5.983444] device class 'mmc_host': registering
[    5.990140] bus: 'sdio': registered
[    5.993541] initcall mmc_init+0x0/0x9c returned 0 after 9765 usecs
[    6.000006] calling  leds_init+0x0/0x67 @ 1
[    6.004190] device class 'leds': registering
[    6.010086] initcall leds_init+0x0/0x67 returned 0 after 9765 usecs
[    6.016278] calling  pci_subsys_init+0x0/0x13d @ 1
[    6.020005] PCI: Using ACPI for IRQ routing
[    6.024481] initcall pci_subsys_init+0x0/0x13d returned 0 after 0 usecs
[    6.030005] calling  proto_init+0x0/0x39 @ 1
[    6.034283] initcall proto_init+0x0/0x39 returned 0 after 0 usecs
[    6.040012] calling  net_dev_init+0x0/0x200 @ 1
[    6.044574] device class 'net': registering
[    6.050098] device: 'lo': device_add
[    6.054009] PM: Adding info for No Bus:lo
[    6.060203] initcall net_dev_init+0x0/0x200 returned 0 after 19531 usecs
[    6.066897] calling  neigh_init+0x0/0x98 @ 1
[    6.070006] initcall neigh_init+0x0/0x98 returned 0 after 0 usecs
[    6.076095] calling  fib_rules_init+0x0/0xcc @ 1
[    6.080008] initcall fib_rules_init+0x0/0xcc returned 0 after 0 usecs
[    6.086443] calling  pktsched_init+0x0/0xeb @ 1
[    6.090036] initcall pktsched_init+0x0/0xeb returned 0 after 0 usecs
[    6.096383] calling  tc_filter_init+0x0/0x73 @ 1
[    6.100008] initcall tc_filter_init+0x0/0x73 returned 0 after 0 usecs
[    6.110005] calling  tc_action_init+0x0/0x73 @ 1
[    6.114616] initcall tc_action_init+0x0/0x73 returned 0 after 0 usecs
[    6.120005] calling  genl_init+0x0/0x100 @ 1
[    6.150090] initcall genl_init+0x0/0x100 returned 0 after 29296 usecs
[    6.156523] calling  cipso_v4_init+0x0/0xae @ 1
[    6.160035] initcall cipso_v4_init+0x0/0xae returned 0 after 0 usecs
[    6.166382] calling  wanrouter_init+0x0/0x79 @ 1
[    6.170004] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    6.177336] initcall wanrouter_init+0x0/0x79 returned 0 after 0 usecs
[    6.180005] calling  irda_init+0x0/0xb8 @ 1
[    6.190086] NET: Registered protocol family 23
[    6.194656] initcall irda_init+0x0/0xb8 returned 0 after 0 usecs
[    6.200008] calling  atm_init+0x0/0xdc @ 1
[    6.204103] NET: Registered protocol family 8
[    6.208458] NET: Registered protocol family 20
[    6.210056] device class 'atm': registering
[    6.214301] initcall atm_init+0x0/0xdc returned 0 after 9765 usecs
[    6.220006] calling  wireless_nlevent_init+0x0/0x69 @ 1
[    6.225224] initcall wireless_nlevent_init+0x0/0x69 returned 0 after 0 usecs
[    6.230006] calling  cfg80211_init+0x0/0x9a @ 1
[    6.240004] device class 'ieee80211': registering
[    6.360084] Registering platform device 'regulatory.0'. Parent at platform
[    6.366955] device: 'regulatory.0': device_add
[    6.370017] bus: 'platform': add device regulatory.0
[    6.375013] PM: Adding info for platform:regulatory.0
[    6.380059] cfg80211: Using static regulatory domain info
[    6.385422] cfg80211: Regulatory domain: US
[    6.390004] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    6.397213] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    6.400004] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.410004] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.416779] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.420006] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.430004] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    6.436938] cfg80211: Calling CRDA for country: US
[    6.440188] initcall cfg80211_init+0x0/0x9a returned 0 after 195312 usecs
[    6.450006] calling  netlbl_init+0x0/0xa8 @ 1
[    6.454355] NetLabel: Initializing
[    6.457749] NetLabel:  domain hash size = 128
[    6.460003] NetLabel:  protocols = UNLABELED CIPSOv4
[    6.465185] NetLabel:  unlabeled traffic allowed by default
[    6.470006] initcall netlbl_init+0x0/0xa8 returned 0 after 19531 usecs
[    6.480007] calling  sysctl_init+0x0/0x6f @ 1
[    6.484366] initcall sysctl_init+0x0/0x6f returned 0 after 0 usecs
[    6.490005] calling  xen_mc_debugfs+0x0/0x13f @ 1
[    6.494815] initcall xen_mc_debugfs+0x0/0x13f returned 0 after 0 usecs
[    6.500005] calling  xen_mmu_debugfs+0x0/0x2e5 @ 1
[    6.505086] initcall xen_mmu_debugfs+0x0/0x2e5 returned 0 after 0 usecs
[    6.510005] calling  xen_spinlock_debugfs+0x0/0x275 @ 1
[    6.515441] initcall xen_spinlock_debugfs+0x0/0x275 returned 0 after 0 usecs
[    6.520007] calling  pci_iommu_init+0x0/0x59 @ 1
[    6.595964] DMA-API: preallocated 32768 debug entries
[    6.600009] DMA-API: debugging enabled by kernel config
[    6.605440] bus: 'pci': add driver agpgart-amd64
[    6.610261] PCI-DMA: Disabling AGP.
[    6.613845] Registering sysdev class 'gart'
[    6.618084] Registering sys device of class 'gart'
[    6.620017] Registering sys device 'gart0'
[    6.624164] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    6.630004] PCI-DMA: using GART IOMMU.
[    6.633754] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    6.643222] initcall pci_iommu_init+0x0/0x59 returned 0 after 107421 usecs
[    6.650014] calling  print_all_ICs+0x0/0xaa @ 1
[    6.654535] 
[    6.654536] printing PIC contents
[    6.660009] ... PIC  IMR: ffff
[    6.663065] ... PIC  IRR: 0829
[    6.670003] ... PIC  ISR: 0000
[    6.673058] ... PIC ELCR: 0828
[    6.676116] printing local APIC contents on CPU#0/0:
[    6.680000] ... APIC ID:      00000000 (0)
[    6.680000] ... APIC VERSION: 00040010
[    6.680000] ... APIC TASKPRI: 00000000 (00)
[    6.680000] ... APIC ARBPRI: 000000e0 (e0)
[    6.680000] ... APIC PROCPRI: 00000000
[    6.680000] ... APIC LDR: 01000000
[    6.680000] ... APIC DFR: ffffffff
[    6.680000] ... APIC SPIV: 000001ff
[    6.680000] ... APIC ISR field:
[    6.680000] 0000000000000000000000000000000000000000000000000000000000000000
[    6.680000] ... APIC TMR field:
[    6.680000] 0000000000000000000000000000000000000000000000000000000000000000
[    6.680000] ... APIC IRR field:
[    6.680000] 0000000000000000000000000000000000000000000000000000000000008000
[    6.680000] ... APIC ESR: 00000000
[    6.680000] ... APIC ICR: 000008fb
[    6.680000] ... APIC ICR2: 02000000
[    6.680000] ... APIC LVTT: 000200ef
[    6.680000] ... APIC LVTPC: 00010000
[    6.680000] ... APIC LVT0: 00010700
[    6.680000] ... APIC LVT1: 00000400
[    6.680000] ... APIC LVTERR: 000000fe
[    6.680000] ... APIC TMICT: 0001eace
[    6.680000] ... APIC TMCCT: 00012b20
[    6.680000] ... APIC TDCR: 00000003
[    6.680000] 
[    6.672390] printing local APIC contents on CPU#1/1:
[    6.677349] ... APIC ID:      01000000 (1)
[    6.680000] ... APIC VERSION: 00040010
[    6.680000] ... APIC TASKPRI: 00000000 (00)
[    6.680000] ... APIC ARBPRI: 000000e0 (e0)
[    6.680000] ... APIC PROCPRI: 00000000
[    6.680000] ... APIC LDR: 02000000
[    6.680000] ... APIC DFR: ffffffff
[    6.680000] ... APIC SPIV: 000001ff
[    6.680000] ... APIC ISR field:
[    6.680000] 0000000000000000000000000000000000000000000000000000000000000000
[    6.680000] ... APIC TMR field:
[    6.680000] 0000000000000000000000000000000000000000000000000000000000000000
[    6.680000] ... APIC IRR field:
[    6.680000] 0000000000000000000000000000000000000000000000000000000000008000
[    6.680000] ... APIC ESR: 00000000
[    6.680000] ... APIC ICR: 000008fd
[    6.680000] ... APIC ICR2: 01000000
[    6.680000] ... APIC LVTT: 000200ef
[    6.680000] ... APIC LVTPC: 00010000
[    6.680000] ... APIC LVT0: 00010700
[    6.680000] ... APIC LVT1: 00010400
[    6.680000] ... APIC LVTERR: 000000fe
[    6.680000] ... APIC TMICT: 0001eace
[    6.680000] ... APIC TMCCT: 0001e9f5
[    6.680000] ... APIC TDCR: 00000003
[    6.680000] 
[    6.788643] number of MP IRQ sources: 16.
[    6.790003] number of IO-APIC #2 registers: 24.
[    6.794528] testing the IO APIC.......................
[    6.800007] 
[    6.801496] IO APIC #2......
[    6.804371] .... register #00: 00000000
[    6.810003] .......    : physical APIC id: 00
[    6.814354] .......    : Delivery Type: 0
[    6.818354] .......    : LTS          : 0
[    6.810004] Clocksource tsc unstable (delta = 109652348 ns)
[    6.820005] .... register #01: 00170011
[    6.830003] .......     : max redirection entries: 0017
[    6.835221] .......     : PRQ implemented: 0
[    6.840003] .......     : IO APIC version: 0011
[    6.844528] .... register #02: 00000000
[    6.850003] .......     : arbitration: 00
[    6.854008] .... IRQ redirection table:
[    6.857836]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    6.860007]  00 003 0    0    0   0   0    1    1    30
[    6.865241]  01 003 0    0    0   0   0    1    1    31
[    6.873232]  02 003 1    0    0   0   0    0    0    32
[    6.878479]  03 003 1    0    0   0   0    1    1    33
[    6.883239]  04 003 0    0    0   0   0    1    1    34
[    6.888479]  05 003 1    0    0   0   0    1    1    35
[    6.893230]  06 003 0    0    0   0   0    1    1    36
[    6.900007]  07 003 1    0    0   0   0    1    1    37
[    6.905241]  08 003 0    0    0   0   0    1    1    38
[    6.910005]  09 003 0    1    0   0   0    1    1    39
[    6.915242]  0a 003 0    0    0   0   0    1    1    3A
[    6.920005]  0b 003 1    0    0   0   0    1    1    3B
[    6.925248]  0c 003 0    0    0   0   0    1    1    3C
[    6.930005]  0d 003 0    0    0   0   0    1    1    3D
[    6.935240]  0e 003 0    0    0   0   0    1    1    3E
[    6.940007]  0f 003 0    0    0   0   0    1    1    3F
[    6.945241]  10 000 1    0    0   0   0    0    0    00
[    6.950005]  11 000 1    0    0   0   0    0    0    00
[    6.955241]  12 000 1    0    0   0   0    0    0    00
[    6.963230]  13 000 1    0    0   0   0    0    0    00
[    6.968470]  14 000 1    0    0   0   0    0    0    00
[    6.973230]  15 000 1    0    0   0   0    0    0    00
[    6.978468]  16 000 1    0    0   0   0    0    0    00
[    6.983231]  17 000 1    0    0   0   0    0    0    00
[    6.988469] IRQ to pin mappings:
[    6.990004] IRQ0 -> 0:0
[    6.992482] IRQ1 -> 0:1
[    6.994961] IRQ2 -> 0:2
[    7.000197] IRQ3 -> 0:3
[    7.002675] IRQ4 -> 0:4
[    7.005152] IRQ5 -> 0:5
[    7.007628] IRQ6 -> 0:6
[    7.010197] IRQ7 -> 0:7
[    7.012675] IRQ8 -> 0:8
[    7.015160] IRQ9 -> 0:9
[    7.017636] IRQ10 -> 0:10
[    7.020198] IRQ11 -> 0:11
[    7.022848] IRQ12 -> 0:12
[    7.025498] IRQ13 -> 0:13
[    7.028149] IRQ14 -> 0:14
[    7.030821] IRQ15 -> 0:15
[    7.033475] .................................... done.
[    7.038610] initcall print_all_ICs+0x0/0xaa returned 0 after 371093 usecs
[    7.040009] calling  hpet_late_init+0x0/0x114 @ 1
[    7.050005] initcall hpet_late_init+0x0/0x114 returned -19 after 0 usecs
[    7.056693] calling  clocksource_done_booting+0x0/0x3e @ 1
[    7.060005] Switching to clocksource jiffies
[    7.064270] initcall clocksource_done_booting+0x0/0x3e returned 0 after 0 usecs
[    7.070005] calling  init_pipe_fs+0x0/0x72 @ 1
[    7.074645] initcall init_pipe_fs+0x0/0x72 returned 0 after 0 usecs
[    7.080005] calling  eventpoll_init+0x0/0x102 @ 1
[    7.084752] initcall eventpoll_init+0x0/0x102 returned 0 after 0 usecs
[    7.090005] calling  anon_inode_init+0x0/0x150 @ 1
[    7.100157] initcall anon_inode_init+0x0/0x150 returned 0 after 0 usecs
[    7.106766] calling  blk_scsi_ioctl_init+0x0/0x2ad @ 1
[    7.110006] initcall blk_scsi_ioctl_init+0x0/0x2ad returned 0 after 0 usecs
[    7.116954] calling  acpi_event_init+0x0/0xa7 @ 1
[    7.150074] initcall acpi_event_init+0x0/0xa7 returned 0 after 29296 usecs
[    7.156935] calling  pnpacpi_init+0x0/0xb3 @ 1
[    7.160005] pnp: PnP ACPI init
[    7.163083] device: 'pnp0': device_add
[    7.166862] PM: Adding info for No Bus:pnp0
[    7.170009] ACPI: bus type pnp registered
[    7.174732] device: '00:00': device_add
[    7.180150] bus: 'pnp': add device 00:00
[    7.184100] PM: Adding info for pnp:00:00
[    7.188167] device: '00:01': device_add
[    7.190043] bus: 'pnp': add device 00:01
[    7.194007] PM: Adding info for pnp:00:01
[    7.206064] device: '00:02': device_add
[    7.210109] bus: 'pnp': add device 00:02
[    7.214061] PM: Adding info for pnp:00:02
[    7.220018] device: '00:03': device_add
[    7.223957] bus: 'pnp': add device 00:03
[    7.227914] PM: Adding info for pnp:00:03
[    7.230090] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    7.237404] device: '00:04': device_add
[    7.240111] bus: 'pnp': add device 00:04
[    7.244073] PM: Adding info for pnp:00:04
[    7.250096] device: '00:05': device_add
[    7.254034] bus: 'pnp': add device 00:05
[    7.257994] PM: Adding info for pnp:00:05
[    7.260088] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    7.270015] device: '00:06': device_add
[    7.273972] bus: 'pnp': add device 00:06
[    7.277926] PM: Adding info for pnp:00:06
[    7.281371] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    7.290057] device: '00:07': device_add
[    7.294015] bus: 'pnp': add device 00:07
[    7.300047] PM: Adding info for pnp:00:07
[    7.304105] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    7.310085] device: '00:08': device_add
[    7.314058] bus: 'pnp': add device 00:08
[    7.320035] PM: Adding info for pnp:00:08
[    7.324097] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    7.330085] device: '00:09': device_add
[    7.340133] bus: 'pnp': add device 00:09
[    7.344081] PM: Adding info for pnp:00:09
[    7.348137] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    7.350018] device: '00:0a': device_add
[    7.360132] bus: 'pnp': add device 00:0a
[    7.364081] PM: Adding info for pnp:00:0a
[    7.368140] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    7.370018] device: '00:0b': device_add
[    7.380136] bus: 'pnp': add device 00:0b
[    7.384089] PM: Adding info for pnp:00:0b
[    7.390724] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    7.398251] device: '00:0c': device_add
[    7.400141] bus: 'pnp': add device 00:0c
[    7.404099] PM: Adding info for pnp:00:0c
[    7.411547] device: '00:0d': device_add
[    7.415520] bus: 'pnp': add device 00:0d
[    7.419466] PM: Adding info for pnp:00:0d
[    7.420321] device: '00:0e': device_add
[    7.424270] bus: 'pnp': add device 00:0e
[    7.430057] PM: Adding info for pnp:00:0e
[    7.434123] device: '00:0f': device_add
[    7.440135] bus: 'pnp': add device 00:0f
[    7.444080] PM: Adding info for pnp:00:0f
[    7.448139] pnp: PnP ACPI: found 16 devices
[    7.450006] ACPI: ACPI bus type pnp unregistered
[    7.454617] initcall pnpacpi_init+0x0/0xb3 returned 0 after 283203 usecs
[    7.460006] calling  pnp_system_init+0x0/0x39 @ 1
[    7.470005] bus: 'pnp': add driver system
[    7.474023] bus: 'pnp': driver_probe_device: matched device 00:01 with driver system
[    7.480007] bus: 'pnp': really_probe: probing driver system with device 00:01
[    7.487145] system 00:01: ioport range 0x4000-0x407f has been reserved
[    7.490007] system 00:01: ioport range 0x4080-0x40ff has been reserved
[    7.500007] system 00:01: ioport range 0x4400-0x447f has been reserved
[    7.506531] system 00:01: ioport range 0x4480-0x44ff has been reserved
[    7.510007] system 00:01: ioport range 0x4800-0x487f has been reserved
[    7.520009] system 00:01: ioport range 0x4880-0x48ff has been reserved
[    7.526528] driver: '00:01': driver_bound: bound to device 'system'
[    7.530005] bus: 'pnp': really_probe: bound device 00:01 to driver system
[    7.540008] bus: 'pnp': driver_probe_device: matched device 00:02 with driver system
[    7.547742] bus: 'pnp': really_probe: probing driver system with device 00:02
[    7.550030] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    7.560009] system 00:02: ioport range 0x800-0x805 has been reserved
[    7.566358] system 00:02: ioport range 0x290-0x297 has been reserved
[    7.570004] driver: '00:02': driver_bound: bound to device 'system'
[    7.580004] bus: 'pnp': really_probe: bound device 00:02 to driver system
[    7.586792] bus: 'pnp': driver_probe_device: matched device 00:0e with driver system
[    7.590004] bus: 'pnp': really_probe: probing driver system with device 00:0e
[    7.600020] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    7.610004] driver: '00:0e': driver_bound: bound to device 'system'
[    7.616261] bus: 'pnp': really_probe: bound device 00:0e to driver system
[    7.620007] bus: 'pnp': driver_probe_device: matched device 00:0f with driver system
[    7.630004] bus: 'pnp': really_probe: probing driver system with device 00:0f
[    7.637143] system 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
[    7.640012] system 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
[    7.650010] system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
[    7.656966] system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
[    7.660010] system 00:0f: iomem range 0x3fff0000-0x3fffffff could not be reserved
[    7.670009] system 00:0f: iomem range 0xffff0000-0xffffffff has been reserved
[    7.680011] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    7.686621] system 00:0f: iomem range 0x100000-0x3ffeffff could not be reserved
[    7.690010] system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
[    7.700007] system 00:0f: iomem range 0xfee00000-0xfeefffff has been reserved
[    7.707138] system 00:0f: iomem range 0xfefff000-0xfeffffff has been reserved
[    7.710007] system 00:0f: iomem range 0xfff80000-0xfff80fff has been reserved
[    7.720018] system 00:0f: iomem range 0xfff90000-0xfffbffff has been reserved
[    7.730007] system 00:0f: iomem range 0xfffed000-0xfffeffff has been reserved
[    7.737135] driver: '00:0f': driver_bound: bound to device 'system'
[    7.740005] bus: 'pnp': really_probe: bound device 00:0f to driver system
[    7.750082] initcall pnp_system_init+0x0/0x39 returned 0 after 273437 usecs
[    7.756969] calling  chr_dev_init+0x0/0xca @ 1
[    7.760031] device class 'mem': registering
[    7.764276] device: 'mem': device_add
[    7.770036] PM: Adding info for No Bus:mem
[    7.774181] device: 'kmem': device_add
[    7.774181] PM: Adding info for No Bus:kmem
[    7.780059] device: 'null': device_add
[    7.783800] PM: Adding info for No Bus:null
[    7.790056] device: 'port': device_add
[    7.793810] PM: Adding info for No Bus:port
[    7.798041] device: 'zero': device_add
[    7.800035] PM: Adding info for No Bus:zero
[    7.804269] device: 'full': device_add
[    7.810033] PM: Adding info for No Bus:full
[    7.814267] device: 'random': device_add
[    7.814267] PM: Adding info for No Bus:random
[    7.820057] device: 'urandom': device_add
[    7.824066] PM: Adding info for No Bus:urandom
[    7.830058] device: 'kmsg': device_add
[    7.833817] PM: Adding info for No Bus:kmsg
[    7.840057] initcall chr_dev_init+0x0/0xca returned 0 after 78125 usecs
[    7.846628] calling  firmware_class_init+0x0/0x9f @ 1
[    7.850004] device class 'firmware': registering
[    7.854678] initcall firmware_class_init+0x0/0x9f returned 0 after 0 usecs
[    7.860007] calling  cpufreq_gov_performance_init+0x0/0x39 @ 1
[    7.870031] initcall cpufreq_gov_performance_init+0x0/0x39 returned 0 after 0 usecs
[    7.877674] calling  cpufreq_gov_dbs_init+0x0/0xd6 @ 1
[    7.880105] initcall cpufreq_gov_dbs_init+0x0/0xd6 returned 0 after 0 usecs
[    7.890006] calling  init_acpi_pm_clocksource+0x0/0x114 @ 1
[    7.900787] Switching to clocksource acpi_pm
[    7.905243] initcall init_acpi_pm_clocksource+0x0/0x114 returned 0 after 9942 usecs
[    7.905243] Switched to high resolution mode on CPU 1
[    7.912892] Switched to high resolution mode on CPU 0
[    7.917937] calling  pcibios_assign_resources+0x0/0x9a @ 1
[    7.923588] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    7.929502] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    7.934836] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    7.940942] pci 0000:00:09.0:   PREFETCH window: disabled
[    7.946336] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    7.952268] pci 0000:00:0b.0:   IO window: disabled
[    7.957143] pci 0000:00:0b.0:   MEM window: disabled
[    7.962123] pci 0000:00:0b.0:   PREFETCH window: disabled
[    7.967518] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    7.973448] pci 0000:00:0c.0:   IO window: disabled
[    7.978325] pci 0000:00:0c.0:   MEM window: disabled
[    7.983305] pci 0000:00:0c.0:   PREFETCH window: disabled
[    7.988697] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    7.994631] pci 0000:00:0d.0:   IO window: disabled
[    7.999506] pci 0000:00:0d.0:   MEM window: disabled
[    8.004491] pci 0000:00:0d.0:   PREFETCH window: disabled
[    8.009895] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    8.015831] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    8.021152] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    8.027238] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    8.034831] pci 0000:00:09.0: setting latency timer to 64
[    8.040243] pci 0000:00:0b.0: setting latency timer to 64
[    8.045644] pci 0000:00:0c.0: setting latency timer to 64
[    8.051063] pci 0000:00:0d.0: setting latency timer to 64
[    8.056459] pci 0000:00:0e.0: setting latency timer to 64
[    8.061870] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    8.067347] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    8.074236] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
[    8.079886] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
[    8.086255] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    8.091748] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    8.098615] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    8.104290] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
[    8.110649] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
[    8.117347] initcall pcibios_assign_resources+0x0/0x9a returned 0 after 189370 usecs
[    8.125099] calling  sysctl_core_init+0x0/0x5f @ 1
[    8.129922] initcall sysctl_core_init+0x0/0x5f returned 0 after 34 usecs
[    8.136635] calling  inet_init+0x0/0x1e8 @ 1
[    8.140974] NET: Registered protocol family 2
[    8.145626] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    8.154774] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    8.165647] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    8.179153] TCP: Hash tables configured (established 131072 bind 65536)
[    8.185845] TCP reno registered
[    8.189235] initcall inet_init+0x0/0x1e8 returned 0 after 47183 usecs
[    8.195698] calling  af_unix_init+0x0/0x7b @ 1
[    8.200172] NET: Registered protocol family 1
[    8.204544] initcall af_unix_init+0x0/0x7b returned 0 after 4289 usecs
[    8.211083] calling  default_rootfs+0x0/0x91 @ 1
[    8.215917] initcall default_rootfs+0x0/0x91 returned 0 after 215 usecs
[    8.222541] calling  i8259A_init_sysfs+0x0/0x49 @ 1
[    8.227413] Registering sysdev class 'i8259'
[    8.231968] Registering sys device of class 'i8259'
[    8.236848] Registering sys device 'i82590'
[    8.241300] initcall i8259A_init_sysfs+0x0/0x49 returned 0 after 13557 usecs
[    8.248339] calling  vsyscall_init+0x0/0x6c @ 1
[    8.252914] initcall vsyscall_init+0x0/0x6c returned 0 after 16 usecs
[    8.259347] calling  sbf_init+0x0/0x118 @ 1
[    8.263553] initcall sbf_init+0x0/0x118 returned 0 after 1 usecs
[    8.269549] calling  i8237A_init_sysfs+0x0/0x49 @ 1
[    8.274445] Registering sysdev class 'i8237'
[    8.278942] Registering sys device of class 'i8237'
[    8.283839] Registering sys device 'i82370'
[    8.288245] initcall i8237A_init_sysfs+0x0/0x49 returned 0 after 13475 usecs
[    8.295305] calling  add_rtc_cmos+0x0/0xea @ 1
[    8.299750] initcall add_rtc_cmos+0x0/0xea returned 0 after 4 usecs
[    8.306028] calling  cache_sysfs_init+0x0/0x82 @ 1
[    8.312951] initcall cache_sysfs_init+0x0/0x82 returned 0 after 2073 usecs
[    8.319814] calling  cpu_debug_init+0x0/0x11f @ 1
[    8.328711] cpu0(2) debug files 137
[    8.338550] cpu1(2) debug files 137
[    8.342079] initcall cpu_debug_init+0x0/0x11f returned 0 after 17122 usecs
[    8.348944] calling  mce_init_device+0x0/0x127 @ 1
[    8.353759] Registering sysdev class 'machinecheck'
[    8.358906] Registering sys device of class 'machinecheck'
[    8.364416] Registering sys device 'machinecheck0'
[    8.369475] Registering sys device of class 'machinecheck'
[    8.374975] Registering sys device 'machinecheck1'
[    8.380111] device: 'mcelog': device_add
[    8.384183] PM: Adding info for No Bus:mcelog
[    8.388967] initcall mce_init_device+0x0/0x127 returned 0 after 34386 usecs
[    8.395937] calling  thermal_throttle_init_device+0x0/0xf5 @ 1
[    8.401776] initcall thermal_throttle_init_device+0x0/0xf5 returned 0 after 1 usecs
[    8.409418] calling  ioapic_init_sysfs+0x0/0xd2 @ 1
[    8.414315] Registering sysdev class 'ioapic'
[    8.418897] Registering sys device of class 'ioapic'
[    8.423883] Registering sys device 'ioapic0'
[    8.428372] initcall ioapic_init_sysfs+0x0/0xd2 returned 0 after 13727 usecs
[    8.435428] calling  audit_classes_init+0x0/0xd6 @ 1
[    8.440433] initcall audit_classes_init+0x0/0xd6 returned 0 after 30 usecs
[    8.447303] calling  start_pageattr_test+0x0/0x67 @ 1
[    8.452495] initcall start_pageattr_test+0x0/0x67 returned 0 after 119 usecs
[    8.459540] calling  pt_dump_init+0x0/0x52 @ 1
[    8.464025] initcall pt_dump_init+0x0/0x52 returned 0 after 16 usecs
[    8.470390] calling  crypto_fpu_module_init+0x0/0x39 @ 1
[    8.475824] initcall crypto_fpu_module_init+0x0/0x39 returned 0 after 124 usecs
[    8.483145] calling  aes_init+0x0/0x39 @ 1
[    8.487604] initcall aes_init+0x0/0x39 returned 0 after 349 usecs
[    8.493703] calling  init+0x0/0x39 @ 1
[    8.497850] initcall init+0x0/0x39 returned 0 after 386 usecs
[    8.503610] calling  aesni_init+0x0/0x166 @ 1
[    8.507962] Intel AES-NI instructions are not detected.
[    8.513203] initcall aesni_init+0x0/0x166 returned -19 after 5112 usecs
[    8.519807] calling  crc32c_intel_mod_init+0x0/0x47 @ 1
[    8.525053] initcall crc32c_intel_mod_init+0x0/0x47 returned -19 after 1 usecs
[    8.532276] calling  init_vdso_vars+0x0/0x272 @ 1
[    8.537001] initcall init_vdso_vars+0x0/0x272 returned 0 after 21 usecs
[    8.543631] calling  ia32_binfmt_init+0x0/0x3b @ 1
[    8.548436] initcall ia32_binfmt_init+0x0/0x3b returned 0 after 16 usecs
[    8.555148] calling  sysenter_setup+0x0/0xfb @ 1
[    8.559771] initcall sysenter_setup+0x0/0xfb returned 0 after 8 usecs
[    8.566225] calling  proc_schedstat_init+0x0/0x49 @ 1
[    8.571304] initcall proc_schedstat_init+0x0/0x49 returned 0 after 17 usecs
[    8.578255] calling  proc_execdomains_init+0x0/0x49 @ 1
[    8.583509] initcall proc_execdomains_init+0x0/0x49 returned 0 after 10 usecs
[    8.590647] calling  ioresources_init+0x0/0x63 @ 1
[    8.595455] initcall ioresources_init+0x0/0x63 returned 0 after 18 usecs
[    8.602164] calling  uid_cache_init+0x0/0xb4 @ 1
[    8.606818] initcall uid_cache_init+0x0/0xb4 returned 0 after 36 usecs
[    8.613355] calling  init_posix_timers+0x0/0x10e @ 1
[    8.618328] initcall init_posix_timers+0x0/0x10e returned 0 after 12 usecs
[    8.625210] calling  init_posix_cpu_timers+0x0/0x109 @ 1
[    8.630533] initcall init_posix_cpu_timers+0x0/0x109 returned 0 after 1 usecs
[    8.637656] calling  nsproxy_cache_init+0x0/0x54 @ 1
[    8.642696] initcall nsproxy_cache_init+0x0/0x54 returned 0 after 54 usecs
[    8.649566] calling  create_proc_profile+0x0/0x8c @ 1
[    8.654638] initcall create_proc_profile+0x0/0x8c returned 0 after 1 usecs
[    8.661523] calling  timekeeping_init_device+0x0/0x49 @ 1
[    8.666916] Registering sysdev class 'timekeeping'
[    8.671973] Registering sys device of class 'timekeeping'
[    8.677374] Registering sys device 'timekeeping0'
[    8.682315] initcall timekeeping_init_device+0x0/0x49 returned 0 after 15031 usecs
[    8.689873] calling  init_clocksource_sysfs+0x0/0x77 @ 1
[    8.695204] Registering sysdev class 'clocksource'
[    8.700227] Registering sys device of class 'clocksource'
[    8.705626] Registering sys device 'clocksource0'
[    8.710573] initcall init_clocksource_sysfs+0x0/0x77 returned 0 after 15006 usecs
[    8.718048] calling  init_timer_list_procfs+0x0/0x53 @ 1
[    8.723393] initcall init_timer_list_procfs+0x0/0x53 returned 0 after 11 usecs
[    8.730622] calling  lockdep_proc_init+0x0/0xa3 @ 1
[    8.735534] initcall lockdep_proc_init+0x0/0xa3 returned 0 after 35 usecs
[    8.742332] calling  futex_init+0x0/0xe4 @ 1
[    8.746632] initcall futex_init+0x0/0xe4 returned 0 after 31 usecs
[    8.752826] calling  init_rttest+0x0/0x177 @ 1
[    8.757269] Registering sysdev class 'rttest'
[    8.761948] Registering sys device of class 'rttest'
[    8.766919] Registering sys device 'rttest0'
[    8.771515] Registering sys device of class 'rttest'
[    8.776477] Registering sys device 'rttest1'
[    8.781108] Registering sys device of class 'rttest'
[    8.786082] Registering sys device 'rttest2'
[    8.790704] Registering sys device of class 'rttest'
[    8.795665] Registering sys device 'rttest3'
[    8.800315] Registering sys device of class 'rttest'
[    8.805278] Registering sys device 'rttest4'
[    8.809868] Registering sys device of class 'rttest'
[    8.814855] Registering sys device 'rttest5'
[    8.819448] Registering sys device of class 'rttest'
[    8.824505] Registering sys device 'rttest6'
[    8.829103] Registering sys device of class 'rttest'
[    8.834089] Registering sys device 'rttest7'
[    8.838579] Initializing RT-Tester: OK
[    8.842349] initcall init_rttest+0x0/0x177 returned 0 after 83081 usecs
[    8.848960] calling  proc_dma_init+0x0/0x49 @ 1
[    8.853534] initcall proc_dma_init+0x0/0x49 returned 0 after 13 usecs
[    8.859966] calling  proc_modules_init+0x0/0x49 @ 1
[    8.864873] initcall proc_modules_init+0x0/0x49 returned 0 after 10 usecs
[    8.871664] calling  kallsyms_init+0x0/0x4c @ 1
[    8.876213] initcall kallsyms_init+0x0/0x4c returned 0 after 19 usecs
[    8.882663] calling  crash_save_vmcoreinfo_init+0x0/0x492 @ 1
[    8.888434] initcall crash_save_vmcoreinfo_init+0x0/0x492 returned 0 after 30 usecs
[    8.896104] calling  crash_notes_memory_init+0x0/0x5f @ 1
[    8.901520] initcall crash_notes_memory_init+0x0/0x5f returned 0 after 8 usecs
[    8.908733] calling  pid_namespaces_init+0x0/0x54 @ 1
[    8.913821] initcall pid_namespaces_init+0x0/0x54 returned 0 after 16 usecs
[    8.920786] calling  audit_init+0x0/0x17a @ 1
[    8.925140] audit: initializing netlink socket (disabled)
[    8.930651] type=2000 audit(1250521435.922:1): initialized
[    8.936139] initcall audit_init+0x0/0x17a returned 0 after 10741 usecs
[    8.942679] calling  audit_tree_init+0x0/0x70 @ 1
[    8.947385] initcall audit_tree_init+0x0/0x70 returned 0 after 5 usecs
[    8.953920] calling  init_kprobes+0x0/0x19e @ 1
[    8.970982] initcall init_kprobes+0x0/0x19e returned 0 after 12235 usecs
[    8.977676] calling  rcuclassic_trace_init+0x0/0x17d @ 1
[    8.983127] initcall rcuclassic_trace_init+0x0/0x17d returned 0 after 111 usecs
[    8.990441] calling  utsname_sysctl_init+0x0/0x3b @ 1
[    8.995498] initcall utsname_sysctl_init+0x0/0x3b returned 0 after 8 usecs
[    9.002384] calling  init_markers+0x0/0x39 @ 1
[    9.006827] initcall init_markers+0x0/0x39 returned 0 after 1 usecs
[    9.013104] calling  init_tracepoints+0x0/0x39 @ 1
[    9.017894] initcall init_tracepoints+0x0/0x39 returned 0 after 1 usecs
[    9.024518] calling  init_per_zone_wmark_min+0x0/0x8d @ 1
[    9.030052] initcall init_per_zone_wmark_min+0x0/0x8d returned 0 after 131 usecs
[    9.037441] calling  pdflush_init+0x0/0x43 @ 1
[    9.042141] initcall pdflush_init+0x0/0x43 returned 0 after 229 usecs
[    9.048568] calling  kswapd_init+0x0/0x9c @ 1
[    9.053082] initcall kswapd_init+0x0/0x9c returned 0 after 96 usecs
[    9.059342] calling  init_tmpfs+0x0/0x64 @ 1
[    9.063826] initcall init_tmpfs+0x0/0x64 returned 0 after 188 usecs
[    9.070104] calling  setup_vmstat+0x0/0xe4 @ 1
[    9.074596] initcall setup_vmstat+0x0/0xe4 returned 0 after 49 usecs
[    9.080970] calling  mm_sysfs_init+0x0/0x50 @ 1
[    9.085526] initcall mm_sysfs_init+0x0/0x50 returned 0 after 25 usecs
[    9.091981] calling  proc_vmalloc_init+0x0/0x4c @ 1
[    9.096866] initcall proc_vmalloc_init+0x0/0x4c returned 0 after 11 usecs
[    9.103662] calling  procswaps_init+0x0/0x49 @ 1
[    9.108288] initcall procswaps_init+0x0/0x49 returned 0 after 10 usecs
[    9.114825] calling  hugetlb_init+0x0/0x22d @ 1
[    9.119355] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    9.125753] initcall hugetlb_init+0x0/0x22d returned 0 after 6246 usecs
[    9.132375] calling  slab_proc_init+0x0/0x4c @ 1
[    9.137000] initcall slab_proc_init+0x0/0x4c returned 0 after 11 usecs
[    9.143538] calling  slab_sysfs_init+0x0/0x11b @ 1
[    9.186696] initcall slab_sysfs_init+0x0/0x11b returned 0 after 37463 usecs
[    9.193711] calling  fasync_init+0x0/0x51 @ 1
[    9.198496] initcall fasync_init+0x0/0x51 returned 0 after 419 usecs
[    9.204931] calling  proc_filesystems_init+0x0/0x49 @ 1
[    9.210187] initcall proc_filesystems_init+0x0/0x49 returned 0 after 19 usecs
[    9.217308] calling  dnotify_init+0x0/0xa7 @ 1
[    9.222691] initcall dnotify_init+0x0/0xa7 returned 0 after 896 usecs
[    9.229123] calling  inotify_setup+0x0/0x37 @ 1
[    9.234188] initcall inotify_setup+0x0/0x37 returned 0 after 1 usecs
[    9.241240] calling  aio_setup+0x0/0xce @ 1
[    9.246570] initcall aio_setup+0x0/0xce returned 0 after 1119 usecs
[    9.252886] calling  proc_locks_init+0x0/0x49 @ 1
[    9.257608] initcall proc_locks_init+0x0/0x49 returned 0 after 20 usecs
[    9.264230] calling  init_sys32_ioctl+0x0/0xac @ 1
[    9.269034] initcall init_sys32_ioctl+0x0/0xac returned 0 after 17 usecs
[    9.275748] calling  init_mbcache+0x0/0x3b @ 1
[    9.280206] initcall init_mbcache+0x0/0x3b returned 0 after 4 usecs
[    9.286469] calling  dquot_init+0x0/0x12a @ 1
[    9.290845] VFS: Disk quotas dquot_6.5.2
[    9.295196] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    9.301882] initcall dquot_init+0x0/0x12a returned 0 after 10776 usecs
[    9.308405] calling  proc_cmdline_init+0x0/0x49 @ 1
[    9.313316] initcall proc_cmdline_init+0x0/0x49 returned 0 after 12 usecs
[    9.320111] calling  proc_cpuinfo_init+0x0/0x49 @ 1
[    9.324999] initcall proc_cpuinfo_init+0x0/0x49 returned 0 after 10 usecs
[    9.331796] calling  proc_devices_init+0x0/0x49 @ 1
[    9.336692] initcall proc_devices_init+0x0/0x49 returned 0 after 21 usecs
[    9.343486] calling  proc_interrupts_init+0x0/0x49 @ 1
[    9.348631] initcall proc_interrupts_init+0x0/0x49 returned 0 after 10 usecs
[    9.355689] calling  proc_loadavg_init+0x0/0x49 @ 1
[    9.360589] initcall proc_loadavg_init+0x0/0x49 returned 0 after 10 usecs
[    9.367363] calling  proc_meminfo_init+0x0/0x49 @ 1
[    9.372271] initcall proc_meminfo_init+0x0/0x49 returned 0 after 10 usecs
[    9.379047] calling  proc_stat_init+0x0/0x49 @ 1
[    9.383696] initcall proc_stat_init+0x0/0x49 returned 0 after 10 usecs
[    9.390233] calling  proc_uptime_init+0x0/0x49 @ 1
[    9.395034] initcall proc_uptime_init+0x0/0x49 returned 0 after 10 usecs
[    9.401742] calling  proc_version_init+0x0/0x49 @ 1
[    9.406630] initcall proc_version_init+0x0/0x49 returned 0 after 10 usecs
[    9.413427] calling  proc_softirqs_init+0x0/0x49 @ 1
[    9.418398] initcall proc_softirqs_init+0x0/0x49 returned 0 after 11 usecs
[    9.425282] calling  proc_kmsg_init+0x0/0x4c @ 1
[    9.429908] initcall proc_kmsg_init+0x0/0x4c returned 0 after 11 usecs
[    9.436445] calling  proc_page_init+0x0/0x69 @ 1
[    9.441093] initcall proc_page_init+0x0/0x69 returned 0 after 19 usecs
[    9.447609] calling  init_devpts_fs+0x0/0x72 @ 1
[    9.452547] initcall init_devpts_fs+0x0/0x72 returned 0 after 293 usecs
[    9.459153] calling  init_ext3_fs+0x0/0x99 @ 1
[    9.464483] initcall init_ext3_fs+0x0/0x99 returned 0 after 843 usecs
[    9.470966] calling  init_ext2_fs+0x0/0x99 @ 1
[    9.476246] initcall init_ext2_fs+0x0/0x99 returned 0 after 816 usecs
[    9.482743] calling  init_ext4_fs+0x0/0x12f @ 1
[    9.489927] initcall init_ext4_fs+0x0/0x12f returned 0 after 2589 usecs
[    9.496560] calling  journal_init+0x0/0xf5 @ 1
[    9.502836] initcall journal_init+0x0/0xf5 returned 0 after 1780 usecs
[    9.509359] calling  journal_init+0x0/0xd6 @ 1
[    9.515592] initcall journal_init+0x0/0xd6 returned 0 after 1722 usecs
[    9.522124] calling  init_cramfs_fs+0x0/0x57 @ 1
[    9.526775] initcall init_cramfs_fs+0x0/0x57 returned 0 after 35 usecs
[    9.533313] calling  init_squashfs_fs+0x0/0x93 @ 1
[    9.538526] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    9.544376] initcall init_squashfs_fs+0x0/0x93 returned 0 after 6125 usecs
[    9.551259] calling  init_ramfs_fs+0x0/0x39 @ 1
[    9.555792] initcall init_ramfs_fs+0x0/0x39 returned 0 after 2 usecs
[    9.562154] calling  init_hugetlbfs_fs+0x0/0xbe @ 1
[    9.567707] initcall init_hugetlbfs_fs+0x0/0xbe returned 0 after 656 usecs
[    9.574596] calling  init_nls_cp437+0x0/0x39 @ 1
[    9.579230] initcall init_nls_cp437+0x0/0x39 returned 0 after 23 usecs
[    9.585773] calling  init_nls_cp737+0x0/0x39 @ 1
[    9.590403] initcall init_nls_cp737+0x0/0x39 returned 0 after 2 usecs
[    9.596832] calling  init_nls_cp850+0x0/0x39 @ 1
[    9.601469] initcall init_nls_cp850+0x0/0x39 returned 0 after 1 usecs
[    9.607898] calling  init_nls_cp860+0x0/0x39 @ 1
[    9.612538] initcall init_nls_cp860+0x0/0x39 returned 0 after 1 usecs
[    9.618965] calling  init_nls_cp869+0x0/0x39 @ 1
[    9.623606] initcall init_nls_cp869+0x0/0x39 returned 0 after 1 usecs
[    9.630056] calling  init_nls_ascii+0x0/0x39 @ 1
[    9.634674] initcall init_nls_ascii+0x0/0x39 returned 0 after 1 usecs
[    9.641124] calling  init_nls_iso8859_1+0x0/0x39 @ 1
[    9.646090] initcall init_nls_iso8859_1+0x0/0x39 returned 0 after 1 usecs
[    9.652885] calling  init_nls_iso8859_2+0x0/0x39 @ 1
[    9.657849] initcall init_nls_iso8859_2+0x0/0x39 returned 0 after 1 usecs
[    9.664647] calling  init_nls_iso8859_3+0x0/0x39 @ 1
[    9.669609] initcall init_nls_iso8859_3+0x0/0x39 returned 0 after 1 usecs
[    9.676407] calling  init_nls_iso8859_4+0x0/0x39 @ 1
[    9.681386] initcall init_nls_iso8859_4+0x0/0x39 returned 0 after 2 usecs
[    9.688161] calling  init_nls_iso8859_5+0x0/0x39 @ 1
[    9.693146] initcall init_nls_iso8859_5+0x0/0x39 returned 0 after 1 usecs
[    9.699921] calling  init_nls_iso8859_15+0x0/0x39 @ 1
[    9.704994] initcall init_nls_iso8859_15+0x0/0x39 returned 0 after 1 usecs
[    9.711879] calling  init_smb_fs+0x0/0x99 @ 1
[    9.717081] initcall init_smb_fs+0x0/0x99 returned 0 after 822 usecs
[    9.723443] calling  init_hpfs_fs+0x0/0x89 @ 1
[    9.728295] initcall init_hpfs_fs+0x0/0x89 returned 0 after 399 usecs
[    9.734744] calling  init_autofs4_fs+0x0/0x4c @ 1
[    9.739455] device: 'autofs': device_add
[    9.743442] PM: Adding info for No Bus:autofs
[    9.748031] initcall init_autofs4_fs+0x0/0x4c returned 0 after 8381 usecs
[    9.754827] calling  init_udf_fs+0x0/0x89 @ 1
[    9.759592] initcall init_udf_fs+0x0/0x89 returned 0 after 400 usecs
[    9.765953] calling  init_omfs_fs+0x0/0x39 @ 1
[    9.770409] initcall init_omfs_fs+0x0/0x39 returned 0 after 3 usecs
[    9.776664] calling  init_xfs_fs+0x0/0xbd @ 1
[    9.781042] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[    9.798115] initcall init_xfs_fs+0x0/0xbd returned 0 after 16666 usecs
[    9.804660] calling  init_nilfs_fs+0x0/0xb9 @ 1
[    9.811021] initcall init_nilfs_fs+0x0/0xb9 returned 0 after 1787 usecs
[    9.817623] calling  init_befs_fs+0x0/0xa4 @ 1
[    9.822089] BeFS version: 0.9.3
[    9.825659] initcall init_befs_fs+0x0/0xa4 returned 0 after 3483 usecs
[    9.832267] calling  ipc_init+0x0/0x4a @ 1
[    9.836382] msgmni has been set to 1803
[    9.840258] initcall ipc_init+0x0/0x4a returned 0 after 3797 usecs
[    9.846431] calling  ipc_sysctl_init+0x0/0x3b @ 1
[    9.851162] initcall ipc_sysctl_init+0x0/0x3b returned 0 after 5 usecs
[    9.857682] calling  init_mqueue_fs+0x0/0xee @ 1
[    9.863039] initcall init_mqueue_fs+0x0/0xee returned 0 after 703 usecs
[    9.869648] calling  key_proc_init+0x0/0x80 @ 1
[    9.874230] initcall key_proc_init+0x0/0x80 returned 0 after 22 usecs
[    9.880681] calling  crypto_wq_init+0x0/0x59 @ 1
[    9.885538] initcall crypto_wq_init+0x0/0x59 returned 0 after 232 usecs
[    9.892165] calling  crypto_algapi_init+0x0/0x34 @ 1
[    9.897143] initcall crypto_algapi_init+0x0/0x34 returned 0 after 16 usecs
[    9.904043] calling  chainiv_module_init+0x0/0x39 @ 1
[    9.909101] initcall chainiv_module_init+0x0/0x39 returned 0 after 6 usecs
[    9.915990] calling  eseqiv_module_init+0x0/0x39 @ 1
[    9.920969] initcall eseqiv_module_init+0x0/0x39 returned 0 after 4 usecs
[    9.927750] calling  md4_mod_init+0x0/0x39 @ 1
[    9.932409] initcall md4_mod_init+0x0/0x39 returned 0 after 187 usecs
[    9.938845] calling  md5_mod_init+0x0/0x39 @ 1
[    9.943467] initcall md5_mod_init+0x0/0x39 returned 0 after 152 usecs
[    9.949903] calling  rmd160_mod_init+0x0/0x39 @ 1
[    9.954799] initcall rmd160_mod_init+0x0/0x39 returned 0 after 160 usecs
[    9.961507] calling  sha1_generic_mod_init+0x0/0x39 @ 1
[    9.966888] initcall sha1_generic_mod_init+0x0/0x39 returned 0 after 153 usecs
[    9.974119] calling  sha256_generic_mod_init+0x0/0x65 @ 1
[    9.979879] initcall sha256_generic_mod_init+0x0/0x65 returned 0 after 355 usecs
[    9.987283] calling  wp512_mod_init+0x0/0x8a @ 1
[    9.992465] initcall wp512_mod_init+0x0/0x8a returned 0 after 541 usecs
[    9.999069] calling  crypto_ecb_module_init+0x0/0x39 @ 1
[   10.004408] initcall crypto_ecb_module_init+0x0/0x39 returned 0 after 4 usecs
[   10.011548] calling  crypto_cbc_module_init+0x0/0x39 @ 1
[   10.016859] initcall crypto_cbc_module_init+0x0/0x39 returned 0 after 4 usecs
[   10.024001] calling  crypto_pcbc_module_init+0x0/0x39 @ 1
[   10.029400] initcall crypto_pcbc_module_init+0x0/0x39 returned 0 after 4 usecs
[   10.036632] calling  crypto_module_init+0x0/0x39 @ 1
[   10.041609] initcall crypto_module_init+0x0/0x39 returned 0 after 4 usecs
[   10.048390] calling  cryptd_init+0x0/0xfd @ 1
[   10.052784] initcall cryptd_init+0x0/0xfd returned 0 after 8 usecs
[   10.058955] calling  serpent_mod_init+0x0/0x65 @ 1
[   10.064185] initcall serpent_mod_init+0x0/0x65 returned 0 after 408 usecs
[   10.070984] calling  aes_init+0x0/0x39 @ 1
[   10.075293] initcall aes_init+0x0/0x39 returned 0 after 205 usecs
[   10.081395] calling  arc4_init+0x0/0x39 @ 1
[   10.085807] initcall arc4_init+0x0/0x39 returned 0 after 222 usecs
[   10.091993] calling  tea_mod_init+0x0/0x8a @ 1
[   10.097039] initcall tea_mod_init+0x0/0x8a returned 0 after 586 usecs
[   10.103485] calling  salsa20_generic_mod_init+0x0/0x39 @ 1
[   10.109084] initcall salsa20_generic_mod_init+0x0/0x39 returned 0 after 110 usecs
[   10.116573] calling  deflate_mod_init+0x0/0x39 @ 1
[   10.122113] initcall deflate_mod_init+0x0/0x39 returned 0 after 722 usecs
[   10.128896] calling  zlib_mod_init+0x0/0x39 @ 1
[   10.134515] initcall zlib_mod_init+0x0/0x39 returned 0 after 1041 usecs
[   10.141141] calling  michael_mic_init+0x0/0x39 @ 1
[   10.146114] initcall michael_mic_init+0x0/0x39 returned 0 after 176 usecs
[   10.152911] calling  crc32c_mod_init+0x0/0x39 @ 1
[   10.157797] initcall crc32c_mod_init+0x0/0x39 returned 0 after 176 usecs
[   10.164508] calling  crypto_authenc_module_init+0x0/0x39 @ 1
[   10.170180] initcall crypto_authenc_module_init+0x0/0x39 returned 0 after 4 usecs
[   10.177654] calling  krng_mod_init+0x0/0x39 @ 1
[   10.182305] alg: No test for stdrng (krng)
[   10.186441] initcall krng_mod_init+0x0/0x39 returned 0 after 4135 usecs
[   10.193064] calling  prng_mod_init+0x0/0x4e @ 1
[   10.197692] alg: No test for stdrng (ansi_cprng)
[   10.202325] initcall prng_mod_init+0x0/0x4e returned 0 after 4619 usecs
[   10.208933] calling  proc_genhd_init+0x0/0x63 @ 1
[   10.213690] initcall proc_genhd_init+0x0/0x63 returned 0 after 31 usecs
[   10.220310] calling  bsg_init+0x0/0x155 @ 1
[   10.225016] device class 'bsg': registering
[   10.229446] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   10.236851] initcall bsg_init+0x0/0x155 returned 0 after 12064 usecs
[   10.243217] calling  noop_init+0x0/0x3b @ 1
[   10.247433] io scheduler noop registered (default)
[   10.252238] initcall noop_init+0x0/0x3b returned 0 after 4724 usecs
[   10.258498] calling  libcrc32c_mod_init+0x0/0x53 @ 1
[   10.263489] initcall libcrc32c_mod_init+0x0/0x53 returned 0 after 7 usecs
[   10.270282] calling  percpu_counter_startup+0x0/0x40 @ 1
[   10.275595] initcall percpu_counter_startup+0x0/0x40 returned 0 after 4 usecs
[   10.282736] calling  dynamic_debug_init+0x0/0x14f @ 1
[   10.288155] initcall dynamic_debug_init+0x0/0x14f returned 0 after 360 usecs
[   10.295221] calling  bt8xxgpio_init+0x0/0x42 @ 1
[   10.299842] bus: 'pci': add driver bt8xxgpio
[   10.304430] initcall bt8xxgpio_init+0x0/0x42 returned 0 after 4478 usecs
[   10.311140] calling  pci_init+0x0/0x5b @ 1
[   10.340282] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.345773] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[   10.351371] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.356956] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.362463] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[   10.368036] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.373659] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.379149] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[   10.384745] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.390372] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.395858] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[   10.401453] pci 0000:00:00.0: Found enabled HT MSI Mapping
[   10.406982] pci 0000:01:00.0: Boot video device
[   10.411546] initcall pci_init+0x0/0x5b returned 0 after 94053 usecs
[   10.417808] calling  pci_proc_init+0x0/0x90 @ 1
[   10.422713] initcall pci_proc_init+0x0/0x90 returned 0 after 346 usecs
[   10.429230] calling  pcie_portdrv_init+0x0/0x72 @ 1
[   10.434401] bus: 'pci_express': registered
[   10.438496] bus: 'pci': add driver pcieport-driver
[   10.443326] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver pcieport-driver
[   10.452463] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0b.0
[   10.461255]   alloc irq_desc for 24 on node 0
[   10.465606]   alloc kstat_irqs on node 0
[   10.469560] pcieport-driver 0000:00:0b.0: irq 24 for MSI/MSI-X
[   10.475416] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[   10.481869] device: '0000:00:0b.0:pcie01': device_add
[   10.486929] bus: 'pci_express': add device 0000:00:0b.0:pcie01
[   10.492793] PM: Adding info for pci_express:0000:00:0b.0:pcie01
[   10.499024] driver: '0000:00:0b.0': driver_bound: bound to device 'pcieport-driver'
[   10.506739] bus: 'pci': really_probe: bound device 0000:00:0b.0 to driver pcieport-driver
[   10.514929] bus: 'pci': driver_probe_device: matched device 0000:00:0c.0 with driver pcieport-driver
[   10.524068] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0c.0
[   10.532816]   alloc irq_desc for 25 on node 0
[   10.537168]   alloc kstat_irqs on node 0
[   10.541156] pcieport-driver 0000:00:0c.0: irq 25 for MSI/MSI-X
[   10.546991] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[   10.553449] device: '0000:00:0c.0:pcie01': device_add
[   10.558507] bus: 'pci_express': add device 0000:00:0c.0:pcie01
[   10.564371] PM: Adding info for pci_express:0000:00:0c.0:pcie01
[   10.570596] driver: '0000:00:0c.0': driver_bound: bound to device 'pcieport-driver'
[   10.578245] bus: 'pci': really_probe: bound device 0000:00:0c.0 to driver pcieport-driver
[   10.586444] bus: 'pci': driver_probe_device: matched device 0000:00:0d.0 with driver pcieport-driver
[   10.595576] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0d.0
[   10.604277]   alloc irq_desc for 26 on node 0
[   10.608632]   alloc kstat_irqs on node 0
[   10.612617] pcieport-driver 0000:00:0d.0: irq 26 for MSI/MSI-X
[   10.618446] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[   10.624905] device: '0000:00:0d.0:pcie01': device_add
[   10.629972] bus: 'pci_express': add device 0000:00:0d.0:pcie01
[   10.635836] PM: Adding info for pci_express:0000:00:0d.0:pcie01
[   10.642060] driver: '0000:00:0d.0': driver_bound: bound to device 'pcieport-driver'
[   10.649710] bus: 'pci': really_probe: bound device 0000:00:0d.0 to driver pcieport-driver
[   10.657908] bus: 'pci': driver_probe_device: matched device 0000:00:0e.0 with driver pcieport-driver
[   10.667041] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0e.0
[   10.675743]   alloc irq_desc for 27 on node 0
[   10.680097]   alloc kstat_irqs on node 0
[   10.684098] pcieport-driver 0000:00:0e.0: irq 27 for MSI/MSI-X
[   10.689929] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[   10.696387] device: '0000:00:0e.0:pcie01': device_add
[   10.701459] bus: 'pci_express': add device 0000:00:0e.0:pcie01
[   10.707302] PM: Adding info for pci_express:0000:00:0e.0:pcie01
[   10.713534] driver: '0000:00:0e.0': driver_bound: bound to device 'pcieport-driver'
[   10.721205] bus: 'pci': really_probe: bound device 0000:00:0e.0 to driver pcieport-driver
[   10.729639] initcall pcie_portdrv_init+0x0/0x72 returned 0 after 288582 usecs
[   10.736808] calling  aer_service_init+0x0/0x47 @ 1
[   10.741610] bus: 'pci_express': add driver aer
[   10.746303] initcall aer_service_init+0x0/0x47 returned 0 after 4581 usecs
[   10.753184] calling  genericbl_init+0x0/0x39 @ 1
[   10.757797] bus: 'platform': add driver generic-bl
[   10.762853] initcall genericbl_init+0x0/0x39 returned 0 after 4934 usecs
[   10.769543] calling  progearbl_init+0x0/0x7b @ 1
[   10.774186] bus: 'platform': add driver progear-bl
[   10.779225] Registering platform device 'progear-bl'. Parent at platform
[   10.785936] device: 'progear-bl': device_add
[   10.790222] bus: 'platform': add device progear-bl
[   10.795042] PM: Adding info for platform:progear-bl
[   10.800185] bus: 'platform': driver_probe_device: matched device progear-bl with driver progear-bl
[   10.809131] bus: 'platform': really_probe: probing driver progear-bl with device progear-bl
[   10.817528] ALI M7101 PMU not found.
[   10.821167] initcall progearbl_init+0x0/0x7b returned 0 after 45878 usecs
[   10.827950] calling  kb3886_init+0x0/0x63 @ 1
[   10.832329] initcall kb3886_init+0x0/0x63 returned -19 after 3 usecs
[   10.838679] calling  cyber2000fb_init+0x0/0xf6 @ 1
[   10.843491] bus: 'pci': add driver CyberPro
[   10.847942] initcall cyber2000fb_init+0x0/0xf6 returned 0 after 4347 usecs
[   10.854864] calling  savagefb_init+0x0/0x9a @ 1
[   10.859396] bus: 'pci': add driver savagefb
[   10.863873] initcall savagefb_init+0x0/0x9a returned 0 after 4369 usecs
[   10.870494] calling  gxfb_init+0x0/0xa7 @ 1
[   10.874675] bus: 'pci': add driver gxfb
[   10.878792] initcall gxfb_init+0x0/0xa7 returned 0 after 4016 usecs
[   10.885073] calling  imsttfb_init+0x0/0x12f @ 1
[   10.889597] bus: 'pci': add driver imsttfb
[   10.893980] initcall imsttfb_init+0x0/0x12f returned 0 after 4276 usecs
[   10.900605] calling  tridentfb_init+0x0/0x70 @ 1
[   10.905224] bus: 'pci': add driver tridentfb
[   10.909766] initcall tridentfb_init+0x0/0x70 returned 0 after 4432 usecs
[   10.916482] calling  arkfb_init+0x0/0xa9 @ 1
[   10.920760] bus: 'pci': add driver arkfb
[   10.924986] initcall arkfb_init+0x0/0xa9 returned 0 after 4127 usecs
[   10.931353] calling  sstfb_init+0x0/0x70 @ 1
[   10.935619] bus: 'pci': add driver sstfb
[   10.939816] initcall sstfb_init+0x0/0x70 returned 0 after 4095 usecs
[   10.946181] calling  s1d13xxxfb_init+0x0/0x54 @ 1
[   10.950893] bus: 'platform': add driver s1d13xxxfb
[   10.955923] initcall s1d13xxxfb_init+0x0/0x54 returned 0 after 4912 usecs
[   10.962715] calling  xenfb_init+0x0/0x6b @ 1
[   10.966985] initcall xenfb_init+0x0/0x6b returned -19 after 1 usecs
[   10.973263] calling  mb862xxfb_init+0x0/0x42 @ 1
[   10.977877] bus: 'pci': add driver mb862xxfb
[   10.982428] initcall mb862xxfb_init+0x0/0x42 returned 0 after 4439 usecs
[   10.989124] calling  efifb_init+0x0/0xb0 @ 1
[   10.993423] initcall efifb_init+0x0/0xb0 returned -19 after 6 usecs
[   10.999680] calling  acpi_reserve_resources+0x0/0x112 @ 1
[   11.005110] initcall acpi_reserve_resources+0x0/0x112 returned 0 after 12 usecs
[   11.012425] calling  irqrouter_init_sysfs+0x0/0x5f @ 1
[   11.017559] Registering sysdev class 'irqrouter'
[   11.022421] Registering sys device of class 'irqrouter'
[   11.027644] Registering sys device 'irqrouter0'
[   11.032411] initcall irqrouter_init_sysfs+0x0/0x5f returned 0 after 14498 usecs
[   11.039711] calling  acpi_processor_init+0x0/0x123 @ 1
[   11.044925] bus: 'acpi': add driver processor
[   11.049294] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[   11.057736] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[   11.065870] device: 'cooling_device0': device_add
[   11.070623] PM: Adding info for No Bus:cooling_device0
[   11.076144] processor LNXCPU:00: registered as cooling_device0
[   11.082008] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[   11.088875] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[   11.096376] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[   11.104822] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[   11.112814] device: 'cooling_device1': device_add
[   11.117547] PM: Adding info for No Bus:cooling_device1
[   11.122937] processor LNXCPU:01: registered as cooling_device1
[   11.128772] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[   11.135660] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[   11.143526] initcall acpi_processor_init+0x0/0x123 returned 0 after 96337 usecs
[   11.150843] calling  acpi_container_init+0x0/0x65 @ 1
[   11.155889] bus: 'acpi': add driver container
[   11.178433] initcall acpi_container_init+0x0/0x65 returned 0 after 22016 usecs
[   11.185667] calling  acpi_smb_hc_init+0x0/0x3f @ 1
[   11.190467] bus: 'acpi': add driver smbus_hc
[   11.195040] initcall acpi_smb_hc_init+0x0/0x3f returned 0 after 4465 usecs
[   11.201925] calling  acpi_sbs_init+0x0/0x76 @ 1
[   11.206563] bus: 'acpi': add driver sbs
[   11.210705] initcall acpi_sbs_init+0x0/0x76 returned 0 after 4150 usecs
[   11.217307] calling  hypervisor_subsys_init+0x0/0x4c @ 1
[   11.222643] initcall hypervisor_subsys_init+0x0/0x4c returned -19 after 2 usecs
[   11.229943] calling  hyper_sysfs_init+0x0/0x118 @ 1
[   11.234844] initcall hyper_sysfs_init+0x0/0x118 returned -19 after 1 usecs
[   11.241728] calling  rand_initialize+0x0/0x53 @ 1
[   11.246470] initcall rand_initialize+0x0/0x53 returned 0 after 39 usecs
[   11.253092] calling  tty_init+0x0/0x11c @ 1
[   11.257285] device: 'tty': device_add
[   11.260994] PM: Adding info for No Bus:tty
[   11.265367] device: 'console': device_add
[   11.269398] PM: Adding info for No Bus:console
[   11.274091] device: 'tty0': device_add
[   11.277876] PM: Adding info for No Bus:tty0
[   11.282303] device class 'vc': registering
[   11.286642] device: 'vcs': device_add
[   11.290357] PM: Adding info for No Bus:vcs
[   11.294723] device: 'vcsa': device_add
[   11.298501] PM: Adding info for No Bus:vcsa
[   11.302932] device: 'vcs1': device_add
[   11.306709] PM: Adding info for No Bus:vcs1
[   11.311137] device: 'vcsa1': device_add
[   11.315012] PM: Adding info for No Bus:vcsa1
[   11.319563] device: 'tty1': device_add
[   11.323358] PM: Adding info for No Bus:tty1
[   11.327780] device: 'tty2': device_add
[   11.331572] PM: Adding info for No Bus:tty2
[   11.335978] device: 'tty3': device_add
[   11.339764] PM: Adding info for No Bus:tty3
[   11.344191] device: 'tty4': device_add
[   11.347971] PM: Adding info for No Bus:tty4
[   11.352401] device: 'tty5': device_add
[   11.356178] PM: Adding info for No Bus:tty5
[   11.360601] device: 'tty6': device_add
[   11.364379] PM: Adding info for No Bus:tty6
[   11.368789] device: 'tty7': device_add
[   11.372594] PM: Adding info for No Bus:tty7
[   11.377017] device: 'tty8': device_add
[   11.380808] PM: Adding info for No Bus:tty8
[   11.385223] device: 'tty9': device_add
[   11.388999] PM: Adding info for No Bus:tty9
[   11.393425] device: 'tty10': device_add
[   11.397295] PM: Adding info for No Bus:tty10
[   11.401807] device: 'tty11': device_add
[   11.405675] PM: Adding info for No Bus:tty11
[   11.410216] device: 'tty12': device_add
[   11.414083] PM: Adding info for No Bus:tty12
[   11.418587] device: 'tty13': device_add
[   11.422471] PM: Adding info for No Bus:tty13
[   11.426981] device: 'tty14': device_add
[   11.430873] PM: Adding info for No Bus:tty14
[   11.435385] device: 'tty15': device_add
[   11.439250] PM: Adding info for No Bus:tty15
[   11.443839] device: 'tty16': device_add
[   11.447700] PM: Adding info for No Bus:tty16
[   11.452215] device: 'tty17': device_add
[   11.456079] PM: Adding info for No Bus:tty17
[   11.460594] device: 'tty18': device_add
[   11.464469] PM: Adding info for No Bus:tty18
[   11.469008] device: 'tty19': device_add
[   11.472895] PM: Adding info for No Bus:tty19
[   11.477389] device: 'tty20': device_add
[   11.481271] PM: Adding info for No Bus:tty20
[   11.485765] device: 'tty21': device_add
[   11.489629] PM: Adding info for No Bus:tty21
[   11.494140] device: 'tty22': device_add
[   11.498010] PM: Adding info for No Bus:tty22
[   11.502520] device: 'tty23': device_add
[   11.506393] PM: Adding info for No Bus:tty23
[   11.510900] device: 'tty24': device_add
[   11.514762] PM: Adding info for No Bus:tty24
[   11.519258] device: 'tty25': device_add
[   11.523141] PM: Adding info for No Bus:tty25
[   11.527649] device: 'tty26': device_add
[   11.531540] PM: Adding info for No Bus:tty26
[   11.536041] device: 'tty27': device_add
[   11.539904] PM: Adding info for No Bus:tty27
[   11.544416] device: 'tty28': device_add
[   11.548277] PM: Adding info for No Bus:tty28
[   11.552800] device: 'tty29': device_add
[   11.556676] PM: Adding info for No Bus:tty29
[   11.561185] device: 'tty30': device_add
[   11.565047] PM: Adding info for No Bus:tty30
[   11.569543] device: 'tty31': device_add
[   11.573426] PM: Adding info for No Bus:tty31
[   11.577922] device: 'tty32': device_add
[   11.581798] PM: Adding info for No Bus:tty32
[   11.586295] device: 'tty33': device_add
[   11.590188] PM: Adding info for No Bus:tty33
[   11.594684] device: 'tty34': device_add
[   11.598552] PM: Adding info for No Bus:tty34
[   11.603066] device: 'tty35': device_add
[   11.606933] PM: Adding info for No Bus:tty35
[   11.611455] device: 'tty36': device_add
[   11.615323] PM: Adding info for No Bus:tty36
[   11.619818] device: 'tty37': device_add
[   11.623712] PM: Adding info for No Bus:tty37
[   11.628218] device: 'tty38': device_add
[   11.632100] PM: Adding info for No Bus:tty38
[   11.636599] device: 'tty39': device_add
[   11.640481] PM: Adding info for No Bus:tty39
[   11.644979] device: 'tty40': device_add
[   11.648855] PM: Adding info for No Bus:tty40
[   11.653364] device: 'tty41': device_add
[   11.657226] PM: Adding info for No Bus:tty41
[   11.661770] device: 'tty42': device_add
[   11.665633] PM: Adding info for No Bus:tty42
[   11.670140] device: 'tty43': device_add
[   11.674006] PM: Adding info for No Bus:tty43
[   11.678512] device: 'tty44': device_add
[   11.682405] PM: Adding info for No Bus:tty44
[   11.686905] device: 'tty45': device_add
[   11.690783] PM: Adding info for No Bus:tty45
[   11.695277] device: 'tty46': device_add
[   11.699139] PM: Adding info for No Bus:tty46
[   11.703689] device: 'tty47': device_add
[   11.707556] PM: Adding info for No Bus:tty47
[   11.712071] device: 'tty48': device_add
[   11.715953] PM: Adding info for No Bus:tty48
[   11.720467] device: 'tty49': device_add
[   11.724333] PM: Adding info for No Bus:tty49
[   11.728835] device: 'tty50': device_add
[   11.732725] PM: Adding info for No Bus:tty50
[   11.737220] device: 'tty51': device_add
[   11.741101] PM: Adding info for No Bus:tty51
[   11.745596] device: 'tty52': device_add
[   11.749477] PM: Adding info for No Bus:tty52
[   11.753996] device: 'tty53': device_add
[   11.757864] PM: Adding info for No Bus:tty53
[   11.762372] device: 'tty54': device_add
[   11.766246] PM: Adding info for No Bus:tty54
[   11.770754] device: 'tty55': device_add
[   11.774627] PM: Adding info for No Bus:tty55
[   11.779120] device: 'tty56': device_add
[   11.783005] PM: Adding info for No Bus:tty56
[   11.787516] device: 'tty57': device_add
[   11.791395] PM: Adding info for No Bus:tty57
[   11.795889] device: 'tty58': device_add
[   11.799751] PM: Adding info for No Bus:tty58
[   11.804259] device: 'tty59': device_add
[   11.808133] PM: Adding info for No Bus:tty59
[   11.812780] device: 'tty60': device_add
[   11.816645] PM: Adding info for No Bus:tty60
[   11.821165] device: 'tty61': device_add
[   11.825044] PM: Adding info for No Bus:tty61
[   11.829561] device: 'tty62': device_add
[   11.833447] PM: Adding info for No Bus:tty62
[   11.837939] device: 'tty63': device_add
[   11.841863] PM: Adding info for No Bus:tty63
[   11.846536] initcall tty_init+0x0/0x11c returned 0 after 575447 usecs
[   11.853019] calling  pty_init+0x0/0x39 @ 1
[   11.857176] device: 'ptyp0': device_add
[   11.861058] PM: Adding info for No Bus:ptyp0
[   11.865604] device: 'ptyp1': device_add
[   11.869475] PM: Adding info for No Bus:ptyp1
[   11.873998] device: 'ptyp2': device_add
[   11.877871] PM: Adding info for No Bus:ptyp2
[   11.882381] device: 'ptyp3': device_add
[   11.886244] PM: Adding info for No Bus:ptyp3
[   11.890758] device: 'ptyp4': device_add
[   11.894624] PM: Adding info for No Bus:ptyp4
[   11.899120] device: 'ptyp5': device_add
[   11.903006] PM: Adding info for No Bus:ptyp5
[   11.907498] device: 'ptyp6': device_add
[   11.911384] PM: Adding info for No Bus:ptyp6
[   11.915891] device: 'ptyp7': device_add
[   11.919758] PM: Adding info for No Bus:ptyp7
[   11.924267] device: 'ptyp8': device_add
[   11.928129] PM: Adding info for No Bus:ptyp8
[   11.932738] device: 'ptyp9': device_add
[   11.936605] PM: Adding info for No Bus:ptyp9
[   11.941129] device: 'ptypa': device_add
[   11.945017] PM: Adding info for No Bus:ptypa
[   11.949525] device: 'ptypb': device_add
[   11.953411] PM: Adding info for No Bus:ptypb
[   11.957907] device: 'ptypc': device_add
[   11.961789] PM: Adding info for No Bus:ptypc
[   11.966287] device: 'ptypd': device_add
[   11.970205] PM: Adding info for No Bus:ptypd
[   11.974728] device: 'ptype': device_add
[   11.978606] PM: Adding info for No Bus:ptype
[   11.983126] device: 'ptypf': device_add
[   11.986995] PM: Adding info for No Bus:ptypf
[   11.991501] device: 'ptyq0': device_add
[   11.995365] PM: Adding info for No Bus:ptyq0
[   11.999863] device: 'ptyq1': device_add
[   12.003761] PM: Adding info for No Bus:ptyq1
[   12.008262] device: 'ptyq2': device_add
[   12.012143] PM: Adding info for No Bus:ptyq2
[   12.016648] device: 'ptyq3': device_add
[   12.020535] PM: Adding info for No Bus:ptyq3
[   12.025029] device: 'ptyq4': device_add
[   12.028898] PM: Adding info for No Bus:ptyq4
[   12.033408] device: 'ptyq5': device_add
[   12.037280] PM: Adding info for No Bus:ptyq5
[   12.041795] device: 'ptyq6': device_add
[   12.045658] PM: Adding info for No Bus:ptyq6
[   12.050175] device: 'ptyq7': device_add
[   12.054043] PM: Adding info for No Bus:ptyq7
[   12.058555] device: 'ptyq8': device_add
[   12.062438] PM: Adding info for No Bus:ptyq8
[   12.066938] device: 'ptyq9': device_add
[   12.070826] PM: Adding info for No Bus:ptyq9
[   12.075323] device: 'ptyqa': device_add
[   12.079191] PM: Adding info for No Bus:ptyqa
[   12.083773] device: 'ptyqb': device_add
[   12.087642] PM: Adding info for No Bus:ptyqb
[   12.092185] device: 'ptyqc': device_add
[   12.096058] PM: Adding info for No Bus:ptyqc
[   12.100583] device: 'ptyqd': device_add
[   12.104456] PM: Adding info for No Bus:ptyqd
[   12.108955] device: 'ptyqe': device_add
[   12.112836] PM: Adding info for No Bus:ptyqe
[   12.117339] device: 'ptyqf': device_add
[   12.121223] PM: Adding info for No Bus:ptyqf
[   12.125721] device: 'ptyr0': device_add
[   12.129596] PM: Adding info for No Bus:ptyr0
[   12.134106] device: 'ptyr1': device_add
[   12.137979] PM: Adding info for No Bus:ptyr1
[   12.142494] device: 'ptyr2': device_add
[   12.146359] PM: Adding info for No Bus:ptyr2
[   12.150872] device: 'ptyr3': device_add
[   12.154751] PM: Adding info for No Bus:ptyr3
[   12.159249] device: 'ptyr4': device_add
[   12.163158] PM: Adding info for No Bus:ptyr4
[   12.167658] device: 'ptyr5': device_add
[   12.171543] PM: Adding info for No Bus:ptyr5
[   12.176039] device: 'ptyr6': device_add
[   12.179907] PM: Adding info for No Bus:ptyr6
[   12.184423] device: 'ptyr7': device_add
[   12.188287] PM: Adding info for No Bus:ptyr7
[   12.192794] device: 'ptyr8': device_add
[   12.196671] PM: Adding info for No Bus:ptyr8
[   12.201184] device: 'ptyr9': device_add
[   12.205049] PM: Adding info for No Bus:ptyr9
[   12.209565] device: 'ptyra': device_add
[   12.213448] PM: Adding info for No Bus:ptyra
[   12.217952] device: 'ptyrb': device_add
[   12.221846] PM: Adding info for No Bus:ptyrb
[   12.226340] device: 'ptyrc': device_add
[   12.230226] PM: Adding info for No Bus:ptyrc
[   12.234718] device: 'ptyrd': device_add
[   12.238591] PM: Adding info for No Bus:ptyrd
[   12.243108] device: 'ptyre': device_add
[   12.246979] PM: Adding info for No Bus:ptyre
[   12.251495] device: 'ptyrf': device_add
[   12.255371] PM: Adding info for No Bus:ptyrf
[   12.259870] device: 'ptys0': device_add
[   12.263768] PM: Adding info for No Bus:ptys0
[   12.268270] device: 'ptys1': device_add
[   12.272154] PM: Adding info for No Bus:ptys1
[   12.276652] device: 'ptys2': device_add
[   12.280535] PM: Adding info for No Bus:ptys2
[   12.285030] device: 'ptys3': device_add
[   12.288909] PM: Adding info for No Bus:ptys3
[   12.293423] device: 'ptys4': device_add
[   12.297289] PM: Adding info for No Bus:ptys4
[   12.301842] device: 'ptys5': device_add
[   12.305714] PM: Adding info for No Bus:ptys5
[   12.310227] device: 'ptys6': device_add
[   12.314112] PM: Adding info for No Bus:ptys6
[   12.318625] device: 'ptys7': device_add
[   12.322510] PM: Adding info for No Bus:ptys7
[   12.327031] device: 'ptys8': device_add
[   12.330917] PM: Adding info for No Bus:ptys8
[   12.335411] device: 'ptys9': device_add
[   12.339279] PM: Adding info for No Bus:ptys9
[   12.343795] device: 'ptysa': device_add
[   12.347669] PM: Adding info for No Bus:ptysa
[   12.352184] device: 'ptysb': device_add
[   12.356051] PM: Adding info for No Bus:ptysb
[   12.360567] device: 'ptysc': device_add
[   12.364439] PM: Adding info for No Bus:ptysc
[   12.368941] device: 'ptysd': device_add
[   12.372839] PM: Adding info for No Bus:ptysd
[   12.377340] device: 'ptyse': device_add
[   12.381284] PM: Adding info for No Bus:ptyse
[   12.385780] device: 'ptysf': device_add
[   12.389668] PM: Adding info for No Bus:ptysf
[   12.394220] device: 'ptyt0': device_add
[   12.398097] PM: Adding info for No Bus:ptyt0
[   12.402721] device: 'ptyt1': device_add
[   12.406593] PM: Adding info for No Bus:ptyt1
[   12.411106] device: 'ptyt2': device_add
[   12.414985] PM: Adding info for No Bus:ptyt2
[   12.419491] device: 'ptyt3': device_add
[   12.423383] PM: Adding info for No Bus:ptyt3
[   12.427884] device: 'ptyt4': device_add
[   12.431769] PM: Adding info for No Bus:ptyt4
[   12.436262] device: 'ptyt5': device_add
[   12.440161] PM: Adding info for No Bus:ptyt5
[   12.444678] device: 'ptyt6': device_add
[   12.448552] PM: Adding info for No Bus:ptyt6
[   12.453063] device: 'ptyt7': device_add
[   12.456931] PM: Adding info for No Bus:ptyt7
[   12.461444] device: 'ptyt8': device_add
[   12.465311] PM: Adding info for No Bus:ptyt8
[   12.469812] device: 'ptyt9': device_add
[   12.473710] PM: Adding info for No Bus:ptyt9
[   12.478221] device: 'ptyta': device_add
[   12.482106] PM: Adding info for No Bus:ptyta
[   12.486599] device: 'ptytb': device_add
[   12.490487] PM: Adding info for No Bus:ptytb
[   12.494981] device: 'ptytc': device_add
[   12.498851] PM: Adding info for No Bus:ptytc
[   12.503365] device: 'ptytd': device_add
[   12.507242] PM: Adding info for No Bus:ptytd
[   12.511755] device: 'ptyte': device_add
[   12.515623] PM: Adding info for No Bus:ptyte
[   12.520157] device: 'ptytf': device_add
[   12.524029] PM: Adding info for No Bus:ptytf
[   12.528548] device: 'ptyu0': device_add
[   12.532446] PM: Adding info for No Bus:ptyu0
[   12.536950] device: 'ptyu1': device_add
[   12.540842] PM: Adding info for No Bus:ptyu1
[   12.545340] device: 'ptyu2': device_add
[   12.549224] PM: Adding info for No Bus:ptyu2
[   12.553784] device: 'ptyu3': device_add
[   12.557656] PM: Adding info for No Bus:ptyu3
[   12.562180] device: 'ptyu4': device_add
[   12.566063] PM: Adding info for No Bus:ptyu4
[   12.570583] device: 'ptyu5': device_add
[   12.574452] PM: Adding info for No Bus:ptyu5
[   12.578951] device: 'ptyu6': device_add
[   12.582852] PM: Adding info for No Bus:ptyu6
[   12.587389] device: 'ptyu7': device_add
[   12.591272] PM: Adding info for No Bus:ptyu7
[   12.595764] device: 'ptyu8': device_add
[   12.599647] PM: Adding info for No Bus:ptyu8
[   12.604159] device: 'ptyu9': device_add
[   12.608026] PM: Adding info for No Bus:ptyu9
[   12.612632] device: 'ptyua': device_add
[   12.616502] PM: Adding info for No Bus:ptyua
[   12.621039] device: 'ptyub': device_add
[   12.624913] PM: Adding info for No Bus:ptyub
[   12.629414] device: 'ptyuc': device_add
[   12.633313] PM: Adding info for No Bus:ptyuc
[   12.637808] device: 'ptyud': device_add
[   12.641696] PM: Adding info for No Bus:ptyud
[   12.646197] device: 'ptyue': device_add
[   12.650120] PM: Adding info for No Bus:ptyue
[   12.654630] device: 'ptyuf': device_add
[   12.658511] PM: Adding info for No Bus:ptyuf
[   12.663028] device: 'ptyv0': device_add
[   12.666901] PM: Adding info for No Bus:ptyv0
[   12.671411] device: 'ptyv1': device_add
[   12.675281] PM: Adding info for No Bus:ptyv1
[   12.679792] device: 'ptyv2': device_add
[   12.683683] PM: Adding info for No Bus:ptyv2
[   12.688176] device: 'ptyv3': device_add
[   12.692086] PM: Adding info for No Bus:ptyv3
[   12.696585] device: 'ptyv4': device_add
[   12.700473] PM: Adding info for No Bus:ptyv4
[   12.704973] device: 'ptyv5': device_add
[   12.708846] PM: Adding info for No Bus:ptyv5
[   12.713360] device: 'ptyv6': device_add
[   12.717228] PM: Adding info for No Bus:ptyv6
[   12.721748] device: 'ptyv7': device_add
[   12.725629] PM: Adding info for No Bus:ptyv7
[   12.730123] device: 'ptyv8': device_add
[   12.733997] PM: Adding info for No Bus:ptyv8
[   12.738509] device: 'ptyv9': device_add
[   12.742396] PM: Adding info for No Bus:ptyv9
[   12.746900] device: 'ptyva': device_add
[   12.750794] PM: Adding info for No Bus:ptyva
[   12.755292] device: 'ptyvb': device_add
[   12.759167] PM: Adding info for No Bus:ptyvb
[   12.763721] device: 'ptyvc': device_add
[   12.767591] PM: Adding info for No Bus:ptyvc
[   12.772099] device: 'ptyvd': device_add
[   12.775971] PM: Adding info for No Bus:ptyvd
[   12.780489] device: 'ptyve': device_add
[   12.784370] PM: Adding info for No Bus:ptyve
[   12.788866] device: 'ptyvf': device_add
[   12.792761] PM: Adding info for No Bus:ptyvf
[   12.797269] device: 'ptyw0': device_add
[   12.801165] PM: Adding info for No Bus:ptyw0
[   12.805666] device: 'ptyw1': device_add
[   12.809537] PM: Adding info for No Bus:ptyw1
[   12.814048] device: 'ptyw2': device_add
[   12.817927] PM: Adding info for No Bus:ptyw2
[   12.822447] device: 'ptyw3': device_add
[   12.826326] PM: Adding info for No Bus:ptyw3
[   12.830838] device: 'ptyw4': device_add
[   12.834715] PM: Adding info for No Bus:ptyw4
[   12.839209] device: 'ptyw5': device_add
[   12.843093] PM: Adding info for No Bus:ptyw5
[   12.847590] device: 'ptyw6': device_add
[   12.851492] PM: Adding info for No Bus:ptyw6
[   12.855990] device: 'ptyw7': device_add
[   12.859864] PM: Adding info for No Bus:ptyw7
[   12.864374] device: 'ptyw8': device_add
[   12.868246] PM: Adding info for No Bus:ptyw8
[   12.872761] device: 'ptyw9': device_add
[   12.876644] PM: Adding info for No Bus:ptyw9
[   12.881157] device: 'ptywa': device_add
[   12.885034] PM: Adding info for No Bus:ptywa
[   12.889530] device: 'ptywb': device_add
[   12.893421] PM: Adding info for No Bus:ptywb
[   12.897919] device: 'ptywc': device_add
[   12.901810] PM: Adding info for No Bus:ptywc
[   12.906329] device: 'ptywd': device_add
[   12.910230] PM: Adding info for No Bus:ptywd
[   12.914741] device: 'ptywe': device_add
[   12.918619] PM: Adding info for No Bus:ptywe
[   12.923145] device: 'ptywf': device_add
[   12.927017] PM: Adding info for No Bus:ptywf
[   12.931567] device: 'ptyx0': device_add
[   12.935450] PM: Adding info for No Bus:ptyx0
[   12.939956] device: 'ptyx1': device_add
[   12.943855] PM: Adding info for No Bus:ptyx1
[   12.948352] device: 'ptyx2': device_add
[   12.952242] PM: Adding info for No Bus:ptyx2
[   12.956741] device: 'ptyx3': device_add
[   12.960631] PM: Adding info for No Bus:ptyx3
[   12.965128] device: 'ptyx4': device_add
[   12.969015] PM: Adding info for No Bus:ptyx4
[   12.973526] device: 'ptyx5': device_add
[   12.977405] PM: Adding info for No Bus:ptyx5
[   12.981912] device: 'ptyx6': device_add
[   12.985785] PM: Adding info for No Bus:ptyx6
[   12.990296] device: 'ptyx7': device_add
[   12.994172] PM: Adding info for No Bus:ptyx7
[   12.998669] device: 'ptyx8': device_add
[   13.002577] PM: Adding info for No Bus:ptyx8
[   13.007077] device: 'ptyx9': device_add
[   13.010980] PM: Adding info for No Bus:ptyx9
[   13.015476] device: 'ptyxa': device_add
[   13.019353] PM: Adding info for No Bus:ptyxa
[   13.023914] device: 'ptyxb': device_add
[   13.027794] PM: Adding info for No Bus:ptyxb
[   13.032327] device: 'ptyxc': device_add
[   13.036211] PM: Adding info for No Bus:ptyxc
[   13.040725] device: 'ptyxd': device_add
[   13.044596] PM: Adding info for No Bus:ptyxd
[   13.049093] device: 'ptyxe': device_add
[   13.052991] PM: Adding info for No Bus:ptyxe
[   13.057489] device: 'ptyxf': device_add
[   13.061382] PM: Adding info for No Bus:ptyxf
[   13.065880] device: 'ptyy0': device_add
[   13.069767] PM: Adding info for No Bus:ptyy0
[   13.074283] device: 'ptyy1': device_add
[   13.078154] PM: Adding info for No Bus:ptyy1
[   13.082807] device: 'ptyy2': device_add
[   13.086685] PM: Adding info for No Bus:ptyy2
[   13.091211] device: 'ptyy3': device_add
[   13.095101] PM: Adding info for No Bus:ptyy3
[   13.099610] device: 'ptyy4': device_add
[   13.103542] PM: Adding info for No Bus:ptyy4
[   13.108055] device: 'ptyy5': device_add
[   13.111945] PM: Adding info for No Bus:ptyy5
[   13.116442] device: 'ptyy6': device_add
[   13.120382] PM: Adding info for No Bus:ptyy6
[   13.124900] device: 'ptyy7': device_add
[   13.128787] PM: Adding info for No Bus:ptyy7
[   13.133313] device: 'ptyy8': device_add
[   13.137192] PM: Adding info for No Bus:ptyy8
[   13.141735] device: 'ptyy9': device_add
[   13.145609] PM: Adding info for No Bus:ptyy9
[   13.150125] device: 'ptyya': device_add
[   13.153998] PM: Adding info for No Bus:ptyya
[   13.158511] device: 'ptyyb': device_add
[   13.162418] PM: Adding info for No Bus:ptyyb
[   13.166923] device: 'ptyyc': device_add
[   13.170818] PM: Adding info for No Bus:ptyyc
[   13.175315] device: 'ptyyd': device_add
[   13.179192] PM: Adding info for No Bus:ptyyd
[   13.183756] device: 'ptyye': device_add
[   13.187644] PM: Adding info for No Bus:ptyye
[   13.192162] device: 'ptyyf': device_add
[   13.196041] PM: Adding info for No Bus:ptyyf
[   13.200563] device: 'ptyz0': device_add
[   13.204438] PM: Adding info for No Bus:ptyz0
[   13.208940] device: 'ptyz1': device_add
[   13.212838] PM: Adding info for No Bus:ptyz1
[   13.217342] device: 'ptyz2': device_add
[   13.221242] PM: Adding info for No Bus:ptyz2
[   13.225746] device: 'ptyz3': device_add
[   13.229636] PM: Adding info for No Bus:ptyz3
[   13.234148] device: 'ptyz4': device_add
[   13.238022] PM: Adding info for No Bus:ptyz4
[   13.242630] device: 'ptyz5': device_add
[   13.246506] PM: Adding info for No Bus:ptyz5
[   13.251034] device: 'ptyz6': device_add
[   13.254926] PM: Adding info for No Bus:ptyz6
[   13.259429] device: 'ptyz7': device_add
[   13.263324] PM: Adding info for No Bus:ptyz7
[   13.267836] device: 'ptyz8': device_add
[   13.271727] PM: Adding info for No Bus:ptyz8
[   13.276222] device: 'ptyz9': device_add
[   13.280151] PM: Adding info for No Bus:ptyz9
[   13.284653] device: 'ptyza': device_add
[   13.288542] PM: Adding info for No Bus:ptyza
[   13.293060] device: 'ptyzb': device_add
[   13.296939] PM: Adding info for No Bus:ptyzb
[   13.301453] device: 'ptyzc': device_add
[   13.305328] PM: Adding info for No Bus:ptyzc
[   13.309829] device: 'ptyzd': device_add
[   13.313739] PM: Adding info for No Bus:ptyzd
[   13.318234] device: 'ptyze': device_add
[   13.322143] PM: Adding info for No Bus:ptyze
[   13.326650] device: 'ptyzf': device_add
[   13.330549] PM: Adding info for No Bus:ptyzf
[   13.335062] device: 'ptya0': device_add
[   13.338938] PM: Adding info for No Bus:ptya0
[   13.343453] device: 'ptya1': device_add
[   13.347338] PM: Adding info for No Bus:ptya1
[   13.351850] device: 'ptya2': device_add
[   13.355724] PM: Adding info for No Bus:ptya2
[   13.360238] device: 'ptya3': device_add
[   13.364114] PM: Adding info for No Bus:ptya3
[   13.368615] device: 'ptya4': device_add
[   13.372512] PM: Adding info for No Bus:ptya4
[   13.377014] device: 'ptya5': device_add
[   13.380920] PM: Adding info for No Bus:ptya5
[   13.385436] device: 'ptya6': device_add
[   13.389319] PM: Adding info for No Bus:ptya6
[   13.393836] device: 'ptya7': device_add
[   13.397716] PM: Adding info for No Bus:ptya7
[   13.402229] device: 'ptya8': device_add
[   13.406115] PM: Adding info for No Bus:ptya8
[   13.410628] device: 'ptya9': device_add
[   13.414513] PM: Adding info for No Bus:ptya9
[   13.419011] device: 'ptyaa': device_add
[   13.422907] PM: Adding info for No Bus:ptyaa
[   13.427410] device: 'ptyab': device_add
[   13.431308] PM: Adding info for No Bus:ptyab
[   13.435809] device: 'ptyac': device_add
[   13.439717] PM: Adding info for No Bus:ptyac
[   13.444274] device: 'ptyad': device_add
[   13.448157] PM: Adding info for No Bus:ptyad
[   13.452803] device: 'ptyae': device_add
[   13.456685] PM: Adding info for No Bus:ptyae
[   13.461209] device: 'ptyaf': device_add
[   13.465093] PM: Adding info for No Bus:ptyaf
[   13.469594] device: 'ptyb0': device_add
[   13.473500] PM: Adding info for No Bus:ptyb0
[   13.478001] device: 'ptyb1': device_add
[   13.481931] PM: Adding info for No Bus:ptyb1
[   13.486439] device: 'ptyb2': device_add
[   13.490335] PM: Adding info for No Bus:ptyb2
[   13.494827] device: 'ptyb3': device_add
[   13.498710] PM: Adding info for No Bus:ptyb3
[   13.503278] device: 'ptyb4': device_add
[   13.507171] PM: Adding info for No Bus:ptyb4
[   13.511688] device: 'ptyb5': device_add
[   13.515566] PM: Adding info for No Bus:ptyb5
[   13.520064] device: 'ptyb6': device_add
[   13.523946] PM: Adding info for No Bus:ptyb6
[   13.528470] device: 'ptyb7': device_add
[   13.532436] PM: Adding info for No Bus:ptyb7
[   13.536936] device: 'ptyb8': device_add
[   13.540846] PM: Adding info for No Bus:ptyb8
[   13.545345] device: 'ptyb9': device_add
[   13.549248] PM: Adding info for No Bus:ptyb9
[   13.553801] device: 'ptyba': device_add
[   13.557679] PM: Adding info for No Bus:ptyba
[   13.562190] device: 'ptybb': device_add
[   13.566078] PM: Adding info for No Bus:ptybb
[   13.570596] device: 'ptybc': device_add
[   13.574475] PM: Adding info for No Bus:ptybc
[   13.578971] device: 'ptybd': device_add
[   13.582873] PM: Adding info for No Bus:ptybd
[   13.587372] device: 'ptybe': device_add
[   13.591268] PM: Adding info for No Bus:ptybe
[   13.595768] device: 'ptybf': device_add
[   13.599661] PM: Adding info for No Bus:ptybf
[   13.604174] device: 'ptyc0': device_add
[   13.608058] PM: Adding info for No Bus:ptyc0
[   13.612659] device: 'ptyc1': device_add
[   13.616542] PM: Adding info for No Bus:ptyc1
[   13.621070] device: 'ptyc2': device_add
[   13.624959] PM: Adding info for No Bus:ptyc2
[   13.629466] device: 'ptyc3': device_add
[   13.633366] PM: Adding info for No Bus:ptyc3
[   13.637862] device: 'ptyc4': device_add
[   13.641760] PM: Adding info for No Bus:ptyc4
[   13.646253] device: 'ptyc5': device_add
[   13.650150] PM: Adding info for No Bus:ptyc5
[   13.654649] device: 'ptyc6': device_add
[   13.658554] PM: Adding info for No Bus:ptyc6
[   13.663071] device: 'ptyc7': device_add
[   13.666949] PM: Adding info for No Bus:ptyc7
[   13.671459] device: 'ptyc8': device_add
[   13.675337] PM: Adding info for No Bus:ptyc8
[   13.679836] device: 'ptyc9': device_add
[   13.683735] PM: Adding info for No Bus:ptyc9
[   13.688234] device: 'ptyca': device_add
[   13.692142] PM: Adding info for No Bus:ptyca
[   13.696641] device: 'ptycb': device_add
[   13.700540] PM: Adding info for No Bus:ptycb
[   13.705037] device: 'ptycc': device_add
[   13.708932] PM: Adding info for No Bus:ptycc
[   13.713441] device: 'ptycd': device_add
[   13.717320] PM: Adding info for No Bus:ptycd
[   13.721869] device: 'ptyce': device_add
[   13.725763] PM: Adding info for No Bus:ptyce
[   13.730282] device: 'ptycf': device_add
[   13.734170] PM: Adding info for No Bus:ptycf
[   13.738689] device: 'ptyd0': device_add
[   13.742592] PM: Adding info for No Bus:ptyd0
[   13.747094] device: 'ptyd1': device_add
[   13.750996] PM: Adding info for No Bus:ptyd1
[   13.755497] device: 'ptyd2': device_add
[   13.759382] PM: Adding info for No Bus:ptyd2
[   13.763908] device: 'ptyd3': device_add
[   13.767797] PM: Adding info for No Bus:ptyd3
[   13.772314] device: 'ptyd4': device_add
[   13.776192] PM: Adding info for No Bus:ptyd4
[   13.780704] device: 'ptyd5': device_add
[   13.784594] PM: Adding info for No Bus:ptyd5
[   13.789095] device: 'ptyd6': device_add
[   13.792996] PM: Adding info for No Bus:ptyd6
[   13.797494] device: 'ptyd7': device_add
[   13.801394] PM: Adding info for No Bus:ptyd7
[   13.805895] device: 'ptyd8': device_add
[   13.809776] PM: Adding info for No Bus:ptyd8
[   13.814323] device: 'ptyd9': device_add
[   13.818220] PM: Adding info for No Bus:ptyd9
[   13.822793] device: 'ptyda': device_add
[   13.826676] PM: Adding info for No Bus:ptyda
[   13.831195] device: 'ptydb': device_add
[   13.835077] PM: Adding info for No Bus:ptydb
[   13.839579] device: 'ptydc': device_add
[   13.843490] PM: Adding info for No Bus:ptydc
[   13.847986] device: 'ptydd': device_add
[   13.851887] PM: Adding info for No Bus:ptydd
[   13.856402] device: 'ptyde': device_add
[   13.860305] PM: Adding info for No Bus:ptyde
[   13.864801] device: 'ptydf': device_add
[   13.868695] PM: Adding info for No Bus:ptydf
[   13.873210] device: 'ptye0': device_add
[   13.877101] PM: Adding info for No Bus:ptye0
[   13.881617] device: 'ptye1': device_add
[   13.885499] PM: Adding info for No Bus:ptye1
[   13.890015] device: 'ptye2': device_add
[   13.893896] PM: Adding info for No Bus:ptye2
[   13.898390] device: 'ptye3': device_add
[   13.902292] PM: Adding info for No Bus:ptye3
[   13.906789] device: 'ptye4': device_add
[   13.910702] PM: Adding info for No Bus:ptye4
[   13.915197] device: 'ptye5': device_add
[   13.919081] PM: Adding info for No Bus:ptye5
[   13.923590] device: 'ptye6': device_add
[   13.927470] PM: Adding info for No Bus:ptye6
[   13.931991] device: 'ptye7': device_add
[   13.935879] PM: Adding info for No Bus:ptye7
[   13.940400] device: 'ptye8': device_add
[   13.944295] PM: Adding info for No Bus:ptye8
[   13.948797] device: 'ptye9': device_add
[   13.952700] PM: Adding info for No Bus:ptye9
[   13.957196] device: 'ptyea': device_add
[   13.961097] PM: Adding info for No Bus:ptyea
[   13.965591] device: 'ptyeb': device_add
[   13.969488] PM: Adding info for No Bus:ptyeb
[   13.974061] device: 'ptyec': device_add
[   13.977960] PM: Adding info for No Bus:ptyec
[   13.982471] device: 'ptyed': device_add
[   13.986354] PM: Adding info for No Bus:ptyed
[   13.990871] device: 'ptyee': device_add
[   13.994760] PM: Adding info for No Bus:ptyee
[   13.999262] device: 'ptyef': device_add
[   14.003176] PM: Adding info for No Bus:ptyef
[   14.007699] device: 'ttyp0': device_add
[   14.011594] PM: Adding info for No Bus:ttyp0
[   14.016095] device: 'ttyp1': device_add
[   14.019976] PM: Adding info for No Bus:ttyp1
[   14.024488] device: 'ttyp2': device_add
[   14.028366] PM: Adding info for No Bus:ttyp2
[   14.032886] device: 'ttyp3': device_add
[   14.036786] PM: Adding info for No Bus:ttyp3
[   14.041306] device: 'ttyp4': device_add
[   14.045186] PM: Adding info for No Bus:ttyp4
[   14.049685] device: 'ttyp5': device_add
[   14.053591] PM: Adding info for No Bus:ttyp5
[   14.058083] device: 'ttyp6': device_add
[   14.061992] PM: Adding info for No Bus:ttyp6
[   14.066491] device: 'ttyp7': device_add
[   14.070391] PM: Adding info for No Bus:ttyp7
[   14.074888] device: 'ttyp8': device_add
[   14.078770] PM: Adding info for No Bus:ttyp8
[   14.083285] device: 'ttyp9': device_add
[   14.087182] PM: Adding info for No Bus:ttyp9
[   14.091713] device: 'ttypa': device_add
[   14.095616] PM: Adding info for No Bus:ttypa
[   14.100122] device: 'ttypb': device_add
[   14.104001] PM: Adding info for No Bus:ttypb
[   14.108529] device: 'ttypc': device_add
[   14.112436] PM: Adding info for No Bus:ttypc
[   14.116934] device: 'ttypd': device_add
[   14.120828] PM: Adding info for No Bus:ttypd
[   14.125328] device: 'ttype': device_add
[   14.129224] PM: Adding info for No Bus:ttype
[   14.133801] device: 'ttypf': device_add
[   14.137682] PM: Adding info for No Bus:ttypf
[   14.142190] device: 'ttyq0': device_add
[   14.146068] PM: Adding info for No Bus:ttyq0
[   14.150586] device: 'ttyq1': device_add
[   14.154468] PM: Adding info for No Bus:ttyq1
[   14.158963] device: 'ttyq2': device_add
[   14.162876] PM: Adding info for No Bus:ttyq2
[   14.167410] device: 'ttyq3': device_add
[   14.171304] PM: Adding info for No Bus:ttyq3
[   14.175803] device: 'ttyq4': device_add
[   14.179686] PM: Adding info for No Bus:ttyq4
[   14.184196] device: 'ttyq5': device_add
[   14.188084] PM: Adding info for No Bus:ttyq5
[   14.192699] device: 'ttyq6': device_add
[   14.196580] PM: Adding info for No Bus:ttyq6
[   14.201100] device: 'ttyq7': device_add
[   14.204984] PM: Adding info for No Bus:ttyq7
[   14.209495] device: 'ttyq8': device_add
[   14.213394] PM: Adding info for No Bus:ttyq8
[   14.217889] device: 'ttyq9': device_add
[   14.221799] PM: Adding info for No Bus:ttyq9
[   14.226295] device: 'ttyqa': device_add
[   14.230195] PM: Adding info for No Bus:ttyqa
[   14.234701] device: 'ttyqb': device_add
[   14.238589] PM: Adding info for No Bus:ttyqb
[   14.243109] device: 'ttyqc': device_add
[   14.246993] PM: Adding info for No Bus:ttyqc
[   14.251505] device: 'ttyqd': device_add
[   14.255402] PM: Adding info for No Bus:ttyqd
[   14.259903] device: 'ttyqe': device_add
[   14.263806] PM: Adding info for No Bus:ttyqe
[   14.268302] device: 'ttyqf': device_add
[   14.272202] PM: Adding info for No Bus:ttyqf
[   14.276702] device: 'ttyr0': device_add
[   14.280612] PM: Adding info for No Bus:ttyr0
[   14.285111] device: 'ttyr1': device_add
[   14.288994] PM: Adding info for No Bus:ttyr1
[   14.293508] device: 'ttyr2': device_add
[   14.297402] PM: Adding info for No Bus:ttyr2
[   14.301954] device: 'ttyr3': device_add
[   14.305841] PM: Adding info for No Bus:ttyr3
[   14.310358] device: 'ttyr4': device_add
[   14.314247] PM: Adding info for No Bus:ttyr4
[   14.318743] device: 'ttyr5': device_add
[   14.322647] PM: Adding info for No Bus:ttyr5
[   14.327160] device: 'ttyr6': device_add
[   14.331061] PM: Adding info for No Bus:ttyr6
[   14.335565] device: 'ttyr7': device_add
[   14.339452] PM: Adding info for No Bus:ttyr7
[   14.343970] device: 'ttyr8': device_add
[   14.347868] PM: Adding info for No Bus:ttyr8
[   14.352384] device: 'ttyr9': device_add
[   14.356272] PM: Adding info for No Bus:ttyr9
[   14.360790] device: 'ttyra': device_add
[   14.364671] PM: Adding info for No Bus:ttyra
[   14.369174] device: 'ttyrb': device_add
[   14.373076] PM: Adding info for No Bus:ttyrb
[   14.377574] device: 'ttyrc': device_add
[   14.381486] PM: Adding info for No Bus:ttyrc
[   14.385980] device: 'ttyrd': device_add
[   14.389864] PM: Adding info for No Bus:ttyrd
[   14.394416] device: 'ttyre': device_add
[   14.398297] PM: Adding info for No Bus:ttyre
[   14.402814] device: 'ttyrf': device_add
[   14.406717] PM: Adding info for No Bus:ttyrf
[   14.411227] device: 'ttys0': device_add
[   14.415112] PM: Adding info for No Bus:ttys0
[   14.419613] device: 'ttys1': device_add
[   14.423517] PM: Adding info for No Bus:ttys1
[   14.428013] device: 'ttys2': device_add
[   14.431914] PM: Adding info for No Bus:ttys2
[   14.436420] device: 'ttys3': device_add
[   14.440335] PM: Adding info for No Bus:ttys3
[   14.444851] device: 'ttys4': device_add
[   14.448739] PM: Adding info for No Bus:ttys4
[   14.453255] device: 'ttys5': device_add
[   14.457143] PM: Adding info for No Bus:ttys5
[   14.461651] device: 'ttys6': device_add
[   14.465534] PM: Adding info for No Bus:ttys6
[   14.470042] device: 'ttys7': device_add
[   14.473945] PM: Adding info for No Bus:ttys7
[   14.478444] device: 'ttys8': device_add
[   14.482358] PM: Adding info for No Bus:ttys8
[   14.486857] device: 'ttys9': device_add
[   14.490765] PM: Adding info for No Bus:ttys9
[   14.495265] device: 'ttysa': device_add
[   14.499160] PM: Adding info for No Bus:ttysa
[   14.503681] device: 'ttysb': device_add
[   14.507569] PM: Adding info for No Bus:ttysb
[   14.512084] device: 'ttysc': device_add
[   14.515979] PM: Adding info for No Bus:ttysc
[   14.520493] device: 'ttysd': device_add
[   14.524381] PM: Adding info for No Bus:ttysd
[   14.528881] device: 'ttyse': device_add
[   14.532796] PM: Adding info for No Bus:ttyse
[   14.537299] device: 'ttysf': device_add
[   14.541205] PM: Adding info for No Bus:ttysf
[   14.545707] device: 'ttyt0': device_add
[   14.549592] PM: Adding info for No Bus:ttyt0
[   14.554144] device: 'ttyt1': device_add
[   14.558033] PM: Adding info for No Bus:ttyt1
[   14.562681] device: 'ttyt2': device_add
[   14.566586] PM: Adding info for No Bus:ttyt2
[   14.571123] device: 'ttyt3': device_add
[   14.575017] PM: Adding info for No Bus:ttyt3
[   14.579519] device: 'ttyt4': device_add
[   14.583419] PM: Adding info for No Bus:ttyt4
[   14.587915] device: 'ttyt5': device_add
[   14.591816] PM: Adding info for No Bus:ttyt5
[   14.596310] device: 'ttyt6': device_add
[   14.600265] PM: Adding info for No Bus:ttyt6
[   14.604771] device: 'ttyt7': device_add
[   14.608656] PM: Adding info for No Bus:ttyt7
[   14.613174] device: 'ttyt8': device_add
[   14.617064] PM: Adding info for No Bus:ttyt8
[   14.621599] device: 'ttyt9': device_add
[   14.625501] PM: Adding info for No Bus:ttyt9
[   14.629999] device: 'ttyta': device_add
[   14.633913] PM: Adding info for No Bus:ttyta
[   14.638422] device: 'ttytb': device_add
[   14.642329] PM: Adding info for No Bus:ttytb
[   14.646831] device: 'ttytc': device_add
[   14.650734] PM: Adding info for No Bus:ttytc
[   14.655228] device: 'ttytd': device_add
[   14.659125] PM: Adding info for No Bus:ttytd
[   14.663640] device: 'ttyte': device_add
[   14.667530] PM: Adding info for No Bus:ttyte
[   14.672043] device: 'ttytf': device_add
[   14.675929] PM: Adding info for No Bus:ttytf
[   14.680458] device: 'ttyu0': device_add
[   14.684391] PM: Adding info for No Bus:ttyu0
[   14.688888] device: 'ttyu1': device_add
[   14.692820] PM: Adding info for No Bus:ttyu1
[   14.697322] device: 'ttyu2': device_add
[   14.701235] PM: Adding info for No Bus:ttyu2
[   14.705736] device: 'ttyu3': device_add
[   14.709624] PM: Adding info for No Bus:ttyu3
[   14.714137] device: 'ttyu4': device_add
[   14.718030] PM: Adding info for No Bus:ttyu4
[   14.722668] device: 'ttyu5': device_add
[   14.726571] PM: Adding info for No Bus:ttyu5
[   14.731106] device: 'ttyu6': device_add
[   14.735000] PM: Adding info for No Bus:ttyu6
[   14.739516] device: 'ttyu7': device_add
[   14.743433] PM: Adding info for No Bus:ttyu7
[   14.747938] device: 'ttyu8': device_add
[   14.751847] PM: Adding info for No Bus:ttyu8
[   14.756343] device: 'ttyu9': device_add
[   14.760285] PM: Adding info for No Bus:ttyu9
[   14.764791] device: 'ttyua': device_add
[   14.768680] PM: Adding info for No Bus:ttyua
[   14.773203] device: 'ttyub': device_add
[   14.777094] PM: Adding info for No Bus:ttyub
[   14.781645] device: 'ttyuc': device_add
[   14.785549] PM: Adding info for No Bus:ttyuc
[   14.790049] device: 'ttyud': device_add
[   14.793935] PM: Adding info for No Bus:ttyud
[   14.798463] device: 'ttyue': device_add
[   14.802377] PM: Adding info for No Bus:ttyue
[   14.806883] device: 'ttyuf': device_add
[   14.810791] PM: Adding info for No Bus:ttyuf
[   14.815292] device: 'ttyv0': device_add
[   14.819194] PM: Adding info for No Bus:ttyv0
[   14.823751] device: 'ttyv1': device_add
[   14.827643] PM: Adding info for No Bus:ttyv1
[   14.832155] device: 'ttyv2': device_add
[   14.836060] PM: Adding info for No Bus:ttyv2
[   14.840593] device: 'ttyv3': device_add
[   14.844491] PM: Adding info for No Bus:ttyv3
[   14.848987] device: 'ttyv4': device_add
[   14.852898] PM: Adding info for No Bus:ttyv4
[   14.857395] device: 'ttyv5': device_add
[   14.861301] PM: Adding info for No Bus:ttyv5
[   14.865804] device: 'ttyv6': device_add
[   14.869702] PM: Adding info for No Bus:ttyv6
[   14.874212] device: 'ttyv7': device_add
[   14.878112] PM: Adding info for No Bus:ttyv7
[   14.882724] device: 'ttyv8': device_add
[   14.886617] PM: Adding info for No Bus:ttyv8
[   14.891144] device: 'ttyv9': device_add
[   14.895037] PM: Adding info for No Bus:ttyv9
[   14.899545] device: 'ttyva': device_add
[   14.903453] PM: Adding info for No Bus:ttyva
[   14.907947] device: 'ttyvb': device_add
[   14.911867] PM: Adding info for No Bus:ttyvb
[   14.916382] device: 'ttyvc': device_add
[   14.920323] PM: Adding info for No Bus:ttyvc
[   14.924830] device: 'ttyvd': device_add
[   14.928720] PM: Adding info for No Bus:ttyvd
[   14.933236] device: 'ttyve': device_add
[   14.937136] PM: Adding info for No Bus:ttyve
[   14.941658] device: 'ttyvf': device_add
[   14.945566] PM: Adding info for No Bus:ttyvf
[   14.950069] device: 'ttyw0': device_add
[   14.953958] PM: Adding info for No Bus:ttyw0
[   14.958470] device: 'ttyw1': device_add
[   14.962379] PM: Adding info for No Bus:ttyw1
[   14.966884] device: 'ttyw2': device_add
[   14.970798] PM: Adding info for No Bus:ttyw2
[   14.975299] device: 'ttyw3': device_add
[   14.979190] PM: Adding info for No Bus:ttyw3
[   14.983756] device: 'ttyw4': device_add
[   14.987648] PM: Adding info for No Bus:ttyw4
[   14.992166] device: 'ttyw5': device_add
[   14.996061] PM: Adding info for No Bus:ttyw5
[   15.000580] device: 'ttyw6': device_add
[   15.004479] PM: Adding info for No Bus:ttyw6
[   15.008986] device: 'ttyw7': device_add
[   15.012893] PM: Adding info for No Bus:ttyw7
[   15.017393] device: 'ttyw8': device_add
[   15.021297] PM: Adding info for No Bus:ttyw8
[   15.025795] device: 'ttyw9': device_add
[   15.029688] PM: Adding info for No Bus:ttyw9
[   15.034216] device: 'ttywa': device_add
[   15.038116] PM: Adding info for No Bus:ttywa
[   15.042737] device: 'ttywb': device_add
[   15.046634] PM: Adding info for No Bus:ttywb
[   15.051190] device: 'ttywc': device_add
[   15.055092] PM: Adding info for No Bus:ttywc
[   15.059604] device: 'ttywd': device_add
[   15.063529] PM: Adding info for No Bus:ttywd
[   15.068028] device: 'ttywe': device_add
[   15.071939] PM: Adding info for No Bus:ttywe
[   15.076436] device: 'ttywf': device_add
[   15.080383] PM: Adding info for No Bus:ttywf
[   15.084888] device: 'ttyx0': device_add
[   15.088778] PM: Adding info for No Bus:ttyx0
[   15.093292] device: 'ttyx1': device_add
[   15.097198] PM: Adding info for No Bus:ttyx1
[   15.101715] device: 'ttyx2': device_add
[   15.105608] PM: Adding info for No Bus:ttyx2
[   15.110105] device: 'ttyx3': device_add
[   15.114000] PM: Adding info for No Bus:ttyx3
[   15.118519] device: 'ttyx4': device_add
[   15.122439] PM: Adding info for No Bus:ttyx4
[   15.126942] device: 'ttyx5': device_add
[   15.130866] PM: Adding info for No Bus:ttyx5
[   15.135362] device: 'ttyx6': device_add
[   15.139253] PM: Adding info for No Bus:ttyx6
[   15.143819] device: 'ttyx7': device_add
[   15.147717] PM: Adding info for No Bus:ttyx7
[   15.152247] device: 'ttyx8': device_add
[   15.156159] PM: Adding info for No Bus:ttyx8
[   15.160683] device: 'ttyx9': device_add
[   15.164581] PM: Adding info for No Bus:ttyx9
[   15.169080] device: 'ttyxa': device_add
[   15.172994] PM: Adding info for No Bus:ttyxa
[   15.177495] device: 'ttyxb': device_add
[   15.181408] PM: Adding info for No Bus:ttyxb
[   15.185904] device: 'ttyxc': device_add
[   15.189815] PM: Adding info for No Bus:ttyxc
[   15.194330] device: 'ttyxd': device_add
[   15.198224] PM: Adding info for No Bus:ttyxd
[   15.202771] device: 'ttyxe': device_add
[   15.206663] PM: Adding info for No Bus:ttyxe
[   15.211173] device: 'ttyxf': device_add
[   15.215072] PM: Adding info for No Bus:ttyxf
[   15.219575] device: 'ttyy0': device_add
[   15.223496] PM: Adding info for No Bus:ttyy0
[   15.227993] device: 'ttyy1': device_add
[   15.231899] PM: Adding info for No Bus:ttyy1
[   15.236395] device: 'ttyy2': device_add
[   15.240308] PM: Adding info for No Bus:ttyy2
[   15.244814] device: 'ttyy3': device_add
[   15.248710] PM: Adding info for No Bus:ttyy3
[   15.253229] device: 'ttyy4': device_add
[   15.257145] PM: Adding info for No Bus:ttyy4
[   15.261659] device: 'ttyy5': device_add
[   15.265570] PM: Adding info for No Bus:ttyy5
[   15.270084] device: 'ttyy6': device_add
[   15.273983] PM: Adding info for No Bus:ttyy6
[   15.278503] device: 'ttyy7': device_add
[   15.282430] PM: Adding info for No Bus:ttyy7
[   15.286940] device: 'ttyy8': device_add
[   15.290856] PM: Adding info for No Bus:ttyy8
[   15.295355] device: 'ttyy9': device_add
[   15.299250] PM: Adding info for No Bus:ttyy9
[   15.303817] device: 'ttyya': device_add
[   15.307715] PM: Adding info for No Bus:ttyya
[   15.312227] device: 'ttyyb': device_add
[   15.316139] PM: Adding info for No Bus:ttyyb
[   15.320658] device: 'ttyyc': device_add
[   15.324551] PM: Adding info for No Bus:ttyyc
[   15.329050] device: 'ttyyd': device_add
[   15.332966] PM: Adding info for No Bus:ttyyd
[   15.337512] device: 'ttyye': device_add
[   15.341422] PM: Adding info for No Bus:ttyye
[   15.345926] device: 'ttyyf': device_add
[   15.349835] PM: Adding info for No Bus:ttyyf
[   15.354349] device: 'ttyz0': device_add
[   15.358246] PM: Adding info for No Bus:ttyz0
[   15.362773] device: 'ttyz1': device_add
[   15.366670] PM: Adding info for No Bus:ttyz1
[   15.371184] device: 'ttyz2': device_add
[   15.375100] PM: Adding info for No Bus:ttyz2
[   15.379605] device: 'ttyz3': device_add
[   15.383521] PM: Adding info for No Bus:ttyz3
[   15.388035] device: 'ttyz4': device_add
[   15.391954] PM: Adding info for No Bus:ttyz4
[   15.396454] device: 'ttyz5': device_add
[   15.400366] PM: Adding info for No Bus:ttyz5
[   15.404859] device: 'ttyz6': device_add
[   15.408766] PM: Adding info for No Bus:ttyz6
[   15.413285] device: 'ttyz7': device_add
[   15.417183] PM: Adding info for No Bus:ttyz7
[   15.421696] device: 'ttyz8': device_add
[   15.425595] PM: Adding info for No Bus:ttyz8
[   15.430098] device: 'ttyz9': device_add
[   15.433993] PM: Adding info for No Bus:ttyz9
[   15.438517] device: 'ttyza': device_add
[   15.442458] PM: Adding info for No Bus:ttyza
[   15.446968] device: 'ttyzb': device_add
[   15.450888] PM: Adding info for No Bus:ttyzb
[   15.455389] device: 'ttyzc': device_add
[   15.459283] PM: Adding info for No Bus:ttyzc
[   15.463847] device: 'ttyzd': device_add
[   15.467746] PM: Adding info for No Bus:ttyzd
[   15.472264] device: 'ttyze': device_add
[   15.476170] PM: Adding info for No Bus:ttyze
[   15.480701] device: 'ttyzf': device_add
[   15.484602] PM: Adding info for No Bus:ttyzf
[   15.489099] device: 'ttya0': device_add
[   15.493016] PM: Adding info for No Bus:ttya0
[   15.497558] device: 'ttya1': device_add
[   15.501482] PM: Adding info for No Bus:ttya1
[   15.505998] device: 'ttya2': device_add
[   15.509899] PM: Adding info for No Bus:ttya2
[   15.514417] device: 'ttya3': device_add
[   15.518313] PM: Adding info for No Bus:ttya3
[   15.522828] device: 'ttya4': device_add
[   15.526726] PM: Adding info for No Bus:ttya4
[   15.531242] device: 'ttya5': device_add
[   15.535155] PM: Adding info for No Bus:ttya5
[   15.539653] device: 'ttya6': device_add
[   15.543567] PM: Adding info for No Bus:ttya6
[   15.548078] device: 'ttya7': device_add
[   15.551994] PM: Adding info for No Bus:ttya7
[   15.556495] device: 'ttya8': device_add
[   15.560406] PM: Adding info for No Bus:ttya8
[   15.564907] device: 'ttya9': device_add
[   15.568818] PM: Adding info for No Bus:ttya9
[   15.573343] device: 'ttyaa': device_add
[   15.577237] PM: Adding info for No Bus:ttyaa
[   15.581753] device: 'ttyab': device_add
[   15.585666] PM: Adding info for No Bus:ttyab
[   15.590194] device: 'ttyac': device_add
[   15.594118] PM: Adding info for No Bus:ttyac
[   15.598638] device: 'ttyad': device_add
[   15.602568] PM: Adding info for No Bus:ttyad
[   15.607078] device: 'ttyae': device_add
[   15.610997] PM: Adding info for No Bus:ttyae
[   15.615497] device: 'ttyaf': device_add
[   15.619393] PM: Adding info for No Bus:ttyaf
[   15.624003] device: 'ttyb0': device_add
[   15.627920] PM: Adding info for No Bus:ttyb0
[   15.632450] device: 'ttyb1': device_add
[   15.636348] PM: Adding info for No Bus:ttyb1
[   15.640869] device: 'ttyb2': device_add
[   15.644780] PM: Adding info for No Bus:ttyb2
[   15.649334] device: 'ttyb3': device_add
[   15.653269] PM: Adding info for No Bus:ttyb3
[   15.657773] device: 'ttyb4': device_add
[   15.661698] PM: Adding info for No Bus:ttyb4
[   15.666195] device: 'ttyb5': device_add
[   15.670113] PM: Adding info for No Bus:ttyb5
[   15.674611] device: 'ttyb6': device_add
[   15.678509] PM: Adding info for No Bus:ttyb6
[   15.683025] device: 'ttyb7': device_add
[   15.686925] PM: Adding info for No Bus:ttyb7
[   15.691435] device: 'ttyb8': device_add
[   15.695355] PM: Adding info for No Bus:ttyb8
[   15.699856] device: 'ttyb9': device_add
[   15.703773] PM: Adding info for No Bus:ttyb9
[   15.708271] device: 'ttyba': device_add
[   15.712185] PM: Adding info for No Bus:ttyba
[   15.716686] device: 'ttybb': device_add
[   15.720613] PM: Adding info for No Bus:ttybb
[   15.725116] device: 'ttybc': device_add
[   15.729022] PM: Adding info for No Bus:ttybc
[   15.733538] device: 'ttybd': device_add
[   15.737435] PM: Adding info for No Bus:ttybd
[   15.741962] device: 'ttybe': device_add
[   15.745862] PM: Adding info for No Bus:ttybe
[   15.750390] device: 'ttybf': device_add
[   15.754317] PM: Adding info for No Bus:ttybf
[   15.758820] device: 'ttyc0': device_add
[   15.762735] PM: Adding info for No Bus:ttyc0
[   15.767235] device: 'ttyc1': device_add
[   15.771155] PM: Adding info for No Bus:ttyc1
[   15.775653] device: 'ttyc2': device_add
[   15.779554] PM: Adding info for No Bus:ttyc2
[   15.784070] device: 'ttyc3': device_add
[   15.787982] PM: Adding info for No Bus:ttyc3
[   15.792501] device: 'ttyc4': device_add
[   15.796404] PM: Adding info for No Bus:ttyc4
[   15.800927] device: 'ttyc5': device_add
[   15.804843] PM: Adding info for No Bus:ttyc5
[   15.809341] device: 'ttyc6': device_add
[   15.813270] PM: Adding info for No Bus:ttyc6
[   15.817767] device: 'ttyc7': device_add
[   15.821686] PM: Adding info for No Bus:ttyc7
[   15.826182] device: 'ttyc8': device_add
[   15.830098] PM: Adding info for No Bus:ttyc8
[   15.834635] device: 'ttyc9': device_add
[   15.838532] PM: Adding info for No Bus:ttyc9
[   15.843047] device: 'ttyca': device_add
[   15.847018] PM: Adding info for No Bus:ttyca
[   15.851545] device: 'ttycb': device_add
[   15.855470] PM: Adding info for No Bus:ttycb
[   15.859991] device: 'ttycc': device_add
[   15.863914] PM: Adding info for No Bus:ttycc
[   15.868421] device: 'ttycd': device_add
[   15.872339] PM: Adding info for No Bus:ttycd
[   15.876837] device: 'ttyce': device_add
[   15.880770] PM: Adding info for No Bus:ttyce
[   15.885273] device: 'ttycf': device_add
[   15.889172] PM: Adding info for No Bus:ttycf
[   15.893690] device: 'ttyd0': device_add
[   15.897595] PM: Adding info for No Bus:ttyd0
[   15.902105] device: 'ttyd1': device_add
[   15.906003] PM: Adding info for No Bus:ttyd1
[   15.910533] device: 'ttyd2': device_add
[   15.914449] PM: Adding info for No Bus:ttyd2
[   15.918950] device: 'ttyd3': device_add
[   15.922869] PM: Adding info for No Bus:ttyd3
[   15.927368] device: 'ttyd4': device_add
[   15.931284] PM: Adding info for No Bus:ttyd4
[   15.935782] device: 'ttyd5': device_add
[   15.939694] PM: Adding info for No Bus:ttyd5
[   15.944213] device: 'ttyd6': device_add
[   15.948117] PM: Adding info for No Bus:ttyd6
[   15.952763] device: 'ttyd7': device_add
[   15.956674] PM: Adding info for No Bus:ttyd7
[   15.961223] device: 'ttyd8': device_add
[   15.965145] PM: Adding info for No Bus:ttyd8
[   15.969656] device: 'ttyd9': device_add
[   15.973602] PM: Adding info for No Bus:ttyd9
[   15.978117] device: 'ttyda': device_add
[   15.982041] PM: Adding info for No Bus:ttyda
[   15.986541] device: 'ttydb': device_add
[   15.990503] PM: Adding info for No Bus:ttydb
[   15.995010] device: 'ttydc': device_add
[   15.998913] PM: Adding info for No Bus:ttydc
[   16.003432] device: 'ttydd': device_add
[   16.007349] PM: Adding info for No Bus:ttydd
[   16.011900] device: 'ttyde': device_add
[   16.015816] PM: Adding info for No Bus:ttyde
[   16.020336] device: 'ttydf': device_add
[   16.024241] PM: Adding info for No Bus:ttydf
[   16.028738] device: 'ttye0': device_add
[   16.032680] PM: Adding info for No Bus:ttye0
[   16.037184] device: 'ttye1': device_add
[   16.041105] PM: Adding info for No Bus:ttye1
[   16.045605] device: 'ttye2': device_add
[   16.049507] PM: Adding info for No Bus:ttye2
[   16.054047] device: 'ttye3': device_add
[   16.057957] PM: Adding info for No Bus:ttye3
[   16.062479] device: 'ttye4': device_add
[   16.066394] PM: Adding info for No Bus:ttye4
[   16.070911] device: 'ttye5': device_add
[   16.074821] PM: Adding info for No Bus:ttye5
[   16.079316] device: 'ttye6': device_add
[   16.083240] PM: Adding info for No Bus:ttye6
[   16.087742] device: 'ttye7': device_add
[   16.091663] PM: Adding info for No Bus:ttye7
[   16.096173] device: 'ttye8': device_add
[   16.100115] PM: Adding info for No Bus:ttye8
[   16.104619] device: 'ttye9': device_add
[   16.108523] PM: Adding info for No Bus:ttye9
[   16.113040] device: 'ttyea': device_add
[   16.116945] PM: Adding info for No Bus:ttyea
[   16.121461] device: 'ttyeb': device_add
[   16.125385] PM: Adding info for No Bus:ttyeb
[   16.129889] device: 'ttyec': device_add
[   16.133826] PM: Adding info for No Bus:ttyec
[   16.138320] device: 'ttyed': device_add
[   16.142244] PM: Adding info for No Bus:ttyed
[   16.146748] device: 'ttyee': device_add
[   16.150667] PM: Adding info for No Bus:ttyee
[   16.155180] device: 'ttyef': device_add
[   16.159097] PM: Adding info for No Bus:ttyef
[   16.163654] device: 'ptmx': device_add
[   16.167476] PM: Adding info for No Bus:ptmx
[   16.171906] initcall pty_init+0x0/0x39 returned 0 after 4213661 usecs
[   16.178335] calling  sysrq_init+0x0/0x4c @ 1
[   16.182653] initcall sysrq_init+0x0/0x4c returned 0 after 24 usecs
[   16.188823] calling  xen_init+0x0/0xbb @ 1
[   16.192941] initcall xen_init+0x0/0xbb returned -19 after 1 usecs
[   16.199022] calling  applicom_init+0x0/0x507 @ 1
[   16.203658] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   16.210814] ac.o: No PCI boards found.
[   16.214562] ac.o: For an ISA board you must supply memory and irq parameters.
[   16.221705] initcall applicom_init+0x0/0x507 returned -6 after 17621 usecs
[   16.228567] initcall applicom_init+0x0/0x507 returned with error code -6 
[   16.235370] calling  nvram_init+0x0/0xaa @ 1
[   16.239644] device: 'nvram': device_add
[   16.243549] PM: Adding info for No Bus:nvram
[   16.248061] Non-volatile memory driver v1.3
[   16.252256] initcall nvram_init+0x0/0xaa returned 0 after 12318 usecs
[   16.258685] calling  mwave_init+0x0/0x2d1 @ 1
[   16.263068] smapi::smapi_init, ERROR invalid usSmapiID
[   16.268200] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   16.277514] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   16.284741] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   16.291019] initcall mwave_init+0x0/0x2d1 returned -5 after 27301 usecs
[   16.297623] initcall mwave_init+0x0/0x2d1 returned with error code -5 
[   16.304165] calling  agp_init+0x0/0x4b @ 1
[   16.308260] Linux agpgart interface v0.103
[   16.312372] initcall agp_init+0x0/0x4b returned 0 after 4011 usecs
[   16.318544] calling  agp_intel_init+0x0/0x50 @ 1
[   16.323176] bus: 'pci': add driver agpgart-intel
[   16.328082] initcall agp_intel_init+0x0/0x50 returned 0 after 4792 usecs
[   16.334796] calling  agp_via_init+0x0/0x50 @ 1
[   16.339234] bus: 'pci': add driver agpgart-via
[   16.343977] initcall agp_via_init+0x0/0x50 returned 0 after 4627 usecs
[   16.350517] calling  drm_core_init+0x0/0x145 @ 1
[   16.355139] device class 'drm': registering
[   16.359634] [drm] Initialized drm 1.1.0 20060810
[   16.364263] initcall drm_core_init+0x0/0x145 returned 0 after 8916 usecs
[   16.370966] calling  sis_init+0x0/0x45 @ 1
[   16.375172] initcall sis_init+0x0/0x45 returned 0 after 105 usecs
[   16.381275] calling  savage_init+0x0/0x45 @ 1
[   16.385921] initcall savage_init+0x0/0x45 returned 0 after 287 usecs
[   16.392289] calling  serial8250_init+0x0/0x16f @ 1
[   16.397076] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   16.403418] Registering platform device 'serial8250'. Parent at platform
[   16.410125] device: 'serial8250': device_add
[   16.414402] bus: 'platform': add device serial8250
[   16.419212] PM: Adding info for platform:serial8250
[   16.424550] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   16.430579] device: 'ttyS0': device_add
[   16.434716] PM: Adding info for No Bus:ttyS0
[   16.439469] device: 'ttyS1': device_add
[   16.443435] PM: Adding info for No Bus:ttyS1
[   16.447975] device: 'ttyS2': device_add
[   16.451919] PM: Adding info for No Bus:ttyS2
[   16.456450] device: 'ttyS3': device_add
[   16.460388] PM: Adding info for No Bus:ttyS3
[   16.464895] bus: 'platform': add driver serial8250
[   16.469699] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   16.478662] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   16.487036] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   16.494096] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   16.502352] initcall serial8250_init+0x0/0x16f returned 0 after 102800 usecs
[   16.509394] calling  max3100_init+0x0/0x39 @ 1
[   16.513860] bus: 'spi': add driver max3100
[   16.518194] initcall max3100_init+0x0/0x39 returned 0 after 4232 usecs
[   16.524733] calling  jsm_init_module+0x0/0x6e @ 1
[   16.529510] bus: 'pci': add driver jsm
[   16.533558] initcall jsm_init_module+0x0/0x6e returned 0 after 4023 usecs
[   16.540353] calling  topology_sysfs_init+0x0/0xba @ 1
[   16.545452] initcall topology_sysfs_init+0x0/0xba returned 0 after 52 usecs
[   16.552422] calling  brd_init+0x0/0x193 @ 1
[   16.557210] device: 'ram0': device_add
[   16.561054] PM: Adding info for No Bus:ram0
[   16.565663] device: '1:0': device_add
[   16.569356] PM: Adding info for No Bus:1:0
[   16.573736] device: 'ram1': device_add
[   16.577544] PM: Adding info for No Bus:ram1
[   16.582075] device: '1:1': device_add
[   16.585780] PM: Adding info for No Bus:1:1
[   16.590134] device: 'ram2': device_add
[   16.593933] PM: Adding info for No Bus:ram2
[   16.598474] device: '1:2': device_add
[   16.602185] PM: Adding info for No Bus:1:2
[   16.606549] device: 'ram3': device_add
[   16.610373] PM: Adding info for No Bus:ram3
[   16.614883] device: '1:3': device_add
[   16.618583] PM: Adding info for No Bus:1:3
[   16.623002] device: 'ram4': device_add
[   16.626805] PM: Adding info for No Bus:ram4
[   16.631309] device: '1:4': device_add
[   16.634997] PM: Adding info for No Bus:1:4
[   16.639349] device: 'ram5': device_add
[   16.643188] PM: Adding info for No Bus:ram5
[   16.647673] device: '1:5': device_add
[   16.651375] PM: Adding info for No Bus:1:5
[   16.655728] device: 'ram6': device_add
[   16.659540] PM: Adding info for No Bus:ram6
[   16.664034] device: '1:6': device_add
[   16.667722] PM: Adding info for No Bus:1:6
[   16.672135] device: 'ram7': device_add
[   16.675936] PM: Adding info for No Bus:ram7
[   16.680438] device: '1:7': device_add
[   16.684128] PM: Adding info for No Bus:1:7
[   16.688478] device: 'ram8': device_add
[   16.692308] PM: Adding info for No Bus:ram8
[   16.696788] device: '1:8': device_add
[   16.700508] PM: Adding info for No Bus:1:8
[   16.704877] device: 'ram9': device_add
[   16.708679] PM: Adding info for No Bus:ram9
[   16.713186] device: '1:9': device_add
[   16.716879] PM: Adding info for No Bus:1:9
[   16.721245] device: 'ram10': device_add
[   16.725146] PM: Adding info for No Bus:ram10
[   16.729737] device: '1:10': device_add
[   16.733537] PM: Adding info for No Bus:1:10
[   16.737977] device: 'ram11': device_add
[   16.741881] PM: Adding info for No Bus:ram11
[   16.746457] device: '1:11': device_add
[   16.750255] PM: Adding info for No Bus:1:11
[   16.754694] device: 'ram12': device_add
[   16.758590] PM: Adding info for No Bus:ram12
[   16.763177] device: '1:12': device_add
[   16.766956] PM: Adding info for No Bus:1:12
[   16.771479] device: 'ram13': device_add
[   16.775378] PM: Adding info for No Bus:ram13
[   16.779954] device: '1:13': device_add
[   16.783761] PM: Adding info for No Bus:1:13
[   16.788198] device: 'ram14': device_add
[   16.792123] PM: Adding info for No Bus:ram14
[   16.796768] device: '1:14': device_add
[   16.800563] PM: Adding info for No Bus:1:14
[   16.805020] device: 'ram15': device_add
[   16.808919] PM: Adding info for No Bus:ram15
[   16.813500] device: '1:15': device_add
[   16.817284] PM: Adding info for No Bus:1:15
[   16.821734] brd: module loaded
[   16.824791] initcall brd_init+0x0/0x193 returned 0 after 261895 usecs
[   16.831240] calling  loop_init+0x0/0x1bc @ 1
[   16.835804] device: 'loop0': device_add
[   16.839690] PM: Adding info for No Bus:loop0
[   16.844280] device: '7:0': device_add
[   16.847971] PM: Adding info for No Bus:7:0
[   16.852335] device: 'loop1': device_add
[   16.856229] PM: Adding info for No Bus:loop1
[   16.860815] device: '7:1': device_add
[   16.864518] PM: Adding info for No Bus:7:1
[   16.868864] device: 'loop2': device_add
[   16.872773] PM: Adding info for No Bus:loop2
[   16.877385] device: '7:2': device_add
[   16.881093] PM: Adding info for No Bus:7:2
[   16.885444] device: 'loop3': device_add
[   16.889345] PM: Adding info for No Bus:loop3
[   16.893931] device: '7:3': device_add
[   16.897622] PM: Adding info for No Bus:7:3
[   16.902013] device: 'loop4': device_add
[   16.905909] PM: Adding info for No Bus:loop4
[   16.910495] device: '7:4': device_add
[   16.914195] PM: Adding info for No Bus:7:4
[   16.918561] device: 'loop5': device_add
[   16.922470] PM: Adding info for No Bus:loop5
[   16.927051] device: '7:5': device_add
[   16.930755] PM: Adding info for No Bus:7:5
[   16.935108] device: 'loop6': device_add
[   16.939006] PM: Adding info for No Bus:loop6
[   16.943581] device: '7:6': device_add
[   16.947283] PM: Adding info for No Bus:7:6
[   16.951644] device: 'loop7': device_add
[   16.955531] PM: Adding info for No Bus:loop7
[   16.960101] device: '7:7': device_add
[   16.963793] PM: Adding info for No Bus:7:7
[   16.968180] loop: module loaded
[   16.971341] initcall loop_init+0x0/0x1bc returned 0 after 132646 usecs
[   16.977863] calling  cpqarray_init+0x0/0x92 @ 1
[   16.982411] Compaq SMART2 Driver (v 2.6.0)
[   16.986507] bus: 'pci': add driver cpqarray
[   16.991141] bus: 'pci': remove driver cpqarray
[   16.995810] driver: 'cpqarray': driver_release
[   17.000315] initcall cpqarray_init+0x0/0x92 returned -19 after 17481 usecs
[   17.007181] calling  cciss_init+0x0/0x7a @ 1
[   17.011470] HP CISS Driver (v 3.6.20)
[   17.015416] bus: 'cciss': registered
[   17.018987] bus: 'pci': add driver cciss
[   17.023208] initcall cciss_init+0x0/0x7a returned 0 after 11459 usecs
[   17.029635] calling  carm_init+0x0/0x42 @ 1
[   17.033846] bus: 'pci': add driver sx8
[   17.037879] initcall carm_init+0x0/0x42 returned 0 after 3937 usecs
[   17.044162] calling  xlblk_init+0x0/0xa1 @ 1
[   17.048430] initcall xlblk_init+0x0/0xa1 returned -19 after 1 usecs
[   17.054710] calling  ics932s401_init+0x0/0x3b @ 1
[   17.059411] bus: 'i2c': add driver ics932s401
[   17.064023] i2c-core: driver [ics932s401] registered
[   17.068988] initcall ics932s401_init+0x0/0x3b returned 0 after 9353 usecs
[   17.075788] calling  lkdtm_module_init+0x0/0x22b @ 1
[   17.080759] lkdtm : Invalid command
[   17.084249] initcall lkdtm_module_init+0x0/0x22b returned -22 after 3409 usecs
[   17.091482] initcall lkdtm_module_init+0x0/0x22b returned with error code -22 
[   17.098692] calling  phantom_init+0x0/0x12f @ 1
[   17.103243] device class 'phantom': registering
[   17.108019] bus: 'pci': add driver phantom
[   17.112409] Phantom Linux Driver, version n0.9.8, init OK
[   17.117805] initcall phantom_init+0x0/0x12f returned 0 after 14224 usecs
[   17.124520] calling  init_kgdbts+0x0/0x3b @ 1
[   17.128874] initcall init_kgdbts+0x0/0x3b returned 0 after 1 usecs
[   17.135066] calling  c2port_init+0x0/0x77 @ 1
[   17.139418] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[   17.146655] device class 'c2port': registering
[   17.151339] initcall c2port_init+0x0/0x77 returned 0 after 11635 usecs
[   17.157861] calling  duramar2150_c2port_init+0x0/0x97 @ 1
[   17.163372] device: 'c2port0': device_add
[   17.167434] PM: Adding info for No Bus:c2port0
[   17.172192] c2port c2port0: C2 port uc added
[   17.176459] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[   17.184046] initcall duramar2150_c2port_init+0x0/0x97 returned 0 after 20276 usecs
[   17.191623] calling  cb710_init_module+0x0/0x42 @ 1
[   17.196499] bus: 'pci': add driver cb710
[   17.200716] initcall cb710_init_module+0x0/0x42 returned 0 after 4113 usecs
[   17.207667] calling  scsi_tgt_init+0x0/0xb1 @ 1
[   17.213088] device: 'tgt': device_add
[   17.216886] PM: Adding info for No Bus:tgt
[   17.221315] initcall scsi_tgt_init+0x0/0xb1 returned 0 after 8878 usecs
[   17.227922] calling  spi_transport_init+0x0/0x9f @ 1
[   17.232912] device class 'spi_transport': registering
[   17.238262] device class 'spi_host': registering
[   17.243181] initcall spi_transport_init+0x0/0x9f returned 0 after 10031 usecs
[   17.250325] calling  fc_transport_init+0x0/0x73 @ 1
[   17.255196] device class 'fc_host': registering
[   17.259966] device class 'fc_vports': registering
[   17.264958] device class 'fc_remote_ports': registering
[   17.270432] device class 'fc_transport': registering
[   17.275627] initcall fc_transport_init+0x0/0x73 returned 0 after 19946 usecs
[   17.282692] calling  iscsi_transport_init+0x0/0x173 @ 1
[   17.287913] Loading iSCSI transport class v2.0-870.
[   17.292805] device class 'iscsi_transport': registering
[   17.298263] device class 'iscsi_endpoint': registering
[   17.303648] device class 'iscsi_host': registering
[   17.308670] device class 'iscsi_connection': registering
[   17.314267] device class 'iscsi_session': registering
[   17.319684] initcall iscsi_transport_init+0x0/0x173 returned 0 after 31019 usecs
[   17.327086] calling  sas_transport_init+0x0/0xe1 @ 1
[   17.332059] device class 'sas_host': registering
[   17.336911] device class 'sas_phy': registering
[   17.341686] device class 'sas_port': registering
[   17.346533] device class 'sas_device': registering
[   17.351565] device class 'sas_end_device': registering
[   17.356937] device class 'sas_expander': registering
[   17.362157] initcall sas_transport_init+0x0/0xe1 returned 0 after 29390 usecs
[   17.369283] calling  sas_class_init+0x0/0x58 @ 1
[   17.374399] initcall sas_class_init+0x0/0x58 returned 0 after 465 usecs
[   17.381026] calling  srp_transport_init+0x0/0x65 @ 1
[   17.385986] device class 'srp_host': registering
[   17.390851] device class 'srp_remote_ports': registering
[   17.396396] initcall srp_transport_init+0x0/0x65 returned 0 after 10159 usecs
[   17.403542] calling  iscsi_sw_tcp_init+0x0/0x67 @ 1
[   17.408449] device: 'tcp': device_add
[   17.412154] PM: Adding info for No Bus:tcp
[   17.416533] iscsi: registered transport (tcp)
[   17.420906] initcall iscsi_sw_tcp_init+0x0/0x67 returned 0 after 12191 usecs
[   17.427947] calling  adpt_init+0x0/0xb1 @ 1
[   17.432153] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   17.437713] Detecting Adaptec I2O RAID controllers...
[   17.442799] initcall adpt_init+0x0/0xb1 returned -19 after 10395 usecs
[   17.449322] calling  arcmsr_module_init+0x0/0x42 @ 1
[   17.454306] bus: 'pci': add driver arcmsr
[   17.458606] initcall arcmsr_module_init+0x0/0x42 returned 0 after 4201 usecs
[   17.465667] calling  ahc_linux_init+0x0/0x8d @ 1
[   17.470301] bus: 'pci': add driver aic7xxx
[   17.474693] initcall ahc_linux_init+0x0/0x8d returned 0 after 4296 usecs
[   17.481405] calling  init_this_scsi_driver+0x0/0x10c @ 1
[   17.487239] initcall init_this_scsi_driver+0x0/0x10c returned -19 after 516 usecs
[   17.494732] calling  qla2x00_module_init+0x0/0x152 @ 1
[   17.500355] QLogic Fibre Channel HBA Driver: 8.03.01-k4
[   17.505576] bus: 'pci': add driver qla2xxx
[   17.510019] initcall qla2x00_module_init+0x0/0x152 returned 0 after 9909 usecs
[   17.517231] calling  qla4xxx_module_init+0x0/0x108 @ 1
[   17.522820] device: 'qla4xxx': device_add
[   17.526851] PM: Adding info for No Bus:qla4xxx
[   17.531537] iscsi: registered transport (qla4xxx)
[   17.536239] bus: 'pci': add driver qla4xxx
[   17.540648] QLogic iSCSI HBA Driver
[   17.544139] initcall qla4xxx_module_init+0x0/0x108 returned 0 after 21242 usecs
[   17.551458] calling  lpfc_init+0x0/0xfb @ 1
[   17.555637] Emulex LightPulse Fibre Channel SCSI driver 8.3.3
[   17.561395] Copyright(c) 2004-2009 Emulex.  All rights reserved.
[   17.567420] bus: 'pci': add driver lpfc
[   17.571548] initcall lpfc_init+0x0/0xfb returned 0 after 15532 usecs
[   17.577890] calling  megaraid_init+0x0/0xdb @ 1
[   17.582464] bus: 'pci': add driver megaraid_legacy
[   17.587535] initcall megaraid_init+0x0/0xdb returned 0 after 4972 usecs
[   17.594157] calling  atp870u_init+0x0/0x42 @ 1
[   17.598597] bus: 'pci': add driver atp870u
[   17.602979] initcall atp870u_init+0x0/0x42 returned 0 after 4275 usecs
[   17.609496] calling  ipr_init+0x0/0x5c @ 1
[   17.613615] ipr: IBM Power RAID SCSI Device Driver version: 2.4.3 (June 10, 2009)
[   17.621101] bus: 'pci': add driver ipr
[   17.625172] initcall ipr_init+0x0/0x5c returned 0 after 11285 usecs
[   17.631449] calling  mvs_init+0x0/0x79 @ 1
[   17.635572] bus: 'pci': add driver mvsas
[   17.639770] initcall mvs_init+0x0/0x79 returned 0 after 4123 usecs
[   17.645958] calling  init_st+0x0/0x129 @ 1
[   17.650065] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[   17.656326] device class 'scsi_tape': registering
[   17.661293] bus: 'scsi': add driver st
[   17.665301] initcall init_st+0x0/0x129 returned 0 after 14877 usecs
[   17.671578] calling  init_osst+0x0/0x160 @ 1
[   17.675843] osst :I: Tape driver with OnStream support version 0.99.4
[   17.675845] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   17.688989] device class 'onstream_tape': registering
[   17.694286] bus: 'scsi': add driver osst
[   17.698446] initcall init_osst+0x0/0x160 returned 0 after 22069 usecs
[   17.704892] calling  init_sd+0x0/0x125 @ 1
[   17.709041] device class 'scsi_disk': registering
[   17.713992] bus: 'scsi': add driver sd
[   17.717987] initcall init_sd+0x0/0x125 returned 0 after 8788 usecs
[   17.724175] calling  init_sr+0x0/0x6f @ 1
[   17.728184] bus: 'scsi': add driver sr
[   17.732188] initcall init_sr+0x0/0x6f returned 0 after 3909 usecs
[   17.738275] calling  init_sg+0x0/0x172 @ 1
[   17.742397] device class 'scsi_generic': registering
[   17.747733] initcall init_sg+0x0/0x172 returned 0 after 5214 usecs
[   17.753929] calling  init_ch_module+0x0/0xcd @ 1
[   17.758539] SCSI Media Changer driver v0.25 
[   17.762829] device class 'scsi_changer': registering
[   17.768035] bus: 'scsi': add driver ch
[   17.772038] initcall init_ch_module+0x0/0xcd returned 0 after 13176 usecs
[   17.778818] calling  ahci_init+0x0/0x42 @ 1
[   17.783024] bus: 'pci': add driver ahci
[   17.787161] initcall ahci_init+0x0/0x42 returned 0 after 4040 usecs
[   17.793440] calling  piix_init+0x0/0x50 @ 1
[   17.797620] bus: 'pci': add driver ata_piix
[   17.802101] initcall piix_init+0x0/0x50 returned 0 after 4373 usecs
[   17.808362] calling  pdc_ata_init+0x0/0x42 @ 1
[   17.812827] bus: 'pci': add driver sata_promise
[   17.817626] initcall pdc_ata_init+0x0/0x42 returned 0 after 4687 usecs
[   17.824163] calling  sil_init+0x0/0x42 @ 1
[   17.828257] bus: 'pci': add driver sata_sil
[   17.832742] initcall sil_init+0x0/0x42 returned 0 after 4377 usecs
[   17.838911] calling  vsc_sata_init+0x0/0x42 @ 1
[   17.843456] bus: 'pci': add driver sata_vsc
[   17.847906] initcall vsc_sata_init+0x0/0x42 returned 0 after 4345 usecs
[   17.854531] calling  nv_init+0x0/0x42 @ 1
[   17.858537] bus: 'pci': add driver sata_nv
[   17.862948] initcall nv_init+0x0/0x42 returned 0 after 4305 usecs
[   17.869038] calling  uli_init+0x0/0x42 @ 1
[   17.873158] bus: 'pci': add driver sata_uli
[   17.877610] initcall uli_init+0x0/0x42 returned 0 after 4348 usecs
[   17.883796] calling  mv_init+0x0/0x6e @ 1
[   17.887805] bus: 'pci': add driver sata_mv
[   17.892204] bus: 'platform': add driver sata_mv
[   17.896975] initcall mv_init+0x0/0x6e returned 0 after 8952 usecs
[   17.903081] calling  amd_init+0x0/0x42 @ 1
[   17.907175] bus: 'pci': add driver pata_amd
[   17.911402] bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
[   17.919908] bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
[   17.927976] pata_amd 0000:00:06.0: version 0.4.1
[   17.932727] pata_amd 0000:00:06.0: setting latency timer to 64
[   17.938884] scsi0 : pata_amd
[   17.942992] device: 'host0': device_add
[   17.946845] PM: Adding info for No Bus:host0
[   17.951138] device: 'host0': device_add
[   17.955057] PM: Adding info for No Bus:host0
[   17.959722] scsi1 : pata_amd
[   17.962627] device: 'host1': device_add
[   17.966536] PM: Adding info for No Bus:host1
[   17.970821] device: 'host1': device_add
[   17.974761] PM: Adding info for No Bus:host1
[   17.983942] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   17.990917] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   18.190552] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[   18.196831] ata1.00: 488397168 sectors, multi 1: LBA48 
[   18.202079] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
[   18.270506] ata1.00: configured for UDMA/100
[   18.274819] async_waiting @ 1449
[   18.278049] async_continuing @ 1449 after 2 usec
[   18.283634] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[   18.291739] device: 'target0:0:0': device_add
[   18.296250] PM: Adding info for No Bus:target0:0:0
[   18.301114] device: '0:0:0:0': device_add
[   18.305196] bus: 'scsi': add device 0:0:0:0
[   18.309419] PM: Adding info for scsi:0:0:0:0
[   18.314116] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver st
[   18.321779] bus: 'scsi': really_probe: probing driver st with device 0:0:0:0
[   18.328939] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver osst
[   18.336779] bus: 'scsi': really_probe: probing driver osst with device 0:0:0:0
[   18.344035] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[   18.351705] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[   18.358976] device: '0:0:0:0': device_add
[   18.363085] PM: Adding info for No Bus:0:0:0:0
[   18.368021] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[   18.375739] sd 0:0:0:0: [sda] Write Protect is off
[   18.380544] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   18.385701] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.394821] device: 'sda': device_add
[   18.398557] PM: Adding info for No Bus:sda
[   18.403702]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   18.509061] device: 'sda1': device_add
[   18.513110] PM: Adding info for No Bus:sda1
[   18.517418] device: 'sda2': device_add
[   18.521237] PM: Adding info for No Bus:sda2
[   18.525443] device: 'sda3': device_add
[   18.529244] PM: Adding info for No Bus:sda3
[   18.533466] device: 'sda5': device_add
[   18.537263] PM: Adding info for No Bus:sda5
[   18.541480] device: 'sda6': device_add
[   18.545288] PM: Adding info for No Bus:sda6
[   18.549498] device: 'sda7': device_add
[   18.553318] PM: Adding info for No Bus:sda7
[   18.557565] device: 'sda8': device_add
[   18.561391] PM: Adding info for No Bus:sda8
[   18.565595] device: 'sda9': device_add
[   18.569399] PM: Adding info for No Bus:sda9
[   18.573628] device: 'sda10': device_add
[   18.577521] PM: Adding info for No Bus:sda10
[   18.584520] device: '8:0': device_add
[   18.588229] PM: Adding info for No Bus:8:0
[   18.593294] sd 0:0:0:0: [sda] Attached SCSI disk
[   18.597905] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[   18.604060] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[   18.610772] device: '0:0:0:0': device_add
[   18.614820] PM: Adding info for No Bus:0:0:0:0
[   18.619865] device: 'sg0': device_add
[   18.623849] PM: Adding info for No Bus:sg0
[   18.628480] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.634051] device: '0:0:0:0': device_add
[   18.638304] PM: Adding info for No Bus:0:0:0:0
[   18.643319] async_waiting @ 1449
[   18.646547] async_continuing @ 1449 after 2 usec
[   18.811310] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[   18.817349] ata2: nv_mode_filter: 0x1f39f&0x701f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x701f (600:60:0x1c)
[   18.860221] ata2.01: configured for UDMA/33
[   18.865148] async_waiting @ 1449
[   18.868378] async_continuing @ 1449 after 1 usec
[   18.873483] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   18.881601] device: 'target1:0:1': device_add
[   18.885974] PM: Adding info for No Bus:target1:0:1
[   18.890789] device: '1:0:1:0': device_add
[   18.894865] bus: 'scsi': add device 1:0:1:0
[   18.899075] PM: Adding info for scsi:1:0:1:0
[   18.903614] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver st
[   18.911276] bus: 'scsi': really_probe: probing driver st with device 1:0:1:0
[   18.918346] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver osst
[   18.926190] bus: 'scsi': really_probe: probing driver osst with device 1:0:1:0
[   18.933446] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
[   18.941107] bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
[   18.948171] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sr
[   18.955838] bus: 'scsi': really_probe: probing driver sr with device 1:0:1:0
[   18.967193] sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
[   18.973904] Uniform CD-ROM driver Revision: 3.20
[   18.978642] device: 'sr0': device_add
[   18.982419] PM: Adding info for No Bus:sr0
[   18.986846] device: '11:0': device_add
[   18.990656] PM: Adding info for No Bus:11:0
[   18.995153] sr 1:0:1:0: Attached scsi CD-ROM sr0
[   18.999761] driver: '1:0:1:0': driver_bound: bound to device 'sr'
[   19.005872] bus: 'scsi': really_probe: bound device 1:0:1:0 to driver sr
[   19.012586] device: '1:0:1:0': device_add
[   19.016630] PM: Adding info for No Bus:1:0:1:0
[   19.021362] device: 'sg1': device_add
[   19.025132] PM: Adding info for No Bus:sg1
[   19.029477] sr 1:0:1:0: Attached scsi generic sg1 type 5
[   19.034822] device: '1:0:1:0': device_add
[   19.038908] PM: Adding info for No Bus:1:0:1:0
[   19.043658] work_for_cpu used greatest stack depth: 2432 bytes left
[   19.049947] driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
[   19.057011] bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
[   19.064866] initcall amd_init+0x0/0x42 returned 0 after 1130551 usecs
[   19.071312] calling  cmd640_init+0x0/0x42 @ 1
[   19.075671] bus: 'pci': add driver pata_cmd640
[   19.080433] initcall cmd640_init+0x0/0x42 returned 0 after 4650 usecs
[   19.086870] calling  hpt36x_init+0x0/0x42 @ 1
[   19.091249] bus: 'pci': add driver pata_hpt366
[   19.095956] initcall hpt36x_init+0x0/0x42 returned 0 after 4597 usecs
[   19.102410] calling  hpt37x_init+0x0/0x42 @ 1
[   19.106764] bus: 'pci': add driver pata_hpt37x
[   19.111505] initcall hpt37x_init+0x0/0x42 returned 0 after 4626 usecs
[   19.117940] calling  ninja32_init+0x0/0x42 @ 1
[   19.122407] bus: 'pci': add driver pata_ninja32
[   19.127219] initcall ninja32_init+0x0/0x42 returned 0 after 4699 usecs
[   19.133758] calling  oldpiix_init+0x0/0x42 @ 1
[   19.138197] bus: 'pci': add driver pata_oldpiix
[   19.143014] initcall oldpiix_init+0x0/0x42 returned 0 after 4701 usecs
[   19.149530] calling  pdc2027x_init+0x0/0x42 @ 1
[   19.154082] bus: 'pci': add driver pata_pdc2027x
[   19.158971] initcall pdc2027x_init+0x0/0x42 returned 0 after 4775 usecs
[   19.165597] calling  radisys_init+0x0/0x42 @ 1
[   19.170051] bus: 'pci': add driver pata_radisys
[   19.174861] initcall radisys_init+0x0/0x42 returned 0 after 4697 usecs
[   19.181397] calling  serverworks_init+0x0/0x42 @ 1
[   19.186185] bus: 'pci': add driver pata_serverworks
[   19.191353] initcall serverworks_init+0x0/0x42 returned 0 after 5043 usecs
[   19.198218] calling  sl82c105_init+0x0/0x42 @ 1
[   19.202772] bus: 'pci': add driver pata_sl82c105
[   19.207660] initcall sl82c105_init+0x0/0x42 returned 0 after 4774 usecs
[   19.214278] calling  e1000_init_module+0x0/0x8f @ 1
[   19.219151] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   19.225084] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   19.230924] bus: 'pci': add driver e1000e
[   19.235268] initcall e1000_init_module+0x0/0x8f returned 0 after 15733 usecs
[   19.242325] calling  jme_init_module+0x0/0x55 @ 1
[   19.247023] jme: JMicron JMC2XX ethernet driver version 1.0.4
[   19.252784] bus: 'pci': add driver jme
[   19.256816] initcall jme_init_module+0x0/0x55 returned 0 after 9557 usecs
[   19.263610] calling  gem_init+0x0/0x42 @ 1
[   19.267705] bus: 'pci': add driver gem
[   19.271743] initcall gem_init+0x0/0x42 returned 0 after 3941 usecs
[   19.277918] calling  vortex_init+0x0/0xd7 @ 1
[   19.282297] bus: 'pci': add driver 3c59x
[   19.286492] initcall vortex_init+0x0/0xd7 returned 0 after 4096 usecs
[   19.292946] calling  e100_init_module+0x0/0x81 @ 1
[   19.297731] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   19.303838] e100: Copyright(c) 1999-2006 Intel Corporation
[   19.309318] bus: 'pci': add driver e100
[   19.313446] initcall e100_init_module+0x0/0x81 returned 0 after 15341 usecs
[   19.320418] calling  sis900_init_module+0x0/0x42 @ 1
[   19.325380] bus: 'pci': add driver sis900
[   19.329713] initcall sis900_init_module+0x0/0x42 returned 0 after 4227 usecs
[   19.336775] calling  acenic_init+0x0/0x42 @ 1
[   19.341142] bus: 'pci': add driver acenic
[   19.345433] initcall acenic_init+0x0/0x42 returned 0 after 4191 usecs
[   19.351879] calling  ns83820_init+0x0/0x4e @ 1
[   19.356317] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   19.363120] bus: 'pci': add driver ns83820
[   19.367486] initcall ns83820_init+0x0/0x4e returned 0 after 10900 usecs
[   19.374109] calling  tg3_init+0x0/0x42 @ 1
[   19.378203] bus: 'pci': add driver tg3
[   19.382248] initcall tg3_init+0x0/0x42 returned 0 after 3947 usecs
[   19.388419] calling  ks8851_init+0x0/0x39 @ 1
[   19.392797] bus: 'spi': add driver ks8851
[   19.397049] initcall ks8851_init+0x0/0x39 returned 0 after 4152 usecs
[   19.403498] calling  velocity_init_module+0x0/0x68 @ 1
[   19.408632] bus: 'pci': add driver via-velocity
[   19.413476] initcall velocity_init_module+0x0/0x68 returned 0 after 4727 usecs
[   19.420708] calling  lxt_init+0x0/0x65 @ 1
[   19.424803] bus: 'mdio_bus': add driver LXT970
[   19.429493] bus: 'mdio_bus': add driver LXT971
[   19.434195] initcall lxt_init+0x0/0x65 returned 0 after 9168 usecs
[   19.440384] calling  et1011c_init+0x0/0x39 @ 1
[   19.444824] bus: 'mdio_bus': add driver ET1011C
[   19.449600] initcall et1011c_init+0x0/0x39 returned 0 after 4660 usecs
[   19.456140] calling  fixed_mdio_bus_init+0x0/0xf6 @ 1
[   19.461206] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   19.468421] device: 'Fixed MDIO bus.0': device_add
[   19.473241] bus: 'platform': add device Fixed MDIO bus.0
[   19.478577] PM: Adding info for platform:Fixed MDIO bus.0
[   19.484240] device: '0': device_add
[   19.487764] PM: Adding info for No Bus:0
[   19.491986] Fixed MDIO Bus: probed
[   19.495385] initcall fixed_mdio_bus_init+0x0/0xf6 returned 0 after 33387 usecs
[   19.502619] calling  mdio_gpio_init+0x0/0x39 @ 1
[   19.507232] bus: 'platform': add driver mdio-gpio
[   19.512201] initcall mdio_gpio_init+0x0/0x39 returned 0 after 4849 usecs
[   19.518894] calling  ns_init+0x0/0x39 @ 1
[   19.522927] bus: 'mdio_bus': add driver NatSemi DP83865
[   19.528405] initcall ns_init+0x0/0x39 returned 0 after 5349 usecs
[   19.534511] calling  sundance_init+0x0/0x42 @ 1
[   19.539040] bus: 'pci': add driver sundance
[   19.543523] initcall sundance_init+0x0/0x42 returned 0 after 4375 usecs
[   19.550146] calling  hamachi_init+0x0/0x42 @ 1
[   19.554587] bus: 'pci': add driver hamachi
[   19.558983] initcall hamachi_init+0x0/0x42 returned 0 after 4289 usecs
[   19.565521] calling  net_olddevs_init+0x0/0x45 @ 1
[   19.570328] initcall net_olddevs_init+0x0/0x45 returned 0 after 7 usecs
[   19.576935] calling  hp100_module_init+0x0/0x42 @ 1
[   19.581833] bus: 'pci': add driver hp100
[   19.586029] initcall hp100_module_init+0x0/0x42 returned 0 after 4097 usecs
[   19.592996] calling  init_nic+0x0/0x42 @ 1
[   19.597090] bus: 'pci': add driver forcedeth
[   19.601394] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
[   19.609987] bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
[   19.618133] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[   19.626908] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[   19.632676]   alloc irq_desc for 23 on node 0
[   19.637033]   alloc kstat_irqs on node 0
[   19.640991] IOAPIC[0]: Set routing entry (2-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
[   19.648467] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
[   19.656922] forcedeth 0000:00:0a.0: setting latency timer to 64
[   19.662928] nv_probe: set workaround bit for reversed mac addr
[   20.190219] device: 'eth0': device_add
[   20.194203] PM: Adding info for No Bus:eth0
[   20.198878] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   20.207248] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[   20.213643] driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
[   20.220788] bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
[   20.228727] initcall init_nic+0x0/0x42 returned 0 after 616826 usecs
[   20.235100] calling  rtl8139_init_module+0x0/0x42 @ 1
[   20.240169] bus: 'pci': add driver 8139too
[   20.244298] bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139too
[   20.252747] bus: 'pci': really_probe: probing driver 8139too with device 0000:05:07.0
[   20.260704] 8139too Fast Ethernet driver 0.9.28
[   20.266047] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   20.271859]   alloc irq_desc for 17 on node 0
[   20.276216]   alloc kstat_irqs on node 0
[   20.280190] IOAPIC[0]: Set routing entry (2-17 -> 0x71 -> IRQ 17 Mode:1 Active:1)
[   20.287668] 8139too 0000:05:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[   20.296199] device: 'eth1': device_add
[   20.300170] PM: Adding info for No Bus:eth1
[   20.304809] eth1: RealTek RTL8139 at 0xffffc9000095a000, 00:c0:df:03:68:5d, IRQ 17
[   20.312466] driver: '0000:05:07.0': driver_bound: bound to device '8139too'
[   20.319420] bus: 'pci': really_probe: bound device 0000:05:07.0 to driver 8139too
[   20.327184] initcall rtl8139_init_module+0x0/0x42 returned 0 after 84979 usecs
[   20.334437] calling  eql_init_module+0x0/0x89 @ 1
[   20.339137] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   20.347690] device: 'eql': device_add
[   20.351546] PM: Adding info for No Bus:eql
[   20.355933] initcall eql_init_module+0x0/0x89 returned 0 after 16397 usecs
[   20.362826] calling  rio_init+0x0/0x42 @ 1
[   20.366928] bus: 'pci': add driver dl2k
[   20.371062] initcall rio_init+0x0/0x42 returned 0 after 4038 usecs
[   20.377234] calling  xl_pci_init+0x0/0x42 @ 1
[   20.381619] bus: 'pci': add driver 3c359
[   20.385806] initcall xl_pci_init+0x0/0x42 returned 0 after 4088 usecs
[   20.392256] calling  catc_init+0x0/0x5e @ 1
[   20.396442] bus: 'usb': add driver catc
[   20.400543] usbcore: registered new interface driver catc
[   20.405940] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   20.411874] initcall catc_init+0x0/0x5e returned 0 after 15068 usecs
[   20.418218] calling  usb_rtl8150_init+0x0/0x4e @ 1
[   20.423028] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[   20.429891] bus: 'usb': add driver rtl8150
[   20.434259] usbcore: registered new interface driver rtl8150
[   20.439916] initcall usb_rtl8150_init+0x0/0x4e returned 0 after 16495 usecs
[   20.446888] calling  ipw_init+0x0/0xad @ 1
[   20.450993] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kdmprq
[   20.458377] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   20.464146] bus: 'pci': add driver ipw2200
[   20.468552] initcall ipw_init+0x0/0xad returned 0 after 17146 usecs
[   20.474829] calling  ieee80211_init+0x0/0x49 @ 1
[   20.479442] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   20.486067] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   20.494423] initcall ieee80211_init+0x0/0x49 returned 0 after 14625 usecs
[   20.501215] calling  atmel_init_module+0x0/0x42 @ 1
[   20.506093] bus: 'pci': add driver atmel
[   20.510305] initcall atmel_init_module+0x0/0x42 returned 0 after 4110 usecs
[   20.517260] calling  nsc_ircc_init+0x0/0x21e @ 1
[   20.521901] bus: 'platform': add driver nsc-ircc
[   20.526769] bus: 'pnp': add driver nsc-ircc
[   20.531269] bus: 'platform': remove driver nsc-ircc
[   20.536388] driver: 'nsc-ircc': driver_release
[   20.540865] bus: 'pnp': remove driver nsc-ircc
[   20.545541] driver: 'nsc-ircc': driver_release
[   20.549984] initcall nsc_ircc_init+0x0/0x21e returned -19 after 27429 usecs
[   20.556954] calling  w83977af_init+0x0/0x74 @ 1
[   20.561548] initcall w83977af_init+0x0/0x74 returned -19 after 52 usecs
[   20.568151] calling  smsc_ircc_init+0x0/0x106 @ 1
[   20.572875] bus: 'platform': add driver smsc-ircc2
[   20.578132] bus: 'platform': remove driver smsc-ircc2
[   20.583433] driver: 'smsc-ircc2': driver_release
[   20.588057] initcall smsc_ircc_init+0x0/0x106 returned -19 after 14829 usecs
[   20.595114] calling  vlsi_mod_init+0x0/0x151 @ 1
[   20.599746] bus: 'pci': add driver vlsi_ir
[   20.604133] initcall vlsi_mod_init+0x0/0x151 returned 0 after 4300 usecs
[   20.610844] calling  mcs_init+0x0/0x69 @ 1
[   20.614937] bus: 'usb': add driver mcs7780
[   20.619300] usbcore: registered new interface driver mcs7780
[   20.624975] initcall mcs_init+0x0/0x69 returned 0 after 9799 usecs
[   20.631164] calling  irtty_sir_init+0x0/0x65 @ 1
[   20.635782] initcall irtty_sir_init+0x0/0x65 returned 0 after 3 usecs
[   20.642233] calling  sir_wq_init+0x0/0x5c @ 1
[   20.646708] initcall sir_wq_init+0x0/0x5c returned 0 after 115 usecs
[   20.653077] calling  tekram_sir_init+0x0/0x52 @ 1
[   20.657838] initcall tekram_sir_init+0x0/0x52 returned 0 after 60 usecs
[   20.664464] calling  litelink_sir_init+0x0/0x39 @ 1
[   20.669339] initcall litelink_sir_init+0x0/0x39 returned 0 after 2 usecs
[   20.676050] calling  girbil_sir_init+0x0/0x39 @ 1
[   20.680768] initcall girbil_sir_init+0x0/0x39 returned 0 after 2 usecs
[   20.687284] calling  ma600_sir_init+0x0/0x39 @ 1
[   20.691922] initcall ma600_sir_init+0x0/0x39 returned 0 after 2 usecs
[   20.698349] calling  kingsun_init+0x0/0x42 @ 1
[   20.702815] bus: 'usb': add driver kingsun-sir
[   20.707504] usbcore: registered new interface driver kingsun-sir
[   20.713523] initcall kingsun_init+0x0/0x42 returned 0 after 10457 usecs
[   20.720144] calling  ks959_init+0x0/0x42 @ 1
[   20.724415] bus: 'usb': add driver ks959-sir
[   20.728931] usbcore: registered new interface driver ks959-sir
[   20.734783] initcall ks959_init+0x0/0x42 returned 0 after 10121 usecs
[   20.741231] calling  init_netconsole+0x0/0x13f @ 1
[   20.746028] console [netcon0] enabled
[   20.749689] netconsole: network logging started
[   20.754241] initcall init_netconsole+0x0/0x13f returned 0 after 8024 usecs
[   20.761121] calling  fusion_init+0x0/0x164 @ 1
[   20.765562] Fusion MPT base driver 3.04.10
[   20.769657] Copyright (c) 1999-2008 LSI Corporation
[   20.774580] initcall fusion_init+0x0/0x164 returned 0 after 8802 usecs
[   20.781116] calling  mptspi_init+0x0/0x102 @ 1
[   20.785557] Fusion MPT SPI Host driver 3.04.10
[   20.790028] bus: 'pci': add driver mptspi
[   20.794316] initcall mptspi_init+0x0/0x102 returned 0 after 8548 usecs
[   20.800852] calling  mptsas_init+0x0/0x130 @ 1
[   20.805290] Fusion MPT SAS Host driver 3.04.10
[   20.809762] bus: 'pci': add driver mptsas
[   20.814075] initcall mptsas_init+0x0/0x130 returned 0 after 8573 usecs
[   20.820610] calling  cdrom_init+0x0/0x91 @ 1
[   20.824880] initcall cdrom_init+0x0/0x91 returned 0 after 1 usecs
[   20.830984] calling  spidev_init+0x0/0xbf @ 1
[   20.835350] device class 'spidev': registering
[   20.840043] bus: 'spi': add driver spidev
[   20.844307] initcall spidev_init+0x0/0xbf returned 0 after 8752 usecs
[   20.850754] calling  aoe_init+0x0/0xd5 @ 1
[   20.854857] device class 'aoe': registering
[   20.859290] device: 'err': device_add
[   20.863073] PM: Adding info for No Bus:err
[   20.867474] device: 'discover': device_add
[   20.871640] PM: Adding info for No Bus:discover
[   20.876410] device: 'interfaces': device_add
[   20.880757] PM: Adding info for No Bus:interfaces
[   20.885694] device: 'revalidate': device_add
[   20.890026] PM: Adding info for No Bus:revalidate
[   20.894968] device: 'flush': device_add
[   20.898849] PM: Adding info for No Bus:flush
[   20.903831] aoe: AoE v47 initialised.
[   20.907629] initcall aoe_init+0x0/0xd5 returned 0 after 51542 usecs
[   20.913910] calling  uwb_subsys_init+0x0/0x77 @ 1
[   20.918623] device class 'uwb_rc': registering
[   20.923360] initcall uwb_subsys_init+0x0/0x77 returned 0 after 4636 usecs
[   20.930158] calling  gpio_vbus_init+0x0/0x40 @ 1
[   20.934773] bus: 'platform': add driver gpio-vbus
[   20.939745] bus: 'platform': remove driver gpio-vbus
[   20.944954] driver: 'gpio-vbus': driver_release
[   20.949482] initcall gpio_vbus_init+0x0/0x40 returned -19 after 14365 usecs
[   20.956454] calling  ehci_hcd_init+0x0/0xe9 @ 1
[   20.960993] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   20.967515] bus: 'pci': add driver ehci_hcd
[   20.971739] bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
[   20.980268] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
[   20.989721] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[   20.995493]   alloc irq_desc for 22 on node 0
[   20.999848]   alloc kstat_irqs on node 0
[   21.003809] IOAPIC[0]: Set routing entry (2-22 -> 0x79 -> IRQ 22 Mode:1 Active:1)
[   21.011300] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 22 (level, low) -> IRQ 22
[   21.019667] ehci_hcd 0000:00:02.1: setting latency timer to 64
[   21.025516] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   21.031571] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   21.039189] ehci_hcd 0000:00:02.1: debug port 1
[   21.043749] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[   21.050609] ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeb00000
[   21.070055] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[   21.076058] device: 'usb1': device_add
[   21.080155] bus: 'usb': add device usb1
[   21.084016] PM: Adding info for usb:usb1
[   21.088467] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[   21.095874] bus: 'usb': really_probe: probing driver usb with device usb1
[   21.102681] usb usb1: configuration #1 chosen from 1 choice
[   21.108470] device: '1-0:1.0': device_add
[   21.112668] bus: 'usb': add device 1-0:1.0
[   21.116803] PM: Adding info for usb:1-0:1.0
[   21.121309] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[   21.128953] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[   21.136036] hub 1-0:1.0: USB hub found
[   21.139875] hub 1-0:1.0: 10 ports detected
[   21.144338] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[   21.150527] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[   21.157254] device: 'ep_81': device_add
[   21.161167] PM: Adding info for No Bus:ep_81
[   21.165471] device: 'usbdev1.1': device_add
[   21.169890] PM: Adding info for No Bus:usbdev1.1
[   21.175111] driver: 'usb1': driver_bound: bound to device 'usb'
[   21.181042] bus: 'usb': really_probe: bound device usb1 to driver usb
[   21.187481] device: 'ep_00': device_add
[   21.191393] PM: Adding info for No Bus:ep_00
[   21.195718] driver: '0000:00:02.1': driver_bound: bound to device 'ehci_hcd'
[   21.202781] bus: 'pci': really_probe: bound device 0000:00:02.1 to driver ehci_hcd
[   21.210654] initcall ehci_hcd_init+0x0/0xe9 returned 0 after 243805 usecs
[   21.217431] calling  oxu_module_init+0x0/0x39 @ 1
[   21.222186] bus: 'platform': add driver oxu210hp-hcd
[   21.227408] initcall oxu_module_init+0x0/0x39 returned 0 after 5101 usecs
[   21.234207] calling  ohci_hcd_mod_init+0x0/0xbb @ 1
[   21.239082] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   21.245363] bus: 'pci': add driver ohci_hcd
[   21.249568] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
[   21.258108] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
[   21.267787] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[   21.273565]   alloc irq_desc for 21 on node 0
[   21.277919]   alloc kstat_irqs on node 0
[   21.281893] IOAPIC[0]: Set routing entry (2-21 -> 0x81 -> IRQ 21 Mode:1 Active:1)
[   21.289371] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 21 (level, low) -> IRQ 21
[   21.297760] ohci_hcd 0000:00:02.0: setting latency timer to 64
[   21.303604] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   21.308875] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   21.316404] ohci_hcd 0000:00:02.0: irq 21, io mem 0xda102000
[   21.372213] device: 'usb2': device_add
[   21.376153] bus: 'usb': add device usb2
[   21.380045] PM: Adding info for usb:usb2
[   21.384258] bus: 'usb': driver_probe_device: matched device usb2 with driver usb
[   21.391659] bus: 'usb': really_probe: probing driver usb with device usb2
[   21.398448] usb usb2: configuration #1 chosen from 1 choice
[   21.404064] device: '2-0:1.0': device_add
[   21.408113] bus: 'usb': add device 2-0:1.0
[   21.412244] PM: Adding info for usb:2-0:1.0
[   21.416663] bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
[   21.424322] bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
[   21.431398] hub 2-0:1.0: USB hub found
[   21.435201] hub 2-0:1.0: 10 ports detected
[   21.439443] driver: '2-0:1.0': driver_bound: bound to device 'hub'
[   21.445647] bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
[   21.452368] device: 'ep_81': device_add
[   21.456247] PM: Adding info for No Bus:ep_81
[   21.460543] device: 'usbdev2.1': device_add
[   21.464761] PM: Adding info for No Bus:usbdev2.1
[   21.469643] driver: 'usb2': driver_bound: bound to device 'usb'
[   21.475581] bus: 'usb': really_probe: bound device usb2 to driver usb
[   21.482057] device: 'ep_00': device_add
[   21.485948] PM: Adding info for No Bus:ep_00
[   21.490297] driver: '0000:00:02.0': driver_bound: bound to device 'ohci_hcd'
[   21.497342] bus: 'pci': really_probe: bound device 0000:00:02.0 to driver ohci_hcd
[   21.505198] initcall ohci_hcd_mod_init+0x0/0xbb returned 0 after 259870 usecs
[   21.512342] calling  uhci_hcd_init+0x0/0xe6 @ 1
[   21.516868] uhci_hcd: USB Universal Host Controller Interface driver
[   21.523768] bus: 'pci': add driver uhci_hcd
[   21.528250] initcall uhci_hcd_init+0x0/0xe6 returned 0 after 11110 usecs
[   21.534969] calling  u132_hcd_init+0x0/0xd8 @ 1
[   21.539496] driver u132_hcd built at 11:04:36 on Aug 17 2009
[   21.545540] bus: 'platform': add driver u132_hcd
[   21.550421] initcall u132_hcd_init+0x0/0xd8 returned 0 after 10664 usecs
[   21.557113] calling  wusbcore_init+0x0/0x9a @ 1
[   21.561979] initcall wusbcore_init+0x0/0x9a returned 0 after 302 usecs
[   21.568501] calling  cbaf_driver_init+0x0/0x42 @ 1
[   21.573316] bus: 'usb': add driver wusb-cbaf
[   21.577844] usbcore: registered new interface driver wusb-cbaf
[   21.583705] initcall cbaf_driver_init+0x0/0x42 returned 0 after 10146 usecs
[   21.590669] calling  usblp_init+0x0/0x42 @ 1
[   21.594938] bus: 'usb': add driver usblp
[   21.599133] usbcore: registered new interface driver usblp
[   21.604638] initcall usblp_init+0x0/0x42 returned 0 after 9469 usecs
[   21.611001] calling  wdm_init+0x0/0x42 @ 1
[   21.615096] bus: 'usb': add driver cdc_wdm
[   21.619445] usbcore: registered new interface driver cdc_wdm
[   21.625119] initcall wdm_init+0x0/0x42 returned 0 after 9784 usecs
[   21.631307] calling  usbtmc_init+0x0/0x5e @ 1
[   21.635662] bus: 'usb': add driver usbtmc
[   21.639924] usbcore: registered new interface driver usbtmc
[   21.645511] initcall usbtmc_init+0x0/0x5e returned 0 after 9614 usecs
[   21.651959] calling  usb_usual_init+0x0/0x66 @ 1
[   21.656624] bus: 'usb': add driver libusual
[   21.661311] usbcore: registered new interface driver libusual
[   21.667086] initcall usb_usual_init+0x0/0x66 returned 0 after 10263 usecs
[   21.673891] calling  microtek_drv_init+0x0/0x42 @ 1
[   21.678761] bus: 'usb': add driver microtekX6
[   21.683394] usbcore: registered new interface driver microtekX6
[   21.689313] initcall microtek_drv_init+0x0/0x42 returned 0 after 10304 usecs
[   21.696371] calling  usb_serial_init+0x0/0x25d @ 1
[   21.701439] bus: 'usb-serial': registered
[   21.705498] bus: 'usb': add driver usbserial
[   21.710041] usbcore: registered new interface driver usbserial
[   21.715870] usbserial: USB Serial Driver core
[   21.720249] initcall usb_serial_init+0x0/0x25d returned 0 after 18632 usecs
[   21.727196] calling  debug_init+0x0/0x6e @ 1
[   21.731489] bus: 'usb-serial': add driver debug
[   21.736262] USB Serial support registered for debug
[   21.741150] bus: 'usb': add driver debug
[   21.745339] usbcore: registered new interface driver debug
[   21.750843] initcall debug_init+0x0/0x6e returned 0 after 18900 usecs
[   21.757279] calling  edgeport_init+0x0/0x9c @ 1
[   21.761829] bus: 'usb-serial': add driver edgeport_ti_1
[   21.767307] USB Serial support registered for Edgeport TI 1 port adapter
[   21.774015] bus: 'usb-serial': add driver edgeport_ti_2
[   21.779488] USB Serial support registered for Edgeport TI 2 port adapter
[   21.786202] bus: 'usb': add driver io_ti
[   21.790391] usbcore: registered new interface driver io_ti
[   21.795871] io_ti: v0.7mode043006:Edgeport USB Serial Driver
[   21.801551] initcall edgeport_init+0x0/0x9c returned 0 after 38790 usecs
[   21.808246] calling  empeg_init+0x0/0x187 @ 1
[   21.813023] bus: 'usb-serial': add driver empeg
[   21.817801] USB Serial support registered for empeg
[   21.822686] bus: 'usb': add driver empeg
[   21.826881] usbcore: registered new interface driver empeg
[   21.832373] empeg: v1.2:USB Empeg Mark I/II Driver
[   21.837163] initcall empeg_init+0x0/0x187 returned 0 after 23965 usecs
[   21.843703] calling  funsoft_init+0x0/0x6e @ 1
[   21.848144] bus: 'usb-serial': add driver funsoft
[   21.853107] USB Serial support registered for funsoft
[   21.858150] bus: 'usb': add driver funsoft
[   21.862536] usbcore: registered new interface driver funsoft
[   21.868189] initcall funsoft_init+0x0/0x6e returned 0 after 19576 usecs
[   21.874817] calling  ir_init+0x0/0x7e @ 1
[   21.878823] bus: 'usb-serial': add driver ir-usb
[   21.883707] USB Serial support registered for IR Dongle
[   21.888926] bus: 'usb': add driver ir-usb
[   21.893230] usbcore: registered new interface driver ir-usb
[   21.898797] ir_usb: v0.4:USB IR Dongle driver
[   21.903176] initcall ir_init+0x0/0x7e returned 0 after 23779 usecs
[   21.909345] calling  iuu_init+0x0/0x7e @ 1
[   21.913462] bus: 'usb-serial': add driver iuu_phoenix
[   21.918753] USB Serial support registered for iuu_phoenix
[   21.924166] bus: 'usb': add driver iuu_phoenix
[   21.928877] usbcore: registered new interface driver iuu_phoenix
[   21.934893] iuu_phoenix: v0.10:Infinity USB Unlimited Phoenix driver
[   21.941253] initcall iuu_init+0x0/0x7e returned 0 after 27140 usecs
[   21.947512] calling  keyspan_init+0x0/0xdc @ 1
[   21.951976] bus: 'usb-serial': add driver keyspan_no_firm
[   21.957614] USB Serial support registered for Keyspan - (without firmware)
[   21.964501] bus: 'usb-serial': add driver keyspan_1
[   21.969616] USB Serial support registered for Keyspan 1 port adapter
[   21.975982] bus: 'usb-serial': add driver keyspan_2
[   21.981118] USB Serial support registered for Keyspan 2 port adapter
[   21.987465] bus: 'usb-serial': add driver keyspan_4
[   21.992688] USB Serial support registered for Keyspan 4 port adapter
[   21.999036] bus: 'usb': add driver keyspan
[   22.003414] usbcore: registered new interface driver keyspan
[   22.009062] keyspan: v1.1.5:Keyspan USB to Serial Converter Driver
[   22.015255] initcall keyspan_init+0x0/0xdc returned 0 after 61795 usecs
[   22.021878] calling  klsi_105_init+0x0/0x7e @ 1
[   22.026409] bus: 'usb-serial': add driver kl5kusb105d
[   22.031714] USB Serial support registered for KL5KUSB105D / PalmConnect
[   22.038322] bus: 'usb': add driver kl5kusb105d
[   22.043074] usbcore: registered new interface driver kl5kusb105d
[   22.049068] kl5kusb105: v0.3a:KLSI KL5KUSB105 chipset USB->Serial Converter driver
[   22.056654] initcall klsi_105_init+0x0/0x7e returned 0 after 29531 usecs
[   22.063358] calling  opticon_init+0x0/0x6e @ 1
[   22.067801] bus: 'usb-serial': add driver opticon
[   22.072764] USB Serial support registered for opticon
[   22.077807] bus: 'usb': add driver opticon
[   22.082193] usbcore: registered new interface driver opticon
[   22.087847] initcall opticon_init+0x0/0x6e returned 0 after 19576 usecs
[   22.094473] calling  pl2303_init+0x0/0x7e @ 1
[   22.098828] bus: 'usb-serial': add driver pl2303
[   22.103697] USB Serial support registered for pl2303
[   22.108662] bus: 'usb': add driver pl2303
[   22.112965] usbcore: registered new interface driver pl2303
[   22.118532] pl2303: Prolific PL2303 USB to serial adaptor driver
[   22.124558] initcall pl2303_init+0x0/0x7e returned 0 after 25123 usecs
[   22.131086] calling  siemens_usb_mpi_init+0x0/0x8c @ 1
[   22.136224] bus: 'usb-serial': add driver siemens_mpi
[   22.141544] USB Serial support registered for siemens_mpi
[   22.146933] bus: 'usb': add driver siemens_mpi
[   22.151639] usbcore: registered new interface driver siemens_mpi
[   22.157639] Driver for Siemens USB/MPI adapter
[   22.162098] Version 0.1 09/26/2005 Thomas Hergenhahn@web.de http://libnodave.sf.net
[   22.169744] initcall siemens_usb_mpi_init+0x0/0x8c returned 0 after 32735 usecs
[   22.177065] calling  spcp8x5_init+0x0/0x7e @ 1
[   22.181521] bus: 'usb-serial': add driver SPCP8x5
[   22.186462] USB Serial support registered for SPCP8x5
[   22.191523] bus: 'usb': add driver spcp8x5
[   22.195878] usbcore: registered new interface driver spcp8x5
[   22.201547] spcp8x5: v0.04:SPCP8x5 USB to serial adaptor driver
[   22.207462] initcall spcp8x5_init+0x0/0x7e returned 0 after 25337 usecs
[   22.214089] calling  symbol_init+0x0/0x6e @ 1
[   22.218444] bus: 'usb-serial': add driver symbol
[   22.223327] USB Serial support registered for symbol
[   22.228288] bus: 'usb': add driver symbol
[   22.232665] usbcore: registered new interface driver symbol
[   22.238231] initcall symbol_init+0x0/0x6e returned 0 after 19323 usecs
[   22.244770] calling  adu_init+0x0/0xba @ 1
[   22.248864] bus: 'usb': add driver adutux
[   22.253147] usbcore: registered new interface driver adutux
[   22.258718] adutux adutux (see www.ontrak.net) v0.0.13
[   22.263871] adutux is an experimental driver. Use at your own risk
[   22.270059] initcall adu_init+0x0/0xba returned 0 after 20694 usecs
[   22.276318] calling  appledisplay_init+0x0/0x80 @ 1
[   22.281324] bus: 'usb': add driver appledisplay
[   22.286101] usbcore: registered new interface driver appledisplay
[   22.292212] initcall appledisplay_init+0x0/0x80 returned 0 after 10739 usecs
[   22.299249] calling  ftdi_elan_init+0x0/0x192 @ 1
[   22.303983] driver ftdi-elan built at 11:04:35 on Aug 17 2009
[   22.310083] bus: 'usb': add driver ftdi-elan
[   22.314599] usbcore: registered new interface driver ftdi-elan
[   22.320447] initcall ftdi_elan_init+0x0/0x192 returned 0 after 16077 usecs
[   22.327312] calling  isight_firmware_init+0x0/0x42 @ 1
[   22.332470] bus: 'usb': add driver isight_firmware
[   22.337532] usbcore: registered new interface driver isight_firmware
[   22.343898] initcall isight_firmware_init+0x0/0x42 returned 0 after 11159 usecs
[   22.351212] calling  i8042_init+0x0/0x143 @ 1
[   22.355569] bus: 'pnp': add driver i8042 kbd
[   22.359858] bus: 'pnp': driver_probe_device: matched device 00:0b with driver i8042 kbd
[   22.367871] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0b
[   22.375284] driver: '00:0b': driver_bound: bound to device 'i8042 kbd'
[   22.381815] bus: 'pnp': really_probe: bound device 00:0b to driver i8042 kbd
[   22.389095] bus: 'pnp': add driver i8042 aux
[   22.393400] bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 aux
[   22.401408] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:0a
[   22.408807] driver: '00:0a': driver_bound: bound to device 'i8042 aux'
[   22.415347] bus: 'pnp': really_probe: bound device 00:0a to driver i8042 aux
[   22.422701] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   22.430356] bus: 'platform': add driver i8042
[   22.434975] Registering platform device 'i8042'. Parent at platform
[   22.441254] device: 'i8042': device_add
[   22.445098] bus: 'platform': add device i8042
[   22.449484] PM: Adding info for platform:i8042
[   22.454235] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   22.462329] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   22.472818] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.477854] serio: i8042 AUX port at 0x60,0x64 irq 12
[   22.482937] driver: 'i8042': driver_bound: bound to device 'i8042'
[   22.489111] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   22.496274] initcall i8042_init+0x0/0x143 returned 0 after 137401 usecs
[   22.502900] calling  serport_init+0x0/0x5a @ 1
[   22.507341] initcall serport_init+0x0/0x5a returned 0 after 3 usecs
[   22.513623] calling  fm801_gp_init+0x0/0x42 @ 1
[   22.518165] bus: 'pci': add driver FM801_gameport
[   22.523099] device: 'serio0': device_add
[   22.527140] bus: 'serio': add device serio0
[   22.531378] PM: Adding info for serio:serio0
[   22.536156] initcall fm801_gp_init+0x0/0x42 returned 0 after 17573 usecs
[   22.542877] calling  mousedev_init+0x0/0xb3 @ 1
[   22.547438] device: 'mice': device_add
[   22.551297] PM: Adding info for No Bus:mice
[   22.555760] device: 'serio1': device_add
[   22.559695] bus: 'serio': add device serio1
[   22.563941] PM: Adding info for serio:serio1
[   22.568360] device: 'psaux': device_add
[   22.572260] PM: Adding info for No Bus:psaux
[   22.576796] mice: PS/2 mouse device common for all mice
[   22.582020] initcall mousedev_init+0x0/0xb3 returned 0 after 33802 usecs
[   22.588734] calling  evdev_init+0x0/0x39 @ 1
[   22.593019] initcall evdev_init+0x0/0x39 returned 0 after 3 usecs
[   22.599108] calling  atkbd_init+0x0/0x4e @ 1
[   22.603403] bus: 'serio': add driver atkbd
[   22.607793] initcall atkbd_init+0x0/0x4e returned 0 after 4290 usecs
[   22.614155] calling  lkkbd_init+0x0/0x42 @ 1
[   22.618418] bus: 'serio': add driver lkkbd
[   22.622618] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   22.630066] initcall lkkbd_init+0x0/0x42 returned 0 after 11366 usecs
[   22.630071] calling  matrix_keypad_init+0x0/0x39 @ 1
[   22.630077] bus: 'platform': add driver matrix-keypad
[   22.630326] initcall matrix_keypad_init+0x0/0x39 returned 0 after 243 usecs
[   22.630330] calling  skbd_init+0x0/0x42 @ 1
[   22.630335] bus: 'serio': add driver stowaway
[   22.630641] initcall skbd_init+0x0/0x42 returned 0 after 298 usecs
[   22.630645] calling  xtkbd_init+0x0/0x42 @ 1
[   22.630650] bus: 'serio': add driver xtkbd
[   22.630908] initcall xtkbd_init+0x0/0x42 returned 0 after 250 usecs
[   22.630912] calling  adi_init+0x0/0x42 @ 1
[   22.630917] bus: 'gameport': add driver adi
[   22.631200] initcall adi_init+0x0/0x42 returned 0 after 276 usecs
[   22.631204] calling  grip_init+0x0/0x42 @ 1
[   22.631208] bus: 'gameport': add driver grip_mp
[   22.631473] initcall grip_init+0x0/0x42 returned 0 after 257 usecs
[   22.631477] calling  guillemot_init+0x0/0x42 @ 1
[   22.631482] bus: 'gameport': add driver guillemot
[   22.631729] initcall guillemot_init+0x0/0x42 returned 0 after 240 usecs
[   22.631733] calling  joydump_init+0x0/0x42 @ 1
[   22.631737] bus: 'gameport': add driver joydump
[   22.631998] initcall joydump_init+0x0/0x42 returned 0 after 253 usecs
[   22.632002] calling  sw_init+0x0/0x42 @ 1
[   22.632006] bus: 'gameport': add driver sidewinder
[   22.632306] initcall sw_init+0x0/0x42 returned 0 after 291 usecs
[   22.632310] calling  tmdc_init+0x0/0x42 @ 1
[   22.632314] bus: 'gameport': add driver tmdc
[   22.632561] initcall tmdc_init+0x0/0x42 returned 0 after 239 usecs
[   22.632565] calling  amd756_init+0x0/0x42 @ 1
[   22.632578] bus: 'pci': add driver amd756_smbus
[   22.632886] initcall amd756_init+0x0/0x42 returned 0 after 308 usecs
[   22.632890] calling  i2c_sis5595_init+0x0/0x42 @ 1
[   22.632897] bus: 'pci': add driver sis5595_smbus
[   22.633163] initcall i2c_sis5595_init+0x0/0x42 returned 0 after 261 usecs
[   22.633167] calling  i2c_sis630_init+0x0/0x42 @ 1
[   22.633175] bus: 'pci': add driver sis630_smbus
[   22.633438] initcall i2c_sis630_init+0x0/0x42 returned 0 after 257 usecs
[   22.633442] calling  i2c_gpio_init+0x0/0x57 @ 1
[   22.633449] bus: 'platform': add driver i2c-gpio
[   22.633697] initcall i2c_gpio_init+0x0/0x57 returned 0 after 242 usecs
[   22.633701] calling  ocores_i2c_init+0x0/0x39 @ 1
[   22.633707] bus: 'platform': add driver ocores-i2c
[   22.634011] initcall ocores_i2c_init+0x0/0x39 returned 0 after 295 usecs
[   22.634015] calling  i2c_adap_simtec_init+0x0/0x39 @ 1
[   22.634020] bus: 'platform': add driver simtec-i2c
[   22.634279] initcall i2c_adap_simtec_init+0x0/0x39 returned 0 after 252 usecs
[   22.634284] calling  asb100_init+0x0/0x3b @ 1
[   22.634290] bus: 'i2c': add driver asb100
[   22.634524] i2c-core: driver [asb100] registered
[   22.634533] initcall asb100_init+0x0/0x3b returned 0 after 237 usecs
[   22.634537] calling  sensors_w83792d_init+0x0/0x3b @ 1
[   22.634542] bus: 'i2c': add driver w83792d
[   22.634772] i2c-core: driver [w83792d] registered
[   22.634781] initcall sensors_w83792d_init+0x0/0x3b returned 0 after 232 usecs
[   22.634785] calling  sensors_w83781d_init+0x0/0x3b @ 1
[   22.634790] bus: 'i2c': add driver w83781d
[   22.635026] i2c-core: driver [w83781d] registered
[   22.635034] initcall sensors_w83781d_init+0x0/0x3b returned 0 after 238 usecs
[   22.635038] calling  abituguru_init+0x0/0x1a2 @ 1
[   22.635046] initcall abituguru_init+0x0/0x1a2 returned -19 after 2 usecs
[   22.635050] calling  abituguru3_init+0x0/0x185 @ 1
[   22.635058] initcall abituguru3_init+0x0/0x185 returned -19 after 2 usecs
[   22.635062] calling  sensors_adm1025_init+0x0/0x3b @ 1
[   22.635067] bus: 'i2c': add driver adm1025
[   22.635328] i2c-core: driver [adm1025] registered
[   22.635336] initcall sensors_adm1025_init+0x0/0x3b returned 0 after 261 usecs
[   22.635340] calling  sm_adm1026_init+0x0/0x3b @ 1
[   22.635345] bus: 'i2c': add driver adm1026
[   22.635634] i2c-core: driver [adm1026] registered
[   22.635642] initcall sm_adm1026_init+0x0/0x3b returned 0 after 289 usecs
[   22.635645] calling  sensors_adm1031_init+0x0/0x3b @ 1
[   22.635650] bus: 'i2c': add driver adm1031
[   22.635902] i2c-core: driver [adm1031] registered
[   22.635910] initcall sensors_adm1031_init+0x0/0x3b returned 0 after 253 usecs
[   22.635915] calling  adt7473_init+0x0/0x3b @ 1
[   22.635920] bus: 'i2c': add driver adt7473
[   22.636158] i2c-core: driver [adt7473] registered
[   22.636166] initcall adt7473_init+0x0/0x3b returned 0 after 239 usecs
[   22.636170] calling  sensors_adt7475_init+0x0/0x3b @ 1
[   22.636175] bus: 'i2c': add driver adt7475
[   22.636403] i2c-core: driver [adt7475] registered
[   22.636411] initcall sensors_adt7475_init+0x0/0x3b returned 0 after 230 usecs
[   22.636415] calling  atxp1_init+0x0/0x3b @ 1
[   22.636420] bus: 'i2c': add driver atxp1
[   22.636656] i2c-core: driver [atxp1] registered
[   22.636665] initcall atxp1_init+0x0/0x3b returned 0 after 238 usecs
[   22.636668] calling  f71805f_init+0x0/0x9f @ 1
[   22.636705] initcall f71805f_init+0x0/0x9f returned -19 after 30 usecs
[   22.636709] calling  sensors_f75375_init+0x0/0x3b @ 1
[   22.636714] bus: 'i2c': add driver f75375
[   22.636942] i2c-core: driver [f75375] registered
[   22.636950] initcall sensors_f75375_init+0x0/0x3b returned 0 after 229 usecs
[   22.636954] calling  fschmd_init+0x0/0x3b @ 1
[   22.636959] bus: 'i2c': add driver fschmd
[   22.637232] i2c-core: driver [fschmd] registered
[   22.637240] initcall fschmd_init+0x0/0x3b returned 0 after 273 usecs
[   22.637244] calling  sm_fscpos_init+0x0/0x3b @ 1
[   22.637249] bus: 'i2c': add driver fscpos
[   22.637497] i2c-core: driver [fscpos] registered
[   22.637504] initcall sm_fscpos_init+0x0/0x3b returned 0 after 248 usecs
[   22.637508] calling  g760a_init+0x0/0x3b @ 1
[   22.637513] bus: 'i2c': add driver g760a
[   22.637752] i2c-core: driver [g760a] registered
[   22.637759] initcall g760a_init+0x0/0x3b returned 0 after 240 usecs
[   22.637763] calling  sensors_gl520sm_init+0x0/0x3b @ 1
[   22.637768] bus: 'i2c': add driver gl520sm
[   22.638018] i2c-core: driver [gl520sm] registered
[   22.638026] initcall sensors_gl520sm_init+0x0/0x3b returned 0 after 250 usecs
[   22.638030] calling  k8temp_init+0x0/0x42 @ 1
[   22.638042] bus: 'pci': add driver k8temp
[   22.638087] bus: 'pci': driver_probe_device: matched device 0000:00:18.3 with driver k8temp
[   22.638091] bus: 'pci': really_probe: probing driver k8temp with device 0000:00:18.3
[   22.638371] device: 'hwmon0': device_add
[   22.638416] PM: Adding info for No Bus:hwmon0
[   22.638731] driver: '0000:00:18.3': driver_bound: bound to device 'k8temp'
[   22.638740] bus: 'pci': really_probe: bound device 0000:00:18.3 to driver k8temp
[   22.639042] initcall k8temp_init+0x0/0x42 returned 0 after 982 usecs
[   22.639046] calling  init_lm70+0x0/0x65 @ 1
[   22.639052] bus: 'spi': add driver lm70
[   22.639320] bus: 'spi': add driver tmp121
[   22.639561] initcall init_lm70+0x0/0x65 returned 0 after 497 usecs
[   22.639565] calling  sensors_lm77_init+0x0/0x3b @ 1
[   22.639574] bus: 'i2c': add driver lm77
[   22.639816] i2c-core: driver [lm77] registered
[   22.639824] initcall sensors_lm77_init+0x0/0x3b returned 0 after 246 usecs
[   22.639828] calling  sensors_lm80_init+0x0/0x3b @ 1
[   22.639833] bus: 'i2c': add driver lm80
[   22.640111] i2c-core: driver [lm80] registered
[   22.640119] initcall sensors_lm80_init+0x0/0x3b returned 0 after 271 usecs
[   22.640123] calling  sm_lm85_init+0x0/0x3b @ 1
[   22.640128] bus: 'i2c': add driver lm85
[   22.640356] i2c-core: driver [lm85] registered
[   22.640364] initcall sm_lm85_init+0x0/0x3b returned 0 after 229 usecs
[   22.640368] calling  sensors_lm87_init+0x0/0x3b @ 1
[   22.640373] bus: 'i2c': add driver lm87
[   22.640646] i2c-core: driver [lm87] registered
[   22.640654] initcall sensors_lm87_init+0x0/0x3b returned 0 after 273 usecs
[   22.640658] calling  ltc4215_init+0x0/0x3b @ 1
[   22.640663] bus: 'i2c': add driver ltc4215
[   22.640901] i2c-core: driver [ltc4215] registered
[   22.640909] initcall ltc4215_init+0x0/0x3b returned 0 after 239 usecs
[   22.640913] calling  sensors_max6650_init+0x0/0x3b @ 1
[   22.640918] bus: 'i2c': add driver max6650
[   22.641155] i2c-core: driver [max6650] registered
[   22.641164] initcall sensors_max6650_init+0x0/0x3b returned 0 after 239 usecs
[   22.641168] calling  pc87360_init+0x0/0xe9 @ 1
[   22.641188] pc87360: PC8736x not detected, module not inserted.
[   22.641195] initcall pc87360_init+0x0/0xe9 returned -19 after 20 usecs
[   22.641198] calling  sht15_init+0x0/0x83 @ 1
[   22.641206] bus: 'platform': add driver sht10
[   22.641468] bus: 'platform': add driver sht11
[   22.641710] bus: 'platform': add driver sht15
[   22.641969] bus: 'platform': add driver sht71
[   22.642245] bus: 'platform': add driver sht75
[   22.642491] initcall sht15_init+0x0/0x83 returned 0 after 1257 usecs
[   22.642495] calling  sm_sis5595_init+0x0/0x42 @ 1
[   22.642508] bus: 'pci': add driver sis5595
[   22.642810] initcall sm_sis5595_init+0x0/0x42 returned 0 after 300 usecs
[   22.642814] calling  smsc47b397_init+0x0/0xfd @ 1
[   22.642830] initcall smsc47b397_init+0x0/0xfd returned -19 after 10 usecs
[   22.642834] calling  sensors_w83l785ts_init+0x0/0x3b @ 1
[   22.642841] bus: 'i2c': add driver w83l785ts
[   22.643073] i2c-core: driver [w83l785ts] registered
[   22.643082] initcall sensors_w83l785ts_init+0x0/0x3b returned 0 after 235 usecs
[   22.643086] calling  telephony_init+0x0/0x71 @ 1
[   22.643089] Linux telephony interface: v1.00
[   22.643105] initcall telephony_init+0x0/0x71 returned 0 after 13 usecs
[   22.643109] calling  cpufreq_stats_init+0x0/0xcb @ 1
[   22.643179] initcall cpufreq_stats_init+0x0/0xcb returned 0 after 63 usecs
[   22.643183] calling  init_ladder+0x0/0x39 @ 1
[   22.643216] cpuidle: using governor ladder
[   22.643222] initcall init_ladder+0x0/0x39 returned 0 after 32 usecs
[   22.643225] calling  init_menu+0x0/0x39 @ 1
[   22.643230] cpuidle: using governor menu
[   22.643235] initcall init_menu+0x0/0x39 returned 0 after 4 usecs
[   22.643239] calling  sdio_uart_init+0x0/0x11a @ 1
[   22.643269] bus: 'sdio': add driver sdio_uart
[   22.643508] initcall sdio_uart_init+0x0/0x11a returned 0 after 257 usecs
[   22.643513] calling  wbsd_drv_init+0x0/0xdb @ 1
[   22.643517] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   22.643519] wbsd: Copyright(c) Pierre Ossman
[   22.643523] bus: 'pnp': add driver wbsd
[   22.643782] initcall wbsd_drv_init+0x0/0xdb returned 0 after 256 usecs
[   22.643786] calling  tifm_sd_init+0x0/0x39 @ 1
[   22.643792] bus: 'tifm': add driver tifm_sd
[   22.644077] initcall tifm_sd_init+0x0/0x39 returned 0 after 276 usecs
[   22.644081] calling  memstick_init+0x0/0xab @ 1
[   22.644458] bus: 'memstick': registered
[   22.644460] device class 'memstick_host': registering
[   22.644709] initcall memstick_init+0x0/0xab returned 0 after 606 usecs
[   22.644713] calling  mspro_block_init+0x0/0x98 @ 1
[   22.644721] bus: 'memstick': add driver mspro_block
[   22.644955] initcall mspro_block_init+0x0/0x98 returned 0 after 230 usecs
[   22.644959] calling  gpio_led_init+0x0/0x2d @ 1
[   22.644968] initcall gpio_led_init+0x0/0x2d returned 0 after 2 usecs
[   22.644972] calling  dac124s085_leds_init+0x0/0x39 @ 1
[   22.644978] bus: 'spi': add driver dac124s085
[   22.645211] initcall dac124s085_leds_init+0x0/0x39 returned 0 after 227 usecs
[   22.645215] calling  ib_core_init+0x0/0x6a @ 1
[   22.645219] device class 'infiniband': registering
[   22.645555] initcall ib_core_init+0x0/0x6a returned 0 after 326 usecs
[   22.645560] calling  ib_mad_init_module+0x0/0xca @ 1
[   22.646035] initcall ib_mad_init_module+0x0/0xca returned 0 after 458 usecs
[   22.646039] calling  ib_sa_init+0x0/0xc1 @ 1
[   22.646133] initcall ib_sa_init+0x0/0xc1 returned 0 after 85 usecs
[   22.646137] calling  ib_cm_init+0x0/0x180 @ 1
[   22.646214] device class 'infiniband_cm': registering
[   22.646596] initcall ib_cm_init+0x0/0x180 returned 0 after 442 usecs
[   22.646600] calling  iw_cm_init+0x0/0x5c @ 1
[   22.646717] initcall iw_cm_init+0x0/0x5c returned 0 after 107 usecs
[   22.646721] calling  ib_uverbs_init+0x0/0x186 @ 1
[   22.646731] device class 'infiniband_verbs': registering
[   22.647194] initcall ib_uverbs_init+0x0/0x186 returned 0 after 454 usecs
[   22.647198] calling  ib_ucm_init+0x0/0xcc @ 1
[   22.647213] initcall ib_ucm_init+0x0/0xcc returned 0 after 8 usecs
[   22.647216] calling  infinipath_init+0x0/0xe9 @ 1
[   22.647280] bus: 'pci': add driver ib_ipath
[   22.647626] initcall infinipath_init+0x0/0xe9 returned 0 after 394 usecs
[   22.647631] calling  srp_init_module+0x0/0x116 @ 1
[   22.647644] device class 'infiniband_srp': registering
[   22.647888] initcall srp_init_module+0x0/0x116 returned 0 after 244 usecs
[   22.647892] calling  efivars_init+0x0/0x213 @ 1
[   22.647900] initcall efivars_init+0x0/0x213 returned -19 after 2 usecs
[   22.647904] calling  dcdbas_init+0x0/0x8d @ 1
[   22.647912] bus: 'platform': add driver dcdbas
[   22.648176] Registering platform device 'dcdbas'. Parent at platform
[   22.648181] device: 'dcdbas': device_add
[   22.648208] bus: 'platform': add device dcdbas
[   22.648236] PM: Adding info for platform:dcdbas
[   22.648482] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   22.648486] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   22.648522] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   22.648525] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   22.648529] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   22.648540] initcall dcdbas_init+0x0/0x8d returned 0 after 615 usecs
[   22.648543] calling  padlock_init+0x0/0xb5 @ 1
[   22.648547] padlock: VIA PadLock Hash Engine not detected.
[   22.648552] initcall padlock_init+0x0/0xb5 returned -19 after 4 usecs
[   22.648556] calling  ioat_init_module+0x0/0x42 @ 1
[   22.648564] bus: 'pci': add driver ioatdma
[   22.648904] initcall ioat_init_module+0x0/0x42 returned 0 after 335 usecs
[   22.648908] calling  hid_init+0x0/0x6e @ 1
[   22.649164] bus: 'hid': registered
[   22.649181] device class 'hidraw': registering
[   22.649413] initcall hid_init+0x0/0x6e returned 0 after 488 usecs
[   22.649417] calling  usb_mouse_init+0x0/0x5e @ 1
[   22.649425] bus: 'usb': add driver usbmouse
[   22.649687] usbcore: registered new interface driver usbmouse
[   22.649694] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[   22.649700] initcall usb_mouse_init+0x0/0x5e returned 0 after 271 usecs
[   22.649704] calling  thinkpad_acpi_module_init+0x0/0x456 @ 1
[   22.649769] initcall thinkpad_acpi_module_init+0x0/0x456 returned -19 after 58 usecs
[   22.649773] calling  fake_init+0x0/0x53 @ 1
[   22.649785] Registering platform device 'ieee802154hardmac'. Parent at platform
[   22.649790] device: 'ieee802154hardmac': device_add
[   22.649805] bus: 'platform': add device ieee802154hardmac
[   22.649832] PM: Adding info for platform:ieee802154hardmac
[   22.650103] bus: 'platform': add driver ieee802154hardmac
[   22.650123] bus: 'platform': driver_probe_device: matched device ieee802154hardmac with driver ieee802154hardmac
[   22.650126] bus: 'platform': really_probe: probing driver ieee802154hardmac with device ieee802154hardmac
[   22.650172] device: 'hardwpan0': device_add
[   22.650372] PM: Adding info for No Bus:hardwpan0
[   22.650701] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMAC hardware
[   22.650704] driver: 'ieee802154hardmac': driver_bound: bound to device 'ieee802154hardmac'
[   22.650708] bus: 'platform': really_probe: bound device ieee802154hardmac to driver ieee802154hardmac
[   22.651002] initcall fake_init+0x0/0x53 returned 0 after 1187 usecs
[   22.651007] calling  flow_cache_init+0x0/0x1c5 @ 1
[   22.651560] initcall flow_cache_init+0x0/0x1c5 returned 0 after 534 usecs
[   22.651564] calling  pg_init+0x0/0x1ab @ 1
[   22.651568] pktgen v2.70: Packet Generator for packet performance testing.
[   24.062748] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   24.070825] initcall pg_init+0x0/0x1ab returned 0 after 1385989 usecs
[   24.077261] calling  llc_init+0x0/0x47 @ 1
[   24.081386] initcall llc_init+0x0/0x47 returned 0 after 4 usecs
[   24.087297] calling  llc2_init+0x0/0xf4 @ 1
[   24.092017] NET: Registered protocol family 26
[   24.092963] device: 'input0': device_add
[   24.093192] PM: Adding info for No Bus:input0
[   24.105383] initcall llc2_init+0x0/0xf4 returned 0 after 13121 usecs
[   24.112360] calling  snap_init+0x0/0x61 @ 1
[   24.117207] initcall snap_init+0x0/0x61 returned 0 after 651 usecs
[   24.123932] calling  rif_init+0x0/0xb5 @ 1
[   24.128060] initcall rif_init+0x0/0xb5 returned 0 after 35 usecs
[   24.134083] calling  blackhole_module_init+0x0/0x39 @ 1
[   24.139310] initcall blackhole_module_init+0x0/0x39 returned 0 after 3 usecs
[   24.146375] calling  gact_init_module+0x0/0x45 @ 1
[   24.151186] GACT probability on
[   24.154368] initcall gact_init_module+0x0/0x45 returned 0 after 3108 usecs
[   24.161257] calling  cbq_module_init+0x0/0x39 @ 1
[   24.165959] initcall cbq_module_init+0x0/0x39 returned 0 after 2 usecs
[   24.172500] calling  htb_module_init+0x0/0x39 @ 1
[   24.177209] initcall htb_module_init+0x0/0x39 returned 0 after 2 usecs
[   24.183747] calling  red_module_init+0x0/0x39 @ 1
[   24.188450] initcall red_module_init+0x0/0x39 returned 0 after 2 usecs
[   24.194988] calling  ingress_module_init+0x0/0x39 @ 1
[   24.200054] initcall ingress_module_init+0x0/0x39 returned 0 after 2 usecs
[   24.206922] calling  sfq_module_init+0x0/0x39 @ 1
[   24.211652] initcall sfq_module_init+0x0/0x39 returned 0 after 2 usecs
[   24.218171] calling  tbf_module_init+0x0/0x39 @ 1
[   24.222898] initcall tbf_module_init+0x0/0x39 returned 0 after 1 usecs
[   24.229420] calling  prio_module_init+0x0/0x39 @ 1
[   24.234235] initcall prio_module_init+0x0/0x39 returned 0 after 2 usecs
[   24.240861] calling  init_u32+0x0/0x61 @ 1
[   24.244952] u32 classifier
[   24.247663]     input device check on 
[   24.251433]     Actions configured 
[   24.254947] initcall init_u32+0x0/0x61 returned 0 after 9757 usecs
[   24.261141] calling  init_route4+0x0/0x39 @ 1
[   24.265496] initcall init_route4+0x0/0x39 returned 0 after 1 usecs
[   24.271689] calling  init_tcindex+0x0/0x39 @ 1
[   24.276129] initcall init_tcindex+0x0/0x39 returned 0 after 2 usecs
[   24.282410] calling  nfnetlink_init+0x0/0x86 @ 1
[   24.287020] Netfilter messages via NETLINK v0.30.
[   24.291778] initcall nfnetlink_init+0x0/0x86 returned 0 after 4641 usecs
[   24.298467] calling  nfnetlink_log_init+0x0/0xfd @ 1
[   24.303535] initcall nfnetlink_log_init+0x0/0xfd returned 0 after 77 usecs
[   24.310420] calling  xt_init+0x0/0x1b0 @ 1
[   24.314564] initcall xt_init+0x0/0x1b0 returned 0 after 49 usecs
[   24.320587] calling  tcpudp_mt_init+0x0/0x3e @ 1
[   24.322816] input: AT Translated Set 2 keyboard as /class/input/input0
[   24.322985] device: 'event0': device_add
[   24.323298] PM: Adding info for No Bus:event0
[   24.323804] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   24.323810] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   24.323837] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   24.323840] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   24.368454] initcall tcpudp_mt_init+0x0/0x3e returned 0 after 38 usecs
[   24.374989] calling  hl_tg_init+0x0/0x3e @ 1
[   24.379256] initcall hl_tg_init+0x0/0x3e returned 0 after 3 usecs
[   24.385363] calling  xt_rateest_tg_init+0x0/0x64 @ 1
[   24.390343] initcall xt_rateest_tg_init+0x0/0x64 returned 0 after 7 usecs
[   24.397121] calling  tcpoptstrip_tg_init+0x0/0x3e @ 1
[   24.402200] initcall tcpoptstrip_tg_init+0x0/0x3e returned 0 after 3 usecs
[   24.409063] calling  dccp_mt_init+0x0/0xc5 @ 1
[   24.413540] initcall dccp_mt_init+0x0/0xc5 returned 0 after 9 usecs
[   24.419801] calling  dscp_mt_init+0x0/0x3e @ 1
[   24.424274] initcall dscp_mt_init+0x0/0x3e returned 0 after 6 usecs
[   24.430549] calling  iprange_mt_init+0x0/0x3e @ 1
[   24.435252] initcall iprange_mt_init+0x0/0x3e returned 0 after 4 usecs
[   24.441792] calling  mark_mt_init+0x0/0x3e @ 1
[   24.446233] initcall mark_mt_init+0x0/0x3e returned 0 after 3 usecs
[   24.452512] calling  owner_mt_init+0x0/0x3e @ 1
[   24.457041] initcall owner_mt_init+0x0/0x3e returned 0 after 4 usecs
[   24.463406] calling  policy_mt_init+0x0/0x3e @ 1
[   24.468021] initcall policy_mt_init+0x0/0x3e returned 0 after 3 usecs
[   24.474471] calling  xt_rateest_mt_init+0x0/0x39 @ 1
[   24.479432] initcall xt_rateest_mt_init+0x0/0x39 returned 0 after 2 usecs
[   24.486234] calling  realm_mt_init+0x0/0x39 @ 1
[   24.490777] initcall realm_mt_init+0x0/0x39 returned 0 after 2 usecs
[   24.497125] calling  recent_mt_init+0x0/0xf9 @ 1
[   24.501790] initcall recent_mt_init+0x0/0xf9 returned 0 after 23 usecs
[   24.508305] calling  tcpmss_mt_init+0x0/0x3e @ 1
[   24.512949] initcall tcpmss_mt_init+0x0/0x3e returned 0 after 3 usecs
[   24.519380] calling  ip_vs_init+0x0/0xe3 @ 1
[   24.523837] IPVS: Registered protocols (TCP)
[   24.528699] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
[   24.536032] IPVS: Each connection entry needs 328 bytes at least
[   24.542158] IPVS: ipvs loaded.
[   24.545215] initcall ip_vs_init+0x0/0xe3 returned 0 after 21033 usecs
[   24.551668] calling  ip_vs_wlc_init+0x0/0x39 @ 1
[   24.556307] IPVS: [wlc] scheduler registered.
[   24.560680] initcall ip_vs_wlc_init+0x0/0x39 returned 0 after 4285 usecs
[   24.567368] calling  ip_vs_lblc_init+0x0/0x6d @ 1
[   24.572107] IPVS: [lblc] scheduler registered.
[   24.576550] initcall ip_vs_lblc_init+0x0/0x6d returned 0 after 4351 usecs
[   24.583351] calling  ip_vs_dh_init+0x0/0x39 @ 1
[   24.587876] IPVS: [dh] scheduler registered.
[   24.592165] initcall ip_vs_dh_init+0x0/0x39 returned 0 after 4184 usecs
[   24.598769] calling  ip_vs_sh_init+0x0/0x39 @ 1
[   24.603321] IPVS: [sh] scheduler registered.
[   24.607586] initcall ip_vs_sh_init+0x0/0x39 returned 0 after 4168 usecs
[   24.614215] calling  sysctl_ipv4_init+0x0/0x74 @ 1
[   24.619028] initcall sysctl_ipv4_init+0x0/0x74 returned 0 after 19 usecs
[   24.625745] calling  init_syncookies+0x0/0x40 @ 1
[   24.630501] initcall init_syncookies+0x0/0x40 returned 0 after 36 usecs
[   24.637110] calling  ipcomp4_init+0x0/0x8f @ 1
[   24.641580] initcall ipcomp4_init+0x0/0x8f returned 0 after 4 usecs
[   24.647838] calling  ipip_init+0x0/0xc5 @ 1
[   24.652080] initcall ipip_init+0x0/0xc5 returned 0 after 30 usecs
[   24.658169] calling  tunnel4_init+0x0/0x8f @ 1
[   24.662640] initcall tunnel4_init+0x0/0x8f returned 0 after 2 usecs
[   24.668901] calling  ipv4_netfilter_init+0x0/0x39 @ 1
[   24.674002] initcall ipv4_netfilter_init+0x0/0x39 returned 0 after 28 usecs
[   24.680973] calling  ip_tables_init+0x0/0xd5 @ 1
[   24.685633] ip_tables: (C) 2000-2006 Netfilter Core Team
[   24.690963] initcall ip_tables_init+0x0/0xd5 returned 0 after 5248 usecs
[   24.697654] calling  iptable_filter_init+0x0/0x92 @ 1
[   24.702784] initcall iptable_filter_init+0x0/0x92 returned 0 after 54 usecs
[   24.709736] calling  iptable_mangle_init+0x0/0x6a @ 1
[   24.714845] initcall iptable_mangle_init+0x0/0x6a returned 0 after 32 usecs
[   24.721818] calling  addrtype_mt_init+0x0/0x3e @ 1
[   24.726608] initcall addrtype_mt_init+0x0/0x3e returned 0 after 3 usecs
[   24.733235] calling  ah_mt_init+0x0/0x39 @ 1
[   24.737510] initcall ah_mt_init+0x0/0x39 returned 0 after 2 usecs
[   24.743617] calling  ecn_tg_init+0x0/0x39 @ 1
[   24.747971] initcall ecn_tg_init+0x0/0x39 returned 0 after 2 usecs
[   24.754164] calling  tcpprobe_init+0x0/0x104 @ 1
[   24.764151] TCP probe registered (port=0)
[   24.768162] initcall tcpprobe_init+0x0/0x104 returned 0 after 9166 usecs
[   24.774882] calling  hybla_register+0x0/0x39 @ 1
[   24.779497] TCP hybla registered
[   24.782748] initcall hybla_register+0x0/0x39 returned 0 after 3171 usecs
[   24.789443] calling  htcp_register+0x0/0x39 @ 1
[   24.794000] TCP htcp registered
[   24.797144] initcall htcp_register+0x0/0x39 returned 0 after 3071 usecs
[   24.803772] calling  tcp_vegas_register+0x0/0x3b @ 1
[   24.808728] TCP vegas registered
[   24.811981] initcall tcp_vegas_register+0x0/0x3b returned 0 after 3172 usecs
[   24.819022] calling  xfrm_user_init+0x0/0x71 @ 1
[   24.823662] Initializing XFRM netlink socket
[   24.827979] initcall xfrm_user_init+0x0/0x71 returned 0 after 4217 usecs
[   24.834694] calling  packet_init+0x0/0x6d @ 1
[   24.839048] NET: Registered protocol family 17
[   24.843567] initcall packet_init+0x0/0x6d returned 0 after 4410 usecs
[   24.850018] calling  edsa_init_module+0x0/0x3b @ 1
[   24.854813] initcall edsa_init_module+0x0/0x3b returned 0 after 3 usecs
[   24.861439] calling  trailer_init_module+0x0/0x3b @ 1
[   24.866486] initcall trailer_init_module+0x0/0x3b returned 0 after 2 usecs
[   24.873374] calling  mv88e6060_init+0x0/0x3b @ 1
[   24.878014] initcall mv88e6060_init+0x0/0x3b returned 0 after 29 usecs
[   24.884553] calling  mv88e6123_61_65_init+0x0/0x3b @ 1
[   24.889689] initcall mv88e6123_61_65_init+0x0/0x3b returned 0 after 2 usecs
[   24.896663] calling  dsa_init_module+0x0/0x39 @ 1
[   24.901389] bus: 'platform': add driver dsa
[   24.905865] initcall dsa_init_module+0x0/0x39 returned 0 after 4374 usecs
[   24.912891] calling  atalk_init+0x0/0xb3 @ 1
[   24.917159] NET: Registered protocol family 5
[   24.970105] initcall atalk_init+0x0/0xb3 returned 0 after 51699 usecs
[   24.976540] calling  lapb_init+0x0/0x2d @ 1
[   24.980751] initcall lapb_init+0x0/0x2d returned 0 after 1 usecs
[   24.986751] calling  af_rxrpc_init+0x0/0x1c6 @ 1
[   24.992482] NET: Registered protocol family 33
[   24.997027] initcall af_rxrpc_init+0x0/0x1c6 returned 0 after 5507 usecs
[   25.003761] calling  decnet_init+0x0/0xb4 @ 1
[   25.008114] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   25.017412] DECnet: Routing cache hash table of 512 buckets, 36Kbytes
[   25.024429] NET: Registered protocol family 12
[   25.028898] initcall decnet_init+0x0/0xb4 returned 0 after 20294 usecs
[   25.035440] calling  dn_rtmsg_init+0x0/0x95 @ 1
[   25.040051] initcall dn_rtmsg_init+0x0/0x95 returned 0 after 80 usecs
[   25.046480] calling  vlan_proto_init+0x0/0xeb @ 1
[   25.051208] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   25.057988] All bugs added by David S. Miller <davem@redhat.com>
[   25.064208] initcall vlan_proto_init+0x0/0xeb returned 0 after 12693 usecs
[   25.071092] calling  lib80211_init+0x0/0x45 @ 1
[   25.075618] lib80211: common routines for IEEE802.11 drivers
[   25.081308] lib80211_crypt: registered algorithm 'NULL'
[   25.086532] initcall lib80211_init+0x0/0x45 returned 0 after 10655 usecs
[   25.093246] calling  lib80211_crypto_wep_init+0x0/0x39 @ 1
[   25.098725] lib80211_crypt: registered algorithm 'WEP'
[   25.103880] initcall lib80211_crypto_wep_init+0x0/0x39 returned 0 after 5030 usecs
[   25.111452] calling  lib80211_crypto_ccmp_init+0x0/0x39 @ 1
[   25.117021] lib80211_crypt: registered algorithm 'CCMP'
[   25.122265] initcall lib80211_crypto_ccmp_init+0x0/0x39 returned 0 after 5116 usecs
[   25.129914] calling  lib80211_crypto_tkip_init+0x0/0x39 @ 1
[   25.135504] lib80211_crypt: registered algorithm 'TKIP'
[   25.140738] initcall lib80211_crypto_tkip_init+0x0/0x39 returned 0 after 5110 usecs
[   25.148380] calling  dcbnl_init+0x0/0x59 @ 1
[   25.152674] initcall dcbnl_init+0x0/0x59 returned 0 after 1 usecs
[   25.158757] calling  ieee802154_nl_init+0x0/0xb4 @ 1
[   25.220072] initcall ieee802154_nl_init+0x0/0xb4 returned 0 after 55010 usecs
[   25.227195] calling  af_ieee802154_init+0x0/0x9b @ 1
[   25.233130] NET: Registered protocol family 36
[   25.237575] initcall af_ieee802154_init+0x0/0x9b returned 0 after 5278 usecs
[   25.244639] calling  severities_debugfs_init+0x0/0x83 @ 1
[   25.250083] initcall severities_debugfs_init+0x0/0x83 returned 0 after 30 usecs
[   25.257383] calling  centrino_init+0x0/0x57 @ 1
[   25.261936] initcall centrino_init+0x0/0x57 returned -19 after 1 usecs
[   25.268458] calling  cpufreq_p4_init+0x0/0x82 @ 1
[   25.273187] initcall cpufreq_p4_init+0x0/0x82 returned -19 after 1 usecs
[   25.279881] calling  hpet_insert_resource+0x0/0x47 @ 1
[   25.285041] initcall hpet_insert_resource+0x0/0x47 returned 1 after 1 usecs
[   25.292014] initcall hpet_insert_resource+0x0/0x47 returned with error code 1 
[   25.299225] calling  update_mp_table+0x0/0x245 @ 1
[   25.304038] initcall update_mp_table+0x0/0x245 returned 0 after 1 usecs
[   25.310656] calling  lapic_insert_resource+0x0/0x67 @ 1
[   25.315883] initcall lapic_insert_resource+0x0/0x67 returned 0 after 4 usecs
[   25.322947] calling  init_lapic_nmi_sysfs+0x0/0x60 @ 1
[   25.328081] initcall init_lapic_nmi_sysfs+0x0/0x60 returned 0 after 1 usecs
[   25.335052] calling  io_apic_bug_finalize+0x0/0x42 @ 1
[   25.340202] initcall io_apic_bug_finalize+0x0/0x42 returned 0 after 1 usecs
[   25.347153] calling  check_early_ioremap_leak+0x0/0x8e @ 1
[   25.352658] initcall check_early_ioremap_leak+0x0/0x8e returned 0 after 1 usecs
[   25.359955] calling  init_oops_id+0x0/0x58 @ 1
[   25.364425] initcall init_oops_id+0x0/0x58 returned 0 after 8 usecs
[   25.370698] calling  disable_boot_consoles+0x0/0xf1 @ 1
[   25.375922] initcall disable_boot_consoles+0x0/0xf1 returned 0 after 1 usecs
[   25.382979] calling  pm_qos_power_init+0x0/0xf0 @ 1
[   25.387864] device: 'cpu_dma_latency': device_add
[   25.392701] PM: Adding info for No Bus:cpu_dma_latency
[   25.398084] device: 'network_latency': device_add
[   25.402902] PM: Adding info for No Bus:network_latency
[   25.408281] device: 'network_throughput': device_add
[   25.413309] PM: Adding info for No Bus:network_throughput
[   25.418939] initcall pm_qos_power_init+0x0/0xf0 returned 0 after 30352 usecs
[   25.426000] calling  debugfs_kprobe_init+0x0/0xac @ 1
[   25.431134] initcall debugfs_kprobe_init+0x0/0xac returned 0 after 69 usecs
[   25.438084] calling  taskstats_init+0x0/0xbe @ 1
[   25.442774] registered taskstats version 1
[   25.446865] initcall taskstats_init+0x0/0xbe returned 0 after 4048 usecs
[   25.453578] calling  fail_page_alloc_debugfs+0x0/0x10d @ 1
[   25.459170] initcall fail_page_alloc_debugfs+0x0/0x10d returned 0 after 109 usecs
[   25.466665] calling  max_swapfiles_check+0x0/0x2d @ 1
[   25.471728] initcall max_swapfiles_check+0x0/0x2d returned 0 after 1 usecs
[   25.478592] calling  failslab_debugfs_init+0x0/0x91 @ 1
[   25.483954] initcall failslab_debugfs_init+0x0/0x91 returned 0 after 116 usecs
[   25.491183] calling  random32_reseed+0x0/0xc2 @ 1
[   25.495901] initcall random32_reseed+0x0/0xc2 returned 0 after 16 usecs
[   25.502533] calling  pci_resource_alignment_sysfs_init+0x0/0x40 @ 1
[   25.508804] initcall pci_resource_alignment_sysfs_init+0x0/0x40 returned 0 after 7 usecs
[   25.516905] calling  pci_sysfs_init+0x0/0x77 @ 1
[   25.521936] initcall pci_sysfs_init+0x0/0x77 returned 0 after 393 usecs
[   25.528545] calling  boot_wait_for_devices+0x0/0x40 @ 1
[   25.533923] initcall boot_wait_for_devices+0x0/0x40 returned 0 after 2 usecs
[   25.540981] calling  regulator_init_complete+0x0/0x166 @ 1
[   25.546492] initcall regulator_init_complete+0x0/0x166 returned 0 after 29 usecs
[   25.553896] calling  seqgen_init+0x0/0x36 @ 1
[   25.558270] initcall seqgen_init+0x0/0x36 returned 0 after 18 usecs
[   25.564549] calling  late_resume_init+0x0/0x148 @ 1
[   25.569420]   Magic number: 5:393:83
[   25.573243] initcall late_resume_init+0x0/0x148 returned 0 after 3727 usecs
[   25.580216] calling  hd_init+0x0/0x321 @ 1
[   25.584362] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   25.592292] initcall hd_init+0x0/0x321 returned -1 after 7789 usecs
[   25.598546] initcall hd_init+0x0/0x321 returned with error code -1 
[   25.604832] calling  scsi_complete_async_scans+0x0/0x169 @ 1
[   25.610499] initcall scsi_complete_async_scans+0x0/0x169 returned 0 after 2 usecs
[   25.617967] calling  dmatest_init+0x0/0x9b @ 1
[   25.622467] initcall dmatest_init+0x0/0x9b returned 0 after 33 usecs
[   25.628813] calling  tcp_congestion_default+0x0/0x39 @ 1
[   25.634146] initcall tcp_congestion_default+0x0/0x39 returned 0 after 3 usecs
[   25.641289] calling  ip_auto_config+0x0/0x317 @ 1
[   25.646014] initcall ip_auto_config+0x0/0x317 returned 0 after 22 usecs
[   25.652643] calling  initialize_hashrnd+0x0/0x40 @ 1
[   25.657610] initcall initialize_hashrnd+0x0/0x40 returned 0 after 7 usecs
[   25.664723] async_waiting @ 1
[   25.667695] async_continuing @ 1 after 2 usec
[   25.674075] EXT3-fs: INFO: recovery required on readonly filesystem.
[   25.680419] EXT3-fs: write access will be enabled during recovery.
[   25.706142] kjournald starting.  Commit interval 5 seconds
[   25.711742] EXT3-fs: recovery complete.
[   25.716708] EXT3-fs: mounted filesystem with ordered data mode.
[   25.722843] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[   25.729549] async_waiting @ 1
[   25.732541] async_continuing @ 1 after 2 usec
[   25.736894] debug: unmapping init memory ffffffff81d0d000..ffffffff81f90000
[   28.367257] device: 'device:00': dev_uevent: bus uevent() returned -12
[   28.415833] device: 'device:01': dev_uevent: bus uevent() returned -12
[   28.422483] device: 'device:02': dev_uevent: bus uevent() returned -12
[   28.430445] device: 'device:03': dev_uevent: bus uevent() returned -12
[   28.437130] device: 'device:04': dev_uevent: bus uevent() returned -12
[   28.444459] device: 'device:05': dev_uevent: bus uevent() returned -12
[   28.451105] device: 'device:06': dev_uevent: bus uevent() returned -12
[   28.480746] device: 'device:07': dev_uevent: bus uevent() returned -12
[   28.487810] device: 'device:08': dev_uevent: bus uevent() returned -12
[   28.599996] device: 'device:09': dev_uevent: bus uevent() returned -12
[   28.625335] device: 'device:0a': dev_uevent: bus uevent() returned -12
[   28.632009] device: 'device:0b': dev_uevent: bus uevent() returned -12
[   28.702005] device: 'device:0c': dev_uevent: bus uevent() returned -12
[   28.708882] device: 'device:0d': dev_uevent: bus uevent() returned -12
[   28.736185] device: 'device:0e': dev_uevent: bus uevent() returned -12
[   28.779769] device: 'device:0f': dev_uevent: bus uevent() returned -12
[   28.786715] device: 'device:10': dev_uevent: bus uevent() returned -12
[   28.793666] device: 'device:11': dev_uevent: bus uevent() returned -12
[   28.800320] device: 'device:12': dev_uevent: bus uevent() returned -12
[   28.830390] device: 'device:13': dev_uevent: bus uevent() returned -12
[   28.837132] device: 'device:14': dev_uevent: bus uevent() returned -12
[   28.844915] device: 'device:15': dev_uevent: bus uevent() returned -12
[   28.851564] device: 'device:16': dev_uevent: bus uevent() returned -12
[   28.940908] device: 'device:17': dev_uevent: bus uevent() returned -12
[   28.978315] device: 'device:18': dev_uevent: bus uevent() returned -12
[   28.985599] device: 'device:19': dev_uevent: bus uevent() returned -12
[   28.992232] device: 'device:1a': dev_uevent: bus uevent() returned -12
[   28.999252] device: 'device:1b': dev_uevent: bus uevent() returned -12
[   29.011021] device: 'device:1c': dev_uevent: bus uevent() returned -12
[   29.019383] device: 'device:1d': dev_uevent: bus uevent() returned -12
[   30.140704] eth1: link down
[   37.192392] EXT3 FS on sda6, internal journal
[   37.320228] kjournald starting.  Commit interval 5 seconds
[   37.326076] EXT3 FS on sda5, internal journal
[   37.330491] EXT3-fs: mounted filesystem with ordered data mode.
[   38.266621] Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k 
[   38.442541] CPA self-test:
[   38.452120]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   38.474220]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   38.495688]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   38.503662] ok.
[   39.855795] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[   43.034250] numa_remove_cpu cpu 1 node 0: mask now 0
[   43.035674] CPU 1 is now offline
[   43.043939] lockdep: fixing up alternatives.
[   43.048224] SMP alternatives: switching to UP code
[   43.081725] 
[   43.081726] =======================================================
[   43.089512] [ INFO: possible circular locking dependency detected ]
[   43.090020] 2.6.31-rc6-tip-01039-ge54d9cb-dirty #4937
[   43.090020] -------------------------------------------------------
[   43.090020] S99local/5002 is trying to acquire lock:
[   43.090020]  (events){+.+.+.}, at: [<ffffffff8106ff4c>] cleanup_workqueue_thread+0x2d/0xdd
[   43.090020] 
[   43.090020] but task is already holding lock:
[   43.090020]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff818387aa>] cpu_down+0x3b/0xb4
[   43.090020] 
[   43.090020] which lock already depends on the new lock.
[   43.090020] 
[   43.090020] 
[   43.090020] the existing dependency chain (in reverse order) is:
[   43.090020] 
[   43.090020] -> #4 (cpu_add_remove_lock){+.+.+.}:
[   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
[   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
[   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
[   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
[   43.090020]        [<ffffffff81872229>] __mutex_lock_common+0x5b/0x3b0
[   43.090020]        [<ffffffff81872683>] mutex_lock_nested+0x45/0x62
[   43.090020]        [<ffffffff8105de75>] cpu_maps_update_begin+0x25/0x3b
[   43.090020]        [<ffffffff81070348>] __create_workqueue_key+0x137/0x200
[   43.090020]        [<ffffffff810a2397>] stop_machine_create+0x4d/0xc2
[   43.090020]        [<ffffffff810a2438>] stop_machine+0x2c/0x74
[   43.090020]        [<ffffffff8107f163>] timekeeping_notify+0x31/0x4c
[   43.090020]        [<ffffffff81080258>] clocksource_select+0xc9/0xe8
[   43.090020]        [<ffffffff81080b8c>] clocksource_register+0x70/0xa1
[   43.090020]        [<ffffffff81d4cc6a>] init_acpi_pm_clocksource+0xf3/0x114
[   43.090020]        [<ffffffff8100a092>] do_one_initcall+0x65/0x15b
[   43.090020]        [<ffffffff81d0d992>] do_basic_setup+0x59/0x82
[   43.090020]        [<ffffffff81d0da3e>] kernel_init+0x83/0xdd
[   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
[   43.090020] 
[   43.090020] -> #3 (setup_lock){+.+.+.}:
[   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
[   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
[   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
[   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
[   43.090020]        [<ffffffff81872229>] __mutex_lock_common+0x5b/0x3b0
[   43.090020]        [<ffffffff81872683>] mutex_lock_nested+0x45/0x62
[   43.090020]        [<ffffffff810a236f>] stop_machine_create+0x25/0xc2
[   43.090020]        [<ffffffff810a2438>] stop_machine+0x2c/0x74
[   43.090020]        [<ffffffff8107f163>] timekeeping_notify+0x31/0x4c
[   43.090020]        [<ffffffff81080258>] clocksource_select+0xc9/0xe8
[   43.090020]        [<ffffffff81080b8c>] clocksource_register+0x70/0xa1
[   43.090020]        [<ffffffff81d4cc6a>] init_acpi_pm_clocksource+0xf3/0x114
[   43.090020]        [<ffffffff8100a092>] do_one_initcall+0x65/0x15b
[   43.090020]        [<ffffffff81d0d992>] do_basic_setup+0x59/0x82
[   43.090020]        [<ffffffff81d0da3e>] kernel_init+0x83/0xdd
[   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
[   43.090020] 
[   43.090020] -> #2 (clocksource_mutex){+.+.+.}:
[   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
[   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
[   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
[   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
[   43.090020]        [<ffffffff81872229>] __mutex_lock_common+0x5b/0x3b0
[   43.090020]        [<ffffffff81872683>] mutex_lock_nested+0x45/0x62
[   43.090020]        [<ffffffff8108076c>] clocksource_change_rating+0x34/0xaf
[   43.090020]        [<ffffffff8108091a>] clocksource_watchdog_work+0x133/0x16f
[   43.090020]        [<ffffffff8106f9ca>] run_workqueue+0x161/0x265
[   43.090020]        [<ffffffff8106fbb3>] worker_thread+0xe5/0x10c
[   43.090020]        [<ffffffff81074b64>] kthread+0x98/0xa0
[   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
[   43.090020] 
[   43.090020] -> #1 (&watchdog_work){+.+...}:
[   43.090020]        [<ffffffff8108925d>] check_prev_add+0x18e/0x225
[   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
[   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
[   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
[   43.090020]        [<ffffffff8106f9c4>] run_workqueue+0x15b/0x265
[   43.090020]        [<ffffffff8106fbb3>] worker_thread+0xe5/0x10c
[   43.090020]        [<ffffffff81074b64>] kthread+0x98/0xa0
[   43.090020]        [<ffffffff8101520a>] child_rip+0xa/0x20
[   43.090020] 
[   43.090020] -> #0 (events){+.+.+.}:
[   43.090020]        [<ffffffff81089146>] check_prev_add+0x77/0x225
[   43.090020]        [<ffffffff8108976a>] validate_chain+0x476/0x556
[   43.090020]        [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
[   43.090020]        [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
[   43.090020]        [<ffffffff8106ff73>] cleanup_workqueue_thread+0x54/0xdd
[   43.090020]        [<ffffffff81839c41>] workqueue_cpu_callback+0xdb/0x13f
[   43.090020]        [<ffffffff8187714e>] notifier_call_chain+0x6d/0xb5
[   43.090020]        [<ffffffff8107a19e>] raw_notifier_call_chain+0x22/0x38
[   43.090020]        [<ffffffff81838735>] _cpu_down+0x2c2/0x2fc
[   43.090020]        [<ffffffff818387cc>] cpu_down+0x5d/0xb4
[   43.090020]        [<ffffffff8183988e>] store_online+0x3f/0x9a
[   43.090020]        [<ffffffff813c2e41>] sysdev_store+0x2e/0x44
[   43.090020]        [<ffffffff811559a5>] sysfs_write_file+0xf3/0x13c
[   43.090020]        [<ffffffff810f6f7a>] vfs_write+0xbe/0x130
[   43.090020]        [<ffffffff810f70e2>] sys_write+0x56/0x93
[   43.090020]        [<ffffffff81014042>] system_call_fastpath+0x16/0x1b
[   43.090020] 
[   43.090020] other info that might help us debug this:
[   43.090020] 
[   43.090020] 2 locks held by S99local/5002:
[   43.090020]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811558f9>] sysfs_write_file+0x47/0x13c
[   43.090020]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff818387aa>] cpu_down+0x3b/0xb4
[   43.090020] 
[   43.090020] stack backtrace:
[   43.090020] Pid: 5002, comm: S99local Not tainted 2.6.31-rc6-tip-01039-ge54d9cb-dirty #4937
[   43.090020] Call Trace:
[   43.090020]  [<ffffffff81088bb0>] print_circular_bug+0xcf/0xf4
[   43.090020]  [<ffffffff81089146>] check_prev_add+0x77/0x225
[   43.090020]  [<ffffffff818710e5>] ? wait_for_common+0xeb/0x150
[   43.090020]  [<ffffffff8108976a>] validate_chain+0x476/0x556
[   43.090020]  [<ffffffff81087d17>] ? mark_lock+0x31/0x17d
[   43.090020]  [<ffffffff81089bfa>] __lock_acquire+0x3b0/0x43b
[   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
[   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
[   43.090020]  [<ffffffff81089d5a>] lock_acquire+0xd5/0x10e
[   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
[   43.090020]  [<ffffffff81871283>] ? wait_for_completion+0x2b/0x41
[   43.090020]  [<ffffffff81074be5>] ? kthread_stop+0x79/0xd9
[   43.090020]  [<ffffffff8106ff73>] cleanup_workqueue_thread+0x54/0xdd
[   43.090020]  [<ffffffff8106ff4c>] ? cleanup_workqueue_thread+0x2d/0xdd
[   43.090020]  [<ffffffff81839c41>] workqueue_cpu_callback+0xdb/0x13f
[   43.090020]  [<ffffffff8187714e>] notifier_call_chain+0x6d/0xb5
[   43.090020]  [<ffffffff8107a19e>] raw_notifier_call_chain+0x22/0x38
[   43.090020]  [<ffffffff81838735>] _cpu_down+0x2c2/0x2fc
[   43.090020]  [<ffffffff818710e5>] ? wait_for_common+0xeb/0x150
[   43.090020]  [<ffffffff818387cc>] cpu_down+0x5d/0xb4
[   43.090020]  [<ffffffff8183988e>] store_online+0x3f/0x9a
[   43.090020]  [<ffffffff813c2e41>] sysdev_store+0x2e/0x44
[   43.090020]  [<ffffffff811559a5>] sysfs_write_file+0xf3/0x13c
[   43.090020]  [<ffffffff810f65fa>] ? rw_verify_area+0x97/0xd1
[   43.090020]  [<ffffffff810f6f7a>] vfs_write+0xbe/0x130
[   43.090020]  [<ffffffff810f70e2>] sys_write+0x56/0x93
[   43.090020]  [<ffffffff81014042>] system_call_fastpath+0x16/0x1b
[   43.829633] lockdep: fixing up alternatives.
[   43.834022] SMP alternatives: switching to SMP code
[   43.844201] Booting processor 1 APIC 0x1 ip 0x6000
[   43.059854] Initializing CPU#1
[   43.059854] masked ExtINT on CPU#1
[   43.059854] Calibrating delay using timer specific routine.. 4020.21 BogoMIPS (lpj=20101052)
[   43.059854] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   43.059854] CPU: L2 Cache: 512K (64 bytes/line)
[   43.059854] CPU 1/0x1 -> Node 0
[   43.059854] CPU: Physical Processor ID: 0
[   43.059854] CPU: Processor Core ID: 1
[   43.059854] mce: CPU supports 5 MCE banks
[   43.059854] numa_add_cpu cpu 1 node 0: mask now 0-1
[   44.010131] CPU1: 
[   44.020028] Switched to high resolution mode on CPU 1
[   44.063664] AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   44.111395] Registering sys device of class 'machinecheck'
[   44.116925] Registering sys device 'machinecheck1'
[   44.152752] numa_remove_cpu cpu 1 node 0: mask now 0
[   44.153909] CPU 1 is now offline
[   44.162169] lockdep: fixing up alternatives.
[   44.166466] SMP alternatives: switching to UP code
[   44.202738] lockdep: fixing up alternatives.
[   44.207016] SMP alternatives: switching to SMP code
[   44.217494] Booting processor 1 APIC 0x1 ip 0x6000
[   44.181294] Initializing CPU#1
[   44.181294] masked ExtINT on CPU#1
[   44.181294] Calibrating delay using timer specific routine.. 4020.67 BogoMIPS (lpj=20103372)
[   44.181294] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   44.181294] CPU: L2 Cache: 512K (64 bytes/line)
[   44.181294] CPU 1/0x1 -> Node 0
[   44.181294] CPU: Physical Processor ID: 0
[   44.181294] CPU: Processor Core ID: 1
[   44.181294] mce: CPU supports 5 MCE banks
[   44.181294] numa_add_cpu cpu 1 node 0: mask now 0-1
[   44.380053] CPU1: 
[   44.390028] Switched to high resolution mode on CPU 1
[   44.433633] AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   44.497501] Registering sys device of class 'machinecheck'
[   44.503042] Registering sys device 'machinecheck1'
[   54.222933] device: 'vcs2': device_add
[   54.223059] PM: Adding info for No Bus:vcs2
[   54.223334] device: 'vcsa2': device_add
[   54.223389] PM: Adding info for No Bus:vcsa2
[   54.241967] device: 'vcs3': device_add
[   54.242086] PM: Adding info for No Bus:vcs3
[   54.242370] device: 'vcsa3': device_add
[   54.242433] PM: Adding info for No Bus:vcsa3
[   54.269818] device: 'vcs5': device_add
[   54.269953] PM: Adding info for No Bus:vcs5
[   54.271338] device: 'vcsa5': device_add
[   54.271471] PM: Adding info for No Bus:vcsa5
[   54.292644] device: 'vcs4': device_add
[   54.292769] PM: Adding info for No Bus:vcs4
[   54.293022] device: 'vcsa4': device_add
[   54.293073] PM: Adding info for No Bus:vcsa4
[   54.309636] device: 'vcs6': device_add
[   54.309696] PM: Adding info for No Bus:vcs6
[   54.309910] device: 'vcsa6': device_add
[   54.309983] PM: Adding info for No Bus:vcsa6

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31-rc6
# Mon Aug 17 11:04:07 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
# CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED is not set
# CONFIG_BOOTPARAM_SUPPORT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_BOOT_ALLOWED4=y
CONFIG_BROKEN_BOOT_ALLOWED3=y
# CONFIG_BROKEN_BOOT_ALLOWED2 is not set
# CONFIG_BROKEN_BOOT_DISALLOWED is not set
# CONFIG_BROKEN_BOOT_EUROPE is not set
# CONFIG_BROKEN_BOOT_TITAN is not set
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y

#
# GCOV-based kernel profiling
#
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP_SUPPORT=y
CONFIG_X86_X2APIC=y
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_X86_CPU_DEBUG=y
CONFIG_UP_WANTED_1=y
CONFIG_UP_WANTED_2=y
# CONFIG_UP_WANTED is not set
CONFIG_SMP=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_MIGRATION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MTRR is not set
CONFIG_EFI=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
# CONFIG_DMAR_DEFAULT_ON is not set
CONFIG_DMAR_BROKEN_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
CONFIG_DEFAULT_HTCP=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="htcp"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=m
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_PPTP is not set
CONFIG_NF_CONNTRACK_SANE=m
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=y
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
# CONFIG_NETFILTER_XT_MATCH_HL is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
# CONFIG_IP_VS_FTP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_MATCH_AH=y
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
# CONFIG_IP6_NF_MATCH_EUI64 is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
CONFIG_IP6_NF_MATCH_OPTS=m
# CONFIG_IP6_NF_MATCH_HL is not set
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
# CONFIG_IP6_NF_MATCH_MH is not set
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
# CONFIG_IP6_NF_TARGET_LOG is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_IP6_NF_SECURITY is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=m
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
# CONFIG_IPDDP is not set
CONFIG_X25=m
CONFIG_LAPB=y
CONFIG_ECONET=m
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=m
CONFIG_IEEE802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=m
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_TCPPROBE=y
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
# CONFIG_ESI_DONGLE is not set
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=y
# CONFIG_TOIM3232_DONGLE is not set
CONFIG_LITELINK_DONGLE=y
CONFIG_MA600_DONGLE=y
CONFIG_GIRBIL_DONGLE=y
# CONFIG_MCP2120_DONGLE is not set
CONFIG_OLD_BELKIN_DONGLE=m
# CONFIG_ACT200L_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
CONFIG_MAC80211_DEFAULT_PS_VALUE=0
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
CONFIG_DELL_LAPTOP=m
# CONFIG_ISL29003 is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
# CONFIG_SCSI_IPR_DUMP is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
CONFIG_SCSI_LPFC=y
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=m
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=m
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=m
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OPTI=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RZ1000=m
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_SCH=m
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
# CONFIG_FUSION_LAN is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
# CONFIG_DUMMY is not set
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_NET_SB1000=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
CONFIG_CASSINI=m
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_VORTEX=y
# CONFIG_ENC28J60 is not set
# CONFIG_ETHOC is not set
CONFIG_DNET=m
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
# CONFIG_ULI526X is not set
CONFIG_PCMCIA_XIRCOM=m
CONFIG_HP100=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=m
CONFIG_SIS900=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC9420=m
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
CONFIG_KS8851=y
# CONFIG_VIA_RHINE is not set
CONFIG_SC92031=m
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=y
CONFIG_E1000=m
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
CONFIG_IGB=m
CONFIG_IGB_DCA=y
# CONFIG_IGBVF is not set
CONFIG_NS83820=y
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=m
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_JME=y
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
# CONFIG_IBMOL is not set
CONFIG_3C359=y
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=y
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBIPW=y
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
# CONFIG_HERMES is not set
CONFIG_IWM=m
CONFIG_IWM_DEBUG=y

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=y
# CONFIG_USB_USBNET is not set
CONFIG_USB_CDC_PHONET=m
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_FDDI=y
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
# CONFIG_ISDN_PPP is not set
# CONFIG_ISDN_AUDIO is not set
# CONFIG_ISDN_X25 is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
# CONFIG_HISAX_TELESPCI is not set
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_DIEHLDIVA is not set
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
# CONFIG_HISAX_NETJET_U is not set
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_BKM_A4T=y
# CONFIG_HISAX_SCT_QUADRO is not set
# CONFIG_HISAX_GAZEL is not set
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
# CONFIG_HISAX_ST5481 is not set
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
CONFIG_HYSDN=m
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_PHONE=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m
# CONFIG_XEN_KBDDEV_FRONTEND is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
# CONFIG_IPMI_SI is not set
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_TSL2550=m
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=m
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=m
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATK0110=m
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHER is not set
CONFIG_SENSORS_FSCPOS=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_MAX1111=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=m
CONFIG_TPS65010=m
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=y
CONFIG_AB3100_CORE=y
# CONFIG_EZX_PCAP is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_BQ24022=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_WM8400=m
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_CAPTURE_DRIVERS is not set
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=y
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_ARC is not set
CONFIG_FB_IMSTT=y
CONFIG_FB_UVESA=m
CONFIG_FB_EFI=y
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MULTIHEAD=y
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=m
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_BROADSHEET=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=y
CONFIG_UWB_HWA=m
# CONFIG_UWB_WHCI is not set
# CONFIG_UWB_WLP is not set
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=m
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_ALIX2=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_GPIO_PLATFORM is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_BD2802=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=y
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_SMX=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m

#
# TI VLYNQ
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_INTEL_MENLOW=m
CONFIG_ACPI_WMI=m
CONFIG_ACPI_ASUS=m
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=m
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NILFS2_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_EXPORTFS=y
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_BACKTRACE_SELF_TEST=m
CONFIG_LKDTM=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_SAMPLES=y
CONFIG_SAMPLE_MARKERS=m
CONFIG_SAMPLE_TRACEPOINTS=m
CONFIG_SAMPLE_KOBJECT=m
CONFIG_SAMPLE_KPROBES=m
CONFIG_SAMPLE_KRETPROBES=m
CONFIG_SAMPLE_HW_BREAKPOINT=m
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=m
CONFIG_KGDB_TESTS=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_IOMMU_LEAK=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_INTEL_TXT=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_64=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y

--AqsLC8rIMeq19msA--
