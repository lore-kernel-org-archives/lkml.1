Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbZD1LNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbZD1LNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZD1LNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:13:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52979 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbZD1LNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:13:07 -0400
Date: Tue, 28 Apr 2009 13:12:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: BUG: Function graph tracer hang
Message-ID: <20090428111223.GA20526@elte.hu>
References: <20090417144055.857407604@goodmis.org> <20090417151135.GG23493@elte.hu> <20090417151303.GA18267@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20090417151303.GA18267@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


FYI, a testbox triggered this message today:

  BUG: Function graph tracer hang!

i've attached the bootlog. Not sure how reproducible it is. I havent 
seen this message recently.

	Ingo

[    0.000000] Linux version 2.6.30-rc3-tip (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #37050 SMP PREEMPT Tue Apr 28 12:41:27 CEST 2009
[    0.000000] Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
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
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 240b000-260d000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000003fff0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [0000000000008000 - 000000000003bfff]
[    0.000000]   bootmap [000000000003c000 -  0000000000043fff] pages 8
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000240a900]    TEXT DATA BSS ==> [0000200000 - 000240a900]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [000240b000 - 000260b000]          PGTABLE ==> [000240b000 - 000260b000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000]  [ffffe20000000000-ffffe200019fffff] PMD -> [ffff880002800000-ffff8800041fffff] on node 0
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
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 99 pages reserved
[    0.000000]   DMA zone: 3791 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6552 pages used for memmap
[    0.000000]   DMA32 zone: 251480 pages, LIFO batch:31
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
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages at ffff880004200000, static data 1928864 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255271
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:33024 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.000 MHz processor.
[    0.000999] spurious 8259A interrupt: IRQ7.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console handover: boot [earlyser0] -> real [ttyS0]
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        8191
[    0.000999] ... CLASSHASH_SIZE:          4096
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000999] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000999] ... CHAINHASH_SIZE:          8192
[    0.000999]  memory used by lock dependency info: 5119 kB
[    0.000999]  per task-struct memory footprint: 2688 bytes
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
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Node 0: aperture @ 20000000 size 32 MB
[    0.000999] Aperture pointing to e820 RAM. Ignoring.
[    0.000999] Your BIOS doesn't leave a aperture memory hole
[    0.000999] Please enable the IOMMU option in the BIOS setup
[    0.000999] This costs you 64 MB of RAM
[    0.000999] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000999] Memory: 914680k/1048512k available (8898k kernel code, 408k absent, 133424k reserved, 11056k data, 3020k init)
[    0.000999] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000999] ODEBUG: 9 of 9 active objects replaced
[    0.001036] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.00 BogoMIPS (lpj=2010000)
[    0.003127] Security Framework initialized
[    0.004026] TOMOYO Linux initialized
[    0.006849] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.008104] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.009554] Mount-cache hash table entries: 256
[    0.014178] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.015012] CPU: L2 Cache: 512K (64 bytes/line)
[    0.016011] CPU 0/0x0 -> Node 0
[    0.017011] tseg: 0000000000
[    0.019087] CPU: Physical Processor ID: 0
[    0.020009] CPU: Processor Core ID: 0
[    0.021011] AMD Performance Monitoring support detected.
[    0.022009] ... num counters:    4
[    0.023009] ... value mask:      0000ffffffffffff
[    0.024008] ... fixed counters:  0
[    0.025008] ... counter mask:    000000000000000f
[    0.027341] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.028016] ftrace: allocating 27543 entries in 109 pages
[    0.032030] Failed to register trace ftrace module notifier
[    0.033561] Setting APIC routing to flat
[    0.034019] enabled ExtINT on CPU#0
[    0.035080] ExtINT not setup in hardware but reported by MP table
[    0.036135] ENABLING IO-APIC IRQs
[    0.037008] init IO_APIC IRQs
[    0.038008]  2-0 (apicid-pin) not connected
[    0.040081] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.041023] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.042020] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
[    0.042993] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
[    0.042993] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
[    0.042993] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.042993] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.042993]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.042993] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.042993] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.042993] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.042993] ..... (found apic 0 pin 0) ...
[    0.053830] ....... works.
[    0.054004] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.057004] Using local APIC timer interrupts.
[    0.057006] calibrating APIC timer ...
[    0.058991] ... lapic delta = 1256243
[    0.058991] ..... delta 1256243
[    0.058991] ..... mult: 53963428
[    0.058991] ..... calibration result: 200998
[    0.058991] ..... CPU clock speed is 2009.0989 MHz.
[    0.058991] ..... host bus clock speed is 200.0998 MHz.
[    0.058991] ... verify APIC timer
[    0.161716] ... jiffies delta = 100
[    0.161987] ... jiffies result ok
[    0.163015] calling  migration_init+0x0/0x88 @ 1
[    0.165241] initcall migration_init+0x0/0x88 returned 1 after 976 usecs
[    0.165989] initcall migration_init+0x0/0x88 returned with error code 1 
[    0.166987] calling  spawn_ksoftirqd+0x0/0x7b @ 1
[    0.168164] initcall spawn_ksoftirqd+0x0/0x7b returned 0 after 0 usecs
[    0.168989] calling  init_call_single_data+0x0/0xd0 @ 1
[    0.169991] initcall init_call_single_data+0x0/0xd0 returned 0 after 0 usecs
[    0.170987] calling  spawn_softlockup_task+0x0/0x9f @ 1
[    0.172114] initcall spawn_softlockup_task+0x0/0x9f returned 0 after 0 usecs
[    0.172987] calling  relay_init+0x0/0x14 @ 1
[    0.173993] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.174986] calling  tracer_alloc_buffers+0x0/0x337 @ 1
[    0.176294] Testing tracer nop: PASSED
[    0.178146] initcall tracer_alloc_buffers+0x0/0x337 returned 0 after 1952 usecs
[    0.178986] calling  init_trace_printk+0x0/0x12 @ 1
[    0.179985] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.180985] calling  trace_workqueue_early_init+0x0/0x1c3 @ 1
[    0.182186] initcall trace_workqueue_early_init+0x0/0x1c3 returned 0 after 0 usecs
[    0.182985] calling  perf_counter_init+0x0/0x2c @ 1
[    0.184053] initcall perf_counter_init+0x0/0x2c returned 0 after 0 usecs
[    0.186915] lockdep: fixing up alternatives.
[    0.187501] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] masked ExtINT on CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4019.95 BogoMIPS (lpj=2009978)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU 1/0x1 -> Node 0
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.259814] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.263313] Brought up 2 CPUs
[    0.263976] Total of 2 processors activated (8039.95 BogoMIPS).
[    0.266030] CPU0 attaching sched-domain:
[    0.266984]  domain 0: span 0-1 level CPU
[    0.268973]   groups: 0 1
[    0.270664] CPU1 attaching sched-domain:
[    0.270976]  domain 0: span 0-1 level CPU
[    0.272978]   groups: 1 0
[    0.277255] khelper used greatest stack depth: 5080 bytes left
[    0.285454] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.285980] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.286971] calling  net_ns_init+0x0/0x174 @ 1
[    0.287968] net_namespace: 1880 bytes
[    0.290431] initcall net_ns_init+0x0/0x174 returned 0 after 1952 usecs
[    0.291039] calling  cpufreq_tsc+0x0/0x5b @ 1
[    0.291970] initcall cpufreq_tsc+0x0/0x5b returned 0 after 0 usecs
[    0.292970] calling  print_banner+0x0/0xe @ 1
[    0.293968] Booting paravirtualized kernel on bare hardware
[    0.295036] initcall print_banner+0x0/0xe returned 0 after 976 usecs
[    0.295969] calling  init_smp_flush+0x0/0x42 @ 1
[    0.296970] initcall init_smp_flush+0x0/0x42 returned 0 after 0 usecs
[    0.297969] calling  sysctl_init+0x0/0x32 @ 1
[    0.300164] initcall sysctl_init+0x0/0x32 returned 0 after 976 usecs
[    0.300968] calling  ksysfs_init+0x0/0x14f @ 1
[    0.302180] initcall ksysfs_init+0x0/0x14f returned 0 after 0 usecs
[    0.303113] calling  async_init+0x0/0xc3 @ 1
[    0.303968] initcall async_init+0x0/0xc3 returned 0 after 0 usecs
[    0.304967] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.306079] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.307041] calling  filelock_init+0x0/0x2e @ 1
[    0.307993] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.308968] calling  init_script_binfmt+0x0/0x12 @ 1
[    0.310032] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.311038] calling  init_elf_binfmt+0x0/0x12 @ 1
[    0.311969] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.312967] calling  init_compat_elf_binfmt+0x0/0x12 @ 1
[    0.313968] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.316037] calling  debugfs_init+0x0/0x86 @ 1
[    0.316999] initcall debugfs_init+0x0/0x86 returned 0 after 0 usecs
[    0.318006] calling  securityfs_init+0x0/0x7d @ 1
[    0.319021] initcall securityfs_init+0x0/0x7d returned 0 after 0 usecs
[    0.320085] calling  calibrate_xor_blocks+0x0/0xc4 @ 1
[    0.321019] xor: automatically using best checksumming function: generic_sse
[    0.327014]    generic_sse:  5324.000 MB/sec
[    0.328083] xor: using function: generic_sse (5324.000 MB/sec)
[    0.329030] initcall calibrate_xor_blocks+0x0/0xc4 returned 0 after 7812 usecs
[    0.330026] calling  random32_init+0x0/0xfb @ 1
[    0.331015] initcall random32_init+0x0/0xfb returned 0 after 0 usecs
[    0.332085] calling  regulator_init+0x0/0x2e @ 1
[    0.333013] regulator: core version 0.5
[    0.335202] initcall regulator_init+0x0/0x2e returned 0 after 1953 usecs
[    0.336175] calling  cpufreq_core_init+0x0/0x76 @ 1
[    0.337017] initcall cpufreq_core_init+0x0/0x76 returned 0 after 0 usecs
[    0.338016] calling  virtio_init+0x0/0x41 @ 1
[    0.339200] initcall virtio_init+0x0/0x41 returned 0 after 0 usecs
[    0.340151] calling  sock_init+0x0/0x6e @ 1
[    0.341433] initcall sock_init+0x0/0x6e returned 0 after 0 usecs
[    0.342014] calling  net_inuse_init+0x0/0x3c @ 1
[    0.343074] initcall net_inuse_init+0x0/0x3c returned 0 after 0 usecs
[    0.344081] calling  netpoll_init+0x0/0x41 @ 1
[    0.345014] initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
[    0.346014] calling  netlink_proto_init+0x0/0x1b5 @ 1
[    0.347144] NET: Registered protocol family 16
[    0.348425] initcall netlink_proto_init+0x0/0x1b5 returned 0 after 976 usecs
[    0.349016] calling  bdi_class_init+0x0/0x41 @ 1
[    0.351453] initcall bdi_class_init+0x0/0x41 returned 0 after 976 usecs
[    0.352015] calling  kobject_uevent_init+0x0/0x6c @ 1
[    0.353031] initcall kobject_uevent_init+0x0/0x6c returned 0 after 0 usecs
[    0.354014] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.356322] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.357018] calling  pci_driver_init+0x0/0x12 @ 1
[    0.358196] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.359018] calling  lcd_class_init+0x0/0x7e @ 1
[    0.360201] initcall lcd_class_init+0x0/0x7e returned 0 after 0 usecs
[    0.361018] calling  backlight_class_init+0x0/0x8e @ 1
[    0.362194] initcall backlight_class_init+0x0/0x8e returned 0 after 0 usecs
[    0.363018] calling  tty_class_init+0x0/0x5f @ 1
[    0.364198] initcall tty_class_init+0x0/0x5f returned 0 after 0 usecs
[    0.365018] calling  vtconsole_class_init+0x0/0x160 @ 1
[    0.367245] initcall vtconsole_class_init+0x0/0x160 returned 0 after 976 usecs
[    0.368015] calling  register_node_type+0x0/0x95 @ 1
[    0.370071] initcall register_node_type+0x0/0x95 returned 0 after 976 usecs
[    0.371015] calling  spi_init+0x0/0xe5 @ 1
[    0.373036] initcall spi_init+0x0/0xe5 returned 0 after 976 usecs
[    0.374014] calling  amd_postcore_init+0x0/0xd8 @ 1
[    0.375017] node 0 link 0: io port [1000, fffff]
[    0.376014] TOM: 0000000040000000 aka 1024M
[    0.378015] node 0 link 0: mmio [e0000000, efffffff]
[    0.380013] node 0 link 0: mmio [feb00000, fec0ffff]
[    0.382014] node 0 link 0: mmio [a0000, bffff]
[    0.383210] node 0 link 0: mmio [40000000, fed3ffff]
[    0.384210] bus: [00,ff] on node 0 link 0
[    0.385083] bus: 00 index 0 io port: [0, ffff]
[    0.386013] bus: 00 index 1 mmio: [40000000, fcffffffff]
[    0.387013] bus: 00 index 2 mmio: [feb00000, fec0ffff]
[    0.388013] bus: 00 index 3 mmio: [a0000, bffff]
[    0.389084] initcall amd_postcore_init+0x0/0xd8 returned 0 after 13671 usecs
[    0.390016] calling  arch_kdebugfs_init+0x0/0x40 @ 1
[    0.391098] initcall arch_kdebugfs_init+0x0/0x40 returned 0 after 0 usecs
[    0.392015] calling  mtrr_if_init+0x0/0x6c @ 1
[    0.393098] initcall mtrr_if_init+0x0/0x6c returned 0 after 0 usecs
[    0.394016] calling  pci_arch_init+0x0/0x73 @ 1
[    0.396013] PCI: Using configuration type 1 for base access
[    0.397086] initcall pci_arch_init+0x0/0x73 returned 0 after 1953 usecs
[    0.398015] calling  topology_init+0x0/0xc6 @ 1
[    0.400311] initcall topology_init+0x0/0xc6 returned 0 after 976 usecs
[    0.401085] calling  mtrr_init_finialize+0x0/0x84 @ 1
[    0.402015] initcall mtrr_init_finialize+0x0/0x84 returned 0 after 0 usecs
[    0.403014] calling  param_sysfs_init+0x0/0x141 @ 1
[    0.467298] initcall param_sysfs_init+0x0/0x141 returned 0 after 61523 usecs
[    0.468101] calling  init_slow_work+0x0/0x6d @ 1
[    0.469016] initcall init_slow_work+0x0/0x6d returned 0 after 0 usecs
[    0.470015] calling  default_bdi_init+0x0/0x4e @ 1
[    0.472226] initcall default_bdi_init+0x0/0x4e returned 0 after 0 usecs
[    0.473148] calling  init_bio+0x0/0x10e @ 1
[    0.474212] bio: create slab <bio-0> at 0
[    0.475023] initcall init_bio+0x0/0x10e returned 0 after 976 usecs
[    0.477082] calling  bio_integrity_init+0x0/0xf2 @ 1
[    0.478172] initcall bio_integrity_init+0x0/0xf2 returned 0 after 0 usecs
[    0.479126] calling  cryptomgr_init+0x0/0x61 @ 1
[    0.480057] initcall cryptomgr_init+0x0/0x61 returned 0 after 0 usecs
[    0.481014] calling  blk_settings_init+0x0/0x2a @ 1
[    0.482015] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.483081] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.484019] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.485014] calling  blk_softirq_init+0x0/0xa0 @ 1
[    0.486018] initcall blk_softirq_init+0x0/0xa0 returned 0 after 0 usecs
[    0.487084] calling  genhd_device_init+0x0/0x90 @ 1
[    0.489126] initcall genhd_device_init+0x0/0x90 returned 0 after 976 usecs
[    0.490015] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    0.491024] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    0.492015] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    0.493106] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.494014] calling  max7301_init+0x0/0x12 @ 1
[    0.495204] initcall max7301_init+0x0/0x12 returned 0 after 0 usecs
[    0.497017] calling  mcp23s08_init+0x0/0x12 @ 1
[    0.498198] initcall mcp23s08_init+0x0/0x12 returned 0 after 0 usecs
[    0.499084] calling  pci_slot_init+0x0/0x60 @ 1
[    0.500027] initcall pci_slot_init+0x0/0x60 returned 0 after 0 usecs
[    0.501015] calling  misc_init+0x0/0xde @ 1
[    0.502200] initcall misc_init+0x0/0xde returned 0 after 0 usecs
[    0.504023] calling  cn_init+0x0/0x135 @ 1
[    0.505166] initcall cn_init+0x0/0x135 returned 0 after 0 usecs
[    0.506015] calling  init_scsi+0x0/0x123 @ 1
[    0.509497] SCSI subsystem initialized
[    0.510120] initcall init_scsi+0x0/0x123 returned 0 after 2929 usecs
[    0.511014] calling  ata_init+0x0/0xb7 @ 1
[    0.513207] libata version 3.00 loaded.
[    0.514091] initcall ata_init+0x0/0xb7 returned 0 after 1953 usecs
[    0.515014] calling  phy_init+0x0/0x5d @ 1
[    0.517239] initcall phy_init+0x0/0x5d returned 0 after 976 usecs
[    0.518169] calling  init_pcmcia_cs+0x0/0x2f @ 1
[    0.520340] initcall init_pcmcia_cs+0x0/0x2f returned 0 after 976 usecs
[    0.522083] calling  usb_init+0x0/0x1d3 @ 1
[    0.524213] usbcore: registered new interface driver usbfs
[    0.526196] usbcore: registered new interface driver hub
[    0.528335] usbcore: registered new device driver usb
[    0.529022] initcall usb_init+0x0/0x1d3 returned 0 after 5859 usecs
[    0.530014] calling  serio_init+0x0/0xf7 @ 1
[    0.531233] initcall serio_init+0x0/0xf7 returned 0 after 0 usecs
[    0.533082] calling  gameport_init+0x0/0xf8 @ 1
[    0.535164] initcall gameport_init+0x0/0xf8 returned 0 after 976 usecs
[    0.536015] calling  input_init+0x0/0x19c @ 1
[    0.537497] initcall input_init+0x0/0x19c returned 0 after 0 usecs
[    0.538019] calling  rtc_init+0x0/0x99 @ 1
[    0.539192] initcall rtc_init+0x0/0x99 returned 0 after 0 usecs
[    0.540019] calling  power_supply_class_init+0x0/0x68 @ 1
[    0.542052] initcall power_supply_class_init+0x0/0x68 returned 0 after 976 usecs
[    0.543015] calling  raid6_select_algo+0x0/0x295 @ 1
[    0.561021] raid6: int64x1   1726 MB/s
[    0.579035] raid6: int64x2   2191 MB/s
[    0.597028] raid6: int64x4   1710 MB/s
[    0.615033] raid6: int64x8   1617 MB/s
[    0.633038] raid6: sse2x1    1890 MB/s
[    0.651034] raid6: sse2x2    2707 MB/s
[    0.669022] raid6: sse2x4    2992 MB/s
[    0.670084] raid6: using algorithm sse2x4 (2992 MB/s)
[    0.671027] initcall raid6_select_algo+0x0/0x295 returned 0 after 124023 usecs
[    0.672015] calling  md_init+0x0/0xfa @ 1
[    0.673069] initcall md_init+0x0/0xfa returned 0 after 0 usecs
[    0.674085] calling  pci_subsys_init+0x0/0xae @ 1
[    0.675013] PCI: Probing PCI hardware
[    0.676145] PCI: Probing PCI hardware (bus 00)
[    0.677204] PCI: Scanning bus 0000:00
[    0.678212] pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
[    0.679136] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x269
[    0.680202] pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
[    0.681097] pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xfd
[    0.682092] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.683016] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x269
[    0.684053] pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
[    0.685049] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    0.686151] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    0.687023] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    0.688031] pci 0000:00:01.1: calling quirk_resource_alignment+0x0/0x269
[    0.689044] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.690089] pci 0000:00:01.1: PME# disabled
[    0.691086] pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
[    0.692048] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    0.693079] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x269
[    0.694114] pci 0000:00:02.0: supports D1 D2
[    0.695014] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.696018] pci 0000:00:02.0: PME# disabled
[    0.697057] pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
[    0.698129] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    0.699079] pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x269
[    0.701018] pci 0000:00:02.1: supports D1 D2
[    0.702084] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.703018] pci 0000:00:02.1: PME# disabled
[    0.704098] pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
[    0.705048] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    0.706094] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    0.708013] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    0.709060] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x269
[    0.710114] pci 0000:00:04.0: supports D1 D2
[    0.711058] pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
[    0.713057] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    0.714125] pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x269
[    0.715087] pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
[    0.716053] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x269
[    0.717053] pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
[    0.718119] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    0.719024] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    0.720069] pci 0000:00:0a.0: calling quirk_resource_alignment+0x0/0x269
[    0.721044] pci 0000:00:0a.0: supports D1 D2
[    0.722084] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.723018] pci 0000:00:0a.0: PME# disabled
[    0.724065] pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
[    0.725070] pci 0000:00:0b.0: calling quirk_resource_alignment+0x0/0x269
[    0.727071] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.728018] pci 0000:00:0b.0: PME# disabled
[    0.730150] pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
[    0.731070] pci 0000:00:0c.0: calling quirk_resource_alignment+0x0/0x269
[    0.733018] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.734088] pci 0000:00:0c.0: PME# disabled
[    0.736063] pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
[    0.737070] pci 0000:00:0d.0: calling quirk_resource_alignment+0x0/0x269
[    0.738166] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.739018] pci 0000:00:0d.0: PME# disabled
[    0.740078] pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
[    0.741070] pci 0000:00:0e.0: calling quirk_resource_alignment+0x0/0x269
[    0.742140] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.743018] pci 0000:00:0e.0: PME# disabled
[    0.744120] pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
[    0.745088] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x269
[    0.746142] pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
[    0.747088] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x269
[    0.748044] pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
[    0.749088] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x269
[    0.750115] pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
[    0.751088] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x269
[    0.752092] PCI: Fixups for bus 0000:00
[    0.753017] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
[    0.754102] PCI: Scanning bus 0000:05
[    0.755092] pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
[    0.756053] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    0.757025] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    0.758147] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x269
[    0.759047] pci 0000:05:07.0: supports D1 D2
[    0.760013] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    0.761018] pci 0000:05:07.0: PME# disabled
[    0.762238] PCI: Fixups for bus 0000:05
[    0.763013] pci 0000:00:09.0: transparent bridge
[    0.764018] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    0.765018] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    0.766088] PCI: Bus scan for 0000:05 returning with max=05
[    0.767019] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
[    0.768030] PCI: Scanning bus 0000:04
[    0.769200] PCI: Fixups for bus 0000:04
[    0.770107] PCI: Bus scan for 0000:04 returning with max=04
[    0.771019] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
[    0.772030] PCI: Scanning bus 0000:03
[    0.773201] PCI: Fixups for bus 0000:03
[    0.774107] PCI: Bus scan for 0000:03 returning with max=03
[    0.775019] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
[    0.776030] PCI: Scanning bus 0000:02
[    0.778270] PCI: Fixups for bus 0000:02
[    0.779037] PCI: Bus scan for 0000:02 returning with max=02
[    0.780019] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
[    0.781030] PCI: Scanning bus 0000:01
[    0.782116] pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
[    0.783030] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x36
[    0.784030] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    0.785024] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    0.787026] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    0.788056] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.789022] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x269
[    0.791061] pci 0000:01:00.0: supports D1 D2
[    0.792070] pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
[    0.793030] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x36
[    0.794098] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    0.795085] pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x269
[    0.796055] pci 0000:01:00.1: supports D1 D2
[    0.797248] PCI: Fixups for bus 0000:01
[    0.798093] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    0.799018] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    0.800023] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    0.801013] PCI: Bus scan for 0000:01 returning with max=01
[    0.802090] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
[    0.803023] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
[    0.804023] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
[    0.805023] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
[    0.806135] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
[    0.807021] PCI: Bus scan for 0000:00 returning with max=05
[    0.822394] pci 0000:00:00.0: default IRQ router [10de:005e]
[    0.823302] pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 3
[    0.824041] pci 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    0.825090] pci 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    0.826023] pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 5
[    0.828428] initcall pci_subsys_init+0x0/0xae returned 0 after 149414 usecs
[    0.829015] calling  proto_init+0x0/0x12 @ 1
[    0.830033] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.831085] calling  net_dev_init+0x0/0x266 @ 1
[    0.834723] initcall net_dev_init+0x0/0x266 returned 0 after 1953 usecs
[    0.835081] calling  neigh_init+0x0/0x71 @ 1
[    0.836016] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.838014] calling  fib_rules_init+0x0/0xce @ 1
[    0.839084] initcall fib_rules_init+0x0/0xce returned 0 after 0 usecs
[    0.840014] calling  pktsched_init+0x0/0xc4 @ 1
[    0.841086] initcall pktsched_init+0x0/0xc4 returned 0 after 0 usecs
[    0.842014] calling  tc_filter_init+0x0/0x4c @ 1
[    0.843081] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    0.844014] calling  tc_action_init+0x0/0x4c @ 1
[    0.846016] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    0.847080] calling  genl_init+0x0/0x130 @ 1
[    0.852276] initcall genl_init+0x0/0x130 returned 0 after 3906 usecs
[    0.853090] calling  cipso_v4_init+0x0/0xb8 @ 1
[    0.854047] initcall cipso_v4_init+0x0/0xb8 returned 0 after 0 usecs
[    0.855015] calling  irda_init+0x0/0xe3 @ 1
[    0.856013] irda_init()
[    0.857193] NET: Registered protocol family 23
[    0.858235] initcall irda_init+0x0/0xe3 returned 0 after 1953 usecs
[    0.859015] calling  bt_init+0x0/0x85 @ 1
[    0.860012] Bluetooth: Core ver 2.15
[    0.862145] NET: Registered protocol family 31
[    0.863018] Bluetooth: HCI device and connection manager initialized
[    0.865098] Bluetooth: HCI socket layer initialized
[    0.867090] initcall bt_init+0x0/0x85 returned 0 after 6835 usecs
[    0.868015] calling  wireless_nlevent_init+0x0/0x41 @ 1
[    0.869015] initcall wireless_nlevent_init+0x0/0x41 returned 0 after 0 usecs
[    0.870016] calling  cfg80211_init+0x0/0xd9 @ 1
[    0.883274] cfg80211: Using static regulatory domain info
[    0.885018] cfg80211: Regulatory domain: US
[    0.886013] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.887014] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.888080] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.889014] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.891011] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.892083] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.893014] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.894099] initcall cfg80211_init+0x0/0xd9 returned 0 after 22460 usecs
[    0.895016] calling  ieee80211_init+0x0/0x30 @ 1
[    0.897113] initcall ieee80211_init+0x0/0x30 returned 0 after 0 usecs
[    0.898015] calling  netlbl_init+0x0/0xe3 @ 1
[    0.900084] NetLabel: Initializing
[    0.901013] NetLabel:  domain hash size = 128
[    0.902012] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.904163] NetLabel:  unlabeled traffic allowed by default
[    0.905016] initcall netlbl_init+0x0/0xe3 returned 0 after 4882 usecs
[    0.906015] calling  sysctl_init+0x0/0x5f @ 1
[    0.907021] initcall sysctl_init+0x0/0x5f returned 0 after 0 usecs
[    0.908087] calling  pci_iommu_init+0x0/0x2d @ 1
[    0.928856] DMA-API: preallocated 32768 debug entries
[    0.929014] DMA-API: debugging enabled by kernel config
[    0.932051] cfg80211: Calling CRDA for country: US
[    0.931745] PCI-DMA: Disabling AGP.
[    0.934661] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.941015] PCI-DMA: using GART IOMMU.
[    0.944022] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.955288] initcall pci_iommu_init+0x0/0x2d returned 0 after 45898 usecs
[    0.963045] calling  print_all_ICs+0x0/0x17 @ 1
[    0.967013] 
[    0.967014] printing PIC contents
[    0.972016] ... PIC  IMR: fffa
[    0.975020] ... PIC  IRR: 0001
[    0.978013] ... PIC  ISR: 0001
[    0.981013] ... PIC ELCR: 0828
[    0.984018] 
[    0.984018] printing local APIC contents on CPU#0/0:
[    0.985000] ... APIC ID:      00000000 (0)
[    0.985000] ... APIC VERSION: 00040010
[    0.985000] ... APIC TASKPRI: 00000000 (00)
[    0.985000] ... APIC ARBPRI: 000000e0 (e0)
[    0.985000] ... APIC PROCPRI: 00000000
[    0.985000] ... APIC LDR: 01000000
[    0.985000] ... APIC DFR: ffffffff
[    0.985000] ... APIC SPIV: 000001ff
[    0.985000] ... APIC ISR field:
[    0.985000] 0123456789abcdef0123456789abcdef
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] ... APIC TMR field:
[    0.985000] 0123456789abcdef0123456789abcdef
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] ... APIC IRR field:
[    0.985000] 0123456789abcdef0123456789abcdef
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000010000000000000000
[    0.985000] ... APIC ESR: 00000000
[    0.985000] ... APIC ICR: 000008fd
[    0.985000] ... APIC ICR2: 02000000
[    0.985000] ... APIC LVTT: 000200ef
[    0.985000] ... APIC LVTPC: 000000ee
[    0.985000] ... APIC LVT0: 00010700
[    0.985000] ... APIC LVT1: 00000400
[    0.985000] ... APIC LVTERR: 000000fe
[    0.985000] ... APIC TMICT: 00003112
[    0.985000] ... APIC TMCCT: 00001ad5
[    0.985000] ... APIC TDCR: 00000003
[    0.985000] 
[    0.985000] 
[    0.985000] printing local APIC contents on CPU#1/1:
[    0.985000] ... APIC ID:      01000000 (1)
[    0.985000] ... APIC VERSION: 00040010
[    0.985000] ... APIC TASKPRI: 00000000 (00)
[    0.985000] ... APIC ARBPRI: 000000f0 (f0)
[    0.985000] ... APIC PROCPRI: 00000000
[    0.985000] ... APIC LDR: 02000000
[    0.985000] ... APIC DFR: ffffffff
[    0.985000] ... APIC SPIV: 000001ff
[    0.985000] ... APIC ISR field:
[    0.985000] 0123456789abcdef0123456789abcdef
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] ... APIC TMR field:
[    0.985000] 0123456789abcdef0123456789abcdef
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] ... APIC IRR field:
[    0.985000] 0123456789abcdef0123456789abcdef
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000000000000000000000
[    0.985000] 00000000000000010000000000000100
[    0.985000] ... APIC ESR: 00000000
[    0.985000] ... APIC ICR: 000008fb
[    0.985000] ... APIC ICR2: 01000000
[    0.985000] ... APIC LVTT: 000200ef
[    0.985000] ... APIC LVTPC: 000100ee
[    0.985000] ... APIC LVT0: 00010700
[    0.985000] ... APIC LVT1: 00010400
[    0.985000] ... APIC LVTERR: 000000fe
[    0.985000] ... APIC TMICT: 00003112
[    0.985000] ... APIC TMCCT: 0000052f
[    0.985000] ... APIC TDCR: 00000003
[    0.985000] 
[    1.202018] number of MP IRQ sources: 17.
[    1.206013] number of IO-APIC #2 registers: 24.
[    1.211041] testing the IO APIC.......................
[    1.216016] 
[    1.217012] IO APIC #2......
[    1.220012] .... register #00: 00000000
[    1.224012] .......    : physical APIC id: 00
[    1.228012] .......    : Delivery Type: 0
[    1.232012] .......    : LTS          : 0
[    1.236012] .... register #01: 00170011
[    1.240012] .......     : max redirection entries: 0017
[    1.245012] .......     : PRQ implemented: 0
[    1.250013] .......     : IO APIC version: 0011
[    1.254012] .... register #02: 00000000
[    1.258012] .......     : arbitration: 00
[    1.262012] .... IRQ redirection table:
[    1.266023]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    1.272016]  00 003 0    0    0   0   0    1    1    30
[    1.277015]  01 003 0    0    0   0   0    1    1    31
[    1.282015]  02 000 1    0    0   0   0    0    0    00
[    1.288015]  03 003 1    1    0   1   0    1    1    33
[    1.293015]  04 003 0    0    0   0   0    1    1    34
[    1.298015]  05 003 1    1    0   1   0    1    1    35
[    1.304015]  06 003 <4>Clocksource tsc unstable (delta = 498304137 ns)
[    1.310026] 0    0    0   0   0    1    1    36
[    1.315027]  07 003 1    0    0   0   0    1    1    37
[    1.320015]  08 003 0    0    0   0   0    1    1    38
[    1.325015]  09 003 0    0    0   0   0    1    1    39
[    1.331051]  0a 003 0    0    0   0   0    1    1    3A
[    1.336015]  0b 003 1    1    0   1   0    1    1    3B
[    1.341015]  0c 003 0    0    0   0   0    1    1    3C
[    1.346015]  0d 003 0    0    0   0   0    1    1    3D
[    1.352015]  0e 003 0    0    0   0   0    1    1    3E
[    1.357015]  0f 003 0    0    0   0   0    1    1    3F
[    1.362015]  10 000 1    0    0   0   0    0    0    00
[    1.368015]  11 000 1    0    0   0   0    0    0    00
[    1.373015]  12 000 1    0    0   0   0    0    0    00
[    1.378015]  13 000 1    0    0   0   0    0    0    00
[    1.383015]  14 000 1    0    0   0   0    0    0    00
[    1.389015]  15 000 1    0    0   0   0    0    0    00
[    1.394020]  16 000 1    0    0   0   0    0    0    00
[    1.399015]  17 000 1    0    0   0   0    0    0    00
[    1.405012] IRQ to pin mappings:
[    1.408013] IRQ0 -> 0:0
[    1.410743] IRQ1 -> 0:1
[    1.413206] IRQ3 -> 0:3
[    1.415796] IRQ4 -> 0:4
[    1.418204] IRQ5 -> 0:5
[    1.420752] IRQ6 -> 0:6
[    1.423206] IRQ7 -> 0:7
[    1.425740] IRQ8 -> 0:8
[    1.428204] IRQ9 -> 0:9
[    1.431038] IRQ10 -> 0:10
[    1.433206] IRQ11 -> 0:11
[    1.436204] IRQ12 -> 0:12
[    1.439042] IRQ13 -> 0:13
[    1.441829] IRQ14 -> 0:14
[    1.444206] IRQ15 -> 0:15
[    1.447244] .................................... done.
[    1.452015] initcall print_all_ICs+0x0/0x17 returned 0 after 473633 usecs
[    1.459015] calling  hpet_late_init+0x0/0x13b @ 1
[    1.463016] initcall hpet_late_init+0x0/0x13b returned -19 after 0 usecs
[    1.470015] calling  init_kmmio+0x0/0x2c @ 1
[    1.474031] initcall init_kmmio+0x0/0x2c returned 0 after 976 usecs
[    1.481015] calling  clocksource_done_booting+0x0/0x12 @ 1
[    1.486015] initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
[    1.494015] calling  ftrace_init_debugfs+0x0/0xe4 @ 1
[    1.499248] initcall ftrace_init_debugfs+0x0/0xe4 returned 0 after 0 usecs
[    1.506016] calling  rb_init_debugfs+0x0/0x2f @ 1
[    1.511111] initcall rb_init_debugfs+0x0/0x2f returned 0 after 0 usecs
[    1.517016] calling  tracer_init_debugfs+0x0/0x289 @ 1
[    1.522828] initcall tracer_init_debugfs+0x0/0x289 returned 0 after 976 usecs
[    1.530017] calling  init_trace_printk_function_export+0x0/0x48 @ 1
[    1.537032] initcall init_trace_printk_function_export+0x0/0x48 returned 0 after 0 usecs
[    1.545016] calling  all_annotated_branch_stats+0x0/0x41 @ 1
[    1.551264] Warning: could not register all branches stats
[    1.556017] initcall all_annotated_branch_stats+0x0/0x41 returned 1 after 4882 usecs
[    1.564016] initcall all_annotated_branch_stats+0x0/0x41 returned with error code 1 
[    1.572015] calling  init_annotated_branch_stats+0x0/0x41 @ 1
[    1.578032] Warning: could not register annotated branches stats
[    1.584016] initcall init_annotated_branch_stats+0x0/0x41 returned 1 after 5859 usecs
[    1.591016] initcall init_annotated_branch_stats+0x0/0x41 returned with error code 1 
[    1.599015] calling  stat_workqueue_init+0x0/0x41 @ 1
[    1.604035] initcall stat_workqueue_init+0x0/0x41 returned 0 after 0 usecs
[    1.611016] calling  event_trace_init+0x0/0x1fd @ 1
[    1.620325] Failed to register trace events module notifier
[    1.626024] initcall event_trace_init+0x0/0x1fd returned 0 after 9765 usecs
[    1.633017] calling  init_pipe_fs+0x0/0x8e @ 1
[    1.638393] initcall init_pipe_fs+0x0/0x8e returned 0 after 0 usecs
[    1.644020] calling  init_mnt_writers+0x0/0x82 @ 1
[    1.649018] initcall init_mnt_writers+0x0/0x82 returned 0 after 0 usecs
[    1.656028] calling  anon_inode_init+0x0/0x1bc @ 1
[    1.661340] initcall anon_inode_init+0x0/0x1bc returned 0 after 0 usecs
[    1.668017] calling  tomoyo_initerface_init+0x0/0x171 @ 1
[    1.673603] initcall tomoyo_initerface_init+0x0/0x171 returned 0 after 976 usecs
[    1.681017] calling  chr_dev_init+0x0/0xd2 @ 1
[    1.691344] initcall chr_dev_init+0x0/0xd2 returned 0 after 4882 usecs
[    1.697101] calling  firmware_class_init+0x0/0xa5 @ 1
[    1.703208] initcall firmware_class_init+0x0/0xa5 returned 0 after 0 usecs
[    1.710104] calling  init_pcmcia_bus+0x0/0xac @ 1
[    1.715238] initcall init_pcmcia_bus+0x0/0xac returned 0 after 0 usecs
[    1.722118] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    1.728086] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    1.735016] calling  cpufreq_gov_dbs_init+0x0/0x131 @ 1
[    1.741174] initcall cpufreq_gov_dbs_init+0x0/0x131 returned 0 after 0 usecs
[    1.748098] calling  pcibios_assign_resources+0x0/0x107 @ 1
[    1.754210] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    1.760019] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    1.765023] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    1.771016] pci 0000:00:09.0:   PREFETCH window: disabled
[    1.777024] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    1.783014] pci 0000:00:0b.0:   IO window: disabled
[    1.788021] pci 0000:00:0b.0:   MEM window: disabled
[    1.793019] pci 0000:00:0b.0:   PREFETCH window: disabled
[    1.798024] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    1.804014] pci 0000:00:0c.0:   IO window: disabled
[    1.809021] pci 0000:00:0c.0:   MEM window: disabled
[    1.814019] pci 0000:00:0c.0:   PREFETCH window: disabled
[    1.819024] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    1.825014] pci 0000:00:0d.0:   IO window: disabled
[    1.830021] pci 0000:00:0d.0:   MEM window: disabled
[    1.835019] pci 0000:00:0d.0:   PREFETCH window: disabled
[    1.841034] pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
[    1.851017] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    1.857017] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    1.862021] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    1.868019] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    1.876108] pci 0000:00:09.0: setting latency timer to 64
[    1.881029] pci 0000:00:0b.0: setting latency timer to 64
[    1.887029] pci 0000:00:0c.0: setting latency timer to 64
[    1.892029] pci 0000:00:0d.0: setting latency timer to 64
[    1.897028] pci 0000:00:0e.0: setting latency timer to 64
[    1.903018] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.908015] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    1.915025] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
[    1.921015] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
[    1.927014] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    1.932014] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    1.938015] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    1.945015] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    1.950015] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    1.955015] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    1.960019] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    1.965022] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    1.971020] pci_bus 0000:03: resource 1 mem: [0x0-0x0]
[    1.976022] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    1.981022] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    1.986019] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    1.991020] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    1.996023] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    2.002019] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    2.007021] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    2.012020] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
[    2.019020] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xd7ffffff]
[    2.025023] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    2.030022] initcall pcibios_assign_resources+0x0/0x107 returned 0 after 269531 usecs
[    2.038022] calling  sysctl_core_init+0x0/0x38 @ 1
[    2.043231] initcall sysctl_core_init+0x0/0x38 returned 0 after 0 usecs
[    2.050021] calling  inet_init+0x0/0x275 @ 1
[    2.054076] NET: Registered protocol family 2
[    2.067755] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.079273] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.091225] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    2.106941] TCP: Hash tables configured (established 131072 bind 65536)
[    2.114109] TCP reno registered
[    2.119476] initcall inet_init+0x0/0x275 returned 0 after 64453 usecs
[    2.126018] calling  af_unix_init+0x0/0x6b @ 1
[    2.131033] NET: Registered protocol family 1
[    2.135083] initcall af_unix_init+0x0/0x6b returned 0 after 3906 usecs
[    2.142018] calling  populate_rootfs+0x0/0xe4 @ 1
[    2.147801] initcall populate_rootfs+0x0/0xe4 returned 0 after 0 usecs
[    2.154019] calling  calgary_fixup_tce_spaces+0x0/0x201 @ 1
[    2.160045] initcall calgary_fixup_tce_spaces+0x0/0x201 returned -19 after 0 usecs
[    2.167016] calling  i8259A_init_sysfs+0x0/0x3e @ 1
[    2.173180] initcall i8259A_init_sysfs+0x0/0x3e returned 0 after 976 usecs
[    2.180092] calling  vsyscall_init+0x0/0x6c @ 1
[    2.184062] initcall vsyscall_init+0x0/0x6c returned 0 after 976 usecs
[    2.191017] calling  sbf_init+0x0/0x184 @ 1
[    2.195016] initcall sbf_init+0x0/0x184 returned 0 after 0 usecs
[    2.201016] calling  i8237A_init_sysfs+0x0/0x3e @ 1
[    2.207200] initcall i8237A_init_sysfs+0x0/0x3e returned 0 after 976 usecs
[    2.214086] calling  add_rtc_cmos+0x0/0x42 @ 1
[    2.219209] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    2.226064] initcall add_rtc_cmos+0x0/0x42 returned 0 after 8789 usecs
[    2.233015] calling  ds_selftest+0x0/0xd4 @ 1
[    2.237016] initcall ds_selftest+0x0/0xd4 returned 0 after 0 usecs
[    2.244017] calling  cache_sysfs_init+0x0/0xd8 @ 1
[    2.252205] initcall cache_sysfs_init+0x0/0xd8 returned 0 after 2929 usecs
[    2.259128] calling  msr_init+0x0/0x1cd @ 1
[    2.265203] initcall msr_init+0x0/0x1cd returned 0 after 1953 usecs
[    2.271022] calling  cpuid_init+0x0/0x1ce @ 1
[    2.277406] initcall cpuid_init+0x0/0x1ce returned 0 after 1953 usecs
[    2.284052] calling  ioapic_init_sysfs+0x0/0x11b @ 1
[    2.289253] initcall ioapic_init_sysfs+0x0/0x11b returned 0 after 0 usecs
[    2.296096] calling  add_pcspkr+0x0/0x45 @ 1
[    2.301212] initcall add_pcspkr+0x0/0x45 returned 0 after 976 usecs
[    2.307096] calling  start_periodic_check_for_corruption+0x0/0x5c @ 1
[    2.314015] Scanning for low memory corruption every 60 seconds
[    2.320033] initcall start_periodic_check_for_corruption+0x0/0x5c returned 0 after 5859 usecs
[    2.328017] calling  audit_classes_init+0x0/0xaf @ 1
[    2.333035] initcall audit_classes_init+0x0/0xaf returned 0 after 0 usecs
[    2.340017] calling  start_pageattr_test+0x0/0x89 @ 1
[    2.345289] initcall start_pageattr_test+0x0/0x89 returned 0 after 0 usecs
[    2.346096] calling  pt_dump_init+0x0/0x44 @ 1
[    2.347048] initcall pt_dump_init+0x0/0x44 returned 0 after 0 usecs
[    2.348019] calling  init_vdso_vars+0x0/0x22f @ 1
[    2.349123] initcall init_vdso_vars+0x0/0x22f returned 0 after 0 usecs
[    2.351018] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    2.352082] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 usecs
[    2.353086] calling  sysenter_setup+0x0/0xd0 @ 1
[    2.354025] initcall sysenter_setup+0x0/0xd0 returned 0 after 0 usecs
[    2.355016] calling  init_sched_debug_procfs+0x0/0x40 @ 1
[    2.356037] initcall init_sched_debug_procfs+0x0/0x40 returned 0 after 0 usecs
[    2.357085] calling  proc_schedstat_init+0x0/0x22 @ 1
[    2.358026] initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 usecs
[    2.359016] calling  proc_execdomains_init+0x0/0x22 @ 1
[    2.360033] initcall proc_execdomains_init+0x0/0x22 returned 0 after 0 usecs
[    2.361085] calling  ioresources_init+0x0/0x3c @ 1
[    2.362035] initcall ioresources_init+0x0/0x3c returned 0 after 0 usecs
[    2.363016] calling  uid_cache_init+0x0/0xa3 @ 1
[    2.365087] initcall uid_cache_init+0x0/0xa3 returned 0 after 976 usecs
[    2.366016] calling  init_posix_timers+0x0/0xe4 @ 1
[    2.367031] initcall init_posix_timers+0x0/0xe4 returned 0 after 0 usecs
[    2.368016] calling  init_posix_cpu_timers+0x0/0xb0 @ 1
[    2.369086] initcall init_posix_cpu_timers+0x0/0xb0 returned 0 after 0 usecs
[    2.370016] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    2.371021] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
[    2.372016] calling  timekeeping_init_device+0x0/0x3e @ 1
[    2.374330] initcall timekeeping_init_device+0x0/0x3e returned 0 after 0 usecs
[    2.375093] calling  init_clocksource_sysfs+0x0/0x9c @ 1
[    2.377376] initcall init_clocksource_sysfs+0x0/0x9c returned 0 after 976 usecs
[    2.378084] calling  init_timer_list_procfs+0x0/0x40 @ 1
[    2.379029] initcall init_timer_list_procfs+0x0/0x40 returned 0 after 0 usecs
[    2.380016] calling  init_tstats_procfs+0x0/0x40 @ 1
[    2.381026] initcall init_tstats_procfs+0x0/0x40 returned 0 after 0 usecs
[    2.382083] calling  lockdep_proc_init+0x0/0x7c @ 1
[    2.383051] initcall lockdep_proc_init+0x0/0x7c returned 0 after 0 usecs
[    2.384015] calling  futex_init+0x0/0x99 @ 1
[    2.385058] initcall futex_init+0x0/0x99 returned 0 after 0 usecs
[    2.386088] calling  init_rttest+0x0/0x246 @ 1
[    2.392411] Initializing RT-Tester: OK
[    2.393162] initcall init_rttest+0x0/0x246 returned 0 after 5859 usecs
[    2.394018] calling  proc_dma_init+0x0/0x22 @ 1
[    2.395035] initcall proc_dma_init+0x0/0x22 returned 0 after 0 usecs
[    2.396016] calling  proc_modules_init+0x0/0x22 @ 1
[    2.397093] initcall proc_modules_init+0x0/0x22 returned 0 after 0 usecs
[    2.398016] calling  kallsyms_init+0x0/0x25 @ 1
[    2.399025] initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
[    2.400016] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
[    2.401122] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 0 usecs
[    2.402016] calling  crash_notes_memory_init+0x0/0x4c @ 1
[    2.403028] initcall crash_notes_memory_init+0x0/0x4c returned 0 after 0 usecs
[    2.405086] calling  pid_namespaces_init+0x0/0x2d @ 1
[    2.406052] initcall pid_namespaces_init+0x0/0x2d returned 0 after 0 usecs
[    2.407016] calling  ikconfig_init+0x0/0x50 @ 1
[    2.408028] initcall ikconfig_init+0x0/0x50 returned 0 after 0 usecs
[    2.409086] calling  audit_init+0x0/0x182 @ 1
[    2.410015] audit: initializing netlink socket (disabled)
[    2.412081] type=2000 audit(1240929699.412:1): initialized
[    2.413094] initcall audit_init+0x0/0x182 returned 0 after 2929 usecs
[    2.414016] calling  init_kprobes+0x0/0x22a @ 1
[    2.421355] initcall init_kprobes+0x0/0x22a returned 0 after 5859 usecs
[    2.423014] calling  rcuclassic_trace_init+0x0/0x225 @ 1
[    2.424150] initcall rcuclassic_trace_init+0x0/0x225 returned 0 after 0 usecs
[    2.425087] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    2.426058] sysctl table check failed: /kernel/ostype .1.1 No proc_handler
[    2.431018] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[    2.432014] Call Trace:
[    2.433090]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[    2.434018]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[    2.435019]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[    2.436020]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[    2.437087]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[    2.438019]  [<ffffffff816393a8>] ? utsname_sysctl_init+0x0/0x14
[    2.439019]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[    2.440017]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[    2.441087]  [<ffffffff816393b8>] utsname_sysctl_init+0x10/0x14
[    2.442018]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[    2.443018]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[    2.444035]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[    2.446019]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[    2.447019]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.448019]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.449087]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.450018]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.451019]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.452017]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[    2.454019]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.455018]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[    2.456018]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.457087]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[    2.458017]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.459018]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[    2.460019]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[    2.461088]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[    2.462018]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.463017]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.464018]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[    2.466019]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    2.467017]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[    2.468019]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[    2.470020]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[    2.471017]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[    2.472042] sysctl table check failed: /kernel/osrelease .1.2 No proc_handler
[    2.476015] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[    2.477083] Call Trace:
[    2.478018]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[    2.479018]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[    2.480018]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[    2.482020]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[    2.483017]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[    2.484018]  [<ffffffff816393a8>] ? utsname_sysctl_init+0x0/0x14
[    2.485088]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[    2.486018]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[    2.487017]  [<ffffffff816393b8>] utsname_sysctl_init+0x10/0x14
[    2.488017]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[    2.489087]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[    2.490018]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[    2.491018]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[    2.492018]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.493088]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.494018]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.495018]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.496018]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.497087]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[    2.499015]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.500018]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[    2.501087]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.502029]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[    2.503017]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.504018]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[    2.505087]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[    2.506018]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[    2.507017]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.508017]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.509087]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[    2.511018]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    2.512017]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[    2.513088]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[    2.515016]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[    2.516017]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[    2.517111] sysctl table check failed: /kernel/version .1.4 No proc_handler
[    2.521085] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[    2.522014] Call Trace:
[    2.523018]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[    2.524018]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[    2.525088]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[    2.526019]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[    2.527017]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[    2.528018]  [<ffffffff816393a8>] ? utsname_sysctl_init+0x0/0x14
[    2.529088]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[    2.530018]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[    2.531017]  [<ffffffff816393b8>] utsname_sysctl_init+0x10/0x14
[    2.532017]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[    2.534087]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[    2.535018]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[    2.536017]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[    2.537018]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.539089]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.540018]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.541018]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.542018]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.543086]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[    2.544017]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.545018]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[    2.546018]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.547087]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[    2.548018]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.549018]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[    2.550022]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[    2.552020]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[    2.553017]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.554017]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.555087]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[    2.556017]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    2.557017]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[    2.558018]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[    2.559088]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[    2.560017]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[    2.561042] sysctl table check failed: /kernel/hostname .1.7 No proc_handler
[    2.566015] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[    2.568015] Call Trace:
[    2.569018]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[    2.570018]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[    2.571088]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[    2.572019]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[    2.573018]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[    2.574018]  [<ffffffff816393a8>] ? utsname_sysctl_init+0x0/0x14
[    2.576020]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[    2.577018]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[    2.578017]  [<ffffffff816393b8>] utsname_sysctl_init+0x10/0x14
[    2.579087]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[    2.581018]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[    2.582018]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[    2.583087]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[    2.584018]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.585019]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.586018]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.588019]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.589018]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.590017]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[    2.591086]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.592018]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[    2.593018]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.594018]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[    2.595087]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.596043]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[    2.597018]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[    2.599089]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[    2.600017]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.601018]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.602017]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[    2.603087]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    2.604017]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[    2.605019]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[    2.606018]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[    2.607087]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[    2.608042] sysctl table check failed: /kernel/domainname .1.8 No proc_handler
[    2.612015] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[    2.613014] Call Trace:
[    2.614018]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[    2.615087]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[    2.616019]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[    2.617019]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[    2.618017]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[    2.620088]  [<ffffffff816393a8>] ? utsname_sysctl_init+0x0/0x14
[    2.621019]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[    2.622018]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[    2.623017]  [<ffffffff816393b8>] utsname_sysctl_init+0x10/0x14
[    2.624087]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[    2.625017]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[    2.626018]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[    2.627018]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[    2.628088]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.629019]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.630018]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[    2.631043]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.632088]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.633017]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[    2.634017]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.635018]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[    2.636087]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[    2.637018]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[    2.638018]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[    2.639018]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[    2.641020]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[    2.643019]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[    2.644087]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.645018]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[    2.646018]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[    2.647017]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    2.648087]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[    2.649019]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[    2.650019]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[    2.651017]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[    2.652090] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 220703 usecs
[    2.653016] calling  init_markers+0x0/0x17 @ 1
[    2.654016] initcall init_markers+0x0/0x17 returned 0 after 0 usecs
[    2.655015] calling  init_tracepoints+0x0/0x17 @ 1
[    2.656086] initcall init_tracepoints+0x0/0x17 returned 0 after 0 usecs
[    2.657016] calling  init_lstats_procfs+0x0/0x25 @ 1
[    2.658038] initcall init_lstats_procfs+0x0/0x25 returned 0 after 0 usecs
[    2.659016] calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
[    2.661020] initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 976 usecs
[    2.662016] calling  init_events+0x0/0x11c @ 1
[    2.663032] initcall init_events+0x0/0x11c returned 0 after 0 usecs
[    2.664087] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    2.665030] Testing tracer sched_switch: PASSED
[    2.768020] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 100586 usecs
[    2.769016] calling  init_stack_trace+0x0/0x12 @ 1
[    2.770019] Testing tracer sysprof: .. no entries found ..FAILED!
[    2.873820] initcall init_stack_trace+0x0/0x12 returned -1 after 100586 usecs
[    2.874016] initcall init_stack_trace+0x0/0x12 returned with error code -1 
[    2.875016] calling  init_function_trace+0x0/0x6a @ 1
[    2.876089] Testing tracer function: PASSED
[    2.986017] Testing dynamic ftrace: PASSED
[    3.220033] initcall init_function_trace+0x0/0x6a returned 0 after 335937 usecs
[    3.221018] calling  init_wakeup_tracer+0x0/0x60 @ 1
[    3.222022] Testing tracer wakeup: PASSED
[    3.530839] Testing tracer wakeup_rt: PASSED
[    3.839830] initcall init_wakeup_tracer+0x0/0x60 returned 0 after 602539 usecs
[    3.840019] calling  stack_trace_init+0x0/0x81 @ 1
[    3.842040] initcall stack_trace_init+0x0/0x81 returned 0 after 976 usecs
[    3.843090] calling  init_mmio_trace+0x0/0x12 @ 1
[    3.844022] initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
[    3.845017] calling  init_graph_trace+0x0/0x12 @ 1
[    3.847095] Testing tracer function_graph: <3>INFO: RCU detected CPU 0 stall (t=10000 jiffies)
[   13.856011] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[   13.856011] Call Trace:
[   13.856011]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff802118fb>] show_trace+0x15/0x17
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[   13.856011]  [<ffffffff8024c8c9>] ? cpumask_next+0x4/0x37
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[   13.856011]  [<ffffffff80250112>] ? tg_shares_up+0x20c/0x22c
[   13.856011]  [<ffffffff8024c8c9>] ? cpumask_next+0x4/0x37
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[   13.856011]  [<ffffffff802cd04f>] ? trace_clock_local+0x28/0x35
[   13.856011]  [<ffffffff802e7ab5>] ftrace_push_return_trace+0x84/0x108
[   13.856011]  [<ffffffff80250112>] ? tg_shares_up+0x20c/0x22c
[   13.856011]  [<ffffffff8022cfdd>] prepare_ftrace_return+0x104/0x164
[   13.856011]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[   13.856011]  [<ffffffff8024c8ce>] ? cpumask_next+0x9/0x37
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[   13.856011]  [<ffffffff8024ff06>] ? tg_shares_up+0x0/0x22c
[   13.856011]  [<ffffffff80247568>] ? tg_nop+0x0/0xd
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8025aba7>] walk_tg_tree+0xac/0x11a
[   13.856011]  [<ffffffff8025ffd6>] ? rebalance_domains+0xc0/0x2da
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8025b030>] update_shares+0x64/0x69
[   13.856011]  [<ffffffff8020c9d6>] ? ftrace_graph_caller+0x46/0x6d
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8025fa03>] load_balance+0xb6/0x5c9
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff802600e5>] rebalance_domains+0x1cf/0x2da
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff80260234>] run_rebalance_domains+0x44/0x153
[   13.856011]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[   13.856011]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   13.856011]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[   13.856011]  <EOI>  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[   13.856011]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[   13.856011]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[   13.856011]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[   13.856011]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[   13.856011]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[   13.856011]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[   13.856011]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[   13.856011]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[   13.856011]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[   13.856011]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[   13.856011]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[   13.856011]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[   43.855991] INFO: RCU detected CPU 0 stall (t=40000 jiffies)
[   43.856026] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[   43.857026] CPA self-test:
[   43.856026] Call Trace:
[   43.856026]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff802118fb>] show_trace+0x15/0x17
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[   43.856026]  [<ffffffff80275d96>] ? __mod_timer+0x11/0x181
[   43.856026]  [<ffffffff802dc5a0>] ? trace_graph_entry+0x20e/0x227
[   43.856026]  [<ffffffff80275d96>] ? __mod_timer+0x11/0x181
[   43.856026]  [<ffffffff80307d7a>] ? wb_timer_fn+0x0/0x49
[   43.856026]  [<ffffffff802dc645>] trace_graph_entry_watchdog+0x8c/0x91
[   43.856026]  [<ffffffff80275fc4>] ? mod_timer+0x39/0x3b
[   43.856026]  [<ffffffff8022d005>] prepare_ftrace_return+0x12c/0x164
[   43.856026]  [<ffffffff80275d96>] ? __mod_timer+0x11/0x181
[   43.856026]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[   43.856026]  [<ffffffff80275d9b>] ? __mod_timer+0x16/0x181
[   43.856026]  [<ffffffff8020c9d6>] ? ftrace_graph_caller+0x46/0x6d
[   43.856026]  [<ffffffff80307d7a>] ? wb_timer_fn+0x0/0x49
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[   43.856026]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[   43.856026]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff80275fc4>] mod_timer+0x39/0x3b
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff80307dc1>] wb_timer_fn+0x47/0x49
[   43.856026]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff80274fbb>] run_timer_softirq+0x23a/0x2ec
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[   43.856026]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[   43.856026]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[   43.856026]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[   43.856026]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   43.856026]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[   43.856026]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[   43.856026]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[   43.856026]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[   43.856026]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[   43.856026]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[   43.856026]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[   43.856026]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[   43.856026]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[   43.856026]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[   43.856026]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[   43.856026]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[   43.856026]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[   43.856026]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[   73.856028] INFO: RCU detected CPU 0 stall (t=70000 jiffies)
[   73.856032] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[   73.856032] Call Trace:
[   73.856032]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[   73.856032]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[   73.856032]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[   73.856032]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff802118fb>] show_trace+0x15/0x17
[   73.856032]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[   73.856032]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[   73.856032]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[   73.856032]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[   73.856032]  [<ffffffff802cd04f>] ? trace_clock_local+0x28/0x35
[   73.856032]  [<ffffffff802e7c40>] ? ftrace_return_to_handler+0x1e/0x9e
[   73.856032]  [<ffffffff8028a4d3>] ? hrtimer_run_pending+0x4/0x30
[   73.856032]  [<ffffffff80274dbe>] ? run_timer_softirq+0x3d/0x2ec
[   73.856032]  [<ffffffff8020ca0f>] ? return_to_handler+0x12/0x33
[   73.856032]  [<ffffffff80296287>] ? tick_check_oneshot_change+0x1b/0xc2
[   73.856032]  [<ffffffff8028a4e9>] ? hrtimer_run_pending+0x1a/0x30
[   73.856032]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[   73.856032]  [<ffffffff8029aef3>] ? mark_lock+0x22/0x177
[   73.856032]  [<ffffffff802e7c76>] ? ftrace_return_to_handler+0x54/0x9e
[   73.856032]  [<ffffffff802c5408>] ? rcu_bh_qsctr_inc+0x4/0x28
[   73.856032]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[   73.856032]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[   73.856032]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[   73.856032]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[   73.856032]  [<ffffffff8020f75a>] ? do_softirq+0x82/0x196
[   73.856032]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[   73.856032]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff80274dbe>] run_timer_softirq+0x3d/0x2ec
[   73.856032]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[   73.856032]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[   73.856032]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[   73.856032]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[   73.856032]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[   73.856032]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[   73.856032]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[   73.856032]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[   73.856032]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[   73.856032]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[   73.856032]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[   73.856032]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[   73.856032]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[   73.856032]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[   73.856032]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[   73.856032]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[   73.856032]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[   73.856032]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  103.856017] INFO: RCU detected CPU 0 stall (t=100000 jiffies)
[  103.856034] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  103.856034] Call Trace:
[  103.856034]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  103.856034]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  103.856034]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  103.856034]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  103.856034]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  103.856034]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  103.856034]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  103.856034]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  103.856034]  [<ffffffff802dc285>] ? trace_graph_return+0x105/0x113
[  103.856034]  [<ffffffff802e7c4d>] ? ftrace_return_to_handler+0x2b/0x9e
[  103.856034]  [<ffffffff80aa7158>] ? _spin_unlock_irqrestore+0x7/0xc5
[  103.856034]  [<ffffffff802c5ae9>] ? cpu_quiet+0x84/0xc0
[  103.856034]  [<ffffffff8020ca0f>] ? return_to_handler+0x12/0x33
[  103.856034]  [<ffffffff80aa7211>] ? _spin_unlock_irqrestore+0xc0/0xc5
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802c5ae9>] cpu_quiet+0x84/0xc0
[  103.856034]  [<ffffffff8020f75a>] ? do_softirq+0x82/0x196
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802c664c>] __rcu_process_callbacks+0xc0/0x117
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff802c66fe>] rcu_process_callbacks+0x5b/0x62
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  103.856034]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  103.856034]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  103.856034]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  103.856034]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  103.856034]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  103.856034]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  103.856034]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  103.856034]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  103.856034]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  103.856034]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  103.856034]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  103.856034]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  103.856034]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  103.856034]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  103.856034]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  103.856034]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  103.856034]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  133.856035] INFO: RCU detected CPU 0 stall (t=130000 jiffies)
[  133.856035] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  133.856035] Call Trace:
[  133.856035]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  133.856035]  [<ffffffff802dc285>] ? trace_graph_return+0x105/0x113
[  133.856035]  [<ffffffff802e7c4d>] ftrace_return_to_handler+0x2b/0x9e
[  133.856035]  [<ffffffff80aa7158>] ? _spin_unlock_irqrestore+0x7/0xc5
[  133.856035]  [<ffffffff80275ef4>] ? __mod_timer+0x16f/0x181
[  133.856035]  [<ffffffff8020ca0f>] return_to_handler+0x12/0x33
[  133.856035]  [<ffffffff80aa7211>] ? _spin_unlock_irqrestore+0xc0/0xc5
[  133.856035]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  133.856035]  [<ffffffff8020c9d6>] ? ftrace_graph_caller+0x46/0x6d
[  133.856035]  [<ffffffff80307d7a>] ? wb_timer_fn+0x0/0x49
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80275ef4>] __mod_timer+0x16f/0x181
[  133.856035]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[  133.856035]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80275fc4>] mod_timer+0x39/0x3b
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80307dc1>] wb_timer_fn+0x47/0x49
[  133.856035]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff80274fbb>] run_timer_softirq+0x23a/0x2ec
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  133.856035]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  133.856035]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  133.856035]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  133.856035]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  133.856035]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  133.856035]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  133.856035]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  133.856035]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  133.856035]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  133.856035]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  133.856035]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  133.856035]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  133.856035]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  133.856035]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  133.856035]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  133.856035]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  133.856035]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  133.856035]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  163.856020] INFO: RCU detected CPU 0 stall (t=160000 jiffies)
[  163.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  163.856036] Call Trace:
[  163.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  163.856036]  [<ffffffff8025afd5>] ? update_shares+0x9/0x69
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  163.856036]  [<ffffffff8025fa03>] ? load_balance+0xb6/0x5c9
[  163.856036]  [<ffffffff8025afd5>] ? update_shares+0x9/0x69
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  163.856036]  [<ffffffff802cd04f>] ? trace_clock_local+0x28/0x35
[  163.856036]  [<ffffffff8029b4bd>] ? trace_hardirqs_on+0xd/0xf
[  163.856036]  [<ffffffff802e7ab5>] ftrace_push_return_trace+0x84/0x108
[  163.856036]  [<ffffffff8025fa03>] ? load_balance+0xb6/0x5c9
[  163.856036]  [<ffffffff8022cfdd>] prepare_ftrace_return+0x104/0x164
[  163.856036]  [<ffffffff802538cf>] ? cpumask_setall+0x8/0x6e
[  163.856036]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[  163.856036]  [<ffffffff8025afda>] ? update_shares+0xe/0x69
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  163.856036]  [<ffffffff8025ffd6>] ? rebalance_domains+0xc0/0x2da
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  163.856036]  [<ffffffff8020c9d6>] ? ftrace_graph_caller+0x46/0x6d
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff802600e5>] rebalance_domains+0x1cf/0x2da
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff80260234>] run_rebalance_domains+0x44/0x153
[  163.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  163.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  163.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  163.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  163.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  163.856036]  [<ffffffff80aaea19>] smp_apic_timer_interrupt+0xa8/0xb6
[  163.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  163.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  163.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  163.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  163.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  163.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  163.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  163.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  163.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  163.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  163.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  163.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  163.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  193.856035] INFO: RCU detected CPU 0 stall (t=190000 jiffies)
[  193.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  193.856036] Call Trace:
[  193.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  193.856036]  [<ffffffff80275f8f>] ? mod_timer+0x4/0x3b
[  193.856036]  [<ffffffff802dc5a0>] ? trace_graph_entry+0x20e/0x227
[  193.856036]  [<ffffffff80275f8f>] ? mod_timer+0x4/0x3b
[  193.856036]  [<ffffffff80307d7a>] ? wb_timer_fn+0x0/0x49
[  193.856036]  [<ffffffff802dc645>] trace_graph_entry_watchdog+0x8c/0x91
[  193.856036]  [<ffffffff80307dc1>] ? wb_timer_fn+0x47/0x49
[  193.856036]  [<ffffffff8022d005>] prepare_ftrace_return+0x12c/0x164
[  193.856036]  [<ffffffff80275f8f>] ? mod_timer+0x4/0x3b
[  193.856036]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[  193.856036]  [<ffffffff80275f94>] ? mod_timer+0x9/0x3b
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  193.856036]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[  193.856036]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff80307dc1>] wb_timer_fn+0x47/0x49
[  193.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff80274fbb>] run_timer_softirq+0x23a/0x2ec
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  193.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  193.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  193.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  193.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  193.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  193.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  193.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  193.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  193.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  193.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  193.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  193.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  193.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  193.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  193.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  193.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  193.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  193.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  223.856015] INFO: RCU detected CPU 0 stall (t=220000 jiffies)
[  223.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  223.856036] Call Trace:
[  223.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  223.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  223.856036]  [<ffffffff802dc5a0>] ? trace_graph_entry+0x20e/0x227
[  223.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  223.856036]  [<ffffffff80307d7a>] ? wb_timer_fn+0x0/0x49
[  223.856036]  [<ffffffff802dc645>] trace_graph_entry_watchdog+0x8c/0x91
[  223.856036]  [<ffffffff80aa71e4>] ? _spin_unlock_irqrestore+0x93/0xc5
[  223.856036]  [<ffffffff8022d005>] prepare_ftrace_return+0x12c/0x164
[  223.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  223.856036]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[  223.856036]  [<ffffffff802a8436>] ? test_ti_thread_flag+0x9/0x13
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  223.856036]  [<ffffffff80307e5d>] ? wb_kupdate+0x0/0x1cd
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff80aa71e4>] _spin_unlock_irqrestore+0x93/0xc5
[  223.856036]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[  223.856036]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff803099ce>] pdflush_operation+0xeb/0xf9
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff80307d91>] wb_timer_fn+0x17/0x49
[  223.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff80274fbb>] run_timer_softirq+0x23a/0x2ec
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  223.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  223.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  223.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  223.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  223.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  223.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  223.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  223.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  223.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  223.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  223.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  223.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  223.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  223.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  223.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  223.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  223.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  223.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  253.856034] INFO: RCU detected CPU 0 stall (t=250000 jiffies)
[  253.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  253.856036] Call Trace:
[  253.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  253.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  253.856036]  [<ffffffff802dc5a0>] ? trace_graph_entry+0x20e/0x227
[  253.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  253.856036]  [<ffffffff80307d7a>] ? wb_timer_fn+0x0/0x49
[  253.856036]  [<ffffffff802dc645>] trace_graph_entry_watchdog+0x8c/0x91
[  253.856036]  [<ffffffff80aa71e4>] ? _spin_unlock_irqrestore+0x93/0xc5
[  253.856036]  [<ffffffff8022d005>] prepare_ftrace_return+0x12c/0x164
[  253.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  253.856036]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[  253.856036]  [<ffffffff802a8436>] ? test_ti_thread_flag+0x9/0x13
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  253.856036]  [<ffffffff80307e5d>] ? wb_kupdate+0x0/0x1cd
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff80aa71e4>] _spin_unlock_irqrestore+0x93/0xc5
[  253.856036]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[  253.856036]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff803099ce>] pdflush_operation+0xeb/0xf9
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff80307d91>] wb_timer_fn+0x17/0x49
[  253.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff80274fbb>] run_timer_softirq+0x23a/0x2ec
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  253.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  253.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  253.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  253.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  253.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  253.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  253.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  253.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  253.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  253.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  253.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  253.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  253.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  253.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  253.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  253.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  253.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  253.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  283.856036] INFO: RCU detected CPU 0 stall (t=280000 jiffies)
[  283.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  283.856036] Call Trace:
[  283.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  283.856036]  [<ffffffff8024c8c9>] ? cpumask_next+0x4/0x37
[  283.856036]  [<ffffffff802dc5a0>] ? trace_graph_entry+0x20e/0x227
[  283.856036]  [<ffffffff8024c8c9>] ? cpumask_next+0x4/0x37
[  283.856036]  [<ffffffff802dc645>] trace_graph_entry_watchdog+0x8c/0x91
[  283.856036]  [<ffffffff8024ffa4>] ? tg_shares_up+0x9e/0x22c
[  283.856036]  [<ffffffff8022d005>] prepare_ftrace_return+0x12c/0x164
[  283.856036]  [<ffffffff8024c8c9>] ? cpumask_next+0x4/0x37
[  283.856036]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[  283.856036]  [<ffffffff8024c8ce>] ? cpumask_next+0x9/0x37
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  283.856036]  [<ffffffff8024ff06>] ? tg_shares_up+0x0/0x22c
[  283.856036]  [<ffffffff80247568>] ? tg_nop+0x0/0xd
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8024ffa4>] tg_shares_up+0x9e/0x22c
[  283.856036]  [<ffffffff8025ffd6>] ? rebalance_domains+0xc0/0x2da
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8025aba7>] walk_tg_tree+0xac/0x11a
[  283.856036]  [<ffffffff8020c9d6>] ? ftrace_graph_caller+0x46/0x6d
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8025b030>] update_shares+0x64/0x69
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8025fa03>] load_balance+0xb6/0x5c9
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff802600e5>] rebalance_domains+0x1cf/0x2da
[  283.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff80260234>] run_rebalance_domains+0x44/0x153
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  283.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  283.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  283.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  283.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  283.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  283.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  283.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  283.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  283.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  283.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  283.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  283.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  283.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  283.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  283.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  283.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  283.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  283.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  313.856036] INFO: RCU detected CPU 0 stall (t=310000 jiffies)
[  313.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  313.856036] Call Trace:
[  313.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  313.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  313.856036]  [<ffffffff802dc5a0>] ? trace_graph_entry+0x20e/0x227
[  313.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  313.856036]  [<ffffffff80307d7a>] ? wb_timer_fn+0x0/0x49
[  313.856036]  [<ffffffff802dc645>] trace_graph_entry_watchdog+0x8c/0x91
[  313.856036]  [<ffffffff80aa7120>] ? _spin_unlock_irq+0x5d/0x8e
[  313.856036]  [<ffffffff8022d005>] prepare_ftrace_return+0x12c/0x164
[  313.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  313.856036]  [<ffffffff8020c9d6>] ftrace_graph_caller+0x46/0x6d
[  313.856036]  [<ffffffff802a8436>] ? test_ti_thread_flag+0x9/0x13
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  313.856036]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  313.856036]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff80aa7120>] _spin_unlock_irq+0x5d/0x8e
[  313.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff80274f77>] run_timer_softirq+0x1f6/0x2ec
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  313.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  313.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  313.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  313.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  313.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  313.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  313.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  313.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  313.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  313.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  313.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  313.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  313.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  313.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  313.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  313.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  313.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  313.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  343.856020] INFO: RCU detected CPU 0 stall (t=340000 jiffies)
[  343.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  343.856036] Call Trace:
[  343.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  343.856036]  [<ffffffff802dc285>] ? trace_graph_return+0x105/0x113
[  343.856036]  [<ffffffff802e7c4d>] ftrace_return_to_handler+0x2b/0x9e
[  343.856036]  [<ffffffff80aa70cc>] ? _spin_unlock_irq+0x9/0x8e
[  343.856036]  [<ffffffff8027505b>] ? run_timer_softirq+0x2da/0x2ec
[  343.856036]  [<ffffffff8020ca0f>] return_to_handler+0x12/0x33
[  343.856036]  [<ffffffff80aa714d>] ? _spin_unlock_irq+0x8a/0x8e
[  343.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  343.856036]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[  343.856036]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  343.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff8027505b>] run_timer_softirq+0x2da/0x2ec
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  343.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  343.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  343.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  343.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  343.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  343.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  343.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  343.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  343.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  343.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  343.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  343.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  343.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  343.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  343.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  343.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  343.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  343.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  373.856036] INFO: RCU detected CPU 0 stall (t=370000 jiffies)
[  373.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  373.856036] Call Trace:
[  373.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  373.856036]  [<ffffffff802dc285>] ? trace_graph_return+0x105/0x113
[  373.856036]  [<ffffffff802e7c4d>] ftrace_return_to_handler+0x2b/0x9e
[  373.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  373.856036]  [<ffffffff80aa7120>] ? _spin_unlock_irq+0x5d/0x8e
[  373.856036]  [<ffffffff8020ca0f>] return_to_handler+0x12/0x33
[  373.856036]  [<ffffffff802a8436>] ? test_ti_thread_flag+0x9/0x13
[  373.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  373.856036]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[  373.856036]  [<ffffffff8026f383>] ? __do_softirq+0x59/0x3b6
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff80aa7120>] _spin_unlock_irq+0x5d/0x8e
[  373.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff80274f77>] run_timer_softirq+0x1f6/0x2ec
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  373.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  373.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  373.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  373.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  373.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  373.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  373.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  373.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  373.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  373.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  373.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  373.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  373.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  373.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  373.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  373.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  373.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  373.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  403.855972] INFO: RCU detected CPU 0 stall (t=400000 jiffies)
[  403.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  403.856036] Call Trace:
[  403.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  403.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  403.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  403.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  403.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  403.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  403.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  403.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  403.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  403.856036]  [<ffffffff802dc5a0>] ? trace_graph_entry+0x20e/0x227
[  403.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  403.856036]  [<ffffffff802dc645>] ? trace_graph_entry_watchdog+0x8c/0x91
[  403.856036]  [<ffffffff80aa71e4>] ? _spin_unlock_irqrestore+0x93/0xc5
[  403.856036]  [<ffffffff8022d005>] ? prepare_ftrace_return+0x12c/0x164
[  403.856036]  [<ffffffff802a8431>] ? test_ti_thread_flag+0x4/0x13
[  403.856036]  [<ffffffff8020c9d6>] ? ftrace_graph_caller+0x46/0x6d
[  403.856036]  [<ffffffff802a8436>] ? test_ti_thread_flag+0x9/0x13
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff80aa71e4>] _spin_unlock_irqrestore+0x93/0xc5
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802c5ae9>] cpu_quiet+0x84/0xc0
[  403.856036]  [<ffffffff8020f75a>] ? do_softirq+0x82/0x196
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802c664c>] __rcu_process_callbacks+0xc0/0x117
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff802c66fe>] rcu_process_callbacks+0x5b/0x62
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  403.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  403.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  403.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  403.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  403.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  403.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  403.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  403.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  403.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  403.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  403.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  403.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  403.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  403.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  403.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  403.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  403.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  433.856036] INFO: RCU detected CPU 0 stall (t=430000 jiffies)
[  433.856036] Pid: 302, comm: kstop/0 Not tainted 2.6.30-rc3-tip #37050
[  433.856036] Call Trace:
[  433.856036]  <IRQ>  [<ffffffff802c677f>] check_cpu_stall+0x7a/0x11e
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff802105c8>] dump_trace+0x289/0x325
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff802118d9>] show_trace_log_lvl+0x51/0x5e
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff802118fb>] show_trace+0x15/0x17
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff80aa3362>] dump_stack+0x77/0x80
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff802c6841>] __rcu_pending+0x1e/0x16b
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff802c69ba>] rcu_pending+0x2c/0x5d
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff8027570c>] update_process_times+0x3c/0x7a
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff80294e16>] tick_periodic+0x7e/0x80
[  433.856036]  [<ffffffff802dc285>] ? trace_graph_return+0x105/0x113
[  433.856036]  [<ffffffff802e7c4d>] ftrace_return_to_handler+0x2b/0x9e
[  433.856036]  [<ffffffff803098ee>] ? pdflush_operation+0xb/0xf9
[  433.856036]  [<ffffffff80307d91>] ? wb_timer_fn+0x17/0x49
[  433.856036]  [<ffffffff8020ca0f>] return_to_handler+0x12/0x33
[  433.856036]  [<ffffffff803099ce>] ? pdflush_operation+0xeb/0xf9
[  433.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff80294e3a>] tick_handle_periodic+0x22/0xa4
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff80aaea0f>] smp_apic_timer_interrupt+0x9e/0xb6
[  433.856036]  [<ffffffff80274f03>] ? run_timer_softirq+0x182/0x2ec
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff80307d91>] wb_timer_fn+0x17/0x49
[  433.856036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff80274fbb>] run_timer_softirq+0x23a/0x2ec
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  433.856036]  [<ffffffff8020c9fd>] return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  433.856036]  <EOI>  [<ffffffff80aa422f>] ? preempt_schedule_irq+0x6d/0x98
[  433.856036]  [<ffffffff80aa422b>] ? preempt_schedule_irq+0x69/0x98
[  433.856036]  [<ffffffff8020c9fd>] ? return_to_handler+0x0/0x33
[  433.856036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  433.856036]  [<ffffffff802b532f>] ? stop_cpu+0x187/0x196
[  433.856036]  [<ffffffff8027fe94>] ? run_workqueue+0x20b/0x34a
[  433.856036]  [<ffffffff8027fe3b>] ? run_workqueue+0x1b2/0x34a
[  433.856036]  [<ffffffff80aa4053>] ? schedule+0x6ca/0x6f7
[  433.856036]  [<ffffffff802b51a8>] ? stop_cpu+0x0/0x196
[  433.856036]  [<ffffffff802800e0>] ? worker_thread+0x10d/0x123
[  433.856036]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  433.856036]  [<ffffffff8027ffd3>] ? worker_thread+0x0/0x123
[  433.856036]  [<ffffffff80285bb4>] ? kthread+0x71/0xb4
[  433.856036]  [<ffffffff8020ddba>] ? child_rip+0xa/0x20
[  433.856036]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  433.856036]  [<ffffffff80285b43>] ? kthread+0x0/0xb4
[  433.856036]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  437.970790] BUG: Function graph tracer hang!
[  437.971083] BUG: Function graph tracer hang!
[  437.986165]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[  438.035600]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[  438.074139] FAILED!
[  438.077176] initcall init_graph_trace+0x0/0x12 returned -1 after 424052767 usecs
[  438.084053] initcall init_graph_trace+0x0/0x12 returned with error code -1 
[  438.091052] calling  init_bts_trace+0x0/0x1e @ 1
[  438.096066] initcall init_bts_trace+0x0/0x1e returned 0 after 0 usecs
[  438.102126] calling  init_kmem_tracer+0x0/0x12 @ 1
[  438.116164]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[  438.125070] ok.
[  438.126099] initcall init_kmem_tracer+0x0/0x12 returned 0 after 18554 usecs
[  438.133059] calling  init_blk_tracer+0x0/0x83 @ 1
[  438.138059] initcall init_blk_tracer+0x0/0x83 returned 0 after 0 usecs
[  438.145051] calling  register_ftrace_syscalls+0x0/0x192 @ 1
[  438.150058] initcall register_ftrace_syscalls+0x0/0x192 returned 0 after 0 usecs
[  438.158077] calling  perf_counter_sysfs_init+0x0/0x19 @ 1
[  438.163082] initcall perf_counter_sysfs_init+0x0/0x19 returned 0 after 0 usecs
[  438.170052] calling  init_per_zone_pages_min+0x0/0xef @ 1
[  438.176144] initcall init_per_zone_pages_min+0x0/0xef returned 0 after 0 usecs
[  438.183051] calling  pdflush_init+0x0/0x2e @ 1
[  438.188219] initcall pdflush_init+0x0/0x2e returned 0 after 0 usecs
[  438.194055] calling  kswapd_init+0x0/0x78 @ 1
[  438.199174] initcall kswapd_init+0x0/0x78 returned 0 after 0 usecs
[  438.205052] calling  init_tmpfs+0x0/0x122 @ 1
[  438.209635] initcall init_tmpfs+0x0/0x122 returned 0 after 0 usecs
[  438.216052] calling  setup_vmstat+0x0/0xba @ 1
[  438.221130] initcall setup_vmstat+0x0/0xba returned 0 after 0 usecs
[  438.227051] calling  mm_sysfs_init+0x0/0x3d @ 1
[  438.232065] initcall mm_sysfs_init+0x0/0x3d returned 0 after 0 usecs
[  438.238051] calling  proc_vmalloc_init+0x0/0x25 @ 1
[  438.243062] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 0 usecs
[  438.250051] calling  procswaps_init+0x0/0x22 @ 1
[  438.254061] initcall procswaps_init+0x0/0x22 returned 0 after 0 usecs
[  438.261051] calling  hugetlb_init+0x0/0x3e8 @ 1
[  438.265055] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[  438.272091] initcall hugetlb_init+0x0/0x3e8 returned 0 after 6835 usecs
[  438.278051] calling  fasync_init+0x0/0x2a @ 1
[  438.283057] initcall fasync_init+0x0/0x2a returned 0 after 0 usecs
[  438.289051] calling  proc_filesystems_init+0x0/0x22 @ 1
[  438.294062] initcall proc_filesystems_init+0x0/0x22 returned 0 after 0 usecs
[  438.301051] calling  dnotify_init+0x0/0x2a @ 1
[  438.306058] initcall dnotify_init+0x0/0x2a returned 0 after 0 usecs
[  438.312051] calling  inotify_setup+0x0/0x12 @ 1
[  438.317051] initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
[  438.323051] calling  inotify_user_setup+0x0/0x112 @ 1
[  438.328394] initcall inotify_user_setup+0x0/0x112 returned 0 after 0 usecs
[  438.335052] calling  proc_locks_init+0x0/0x22 @ 1
[  438.340062] initcall proc_locks_init+0x0/0x22 returned 0 after 0 usecs
[  438.347051] calling  init_sys32_ioctl+0x0/0xd1 @ 1
[  438.351071] initcall init_sys32_ioctl+0x0/0xd1 returned 0 after 0 usecs
[  438.358051] calling  init_mbcache+0x0/0x14 @ 1
[  438.362055] initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
[  438.369051] calling  dquot_init+0x0/0x131 @ 1
[  438.373049] VFS: Disk quotas dquot_6.5.2
[  438.377344] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  438.384083] initcall dquot_init+0x0/0x131 returned 0 after 10742 usecs
[  438.390051] calling  proc_cmdline_init+0x0/0x22 @ 1
[  438.395062] initcall proc_cmdline_init+0x0/0x22 returned 0 after 0 usecs
[  438.402050] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[  438.407060] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 0 usecs
[  438.414050] calling  proc_devices_init+0x0/0x22 @ 1
[  438.419061] initcall proc_devices_init+0x0/0x22 returned 0 after 0 usecs
[  438.425050] calling  proc_interrupts_init+0x0/0x22 @ 1
[  438.430056] initcall proc_interrupts_init+0x0/0x22 returned 0 after 0 usecs
[  438.437050] calling  proc_loadavg_init+0x0/0x22 @ 1
[  438.442068] initcall proc_loadavg_init+0x0/0x22 returned 0 after 0 usecs
[  438.449051] calling  proc_meminfo_init+0x0/0x22 @ 1
[  438.454061] initcall proc_meminfo_init+0x0/0x22 returned 0 after 0 usecs
[  438.461050] calling  proc_stat_init+0x0/0x22 @ 1
[  438.465060] initcall proc_stat_init+0x0/0x22 returned 0 after 0 usecs
[  438.472050] calling  proc_uptime_init+0x0/0x22 @ 1
[  438.477060] initcall proc_uptime_init+0x0/0x22 returned 0 after 0 usecs
[  438.483050] calling  proc_version_init+0x0/0x22 @ 1
[  438.488060] initcall proc_version_init+0x0/0x22 returned 0 after 0 usecs
[  438.495050] calling  proc_kcore_init+0x0/0x5f @ 1
[  438.500061] initcall proc_kcore_init+0x0/0x5f returned 0 after 0 usecs
[  438.506050] calling  proc_kmsg_init+0x0/0x25 @ 1
[  438.511060] initcall proc_kmsg_init+0x0/0x25 returned 0 after 0 usecs
[  438.517050] calling  init_devpts_fs+0x0/0x81 @ 1
[  438.522627] initcall init_devpts_fs+0x0/0x81 returned 0 after 976 usecs
[  438.529050] calling  init_ext3_fs+0x0/0xcf @ 1
[  438.534137] initcall init_ext3_fs+0x0/0xcf returned 0 after 0 usecs
[  438.540051] calling  journal_init+0x0/0x35 @ 1
[  438.544112] initcall journal_init+0x0/0x35 returned 0 after 976 usecs
[  438.551051] calling  init_ramfs_fs+0x0/0x12 @ 1
[  438.556058] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[  438.562050] calling  init_hugetlbfs_fs+0x0/0x12b @ 1
[  438.567603] initcall init_hugetlbfs_fs+0x0/0x12b returned 0 after 0 usecs
[  438.574050] calling  init_minix_fs+0x0/0xa5 @ 1
[  438.579071] initcall init_minix_fs+0x0/0xa5 returned 0 after 0 usecs
[  438.585051] calling  init_fat_fs+0x0/0x96 @ 1
[  438.590065] initcall init_fat_fs+0x0/0x96 returned 0 after 0 usecs
[  438.596050] calling  init_vfat_fs+0x0/0x12 @ 1
[  438.600052] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[  438.607050] calling  init_bfs_fs+0x0/0xa4 @ 1
[  438.611060] initcall init_bfs_fs+0x0/0xa4 returned 0 after 0 usecs
[  438.617050] calling  init_nls_cp437+0x0/0x12 @ 1
[  438.622116] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[  438.628050] calling  init_nls_cp864+0x0/0x12 @ 1
[  438.633052] initcall init_nls_cp864+0x0/0x12 returned 0 after 0 usecs
[  438.639050] calling  init_nls_cp866+0x0/0x12 @ 1
[  438.644052] initcall init_nls_cp866+0x0/0x12 returned 0 after 0 usecs
[  438.650058] calling  init_nls_cp874+0x0/0x12 @ 1
[  438.655052] initcall init_nls_cp874+0x0/0x12 returned 0 after 0 usecs
[  438.662050] calling  init_nls_cp1250+0x0/0x12 @ 1
[  438.666052] initcall init_nls_cp1250+0x0/0x12 returned 0 after 0 usecs
[  438.673050] calling  init_nls_cp1251+0x0/0x12 @ 1
[  438.678052] initcall init_nls_cp1251+0x0/0x12 returned 0 after 0 usecs
[  438.684050] calling  init_nls_ascii+0x0/0x12 @ 1
[  438.689052] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[  438.695050] calling  init_nls_iso8859_6+0x0/0x12 @ 1
[  438.700052] initcall init_nls_iso8859_6+0x0/0x12 returned 0 after 0 usecs
[  438.707050] calling  init_nls_cp1255+0x0/0x12 @ 1
[  438.712052] initcall init_nls_cp1255+0x0/0x12 returned 0 after 0 usecs
[  438.718050] calling  init_nls_iso8859_14+0x0/0x12 @ 1
[  438.723052] initcall init_nls_iso8859_14+0x0/0x12 returned 0 after 0 usecs
[  438.730050] calling  init_nls_koi8_r+0x0/0x12 @ 1
[  438.735052] initcall init_nls_koi8_r+0x0/0x12 returned 0 after 0 usecs
[  438.742054] calling  init_nls_koi8_u+0x0/0x12 @ 1
[  438.746052] initcall init_nls_koi8_u+0x0/0x12 returned 0 after 0 usecs
[  438.753050] calling  init_nls_koi8_ru+0x0/0x5e @ 1
[  438.758053] initcall init_nls_koi8_ru+0x0/0x5e returned 0 after 0 usecs
[  438.764050] calling  init_hpfs_fs+0x0/0xa4 @ 1
[  438.769071] initcall init_hpfs_fs+0x0/0xa4 returned 0 after 0 usecs
[  438.775051] calling  init_autofs_fs+0x0/0x12 @ 1
[  438.780052] initcall init_autofs_fs+0x0/0x12 returned 0 after 0 usecs
[  438.786050] calling  init_adfs_fs+0x0/0xa4 @ 1
[  438.791060] initcall init_adfs_fs+0x0/0xa4 returned 0 after 0 usecs
[  438.797050] calling  init_udf_fs+0x0/0xa4 @ 1
[  438.801061] initcall init_udf_fs+0x0/0xa4 returned 0 after 0 usecs
[  438.807047] calling  init_omfs_fs+0x0/0x12 @ 1
[  438.812053] initcall init_omfs_fs+0x0/0x12 returned 0 after 0 usecs
[  438.818050] calling  init_jfs_fs+0x0/0x42b @ 1
[  438.823103] JFS: nTxBlock = 7145, nTxLock = 57167
[  438.838036] initcall init_jfs_fs+0x0/0x42b returned 0 after 14648 usecs
[  438.844053] calling  init_befs_fs+0x0/0xcd @ 1
[  438.849049] BeFS version: 0.9.3
[  438.852067] initcall init_befs_fs+0x0/0xcd returned 0 after 2929 usecs
[  438.859050] calling  init_btrfs_fs+0x0/0x122 @ 1
[  438.865460] Btrfs loaded
[  438.868092] initcall init_btrfs_fs+0x0/0x122 returned 0 after 4882 usecs
[  438.874051] calling  init_exofs+0x0/0xa4 @ 1
[  438.879063] initcall init_exofs+0x0/0xa4 returned 0 after 0 usecs
[  438.885050] calling  ipc_init+0x0/0x23 @ 1
[  438.889068] msgmni has been set to 1786
[  438.893071] initcall ipc_init+0x0/0x23 returned 0 after 3906 usecs
[  438.899050] calling  ipc_sysctl_init+0x0/0x14 @ 1
[  438.904091] sysctl table check failed: /kernel/shmmax .1.34 No proc_handler
[  438.911050] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  438.917048] Call Trace:
[  438.920093]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  438.925052]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  438.931052]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  438.937054]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  438.943051]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  438.949051]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  438.955052]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  438.961051]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  438.967051]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  438.972054]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  438.978052]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  438.984053]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  438.990051]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  438.997054]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.003052]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.009052]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.016054]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.022053]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.028051]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  439.034051]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.039052]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  439.045052]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.051052]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  439.057051]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.063051]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  439.069053]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  439.075052]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  439.080053]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.086051]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.092052]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  439.097051]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  439.104052]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  439.109052]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  439.114052]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  439.120084]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  439.125073] sysctl table check failed: /kernel/shmall .1.41 No proc_handler
[  439.132049] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  439.138047] Call Trace:
[  439.141052]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  439.146052]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  439.152087]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  439.158052]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  439.164051]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  439.170051]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  439.176091]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  439.182051]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  439.188051]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  439.193051]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  439.199051]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  439.205051]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  439.211051]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  439.218052]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.224053]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.230052]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.237052]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.243052]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.249051]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  439.255051]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.260052]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  439.266052]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.272051]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  439.278051]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.284086]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  439.290052]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  439.296071]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  439.301051]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.307051]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.313051]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  439.318051]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  439.325051]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  439.330052]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  439.335052]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  439.341051]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  439.346073] sysctl table check failed: /kernel/shmmni .1.45 No proc_handler
[  439.353049] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  439.359047] Call Trace:
[  439.362051]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  439.367051]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  439.373052]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  439.379053]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  439.385051]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  439.391051]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  439.397052]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  439.403051]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  439.409051]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  439.414051]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  439.420051]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  439.426051]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  439.432051]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  439.439066]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.445052]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.451049]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.458052]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.464052]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.470051]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  439.476085]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.481052]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  439.487051]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.493051]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  439.499051]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.505051]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  439.511051]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  439.517052]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  439.522052]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.528051]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.534051]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  439.539051]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  439.546051]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  439.551052]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  439.556052]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  439.562051]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  439.567072] sysctl table check failed: /kernel/msgmax .1.35 No proc_handler
[  439.574049] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  439.580047] Call Trace:
[  439.583051]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  439.588087]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  439.594052]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  439.600053]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  439.606051]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  439.612051]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  439.618052]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  439.624051]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  439.630051]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  439.635051]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  439.641051]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  439.647051]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  439.653051]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  439.660087]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.666053]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.673083]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.679051]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.685052]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.691051]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  439.697051]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.702097]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  439.709089]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.715053]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  439.720057]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.726058]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  439.732056]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  439.738057]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  439.743058]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.749059]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.755057]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  439.760057]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  439.767058]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  439.772057]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  439.777058]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  439.783056]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  439.788076] sysctl table check failed: /kernel/msgmni .1.42 No proc_handler
[  439.795057] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  439.801057] Call Trace:
[  439.804058]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  439.809056]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  439.815057]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  439.821057]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  439.827056]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  439.833056]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  439.839057]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  439.845056]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  439.851057]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  439.857056]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  439.862058]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  439.868060]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  439.874058]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  439.881053]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.887056]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.894058]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  439.900058]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.906058]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.912058]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  439.918057]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.923059]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  439.929057]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  439.936076]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  439.941058]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  439.947058]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  439.953058]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  439.959056]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  439.964059]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.970058]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  439.976057]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  439.981070]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  439.988058]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  439.993057]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  439.998054]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  440.004060]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  440.009075] sysctl table check failed: /kernel/msgmnb .1.36 No proc_handler
[  440.016064] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  440.022056] Call Trace:
[  440.025058]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  440.030057]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  440.036059]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  440.042055]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  440.048058]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  440.054057]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  440.060057]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  440.066056]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  440.072058]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  440.078057]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  440.083058]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  440.089060]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  440.095055]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  440.102057]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.108055]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.115059]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.121055]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  440.127060]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.133060]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  440.139055]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.145057]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  440.151057]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  440.157056]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  440.162059]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.168058]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  440.174058]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  440.180055]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  440.185060]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  440.191056]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  440.197056]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  440.202057]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  440.209057]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  440.214060]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  440.219059]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  440.225058]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  440.230075] sysctl table check failed: /kernel/sem .1.43 No proc_handler
[  440.237058] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  440.243056] Call Trace:
[  440.246060]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  440.251056]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  440.257056]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  440.263056]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  440.269057]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  440.275059]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  440.281084]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  440.287056]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  440.293058]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  440.298054]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  440.304057]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  440.310056]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  440.316055]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  440.322058]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.329058]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.335057]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.342058]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  440.348056]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.354058]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  440.359055]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.365058]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  440.371058]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  440.377058]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  440.383057]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.389057]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  440.395056]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  440.401082]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  440.406058]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  440.412056]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  440.418056]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  440.423058]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  440.430058]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  440.435055]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  440.440056]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  440.445057]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  440.451076] sysctl table check failed: /kernel/auto_msgmni  No proc_handler
[  440.458058] Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip #37050
[  440.464059] Call Trace:
[  440.466088]  [<ffffffff8028f5f2>] set_fail+0x63/0x6e
[  440.472102]  [<ffffffff8028fcf0>] sysctl_check_table+0x5ed/0x6da
[  440.478056]  [<ffffffff8028fd19>] sysctl_check_table+0x616/0x6da
[  440.484097]  [<ffffffff80271c11>] __register_sysctl_paths+0x10c/0x312
[  440.490057]  [<ffffffff80290cf2>] ? getnstimeofday+0xd0/0x138
[  440.496058]  [<ffffffff81641dd4>] ? ipc_sysctl_init+0x0/0x14
[  440.502058]  [<ffffffff80271e45>] register_sysctl_paths+0x2e/0x30
[  440.508058]  [<ffffffff80271e5f>] register_sysctl_table+0x18/0x1a
[  440.514058]  [<ffffffff81641de4>] ipc_sysctl_init+0x10/0x14
[  440.519057]  [<ffffffff80209096>] do_one_initcall+0x8b/0x217
[  440.525057]  [<ffffffff8029b1ba>] ? mark_held_locks+0x4d/0x6b
[  440.531055]  [<ffffffff80347516>] ? kmem_cache_free+0x131/0x21c
[  440.537058]  [<ffffffff8029b485>] ? trace_hardirqs_on_caller+0x124/0x14f
[  440.544162]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.550058]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.557057]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  440.563058]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  440.569056]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.575059]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  440.581058]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.586057]  [<ffffffff80559229>] ? _raw_spin_unlock+0x19a/0x1a4
[  440.592055]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  440.598055]  [<ffffffff80aa727c>] ? _spin_unlock+0x66/0x82
[  440.604059]  [<ffffffff803b92ed>] ? proc_register+0x1f2/0x1fd
[  440.610059]  [<ffffffff803b9518>] ? create_proc_entry+0xf1/0x118
[  440.616059]  [<ffffffff802c4c00>] ? register_irq_proc+0xca/0xff
[  440.622054]  [<ffffffff802c4cf7>] ? init_irq_proc+0xc2/0xd5
[  440.627057]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  440.633055]  [<ffffffff8161a140>] ? early_idt_handler+0x0/0x71
[  440.639056]  [<ffffffff8161a9dc>] kernel_init+0xa3/0x120
[  440.644059]  [<ffffffff80aa69d2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  440.651056]  [<ffffffff8020ddba>] child_rip+0xa/0x20
[  440.656057]  [<ffffffff8020d714>] ? restore_args+0x0/0x30
[  440.661058]  [<ffffffff8161a939>] ? kernel_init+0x0/0x120
[  440.667057]  [<ffffffff8020ddb0>] ? child_rip+0x0/0x20
[  440.672057] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 1726562 usecs
[  440.679058] calling  key_proc_init+0x0/0x87 @ 1
[  440.683073] initcall key_proc_init+0x0/0x87 returned 0 after 0 usecs
[  440.690058] calling  crypto_wq_init+0x0/0x60 @ 1
[  440.695261] initcall crypto_wq_init+0x0/0x60 returned 0 after 976 usecs
[  440.702055] calling  crypto_algapi_init+0x0/0xd @ 1
[  440.706242] initcall crypto_algapi_init+0x0/0xd returned 0 after 0 usecs
[  440.713051] calling  chainiv_module_init+0x0/0x12 @ 1
[  440.718677] initcall chainiv_module_init+0x0/0x12 returned 0 after 976 usecs
[  440.726051] calling  eseqiv_module_init+0x0/0x12 @ 1
[  440.731058] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[  440.738051] calling  seqiv_module_init+0x0/0x12 @ 1
[  440.743058] initcall seqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[  440.750051] calling  hmac_module_init+0x0/0x12 @ 1
[  440.754058] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[  440.761052] calling  crypto_xcbc_module_init+0x0/0x12 @ 1
[  440.766058] initcall crypto_xcbc_module_init+0x0/0x12 returned 0 after 0 usecs
[  440.774056] calling  md4_mod_init+0x0/0x12 @ 1
[  440.779419] initcall md4_mod_init+0x0/0x12 returned 0 after 976 usecs
[  440.786055] calling  md5_mod_init+0x0/0x12 @ 1
[  440.791423] initcall md5_mod_init+0x0/0x12 returned 0 after 976 usecs
[  440.798051] calling  rmd320_mod_init+0x0/0x12 @ 1
[  440.803149] initcall rmd320_mod_init+0x0/0x12 returned 0 after 976 usecs
[  440.809052] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[  440.815238] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 usecs
[  440.822055] calling  tgr192_mod_init+0x0/0xa1 @ 1
[  440.828042] initcall tgr192_mod_init+0x0/0xa1 returned 0 after 976 usecs
[  440.835128] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[  440.840058] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 0 usecs
[  440.847051] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[  440.853058] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[  440.860051] calling  crypto_module_init+0x0/0x12 @ 1
[  440.865057] initcall crypto_module_init+0x0/0x12 returned 0 after 0 usecs
[  440.872051] calling  crypto_ctr_module_init+0x0/0x6d @ 1
[  440.877064] initcall crypto_ctr_module_init+0x0/0x6d returned 0 after 0 usecs
[  440.884051] calling  des_generic_mod_init+0x0/0x67 @ 1
[  440.890378] initcall des_generic_mod_init+0x0/0x67 returned 0 after 976 usecs
[  440.897120] calling  blowfish_mod_init+0x0/0x12 @ 1
[  440.904200] initcall blowfish_mod_init+0x0/0x12 returned 0 after 1953 usecs
[  440.911055] calling  twofish_mod_init+0x0/0x12 @ 1
[  440.916317] initcall twofish_mod_init+0x0/0x12 returned 0 after 0 usecs
[  440.923128] calling  serpent_mod_init+0x0/0x6b @ 1
[  440.928273] initcall serpent_mod_init+0x0/0x6b returned 0 after 0 usecs
[  440.935058] calling  aes_init+0x0/0x12 @ 1
[  440.939150] initcall aes_init+0x0/0x12 returned 0 after 0 usecs
[  440.945056] calling  arc4_init+0x0/0x12 @ 1
[  440.950281] initcall arc4_init+0x0/0x12 returned 0 after 0 usecs
[  440.956055] calling  khazad_mod_init+0x0/0x12 @ 1
[  440.961221] initcall khazad_mod_init+0x0/0x12 returned 0 after 0 usecs
[  440.968056] calling  seed_init+0x0/0x12 @ 1
[  440.972151] initcall seed_init+0x0/0x12 returned 0 after 0 usecs
[  440.978056] calling  deflate_mod_init+0x0/0x12 @ 1
[  440.985088] initcall deflate_mod_init+0x0/0x12 returned 0 after 1953 usecs
[  440.992094] calling  crc32c_mod_init+0x0/0x12 @ 1
[  440.997352] initcall crc32c_mod_init+0x0/0x12 returned 0 after 976 usecs
[  441.004053] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[  441.009058] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[  441.017051] calling  krng_mod_init+0x0/0x12 @ 1
[  441.022242] alg: No test for stdrng (krng)
[  441.023141] initcall krng_mod_init+0x0/0x12 returned 0 after 1953 usecs
[  441.030052] calling  async_tx_init+0x0/0x16 @ 1
[  441.034049] async_tx: api initialized (sync-only)
[  441.039051] initcall async_tx_init+0x0/0x16 returned 0 after 4882 usecs
[  441.046050] calling  async_memcpy_init+0x0/0x8 @ 1
[  441.050051] initcall async_memcpy_init+0x0/0x8 returned 0 after 0 usecs
[  441.057051] calling  async_xor_init+0x0/0x8 @ 1
[  441.062051] initcall async_xor_init+0x0/0x8 returned 0 after 0 usecs
[  441.068051] calling  proc_genhd_init+0x0/0x3c @ 1
[  441.073081] initcall proc_genhd_init+0x0/0x3c returned 0 after 0 usecs
[  441.079051] calling  noop_init+0x0/0x14 @ 1
[  441.084052] io scheduler noop registered
[  441.088070] initcall noop_init+0x0/0x14 returned 0 after 4882 usecs
[  441.094050] calling  as_init+0x0/0x14 @ 1
[  441.098050] io scheduler anticipatory registered (default)
[  441.103051] initcall as_init+0x0/0x14 returned 0 after 4882 usecs
[  441.109051] calling  debug_objects_init_debugfs+0x0/0xa6 @ 1
[  441.115113] initcall debug_objects_init_debugfs+0x0/0xa6 returned 0 after 0 usecs
[  441.123051] calling  libcrc32c_mod_init+0x0/0x5a @ 1
[  441.128059] initcall libcrc32c_mod_init+0x0/0x5a returned 0 after 0 usecs
[  441.135162] calling  init_kmp+0x0/0x12 @ 1
[  441.139123] initcall init_kmp+0x0/0x12 returned 0 after 0 usecs
[  441.145051] calling  init_bm+0x0/0x12 @ 1
[  441.149052] initcall init_bm+0x0/0x12 returned 0 after 0 usecs
[  441.155082] calling  init_fsm+0x0/0x12 @ 1
[  441.159053] initcall init_fsm+0x0/0x12 returned 0 after 0 usecs
[  441.165051] calling  percpu_counter_startup+0x0/0x19 @ 1
[  441.170056] initcall percpu_counter_startup+0x0/0x19 returned 0 after 0 usecs
[  441.177053] calling  pci_init+0x0/0x3a @ 1
[  441.181069] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.188053] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.194052] pci 0000:00:00.0: calling pci_fixup_video+0x0/0x144
[  441.200060] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.206175] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.213051] pci 0000:00:01.0: calling pci_fixup_video+0x0/0x144
[  441.219060] pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x3a
[  441.225054] pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0x13e
[  441.232051] pci 0000:00:01.1: calling pci_fixup_video+0x0/0x144
[  441.238060] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.244051] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.262243] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x144
[  441.269061] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x3a
[  441.275051] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x13e
[  441.282107] pci 0000:00:02.1: calling pci_fixup_video+0x0/0x144
[  441.288077] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.294051] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.300050] pci 0000:00:04.0: calling pci_fixup_video+0x0/0x144
[  441.306058] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.313051] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.319050] pci 0000:00:06.0: calling pci_fixup_video+0x0/0x144
[  441.325058] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.332051] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.338050] pci 0000:00:09.0: calling pci_fixup_video+0x0/0x144
[  441.344058] pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.350050] pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.357050] pci 0000:00:0a.0: calling pci_fixup_video+0x0/0x144
[  441.363058] pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xb0
[  441.371052] pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.377050] pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.383072] pci 0000:00:0b.0: calling pci_fixup_video+0x0/0x144
[  441.389058] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xb0
[  441.397052] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.403050] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.410050] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0x144
[  441.416058] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xb0
[  441.423081] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.430050] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.436051] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0x144
[  441.442058] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xb0
[  441.450052] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.456050] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.463050] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0x144
[  441.469060] pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x69
[  441.475059] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.481050] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.488050] pci 0000:00:18.0: calling pci_fixup_video+0x0/0x144
[  441.494058] pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x69
[  441.500056] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x3a
[  441.506050] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x13e
[  441.513050] pci 0000:00:18.1: calling pci_fixup_video+0x0/0x144
[  441.519058] pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x69
[  441.525056] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x3a
[  441.531050] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x13e
[  441.538050] pci 0000:00:18.2: calling pci_fixup_video+0x0/0x144
[  441.544063] pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x69
[  441.550056] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x3a
[  441.556051] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x13e
[  441.562072] pci 0000:00:18.3: calling pci_fixup_video+0x0/0x144
[  441.568059] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.575050] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.581050] pci 0000:05:07.0: calling pci_fixup_video+0x0/0x144
[  441.587058] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x3a
[  441.594050] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x13e
[  441.600050] pci 0000:01:00.0: calling pci_fixup_video+0x0/0x144
[  441.606054] pci 0000:01:00.0: Boot video device
[  441.611058] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x3a
[  441.617050] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x13e
[  441.624050] pci 0000:01:00.1: calling pci_fixup_video+0x0/0x144
[  441.630057] initcall pci_init+0x0/0x3a returned 0 after 438476 usecs
[  441.636050] calling  pci_proc_init+0x0/0x6a @ 1
[  441.641426] initcall pci_proc_init+0x0/0x6a returned 0 after 0 usecs
[  441.647051] calling  platform_lcd_init+0x0/0x12 @ 1
[  441.653165] initcall platform_lcd_init+0x0/0x12 returned 0 after 976 usecs
[  441.660092] calling  genericbl_init+0x0/0x12 @ 1
[  441.665215] initcall genericbl_init+0x0/0x12 returned 0 after 976 usecs
[  441.671050] calling  kb3886_init+0x0/0x12 @ 1
[  441.676051] initcall kb3886_init+0x0/0x12 returned -19 after 0 usecs
[  441.682051] calling  display_class_init+0x0/0xb2 @ 1
[  441.687192] initcall display_class_init+0x0/0xb2 returned 0 after 976 usecs
[  441.695052] calling  regulator_fixed_voltage_init+0x0/0x12 @ 1
[  441.701163] initcall regulator_fixed_voltage_init+0x0/0x12 returned 0 after 976 usecs
[  441.709087] calling  regulator_virtual_consumer_init+0x0/0x12 @ 1
[  441.715292] initcall regulator_virtual_consumer_init+0x0/0x12 returned 0 after 0 usecs
[  441.723056] calling  rand_initialize+0x0/0x31 @ 1
[  441.728122] initcall rand_initialize+0x0/0x31 returned 0 after 0 usecs
[  441.734051] calling  tty_init+0x0/0x12b @ 1
[  441.771260] initcall tty_init+0x0/0x12b returned 0 after 31250 usecs
[  441.777055] calling  pty_init+0x0/0x12 @ 1
[  442.035135] initcall pty_init+0x0/0x12 returned 0 after 248046 usecs
[  442.041170] calling  sysrq_init+0x0/0x25 @ 1
[  442.045084] initcall sysrq_init+0x0/0x25 returned 0 after 976 usecs
[  442.052051] calling  epca_module_init+0x0/0xb @ 1
[  442.057081] DIGI epca driver version 1.3.0.1-LK2.6 loaded.
[  442.344323] initcall epca_module_init+0x0/0xb returned 0 after 280273 usecs
[  442.351066] calling  specialix_init_module+0x0/0xde @ 1
[  442.356050] sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
[  442.363049] sx: derived from work (c) D.Gorodchanin 1994-1996.
[  442.368048] sx: DTR/RTS pin is always RTS.
[  442.412281] sx0: specialix IO8+ Board at 0x100 not found.
[  442.418085] sx1: specialix IO8+ Board at 0x180 not found.
[  442.423061] sx2: specialix IO8+ Board at 0x250 not found.
[  442.429071] sx3: specialix IO8+ Board at 0x260 not found.
[  442.583283] sx: No specialix IO8+ boards detected.
[  442.588061] initcall specialix_init_module+0x0/0xde returned -5 after 226562 usecs
[  442.595062] initcall specialix_init_module+0x0/0xde returned with error code -5 
[  442.603052] calling  riscom8_init_module+0x0/0xb @ 1
[  442.608049] rc: SDL RISCom/8 card driver v1.1, (c) D.Gorodchanin 1994-1996.
[  442.633578] rc0: RISCom/8 Board at 0x220 not found.
[  442.639244] rc1: RISCom/8 Board at 0x240 not found.
[  442.644095] rc2: RISCom/8 Board at 0x250 not found.
[  442.649094] rc3: RISCom/8 Board at 0x260 not found.
[  442.729229] rc: No RISCom/8 boards detected.
[  442.733064] initcall riscom8_init_module+0x0/0xb returned -5 after 122070 usecs
[  442.741054] initcall riscom8_init_module+0x0/0xb returned with error code -5 
[  442.748051] calling  isicom_init+0x0/0x21d @ 1
[  442.753261] initcall isicom_init+0x0/0x21d returned 0 after 976 usecs
[  442.759112] calling  sx_init+0x0/0x167 @ 1
[  442.764280] initcall sx_init+0x0/0x167 returned 0 after 976 usecs
[  442.770063] calling  rio_init+0x0/0x1003 @ 1
[  442.778397] initcall rio_init+0x0/0x1003 returned -5 after 2929 usecs
[  442.784251] initcall rio_init+0x0/0x1003 returned with error code -5 
[  442.791052] calling  init+0x0/0x12 @ 1
[  442.795294] initcall init+0x0/0x12 returned 0 after 0 usecs
[  442.801144] calling  raw_init+0x0/0x138 @ 1
[  442.806408] initcall raw_init+0x0/0x138 returned 0 after 1953 usecs
[  442.813058] calling  i8k_init+0x0/0x7b @ 1
[  442.817061] initcall i8k_init+0x0/0x7b returned -19 after 0 usecs
[  442.823051] calling  timeriomem_rng_init+0x0/0x12 @ 1
[  442.829200] initcall timeriomem_rng_init+0x0/0x12 returned 0 after 976 usecs
[  442.836152] calling  mod_init+0x0/0x12b @ 1
[  442.840210] initcall mod_init+0x0/0x12b returned -19 after 0 usecs
[  442.847067] calling  pc8736x_gpio_init+0x0/0x426 @ 1
[  442.852365] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[  442.859136] platform pc8736x_gpio.0: no device found
[  442.865238] initcall pc8736x_gpio_init+0x0/0x426 returned -19 after 12695 usecs
[  442.872127] calling  nsc_gpio_init+0x0/0x16 @ 1
[  442.877056] nsc_gpio initializing
[  442.880051] initcall nsc_gpio_init+0x0/0x16 returned 0 after 2929 usecs
[  442.887064] calling  agp_init+0x0/0x3c @ 1
[  442.891050] Linux agpgart interface v0.103
[  442.895052] initcall agp_init+0x0/0x3c returned 0 after 3906 usecs
[  442.901057] calling  agp_intel_init+0x0/0x3f @ 1
[  442.906298] initcall agp_intel_init+0x0/0x3f returned 0 after 0 usecs
[  442.913144] calling  agp_sis_init+0x0/0x3f @ 1
[  442.918242] initcall agp_sis_init+0x0/0x3f returned 0 after 976 usecs
[  442.924125] calling  cn_proc_init+0x0/0x57 @ 1
[  442.929065] initcall cn_proc_init+0x0/0x57 returned 0 after 0 usecs
[  442.935057] calling  serial8250_init+0x0/0x186 @ 1
[  442.940050] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[  442.947707] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  442.958431] initcall serial8250_init+0x0/0x186 returned 0 after 17578 usecs
[  442.965109] calling  serial8250_pci_init+0x0/0x1b @ 1
[  442.971249] initcall serial8250_pci_init+0x0/0x1b returned 0 after 976 usecs
[  442.978164] calling  init_serial_cs+0x0/0x12 @ 1
[  442.983236] initcall init_serial_cs+0x0/0x12 returned 0 after 0 usecs
[  442.990334] calling  topology_sysfs_init+0x0/0xba @ 1
[  442.995131] initcall topology_sysfs_init+0x0/0xba returned 0 after 0 usecs
[  443.002051] calling  floppy_init+0x0/0x742 @ 1
[  443.006244] Floppy drive(s): fd0 is 1.44M
[  443.027796] FDC 0 is a post-1991 82077
[  443.034361] initcall floppy_init+0x0/0x742 returned 0 after 27343 usecs
[  443.041066] calling  cpqarray_init+0x0/0xbc @ 1
[  443.045050] Compaq SMART2 Driver (v 2.6.0)
[  443.051322] initcall cpqarray_init+0x0/0xbc returned -19 after 5859 usecs
[  443.058146] calling  DAC960_init_module+0x0/0x7f @ 1
[  443.064344] initcall DAC960_init_module+0x0/0x7f returned 0 after 976 usecs
[  443.071137] calling  carm_init+0x0/0x1b @ 1
[  443.076293] initcall carm_init+0x0/0x1b returned 0 after 976 usecs
[  443.082141] calling  ub_init+0x0/0xb6 @ 1
[  443.086259] usbcore: registered new interface driver ub
[  443.092201] initcall ub_init+0x0/0xb6 returned 0 after 5859 usecs
[  443.098058] calling  ibmasm_init+0x0/0x9b @ 1
[  443.103261] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[  443.110131] initcall ibmasm_init+0x0/0x9b returned 0 after 6835 usecs
[  443.116057] calling  init_kgdbts+0x0/0x2c @ 1
[  443.121051] initcall init_kgdbts+0x0/0x2c returned 0 after 0 usecs
[  443.127056] calling  c2port_init+0x0/0x6d @ 1
[  443.131049] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[  443.139233] initcall c2port_init+0x0/0x6d returned 0 after 7812 usecs
[  443.145057] calling  sm501_base_init+0x0/0x27 @ 1
[  443.151262] initcall sm501_base_init+0x0/0x27 returned 0 after 976 usecs
[  443.158126] calling  pasic3_base_init+0x0/0x19 @ 1
[  443.163345] initcall pasic3_base_init+0x0/0x19 returned -19 after 0 usecs
[  443.170137] calling  raid_init+0x0/0x12 @ 1
[  443.175414] initcall raid_init+0x0/0x12 returned 0 after 976 usecs
[  443.181135] calling  spi_transport_init+0x0/0x4a @ 1
[  443.187370] initcall spi_transport_init+0x0/0x4a returned 0 after 976 usecs
[  443.194125] calling  fc_transport_init+0x0/0x98 @ 1
[  443.201380] initcall fc_transport_init+0x0/0x98 returned 0 after 1953 usecs
[  443.208183] calling  ahc_linux_init+0x0/0xc6 @ 1
[  443.213270] initcall ahc_linux_init+0x0/0xc6 returned 0 after 0 usecs
[  443.220154] calling  init_sd+0x0/0x150 @ 1
[  443.224239] Driver 'sd' needs updating - please use bus_type methods
[  443.231239] initcall init_sd+0x0/0x150 returned 0 after 6835 usecs
[  443.237126] calling  init_ch_module+0x0/0x100 @ 1
[  443.242049] SCSI Media Changer driver v0.25 
[  443.247241] Driver 'ch' needs updating - please use bus_type methods
[  443.254272] initcall init_ch_module+0x0/0x100 returned 0 after 11718 usecs
[  443.261061] calling  osd_uld_init+0x0/0x130 @ 1
[  443.266392] Driver 'osd' needs updating - please use bus_type methods
[  443.273239] osd: LOADED open-osd 0.1.0
[  443.277125] initcall osd_uld_init+0x0/0x130 returned 0 after 11718 usecs
[  443.283051] calling  ahci_init+0x0/0x1b @ 1
[  443.288267] initcall ahci_init+0x0/0x1b returned 0 after 0 usecs
[  443.294135] calling  piix_init+0x0/0x45 @ 1
[  443.299237] initcall piix_init+0x0/0x45 returned 0 after 976 usecs
[  443.305068] calling  qs_ata_init+0x0/0x1b @ 1
[  443.310351] initcall qs_ata_init+0x0/0x1b returned 0 after 976 usecs
[  443.316067] calling  sis_init+0x0/0x1b @ 1
[  443.321293] initcall sis_init+0x0/0x1b returned 0 after 0 usecs
[  443.327061] calling  nv_init+0x0/0x1b @ 1
[  443.331230] initcall nv_init+0x0/0x1b returned 0 after 0 usecs
[  443.337057] calling  adma_ata_init+0x0/0x1b @ 1
[  443.342238] initcall adma_ata_init+0x0/0x1b returned 0 after 0 usecs
[  443.349066] calling  amd_init+0x0/0x1b @ 1
[  443.353222] pata_amd 0000:00:06.0: version 0.4.1
[  443.354354] pata_amd 0000:00:06.0: setting latency timer to 64
[  443.356172] scsi0 : pata_amd
[  443.358193] scsi1 : pata_amd
[  443.359339] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[  443.360052] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[  443.539088] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[  443.545056] ata1.00: 488397168 sectors, multi 1: LBA48 
[  443.551085] ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[  443.571103] ata1.00: configured for UDMA/100
[  443.575075] async_waiting @ 1682
[  443.576052] async_continuing @ 1682 after 0 usec
[  443.579542] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[  443.583771] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[  443.584149] sd 0:0:0:0: [sda] Write Protect is off
[  443.585054] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  443.586225] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  443.590402]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[  443.708459] sd 0:0:0:0: [sda] Attached SCSI disk
[  443.709413] async_waiting @ 1682
[  443.710124] async_continuing @ 1682 after 0 usec
[  443.875354] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[  443.881079] ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[  443.893470] ata2.01: configured for UDMA/33
[  443.899163] async_waiting @ 1682
[  443.900051] async_continuing @ 1682 after 0 usec
[  443.901371] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[  443.903264] work_for_cpu used greatest stack depth: 3352 bytes left
[  443.904270] initcall amd_init+0x0/0x1b returned 0 after 539062 usecs
[  443.911096] calling  cs5530_init+0x0/0x1b @ 1
[  443.916336] initcall cs5530_init+0x0/0x1b returned 0 after 976 usecs
[  443.922146] calling  efar_init+0x0/0x1b @ 1
[  443.927244] initcall efar_init+0x0/0x1b returned 0 after 0 usecs
[  443.933155] calling  hpt3x2n_init+0x0/0x1b @ 1
[  443.938244] initcall hpt3x2n_init+0x0/0x1b returned 0 after 0 usecs
[  443.944134] calling  it821x_init+0x0/0x1b @ 1
[  443.949238] initcall it821x_init+0x0/0x1b returned 0 after 0 usecs
[  443.956094] calling  netcell_init+0x0/0x1b @ 1
[  443.960237] initcall netcell_init+0x0/0x1b returned 0 after 0 usecs
[  443.967127] calling  optidma_init+0x0/0x1b @ 1
[  443.972226] initcall optidma_init+0x0/0x1b returned 0 after 976 usecs
[  443.978058] calling  marvell_init+0x0/0x1b @ 1
[  443.983238] initcall marvell_init+0x0/0x1b returned 0 after 0 usecs
[  443.989061] calling  mpiix_init+0x0/0x1b @ 1
[  443.994233] initcall mpiix_init+0x0/0x1b returned 0 after 0 usecs
[  444.000066] calling  oldpiix_init+0x0/0x1b @ 1
[  444.005242] initcall oldpiix_init+0x0/0x1b returned 0 after 0 usecs
[  444.011062] calling  pcmcia_init+0x0/0x12 @ 1
[  444.016235] initcall pcmcia_init+0x0/0x12 returned 0 after 0 usecs
[  444.022062] calling  pdc202xx_init+0x0/0x1b @ 1
[  444.027238] initcall pdc202xx_init+0x0/0x1b returned 0 after 0 usecs
[  444.034061] calling  radisys_init+0x0/0x1b @ 1
[  444.038236] initcall radisys_init+0x0/0x1b returned 0 after 976 usecs
[  444.045064] calling  rz1000_init+0x0/0x1b @ 1
[  444.050242] initcall rz1000_init+0x0/0x1b returned 0 after 976 usecs
[  444.056061] calling  sc1200_init+0x0/0x1b @ 1
[  444.061248] initcall sc1200_init+0x0/0x1b returned 0 after 0 usecs
[  444.067061] calling  sis_init+0x0/0x1b @ 1
[  444.072389] initcall sis_init+0x0/0x1b returned 0 after 976 usecs
[  444.078061] calling  e1000_init_module+0x0/0xb3 @ 1
[  444.083049] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[  444.089060] Copyright (c) 1999-2006 Intel Corporation.
[  444.095380] initcall e1000_init_module+0x0/0xb3 returned 0 after 11718 usecs
[  444.102061] calling  e1000_init_module+0x0/0x6b @ 1
[  444.107050] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[  444.113054] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[  444.119321] initcall e1000_init_module+0x0/0x6b returned 0 after 12695 usecs
[  444.127060] calling  ixgb_init_module+0x0/0x4c @ 1
[  444.132104] Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[  444.138055] Copyright (c) 1999-2008 Intel Corporation.
[  444.144375] initcall ixgb_init_module+0x0/0x4c returned 0 after 11718 usecs
[  444.151061] calling  enic_init_module+0x0/0x37 @ 1
[  444.156050] enic: Cisco 10G Ethernet Driver, ver 1.0.0.933
[  444.162237] initcall enic_init_module+0x0/0x37 returned 0 after 5859 usecs
[  444.169055] calling  jme_init_module+0x0/0x30 @ 1
[  444.174131] jme: JMicron JMC2XX ethernet driver version 1.0.4
[  444.180264] initcall jme_init_module+0x0/0x30 returned 0 after 5859 usecs
[  444.187061] calling  rr_init_module+0x0/0x1b @ 1
[  444.192237] initcall rr_init_module+0x0/0x1b returned 0 after 976 usecs
[  444.198058] calling  happy_meal_probe+0x0/0x1b @ 1
[  444.204185] initcall happy_meal_probe+0x0/0x1b returned 0 after 976 usecs
[  444.211067] calling  vortex_init+0x0/0xef @ 1
[  444.215233] initcall vortex_init+0x0/0xef returned 0 after 0 usecs
[  444.222071] calling  ne2k_pci_init+0x0/0x1b @ 1
[  444.226238] initcall ne2k_pci_init+0x0/0x1b returned 0 after 976 usecs
[  444.233059] calling  e100_init_module+0x0/0x71 @ 1
[  444.238049] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[  444.244054] e100: Copyright(c) 1999-2006 Intel Corporation
[  444.250239] initcall e100_init_module+0x0/0x71 returned 0 after 11718 usecs
[  444.257067] calling  tlan_probe+0x0/0x158 @ 1
[  444.261049] ThunderLAN driver v1.15a
[  444.265238] TLAN: 0 devices installed, PCI: 0  EISA: 0
[  444.271497] initcall tlan_probe+0x0/0x158 returned -19 after 9765 usecs
[  444.278052] calling  smsc9420_init_module+0x0/0x6c @ 1
[  444.283226] initcall smsc9420_init_module+0x0/0x6c returned 0 after 0 usecs
[  444.290055] calling  sis190_init_module+0x0/0x1b @ 1
[  444.296204] initcall sis190_init_module+0x0/0x1b returned 0 after 976 usecs
[  444.303058] calling  sis900_init_module+0x0/0x1b @ 1
[  444.308235] initcall sis900_init_module+0x0/0x1b returned 0 after 0 usecs
[  444.315055] calling  r6040_init+0x0/0x1b @ 1
[  444.320234] initcall r6040_init+0x0/0x1b returned 0 after 976 usecs
[  444.326052] calling  tg3_init+0x0/0x1b @ 1
[  444.331176] initcall tg3_init+0x0/0x1b returned 0 after 976 usecs
[  444.337051] calling  skge_init_module+0x0/0x93 @ 1
[  444.342237] initcall skge_init_module+0x0/0x93 returned 0 after 0 usecs
[  444.349061] calling  sky2_init_module+0x0/0x91 @ 1
[  444.354104] sky2 driver version 1.22
[  444.358223] initcall sky2_init_module+0x0/0x91 returned 0 after 3906 usecs
[  444.365059] calling  rhine_init+0x0/0x56 @ 1
[  444.369240] initcall rhine_init+0x0/0x56 returned 0 after 0 usecs
[  444.375061] calling  velocity_init_module+0x0/0x2f @ 1
[  444.381235] initcall velocity_init_module+0x0/0x2f returned 0 after 0 usecs
[  444.388061] calling  starfire_init+0x0/0x1b @ 1
[  444.393358] initcall starfire_init+0x0/0x1b returned 0 after 0 usecs
[  444.399104] calling  marvell_init+0x0/0x85 @ 1
[  444.407235] initcall marvell_init+0x0/0x85 returned 0 after 2929 usecs
[  444.414230] calling  davicom_init+0x0/0xa3 @ 1
[  444.420266] initcall davicom_init+0x0/0xa3 returned 0 after 1953 usecs
[  444.426245] calling  smsc_init+0x0/0x113 @ 1
[  444.433446] initcall smsc_init+0x0/0x113 returned 0 after 1953 usecs
[  444.440230] calling  broadcom_init+0x0/0x1b7 @ 1
[  444.448088] initcall broadcom_init+0x0/0x1b7 returned 0 after 3906 usecs
[  444.454139] calling  ip175c_init+0x0/0x12 @ 1
[  444.459243] initcall ip175c_init+0x0/0x12 returned 0 after 0 usecs
[  444.465134] calling  et1011c_init+0x0/0x12 @ 1
[  444.470243] initcall et1011c_init+0x0/0x12 returned 0 after 0 usecs
[  444.477124] calling  ste10Xp_init+0x0/0x3c @ 1
[  444.482290] initcall ste10Xp_init+0x0/0x3c returned 0 after 976 usecs
[  444.488127] calling  hamachi_init+0x0/0x1b @ 1
[  444.493295] initcall hamachi_init+0x0/0x1b returned 0 after 0 usecs
[  444.500140] calling  net_olddevs_init+0x0/0x27 @ 1
[  444.505058] initcall net_olddevs_init+0x0/0x27 returned 0 after 0 usecs
[  444.511056] calling  hp100_module_init+0x0/0x39 @ 1
[  444.517230] initcall hp100_module_init+0x0/0x39 returned 0 after 976 usecs
[  444.524139] calling  init_nic+0x0/0x1b @ 1
[  444.528235] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[  444.529122] forcedeth 0000:00:0a.0: setting latency timer to 64
[  444.530225] nv_probe: set workaround bit for reversed mac addr
[  445.045527] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:13:d4:dc:41:12
[  445.046051] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[  445.047312] initcall init_nic+0x0/0x1b returned 0 after 506835 usecs
[  445.054084] calling  ql3xxx_init_module+0x0/0x1b @ 1
[  445.059299] initcall ql3xxx_init_module+0x0/0x1b returned 0 after 0 usecs
[  445.066129] calling  macvlan_init_module+0x0/0x67 @ 1
[  445.071066] initcall macvlan_init_module+0x0/0x67 returned 0 after 0 usecs
[  445.078051] calling  rtl8139_init_module+0x0/0x1b @ 1
[  445.083245] 8139too Fast Ethernet driver 0.9.28
[  445.087309] eth1: RealTek RTL8139 at 0xffffc20000e78000, 00:c0:df:03:68:5d, IRQ 11
[  445.088049] eth1:  Identified 8139 chip type 'RTL-8139B'
[  445.089265] initcall rtl8139_init_module+0x0/0x1b returned 0 after 5859 usecs
[  445.096067] calling  eql_init_module+0x0/0x91 @ 1
[  445.101050] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[  445.111812] initcall eql_init_module+0x0/0x91 returned 0 after 10742 usecs
[  445.119051] calling  tun_init+0x0/0xc3 @ 1
[  445.123055] tun: Universal TUN/TAP device driver, 1.6
[  445.128054] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  445.135239] initcall tun_init+0x0/0xc3 returned 0 after 11718 usecs
[  445.141140] calling  rio_init+0x0/0x1b @ 1
[  445.146239] initcall rio_init+0x0/0x1b returned 0 after 0 usecs
[  445.152126] calling  amd8111e_init+0x0/0x1b @ 1
[  445.157234] initcall amd8111e_init+0x0/0x1b returned 0 after 0 usecs
[  445.163126] calling  dnet_init+0x0/0x12 @ 1
[  445.168230] initcall dnet_init+0x0/0x12 returned 0 after 0 usecs
[  445.174121] calling  arcnet_init+0x0/0x5d @ 1
[  445.178055] arcnet loaded.
[  445.181051] initcall arcnet_init+0x0/0x5d returned 0 after 2929 usecs
[  445.188056] calling  com90xx_init+0x0/0x54 @ 1
[  445.192053] arcnet: COM90xx chipset support
[  445.496861] S3: No ARCnet cards found.
[  445.501067] initcall com90xx_init+0x0/0x54 returned -5 after 301757 usecs
[  445.508051] initcall com90xx_init+0x0/0x54 returned with error code -5 
[  445.514091] calling  com20020pci_init+0x0/0x45 @ 1
[  445.519049] arcnet: COM20020 PCI support
[  445.524275] initcall com20020pci_init+0x0/0x45 returned 0 after 4882 usecs
[  445.531139] calling  init_tc589+0x0/0x12 @ 1
[  445.536304] initcall init_tc589+0x0/0x12 returned 0 after 976 usecs
[  445.542153] calling  init_nmclan_cs+0x0/0x12 @ 1
[  445.547234] initcall init_nmclan_cs+0x0/0x12 returned 0 after 0 usecs
[  445.554153] calling  init_ibmtr_cs+0x0/0x12 @ 1
[  445.559189] initcall init_ibmtr_cs+0x0/0x12 returned 0 after 976 usecs
[  445.565260] calling  catc_init+0x0/0x4f @ 1
[  445.570258] usbcore: registered new interface driver catc
[  445.576152] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[  445.582052] initcall catc_init+0x0/0x4f returned 0 after 11718 usecs
[  445.588057] calling  pegasus_init+0x0/0x5e @ 1
[  445.593050] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[  445.600239] usbcore: registered new interface driver pegasus
[  445.606151] initcall pegasus_init+0x0/0x5e returned 0 after 12695 usecs
[  445.613058] calling  cdc_init+0x0/0x1b @ 1
[  445.617235] usbcore: registered new interface driver cdc_ether
[  445.623140] initcall cdc_init+0x0/0x1b returned 0 after 5859 usecs
[  445.629051] calling  rndis_init+0x0/0x1b @ 1
[  445.634232] usbcore: registered new interface driver rndis_host
[  445.640135] initcall rndis_init+0x0/0x1b returned 0 after 5859 usecs
[  445.646058] calling  usbnet_init+0x0/0x2b @ 1
[  445.651063] initcall usbnet_init+0x0/0x2b returned 0 after 0 usecs
[  445.657063] calling  init_netwave_cs+0x0/0x12 @ 1
[  445.662236] initcall init_netwave_cs+0x0/0x12 returned 0 after 0 usecs
[  445.669064] calling  init_wavelan_cs+0x0/0x12 @ 1
[  445.674282] initcall init_wavelan_cs+0x0/0x12 returned 0 after 976 usecs
[  445.681134] calling  xircom_init+0x0/0x1b @ 1
[  445.685252] initcall xircom_init+0x0/0x1b returned 0 after 976 usecs
[  445.692059] calling  dmfe_init_module+0x0/0x199 @ 1
[  445.697055] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[  445.704279] initcall dmfe_init_module+0x0/0x199 returned 0 after 6835 usecs
[  445.711144] calling  w840_init+0x0/0x29 @ 1
[  445.715057] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[  445.715060]   http://www.scyld.com/network/drivers.html
[  445.729229] initcall w840_init+0x0/0x29 returned 0 after 13671 usecs
[  445.736126] calling  tulip_init+0x0/0x33 @ 1
[  445.740232] initcall tulip_init+0x0/0x33 returned 0 after 0 usecs
[  445.747159] calling  de4x5_module_init+0x0/0x1b @ 1
[  445.752236] initcall de4x5_module_init+0x0/0x1b returned 0 after 0 usecs
[  445.759093] calling  stir_init+0x0/0x1b @ 1
[  445.763231] usbcore: registered new interface driver stir4200
[  445.769063] initcall stir_init+0x0/0x1b returned 0 after 5859 usecs
[  445.775057] calling  via_ircc_init+0x0/0x87 @ 1
[  445.780232] initcall via_ircc_init+0x0/0x87 returned 0 after 0 usecs
[  445.787062] calling  irtty_sir_init+0x0/0x6b @ 1
[  445.791054] initcall irtty_sir_init+0x0/0x6b returned 0 after 0 usecs
[  445.798057] calling  sir_wq_init+0x0/0x49 @ 1
[  445.802182] initcall sir_wq_init+0x0/0x49 returned 0 after 0 usecs
[  445.809061] calling  actisys_sir_init+0x0/0x6b @ 1
[  445.813050] irda_register_dongle : registering dongle "Actisys ACT-220L" (2).
[  445.821173] irda_register_dongle : registering dongle "Actisys ACT-220L+" (3).
[  445.828054] initcall actisys_sir_init+0x0/0x6b returned 0 after 14648 usecs
[  445.835057] calling  old_belkin_sir_init+0x0/0x12 @ 1
[  445.840050] irda_register_dongle : registering dongle "Old Belkin SmartBeam" (7).
[  445.847054] initcall old_belkin_sir_init+0x0/0x12 returned 0 after 6835 usecs
[  445.855051] calling  ma600_sir_init+0x0/0x46 @ 1
[  445.859056] irda_register_dongle : registering dongle "MA600" (11).
[  445.866111] initcall ma600_sir_init+0x0/0x46 returned 0 after 6835 usecs
[  445.872057] calling  kingsun_init+0x0/0x1b @ 1
[  445.877237] usbcore: registered new interface driver kingsun-sir
[  445.883069] initcall kingsun_init+0x0/0x1b returned 0 after 5859 usecs
[  445.890051] calling  init_netconsole+0x0/0x1b6 @ 1
[  445.895063] console [netcon0] enabled
[  445.898055] netconsole: network logging started
[  445.903051] initcall init_netconsole+0x0/0x1b6 returned 0 after 7812 usecs
[  445.910062] calling  spidev_init+0x0/0xec @ 1
[  445.915255] initcall spidev_init+0x0/0xec returned 0 after 976 usecs
[  445.921136] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[  445.927061] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 0 usecs
[  445.934067] calling  pd6729_module_init+0x0/0x20 @ 1
[  445.939238] initcall pd6729_module_init+0x0/0x20 returned 0 after 0 usecs
[  445.946144] calling  uwb_subsys_init+0x0/0x79 @ 1
[  445.951239] initcall uwb_subsys_init+0x0/0x79 returned 0 after 0 usecs
[  445.958219] calling  wlp_subsys_init+0x0/0x8 @ 1
[  445.962052] initcall wlp_subsys_init+0x0/0x8 returned 0 after 0 usecs
[  445.969057] calling  ehci_hcd_init+0x0/0xb7 @ 1
[  445.973050] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[  445.980232] ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
[  445.982075] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[  445.983056] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[  445.984339] initcall ehci_hcd_init+0x0/0xb7 returned 0 after 10742 usecs
[  445.991066] calling  isp116x_init+0x0/0x52 @ 1
[  445.996050] 116x: driver isp116x-hcd, 03 Nov 2005
[  446.001392] initcall isp116x_init+0x0/0x52 returned 0 after 4882 usecs
[  446.007248] calling  ohci_hcd_mod_init+0x0/0xbd @ 1
[  446.013049] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[  446.019213] ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[  446.020058] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[  446.021054] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[  446.024167] initcall ohci_hcd_mod_init+0x0/0xbd returned 0 after 10742 usecs
[  446.031068] calling  uhci_hcd_init+0x0/0x106 @ 1
[  446.035050] uhci_hcd: USB Universal Host Controller Interface driver
[  446.042272] initcall uhci_hcd_init+0x0/0x106 returned 0 after 6835 usecs
[  446.049134] calling  isp1760_init+0x0/0x92 @ 1
[  446.054278] initcall isp1760_init+0x0/0x92 returned 0 after 0 usecs
[  446.061228] calling  wusbcore_init+0x0/0xa1 @ 1
[  446.066235] initcall wusbcore_init+0x0/0xa1 returned 0 after 976 usecs
[  446.072139] calling  acm_init+0x0/0x14c @ 1
[  446.077247] usbcore: registered new interface driver cdc_acm
[  446.083063] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[  446.091059] initcall acm_init+0x0/0x14c returned 0 after 13671 usecs
[  446.098051] calling  usblp_init+0x0/0x1b @ 1
[  446.102238] usbcore: registered new interface driver usblp
[  446.108062] initcall usblp_init+0x0/0x1b returned 0 after 5859 usecs
[  446.114063] calling  usbtmc_init+0x0/0x4e @ 1
[  446.119236] usbcore: registered new interface driver usbtmc
[  446.124069] initcall usbtmc_init+0x0/0x4e returned 0 after 4882 usecs
[  446.131051] calling  usb_usual_init+0x0/0x40 @ 1
[  446.137411] usbcore: registered new interface driver libusual
[  446.143078] initcall usb_usual_init+0x0/0x40 returned 0 after 6835 usecs
[  446.150089] calling  microtek_drv_init+0x0/0x1b @ 1
[  446.155241] usbcore: registered new interface driver microtekX6
[  446.161069] initcall microtek_drv_init+0x0/0x1b returned 0 after 6835 usecs
[  446.168051] calling  adu_init+0x0/0xd7 @ 1
[  446.172239] usbcore: registered new interface driver adutux
[  446.178061] adutux adutux (see www.ontrak.net) v0.0.13
[  446.183055] adutux is an experimental driver. Use at your own risk
[  446.189052] initcall adu_init+0x0/0xd7 returned 0 after 16601 usecs
[  446.195088] calling  appledisplay_init+0x0/0x71 @ 1
[  446.201247] usbcore: registered new interface driver appledisplay
[  446.207070] initcall appledisplay_init+0x0/0x71 returned 0 after 6835 usecs
[  446.214051] calling  ftdi_elan_init+0x0/0x1c2 @ 1
[  446.219056] driver ftdi-elan built at 12:41:19 on Apr 28 2009
[  446.226270] usbcore: registered new interface driver ftdi-elan
[  446.232143] initcall ftdi_elan_init+0x0/0x1c2 returned 0 after 12695 usecs
[  446.239059] calling  iowarrior_init+0x0/0x1b @ 1
[  446.244481] usbcore: registered new interface driver iowarrior
[  446.250133] initcall iowarrior_init+0x0/0x1b returned 0 after 6835 usecs
[  446.257058] calling  usb_led_init+0x0/0x50 @ 1
[  446.261285] usbcore: registered new interface driver usbled
[  446.267067] initcall usb_led_init+0x0/0x50 returned 0 after 5859 usecs
[  446.274051] calling  usb_rio_init+0x0/0x4e @ 1
[  446.279181] usbcore: registered new interface driver rio500
[  446.284271] rio500: v1.1:USB Rio 500 driver
[  446.289059] initcall usb_rio_init+0x0/0x4e returned 0 after 10742 usecs
[  446.296051] calling  usb_sevseg_init+0x0/0x51 @ 1
[  446.301357] usbcore: registered new interface driver usbsevseg
[  446.307151] initcall usb_sevseg_init+0x0/0x51 returned 0 after 6835 usecs
[  446.314058] calling  i8042_init+0x0/0x14d @ 1
[  446.322773] serio: i8042 KBD port at 0x60,0x64 irq 1
[  446.327204] serio: i8042 AUX port at 0x60,0x64 irq 12
[  446.332067] initcall i8042_init+0x0/0x14d returned 0 after 13671 usecs
[  446.339059] calling  serport_init+0x0/0x4a @ 1
[  446.343068] initcall serport_init+0x0/0x4a returned 0 after 976 usecs
[  446.350057] calling  serio_raw_init+0x0/0x1b @ 1
[  446.356472] initcall serio_raw_init+0x0/0x1b returned 0 after 976 usecs
[  446.363060] calling  emu_init+0x0/0x1b @ 1
[  446.367251] initcall emu_init+0x0/0x1b returned 0 after 976 usecs
[  446.374058] calling  ns558_init+0x0/0x3a @ 1
[  446.386753] initcall ns558_init+0x0/0x3a returned -19 after 8789 usecs
[  446.394056] calling  mousedev_init+0x0/0xea @ 1
[  446.399398] mice: PS/2 mouse device common for all mice
[  446.405069] initcall mousedev_init+0x0/0xea returned 0 after 6835 usecs
[  446.411058] calling  atkbd_init+0x0/0x1b @ 1
[  446.416291] initcall atkbd_init+0x0/0x1b returned 0 after 0 usecs
[  446.422056] calling  sunkbd_init+0x0/0x1b @ 1
[  446.427590] initcall sunkbd_init+0x0/0x1b returned 0 after 976 usecs
[  446.433091] calling  xtkbd_init+0x0/0x1b @ 1
[  446.438242] initcall xtkbd_init+0x0/0x1b returned 0 after 0 usecs
[  446.443743] input: AT Translated Set 2 keyboard as /class/input/input0
[  446.451071] calling  skbd_init+0x0/0x1b @ 1
[  446.455266] initcall skbd_init+0x0/0x1b returned 0 after 0 usecs
[  446.461081] calling  cobra_init+0x0/0x1b @ 1
[  446.466290] initcall cobra_init+0x0/0x1b returned 0 after 0 usecs
[  446.472062] calling  guillemot_init+0x0/0x1b @ 1
[  446.477287] initcall guillemot_init+0x0/0x1b returned 0 after 0 usecs
[  446.484061] calling  iforce_init+0x0/0x7d @ 1
[  446.489211] usbcore: registered new interface driver iforce
[  446.495277] initcall iforce_init+0x0/0x7d returned 0 after 6835 usecs
[  446.501128] calling  joydump_init+0x0/0x1b @ 1
[  446.506337] initcall joydump_init+0x0/0x1b returned 0 after 0 usecs
[  446.513191] calling  magellan_init+0x0/0x1b @ 1
[  446.518362] initcall magellan_init+0x0/0x1b returned 0 after 976 usecs
[  446.524238] calling  sw_init+0x0/0x1b @ 1
[  446.529279] initcall sw_init+0x0/0x1b returned 0 after 0 usecs
[  446.535130] calling  spaceball_init+0x0/0x1b @ 1
[  446.540235] initcall spaceball_init+0x0/0x1b returned 0 after 0 usecs
[  446.546058] calling  spaceorb_init+0x0/0x1b @ 1
[  446.551227] initcall spaceorb_init+0x0/0x1b returned 0 after 0 usecs
[  446.558055] calling  stinger_init+0x0/0x1b @ 1
[  446.562230] initcall stinger_init+0x0/0x1b returned 0 after 976 usecs
[  446.569052] calling  tmdc_init+0x0/0x1b @ 1
[  446.574203] initcall tmdc_init+0x0/0x1b returned 0 after 976 usecs
[  446.580058] calling  ad7877_init+0x0/0x12 @ 1
[  446.585252] initcall ad7877_init+0x0/0x12 returned 0 after 976 usecs
[  446.591051] calling  gunze_init+0x0/0x1b @ 1
[  446.596234] initcall gunze_init+0x0/0x1b returned 0 after 976 usecs
[  446.602055] calling  usbtouch_init+0x0/0x1b @ 1
[  446.607258] usbcore: registered new interface driver usbtouchscreen
[  446.613063] initcall usbtouch_init+0x0/0x1b returned 0 after 5859 usecs
[  446.620063] calling  tw_init+0x0/0x1b @ 1
[  446.624237] initcall tw_init+0x0/0x1b returned 0 after 0 usecs
[  446.630062] calling  ati_remote2_init+0x0/0x61 @ 1
[  446.635227] usbcore: registered new interface driver ati_remote2
[  446.641066] ati_remote2: ATI/Philips USB RF remote driver 0.3
[  446.647053] initcall ati_remote2_init+0x0/0x61 returned 0 after 11718 usecs
[  446.654057] calling  pcspkr_init+0x0/0x12 @ 1
[  446.659332] input: PC Speaker as /class/input/input1
[  446.664279] initcall pcspkr_init+0x0/0x12 returned 0 after 4882 usecs
[  446.671052] calling  rotary_encoder_init+0x0/0x12 @ 1
[  446.676234] initcall rotary_encoder_init+0x0/0x12 returned 0 after 0 usecs
[  446.683055] calling  i2o_iop_init+0x0/0x8e @ 1
[  446.688056] I2O subsystem v1.325
[  446.691050] i2o: max drivers = 8
[  446.696382] initcall i2o_iop_init+0x0/0x8e returned 0 after 7812 usecs
[  446.703181] calling  cmos_init+0x0/0x5f @ 1
[  446.708280] rtc_cmos: dev (254:0)
[  446.712180] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[  446.718117] rtc0: alarms up to one day, 114 bytes nvram
[  446.724296] initcall cmos_init+0x0/0x5f returned 0 after 16601 usecs
[  446.730136] calling  ds1286_init+0x0/0x12 @ 1
[  446.735240] initcall ds1286_init+0x0/0x12 returned 0 after 0 usecs
[  446.741137] calling  ds1305_init+0x0/0x12 @ 1
[  446.746238] initcall ds1305_init+0x0/0x12 returned 0 after 0 usecs
[  446.752071] calling  m41t94_init+0x0/0x12 @ 1
[  446.757279] initcall m41t94_init+0x0/0x12 returned 0 after 0 usecs
[  446.763061] calling  m48t35_init+0x0/0x12 @ 1
[  446.768277] initcall m48t35_init+0x0/0x12 returned 0 after 0 usecs
[  446.774063] calling  w1_init+0x0/0xf2 @ 1
[  446.778049] Driver for 1-wire Dallas network protocol.
[  446.784284] initcall w1_init+0x0/0xf2 returned 0 after 6835 usecs
[  446.791052] calling  matrox_w1_init+0x0/0x1b @ 1
[  446.796244] initcall matrox_w1_init+0x0/0x1b returned 0 after 976 usecs
[  446.802055] calling  ds_init+0x0/0x59 @ 1
[  446.807449] usbcore: registered new interface driver DS9490R
[  446.813064] initcall ds_init+0x0/0x59 returned 0 after 6835 usecs
[  446.819058] calling  w1_therm_init+0x0/0x59 @ 1
[  446.823195] initcall w1_therm_init+0x0/0x59 returned 0 after 976 usecs
[  446.830057] calling  w1_f2d_init+0x0/0x12 @ 1
[  446.834054] initcall w1_f2d_init+0x0/0x12 returned 0 after 0 usecs
[  446.841062] calling  w1_ds2760_init+0x0/0x2c @ 1
[  446.845049] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[  446.854061] initcall w1_ds2760_init+0x0/0x2c returned 0 after 8789 usecs
[  446.861051] calling  ds2760_battery_init+0x0/0x12 @ 1
[  446.866243] initcall ds2760_battery_init+0x0/0x12 returned 0 after 0 usecs
[  446.873055] calling  telephony_init+0x0/0x60 @ 1
[  446.878055] Linux telephony interface: v1.00
[  446.882067] initcall telephony_init+0x0/0x60 returned 0 after 3906 usecs
[  446.889057] calling  raid_init+0x0/0x12 @ 1
[  446.893116] md: raid1 personality registered for level 1
[  446.898053] initcall raid_init+0x0/0x12 returned 0 after 4882 usecs
[  446.905057] calling  raid5_init+0x0/0x2c @ 1
[  446.909050] md: raid6 personality registered for level 6
[  446.914050] md: raid5 personality registered for level 5
[  446.920056] md: raid4 personality registered for level 4
[  446.925058] initcall raid5_init+0x0/0x2c returned 0 after 15625 usecs
[  446.931080] calling  multipath_init+0x0/0x12 @ 1
[  446.936050] md: multipath personality registered for level -4
[  446.942058] initcall multipath_init+0x0/0x12 returned 0 after 5859 usecs
[  446.949052] calling  vhci_init+0x0/0x6d @ 1
[  446.953055] Bluetooth: Virtual HCI driver ver 1.2
[  446.958389] initcall vhci_init+0x0/0x6d returned 0 after 4882 usecs
[  446.964063] calling  init_bt3c_cs+0x0/0x12 @ 1
[  446.969240] initcall init_bt3c_cs+0x0/0x12 returned 0 after 0 usecs
[  446.976062] calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
[  446.981056] initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
[  446.989057] calling  i7300_idle_init+0x0/0x27b @ 1
[  446.994199] initcall i7300_idle_init+0x0/0x27b returned -19 after 0 usecs
[  447.001102] calling  gpio_trig_init+0x0/0x12 @ 1
[  447.005262] initcall gpio_trig_init+0x0/0x12 returned 0 after 976 usecs
[  447.012063] calling  dcdrbu_init+0x0/0x1b9 @ 1
[  447.017242] initcall dcdrbu_init+0x0/0x1b9 returned 0 after 0 usecs
[  447.023062] calling  dcdbas_init+0x0/0xad @ 1
[  447.028305] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[  447.036068] initcall dcdbas_init+0x0/0xad returned 0 after 7812 usecs
[  447.043052] calling  hifn_init+0x0/0x1e @ 1
[  447.047055] HIFN supports only 32-bit addresses.
[  447.052057] initcall hifn_init+0x0/0x1e returned -22 after 4882 usecs
[  447.058057] initcall hifn_init+0x0/0x1e returned with error code -22 
[  447.065080] calling  hid_init+0x0/0x78 @ 1
[  447.069283] initcall hid_init+0x0/0x78 returned 0 after 0 usecs
[  447.075057] calling  apple_init+0x0/0x54 @ 1
[  447.080268] initcall apple_init+0x0/0x54 returned 0 after 0 usecs
[  447.086055] calling  usb_mouse_init+0x0/0x4e @ 1
[  447.091227] usbcore: registered new interface driver usbmouse
[  447.097066] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[  447.103059] initcall usb_mouse_init+0x0/0x4e returned 0 after 11718 usecs
[  447.110079] calling  init+0x0/0x12 @ 1
[  447.114272] initcall init+0x0/0x12 returned 0 after 976 usecs
[  447.120124] calling  flow_cache_init+0x0/0x1e8 @ 1
[  447.125134] initcall flow_cache_init+0x0/0x1e8 returned 0 after 0 usecs
[  447.131053] calling  pg_init+0x0/0x1ef @ 1
[  447.135055] pktgen v2.70: Packet Generator for packet performance testing.
[  447.143321] initcall pg_init+0x0/0x1ef returned 0 after 7812 usecs
[  447.149131] calling  llc_init+0x0/0x4a @ 1
[  447.153056] initcall llc_init+0x0/0x4a returned 0 after 0 usecs
[  447.159057] calling  snap_init+0x0/0x4e @ 1
[  447.164131] initcall snap_init+0x0/0x4e returned 0 after 0 usecs
[  447.170057] calling  rif_init+0x0/0x8e @ 1
[  447.174160] initcall rif_init+0x0/0x8e returned 0 after 0 usecs
[  447.180057] calling  blackhole_module_init+0x0/0x12 @ 1
[  447.185059] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[  447.192056] calling  nat_init_module+0x0/0x12 @ 1
[  447.197118] initcall nat_init_module+0x0/0x12 returned 0 after 0 usecs
[  447.204056] calling  skbedit_init_module+0x0/0x12 @ 1
[  447.209087] initcall skbedit_init_module+0x0/0x12 returned 0 after 0 usecs
[  447.216056] calling  htb_module_init+0x0/0x12 @ 1
[  447.220052] initcall htb_module_init+0x0/0x12 returned 0 after 0 usecs
[  447.227061] calling  hfsc_init+0x0/0x12 @ 1
[  447.231052] initcall hfsc_init+0x0/0x12 returned 0 after 0 usecs
[  447.237056] calling  gred_module_init+0x0/0x12 @ 1
[  447.242052] initcall gred_module_init+0x0/0x12 returned 0 after 0 usecs
[  447.249143] calling  teql_init+0x0/0x156 @ 1
[  447.255004] initcall teql_init+0x0/0x156 returned 0 after 1953 usecs
[  447.262058] calling  multiq_module_init+0x0/0x12 @ 1
[  447.267058] initcall multiq_module_init+0x0/0x12 returned 0 after 0 usecs
[  447.274105] calling  netem_module_init+0x0/0x20 @ 1
[  447.279048] netem: version 1.2
[  447.282087] initcall netem_module_init+0x0/0x20 returned 0 after 2929 usecs
[  447.289056] calling  init_rsvp+0x0/0x12 @ 1
[  447.293122] initcall init_rsvp+0x0/0x12 returned 0 after 0 usecs
[  447.299056] calling  cls_flow_init+0x0/0x12 @ 1
[  447.304066] initcall cls_flow_init+0x0/0x12 returned 0 after 0 usecs
[  447.310061] calling  init_em_nbyte+0x0/0x12 @ 1
[  447.314161] initcall init_em_nbyte+0x0/0x12 returned 0 after 976 usecs
[  447.321056] calling  init_em_u32+0x0/0x12 @ 1
[  447.326088] initcall init_em_u32+0x0/0x12 returned 0 after 0 usecs
[  447.332056] calling  init_em_text+0x0/0x12 @ 1
[  447.336052] initcall init_em_text+0x0/0x12 returned 0 after 0 usecs
[  447.343091] calling  sysctl_ipv4_init+0x0/0x78 @ 1
[  447.350307] initcall sysctl_ipv4_init+0x0/0x78 returned 0 after 3906 usecs
[  447.358145] calling  ipip_init+0x0/0x9d @ 1
[  447.362051] IPv4 over IPv4 tunneling driver
[  447.368926] initcall ipip_init+0x0/0x9d returned 0 after 6835 usecs
[  447.376083] calling  init_syncookies+0x0/0x19 @ 1
[  447.380098] initcall init_syncookies+0x0/0x19 returned 0 after 0 usecs
[  447.387050] calling  ah4_init+0x0/0x8c @ 1
[  447.391067] initcall ah4_init+0x0/0x8c returned 0 after 0 usecs
[  447.397050] calling  esp4_init+0x0/0x8c @ 1
[  447.401059] initcall esp4_init+0x0/0x8c returned 0 after 0 usecs
[  447.407050] calling  tunnel4_init+0x0/0x92 @ 1
[  447.412059] initcall tunnel4_init+0x0/0x92 returned 0 after 0 usecs
[  447.418050] calling  hybla_register+0x0/0x12 @ 1
[  447.423056] TCP hybla registered
[  447.426052] initcall hybla_register+0x0/0x12 returned 0 after 2929 usecs
[  447.433061] calling  tcp_veno_register+0x0/0x14 @ 1
[  447.438049] TCP veno registered
[  447.441051] initcall tcp_veno_register+0x0/0x14 returned 0 after 2929 usecs
[  447.448057] calling  tcp_scalable_register+0x0/0x12 @ 1
[  447.453049] TCP scalable registered
[  447.456068] initcall tcp_scalable_register+0x0/0x12 returned 0 after 3906 usecs
[  447.464056] calling  xfrm_user_init+0x0/0x75 @ 1
[  447.468092] Initializing XFRM netlink socket
[  447.473152] initcall xfrm_user_init+0x0/0x75 returned 0 after 3906 usecs
[  447.480106] calling  inet6_init+0x0/0x502 @ 1
[  447.484198] NET: Registered protocol family 10
[  447.495056] lo: Disabled Privacy Extensions
[  447.512077] tunl0: Disabled Privacy Extensions
[  447.521100] initcall inet6_init+0x0/0x502 returned 0 after 37109 usecs
[  447.528058] calling  ah6_init+0x0/0x8c @ 1
[  447.532063] initcall ah6_init+0x0/0x8c returned 0 after 0 usecs
[  447.538057] calling  ipcomp6_init+0x0/0x8c @ 1
[  447.543106] initcall ipcomp6_init+0x0/0x8c returned 0 after 0 usecs
[  447.549056] calling  xfrm6_tunnel_init+0x0/0x16a @ 1
[  447.554158] initcall xfrm6_tunnel_init+0x0/0x16a returned 0 after 0 usecs
[  447.561059] calling  tunnel6_init+0x0/0x92 @ 1
[  447.565061] initcall tunnel6_init+0x0/0x92 returned 0 after 0 usecs
[  447.572082] calling  xfrm6_transport_init+0x0/0x17 @ 1
[  447.577060] initcall xfrm6_transport_init+0x0/0x17 returned 0 after 0 usecs
[  447.584057] calling  mip6_init+0x0/0xf5 @ 1
[  447.588058] Mobile IPv6
[  447.590056] initcall mip6_init+0x0/0xf5 returned 0 after 1953 usecs
[  447.597058] calling  packet_init+0x0/0x5d @ 1
[  447.601065] NET: Registered protocol family 17
[  447.606164] initcall packet_init+0x0/0x5d returned 0 after 4882 usecs
[  447.612059] calling  ipsec_pfkey_init+0x0/0xdc @ 1
[  447.617057] NET: Registered protocol family 15
[  447.621075] initcall ipsec_pfkey_init+0x0/0xdc returned 0 after 3906 usecs
[  447.628059] calling  ipx_init+0x0/0x16c @ 1
[  447.633071] NET: Registered protocol family 4
[  447.639312] initcall ipx_init+0x0/0x16c returned 0 after 6835 usecs
[  447.646062] calling  l2cap_init+0x0/0x132 @ 1
[  447.650107] Bluetooth: L2CAP ver 2.13
[  447.654049] Bluetooth: L2CAP socket layer initialized
[  447.659051] initcall l2cap_init+0x0/0x132 returned 0 after 8789 usecs
[  447.666056] calling  sco_init+0x0/0x138 @ 1
[  447.670058] Bluetooth: SCO (Voice Link) ver 0.6
[  447.674049] Bluetooth: SCO socket layer initialized
[  447.679057] initcall sco_init+0x0/0x138 returned 0 after 8789 usecs
[  447.686056] calling  hidp_init+0x0/0x8b @ 1
[  447.690054] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  447.696238] initcall hidp_init+0x0/0x8b returned 0 after 5859 usecs
[  447.702199] calling  dccp_init+0x0/0x487 @ 1
[  447.712981] CCID: Activated CCID 2 (TCP-like)
[  447.718071] CCID: Activated CCID 3 (TCP-Friendly Rate Control)
[  447.724120] initcall dccp_init+0x0/0x487 returned 0 after 16601 usecs
[  447.730061] calling  dccp_v4_init+0x0/0xc8 @ 1
[  447.737422] initcall dccp_v4_init+0x0/0xc8 returned 0 after 2929 usecs
[  447.744056] calling  dccp_v6_init+0x0/0xc8 @ 1
[  447.749141] initcall dccp_v6_init+0x0/0xc8 returned 0 after 0 usecs
[  447.755052] calling  dccpprobe_init+0x0/0x12a @ 1
[  447.765337] DCCP watch registered (port=0)
[  447.770073] initcall dccpprobe_init+0x0/0x12a returned 0 after 9765 usecs
[  447.777052] calling  tipc_init+0x0/0xbe @ 1
[  447.781107] TIPC: Activated (version 1.6.4 compiled Apr 28 2009 12:41:17)
[  447.788840] NET: Registered protocol family 30
[  447.794067] TIPC: Started in single node mode
[  447.798060] initcall tipc_init+0x0/0xbe returned 0 after 16601 usecs
[  447.805116] calling  update_mp_table+0x0/0x2ee @ 1
[  447.809056] initcall update_mp_table+0x0/0x2ee returned 0 after 0 usecs
[  447.816065] calling  lapic_insert_resource+0x0/0x55 @ 1
[  447.821057] initcall lapic_insert_resource+0x0/0x55 returned 0 after 0 usecs
[  447.828059] calling  ioapic_insert_resources+0x0/0x81 @ 1
[  447.834057] initcall ioapic_insert_resources+0x0/0x81 returned 0 after 0 usecs
[  447.841072] calling  io_apic_bug_finalize+0x0/0x31 @ 1
[  447.846057] initcall io_apic_bug_finalize+0x0/0x31 returned 0 after 0 usecs
[  447.853060] calling  check_early_ioremap_leak+0x0/0x9b @ 1
[  447.859059] initcall check_early_ioremap_leak+0x0/0x9b returned 0 after 0 usecs
[  447.866059] calling  pat_memtype_list_init+0x0/0x29 @ 1
[  447.871088] initcall pat_memtype_list_init+0x0/0x29 returned 0 after 0 usecs
[  447.878058] calling  sched_init_debug+0x0/0x24 @ 1
[  447.883070] initcall sched_init_debug+0x0/0x24 returned 0 after 0 usecs
[  447.890062] calling  init_oops_id+0x0/0x4d @ 1
[  447.894064] initcall init_oops_id+0x0/0x4d returned 0 after 0 usecs
[  447.901135] calling  disable_boot_consoles+0x0/0x67 @ 1
[  447.906059] initcall disable_boot_consoles+0x0/0x67 returned 0 after 0 usecs
[  447.913058] calling  pm_qos_power_init+0x0/0x10a @ 1
[  447.920277] initcall pm_qos_power_init+0x0/0x10a returned 0 after 1953 usecs
[  447.927140] calling  debugfs_kprobe_init+0x0/0xcd @ 1
[  447.932104] initcall debugfs_kprobe_init+0x0/0xcd returned 0 after 0 usecs
[  447.939058] calling  clear_boot_tracer+0x0/0x43 @ 1
[  447.944061] initcall clear_boot_tracer+0x0/0x43 returned 0 after 0 usecs
[  447.951111] calling  max_swapfiles_check+0x0/0x8 @ 1
[  447.956052] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[  447.962060] calling  random32_reseed+0x0/0xd0 @ 1
[  447.967078] initcall random32_reseed+0x0/0xd0 returned 0 after 0 usecs
[  447.974059] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[  447.980062] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 0 usecs
[  447.988065] calling  pci_sysfs_init+0x0/0x7d @ 1
[  447.993527] initcall pci_sysfs_init+0x0/0x7d returned 0 after 0 usecs
[  448.000059] calling  regulator_init_complete+0x0/0x25c @ 1
[  448.005172] initcall regulator_init_complete+0x0/0x25c returned 0 after 0 usecs
[  448.013059] calling  seqgen_init+0x0/0xf @ 1
[  448.017084] initcall seqgen_init+0x0/0xf returned 0 after 0 usecs
[  448.023073] calling  hd_init+0x0/0x3b6 @ 1
[  448.027122] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[  448.035496] initcall hd_init+0x0/0x3b6 returned -1 after 8789 usecs
[  448.042057] initcall hd_init+0x0/0x3b6 returned with error code -1 
[  448.049069] calling  scsi_complete_async_scans+0x0/0x1c6 @ 1
[  448.054059] initcall scsi_complete_async_scans+0x0/0x1c6 returned 0 after 0 usecs
[  448.062059] calling  edd_init+0x0/0x340 @ 1
[  448.066056] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[  448.072368] initcall edd_init+0x0/0x340 returned 0 after 6835 usecs
[  448.079058] calling  memmap_init+0x0/0x123 @ 1
[  448.084452] initcall memmap_init+0x0/0x123 returned 0 after 0 usecs
[  448.090052] calling  init_net_drop_monitor+0x0/0x1a7 @ 1
[  448.096107] Initalizing network drop monitor service
[  448.101086] initcall init_net_drop_monitor+0x0/0x1a7 returned 0 after 4882 usecs
[  448.108057] calling  tcp_congestion_default+0x0/0x12 @ 1
[  448.113054] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[  448.121062] calling  initialize_hashrnd+0x0/0x19 @ 1
[  448.126063] initcall initialize_hashrnd+0x0/0x19 returned 0 after 0 usecs
[  448.132092] async_waiting @ 1
[  448.135052] async_continuing @ 1 after 0 usec
[  448.140105] md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
[  448.151527] EXT3-fs: INFO: recovery required on readonly filesystem.
[  448.158080] EXT3-fs: write access will be enabled during recovery.
[  448.215339] kjournald starting.  Commit interval 5 seconds
[  448.215339] EXT3-fs: recovery complete.
[  448.216036] EXT3-fs: mounted filesystem with ordered data mode.
[  448.216036] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[  448.216036] async_waiting @ 1
[  448.216036] async_continuing @ 1 after 0 usec
[  448.216036] debug: unmapping init memory ffffffff8161a000..ffffffff8190d000
[  448.216523] Write protecting the kernel read-only data: 14716k
[  448.224693] Testing CPA: undo ffffffff80209000-ffffffff81068000
[  448.232325] Testing CPA: again
[  448.292393] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
[  449.927333] ttyS0: 1 input overrun(s)
[  453.776754] udev: renamed network interface eth0 to eth1
[  453.777338] ttyS0: 4 input overrun(s)
[  453.886610] udev: renamed network interface eth1_rename to eth0
[  456.164253] eth0: link down
[  456.169236] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  456.384735] eth1: no link during initialization.
[  456.421011] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  456.458551] ttyS0: 3 input overrun(s)
[  458.524036] eth1: link up.
[  458.530284] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  458.544170] ------------[ cut here ]------------
[  458.545036] WARNING: at lib/dma-debug.c:574 check_unmap+0x3eb/0x799()
[  458.545036] forcedeth 0000:00:0a.0: DMA-API: device driver frees DMA memory with wrong function [device address=0x0000000020d2b802] [size=90 bytes] [mapped as single] [unmapped as page]
[  458.545036] Modules linked in:
[  458.545036] Pid: 3696, comm: usleep Not tainted 2.6.30-rc3-tip #37050
[  458.545036] Call Trace:
[  458.545036]  <IRQ>  [<ffffffff80266ae9>] warn_slowpath+0xb3/0xe7
[  458.545036]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  458.545036]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  458.545036]  [<ffffffff80299c2b>] ? put_lock_stats+0x31/0x33
[  458.545036]  [<ffffffff8029ceb3>] ? __lock_acquired+0x1ff/0x220
[  458.545036]  [<ffffffff80567434>] ? check_unmap+0x10b/0x799
[  458.545036]  [<ffffffff80567434>] ? check_unmap+0x10b/0x799
[  458.545036]  [<ffffffff80567714>] check_unmap+0x3eb/0x799
[  458.545036]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  458.545036]  [<ffffffff80567b67>] debug_dma_unmap_page+0xa5/0xb1
[  458.545036]  [<ffffffff8073298d>] pci_unmap_page+0xb3/0xbf
[  458.545036]  [<ffffffff80733084>] nv_tx_done_optimized+0x58/0x3ac
[  458.545036]  [<ffffffff80739335>] nv_napi_poll+0xca/0x3ec
[  458.545036]  [<ffffffff808943a1>] net_rx_action+0x15b/0x387
[  458.545036]  [<ffffffff8026f4cd>] __do_softirq+0x1a3/0x3b6
[  458.545036]  [<ffffffff8020debc>] call_softirq+0x1c/0x28
[  458.545036]  [<ffffffff8020f75a>] do_softirq+0x82/0x196
[  458.545036]  [<ffffffff8026ec7a>] irq_exit+0x67/0xee
[  458.545036]  [<ffffffff80aaea19>] smp_apic_timer_interrupt+0xa8/0xb6
[  458.545036]  [<ffffffff8020d883>] apic_timer_interrupt+0x13/0x20
[  458.681080]  <EOI>  [<ffffffff802e7df5>] ? ftrace_likely_update+0x1b/0x2b
[  458.681080]  [<ffffffff805590b9>] ? _raw_spin_unlock+0x2a/0x1a4
[  458.681080]  [<ffffffff80aa7241>] ? _spin_unlock+0x2b/0x82
[  458.681080]  [<ffffffff8032fbcd>] ? anon_vma_prepare+0x154/0x1a6
[  458.681080]  [<ffffffff8031e6ff>] ? do_anonymous_page+0x2e/0x184
[  458.681080]  [<ffffffff80321ef3>] ? handle_mm_fault+0x244/0x44b
[  458.681080]  [<ffffffff80aab65d>] ? do_page_fault+0x5f6/0x6a9
[  458.681080]  [<ffffffff80aa6a11>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  458.681080]  [<ffffffff80aa81b5>] ? page_fault+0x25/0x30
[  458.681080] ---[ end trace 5a0d2a1de3ad49ca ]---
[  458.681080] Mapped at:
[  458.681080]  [<ffffffffffffffff>] 0xffffffffffffffff
[  458.755195] ttyS0: 4 input overrun(s)
[  466.917597] EXT3 FS on sda6, internal journal
[  467.078330] kjournald starting.  Commit interval 5 seconds
[  467.079277] EXT3 FS on sda5, internal journal
[  467.079345] EXT3-fs: mounted filesystem with ordered data mode.
[  467.095305] ttyS0: 3 input overrun(s)
[  468.487821] Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k 
[  468.497062] ttyS0: 1 input overrun(s)
[  468.754144] eth1: no IPv6 routers present
[  471.464761] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[  471.467232] ttyS0: 1 input overrun(s)
[  473.137355] BUG: MAX_LOCKDEP_ENTRIES too low!
[  473.140050] turning off the locking correctness validator.
[  473.140050] Pid: 5827, comm: sshd Tainted: G        W  2.6.30-rc3-tip #37050
[  473.143104] ttyS0: 1 input overrun(s)
[  473.145046] Call Trace:
[  473.145046]  [<ffffffff80299a6e>] add_lock_to_list+0x53/0xba
[  473.145046]  [<ffffffff805672fb>] ? add_dma_entry+0x2f/0x5d
[  473.145046]  [<ffffffff8029c0bf>] check_prev_add+0x14b/0x1c7
[  473.145046]  [<ffffffff8029c5d5>] validate_chain+0x49a/0x554
[  473.145046]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  473.145046]  [<ffffffff8029c9e3>] __lock_acquire+0x354/0x3d9
[  473.145046]  [<ffffffff8029cb78>] lock_acquire+0x110/0x13c
[  473.145046]  [<ffffffff805672fb>] ? add_dma_entry+0x2f/0x5d
[  473.145046]  [<ffffffff80aa766d>] _spin_lock_irqsave+0x59/0xa7
[  473.145046]  [<ffffffff805672fb>] ? add_dma_entry+0x2f/0x5d
[  473.145046]  [<ffffffff805672fb>] add_dma_entry+0x2f/0x5d
[  473.145046]  [<ffffffff8056844b>] debug_dma_map_page+0x15c/0x16b
[  473.145046]  [<ffffffff8073514a>] pci_map_single+0xe8/0xfa
[  473.145046]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  473.145046]  [<ffffffff80735c22>] nv_start_xmit_optimized+0x192/0x675
[  473.145046]  [<ffffffff80898adb>] dev_hard_start_xmit+0x18e/0x285
[  473.145046]  [<ffffffff808bf364>] __qdisc_run+0x223/0x3f7
[  473.145046]  [<ffffffff80899151>] dev_queue_xmit+0x37c/0x587
[  473.145046]  [<ffffffff80898fe8>] ? dev_queue_xmit+0x213/0x587
[  473.145046]  [<ffffffff808ee1b2>] ip_finish_output2+0x360/0x3d7
[  473.145046]  [<ffffffff808ee2a3>] ip_finish_output+0x7a/0x7c
[  473.145046]  [<ffffffff808ee375>] ip_output+0xd0/0xd8
[  473.145046]  [<ffffffff808ea8a3>] ip_local_out+0x6c/0x6e
[  473.145046]  [<ffffffff808edc1b>] ip_queue_xmit+0x3ef/0x4a9
[  473.145046]  [<ffffffff80559744>] ? debug_smp_processor_id+0x38/0x190
[  473.145046]  [<ffffffff8029aef3>] ? mark_lock+0x22/0x177
[  473.145046]  [<ffffffff8029aef3>] ? mark_lock+0x22/0x177
[  473.145046]  [<ffffffff8090ea6d>] ? tcp_v4_md5_do_lookup+0x9/0x85
[  473.145046]  [<ffffffff8090905a>] ? tcp_event_data_sent+0x16/0x19d
[  473.145046]  [<ffffffff80909a43>] tcp_transmit_skb+0x862/0x8b7
[  473.145046]  [<ffffffff808fa1f4>] ? sk_stream_alloc_skb+0x3d/0x153
[  473.145046]  [<ffffffff8090d148>] tcp_write_xmit+0x447/0x601
[  473.145046]  [<ffffffff8090d3fe>] __tcp_push_pending_frames+0x7e/0xe9
[  473.145046]  [<ffffffff808f7245>] tcp_push+0xe4/0xe6
[  473.145046]  [<ffffffff808fafb0>] tcp_sendmsg+0xca6/0xdde
[  473.145046]  [<ffffffff8087f58a>] __sock_sendmsg+0x75/0x82
[  473.145046]  [<ffffffff8087f6a3>] sock_aio_write+0x10c/0x11c
[  473.145046]  [<ffffffff8029a069>] ? register_lock_class+0x20/0x367
[  473.145046]  [<ffffffff8034d8c3>] do_sync_write+0xf9/0x172
[  473.145046]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  473.145046]  [<ffffffff8029d63a>] ? __lock_release+0x164/0x16d
[  473.145046]  [<ffffffff8028615f>] ? autoremove_wake_function+0x0/0x53
[  473.145046]  [<ffffffff80aab808>] ? sub_preempt_count+0xf8/0x1aa
[  473.145046]  [<ffffffff804efc8a>] ? cap_file_permission+0x9/0xd
[  473.145046]  [<ffffffff804edd62>] ? security_file_permission+0x16/0x18
[  473.145046]  [<ffffffff8034e8d8>] vfs_write+0x175/0x1ab
[  473.145046]  [<ffffffff8034ea32>] sys_write+0x62/0x87
[  473.145046]  [<ffffffff8020cc32>] system_call_fastpath+0x16/0x1b
[  475.165079] CPU 1 is now offline
[  475.166069] lockdep: fixing up alternatives.
[  475.167060] SMP alternatives: switching to UP code
[  475.206539] CPU0 attaching NULL sched-domain.
[  475.208189] CPU1 attaching NULL sched-domain.
[  475.209384] CPU0 attaching NULL sched-domain.
[  475.254225] lockdep: fixing up alternatives.
[  475.255069] SMP alternatives: switching to SMP code
[  475.269765] Booting processor 1 APIC 0x1 ip 0x6000
[  475.206102] Initializing CPU#1
[  475.206102] masked ExtINT on CPU#1
[  475.206102] Calibrating delay using timer specific routine.. 4020.80 BogoMIPS (lpj=2010400)
[  475.206102] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  475.206102] CPU: L2 Cache: 512K (64 bytes/line)
[  475.206102] CPU 1/0x1 -> Node 0
[  475.206102] CPU: Physical Processor ID: 0
[  475.206102] CPU: Processor Core ID: 1
[  475.206102] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  475.347988] CPU1: <4>ttyS0: 2 input overrun(s)
[  475.349135] AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[  475.366164] CPU0 attaching NULL sched-domain.
[  475.385292] CPU0 attaching sched-domain:
[  475.386164]  domain 0: span 0-1 level CPU
[  475.388105]   groups: 0 1
[  475.390115] CPU1 attaching sched-domain:
[  475.391086]  domain 0: span 0-1 level CPU
[  475.393087]   groups: 1 0
[  475.455100] CPU 1 is now offline
[  475.456115] lockdep: fixing up alternatives.
[  475.457091] SMP alternatives: switching to UP code
[  475.467011] CPU0 attaching NULL sched-domain.
[  475.467195] CPU1 attaching NULL sched-domain.
[  475.468362] CPU0 attaching NULL sched-domain.
[  475.525706] lockdep: fixing up alternatives.
[  475.526256] SMP alternatives: switching to SMP code
[  475.541368] Booting processor 1 APIC 0x1 ip 0x6000
[  475.466721] Initializing CPU#1
[  475.466721] masked ExtINT on CPU#1
[  475.466721] Calibrating delay using timer specific routine.. 4020.20 BogoMIPS (lpj=2010100)
[  475.466721] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  475.466721] CPU: L2 Cache: 512K (64 bytes/line)
[  475.466721] CPU 1/0x1 -> Node 0
[  475.466721] CPU: Physical Processor ID: 0
[  475.466721] CPU: Processor Core ID: 1
[  475.466721] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  475.665082] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[  475.682168] CPU0 attaching NULL sched-domain.
[  475.697793] CPU0 attaching sched-domain:
[  475.698115]  domain 0: span 0-1 level CPU
[  475.700110]   groups: 0 1
[  475.702115] CPU1 attaching sched-domain:
[  475.703212]  domain 0: span 0-1 level CPU
[  475.705064]   groups: 1 0


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30-rc3
# Tue Apr 28 12:40:44 2009
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

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
CONFIG_BROKEN_BOOT_EUROPE=y
CONFIG_BROKEN_BOOT_TITAN=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP_SUPPORT=y
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_CLOCK is not set
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_MEMTEST is not set
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_CPU_DEBUG is not set
CONFIG_UP_WANTED_1=y
CONFIG_UP_WANTED_2=y
# CONFIG_UP_WANTED is not set
CONFIG_SMP=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
# CONFIG_K8_NUMA is not set
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=9
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
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_MIGRATION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
# CONFIG_PM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
# CONFIG_CPU_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=y
# CONFIG_IP_SCTP is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
CONFIG_ACTISYS_DONGLE=y
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
# CONFIG_LITELINK_DONGLE is not set
CONFIG_MA600_DONGLE=y
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=y
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=y
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_MPL_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y

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
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_ISL29003=m
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_AIC7XXX=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=m
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=m
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=y
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87410=m
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SERVERWORKS=m
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_SCH=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=y
CONFIG_MD_RAID6_PQ=y
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_IEEE1394=m
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VERBOSEDEBUG=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_BUS=m
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
# CONFIG_IFB is not set
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=m
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_VORTEX=y
CONFIG_ENC28J60=m
CONFIG_ENC28J60_WRITEVERIFY=y
# CONFIG_ETHOC is not set
CONFIG_DNET=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=y
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
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
CONFIG_FEALNX=m
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=y
CONFIG_SIS900=y
CONFIG_EPIC100=m
CONFIG_SMSC9420=y
CONFIG_SUNDANCE=m
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
# CONFIG_DE620 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
CONFIG_DL2K=y
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
CONFIG_QLA3XXX=y
CONFIG_ATL1=m
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_JME=y
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=m
CONFIG_ENIC=y
CONFIG_IXGBE=m
CONFIG_IXGB=y
CONFIG_S2IO=m
CONFIG_MYRI10GE=m
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
CONFIG_TR=y
CONFIG_IBMOL=m
# CONFIG_3C359 is not set
CONFIG_TMS380TR=y
CONFIG_TMSPCI=m
# CONFIG_ABYSS is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=m
CONFIG_PCMCIA_WAVELAN=y
CONFIG_PCMCIA_NETWAVE=y
# CONFIG_WLAN_80211 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=m
# CONFIG_USB_ALI_M5632 is not set
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_HSO is not set
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_FMVJ18X=m
# CONFIG_PCMCIA_PCNET is not set
CONFIG_PCMCIA_NMCLAN=y
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_PCMCIA_XIRC2PS=m
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_ARCNET_COM20020_CS is not set
CONFIG_PCMCIA_IBMTR=y
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
# CONFIG_ATM_ENI_BURST_TX_16W is not set
CONFIG_ATM_ENI_BURST_TX_8W=y
# CONFIG_ATM_ENI_BURST_TX_4W is not set
CONFIG_ATM_ENI_BURST_TX_2W=y
CONFIG_ATM_ENI_BURST_RX_16W=y
# CONFIG_ATM_ENI_BURST_RX_8W is not set
# CONFIG_ATM_ENI_BURST_RX_4W is not set
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_IDT77252=m
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
# CONFIG_ATM_SOLOS is not set
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PLIP=m
CONFIG_PPP=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
CONFIG_PHONE=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
CONFIG_DIGIEPCA=y
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=y
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=m
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
CONFIG_RISCOM8=y
CONFIG_SPECIALIX=y
CONFIG_SX=y
CONFIG_RIO=y
CONFIG_RIO_OLDPCI=y
CONFIG_STALDRV=y
CONFIG_STALLION=m
# CONFIG_ISTALLION is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_SENSORS_PCF8574=m
CONFIG_PCF8575=m
CONFIG_SENSORS_MAX6875=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_BQ27x00=m
CONFIG_CHARGER_PCF50633=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHER is not set
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_LIS3_SPI=m
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=m
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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
CONFIG_TPS65010=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_BQ24022=m
CONFIG_REGULATOR_PCF50633=m

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
# CONFIG_VIDEO_V4L1_COMPAT is not set
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_ZORAN=m
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=m
# CONFIG_VIDEO_ZORAN_BUZ is not set
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_HEXIUM_ORION=m
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_IVTV is not set
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_USB_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_USB_DSBR=m
# CONFIG_USB_SI470X is not set
CONFIG_USB_MR800=m
# CONFIG_RADIO_TEA5764 is not set
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I810=m
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=m
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
CONFIG_BACKLIGHT_SAHARA=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

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
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
CONFIG_HID_APPLE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=m
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=m
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
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
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_VST=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=m

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=y
CONFIG_UWB_I1480U=m
CONFIG_UWB_I1480U_WLP=m
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DEBUG_VERBOSE is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_X38=m
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=m
# CONFIG_EDAC_AMD8131 is not set
CONFIG_EDAC_AMD8111=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_SMX is not set
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_OCFS2_FS_POSIX_ACL=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=m
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
# CONFIG_NILFS2_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ALLOW_WARNINGS is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_ENABLE_EVENT_TRACING=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_POWER_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_HW_BRANCH_TRACER=y
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=m
CONFIG_KGDB_TESTS=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_LEAK=y
CONFIG_X86_DS_SELFTEST=y
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
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
# CONFIG_SECURITY_SELINUX is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
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
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_64=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y

--huq684BweRXVnRxX--
