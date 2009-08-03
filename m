Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZHCHGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZHCHGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 03:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZHCHGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 03:06:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbZHCHFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 03:05:52 -0400
Date: Mon, 3 Aug 2009 09:04:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org, ego@in.ibm.com
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090803070458.GA27581@elte.hu>
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090802221324.GP6854@linux.vnet.ibm.com>
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


i've attached the full serial bootlog with the warning in it. This 
should address your question about what the order of initialization 
is, right?

Let me know if you still would like me to run your diagnostic patch 
too.

	Ingo

[    0.000000] Linux version 2.6.31-rc5-tip (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #291 SMP PREEMPT Sun Aug 2 22:49:56 CEST 2009
[    0.000000] Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3 nolapic_timer hpet=disable idle=poll highmem=512m nopat acpi=off pci=nomsi
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
[    0.000000] using polling idle threads.
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  modified: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  modified: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 100000-302000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000003fff0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [0000000000008000 - 0000000000046fff]
[    0.000000]   bootmap [0000000000047000 -  000000000004efff] pages 8
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00033f8d90]    TEXT DATA BSS ==> [0001000000 - 00033f8d90]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [0000100000 - 0000300000]          PGTABLE ==> [0000100000 - 0000300000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000]  [ffffea0000000000-ffffea00015fffff] PMD -> [ffff880003800000-ffff880004dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262026
[    0.000000]   DMA zone: 88 pages used for memmap
[    0.000000]   DMA zone: 611 pages reserved
[    0.000000]   DMA zone: 3295 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 5544 pages used for memmap
[    0.000000]   DMA32 zone: 252488 pages, LIFO batch:31
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: f1400-f152c
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is PCI   
[    0.000000] Bus #2 is PCI   
[    0.000000] Bus #3 is PCI   
[    0.000000] Bus #4 is PCI   
[    0.000000] Bus #5 is PCI   
[    0.000000] Bus #6 is ISA   
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 00
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages at ffff88000347c000, static data 95072 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255783
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3 nolapic_timer hpet=disable idle=poll highmem=512m nopat acpi=off pci=nomsi
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 985624k/1048512k available (15196k kernel code, 408k absent, 62480k reserved, 9977k data, 868k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:424
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.639 MHz processor.
[    0.000015] spurious 8259A interrupt: IRQ7.
[    0.006744] Console: colour VGA+ 80x25
[    0.010000] console [ttyS0] enabled, bootconsole disabled
[    0.010000] console [ttyS0] enabled, bootconsole disabled
[    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.010000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.010000] ... MAX_LOCK_DEPTH:          48
[    0.010000] ... MAX_LOCKDEP_KEYS:        8191
[    0.010000] ... CLASSHASH_SIZE:          4096
[    0.010000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.010000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.010000] ... CHAINHASH_SIZE:          16384
[    0.010000]  memory used by lock dependency info: 5823 kB
[    0.010000]  per task-struct memory footprint: 1920 bytes
[    0.010000] ------------------------
[    0.010000] | Locking API testsuite:
[    0.010000] ----------------------------------------------------------------------------
[    0.010000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]               recursive read-lock:             |  ok  |             |failed|
[    0.010000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.010000]             mixed read-write-lock:             |failed|             |failed|
[    0.010000]             mixed write-read-lock:             |failed|             |failed|
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.010000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.010000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.010000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.010000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.010000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.010000] --------------------------------------------------------
[    0.010000] 133 out of 218 testcases failed, as expected. |
[    0.010000] ----------------------------------------------------
[    0.010000] ODEBUG: 11 of 11 active objects replaced
[    0.010000] ODEBUG: selftest passed
[    0.010013] Calibrating delay loop (skipped), value calculated using timer frequency.. 4021.27 BogoMIPS (lpj=20106390)
[    0.020634] Security Framework initialized
[    0.024730] TOMOYO Linux initialized
[    0.028979] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.030924] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.040482] Mount-cache hash table entries: 256
[    0.050722] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.057847] CPU: L2 Cache: 512K (64 bytes/line)
[    0.060006] CPU 0/0x0 -> Node 0
[    0.063146] tseg: 0000000000
[    0.066032] CPU: Physical Processor ID: 0
[    0.070003] CPU: Processor Core ID: 0
[    0.073660] mce: CPU supports 5 MCE banks
[    0.080899] debug: unmapping init memory ffffffff8289a000..ffffffff828ac000
[    0.088243] Setting APIC routing to flat
[    0.090012] enabled ExtINT on CPU#0
[    0.093548] ExtINT not setup in hardware but reported by MP table
[    0.100094] ENABLING IO-APIC IRQs
[    0.103408] init IO_APIC IRQs
[    0.106371]  2-0 (apicid-pin) not connected
[    0.110021] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.117334] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.120014] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
[    0.127323] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
[    0.130000] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
[    0.130000] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.130000] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.130000]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.130000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.130000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.130000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.130000] ..... (found apic 0 pin 0) ...
[    0.232854] ....... works.
[    0.235555] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.241237] Disabling APIC timer
[    0.250011] calling  migration_init+0x0/0x7f @ 1
[    0.254802] initcall migration_init+0x0/0x7f returned 0 after 0 usecs
[    0.260006] calling  spawn_ksoftirqd+0x0/0x7f @ 1
[    0.264792] initcall spawn_ksoftirqd+0x0/0x7f returned 0 after 0 usecs
[    0.270006] calling  init_call_single_data+0x0/0xd5 @ 1
[    0.275234] initcall init_call_single_data+0x0/0xd5 returned 0 after 0 usecs
[    0.280005] calling  spawn_softlockup_task+0x0/0x9b @ 1
[    0.290126] initcall spawn_softlockup_task+0x0/0x9b returned 0 after 0 usecs
[    0.297160] calling  relay_init+0x0/0x2d @ 1
[    0.300005] initcall relay_init+0x0/0x2d returned 0 after 0 usecs
[    0.306096] calling  tracer_alloc_buffers+0x0/0x2b6 @ 1
[    0.310195] initcall tracer_alloc_buffers+0x0/0x2b6 returned 0 after 0 usecs
[    0.320005] calling  init_trace_printk+0x0/0x2d @ 1
[    0.324882] initcall init_trace_printk+0x0/0x2d returned 0 after 0 usecs
[    0.330004] calling  trace_workqueue_early_init+0x0/0x164 @ 1
[    0.335806] initcall trace_workqueue_early_init+0x0/0x164 returned 0 after 0 usecs
[    0.350022] lockdep: fixing up alternatives.
[    0.354423] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] masked ExtINT on CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4020.69 BogoMIPS (lpj=20103483)
[    0.010000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.010000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.010000] CPU 1/0x1 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] mce: CPU supports 5 MCE banks
[    0.520258] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
[    0.530009] ------------[ cut here ]------------
[    0.530019] WARNING: at kernel/rcutree.c:1140 __rcu_process_callbacks+0x4b/0x294()
[    0.530024] Pid: 0, comm: swapper Not tainted 2.6.31-rc5-tip #291
[    0.530027] Call Trace:
[    0.530029]  <IRQ>  [<ffffffff810becbc>] ? __rcu_process_callbacks+0x4b/0x294
[    0.530037]  [<ffffffff8107c455>] warn_slowpath_common+0x68/0xab
[    0.530041]  [<ffffffff8107c4bf>] warn_slowpath_null+0x27/0x3d
[    0.530045]  [<ffffffff810becbc>] __rcu_process_callbacks+0x4b/0x294
[    0.530050]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    0.530055]  [<ffffffff810bef43>] rcu_process_callbacks+0x3e/0x76
[    0.530059]  [<ffffffff8108312a>] __do_softirq+0x12c/0x24b
[    0.530064]  [<ffffffff8102f44c>] call_softirq+0x1c/0x28
[    0.530068]  [<ffffffff8103177a>] do_softirq+0x56/0xb3
[    0.530073]  [<ffffffff810a5442>] ? tick_handle_periodic+0x35/0x9b
[    0.530077]  [<ffffffff8108274f>] irq_exit+0x57/0x7c
[    0.530083]  [<ffffffff81047643>] smp_apic_timer_interrupt+0xa0/0xc6
[    0.530088]  [<ffffffff8102ee33>] apic_timer_interrupt+0x13/0x20
[    0.530090]  <EOI>  [<ffffffff810374ca>] ? need_resched+0x53/0x54
[    0.530098]  [<ffffffff810375ac>] ? poll_idle+0x3c/0x5f
[    0.530102]  [<ffffffff8102d376>] ? enter_idle+0x38/0x4e
[    0.530106]  [<ffffffff8102d436>] ? cpu_idle+0xaa/0x110
[    0.530112]  [<ffffffff8290a187>] ? start_secondary+0x1c7/0x1e2
[    0.530119] ---[ end trace 93d72a36b9146f22 ]---
[    0.540003]  stepping 02
[    0.542554] Brought up 2 CPUs
[    0.550004] Total of 2 processors activated (8041.97 BogoMIPS).
[    0.556465] CPU0 attaching sched-domain:
[    0.560007]  domain 0: span 0-1 level CPU
[    0.564032]   groups: 0 1
[    0.570008] CPU1 attaching sched-domain:
[    0.573934]  domain 0: span 0-1 level CPU
[    0.577958]   groups: 1 0
[    0.581105] device: 'platform': device_add
[    0.585775] bus: 'platform': registered
[    0.589626] Registering sysdev class 'cpu'
[    0.590213] Registering sysdev class 'memory'
[    0.594788] Registering sys device of class 'memory'
[    0.600010] Registering sys device 'memory0'
[    0.604507] Registering sys device of class 'memory'
[    0.610008] Registering sys device 'memory1'
[    0.614511] Registering sys device of class 'memory'
[    0.620009] Registering sys device 'memory2'
[    0.624488] Registering sys device of class 'memory'
[    0.630008] Registering sys device 'memory3'
[    0.634469] Registering sys device of class 'memory'
[    0.640009] Registering sys device 'memory4'
[    0.644520] Registering sys device of class 'memory'
[    0.650008] Registering sys device 'memory5'
[    0.654481] Registering sys device of class 'memory'
[    0.660009] Registering sys device 'memory6'
[    0.664499] Registering sys device of class 'memory'
[    0.669460] Registering sys device 'memory7'
[    0.680699] calling  init_cpufreq_transition_notifier_list+0x0/0x42 @ 1
[    0.687308] initcall init_cpufreq_transition_notifier_list+0x0/0x42 returned 0 after 0 usecs
[    0.690006] calling  net_ns_init+0x0/0x11b @ 1
[    0.700016] initcall net_ns_init+0x0/0x11b returned 0 after 0 usecs
[    0.706277] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.710004] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.716175] calling  print_banner+0x0/0xe @ 1
[    0.720035] Booting paravirtualized kernel on bare hardware
[    0.725605] initcall print_banner+0x0/0xe returned 0 after 0 usecs
[    0.730004] calling  init_smp_flush+0x0/0x64 @ 1
[    0.734617] initcall init_smp_flush+0x0/0x64 returned 0 after 0 usecs
[    0.740004] calling  sysctl_init+0x0/0x59 @ 1
[    0.744570] initcall sysctl_init+0x0/0x59 returned 0 after 0 usecs
[    0.750003] calling  ksysfs_init+0x0/0xe4 @ 1
[    0.754637] initcall ksysfs_init+0x0/0xe4 returned 0 after 0 usecs
[    0.760020] calling  async_init+0x0/0x69 @ 1
[    0.770004] initcall async_init+0x0/0x69 returned 0 after 0 usecs
[    0.776088] calling  init_jiffies_clocksource+0x0/0x39 @ 1
[    0.780008] initcall init_jiffies_clocksource+0x0/0x39 returned 0 after 0 usecs
[    0.787309] calling  init_hw_breakpoint+0x0/0x39 @ 1
[    0.790006] initcall init_hw_breakpoint+0x0/0x39 returned 0 after 0 usecs
[    0.800027] calling  filelock_init+0x0/0x55 @ 1
[    0.804637] initcall filelock_init+0x0/0x55 returned 0 after 0 usecs
[    0.810004] calling  init_misc_binfmt+0x0/0x67 @ 1
[    0.814800] initcall init_misc_binfmt+0x0/0x67 returned 0 after 0 usecs
[    0.820004] calling  init_script_binfmt+0x0/0x3b @ 1
[    0.824963] initcall init_script_binfmt+0x0/0x3b returned 0 after 0 usecs
[    0.830004] calling  init_elf_binfmt+0x0/0x3b @ 1
[    0.834704] initcall init_elf_binfmt+0x0/0x3b returned 0 after 0 usecs
[    0.840019] calling  init_compat_elf_binfmt+0x0/0x3b @ 1
[    0.850004] initcall init_compat_elf_binfmt+0x0/0x3b returned 0 after 0 usecs
[    0.857128] calling  debugfs_init+0x0/0x80 @ 1
[    0.860011] initcall debugfs_init+0x0/0x80 returned 0 after 0 usecs
[    0.866269] calling  securityfs_init+0x0/0x77 @ 1
[    0.870011] initcall securityfs_init+0x0/0x77 returned 0 after 0 usecs
[    0.880019] calling  random32_init+0x0/0xff @ 1
[    0.884547] initcall random32_init+0x0/0xff returned 0 after 0 usecs
[    0.890003] calling  cpufreq_core_init+0x0/0xaa @ 1
[    0.894878] initcall cpufreq_core_init+0x0/0xaa returned 0 after 0 usecs
[    0.900005] calling  virtio_init+0x0/0x52 @ 1
[    0.904567] bus: 'virtio': registered
[    0.910005] initcall virtio_init+0x0/0x52 returned 0 after 9765 usecs
[    0.916434] calling  sock_init+0x0/0x80 @ 1
[    0.920220] initcall sock_init+0x0/0x80 returned 0 after 0 usecs
[    0.926216] calling  netpoll_init+0x0/0x69 @ 1
[    0.930004] initcall netpoll_init+0x0/0x69 returned 0 after 0 usecs
[    0.936268] calling  netlink_proto_init+0x0/0x169 @ 1
[    0.940054] NET: Registered protocol family 16
[    0.944557] initcall netlink_proto_init+0x0/0x169 returned 0 after 0 usecs
[    0.950027] calling  bdi_class_init+0x0/0x68 @ 1
[    0.954642] device class 'bdi': registering
[    0.960271] initcall bdi_class_init+0x0/0x68 returned 0 after 9765 usecs
[    0.970005] calling  kobject_uevent_init+0x0/0x7b @ 1
[    0.975070] initcall kobject_uevent_init+0x0/0x7b returned 0 after 0 usecs
[    0.980004] calling  gpiolib_sysfs_init+0x0/0xbc @ 1
[    0.984961] device class 'gpio': registering
[    0.990252] initcall gpiolib_sysfs_init+0x0/0xbc returned 0 after 9765 usecs
[    0.997293] calling  pcibus_class_init+0x0/0x40 @ 1
[    1.000004] device class 'pci_bus': registering
[    1.004788] initcall pcibus_class_init+0x0/0x40 returned 0 after 0 usecs
[    1.010004] calling  pci_driver_init+0x0/0x39 @ 1
[    1.020227] bus: 'pci': registered
[    1.023630] initcall pci_driver_init+0x0/0x39 returned 0 after 0 usecs
[    1.030005] calling  lcd_class_init+0x0/0x74 @ 1
[    1.034623] device class 'lcd': registering
[    1.039024] initcall lcd_class_init+0x0/0x74 returned 0 after 0 usecs
[    1.040004] calling  backlight_class_init+0x0/0x84 @ 1
[    1.050003] device class 'backlight': registering
[    1.054907] initcall backlight_class_init+0x0/0x84 returned 0 after 0 usecs
[    1.060005] calling  tty_class_init+0x0/0x58 @ 1
[    1.064617] device class 'tty': registering
[    1.070242] initcall tty_class_init+0x0/0x58 returned 0 after 9765 usecs
[    1.076936] calling  vtconsole_class_init+0x0/0xe8 @ 1
[    1.080005] device class 'vtconsole': registering
[    1.084930] device: 'vtcon0': device_add
[    1.090293] initcall vtconsole_class_init+0x0/0xe8 returned 0 after 9765 usecs
[    1.100005] calling  register_node_type+0x0/0xa4 @ 1
[    1.104960] Registering sysdev class 'node'
[    1.109376] initcall register_node_type+0x0/0xa4 returned 0 after 0 usecs
[    1.110005] calling  spi_init+0x0/0xd4 @ 1
[    1.120238] bus: 'spi': registered
[    1.123635] device class 'spi_master': registering
[    1.128652] initcall spi_init+0x0/0xd4 returned 0 after 0 usecs
[    1.130006] calling  i2c_init+0x0/0x8c @ 1
[    1.134334] bus: 'i2c': registered
[    1.140003] device class 'i2c-adapter': registering
[    1.145077] bus: 'i2c': add driver dummy
[    1.150253] initcall i2c_init+0x0/0x8c returned 0 after 19531 usecs
[    1.156512] calling  amd_postcore_init+0x0/0xa3 @ 1
[    1.160008] node 0 link 0: io port [1000, fffff]
[    1.164624] TOM: 0000000040000000 aka 1024M
[    1.170003] node 0 link 0: mmio [e0000000, efffffff]
[    1.174979] node 0 link 0: mmio [feb00000, fec0ffff]
[    1.180200] node 0 link 0: mmio [a0000, bffff]
[    1.184659] node 0 link 0: mmio [40000000, fed3ffff]
[    1.190215] bus: [00,ff] on node 0 link 0
[    1.194224] bus: 00 index 0 io port: [0, ffff]
[    1.200003] bus: 00 index 1 mmio: [40000000, fcffffffff]
[    1.205308] bus: 00 index 2 mmio: [feb00000, fec0ffff]
[    1.210003] bus: 00 index 3 mmio: [a0000, bffff]
[    1.214618] initcall amd_postcore_init+0x0/0xa3 returned 0 after 48828 usecs
[    1.220003] calling  arch_kdebugfs_init+0x0/0x2a7 @ 1
[    1.225086] initcall arch_kdebugfs_init+0x0/0x2a7 returned 0 after 0 usecs
[    1.230018] calling  mtrr_if_init+0x0/0x8a @ 1
[    1.234470] initcall mtrr_if_init+0x0/0x8a returned 0 after 0 usecs
[    1.240004] calling  dma_bus_init+0x0/0x66 @ 1
[    1.244442] device class 'dma': registering
[    1.250225] initcall dma_bus_init+0x0/0x66 returned 0 after 9765 usecs
[    1.260004] calling  dma_channel_table_init+0x0/0x137 @ 1
[    1.265409] initcall dma_channel_table_init+0x0/0x137 returned 0 after 0 usecs
[    1.270004] calling  dca_init+0x0/0x45 @ 1
[    1.274093] dca service started, version 1.8
[    1.280017] device class 'dca': registering
[    1.284444] initcall dca_init+0x0/0x45 returned 0 after 9765 usecs
[    1.290005] calling  pci_arch_init+0x0/0x67 @ 1
[    1.294841] PCI: Using configuration type 1 for base access
[    1.300005] initcall pci_arch_init+0x0/0x67 returned 0 after 9765 usecs
[    1.306609] calling  topology_init+0x0/0xe0 @ 1
[    1.310003] Registering sys device of class 'node'
[    1.314793] Registering sys device 'node0'
[    1.320256] Registering sys device of class 'cpu'
[    1.324956] Registering sys device 'cpu0'
[    1.330286] Registering sys device of class 'cpu'
[    1.334992] Registering sys device 'cpu1'
[    1.340225] initcall topology_init+0x0/0xe0 returned 0 after 29296 usecs
[    1.346919] calling  mtrr_init_finialize+0x0/0x64 @ 1
[    1.350006] initcall mtrr_init_finialize+0x0/0x64 returned 0 after 0 usecs
[    1.356874] calling  param_sysfs_init+0x0/0x37b @ 1
[    1.579904] initcall param_sysfs_init+0x0/0x37b returned 0 after 205078 usecs
[    1.581017] calling  init_slow_work+0x0/0x5f @ 1
[    1.590005] initcall init_slow_work+0x0/0x5f returned 0 after 0 usecs
[    1.596434] calling  default_bdi_init+0x0/0x5e @ 1
[    1.600020] device: 'default': device_add
[    1.604377] initcall default_bdi_init+0x0/0x5e returned 0 after 0 usecs
[    1.611124] calling  init_bio+0x0/0x100 @ 1
[    1.621337] bio: create slab <bio-0> at 0
[    1.625444] initcall init_bio+0x0/0x100 returned 0 after 0 usecs
[    1.630925] calling  fsnotify_init+0x0/0x39 @ 1
[    1.635459] initcall fsnotify_init+0x0/0x39 returned 0 after 0 usecs
[    1.640005] calling  fsnotify_notification_init+0x0/0x129 @ 1
[    1.645853] initcall fsnotify_notification_init+0x0/0x129 returned 0 after 0 usecs
[    1.650026] calling  cryptomgr_init+0x0/0x39 @ 1
[    1.660005] initcall cryptomgr_init+0x0/0x39 returned 0 after 0 usecs
[    1.666434] calling  blk_settings_init+0x0/0x51 @ 1
[    1.670004] initcall blk_settings_init+0x0/0x51 returned 0 after 0 usecs
[    1.676694] calling  blk_ioc_init+0x0/0x51 @ 1
[    1.680043] initcall blk_ioc_init+0x0/0x51 returned 0 after 0 usecs
[    1.690019] calling  blk_softirq_init+0x0/0x8f @ 1
[    1.694805] initcall blk_softirq_init+0x0/0x8f returned 0 after 0 usecs
[    1.700004] calling  genhd_device_init+0x0/0x8c @ 1
[    1.704875] device class 'block': registering
[    1.710394] initcall genhd_device_init+0x0/0x8c returned 0 after 9765 usecs
[    1.717344] calling  gpiolib_debugfs_init+0x0/0x4b @ 1
[    1.720122] initcall gpiolib_debugfs_init+0x0/0x4b returned 0 after 0 usecs
[    1.730004] calling  max7301_init+0x0/0x39 @ 1
[    1.734445] bus: 'spi': add driver max7301
[    1.738825] initcall max7301_init+0x0/0x39 returned 0 after 0 usecs
[    1.740261] calling  max732x_init+0x0/0x3b @ 1
[    1.750054] bus: 'i2c': add driver max732x
[    1.754367] initcall max732x_init+0x0/0x3b returned 0 after 0 usecs
[    1.760045] calling  mcp23s08_init+0x0/0x39 @ 1
[    1.764571] bus: 'spi': add driver mcp23s08
[    1.770071] initcall mcp23s08_init+0x0/0x39 returned 0 after 9765 usecs
[    1.776678] calling  pcf857x_init+0x0/0x3b @ 1
[    1.780003] bus: 'i2c': add driver pcf857x
[    1.784308] initcall pcf857x_init+0x0/0x3b returned 0 after 0 usecs
[    1.790005] calling  gpio_twl4030_init+0x0/0x39 @ 1
[    1.794874] bus: 'platform': add driver twl4030_gpio
[    1.800215] initcall gpio_twl4030_init+0x0/0x39 returned 0 after 9765 usecs
[    1.807173] calling  pci_slot_init+0x0/0x73 @ 1
[    1.810014] initcall pci_slot_init+0x0/0x73 returned 0 after 0 usecs
[    1.816364] calling  misc_init+0x0/0xd6 @ 1
[    1.820026] device class 'misc': registering
[    1.824517] initcall misc_init+0x0/0xd6 returned 0 after 0 usecs
[    1.830006] calling  cn_init+0x0/0x11a @ 1
[    1.834149] initcall cn_init+0x0/0x11a returned 0 after 0 usecs
[    1.840004] calling  tifm_init+0x0/0xab @ 1
[    1.844520] bus: 'tifm': registered
[    1.850003] device class 'tifm_adapter': registering
[    1.855186] initcall tifm_init+0x0/0xab returned 0 after 9765 usecs
[    1.860004] calling  tps_init+0x0/0xa4 @ 1
[    1.864094] tps65010: version 2 May 2005
[    1.870003] bus: 'i2c': add driver tps65010
[    1.874414] bus: 'i2c': remove driver tps65010
[    1.880261] driver: 'tps65010': driver_release
[    1.900010] bus: 'i2c': add driver tps65010
[    1.904449] bus: 'i2c': remove driver tps65010
[    1.909082] driver: 'tps65010': driver_release
[    1.930062] bus: 'i2c': add driver tps65010
[    1.934472] bus: 'i2c': remove driver tps65010
[    1.939102] driver: 'tps65010': driver_release
[    1.940034] tps65010: no chip?
[    1.943090] initcall tps_init+0x0/0xa4 returned -19 after 78125 usecs
[    1.950004] calling  twl4030_init+0x0/0x3b @ 1
[    1.954441] bus: 'i2c': add driver twl4030
[    1.960222] initcall twl4030_init+0x0/0x3b returned 0 after 9765 usecs
[    1.966739] calling  da903x_init+0x0/0x3b @ 1
[    1.970080] bus: 'i2c': add driver da903x
[    1.974311] initcall da903x_init+0x0/0x3b returned 0 after 0 usecs
[    1.980055] calling  pcf50633_init+0x0/0x3b @ 1
[    1.984579] bus: 'i2c': add driver pcf50633
[    1.990239] initcall pcf50633_init+0x0/0x3b returned 0 after 9765 usecs
[    1.996841] calling  init_scsi+0x0/0xb7 @ 1
[    2.000790] device class 'scsi_host': registering
[    2.005987] bus: 'scsi': registered
[    2.010026] device class 'scsi_device': registering
[    2.015146] SCSI subsystem initialized
[    2.020023] initcall init_scsi+0x0/0xb7 returned 0 after 19531 usecs
[    2.026366] calling  ata_init+0x0/0x3b3 @ 1
[    2.030339] libata version 3.00 loaded.
[    2.034175] initcall ata_init+0x0/0x3b3 returned 0 after 0 usecs
[    2.040007] calling  phy_init+0x0/0x57 @ 1
[    2.044096] device class 'mdio_bus': registering
[    2.050458] bus: 'mdio_bus': registered
[    2.054295] bus: 'mdio_bus': add driver Generic PHY
[    2.060234] initcall phy_init+0x0/0x57 returned 0 after 19531 usecs
[    2.066495] calling  usb_init+0x0/0x185 @ 1
[    2.070256] bus: 'usb': registered
[    2.073668] bus: 'usb': add driver usbfs
[    2.077830] usbcore: registered new interface driver usbfs
[    2.080012] bus: 'usb': add driver hub
[    2.083986] usbcore: registered new interface driver hub
[    2.090089] bus: 'usb': add driver usb
[    2.094047] usbcore: registered new device driver usb
[    2.100005] initcall usb_init+0x0/0x185 returned 0 after 29296 usecs
[    2.106355] calling  serio_init+0x0/0xb2 @ 1
[    2.110238] bus: 'serio': registered
[    2.113894] initcall serio_init+0x0/0xb2 returned 0 after 0 usecs
[    2.120005] calling  gameport_init+0x0/0xb2 @ 1
[    2.124806] bus: 'gameport': registered
[    2.130088] initcall gameport_init+0x0/0xb2 returned 0 after 9765 usecs
[    2.136693] calling  input_init+0x0/0x15d @ 1
[    2.140004] device class 'input': registering
[    2.144608] initcall input_init+0x0/0x15d returned 0 after 0 usecs
[    2.150005] calling  pps_init+0x0/0xd7 @ 1
[    2.154096] device class 'pps': registering
[    2.160205] LinuxPPS API ver. 1 registered
[    2.164295] Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.170006] initcall pps_init+0x0/0xd7 returned 0 after 19531 usecs
[    2.180003] calling  power_supply_class_init+0x0/0x5f @ 1
[    2.185396] device class 'power_supply': registering
[    2.190207] initcall power_supply_class_init+0x0/0x5f returned 0 after 9765 usecs
[    2.197681] calling  thermal_init+0x0/0x7e @ 1
[    2.200008] device class 'thermal': registering
[    2.204802] initcall thermal_init+0x0/0x7e returned 0 after 0 usecs
[    2.210004] calling  mmc_init+0x0/0x9c @ 1
[    2.214432] bus: 'mmc': registered
[    2.220004] device class 'mmc_host': registering
[    2.225103] bus: 'sdio': registered
[    2.230005] initcall mmc_init+0x0/0x9c returned 0 after 19531 usecs
[    2.236260] calling  leds_init+0x0/0x67 @ 1
[    2.240004] device class 'leds': registering
[    2.244485] initcall leds_init+0x0/0x67 returned 0 after 0 usecs
[    2.250006] calling  ac97_bus_init+0x0/0x39 @ 1
[    2.254789] bus: 'ac97': registered
[    2.258279] initcall ac97_bus_init+0x0/0x39 returned 0 after 0 usecs
[    2.260005] calling  pci_subsys_init+0x0/0x136 @ 1
[    2.270002] PCI: Probing PCI hardware
[    2.273683] PCI: Probing PCI hardware (bus 00)
[    2.278136] device: 'pci0000:00': device_add
[    2.280020] device: '0000:00': device_add
[    2.284259] PCI: Scanning bus 0000:00
[    2.290058] pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
[    2.297060] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.300054] pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
[    2.310030] pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xec
[    2.316634] HPET not enabled in BIOS. You might try hpet=force boot option
[    2.320004] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.330045] pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
[    2.337007] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    2.340015] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    2.350006] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    2.355749] pci 0000:00:01.1: calling quirk_resource_alignment+0x0/0x1dd
[    2.360013] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    2.365837] pci 0000:00:01.1: PME# disabled
[    2.370048] pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
[    2.380014] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    2.386731] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.390012] pci 0000:00:02.0: supports D1 D2
[    2.394276] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.400004] pci 0000:00:02.0: PME# disabled
[    2.404204] pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
[    2.410033] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    2.420023] pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x1dd
[    2.426727] pci 0000:00:02.1: supports D1 D2
[    2.430003] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    2.440004] pci 0000:00:02.1: PME# disabled
[    2.444216] pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
[    2.450029] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    2.455770] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    2.460009] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    2.466719] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.470012] pci 0000:00:04.0: supports D1 D2
[    2.480025] pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
[    2.487000] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    2.490028] pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.500033] pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
[    2.507001] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.510023] pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
[    2.520014] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    2.526706] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    2.530036] pci 0000:00:0a.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.536738] pci 0000:00:0a.0: supports D1 D2
[    2.540003] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.550004] pci 0000:00:0a.0: PME# disabled
[    2.554250] pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
[    2.560021] pci 0000:00:0b.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.566728] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.570019] pci 0000:00:0b.0: PME# disabled
[    2.574228] pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
[    2.580020] pci 0000:00:0c.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.590020] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.596626] pci 0000:00:0c.0: PME# disabled
[    2.600030] pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
[    2.610035] pci 0000:00:0d.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.616744] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.620004] pci 0000:00:0d.0: PME# disabled
[    2.624209] pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
[    2.630020] pci 0000:00:0e.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.640030] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.646633] pci 0000:00:0e.0: PME# disabled
[    2.650056] pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
[    2.660024] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.666744] pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
[    2.670024] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x1dd
[    2.680019] pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
[    2.686991] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x1dd
[    2.690034] pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
[    2.700023] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x1dd
[    2.706740] PCI: Fixups for bus 0000:00
[    2.710005] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
[    2.716964] PCI: Scanning bus 0000:05
[    2.720035] pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
[    2.727005] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    2.730022] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    2.740027] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.746731] pci 0000:05:07.0: supports D1 D2
[    2.750003] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    2.755743] pci 0000:05:07.0: PME# disabled
[    2.760047] PCI: Fixups for bus 0000:05
[    2.763880] pci 0000:00:09.0: transparent bridge
[    2.770019] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    2.775759] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    2.780004] PCI: Bus scan for 0000:05 returning with max=05
[    2.785571] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
[    2.790012] PCI: Scanning bus 0000:04
[    2.800056] PCI: Fixups for bus 0000:04
[    2.803895] PCI: Bus scan for 0000:04 returning with max=04
[    2.809468] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
[    2.810027] PCI: Scanning bus 0000:03
[    2.820056] PCI: Fixups for bus 0000:03
[    2.823893] PCI: Bus scan for 0000:03 returning with max=03
[    2.829457] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
[    2.830012] PCI: Scanning bus 0000:02
[    2.840056] PCI: Fixups for bus 0000:02
[    2.843896] PCI: Bus scan for 0000:02 returning with max=02
[    2.849468] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
[    2.850027] PCI: Scanning bus 0000:01
[    2.860022] pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
[    2.866977] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x47
[    2.870009] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    2.876705] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    2.880007] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    2.890033] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.896387] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x1dd
[    2.900021] pci 0000:01:00.0: supports D1 D2
[    2.904313] pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
[    2.910009] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x47
[    2.920008] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    2.926729] pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x1dd
[    2.930034] pci 0000:01:00.1: supports D1 D2
[    2.940070] PCI: Fixups for bus 0000:01
[    2.943908] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    2.950004] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    2.956696] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    2.960003] PCI: Bus scan for 0000:01 returning with max=01
[    2.965569] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
[    2.970021] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
[    2.980007] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
[    2.990005] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
[    2.996957] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
[    3.000005] PCI: Bus scan for 0000:00 returning with max=05
[    3.005568] device: '0000:00:00.0': device_add
[    3.010025] bus: 'pci': add device 0000:00:00.0
[    3.014867] device: '0000:00:01.0': device_add
[    3.020011] bus: 'pci': add device 0000:00:01.0
[    3.024813] device: '0000:00:01.1': device_add
[    3.030020] bus: 'pci': add device 0000:00:01.1
[    3.034810] device: '0000:00:02.0': device_add
[    3.040011] bus: 'pci': add device 0000:00:02.0
[    3.044828] device: '0000:00:02.1': device_add
[    3.050010] bus: 'pci': add device 0000:00:02.1
[    3.054798] device: '0000:00:04.0': device_add
[    3.060011] bus: 'pci': add device 0000:00:04.0
[    3.064853] device: '0000:00:06.0': device_add
[    3.069298] bus: 'pci': add device 0000:00:06.0
[    3.070257] device: '0000:00:09.0': device_add
[    3.074710] bus: 'pci': add device 0000:00:09.0
[    3.080277] device: '0000:00:0a.0': device_add
[    3.084723] bus: 'pci': add device 0000:00:0a.0
[    3.090266] device: '0000:00:0b.0': device_add
[    3.094716] bus: 'pci': add device 0000:00:0b.0
[    3.100286] device: '0000:00:0c.0': device_add
[    3.104736] bus: 'pci': add device 0000:00:0c.0
[    3.110279] device: '0000:00:0d.0': device_add
[    3.114725] bus: 'pci': add device 0000:00:0d.0
[    3.120326] device: '0000:00:0e.0': device_add
[    3.124770] bus: 'pci': add device 0000:00:0e.0
[    3.130269] device: '0000:00:18.0': device_add
[    3.134717] bus: 'pci': add device 0000:00:18.0
[    3.139532] device: '0000:00:18.1': device_add
[    3.140011] bus: 'pci': add device 0000:00:18.1
[    3.144818] device: '0000:00:18.2': device_add
[    3.150011] bus: 'pci': add device 0000:00:18.2
[    3.154801] device: '0000:00:18.3': device_add
[    3.160011] bus: 'pci': add device 0000:00:18.3
[    3.164820] device: '0000:05:07.0': device_add
[    3.170010] bus: 'pci': add device 0000:05:07.0
[    3.174803] device: '0000:05': device_add
[    3.180306] device: '0000:04': device_add
[    3.184542] device: '0000:03': device_add
[    3.188810] device: '0000:02': device_add
[    3.190235] device: '0000:01:00.0': device_add
[    3.194692] bus: 'pci': add device 0000:01:00.0
[    3.200279] device: '0000:01:00.1': device_add
[    3.204725] bus: 'pci': add device 0000:01:00.1
[    3.210268] device: '0000:01': device_add
[    3.214784] pci 0000:00:00.0: default IRQ router [10de:005e]
[    3.220374] initcall pci_subsys_init+0x0/0x136 returned 0 after 927734 usecs
[    3.227411] calling  proto_init+0x0/0x39 @ 1
[    3.230016] initcall proto_init+0x0/0x39 returned 0 after 0 usecs
[    3.240007] calling  net_dev_init+0x0/0x1c2 @ 1
[    3.244575] device class 'net': registering
[    3.249002] device: 'lo': device_add
[    3.250442] initcall net_dev_init+0x0/0x1c2 returned 0 after 9765 usecs
[    3.257049] calling  neigh_init+0x0/0x98 @ 1
[    3.260006] initcall neigh_init+0x0/0x98 returned 0 after 0 usecs
[    3.270003] calling  fib_rules_init+0x0/0xcc @ 1
[    3.274619] initcall fib_rules_init+0x0/0xcc returned 0 after 0 usecs
[    3.280007] calling  genl_init+0x0/0x100 @ 1
[    3.300047] initcall genl_init+0x0/0x100 returned 0 after 19531 usecs
[    3.306481] calling  cipso_v4_init+0x0/0xae @ 1
[    3.310024] initcall cipso_v4_init+0x0/0xae returned 0 after 0 usecs
[    3.316373] calling  wanrouter_init+0x0/0x79 @ 1
[    3.320003] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    3.327322] initcall wanrouter_init+0x0/0x79 returned 0 after 0 usecs
[    3.330004] calling  irda_init+0x0/0xcb @ 1
[    3.334180] irda_init()
[    3.340099] NET: Registered protocol family 23
[    3.344686] initcall irda_init+0x0/0xcb returned 0 after 9765 usecs
[    3.350004] calling  bt_init+0x0/0x81 @ 1
[    3.354007] Bluetooth: Core ver 2.15
[    3.360101] device class 'bluetooth': registering
[    3.365007] NET: Registered protocol family 31
[    3.370003] Bluetooth: HCI device and connection manager initialized
[    3.376364] Bluetooth: HCI socket layer initialized
[    3.380005] initcall bt_init+0x0/0x81 returned 0 after 29296 usecs
[    3.386173] calling  wireless_nlevent_init+0x0/0x69 @ 1
[    3.390004] initcall wireless_nlevent_init+0x0/0x69 returned 0 after 0 usecs
[    3.400005] calling  cfg80211_init+0x0/0x9f @ 1
[    3.404527] device class 'ieee80211': registering
[    3.460063] Registering platform device 'regulatory.0'. Parent at platform
[    3.466925] device: 'regulatory.0': device_add
[    3.470011] bus: 'platform': add device regulatory.0
[    3.475183] cfg80211: Using static regulatory domain info
[    3.480004] cfg80211: Regulatory domain: US
[    3.484181] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    3.490003] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    3.500005] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    3.506781] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    3.510003] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    3.520025] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    3.526807] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    3.530045] cfg80211: Calling CRDA for country: US
[    3.535050] initcall cfg80211_init+0x0/0x9f returned 0 after 126953 usecs
[    3.540005] calling  ieee80211_init+0x0/0x45 @ 1
[    3.550016] initcall ieee80211_init+0x0/0x45 returned 0 after 0 usecs
[    3.556453] calling  netlbl_init+0x0/0xa8 @ 1
[    3.560002] NetLabel: Initializing
[    3.563402] NetLabel:  domain hash size = 128
[    3.567759] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.570201] NetLabel:  unlabeled traffic allowed by default
[    3.575768] initcall netlbl_init+0x0/0xa8 returned 0 after 9765 usecs
[    3.580027] calling  rfkill_init+0x0/0xb1 @ 1
[    3.590002] device class 'rfkill': registering
[    3.594660] device: 'rfkill': device_add
[    3.598834] initcall rfkill_init+0x0/0xb1 returned 0 after 0 usecs
[    3.600005] calling  sysctl_init+0x0/0x6f @ 1
[    3.610006] initcall sysctl_init+0x0/0x6f returned 0 after 0 usecs
[    3.616176] calling  pci_iommu_init+0x0/0x4a @ 1
[    3.679259] DMA-API: preallocated 32768 debug entries
[    3.680026] DMA-API: debugging enabled by kernel config
[    3.685252] initcall pci_iommu_init+0x0/0x4a returned 0 after 58593 usecs
[    3.690005] calling  print_all_ICs+0x0/0x5a1 @ 1
[    3.700002] 
[    3.700003] printing PIC contents
[    3.704807] ... PIC  IMR: fffa
[    3.707864] ... PIC  IRR: 0001
[    3.710002] ... PIC  ISR: 0001
[    3.713058] ... PIC ELCR: 0828
[    3.716116] printing local APIC contents on CPU#0/0:
[    3.720000] ... APIC ID:      00000000 (0)
[    3.720000] ... APIC VERSION: 00040010
[    3.720000] ... APIC TASKPRI: 00000000 (00)
[    3.720000] ... APIC ARBPRI: 000000e0 (e0)
[    3.720000] ... APIC PROCPRI: 00000000
[    3.720000] ... APIC LDR: 01000000
[    3.720000] ... APIC DFR: ffffffff
[    3.720000] ... APIC SPIV: 000001ff
[    3.720000] ... APIC ISR field:
[    3.720000] 0000000000000000000000000000000000000000000000000000000000000000
[    3.720000] ... APIC TMR field:
[    3.720000] 0000000000000000000000000000000000000000000000000000000000000000
[    3.720000] ... APIC IRR field:
[    3.720000] 0000000000000000000000000000000000000000000000000000000000008000
[    3.720000] ... APIC ESR: 00000000
[    3.720000] ... APIC ICR: 000008ef
[    3.720000] ... APIC ICR2: 02000000
[    3.720000] ... APIC LVTT: 00010000
[    3.720000] ... APIC LVTPC: 00010000
[    3.720000] ... APIC LVT0: 00010700
[    3.720000] ... APIC LVT1: 00000400
[    3.720000] ... APIC LVTERR: 000000fe
[    3.720000] ... APIC TMICT: 00000000
[    3.720000] ... APIC TMCCT: 00000000
[    3.720000] ... APIC TDCR: 00000000
[    3.720000] 
[    3.719992] printing local APIC contents on CPU#1/1:
[    3.719992] ... APIC ID:      01000000 (1)
[    3.720000] ... APIC VERSION: 00040010
[    3.720000] ... APIC TASKPRI: 00000000 (00)
[    3.720000] ... APIC ARBPRI: 00000030 (30)
[    3.720000] ... APIC PROCPRI: 00000000
[    3.720000] ... APIC LDR: 02000000
[    3.720000] ... APIC DFR: ffffffff
[    3.720000] ... APIC SPIV: 000001ff
[    3.720000] ... APIC ISR field:
[    3.720000] 0000000000000000000000000000000000000000000000000000000000000000
[    3.720000] ... APIC TMR field:
[    3.720000] 0000000000000000000000000000000000000000000000000000000000000000
[    3.720000] ... APIC IRR field:
[    3.720000] 0000000000010000000000000000000000000000000000000000000000000000
[    3.720000] ... APIC ESR: 00000000
[    3.720000] ... APIC ICR: 000008ef
[    3.720000] ... APIC ICR2: 01000000
[    3.720000] ... APIC LVTT: 00010000
[    3.720000] ... APIC LVTPC: 00010000
[    3.720000] ... APIC LVT0: 00010700
[    3.720000] ... APIC LVT1: 00010400
[    3.720000] ... APIC LVTERR: 000000fe
[    3.720000] ... APIC TMICT: 00000000
[    3.720000] ... APIC TMCCT: 00000000
[    3.720000] ... APIC TDCR: 00000000
[    3.720000] 
[    3.730000] number of MP IRQ sources: 17.
[    3.730003] number of IO-APIC #2 registers: 24.
[    3.734528] testing the IO APIC.......................
[    3.740005] 
[    3.741497] IO APIC #2......
[    3.744374] .... register #00: 00000000
[    3.750002] .......    : physical APIC id: 00
[    3.754355] .......    : Delivery Type: 0
[    3.760024] .......    : LTS          : 0
[    3.764026] .... register #01: 00170011
[    3.767854] .......     : max redirection entries: 0017
[    3.770002] .......     : PRQ implemented: 0
[    3.774268] .......     : IO APIC version: 0011
[    3.780002] .... register #02: 00000000
[    3.783836] .......     : arbitration: 00
[    3.780005] Clocksource tsc unstable (delta = 208562563 ns)
[    3.790002] .... IRQ redirection table:
[    3.793836]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    3.800019]  00 003 0    0    0   0   0    1    1    30
[    3.810004]  01 003 0    0    0   0   0    1    1    31
[    3.815239]  02 000 1    0    0   0   0    0    0    00
[    3.820004]  03 003 1    1    0   1   0    1    1    33
[    3.825250]  04 003 0    0    0   0   0    1    1    34
[    3.830004]  05 003 1    1    0   1   0    1    1    35
[    3.835239]  06 003 0    0    0   0   0    1    1    36
[    3.840019]  07 003 1    0    0   0   0    1    1    37
[    3.845265]  08 003 0    0    0   0   0    1    1    38
[    3.850004]  09 003 0    0    0   0   0    1    1    39
[    3.855250]  0a 003 0    0    0   0   0    1    1    3A
[    3.863230]  0b 003 1    1    0   1   0    1    1    3B
[    3.868470]  0c 003 0    0    0   0   0    1    1    3C
[    3.873232]  0d 003 0    0    0   0   0    1    1    3D
[    3.878469]  0e 003 0    0    0   0   0    1    1    3E
[    3.883249]  0f 003 0    0    0   0   0    1    1    3F
[    3.888498]  10 000 1    0    0   0   0    0    0    00
[    3.893230]  11 000 1    0    0   0   0    0    0    00
[    3.900004]  12 000 1    0    0   0   0    0    0    00
[    3.905250]  13 000 1    0    0   0   0    0    0    00
[    3.910004]  14 000 1    0    0   0   0    0    0    00
[    3.915239]  15 000 1    0    0   0   0    0    0    00
[    3.920019]  16 000 1    0    0   0   0    0    0    00
[    3.925267]  17 000 1    0    0   0   0    0    0    00
[    3.930002] IRQ to pin mappings:
[    3.933228] IRQ0 -> 0:0
[    3.935704] IRQ1 -> 0:1
[    3.938183] IRQ3 -> 0:3
[    3.940735] IRQ4 -> 0:4
[    3.943211] IRQ5 -> 0:5
[    3.945689] IRQ6 -> 0:6
[    3.948166] IRQ7 -> 0:7
[    3.950735] IRQ8 -> 0:8
[    3.953211] IRQ9 -> 0:9
[    3.955687] IRQ10 -> 0:10
[    3.958338] IRQ11 -> 0:11
[    3.960837] IRQ12 -> 0:12
[    3.963488] IRQ13 -> 0:13
[    3.966139] IRQ14 -> 0:14
[    3.970198] IRQ15 -> 0:15
[    3.972853] .................................... done.
[    3.977986] initcall print_all_ICs+0x0/0x5a1 returned 0 after 263671 usecs
[    3.980004] calling  hpet_late_init+0x0/0x91 @ 1
[    3.984619] initcall hpet_late_init+0x0/0x91 returned -19 after 0 usecs
[    3.990004] calling  clocksource_done_booting+0x0/0x37 @ 1
[    4.000019] initcall clocksource_done_booting+0x0/0x37 returned 0 after 0 usecs
[    4.007318] calling  ftrace_init_debugfs+0x0/0x1ad @ 1
[    4.010093] initcall ftrace_init_debugfs+0x0/0x1ad returned 0 after 0 usecs
[    4.020006] calling  rb_init_debugfs+0x0/0x56 @ 1
[    4.024709] initcall rb_init_debugfs+0x0/0x56 returned 0 after 0 usecs
[    4.030003] calling  tracer_init_debugfs+0x0/0x32e @ 1
[    4.035550] initcall tracer_init_debugfs+0x0/0x32e returned 0 after 0 usecs
[    4.040020] calling  init_trace_printk_function_export+0x0/0x56 @ 1
[    4.050011] initcall init_trace_printk_function_export+0x0/0x56 returned 0 after 0 usecs
[    4.058089] calling  stat_workqueue_init+0x0/0x54 @ 1
[    4.060013] initcall stat_workqueue_init+0x0/0x54 returned 0 after 0 usecs
[    4.070003] calling  event_trace_init+0x0/0x49c @ 1
[    4.089466] initcall event_trace_init+0x0/0x49c returned 0 after 9765 usecs
[    4.090012] calling  ksym_tracer_stat_init+0x0/0x54 @ 1
[    4.100016] initcall ksym_tracer_stat_init+0x0/0x54 returned 0 after 0 usecs
[    4.107057] calling  init_pipe_fs+0x0/0x72 @ 1
[    4.110092] initcall init_pipe_fs+0x0/0x72 returned 0 after 0 usecs
[    4.116348] calling  eventpoll_init+0x0/0x102 @ 1
[    4.120159] initcall eventpoll_init+0x0/0x102 returned 0 after 0 usecs
[    4.130004] calling  anon_inode_init+0x0/0x15c @ 1
[    4.134855] initcall anon_inode_init+0x0/0x15c returned 0 after 0 usecs
[    4.140005] calling  fscache_init+0x0/0xd1 @ 1
[    4.144450] Slow work thread pool: Starting up
[    4.150229] Slow work thread pool: Ready
[    4.154219] FS-Cache: Loaded
[    4.157102] initcall fscache_init+0x0/0xd1 returned 0 after 9765 usecs
[    4.160023] calling  tomoyo_initerface_init+0x0/0x181 @ 1
[    4.170131] initcall tomoyo_initerface_init+0x0/0x181 returned 0 after 0 usecs
[    4.177345] calling  blk_scsi_ioctl_init+0x0/0x2ad @ 1
[    4.180005] initcall blk_scsi_ioctl_init+0x0/0x2ad returned 0 after 0 usecs
[    4.186961] calling  chr_dev_init+0x0/0xca @ 1
[    4.190018] device class 'mem': registering
[    4.194441] device: 'mem': device_add
[    4.200283] device: 'kmem': device_add
[    4.204248] device: 'null': device_add
[    4.210252] device: 'port': device_add
[    4.214222] device: 'zero': device_add
[    4.218226] device: 'full': device_add
[    4.220239] device: 'random': device_add
[    4.224421] device: 'urandom': device_add
[    4.230221] device: 'kmsg': device_add
[    4.234229] initcall chr_dev_init+0x0/0xca returned 0 after 39062 usecs
[    4.240005] calling  firmware_class_init+0x0/0x9f @ 1
[    4.245048] device class 'firmware': registering
[    4.250216] initcall firmware_class_init+0x0/0x9f returned 0 after 9765 usecs
[    4.257345] calling  ieee1394_init+0x0/0x289 @ 1
[    4.260412] bus: 'ieee1394': registered
[    4.264248] device class 'ieee1394_host': registering
[    4.270211] device class 'ieee1394_protocol': registering
[    4.275845] device class 'ieee1394_node': registering
[    4.280263] device class 'ieee1394': registering
[    4.285076] bus: 'ieee1394': add driver nodemgr
[    4.290217] initcall ieee1394_init+0x0/0x289 returned 0 after 29296 usecs
[    4.300005] calling  cpufreq_gov_performance_init+0x0/0x39 @ 1
[    4.305838] initcall cpufreq_gov_performance_init+0x0/0x39 returned 0 after 0 usecs
[    4.310004] calling  cpufreq_gov_dbs_init+0x0/0x8e @ 1
[    4.315349] initcall cpufreq_gov_dbs_init+0x0/0x8e returned 0 after 0 usecs
[    4.320005] calling  ssb_modinit+0x0/0x9b @ 1
[    4.330253] bus: 'ssb': registered
[    4.333666] initcall ssb_modinit+0x0/0x9b returned 0 after 0 usecs
[    4.340006] calling  pcibios_assign_resources+0x0/0x9a @ 1
[    4.345624] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    4.350004] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    4.355310] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    4.360004] pci 0000:00:09.0:   PREFETCH window: disabled
[    4.365397] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    4.370002] pci 0000:00:0b.0:   IO window: disabled
[    4.374876] pci 0000:00:0b.0:   MEM window: disabled
[    4.380026] pci 0000:00:0b.0:   PREFETCH window: disabled
[    4.385421] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    4.390002] pci 0000:00:0c.0:   IO window: disabled
[    4.400004] pci 0000:00:0c.0:   MEM window: disabled
[    4.404961] pci 0000:00:0c.0:   PREFETCH window: disabled
[    4.410004] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    4.415912] pci 0000:00:0d.0:   IO window: disabled
[    4.420019] pci 0000:00:0d.0:   MEM window: disabled
[    4.424979] pci 0000:00:0d.0:   PREFETCH window: disabled
[    4.430010] pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
[    4.440006] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    4.445922] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    4.450005] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    4.456088] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    4.460027] pci 0000:00:09.0: setting latency timer to 64
[    4.470008] pci 0000:00:0b.0: setting latency timer to 64
[    4.475407] pci 0000:00:0c.0: setting latency timer to 64
[    4.480007] pci 0000:00:0d.0: setting latency timer to 64
[    4.485406] pci 0000:00:0e.0: setting latency timer to 64
[    4.490005] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    4.495482] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    4.500018] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
[    4.510003] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
[    4.516348] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    4.520003] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    4.530004] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    4.535653] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
[    4.540021] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
[    4.546711] initcall pcibios_assign_resources+0x0/0x9a returned 0 after 195312 usecs
[    4.550004] calling  sysctl_core_init+0x0/0x5f @ 1
[    4.560056] initcall sysctl_core_init+0x0/0x5f returned 0 after 0 usecs
[    4.566659] calling  inet_init+0x0/0x231 @ 1
[    4.570263] NET: Registered protocol family 2
[    4.575033] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    4.582295] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    4.592850] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    4.603425] TCP: Hash tables configured (established 131072 bind 65536)
[    4.610046] TCP reno registered
[    4.613592] initcall inet_init+0x0/0x231 returned 0 after 39062 usecs
[    4.620026] calling  af_unix_init+0x0/0x7b @ 1
[    4.624506] NET: Registered protocol family 1
[    4.630033] initcall af_unix_init+0x0/0x7b returned 0 after 9765 usecs
[    4.636550] calling  populate_rootfs+0x0/0x131 @ 1
[    4.640583] initcall populate_rootfs+0x0/0x131 returned 0 after 0 usecs
[    4.650005] calling  svm_init+0x0/0x40 @ 1
[    4.654363] has_svm: svm not available
[    4.658113] kvm: no hardware support
[    4.660022] initcall svm_init+0x0/0x40 returned -95 after 9765 usecs
[    4.666364] initcall svm_init+0x0/0x40 returned with error code -95 
[    4.670004] calling  i8259A_init_sysfs+0x0/0x49 @ 1
[    4.680003] Registering sysdev class 'i8259'
[    4.684550] Registering sys device of class 'i8259'
[    4.690025] Registering sys device 'i82590'
[    4.694441] initcall i8259A_init_sysfs+0x0/0x49 returned 0 after 9765 usecs
[    4.700010] calling  vsyscall_init+0x0/0x60 @ 1
[    4.704560] initcall vsyscall_init+0x0/0x60 returned 0 after 0 usecs
[    4.710004] calling  sbf_init+0x0/0x118 @ 1
[    4.714183] initcall sbf_init+0x0/0x118 returned 0 after 0 usecs
[    4.720004] calling  i8237A_init_sysfs+0x0/0x49 @ 1
[    4.724876] Registering sysdev class 'i8237'
[    4.730209] Registering sys device of class 'i8237'
[    4.735087] Registering sys device 'i82370'
[    4.740251] initcall i8237A_init_sysfs+0x0/0x49 returned 0 after 19531 usecs
[    4.747291] calling  add_rtc_cmos+0x0/0x68 @ 1
[    4.750008] Registering platform device 'rtc_cmos'. Parent at platform
[    4.756531] device: 'rtc_cmos': device_add
[    4.760023] bus: 'platform': add device rtc_cmos
[    4.764853] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    4.770005] initcall add_rtc_cmos+0x0/0x68 returned 0 after 19531 usecs
[    4.780005] calling  cache_sysfs_init+0x0/0x323 @ 1
[    4.786815] initcall cache_sysfs_init+0x0/0x323 returned 0 after 0 usecs
[    4.790005] calling  cpu_debug_init+0x0/0x2de @ 1
[    4.802659] cpu0(2) debug files 137
[    4.810500] cpu1(2) debug files 137
[    4.813997] initcall cpu_debug_init+0x0/0x2de returned 0 after 9765 usecs
[    4.820004] calling  mce_init_device+0x0/0x2ed @ 1
[    4.824794] Registering sysdev class 'machinecheck'
[    4.830276] Registering sys device of class 'machinecheck'
[    4.835763] Registering sys device 'machinecheck0'
[    4.840257] Registering sys device of class 'machinecheck'
[    4.845736] Registering sys device 'machinecheck1'
[    4.850292] device: 'mcelog': device_add
[    4.854442] initcall mce_init_device+0x0/0x2ed returned 0 after 29296 usecs
[    4.860005] calling  threshold_init_device+0x0/0xc0 @ 1
[    4.865221] initcall threshold_init_device+0x0/0xc0 returned 0 after 0 usecs
[    4.870005] calling  inject_init+0x0/0x4b @ 1
[    4.874356] Machine check injector initialized
[    4.880004] initcall inject_init+0x0/0x4b returned 0 after 9765 usecs
[    4.890003] calling  msr_init+0x0/0x15c @ 1
[    4.894192] device class 'msr': registering
[    4.898590] device: 'msr0': device_add
[    4.900369] device: 'msr1': device_add
[    4.904340] initcall msr_init+0x0/0x15c returned 0 after 9765 usecs
[    4.910005] calling  ioapic_init_sysfs+0x0/0xd2 @ 1
[    4.914875] Registering sysdev class 'ioapic'
[    4.920224] Registering sys device of class 'ioapic'
[    4.925192] Registering sys device 'ioapic0'
[    4.930264] initcall ioapic_init_sysfs+0x0/0xd2 returned 0 after 19531 usecs
[    4.937300] calling  add_pcspkr+0x0/0x4f @ 1
[    4.940008] Registering platform device 'pcspkr'. Parent at platform
[    4.950004] device: 'pcspkr': device_add
[    4.953930] bus: 'platform': add device pcspkr
[    4.958586] initcall add_pcspkr+0x0/0x4f returned 0 after 9765 usecs
[    4.960006] calling  start_periodic_check_for_corruption+0x0/0x61 @ 1
[    4.970003] Scanning for low memory corruption every 60 seconds
[    4.975919] initcall start_periodic_check_for_corruption+0x0/0x61 returned 0 after 0 usecs
[    4.980005] calling  start_pageattr_test+0x0/0x6c @ 1
[    4.990099] initcall start_pageattr_test+0x0/0x6c returned 0 after 0 usecs
[    4.996963] calling  pt_dump_init+0x0/0x57 @ 1
[    5.000039] initcall pt_dump_init+0x0/0x57 returned 0 after 0 usecs
[    5.006296] calling  crypto_fpu_module_init+0x0/0x39 @ 1
[    5.010041] initcall crypto_fpu_module_init+0x0/0x39 returned 0 after 0 usecs
[    5.020004] calling  aes_init+0x0/0x39 @ 1
[    5.024340] initcall aes_init+0x0/0x39 returned 0 after 0 usecs
[    5.030005] calling  init+0x0/0x39 @ 1
[    5.034148] initcall init+0x0/0x39 returned 0 after 0 usecs
[    5.040004] calling  init+0x0/0x39 @ 1
[    5.043852] initcall init+0x0/0x39 returned 0 after 0 usecs
[    5.050029] calling  aesni_init+0x0/0x166 @ 1
[    5.054379] Intel AES-NI instructions are not detected.
[    5.059603] initcall aesni_init+0x0/0x166 returned -19 after 0 usecs
[    5.060008] calling  crc32c_intel_mod_init+0x0/0x47 @ 1
[    5.070004] initcall crc32c_intel_mod_init+0x0/0x47 returned -19 after 0 usecs
[    5.077214] calling  init_vdso_vars+0x0/0x245 @ 1
[    5.080025] initcall init_vdso_vars+0x0/0x245 returned 0 after 0 usecs
[    5.086546] calling  ia32_binfmt_init+0x0/0x3b @ 1
[    5.090049] initcall ia32_binfmt_init+0x0/0x3b returned 0 after 0 usecs
[    5.100004] calling  sysenter_setup+0x0/0x304 @ 1
[    5.104711] initcall sysenter_setup+0x0/0x304 returned 0 after 0 usecs
[    5.110004] calling  init_aout_binfmt+0x0/0x3b @ 1
[    5.114791] initcall init_aout_binfmt+0x0/0x3b returned 0 after 0 usecs
[    5.120004] calling  init_sched_debug_procfs+0x0/0x53 @ 1
[    5.125409] initcall init_sched_debug_procfs+0x0/0x53 returned 0 after 0 usecs
[    5.130019] calling  proc_schedstat_init+0x0/0x49 @ 1
[    5.140012] initcall proc_schedstat_init+0x0/0x49 returned 0 after 0 usecs
[    5.146877] calling  proc_execdomains_init+0x0/0x49 @ 1
[    5.150012] initcall proc_execdomains_init+0x0/0x49 returned 0 after 0 usecs
[    5.160004] calling  ioresources_init+0x0/0x63 @ 1
[    5.164804] initcall ioresources_init+0x0/0x63 returned 0 after 0 usecs
[    5.170019] calling  uid_cache_init+0x0/0xb4 @ 1
[    5.174691] initcall uid_cache_init+0x0/0xb4 returned 0 after 0 usecs
[    5.180004] calling  init_posix_timers+0x0/0x103 @ 1
[    5.185004] initcall init_posix_timers+0x0/0x103 returned 0 after 0 usecs
[    5.190003] calling  init_posix_cpu_timers+0x0/0xd6 @ 1
[    5.200004] initcall init_posix_cpu_timers+0x0/0xd6 returned 0 after 0 usecs
[    5.207040] calling  nsproxy_cache_init+0x0/0x54 @ 1
[    5.210059] initcall nsproxy_cache_init+0x0/0x54 returned 0 after 0 usecs
[    5.216842] calling  create_proc_profile+0x0/0x2a0 @ 1
[    5.220004] initcall create_proc_profile+0x0/0x2a0 returned 0 after 0 usecs
[    5.230003] calling  timekeeping_init_device+0x0/0x49 @ 1
[    5.235395] Registering sysdev class 'timekeeping'
[    5.240237] Registering sys device of class 'timekeeping'
[    5.245633] Registering sys device 'timekeeping0'
[    5.250281] initcall timekeeping_init_device+0x0/0x49 returned 0 after 19531 usecs
[    5.257836] calling  init_clocksource_sysfs+0x0/0x77 @ 1
[    5.260003] Registering sysdev class 'clocksource'
[    5.270153] Registering sys device of class 'clocksource'
[    5.275549] Registering sys device 'clocksource0'
[    5.280229] initcall init_clocksource_sysfs+0x0/0x77 returned 0 after 19531 usecs
[    5.287699] calling  init_timer_list_procfs+0x0/0x53 @ 1
[    5.290041] initcall init_timer_list_procfs+0x0/0x53 returned 0 after 0 usecs
[    5.300003] calling  lockdep_proc_init+0x0/0x69 @ 1
[    5.304900] initcall lockdep_proc_init+0x0/0x69 returned 0 after 0 usecs
[    5.310003] calling  futex_init+0x0/0xac @ 1
[    5.314289] initcall futex_init+0x0/0xac returned 0 after 0 usecs
[    5.320006] calling  proc_dma_init+0x0/0x49 @ 1
[    5.324545] initcall proc_dma_init+0x0/0x49 returned 0 after 0 usecs
[    5.330019] calling  kallsyms_init+0x0/0x4c @ 1
[    5.334554] initcall kallsyms_init+0x0/0x4c returned 0 after 0 usecs
[    5.340003] calling  crash_save_vmcoreinfo_init+0x0/0x492 @ 1
[    5.350032] initcall crash_save_vmcoreinfo_init+0x0/0x492 returned 0 after 0 usecs
[    5.357593] calling  crash_notes_memory_init+0x0/0x5f @ 1
[    5.360009] initcall crash_notes_memory_init+0x0/0x5f returned 0 after 0 usecs
[    5.370020] calling  backtrace_regression_test+0x0/0x11f @ 1
[    5.375671] ====[ backtrace testing ]===========
[    5.380002] Testing a backtrace from process context.
[    5.385046] The following trace is a kernel self test and not a bug!
[    5.390004] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    5.396866] Call Trace:
[    5.400006]  [<ffffffff810b3619>] ? backtrace_regression_test+0x0/0x11f
[    5.406608]  [<ffffffff810b3663>] backtrace_regression_test+0x4a/0x11f
[    5.410020]  [<ffffffff810a3721>] ? jiffies_read+0xd/0x3c
[    5.415414]  [<ffffffff810a1f2a>] ? ktime_get+0x77/0xea
[    5.420004]  [<ffffffff810b3619>] ? backtrace_regression_test+0x0/0x11f
[    5.430006]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    5.435658]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    5.440006]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    5.446091]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    5.450020]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.460004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.465742]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    5.470006]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    5.475484]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.480004]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    5.485395]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    5.490019]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    5.500004]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    5.505916]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    5.510005]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    5.515397]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    5.520005]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    5.525395]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    5.530017] Testing a backtrace from irq context.
[    5.534717] The following trace is a kernel self test and not a bug!
[    5.540011] Pid: 4, comm: ksoftirqd/0 Tainted: G        W  2.6.31-rc5-tip #291
[    5.550001] Call Trace:
[    5.552449]  <IRQ>  [<ffffffff810b35f7>] backtrace_test_irq_callback+0x21/0x43
[    5.560004]  [<ffffffff810818dd>] tasklet_action+0x91/0xff
[    5.565484]  [<ffffffff8102f44c>] ? call_softirq+0x1c/0x28
[    5.570004]  [<ffffffff8108312a>] __do_softirq+0x12c/0x24b
[    5.575482]  [<ffffffff810827ac>] ? ksoftirqd+0x0/0x1c9
[    5.580003]  [<ffffffff8102f44c>] call_softirq+0x1c/0x28
[    5.585307]  <EOI>  [<ffffffff8103177a>] do_softirq+0x56/0xb3
[    5.590003]  [<ffffffff81082857>] ksoftirqd+0xab/0x1c9
[    5.595135]  [<ffffffff81096e4e>] kthread+0x9c/0xa4
[    5.600003]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    5.604962]  [<ffffffff81096db2>] ? kthread+0x0/0xa4
[    5.610003]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    5.615282] Testing a saved backtrace.
[    5.620019] The following trace is a kernel self test and not a bug!
[    5.626367]  [<ffffffff8103bcb7>] save_stack_trace+0x3e/0x73
[    5.634268]  [<ffffffff810b3701>] backtrace_regression_test+0xe8/0x11f
[    5.640002]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    5.645679]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    5.650002]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    5.654980]  [<ffffffffffffffff>] 0xffffffffffffffff
[    5.660017] ====[ end of backtrace testing ]====
[    5.664634] initcall backtrace_regression_test+0x0/0x11f returned 0 after 283203 usecs
[    5.670003] calling  hung_task_init+0x0/0x79 @ 1
[    5.674698] initcall hung_task_init+0x0/0x79 returned 0 after 0 usecs
[    5.680021] calling  rcu_torture_init+0x0/0x6ef @ 1
[    5.690024] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[    5.701021] initcall rcu_torture_init+0x0/0x6ef returned 0 after 9765 usecs
[    5.710007] calling  utsname_sysctl_init+0x0/0x3b @ 1
[    5.715072] sysctl table check failed: /kernel/ostype .1.1 No proc_handler
[    5.723317] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    5.730002] Call Trace:
[    5.732452]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    5.737416]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    5.740004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    5.750028]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    5.756547]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    5.760004]  [<ffffffff828c3330>] ? utsname_sysctl_init+0x0/0x3b
[    5.766002]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    5.770004]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    5.780004]  [<ffffffff828c3353>] utsname_sysctl_init+0x23/0x3b
[    5.785916]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    5.790020]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    5.795586]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    5.800005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    5.810004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.815742]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.820005]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    5.826004]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    5.830019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.835759]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    5.840004]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    5.850004]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    5.855917]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    5.860005]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    5.865311]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    5.870021]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    5.874981]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    5.880004]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    5.885141] sysctl table check failed: /kernel/osrelease .1.2 No proc_handler
[    5.893577] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    5.900002] Call Trace:
[    5.902450]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    5.910019]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    5.916019]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    5.920005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    5.926522]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    5.930004]  [<ffffffff828c3330>] ? utsname_sysctl_init+0x0/0x3b
[    5.940005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    5.946089]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    5.950019]  [<ffffffff828c3353>] utsname_sysctl_init+0x23/0x3b
[    5.955933]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    5.960005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    5.970004]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    5.976089]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    5.980004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.985741]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    5.990019]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    6.000004]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    6.005482]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.010004]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    6.015395]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    6.020004]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    6.025916]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    6.030020]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    6.040005]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    6.045395]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    6.050008]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    6.055405]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    6.060009] sysctl table check failed: /kernel/version .1.4 No proc_handler
[    6.067066] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    6.070017] Call Trace:
[    6.072469]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    6.080004]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    6.086002]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    6.090005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    6.100005]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    6.106434]  [<ffffffff828c3330>] ? utsname_sysctl_init+0x0/0x3b
[    6.110020]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    6.116107]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    6.120004]  [<ffffffff828c3353>] utsname_sysctl_init+0x23/0x3b
[    6.130006]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    6.135657]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    6.140005]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    6.146089]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    6.150019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.160004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.165743]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    6.170004]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    6.175481]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.180004]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    6.185396]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    6.190019]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    6.200004]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    6.205916]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    6.210005]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    6.215397]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    6.220005]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    6.225395]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    6.230024] sysctl table check failed: /kernel/hostname .1.7 No proc_handler
[    6.237169] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    6.240002] Call Trace:
[    6.242452]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    6.250004]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    6.260004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    6.266003]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    6.270019]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    6.276453]  [<ffffffff828c3330>] ? utsname_sysctl_init+0x0/0x3b
[    6.280005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    6.290005]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    6.296089]  [<ffffffff828c3353>] utsname_sysctl_init+0x23/0x3b
[    6.300004]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    6.305656]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    6.310019]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    6.320005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    6.325830]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.330004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.335743]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    6.340004]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    6.345481]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.350019]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    6.360004]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    6.365740]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    6.370004]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    6.375918]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    6.380005]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    6.385396]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    6.390021]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    6.395412]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    6.400009] sysctl table check failed: /kernel/domainname .1.8 No proc_handler
[    6.410003] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    6.416865] Call Trace:
[    6.420004]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    6.424962]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    6.430019]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    6.436019]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    6.440005]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    6.450004]  [<ffffffff828c3330>] ? utsname_sysctl_init+0x0/0x3b
[    6.456002]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    6.460005]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    6.466089]  [<ffffffff828c3353>] utsname_sysctl_init+0x23/0x3b
[    6.470019]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    6.480005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    6.485569]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    6.490005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    6.495830]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.500004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.505742]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    6.510019]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    6.520004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    6.525743]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    6.530004]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    6.535742]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    6.540004]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    6.545916]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    6.550020]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    6.560004]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    6.564962]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    6.570004]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    6.575138] initcall utsname_sysctl_init+0x0/0x3b returned 0 after 839843 usecs
[    6.580003] calling  init_lstats_procfs+0x0/0x4c @ 1
[    6.584973] initcall init_lstats_procfs+0x0/0x4c returned 0 after 0 usecs
[    6.590018] calling  ftrace_nodyn_init+0x0/0x37 @ 1
[    6.600004] initcall ftrace_nodyn_init+0x0/0x37 returned 0 after 0 usecs
[    6.606694] calling  init_events+0x0/0x8c @ 1
[    6.610010] initcall init_events+0x0/0x8c returned 0 after 0 usecs
[    6.616183] calling  init_sched_switch_trace+0x0/0x39 @ 1
[    6.620007] initcall init_sched_switch_trace+0x0/0x39 returned 0 after 0 usecs
[    6.627222] calling  init_stack_trace+0x0/0x39 @ 1
[    6.630021] initcall init_stack_trace+0x0/0x39 returned 0 after 0 usecs
[    6.640003] calling  init_function_trace+0x0/0x39 @ 1
[    6.645050] initcall init_function_trace+0x0/0x39 returned 0 after 0 usecs
[    6.650005] calling  init_wakeup_tracer+0x0/0x49 @ 1
[    6.654963] initcall init_wakeup_tracer+0x0/0x49 returned 0 after 0 usecs
[    6.660003] calling  stack_trace_init+0x0/0x91 @ 1
[    6.664810] initcall stack_trace_init+0x0/0x91 returned 0 after 0 usecs
[    6.670025] calling  init_mmio_trace+0x0/0x39 @ 1
[    6.680006] initcall init_mmio_trace+0x0/0x39 returned 0 after 0 usecs
[    6.686521] calling  init_power_trace+0x0/0x39 @ 1
[    6.690005] initcall init_power_trace+0x0/0x39 returned 0 after 0 usecs
[    6.696607] calling  init_kmem_tracer+0x0/0x7d @ 1
[    6.700004] Warning: could not register the kmem tracer
[    6.705222] initcall init_kmem_tracer+0x0/0x7d returned 1 after 0 usecs
[    6.710004] initcall init_kmem_tracer+0x0/0x7d returned with error code 1 
[    6.720004] calling  init_blk_tracer+0x0/0x7e @ 1
[    6.724702] initcall init_blk_tracer+0x0/0x7e returned 0 after 0 usecs
[    6.730025] calling  register_ftrace_syscalls+0x0/0xc5 @ 1
[    6.735512] initcall register_ftrace_syscalls+0x0/0xc5 returned 0 after 0 usecs
[    6.740004] calling  init_ksym_trace+0x0/0x76 @ 1
[    6.750012] initcall init_ksym_trace+0x0/0x76 returned 0 after 0 usecs
[    6.756532] calling  init_per_zone_wmark_min+0x0/0x8d @ 1
[    6.760070] initcall init_per_zone_wmark_min+0x0/0x8d returned 0 after 0 usecs
[    6.770003] calling  pdflush_init+0x0/0x43 @ 1
[    6.774705] initcall pdflush_init+0x0/0x43 returned 0 after 0 usecs
[    6.780026] calling  kswapd_init+0x0/0x97 @ 1
[    6.784508] initcall kswapd_init+0x0/0x97 returned 0 after 0 usecs
[    6.790004] calling  init_tmpfs+0x0/0x64 @ 1
[    6.794339] initcall init_tmpfs+0x0/0x64 returned 0 after 0 usecs
[    6.800005] calling  setup_vmstat+0x0/0xf0 @ 1
[    6.804482] initcall setup_vmstat+0x0/0xf0 returned 0 after 0 usecs
[    6.810004] calling  mm_sysfs_init+0x0/0x50 @ 1
[    6.814540] initcall mm_sysfs_init+0x0/0x50 returned 0 after 0 usecs
[    6.820027] calling  proc_vmalloc_init+0x0/0x4c @ 1
[    6.824909] initcall proc_vmalloc_init+0x0/0x4c returned 0 after 0 usecs
[    6.830004] calling  procswaps_init+0x0/0x49 @ 1
[    6.840012] initcall procswaps_init+0x0/0x49 returned 0 after 0 usecs
[    6.846443] calling  hugetlb_init+0x0/0x3cc @ 1
[    6.850008] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.856381] initcall hugetlb_init+0x0/0x3cc returned 0 after 0 usecs
[    6.860019] calling  slab_proc_init+0x0/0x4c @ 1
[    6.864643] initcall slab_proc_init+0x0/0x4c returned 0 after 0 usecs
[    6.870004] calling  slab_sysfs_init+0x0/0x119 @ 1
[    6.954616] initcall slab_sysfs_init+0x0/0x119 returned 0 after 68359 usecs
[    6.960110] calling  fasync_init+0x0/0x51 @ 1
[    6.975420] initcall fasync_init+0x0/0x51 returned 0 after 9765 usecs
[    6.980132] calling  proc_filesystems_init+0x0/0x49 @ 1
[    6.985369] initcall proc_filesystems_init+0x0/0x49 returned 0 after 0 usecs
[    6.990005] calling  dnotify_init+0x0/0xa7 @ 1
[    7.005625] initcall dnotify_init+0x0/0xa7 returned 0 after 9765 usecs
[    7.010026] calling  inotify_setup+0x0/0x37 @ 1
[    7.014554] initcall inotify_setup+0x0/0x37 returned 0 after 0 usecs
[    7.020004] calling  aio_setup+0x0/0x9c @ 1
[    7.050095] initcall aio_setup+0x0/0x9c returned 0 after 29296 usecs
[    7.056443] calling  proc_locks_init+0x0/0x49 @ 1
[    7.060037] initcall proc_locks_init+0x0/0x49 returned 0 after 0 usecs
[    7.066555] calling  init_sys32_ioctl+0x0/0xac @ 1
[    7.070019] initcall init_sys32_ioctl+0x0/0xac returned 0 after 0 usecs
[    7.076625] calling  init_mbcache+0x0/0x3b @ 1
[    7.080005] initcall init_mbcache+0x0/0x3b returned 0 after 0 usecs
[    7.086262] calling  dquot_init+0x0/0x12a @ 1
[    7.090002] VFS: Disk quotas dquot_6.5.2
[    7.104868] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    7.110065] initcall dquot_init+0x0/0x12a returned 0 after 19531 usecs
[    7.116581] calling  init_v1_quota_format+0x0/0x39 @ 1
[    7.120005] initcall init_v1_quota_format+0x0/0x39 returned 0 after 0 usecs
[    7.126954] calling  proc_cmdline_init+0x0/0x49 @ 1
[    7.130014] initcall proc_cmdline_init+0x0/0x49 returned 0 after 0 usecs
[    7.140004] calling  proc_cpuinfo_init+0x0/0x49 @ 1
[    7.144883] initcall proc_cpuinfo_init+0x0/0x49 returned 0 after 0 usecs
[    7.150019] calling  proc_devices_init+0x0/0x49 @ 1
[    7.154902] initcall proc_devices_init+0x0/0x49 returned 0 after 0 usecs
[    7.160004] calling  proc_interrupts_init+0x0/0x49 @ 1
[    7.165143] initcall proc_interrupts_init+0x0/0x49 returned 0 after 0 usecs
[    7.170009] calling  proc_loadavg_init+0x0/0x49 @ 1
[    7.180012] initcall proc_loadavg_init+0x0/0x49 returned 0 after 0 usecs
[    7.186702] calling  proc_meminfo_init+0x0/0x49 @ 1
[    7.190027] initcall proc_meminfo_init+0x0/0x49 returned 0 after 0 usecs
[    7.200004] calling  proc_stat_init+0x0/0x49 @ 1
[    7.204623] initcall proc_stat_init+0x0/0x49 returned 0 after 0 usecs
[    7.210004] calling  proc_uptime_init+0x0/0x49 @ 1
[    7.214798] initcall proc_uptime_init+0x0/0x49 returned 0 after 0 usecs
[    7.220004] calling  proc_version_init+0x0/0x49 @ 1
[    7.224884] initcall proc_version_init+0x0/0x49 returned 0 after 0 usecs
[    7.230019] calling  proc_softirqs_init+0x0/0x49 @ 1
[    7.234988] initcall proc_softirqs_init+0x0/0x49 returned 0 after 0 usecs
[    7.240004] calling  proc_kcore_init+0x0/0x70 @ 1
[    7.250021] initcall proc_kcore_init+0x0/0x70 returned 0 after 0 usecs
[    7.256537] calling  proc_kmsg_init+0x0/0x4c @ 1
[    7.260012] initcall proc_kmsg_init+0x0/0x4c returned 0 after 0 usecs
[    7.266443] calling  proc_page_init+0x0/0x69 @ 1
[    7.270034] initcall proc_page_init+0x0/0x69 returned 0 after 0 usecs
[    7.276470] calling  configfs_init+0x0/0xfb @ 1
[    7.291246] initcall configfs_init+0x0/0xfb returned 0 after 9765 usecs
[    7.297849] calling  init_devpts_fs+0x0/0x72 @ 1
[    7.300135] initcall init_devpts_fs+0x0/0x72 returned 0 after 0 usecs
[    7.306564] calling  init_dlm+0x0/0xae @ 1
[    7.321364] device: 'dlm-control': device_add
[    7.325982] device: 'dlm-monitor': device_add
[    7.342388] device: 'dlm_plock': device_add
[    7.346791] DLM (built Aug  2 2009 22:49:30) installed
[    7.350027] initcall init_dlm+0x0/0xae returned 0 after 39062 usecs
[    7.356286] calling  init_reiserfs_fs+0x0/0xb2 @ 1
[    7.371489] initcall init_reiserfs_fs+0x0/0xb2 returned 0 after 9765 usecs
[    7.378352] calling  init_ext3_fs+0x0/0x99 @ 1
[    7.391644] initcall init_ext3_fs+0x0/0x99 returned 0 after 9765 usecs
[    7.398165] calling  init_ext2_fs+0x0/0x99 @ 1
[    7.411883] initcall init_ext2_fs+0x0/0x99 returned 0 after 9765 usecs
[    7.418400] calling  init_ext4_fs+0x0/0x111 @ 1
[    7.433538] initcall init_ext4_fs+0x0/0x111 returned 0 after 9765 usecs
[    7.440031] calling  journal_init+0x0/0xf5 @ 1
[    7.456339] initcall journal_init+0x0/0xf5 returned 0 after 9765 usecs
[    7.460030] calling  journal_init+0x0/0xd6 @ 1
[    7.476480] initcall journal_init+0x0/0xd6 returned 0 after 9765 usecs
[    7.480028] calling  init_cramfs_fs+0x0/0x57 @ 1
[    7.484673] initcall init_cramfs_fs+0x0/0x57 returned 0 after 0 usecs
[    7.490005] calling  init_ramfs_fs+0x0/0x39 @ 1
[    7.494532] initcall init_ramfs_fs+0x0/0x39 returned 0 after 0 usecs
[    7.500004] calling  init_hugetlbfs_fs+0x0/0xbe @ 1
[    7.521169] initcall init_hugetlbfs_fs+0x0/0xbe returned 0 after 19531 usecs
[    7.528214] calling  init_fat_fs+0x0/0x75 @ 1
[    7.541176] initcall init_fat_fs+0x0/0x75 returned 0 after 9765 usecs
[    7.547609] calling  init_msdos_fs+0x0/0x39 @ 1
[    7.550029] initcall init_msdos_fs+0x0/0x39 returned 0 after 0 usecs
[    7.556372] calling  init_bfs_fs+0x0/0x89 @ 1
[    7.571734] initcall init_bfs_fs+0x0/0x89 returned 0 after 9765 usecs
[    7.578168] calling  init_iso9660_fs+0x0/0x89 @ 1
[    7.590952] initcall init_iso9660_fs+0x0/0x89 returned 0 after 9765 usecs
[    7.597727] calling  init_hfs_fs+0x0/0x83 @ 1
[    7.610719] initcall init_hfs_fs+0x0/0x83 returned 0 after 9765 usecs
[    7.617150] calling  ecryptfs_init+0x0/0x220 @ 1
[    7.636642] device: 'ecryptfs': device_add
[    7.640288] initcall ecryptfs_init+0x0/0x220 returned 0 after 19531 usecs
[    7.647067] calling  init_nls_cp437+0x0/0x39 @ 1
[    7.650838] initcall init_nls_cp437+0x0/0x39 returned 0 after 0 usecs
[    7.657273] calling  init_nls_cp737+0x0/0x39 @ 1
[    7.660005] initcall init_nls_cp737+0x0/0x39 returned 0 after 0 usecs
[    7.670003] calling  init_nls_cp775+0x0/0x39 @ 1
[    7.674616] initcall init_nls_cp775+0x0/0x39 returned 0 after 0 usecs
[    7.680003] calling  init_nls_cp850+0x0/0x39 @ 1
[    7.684615] initcall init_nls_cp850+0x0/0x39 returned 0 after 0 usecs
[    7.690028] calling  init_nls_cp852+0x0/0x39 @ 1
[    7.694643] initcall init_nls_cp852+0x0/0x39 returned 0 after 0 usecs
[    7.700003] calling  init_nls_cp857+0x0/0x39 @ 1
[    7.704616] initcall init_nls_cp857+0x0/0x39 returned 0 after 0 usecs
[    7.710003] calling  init_nls_cp861+0x0/0x39 @ 1
[    7.714616] initcall init_nls_cp861+0x0/0x39 returned 0 after 0 usecs
[    7.720003] calling  init_nls_cp862+0x0/0x39 @ 1
[    7.730019] initcall init_nls_cp862+0x0/0x39 returned 0 after 0 usecs
[    7.736451] calling  init_nls_cp863+0x0/0x39 @ 1
[    7.740004] initcall init_nls_cp863+0x0/0x39 returned 0 after 0 usecs
[    7.746432] calling  init_nls_cp874+0x0/0x39 @ 1
[    7.750004] initcall init_nls_cp874+0x0/0x39 returned 0 after 0 usecs
[    7.756435] calling  init_nls_cp932+0x0/0x39 @ 1
[    7.760004] initcall init_nls_cp932+0x0/0x39 returned 0 after 0 usecs
[    7.770018] calling  init_nls_euc_jp+0x0/0x6f @ 1
[    7.774721] initcall init_nls_euc_jp+0x0/0x6f returned 0 after 0 usecs
[    7.780003] calling  init_nls_cp936+0x0/0x39 @ 1
[    7.784616] initcall init_nls_cp936+0x0/0x39 returned 0 after 0 usecs
[    7.790003] calling  init_nls_cp949+0x0/0x39 @ 1
[    7.794616] initcall init_nls_cp949+0x0/0x39 returned 0 after 0 usecs
[    7.800003] calling  init_nls_cp950+0x0/0x39 @ 1
[    7.804616] initcall init_nls_cp950+0x0/0x39 returned 0 after 0 usecs
[    7.810018] calling  init_nls_cp1250+0x0/0x39 @ 1
[    7.814720] initcall init_nls_cp1250+0x0/0x39 returned 0 after 0 usecs
[    7.820003] calling  init_nls_cp1251+0x0/0x39 @ 1
[    7.830004] initcall init_nls_cp1251+0x0/0x39 returned 0 after 0 usecs
[    7.836519] calling  init_nls_ascii+0x0/0x39 @ 1
[    7.840004] initcall init_nls_ascii+0x0/0x39 returned 0 after 0 usecs
[    7.846435] calling  init_nls_iso8859_1+0x0/0x39 @ 1
[    7.850019] initcall init_nls_iso8859_1+0x0/0x39 returned 0 after 0 usecs
[    7.860003] calling  init_nls_iso8859_4+0x0/0x39 @ 1
[    7.864962] initcall init_nls_iso8859_4+0x0/0x39 returned 0 after 0 usecs
[    7.870003] calling  init_nls_iso8859_5+0x0/0x39 @ 1
[    7.874960] initcall init_nls_iso8859_5+0x0/0x39 returned 0 after 0 usecs
[    7.880003] calling  init_nls_iso8859_6+0x0/0x39 @ 1
[    7.884963] initcall init_nls_iso8859_6+0x0/0x39 returned 0 after 0 usecs
[    7.890018] calling  init_nls_iso8859_7+0x0/0x39 @ 1
[    7.900004] initcall init_nls_iso8859_7+0x0/0x39 returned 0 after 0 usecs
[    7.906781] calling  init_nls_cp1255+0x0/0x39 @ 1
[    7.910004] initcall init_nls_cp1255+0x0/0x39 returned 0 after 0 usecs
[    7.916522] calling  init_nls_iso8859_9+0x0/0x39 @ 1
[    7.920004] initcall init_nls_iso8859_9+0x0/0x39 returned 0 after 0 usecs
[    7.930018] calling  init_nls_iso8859_14+0x0/0x39 @ 1
[    7.935067] initcall init_nls_iso8859_14+0x0/0x39 returned 0 after 0 usecs
[    7.940003] calling  init_nls_koi8_r+0x0/0x39 @ 1
[    7.944703] initcall init_nls_koi8_r+0x0/0x39 returned 0 after 0 usecs
[    7.950005] calling  init_sysv_fs+0x0/0x75 @ 1
[    7.965022] initcall init_sysv_fs+0x0/0x75 returned 0 after 9765 usecs
[    7.970091] calling  init_ntfs_fs+0x0/0x253 @ 1
[    7.974615] NTFS driver 2.1.29 [Flags: R/W DEBUG].
[    7.992350] initcall init_ntfs_fs+0x0/0x253 returned 0 after 19531 usecs
[    7.999047] calling  init_ufs_fs+0x0/0x89 @ 1
[    8.011586] initcall init_ufs_fs+0x0/0x89 returned 0 after 9765 usecs
[    8.018020] calling  init_efs_fs+0x0/0x95 @ 1
[    8.020021] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    8.035735] initcall init_efs_fs+0x0/0x95 returned 0 after 9765 usecs
[    8.040030] calling  init_romfs_fs+0x0/0xab @ 1
[    8.044555] ROMFS MTD (C) 2007 Red Hat, Inc.
[    8.061332] initcall init_romfs_fs+0x0/0xab returned 0 after 19531 usecs
[    8.068025] calling  init_qnx4_fs+0x0/0x99 @ 1
[    8.080617] QNX4 filesystem 0.2.3 registered.
[    8.084973] initcall init_qnx4_fs+0x0/0x99 returned 0 after 9765 usecs
[    8.090004] calling  init_autofs_fs+0x0/0x39 @ 1
[    8.094615] initcall init_autofs_fs+0x0/0x39 returned 0 after 0 usecs
[    8.100003] calling  init_autofs4_fs+0x0/0x4c @ 1
[    8.104702] initcall init_autofs4_fs+0x0/0x4c returned -16 after 0 usecs
[    8.110004] initcall init_autofs4_fs+0x0/0x4c returned with error code -16 
[    8.120025] calling  fuse_init+0x0/0x15c @ 1
[    8.124295] fuse init (API version 7.12)
[    8.139711] device: 'fuse': device_add
[    8.151362] initcall fuse_init+0x0/0x15c returned 0 after 29296 usecs
[    8.157795] calling  init_udf_fs+0x0/0x89 @ 1
[    8.171133] initcall init_udf_fs+0x0/0x89 returned 0 after 9765 usecs
[    8.177562] calling  init_omfs_fs+0x0/0x39 @ 1
[    8.180008] initcall init_omfs_fs+0x0/0x39 returned 0 after 0 usecs
[    8.186268] calling  init_jfs_fs+0x0/0x1f8 @ 1
[    8.202499] JFS: nTxBlock = 7700, nTxLock = 61601
[    8.214301] initcall init_jfs_fs+0x0/0x1f8 returned 0 after 19531 usecs
[    8.220098] calling  init_nilfs_fs+0x0/0xb9 @ 1
[    8.226415] initcall init_nilfs_fs+0x0/0xb9 returned 0 after 0 usecs
[    8.230029] calling  ocfs2_init+0x0/0x4c5 @ 1
[    8.234386] OCFS2 1.5.0
[    8.260226] initcall ocfs2_init+0x0/0x4c5 returned 0 after 29296 usecs
[    8.266748] calling  ocfs2_stack_glue_init+0x0/0xbb @ 1
[    8.270290] initcall ocfs2_stack_glue_init+0x0/0xbb returned 0 after 0 usecs
[    8.277325] calling  o2cb_stack_init+0x0/0x39 @ 1
[    8.280003] ocfs2: Registered cluster interface o2cb
[    8.284962] initcall o2cb_stack_init+0x0/0x39 returned 0 after 0 usecs
[    8.290003] calling  init_o2nm+0x0/0xcf @ 1
[    8.294182] OCFS2 Node Manager 1.5.0
[    8.312148] initcall init_o2nm+0x0/0xcf returned 0 after 19531 usecs
[    8.318494] calling  dlm_init+0x0/0x38a @ 1
[    8.320042] OCFS2 DLM 1.5.0
[    8.334832] initcall dlm_init+0x0/0x38a returned 0 after 9765 usecs
[    8.340030] calling  init_dlmfs_fs+0x0/0x106 @ 1
[    8.344646] OCFS2 DLMFS 1.5.0
[    8.358507] OCFS2 User DLM kernel interface loaded
[    8.360023] initcall init_dlmfs_fs+0x0/0x106 returned 0 after 19531 usecs
[    8.370004] calling  init_gfs2_fs+0x0/0x20d @ 1
[    8.382435] GFS2 (built Aug  2 2009 22:49:39) installed
[    8.387660] initcall init_gfs2_fs+0x0/0x20d returned 0 after 9765 usecs
[    8.390030] calling  ipc_init+0x0/0x56 @ 1
[    8.394148] msgmni has been set to 1925
[    8.400023] initcall ipc_init+0x0/0x56 returned 0 after 9765 usecs
[    8.406200] calling  ipc_sysctl_init+0x0/0x3b @ 1
[    8.410027] sysctl table check failed: /kernel/shmmax .1.34 No proc_handler
[    8.420005] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    8.426868] Call Trace:
[    8.429324]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    8.430021]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    8.440005]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    8.446005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    8.450005]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    8.456437]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    8.460005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    8.470025]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    8.476115]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    8.480006]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    8.485665]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    8.490007]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    8.500006]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    8.505830]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.510019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.515759]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    8.520006]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    8.525490]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.530004]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    8.540004]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    8.545742]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    8.550020]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    8.555934]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    8.560006]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    8.565404]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    8.570005]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    8.575394]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    8.580011] sysctl table check failed: /kernel/shmall .1.41 No proc_handler
[    8.590018] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    8.596883] Call Trace:
[    8.600005]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    8.604963]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    8.610004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    8.616001]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    8.620005]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    8.630020]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    8.635671]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    8.640005]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    8.646088]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    8.650005]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    8.655655]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    8.660005]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    8.670020]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    8.675848]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.680004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.685743]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    8.690004]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    8.700004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.705743]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    8.710019]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    8.715760]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    8.720005]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    8.725917]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    8.730007]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    8.735405]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    8.740005]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    8.745396]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    8.750026] sysctl table check failed: /kernel/shmmni .1.45 No proc_handler
[    8.762156] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    8.769021] Call Trace:
[    8.770004]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    8.774962]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    8.780004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    8.786004]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    8.790020]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    8.800004]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    8.805656]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    8.810005]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    8.816088]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    8.820004]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    8.830020]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    8.835588]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    8.840005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    8.845829]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.850004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.855742]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    8.860004]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    8.870019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    8.875758]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    8.880004]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    8.885741]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    8.890004]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    8.895916]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    8.900005]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    8.910019]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    8.914982]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    8.920004]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    8.925143] sysctl table check failed: /kernel/msgmax .1.35 No proc_handler
[    8.932778] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    8.939645] Call Trace:
[    8.940004]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    8.944963]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    8.950019]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    8.956020]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    8.960005]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    8.970004]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    8.975658]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    8.980005]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    8.990022]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    8.995586]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    9.000005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    9.005569]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    9.010005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    9.015829]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.020004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.030019]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    9.036019]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    9.040011]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.045751]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    9.050005]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    9.055743]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    9.060004]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    9.070020]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    9.075327]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    9.080004]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    9.084965]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    9.090004]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    9.095141] sysctl table check failed: /kernel/msgmni .1.42 No proc_handler
[    9.103402] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    9.110017] Call Trace:
[    9.112468]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    9.117432]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    9.120004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    9.130005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    9.136521]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    9.140004]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    9.145656]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    9.150020]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    9.160004]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    9.165569]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    9.170005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    9.175569]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    9.180005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    9.185831]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.190019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.200005]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    9.206002]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    9.210004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.215743]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    9.220004]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    9.225743]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    9.230019]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    9.240005]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    9.245311]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    9.250006]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    9.254972]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    9.260004]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    9.265142] sysctl table check failed: /kernel/msgmnb .1.36 No proc_handler
[    9.273419] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    9.280002] Call Trace:
[    9.282451]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    9.287413]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    9.290004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    9.300005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    9.306522]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    9.310019]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    9.315674]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    9.320005]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    9.330004]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    9.335571]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    9.340005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    9.345570]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    9.350020]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    9.360004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.365743]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.370005]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    9.376002]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    9.380004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.385743]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    9.390019]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    9.400004]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    9.405917]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    9.410005]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    9.415308]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    9.420004]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    9.424962]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    9.430019]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    9.435161] sysctl table check failed: /kernel/sem .1.43 No proc_handler
[    9.443144] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    9.450002] Call Trace:
[    9.452453]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    9.457413]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    9.460004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    9.470020]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    9.476539]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    9.480004]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    9.490005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    9.496090]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    9.500004]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    9.505569]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    9.510022]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    9.515587]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    9.520005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    9.530004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.535742]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.540005]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    9.546002]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    9.550019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.560005]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    9.565394]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    9.570004]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    9.575915]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    9.580005]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    9.585310]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    9.590019]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    9.594982]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    9.600004]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    9.605142] sysctl table check failed: /kernel/auto_msgmni  No proc_handler
[    9.613367] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    9.620002] Call Trace:
[    9.622453]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    9.630019]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    9.636019]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    9.640005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    9.646521]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    9.650004]  [<ffffffff828ce5ad>] ? ipc_sysctl_init+0x0/0x3b
[    9.660005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    9.666090]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    9.670019]  [<ffffffff828ce5d0>] ipc_sysctl_init+0x23/0x3b
[    9.675587]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    9.680005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    9.690005]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    9.696090]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    9.700004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.705743]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.710019]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    9.716020]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    9.720004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.730004]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    9.735396]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    9.740004]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    9.745915]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    9.750020]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    9.755327]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    9.760004]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    9.764963]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[    9.770006]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[    9.780007] initcall ipc_sysctl_init+0x0/0x3b returned 0 after 1337890 usecs
[    9.787048] calling  init_mqueue_fs+0x0/0xee @ 1
[    9.800719] sysctl table check failed: /fs/mqueue/queues_max  No proc_handler
[    9.807935] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[    9.810025] Call Trace:
[    9.812478]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[    9.820005]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[    9.826002]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    9.830004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[    9.840005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[    9.846531]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[    9.850020]  [<ffffffff8145a27a>] ? kobject_uevent+0x1e/0x34
[    9.855673]  [<ffffffff81118ef5>] ? sysfs_slab_add+0x1a4/0x1e6
[    9.860005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[    9.870005]  [<ffffffff813ffe15>] ? init_once+0x0/0x3b
[    9.875135]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[    9.880004]  [<ffffffff814016c0>] mq_register_sysctl_table+0x28/0x40
[    9.886349]  [<ffffffff828ce639>] init_mqueue_fs+0x51/0xee
[    9.890019]  [<ffffffff828ce5e8>] ? init_mqueue_fs+0x0/0xee
[    9.895586]  [<ffffffff828ce5e8>] ? init_mqueue_fs+0x0/0xee
[    9.900005]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[    9.910005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[    9.915570]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[    9.920005]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[    9.925829]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.930019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.935760]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[    9.940005]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[    9.950004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[    9.955742]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[    9.960004]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[    9.965743]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[    9.970019]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[    9.980005]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[    9.985319]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[    9.990004]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[    9.994963]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[   10.000004]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[   10.005142] sysctl table check failed: /fs/mqueue/msg_max  No proc_handler
[   10.013031] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[   10.020002] Call Trace:
[   10.022451]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[   10.027412]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[   10.030007]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[   10.036010]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[   10.040005]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[   10.050020]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[   10.056451]  [<ffffffff8145a27a>] ? kobject_uevent+0x1e/0x34
[   10.060005]  [<ffffffff81118ef5>] ? sysfs_slab_add+0x1a4/0x1e6
[   10.070005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[   10.076089]  [<ffffffff813ffe15>] ? init_once+0x0/0x3b
[   10.080005]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[   10.086089]  [<ffffffff814016c0>] mq_register_sysctl_table+0x28/0x40
[   10.090019]  [<ffffffff828ce639>] init_mqueue_fs+0x51/0xee
[   10.095501]  [<ffffffff828ce5e8>] ? init_mqueue_fs+0x0/0xee
[   10.100004]  [<ffffffff828ce5e8>] ? init_mqueue_fs+0x0/0xee
[   10.110004]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[   10.115657]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[   10.120005]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[   10.126089]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[   10.130019]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[   10.135758]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[   10.140005]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[   10.150004]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[   10.155484]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[   10.160004]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[   10.165395]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[   10.170019]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[   10.175933]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[   10.180005]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[   10.190005]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[   10.195396]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[   10.200005]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[   10.205404]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[   10.210024] sysctl table check failed: /fs/mqueue/msgsize_max  No proc_handler
[   10.217327] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #291
[   10.220002] Call Trace:
[   10.222451]  [<ffffffff810a0b5c>] set_fail+0x5a/0x7c
[   10.230004]  [<ffffffff810a107c>] sysctl_check_table+0x4fe/0x5b7
[   10.236003]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[   10.240004]  [<ffffffff810a1095>] sysctl_check_table+0x517/0x5b7
[   10.250020]  [<ffffffff810857d4>] ? __register_sysctl_paths+0x69/0x2cd
[   10.256540]  [<ffffffff81085876>] __register_sysctl_paths+0x10b/0x2cd
[   10.260005]  [<ffffffff8145a27a>] ? kobject_uevent+0x1e/0x34
[   10.265657]  [<ffffffff81118ef5>] ? sysfs_slab_add+0x1a4/0x1e6
[   10.270005]  [<ffffffff81085a79>] register_sysctl_paths+0x41/0x57
[   10.280004]  [<ffffffff813ffe15>] ? init_once+0x0/0x3b
[   10.285137]  [<ffffffff81085aba>] register_sysctl_table+0x2b/0x41
[   10.290022]  [<ffffffff814016c0>] mq_register_sysctl_table+0x28/0x40
[   10.296367]  [<ffffffff828ce639>] init_mqueue_fs+0x51/0xee
[   10.300004]  [<ffffffff828ce5e8>] ? init_mqueue_fs+0x0/0xee
[   10.310004]  [<ffffffff828ce5e8>] ? init_mqueue_fs+0x0/0xee
[   10.315571]  [<ffffffff810090b6>] do_one_initcall+0x84/0x1a8
[   10.320005]  [<ffffffff81117da5>] ? __slab_free+0x14a/0x36f
[   10.325570]  [<ffffffff814581d3>] ? ida_get_new_above+0x1b5/0x1ea
[   10.330020]  [<ffffffff810a88a4>] ? __lock_acquire+0x23a/0x472
[   10.335844]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[   10.340004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[   10.350005]  [<ffffffff810afd93>] ? test_ti_thread_flag+0xd/0x3a
[   10.356002]  [<ffffffff81ed39d9>] ? _spin_unlock+0x63/0x87
[   10.360004]  [<ffffffff8117aeb4>] ? proc_register+0x131/0x1bb
[   10.365742]  [<ffffffff81458229>] ? ida_get_new+0x21/0x37
[   10.370019]  [<ffffffff8117af16>] ? proc_register+0x193/0x1bb
[   10.375759]  [<ffffffff8117b0a4>] ? create_proc_entry+0x92/0xbe
[   10.380004]  [<ffffffff810bbce1>] ? register_irq_proc+0xc2/0xf2
[   10.390005]  [<ffffffff810b84dd>] ? irq_to_desc+0xd/0x50
[   10.395311]  [<ffffffff828ac8f9>] kernel_init+0x159/0x1c5
[   10.400004]  [<ffffffff8102f34a>] child_rip+0xa/0x20
[   10.404964]  [<ffffffff828ac7a0>] ? kernel_init+0x0/0x1c5
[   10.410019]  [<ffffffff8102f340>] ? child_rip+0x0/0x20
[   10.415290] initcall init_mqueue_fs+0x0/0xee returned 0 after 605468 usecs
[   10.420004] calling  key_proc_init+0x0/0x5a @ 1
[   10.424550] initcall key_proc_init+0x0/0x5a returned 0 after 0 usecs
[   10.430004] calling  crypto_wq_init+0x0/0x59 @ 1
[   10.434817] initcall crypto_wq_init+0x0/0x59 returned 0 after 0 usecs
[   10.440049] calling  crypto_algapi_init+0x0/0x34 @ 1
[   10.450014] initcall crypto_algapi_init+0x0/0x34 returned 0 after 0 usecs
[   10.456798] calling  chainiv_module_init+0x0/0x39 @ 1
[   10.460007] initcall chainiv_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.466875] calling  eseqiv_module_init+0x0/0x39 @ 1
[   10.470006] initcall eseqiv_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.480019] calling  seqiv_module_init+0x0/0x39 @ 1
[   10.484895] initcall seqiv_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.490003] calling  hmac_module_init+0x0/0x39 @ 1
[   10.494789] initcall hmac_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.500004] calling  crypto_xcbc_module_init+0x0/0x39 @ 1
[   10.510005] initcall crypto_xcbc_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.517221] calling  crypto_null_mod_init+0x0/0xa5 @ 1
[   10.520117] alg: No test for cipher_null (cipher_null-generic)
[   10.526097] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[   10.530179] alg: No test for digest_null (digest_null-generic)
[   10.540174] alg: No test for compress_null (compress_null-generic)
[   10.546359] initcall crypto_null_mod_init+0x0/0xa5 returned 0 after 19531 usecs
[   10.550025] calling  md4_mod_init+0x0/0x39 @ 1
[   10.554659] initcall md4_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.560051] calling  md5_mod_init+0x0/0x39 @ 1
[   10.564663] initcall md5_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.570053] calling  rmd128_mod_init+0x0/0x39 @ 1
[   10.580162] initcall rmd128_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.586677] calling  rmd160_mod_init+0x0/0x39 @ 1
[   10.590216] initcall rmd160_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.596736] calling  rmd256_mod_init+0x0/0x39 @ 1
[   10.600185] initcall rmd256_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.610054] calling  sha1_generic_mod_init+0x0/0x39 @ 1
[   10.615423] initcall sha1_generic_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.620022] calling  sha256_generic_mod_init+0x0/0x65 @ 1
[   10.625722] initcall sha256_generic_mod_init+0x0/0x65 returned 0 after 0 usecs
[   10.630055] calling  wp512_mod_init+0x0/0x8a @ 1
[   10.640627] initcall wp512_mod_init+0x0/0x8a returned 0 after 0 usecs
[   10.647058] calling  tgr192_mod_init+0x0/0x8a @ 1
[   10.650553] initcall tgr192_mod_init+0x0/0x8a returned 0 after 0 usecs
[   10.657073] calling  crypto_ecb_module_init+0x0/0x39 @ 1
[   10.660173] initcall crypto_ecb_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.670004] calling  crypto_cbc_module_init+0x0/0x39 @ 1
[   10.675310] initcall crypto_cbc_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.680004] calling  crypto_module_init+0x0/0x39 @ 1
[   10.684963] initcall crypto_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.690003] calling  crypto_module_init+0x0/0x39 @ 1
[   10.700021] initcall crypto_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.706798] calling  crypto_ctr_module_init+0x0/0x69 @ 1
[   10.710006] initcall crypto_ctr_module_init+0x0/0x69 returned 0 after 0 usecs
[   10.720004] calling  cryptd_init+0x0/0x109 @ 1
[   10.724450] initcall cryptd_init+0x0/0x109 returned 0 after 0 usecs
[   10.730004] calling  des_generic_mod_init+0x0/0x65 @ 1
[   10.735530] initcall des_generic_mod_init+0x0/0x65 returned 0 after 0 usecs
[   10.740099] calling  fcrypt_mod_init+0x0/0x39 @ 1
[   10.744891] alg: No test for fcrypt (fcrypt-generic)
[   10.751125] initcall fcrypt_mod_init+0x0/0x39 returned 0 after 9765 usecs
[   10.760024] calling  blowfish_mod_init+0x0/0x39 @ 1
[   10.765837] initcall blowfish_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.770024] calling  twofish_mod_init+0x0/0x39 @ 1
[   10.775129] initcall twofish_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.780008] calling  aes_init+0x0/0x39 @ 1
[   10.784301] initcall aes_init+0x0/0x39 returned 0 after 0 usecs
[   10.790004] calling  cast5_mod_init+0x0/0x39 @ 1
[   10.800209] initcall cast5_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.806641] calling  cast6_mod_init+0x0/0x39 @ 1
[   10.810222] initcall cast6_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.816652] calling  arc4_init+0x0/0x39 @ 1
[   10.820198] initcall arc4_init+0x0/0x39 returned 0 after 0 usecs
[   10.826200] calling  tea_mod_init+0x0/0x8a @ 1
[   10.830601] initcall tea_mod_init+0x0/0x8a returned 0 after 0 usecs
[   10.840004] calling  khazad_mod_init+0x0/0x39 @ 1
[   10.844896] initcall khazad_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.850004] calling  anubis_mod_init+0x0/0x39 @ 1
[   10.854984] initcall anubis_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.860004] calling  seed_init+0x0/0x39 @ 1
[   10.864360] initcall seed_init+0x0/0x39 returned 0 after 0 usecs
[   10.870004] calling  deflate_mod_init+0x0/0x39 @ 1
[   10.875615] initcall deflate_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.880004] calling  zlib_mod_init+0x0/0x39 @ 1
[   10.891249] initcall zlib_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.897594] calling  michael_mic_init+0x0/0x39 @ 1
[   10.900195] initcall michael_mic_init+0x0/0x39 returned 0 after 0 usecs
[   10.906797] calling  crc32c_mod_init+0x0/0x39 @ 1
[   10.910215] initcall crc32c_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.920005] calling  crypto_authenc_module_init+0x0/0x39 @ 1
[   10.925655] initcall crypto_authenc_module_init+0x0/0x39 returned 0 after 0 usecs
[   10.930004] calling  lzo_mod_init+0x0/0x39 @ 1
[   10.934737] initcall lzo_mod_init+0x0/0x39 returned 0 after 0 usecs
[   10.940005] calling  krng_mod_init+0x0/0x39 @ 1
[   10.944614] alg: No test for stdrng (krng)
[   10.950132] initcall krng_mod_init+0x0/0x39 returned 0 after 9765 usecs
[   10.960004] calling  proc_genhd_init+0x0/0x63 @ 1
[   10.964723] initcall proc_genhd_init+0x0/0x63 returned 0 after 0 usecs
[   10.970004] calling  bsg_init+0x0/0x155 @ 1
[   10.974695] device class 'bsg': registering
[   10.980243] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   10.987629] initcall bsg_init+0x0/0x155 returned 0 after 9765 usecs
[   10.990004] calling  noop_init+0x0/0x3b @ 1
[   10.994209] io scheduler noop registered (default)
[   11.000004] initcall noop_init+0x0/0x3b returned 0 after 9765 usecs
[   11.006260] calling  as_init+0x0/0x3b @ 1
[   11.010003] io scheduler anticipatory registered
[   11.014617] initcall as_init+0x0/0x3b returned 0 after 0 usecs
[   11.020025] calling  deadline_init+0x0/0x3b @ 1
[   11.024554] io scheduler deadline registered
[   11.030004] initcall deadline_init+0x0/0x3b returned 0 after 9765 usecs
[   11.036607] calling  debug_objects_init_debugfs+0x0/0x8a @ 1
[   11.040035] initcall debug_objects_init_debugfs+0x0/0x8a returned 0 after 0 usecs
[   11.050004] calling  libcrc32c_mod_init+0x0/0x53 @ 1
[   11.054967] initcall libcrc32c_mod_init+0x0/0x53 returned 0 after 0 usecs
[   11.060019] calling  percpu_counter_startup+0x0/0x54 @ 1
[   11.065326] initcall percpu_counter_startup+0x0/0x54 returned 0 after 0 usecs
[   11.070007] calling  pci_init+0x0/0x60 @ 1
[   11.080015] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.086272] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.090005] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xe3
[   11.095834] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.100019] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.110003] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xe3
[   11.115834] pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x4e
[   11.120004] pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0x63e
[   11.130003] pci 0000:00:01.1: calling pci_fixup_video+0x0/0xe3
[   11.135834] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.140019] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.170025] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xe3
[   11.175864] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x4e
[   11.180005] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x63e
[   11.186623] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xe3
[   11.190010] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.200004] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.206609] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xe3
[   11.210010] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.216270] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.220026] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xe3
[   11.230010] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.236271] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.240004] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xe3
[   11.250010] pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.256271] pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.260019] pci 0000:00:0a.0: calling pci_fixup_video+0x0/0xe3
[   11.265852] pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
[   11.270005] pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.280004] pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.286607] pci 0000:00:0b.0: calling pci_fixup_video+0x0/0xe3
[   11.290010] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
[   11.300019] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.306278] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.310003] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xe3
[   11.320010] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
[   11.327568] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.330006] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.340018] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xe3
[   11.345853] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
[   11.350004] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.360004] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.366607] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xe3
[   11.370010] pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x76
[   11.380022] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.386278] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.390003] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xe3
[   11.395833] pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x76
[   11.400006] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x4e
[   11.410004] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x63e
[   11.416609] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xe3
[   11.420024] pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x76
[   11.430006] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x4e
[   11.436269] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x63e
[   11.440003] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xe3
[   11.445835] pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x76
[   11.450006] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x4e
[   11.460019] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x63e
[   11.466624] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xe3
[   11.470010] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.476270] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.480004] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xe3
[   11.490010] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x4e
[   11.496271] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x63e
[   11.500018] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xe3
[   11.510004] pci 0000:01:00.0: Boot video device
[   11.514536] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x4e
[   11.520004] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x63e
[   11.526609] pci 0000:01:00.1: calling pci_fixup_video+0x0/0xe3
[   11.530009] initcall pci_init+0x0/0x60 returned 0 after 439453 usecs
[   11.540019] calling  pci_proc_init+0x0/0x90 @ 1
[   11.544850] initcall pci_proc_init+0x0/0x90 returned 0 after 0 usecs
[   11.550004] calling  pci_hotplug_init+0x0/0x74 @ 1
[   11.554788] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   11.560004] initcall pci_hotplug_init+0x0/0x74 returned 0 after 9765 usecs
[   11.566867] calling  zt5550_init+0x0/0xa3 @ 1
[   11.570002] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[   11.580021] bus: 'pci': add driver zt5550_hc
[   11.584558] initcall zt5550_init+0x0/0xa3 returned 0 after 9765 usecs
[   11.590008] calling  cpcihp_generic_init+0x0/0x443 @ 1
[   11.595142] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[   11.600002] cpcihp_generic: not configured, disabling.
[   11.605136] initcall cpcihp_generic_init+0x0/0x443 returned -22 after 9765 usecs
[   11.610004] initcall cpcihp_generic_init+0x0/0x443 returned with error code -22 
[   11.620004] calling  shpcd_init+0x0/0x88 @ 1
[   11.624270] bus: 'pci': add driver shpchp
[   11.630040] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver shpchp
[   11.640003] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0b.0
[   11.647918] bus: 'pci': driver_probe_device: matched device 0000:00:0c.0 with driver shpchp
[   11.650019] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0c.0
[   11.660147] bus: 'pci': driver_probe_device: matched device 0000:00:0d.0 with driver shpchp
[   11.670057] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0d.0
[   11.680157] bus: 'pci': driver_probe_device: matched device 0000:00:0e.0 with driver shpchp
[   11.688493] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:0e.0
[   11.690459] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.700058] initcall shpcd_init+0x0/0x88 returned 0 after 78125 usecs
[   11.710004] calling  init_legacy+0x0/0x69 @ 1
[   11.714648] initcall init_legacy+0x0/0x69 returned 0 after 0 usecs
[   11.720004] calling  tdo24m_init+0x0/0x39 @ 1
[   11.724357] bus: 'spi': add driver tdo24m
[   11.730232] initcall tdo24m_init+0x0/0x39 returned 0 after 9765 usecs
[   11.736669] calling  kb3886_init+0x0/0x32 @ 1
[   11.740071] initcall kb3886_init+0x0/0x32 returned -19 after 0 usecs
[   11.746415] calling  display_class_init+0x0/0xa5 @ 1
[   11.750004] device class 'display': registering
[   11.754753] initcall display_class_init+0x0/0xa5 returned 0 after 0 usecs
[   11.760026] calling  rand_initialize+0x0/0x58 @ 1
[   11.764761] initcall rand_initialize+0x0/0x58 returned 0 after 0 usecs
[   11.770004] calling  tty_init+0x0/0x11c @ 1
[   11.774192] device: 'tty': device_add
[   11.780256] device: 'console': device_add
[   11.784483] device: 'tty0': device_add
[   11.790282] device class 'vc': registering
[   11.794596] device: 'vcs': device_add
[   11.800199] device: 'vcsa': device_add
[   11.804190] device: 'vcs1': device_add
[   11.808152] device: 'vcsa1': device_add
[   11.810274] device: 'tty1': device_add
[   11.814291] device: 'tty2': device_add
[   11.820435] device: 'tty3': device_add
[   11.824414] device: 'tty4': device_add
[   11.828383] device: 'tty5': device_add
[   11.830409] device: 'tty6': device_add
[   11.834375] device: 'tty7': device_add
[   11.840251] device: 'tty8': device_add
[   11.844259] device: 'tty9': device_add
[   11.848241] device: 'tty10': device_add
[   11.850251] device: 'tty11': device_add
[   11.854305] device: 'tty12': device_add
[   11.860245] device: 'tty13': device_add
[   11.864310] device: 'tty14': device_add
[   11.868358] device: 'tty15': device_add
[   11.870285] device: 'tty16': device_add
[   11.874341] device: 'tty17': device_add
[   11.880229] device: 'tty18': device_add
[   11.884333] device: 'tty19': device_add
[   11.888387] device: 'tty20': device_add
[   11.890304] device: 'tty21': device_add
[   11.894358] device: 'tty22': device_add
[   11.900234] device: 'tty23': device_add
[   11.904304] device: 'tty24': device_add
[   11.908378] device: 'tty25': device_add
[   11.910285] device: 'tty26': device_add
[   11.914343] device: 'tty27': device_add
[   11.920232] device: 'tty28': device_add
[   11.924323] device: 'tty29': device_add
[   11.930583] device: 'tty30': device_add
[   11.934636] device: 'tty31': device_add
[   11.938689] device: 'tty32': device_add
[   11.940257] device: 'tty33': device_add
[   11.944339] device: 'tty34': device_add
[   11.950425] device: 'tty35': device_add
[   11.954498] device: 'tty36': device_add
[   11.958560] device: 'tty37': device_add
[   11.960312] device: 'tty38': device_add
[   11.964416] device: 'tty39': device_add
[   11.970271] device: 'tty40': device_add
[   11.974362] device: 'tty41': device_add
[   11.978412] device: 'tty42': device_add
[   11.980250] device: 'tty43': device_add
[   11.984308] device: 'tty44': device_add
[   11.990259] device: 'tty45': device_add
[   11.994316] device: 'tty46': device_add
[   12.000630] device: 'tty47': device_add
[   12.004691] device: 'tty48': device_add
[   12.008785] device: 'tty49': device_add
[   12.010226] device: 'tty50': device_add
[   12.014339] device: 'tty51': device_add
[   12.020266] device: 'tty52': device_add
[   12.024375] device: 'tty53': device_add
[   12.028433] device: 'tty54': device_add
[   12.030269] device: 'tty55': device_add
[   12.034336] device: 'tty56': device_add
[   12.040295] device: 'tty57': device_add
[   12.044354] device: 'tty58': device_add
[   12.048448] device: 'tty59': device_add
[   12.050240] device: 'tty60': device_add
[   12.054313] device: 'tty61': device_add
[   12.060252] device: 'tty62': device_add
[   12.064308] device: 'tty63': device_add
[   12.070630] initcall tty_init+0x0/0x11c returned 0 after 292968 usecs
[   12.077059] calling  pty_init+0x0/0x35d @ 1
[   12.080087] device: 'ptmx': device_add
[   12.084072] initcall pty_init+0x0/0x35d returned 0 after 0 usecs
[   12.090036] calling  sysrq_init+0x0/0x4c @ 1
[   12.094322] initcall sysrq_init+0x0/0x4c returned 0 after 0 usecs
[   12.100004] calling  nozomi_init+0x0/0x153 @ 1
[   12.104441] Initializing Nozomi driver 2.1d (build date: Aug  2 2009 22:49:23)
[   12.110030] bus: 'pci': add driver nozomi
[   12.114293] initcall nozomi_init+0x0/0x153 returned 0 after 9765 usecs
[   12.120059] calling  lp_init_module+0x0/0x259 @ 1
[   12.124771] device class 'printer': registering
[   12.130247] lp: driver loaded but no devices found
[   12.135032] initcall lp_init_module+0x0/0x259 returned 0 after 9765 usecs
[   12.140025] calling  rtc_init+0x0/0x12c @ 1
[   12.144228] device: 'rtc': device_add
[   12.150263] Real Time Clock Driver v1.12b
[   12.154270] initcall rtc_init+0x0/0x12c returned 0 after 9765 usecs
[   12.160024] calling  mod_init+0x0/0x73 @ 1
[   12.164121] initcall mod_init+0x0/0x73 returned -19 after 0 usecs
[   12.170004] calling  ppdev_init+0x0/0xe2 @ 1
[   12.174277] device class 'ppdev': registering
[   12.180212] ppdev: user-space parallel port driver
[   12.184999] initcall ppdev_init+0x0/0xe2 returned 0 after 9765 usecs
[   12.190007] calling  tlclk_init+0x0/0x274 @ 1
[   12.194382] telclk_interrup = 0xf non-mcpbl0010 hw.
[   12.200030] initcall tlclk_init+0x0/0x274 returned -6 after 9765 usecs
[   12.206547] initcall tlclk_init+0x0/0x274 returned with error code -6 
[   12.210004] calling  mwave_init+0x0/0x2ca @ 1
[   12.220008] smapi::smapi_init, ERROR invalid usSmapiID
[   12.225142] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   12.230025] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   12.240002] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   12.246261] initcall mwave_init+0x0/0x2ca returned -5 after 19531 usecs
[   12.250004] initcall mwave_init+0x0/0x2ca returned with error code -5 
[   12.260004] calling  agp_init+0x0/0x4b @ 1
[   12.264094] Linux agpgart interface v0.103
[   12.270019] initcall agp_init+0x0/0x4b returned 0 after 9765 usecs
[   12.276192] calling  agp_amd64_init+0x0/0xe8 @ 1
[   12.280003] bus: 'pci': add driver agpgart-amd64
[   12.285079] initcall agp_amd64_init+0x0/0xe8 returned -19 after 0 usecs
[   12.290005] calling  agp_intel_init+0x0/0x50 @ 1
[   12.294615] bus: 'pci': add driver agpgart-intel
[   12.300241] initcall agp_intel_init+0x0/0x50 returned 0 after 9765 usecs
[   12.306936] calling  agp_sis_init+0x0/0x50 @ 1
[   12.310004] bus: 'pci': add driver agpgart-sis
[   12.314705] initcall agp_sis_init+0x0/0x50 returned 0 after 0 usecs
[   12.320005] calling  ipmi_init_msghandler_mod+0x0/0x34 @ 1
[   12.325482] bus: 'platform': add driver ipmi
[   12.330221] ipmi message handler version 39.2
[   12.334587] initcall ipmi_init_msghandler_mod+0x0/0x34 returned 0 after 9765 usecs
[   12.340005] calling  ipmi_wdog_init+0x0/0x153 @ 1
[   12.350025] IPMI Watchdog: driver initialized
[   12.354383] initcall ipmi_wdog_init+0x0/0x153 returned 0 after 0 usecs
[   12.360006] calling  ipmi_poweroff_init+0x0/0xb7 @ 1
[   12.364969] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   12.370028] initcall ipmi_poweroff_init+0x0/0xb7 returned 0 after 9765 usecs
[   12.380026] calling  drm_core_init+0x0/0x145 @ 1
[   12.384647] device class 'drm': registering
[   12.390287] [drm] Initialized drm 1.1.0 20060810
[   12.394903] initcall drm_core_init+0x0/0x145 returned 0 after 9765 usecs
[   12.400005] calling  mga_init+0x0/0x45 @ 1
[   12.404137] initcall mga_init+0x0/0x45 returned 0 after 0 usecs
[   12.410004] calling  i810_init+0x0/0x45 @ 1
[   12.414224] initcall i810_init+0x0/0x45 returned 0 after 0 usecs
[   12.420004] calling  sis_init+0x0/0x45 @ 1
[   12.424179] initcall sis_init+0x0/0x45 returned 0 after 0 usecs
[   12.430021] calling  savage_init+0x0/0x45 @ 1
[   12.434606] initcall savage_init+0x0/0x45 returned 0 after 0 usecs
[   12.440026] calling  via_init+0x0/0x4a @ 1
[   12.444219] initcall via_init+0x0/0x4a returned 0 after 0 usecs
[   12.450004] calling  serial8250_init+0x0/0x16f @ 1
[   12.454786] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   12.460051] Registering platform device 'serial8250'. Parent at platform
[   12.470005] device: 'serial8250': device_add
[   12.474276] bus: 'platform': add device serial8250
[   12.480304] async_waiting @ 1
[   12.483281] async_continuing @ 1 after 0 usec
[   12.620064] async_waiting @ 1
[   12.623031] async_continuing @ 1 after 0 usec
�[   12.760103] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   12.766120] device: 'ttyS0': device_add
[   12.770255] device: 'ttyS1': device_add
[   12.774346] device: 'ttyS2': device_add
[   12.778434] device: 'ttyS3': device_add
[   12.780253] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[   12.787549] bus: 'platform': add driver serial8250
[   12.790015] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   12.800003] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   12.810011] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   12.817048] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   12.820248] initcall serial8250_init+0x0/0x16f returned 0 after 361328 usecs
[   12.830029] calling  jsm_init_module+0x0/0x6e @ 1
[   12.834778] bus: 'pci': add driver jsm
[   12.840253] initcall jsm_init_module+0x0/0x6e returned 0 after 9765 usecs
[   12.847033] calling  init_kgdboc+0x0/0x3b @ 1
[   12.850006] initcall init_kgdboc+0x0/0x3b returned 0 after 0 usecs
[   12.860004] calling  parport_default_proc_register+0x0/0x42 @ 1
[   12.865956] initcall parport_default_proc_register+0x0/0x42 returned 0 after 0 usecs
[   12.870003] calling  parport_pc_init+0x0/0x355 @ 1
[   12.874789] bus: 'platform': add driver parport_pc
[   12.880233] IT8712 SuperIO detected.
[   12.884151] Registering platform device 'parport_pc.956'. Parent at platform
[   12.890027] device: 'parport_pc.956': device_add
[   12.894648] bus: 'platform': add device parport_pc.956
[   12.900217] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[   12.910004] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[   12.920011] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[   12.930005] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[   12.938429] bus: 'platform': remove device parport_pc.956
[   12.940237] Registering platform device 'parport_pc.888'. Parent at platform
[   12.950027] device: 'parport_pc.888': device_add
[   12.954647] bus: 'platform': add device parport_pc.888
[   12.960217] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[   12.970004] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[   12.978693] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[   12.980003] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[   12.990053] parport0: PC-style at 0x378 (0x778)async_waiting @ 1
[   13.000003] async_continuing @ 1 after 0 usec
[   13.141034]  [PCSPP,TRISTATE]
[   13.144052] parport0: irq 7 detected
[   13.220165] device: 'parport0': device_add
[   13.224600] device: 'lp0': device_add
[   13.228517] lp0: using parport0 (polling).
[   13.230028] lp0: console ready
[   13.233086] Registering platform device 'parport_pc.632'. Parent at platform
[   13.240005] device: 'parport_pc.632': device_add
[   13.244621] bus: 'platform': add device parport_pc.632
[   13.250227] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[   13.260082] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[   13.270011] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[   13.277396] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[   13.280073] bus: 'platform': remove device parport_pc.632
[   13.290235] bus: 'pci': add driver parport_pc
[   13.294830] initcall parport_pc_init+0x0/0x355 returned 0 after 410156 usecs
[   13.300072] calling  topology_sysfs_init+0x0/0x82 @ 1
[   13.305154] initcall topology_sysfs_init+0x0/0x82 returned 0 after 0 usecs
[   13.310004] calling  floppy_init+0x0/0xe23 @ 1
[   13.320089] Platform driver 'floppy' needs updating - please use dev_pm_ops
[   13.327040] bus: 'platform': add driver floppy
[   13.330346] Floppy drive(s): fd0 is 1.44M
[   13.353888] FDC 0 is a post-1991 82077
[   13.358610] Registering platform device 'floppy.0'. Parent at platform
[   13.360022] device: 'floppy.0': device_add
[   13.364131] bus: 'platform': add device floppy.0
[   13.370229] bus: 'platform': driver_probe_device: matched device floppy.0 with driver floppy
[   13.380005] bus: 'platform': really_probe: probing driver floppy with device floppy.0
[   13.390011] driver: 'floppy.0': driver_bound: bound to device 'floppy'
[   13.396528] bus: 'platform': really_probe: bound device floppy.0 to driver floppy
[   13.400012] device: 'fd0': device_add
[   13.404023] device: '2:0': device_add
[   13.410281] initcall floppy_init+0x0/0xe23 returned 0 after 87890 usecs
[   13.416885] calling  loop_init+0x0/0x1bc @ 1
[   13.420291] device: 'loop0': device_add
[   13.424478] device: '7:0': device_add
[   13.430289] device: 'loop1': device_add
[   13.434513] device: '7:1': device_add
[   13.438420] device: 'loop2': device_add
[   13.440317] device: '7:2': device_add
[   13.444257] device: 'loop3': device_add
[   13.450344] device: '7:3': device_add
[   13.454278] device: 'loop4': device_add
[   13.460327] device: '7:4': device_add
[   13.464225] device: 'loop5': device_add
[   13.468373] device: '7:5': device_add
[   13.470313] device: 'loop6': device_add
[   13.474463] device: '7:6': device_add
[   13.480406] device: 'loop7': device_add
[   13.484580] device: '7:7': device_add
[   13.488499] loop: module loaded
[   13.490060] initcall loop_init+0x0/0x1bc returned 0 after 68359 usecs
[   13.496494] calling  cpqarray_init+0x0/0x2ba @ 1
[   13.500003] Compaq SMART2 Driver (v 2.6.0)
[   13.504097] bus: 'pci': add driver cpqarray
[   13.510267] bus: 'pci': remove driver cpqarray
[   13.514924] driver: 'cpqarray': driver_release
[   13.520039] initcall cpqarray_init+0x0/0x2ba returned -19 after 19531 usecs
[   13.526988] calling  cciss_init+0x0/0x7a @ 1
[   13.530006] HP CISS Driver (v 3.6.20)
[   13.533907] bus: 'cciss': registered
[   13.537481] bus: 'pci': add driver cciss
[   13.540286] initcall cciss_init+0x0/0x7a returned 0 after 9765 usecs
[   13.546635] calling  DAC960_init_module+0x0/0x78 @ 1
[   13.550022] bus: 'pci': add driver DAC960
[   13.554272] device: 'dac960_gam': device_add
[   13.560269] initcall DAC960_init_module+0x0/0x78 returned 0 after 9765 usecs
[   13.570004] calling  nbd_init+0x0/0x305 @ 1
[   13.574962] nbd: registered device at major 43
[   13.580017] device: 'nbd0': device_add
[   13.584088] device: '43:0': device_add
[   13.588076] device: 'nbd1': device_add
[   13.590350] device: '43:1': device_add
[   13.594362] device: 'nbd2': device_add
[   13.600360] device: '43:2': device_add
[   13.604370] device: 'nbd3': device_add
[   13.608423] device: '43:3': device_add
[   13.610309] device: 'nbd4': device_add
[   13.614390] device: '43:4': device_add
[   13.620243] device: 'nbd5': device_add
[   13.624356] device: '43:5': device_add
[   13.628339] device: 'nbd6': device_add
[   13.630400] device: '43:6': device_add
[   13.634399] device: 'nbd7': device_add
[   13.640345] device: '43:7': device_add
[   13.644381] device: 'nbd8': device_add
[   13.648451] device: '43:8': device_add
[   13.650295] device: 'nbd9': device_add
[   13.654368] device: '43:9': device_add
[   13.660259] device: 'nbd10': device_add
[   13.664438] device: '43:10': device_add
[   13.668513] device: 'nbd11': device_add
[   13.670381] device: '43:11': device_add
[   13.674452] device: 'nbd12': device_add
[   13.680325] device: '43:12': device_add
[   13.684445] device: 'nbd13': device_add
[   13.690703] device: '43:13': device_add
[   13.694776] device: 'nbd14': device_add
[   13.698967] device: '43:14': device_add
[   13.700273] device: 'nbd15': device_add
[   13.704518] device: '43:15': device_add
[   13.710264] initcall nbd_init+0x0/0x305 returned 0 after 136718 usecs
[   13.716692] calling  init_cryptoloop+0x0/0x55 @ 1
[   13.720005] initcall init_cryptoloop+0x0/0x55 returned 0 after 0 usecs
[   13.726519] calling  ibmasm_init+0x0/0x8a @ 1
[   13.730020] bus: 'pci': add driver ibmasm
[   13.734266] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   13.740010] initcall ibmasm_init+0x0/0x8a returned 0 after 9765 usecs
[   13.750003] calling  ics932s401_init+0x0/0x3b @ 1
[   13.754701] bus: 'i2c': add driver ics932s401
[   13.760342] initcall ics932s401_init+0x0/0x3b returned 0 after 9765 usecs
[   13.767121] calling  tifm_7xx1_init+0x0/0x42 @ 1
[   13.770003] bus: 'pci': add driver tifm_7xx1
[   13.774495] initcall tifm_7xx1_init+0x0/0x42 returned 0 after 0 usecs
[   13.780005] calling  phantom_init+0x0/0x12f @ 1
[   13.784527] device class 'phantom': registering
[   13.790251] bus: 'pci': add driver phantom
[   13.794592] Phantom Linux Driver, version n0.9.8, init OK
[   13.800005] initcall phantom_init+0x0/0x12f returned 0 after 19531 usecs
[   13.806703] calling  ioc4_init+0x0/0x47 @ 1
[   13.810004] bus: 'pci': add driver IOC4
[   13.814066] initcall ioc4_init+0x0/0x47 returned 0 after 0 usecs
[   13.820004] calling  ilo_init+0x0/0xb8 @ 1
[   13.824095] device class 'iLO': registering
[   13.830230] bus: 'pci': add driver hpilo
[   13.834403] initcall ilo_init+0x0/0xb8 returned 0 after 9765 usecs
[   13.840005] calling  c2port_init+0x0/0x77 @ 1
[   13.844353] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[   13.850004] device class 'c2port': registering
[   13.854653] initcall c2port_init+0x0/0x77 returned 0 after 9765 usecs
[   13.860005] calling  duramar2150_c2port_init+0x0/0x97 @ 1
[   13.865489] device: 'c2port0': device_add
[   13.870286] c2port c2port0: C2 port uc added
[   13.874553] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[   13.880006] initcall duramar2150_c2port_init+0x0/0x97 returned 0 after 19531 usecs
[   13.890004] calling  at24_init+0x0/0x5d @ 1
[   13.894183] bus: 'i2c': add driver at24
[   13.900218] initcall at24_init+0x0/0x5d returned 0 after 9765 usecs
[   13.906478] calling  at25_init+0x0/0x39 @ 1
[   13.910005] bus: 'spi': add driver at25
[   13.914068] initcall at25_init+0x0/0x39 returned 0 after 0 usecs
[   13.920004] calling  eeprom_init+0x0/0x3b @ 1
[   13.924355] bus: 'i2c': add driver eeprom
[   13.930221] initcall eeprom_init+0x0/0x3b returned 0 after 9765 usecs
[   13.936649] calling  max6875_init+0x0/0x3b @ 1
[   13.940004] bus: 'i2c': add driver max6875
[   13.944328] initcall max6875_init+0x0/0x3b returned 0 after 0 usecs
[   13.950004] calling  cb710_init_module+0x0/0x42 @ 1
[   13.954875] bus: 'pci': add driver cb710
[   13.960243] initcall cb710_init_module+0x0/0x42 returned 0 after 9765 usecs
[   13.967196] calling  pasic3_base_init+0x0/0x40 @ 1
[   13.970006] bus: 'platform': add driver pasic3
[   13.974735] bus: 'platform': remove driver pasic3
[   13.980211] driver: 'pasic3': driver_release
[   13.984481] initcall pasic3_base_init+0x0/0x40 returned -19 after 9765 usecs
[   13.990004] calling  ezx_pcap_init+0x0/0x39 @ 1
[   13.994529] bus: 'spi': add driver ezx-pcap
[   14.000221] initcall ezx_pcap_init+0x0/0x39 returned 0 after 9765 usecs
[   14.006825] calling  scsi_tgt_init+0x0/0xb1 @ 1
[   14.010805] device: 'tgt': device_add
[   14.014740] initcall scsi_tgt_init+0x0/0xb1 returned 0 after 0 usecs
[   14.020005] calling  raid_init+0x0/0x39 @ 1
[   14.024179] device class 'raid_devices': registering
[   14.030238] initcall raid_init+0x0/0x39 returned 0 after 9765 usecs
[   14.040012] calling  spi_transport_init+0x0/0x9f @ 1
[   14.044984] device class 'spi_transport': registering
[   14.050240] device class 'spi_host': registering
[   14.055093] initcall spi_transport_init+0x0/0x9f returned 0 after 9765 usecs
[   14.060005] calling  fc_transport_init+0x0/0x73 @ 1
[   14.064872] device class 'fc_host': registering
[   14.070212] device class 'fc_vports': registering
[   14.075112] device class 'fc_remote_ports': registering
[   14.080259] device class 'fc_transport': registering
[   14.085424] initcall fc_transport_init+0x0/0x73 returned 0 after 19531 usecs
[   14.090004] calling  iscsi_transport_init+0x0/0x173 @ 1
[   14.100002] Loading iSCSI transport class v2.0-870.
[   14.104874] device class 'iscsi_transport': registering
[   14.110211] device class 'iscsi_endpoint': registering
[   14.115545] device class 'iscsi_host': registering
[   14.120292] device class 'iscsi_connection': registering
[   14.125804] device class 'iscsi_session': registering
[   14.130326] initcall iscsi_transport_init+0x0/0x173 returned 0 after 29296 usecs
[   14.137714] calling  sas_transport_init+0x0/0xe1 @ 1
[   14.140004] device class 'sas_host': registering
[   14.144883] device class 'sas_phy': registering
[   14.150213] device class 'sas_port': registering
[   14.155050] device class 'sas_device': registering
[   14.160231] device class 'sas_end_device': registering
[   14.165601] device class 'sas_expander': registering
[   14.170215] initcall sas_transport_init+0x0/0xe1 returned 0 after 29296 usecs
[   14.180005] calling  sas_class_init+0x0/0x58 @ 1
[   14.185105] initcall sas_class_init+0x0/0x58 returned 0 after 0 usecs
[   14.190004] calling  srp_transport_init+0x0/0x65 @ 1
[   14.194959] device class 'srp_host': registering
[   14.200216] device class 'srp_remote_ports': registering
[   14.205760] initcall srp_transport_init+0x0/0x65 returned 0 after 9765 usecs
[   14.210005] calling  libfc_init+0x0/0x96 @ 1
[   14.220974] initcall libfc_init+0x0/0x96 returned 0 after 9765 usecs
[   14.227325] calling  fcoe_init+0x0/0x1ab @ 1
[   14.230260] initcall fcoe_init+0x0/0x1ab returned 0 after 0 usecs
[   14.236345] calling  fnic_init_module+0x0/0x20d @ 1
[   14.240004] fnic: Cisco FCoE HBA Driver, ver 1.0.0.1121
[   14.246678] bus: 'pci': add driver fnic
[   14.250264] initcall fnic_init_module+0x0/0x20d returned 0 after 9765 usecs
[   14.260010] calling  BusLogic_init+0x0/0x1830 @ 1
[   14.264807] initcall BusLogic_init+0x0/0x1830 returned 0 after 0 usecs
[   14.270004] calling  adpt_init+0x0/0xe95 @ 1
[   14.274267] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   14.280002] Detecting Adaptec I2O RAID controllers...
[   14.285060] initcall adpt_init+0x0/0xe95 returned -19 after 9765 usecs
[   14.290006] calling  arcmsr_module_init+0x0/0x47 @ 1
[   14.294962] bus: 'pci': add driver arcmsr
[   14.300267] initcall arcmsr_module_init+0x0/0x47 returned 0 after 9765 usecs
[   14.307310] calling  ahc_linux_init+0x0/0x8d @ 1
[   14.310009] bus: 'pci': add driver aic7xxx
[   14.314401] initcall ahc_linux_init+0x0/0x8d returned 0 after 0 usecs
[   14.320004] calling  ahd_linux_init+0x0/0xa7 @ 1
[   14.324617] bus: 'pci': add driver aic79xx
[   14.330254] initcall ahd_linux_init+0x0/0xa7 returned 0 after 9765 usecs
[   14.340005] calling  aac_init+0x0/0x95 @ 1
[   14.344096] Adaptec aacraid driver 1.1-5[2461]-ms
[   14.348800] bus: 'pci': add driver aacraid
[   14.350259] initcall aac_init+0x0/0x95 returned 0 after 9765 usecs
[   14.360005] calling  init_this_scsi_driver+0x0/0x10c @ 1
[   14.365676] initcall init_this_scsi_driver+0x0/0x10c returned -19 after 0 usecs
[   14.370004] calling  ips_module_init+0x0/0x3b7 @ 1
[   14.374790] bus: 'pci': add driver ips
[   14.380260] bus: 'pci': remove driver ips
[   14.384468] driver: 'ips': driver_release
[   14.390009] initcall ips_module_init+0x0/0x3b7 returned -19 after 19531 usecs
[   14.397135] calling  init_this_scsi_driver+0x0/0x10c @ 1
[   14.400058] scsi: <fdomain> Detection failed (no card)
[   14.405188] initcall init_this_scsi_driver+0x0/0x10c returned -19 after 0 usecs
[   14.410004] calling  qla1280_init+0x0/0x42 @ 1
[   14.414443] bus: 'pci': add driver qla1280
[   14.420234] initcall qla1280_init+0x0/0x42 returned 0 after 9765 usecs
[   14.430028] calling  qla2x00_module_init+0x0/0x152 @ 1
[   14.435704] QLogic Fibre Channel HBA Driver: 8.03.01-k4
[   14.440005] bus: 'pci': add driver qla2xxx
[   14.444372] initcall qla2x00_module_init+0x0/0x152 returned 0 after 9765 usecs
[   14.450005] calling  dc395x_module_init+0x0/0x42 @ 1
[   14.454970] bus: 'pci': add driver dc395x
[   14.460235] initcall dc395x_module_init+0x0/0x42 returned 0 after 9765 usecs
[   14.467275] calling  dc390_module_init+0x0/0xbf @ 1
[   14.470003] DC390: clustering now enabled by default. If you get problems load
[   14.480002]        with "disable_clustering=1" and report to maintainers
[   14.486694] bus: 'pci': add driver tmscsim
[   14.490236] initcall dc390_module_init+0x0/0xbf returned 0 after 19531 usecs
[   14.497275] calling  mraid_mm_init+0x0/0xa7 @ 1
[   14.500004] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   14.510010] device: 'megadev0': device_add
[   14.514341] initcall mraid_mm_init+0x0/0xa7 returned 0 after 9765 usecs
[   14.520008] calling  megaraid_init+0x0/0xbc @ 1
[   14.524538] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   14.530006] bus: 'pci': add driver megaraid
[   14.534429] initcall megaraid_init+0x0/0xbc returned 0 after 9765 usecs
[   14.540005] calling  megasas_init+0x0/0x180 @ 1
[   14.544528] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[   14.550014] bus: 'pci': add driver megaraid_sas
[   14.554778] initcall megasas_init+0x0/0x180 returned 0 after 9765 usecs
[   14.560005] calling  _scsih_init+0x0/0x117 @ 1
[   14.570003] mpt2sas version 01.100.03.00 loaded
[   14.574556] device: 'mpt2ctl': device_add
[   14.578801] bus: 'pci': add driver mpt2sas
[   14.580275] initcall _scsih_init+0x0/0x117 returned 0 after 9765 usecs
[   14.590004] calling  inia100_init+0x0/0x42 @ 1
[   14.594442] bus: 'pci': add driver inia100
[   14.598768] initcall inia100_init+0x0/0x42 returned 0 after 0 usecs
[   14.600005] calling  tw_init+0x0/0x55 @ 1
[   14.604007] 3ware Storage Controller device driver for Linux v1.26.02.002.
[   14.610003] bus: 'pci': add driver 3w-xxxx
[   14.620234] initcall tw_init+0x0/0x55 returned 0 after 19531 usecs
[   14.626409] calling  twa_init+0x0/0x55 @ 1
[   14.630006] 3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
[   14.637308] bus: 'pci': add driver 3w-9xxx
[   14.640235] initcall twa_init+0x0/0x55 returned 0 after 9765 usecs
[   14.646408] calling  ppa_driver_init+0x0/0x4c @ 1
[   14.650004] ppa: Version 2.07 (for Linux 2.4.x)
[   14.660401] initcall ppa_driver_init+0x0/0x4c returned 0 after 9765 usecs
[   14.667177] calling  ipr_init+0x0/0x5c @ 1
[   14.670003] ipr: IBM Power RAID SCSI Device Driver version: 2.4.3 (June 10, 2009)
[   14.677472] bus: 'pci': add driver ipr
[   14.680237] initcall ipr_init+0x0/0x5c returned 0 after 9765 usecs
[   14.686410] calling  hptiop_module_init+0x0/0x5c @ 1
[   14.690004] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[   14.696000] bus: 'pci': add driver hptiop
[   14.700247] initcall hptiop_module_init+0x0/0x5c returned 0 after 9765 usecs
[   14.710005] calling  stex_init+0x0/0x55 @ 1
[   14.714179] stex: Promise SuperTrak EX Driver version: 4.6.0000.3
[   14.720004] bus: 'pci': add driver stex
[   14.724070] initcall stex_init+0x0/0x55 returned 0 after 9765 usecs
[   14.730007] calling  mvs_init+0x0/0x79 @ 1
[   14.734124] bus: 'pci': add driver mvsas
[   14.740230] initcall mvs_init+0x0/0x79 returned 0 after 9765 usecs
[   14.746406] calling  cxgb3i_init_module+0x0/0x5d @ 1
[   14.750004] cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[   14.755763] device: 'cxgb3i': device_add
[   14.760229] iscsi: registered transport (cxgb3i)
[   14.764858] initcall cxgb3i_init_module+0x0/0x5d returned 0 after 9765 usecs
[   14.770005] calling  init_sd+0x0/0x106 @ 1
[   14.774124] device class 'scsi_disk': registering
[   14.780221] bus: 'scsi': add driver sd
[   14.784214] initcall init_sd+0x0/0x106 returned 0 after 9765 usecs
[   14.790005] calling  init_sr+0x0/0x6f @ 1
[   14.794009] bus: 'scsi': add driver sr
[   14.800331] initcall init_sr+0x0/0x6f returned 0 after 9765 usecs
[   14.806414] calling  init_sg+0x0/0x170 @ 1
[   14.810006] device class 'scsi_generic': registering
[   14.815284] initcall init_sg+0x0/0x170 returned 0 after 0 usecs
[   14.820005] calling  ahci_init+0x0/0x42 @ 1
[   14.824184] bus: 'pci': add driver ahci
[   14.830024] initcall ahci_init+0x0/0x42 returned 0 after 9765 usecs
[   14.836285] calling  k2_sata_init+0x0/0x42 @ 1
[   14.840004] bus: 'pci': add driver sata_svw
[   14.844415] initcall k2_sata_init+0x0/0x42 returned 0 after 0 usecs
[   14.850005] calling  piix_init+0x0/0x50 @ 1
[   14.854183] bus: 'pci': add driver ata_piix
[   14.860179] initcall piix_init+0x0/0x50 returned 0 after 9765 usecs
[   14.866440] calling  pdc_ata_init+0x0/0x42 @ 1
[   14.870005] bus: 'pci': add driver sata_promise
[   14.874793] initcall pdc_ata_init+0x0/0x42 returned 0 after 0 usecs
[   14.880004] calling  qs_ata_init+0x0/0x42 @ 1
[   14.884357] bus: 'pci': add driver sata_qstor
[   14.890250] initcall qs_ata_init+0x0/0x42 returned 0 after 9765 usecs
[   14.896685] calling  sil_init+0x0/0x42 @ 1
[   14.900005] bus: 'pci': add driver sata_sil
[   14.904436] initcall sil_init+0x0/0x42 returned 0 after 0 usecs
[   14.910004] calling  sil24_init+0x0/0x42 @ 1
[   14.914267] bus: 'pci': add driver sata_sil24
[   14.920239] initcall sil24_init+0x0/0x42 returned 0 after 9765 usecs
[   14.926582] calling  svia_init+0x0/0x42 @ 1
[   14.930007] bus: 'pci': add driver sata_via
[   14.934454] initcall svia_init+0x0/0x42 returned 0 after 0 usecs
[   14.940004] calling  sis_init+0x0/0x42 @ 1
[   14.944097] bus: 'pci': add driver sata_sis
[   14.950230] initcall sis_init+0x0/0x42 returned 0 after 9765 usecs
[   14.956407] calling  pdc_sata_init+0x0/0x42 @ 1
[   14.960005] bus: 'pci': add driver sata_sx4
[   14.964447] initcall pdc_sata_init+0x0/0x42 returned 0 after 0 usecs
[   14.970004] calling  nv_init+0x0/0x42 @ 1
[   14.974010] bus: 'pci': add driver sata_nv
[   14.980309] initcall nv_init+0x0/0x42 returned 0 after 9765 usecs
[   14.986399] calling  uli_init+0x0/0x42 @ 1
[   14.990005] bus: 'pci': add driver sata_uli
[   14.994411] initcall uli_init+0x0/0x42 returned 0 after 0 usecs
[   15.000005] calling  mv_init+0x0/0x6e @ 1
[   15.004009] bus: 'pci': add driver sata_mv
[   15.008395] bus: 'platform': add driver sata_mv
[   15.010225] initcall mv_init+0x0/0x6e returned 0 after 9765 usecs
[   15.020005] calling  amd_init+0x0/0x42 @ 1
[   15.024096] bus: 'pci': add driver pata_amd
[   15.028292] bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
[   15.030005] bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
[   15.040115] pata_amd 0000:00:06.0: version 0.4.1
[   15.044825] pata_amd 0000:00:06.0: setting latency timer to 64
[   15.050275] scsi0 : pata_amd
[   15.054088] device: 'host0': device_add
[   15.060017] device: 'host0': device_add
[   15.064261] scsi1 : pata_amd
[   15.070009] device: 'host1': device_add
[   15.073859] device: 'host1': device_add
[   15.077990] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   15.080004] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   15.280546] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[   15.286804] ata1.00: 488397168 sectors, multi 1: LBA48 
[   15.290044] ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[   15.370475] ata1.00: configured for UDMA/100
[   15.384754] async_waiting @ 1360
[   15.387981] async_continuing @ 1360 after 0 usec
[   15.390285] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[   15.400009] device: 'target0:0:0': device_add
[   15.404376] device: '0:0:0:0': device_add
[   15.408436] bus: 'scsi': add device 0:0:0:0
[   15.410267] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[   15.420019] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[   15.427161] device: '0:0:0:0': device_add
[   15.430402] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[   15.440228] sd 0:0:0:0: [sda] Write Protect is off
[   15.445012] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.450106] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.459143] device: 'sda': device_add
[   15.460589]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   15.545548] device: 'sda1': device_add
[   15.549369] device: 'sda2': device_add
[   15.550125] device: 'sda3': device_add
[   15.553952] device: 'sda5': device_add
[   15.560067] device: 'sda6': device_add
[   15.563871] device: 'sda7': device_add
[   15.567682] device: 'sda8': device_add
[   15.570083] device: 'sda9': device_add
[   15.573891] device: 'sda10': device_add
[   15.582455] device: '8:0': device_add
[   15.586805] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.590029] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[   15.596113] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[   15.600009] device: '0:0:0:0': device_add
[   15.604334] device: 'sg0': device_add
[   15.610381] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.615766] device: '0:0:0:0': device_add
[   15.620310] async_waiting @ 1360
[   15.623540] async_continuing @ 1360 after 0 usec
[   15.800299] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[   15.806323] ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[   15.860251] ata2.01: configured for UDMA/33
[   15.875113] async_waiting @ 1360
[   15.878342] async_continuing @ 1360 after 0 usec
[   15.880431] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   15.890018] device: 'target1:0:1': device_add
[   15.894387] device: '1:0:1:0': device_add
[   15.898442] bus: 'scsi': add device 1:0:1:0
[   15.911921] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
[   15.919566] bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
[   15.920033] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sr
[   15.930005] bus: 'scsi': really_probe: probing driver sr with device 1:0:1:0
[   15.944171] sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
[   15.950089] Uniform CD-ROM driver Revision: 3.20
[   15.954799] device: 'sr0': device_add
[   15.970664] device: '11:0': device_add
[   15.974976] sr 1:0:1:0: Attached scsi CD-ROM sr0
[   15.979590] driver: '1:0:1:0': driver_bound: bound to device 'sr'
[   15.980030] bus: 'scsi': really_probe: bound device 1:0:1:0 to driver sr
[   15.990008] device: '1:0:1:0': device_add
[   15.994476] device: 'sg1': device_add
[   16.011019] sr 1:0:1:0: Attached scsi generic sg1 type 5
[   16.016337] device: '1:0:1:0': device_add
[   16.032231] driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
[   16.039304] bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
[   16.051101] initcall amd_init+0x0/0x42 returned 0 after 1005859 usecs
[   16.057540] calling  artop_init+0x0/0x42 @ 1
[   16.060030] bus: 'pci': add driver pata_artop
[   16.074802] initcall artop_init+0x0/0x42 returned 0 after 9765 usecs
[   16.080011] calling  cmd640_init+0x0/0x42 @ 1
[   16.084365] bus: 'pci': add driver pata_cmd640
[   16.092518] initcall cmd640_init+0x0/0x42 returned 0 after 9765 usecs
[   16.098955] calling  cmd64x_init+0x0/0x42 @ 1
[   16.100009] bus: 'pci': add driver pata_cmd64x
[   16.114910] initcall cmd64x_init+0x0/0x42 returned 0 after 9765 usecs
[   16.120008] calling  cs5520_init+0x0/0x42 @ 1
[   16.124366] bus: 'pci': add driver pata_cs5520
[   16.141108] initcall cs5520_init+0x0/0x42 returned 0 after 19531 usecs
[   16.147629] calling  cy82c693_init+0x0/0x42 @ 1
[   16.150030] bus: 'pci': add driver pata_cypress
[   16.165147] initcall cy82c693_init+0x0/0x42 returned 0 after 9765 usecs
[   16.170007] calling  hpt36x_init+0x0/0x42 @ 1
[   16.174365] bus: 'pci': add driver pata_hpt366
[   16.190432] initcall hpt36x_init+0x0/0x42 returned 0 after 19531 usecs
[   16.196952] calling  hpt37x_init+0x0/0x42 @ 1
[   16.200007] bus: 'pci': add driver pata_hpt37x
[   16.215004] initcall hpt37x_init+0x0/0x42 returned 0 after 9765 usecs
[   16.220007] calling  hpt3x3_init+0x0/0x42 @ 1
[   16.224365] bus: 'pci': add driver pata_hpt3x3
[   16.242184] initcall hpt3x3_init+0x0/0x42 returned 0 after 19531 usecs
[   16.248706] calling  it8213_init+0x0/0x42 @ 1
[   16.250013] bus: 'pci': add driver pata_it8213
[   16.264853] initcall it8213_init+0x0/0x42 returned 0 after 9765 usecs
[   16.270010] calling  jmicron_init+0x0/0x42 @ 1
[   16.274453] bus: 'pci': add driver pata_jmicron
[   16.291973] initcall jmicron_init+0x0/0x42 returned 0 after 19531 usecs
[   16.298583] calling  ninja32_init+0x0/0x42 @ 1
[   16.300008] bus: 'pci': add driver pata_ninja32
[   16.314946] initcall ninja32_init+0x0/0x42 returned 0 after 9765 usecs
[   16.320012] calling  ns87410_init+0x0/0x42 @ 1
[   16.324451] bus: 'pci': add driver pata_ns87410
[   16.340961] initcall ns87410_init+0x0/0x42 returned 0 after 19531 usecs
[   16.347564] calling  ns87415_init+0x0/0x42 @ 1
[   16.350013] bus: 'pci': add driver pata_ns87415
[   16.364940] initcall ns87415_init+0x0/0x42 returned 0 after 9765 usecs
[   16.370008] calling  opti_init+0x0/0x42 @ 1
[   16.374194] bus: 'pci': add driver pata_opti
[   16.390368] initcall opti_init+0x0/0x42 returned 0 after 19531 usecs
[   16.396714] calling  optidma_init+0x0/0x42 @ 1
[   16.400009] bus: 'pci': add driver pata_optidma
[   16.415069] initcall optidma_init+0x0/0x42 returned 0 after 9765 usecs
[   16.420029] calling  marvell_init+0x0/0x42 @ 1
[   16.424471] bus: 'pci': add driver pata_marvell
[   16.441598] initcall marvell_init+0x0/0x42 returned 0 after 19531 usecs
[   16.448200] calling  mpiix_init+0x0/0x42 @ 1
[   16.450008] bus: 'pci': add driver pata_mpiix
[   16.464783] initcall mpiix_init+0x0/0x42 returned 0 after 9765 usecs
[   16.470007] calling  oldpiix_init+0x0/0x42 @ 1
[   16.474451] bus: 'pci': add driver pata_oldpiix
[   16.490954] initcall oldpiix_init+0x0/0x42 returned 0 after 19531 usecs
[   16.497558] calling  pdc2027x_init+0x0/0x42 @ 1
[   16.500008] bus: 'pci': add driver pata_pdc2027x
[   16.515026] initcall pdc2027x_init+0x0/0x42 returned 0 after 9765 usecs
[   16.520029] calling  pdc202xx_init+0x0/0x42 @ 1
[   16.524558] bus: 'pci': add driver pata_pdc202xx_old
[   16.540625] initcall pdc202xx_init+0x0/0x42 returned 0 after 19531 usecs
[   16.547322] calling  sc1200_init+0x0/0x42 @ 1
[   16.550012] bus: 'pci': add driver sc1200
[   16.564438] initcall sc1200_init+0x0/0x42 returned 0 after 9765 usecs
[   16.570013] calling  serverworks_init+0x0/0x42 @ 1
[   16.574799] bus: 'pci': add driver pata_serverworks
[   16.590974] initcall serverworks_init+0x0/0x42 returned 0 after 19531 usecs
[   16.597924] calling  via_init+0x0/0x42 @ 1
[   16.600009] bus: 'pci': add driver pata_via
[   16.614600] initcall via_init+0x0/0x42 returned 0 after 9765 usecs
[   16.620029] calling  sl82c105_init+0x0/0x42 @ 1
[   16.624556] bus: 'pci': add driver pata_sl82c105
[   16.641839] initcall sl82c105_init+0x0/0x42 returned 0 after 19531 usecs
[   16.648529] calling  sis_init+0x0/0x42 @ 1
[   16.650009] bus: 'pci': add driver pata_sis
[   16.664603] initcall sis_init+0x0/0x42 returned 0 after 9765 usecs
[   16.670008] calling  triflex_init+0x0/0x42 @ 1
[   16.674452] bus: 'pci': add driver pata_triflex
[   16.689405] initcall triflex_init+0x0/0x42 returned 0 after 9765 usecs
[   16.690012] calling  sch_init+0x0/0x42 @ 1
[   16.700005] bus: 'pci': add driver pata_sch
[   16.714591] initcall sch_init+0x0/0x42 returned 0 after 9765 usecs
[   16.720012] calling  pata_platform_init+0x0/0x39 @ 1
[   16.724971] bus: 'platform': add driver pata_platform
[   16.741084] initcall pata_platform_init+0x0/0x39 returned 0 after 19531 usecs
[   16.748211] calling  e1000_init_module+0x0/0xab @ 1
[   16.750006] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[   16.756442] Copyright (c) 1999-2006 Intel Corporation.
[   16.760005] bus: 'pci': add driver e1000
[   16.774336] initcall e1000_init_module+0x0/0xab returned 0 after 19531 usecs
[   16.780008] calling  e1000_init_module+0x0/0x8f @ 1
[   16.784883] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   16.790003] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   16.795831] bus: 'pci': add driver e1000e
[   16.810833] initcall e1000_init_module+0x0/0x8f returned 0 after 29296 usecs
[   16.817873] calling  igb_init_module+0x0/0x7b @ 1
[   16.820009] Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
[   16.826701] Copyright (c) 2007-2009 Intel Corporation.
[   16.830009] bus: 'pci': add driver igb
[   16.844353] initcall igb_init_module+0x0/0x7b returned 0 after 19531 usecs
[   16.850006] calling  ixgbe_init_module+0x0/0x7f @ 1
[   16.854881] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.34-k2
[   16.860003] ixgbe: Copyright (c) 1999-2009 Intel Corporation.
[   16.865743] bus: 'pci': add driver ixgbe
[   16.883031] initcall ixgbe_init_module+0x0/0x7f returned 0 after 29296 usecs
[   16.890011] calling  ixgb_init_module+0x0/0x71 @ 1
[   16.894796] Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   16.900002] Copyright (c) 1999-2008 Intel Corporation.
[   16.905138] bus: 'pci': add driver ixgb
[   16.921260] initcall ixgb_init_module+0x0/0x71 returned 0 after 29296 usecs
[   16.928214] calling  t1_init_module+0x0/0x42 @ 1
[   16.930009] bus: 'pci': add driver cxgb
[   16.944492] initcall t1_init_module+0x0/0x42 returned 0 after 9765 usecs
[   16.950006] calling  cxgb3_init_module+0x0/0x47 @ 1
[   16.954886] bus: 'pci': add driver cxgb3
[   16.970473] initcall cxgb3_init_module+0x0/0x47 returned 0 after 19531 usecs
[   16.977510] calling  vcan_init_module+0x0/0x5c @ 1
[   16.980008] vcan: Virtual CAN interface driver
[   16.984454] initcall vcan_init_module+0x0/0x5c returned 0 after 0 usecs
[   16.990004] calling  can_dev_init+0x0/0x55 @ 1
[   16.994443] CAN device driver interface
[   17.000004] initcall can_dev_init+0x0/0x55 returned 0 after 9765 usecs
[   17.006522] calling  atl1_init_module+0x0/0x42 @ 1
[   17.010027] bus: 'pci': add driver atl1
[   17.024333] initcall atl1_init_module+0x0/0x42 returned 0 after 9765 usecs
[   17.030013] calling  atl2_init_module+0x0/0x71 @ 1
[   17.034798] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   17.040009] Copyright (c) 2007 Atheros Corporation.
[   17.044884] bus: 'pci': add driver atl2
[   17.061098] initcall atl2_init_module+0x0/0x71 returned 0 after 29296 usecs
[   17.068049] calling  atl1e_init_module+0x0/0x42 @ 1
[   17.070005] bus: 'pci': add driver ATL1E
[   17.084518] initcall atl1e_init_module+0x0/0x42 returned 0 after 9765 usecs
[   17.090008] calling  bdx_module_init+0x0/0xb0 @ 1
[   17.094709] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[   17.100002] tehuti: Options: hw_csum 
[   17.103663] bus: 'pci': add driver tehuti
[   17.118811] initcall bdx_module_init+0x0/0xb0 returned 0 after 19531 usecs
[   17.120004] calling  enic_init_module+0x0/0x5c @ 1
[   17.130005] enic: Cisco 10G Ethernet Driver, ver 1.0.0.933
[   17.135484] bus: 'pci': add driver enic
[   17.149900] initcall enic_init_module+0x0/0x5c returned 0 after 9765 usecs
[   17.150027] calling  plip_init+0x0/0x84 @ 1
[   17.160024] plip: parport0 has no IRQ. Using IRQ-less mode,which is fairly inefficient!
[   17.168031] device: 'plip0': device_add
[   17.182739] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[   17.188218] plip0: Parallel port at 0x378, not using IRQ.
[   17.190006] initcall plip_init+0x0/0x84 returned 0 after 29296 usecs
[   17.196348] calling  happy_meal_probe+0x0/0x42 @ 1
[   17.200006] bus: 'pci': add driver hme
[   17.214277] initcall happy_meal_probe+0x0/0x42 returned 0 after 9765 usecs
[   17.220008] calling  gem_init+0x0/0x42 @ 1
[   17.224104] bus: 'pci': add driver gem
[   17.238427] initcall gem_init+0x0/0x42 returned 0 after 9765 usecs
[   17.240009] calling  cas_init+0x0/0x61 @ 1
[   17.244106] bus: 'pci': add driver cassini
[   17.261348] initcall cas_init+0x0/0x61 returned 0 after 19531 usecs
[   17.267604] calling  vortex_init+0x0/0xd8 @ 1
[   17.270010] bus: 'pci': add driver 3c59x
[   17.284526] initcall vortex_init+0x0/0xd8 returned 0 after 9765 usecs
[   17.290026] calling  typhoon_init+0x0/0x42 @ 1
[   17.294470] bus: 'pci': add driver typhoon
[   17.309213] initcall typhoon_init+0x0/0x42 returned 0 after 9765 usecs
[   17.310004] calling  ne2k_pci_init+0x0/0x42 @ 1
[   17.320005] bus: 'pci': add driver ne2k-pci
[   17.334753] initcall ne2k_pci_init+0x0/0x42 returned 0 after 9765 usecs
[   17.340004] calling  pcnet32_init_module+0x0/0x154 @ 1
[   17.345135] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   17.350008] bus: 'pci': add driver pcnet32
[   17.364651] initcall pcnet32_init_module+0x0/0x154 returned 0 after 19531 usecs
[   17.370004] calling  e100_init_module+0x0/0x81 @ 1
[   17.374787] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   17.380006] e100: Copyright(c) 1999-2006 Intel Corporation
[   17.385485] bus: 'pci': add driver e100
[   17.401336] initcall e100_init_module+0x0/0x81 returned 0 after 29296 usecs
[   17.408290] calling  tlan_probe+0x0/0x108 @ 1
[   17.410006] ThunderLAN driver v1.15a
[   17.413577] bus: 'pci': add driver tlan
[   17.430938] TLAN: 0 devices installed, PCI: 0  EISA: 0
[   17.436101] bus: 'pci': remove driver tlan
[   17.451223] driver: 'tlan': driver_release
[   17.455321] initcall tlan_probe+0x0/0x108 returned -19 after 39062 usecs
[   17.460004] calling  smsc9420_init_module+0x0/0x64 @ 1
[   17.465137] bus: 'pci': add driver smsc9420
[   17.481487] initcall smsc9420_init_module+0x0/0x64 returned 0 after 19531 usecs
[   17.488791] calling  sis190_init_module+0x0/0x42 @ 1
[   17.490011] bus: 'pci': add driver sis190
[   17.504715] initcall sis190_init_module+0x0/0x42 returned 0 after 9765 usecs
[   17.510008] calling  r6040_init+0x0/0x42 @ 1
[   17.514278] bus: 'pci': add driver r6040
[   17.530686] initcall r6040_init+0x0/0x42 returned 0 after 19531 usecs
[   17.537117] calling  yellowfin_init+0x0/0x42 @ 1
[   17.540006] bus: 'pci': add driver yellowfin
[   17.555044] initcall yellowfin_init+0x0/0x42 returned 0 after 9765 usecs
[   17.560026] calling  acenic_init+0x0/0x42 @ 1
[   17.564384] bus: 'pci': add driver acenic
[   17.581320] initcall acenic_init+0x0/0x42 returned 0 after 19531 usecs
[   17.587843] calling  ns83820_init+0x0/0x4e @ 1
[   17.590003] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   17.596782] bus: 'pci': add driver ns83820
[   17.612402] initcall ns83820_init+0x0/0x4e returned 0 after 19531 usecs
[   17.619007] calling  fealnx_init+0x0/0x42 @ 1
[   17.620010] bus: 'pci': add driver fealnx
[   17.634614] initcall fealnx_init+0x0/0x42 returned 0 after 9765 usecs
[   17.640009] calling  tg3_init+0x0/0x42 @ 1
[   17.644106] bus: 'pci': add driver tg3
[   17.658455] initcall tg3_init+0x0/0x42 returned 0 after 9765 usecs
[   17.660005] calling  bnx2x_init+0x0/0xa8 @ 1
[   17.664387] bus: 'pci': add driver bnx2x
[   17.670272] initcall bnx2x_init+0x0/0xa8 returned 0 after 9765 usecs
[   17.676616] calling  skge_init_module+0x0/0x42 @ 1
[   17.680029] bus: 'pci': add driver skge
[   17.694662] initcall skge_init_module+0x0/0x42 returned 0 after 9765 usecs
[   17.700022] calling  sky2_init_module+0x0/0x4e @ 1
[   17.704805] sky2 driver version 1.23
[   17.708383] bus: 'pci': add driver sky2
[   17.720697] initcall sky2_init_module+0x0/0x4e returned 0 after 19531 usecs
[   17.727652] calling  ks8851_init+0x0/0x39 @ 1
[   17.730010] bus: 'spi': add driver ks8851
[   17.744456] initcall ks8851_init+0x0/0x39 returned 0 after 9765 usecs
[   17.750026] calling  rhine_init+0x0/0x5e @ 1
[   17.754296] bus: 'pci': add driver via-rhine
[   17.769167] initcall rhine_init+0x0/0x5e returned 0 after 9765 usecs
[   17.770005] calling  velocity_init_module+0x0/0x42 @ 1
[   17.780005] bus: 'pci': add driver via-velocity
[   17.795092] initcall velocity_init_module+0x0/0x42 returned 0 after 9765 usecs
[   17.800004] calling  starfire_init+0x0/0x42 @ 1
[   17.804531] bus: 'pci': add driver starfire
[   17.820968] initcall starfire_init+0x0/0x42 returned 0 after 19531 usecs
[   17.827663] calling  marvell_init+0x0/0x84 @ 1
[   17.830029] bus: 'mdio_bus': add driver Marvell 88E1101
[   17.845786] bus: 'mdio_bus': add driver Marvell 88E1112
[   17.861869] bus: 'mdio_bus': add driver Marvell 88E1111
[   17.867310] bus: 'mdio_bus': add driver Marvell 88E1118
[   17.881776] bus: 'mdio_bus': add driver Marvell 88E1121R
[   17.887311] bus: 'mdio_bus': add driver Marvell 88E1145
[   17.900786] bus: 'mdio_bus': add driver Marvell 88E1240
[   17.906235] initcall marvell_init+0x0/0x84 returned 0 after 68359 usecs
[   17.910024] calling  davicom_init+0x0/0x83 @ 1
[   17.914466] bus: 'mdio_bus': add driver Davicom DM9161E
[   17.930745] bus: 'mdio_bus': add driver Davicom DM9161A
[   17.936187] bus: 'mdio_bus': add driver Davicom DM9131
[   17.951200] initcall davicom_init+0x0/0x83 returned 0 after 39062 usecs
[   17.957808] calling  cicada_init+0x0/0x65 @ 1
[   17.960025] bus: 'mdio_bus': add driver Cicada Cis8204
[   17.975550] bus: 'mdio_bus': add driver Cicada Cis8201
[   17.990396] initcall cicada_init+0x0/0x65 returned 0 after 29296 usecs
[   17.996914] calling  qs6612_init+0x0/0x39 @ 1
[   18.000004] bus: 'mdio_bus': add driver QS6612
[   18.014841] initcall qs6612_init+0x0/0x39 returned 0 after 9765 usecs
[   18.020005] calling  smsc_init+0x0/0xbf @ 1
[   18.024183] bus: 'mdio_bus': add driver SMSC LAN83C185
[   18.041405] bus: 'mdio_bus': add driver SMSC LAN8187
[   18.046626] bus: 'mdio_bus': add driver SMSC LAN8700
[   18.060595] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[   18.066896] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[   18.081363] initcall smsc_init+0x0/0xbf returned 0 after 58593 usecs
[   18.087711] calling  vsc82xx_init+0x0/0x65 @ 1
[   18.090021] bus: 'mdio_bus': add driver Vitesse VSC8244
[   18.105657] bus: 'mdio_bus': add driver Vitesse VSC8221
[   18.120475] initcall vsc82xx_init+0x0/0x65 returned 0 after 29296 usecs
[   18.127085] calling  broadcom_init+0x0/0x125 @ 1
[   18.130010] bus: 'mdio_bus': add driver Broadcom BCM5411
[   18.145697] bus: 'mdio_bus': add driver Broadcom BCM5421
[   18.160543] bus: 'mdio_bus': add driver Broadcom BCM5461
[   18.166075] bus: 'mdio_bus': add driver Broadcom BCM5464
[   18.181715] bus: 'mdio_bus': add driver Broadcom BCM5481
[   18.187258] bus: 'mdio_bus': add driver Broadcom BCM5482
[   18.201082] bus: 'mdio_bus': add driver Broadcom BCM50610
[   18.206698] bus: 'mdio_bus': add driver Broadcom BCM57780
[   18.221151] initcall broadcom_init+0x0/0x125 returned 0 after 87890 usecs
[   18.227927] calling  ip175c_init+0x0/0x39 @ 1
[   18.230023] bus: 'mdio_bus': add driver ICPlus IP175C
[   18.245650] initcall ip175c_init+0x0/0x39 returned 0 after 9765 usecs
[   18.250026] calling  et1011c_init+0x0/0x39 @ 1
[   18.254468] bus: 'mdio_bus': add driver ET1011C
[   18.271408] initcall et1011c_init+0x0/0x39 returned 0 after 19531 usecs
[   18.278019] calling  fixed_mdio_bus_init+0x0/0xf6 @ 1
[   18.280009] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   18.290005] device: 'Fixed MDIO bus.0': device_add
[   18.294798] bus: 'platform': add device Fixed MDIO bus.0
[   18.311411] device: '0': device_add
[   18.315178] Fixed MDIO Bus: probed
[   18.318580] initcall fixed_mdio_bus_init+0x0/0xf6 returned 0 after 29296 usecs
[   18.320032] calling  ns_init+0x0/0x39 @ 1
[   18.324043] bus: 'mdio_bus': add driver NatSemi DP83865
[   18.341561] initcall ns_init+0x0/0x39 returned 0 after 19531 usecs
[   18.347733] calling  ste10Xp_init+0x0/0x49 @ 1
[   18.350023] bus: 'mdio_bus': add driver STe100p
[   18.364935] bus: 'mdio_bus': add driver STe101p
[   18.369677] initcall ste10Xp_init+0x0/0x49 returned 0 after 9765 usecs
[   18.370027] calling  sundance_init+0x0/0x42 @ 1
[   18.380011] bus: 'pci': add driver sundance
[   18.394811] initcall sundance_init+0x0/0x42 returned 0 after 9765 usecs
[   18.400022] calling  hamachi_init+0x0/0x42 @ 1
[   18.404462] bus: 'pci': add driver hamachi
[   18.410236] initcall hamachi_init+0x0/0x42 returned 0 after 9765 usecs
[   18.416754] calling  net_olddevs_init+0x0/0xc7 @ 1
[   18.420040] D-Link DE-620 pocket adapter io 0x378, which is busy.
[   18.426159] initcall net_olddevs_init+0x0/0xc7 returned 0 after 0 usecs
[   18.430011] calling  hp100_module_init+0x0/0x42 @ 1
[   18.434888] bus: 'pci': add driver hp100
[   18.450854] initcall hp100_module_init+0x0/0x42 returned 0 after 19531 usecs
[   18.457894] calling  b44_init+0x0/0x89 @ 1
[   18.460030] bus: 'pci': add driver b44
[   18.474362] bus: 'ssb': add driver b44
[   18.478337] initcall b44_init+0x0/0x89 returned 0 after 9765 usecs
[   18.480027] calling  init_nic+0x0/0x42 @ 1
[   18.484123] bus: 'pci': add driver forcedeth
[   18.490024] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
[   18.500003] bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
[   18.508124] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[   18.510134] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
[   18.520009] forcedeth 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[   18.530008] forcedeth 0000:00:0a.0: setting latency timer to 64
[   18.535986] nv_probe: set workaround bit for reversed mac addr
[   19.070247] device: 'eth0': device_add
[   19.075056] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   19.080031] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[   19.086409] driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
[   19.090071] bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
[   19.110984] initcall init_nic+0x0/0x42 returned 0 after 615234 usecs
[   19.117330] calling  ql3xxx_init_module+0x0/0x42 @ 1
[   19.120037] bus: 'pci': add driver qla3xxx
[   19.134597] initcall ql3xxx_init_module+0x0/0x42 returned 0 after 9765 usecs
[   19.140022] calling  qlge_init_module+0x0/0x42 @ 1
[   19.144809] bus: 'pci': add driver qlge
[   19.162653] initcall qlge_init_module+0x0/0x42 returned 0 after 19531 usecs
[   19.169606] calling  ppp_init+0x0/0x104 @ 1
[   19.170002] PPP generic driver version 2.4.2
[   19.174346] device class 'ppp': registering
[   19.190604] device: 'ppp': device_add
[   19.194545] initcall ppp_init+0x0/0x104 returned 0 after 19531 usecs
[   19.200028] calling  ppp_sync_init+0x0/0x5c @ 1
[   19.204555] initcall ppp_sync_init+0x0/0x5c returned 0 after 0 usecs
[   19.210008] calling  deflate_init+0x0/0x61 @ 1
[   19.214463] PPP Deflate Compression module registered
[   19.220006] initcall deflate_init+0x0/0x61 returned 0 after 9765 usecs
[   19.226521] calling  bsdcomp_init+0x0/0x55 @ 1
[   19.230006] PPP BSD Compression module registered
[   19.234704] initcall bsdcomp_init+0x0/0x55 returned 0 after 0 usecs
[   19.240020] calling  ppp_mppe_init+0x0/0x10d @ 1
[   19.255352] PPP MPPE Compression module registered
[   19.260025] initcall ppp_mppe_init+0x0/0x10d returned 0 after 19531 usecs
[   19.266808] calling  pppox_init+0x0/0x39 @ 1
[   19.270003] NET: Registered protocol family 24
[   19.274443] initcall pppox_init+0x0/0x39 returned 0 after 0 usecs
[   19.280004] calling  pppoe_init+0x0/0xaf @ 1
[   19.284295] initcall pppoe_init+0x0/0xaf returned 0 after 0 usecs
[   19.290004] calling  pppol2tp_init+0x0/0xa8 @ 1
[   19.294540] PPPoL2TP kernel driver, V1.0
[   19.300020] initcall pppol2tp_init+0x0/0xa8 returned 0 after 9765 usecs
[   19.306624] calling  slip_init+0x0/0xe6 @ 1
[   19.310003] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[   19.320002] CSLIP: code copyright 1989 Regents of the University of California.
[   19.327299] SLIP linefill/keepalive option.
[   19.330057] initcall slip_init+0x0/0xe6 returned 0 after 19531 usecs
[   19.336401] calling  macvlan_init_module+0x0/0x79 @ 1
[   19.340022] initcall macvlan_init_module+0x0/0x79 returned 0 after 0 usecs
[   19.350004] calling  de600_init+0x0/0x2f2 @ 1
[   19.354370] DE600: port 0x378 busy
[   19.357776] initcall de600_init+0x0/0x2f2 returned -16 after 0 usecs
[   19.360004] initcall de600_init+0x0/0x2f2 returned with error code -16 
[   19.370008] calling  cp_init+0x0/0x42 @ 1
[   19.374025] bus: 'pci': add driver 8139cp
[   19.378069] bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139cp
[   19.380018] bus: 'pci': really_probe: probing driver 8139cp with device 0000:05:07.0
[   19.390120] <6>8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   19.400026] 8139cp 0000:05:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[   19.410302] initcall cp_init+0x0/0x42 returned 0 after 39062 usecs
[   19.416479] calling  rtl8139_init_module+0x0/0x42 @ 1
[   19.420028] bus: 'pci': add driver 8139too
[   19.424147] bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139too
[   19.430006] bus: 'pci': really_probe: probing driver 8139too with device 0000:05:07.0
[   19.440102] 8139too Fast Ethernet driver 0.9.28
[   19.444662] 8139too 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[   19.450412] device: 'eth1': device_add
[   19.460574] eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 11
[   19.467124] driver: '0000:05:07.0': driver_bound: bound to device '8139too'
[   19.470071] bus: 'pci': really_probe: bound device 0000:05:07.0 to driver 8139too
[   19.491790] initcall rtl8139_init_module+0x0/0x42 returned 0 after 68359 usecs
[   19.499002] calling  atp_init_module+0x0/0xbf @ 1
[   19.500030] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
[   19.510035] initcall atp_init_module+0x0/0xbf returned -19 after 9765 usecs
[   19.516988] calling  sc92031_init+0x0/0x42 @ 1
[   19.520009] bus: 'pci': add driver sc92031
[   19.534723] initcall sc92031_init+0x0/0x42 returned 0 after 9765 usecs
[   19.540022] calling  eql_init_module+0x0/0x89 @ 1
[   19.544718] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   19.550021] device: 'eql': device_add
[   19.564971] initcall eql_init_module+0x0/0x89 returned 0 after 19531 usecs
[   19.570004] calling  tun_init+0x0/0xb7 @ 1
[   19.574094] tun: Universal TUN/TAP device driver, 1.6
[   19.580003] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   19.586182] device: 'tun': device_add
[   19.601596] initcall tun_init+0x0/0xb7 returned 0 after 29296 usecs
[   19.607855] calling  veth_init+0x0/0x39 @ 1
[   19.610008] initcall veth_init+0x0/0x39 returned 0 after 0 usecs
[   19.616011] calling  rio_init+0x0/0x42 @ 1
[   19.620007] bus: 'pci': add driver dl2k
[   19.634361] initcall rio_init+0x0/0x42 returned 0 after 9765 usecs
[   19.640005] calling  rtl8169_init_module+0x0/0x42 @ 1
[   19.645051] bus: 'pci': add driver r8169
[   19.659473] initcall rtl8169_init_module+0x0/0x42 returned 0 after 9765 usecs
[   19.660004] calling  amd8111e_init+0x0/0x42 @ 1
[   19.670006] bus: 'pci': add driver amd8111e
[   19.684813] initcall amd8111e_init+0x0/0x42 returned 0 after 9765 usecs
[   19.690004] calling  myri10ge_init_module+0x0/0x99 @ 1
[   19.695135] myri10ge: Version 1.5.0-1.418
[   19.700006] bus: 'pci': add driver myri10ge
[   19.714774] initcall myri10ge_init_module+0x0/0x99 returned 0 after 19531 usecs
[   19.720010] calling  mlx4_init+0x0/0xcb @ 1
[   19.725249] bus: 'pci': add driver mlx4_core
[   19.742084] initcall mlx4_init+0x0/0xcb returned 0 after 19531 usecs
[   19.748434] calling  mlx4_en_init+0x0/0x39 @ 1
[   19.750045] initcall mlx4_en_init+0x0/0x39 returned 0 after 0 usecs
[   19.756304] calling  enc28j60_init+0x0/0x4a @ 1
[   19.760005] bus: 'spi': add driver enc28j60
[   19.774953] initcall enc28j60_init+0x0/0x4a returned 0 after 9765 usecs
[   19.780004] calling  ethoc_init+0x0/0x39 @ 1
[   19.784270] bus: 'platform': add driver ethoc
[   19.800902] initcall ethoc_init+0x0/0x39 returned 0 after 19531 usecs
[   19.807333] calling  dnet_init+0x0/0x39 @ 1
[   19.810004] bus: 'platform': add driver dnet
[   19.824913] initcall dnet_init+0x0/0x39 returned 0 after 9765 usecs
[   19.830010] calling  hdlc_module_init+0x0/0x66 @ 1
[   19.834795] HDLC support module revision 1.22
[   19.840009] initcall hdlc_module_init+0x0/0x66 returned 0 after 9765 usecs
[   19.846874] calling  mod_init+0x0/0x3b @ 1
[   19.850005] initcall mod_init+0x0/0x3b returned 0 after 0 usecs
[   19.855916] calling  mod_init+0x0/0x3b @ 1
[   19.860005] initcall mod_init+0x0/0x3b returned 0 after 0 usecs
[   19.865914] calling  mod_init+0x0/0x3b @ 1
[   19.870027] initcall mod_init+0x0/0x3b returned 0 after 0 usecs
[   19.875941] calling  fst_init+0x0/0x76 @ 1
[   19.880008] bus: 'pci': add driver fst
[   19.894429] initcall fst_init+0x0/0x76 returned 0 after 9765 usecs
[   19.900005] calling  pci200_init_module+0x0/0x69 @ 1
[   19.904970] bus: 'pci': add driver PCI200SYN
[   19.921761] initcall pci200_init_module+0x0/0x69 returned 0 after 19531 usecs
[   19.928890] calling  pc300_init_module+0x0/0x8c @ 1
[   19.930014] bus: 'pci': add driver PC300
[   19.944445] initcall pc300_init_module+0x0/0x8c returned 0 after 9765 usecs
[   19.950008] calling  arcnet_init+0x0/0x84 @ 1
[   19.954364] arcnet loaded.
[   19.957074] initcall arcnet_init+0x0/0x84 returned 0 after 0 usecs
[   19.960003] calling  arcnet_rfc1201_init+0x0/0x98 @ 1
[   19.965047] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[   19.970003] initcall arcnet_rfc1201_init+0x0/0x98 returned 0 after 9765 usecs
[   19.980003] calling  arcnet_raw_init+0x0/0x80 @ 1
[   19.984700] arcnet: raw mode (`r') encapsulation support loaded.
[   19.990026] initcall arcnet_raw_init+0x0/0x80 returned 0 after 9765 usecs
[   20.000003] calling  com90io_init+0x0/0x4d4 @ 1
[   20.004567] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   20.010002] E-mail me if you actually test this driver, please!
[   20.015913]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   20.020023] initcall com90io_init+0x0/0x4d4 returned -19 after 19531 usecs
[   20.030021] calling  arc_rimi_init+0x0/0x4f2 @ 1
[   20.034666] arcnet: RIM I (entirely mem-mapped) support
[   20.040011] E-mail me if you actually test the RIM I driver, please!
[   20.050003]  arc%d: Given: node 00h, shmem 0h, irq 0
[   20.054962]  arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
[   20.060022] initcall arc_rimi_init+0x0/0x4f2 returned -5 after 29296 usecs
[   20.066885] initcall arc_rimi_init+0x0/0x4f2 returned with error code -5 
[   20.070019] calling  com20020pci_init+0x0/0x57 @ 1
[   20.080002] arcnet: COM20020 PCI support
[   20.083925] bus: 'pci': add driver com20020
[   20.098694] initcall com20020pci_init+0x0/0x57 returned 0 after 9765 usecs
[   20.100009] calling  catc_init+0x0/0x5e @ 1
[   20.104192] bus: 'usb': add driver catc
[   20.121196] usbcore: registered new interface driver catc
[   20.126594] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   20.130006] initcall catc_init+0x0/0x5e returned 0 after 29296 usecs
[   20.136356] calling  kaweth_init+0x0/0x42 @ 1
[   20.140003] bus: 'usb': add driver kaweth
[   20.154771] usbcore: registered new interface driver kaweth
[   20.160008] initcall kaweth_init+0x0/0x42 returned 0 after 19531 usecs
[   20.166530] calling  pegasus_init+0x0/0x18d @ 1
[   20.170003] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   20.177474] bus: 'usb': add driver pegasus
[   20.191608] usbcore: registered new interface driver pegasus
[   20.197272] initcall pegasus_init+0x0/0x18d returned 0 after 19531 usecs
[   20.200004] calling  usb_rtl8150_init+0x0/0x4e @ 1
[   20.204787] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[   20.210003] bus: 'usb': add driver rtl8150
[   20.224668] usbcore: registered new interface driver rtl8150
[   20.230010] initcall usb_rtl8150_init+0x0/0x4e returned 0 after 29296 usecs
[   20.236961] calling  hso_init+0x0/0x1ce @ 1
[   20.240003] hso: drivers/net/usb/hso.c: 1.2 Option Wireless
[   20.245595] bus: 'usb': add driver hso
[   20.261984] usbcore: registered new interface driver hso
[   20.267296] initcall hso_init+0x0/0x1ce returned 0 after 19531 usecs
[   20.270004] calling  asix_init+0x0/0x42 @ 1
[   20.274182] bus: 'usb': add driver asix
[   20.290989] usbcore: registered new interface driver asix
[   20.296391] initcall asix_init+0x0/0x42 returned 0 after 19531 usecs
[   20.300003] calling  cdc_init+0x0/0x42 @ 1
[   20.304097] bus: 'usb': add driver cdc_ether
[   20.322061] usbcore: registered new interface driver cdc_ether
[   20.327893] initcall cdc_init+0x0/0x42 returned 0 after 19531 usecs
[   20.330006] calling  eem_init+0x0/0x42 @ 1
[   20.334097] bus: 'usb': add driver cdc_eem
[   20.352334] usbcore: registered new interface driver cdc_eem
[   20.357999] initcall eem_init+0x0/0x42 returned 0 after 19531 usecs
[   20.360004] calling  dm9601_init+0x0/0x42 @ 1
[   20.364354] bus: 'usb': add driver dm9601
[   20.381143] usbcore: registered new interface driver dm9601
[   20.386713] initcall dm9601_init+0x0/0x42 returned 0 after 19531 usecs
[   20.390004] calling  smsc95xx_init+0x0/0x42 @ 1
[   20.394529] bus: 'usb': add driver smsc95xx
[   20.410891] usbcore: registered new interface driver smsc95xx
[   20.416637] initcall smsc95xx_init+0x0/0x42 returned 0 after 19531 usecs
[   20.420004] calling  usbnet_init+0x0/0x42 @ 1
[   20.424354] bus: 'usb': add driver gl620a
[   20.441793] usbcore: registered new interface driver gl620a
[   20.447361] initcall usbnet_init+0x0/0x42 returned 0 after 19531 usecs
[   20.450004] calling  net1080_init+0x0/0x42 @ 1
[   20.454441] bus: 'usb': add driver net1080
[   20.471106] usbcore: registered new interface driver net1080
[   20.476767] initcall net1080_init+0x0/0x42 returned 0 after 19531 usecs
[   20.480004] calling  plusb_init+0x0/0x42 @ 1
[   20.484268] bus: 'usb': add driver plusb
[   20.501569] usbcore: registered new interface driver plusb
[   20.507056] initcall plusb_init+0x0/0x42 returned 0 after 19531 usecs
[   20.510004] calling  rndis_init+0x0/0x42 @ 1
[   20.514269] bus: 'usb': add driver rndis_host
[   20.530631] usbcore: registered new interface driver rndis_host
[   20.536549] initcall rndis_init+0x0/0x42 returned 0 after 19531 usecs
[   20.540004] calling  cdc_subset_init+0x0/0x42 @ 1
[   20.544701] bus: 'usb': add driver cdc_subset
[   20.560807] usbcore: registered new interface driver cdc_subset
[   20.566726] initcall cdc_subset_init+0x0/0x42 returned 0 after 19531 usecs
[   20.570004] calling  zaurus_init+0x0/0x42 @ 1
[   20.574354] bus: 'usb': add driver zaurus
[   20.591559] usbcore: registered new interface driver zaurus
[   20.597128] initcall zaurus_init+0x0/0x42 returned 0 after 19531 usecs
[   20.600004] calling  mcs7830_init+0x0/0x42 @ 1
[   20.604443] bus: 'usb': add driver MOSCHIP usb-ethernet driver
[   20.622315] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   20.629704] initcall mcs7830_init+0x0/0x42 returned 0 after 19531 usecs
[   20.630006] calling  usbnet_init+0x0/0x52 @ 1
[   20.640009] initcall usbnet_init+0x0/0x52 returned 0 after 0 usecs
[   20.646182] calling  int51x1_init+0x0/0x42 @ 1
[   20.650003] bus: 'usb': add driver int51x1
[   20.664849] usbcore: registered new interface driver int51x1
[   20.670011] initcall int51x1_init+0x0/0x42 returned 0 after 19531 usecs
[   20.676616] calling  usbpn_init+0x0/0x42 @ 1
[   20.680004] bus: 'usb': add driver cdc_phonet
[   20.695108] usbcore: registered new interface driver cdc_phonet
[   20.700008] initcall usbpn_init+0x0/0x42 returned 0 after 19531 usecs
[   20.706443] calling  ipw2100_init+0x0/0x93 @ 1
[   20.710003] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   20.716778] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   20.720009] bus: 'pci': add driver ipw2100
[   20.724349] initcall ipw2100_init+0x0/0x93 returned 0 after 9765 usecs
[   20.730028] calling  ipw_init+0x0/0xad @ 1
[   20.734120] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kdq
[   20.740002] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   20.750006] bus: 'pci': add driver ipw2200
[   20.754387] initcall ipw_init+0x0/0xad returned 0 after 19531 usecs
[   20.760005] calling  ieee80211_init+0x0/0x49 @ 1
[   20.764615] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   20.770002] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   20.780004] initcall ieee80211_init+0x0/0x49 returned 0 after 19531 usecs
[   20.786782] calling  strip_init_driver+0x0/0x8e @ 1
[   20.790002] STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
[   20.800042] initcall strip_init_driver+0x0/0x8e returned 0 after 9765 usecs
[   20.806996] calling  init_orinoco+0x0/0x42 @ 1
[   20.810003] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   20.820003] initcall init_orinoco+0x0/0x42 returned 0 after 9765 usecs
[   20.826521] calling  orinoco_pci_init+0x0/0x55 @ 1
[   20.830005] orinoco_pci 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au> & Jean Tourrilhes <jt@hpl.hp.com>)
[   20.840021] bus: 'pci': add driver orinoco_pci
[   20.850237] initcall orinoco_pci_init+0x0/0x55 returned 0 after 19531 usecs
[   20.857188] calling  airo_init_module+0x0/0x110 @ 1
[   20.860018] airo(): Probing for PCI adapters
[   20.864288] bus: 'pci': add driver airo
[   20.870251] airo(): Finished probing for PCI adapters
[   20.875301] initcall airo_init_module+0x0/0x110 returned 0 after 9765 usecs
[   20.880005] calling  prism54_module_init+0x0/0x5c @ 1
[   20.885047] Loaded prism54 driver, version 1.2
[   20.890006] bus: 'pci': add driver prism54
[   20.894333] initcall prism54_module_init+0x0/0x5c returned 0 after 9765 usecs
[   20.900005] calling  rtl8180_init+0x0/0x42 @ 1
[   20.904442] bus: 'pci': add driver rtl8180
[   20.910238] initcall rtl8180_init+0x0/0x42 returned 0 after 9765 usecs
[   20.916755] calling  rtl8187_init+0x0/0x42 @ 1
[   20.920006] bus: 'usb': add driver rtl8187
[   20.924321] usbcore: registered new interface driver rtl8187
[   20.930014] initcall rtl8187_init+0x0/0x42 returned 0 after 9765 usecs
[   20.936537] calling  rndis_wlan_init+0x0/0x42 @ 1
[   20.940004] bus: 'usb': add driver rndis_wlan
[   20.944565] usbcore: registered new interface driver rndis_wlan
[   20.950009] initcall rndis_wlan_init+0x0/0x42 returned 0 after 9765 usecs
[   20.960004] calling  zd1201_init+0x0/0x42 @ 1
[   20.964354] bus: 'usb': add driver zd1201
[   20.970265] usbcore: registered new interface driver zd1201
[   20.975832] initcall zd1201_init+0x0/0x42 returned 0 after 9765 usecs
[   20.980005] calling  lbs_init_module+0x0/0x5d @ 1
[   20.984728] initcall lbs_init_module+0x0/0x5d returned 0 after 0 usecs
[   20.990004] calling  if_spi_init_module+0x0/0x45 @ 1
[   20.994960] libertas_spi: Libertas SPI driver
[   21.000004] bus: 'spi': add driver libertas_spi
[   21.004735] initcall if_spi_init_module+0x0/0x45 returned 0 after 9765 usecs
[   21.010005] calling  lbtf_init_module+0x0/0x6c @ 1
[   21.014985] initcall lbtf_init_module+0x0/0x6c returned 0 after 0 usecs
[   21.020004] calling  if_usb_init_module+0x0/0x42 @ 1
[   21.030006] bus: 'usb': add driver lbtf_usb
[   21.034401] usbcore: registered new interface driver lbtf_usb
[   21.040015] initcall if_usb_init_module+0x0/0x42 returned 0 after 9765 usecs
[   21.047056] calling  adm8211_init+0x0/0x42 @ 1
[   21.050008] bus: 'pci': add driver adm8211
[   21.054346] initcall adm8211_init+0x0/0x42 returned 0 after 0 usecs
[   21.060005] calling  iwl3945_init+0x0/0x9a @ 1
[   21.064441] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kd
[   21.070002] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[   21.080008] bus: 'pci': add driver iwl3945
[   21.084341] initcall iwl3945_init+0x0/0x9a returned 0 after 19531 usecs
[   21.090005] calling  p54p_init+0x0/0x42 @ 1
[   21.094185] bus: 'pci': add driver p54pci
[   21.100251] initcall p54p_init+0x0/0x42 returned 0 after 9765 usecs
[   21.106511] calling  p54spi_init+0x0/0x57 @ 1
[   21.110005] bus: 'spi': add driver cx3110x
[   21.114324] initcall p54spi_init+0x0/0x57 returned 0 after 0 usecs
[   21.120004] calling  ar9170_init+0x0/0x42 @ 1
[   21.124356] bus: 'usb': add driver ar9170usb
[   21.130218] usbcore: registered new interface driver ar9170usb
[   21.136047] initcall ar9170_init+0x0/0x42 returned 0 after 9765 usecs
[   21.140005] calling  init_mac80211_hwsim+0x0/0x535 @ 1
[   21.145134] device class 'mac80211_hwsim': registering
[   21.150219] mac80211_hwsim: Initializing radio 0
[   21.154897] device: 'hwsim0': device_add
[   21.160325] device: 'phy0': device_add
[   21.164316] device: 'rfkill0': device_add
[   21.170892] device: 'wmaster0': device_add
[   21.176092] phy0: Selected rate control algorithm 'pid'
[   21.180181] device: 'wlan0': device_add
[   21.185107] phy0: hwaddr 02:00:00:00:00:00 registered
[   21.190034] mac80211_hwsim: Initializing radio 1
[   21.194744] device: 'hwsim1': device_add
[   21.200224] device: 'phy1': device_add
[   21.204227] device: 'rfkill1': device_add
[   21.210790] device: 'wmaster1': device_add
[   21.216080] phy1: Selected rate control algorithm 'pid'
[   21.220183] device: 'wlan1': device_add
[   21.225221] phy1: hwaddr 02:00:00:00:01:00 registered
[   21.230063] device: 'hwsim0': device_add
[   21.235088] initcall init_mac80211_hwsim+0x0/0x535 returned 0 after 87890 usecs
[   21.240005] calling  wl12xx_init+0x0/0x57 @ 1
[   21.244364] bus: 'spi': add driver wl12xx
[   21.250221] initcall wl12xx_init+0x0/0x57 returned 0 after 9765 usecs
[   21.256651] calling  iwm_sdio_init_module+0x0/0x39 @ 1
[   21.260005] bus: 'sdio': add driver iwm_sdio
[   21.264505] initcall iwm_sdio_init_module+0x0/0x39 returned 0 after 0 usecs
[   21.270004] calling  dmfe_init_module+0x0/0x10f @ 1
[   21.280002] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   21.286707] bus: 'pci': add driver dmfe
[   21.290272] initcall dmfe_init_module+0x0/0x10f returned 0 after 9765 usecs
[   21.297223] calling  de_init+0x0/0x42 @ 1
[   21.300029] bus: 'pci': add driver de2104x
[   21.304382] initcall de_init+0x0/0x42 returned 0 after 0 usecs
[   21.310004] calling  tulip_init+0x0/0x5a @ 1
[   21.314269] bus: 'pci': add driver tulip
[   21.320282] initcall tulip_init+0x0/0x5a returned 0 after 9765 usecs
[   21.326625] calling  de4x5_module_init+0x0/0x42 @ 1
[   21.330010] bus: 'pci': add driver de4x5
[   21.334176] initcall de4x5_module_init+0x0/0x42 returned 0 after 0 usecs
[   21.340004] calling  uli526x_init_module+0x0/0xc3 @ 1
[   21.345046] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   21.350006] bus: 'pci': add driver uli526x
[   21.354383] initcall uli526x_init_module+0x0/0xc3 returned 0 after 9765 usecs
[   21.360005] calling  mkiss_init_driver+0x0/0x68 @ 1
[   21.370002] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[   21.375049] initcall mkiss_init_driver+0x0/0x68 returned 0 after 0 usecs
[   21.380003] calling  sixpack_init_driver+0x0/0x68 @ 1
[   21.385047] AX.25: 6pack driver, Revision: 0.3.0
[   21.390004] initcall sixpack_init_driver+0x0/0x68 returned 0 after 9765 usecs
[   21.400025] calling  bpq_init_driver+0x0/0x8c @ 1
[   21.404750] AX.25: bpqether driver version 004
[   21.409188] initcall bpq_init_driver+0x0/0x8c returned 0 after 0 usecs
[   21.410004] calling  init_baycomserfdx+0x0/0x120 @ 1
[   21.420002] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   21.420005] baycom_ser_fdx: version 0.10 compiled 22:49:37 Aug  2 2009
[   21.430031] device: 'bcsf0': device_add
[   21.434998] device: 'bcsf1': device_add
[   21.441145] device: 'bcsf2': device_add
[   21.446202] device: 'bcsf3': device_add
[   21.451234] initcall init_baycomserfdx+0x0/0x120 returned 0 after 29296 usecs
[   21.460006] calling  hdlcdrv_init_driver+0x0/0x49 @ 1
[   21.465054] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   21.470002] hdlcdrv: version 0.8 compiled 22:49:38 Aug  2 2009
[   21.475830] initcall hdlcdrv_init_driver+0x0/0x49 returned 0 after 9765 usecs
[   21.480003] calling  usb_irda_init+0x0/0x65 @ 1
[   21.484532] bus: 'usb': add driver irda-usb
[   21.490264] usbcore: registered new interface driver irda-usb
[   21.496055] USB IrDA support registered
[   21.500028] initcall usb_irda_init+0x0/0x65 returned 0 after 19531 usecs
[   21.510004] calling  nsc_ircc_init+0x0/0x2a8 @ 1
[   21.514615] Platform driver 'nsc-ircc' needs updating - please use dev_pm_ops
[   21.520004] bus: 'platform': add driver nsc-ircc
[   21.524878] bus: 'platform': remove driver nsc-ircc
[   21.530235] driver: 'nsc-ircc': driver_release
[   21.534681] initcall nsc_ircc_init+0x0/0x2a8 returned -19 after 19531 usecs
[   21.540004] calling  smsc_ircc_init+0x0/0x4f9 @ 1
[   21.544702] Platform driver 'smsc-ircc2' needs updating - please use dev_pm_ops
[   21.550003] bus: 'platform': add driver smsc-ircc2
[   21.560427] bus: 'platform': remove driver smsc-ircc2
[   21.565713] driver: 'smsc-ircc2': driver_release
[   21.570032] initcall smsc_ircc_init+0x0/0x4f9 returned -19 after 29296 usecs
[   21.577076] calling  ali_ircc_init+0x0/0x812 @ 1
[   21.580003] Platform driver 'ali-ircc' needs updating - please use dev_pm_ops
[   21.587126] bus: 'platform': add driver ali-ircc
[   21.590265] bus: 'platform': remove driver ali-ircc
[   21.595340] driver: 'ali-ircc': driver_release
[   21.600010] initcall ali_ircc_init+0x0/0x812 returned -19 after 19531 usecs
[   21.610004] calling  via_ircc_init+0x0/0x82 @ 1
[   21.614541] bus: 'pci': add driver via-ircc
[   21.618972] initcall via_ircc_init+0x0/0x82 returned 0 after 0 usecs
[   21.620005] calling  kingsun_init+0x0/0x42 @ 1
[   21.630007] bus: 'usb': add driver kingsun-sir
[   21.634666] usbcore: registered new interface driver kingsun-sir
[   21.640009] initcall kingsun_init+0x0/0x42 returned 0 after 9765 usecs
[   21.646528] calling  ksdazzle_init+0x0/0x42 @ 1
[   21.650004] bus: 'usb': add driver ksdazzle-sir
[   21.654740] usbcore: registered new interface driver ksdazzle-sir
[   21.660009] initcall ksdazzle_init+0x0/0x42 returned 0 after 9765 usecs
[   21.666616] calling  ks959_init+0x0/0x42 @ 1
[   21.670004] bus: 'usb': add driver ks959-sir
[   21.674483] usbcore: registered new interface driver ks959-sir
[   21.680009] initcall ks959_init+0x0/0x42 returned 0 after 9765 usecs
[   21.690004] calling  init_netconsole+0x0/0x260 @ 1
[   21.694793] console [netcon0] enabled
[   21.698450] netconsole: network logging started
[   21.700004] initcall init_netconsole+0x0/0x260 returned 0 after 9765 usecs
[   21.710006] calling  niu_init+0x0/0x64 @ 1
[   21.714106] bus: 'pci': add driver niu
[   21.718092] initcall niu_init+0x0/0x64 returned 0 after 0 usecs
[   21.720027] calling  init+0x0/0x39 @ 1
[   21.723774] bus: 'virtio': add driver virtio_net
[   21.730233] initcall init+0x0/0x39 returned 0 after 9765 usecs
[   21.736062] calling  efx_init_module+0x0/0xfd @ 1
[   21.740003] Solarflare NET driver v2.3
[   21.744083] bus: 'pci': add driver sfc
[   21.750249] initcall efx_init_module+0x0/0xfd returned 0 after 9765 usecs
[   21.757032] calling  i2400m_driver_init+0x0/0x2d @ 1
[   21.760005] initcall i2400m_driver_init+0x0/0x2d returned 0 after 0 usecs
[   21.770004] calling  i2400ms_driver_init+0x0/0x39 @ 1
[   21.775049] bus: 'sdio': add driver i2400m_sdio
[   21.780219] initcall i2400ms_driver_init+0x0/0x39 returned 0 after 9765 usecs
[   21.787344] calling  i2o_iop_init+0x0/0x6c @ 1
[   21.790003] I2O subsystem v1.325
[   21.793227] i2o: max drivers = 8
[   21.796733] bus: 'i2o': registered
[   21.800255] bus: 'i2o': add driver exec-osm
[   21.804653] bus: 'pci': add driver PCI_I2O
[   21.810304] initcall i2o_iop_init+0x0/0x6c returned 0 after 19531 usecs
[   21.816908] calling  i2o_bus_init+0x0/0x68 @ 1
[   21.820003] I2O Bus Adapter OSM v1.317
[   21.823749] bus: 'i2o': add driver bus-osm
[   21.830169] initcall i2o_bus_init+0x0/0x68 returned 0 after 9765 usecs
[   21.836688] calling  i2o_scsi_init+0x0/0x68 @ 1
[   21.840003] I2O SCSI Peripheral OSM v1.316
[   21.844095] bus: 'i2o': add driver scsi-osm
[   21.848521] initcall i2o_scsi_init+0x0/0x68 returned 0 after 0 usecs
[   21.850004] calling  fusion_init+0x0/0x164 @ 1
[   21.860003] Fusion MPT base driver 3.04.10
[   21.864096] Copyright (c) 1999-2008 LSI Corporation
[   21.869005] initcall fusion_init+0x0/0x164 returned 0 after 0 usecs
[   21.870004] calling  mptfc_init+0x0/0x115 @ 1
[   21.880024] Fusion MPT FC Host driver 3.04.10
[   21.884408] bus: 'pci': add driver mptfc
[   21.888612] initcall mptfc_init+0x0/0x115 returned 0 after 0 usecs
[   21.890005] calling  mptctl_init+0x0/0x141 @ 1
[   21.894448] Fusion MPT misc device (ioctl) driver 3.04.10
[   21.900011] device: 'mptctl': device_add
[   21.904214] mptctl: Registered with Fusion MPT base driver
[   21.910004] mptctl: /dev/mptctl @ (major,minor=10,220)
[   21.915135] initcall mptctl_init+0x0/0x141 returned 0 after 19531 usecs
[   21.920004] calling  mpt_lan_init+0x0/0xa4 @ 1
[   21.930005] Fusion MPT LAN driver 3.04.10
[   21.934011] initcall mpt_lan_init+0x0/0xa4 returned 0 after 0 usecs
[   21.940004] calling  fw_core_init+0x0/0xb0 @ 1
[   21.944692] bus: 'firewire': registered
[   21.948570] initcall fw_core_init+0x0/0xb0 returned 0 after 0 usecs
[   21.950028] calling  fw_ohci_init+0x0/0x42 @ 1
[   21.960009] bus: 'pci': add driver firewire_ohci
[   21.964878] initcall fw_ohci_init+0x0/0x42 returned 0 after 0 usecs
[   21.970009] calling  sbp2_init+0x0/0x6d @ 1
[   21.974287] bus: 'firewire': add driver sbp2
[   21.980261] initcall sbp2_init+0x0/0x6d returned 0 after 9765 usecs
[   21.986519] calling  ohci1394_init+0x0/0x42 @ 1
[   21.990032] bus: 'pci': add driver ohci1394
[   21.994449] initcall ohci1394_init+0x0/0x42 returned 0 after 0 usecs
[   22.000074] calling  video1394_init_module+0x0/0xfc @ 1
[   22.005296] bus: 'ieee1394': add driver video1394
[   22.010222] video1394: Installed video1394 module
[   22.014920] initcall video1394_init_module+0x0/0xfc returned 0 after 9765 usecs
[   22.020022] calling  init_raw1394+0x0/0x11a @ 1
[   22.024560] device: 'raw1394': device_add
[   22.030267] ieee1394: raw1394: /dev/raw1394 device initialized
[   22.036095] bus: 'ieee1394': add driver raw1394
[   22.040280] initcall init_raw1394+0x0/0x11a returned 0 after 19531 usecs
[   22.050014] calling  dv1394_init_module+0x0/0xc5 @ 1
[   22.054974] bus: 'ieee1394': add driver dv1394
[   22.059649] initcall dv1394_init_module+0x0/0xc5 returned 0 after 0 usecs
[   22.060004] calling  ether1394_init_module+0x0/0x96 @ 1
[   22.070487] bus: 'ieee1394': add driver eth1394
[   22.075223] initcall ether1394_init_module+0x0/0x96 returned 0 after 0 usecs
[   22.080005] calling  cdrom_init+0x0/0x91 @ 1
[   22.084268] initcall cdrom_init+0x0/0x91 returned 0 after 0 usecs
[   22.090004] calling  ks0108_init+0x0/0xe0 @ 1
[   22.094359] parport0: cannot grant exclusive access for device ks0108
[   22.100008] ks0108: ERROR: parport didn't register new device
[   22.110004] initcall ks0108_init+0x0/0xe0 returned -22 after 19531 usecs
[   22.116696] initcall ks0108_init+0x0/0xe0 returned with error code -22 
[   22.120026] calling  spi_gpio_init+0x0/0x40 @ 1
[   22.124557] bus: 'platform': add driver spi_gpio
[   22.130240] bus: 'platform': remove driver spi_gpio
[   22.135310] driver: 'spi_gpio': driver_release
[   22.140011] initcall spi_gpio_init+0x0/0x40 returned -19 after 19531 usecs
[   22.150004] calling  init_spi_lm70llp+0x0/0x39 @ 1
[   22.154796] parport0: cannot grant exclusive access for device spi-lm70llp
[   22.160008] spi-lm70llp: spi_lm70llp probe fail, status -12
[   22.165578] initcall init_spi_lm70llp+0x0/0x39 returned 0 after 9765 usecs
[   22.170003] calling  spidev_init+0x0/0xbf @ 1
[   22.174363] device class 'spidev': registering
[   22.180245] bus: 'spi': add driver spidev
[   22.184505] initcall spidev_init+0x0/0xbf returned 0 after 9765 usecs
[   22.190005] calling  tle62x0_init+0x0/0x39 @ 1
[   22.194442] bus: 'spi': add driver tle62x0
[   22.200209] initcall tle62x0_init+0x0/0x39 returned 0 after 9765 usecs
[   22.206729] calling  aoe_init+0x0/0xd5 @ 1
[   22.210011] device class 'aoe': registering
[   22.214438] device: 'err': device_add
[   22.220271] device: 'discover': device_add
[   22.224630] device: 'interfaces': device_add
[   22.230263] device: 'revalidate': device_add
[   22.234776] device: 'flush': device_add
[   22.239272] aoe: AoE v47 initialised.
[   22.240246] initcall aoe_init+0x0/0xd5 returned 0 after 29296 usecs
[   22.250005] calling  uwb_subsys_init+0x0/0x77 @ 1
[   22.254723] device class 'uwb_rc': registering
[   22.259401] initcall uwb_subsys_init+0x0/0x77 returned 0 after 0 usecs
[   22.260006] calling  wlp_subsys_init+0x0/0x2d @ 1
[   22.270004] initcall wlp_subsys_init+0x0/0x2d returned 0 after 0 usecs
[   22.276521] calling  umc_bus_init+0x0/0x39 @ 1
[   22.280259] bus: 'umc': registered
[   22.283663] initcall umc_bus_init+0x0/0x39 returned 0 after 0 usecs
[   22.290005] calling  whci_init+0x0/0x42 @ 1
[   22.294196] bus: 'pci': add driver whci
[   22.298302] initcall whci_init+0x0/0x42 returned 0 after 0 usecs
[   22.300004] calling  whcrc_driver_init+0x0/0x42 @ 1
[   22.310003] bus: 'umc': add driver whc-rc
[   22.314226] initcall whcrc_driver_init+0x0/0x42 returned 0 after 0 usecs
[   22.320005] calling  hwarc_driver_init+0x0/0x42 @ 1
[   22.324879] bus: 'usb': add driver hwa-rc
[   22.330224] usbcore: registered new interface driver hwa-rc
[   22.335799] initcall hwarc_driver_init+0x0/0x42 returned 0 after 9765 usecs
[   22.340005] calling  gpio_vbus_init+0x0/0x40 @ 1
[   22.344616] bus: 'platform': add driver gpio-vbus
[   22.350262] bus: 'platform': remove driver gpio-vbus
[   22.355418] driver: 'gpio-vbus': driver_release
[   22.360011] initcall gpio_vbus_init+0x0/0x40 returned -19 after 19531 usecs
[   22.366962] calling  mon_init+0x0/0x141 @ 1
[   22.370015] device class 'usbmon': registering
[   22.374689] device: 'usbmon0': device_add
[   22.380339] initcall mon_init+0x0/0x141 returned 0 after 9765 usecs
[   22.386599] calling  ehci_hcd_init+0x0/0x10e @ 1
[   22.390004] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   22.400003] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[   22.406028] bus: 'pci': add driver ehci_hcd
[   22.410027] bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
[   22.418537] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
[   22.420204] ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
[   22.430007] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[   22.440005] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[   22.446113] initcall ehci_hcd_init+0x0/0x10e returned 0 after 48828 usecs
[   22.450027] calling  oxu_module_init+0x0/0x39 @ 1
[   22.460004] bus: 'platform': add driver oxu210hp-hcd
[   22.465183] initcall oxu_module_init+0x0/0x39 returned 0 after 0 usecs
[   22.470057] calling  ohci_hcd_mod_init+0x0/0x101 @ 1
[   22.475012] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   22.480003] ohci_hcd: block sizes: ed 80 td 96
[   22.484478] bus: 'pci': add driver ohci_hcd
[   22.490026] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
[   22.500003] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
[   22.508021] ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[   22.510042] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[   22.520008] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[   22.530272] bus: 'ssb': add driver ohci_hcd
[   22.534661] initcall ohci_hcd_mod_init+0x0/0x101 returned 0 after 58593 usecs
[   22.540027] calling  uhci_hcd_init+0x0/0x159 @ 1
[   22.544640] uhci_hcd: USB Universal Host Controller Interface driver
[   22.550486] bus: 'pci': add driver uhci_hcd
[   22.554946] initcall uhci_hcd_init+0x0/0x159 returned 0 after 9765 usecs
[   22.560058] calling  sl811h_init+0x0/0x67 @ 1
[   22.570003] sl811: driver sl811-hcd, 19 May 2005
[   22.574615] bus: 'platform': add driver sl811-hcd
[   22.580206] initcall sl811h_init+0x0/0x67 returned 0 after 9765 usecs
[   22.586641] calling  u132_hcd_init+0x0/0xd8 @ 1
[   22.590023] driver u132_hcd built at 22:49:46 on Aug  2 2009
[   22.595786] bus: 'platform': add driver u132_hcd
[   22.600300] initcall u132_hcd_init+0x0/0xd8 returned 0 after 9765 usecs
[   22.606910] calling  isp1760_init+0x0/0x76 @ 1
[   22.610798] bus: 'platform': add driver isp1760
[   22.615539] bus: 'pci': add driver isp1760
[   22.620298] initcall isp1760_init+0x0/0x76 returned 0 after 9765 usecs
[   22.626814] calling  hwahc_driver_init+0x0/0x42 @ 1
[   22.630011] bus: 'usb': add driver hwa-hc
[   22.634226] usbcore: registered new interface driver hwa-hc
[   22.640009] initcall hwahc_driver_init+0x0/0x42 returned 0 after 9765 usecs
[   22.650004] calling  c67x00_init+0x0/0x39 @ 1
[   22.654356] bus: 'platform': add driver c67x00
[   22.660321] initcall c67x00_init+0x0/0x39 returned 0 after 9765 usecs
[   22.666752] calling  wusbcore_init+0x0/0x9a @ 1
[   22.670127] initcall wusbcore_init+0x0/0x9a returned 0 after 0 usecs
[   22.676477] calling  cbaf_driver_init+0x0/0x42 @ 1
[   22.680005] bus: 'usb': add driver wusb-cbaf
[   22.684544] usbcore: registered new interface driver wusb-cbaf
[   22.690009] initcall cbaf_driver_init+0x0/0x42 returned 0 after 9765 usecs
[   22.696875] calling  acm_init+0x0/0x128 @ 1
[   22.700016] bus: 'usb': add driver cdc_acm
[   22.704317] usbcore: registered new interface driver cdc_acm
[   22.710007] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[   22.720005] initcall acm_init+0x0/0x128 returned 0 after 19531 usecs
[   22.726348] calling  usb_stor_init+0x0/0x6a @ 1
[   22.730004] Initializing USB Mass Storage driver...
[   22.734878] bus: 'usb': add driver usb-storage
[   22.740216] usbcore: registered new interface driver usb-storage
[   22.746220] USB Mass Storage support registered.
[   22.750033] initcall usb_stor_init+0x0/0x6a returned 0 after 19531 usecs
[   22.760004] calling  alauda_init+0x0/0x42 @ 1
[   22.764355] bus: 'usb': add driver ums-alauda
[   22.768974] usbcore: registered new interface driver ums-alauda
[   22.770009] initcall alauda_init+0x0/0x42 returned 0 after 9765 usecs
[   22.780004] calling  cypress_init+0x0/0x42 @ 1
[   22.784444] bus: 'usb': add driver ums-cypress
[   22.790207] usbcore: registered new interface driver ums-cypress
[   22.796213] initcall cypress_init+0x0/0x42 returned 0 after 9765 usecs
[   22.800005] calling  datafab_init+0x0/0x42 @ 1
[   22.804443] bus: 'usb': add driver ums-datafab
[   22.810214] usbcore: registered new interface driver ums-datafab
[   22.816223] initcall datafab_init+0x0/0x42 returned 0 after 9765 usecs
[   22.820005] calling  freecom_init+0x0/0x42 @ 1
[   22.824442] bus: 'usb': add driver ums-freecom
[   22.830229] usbcore: registered new interface driver ums-freecom
[   22.840009] initcall freecom_init+0x0/0x42 returned 0 after 19531 usecs
[   22.846616] calling  isd200_init+0x0/0x42 @ 1
[   22.850004] bus: 'usb': add driver ums-isd200
[   22.854567] usbcore: registered new interface driver ums-isd200
[   22.860009] initcall isd200_init+0x0/0x42 returned 0 after 9765 usecs
[   22.866442] calling  jumpshot_init+0x0/0x42 @ 1
[   22.870004] bus: 'usb': add driver ums-jumpshot
[   22.874768] usbcore: registered new interface driver ums-jumpshot
[   22.880009] initcall jumpshot_init+0x0/0x42 returned 0 after 9765 usecs
[   22.886614] calling  sddr09_init+0x0/0x42 @ 1
[   22.890004] bus: 'usb': add driver ums-sddr09
[   22.894568] usbcore: registered new interface driver ums-sddr09
[   22.900009] initcall sddr09_init+0x0/0x42 returned 0 after 9765 usecs
[   22.910004] calling  usbat_init+0x0/0x42 @ 1
[   22.914270] bus: 'usb': add driver ums-usbat
[   22.920120] usbcore: registered new interface driver ums-usbat
[   22.925954] initcall usbat_init+0x0/0x42 returned 0 after 9765 usecs
[   22.930006] calling  usb_mdc800_init+0x0/0x325 @ 1
[   22.934801] bus: 'usb': add driver mdc800
[   22.940213] usbcore: registered new interface driver mdc800
[   22.945778] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   22.950006] initcall usb_mdc800_init+0x0/0x325 returned 0 after 19531 usecs
[   22.960004] calling  microtek_drv_init+0x0/0x42 @ 1
[   22.964876] bus: 'usb': add driver microtekX6
[   22.970212] usbcore: registered new interface driver microtekX6
[   22.976127] initcall microtek_drv_init+0x0/0x42 returned 0 after 9765 usecs
[   22.980005] calling  adu_init+0x0/0xba @ 1
[   22.984094] drivers/usb/misc/adutux.c :  adu_init : enter 
[   22.990004] bus: 'usb': add driver adutux
[   22.994269] usbcore: registered new interface driver adutux
[   23.000007] adutux adutux (see www.ontrak.net) v0.0.13
[   23.005142] adutux is an experimental driver. Use at your own risk
[   23.010005] drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
[   23.020004] initcall adu_init+0x0/0xba returned 0 after 39062 usecs
[   23.026260] calling  appledisplay_init+0x0/0x80 @ 1
[   23.030099] bus: 'usb': add driver appledisplay
[   23.034833] usbcore: registered new interface driver appledisplay
[   23.040037] initcall appledisplay_init+0x0/0x80 returned 0 after 9765 usecs
[   23.050004] calling  berry_init+0x0/0x42 @ 1
[   23.054270] bus: 'usb': add driver berry_charge
[   23.059010] usbcore: registered new interface driver berry_charge
[   23.060009] initcall berry_init+0x0/0x42 returned 0 after 9765 usecs
[   23.070004] calling  usb_cytherm_init+0x0/0x70 @ 1
[   23.074789] bus: 'usb': add driver cytherm
[   23.080214] usbcore: registered new interface driver cytherm
[   23.085871] cytherm: v1.0:Cypress USB Thermometer driver
[   23.090006] initcall usb_cytherm_init+0x0/0x70 returned 0 after 19531 usecs
[   23.096955] calling  emi26_init+0x0/0x42 @ 1
[   23.100004] bus: 'usb': add driver emi26 - firmware loader
[   23.105693] usbcore: registered new interface driver emi26 - firmware loader
[   23.110009] initcall emi26_init+0x0/0x42 returned 0 after 9765 usecs
[   23.120004] calling  ftdi_elan_init+0x0/0x192 @ 1
[   23.124700] driver ftdi-elan built at 22:49:45 on Aug  2 2009
[   23.130336] bus: 'usb': add driver ftdi-elan
[   23.134824] usbcore: registered new interface driver ftdi-elan
[   23.140019] initcall ftdi_elan_init+0x0/0x192 returned 0 after 19531 usecs
[   23.150004] calling  iowarrior_init+0x0/0x42 @ 1
[   23.154617] bus: 'usb': add driver iowarrior
[   23.159099] usbcore: registered new interface driver iowarrior
[   23.160009] initcall iowarrior_init+0x0/0x42 returned 0 after 9765 usecs
[   23.170004] calling  isight_firmware_init+0x0/0x42 @ 1
[   23.175138] bus: 'usb': add driver isight_firmware
[   23.180225] usbcore: registered new interface driver isight_firmware
[   23.186576] initcall isight_firmware_init+0x0/0x42 returned 0 after 9765 usecs
[   23.190005] calling  usb_lcd_init+0x0/0x60 @ 1
[   23.200004] bus: 'usb': add driver usblcd
[   23.204221] usbcore: registered new interface driver usblcd
[   23.210009] initcall usb_lcd_init+0x0/0x60 returned 0 after 9765 usecs
[   23.216530] calling  ld_usb_init+0x0/0x60 @ 1
[   23.220004] bus: 'usb': add driver ldusb
[   23.224135] usbcore: registered new interface driver ldusb
[   23.230011] initcall ld_usb_init+0x0/0x60 returned 0 after 9765 usecs
[   23.236444] calling  usb_led_init+0x0/0x60 @ 1
[   23.240005] bus: 'usb': add driver usbled
[   23.244221] usbcore: registered new interface driver usbled
[   23.250009] initcall usb_led_init+0x0/0x60 returned 0 after 9765 usecs
[   23.256529] calling  usb_rio_init+0x0/0x5e @ 1
[   23.260005] bus: 'usb': add driver rio500
[   23.264231] usbcore: registered new interface driver rio500
[   23.270010] rio500: v1.1:USB Rio 500 driver
[   23.274191] initcall usb_rio_init+0x0/0x5e returned 0 after 9765 usecs
[   23.280004] calling  tv_init+0x0/0x70 @ 1
[   23.284008] bus: 'usb': add driver trancevibrator
[   23.290215] usbcore: registered new interface driver trancevibrator
[   23.296480] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[   23.300006] initcall tv_init+0x0/0x70 returned 0 after 19531 usecs
[   23.310004] calling  usb_sevseg_init+0x0/0x60 @ 1
[   23.314704] bus: 'usb': add driver usbsevseg
[   23.319184] usbcore: registered new interface driver usbsevseg
[   23.320009] initcall usb_sevseg_init+0x0/0x60 returned 0 after 9765 usecs
[   23.330006] calling  vstusb_init+0x0/0x67 @ 1
[   23.334357] bus: 'usb': add driver vstusb
[   23.340228] usbcore: registered new interface driver vstusb
[   23.345796] initcall vstusb_init+0x0/0x67 returned 0 after 9765 usecs
[   23.350005] calling  i8042_init+0x0/0xdb @ 1
[   23.354318] bus: 'platform': add driver i8042
[   23.360227] Registering platform device 'i8042'. Parent at platform
[   23.366489] device: 'i8042': device_add
[   23.370013] bus: 'platform': add device i8042
[   23.374641] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   23.380003] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   23.391444] serio: i8042 KBD port at 0x60,0x64 irq 1
[   23.391444] serio: i8042 AUX port at 0x60,0x64 irq 12
[   23.391444] driver: 'i8042': driver_bound: bound to device 'i8042'
[   23.400096] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   23.407233] initcall i8042_init+0x0/0xdb returned 0 after 58593 usecs
[   23.410006] calling  parkbd_init+0x0/0x230 @ 1
[   23.414447] parport0: cannot grant exclusive access for device parkbd
[   23.420081] initcall parkbd_init+0x0/0x230 returned -19 after 9765 usecs
[   23.430005] calling  serport_init+0x0/0x5a @ 1
[   23.434443] initcall serport_init+0x0/0x5a returned 0 after 0 usecs
[   23.440031] calling  pcips2_init+0x0/0x42 @ 1
[   23.444400] bus: 'pci': add driver pcips2
[   23.460000] device: 'serio0': device_add
[   23.460388] initcall pcips2_init+0x0/0x42 returned 0 after 9765 usecs
[   23.460393] calling  serio_raw_init+0x0/0x42 @ 1
[   23.460397] bus: 'serio': add driver serio_raw
[   23.460620] initcall serio_raw_init+0x0/0x42 returned 0 after 0 usecs
[   23.460624] calling  emu_init+0x0/0x42 @ 1
[   23.460641] bus: 'pci': add driver Emu10k1_gameport
[   23.460942] initcall emu_init+0x0/0x42 returned 0 after 0 usecs
[   23.460947] calling  fm801_gp_init+0x0/0x42 @ 1
[   23.460953] bus: 'pci': add driver FM801_gameport
[   23.461189] initcall fm801_gp_init+0x0/0x42 returned 0 after 0 usecs
[   23.461193] calling  l4_init+0x0/0x37f @ 1
[   23.461215] initcall l4_init+0x0/0x37f returned -19 after 0 usecs
[   23.461219] calling  ns558_init+0x0/0x311 @ 1
[   23.470000] initcall ns558_init+0x0/0x311 returned -19 after 0 usecs
[   23.470000] calling  mousedev_init+0x0/0x87 @ 1
[   23.470000] device: 'mice': device_add
[   23.470000] mice: PS/2 mouse device common for all mice
[   23.470000] initcall mousedev_init+0x0/0x87 returned 0 after 0 usecs
[   23.470000] calling  joydev_init+0x0/0x39 @ 1
[   23.470000] initcall joydev_init+0x0/0x39 returned 0 after 0 usecs
[   23.470000] calling  evdev_init+0x0/0x39 @ 1
[   23.470000] initcall evdev_init+0x0/0x39 returned 0 after 0 usecs
[   23.470000] calling  evbug_init+0x0/0x39 @ 1
[   23.470000] initcall evbug_init+0x0/0x39 returned 0 after 0 usecs
[   23.470000] calling  atkbd_init+0x0/0x42 @ 1
[   23.470000] bus: 'serio': add driver atkbd
[   23.470000] initcall atkbd_init+0x0/0x42 returned 0 after 0 usecs
[   23.470000] calling  gpio_keys_init+0x0/0x39 @ 1
[   23.470000] bus: 'platform': add driver gpio-keys
[   23.470000] initcall gpio_keys_init+0x0/0x39 returned 0 after 0 usecs
[   23.470000] calling  lkkbd_init+0x0/0x42 @ 1
[   23.470000] bus: 'serio': add driver lkkbd
[   23.470000] initcall lkkbd_init+0x0/0x42 returned 0 after 0 usecs
[   23.470000] calling  lm8323_init+0x0/0x3b @ 1
[   23.470000] bus: 'i2c': add driver lm8323
[   23.470000] initcall lm8323_init+0x0/0x3b returned 0 after 0 usecs
[   23.470000] calling  matrix_keypad_init+0x0/0x39 @ 1
[   23.470000] bus: 'platform': add driver matrix-keypad
[   23.470000] initcall matrix_keypad_init+0x0/0x39 returned 0 after 0 usecs
[   23.470000] calling  sunkbd_init+0x0/0x42 @ 1
[   23.470000] bus: 'serio': add driver sunkbd
[   23.470000] initcall sunkbd_init+0x0/0x42 returned 0 after 0 usecs
[   23.470000] calling  xtkbd_init+0x0/0x42 @ 1
[   23.470000] bus: 'serio': add driver xtkbd
[   23.470000] initcall xtkbd_init+0x0/0x42 returned 0 after 0 usecs
[   23.470000] calling  atp_init+0x0/0x42 @ 1
[   23.470000] bus: 'usb': add driver appletouch
[   23.470000] usbcore: registered new interface driver appletouch
[   23.470000] initcall atp_init+0x0/0x42 returned 0 after 0 usecs
[   23.470000] calling  gpio_mouse_init+0x0/0x39 @ 1
[   23.470000] bus: 'platform': add driver gpio_mouse
[   23.470000] initcall gpio_mouse_init+0x0/0x39 returned 0 after 0 usecs
[   23.470000] calling  psmouse_init+0x0/0x9a @ 1
[   23.470000] bus: 'serio': add device serio0
[   23.480948] bus: 'serio': add driver psmouse
[   23.485465] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   23.485622] initcall psmouse_init+0x0/0x9a returned 0 after 19531 usecs
[   23.485627] calling  sermouse_init+0x0/0x42 @ 1
[   23.485630] bus: 'serio': add driver sermouse
[   23.485878] initcall sermouse_init+0x0/0x42 returned 0 after 0 usecs
[   23.485882] calling  synaptics_i2c_init+0x0/0x3b @ 1
[   23.485887] bus: 'i2c': add driver synaptics_i2c
[   23.486098] initcall synaptics_i2c_init+0x0/0x3b returned 0 after 0 usecs
[   23.486103] calling  vsxxxaa_init+0x0/0x42 @ 1
[   23.486106] bus: 'serio': add driver vsxxxaa
[   23.486356] initcall vsxxxaa_init+0x0/0x42 returned 0 after 0 usecs
[   23.486360] calling  a3d_init+0x0/0x42 @ 1
[   23.486363] bus: 'gameport': add driver adc
[   23.486581] initcall a3d_init+0x0/0x42 returned 0 after 0 usecs
[   23.486585] calling  analog_init+0x0/0x118 @ 1
[   23.486588] bus: 'gameport': add driver analog
[   23.486841] initcall analog_init+0x0/0x118 returned 0 after 0 usecs
[   23.486845] calling  gc_init+0x0/0x62b @ 1
[   23.486850] initcall gc_init+0x0/0x62b returned -19 after 0 usecs
[   23.486853] calling  gf2k_init+0x0/0x42 @ 1
[   23.486856] bus: 'gameport': add driver gf2k
[   23.487069] initcall gf2k_init+0x0/0x42 returned 0 after 0 usecs
[   23.487073] calling  grip_init+0x0/0x42 @ 1
[   23.487076] bus: 'gameport': add driver grip_mp
[   23.487326] initcall grip_init+0x0/0x42 returned 0 after 0 usecs
[   23.487330] calling  iforce_init+0x0/0x42 @ 1
[   23.487333] bus: 'serio': add driver iforce
[   23.487558] initcall iforce_init+0x0/0x42 returned 0 after 0 usecs
[   23.487563] calling  interact_init+0x0/0x42 @ 1
[   23.487566] bus: 'gameport': add driver interact
[   23.487813] initcall interact_init+0x0/0x42 returned 0 after 0 usecs
[   23.487818] calling  magellan_init+0x0/0x42 @ 1
[   23.487821] bus: 'serio': add driver magellan
[   23.488056] initcall magellan_init+0x0/0x42 returned 0 after 0 usecs
[   23.488060] calling  sw_init+0x0/0x42 @ 1
[   23.488063] bus: 'gameport': add driver sidewinder
[   23.488307] initcall sw_init+0x0/0x42 returned 0 after 0 usecs
[   23.488311] calling  spaceball_init+0x0/0x42 @ 1
[   23.488315] bus: 'serio': add driver spaceball
[   23.488531] initcall spaceball_init+0x0/0x42 returned 0 after 0 usecs
[   23.488535] calling  spaceorb_init+0x0/0x42 @ 1
[   23.488538] bus: 'serio': add driver spaceorb
[   23.488796] initcall spaceorb_init+0x0/0x42 returned 0 after 0 usecs
[   23.488800] calling  stinger_init+0x0/0x42 @ 1
[   23.488803] bus: 'serio': add driver stinger
[   23.489038] initcall stinger_init+0x0/0x42 returned 0 after 0 usecs
[   23.489042] calling  tmdc_init+0x0/0x42 @ 1
[   23.489045] bus: 'gameport': add driver tmdc
[   23.489289] initcall tmdc_init+0x0/0x42 returned 0 after 0 usecs
[   23.489293] calling  tgfx_init+0x0/0x4a2 @ 1
[   23.489298] initcall tgfx_init+0x0/0x4a2 returned -19 after 0 usecs
[   23.489302] calling  walkera0701_init+0x0/0x2c8 @ 1
[   23.489305] walkera0701: parport without interrupt
[   23.489310] initcall walkera0701_init+0x0/0x2c8 returned -19 after 0 usecs
[   23.489314] calling  ad7877_init+0x0/0x39 @ 1
[   23.489319] bus: 'spi': add driver ad7877
[   23.489530] initcall ad7877_init+0x0/0x39 returned 0 after 0 usecs
[   23.489535] calling  ad7879_init+0x0/0x39 @ 1
[   23.489539] bus: 'spi': add driver ad7879
[   23.489782] initcall ad7879_init+0x0/0x39 returned 0 after 0 usecs
[   23.489787] calling  elo_init+0x0/0x42 @ 1
[   23.489791] bus: 'serio': add driver elo
[   23.490056] initcall elo_init+0x0/0x42 returned 0 after 9765 usecs
[   23.490060] calling  fujitsu_init+0x0/0x42 @ 1
[   23.490063] bus: 'serio': add driver fujitsu_ts
[   23.490326] initcall fujitsu_init+0x0/0x42 returned 0 after 0 usecs
[   23.490331] calling  usbtouch_init+0x0/0x42 @ 1
[   23.490342] bus: 'usb': add driver usbtouchscreen
[   23.490574] usbcore: registered new interface driver usbtouchscreen
[   23.490584] initcall usbtouch_init+0x0/0x42 returned 0 after 0 usecs
[   23.490588] calling  touchit213_init+0x0/0x42 @ 1
[   23.490592] bus: 'serio': add driver touchit213
[   23.490840] initcall touchit213_init+0x0/0x42 returned 0 after 0 usecs
[   23.490844] calling  tr_init+0x0/0x42 @ 1
[   23.490847] bus: 'serio': add driver touchright
[   23.491083] initcall tr_init+0x0/0x42 returned 0 after 0 usecs
[   23.491087] calling  tw_init+0x0/0x42 @ 1
[   23.491090] bus: 'serio': add driver touchwin
[   23.491350] initcall tw_init+0x0/0x42 returned 0 after 0 usecs
[   23.491354] calling  tsc2007_init+0x0/0x3b @ 1
[   23.491359] bus: 'i2c': add driver tsc2007
[   23.491582] initcall tsc2007_init+0x0/0x3b returned 0 after 0 usecs
[   23.491586] calling  da9034_touch_init+0x0/0x39 @ 1
[   23.491593] bus: 'platform': add driver da9034-touch
[   23.491847] initcall da9034_touch_init+0x0/0x39 returned 0 after 0 usecs
[   23.491852] calling  w90x900ts_init+0x0/0x39 @ 1
[   23.491856] bus: 'platform': add driver w90x900-ts
[   23.492067] initcall w90x900ts_init+0x0/0x39 returned 0 after 0 usecs
[   23.492072] calling  i2c_dev_init+0x0/0xcb @ 1
[   23.492074] i2c /dev entries driver
[   23.492096] device class 'i2c-dev': registering
[   23.492345] bus: 'i2c': add driver dev_driver
[   23.492554] initcall i2c_dev_init+0x0/0xcb returned 0 after 0 usecs
[   23.492559] calling  i2c_ali1535_init+0x0/0x42 @ 1
[   23.492580] bus: 'pci': add driver ali1535_smbus
[   23.492884] initcall i2c_ali1535_init+0x0/0x42 returned 0 after 0 usecs
[   23.492889] calling  ali1563_init+0x0/0x42 @ 1
[   23.492896] bus: 'pci': add driver ali1563_smbus
[   23.493123] initcall ali1563_init+0x0/0x42 returned 0 after 0 usecs
[   23.493128] calling  i2c_amd8111_init+0x0/0x42 @ 1
[   23.493135] bus: 'pci': add driver amd8111_smbus2
[   23.493409] initcall i2c_amd8111_init+0x0/0x42 returned 0 after 0 usecs
[   23.493414] calling  i2c_i801_init+0x0/0x42 @ 1
[   23.493421] bus: 'pci': add driver i801_smbus
[   23.493655] initcall i2c_i801_init+0x0/0x42 returned 0 after 0 usecs
[   23.493660] calling  i2c_sch_init+0x0/0x42 @ 1
[   23.493667] bus: 'pci': add driver isch_smbus
[   23.493961] initcall i2c_sch_init+0x0/0x42 returned 0 after 0 usecs
[   23.493966] calling  nforce2_init+0x0/0x42 @ 1
[   23.493972] bus: 'pci': add driver nForce2_smbus
[   23.493992] bus: 'pci': driver_probe_device: matched device 0000:00:01.1 with driver nForce2_smbus
[   23.493996] bus: 'pci': really_probe: probing driver nForce2_smbus with device 0000:00:01.1
[   23.502943] device: 'i2c-0': device_add
[   23.520109] i2c-adapter i2c-0: Transaction failed (0x10)!
[   23.560018] device: '0-0050': device_add
[   23.560030] bus: 'i2c': add device 0-0050
[   23.560275] bus: 'i2c': driver_probe_device: matched device 0-0050 with driver eeprom
[   23.560279] bus: 'i2c': really_probe: probing driver eeprom with device 0-0050
[   23.560297] driver: '0-0050': driver_bound: bound to device 'eeprom'
[   23.560301] bus: 'i2c': really_probe: bound device 0-0050 to driver eeprom
[   23.600037] device: '0-0051': device_add
[   23.600047] bus: 'i2c': add device 0-0051
[   23.600260] bus: 'i2c': driver_probe_device: matched device 0-0051 with driver eeprom
[   23.600264] bus: 'i2c': really_probe: probing driver eeprom with device 0-0051
[   23.600281] driver: '0-0051': driver_bound: bound to device 'eeprom'
[   23.600284] bus: 'i2c': really_probe: bound device 0-0051 to driver eeprom
[   23.620068] i2c-adapter i2c-0: Transaction failed (0x10)!
[   23.640030] i2c-adapter i2c-0: Transaction failed (0x10)!
[   23.660010] i2c-adapter i2c-0: Transaction failed (0x10)!
[   23.680010] i2c-adapter i2c-0: Transaction failed (0x10)!
[   23.700009] i2c-adapter i2c-0: Transaction failed (0x10)!
[   23.720010] i2c-adapter i2c-0: Transaction failed (0x10)!
[   23.720057] device: 'i2c-0': device_add
[   23.720362] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[   23.720377] device: 'i2c-1': device_add
[   23.740111] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.760034] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.780012] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.800010] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.820010] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.840009] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.860009] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.880009] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.900010] i2c-adapter i2c-1: Transaction failed (0x10)!
[   23.900027] device: 'i2c-1': device_add
[   23.900284] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[   23.900309] driver: '0000:00:01.1': driver_bound: bound to device 'nForce2_smbus'
[   23.900316] bus: 'pci': really_probe: bound device 0000:00:01.1 to driver nForce2_smbus
[   23.900560] initcall nforce2_init+0x0/0x42 returned 0 after 400390 usecs
[   23.900566] calling  i2c_piix4_init+0x0/0x42 @ 1
[   23.900585] bus: 'pci': add driver piix4_smbus
[   23.900849] initcall i2c_piix4_init+0x0/0x42 returned 0 after 0 usecs
[   23.900854] calling  i2c_sis5595_init+0x0/0x42 @ 1
[   23.900861] bus: 'pci': add driver sis5595_smbus
[   23.901126] initcall i2c_sis5595_init+0x0/0x42 returned 0 after 0 usecs
[   23.901131] calling  i2c_sis630_init+0x0/0x42 @ 1
[   23.901138] bus: 'pci': add driver sis630_smbus
[   23.901370] initcall i2c_sis630_init+0x0/0x42 returned 0 after 0 usecs
[   23.901375] calling  i2c_sis96x_init+0x0/0x42 @ 1
[   23.901382] bus: 'pci': add driver sis96x_smbus
[   23.901649] initcall i2c_sis96x_init+0x0/0x42 returned 0 after 0 usecs
[   23.901653] calling  ocores_i2c_init+0x0/0x39 @ 1
[   23.901660] bus: 'platform': add driver ocores-i2c
[   23.901889] initcall ocores_i2c_init+0x0/0x39 returned 0 after 0 usecs
[   23.901894] calling  i2c_adap_simtec_init+0x0/0x39 @ 1
[   23.901898] bus: 'platform': add driver simtec-i2c
[   23.902143] initcall i2c_adap_simtec_init+0x0/0x39 returned 0 after 0 usecs
[   23.902148] calling  i2c_parport_init+0x0/0x171 @ 1
[   23.902151] i2c-parport-light: adapter type unspecified
[   23.902156] initcall i2c_parport_init+0x0/0x171 returned -19 after 0 usecs
[   23.902160] calling  taos_init+0x0/0x42 @ 1
[   23.902166] bus: 'serio': add driver taos-evm
[   23.902387] initcall taos_init+0x0/0x42 returned 0 after 0 usecs
[   23.902391] calling  tsl2550_init+0x0/0x3b @ 1
[   23.902395] bus: 'i2c': add driver tsl2550
[   23.902643] initcall tsl2550_init+0x0/0x3b returned 0 after 0 usecs
[   23.902648] calling  videodev_init+0x0/0xad @ 1
[   23.902651] Linux video capture interface: v2.00
[   23.902657] device class 'video4linux': registering
[   23.902872] initcall videodev_init+0x0/0xad returned 0 after 0 usecs
[   23.902877] calling  dabusb_init+0x0/0x11b @ 1
[   23.902993] bus: 'usb': add driver dabusb
[   23.903247] usbcore: registered new interface driver dabusb
[   23.903253] dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
[   23.903259] initcall dabusb_init+0x0/0x11b returned 0 after 0 usecs
[   23.903264] calling  gemtek_pci_init+0x0/0x42 @ 1
[   23.903281] bus: 'pci': add driver gemtek_pci
[   23.903564] initcall gemtek_pci_init+0x0/0x42 returned 0 after 0 usecs
[   23.903569] calling  maestro_radio_init+0x0/0x5e @ 1
[   23.903576] bus: 'pci': add driver maestro_radio
[   23.903842] initcall maestro_radio_init+0x0/0x5e returned 0 after 0 usecs
[   23.903847] calling  dsbr100_init+0x0/0x5a @ 1
[   23.903854] bus: 'usb': add driver dsbr100
[   23.904063] usbcore: registered new interface driver dsbr100
[   23.904070] dsbr100: v0.46:D-Link DSB-R100 USB FM radio driver
[   23.904075] initcall dsbr100_init+0x0/0x5a returned 0 after 0 usecs
[   23.904080] calling  tea5764_init+0x0/0x53 @ 1
[   23.904085] bus: 'i2c': add driver radio-tea5764
[   23.904343] radio_tea5764: v0.01: A driver for the TEA5764 radio chip for EZX Phones.
[   23.904349] initcall tea5764_init+0x0/0x53 returned 0 after 0 usecs
[   23.904355] calling  w1_init+0x0/0xcd @ 1
[   23.904357] Driver for 1-wire Dallas network protocol.
[   23.904602] bus: 'w1': registered
[   23.904606] bus: 'w1': add driver w1_master_driver
[   23.904867] bus: 'w1': add driver w1_slave_driver
[   23.905126] initcall w1_init+0x0/0xcd returned 0 after 0 usecs
[   23.905131] calling  matrox_w1_init+0x0/0x42 @ 1
[   23.905144] bus: 'pci': add driver matrox_w1
[   23.905432] initcall matrox_w1_init+0x0/0x42 returned 0 after 0 usecs
[   23.905437] calling  ds_init+0x0/0x65 @ 1
[   23.905445] bus: 'usb': add driver DS9490R
[   23.905664] usbcore: registered new interface driver DS9490R
[   23.905675] initcall ds_init+0x0/0x65 returned 0 after 0 usecs
[   23.905679] calling  sensors_ds2482_init+0x0/0x3b @ 1
[   23.905684] bus: 'i2c': add driver ds2482
[   23.905953] initcall sensors_ds2482_init+0x0/0x3b returned 0 after 0 usecs
[   23.905957] calling  w1_therm_init+0x0/0x5b @ 1
[   23.906032] initcall w1_therm_init+0x0/0x5b returned 0 after 0 usecs
[   23.906036] calling  w1_smem_init+0x0/0x65 @ 1
[   23.906041] initcall w1_smem_init+0x0/0x65 returned 0 after 0 usecs
[   23.906045] calling  w1_f2d_init+0x0/0x39 @ 1
[   23.906049] initcall w1_f2d_init+0x0/0x39 returned 0 after 0 usecs
[   23.906053] calling  w1_ds2760_init+0x0/0x51 @ 1
[   23.906055] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   23.906061] initcall w1_ds2760_init+0x0/0x51 returned 0 after 0 usecs
[   23.906065] calling  w1_bq27000_init+0x0/0x49 @ 1
[   23.906069] initcall w1_bq27000_init+0x0/0x49 returned -17 after 0 usecs
[   23.906074] initcall w1_bq27000_init+0x0/0x49 returned with error code -17 
[   23.906078] calling  pda_power_init+0x0/0x39 @ 1
[   23.906084] bus: 'platform': add driver pda-power
[   23.906308] initcall pda_power_init+0x0/0x39 returned 0 after 0 usecs
[   23.906312] calling  ds2760_battery_init+0x0/0x39 @ 1
[   23.906316] bus: 'platform': add driver ds2760-battery
[   23.906595] initcall ds2760_battery_init+0x0/0x39 returned 0 after 0 usecs
[   23.906600] calling  bq27x00_battery_init+0x0/0x57 @ 1
[   23.906605] bus: 'i2c': add driver bq27200-battery
[   23.906817] initcall bq27x00_battery_init+0x0/0x57 returned 0 after 0 usecs
[   23.906822] calling  da903x_battery_init+0x0/0x3e @ 1
[   23.906827] bus: 'platform': add driver da903x-battery
[   23.907070] initcall da903x_battery_init+0x0/0x3e returned 0 after 0 usecs
[   23.907075] calling  max17040_init+0x0/0x3b @ 1
[   23.907078] bus: 'i2c': add driver max17040
[   23.907291] initcall max17040_init+0x0/0x3b returned 0 after 0 usecs
[   23.907295] calling  pcipcwd_init_module+0x0/0x5c @ 1
[   23.907313] bus: 'pci': add driver pcwd_pci
[   23.907592] initcall pcipcwd_init_module+0x0/0x5c returned 0 after 0 usecs
[   23.907596] calling  wdtpci_init+0x0/0x42 @ 1
[   23.907603] bus: 'pci': add driver wdt_pci
[   23.907864] initcall wdtpci_init+0x0/0x42 returned 0 after 0 usecs
[   23.907868] calling  usb_pcwd_init+0x0/0x70 @ 1
[   23.907879] bus: 'usb': add driver pcwd_usb
[   23.908125] usbcore: registered new interface driver pcwd_usb
[   23.908131] pcwd_usb: Berkshire USB-PC Watchdog driver v1.02
[   23.908136] initcall usb_pcwd_init+0x0/0x70 returned 0 after 0 usecs
[   23.908142] calling  twl4030_wdt_init+0x0/0x3e @ 1
[   23.908147] bus: 'platform': add driver twl4030_wdt
[   23.908361] initcall twl4030_wdt_init+0x0/0x3e returned 0 after 0 usecs
[   23.908365] calling  advwdt_init+0x0/0x83 @ 1
[   23.908368] WDT driver for Advantech single board computer initialising.
[   23.908372] bus: 'platform': add driver advantechwdt
[   23.908622] Registering platform device 'advantechwdt'. Parent at platform
[   23.908628] device: 'advantechwdt': device_add
[   23.908641] bus: 'platform': add device advantechwdt
[   23.908881] bus: 'platform': driver_probe_device: matched device advantechwdt with driver advantechwdt
[   23.908886] bus: 'platform': really_probe: probing driver advantechwdt with device advantechwdt
[   23.908908] device: 'watchdog': device_add
[   23.909178] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[   23.909182] driver: 'advantechwdt': driver_bound: bound to device 'advantechwdt'
[   23.909186] bus: 'platform': really_probe: bound device advantechwdt to driver advantechwdt
[   23.909195] initcall advwdt_init+0x0/0x83 returned 0 after 0 usecs
[   23.909199] calling  watchdog_init+0x0/0x18d @ 1
[   23.909223] initcall watchdog_init+0x0/0x18d returned -19 after 0 usecs
[   23.909227] calling  alim7101_wdt_init+0x0/0x1b7 @ 1
[   23.909229] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   23.909239] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   23.909243] initcall alim7101_wdt_init+0x0/0x1b7 returned -16 after 0 usecs
[   23.909246] initcall alim7101_wdt_init+0x0/0x1b7 returned with error code -16 
[   23.909250] calling  wafwdt_init+0x0/0x18e @ 1
[   23.909252] WDT driver for Wafer 5823 single board computer initialising.
[   23.909259] Wafer 5823 WDT: I/O address 0x0443 already in use
[   23.909265] initcall wafwdt_init+0x0/0x18e returned -5 after 0 usecs
[   23.909268] initcall wafwdt_init+0x0/0x18e returned with error code -5 
[   23.909272] calling  watchdog_init+0x0/0x8a @ 1
[   23.909274] i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
[   23.909278] bus: 'platform': add driver i6300ESB timer
[   23.909525] Registering platform device 'i6300ESB timer'. Parent at platform
[   23.909530] device: 'i6300ESB timer': device_add
[   23.909541] bus: 'platform': add device i6300ESB timer
[   23.909803] bus: 'platform': driver_probe_device: matched device i6300ESB timer with driver i6300ESB timer
[   23.909808] bus: 'platform': really_probe: probing driver i6300ESB timer with device i6300ESB timer
[   23.909849] initcall watchdog_init+0x0/0x8a returned 0 after 0 usecs
[   23.909853] calling  iTCO_wdt_init_module+0x0/0x8a @ 1
[   23.909855] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   23.909859] bus: 'platform': add driver iTCO_wdt
[   23.910131] Registering platform device 'iTCO_wdt'. Parent at platform
[   23.910137] device: 'iTCO_wdt': device_add
[   23.910148] bus: 'platform': add device iTCO_wdt
[   23.910399] bus: 'platform': driver_probe_device: matched device iTCO_wdt with driver iTCO_wdt
[   23.910403] bus: 'platform': really_probe: probing driver iTCO_wdt with device iTCO_wdt
[   23.910497] iTCO_wdt: No card detected
[   23.910514] initcall iTCO_wdt_init_module+0x0/0x8a returned 0 after 9765 usecs
[   23.910518] calling  it87_wdt_init+0x0/0x4ee @ 1
[   23.910597] IT87 WDT: Unsupported Chip found, Chip 8712 Revision 07
[   23.910601] initcall it87_wdt_init+0x0/0x4ee returned -19 after 0 usecs
[   23.910605] calling  hpwdt_init+0x0/0x42 @ 1
[   23.910626] bus: 'pci': add driver hpwdt
[   23.910923] initcall hpwdt_init+0x0/0x42 returned 0 after 0 usecs
[   23.910927] calling  pc87413_init+0x0/0xb5 @ 1
[   23.910930] pc87413 WDT: Version 1.1 at io 0x2E
[   23.910934] pc87413 WDT: cannot register miscdev on minor=130 (err=-16)
[   23.910939] initcall pc87413_init+0x0/0xb5 returned -16 after 0 usecs
[   23.910943] initcall pc87413_init+0x0/0xb5 returned with error code -16 
[   23.910947] calling  sbc60xxwdt_init+0x0/0x1ab @ 1
[   23.910955] sbc60xxwdt: I/O address 0x0443 already in use
[   23.910959] initcall sbc60xxwdt_init+0x0/0x1ab returned -5 after 0 usecs
[   23.910964] initcall sbc60xxwdt_init+0x0/0x1ab returned with error code -5 
[   23.910968] calling  sbc8360_init+0x0/0x1ca @ 1
[   23.910973] sbc8360: failed to register misc device
[   23.910981] initcall sbc8360_init+0x0/0x1ca returned -16 after 0 usecs
[   23.910985] initcall sbc8360_init+0x0/0x1ca returned with error code -16 
[   23.910989] calling  sch311x_wdt_init+0x0/0x176 @ 1
[   23.911017] initcall sch311x_wdt_init+0x0/0x176 returned -19 after 0 usecs
[   23.911022] calling  wb_smsc_wdt_init+0x0/0x1de @ 1
[   23.911024] SMsC 37B787 watchdog component driver 1.1 initialising...
[   23.912089] smsc37b787_wdt: Unable to register miscdev on minor 130
[   23.912096] initcall wb_smsc_wdt_init+0x0/0x1de returned -16 after 0 usecs
[   23.912100] initcall wb_smsc_wdt_init+0x0/0x1de returned with error code -16 
[   23.912105] calling  w83877f_wdt_init+0x0/0x183 @ 1
[   23.912111] w83877f_wdt: I/O address 0x0443 already in use
[   23.912118] initcall w83877f_wdt_init+0x0/0x183 returned -5 after 0 usecs
[   23.912122] initcall w83877f_wdt_init+0x0/0x183 returned with error code -5 
[   23.912126] calling  watchdog_init+0x0/0xde @ 1
[   23.912131] epx_c3: cannot register miscdev on minor=130 (err=-16)
[   23.912137] initcall watchdog_init+0x0/0xde returned -16 after 0 usecs
[   23.912141] initcall watchdog_init+0x0/0xde returned with error code -16 
[   23.912145] calling  watchdog_init+0x0/0xdb @ 1
[   23.912148] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   23.912153] initcall watchdog_init+0x0/0xdb returned -16 after 0 usecs
[   23.912157] initcall watchdog_init+0x0/0xdb returned with error code -16 
[   23.912161] calling  telephony_init+0x0/0x71 @ 1
[   23.912163] Linux telephony interface: v1.00
[   23.912175] initcall telephony_init+0x0/0x71 returned 0 after 0 usecs
[   23.912178] calling  vhci_init+0x0/0x73 @ 1
[   23.912181] Bluetooth: Virtual HCI driver ver 1.3
[   23.912191] device: 'vhci': device_add
[   23.912476] initcall vhci_init+0x0/0x73 returned 0 after 0 usecs
[   23.912480] calling  hci_uart_init+0x0/0x109 @ 1
[   23.912483] Bluetooth: HCI UART driver ver 2.2
[   23.912486] Bluetooth: HCI H4 protocol initialized
[   23.912489] Bluetooth: HCILL protocol initialized
[   23.912493] initcall hci_uart_init+0x0/0x109 returned 0 after 0 usecs
[   23.912497] calling  bpa10x_init+0x0/0x55 @ 1
[   23.912499] Bluetooth: Digianswer Bluetooth USB driver ver 0.10
[   23.912510] bus: 'usb': add driver bpa10x
[   23.912728] usbcore: registered new interface driver bpa10x
[   23.912737] initcall bpa10x_init+0x0/0x55 returned 0 after 0 usecs
[   23.912741] calling  bfusb_init+0x0/0x78 @ 1
[   23.912743] Bluetooth: BlueFRITZ! USB driver ver 1.2
[   23.912748] bus: 'usb': add driver bfusb
[   23.912992] usbcore: registered new interface driver bfusb
[   23.913000] initcall bfusb_init+0x0/0x78 returned 0 after 0 usecs
[   23.913004] calling  btusb_init+0x0/0x55 @ 1
[   23.913007] Bluetooth: Generic Bluetooth USB driver ver 0.5
[   23.913012] bus: 'usb': add driver btusb
[   23.913235] usbcore: registered new interface driver btusb
[   23.913244] initcall btusb_init+0x0/0x55 returned 0 after 0 usecs
[   23.913248] calling  btsdio_init+0x0/0x4c @ 1
[   23.913250] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   23.913255] bus: 'sdio': add driver btsdio
[   23.913508] initcall btsdio_init+0x0/0x4c returned 0 after 0 usecs
[   23.913513] calling  isdn_init+0x0/0x35c @ 1
[   23.916520] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/none/1.1.2.2
[   23.916536] initcall isdn_init+0x0/0x35c returned 0 after 0 usecs
[   23.916540] calling  isdn_bsdcomp_init+0x0/0x55 @ 1
[   23.916542] PPP BSD Compression module registered
[   23.916546] initcall isdn_bsdcomp_init+0x0/0x55 returned 0 after 0 usecs
[   23.916549] calling  divert_init+0x0/0x8a @ 1
[   23.916583] dss1_divert module successfully installed
[   23.916587] initcall divert_init+0x0/0x8a returned 0 after 0 usecs
[   23.916590] calling  cpufreq_stats_init+0x0/0xca @ 1
[   23.916669] initcall cpufreq_stats_init+0x0/0xca returned 0 after 0 usecs
[   23.916673] calling  cpufreq_gov_userspace_init+0x0/0x39 @ 1
[   23.916678] initcall cpufreq_gov_userspace_init+0x0/0x39 returned 0 after 0 usecs
[   23.916682] calling  cpufreq_gov_dbs_init+0x0/0xd5 @ 1
[   23.921086] initcall cpufreq_gov_dbs_init+0x0/0xd5 returned 0 after 9765 usecs
[   23.921091] calling  i7300_idle_init+0x0/0x649 @ 1
[   23.921183] initcall i7300_idle_init+0x0/0x649 returned -19 after 0 usecs
[   23.921187] calling  mmc_test_init+0x0/0x39 @ 1
[   23.921192] bus: 'mmc': add driver mmc_test
[   23.923942] initcall mmc_test_init+0x0/0x39 returned 0 after 0 usecs
[   23.923947] calling  sdio_uart_init+0x0/0x11a @ 1
[   23.923979] bus: 'sdio': add driver sdio_uart
[   23.924202] initcall sdio_uart_init+0x0/0x11a returned 0 after 0 usecs
[   23.924207] calling  wbsd_drv_init+0x0/0xb5 @ 1
[   23.924209] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   23.924212] wbsd: Copyright(c) Pierre Ossman
[   23.924220] bus: 'platform': add driver wbsd
[   23.924478] Registering platform device 'wbsd'. Parent at platform
[   23.924484] device: 'wbsd': device_add
[   23.924498] bus: 'platform': add device wbsd
[   23.924725] bus: 'platform': driver_probe_device: matched device wbsd with driver wbsd
[   23.924729] bus: 'platform': really_probe: probing driver wbsd with device wbsd
[   23.924965] initcall wbsd_drv_init+0x0/0xb5 returned 0 after 0 usecs
[   23.924969] calling  memstick_init+0x0/0xab @ 1
[   23.925344] bus: 'memstick': registered
[   23.925347] device class 'memstick_host': registering
[   23.925592] initcall memstick_init+0x0/0xab returned 0 after 0 usecs
[   23.925597] calling  tifm_ms_init+0x0/0x39 @ 1
[   23.925601] bus: 'tifm': add driver tifm_ms
[   23.925821] initcall tifm_ms_init+0x0/0x39 returned 0 after 0 usecs
[   23.925825] calling  bd2802_init+0x0/0x3b @ 1
[   23.925831] bus: 'i2c': add driver BD2802
[   23.926080] initcall bd2802_init+0x0/0x3b returned 0 after 0 usecs
[   23.926085] calling  alix_led_init+0x0/0x132 @ 1
[   23.931221] initcall alix_led_init+0x0/0x132 returned -19 after 9765 usecs
[   23.931225] calling  pca9532_init+0x0/0x3b @ 1
[   23.931229] bus: 'i2c': add driver pca9532
[   23.931449] initcall pca9532_init+0x0/0x3b returned 0 after 0 usecs
[   23.931453] calling  gpio_led_init+0x0/0x2d @ 1
[   23.931457] initcall gpio_led_init+0x0/0x2d returned 0 after 0 usecs
[   23.931461] calling  dac124s085_leds_init+0x0/0x39 @ 1
[   23.931467] bus: 'spi': add driver dac124s085
[   23.931710] initcall dac124s085_leds_init+0x0/0x39 returned 0 after 0 usecs
[   23.931715] calling  timer_trig_init+0x0/0x39 @ 1
[   23.931723] initcall timer_trig_init+0x0/0x39 returned 0 after 0 usecs
[   23.931727] calling  heartbeat_trig_init+0x0/0x39 @ 1
[   23.931733] initcall heartbeat_trig_init+0x0/0x39 returned 0 after 0 usecs
[   23.931737] calling  gpio_trig_init+0x0/0x39 @ 1
[   23.931742] initcall gpio_trig_init+0x0/0x39 returned 0 after 0 usecs
[   23.931746] calling  ib_core_init+0x0/0x6a @ 1
[   23.931748] device class 'infiniband': registering
[   23.931998] initcall ib_core_init+0x0/0x6a returned 0 after 0 usecs
[   23.932002] calling  ib_mad_init_module+0x0/0xca @ 1
[   23.932521] initcall ib_mad_init_module+0x0/0xca returned 0 after 0 usecs
[   23.932525] calling  ib_sa_init+0x0/0xc1 @ 1
[   23.932625] initcall ib_sa_init+0x0/0xc1 returned 0 after 0 usecs
[   23.932629] calling  ib_cm_init+0x0/0x180 @ 1
[   23.932703] device class 'infiniband_cm': registering
[   23.950396] initcall ib_cm_init+0x0/0x180 returned 0 after 19531 usecs
[   23.950402] calling  iw_cm_init+0x0/0x5c @ 1
[   23.950487] initcall iw_cm_init+0x0/0x5c returned 0 after 0 usecs
[   23.950492] calling  addr_init+0x0/0x6d @ 1
[   23.950628] initcall addr_init+0x0/0x6d returned 0 after 0 usecs
[   23.950632] calling  cma_init+0x0/0x108 @ 1
[   23.950731] initcall cma_init+0x0/0x108 returned 0 after 0 usecs
[   23.950735] calling  mthca_init+0x0/0x1a7 @ 1
[   23.950837] bus: 'pci': add driver ib_mthca
[   23.951197] initcall mthca_init+0x0/0x1a7 returned 0 after 0 usecs
[   23.951201] calling  infinipath_init+0x0/0xe9 @ 1
[   23.951255] bus: 'pci': add driver ib_ipath
[   23.951511] initcall infinipath_init+0x0/0xe9 returned 0 after 0 usecs
[   23.951515] calling  c2_init_module+0x0/0x42 @ 1
[   23.951522] bus: 'pci': add driver c2
[   23.951801] initcall c2_init_module+0x0/0x42 returned 0 after 0 usecs
[   23.951805] calling  nes_init_module+0x0/0x17f @ 1
[   23.952051] bus: 'pci': add driver iw_nes
[   23.952328] initcall nes_init_module+0x0/0x17f returned 0 after 0 usecs
[   23.952333] calling  ipoib_init_module+0x0/0x12d @ 1
[   23.952464] initcall ipoib_init_module+0x0/0x12d returned 0 after 0 usecs
[   23.952469] calling  srp_init_module+0x0/0x116 @ 1
[   23.952479] device class 'infiniband_srp': registering
[   23.952705] initcall srp_init_module+0x0/0x116 returned 0 after 0 usecs
[   23.952710] calling  dcdrbu_init+0x0/0x169 @ 1
[   23.952733] Registering platform device 'dell_rbu'. Parent at platform
[   23.952747] device: 'dell_rbu': device_add
[   23.952762] bus: 'platform': add device dell_rbu
[   23.953051] initcall dcdrbu_init+0x0/0x169 returned 0 after 0 usecs
[   23.953056] calling  dcdbas_init+0x0/0x8d @ 1
[   23.953063] bus: 'platform': add driver dcdbas
[   23.953284] Registering platform device 'dcdbas'. Parent at platform
[   23.953289] device: 'dcdbas': device_add
[   23.953300] bus: 'platform': add device dcdbas
[   23.953552] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   23.953556] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   23.953586] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   23.953590] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   23.953594] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   23.953602] initcall dcdbas_init+0x0/0x8d returned 0 after 0 usecs
[   23.953605] calling  hifn_init+0x0/0x3e @ 1
[   23.953607] HIFN supports only 32-bit addresses.
[   23.953611] initcall hifn_init+0x0/0x3e returned -22 after 0 usecs
[   23.953614] initcall hifn_init+0x0/0x3e returned with error code -22 
[   23.953618] calling  ioat_init_module+0x0/0x42 @ 1
[   23.953633] bus: 'pci': add driver ioatdma
[   23.953892] initcall ioat_init_module+0x0/0x42 returned 0 after 0 usecs
[   23.953897] calling  hid_init+0x0/0x55 @ 1
[   23.954173] bus: 'hid': registered
[   23.954177] initcall hid_init+0x0/0x55 returned 0 after 0 usecs
[   23.954183] calling  apple_init+0x0/0x63 @ 1
[   23.954187] bus: 'hid': add driver apple
[   23.954396] initcall apple_init+0x0/0x63 returned 0 after 0 usecs
[   23.954401] calling  belkin_init+0x0/0x47 @ 1
[   23.954404] bus: 'hid': add driver belkin
[   23.954648] initcall belkin_init+0x0/0x47 returned 0 after 0 usecs
[   23.954652] calling  ch_init+0x0/0x47 @ 1
[   23.954656] bus: 'hid': add driver cherry
[   23.954864] initcall ch_init+0x0/0x47 returned 0 after 0 usecs
[   23.954869] calling  dr_init+0x0/0x42 @ 1
[   23.954872] bus: 'hid': add driver dragonrise
[   23.955141] initcall dr_init+0x0/0x42 returned 0 after 0 usecs
[   23.955145] calling  ez_init+0x0/0x47 @ 1
[   23.955149] bus: 'hid': add driver ezkey
[   23.955368] initcall ez_init+0x0/0x47 returned 0 after 0 usecs
[   23.955372] calling  gyration_init+0x0/0x47 @ 1
[   23.955376] bus: 'hid': add driver gyration
[   23.955619] initcall gyration_init+0x0/0x47 returned 0 after 0 usecs
[   23.955623] calling  ks_init+0x0/0x47 @ 1
[   23.955627] bus: 'hid': add driver kensington
[   23.955837] initcall ks_init+0x0/0x47 returned 0 after 0 usecs
[   23.955841] calling  lg_init+0x0/0x47 @ 1
[   23.955845] bus: 'hid': add driver logitech
[   23.956087] initcall lg_init+0x0/0x47 returned 0 after 0 usecs
[   23.956092] calling  ms_init+0x0/0x47 @ 1
[   23.956096] bus: 'hid': add driver microsoft
[   23.956318] initcall ms_init+0x0/0x47 returned 0 after 0 usecs
[   23.956322] calling  mr_init+0x0/0x47 @ 1
[   23.956326] bus: 'hid': add driver monterey
[   23.956578] initcall mr_init+0x0/0x47 returned 0 after 0 usecs
[   23.956583] calling  ntrig_init+0x0/0x47 @ 1
[   23.956587] bus: 'hid': add driver ntrig
[   23.956808] initcall ntrig_init+0x0/0x47 returned 0 after 0 usecs
[   23.956812] calling  sony_init+0x0/0x47 @ 1
[   23.956816] bus: 'hid': add driver sony
[   23.957073] initcall sony_init+0x0/0x47 returned 0 after 0 usecs
[   23.957078] calling  sp_init+0x0/0x47 @ 1
[   23.957082] bus: 'hid': add driver sunplus
[   23.957292] initcall sp_init+0x0/0x47 returned 0 after 0 usecs
[   23.957296] calling  tm_init+0x0/0x47 @ 1
[   23.957300] bus: 'hid': add driver thrustmaster
[   23.957577] initcall tm_init+0x0/0x47 returned 0 after 0 usecs
[   23.957581] calling  ts_init+0x0/0x47 @ 1
[   23.957585] bus: 'hid': add driver topseed
[   23.957793] initcall ts_init+0x0/0x47 returned 0 after 0 usecs
[   23.957798] calling  zp_init+0x0/0x47 @ 1
[   23.957801] bus: 'hid': add driver zeroplus
[   23.958064] initcall zp_init+0x0/0x47 returned 0 after 0 usecs
[   23.958068] calling  wacom_init+0x0/0x71 @ 1
[   23.958072] bus: 'hid': add driver wacom
[   23.958278] wacom driver registered
[   23.958283] initcall wacom_init+0x0/0x71 returned 0 after 0 usecs
[   23.958288] calling  hid_init+0x0/0xf1 @ 1
[   23.958419] bus: 'hid': add driver generic-usb
[   23.958688] bus: 'usb': add driver hiddev
[   23.958943] usbcore: registered new interface driver hiddev
[   23.958963] bus: 'usb': add driver usbhid
[   23.959171] usbcore: registered new interface driver usbhid
[   23.959177] usbhid: v2.6:USB HID core driver
[   23.959183] initcall hid_init+0x0/0xf1 returned 0 after 0 usecs
[   23.959187] calling  usb_mouse_init+0x0/0x5e @ 1
[   23.959192] bus: 'usb': add driver usbmouse
[   23.959444] usbcore: registered new interface driver usbmouse
[   23.959451] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[   23.959456] initcall usb_mouse_init+0x0/0x5e returned 0 after 0 usecs
[   23.959460] calling  virtio_pci_init+0x0/0x7b @ 1
[   23.959471] device: 'virtio-pci': device_add
[   23.959505] bus: 'pci': add driver virtio-pci
[   23.959766] initcall virtio_pci_init+0x0/0x7b returned 0 after 0 usecs
[   23.959770] calling  dell_init+0x0/0x32 @ 1
[   23.959774] initcall dell_init+0x0/0x32 returned -19 after 0 usecs
[   23.959778] calling  init_soundcore+0x0/0xa5 @ 1
[   23.959791] device class 'sound': registering
[   23.960111] initcall init_soundcore+0x0/0xa5 returned 0 after 9765 usecs
[   23.960116] calling  alsa_sound_init+0x0/0xba @ 1
[   23.960281] Advanced Linux Sound Architecture Driver Version 1.0.20.
[   23.960287] initcall alsa_sound_init+0x0/0xba returned 0 after 0 usecs
[   23.960291] calling  alsa_hwdep_init+0x0/0x8a @ 1
[   23.960343] initcall alsa_hwdep_init+0x0/0x8a returned 0 after 0 usecs
[   23.960348] calling  alsa_timer_init+0x0/0x1a6 @ 1
[   23.960405] device: 'timer': device_add
[   23.960715] initcall alsa_timer_init+0x0/0x1a6 returned 0 after 0 usecs
[   23.960720] calling  rtctimer_init+0x0/0x148 @ 1
[   23.960728] initcall rtctimer_init+0x0/0x148 returned 0 after 0 usecs
[   23.960732] calling  alsa_pcm_init+0x0/0x92 @ 1
[   23.960749] initcall alsa_pcm_init+0x0/0x92 returned 0 after 0 usecs
[   23.960753] calling  snd_mem_init+0x0/0x53 @ 1
[   23.960767] initcall snd_mem_init+0x0/0x53 returned 0 after 0 usecs
[   23.960771] calling  alsa_rawmidi_init+0x0/0xcb @ 1
[   23.960778] initcall alsa_rawmidi_init+0x0/0xcb returned 0 after 0 usecs
[   23.960782] calling  alsa_mixer_oss_init+0x0/0x63 @ 1
[   23.960787] initcall alsa_mixer_oss_init+0x0/0x63 returned 0 after 0 usecs
[   23.960791] calling  alsa_pcm_oss_init+0x0/0xc8 @ 1
[   23.960809] initcall alsa_pcm_oss_init+0x0/0xc8 returned 0 after 0 usecs
[   23.960813] calling  alsa_akm4xxx_module_init+0x0/0x2d @ 1
[   23.960818] initcall alsa_akm4xxx_module_init+0x0/0x2d returned 0 after 0 usecs
[   23.960822] calling  alsa_tea575x_module_init+0x0/0x2d @ 1
[   23.960827] initcall alsa_tea575x_module_init+0x0/0x2d returned 0 after 0 usecs
[   23.960831] calling  alsa_i2c_init+0x0/0x2d @ 1
[   23.960835] initcall alsa_i2c_init+0x0/0x2d returned 0 after 0 usecs
[   23.960839] calling  alsa_opl3_init+0x0/0x2d @ 1
[   23.960843] initcall alsa_opl3_init+0x0/0x2d returned 0 after 0 usecs
[   23.960848] calling  alsa_mpu401_uart_init+0x0/0x2d @ 1
[   23.960852] initcall alsa_mpu401_uart_init+0x0/0x2d returned 0 after 0 usecs
[   23.960856] calling  alsa_sb_common_init+0x0/0x2d @ 1
[   23.960860] initcall alsa_sb_common_init+0x0/0x2d returned 0 after 0 usecs
[   23.960865] calling  alsa_sb16_init+0x0/0x2d @ 1
[   23.960869] initcall alsa_sb16_init+0x0/0x2d returned 0 after 0 usecs
[   23.960873] calling  alsa_ad1889_init+0x0/0x42 @ 1
[   23.960890] bus: 'pci': add driver AD1889 Audio
[   23.961234] initcall alsa_ad1889_init+0x0/0x42 returned 0 after 0 usecs
[   23.961238] calling  alsa_card_als4000_init+0x0/0x42 @ 1
[   23.961247] bus: 'pci': add driver ALS4000
[   23.961481] initcall alsa_card_als4000_init+0x0/0x42 returned 0 after 0 usecs
[   23.961486] calling  alsa_card_atiixp_init+0x0/0x42 @ 1
[   23.961493] bus: 'pci': add driver ATI IXP MC97 controller
[   23.961757] initcall alsa_card_atiixp_init+0x0/0x42 returned 0 after 0 usecs
[   23.961762] calling  alsa_card_bt87x_init+0x0/0x56 @ 1
[   23.961770] bus: 'pci': add driver Bt87x
[   23.962006] initcall alsa_card_bt87x_init+0x0/0x56 returned 0 after 0 usecs
[   23.962011] calling  alsa_card_cmipci_init+0x0/0x42 @ 1
[   23.962019] bus: 'pci': add driver C-Media PCI
[   23.962307] initcall alsa_card_cmipci_init+0x0/0x42 returned 0 after 0 usecs
[   23.962312] calling  alsa_card_cs5530_init+0x0/0x42 @ 1
[   23.962319] bus: 'pci': add driver CS5530_Audio
[   23.962555] initcall alsa_card_cs5530_init+0x0/0x42 returned 0 after 0 usecs
[   23.962560] calling  alsa_card_es1968_init+0x0/0x42 @ 1
[   23.962568] bus: 'pci': add driver ES1968 (ESS Maestro)
[   23.962857] initcall alsa_card_es1968_init+0x0/0x42 returned 0 after 0 usecs
[   23.962862] calling  alsa_card_fm801_init+0x0/0x42 @ 1
[   23.962870] bus: 'pci': add driver FM801
[   23.963108] initcall alsa_card_fm801_init+0x0/0x42 returned 0 after 0 usecs
[   23.963113] calling  alsa_card_intel8x0_init+0x0/0x42 @ 1
[   23.963121] bus: 'pci': add driver Intel ICH
[   23.963143] bus: 'pci': driver_probe_device: matched device 0000:00:04.0 with driver Intel ICH
[   23.963147] bus: 'pci': really_probe: probing driver Intel ICH with device 0000:00:04.0
[   23.963382] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
[   23.963392] Intel ICH 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 3
[   23.963441] Intel ICH 0000:00:04.0: setting latency timer to 64
[   24.300018] intel8x0_measure_ac97_clock: measured 60000 usecs (2936 samples)
[   24.300021] intel8x0: clocking to 47084
[   24.300053] device: 'pcmC0D2p': device_add
[   24.300473] device: 'pcmC0D1c': device_add
[   24.300774] device: 'adsp': device_add
[   24.301033] device: 'pcmC0D0p': device_add
[   24.301292] device: 'pcmC0D0c': device_add
[   24.301538] device: 'dsp': device_add
[   24.301809] device: 'audio': device_add
[   24.302081] device: '0-0:ALC850': device_add
[   24.302101] bus: 'ac97': add device 0-0:ALC850
[   24.302361] device: 'controlC0': device_add
[   24.302664] device: 'mixer': device_add
[   24.303581] driver: '0000:00:04.0': driver_bound: bound to device 'Intel ICH'
[   24.303588] bus: 'pci': really_probe: bound device 0000:00:04.0 to driver Intel ICH
[   24.303833] initcall alsa_card_intel8x0_init+0x0/0x42 returned 0 after 332031 usecs
[   24.303839] calling  alsa_card_m3_init+0x0/0x42 @ 1
[   24.303862] bus: 'pci': add driver Maestro3
[   24.304185] initcall alsa_card_m3_init+0x0/0x42 returned 0 after 0 usecs
[   24.304190] calling  alsa_card_rme96_init+0x0/0x42 @ 1
[   24.304198] bus: 'pci': add driver RME Digi96
[   24.304433] initcall alsa_card_rme96_init+0x0/0x42 returned 0 after 0 usecs
[   24.304438] calling  alsa_card_via82xx_init+0x0/0x42 @ 1
[   24.304445] bus: 'pci': add driver VIA 82xx Audio
[   24.304713] initcall alsa_card_via82xx_init+0x0/0x42 returned 0 after 0 usecs
[   24.304718] calling  alsa_card_via82xx_init+0x0/0x42 @ 1
[   24.304726] bus: 'pci': add driver VIA 82xx Modem
[   24.304961] initcall alsa_card_via82xx_init+0x0/0x42 returned 0 after 0 usecs
[   24.304966] calling  alsa_ac97_init+0x0/0x2d @ 1
[   24.304970] initcall alsa_ac97_init+0x0/0x2d returned 0 after 0 usecs
[   24.304974] calling  alsa_card_ali_init+0x0/0x42 @ 1
[   24.304982] bus: 'pci': add driver ALI 5451
[   24.305259] initcall alsa_card_ali_init+0x0/0x42 returned 0 after 0 usecs
[   24.305264] calling  alsa_card_vortex_init+0x0/0x42 @ 1
[   24.305272] bus: 'pci': add driver au8810
[   24.305507] initcall alsa_card_vortex_init+0x0/0x42 returned 0 after 0 usecs
[   24.305512] calling  alsa_card_vortex_init+0x0/0x42 @ 1
[   24.305520] bus: 'pci': add driver au8830
[   24.305803] initcall alsa_card_vortex_init+0x0/0x42 returned 0 after 0 usecs
[   24.305808] calling  ct_card_init+0x0/0x42 @ 1
[   24.305815] bus: 'pci': add driver SB-XFi
[   24.306052] initcall ct_card_init+0x0/0x42 returned 0 after 0 usecs
[   24.306057] calling  alsa_card_ca0106_init+0x0/0x42 @ 1
[   24.306065] bus: 'pci': add driver CA0106
[   24.306334] initcall alsa_card_ca0106_init+0x0/0x42 returned 0 after 0 usecs
[   24.306339] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.306347] bus: 'pci': add driver Echoaudio Darla20
[   24.306604] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.306609] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.306617] bus: 'pci': add driver Echoaudio Gina20
[   24.306902] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.306906] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.306915] bus: 'pci': add driver Echoaudio Darla24
[   24.307150] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.307155] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.307163] bus: 'pci': add driver Echoaudio Layla24
[   24.307453] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.307458] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.307466] bus: 'pci': add driver Echoaudio Mia
[   24.307724] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.307729] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.307738] bus: 'pci': add driver Echoaudio Echo3G
[   24.308010] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.308015] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.308023] bus: 'pci': add driver Echoaudio Indigo DJ
[   24.308256] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.308261] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.308269] bus: 'pci': add driver Echoaudio Indigo IOx
[   24.308524] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.308529] calling  alsa_card_echo_init+0x0/0x42 @ 1
[   24.308537] bus: 'pci': add driver Echoaudio Indigo DJx
[   24.308787] initcall alsa_card_echo_init+0x0/0x42 returned 0 after 0 usecs
[   24.308792] calling  alsa_card_emu10k1_init+0x0/0x42 @ 1
[   24.308801] bus: 'pci': add driver EMU10K1_Audigy
[   24.309089] initcall alsa_card_emu10k1_init+0x0/0x42 returned 0 after 0 usecs
[   24.309094] calling  alsa_card_emu10k1x_init+0x0/0x42 @ 1
[   24.309103] bus: 'pci': add driver EMU10K1X
[   24.309341] initcall alsa_card_emu10k1x_init+0x0/0x42 returned 0 after 0 usecs
[   24.309346] calling  patch_cmedia_init+0x0/0x39 @ 1
[   24.309418] initcall patch_cmedia_init+0x0/0x39 returned 0 after 0 usecs
[   24.309423] calling  patch_sigmatel_init+0x0/0x39 @ 1
[   24.309428] initcall patch_sigmatel_init+0x0/0x39 returned 0 after 0 usecs
[   24.309432] calling  patch_ca0110_init+0x0/0x39 @ 1
[   24.309437] initcall patch_ca0110_init+0x0/0x39 returned 0 after 0 usecs
[   24.309441] calling  patch_nvhdmi_init+0x0/0x39 @ 1
[   24.309446] initcall patch_nvhdmi_init+0x0/0x39 returned 0 after 0 usecs
[   24.309450] calling  patch_intelhdmi_init+0x0/0x39 @ 1
[   24.309455] initcall patch_intelhdmi_init+0x0/0x39 returned 0 after 0 usecs
[   24.309460] calling  alsa_card_azx_init+0x0/0x42 @ 1
[   24.309471] bus: 'pci': add driver HDA Intel
[   24.309769] initcall alsa_card_azx_init+0x0/0x42 returned 0 after 0 usecs
[   24.309774] calling  alsa_card_ice1724_init+0x0/0x42 @ 1
[   24.309782] bus: 'pci': add driver ICE1724
[   24.310063] initcall alsa_card_ice1724_init+0x0/0x42 returned 0 after 9765 usecs
[   24.310069] calling  alsa_ice1712_akm4xxx_module_init+0x0/0x2d @ 1
[   24.310073] initcall alsa_ice1712_akm4xxx_module_init+0x0/0x2d returned 0 after 0 usecs
[   24.310078] calling  alsa_card_mixart_init+0x0/0x42 @ 1
[   24.310088] bus: 'pci': add driver Digigram miXart
[   24.310380] initcall alsa_card_mixart_init+0x0/0x42 returned 0 after 0 usecs
[   24.310385] calling  alsa_card_nm256_init+0x0/0x42 @ 1
[   24.310394] bus: 'pci': add driver NeoMagic 256
[   24.310670] initcall alsa_card_nm256_init+0x0/0x42 returned 0 after 0 usecs
[   24.310675] calling  alsa_card_hifier_init+0x0/0x42 @ 1
[   24.310683] bus: 'pci': add driver CMI8787HiFier
[   24.310957] initcall alsa_card_hifier_init+0x0/0x42 returned 0 after 0 usecs
[   24.310962] calling  alsa_card_oxygen_init+0x0/0x42 @ 1
[   24.310971] bus: 'pci': add driver CMI8788
[   24.311221] initcall alsa_card_oxygen_init+0x0/0x42 returned 0 after 0 usecs
[   24.311226] calling  alsa_card_xonar_init+0x0/0x42 @ 1
[   24.311235] bus: 'pci': add driver AV200
[   24.311518] initcall alsa_card_xonar_init+0x0/0x42 returned 0 after 0 usecs
[   24.311523] calling  pcxhr_module_init+0x0/0x42 @ 1
[   24.311532] bus: 'pci': add driver Digigram pcxhr
[   24.311772] initcall pcxhr_module_init+0x0/0x42 returned 0 after 0 usecs
[   24.311777] calling  alsa_card_riptide_init+0x0/0x77 @ 1
[   24.311785] bus: 'pci': add driver RIPTIDE
[   24.312071] bus: 'pci': add driver Riptide Joystick
[   24.312319] initcall alsa_card_riptide_init+0x0/0x77 returned 0 after 0 usecs
[   24.312325] calling  alsa_card_hammerfall_init+0x0/0x42 @ 1
[   24.312334] bus: 'pci': add driver RME Digi9652 (Hammerfall)
[   24.312618] initcall alsa_card_hammerfall_init+0x0/0x42 returned 0 after 0 usecs
[   24.312623] calling  alsa_card_hdsp_init+0x0/0x42 @ 1
[   24.312632] bus: 'pci': add driver RME Hammerfall DSP
[   24.312897] initcall alsa_card_hdsp_init+0x0/0x42 returned 0 after 0 usecs
[   24.312902] calling  alsa_card_hdspm_init+0x0/0x42 @ 1
[   24.312911] bus: 'pci': add driver RME Hammerfall DSP MADI
[   24.313186] initcall alsa_card_hdspm_init+0x0/0x42 returned 0 after 0 usecs
[   24.313191] calling  alsa_card_trident_init+0x0/0x42 @ 1
[   24.313200] bus: 'pci': add driver Trident4DWaveAudio
[   24.313440] initcall alsa_card_trident_init+0x0/0x42 returned 0 after 0 usecs
[   24.313445] calling  alsa_card_ymfpci_init+0x0/0x42 @ 1
[   24.313453] bus: 'pci': add driver Yamaha DS-1 PCI
[   24.313736] initcall alsa_card_ymfpci_init+0x0/0x42 returned 0 after 0 usecs
[   24.313741] calling  alsa_util_mem_init+0x0/0x2d @ 1
[   24.313746] initcall alsa_util_mem_init+0x0/0x2d returned 0 after 0 usecs
[   24.313750] calling  snd_usX2Y_module_init+0x0/0x42 @ 1
[   24.313763] bus: 'usb': add driver snd-usb-usx2y
[   24.313995] usbcore: registered new interface driver snd-usb-usx2y
[   24.314005] initcall snd_usX2Y_module_init+0x0/0x42 returned 0 after 0 usecs
[   24.314009] calling  snd_module_init+0x0/0x42 @ 1
[   24.314015] bus: 'usb': add driver snd-usb-caiaq
[   24.314261] usbcore: registered new interface driver snd-usb-caiaq
[   24.314270] initcall snd_module_init+0x0/0x42 returned 0 after 0 usecs
[   24.314274] calling  snd_soc_init+0x0/0x74 @ 1
[   24.314297] bus: 'platform': add driver soc-audio
[   24.314533] initcall snd_soc_init+0x0/0x74 returned 0 after 0 usecs
[   24.314538] calling  ad73311_init+0x0/0x39 @ 1
[   24.314541] No device for DAI AD73311
[   24.314608] initcall ad73311_init+0x0/0x39 returned 0 after 0 usecs
[   24.314613] calling  ak4104_init+0x0/0x45 @ 1
[   24.314615] Asahi Kasei AK4104 ALSA SoC Codec Driver
[   24.314621] bus: 'spi': add driver ak4104
[   24.314881] initcall ak4104_init+0x0/0x45 returned 0 after 0 usecs
[   24.314886] calling  ak4535_modinit+0x0/0x39 @ 1
[   24.314889] No device for DAI AK4535
[   24.314893] initcall ak4535_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.314898] calling  cs4270_init+0x0/0x47 @ 1
[   24.314900] Cirrus Logic CS4270 ALSA SoC Codec Driver
[   24.314906] bus: 'i2c': add driver cs4270
[   24.315144] initcall cs4270_init+0x0/0x47 returned 0 after 0 usecs
[   24.315149] calling  pcm3008_init+0x0/0x39 @ 1
[   24.315151] No device for DAI PCM3008 HiFi
[   24.315156] initcall pcm3008_init+0x0/0x39 returned 0 after 0 usecs
[   24.315161] calling  dit_modinit+0x0/0x39 @ 1
[   24.315166] bus: 'platform': add driver spdif-dit
[   24.315416] initcall dit_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.315421] calling  ssm2602_modinit+0x0/0x39 @ 1
[   24.315424] No device for DAI SSM2602
[   24.315428] initcall ssm2602_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.315433] calling  tlv320aic23_modinit+0x0/0x39 @ 1
[   24.315436] No device for DAI tlv320aic23
[   24.315440] initcall tlv320aic23_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.315445] calling  aic26_init+0x0/0x39 @ 1
[   24.315449] bus: 'spi': add driver tlv320aic26
[   24.315695] initcall aic26_init+0x0/0x39 returned 0 after 0 usecs
[   24.315699] calling  aic3x_modinit+0x0/0x39 @ 1
[   24.315702] No device for DAI tlv320aic3x
[   24.315707] initcall aic3x_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.315711] calling  twl4030_modinit+0x0/0x3e @ 1
[   24.315714] No device for DAI twl4030
[   24.315717] No device for DAI twl4030 Voice
[   24.315721] initcall twl4030_modinit+0x0/0x3e returned 0 after 0 usecs
[   24.315726] calling  uda134x_init+0x0/0x39 @ 1
[   24.315728] No device for DAI UDA134X
[   24.315733] initcall uda134x_init+0x0/0x39 returned 0 after 0 usecs
[   24.315737] calling  uda1380_modinit+0x0/0x3e @ 1
[   24.315740] No device for DAI UDA1380
[   24.315743] No device for DAI UDA1380
[   24.315745] No device for DAI UDA1380
[   24.315750] initcall uda1380_modinit+0x0/0x3e returned 0 after 0 usecs
[   24.315754] calling  wm8510_modinit+0x0/0x39 @ 1
[   24.315757] No device for DAI WM8510 HiFi
[   24.315761] initcall wm8510_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.315766] calling  wm8580_modinit+0x0/0x51 @ 1
[   24.315770] bus: 'i2c': add driver wm8580
[   24.316018] initcall wm8580_modinit+0x0/0x51 returned 0 after 0 usecs
[   24.316023] calling  wm8728_modinit+0x0/0x39 @ 1
[   24.316026] No device for DAI WM8728
[   24.316030] initcall wm8728_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.316035] calling  wm8731_modinit+0x0/0x71 @ 1
[   24.316039] bus: 'i2c': add driver WM8731 I2C Codec
[   24.316263] bus: 'spi': add driver wm8731
[   24.316507] initcall wm8731_modinit+0x0/0x71 returned 0 after 0 usecs
[   24.316513] calling  wm8750_modinit+0x0/0x39 @ 1
[   24.316515] No device for DAI WM8750
[   24.316520] initcall wm8750_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.316524] calling  wm8753_modinit+0x0/0x71 @ 1
[   24.316529] bus: 'i2c': add driver wm8753
[   24.316750] bus: 'spi': add driver wm8753
[   24.316995] initcall wm8753_modinit+0x0/0x71 returned 0 after 0 usecs
[   24.317001] calling  wm8900_modinit+0x0/0x3b @ 1
[   24.317005] bus: 'i2c': add driver WM8900
[   24.317240] initcall wm8900_modinit+0x0/0x3b returned 0 after 0 usecs
[   24.317245] calling  wm8903_modinit+0x0/0x3b @ 1
[   24.317249] bus: 'i2c': add driver WM8903
[   24.317495] initcall wm8903_modinit+0x0/0x3b returned 0 after 0 usecs
[   24.317500] calling  wm8971_modinit+0x0/0x39 @ 1
[   24.317503] No device for DAI WM8971
[   24.317508] initcall wm8971_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.317512] calling  wm8940_modinit+0x0/0x59 @ 1
[   24.317517] bus: 'i2c': add driver WM8940 I2C Codec
[   24.317733] initcall wm8940_modinit+0x0/0x59 returned 0 after 0 usecs
[   24.317738] calling  wm8960_modinit+0x0/0x59 @ 1
[   24.317742] bus: 'i2c': add driver WM8960 I2C Codec
[   24.318009] initcall wm8960_modinit+0x0/0x59 returned 0 after 0 usecs
[   24.318013] calling  wm8988_modinit+0x0/0x79 @ 1
[   24.318018] bus: 'i2c': add driver WM8988
[   24.318231] bus: 'spi': add driver wm8988
[   24.318499] initcall wm8988_modinit+0x0/0x79 returned 0 after 0 usecs
[   24.318504] calling  wm8990_modinit+0x0/0x39 @ 1
[   24.318506] No device for DAI WM8990 ADC/DAC Primary
[   24.318512] initcall wm8990_modinit+0x0/0x39 returned 0 after 0 usecs
[   24.318516] calling  wm9081_modinit+0x0/0x59 @ 1
[   24.318520] bus: 'i2c': add driver wm9081
[   24.318734] initcall wm9081_modinit+0x0/0x59 returned 0 after 0 usecs
[   24.318739] calling  alsa_sound_last_init+0x0/0x93 @ 1
[   24.318742] ALSA device list:
[   24.318744]   #0: NVidia CK804 with ALC850 at irq 3
[   24.318749] initcall alsa_sound_last_init+0x0/0x93 returned 0 after 0 usecs
[   24.318754] calling  flow_cache_init+0x0/0x1c9 @ 1
[   24.319248] initcall flow_cache_init+0x0/0x1c9 returned 0 after 0 usecs
[   24.319252] calling  llc_init+0x0/0x47 @ 1
[   24.319258] initcall llc_init+0x0/0x47 returned 0 after 0 usecs
[   24.319262] calling  snap_init+0x0/0x61 @ 1
[   24.319332] initcall snap_init+0x0/0x61 returned 0 after 0 usecs
[   24.319336] calling  sysctl_ipv4_init+0x0/0x74 @ 1
[   24.321697] initcall sysctl_ipv4_init+0x0/0x74 returned 0 after 9765 usecs
[   24.321702] calling  ipip_init+0x0/0x95 @ 1
[   24.321704] IPv4 over IPv4 tunneling driver
[   24.321802] device: 'tunl0': device_add
[   24.327530] initcall ipip_init+0x0/0x95 returned 0 after 0 usecs
[   24.327535] calling  ipgre_init+0x0/0xd7 @ 1
[   24.327537] GRE over IPv4 tunneling driver
[   24.327572] device: 'gre0': device_add
[   24.328830] initcall ipgre_init+0x0/0xd7 returned 0 after 0 usecs
[   24.328834] calling  ah4_init+0x0/0x8f @ 1
[   24.328839] initcall ah4_init+0x0/0x8f returned 0 after 0 usecs
[   24.328842] calling  ipcomp4_init+0x0/0x8f @ 1
[   24.328846] initcall ipcomp4_init+0x0/0x8f returned 0 after 0 usecs
[   24.328850] calling  ipip_init+0x0/0xc5 @ 1
[   24.328855] initcall ipip_init+0x0/0xc5 returned 0 after 0 usecs
[   24.328859] calling  tunnel4_init+0x0/0x8f @ 1
[   24.328863] initcall tunnel4_init+0x0/0x8f returned 0 after 0 usecs
[   24.328866] calling  xfrm4_mode_tunnel_init+0x0/0x3e @ 1
[   24.328870] initcall xfrm4_mode_tunnel_init+0x0/0x3e returned 0 after 0 usecs
[   24.328874] calling  tcp_westwood_register+0x0/0x39 @ 1
[   24.328878] TCP westwood registered
[   24.328881] initcall tcp_westwood_register+0x0/0x39 returned 0 after 0 usecs
[   24.328884] calling  hstcp_register+0x0/0x39 @ 1
[   24.328887] TCP highspeed registered
[   24.328890] initcall hstcp_register+0x0/0x39 returned 0 after 0 usecs
[   24.328894] calling  hybla_register+0x0/0x39 @ 1
[   24.328896] TCP hybla registered
[   24.328899] initcall hybla_register+0x0/0x39 returned 0 after 0 usecs
[   24.328902] calling  htcp_register+0x0/0x39 @ 1
[   24.328905] TCP htcp registered
[   24.328908] initcall htcp_register+0x0/0x39 returned 0 after 0 usecs
[   24.328911] calling  tcp_vegas_register+0x0/0x3b @ 1
[   24.328914] TCP vegas registered
[   24.328917] initcall tcp_vegas_register+0x0/0x3b returned 0 after 0 usecs
[   24.328921] calling  tcp_veno_register+0x0/0x3b @ 1
[   24.328923] TCP veno registered
[   24.328926] initcall tcp_veno_register+0x0/0x3b returned 0 after 0 usecs
[   24.328930] calling  tcp_scalable_register+0x0/0x39 @ 1
[   24.328932] TCP scalable registered
[   24.328936] initcall tcp_scalable_register+0x0/0x39 returned 0 after 0 usecs
[   24.328939] calling  tcp_yeah_register+0x0/0x3b @ 1
[   24.328942] TCP yeah registered
[   24.328945] initcall tcp_yeah_register+0x0/0x3b returned 0 after 0 usecs
[   24.328948] calling  inet6_init+0x0/0x2ec @ 1
[   24.331725] NET: Registered protocol family 10
[   24.335890] lo: Disabled Privacy Extensions
[   24.344751] tunl0: Disabled Privacy Extensions
[   24.348036] initcall inet6_init+0x0/0x2ec returned 0 after 19531 usecs
[   24.348041] calling  ah6_init+0x0/0x8f @ 1
[   24.348047] initcall ah6_init+0x0/0x8f returned 0 after 0 usecs
[   24.348051] calling  xfrm6_mode_tunnel_init+0x0/0x3e @ 1
[   24.348056] initcall xfrm6_mode_tunnel_init+0x0/0x3e returned 0 after 0 usecs
[   24.348059] calling  xfrm6_ro_init+0x0/0x3e @ 1
[   24.348063] initcall xfrm6_ro_init+0x0/0x3e returned 0 after 0 usecs
[   24.348067] calling  xfrm6_beet_init+0x0/0x3e @ 1
[   24.348071] initcall xfrm6_beet_init+0x0/0x3e returned 0 after 0 usecs
[   24.348075] calling  mip6_init+0x0/0xe1 @ 1
[   24.348077] Mobile IPv6
[   24.348081] initcall mip6_init+0x0/0xe1 returned 0 after 0 usecs
[   24.348085] calling  sit_init+0x0/0x95 @ 1
[   24.348087] IPv6 over IPv4 tunneling driver
[   24.348136] device: 'sit0': device_add
[   24.350627] sit0: Disabled Privacy Extensions
[   24.352082] initcall sit_init+0x0/0x95 returned 0 after 9765 usecs
[   24.352087] calling  packet_init+0x0/0x6d @ 1
[   24.352092] NET: Registered protocol family 17
[   24.352176] initcall packet_init+0x0/0x6d returned 0 after 0 usecs
[   24.352180] calling  ipsec_pfkey_init+0x0/0xac @ 1
[   24.352184] NET: Registered protocol family 15
[   24.352215] initcall ipsec_pfkey_init+0x0/0xac returned 0 after 0 usecs
[   24.352219] calling  br_init+0x0/0xd3 @ 1
[   24.352818] initcall br_init+0x0/0xd3 returned 0 after 0 usecs
[   24.352822] calling  dsa_init_module+0x0/0x3b @ 1
[   24.352827] initcall dsa_init_module+0x0/0x3b returned 0 after 0 usecs
[   24.352831] calling  edsa_init_module+0x0/0x3b @ 1
[   24.352835] initcall edsa_init_module+0x0/0x3b returned 0 after 0 usecs
[   24.352839] calling  mv88e6123_61_65_init+0x0/0x3b @ 1
[   24.352855] initcall mv88e6123_61_65_init+0x0/0x3b returned 0 after 0 usecs
[   24.352859] calling  mv88e6131_init+0x0/0x3b @ 1
[   24.352863] initcall mv88e6131_init+0x0/0x3b returned 0 after 0 usecs
[   24.352867] calling  dsa_init_module+0x0/0x39 @ 1
[   24.352876] bus: 'platform': add driver dsa
[   24.353117] initcall dsa_init_module+0x0/0x39 returned 0 after 0 usecs
[   24.353122] calling  atalk_init+0x0/0xb3 @ 1
[   24.353126] NET: Registered protocol family 5
[   24.390282] initcall atalk_init+0x0/0xb3 returned 0 after 39062 usecs
[   24.390287] calling  x25_init+0x0/0x85 @ 1
[   24.390291] NET: Registered protocol family 9
[   24.390295] X.25 for Linux Version 0.2
[   24.390526] initcall x25_init+0x0/0x85 returned 0 after 0 usecs
[   24.390531] calling  nr_proto_init+0x0/0x273 @ 1
[   24.390555] device: 'nr0': device_add
[   24.392441] device: 'nr1': device_add
[   24.394139] device: 'nr2': device_add
[   24.395896] device: 'nr3': device_add
[   24.397650] NET: Registered protocol family 6
[   24.398156] initcall nr_proto_init+0x0/0x273 returned 0 after 0 usecs
[   24.398160] calling  ax25_init+0x0/0xd3 @ 1
[   24.398164] NET: Registered protocol family 3
[   24.398243] initcall ax25_init+0x0/0xd3 returned 0 after 0 usecs
[   24.398247] calling  can_init+0x0/0x141 @ 1
[   24.398249] can: controller area network core (rev 20090105 abi 8)
[   24.398897] NET: Registered protocol family 29
[   24.398908] initcall can_init+0x0/0x141 returned 0 after 0 usecs
[   24.398913] calling  irnet_init+0x0/0x42 @ 1
[   24.398977] device: 'irnet': device_add
[   24.399238] initcall irnet_init+0x0/0x42 returned 0 after 0 usecs
[   24.399242] calling  l2cap_init+0x0/0x10a @ 1
[   24.399271] Bluetooth: L2CAP ver 2.13
[   24.399273] Bluetooth: L2CAP socket layer initialized
[   24.399277] initcall l2cap_init+0x0/0x10a returned 0 after 0 usecs
[   24.399282] calling  hidp_init+0x0/0x81 @ 1
[   24.399285] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   24.399291] bus: 'hid': add driver generic-bluetooth
[   24.399550] initcall hidp_init+0x0/0x81 returned 0 after 0 usecs
[   24.399554] calling  decnet_init+0x0/0xaf @ 1
[   24.399557] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   24.401727] DECnet: Routing cache hash table of 1024 buckets, 56Kbytes
[   24.401798] NET: Registered protocol family 12
[   24.402221] initcall decnet_init+0x0/0xaf returned 0 after 9765 usecs
[   24.402226] calling  econet_proto_init+0x0/0x1fb @ 1
[   24.402230] NET: Registered protocol family 19
[   24.402371] initcall econet_proto_init+0x0/0x1fb returned 0 after 0 usecs
[   24.402376] calling  phonet_init+0x0/0x9e @ 1
[   24.402393] NET: Registered protocol family 35
[   24.403082] initcall phonet_init+0x0/0x9e returned 0 after 0 usecs
[   24.403087] calling  pep_register+0x0/0x3e @ 1
[   24.403519] initcall pep_register+0x0/0x3e returned 0 after 0 usecs
[   24.403523] calling  vlan_proto_init+0x0/0xeb @ 1
[   24.403527] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   24.403530] All bugs added by David S. Miller <davem@redhat.com>
[   24.403596] initcall vlan_proto_init+0x0/0xeb returned 0 after 0 usecs
[   24.403601] calling  sctp_init+0x0/0x82d @ 1
[   24.406583] SCTP: Hash tables configured (established 18724 bind 18724)
[   24.408512] sctp_init_sock(sk: ffff88003cb08000)
[   24.408611] initcall sctp_init+0x0/0x82d returned 0 after 0 usecs
[   24.408616] calling  lib80211_init+0x0/0x45 @ 1
[   24.408618] lib80211: common routines for IEEE802.11 drivers
[   24.408634] lib80211_crypt: registered algorithm 'NULL'
[   24.408638] initcall lib80211_init+0x0/0x45 returned 0 after 0 usecs
[   24.408642] calling  lib80211_crypto_wep_init+0x0/0x39 @ 1
[   24.408646] lib80211_crypt: registered algorithm 'WEP'
[   24.408650] initcall lib80211_crypto_wep_init+0x0/0x39 returned 0 after 0 usecs
[   24.408654] calling  lib80211_crypto_ccmp_init+0x0/0x39 @ 1
[   24.408657] lib80211_crypt: registered algorithm 'CCMP'
[   24.408661] initcall lib80211_crypto_ccmp_init+0x0/0x39 returned 0 after 0 usecs
[   24.408665] calling  lib80211_crypto_tkip_init+0x0/0x39 @ 1
[   24.408668] lib80211_crypt: registered algorithm 'TKIP'
[   24.408672] initcall lib80211_crypto_tkip_init+0x0/0x39 returned 0 after 0 usecs
[   24.408676] calling  tipc_init+0x0/0xdf @ 1
[   24.408692] TIPC: Activated (version 1.6.4 compiled Aug  2 2009 22:49:36)
[   24.411036] NET: Registered protocol family 30
[   24.411040] TIPC: Started in single node mode
[   24.411049] initcall tipc_init+0x0/0xdf returned 0 after 9765 usecs
[   24.411054] calling  dcbnl_init+0x0/0x59 @ 1
[   24.411059] initcall dcbnl_init+0x0/0x59 returned 0 after 0 usecs
[   24.411063] calling  wimax_subsys_init+0x0/0x25a @ 1
[   24.430153] initcall wimax_subsys_init+0x0/0x25a returned 0 after 19531 usecs
[   24.430158] calling  severities_debugfs_init+0x0/0x83 @ 1
[   24.430184] initcall severities_debugfs_init+0x0/0x83 returned 0 after 0 usecs
[   24.430188] calling  cpufreq_p4_init+0x0/0x82 @ 1
[   24.430192] initcall cpufreq_p4_init+0x0/0x82 returned -19 after 0 usecs
[   24.430196] calling  update_mp_table+0x0/0x689 @ 1
[   24.430200] initcall update_mp_table+0x0/0x689 returned 0 after 0 usecs
[   24.430204] calling  lapic_insert_resource+0x0/0x67 @ 1
[   24.430211] initcall lapic_insert_resource+0x0/0x67 returned 0 after 0 usecs
[   24.430215] calling  io_apic_bug_finalize+0x0/0x42 @ 1
[   24.430219] initcall io_apic_bug_finalize+0x0/0x42 returned 0 after 0 usecs
[   24.430223] calling  check_early_ioremap_leak+0x0/0x8e @ 1
[   24.430228] initcall check_early_ioremap_leak+0x0/0x8e returned 0 after 0 usecs
[   24.430232] calling  sched_init_debug+0x0/0x4b @ 1
[   24.430243] initcall sched_init_debug+0x0/0x4b returned 0 after 0 usecs
[   24.430247] calling  init_oops_id+0x0/0x5d @ 1
[   24.430251] initcall init_oops_id+0x0/0x5d returned 0 after 0 usecs
[   24.430255] calling  disable_boot_consoles+0x0/0xf3 @ 1
[   24.430259] initcall disable_boot_consoles+0x0/0xf3 returned 0 after 0 usecs
[   24.430263] calling  pm_qos_power_init+0x0/0xf0 @ 1
[   24.430277] device: 'cpu_dma_latency': device_add
[   24.430572] device: 'network_latency': device_add
[   24.430796] device: 'network_throughput': device_add
[   24.431028] initcall pm_qos_power_init+0x0/0xf0 returned 0 after 0 usecs
[   24.431033] calling  clear_boot_tracer+0x0/0x52 @ 1
[   24.431037] initcall clear_boot_tracer+0x0/0x52 returned 0 after 0 usecs
[   24.431042] calling  max_swapfiles_check+0x0/0x2d @ 1
[   24.431047] initcall max_swapfiles_check+0x0/0x2d returned 0 after 0 usecs
[   24.431052] calling  random32_reseed+0x0/0xce @ 1
[   24.431070] initcall random32_reseed+0x0/0xce returned 0 after 0 usecs
[   24.431075] calling  pci_resource_alignment_sysfs_init+0x0/0x40 @ 1
[   24.431085] initcall pci_resource_alignment_sysfs_init+0x0/0x40 returned 0 after 0 usecs
[   24.431089] calling  pci_sysfs_init+0x0/0x77 @ 1
[   24.431401] initcall pci_sysfs_init+0x0/0x77 returned 0 after 0 usecs
[   24.431405] calling  seqgen_init+0x0/0x36 @ 1
[   24.431425] initcall seqgen_init+0x0/0x36 returned 0 after 0 usecs
[   24.431429] calling  hd_init+0x0/0x321 @ 1
[   24.431478] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   24.431629] initcall hd_init+0x0/0x321 returned -1 after 0 usecs
[   24.431633] initcall hd_init+0x0/0x321 returned with error code -1 
[   24.431639] calling  scsi_complete_async_scans+0x0/0x13b @ 1
[   24.431643] initcall scsi_complete_async_scans+0x0/0x13b returned 0 after 0 usecs
[   24.431647] calling  edd_init+0x0/0x386 @ 1
[   24.431650] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   24.431652] EDD information not available.
[   24.431656] initcall edd_init+0x0/0x386 returned -19 after 0 usecs
[   24.431659] calling  memmap_init+0x0/0xce @ 1
[   24.431778] initcall memmap_init+0x0/0xce returned 0 after 0 usecs
[   24.431781] calling  dmatest_init+0x0/0x16c @ 1
[   24.431802] initcall dmatest_init+0x0/0x16c returned 0 after 0 usecs
[   24.431806] calling  tcp_congestion_default+0x0/0x39 @ 1
[   24.431811] initcall tcp_congestion_default+0x0/0x39 returned 0 after 0 usecs
[   24.431815] calling  ip_auto_config+0x0/0xf1d @ 1
[   24.431842] initcall ip_auto_config+0x0/0xf1d returned 0 after 0 usecs
[   24.431846] calling  initialize_hashrnd+0x0/0x40 @ 1
[   24.431854] initcall initialize_hashrnd+0x0/0x40 returned 0 after 0 usecs
[   24.431894] async_waiting @ 1
[   24.431897] async_continuing @ 1 after 0 usec
[   29.297460] EXT3-fs: INFO: recovery required on readonly filesystem.
[   29.300255] EXT3-fs: write access will be enabled during recovery.
[   29.345899] kjournald starting.  Commit interval 5 seconds
[   29.350055] EXT3-fs: recovery complete.
[   29.354793] EXT3-fs: mounted filesystem with writeback data mode.
[   29.360101] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[   29.366790] async_waiting @ 1
[   29.370004] async_continuing @ 1 after 0 usec
[   29.374355] debug: unmapping init memory ffffffff828ac000..ffffffff82985000
[   29.380094] Write protecting the kernel read-only data: 22020k
[   29.390362] Testing CPA: undo ffffffff81009000-ffffffff8258a000
[   29.397211] Testing CPA: again
[   29.397780] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   29.432248] device: 'input0': device_add
[   29.447136] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
[   29.464851] input: AT Translated Set 2 keyboard as /class/input/input0
[   29.464851] device: 'event0': device_add
[   29.474693] evbug.c: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[   29.480032] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   29.486339] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   29.487052] device: 'serio1': device_add
[   29.490012] bus: 'serio': add device serio1
[   29.504888] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   29.504888] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   29.525961] bus: 'serio': driver_probe_device: matched device serio1 with driver psmouse
[   29.530000] bus: 'serio': really_probe: probing driver psmouse with device serio1
Mount failed for selinuxfs on /selinux:  No such device
INIT: version 2.86 booting
		Welcome to Fedora 
		Press 'I' to enter interactive startup.
[   30.915335] device: 'input1': device_add
[   30.930122] input: ImPS/2 Generic Wheel Mouse as /class/input/input1
[   30.930122] device: 'mouse0': device_add
[   30.940546] device: 'event1': device_add
[   30.945070] evbug.c: Connected device: input1 (ImPS/2 Generic Wheel Mouse at isa0060/serio1/input0)
[   30.945070] driver: 'serio1': driver_bound: bound to device 'psmouse'
[   30.950012] bus: 'serio': really_probe: bound device serio1 to driver psmouse
Setting clock  (localtime): Mon Aug  3 02:49:22 CEST 2009 [  OK  ]
Starting udev: /sbin/start_udev: line 85: cannot redirect standard input from /dev/null: No such file or directory
/sbin/start_udev: line 85: cannot redirect standard input from /dev/null: No such file or directory
/sbin/start_udev: line 187: /proc/sys/kernel/hotplug: No such file or directory
[   34.989808] CPA self-test:
[   35.002100]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   35.028029]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   35.055923]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   35.059899] ok.
[   36.010887] eth1: link down
[   36.010887] device: 'bpq0': device_add
[   36.021765] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   36.075293] device: 'bpq1': device_add
[   37.270073] IPv4 FIB: Using LC-trie version 0.408
[  OK  ]
Loading default keymap (us): [  OK  ]
Setting hostname mercury:  [  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda6 
/1: Superblock last mount time is in the future.  FIXED.
/1: Superblock last write time is in the future.  FIXED.
/1: clean, 375369/7325696 files, 3524827/7325632 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/sda5 
/home: recovering journal
/home: Superblock last mount time is in the future.  FIXED.
/home: clean, 134936/6111232 files, 2541855/12209392 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  [   43.092507] EXT3 FS on sda6, internal journal
[  OK  ]
Mounting local filesystems:  [   43.208424] kjournald starting.  Commit interval 5 seconds
[   43.211002] EXT3 FS on sda5, internal journal
[   43.211002] EXT3-fs: mounted filesystem with writeback data mode.
[  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling /etc/fstab swaps:  [   44.106716] Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k 
[  OK  ]
INIT: Entering runlevel: 3
Entering non-interactive startup
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [  OK  ]
Starting system message bus: [   45.537838] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
