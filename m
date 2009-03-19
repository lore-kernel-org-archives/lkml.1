Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCSN0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCSN0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZCSNZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:25:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZCSNZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:25:41 -0400
Date: Thu, 19 Mar 2009 14:25:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpumask: remove cpumask allocation from idle_balance
Message-ID: <20090319132501.GA27506@elte.hu>
References: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com> <alpine.DEB.2.00.0903182225450.31583@gandalf.stny.rr.com> <200903191522.21045.rusty@rustcorp.com.au> <200903192310.52314.rusty@rustcorp.com.au> <20090319132426.GA27017@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090319132426.GA27017@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bootlog.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.29-rc8-tip-02665-g4c672bd-dirty (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #21494 SMP Thu Mar 19 14:10:44 CET 2009
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
[    0.000000] DMI 2.3 present.
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
[    0.000000]   get_mtrr: cpu0 reg00 base=0000000000 size=0000040000 write-back
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
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 18dd000-1adf000
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00018db778]    TEXT DATA BSS ==> [0000200000 - 00018db778]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [00018dc000 - 00018dc149]              BRK ==> [00018dc000 - 00018dc149]
[    0.000000]   #5 [00018dd000 - 0001add000]          PGTABLE ==> [00018dd000 - 0001add000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000]  [ffffe20000000000-ffffe200015fffff] PMD -> [ffff880001c00000-ffff8800031fffff] on node 0
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
[    0.000000]   DMA zone: 99 pages reserved
[    0.000000]   DMA zone: 3807 pages, LIFO batch:0
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
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages at ffff880001b60000, static data 95136 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256295
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:33024 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.437 MHz processor.
[    0.003333] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console handover: boot [earlyser0] -> real [ttyS0]
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 4607 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333] ----------------------------------------------------------------------------
[    0.003333]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.003333]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.003333]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.003333]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.003333]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.003333]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.003333]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.003333]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]               recursive read-lock:             |  ok  |             |failed|
[    0.003333]            recursive read-lock #2:             |  ok  |             |failed|
[    0.003333]             mixed read-write-lock:             |failed|             |failed|
[    0.003333]             mixed write-read-lock:             |failed|             |failed|
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.003333]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.003333]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.003333]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.003333]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.003333]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.003333]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.003333]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.003333]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.003333]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.003333]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.003333]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.003333]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.003333]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.003333]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.003333]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.003333]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.003333]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.003333]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.003333]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.003333]       hard-irq read-recursion/123:  ok  |
[    0.003333]       soft-irq read-recursion/123:  ok  |
[    0.003333]       hard-irq read-recursion/132:  ok  |
[    0.003333]       soft-irq read-recursion/132:  ok  |
[    0.003333]       hard-irq read-recursion/213:  ok  |
[    0.003333]       soft-irq read-recursion/213:  ok  |
[    0.003333]       hard-irq read-recursion/231:  ok  |
[    0.003333]       soft-irq read-recursion/231:  ok  |
[    0.003333]       hard-irq read-recursion/312:  ok  |
[    0.003333]       soft-irq read-recursion/312:  ok  |
[    0.003333]       hard-irq read-recursion/321:  ok  |
[    0.003333]       soft-irq read-recursion/321:  ok  |
[    0.003333] --------------------------------------------------------
[    0.003333] 133 out of 218 testcases failed, as expected. |
[    0.003333] ----------------------------------------------------
[    0.003333] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.003333] Memory: 996956k/1048512k available (8062k kernel code, 408k absent, 50456k reserved, 5594k data, 604k init)
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.003341] Calibrating delay loop (skipped), value calculated using timer frequency.. 4022.41 BogoMIPS (lpj=6701456)
[    0.010106] Security Framework initialized
[    0.013347] SELinux:  Initializing.
[    0.016738] SELinux:  Starting in permissive mode
[    0.020054] Mount-cache hash table entries: 256
[    0.024249] Initializing cgroup subsys ns
[    0.026674] Initializing cgroup subsys devices
[    0.030004] Initializing cgroup subsys freezer
[    0.033367] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.036669] CPU: L2 Cache: 512K (64 bytes/line)
[    0.040002] tseg: 0000000000
[    0.043345] CPU: Physical Processor ID: 0
[    0.046669] CPU: Processor Core ID: 0
[    0.050894] debug: unmapping init memory ffffffff80fef000..ffffffff80ffe000
[    0.053710] Setting APIC routing to flat
[    0.056672] enabled ExtINT on CPU#0
[    0.060051] ExtINT not setup in hardware but reported by MP table
[    0.063424] ENABLING IO-APIC IRQs
[    0.066668] init IO_APIC IRQs
[    0.070002]  2-0 (apicid-pin) not connected
[    0.075881] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.076678] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.080010] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
[    0.083332] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
[    0.083332] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
[    0.083332] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.083332] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.083332]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.083332] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.083332] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.083332] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.083332] ..... (found apic 0 pin 0) ...
[    0.119107] ....... works.
[    0.120001] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.127904] Using local APIC timer interrupts.
[    0.127905] calibrating APIC timer ...
[    0.133332] ... lapic delta = 1256355
[    0.133332] ..... delta 1256355
[    0.133332] ..... mult: 53963554
[    0.133332] ..... calibration result: 670056
[    0.133332] ..... CPU clock speed is 2010.1229 MHz.
[    0.133332] ..... host bus clock speed is 201.0123 MHz.
[    0.133332] ... verify APIC timer
[    0.241024] ... jiffies delta = 30
[    0.243334] ... jiffies result ok
[    0.246688] calling  migration_init+0x0/0x4f @ 1
[    0.250147] initcall migration_init+0x0/0x4f returned 1 after 0 usecs
[    0.253336] initcall migration_init+0x0/0x4f returned with error code 1 
[    0.256669] calling  spawn_ksoftirqd+0x0/0x4f @ 1
[    0.260108] initcall spawn_ksoftirqd+0x0/0x4f returned 0 after 0 usecs
[    0.263337] calling  init_call_single_data+0x0/0xaf @ 1
[    0.266673] initcall init_call_single_data+0x0/0xaf returned 0 after 0 usecs
[    0.270003] calling  relay_init+0x0/0x8 @ 1
[    0.273336] initcall relay_init+0x0/0x8 returned 0 after 0 usecs
[    0.276669] calling  tracer_alloc_buffers+0x0/0x27b @ 1
[    0.280069] Testing tracer nop: PASSED
[    0.284066] initcall tracer_alloc_buffers+0x0/0x27b returned 0 after 3255 usecs
[    0.286669] calling  init_trace_printk+0x0/0x12 @ 1
[    0.290003] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.293336] calling  trace_workqueue_early_init+0x0/0x139 @ 1
[    0.296717] initcall trace_workqueue_early_init+0x0/0x139 returned 0 after 0 usecs
[    0.300237] lockdep: fixing up alternatives.
[    0.303449] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] masked ExtINT on CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 4021.85 BogoMIPS (lpj=6700566)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.403476] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.411244] Brought up 2 CPUs
[    0.413335] Total of 2 processors activated (8044.26 BogoMIPS).
[    0.417093] CPU0 attaching sched-domain:
[    0.420004]  domain 0: span 0-1 level CPU
[    0.425088]   groups: 0 1
[    0.427251] CPU1 attaching sched-domain:
[    0.430004]  domain 0: span 0-1 level CPU
[    0.435089]   groups: 1 0
[    0.438023] device: 'platform': device_add
[    0.440472] khelper used greatest stack depth: 5400 bytes left
[    0.446541] bus: 'platform': registered
[    0.446674] Registering sysdev class 'cpu'
[    0.450228] Registering sysdev class 'memory'
[    0.453549] Registering sys device of class 'memory'
[    0.456673] Registering sys device 'memory0'
[    0.460250] Registering sys device of class 'memory'
[    0.463340] Registering sys device 'memory1'
[    0.466884] Registering sys device of class 'memory'
[    0.470006] Registering sys device 'memory2'
[    0.473560] Registering sys device of class 'memory'
[    0.476673] Registering sys device 'memory3'
[    0.480216] Registering sys device of class 'memory'
[    0.483342] Registering sys device 'memory4'
[    0.486892] Registering sys device of class 'memory'
[    0.490007] Registering sys device 'memory5'
[    0.493559] Registering sys device of class 'memory'
[    0.496673] Registering sys device 'memory6'
[    0.500217] Registering sys device of class 'memory'
[    0.503340] Registering sys device 'memory7'
[    0.507729] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.510007] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.513336] calling  net_ns_init+0x0/0x103 @ 1
[    0.516668] net_namespace: 2016 bytes
[    0.520148] initcall net_ns_init+0x0/0x103 returned 0 after 3255 usecs
[    0.523338] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.526670] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.530003] calling  print_banner+0x0/0xe @ 1
[    0.533335] Booting paravirtualized kernel on bare hardware
[    0.536669] initcall print_banner+0x0/0xe returned 0 after 3255 usecs
[    0.540002] calling  init_smp_flush+0x0/0x3e @ 1
[    0.543336] initcall init_smp_flush+0x0/0x3e returned 0 after 0 usecs
[    0.546669] calling  sysctl_init+0x0/0x16 @ 1
[    0.550007] initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
[    0.553335] calling  ksysfs_init+0x0/0xbb @ 1
[    0.556686] initcall ksysfs_init+0x0/0xbb returned 0 after 0 usecs
[    0.560002] calling  async_init+0x0/0x44 @ 1
[    0.563336] initcall async_init+0x0/0x44 returned 0 after 0 usecs
[    0.566669] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.570005] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.573336] calling  filelock_init+0x0/0x2e @ 1
[    0.576673] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.580002] calling  init_misc_binfmt+0x0/0x3f @ 1
[    0.583346] initcall init_misc_binfmt+0x0/0x3f returned 0 after 0 usecs
[    0.586669] calling  init_script_binfmt+0x0/0x12 @ 1
[    0.590002] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.593335] calling  init_elf_binfmt+0x0/0x12 @ 1
[    0.596669] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.600002] calling  init_compat_elf_binfmt+0x0/0x12 @ 1
[    0.603336] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.606669] calling  debugfs_init+0x0/0x51 @ 1
[    0.610019] initcall debugfs_init+0x0/0x51 returned 0 after 0 usecs
[    0.613337] calling  securityfs_init+0x0/0x51 @ 1
[    0.616676] initcall securityfs_init+0x0/0x51 returned 0 after 0 usecs
[    0.620003] calling  random32_init+0x0/0xd9 @ 1
[    0.623337] initcall random32_init+0x0/0xd9 returned 0 after 0 usecs
[    0.626670] calling  regulator_init+0x0/0x2e @ 1
[    0.630001] regulator: core version 0.5
[    0.633335] device class 'regulator': registering
[    0.636884] initcall regulator_init+0x0/0x2e returned 0 after 6510 usecs
[    0.640003] calling  cpufreq_core_init+0x0/0x81 @ 1
[    0.643336] initcall cpufreq_core_init+0x0/0x81 returned 0 after 0 usecs
[    0.646669] calling  sock_init+0x0/0x5e @ 1
[    0.650112] initcall sock_init+0x0/0x5e returned 0 after 0 usecs
[    0.653336] calling  net_inuse_init+0x0/0x26 @ 1
[    0.656672] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.660002] calling  netpoll_init+0x0/0x41 @ 1
[    0.663336] initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
[    0.666669] calling  netlink_proto_init+0x0/0x14c @ 1
[    0.670053] NET: Registered protocol family 16
[    0.673434] initcall netlink_proto_init+0x0/0x14c returned 0 after 3255 usecs
[    0.676670] calling  bdi_class_init+0x0/0x41 @ 1
[    0.680003] device class 'bdi': registering
[    0.683653] initcall bdi_class_init+0x0/0x41 returned 0 after 3255 usecs
[    0.686670] calling  kobject_uevent_init+0x0/0x47 @ 1
[    0.690021] initcall kobject_uevent_init+0x0/0x47 returned 0 after 0 usecs
[    0.693336] calling  gpiolib_sysfs_init+0x0/0x96 @ 1
[    0.696668] device class 'gpio': registering
[    0.700259] initcall gpiolib_sysfs_init+0x0/0x96 returned 0 after 3255 usecs
[    0.703337] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.706668] device class 'pci_bus': registering
[    0.710239] initcall pcibus_class_init+0x0/0x19 returned 0 after 3255 usecs
[    0.713337] calling  pci_driver_init+0x0/0x12 @ 1
[    0.716912] bus: 'pci': registered
[    0.720004] initcall pci_driver_init+0x0/0x12 returned 0 after 3255 usecs
[    0.723336] calling  backlight_class_init+0x0/0x5d @ 1
[    0.726669] device class 'backlight': registering
[    0.730228] initcall backlight_class_init+0x0/0x5d returned 0 after 3255 usecs
[    0.733337] calling  tty_class_init+0x0/0x31 @ 1
[    0.736669] device class 'tty': registering
[    0.740227] initcall tty_class_init+0x0/0x31 returned 0 after 3255 usecs
[    0.743337] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.746669] device class 'vtconsole': registering
[    0.750233] device: 'vtcon0': device_add
[    0.753618] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 6510 usecs
[    0.756670] calling  spi_init+0x0/0x83 @ 1
[    0.760263] bus: 'spi': registered
[    0.763335] device class 'spi_master': registering
[    0.766895] initcall spi_init+0x0/0x83 returned 0 after 6510 usecs
[    0.770004] calling  i2c_init+0x0/0x67 @ 1
[    0.773586] bus: 'i2c': registered
[    0.776669] device class 'i2c-adapter': registering
[    0.780245] bus: 'i2c': add driver dummy
[    0.783579] initcall i2c_init+0x0/0x67 returned 0 after 9765 usecs
[    0.786669] calling  amd_postcore_init+0x0/0x7a @ 1
[    0.790005] node 0 link 0: io port [1000, fffff]
[    0.793336] TOM: 0000000040000000 aka 1024M
[    0.796669] node 0 link 0: mmio [e0000000, efffffff]
[    0.800198] node 0 link 0: mmio [feb00000, fec0ffff]
[    0.803532] node 0 link 0: mmio [a0000, bffff]
[    0.810002] node 0 link 0: mmio [40000000, fed3ffff]
[    0.813532] bus: [00,ff] on node 0 link 0
[    0.816668] bus: 00 index 0 io port: [0, ffff]
[    0.820002] bus: 00 index 1 mmio: [40000000, fcffffffff]
[    0.823335] bus: 00 index 2 mmio: [feb00000, fec0ffff]
[    0.826668] bus: 00 index 3 mmio: [a0000, bffff]
[    0.830003] initcall amd_postcore_init+0x0/0x7a returned 0 after 39062 usecs
[    0.833336] calling  arch_kdebugfs_init+0x0/0x24 @ 1
[    0.836681] initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.840003] calling  mtrr_if_init+0x0/0x79 @ 1
[    0.843345] initcall mtrr_if_init+0x0/0x79 returned 0 after 0 usecs
[    0.846669] calling  uv_rtc_setup_clock+0x0/0x267 @ 1
[    0.850003] initcall uv_rtc_setup_clock+0x0/0x267 returned -19 after 0 usecs
[    0.853335] calling  dma_bus_init+0x0/0x3f @ 1
[    0.856668] device class 'dma': registering
[    0.860243] initcall dma_bus_init+0x0/0x3f returned 0 after 3255 usecs
[    0.863336] calling  dma_channel_table_init+0x0/0x10e @ 1
[    0.866683] initcall dma_channel_table_init+0x0/0x10e returned 0 after 0 usecs
[    0.870003] calling  pci_arch_init+0x0/0x40 @ 1
[    0.873339] PCI: Using configuration type 1 for base access
[    0.876675] initcall pci_arch_init+0x0/0x40 returned 0 after 3255 usecs
[    0.880002] calling  topology_init+0x0/0x61 @ 1
[    0.883335] Registering sys device of class 'cpu'
[    0.886674] Registering sys device 'cpu0'
[    0.890221] Registering sys device of class 'cpu'
[    0.893340] Registering sys device 'cpu1'
[    0.896889] initcall topology_init+0x0/0x61 returned 0 after 13020 usecs
[    0.900003] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.903336] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    0.906669] calling  param_sysfs_init+0x0/0x1b6 @ 1
[    0.982455] initcall param_sysfs_init+0x0/0x1b6 returned 0 after 68359 usecs
[    0.986981] calling  pm_sysrq_init+0x0/0x1e @ 1
[    0.990042] initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 usecs
[    0.993337] calling  readahead_init+0x0/0x38 @ 1
[    0.996683] device: 'default': device_add
[    1.003541] initcall readahead_init+0x0/0x38 returned 0 after 6510 usecs
[    1.007033] calling  init_bio+0x0/0xd0 @ 1
[    1.010810] bio: create slab <bio-0> at 0
[    1.013459] initcall init_bio+0x0/0xd0 returned 0 after 3255 usecs
[    1.016669] calling  integrity_init+0x0/0x3c @ 1
[    1.020313] initcall integrity_init+0x0/0x3c returned 0 after 0 usecs
[    1.023338] calling  cryptomgr_init+0x0/0x31 @ 1
[    1.027485] initcall cryptomgr_init+0x0/0x31 returned 0 after 0 usecs
[    1.030005] calling  blk_settings_init+0x0/0x2a @ 1
[    1.033336] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    1.036669] calling  blk_ioc_init+0x0/0x2a @ 1
[    1.040011] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    1.043336] calling  blk_softirq_init+0x0/0x66 @ 1
[    1.046670] initcall blk_softirq_init+0x0/0x66 returned 0 after 0 usecs
[    1.050002] calling  genhd_device_init+0x0/0x66 @ 1
[    1.053335] device class 'block': registering
[    1.056943] initcall genhd_device_init+0x0/0x66 returned 0 after 3255 usecs
[    1.060004] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    1.063527] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    1.066670] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    1.070029] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    1.073336] calling  pca953x_init+0x0/0x14 @ 1
[    1.076670] bus: 'i2c': add driver pca953x
[    1.080279] initcall pca953x_init+0x0/0x14 returned 0 after 3255 usecs
[    1.083337] calling  pcf857x_init+0x0/0x14 @ 1
[    1.086768] bus: 'i2c': add driver pcf857x
[    1.090260] initcall pcf857x_init+0x0/0x14 returned 0 after 3255 usecs
[    1.093337] calling  pci_slot_init+0x0/0x4c @ 1
[    1.096703] initcall pci_slot_init+0x0/0x4c returned 0 after 0 usecs
[    1.100003] calling  fbmem_init+0x0/0x91 @ 1
[    1.106690] device class 'graphics': registering
[    1.110256] initcall fbmem_init+0x0/0x91 returned 0 after 6510 usecs
[    1.113337] calling  misc_init+0x0/0x9f @ 1
[    1.116701] device class 'misc': registering
[    1.120232] initcall misc_init+0x0/0x9f returned 0 after 3255 usecs
[    1.123338] calling  cn_init+0x0/0xf3 @ 1
[    1.126842] initcall cn_init+0x0/0xf3 returned 0 after 0 usecs
[    1.130004] calling  twl4030_init+0x0/0x14 @ 1
[    1.133335] bus: 'i2c': add driver twl4030
[    1.136888] initcall twl4030_init+0x0/0x14 returned 0 after 3255 usecs
[    1.140003] calling  phy_init+0x0/0x31 @ 1
[    1.143335] device class 'mdio_bus': registering
[    1.147153] bus: 'mdio_bus': registered
[    1.150003] bus: 'mdio_bus': add driver Generic PHY
[    1.153568] initcall phy_init+0x0/0x31 returned 0 after 9765 usecs
[    1.156670] calling  init_scsi+0x0/0x91 @ 1
[    1.160462] device class 'scsi_host': registering
[    1.163831] bus: 'scsi': registered
[    1.166669] device class 'scsi_device': registering
[    1.170307] SCSI subsystem initialized
[    1.173337] initcall init_scsi+0x0/0x91 returned 0 after 13020 usecs
[    1.176669] calling  ata_init+0x0/0x38a @ 1
[    1.180329] libata version 3.00 loaded.
[    1.183337] initcall ata_init+0x0/0x38a returned 0 after 3255 usecs
[    1.186670] calling  twl4030_usb_init+0x0/0x12 @ 1
[    1.190002] bus: 'platform': add driver twl4030_usb
[    1.193557] initcall twl4030_usb_init+0x0/0x12 returned 0 after 3255 usecs
[    1.196670] calling  usb_init+0x0/0x115 @ 1
[    1.200320] bus: 'usb': registered
[    1.203338] device class 'usb_host': registering
[    1.206906] bus: 'usb': add driver usbfs
[    1.210267] usbcore: registered new interface driver usbfs
[    1.213424] device class 'usb_device': registering
[    1.220166] bus: 'usb': add driver hub
[    1.223592] usbcore: registered new interface driver hub
[    1.226786] bus: 'usb': add driver usb
[    1.230249] usbcore: registered new device driver usb
[    1.233338] initcall usb_init+0x0/0x115 returned 0 after 32552 usecs
[    1.236743] calling  serio_init+0x0/0x89 @ 1
[    1.240268] bus: 'serio': registered
[    1.243441] initcall serio_init+0x0/0x89 returned 0 after 3255 usecs
[    1.246671] calling  input_init+0x0/0x10e @ 1
[    1.250001] device class 'input': registering
[    1.253592] initcall input_init+0x0/0x10e returned 0 after 3255 usecs
[    1.256670] calling  power_supply_class_init+0x0/0x38 @ 1
[    1.260009] device class 'power_supply': registering
[    1.263572] initcall power_supply_class_init+0x0/0x38 returned 0 after 3255 usecs
[    1.266670] calling  thermal_init+0x0/0x58 @ 1
[    1.270001] device class 'thermal': registering
[    1.273562] initcall thermal_init+0x0/0x58 returned 0 after 3255 usecs
[    1.276670] calling  leds_init+0x0/0x40 @ 1
[    1.280004] device class 'leds': registering
[    1.283562] initcall leds_init+0x0/0x40 returned 0 after 3255 usecs
[    1.286670] calling  pci_subsys_init+0x0/0x10b @ 1
[    1.290001] PCI: Probing PCI hardware
[    1.293360] PCI: Probing PCI hardware (bus 00)
[    1.296683] device: 'pci0000:00': device_add
[    1.300012] device: '0000:00': device_add
[    1.303600] PCI: Scanning bus 0000:00
[    1.306719] pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
[    1.310074] pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
[    1.313360] pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xc4
[    1.316668] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.320026] pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
[    1.323340] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    1.326680] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    1.330005] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    1.333349] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.336670] pci 0000:00:01.1: PME# disabled
[    1.340032] pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
[    1.343340] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    1.346696] pci 0000:00:02.0: supports D1 D2
[    1.350002] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.353336] pci 0000:00:02.0: PME# disabled
[    1.356698] pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
[    1.360006] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    1.363368] pci 0000:00:02.1: supports D1 D2
[    1.366668] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.370003] pci 0000:00:02.1: PME# disabled
[    1.373368] pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
[    1.376673] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    1.380005] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    1.383341] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    1.386690] pci 0000:00:04.0: supports D1 D2
[    1.390026] pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
[    1.393350] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    1.396705] pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
[    1.400035] pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
[    1.403340] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    1.406671] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    1.410026] pci 0000:00:0a.0: supports D1 D2
[    1.413335] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.416669] pci 0000:00:0a.0: PME# disabled
[    1.420029] pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
[    1.423361] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.426669] pci 0000:00:0b.0: PME# disabled
[    1.430033] pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
[    1.433361] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.436669] pci 0000:00:0c.0: PME# disabled
[    1.440033] pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
[    1.443361] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.446669] pci 0000:00:0d.0: PME# disabled
[    1.450032] pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
[    1.453360] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.456669] pci 0000:00:0e.0: PME# disabled
[    1.460036] pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
[    1.463419] pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
[    1.466702] pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
[    1.470036] pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
[    1.473366] PCI: Fixups for bus 0000:00
[    1.476670] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
[    1.480011] PCI: Scanning bus 0000:05
[    1.483366] pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
[    1.486675] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    1.490006] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    1.493370] pci 0000:05:07.0: supports D1 D2
[    1.496668] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.500003] pci 0000:05:07.0: PME# disabled
[    1.503365] PCI: Fixups for bus 0000:05
[    1.506668] pci 0000:00:09.0: transparent bridge
[    1.510003] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    1.513336] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    1.516669] PCI: Bus scan for 0000:05 returning with max=05
[    1.520003] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
[    1.523344] PCI: Scanning bus 0000:04
[    1.526701] PCI: Fixups for bus 0000:04
[    1.530008] PCI: Bus scan for 0000:04 returning with max=04
[    1.533337] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
[    1.536677] PCI: Scanning bus 0000:03
[    1.540034] PCI: Fixups for bus 0000:03
[    1.543341] PCI: Bus scan for 0000:03 returning with max=03
[    1.546670] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
[    1.550011] PCI: Scanning bus 0000:02
[    1.553368] PCI: Fixups for bus 0000:02
[    1.556675] PCI: Bus scan for 0000:02 returning with max=02
[    1.560003] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
[    1.563344] PCI: Scanning bus 0000:01
[    1.566691] pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
[    1.570004] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x20
[    1.570004] Clocksource tsc unstable (delta = 302715287 ns)
[    1.573341] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    1.576672] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    1.580006] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    1.583350] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.586688] pci 0000:01:00.0: supports D1 D2
[    1.590033] pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
[    1.593336] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x20
[    1.596674] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    1.600042] pci 0000:01:00.1: supports D1 D2
[    1.603354] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.606756] PCI: Fixups for bus 0000:01
[    1.610004] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    1.613336] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    1.616671] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    1.620001] PCI: Bus scan for 0000:01 returning with max=01
[    1.623337] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
[    1.626671] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
[    1.630004] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
[    1.633337] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
[    1.636671] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
[    1.640004] PCI: Bus scan for 0000:00 returning with max=05
[    1.643335] device: '0000:00:00.0': device_add
[    1.646676] bus: 'pci': add device 0000:00:00.0
[    1.650285] device: '0000:00:01.0': device_add
[    1.653343] bus: 'pci': add device 0000:00:01.0
[    1.656938] device: '0000:00:01.1': device_add
[    1.660010] bus: 'pci': add device 0000:00:01.1
[    1.663605] device: '0000:00:02.0': device_add
[    1.666676] bus: 'pci': add device 0000:00:02.0
[    1.670260] device: '0000:00:02.1': device_add
[    1.673343] bus: 'pci': add device 0000:00:02.1
[    1.676938] device: '0000:00:04.0': device_add
[    1.680010] bus: 'pci': add device 0000:00:04.0
[    1.683604] device: '0000:00:06.0': device_add
[    1.686676] bus: 'pci': add device 0000:00:06.0
[    1.690261] device: '0000:00:09.0': device_add
[    1.693343] bus: 'pci': add device 0000:00:09.0
[    1.696937] device: '0000:00:0a.0': device_add
[    1.700010] bus: 'pci': add device 0000:00:0a.0
[    1.703616] device: '0000:00:0b.0': device_add
[    1.706677] bus: 'pci': add device 0000:00:0b.0
[    1.710261] device: '0000:00:0c.0': device_add
[    1.713352] bus: 'pci': add device 0000:00:0c.0
[    1.716928] device: '0000:00:0d.0': device_add
[    1.720010] bus: 'pci': add device 0000:00:0d.0
[    1.723604] device: '0000:00:0e.0': device_add
[    1.726677] bus: 'pci': add device 0000:00:0e.0
[    1.730271] device: '0000:00:18.0': device_add
[    1.733344] bus: 'pci': add device 0000:00:18.0
[    1.736927] device: '0000:00:18.1': device_add
[    1.740010] bus: 'pci': add device 0000:00:18.1
[    1.743605] device: '0000:00:18.2': device_add
[    1.746677] bus: 'pci': add device 0000:00:18.2
[    1.750270] device: '0000:00:18.3': device_add
[    1.753343] bus: 'pci': add device 0000:00:18.3
[    1.756929] device: '0000:05:07.0': device_add
[    1.760010] bus: 'pci': add device 0000:05:07.0
[    1.763605] device: '0000:05': device_add
[    1.766925] device: '0000:04': device_add
[    1.770279] device: '0000:03': device_add
[    1.773598] device: '0000:02': device_add
[    1.776934] device: '0000:01:00.0': device_add
[    1.780009] bus: 'pci': add device 0000:01:00.0
[    1.783753] device: '0000:01:00.1': device_add
[    1.786678] bus: 'pci': add device 0000:01:00.1
[    1.790264] device: '0000:01': device_add
[    1.793875] pci 0000:00:00.0: default IRQ router [10de:005e]
[    1.796771] pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 3
[    1.800013] pci 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.803369] pci 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.806673] pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 5
[    1.810185] initcall pci_subsys_init+0x0/0x10b returned 0 after 507812 usecs
[    1.813336] calling  proto_init+0x0/0x12 @ 1
[    1.816680] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    1.820002] calling  net_dev_init+0x0/0x180 @ 1
[    1.823373] device class 'net': registering
[    1.826933] device: 'lo': device_add
[    1.830400] initcall net_dev_init+0x0/0x180 returned 0 after 6510 usecs
[    1.833336] calling  neigh_init+0x0/0x71 @ 1
[    1.836670] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    1.840002] calling  genl_init+0x0/0xd9 @ 1
[    1.856716] initcall genl_init+0x0/0xd9 returned 0 after 13020 usecs
[    1.860004] calling  cipso_v4_init+0x0/0x88 @ 1
[    1.863354] initcall cipso_v4_init+0x0/0x88 returned 0 after 0 usecs
[    1.866670] calling  irda_init+0x0/0x92 @ 1
[    1.870061] NET: Registered protocol family 23
[    1.873435] initcall irda_init+0x0/0x92 returned 0 after 3255 usecs
[    1.876669] calling  bt_init+0x0/0x5d @ 1
[    1.880001] Bluetooth: Core ver 2.14
[    1.886844] device class 'bluetooth': registering
[    1.890220] NET: Registered protocol family 31
[    1.893335] Bluetooth: HCI device and connection manager initialized
[    1.896688] Bluetooth: HCI socket layer initialized
[    1.900003] initcall bt_init+0x0/0x5d returned 0 after 19531 usecs
[    1.903336] calling  atm_init+0x0/0xb4 @ 1
[    1.906668] NET: Registered protocol family 8
[    1.910001] NET: Registered protocol family 20
[    1.913376] device class 'atm': registering
[    1.916898] initcall atm_init+0x0/0xb4 returned 0 after 9765 usecs
[    1.920004] calling  wireless_nlevent_init+0x0/0x41 @ 1
[    1.923336] initcall wireless_nlevent_init+0x0/0x41 returned 0 after 0 usecs
[    1.926670] calling  cfg80211_init+0x0/0x79 @ 1
[    1.930002] device class 'ieee80211': registering
[    1.946739] Registering platform device 'regulatory.0'. Parent at platform
[    1.950002] device: 'regulatory.0': device_add
[    1.953343] bus: 'platform': add device regulatory.0
[    1.956888] cfg80211: Using static regulatory domain info
[    1.960002] cfg80211: Regulatory domain: US
[    1.963334] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    1.966668] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    1.970002] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.973335] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.976668] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.980002] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.983335] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    1.986669] cfg80211: Calling CRDA for country: US
[    1.990221] initcall cfg80211_init+0x0/0x79 returned 0 after 58593 usecs
[    1.993337] calling  ieee80211_init+0x0/0x1f @ 1
[    1.996683] initcall ieee80211_init+0x0/0x1f returned 0 after 0 usecs
[    2.000002] calling  netlbl_init+0x0/0x81 @ 1
[    2.003334] NetLabel: Initializing
[    2.006668] NetLabel:  domain hash size = 128
[    2.010001] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.013537] NetLabel:  unlabeled traffic allowed by default
[    2.016670] initcall netlbl_init+0x0/0x81 returned 0 after 13020 usecs
[    2.020003] calling  sysctl_init+0x0/0x49 @ 1
[    2.023338] initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
[    2.026670] calling  pci_iommu_init+0x0/0x23 @ 1
[    2.090111] DMA-API: preallocated 32768 debug entries
[    2.093334] DMA-API: debugging enabled by kernel config
[    2.096676] initcall pci_iommu_init+0x0/0x23 returned 0 after 65104 usecs
[    2.100005] calling  print_all_ICs+0x0/0x531 @ 1
[    2.103334] 
[    2.103335] printing PIC contents
[    2.106670] ... PIC  IMR: fffa
[    2.109724] ... PIC  IRR: 0001
[    2.110001] ... PIC  ISR: 0001
[    2.113335] ... PIC ELCR: 0828
[    2.116669] 
[    2.116670] printing local APIC contents on CPU#0/0:
[    2.119999] ... APIC ID:      00000000 (0)
[    2.119999] ... APIC VERSION: 00040010
[    2.119999] ... APIC TASKPRI: 00000000 (00)
[    2.119999] ... APIC ARBPRI: 000000e0 (e0)
[    2.119999] ... APIC PROCPRI: 00000000
[    2.119999] ... APIC LDR: 01000000
[    2.119999] ... APIC DFR: ffffffff
[    2.119999] ... APIC SPIV: 000001ff
[    2.119999] ... APIC ISR field:
[    2.119999] 0123456789abcdef0123456789abcdef
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] ... APIC TMR field:
[    2.119999] 0123456789abcdef0123456789abcdef
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] ... APIC IRR field:
[    2.119999] 0123456789abcdef0123456789abcdef
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000010000000000000000
[    2.119999] ... APIC ESR: 00000000
[    2.119999] ... APIC ICR: 000008fd
[    2.119999] ... APIC ICR2: 02000000
[    2.119999] ... APIC LVTT: 000200ef
[    2.119999] ... APIC LVTPC: 00010000
[    2.119999] ... APIC LVT0: 00010700
[    2.119999] ... APIC LVT1: 00000400
[    2.119999] ... APIC LVTERR: 000000fe
[    2.119999] ... APIC TMICT: 0000a396
[    2.119999] ... APIC TMCCT: 000055cd
[    2.119999] ... APIC TDCR: 00000003
[    2.119999] 
[    2.119997] 
[    2.119998] printing local APIC contents on CPU#1/1:
[    2.119999] ... APIC ID:      01000000 (1)
[    2.119999] ... APIC VERSION: 00040010
[    2.119999] ... APIC TASKPRI: 00000000 (00)
[    2.119999] ... APIC ARBPRI: 000000e0 (e0)
[    2.119999] ... APIC PROCPRI: 00000000
[    2.119999] ... APIC LDR: 02000000
[    2.119999] ... APIC DFR: ffffffff
[    2.119999] ... APIC SPIV: 000001ff
[    2.119999] ... APIC ISR field:
[    2.119999] 0123456789abcdef0123456789abcdef
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] ... APIC TMR field:
[    2.119999] 0123456789abcdef0123456789abcdef
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] ... APIC IRR field:
[    2.119999] 0123456789abcdef0123456789abcdef
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000000000000000000000
[    2.119999] 00000000000000010000000000000000
[    2.119999] ... APIC ESR: 00000000
[    2.119999] ... APIC ICR: 000008fd
[    2.119999] ... APIC ICR2: 01000000
[    2.119999] ... APIC LVTT: 000200ef
[    2.119999] ... APIC LVTPC: 00010000
[    2.119999] ... APIC LVT0: 00010700
[    2.119999] ... APIC LVT1: 00010400
[    2.119999] ... APIC LVTERR: 000000fe
[    2.119999] ... APIC TMICT: 0000a396
[    2.119999] ... APIC TMCCT: 00001cec
[    2.119999] ... APIC TDCR: 00000003
[    2.119999] 
[    2.334793] number of MP IRQ sources: 17.
[    2.336668] number of IO-APIC #2 registers: 24.
[    2.340001] testing the IO APIC.......................
[    2.343337] 
[    2.344829] IO APIC #2......
[    2.346667] .... register #00: 00000000
[    2.350001] .......    : physical APIC id: 00
[    2.353334] .......    : Delivery Type: 0
[    2.356668] .......    : LTS          : 0
[    2.360001] .... register #01: 00170011
[    2.363334] .......     : max redirection entries: 0017
[    2.366667] .......     : PRQ implemented: 0
[    2.370001] .......     : IO APIC version: 0011
[    2.373334] .... register #02: 00000000
[    2.376668] .......     : arbitration: 00
[    2.380001] .... IRQ redirection table:
[    2.383334]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    2.386670]  00 003 0    0    0   0   0    1    1    30
[    2.390003]  01 003 0    0    0   0   0    1    1    31
[    2.396670]  02 000 1    0    0   0   0    0    0    00
[    2.403337]  03 003 1    1    0   1   0    1    1    33
[    2.406670]  04 003 0    0    0   0   0    1    1    34
[    2.413336]  05 003 1    1    0   1   0    1    1    35
[    2.416670]  06 003 0    0    0   0   0    1    1    36
[    2.423336]  07 003 1    0    0   0   0    1    1    37
[    2.426670]  08 003 0    0    0   0   0    1    1    38
[    2.433336]  09 003 0    0    0   0   0    1    1    39
[    2.440003]  0a 003 0    0    0   0   0    1    1    3A
[    2.443336]  0b 003 1    1    0   1   0    1    1    3B
[    2.450003]  0c 003 0    0    0   0   0    1    1    3C
[    2.453336]  0d 003 0    0    0   0   0    1    1    3D
[    2.460003]  0e 003 0    0    0   0   0    1    1    3E
[    2.463336]  0f 003 0    0    0   0   0    1    1    3F
[    2.470003]  10 000 1    0    0   0   0    0    0    00
[    2.476670]  11 000 1    0    0   0   0    0    0    00
[    2.480003]  12 000 1    0    0   0   0    0    0    00
[    2.486670]  13 000 1    0    0   0   0    0    0    00
[    2.490003]  14 000 1    0    0   0   0    0    0    00
[    2.496670]  15 000 1    0    0   0   0    0    0    00
[    2.500003]  16 000 1    0    0   0   0    0    0    00
[    2.506670]  17 000 1    0    0   0   0    0    0    00
[    2.513334] IRQ to pin mappings:
[    2.516668] IRQ0 -> 0:0
[    2.519150] IRQ1 -> 0:1
[    2.520735] IRQ3 -> 0:3
[    2.524068] IRQ4 -> 0:4
[    2.526855] IRQ5 -> 0:5
[    2.529332] IRQ6 -> 0:6
[    2.530735] IRQ7 -> 0:7
[    2.534068] IRQ8 -> 0:8
[    2.536667] IRQ9 -> 0:9
[    2.539151] IRQ10 -> 0:10
[    2.540820] IRQ11 -> 0:11
[    2.544154] IRQ12 -> 0:12
[    2.546855] IRQ13 -> 0:13
[    2.549506] IRQ14 -> 0:14
[    2.550813] IRQ15 -> 0:15
[    2.554151] .................................... done.
[    2.556670] initcall print_all_ICs+0x0/0x531 returned 0 after 442708 usecs
[    2.560003] calling  hpet_late_init+0x0/0x16c @ 1
[    2.563336] initcall hpet_late_init+0x0/0x16c returned -19 after 0 usecs
[    2.566670] calling  clocksource_done_booting+0x0/0x12 @ 1
[    2.570003] initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
[    2.573336] calling  ftrace_init_debugfs+0x0/0x40 @ 1
[    2.576699] initcall ftrace_init_debugfs+0x0/0x40 returned 0 after 0 usecs
[    2.580002] calling  rb_init_debugfs+0x0/0x40 @ 1
[    2.583355] initcall rb_init_debugfs+0x0/0x40 returned 0 after 0 usecs
[    2.586669] calling  tracer_init_debugfs+0x0/0x3df @ 1
[    2.593601] initcall tracer_init_debugfs+0x0/0x3df returned 0 after 3255 usecs
[    2.596669] calling  init_trace_printk_function_export+0x0/0x40 @ 1
[    2.600012] initcall init_trace_printk_function_export+0x0/0x40 returned 0 after 0 usecs
[    2.603336] calling  stat_workqueue_init+0x0/0x2d @ 1
[    2.606700] initcall stat_workqueue_init+0x0/0x2d returned 0 after 0 usecs
[    2.610002] calling  event_trace_init+0x0/0x2a4 @ 1
[    2.614283] initcall event_trace_init+0x0/0x2a4 returned 0 after 0 usecs
[    2.616670] calling  init_pipe_fs+0x0/0x4c @ 1
[    2.620086] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
[    2.623336] calling  init_mnt_writers+0x0/0x8e @ 1
[    2.626670] initcall init_mnt_writers+0x0/0x8e returned 0 after 0 usecs
[    2.630002] calling  eventpoll_init+0x0/0xab @ 1
[    2.633362] initcall eventpoll_init+0x0/0xab returned 0 after 0 usecs
[    2.636669] calling  anon_inode_init+0x0/0x11f @ 1
[    2.640050] initcall anon_inode_init+0x0/0x11f returned 0 after 0 usecs
[    2.643337] calling  chr_dev_init+0x0/0xa1 @ 1
[    2.646688] device class 'mem': registering
[    2.650269] device: 'mem': device_add
[    2.653595] device: 'null': device_add
[    2.656911] device: 'port': device_add
[    2.660246] device: 'zero': device_add
[    2.663586] device: 'full': device_add
[    2.666914] device: 'random': device_add
[    2.670245] device: 'urandom': device_add
[    2.673578] device: 'kmsg': device_add
[    2.676908] device: 'oldmem': device_add
[    2.680250] initcall chr_dev_init+0x0/0xa1 returned 0 after 32552 usecs
[    2.683337] calling  firmware_class_init+0x0/0x79 @ 1
[    2.686668] device class 'firmware': registering
[    2.690231] initcall firmware_class_init+0x0/0x79 returned 0 after 3255 usecs
[    2.693337] calling  ieee1394_init+0x0/0x25e @ 1
[    2.697080] bus: 'ieee1394': registered
[    2.700007] device class 'ieee1394_host': registering
[    2.703565] device class 'ieee1394_protocol': registering
[    2.706927] device class 'ieee1394_node': registering
[    2.710231] device class 'ieee1394': registering
[    2.716769] bus: 'ieee1394': add driver nodemgr
[    2.720242] initcall ieee1394_init+0x0/0x25e returned 0 after 22786 usecs
[    2.723336] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    2.726680] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    2.730002] calling  cpufreq_gov_dbs_init+0x0/0x68 @ 1
[    2.733558] initcall cpufreq_gov_dbs_init+0x0/0x68 returned 0 after 0 usecs
[    2.736669] calling  ssb_modinit+0x0/0x70 @ 1
[    2.740253] bus: 'ssb': registered
[    2.743348] initcall ssb_modinit+0x0/0x70 returned 0 after 3255 usecs
[    2.746669] calling  pcibios_assign_resources+0x0/0x88 @ 1
[    2.750114] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    2.753336] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    2.756671] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    2.760003] pci 0000:00:09.0:   PREFETCH window: disabled
[    2.763338] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    2.766668] pci 0000:00:0b.0:   IO window: disabled
[    2.770003] pci 0000:00:0b.0:   MEM window: disabled
[    2.773336] pci 0000:00:0b.0:   PREFETCH window: disabled
[    2.776671] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    2.780001] pci 0000:00:0c.0:   IO window: disabled
[    2.783336] pci 0000:00:0c.0:   MEM window: disabled
[    2.786669] pci 0000:00:0c.0:   PREFETCH window: disabled
[    2.790004] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    2.793334] pci 0000:00:0d.0:   IO window: disabled
[    2.796670] pci 0000:00:0d.0:   MEM window: disabled
[    2.800002] pci 0000:00:0d.0:   PREFETCH window: disabled
[    2.803343] pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
[    2.806670] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    2.810002] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    2.813337] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    2.816669] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    2.820010] pci 0000:00:09.0: setting latency timer to 64
[    2.823340] pci 0000:00:0b.0: setting latency timer to 64
[    2.826673] pci 0000:00:0c.0: setting latency timer to 64
[    2.830006] pci 0000:00:0d.0: setting latency timer to 64
[    2.833340] pci 0000:00:0e.0: setting latency timer to 64
[    2.836670] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.840002] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    2.843335] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
[    2.846668] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
[    2.850002] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    2.853335] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    2.856668] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    2.860002] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    2.863335] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    2.866668] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    2.870001] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    2.873335] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    2.876668] pci_bus 0000:03: resource 1 mem: [0x0-0x0]
[    2.880002] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    2.883335] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    2.886668] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    2.890001] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    2.893335] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    2.896668] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    2.900002] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    2.903335] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
[    2.906668] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xd7ffffff]
[    2.910001] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    2.913336] initcall pcibios_assign_resources+0x0/0x88 returned 0 after 159505 usecs
[    2.916669] calling  sysctl_core_init+0x0/0x38 @ 1
[    2.920031] initcall sysctl_core_init+0x0/0x38 returned 0 after 0 usecs
[    2.923338] calling  inet_init+0x0/0x1cf @ 1
[    2.926692] NET: Registered protocol family 2
[    2.970109] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.973968] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.980097] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    2.986677] TCP: Hash tables configured (established 131072 bind 65536)
[    2.993334] TCP reno registered
[    3.003532] initcall inet_init+0x0/0x1cf returned 0 after 74869 usecs
[    3.006670] calling  af_unix_init+0x0/0x55 @ 1
[    3.010015] NET: Registered protocol family 1
[    3.013359] initcall af_unix_init+0x0/0x55 returned 0 after 3255 usecs
[    3.016670] calling  populate_rootfs+0x0/0x11b @ 1
[    3.020580] initcall populate_rootfs+0x0/0x11b returned 0 after 0 usecs
[    3.023337] calling  i8259A_init_sysfs+0x0/0x22 @ 1
[    3.026668] Registering sysdev class 'i8259'
[    3.033376] Registering sys device of class 'i8259'
[    3.036696] Registering sys device 'i82590'
[    3.040230] initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 13020 usecs
[    3.043337] calling  vsyscall_init+0x0/0x27 @ 1
[    3.046677] initcall vsyscall_init+0x0/0x27 returned 0 after 0 usecs
[    3.050002] calling  sbf_init+0x0/0xef @ 1
[    3.053336] initcall sbf_init+0x0/0xef returned 0 after 0 usecs
[    3.056669] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    3.060001] Registering sysdev class 'i8237'
[    3.066694] Registering sys device of class 'i8237'
[    3.070006] Registering sys device 'i82370'
[    3.073557] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 13020 usecs
[    3.076670] calling  add_rtc_cmos+0x0/0x38 @ 1
[    3.080005] Registering platform device 'rtc_cmos'. Parent at platform
[    3.083335] device: 'rtc_cmos': device_add
[    3.086678] bus: 'platform': add device rtc_cmos
[    3.090246] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    3.093337] initcall add_rtc_cmos+0x0/0x38 returned 0 after 13020 usecs
[    3.096669] calling  cache_sysfs_init+0x0/0x2fb @ 1
[    3.104246] initcall cache_sysfs_init+0x0/0x2fb returned 0 after 3255 usecs
[    3.106670] calling  cpu_debug_init+0x0/0x541 @ 1
[    3.115613] cpu0(2) debug files 130
[    3.122356] cpu1(2) debug files 130
[    3.123340] initcall cpu_debug_init+0x0/0x541 returned 0 after 13020 usecs
[    3.126671] calling  ioapic_init_sysfs+0x0/0xa7 @ 1
[    3.130002] Registering sysdev class 'ioapic'
[    3.133605] Registering sys device of class 'ioapic'
[    3.136683] Registering sys device 'ioapic0'
[    3.140225] initcall ioapic_init_sysfs+0x0/0xa7 returned 0 after 9765 usecs
[    3.143337] calling  add_pcspkr+0x0/0x28 @ 1
[    3.146912] Registering platform device 'pcspkr'. Parent at platform
[    3.150002] device: 'pcspkr': device_add
[    3.153345] bus: 'platform': add device pcspkr
[    3.156916] initcall add_pcspkr+0x0/0x28 returned 0 after 9765 usecs
[    3.160006] calling  start_periodic_check_for_corruption+0x0/0x3c @ 1
[    3.163335] Scanning for low memory corruption every 60 seconds
[    3.166674] initcall start_periodic_check_for_corruption+0x0/0x3c returned 0 after 3255 usecs
[    3.170002] calling  uv_ptc_init+0x0/0x4f @ 1
[    3.173336] initcall uv_ptc_init+0x0/0x4f returned 0 after 0 usecs
[    3.176669] calling  uv_bau_init+0x0/0x44e @ 1
[    3.180006] initcall uv_bau_init+0x0/0x44e returned 0 after 0 usecs
[    3.183335] calling  sgi_uv_sysfs_init+0x0/0x94 @ 1
[    3.186681] initcall sgi_uv_sysfs_init+0x0/0x94 returned 0 after 0 usecs
[    3.190002] calling  audit_classes_init+0x0/0xaf @ 1
[    3.193362] initcall audit_classes_init+0x0/0xaf returned 0 after 0 usecs
[    3.196669] calling  start_pageattr_test+0x0/0x34 @ 1
[    3.200223] initcall start_pageattr_test+0x0/0x34 returned 0 after 0 usecs
[    3.203337] calling  pt_dump_init+0x0/0x30 @ 1
[    3.206702] initcall pt_dump_init+0x0/0x30 returned 0 after 0 usecs
[    3.210003] calling  init_vdso_vars+0x0/0x229 @ 1
[    3.213390] initcall init_vdso_vars+0x0/0x229 returned 0 after 0 usecs
[    3.216669] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    3.220008] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 usecs
[    3.223335] calling  sysenter_setup+0x0/0x28c @ 1
[    3.226676] initcall sysenter_setup+0x0/0x28c returned 0 after 0 usecs
[    3.230002] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    3.233349] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 0 usecs
[    3.236669] calling  proc_schedstat_init+0x0/0x22 @ 1
[    3.240010] initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 usecs
[    3.243335] calling  proc_execdomains_init+0x0/0x22 @ 1
[    3.246676] initcall proc_execdomains_init+0x0/0x22 returned 0 after 0 usecs
[    3.250002] calling  ioresources_init+0x0/0x3c @ 1
[    3.253350] initcall ioresources_init+0x0/0x3c returned 0 after 0 usecs
[    3.256669] calling  uid_cache_init+0x0/0x8d @ 1
[    3.260041] initcall uid_cache_init+0x0/0x8d returned 0 after 0 usecs
[    3.263336] calling  init_posix_timers+0x0/0xe4 @ 1
[    3.266674] initcall init_posix_timers+0x0/0xe4 returned 0 after 0 usecs
[    3.270002] calling  init_posix_cpu_timers+0x0/0xb0 @ 1
[    3.273336] initcall init_posix_cpu_timers+0x0/0xb0 returned 0 after 0 usecs
[    3.276669] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    3.280006] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
[    3.283337] calling  create_proc_profile+0x0/0x22d @ 1
[    3.286670] initcall create_proc_profile+0x0/0x22d returned 0 after 0 usecs
[    3.290002] calling  timekeeping_init_device+0x0/0x22 @ 1
[    3.293335] Registering sysdev class 'timekeeping'
[    3.296883] Registering sys device of class 'timekeeping'
[    3.300007] Registering sys device 'timekeeping0'
[    3.303566] initcall timekeeping_init_device+0x0/0x22 returned 0 after 9765 usecs
[    3.306670] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    3.310006] Registering sysdev class 'clocksource'
[    3.313558] Registering sys device of class 'clocksource'
[    3.316683] Registering sys device 'clocksource0'
[    3.320226] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 9765 usecs
[    3.323337] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    3.326678] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 usecs
[    3.330002] calling  lockdep_proc_init+0x0/0x42 @ 1
[    3.333357] initcall lockdep_proc_init+0x0/0x42 returned 0 after 0 usecs
[    3.336669] calling  futex_init+0x0/0xc4 @ 1
[    3.340007] initcall futex_init+0x0/0xc4 returned 0 after 0 usecs
[    3.343336] calling  init_rttest+0x0/0x15e @ 1
[    3.346670] Registering sysdev class 'rttest'
[    3.350385] Registering sys device of class 'rttest'
[    3.353342] Registering sys device 'rttest0'
[    3.360047] Registering sys device of class 'rttest'
[    3.363418] Registering sys device 'rttest1'
[    3.367012] Registering sys device of class 'rttest'
[    3.370008] Registering sys device 'rttest2'
[    3.373662] Registering sys device of class 'rttest'
[    3.376682] Registering sys device 'rttest3'
[    3.380334] Registering sys device of class 'rttest'
[    3.383341] Registering sys device 'rttest4'
[    3.386996] Registering sys device of class 'rttest'
[    3.390007] Registering sys device 'rttest5'
[    3.393664] Registering sys device of class 'rttest'
[    3.396674] Registering sys device 'rttest6'
[    3.400328] Registering sys device of class 'rttest'
[    3.403341] Registering sys device 'rttest7'
[    3.406895] Initializing RT-Tester: OK
[    3.410005] initcall init_rttest+0x0/0x15e returned 0 after 61848 usecs
[    3.413337] calling  proc_dma_init+0x0/0x22 @ 1
[    3.416678] initcall proc_dma_init+0x0/0x22 returned 0 after 0 usecs
[    3.420002] calling  proc_modules_init+0x0/0x22 @ 1
[    3.423343] initcall proc_modules_init+0x0/0x22 returned 0 after 0 usecs
[    3.426669] calling  kallsyms_init+0x0/0x25 @ 1
[    3.430009] initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
[    3.433336] calling  pid_namespaces_init+0x0/0x2d @ 1
[    3.436680] initcall pid_namespaces_init+0x0/0x2d returned 0 after 0 usecs
[    3.440002] calling  ikconfig_init+0x0/0x39 @ 1
[    3.443343] initcall ikconfig_init+0x0/0x39 returned 0 after 0 usecs
[    3.446669] calling  audit_init+0x0/0x153 @ 1
[    3.450001] audit: initializing netlink socket (disabled)
[    3.453414] type=2000 audit(1237471872.453:1): initialized
[    3.456677] initcall audit_init+0x0/0x153 returned 0 after 6510 usecs
[    3.460002] calling  init_kprobes+0x0/0x169 @ 1
[    3.477471] initcall init_kprobes+0x0/0x169 returned 0 after 13020 usecs
[    3.480003] calling  rcu_torture_init+0x0/0x694 @ 1
[    3.483362] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[    3.490808] initcall rcu_torture_init+0x0/0x694 returned 0 after 6510 usecs
[    3.493336] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    3.496675] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 usecs
[    3.500004] calling  init_markers+0x0/0x17 @ 1
[    3.503336] initcall init_markers+0x0/0x17 returned 0 after 0 usecs
[    3.506669] calling  init_tracepoints+0x0/0x17 @ 1
[    3.510003] initcall init_tracepoints+0x0/0x17 returned 0 after 0 usecs
[    3.513336] calling  init_lstats_procfs+0x0/0x25 @ 1
[    3.516684] initcall init_lstats_procfs+0x0/0x25 returned 0 after 0 usecs
[    3.520002] calling  ftrace_nodyn_init+0x0/0x12 @ 1
[    3.523336] initcall ftrace_nodyn_init+0x0/0x12 returned 0 after 0 usecs
[    3.526669] calling  init_events+0x0/0x52 @ 1
[    3.530006] initcall init_events+0x0/0x52 returned 0 after 0 usecs
[    3.533336] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    3.536671] Testing tracer sched_switch: PASSED
[    3.644100] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 104166 usecs
[    3.646669] calling  init_function_trace+0x0/0x12 @ 1
[    3.650002] Testing tracer function: PASSED
[    3.764153] initcall init_function_trace+0x0/0x12 returned 0 after 110677 usecs
[    3.766669] calling  init_wakeup_tracer+0x0/0x22 @ 1
[    3.770003] Testing tracer wakeup: PASSED
[    3.980808] Testing tracer wakeup_rt: PASSED
[    4.190768] initcall init_wakeup_tracer+0x0/0x22 returned 0 after 410156 usecs
[    4.193339] calling  stack_trace_init+0x0/0x8d @ 1
[    4.196703] initcall stack_trace_init+0x0/0x8d returned 0 after 0 usecs
[    4.200002] calling  init_bts_trace+0x0/0x12 @ 1
[    4.203335] Testing tracer hw-branch-tracer: <4>Failed to init hw-branch-tracer tracer, init returned -95
[    4.210001] FAILED!
[    4.212104] initcall init_bts_trace+0x0/0x12 returned -95 after 6510 usecs
[    4.213336] initcall init_bts_trace+0x0/0x12 returned with error code -95 
[    4.216671] calling  init_power_trace+0x0/0x12 @ 1
[    4.220004] initcall init_power_trace+0x0/0x12 returned 0 after 0 usecs
[    4.223336] calling  init_blk_tracer+0x0/0x57 @ 1
[    4.226671] initcall init_blk_tracer+0x0/0x57 returned 0 after 0 usecs
[    4.230003] calling  init_per_zone_pages_min+0x0/0x88 @ 1
[    4.233416] initcall init_per_zone_pages_min+0x0/0x88 returned 0 after 0 usecs
[    4.236669] calling  pdflush_init+0x0/0x12 @ 1
[    4.240229] initcall pdflush_init+0x0/0x12 returned 0 after 0 usecs
[    4.243539] calling  kswapd_init+0x0/0x14 @ 1
[    4.246788] initcall kswapd_init+0x0/0x14 returned 0 after 0 usecs
[    4.250006] calling  init_tmpfs+0x0/0x29 @ 1
[    4.253398] initcall init_tmpfs+0x0/0x29 returned 0 after 0 usecs
[    4.256669] calling  setup_vmstat+0x0/0xc5 @ 1
[    4.260036] initcall setup_vmstat+0x0/0xc5 returned 0 after 0 usecs
[    4.263336] calling  mm_sysfs_init+0x0/0x29 @ 1
[    4.266681] initcall mm_sysfs_init+0x0/0x29 returned 0 after 0 usecs
[    4.270003] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    4.273343] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 0 usecs
[    4.276669] calling  hugetlb_init+0x0/0x2fb @ 1
[    4.280003] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.283359] initcall hugetlb_init+0x0/0x2fb returned 0 after 3255 usecs
[    4.286670] calling  slab_proc_init+0x0/0x25 @ 1
[    4.290018] initcall slab_proc_init+0x0/0x25 returned 0 after 0 usecs
[    4.293336] calling  slab_sysfs_init+0x0/0xf0 @ 1
[    4.303068] =============================================================================
[    4.303332] BUG idr_layer_cache: Redzone overwritten
[    4.303332] -----------------------------------------------------------------------------
[    4.303332] 
[    4.303332] INFO: 0xffff88003f838958-0xffff88003f83895f. First byte 0xa1 instead of 0xbb
[    4.303332] INFO: Allocated in 0xffff88003f9b94b0 age=4294878587 cpu=2 pid=0
[    4.303332] INFO: Freed in 0xffff88003f8389f0 age=18446744073709463001 cpu=4294967295 pid=0
[    4.303332] INFO: Slab 0xffffe200015d5340 objects=13 used=10 fp=0xffff88003f838738 flags=0x40000000000020c3
[    4.303332] INFO: Object 0xffff88003f838738 @offset=1848 fp=0x(null)
[    4.303332] 
[    4.303332] Bytes b4 0xffff88003f838728:  87 a2 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .���....ZZZZZZZZ
[    4.303332]   Object 0xffff88003f838738:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    4.303332]   Object 0xffff88003f838748:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    4.303332]   Object 0xffff88003f838758:  6b 6b 6b 6b 6b 6b 6b 6b 20 00 00 00 00 00 00 00 kkkkkkkk........
[    4.303332]   Object 0xffff88003f838768:  e0 22 8b 81 ff ff ff ff e8 26 00 00 00 00 00 00 �"..�����&......
[    4.303332]   Object 0xffff88003f838778:  e0 87 83 3f 00 88 ff ff eb 47 53 80 ff ff ff ff �..?..���GS.����
[    4.303332]   Object 0xffff88003f838788:  88 48 53 80 ff ff ff ff c0 87 83 3f 00 88 ff ff .HS.�����..?..��
[    4.303332]   Object 0xffff88003f838798:  08 94 5d 80 ff ff ff ff e0 22 8b 81 ff ff ff ff ..].�����"..����
[    4.303332]   Object 0xffff88003f8387a8:  0a 00 00 00 00 00 00 00 57 94 5d 80 ff ff ff ff ........W.].����
[    4.303332]   Object 0xffff88003f8387b8:  b1 8e 5d 80 ff ff ff ff 60 00 00 00 00 00 00 00 �.].���?`.......
[    4.303332]   Object 0xffff88003f8387c8:  e0 22 8b 81 ff ff ff ff c2 26 00 00 00 00 00 00 �"..�����&......
[    4.303332]   Object 0xffff88003f8387d8:  60 00 00 00 00 00 00 00 00 88 83 3f 00 88 ff ff `..........?..��
[    4.303332]   Object 0xffff88003f8387e8:  de 0d 54 80 ff ff ff ff 01 00 00 00 00 00 00 00 �.T.����........
[    4.303332]   Object 0xffff88003f8387f8:  e0 22 8b 81 ff ff ff ff 20 88 83 3f 00 88 ff ff �"..����...?..��
[    4.303332]   Object 0xffff88003f838808:  3c 90 9d 80 ff ff ff ff 01 00 00 00 00 00 00 00 <...����........
[    4.303332]   Object 0xffff88003f838818:  e0 22 8b 81 ff ff ff ff 70 88 83 3f 00 88 ff ff �"..����p..?..��
[    4.303332]   Object 0xffff88003f838828:  46 00 00 00 00 00 00 00 70 88 83 3f 00 88 ff ff F.......p..?..��
[    4.303332]   Object 0xffff88003f838838:  51 0e 54 80 ff ff ff ff 98 26 d8 80 ff ff ff ff Q.T.����.&�.����
[    4.303332]   Object 0xffff88003f838848:  80 26 d8 80 ff ff ff ff 80 26 d8 80 ff ff ff ff .&�.����.&�.��??
[    4.303332]   Object 0xffff88003f838858:  46 00 00 00 00 00 00 00 80 88 83 3f 00 88 ff ff F..........?..��
[    4.303332]   Object 0xffff88003f838868:  de 0d 54 80 ff ff ff ff 29 26 01 00 00 00 00 00 �.T.����)&......
[    4.303332]   Object 0xffff88003f838878:  80 26 d8 80 ff ff ff ff a0 88 83 3f 00 88 ff ff .&�.����...?..��
[    4.303332]   Object 0xffff88003f838888:  6e bd 20 80 ff ff ff ff b0 89 83 3f 00 88 ff ff n�..�����..?..��
[    4.303332]   Object 0xffff88003f838898:  46 00 00 00 00 00 00 00 29 26 01 00 00 00 00 00 F.......)&......
[    4.303332]   Object 0xffff88003f8388a8:  00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 ................
[    4.303332]   Object 0xffff88003f8388b8:  00 c0 83 3f 00 88 ff ff 00 00 00 00 00 00 00 00 .�.?..��........
[    4.303332]   Object 0xffff88003f8388c8:  1e 25 1f 25 00 00 00 00 01 00 00 00 00 00 00 00 .%.%............
[    4.303332]   Object 0xffff88003f8388d8:  46 02 00 00 00 00 00 00 10 ff ff ff ff ff ff ff F........�������
[    4.303332]   Object 0xffff88003f8388e8:  5e a9 23 80 ff ff ff ff 10 00 00 00 00 00 00 00 ^�#.����........
[    4.303332]   Object 0xffff88003f8388f8:  46 02 00 00 00 00 00 00 10 89 83 3f 00 88 ff ff F..........?..��
[    4.303332]   Object 0xffff88003f838908:  18 00 00 00 00 00 00 00 40 14 b7 01 00 88 ff ff ........@.�...��
[    4.303332]   Object 0xffff88003f838918:  40 14 b7 01 00 88 ff ff 98 d7 5d 01 00 e2 ff ff @.�...��.�]..���
[    4.303332]   Object 0xffff88003f838928:  b0 94 9b 3f 04 00 00 00 46 02 00 00 00 00 00 00 �..?....F.......
[    4.303332]   Object 0xffff88003f838938:  b0 f7 f8 80 00 00 00 00 80 89 83 3f 00 88 ff ff ���........?..��
[    4.303332]   Object 0xffff88003f838948:  82 00 00 00 00 00 00 00 53 56 21 80 ff ff ff ff ........SV!.����
[    4.303332]  Redzone 0xffff88003f838958:  a1 ff ff ff 00 00 00 00                         ����....        
[    4.303332]  Padding 0xffff88003f838998:  e0 a6 fc 80 ff ff ff ff                         ���.����        
[    4.303332] Pid: 1, comm: swapper Not tainted 2.6.29-rc8-tip-02665-g4c672bd-dirty #21494
[    4.303332] Call Trace:
[    4.303332]  [<ffffffff802abdbf>] print_trailer+0x140/0x149
[    4.303332]  [<ffffffff802ac2fc>] check_bytes_and_report+0xb7/0xf7
[    4.303332]  [<ffffffff802ac39d>] check_object+0x61/0x20d
[    4.303332]  [<ffffffff802addf6>] __slab_alloc+0x41d/0x519
[    4.303332]  [<ffffffff8052d7a8>] ? idr_pre_get+0x2d/0x75
[    4.303332]  [<ffffffff8052d7bc>] ? idr_pre_get+0x41/0x75
[    4.303332]  [<ffffffff8052d7a8>] ? idr_pre_get+0x2d/0x75
[    4.303332]  [<ffffffff802adf82>] kmem_cache_alloc+0x90/0xc1
[    4.303332]  [<ffffffff8052d7a8>] idr_pre_get+0x2d/0x75
[    4.303332]  [<ffffffff8052d801>] ida_pre_get+0x11/0x61
[    4.303332]  [<ffffffff803053cf>] sysfs_new_dirent+0xa7/0x105
[    4.303332]  [<ffffffff80304d55>] sysfs_add_file_mode+0x36/0x90
[    4.303332]  [<ffffffff8030692b>] internal_create_group+0xc8/0x152
[    4.303332]  [<ffffffff803069e0>] sysfs_create_group+0x13/0x17
[    4.303332]  [<ffffffff802af162>] sysfs_slab_add+0x13f/0x17d
[    4.303332]  [<ffffffff81014238>] ? slab_sysfs_init+0x0/0xf0
[    4.303332]  [<ffffffff81014296>] slab_sysfs_init+0x5e/0xf0
[    4.303332]  [<ffffffff81014238>] ? slab_sysfs_init+0x0/0xf0
[    4.303332]  [<ffffffff80209080>] do_one_initcall+0x75/0x185
[    4.303332]  [<ffffffff8052d672>] ? ida_get_new_above+0x18d/0x1ae
[    4.303332]  [<ffffffff802ac49a>] ? check_object+0x15e/0x20d
[    4.303332]  [<ffffffff802ac003>] ? trace+0x12/0x82
[    4.303332]  [<ffffffff802ac9d7>] ? init_object+0xd/0x58
[    4.303332]  [<ffffffff8025a403>] ? __lock_acquire+0x7f2/0x846
[    4.303332]  [<ffffffff80540dde>] ? _raw_spin_unlock+0x8f/0x96
[    4.303332]  [<ffffffff809d903c>] ? _spin_unlock+0x2b/0x2f
[    4.303332]  [<ffffffff802fc575>] ? proc_register+0x122/0x175
[    4.303332]  [<ffffffff802fc5b2>] ? proc_register+0x15f/0x175
[    4.303332]  [<ffffffff802fc6fa>] ? create_proc_entry+0x83/0x99
[    4.303332]  [<ffffffff802f0000>] ? __mb_cache_entry_find+0x9f/0x124
[    4.303332]  [<ffffffff80272131>] ? irq_to_desc+0x9/0x29
[    4.303332]  [<ffffffff80ffe64a>] kernel_init+0x13c/0x192
[    4.303332]  [<ffffffff8020c26a>] child_rip+0xa/0x20
[    4.303332]  [<ffffffff80ffe50e>] ? kernel_init+0x0/0x192
[    4.303332]  [<ffffffff8020c260>] ? child_rip+0x0/0x20
[    4.303332] FIX idr_layer_cache: Restoring 0xffff88003f838958-0xffff88003f83895f=0xbb
[    4.303332] 
[    4.303332] FIX idr_layer_cache: Marking all objects used
[    4.339819] initcall slab_sysfs_init+0x0/0xf0 returned 0 after 39062 usecs
[    4.340008] calling  fasync_init+0x0/0x2a @ 1
[    4.344059] initcall fasync_init+0x0/0x2a returned 0 after 0 usecs
[    4.346673] calling  proc_filesystems_init+0x0/0x22 @ 1
[    4.350078] initcall proc_filesystems_init+0x0/0x22 returned 0 after 0 usecs
[    4.353336] calling  inotify_setup+0x0/0x12 @ 1
[    4.356669] initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
[    4.360002] calling  aio_setup+0x0/0xb6 @ 1
[    4.364385] initcall aio_setup+0x0/0xb6 returned 0 after 0 usecs
[    4.366673] calling  proc_locks_init+0x0/0x22 @ 1
[    4.370045] initcall proc_locks_init+0x0/0x22 returned 0 after 0 usecs
[    4.373335] calling  init_sys32_ioctl+0x0/0x85 @ 1
[    4.376684] initcall init_sys32_ioctl+0x0/0x85 returned 0 after 0 usecs
[    4.380003] calling  init_mbcache+0x0/0x14 @ 1
[    4.383337] initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
[    4.386669] calling  dquot_init+0x0/0xe5 @ 1
[    4.390001] VFS: Disk quotas dquot_6.5.2
[    4.393732] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.396671] initcall dquot_init+0x0/0xe5 returned 0 after 6510 usecs
[    4.400014] calling  proc_cmdline_init+0x0/0x22 @ 1
[    4.403345] initcall proc_cmdline_init+0x0/0x22 returned 0 after 0 usecs
[    4.406669] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    4.410010] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 0 usecs
[    4.413338] calling  proc_devices_init+0x0/0x22 @ 1
[    4.416677] initcall proc_devices_init+0x0/0x22 returned 0 after 0 usecs
[    4.420002] calling  proc_interrupts_init+0x0/0x22 @ 1
[    4.423343] initcall proc_interrupts_init+0x0/0x22 returned 0 after 0 usecs
[    4.426669] calling  proc_loadavg_init+0x0/0x22 @ 1
[    4.430010] initcall proc_loadavg_init+0x0/0x22 returned 0 after 0 usecs
[    4.433335] calling  proc_meminfo_init+0x0/0x22 @ 1
[    4.436676] initcall proc_meminfo_init+0x0/0x22 returned 0 after 0 usecs
[    4.440002] calling  proc_stat_init+0x0/0x22 @ 1
[    4.443343] initcall proc_stat_init+0x0/0x22 returned 0 after 0 usecs
[    4.446669] calling  proc_uptime_init+0x0/0x2d @ 1
[    4.450010] initcall proc_uptime_init+0x0/0x2d returned 0 after 0 usecs
[    4.453335] calling  proc_version_init+0x0/0x22 @ 1
[    4.456677] initcall proc_version_init+0x0/0x22 returned 0 after 0 usecs
[    4.460002] calling  vmcore_init+0x0/0x8a9 @ 1
[    4.463336] initcall vmcore_init+0x0/0x8a9 returned 0 after 0 usecs
[    4.466669] calling  proc_kmsg_init+0x0/0x25 @ 1
[    4.470019] initcall proc_kmsg_init+0x0/0x25 returned 0 after 0 usecs
[    4.473335] calling  configfs_init+0x0/0xd5 @ 1
[    4.477070] initcall configfs_init+0x0/0xd5 returned 0 after 0 usecs
[    4.480003] calling  init_devpts_fs+0x0/0x3f @ 1
[    4.483445] initcall init_devpts_fs+0x0/0x3f returned 0 after 0 usecs
[    4.486669] calling  init_reiserfs_fs+0x0/0x9a @ 1
[    4.490594] initcall init_reiserfs_fs+0x0/0x9a returned 0 after 0 usecs
[    4.493337] calling  init_ext3_fs+0x0/0x72 @ 1
[    4.497475] initcall init_ext3_fs+0x0/0x72 returned 0 after 0 usecs
[    4.500003] calling  init_ext4_fs+0x0/0x97 @ 1
[    4.505419] initcall init_ext4_fs+0x0/0x97 returned 0 after 0 usecs
[    4.506670] calling  journal_init+0x0/0x85 @ 1
[    4.515833] initcall journal_init+0x0/0x85 returned 0 after 3255 usecs
[    4.516669] calling  journal_init+0x0/0xde @ 1
[    4.521874] initcall journal_init+0x0/0xde returned 0 after 0 usecs
[    4.523337] calling  init_ramfs_fs+0x0/0x12 @ 1
[    4.526671] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    4.530002] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    4.533852] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 0 usecs
[    4.536670] calling  init_coda+0x0/0x141 @ 1
[    4.540412] device class 'coda': registering
[    4.543603] device: 'cfs0': device_add
[    4.546992] device: 'cfs1': device_add
[    4.550272] device: 'cfs2': device_add
[    4.553609] device: 'cfs3': device_add
[    4.560033] device: 'cfs4': device_add
[    4.563684] initcall init_coda+0x0/0x141 returned 0 after 22786 usecs
[    4.566669] calling  init_fat_fs+0x0/0x4f @ 1
[    4.570976] initcall init_fat_fs+0x0/0x4f returned 0 after 0 usecs
[    4.573336] calling  init_vfat_fs+0x0/0x12 @ 1
[    4.576670] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    4.580002] calling  init_nfsd+0x0/0xe3 @ 1
[    4.583334] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.593781] initcall init_nfsd+0x0/0xe3 returned 0 after 9765 usecs
[    4.596670] calling  init_nlm+0x0/0x22 @ 1
[    4.600010] initcall init_nlm+0x0/0x22 returned 0 after 0 usecs
[    4.603336] calling  init_nls_cp437+0x0/0x12 @ 1
[    4.606679] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    4.610002] calling  init_nls_cp850+0x0/0x12 @ 1
[    4.613336] initcall init_nls_cp850+0x0/0x12 returned 0 after 0 usecs
[    4.616669] calling  init_nls_cp860+0x0/0x12 @ 1
[    4.620003] initcall init_nls_cp860+0x0/0x12 returned 0 after 0 usecs
[    4.623335] calling  init_nls_cp866+0x0/0x12 @ 1
[    4.626669] initcall init_nls_cp866+0x0/0x12 returned 0 after 0 usecs
[    4.630002] calling  init_nls_cp949+0x0/0x12 @ 1
[    4.633336] initcall init_nls_cp949+0x0/0x12 returned 0 after 0 usecs
[    4.636669] calling  init_nls_cp1250+0x0/0x12 @ 1
[    4.640003] initcall init_nls_cp1250+0x0/0x12 returned 0 after 0 usecs
[    4.643335] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    4.646669] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    4.650002] calling  init_nls_iso8859_2+0x0/0x12 @ 1
[    4.653336] initcall init_nls_iso8859_2+0x0/0x12 returned 0 after 0 usecs
[    4.656669] calling  init_nls_iso8859_4+0x0/0x12 @ 1
[    4.660003] initcall init_nls_iso8859_4+0x0/0x12 returned 0 after 0 usecs
[    4.663335] calling  init_nls_iso8859_7+0x0/0x12 @ 1
[    4.666669] initcall init_nls_iso8859_7+0x0/0x12 returned 0 after 0 usecs
[    4.670005] calling  init_nls_iso8859_9+0x0/0x12 @ 1
[    4.673336] initcall init_nls_iso8859_9+0x0/0x12 returned 0 after 0 usecs
[    4.676669] calling  init_nls_iso8859_14+0x0/0x12 @ 1
[    4.680003] initcall init_nls_iso8859_14+0x0/0x12 returned 0 after 0 usecs
[    4.683335] calling  init_nls_koi8_r+0x0/0x12 @ 1
[    4.686669] initcall init_nls_koi8_r+0x0/0x12 returned 0 after 0 usecs
[    4.690002] calling  init_nls_koi8_u+0x0/0x12 @ 1
[    4.693336] initcall init_nls_koi8_u+0x0/0x12 returned 0 after 0 usecs
[    4.696669] calling  init_nls_koi8_ru+0x0/0x48 @ 1
[    4.700003] initcall init_nls_koi8_ru+0x0/0x48 returned 0 after 0 usecs
[    4.703336] calling  init_cifs+0x0/0x48a @ 1
[    4.712075] initcall init_cifs+0x0/0x48a returned 0 after 3255 usecs
[    4.713339] calling  init_ncp_fs+0x0/0x62 @ 1
[    4.717077] initcall init_ncp_fs+0x0/0x62 returned 0 after 0 usecs
[    4.720004] calling  init_xfs_fs+0x0/0xaa @ 1
[    4.723345] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    4.739689] SGI XFS Quota Management subsystem
[    4.740033] initcall init_xfs_fs+0x0/0xaa returned 0 after 16276 usecs
[    4.743336] calling  ocfs2_init+0x0/0x340 @ 1
[    4.746674] OCFS2 1.5.0
[    4.752157] initcall ocfs2_init+0x0/0x340 returned 0 after 3255 usecs
[    4.753339] calling  ocfs2_stack_glue_init+0x0/0x95 @ 1
[    4.756708] initcall ocfs2_stack_glue_init+0x0/0x95 returned 0 after 0 usecs
[    4.760002] calling  o2cb_stack_init+0x0/0x12 @ 1
[    4.763335] ocfs2: Registered cluster interface o2cb
[    4.766673] initcall o2cb_stack_init+0x0/0x12 returned 0 after 3255 usecs
[    4.770002] calling  init_o2nm+0x0/0x9a @ 1
[    4.773335] OCFS2 Node Manager 1.5.0
[    4.780073] initcall init_o2nm+0x0/0x9a returned 0 after 6510 usecs
[    4.783336] calling  dlm_init+0x0/0x245 @ 1
[    4.786668] OCFS2 DLM 1.5.0
[    4.792564] initcall dlm_init+0x0/0x245 returned 0 after 3255 usecs
[    4.793341] calling  init_dlmfs_fs+0x0/0xdd @ 1
[    4.796671] OCFS2 DLMFS 1.5.0
[    4.800588] OCFS2 User DLM kernel interface loaded
[    4.803337] initcall init_dlmfs_fs+0x0/0xdd returned 0 after 6510 usecs
[    4.806669] calling  init_gfs2_fs+0x0/0x1b1 @ 1
[    4.815925] GFS2 (built Mar 19 2009 14:10:16) installed
[    4.816675] initcall init_gfs2_fs+0x0/0x1b1 returned 0 after 6510 usecs
[    4.820003] calling  ipc_init+0x0/0x2f @ 1
[    4.823355] msgmni has been set to 1948
[    4.826689] initcall ipc_init+0x0/0x2f returned 0 after 3255 usecs
[    4.830002] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    4.833345] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 0 usecs
[    4.836669] calling  init_mqueue_fs+0x0/0xd6 @ 1
[    4.840547] initcall init_mqueue_fs+0x0/0xd6 returned 0 after 0 usecs
[    4.843337] calling  key_proc_init+0x0/0x33 @ 1
[    4.846687] initcall key_proc_init+0x0/0x33 returned 0 after 0 usecs
[    4.850003] calling  selinux_nf_ip_init+0x0/0x60 @ 1
[    4.853334] SELinux:  Registering netfilter hooks
[    4.856682] initcall selinux_nf_ip_init+0x0/0x60 returned 0 after 3255 usecs
[    4.860002] calling  init_sel_fs+0x0/0x68 @ 1
[    4.863889] initcall init_sel_fs+0x0/0x68 returned 0 after 0 usecs
[    4.866669] calling  selnl_init+0x0/0x4d @ 1
[    4.870080] initcall selnl_init+0x0/0x4d returned 0 after 0 usecs
[    4.873336] calling  sel_netif_init+0x0/0x66 @ 1
[    4.876675] initcall sel_netif_init+0x0/0x66 returned 0 after 0 usecs
[    4.880002] calling  sel_netnode_init+0x0/0x73 @ 1
[    4.883340] initcall sel_netnode_init+0x0/0x73 returned 0 after 0 usecs
[    4.886669] calling  sel_netport_init+0x0/0x73 @ 1
[    4.890006] initcall sel_netport_init+0x0/0x73 returned 0 after 0 usecs
[    4.893336] calling  aurule_init+0x0/0x37 @ 1
[    4.896670] initcall aurule_init+0x0/0x37 returned 0 after 0 usecs
[    4.900002] calling  crypto_algapi_init+0x0/0xd @ 1
[    4.903350] initcall crypto_algapi_init+0x0/0xd returned 0 after 0 usecs
[    4.906669] calling  chainiv_module_init+0x0/0x12 @ 1
[    4.910040] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.913336] calling  eseqiv_module_init+0x0/0x12 @ 1
[    4.916671] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.920002] calling  hmac_module_init+0x0/0x12 @ 1
[    4.923337] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.926672] calling  crypto_null_mod_init+0x0/0x7d @ 1
[    4.930148] alg: No test for cipher_null (cipher_null-generic)
[    4.936595] alg: No test for digest_null (digest_null-generic)
[    4.936810] alg: No test for compress_null (compress_null-generic)
[    4.945488] initcall crypto_null_mod_init+0x0/0x7d returned 0 after 13020 usecs
[    4.946670] calling  md5_mod_init+0x0/0x12 @ 1
[    4.950317] initcall md5_mod_init+0x0/0x12 returned 0 after 0 usecs
[    4.953337] calling  rmd256_mod_init+0x0/0x12 @ 1
[    4.956838] initcall rmd256_mod_init+0x0/0x12 returned 0 after 0 usecs
[    4.960004] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    4.963504] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 usecs
[    4.966670] calling  sha256_generic_mod_init+0x0/0x3f @ 1
[    4.973391] initcall sha256_generic_mod_init+0x0/0x3f returned 0 after 3255 usecs
[    4.976673] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[    4.980004] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.983336] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    4.986671] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.990002] calling  crypto_cts_module_init+0x0/0x12 @ 1
[    4.993337] initcall crypto_cts_module_init+0x0/0x12 returned 0 after 0 usecs
[    4.996669] calling  des_generic_mod_init+0x0/0x3f @ 1
[    5.000361] initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 usecs
[    5.003337] calling  aes_init+0x0/0x12 @ 1
[    5.006899] initcall aes_init+0x0/0x12 returned 0 after 0 usecs
[    5.010003] calling  cast5_mod_init+0x0/0x12 @ 1
[    5.013582] initcall cast5_mod_init+0x0/0x12 returned 0 after 0 usecs
[    5.016670] calling  arc4_init+0x0/0x12 @ 1
[    5.020192] initcall arc4_init+0x0/0x12 returned 0 after 0 usecs
[    5.023352] calling  tea_mod_init+0x0/0x64 @ 1
[    5.027169] initcall tea_mod_init+0x0/0x64 returned 0 after 0 usecs
[    5.030003] calling  salsa20_generic_mod_init+0x0/0x12 @ 1
[    5.033481] initcall salsa20_generic_mod_init+0x0/0x12 returned 0 after 0 usecs
[    5.036670] calling  crc32c_mod_init+0x0/0x12 @ 1
[    5.040379] initcall crc32c_mod_init+0x0/0x12 returned 0 after 0 usecs
[    5.043336] calling  lzo_mod_init+0x0/0x12 @ 1
[    5.047009] initcall lzo_mod_init+0x0/0x12 returned 0 after 0 usecs
[    5.050003] calling  krng_mod_init+0x0/0x12 @ 1
[    5.053465] alg: No test for stdrng (krng)
[    5.058312] initcall krng_mod_init+0x0/0x12 returned 0 after 3255 usecs
[    5.060002] calling  prng_mod_init+0x0/0x27 @ 1
[    5.063465] alg: No test for stdrng (ansi_cprng)
[    5.070903] initcall prng_mod_init+0x0/0x27 returned 0 after 6510 usecs
[    5.073336] calling  proc_genhd_init+0x0/0x3c @ 1
[    5.076688] initcall proc_genhd_init+0x0/0x3c returned 0 after 0 usecs
[    5.080002] calling  bsg_init+0x0/0x12a @ 1
[    5.086737] device class 'bsg': registering
[    5.090265] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    5.093337] initcall bsg_init+0x0/0x12a returned 0 after 9765 usecs
[    5.096669] calling  noop_init+0x0/0x14 @ 1
[    5.100017] io scheduler noop registered
[    5.103336] initcall noop_init+0x0/0x14 returned 0 after 3255 usecs
[    5.106669] calling  as_init+0x0/0x14 @ 1
[    5.110001] io scheduler anticipatory registered
[    5.113336] initcall as_init+0x0/0x14 returned 0 after 3255 usecs
[    5.116669] calling  deadline_init+0x0/0x14 @ 1
[    5.120001] io scheduler deadline registered
[    5.123336] initcall deadline_init+0x0/0x14 returned 0 after 3255 usecs
[    5.126669] calling  cfq_init+0x0/0x94 @ 1
[    5.130883] io scheduler cfq registered (default)
[    5.133337] initcall cfq_init+0x0/0x94 returned 0 after 3255 usecs
[    5.136669] calling  libcrc32c_mod_init+0x0/0x2c @ 1
[    5.140007] initcall libcrc32c_mod_init+0x0/0x2c returned 0 after 0 usecs
[    5.143336] calling  percpu_counter_startup+0x0/0x2d @ 1
[    5.146670] initcall percpu_counter_startup+0x0/0x2d returned 0 after 0 usecs
[    5.150002] calling  dynamic_printk_init+0x0/0xe2 @ 1
[    5.155325] initcall dynamic_printk_init+0x0/0xe2 returned 0 after 0 usecs
[    5.156671] calling  bt8xxgpio_init+0x0/0x20 @ 1
[    5.160003] bus: 'pci': add driver bt8xxgpio
[    5.163657] initcall bt8xxgpio_init+0x0/0x20 returned 0 after 3255 usecs
[    5.166671] calling  pci_init+0x0/0x3a @ 1
[    5.170010] pci 0000:00:00.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.173355] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.176670] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.180003] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xb9
[    5.183342] pci 0000:00:01.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.186671] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.190002] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.193335] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xb9
[    5.196672] pci 0000:00:01.1: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.200006] pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x27
[    5.203336] pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0x404
[    5.206669] pci 0000:00:01.1: calling pci_fixup_video+0x0/0xb9
[    5.210006] pci 0000:00:02.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.213340] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.216669] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.233347] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xb9
[    5.236677] pci 0000:00:02.1: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.240008] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x27
[    5.243336] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x404
[    5.246688] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xb9
[    5.250006] pci 0000:00:04.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.253340] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.256669] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.260015] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xb9
[    5.263340] pci 0000:00:06.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.266673] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.270002] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.273335] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xb9
[    5.276673] pci 0000:00:09.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.280004] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.283336] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.286669] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xb9
[    5.290006] pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.293340] pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.296669] pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.300002] pci 0000:00:0a.0: calling pci_fixup_video+0x0/0xb9
[    5.303339] pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.306726] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.310003] pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x7e
[    5.313342] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    5.316676] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.320003] pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x73
[    5.323337] pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.326669] pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.330002] pci 0000:00:0b.0: calling pci_fixup_video+0x0/0xb9
[    5.333339] pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.336732] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.340003] pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x7e
[    5.343341] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    5.346676] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.350003] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x73
[    5.353337] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.356669] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.360002] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xb9
[    5.363339] pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.366740] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.370003] pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x7e
[    5.373341] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    5.376676] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.380003] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x73
[    5.383337] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.386669] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.390002] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xb9
[    5.393339] pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk+0x0/0x1fd
[    5.396748] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.400003] pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x7e
[    5.403341] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    5.406676] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.410003] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x73
[    5.413337] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.416669] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.420002] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xb9
[    5.423340] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.426669] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.430002] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xb9
[    5.433340] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x27
[    5.436669] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x404
[    5.440003] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xb9
[    5.443340] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x27
[    5.446669] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x404
[    5.450002] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xb9
[    5.453340] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x27
[    5.456669] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x404
[    5.460002] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xb9
[    5.463340] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.466669] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.470002] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xb9
[    5.473340] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x27
[    5.476669] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x404
[    5.480002] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xb9
[    5.483336] pci 0000:01:00.0: Boot video device
[    5.486673] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x27
[    5.490002] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x404
[    5.493335] pci 0000:01:00.1: calling pci_fixup_video+0x0/0xb9
[    5.496672] initcall pci_init+0x0/0x3a returned 0 after 319010 usecs
[    5.500003] calling  pci_proc_init+0x0/0x6b @ 1
[    5.503622] initcall pci_proc_init+0x0/0x6b returned 0 after 0 usecs
[    5.506669] calling  pcie_portdrv_init+0x0/0x4c @ 1
[    5.510264] bus: 'pci_express': registered
[    5.513336] bus: 'pci': add driver pcieport-driver
[    5.516682] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver pcieport-driver
[    5.520002] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0b.0
[    5.523355] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    5.526755]   alloc irq_desc for 24 on cpu 0 node 0
[    5.529999]   alloc kstat_irqs on cpu 0 node 0
[    5.530011] pcieport-driver 0000:00:0b.0: irq 24 for MSI/MSI-X
[    5.533349] device: '0000:00:0b.0:pcie00': device_add
[    5.536677] bus: 'pci_express': add device 0000:00:0b.0:pcie00
[    5.540295] driver: '0000:00:0b.0': driver_bound: bound to device 'pcieport-driver'
[    5.543351] bus: 'pci': really_probe: bound device 0000:00:0b.0 to driver pcieport-driver
[    5.546683] bus: 'pci': driver_probe_device: matched device 0000:00:0c.0 with driver pcieport-driver
[    5.550001] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0c.0
[    5.553353] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    5.556737]   alloc irq_desc for 25 on cpu 0 node 0
[    5.559999]   alloc kstat_irqs on cpu 0 node 0
[    5.560009] pcieport-driver 0000:00:0c.0: irq 25 for MSI/MSI-X
[    5.563348] device: '0000:00:0c.0:pcie00': device_add
[    5.566676] bus: 'pci_express': add device 0000:00:0c.0:pcie00
[    5.570292] driver: '0000:00:0c.0': driver_bound: bound to device 'pcieport-driver'
[    5.573337] bus: 'pci': really_probe: bound device 0000:00:0c.0 to driver pcieport-driver
[    5.576670] bus: 'pci': driver_probe_device: matched device 0000:00:0d.0 with driver pcieport-driver
[    5.580001] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0d.0
[    5.583353] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[    5.586737]   alloc irq_desc for 26 on cpu 0 node 0
[    5.589999]   alloc kstat_irqs on cpu 0 node 0
[    5.590009] pcieport-driver 0000:00:0d.0: irq 26 for MSI/MSI-X
[    5.593348] device: '0000:00:0d.0:pcie00': device_add
[    5.596676] bus: 'pci_express': add device 0000:00:0d.0:pcie00
[    5.600283] driver: '0000:00:0d.0': driver_bound: bound to device 'pcieport-driver'
[    5.603337] bus: 'pci': really_probe: bound device 0000:00:0d.0 to driver pcieport-driver
[    5.606670] bus: 'pci': driver_probe_device: matched device 0000:00:0e.0 with driver pcieport-driver
[    5.610001] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0e.0
[    5.613363] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    5.616737]   alloc irq_desc for 27 on cpu 0 node 0
[    5.619999]   alloc kstat_irqs on cpu 0 node 0
[    5.620009] pcieport-driver 0000:00:0e.0: irq 27 for MSI/MSI-X
[    5.623348] device: '0000:00:0e.0:pcie00': device_add
[    5.626676] bus: 'pci_express': add device 0000:00:0e.0:pcie00
[    5.630328] driver: '0000:00:0e.0': driver_bound: bound to device 'pcieport-driver'
[    5.633337] bus: 'pci': really_probe: bound device 0000:00:0e.0 to driver pcieport-driver
[    5.636946] initcall pcie_portdrv_init+0x0/0x4c returned 0 after 123697 usecs
[    5.640004] calling  aer_service_init+0x0/0x20 @ 1
[    5.643335] bus: 'pci_express': add driver aer
[    5.646933] initcall aer_service_init+0x0/0x20 returned 0 after 3255 usecs
[    5.650003] calling  pci_stub_init+0x0/0x1b @ 1
[    5.656668] bus: 'pci': add driver pci-stub
[    5.660274] initcall pci_stub_init+0x0/0x1b returned 0 after 6510 usecs
[    5.663337] calling  kb3886_init+0x0/0x3c @ 1
[    5.666670] initcall kb3886_init+0x0/0x3c returned -19 after 0 usecs
[    5.670004] calling  nvidiafb_init+0x0/0x2c0 @ 1
[    5.673336] bus: 'pci': add driver nvidiafb
[    5.677072] initcall nvidiafb_init+0x0/0x2c0 returned 0 after 3255 usecs
[    5.680004] calling  viafb_init+0x0/0x1188 @ 1
[    5.683335] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[    5.686784] device: 'i2c-0': device_add
[    5.760003] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    5.896669] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.033335] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.170001] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.173335] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    6.176668] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    6.313335] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.450001] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.586668] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.723336] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    6.726668] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    6.730001] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    6.866668] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.003335] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.140002] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.276668] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.280002] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    7.283335] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    7.420002] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.556668] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.693335] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.830002] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    7.833335] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    7.836668] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    7.973335] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.110001] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.246669] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.383335] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.386668] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    8.390001] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    8.526669] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.663335] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.799830] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.936493] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    8.940002] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    8.950002] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    9.089828] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.226494] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.363337] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.500001] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.503335] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    9.506668] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    9.643335] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.780002] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.916495] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.053160] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.056669] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   10.066668] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   10.206494] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.343161] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.480003] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.616668] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.620002] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   10.623335] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   10.760002] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   10.896669] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.033161] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.169827] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.173335] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   11.183335] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   11.323160] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.459828] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.596669] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.733335] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   11.736669] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   11.740002] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   11.876668] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.013335] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.149828] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.286495] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.290002] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.300002] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.439827] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.576495] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.713337] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.850001] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.853335] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.856668] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.993335] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   13.130002] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   13.266495] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   13.403161] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   13.406669] i2c-adapter i2c-0: Used 4 tries to write to client at 0x38: failed, timeout?
[   13.416668] i2c-adapter i2c-0: NAK from device addr 0x38 msg #0
[   13.489874] ioremap failed
[   13.490009] initcall viafb_init+0x0/0x1188 returned -1 after 7623697 usecs
[   13.496670] initcall viafb_init+0x0/0x1188 returned with error code -1 
[   13.503343] calling  gxfb_init+0x0/0x84 @ 1
[   13.510010] bus: 'pci': add driver gxfb
[   13.514641] initcall gxfb_init+0x0/0x84 returned 0 after 3255 usecs
[   13.520003] calling  lxfb_init+0x0/0xf6 @ 1
[   13.523336] bus: 'pci': add driver lxfb
[   13.529225] initcall lxfb_init+0x0/0xf6 returned 0 after 3255 usecs
[   13.533337] calling  imsttfb_init+0x0/0x10c @ 1
[   13.540002] bus: 'pci': add driver imsttfb
[   13.544437] initcall imsttfb_init+0x0/0x10c returned 0 after 3255 usecs
[   13.550004] calling  s1d13xxxfb_init+0x0/0x2d @ 1
[   13.553336] bus: 'platform': add driver s1d13806fb
[   13.560990] initcall s1d13xxxfb_init+0x0/0x2d returned 0 after 6510 usecs
[   13.566670] calling  bq24022_init+0x0/0x19 @ 1
[   13.570002] bus: 'platform': add driver bq24022
[   13.577380] bus: 'platform': remove driver bq24022
[   13.582452] driver: 'bq24022': driver_release
[   13.586674] initcall bq24022_init+0x0/0x19 returned -19 after 16276 usecs
[   13.593336] calling  da903x_regulator_init+0x0/0x12 @ 1
[   13.596669] bus: 'platform': add driver da903x-regulator
[   13.604464] initcall da903x_regulator_init+0x0/0x12 returned 0 after 6510 usecs
[   13.610005] calling  rand_initialize+0x0/0x31 @ 1
[   13.613367] initcall rand_initialize+0x0/0x31 returned 0 after 0 usecs
[   13.620003] calling  tty_init+0x0/0xf5 @ 1
[   13.626680] device: 'tty': device_add
[   13.631167] device: 'console': device_add
[   13.635467] device: 'tty0': device_add
[   13.639486] device class 'vc': registering
[   13.643851] device: 'vcs': device_add
[   13.647782] device: 'vcsa': device_add
[   13.651826] device: 'tty1': device_add
[   13.655879] device: 'tty2': device_add
[   13.659897] device: 'tty3': device_add
[   13.664145] device: 'tty4': device_add
[   13.668381] device: 'tty5': device_add
[   13.672395] device: 'tty6': device_add
[   13.676427] device: 'tty7': device_add
[   13.680998] device: 'tty8': device_add
[   13.685018] device: 'tty9': device_add
[   13.689037] device: 'tty10': device_add
[   13.693157] device: 'tty11': device_add
[   13.697615] device: 'tty12': device_add
[   13.701727] device: 'tty13': device_add
[   13.705834] device: 'tty14': device_add
[   13.709944] device: 'tty15': device_add
[   13.714581] device: 'tty16': device_add
[   13.718691] device: 'tty17': device_add
[   13.722804] device: 'tty18': device_add
[   13.727690] device: 'tty19': device_add
[   13.731893] device: 'tty20': device_add
[   13.735995] device: 'tty21': device_add
[   13.740999] device: 'tty22': device_add
[   13.745119] device: 'tty23': device_add
[   13.749264] device: 'tty24': device_add
[   13.753390] device: 'tty25': device_add
[   13.757586] device: 'tty26': device_add
[   13.761701] device: 'tty27': device_add
[   13.765825] device: 'tty28': device_add
[   13.769932] device: 'tty29': device_add
[   13.774321] device: 'tty30': device_add
[   13.778427] device: 'tty31': device_add
[   13.782534] device: 'tty32': device_add
[   13.786653] device: 'tty33': device_add
[   13.790786] device: 'tty34': device_add
[   13.794897] device: 'tty35': device_add
[   13.799003] device: 'tty36': device_add
[   13.803256] device: 'tty37': device_add
[   13.807367] device: 'tty38': device_add
[   13.812023] device: 'tty39': device_add
[   13.816131] device: 'tty40': device_add
[   13.821161] device: 'tty41': device_add
[   13.825280] device: 'tty42': device_add
[   13.829392] device: 'tty43': device_add
[   13.834730] device: 'tty44': device_add
[   13.838958] device: 'tty45': device_add
[   13.843067] device: 'tty46': device_add
[   13.847706] device: 'tty47': device_add
[   13.851900] device: 'tty48': device_add
[   13.856018] device: 'tty49': device_add
[   13.861242] device: 'tty50': device_add
[   13.865358] device: 'tty51': device_add
[   13.869467] device: 'tty52': device_add
[   13.874236] device: 'tty53': device_add
[   13.878453] device: 'tty54': device_add
[   13.882565] device: 'tty55': device_add
[   13.886725] device: 'tty56': device_add
[   13.891012] device: 'tty57': device_add
[   13.895215] device: 'tty58': device_add
[   13.899337] device: 'tty59': device_add
[   13.904184] device: 'tty60': device_add
[   13.908310] device: 'tty61': device_add
[   13.912424] device: 'tty62': device_add
[   13.916610] device: 'tty63': device_add
[   13.921145] initcall tty_init+0x0/0xf5 returned 0 after 286458 usecs
[   13.926673] calling  pty_init+0x0/0x336 @ 1
[   13.930035] device: 'ptmx': device_add
[   13.935877] initcall pty_init+0x0/0x336 returned 0 after 3255 usecs
[   13.940004] calling  sysrq_init+0x0/0x25 @ 1
[   13.943363] initcall sysrq_init+0x0/0x25 returned 0 after 0 usecs
[   13.950003] calling  cy_init+0x0/0x122 @ 1
[   13.953337] Cyclades driver 2.5 (built Mar 19 2009 14:10:22)
[   13.960034] bus: 'pci': add driver cyclades
[   13.967337] initcall cy_init+0x0/0x122 returned 0 after 13020 usecs
[   13.973336] calling  nozomi_init+0x0/0x12f @ 1
[   13.976668] Initializing Nozomi driver 2.1d (build date: Mar 19 2009 14:10:22)
[   13.983361] bus: 'pci': add driver nozomi
[   13.989627] initcall nozomi_init+0x0/0x12f returned 0 after 9765 usecs
[   13.993337] calling  specialix_init_module+0x0/0x436 @ 1
[   14.000080] sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
[   14.006668] sx: derived from work (c) D.Gorodchanin 1994-1996.
[   14.013334] sx: DTR/RTS pin is always RTS.
[   14.016686] device: 'ttyW0': device_add
[   14.022046] device: 'ttyW1': device_add
[   14.026167] device: 'ttyW2': device_add
[   14.030977] device: 'ttyW3': device_add
[   14.035114] device: 'ttyW4': device_add
[   14.039218] device: 'ttyW5': device_add
[   14.043324] device: 'ttyW6': device_add
[   14.047698] device: 'ttyW7': device_add
[   14.051931] device: 'ttyW8': device_add
[   14.056043] device: 'ttyW9': device_add
[   14.060451] device: 'ttyW10': device_add
[   14.064657] device: 'ttyW11': device_add
[   14.068862] device: 'ttyW12': device_add
[   14.073083] device: 'ttyW13': device_add
[   14.077280] device: 'ttyW14': device_add
[   14.081580] device: 'ttyW15': device_add
[   14.085780] device: 'ttyW16': device_add
[   14.089974] device: 'ttyW17': device_add
[   14.094345] device: 'ttyW18': device_add
[   14.098549] device: 'ttyW19': device_add
[   14.102735] device: 'ttyW20': device_add
[   14.107679] device: 'ttyW21': device_add
[   14.111899] device: 'ttyW22': device_add
[   14.116101] device: 'ttyW23': device_add
[   14.120934] device: 'ttyW24': device_add
[   14.125229] device: 'ttyW25': device_add
[   14.129425] device: 'ttyW26': device_add
[   14.133745] device: 'ttyW27': device_add
[   14.138102] device: 'ttyW28': device_add
[   14.142315] device: 'ttyW29': device_add
[   14.146511] device: 'ttyW30': device_add
[   14.150704] device: 'ttyW31': device_add
[   14.154993] device: 'ttyW32': device_add
[   14.159196] device: 'ttyW33': device_add
[   14.163392] device: 'ttyW34': device_add
[   14.167777] device: 'ttyW35': device_add
[   14.171971] device: 'ttyW36': device_add
[   14.176166] device: 'ttyW37': device_add
[   14.180785] device: 'ttyW38': device_add
[   14.184979] device: 'ttyW39': device_add
[   14.189169] device: 'ttyW40': device_add
[   14.193564] device: 'ttyW41': device_add
[   14.197761] device: 'ttyW42': device_add
[   14.201952] device: 'ttyW43': device_add
[   14.206192] device: 'ttyW44': device_add
[   14.210782] device: 'ttyW45': device_add
[   14.214985] device: 'ttyW46': device_add
[   14.219177] device: 'ttyW47': device_add
[   14.223569] device: 'ttyW48': device_add
[   14.227775] device: 'ttyW49': device_add
[   14.231968] device: 'ttyW50': device_add
[   14.236162] device: 'ttyW51': device_add
[   14.240364] device: 'ttyW52': device_add
[   14.244556] device: 'ttyW53': device_add
[   14.248757] device: 'ttyW54': device_add
[   14.252951] device: 'ttyW55': device_add
[   14.257244] device: 'ttyW56': device_add
[   14.261629] device: 'ttyW57': device_add
[   14.265824] device: 'ttyW58': device_add
[   14.270236] device: 'ttyW59': device_add
[   14.275011] device: 'ttyW60': device_add
[   14.279205] device: 'ttyW61': device_add
[   14.283515] device: 'ttyW62': device_add
[   14.287719] device: 'ttyW63': device_add
[   14.291914] sx0: specialix IO8+ Board at 0x100 not found.
[   14.296680] sx1: specialix IO8+ Board at 0x180 not found.
[   14.300011] sx2: specialix IO8+ Board at 0x250 not found.
[   14.306677] sx3: specialix IO8+ Board at 0x260 not found.
[   14.313381] device: 'ttyW0': device_unregister
[   14.318508] device: 'ttyW0': device_create_release
[   14.320027] device: 'ttyW1': device_unregister
[   14.328031] device: 'ttyW1': device_create_release
[   14.330026] device: 'ttyW2': device_unregister
[   14.337566] device: 'ttyW2': device_create_release
[   14.340026] device: 'ttyW3': device_unregister
[   14.347429] device: 'ttyW3': device_create_release
[   14.350026] device: 'ttyW4': device_unregister
[   14.358145] device: 'ttyW4': device_create_release
[   14.360024] device: 'ttyW5': device_unregister
[   14.368253] device: 'ttyW5': device_create_release
[   14.370025] device: 'ttyW6': device_unregister
[   14.377775] device: 'ttyW6': device_create_release
[   14.380025] device: 'ttyW7': device_unregister
[   14.387774] device: 'ttyW7': device_create_release
[   14.390028] device: 'ttyW8': device_unregister
[   14.397604] device: 'ttyW8': device_create_release
[   14.400028] device: 'ttyW9': device_unregister
[   14.407758] device: 'ttyW9': device_create_release
[   14.410028] device: 'ttyW10': device_unregister
[   14.417460] device: 'ttyW10': device_create_release
[   14.420028] device: 'ttyW11': device_unregister
[   14.427802] device: 'ttyW11': device_create_release
[   14.430029] device: 'ttyW12': device_unregister
[   14.437666] device: 'ttyW12': device_create_release
[   14.440027] device: 'ttyW13': device_unregister
[   14.447401] device: 'ttyW13': device_create_release
[   14.450027] device: 'ttyW14': device_unregister
[   14.457099] device: 'ttyW14': device_create_release
[   14.460027] device: 'ttyW15': device_unregister
[   14.467342] device: 'ttyW15': device_create_release
[   14.470025] device: 'ttyW16': device_unregister
[   14.477730] device: 'ttyW16': device_create_release
[   14.480024] device: 'ttyW17': device_unregister
[   14.487881] device: 'ttyW17': device_create_release
[   14.490028] device: 'ttyW18': device_unregister
[   14.497591] device: 'ttyW18': device_create_release
[   14.500028] device: 'ttyW19': device_unregister
[   14.507585] device: 'ttyW19': device_create_release
[   14.510027] device: 'ttyW20': device_unregister
[   14.517285] device: 'ttyW20': device_create_release
[   14.520027] device: 'ttyW21': device_unregister
[   14.527647] device: 'ttyW21': device_create_release
[   14.530025] device: 'ttyW22': device_unregister
[   14.537373] device: 'ttyW22': device_create_release
[   14.540026] device: 'ttyW23': device_unregister
[   14.547084] device: 'ttyW23': device_create_release
[   14.550025] device: 'ttyW24': device_unregister
[   14.557855] device: 'ttyW24': device_create_release
[   14.560026] device: 'ttyW25': device_unregister
[   14.567562] device: 'ttyW25': device_create_release
[   14.570026] device: 'ttyW26': device_unregister
[   14.577703] device: 'ttyW26': device_create_release
[   14.580026] device: 'ttyW27': device_unregister
[   14.587547] device: 'ttyW27': device_create_release
[   14.590029] device: 'ttyW28': device_unregister
[   14.597257] device: 'ttyW28': device_create_release
[   14.600039] device: 'ttyW29': device_unregister
[   14.607445] device: 'ttyW29': device_create_release
[   14.610024] device: 'ttyW30': device_unregister
[   14.617464] device: 'ttyW30': device_create_release
[   14.620024] device: 'ttyW31': device_unregister
[   14.627308] device: 'ttyW31': device_create_release
[   14.630024] device: 'ttyW32': device_unregister
[   14.637431] device: 'ttyW32': device_create_release
[   14.640028] device: 'ttyW33': device_unregister
[   14.647455] device: 'ttyW33': device_create_release
[   14.650028] device: 'ttyW34': device_unregister
[   14.657164] device: 'ttyW34': device_create_release
[   14.660028] device: 'ttyW35': device_unregister
[   14.666968] device: 'ttyW35': device_create_release
[   14.670027] device: 'ttyW36': device_unregister
[   14.676694] device: 'ttyW36': device_create_release
[   14.680026] device: 'ttyW37': device_unregister
[   14.686577] device: 'ttyW37': device_create_release
[   14.690026] device: 'ttyW38': device_unregister
[   14.696378] device: 'ttyW38': device_create_release
[   14.700029] device: 'ttyW39': device_unregister
[   14.706075] device: 'ttyW39': device_create_release
[   14.710029] device: 'ttyW40': device_unregister
[   14.715781] device: 'ttyW40': device_create_release
[   14.720029] device: 'ttyW41': device_unregister
[   14.725485] device: 'ttyW41': device_create_release
[   14.730029] device: 'ttyW42': device_unregister
[   14.735193] device: 'ttyW42': device_create_release
[   14.740030] device: 'ttyW43': device_unregister
[   14.744899] device: 'ttyW43': device_create_release
[   14.746752] device: 'ttyW44': device_unregister
[   14.754666] device: 'ttyW44': device_create_release
[   14.756695] device: 'ttyW45': device_unregister
[   14.764365] device: 'ttyW45': device_create_release
[   14.766706] device: 'ttyW46': device_unregister
[   14.774075] device: 'ttyW46': device_create_release
[   14.776693] device: 'ttyW47': device_unregister
[   14.784151] device: 'ttyW47': device_create_release
[   14.786694] device: 'ttyW48': device_unregister
[   14.794269] device: 'ttyW48': device_create_release
[   14.796694] device: 'ttyW49': device_unregister
[   14.804761] device: 'ttyW49': device_create_release
[   14.806694] device: 'ttyW50': device_unregister
[   14.814462] device: 'ttyW50': device_create_release
[   14.816694] device: 'ttyW51': device_unregister
[   14.824161] device: 'ttyW51': device_create_release
[   14.826694] device: 'ttyW52': device_unregister
[   14.834326] device: 'ttyW52': device_create_release
[   14.836694] device: 'ttyW53': device_unregister
[   14.844044] device: 'ttyW53': device_create_release
[   14.846695] device: 'ttyW54': device_unregister
[   14.853760] device: 'ttyW54': device_create_release
[   14.856695] device: 'ttyW55': device_unregister
[   14.863821] device: 'ttyW55': device_create_release
[   14.866692] device: 'ttyW56': device_unregister
[   14.874238] device: 'ttyW56': device_create_release
[   14.876771] device: 'ttyW57': device_unregister
[   14.884366] device: 'ttyW57': device_create_release
[   14.886695] device: 'ttyW58': device_unregister
[   14.894080] device: 'ttyW58': device_create_release
[   14.896696] device: 'ttyW59': device_unregister
[   14.904233] device: 'ttyW59': device_create_release
[   14.906696] device: 'ttyW60': device_unregister
[   14.913974] device: 'ttyW60': device_create_release
[   14.916696] device: 'ttyW61': device_unregister
[   14.924288] device: 'ttyW61': device_create_release
[   14.926696] device: 'ttyW62': device_unregister
[   14.933998] device: 'ttyW62': device_create_release
[   14.936707] device: 'ttyW63': device_unregister
[   14.944482] device: 'ttyW63': device_create_release
[   14.946705] sx: No specialix IO8+ boards detected.
[   14.953340] initcall specialix_init_module+0x0/0x436 returned -5 after 930989 usecs
[   14.960003] initcall specialix_init_module+0x0/0x436 returned with error code -5 
[   14.966670] calling  isicom_init+0x0/0x223 @ 1
[   14.973374] bus: 'pci': add driver isicom
[   14.978107] initcall isicom_init+0x0/0x223 returned 0 after 3255 usecs
[   14.983346] calling  n_hdlc_init+0x0/0x94 @ 1
[   14.986668] HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
[   14.993336] N_HDLC line discipline registered.
[   15.000003] initcall n_hdlc_init+0x0/0x94 returned 0 after 13020 usecs
[   15.006670] calling  sx_init+0x0/0xeb @ 1
[   15.010018] device: 'sxctl': device_add
[   15.014898] bus: 'pci': add driver sx
[   15.018848] initcall sx_init+0x0/0xeb returned 0 after 6510 usecs
[   15.023337] calling  r3964_init+0x0/0x44 @ 1
[   15.026669] r3964: Philips r3964 Driver $Revision: 1.10 $
[   15.033337] initcall r3964_init+0x0/0x44 returned 0 after 6510 usecs
[   15.040003] calling  i8k_init+0x0/0x371 @ 1
[   15.043339] initcall i8k_init+0x0/0x371 returned -19 after 0 usecs
[   15.050003] calling  tlclk_init+0x0/0x1c8 @ 1
[   15.053344] telclk_interrup = 0xf non-mcpbl0010 hw.
[   15.060013] initcall tlclk_init+0x0/0x1c8 returned -6 after 6510 usecs
[   15.066670] initcall tlclk_init+0x0/0x1c8 returned with error code -6 
[   15.073336] calling  agp_init+0x0/0x26 @ 1
[   15.076668] Linux agpgart interface v0.103
[   15.080002] initcall agp_init+0x0/0x26 returned 0 after 3255 usecs
[   15.086669] calling  agp_intel_init+0x0/0x29 @ 1
[   15.090002] bus: 'pci': add driver agpgart-intel
[   15.097578] initcall agp_intel_init+0x0/0x29 returned 0 after 6510 usecs
[   15.103336] calling  agp_sis_init+0x0/0x29 @ 1
[   15.106670] bus: 'pci': add driver agpgart-sis
[   15.113914] initcall agp_sis_init+0x0/0x29 returned 0 after 6510 usecs
[   15.120004] calling  ipmi_init_msghandler_mod+0x0/0xd @ 1
[   15.123336] bus: 'platform': add driver ipmi
[   15.130586] ipmi message handler version 39.2
[   15.133357] initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 9765 usecs
[   15.140083] calling  init_ipmi_si+0x0/0x5e5 @ 1
[   15.146669] bus: 'platform': add driver ipmi_si
[   15.151850] IPMI System Interface driver.
[   15.153337] bus: 'pci': add driver ipmi_si
[   15.203368] bus: 'pci': remove driver ipmi_si
[   15.208110] driver: 'ipmi_si': driver_release
[   15.210017] bus: 'platform': remove driver ipmi_si
[   15.218245] driver: 'ipmi_si': driver_release
[   15.220007] ipmi_si: Unable to find any System Interface(s)
[   15.226671] initcall init_ipmi_si+0x0/0x5e5 returned -19 after 78125 usecs
[   15.233346] calling  hangcheck_init+0x0/0x8c @ 1
[   15.240002] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   15.246668] Hangcheck: Using get_cycles().
[   15.250006] initcall hangcheck_init+0x0/0x8c returned 0 after 9765 usecs
[   15.256669] calling  drm_core_init+0x0/0xf9 @ 1
[   15.263341] device class 'drm': registering
[   15.268944] [drm] Initialized drm 1.1.0 20060810
[   15.273338] initcall drm_core_init+0x0/0xf9 returned 0 after 9765 usecs
[   15.280003] calling  tdfx_init+0x0/0x12 @ 1
[   15.283389] initcall tdfx_init+0x0/0x12 returned 0 after 0 usecs
[   15.290003] calling  i830_init+0x0/0x1e @ 1
[   15.293370] initcall i830_init+0x0/0x1e returned 0 after 0 usecs
[   15.300003] calling  savage_init+0x0/0x1e @ 1
[   15.303530] initcall savage_init+0x0/0x1e returned 0 after 0 usecs
[   15.310003] calling  via_init+0x0/0x23 @ 1
[   15.313415] initcall via_init+0x0/0x23 returned 0 after 0 usecs
[   15.320003] calling  cn_proc_init+0x0/0x3d @ 1
[   15.323339] initcall cn_proc_init+0x0/0x3d returned 0 after 0 usecs
[   15.330003] calling  serial8250_init+0x0/0x120 @ 1
[   15.336670] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   15.343378] Registering platform device 'serial8250'. Parent at platform
[   15.350001] device: 'serial8250': device_add
[   15.353344] bus: 'platform': add device serial8250
[   15.360303] async_waiting @ 1
[   15.363233] async_continuing @ 1 after 0 usec
[   15.494398] async_waiting @ 1
[   15.496672] async_continuing @ 1 after 0 usec
[   15.627512] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   15.633346] device: 'ttyS0': device_add
[   15.637811] device: 'ttyS1': device_add
[   15.642610] device: 'ttyS2': device_add
[   15.646751] device: 'ttyS3': device_add
[   15.651036] bus: 'platform': add driver serial8250
[   15.653356] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   15.663340] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   15.673343] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   15.680002] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   15.689156] initcall serial8250_init+0x0/0x120 returned 0 after 341796 usecs
[   15.693337] calling  jsm_init_module+0x0/0x48 @ 1
[   15.700067] bus: 'pci': add driver jsm
[   15.705417] initcall jsm_init_module+0x0/0x48 returned 0 after 3255 usecs
[   15.710006] calling  topology_sysfs_init+0x0/0x59 @ 1
[   15.716715] initcall topology_sysfs_init+0x0/0x59 returned 0 after 0 usecs
[   15.723337] calling  brd_init+0x0/0x1a0 @ 1
[   15.727144] device: 'ram0': device_add
[   15.733545] device: '1:0': device_add
[   15.737613] device: 'ram1': device_add
[   15.741718] device: '1:1': device_add
[   15.745714] device: 'ram2': device_add
[   15.751002] device: '1:2': device_add
[   15.755071] device: 'ram3': device_add
[   15.760144] device: '1:3': device_add
[   15.764376] device: 'ram4': device_add
[   15.768774] device: '1:4': device_add
[   15.773358] device: 'ram5': device_add
[   15.777552] device: '1:5': device_add
[   15.781966] device: 'ram6': device_add
[   15.787170] device: '1:6': device_add
[   15.791251] device: 'ram7': device_add
[   15.796054] device: '1:7': device_add
[   15.801003] device: 'ram8': device_add
[   15.805212] device: '1:8': device_add
[   15.810217] device: 'ram9': device_add
[   15.814414] device: '1:9': device_add
[   15.818713] device: 'ram10': device_add
[   15.822881] device: '1:10': device_add
[   15.827517] device: 'ram11': device_add
[   15.831697] device: '1:11': device_add
[   15.836319] device: 'ram12': device_add
[   15.840585] device: '1:12': device_add
[   15.844884] device: 'ram13': device_add
[   15.849796] device: '1:13': device_add
[   15.854091] device: 'ram14': device_add
[   15.858444] device: '1:14': device_add
[   15.863640] device: 'ram15': device_add
[   15.867923] device: '1:15': device_add
[   15.872149] brd: module loaded
[   15.873341] initcall brd_init+0x0/0x1a0 returned 0 after 143229 usecs
[   15.880008] calling  cpqarray_init+0x0/0x299 @ 1
[   15.883335] Compaq SMART2 Driver (v 2.6.0)
[   15.890004] bus: 'pci': add driver cpqarray
[   15.894960] bus: 'pci': remove driver cpqarray
[   15.900656] driver: 'cpqarray': driver_release
[   15.903343] initcall cpqarray_init+0x0/0x299 returned -19 after 19531 usecs
[   15.910002] calling  cciss_init+0x0/0x29 @ 1
[   15.913335] HP CISS Driver (v 3.6.20)
[   15.920002] bus: 'pci': add driver cciss
[   15.924451] initcall cciss_init+0x0/0x29 returned 0 after 9765 usecs
[   15.930004] calling  ub_init+0x0/0x88 @ 1
[   15.933343] bus: 'usb': add driver ub
[   15.938799] usbcore: registered new interface driver ub
[   15.943369] initcall ub_init+0x0/0x88 returned 0 after 9765 usecs
[   15.950006] calling  at24_init+0x0/0x38 @ 1
[   15.953338] bus: 'i2c': add driver at24
[   15.959199] initcall at24_init+0x0/0x38 returned 0 after 3255 usecs
[   15.963339] calling  pasic3_base_init+0x0/0x19 @ 1
[   15.970005] bus: 'platform': add driver pasic3
[   15.975352] bus: 'platform': remove driver pasic3
[   15.980971] driver: 'pasic3': driver_release
[   15.983345] initcall pasic3_base_init+0x0/0x19 returned -19 after 13020 usecs
[   15.990002] calling  da903x_init+0x0/0x14 @ 1
[   15.996670] bus: 'i2c': add driver da903x
[   16.001410] initcall da903x_init+0x0/0x14 returned 0 after 3255 usecs
[   16.006673] calling  pcf50633_init+0x0/0x14 @ 1
[   16.010004] bus: 'i2c': add driver pcf50633
[   16.017368] initcall pcf50633_init+0x0/0x14 returned 0 after 6510 usecs
[   16.023338] calling  e1000_init_module+0x0/0x6b @ 1
[   16.026671] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[   16.033334] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   16.040003] bus: 'pci': add driver e1000e
[   16.045392] initcall e1000_init_module+0x0/0x6b returned 0 after 16276 usecs
[   16.050006] calling  ipg_init_module+0x0/0x1b @ 1
[   16.056671] bus: 'pci': add driver Sundance Technology IPG Triple-Speed Ethernet
[   16.065055] initcall ipg_init_module+0x0/0x1b returned 0 after 6510 usecs
[   16.070005] calling  t1_init_module+0x0/0x1b @ 1
[   16.073338] bus: 'pci': add driver cxgb
[   16.080988] initcall t1_init_module+0x0/0x1b returned 0 after 6510 usecs
[   16.086672] calling  cxgb3_init_module+0x0/0x20 @ 1
[   16.090005] bus: 'pci': add driver cxgb3
[   16.097471] initcall cxgb3_init_module+0x0/0x20 returned 0 after 6510 usecs
[   16.103338] calling  bonding_init+0x0/0x8c6 @ 1
[   16.106671] Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)
[   16.113336] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[   16.132963] device: 'bond0': device_add
[   16.138029] initcall bonding_init+0x0/0x8c6 returned 0 after 29296 usecs
[   16.143341] calling  atl1c_init_module+0x0/0x1b @ 1
[   16.146672] bus: 'pci': add driver atl1c
[   16.154114] initcall atl1c_init_module+0x0/0x1b returned 0 after 6510 usecs
[   16.160005] calling  bdx_module_init+0x0/0x9e @ 1
[   16.163353] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[   16.170001] tehuti: Options: hw_csum 
[   16.173336] bus: 'pci': add driver tehuti
[   16.180078] initcall bdx_module_init+0x0/0x9e returned 0 after 16276 usecs
[   16.186673] calling  jme_init_module+0x0/0x30 @ 1
[   16.190001] jme: JMicron JMC250 gigabit ethernet driver version 1.0.3
[   16.196669] bus: 'pci': add driver jme
[   16.202261] initcall jme_init_module+0x0/0x30 returned 0 after 9765 usecs
[   16.206672] calling  rr_init_module+0x0/0x1b @ 1
[   16.213337] bus: 'pci': add driver rrunner
[   16.218669] initcall rr_init_module+0x0/0x1b returned 0 after 3255 usecs
[   16.223338] calling  gem_init+0x0/0x1b @ 1
[   16.226672] bus: 'pci': add driver gem
[   16.233900] initcall gem_init+0x0/0x1b returned 0 after 6510 usecs
[   16.240005] calling  cas_init+0x0/0x3d @ 1
[   16.243338] bus: 'pci': add driver cassini
[   16.248572] initcall cas_init+0x0/0x3d returned 0 after 3255 usecs
[   16.253339] calling  vortex_init+0x0/0xad @ 1
[   16.256671] bus: 'pci': add driver 3c59x
[   16.264111] initcall vortex_init+0x0/0xad returned 0 after 6510 usecs
[   16.270005] calling  pcnet32_init_module+0x0/0x130 @ 1
[   16.273337] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   16.280002] bus: 'pci': add driver pcnet32
[   16.286819] initcall pcnet32_init_module+0x0/0x130 returned 0 after 13020 usecs
[   16.293340] calling  e100_init_module+0x0/0x5d @ 1
[   16.296668] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[   16.303335] e100: Copyright(c) 1999-2006 Intel Corporation
[   16.310002] bus: 'pci': add driver e100
[   16.314751] initcall e100_init_module+0x0/0x5d returned 0 after 16276 usecs
[   16.320005] calling  sis900_init_module+0x0/0x1b @ 1
[   16.326671] bus: 'pci': add driver sis900
[   16.331784] initcall sis900_init_module+0x0/0x1b returned 0 after 3255 usecs
[   16.336672] calling  ns83820_init+0x0/0x29 @ 1
[   16.343337] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   16.350003] bus: 'pci': add driver ns83820
[   16.354843] initcall ns83820_init+0x0/0x29 returned 0 after 9765 usecs
[   16.360005] calling  tg3_init+0x0/0x1b @ 1
[   16.363337] bus: 'pci': add driver tg3
[   16.370134] initcall tg3_init+0x0/0x1b returned 0 after 6510 usecs
[   16.373339] calling  sky2_init_module+0x0/0x29 @ 1
[   16.380002] sky2 driver version 1.22
[   16.383335] bus: 'pci': add driver sky2
[   16.388935] initcall sky2_init_module+0x0/0x29 returned 0 after 6510 usecs
[   16.393339] calling  rhine_init+0x0/0x63 @ 1
[   16.400005] bus: 'pci': add driver via-rhine
[   16.404663] initcall rhine_init+0x0/0x63 returned 0 after 3255 usecs
[   16.410005] calling  velocity_init_module+0x0/0x1b @ 1
[   16.416672] bus: 'pci': add driver via-velocity
[   16.421492] initcall velocity_init_module+0x0/0x1b returned 0 after 3255 usecs
[   16.426672] calling  davicom_init+0x0/0x5d @ 1
[   16.433337] bus: 'mdio_bus': add driver Davicom DM9161E
[   16.439201] bus: 'mdio_bus': add driver Davicom DM9161A
[   16.444680] bus: 'mdio_bus': add driver Davicom DM9131
[   16.450679] initcall davicom_init+0x0/0x5d returned 0 after 16276 usecs
[   16.456671] calling  lxt_init+0x0/0x3f @ 1
[   16.460004] bus: 'mdio_bus': add driver LXT970
[   16.466086] bus: 'mdio_bus': add driver LXT971
[   16.470981] initcall lxt_init+0x0/0x3f returned 0 after 9765 usecs
[   16.476672] calling  smsc_init+0x0/0x7b @ 1
[   16.480003] bus: 'mdio_bus': add driver SMSC LAN83C185
[   16.487155] bus: 'mdio_bus': add driver SMSC LAN8187
[   16.492538] bus: 'mdio_bus': add driver SMSC LAN8700
[   16.498032] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[   16.505232] initcall smsc_init+0x0/0x7b returned 0 after 22786 usecs
[   16.510006] calling  realtek_init+0x0/0x12 @ 1
[   16.516670] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
[   16.522995] initcall realtek_init+0x0/0x12 returned 0 after 3255 usecs
[   16.526672] calling  fixed_mdio_bus_init+0x0/0xd0 @ 1
[   16.533343] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   16.540006] device: 'Fixed MDIO bus.0': device_add
[   16.543346] bus: 'platform': add device Fixed MDIO bus.0
[   16.552181] device: '0': device_add
[   16.556718] Fixed MDIO Bus: probed
[   16.560006] initcall fixed_mdio_bus_init+0x0/0xd0 returned 0 after 26041 usecs
[   16.566670] calling  ns_init+0x0/0x12 @ 1
[   16.570003] bus: 'mdio_bus': add driver NatSemi DP83865
[   16.577117] initcall ns_init+0x0/0x12 returned 0 after 6510 usecs
[   16.580007] calling  sundance_init+0x0/0x1b @ 1
[   16.586670] bus: 'pci': add driver sundance
[   16.592222] initcall sundance_init+0x0/0x1b returned 0 after 3255 usecs
[   16.596671] calling  net_olddevs_init+0x0/0x9e @ 1
[   16.603342] initcall net_olddevs_init+0x0/0x9e returned 0 after 0 usecs
[   16.610002] calling  hp100_module_init+0x0/0x1b @ 1
[   16.613336] bus: 'pci': add driver hp100
[   16.619506] initcall hp100_module_init+0x0/0x1b returned 0 after 6510 usecs
[   16.626672] calling  b44_init+0x0/0x63 @ 1
[   16.630087] bus: 'pci': add driver b44
[   16.635258] bus: 'ssb': add driver b44
[   16.640211] initcall b44_init+0x0/0x63 returned 0 after 9765 usecs
[   16.643340] calling  init_nic+0x0/0x1b @ 1
[   16.650015] bus: 'pci': add driver forcedeth
[   16.653350] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
[   16.663336] bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
[   16.670012] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.62.
[   16.676688] forcedeth 0000:00:0a.0: setting latency timer to 64
[   16.683421] nv_probe: set workaround bit for reversed mac addr
[   17.206852] device: 'eth0': device_add
[   17.211364] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   17.216673] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[   17.226669] driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
[   17.233337] bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
[   17.241854] initcall init_nic+0x0/0x1b returned 0 after 576171 usecs
[   17.246674] calling  slip_init+0x0/0xb2 @ 1
[   17.250003] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[   17.260002] SLIP linefill/keepalive option.
[   17.263345] initcall slip_init+0x0/0xb2 returned 0 after 13020 usecs
[   17.270003] calling  macvlan_init_module+0x0/0x53 @ 1
[   17.276672] initcall macvlan_init_module+0x0/0x53 returned 0 after 0 usecs
[   17.283337] calling  rtl8139_init_module+0x0/0x1b @ 1
[   17.286670] bus: 'pci': add driver 8139too
[   17.293357] bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139too
[   17.300002] bus: 'pci': really_probe: probing driver 8139too with device 0000:05:07.0
[   17.306678] 8139too Fast Ethernet driver 0.9.28
[   17.313600] device: 'eth1': device_add
[   17.318938] eth1: RealTek RTL8139 at 0xffffc20000004000, 00:c0:df:03:68:5d, IRQ 11
[   17.323338] eth1:  Identified 8139 chip type 'RTL-8139B'
[   17.330003] driver: '0000:05:07.0': driver_bound: bound to device '8139too'
[   17.336670] bus: 'pci': really_probe: bound device 0000:05:07.0 to driver 8139too
[   17.346589] initcall rtl8139_init_module+0x0/0x1b returned 0 after 58593 usecs
[   17.353340] calling  rio_init+0x0/0x1b @ 1
[   17.356669] bus: 'pci': add driver dl2k
[   17.362126] initcall rio_init+0x0/0x1b returned 0 after 3255 usecs
[   17.366675] calling  myri10ge_init_module+0x0/0x74 @ 1
[   17.373335] myri10ge: Version 1.4.4-1.401
[   17.376670] bus: 'pci': add driver myri10ge
[   17.381931] initcall myri10ge_init_module+0x0/0x74 returned 0 after 6510 usecs
[   17.386673] calling  enc28j60_init+0x0/0x23 @ 1
[   17.393336] bus: 'spi': add driver enc28j60
[   17.398118] initcall enc28j60_init+0x0/0x23 returned 0 after 3255 usecs
[   17.403338] calling  catc_init+0x0/0x38 @ 1
[   17.406671] bus: 'usb': add driver catc
[   17.413010] usbcore: registered new interface driver catc
[   17.416675] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   17.423336] initcall catc_init+0x0/0x38 returned 0 after 16276 usecs
[   17.430003] calling  usb_irda_init+0x0/0x3e @ 1
[   17.433335] bus: 'usb': add driver irda-usb
[   17.439989] usbcore: registered new interface driver irda-usb
[   17.443341] USB IrDA support registered
[   17.446669] initcall usb_irda_init+0x0/0x3e returned 0 after 13020 usecs
[   17.453338] calling  stir_init+0x0/0x1b @ 1
[   17.460002] bus: 'usb': add driver stir4200
[   17.464911] usbcore: registered new interface driver stir4200
[   17.470008] initcall stir_init+0x0/0x1b returned 0 after 9765 usecs
[   17.476670] calling  ali_ircc_init+0x0/0x7ea @ 1
[   17.480003] bus: 'platform': add driver ali-ircc
[   17.486415] bus: 'platform': remove driver ali-ircc
[   17.491590] driver: 'ali-ircc': driver_release
[   17.493341] initcall ali_ircc_init+0x0/0x7ea returned -19 after 13020 usecs
[   17.500003] calling  via_ircc_init+0x0/0x21 @ 1
[   17.506669] bus: 'pci': add driver via-ircc
[   17.511987] initcall via_ircc_init+0x0/0x21 returned 0 after 3255 usecs
[   17.516672] calling  init_netconsole+0x0/0x1e5 @ 1
[   17.523338] console [netcon0] enabled
[   17.526669] netconsole: network logging started
[   17.530003] initcall init_netconsole+0x0/0x1e5 returned 0 after 6510 usecs
[   17.536670] calling  niu_init+0x0/0x40 @ 1
[   17.540002] bus: 'pci': add driver niu
[   17.546723] initcall niu_init+0x0/0x40 returned 0 after 6510 usecs
[   17.550006] calling  he_init+0x0/0x1b @ 1
[   17.556670] bus: 'pci': add driver he
[   17.560865] initcall he_init+0x0/0x1b returned 0 after 3255 usecs
[   17.566672] calling  mac_hid_init+0x0/0xd5 @ 1
[   17.570023] device: 'input0': device_add
[   17.575680] input: Macintosh mouse button emulation as /class/input/input0
[   17.580015] initcall mac_hid_init+0x0/0xd5 returned 0 after 9765 usecs
[   17.586669] calling  raid_init+0x0/0x12 @ 1
[   17.590003] device class 'raid_devices': registering
[   17.598516] initcall raid_init+0x0/0x12 returned 0 after 6510 usecs
[   17.603340] calling  spi_transport_init+0x0/0x2e @ 1
[   17.606668] device class 'spi_transport': registering
[   17.615057] device class 'spi_host': registering
[   17.619931] initcall spi_transport_init+0x0/0x2e returned 0 after 9765 usecs
[   17.626673] calling  fc_transport_init+0x0/0x4c @ 1
[   17.630001] device class 'fc_host': registering
[   17.636636] device class 'fc_vports': registering
[   17.641698] device class 'fc_remote_ports': registering
[   17.647808] device class 'fc_transport': registering
[   17.653104] initcall fc_transport_init+0x0/0x4c returned 0 after 19531 usecs
[   17.660006] calling  sas_transport_init+0x0/0xbb @ 1
[   17.663335] device class 'sas_host': registering
[   17.670802] device class 'sas_phy': registering
[   17.675586] device class 'sas_port': registering
[   17.680458] device class 'sas_device': registering
[   17.685516] device class 'sas_end_device': registering
[   17.690909] device class 'sas_expander': registering
[   17.696217] initcall sas_transport_init+0x0/0xbb returned 0 after 29296 usecs
[   17.703340] calling  scsi_dh_init+0x0/0x3f @ 1
[   17.706671] initcall scsi_dh_init+0x0/0x3f returned 0 after 0 usecs
[   17.713337] calling  hp_sw_init+0x0/0x12 @ 1
[   17.716682] hp_sw: device handler registered
[   17.720003] initcall hp_sw_init+0x0/0x12 returned 0 after 3255 usecs
[   17.726670] calling  libfc_init+0x0/0x77 @ 1
[   17.734466] initcall libfc_init+0x0/0x77 returned 0 after 3255 usecs
[   17.740006] calling  fcoe_init+0x0/0x185 @ 1
[   17.745653] fcoe_transport_register:fcoesw
[   17.746672] initcall fcoe_init+0x0/0x185 returned 0 after 3255 usecs
[   17.753337] calling  ahc_linux_init+0x0/0x59 @ 1
[   17.760010] bus: 'pci': add driver aic7xxx
[   17.765226] initcall ahc_linux_init+0x0/0x59 returned 0 after 3255 usecs
[   17.770007] calling  ahd_linux_init+0x0/0x74 @ 1
[   17.773343] bus: 'pci': add driver aic79xx
[   17.780954] initcall ahd_linux_init+0x0/0x74 returned 0 after 6510 usecs
[   17.786671] calling  aac_init+0x0/0x70 @ 1
[   17.790002] Adaptec aacraid driver 1.1-5[2456]-ms
[   17.793336] bus: 'pci': add driver aacraid
[   17.800961] initcall aac_init+0x0/0x70 returned 0 after 9765 usecs
[   17.806670] calling  qla1280_init+0x0/0x1b @ 1
[   17.810003] bus: 'pci': add driver qla1280
[   17.815959] initcall qla1280_init+0x0/0x1b returned 0 after 3255 usecs
[   17.820004] calling  dmx3191d_init+0x0/0x1b @ 1
[   17.826669] bus: 'pci': add driver dmx3191d
[   17.831481] initcall dmx3191d_init+0x0/0x1b returned 0 after 3255 usecs
[   17.836670] calling  init_this_scsi_driver+0x0/0xe8 @ 1
[   17.843347] initcall init_this_scsi_driver+0x0/0xe8 returned -19 after 0 usecs
[   17.850002] calling  dc390_module_init+0x0/0x9a @ 1
[   17.853335] DC390: clustering now enabled by default. If you get problems load
[   17.860002]        with "disable_clustering=1" and report to maintainers
[   17.866670] bus: 'pci': add driver tmscsim
[   17.873737] initcall dc390_module_init+0x0/0x9a returned 0 after 19531 usecs
[   17.880004] calling  megaraid_init+0x0/0xb5 @ 1
[   17.883357] bus: 'pci': add driver megaraid_legacy
[   17.891122] initcall megaraid_init+0x0/0xb5 returned 0 after 6510 usecs
[   17.896670] calling  mraid_mm_init+0x0/0x83 @ 1
[   17.900002] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   17.906676] device: 'megadev0': device_add
[   17.914363] initcall mraid_mm_init+0x0/0x83 returned 0 after 13020 usecs
[   17.920003] calling  megasas_init+0x0/0x15c @ 1
[   17.923336] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[   17.930012] bus: 'pci': add driver megaraid_sas
[   17.936244] initcall megasas_init+0x0/0x15c returned 0 after 9765 usecs
[   17.940003] calling  initio_init_driver+0x0/0x1b @ 1
[   17.946670] bus: 'pci': add driver initio
[   17.952124] initcall initio_init_driver+0x0/0x1b returned 0 after 3255 usecs
[   17.956671] calling  hptiop_module_init+0x0/0x37 @ 1
[   17.963336] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[   17.970003] bus: 'pci': add driver hptiop
[   17.974425] initcall hptiop_module_init+0x0/0x37 returned 0 after 9765 usecs
[   17.980004] calling  stex_init+0x0/0x30 @ 1
[   17.983335] stex: Promise SuperTrak EX Driver version: 3.6.0000.1
[   17.990003] bus: 'pci': add driver stex
[   17.995858] initcall stex_init+0x0/0x30 returned 0 after 9765 usecs
[   18.000004] calling  init_st+0x0/0x1a7 @ 1
[   18.003335] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[   18.010003] device class 'scsi_tape': registering
[   18.017632] Driver 'st' needs updating - please use bus_type methods
[   18.023337] bus: 'scsi': add driver st
[   18.027983] initcall init_st+0x0/0x1a7 returned 0 after 22786 usecs
[   18.033338] calling  init_sd+0x0/0xed @ 1
[   18.036700] device class 'scsi_disk': registering
[   18.043257] Driver 'sd' needs updating - please use bus_type methods
[   18.046670] bus: 'scsi': add driver sd
[   18.054737] initcall init_sd+0x0/0xed returned 0 after 16276 usecs
[   18.060004] calling  init_sr+0x0/0x49 @ 1
[   18.063337] Driver 'sr' needs updating - please use bus_type methods
[   18.070002] bus: 'scsi': add driver sr
[   18.075294] initcall init_sr+0x0/0x49 returned 0 after 9765 usecs
[   18.080004] calling  ahci_init+0x0/0x1b @ 1
[   18.083337] bus: 'pci': add driver ahci
[   18.089840] initcall ahci_init+0x0/0x1b returned 0 after 3255 usecs
[   18.093338] calling  piix_init+0x0/0x29 @ 1
[   18.100082] bus: 'pci': add driver ata_piix
[   18.104872] initcall piix_init+0x0/0x29 returned 0 after 3255 usecs
[   18.110003] calling  sil_init+0x0/0x1b @ 1
[   18.113337] bus: 'pci': add driver sata_sil
[   18.119726] initcall sil_init+0x0/0x1b returned 0 after 3255 usecs
[   18.123338] calling  sil24_init+0x0/0x1b @ 1
[   18.130010] bus: 'pci': add driver sata_sil24
[   18.134814] initcall sil24_init+0x0/0x1b returned 0 after 3255 usecs
[   18.140004] calling  svia_init+0x0/0x1b @ 1
[   18.143337] bus: 'pci': add driver sata_via
[   18.149806] initcall svia_init+0x0/0x1b returned 0 after 3255 usecs
[   18.153338] calling  sis_init+0x0/0x1b @ 1
[   18.160004] bus: 'pci': add driver sata_sis
[   18.164632] initcall sis_init+0x0/0x1b returned 0 after 3255 usecs
[   18.170003] calling  nv_init+0x0/0x1b @ 1
[   18.173337] bus: 'pci': add driver sata_nv
[   18.179212] initcall nv_init+0x0/0x1b returned 0 after 3255 usecs
[   18.183338] calling  uli_init+0x0/0x1b @ 1
[   18.186670] bus: 'pci': add driver sata_uli
[   18.193952] initcall uli_init+0x0/0x1b returned 0 after 6510 usecs
[   18.200003] calling  adma_ata_init+0x0/0x1b @ 1
[   18.203337] bus: 'pci': add driver pdc_adma
[   18.209127] initcall adma_ata_init+0x0/0x1b returned 0 after 3255 usecs
[   18.213338] calling  ali_init+0x0/0x4e @ 1
[   18.216680] bus: 'pci': add driver pata_ali
[   18.224318] initcall ali_init+0x0/0x4e returned 0 after 6510 usecs
[   18.230003] calling  amd_init+0x0/0x1b @ 1
[   18.233337] bus: 'pci': add driver pata_amd
[   18.236682] bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
[   18.246669] bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
[   18.253344] pata_amd 0000:00:06.0: version 0.4.1
[   18.256758] pata_amd 0000:00:06.0: setting latency timer to 64
[   18.266071] scsi0 : pata_amd
[   18.269773] device: 'host0': device_add
[   18.273346] device: 'host0': device_add
[   18.277961] scsi1 : pata_amd
[   18.280006] device: 'host1': device_add
[   18.283343] device: 'host1': device_add
[   18.288845] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   18.293336] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   18.467500] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[   18.470006] ata1.00: 488397168 sectors, multi 1: LBA48 
[   18.473359] ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[   18.497923] ata1.00: configured for UDMA/100
[   18.500008] async_waiting @ 1
[   18.503340] async_continuing @ 1 after 0 usec
[   18.506794] isa bounce pool size: 16 pages
[   18.513607] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[   18.520005] device: 'target0:0:0': device_add
[   18.523348] device: '0:0:0:0': device_add
[   18.530055] bus: 'scsi': add device 0:0:0:0
[   18.535130] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver st
[   18.540003] bus: 'scsi': really_probe: probing driver st with device 0:0:0:0
[   18.550025] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[   18.556668] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[   18.563434] device: '0:0:0:0': device_add
[   18.569185] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[   18.576721] sd 0:0:0:0: [sda] Write Protect is off
[   18.580004] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   18.586764] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.593340] device: 'sda': device_add
[   18.596909] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[   18.606719] sd 0:0:0:0: [sda] Write Protect is off
[   18.610002] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   18.616763] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.626674]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   18.730657] device: 'sda1': device_add
[   18.733414] device: 'sda2': device_add
[   18.736734] device: 'sda3': device_add
[   18.740068] device: 'sda5': device_add
[   18.743399] device: 'sda6': device_add
[   18.746726] device: 'sda7': device_add
[   18.753399] device: 'sda8': device_add
[   18.756733] device: 'sda9': device_add
[   18.760057] device: 'sda10': device_add
[   18.767790] device: '8:0': device_add
[   18.771833] sd 0:0:0:0: [sda] Attached SCSI disk
[   18.773337] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[   18.780049] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[   18.786671] device: '0:0:0:0': device_add
[   18.793592] device: '0:0:0:0': device_add
[   18.798345] async_waiting @ 1
[   18.800003] async_continuing @ 1 after 0 usec
[   18.960289] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[   18.963354] ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[   18.980199] ata2.01: configured for UDMA/33
[   18.983408] async_waiting @ 1
[   18.986671] async_continuing @ 1 after 0 usec
[   18.990402] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   19.000009] device: 'target1:0:1': device_add
[   19.003346] device: '1:0:1:0': device_add
[   19.006714] bus: 'scsi': add device 1:0:1:0
[   19.013752] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver st
[   19.020002] bus: 'scsi': really_probe: probing driver st with device 1:0:1:0
[   19.026694] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
[   19.033335] bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
[   19.040023] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sr
[   19.050003] bus: 'scsi': really_probe: probing driver sr with device 1:0:1:0
[   19.061672] sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
[   19.066672] Uniform CD-ROM driver Revision: 3.20
[   19.070032] device: 'sr0': device_add
[   19.077158] device: '11:0': device_add
[   19.081240] sr 1:0:1:0: Attached scsi CD-ROM sr0
[   19.083335] driver: '1:0:1:0': driver_bound: bound to device 'sr'
[   19.090005] bus: 'scsi': really_probe: bound device 1:0:1:0 to driver sr
[   19.096670] device: '1:0:1:0': device_add
[   19.102967] device: '1:0:1:0': device_add
[   19.107290] driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
[   19.113338] bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
[   19.122187] initcall amd_init+0x0/0x1b returned 0 after 865885 usecs
[   19.126672] calling  atiixp_init+0x0/0x1b @ 1
[   19.130008] bus: 'pci': add driver pata_atiixp
[   19.137629] initcall atiixp_init+0x0/0x1b returned 0 after 6510 usecs
[   19.143337] calling  cy82c693_init+0x0/0x1b @ 1
[   19.146670] bus: 'pci': add driver pata_cypress
[   19.153422] initcall cy82c693_init+0x0/0x1b returned 0 after 6510 usecs
[   19.160004] calling  it821x_init+0x0/0x1b @ 1
[   19.163336] bus: 'pci': add driver pata_it821x
[   19.169127] initcall it821x_init+0x0/0x1b returned 0 after 3255 usecs
[   19.173338] calling  ninja32_init+0x0/0x1b @ 1
[   19.180003] bus: 'pci': add driver pata_ninja32
[   19.184829] initcall ninja32_init+0x0/0x1b returned 0 after 3255 usecs
[   19.190003] calling  ns87410_init+0x0/0x1b @ 1
[   19.193337] bus: 'pci': add driver pata_ns87410
[   19.200601] initcall ns87410_init+0x0/0x1b returned 0 after 6510 usecs
[   19.206671] calling  opti_init+0x0/0x1b @ 1
[   19.210003] bus: 'pci': add driver pata_opti
[   19.215852] initcall opti_init+0x0/0x1b returned 0 after 3255 usecs
[   19.220004] calling  optidma_init+0x0/0x1b @ 1
[   19.223336] bus: 'pci': add driver pata_optidma
[   19.231372] initcall optidma_init+0x0/0x1b returned 0 after 6510 usecs
[   19.236670] calling  oldpiix_init+0x0/0x1b @ 1
[   19.240004] bus: 'pci': add driver pata_oldpiix
[   19.247157] initcall oldpiix_init+0x0/0x1b returned 0 after 6510 usecs
[   19.253338] calling  sis_init+0x0/0x1b @ 1
[   19.256670] bus: 'pci': add driver pata_sis
[   19.262243] initcall sis_init+0x0/0x1b returned 0 after 3255 usecs
[   19.266672] calling  triflex_init+0x0/0x1b @ 1
[   19.270003] bus: 'pci': add driver pata_triflex
[   19.277670] initcall triflex_init+0x0/0x1b returned 0 after 6510 usecs
[   19.283337] calling  fusion_init+0x0/0x13f @ 1
[   19.286669] Fusion MPT base driver 3.04.07
[   19.290001] Copyright (c) 1999-2008 LSI Corporation
[   19.296701] initcall fusion_init+0x0/0x13f returned 0 after 9765 usecs
[   19.303336] calling  mptspi_init+0x0/0xde @ 1
[   19.306669] Fusion MPT SPI Host driver 3.04.07
[   19.310007] bus: 'pci': add driver mptspi
[   19.317273] initcall mptspi_init+0x0/0xde returned 0 after 9765 usecs
[   19.323337] calling  mptfc_init+0x0/0xf1 @ 1
[   19.326669] Fusion MPT FC Host driver 3.04.07
[   19.330027] bus: 'pci': add driver mptfc
[   19.336562] initcall mptfc_init+0x0/0xf1 returned 0 after 6510 usecs
[   19.340004] calling  mptsas_init+0x0/0xf5 @ 1
[   19.346668] Fusion MPT SAS Host driver 3.04.07
[   19.350027] bus: 'pci': add driver mptsas
[   19.356030] initcall mptsas_init+0x0/0xf5 returned 0 after 6510 usecs
[   19.360005] calling  pcilynx_init+0x0/0x3c @ 1
[   19.366671] bus: 'pci': add driver pcilynx
[   19.371307] initcall pcilynx_init+0x0/0x3c returned 0 after 3255 usecs
[   19.376670] calling  ohci1394_init+0x0/0x1b @ 1
[   19.380004] bus: 'pci': add driver ohci1394
[   19.386855] initcall ohci1394_init+0x0/0x1b returned 0 after 6510 usecs
[   19.393340] calling  sbp2_module_init+0x0/0x79 @ 1
[   19.396672] bus: 'ieee1394': add driver sbp2
[   19.402847] initcall sbp2_module_init+0x0/0x79 returned 0 after 3255 usecs
[   19.406671] calling  ether1394_init_module+0x0/0x70 @ 1
[   19.415389] bus: 'ieee1394': add driver eth1394
[   19.420303] initcall ether1394_init_module+0x0/0x70 returned 0 after 6510 usecs
[   19.426671] calling  cdrom_init+0x0/0x6a @ 1
[   19.430008] initcall cdrom_init+0x0/0x6a returned 0 after 0 usecs
[   19.436670] calling  spidev_init+0x0/0x99 @ 1
[   19.440009] device class 'spidev': registering
[   19.447068] bus: 'spi': add driver spidev
[   19.451335] initcall spidev_init+0x0/0x99 returned 0 after 9765 usecs
[   19.456746] calling  aoe_init+0x0/0xac @ 1
[   19.460008] device class 'aoe': registering
[   19.466404] device: 'err': device_add
[   19.470364] device: 'discover': device_add
[   19.474757] device: 'interfaces': device_add
[   19.479294] device: 'revalidate': device_add
[   19.483833] device: 'flush': device_add
[   19.488381] aoe: AoE v47 initialised.
[   19.490131] initcall aoe_init+0x0/0xac returned 0 after 29296 usecs
[   19.496673] calling  uwb_subsys_init+0x0/0x51 @ 1
[   19.500015] device class 'uwb_rc': registering
[   19.507863] initcall uwb_subsys_init+0x0/0x51 returned 0 after 6510 usecs
[   19.513337] calling  hwarc_driver_init+0x0/0x1b @ 1
[   19.516671] bus: 'usb': add driver hwa-rc
[   19.523827] usbcore: registered new interface driver hwa-rc
[   19.526675] initcall hwarc_driver_init+0x0/0x1b returned 0 after 9765 usecs
[   19.533336] calling  i1480_dfu_driver_init+0x0/0x1b @ 1
[   19.540003] bus: 'usb': add driver i1480-dfu-usb
[   19.546465] usbcore: registered new interface driver i1480-dfu-usb
[   19.550008] initcall i1480_dfu_driver_init+0x0/0x1b returned 0 after 9765 usecs
[   19.556670] calling  i1480_est_init+0x0/0x86 @ 1
[   19.563341] initcall i1480_est_init+0x0/0x86 returned 0 after 0 usecs
[   19.570004] calling  ehci_hcd_init+0x0/0xe3 @ 1
[   19.573336] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   19.580002] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[   19.586685] bus: 'pci': add driver ehci_hcd
[   19.590020] bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
[   19.600003] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
[   19.606687] ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
[   19.616670] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[   19.623337] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[   19.631397] initcall ehci_hcd_init+0x0/0xe3 returned 0 after 55338 usecs
[   19.636670] calling  isp116x_init+0x0/0x40 @ 1
[   19.640002] 116x: driver isp116x-hcd, 03 Nov 2005
[   19.646669] bus: 'platform': add driver isp116x-hcd
[   19.652385] initcall isp116x_init+0x0/0x40 returned 0 after 9765 usecs
[   19.656670] calling  ohci_hcd_mod_init+0x0/0xd6 @ 1
[   19.663336] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   19.666668] ohci_hcd: block sizes: ed 80 td 96
[   19.673349] bus: 'pci': add driver ohci_hcd
[   19.676689] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
[   19.686670] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
[   19.693354] ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[   19.700003] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[   19.710010] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[   19.717708] bus: 'ssb': add driver ohci_hcd
[   19.722145] initcall ohci_hcd_mod_init+0x0/0xd6 returned 0 after 55338 usecs
[   19.726670] calling  uhci_hcd_init+0x0/0x104 @ 1
[   19.733336] uhci_hcd: USB Universal Host Controller Interface driver
[   19.740564] bus: 'pci': add driver uhci_hcd
[   19.745028] initcall uhci_hcd_init+0x0/0x104 returned 0 after 9765 usecs
[   19.750003] calling  sl811h_init+0x0/0x40 @ 1
[   19.753336] sl811: driver sl811-hcd, 19 May 2005
[   19.760002] bus: 'platform': add driver sl811-hcd
[   19.765683] initcall sl811h_init+0x0/0x40 returned 0 after 9765 usecs
[   19.770004] calling  u132_hcd_init+0x0/0xb1 @ 1
[   19.776671] driver u132_hcd built at 14:10:27 on Mar 19 2009
[   19.782456] bus: 'platform': add driver u132_hcd
[   19.787320] initcall u132_hcd_init+0x0/0xb1 returned 0 after 9765 usecs
[   19.793336] calling  r8a66597_init+0x0/0x40 @ 1
[   19.796669] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
[   19.803335] bus: 'platform': add driver r8a66597_hcd
[   19.809173] initcall r8a66597_init+0x0/0x40 returned 0 after 9765 usecs
[   19.813337] calling  hwahc_driver_init+0x0/0x1b @ 1
[   19.820004] bus: 'usb': add driver hwa-hc
[   19.824931] usbcore: registered new interface driver hwa-hc
[   19.830008] initcall hwahc_driver_init+0x0/0x1b returned 0 after 9765 usecs
[   19.836669] calling  c67x00_init+0x0/0x12 @ 1
[   19.840003] bus: 'platform': add driver c67x00
[   19.846528] initcall c67x00_init+0x0/0x12 returned 0 after 3255 usecs
[   19.850005] calling  wusbcore_init+0x0/0x73 @ 1
[   19.857627] initcall wusbcore_init+0x0/0x73 returned 0 after 0 usecs
[   19.863338] calling  usb_stor_init+0x0/0x51 @ 1
[   19.866668] Initializing USB Mass Storage driver...
[   19.873336] bus: 'usb': add driver usb-storage
[   19.878103] usbcore: registered new interface driver usb-storage
[   19.883339] USB Mass Storage support registered.
[   19.886671] initcall usb_stor_init+0x0/0x51 returned 0 after 19531 usecs
[   19.893337] calling  usb_usual_init+0x0/0x40 @ 1
[   19.900023] bus: 'usb': add driver libusual
[   19.904523] usbcore: registered new interface driver libusual
[   19.910007] initcall usb_usual_init+0x0/0x40 returned 0 after 9765 usecs
[   19.916670] calling  usb_serial_init+0x0/0x238 @ 1
[   19.922011] bus: 'usb-serial': registered
[   19.923371] bus: 'usb': add driver usbserial
[   19.930620] usbcore: registered new interface driver usbserial
[   19.933337] bus: 'usb-serial': add driver generic
[   19.941421] USB Serial support registered for generic
[   19.943337] bus: 'usb': add driver usbserial_generic
[   19.951699] usbcore: registered new interface driver usbserial_generic
[   19.956669] usbserial: USB Serial Driver core
[   19.960004] initcall usb_serial_init+0x0/0x238 returned 0 after 39062 usecs
[   19.966669] calling  ch341_init+0x0/0x48 @ 1
[   19.973336] bus: 'usb-serial': add driver ch341-uart
[   19.979045] USB Serial support registered for ch341-uart
[   19.983337] bus: 'usb': add driver ch341
[   19.988559] usbcore: registered new interface driver ch341
[   19.993339] initcall ch341_init+0x0/0x48 returned 0 after 19531 usecs
[   20.000003] calling  cyberjack_init+0x0/0x66 @ 1
[   20.003336] bus: 'usb-serial': add driver cyberjack
[   20.010249] USB Serial support registered for Reiner SCT Cyberjack USB card reader
[   20.016670] bus: 'usb': add driver cyberjack
[   20.022360] usbcore: registered new interface driver cyberjack
[   20.026670] cyberjack: v1.01 Matthias Bruestle
[   20.030001] cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
[   20.040004] initcall cyberjack_init+0x0/0x66 returned 0 after 35807 usecs
[   20.046669] calling  funsoft_init+0x0/0x48 @ 1
[   20.050003] bus: 'usb-serial': add driver funsoft
[   20.056488] USB Serial support registered for funsoft
[   20.060004] bus: 'usb': add driver funsoft
[   20.065902] usbcore: registered new interface driver funsoft
[   20.070005] initcall funsoft_init+0x0/0x48 returned 0 after 19531 usecs
[   20.076671] calling  ipaq_init+0x0/0x94 @ 1
[   20.080003] bus: 'usb-serial': add driver ipaq
[   20.087059] USB Serial support registered for PocketPC PDA
[   20.090004] bus: 'usb': add driver ipaq
[   20.096697] usbcore: registered new interface driver ipaq
[   20.100003] ipaq: v0.5:USB PocketPC PDA driver
[   20.103336] initcall ipaq_init+0x0/0x94 returned 0 after 22786 usecs
[   20.110004] calling  iuu_init+0x0/0x58 @ 1
[   20.116669] bus: 'usb-serial': add driver iuu_phoenix
[   20.122297] USB Serial support registered for iuu_phoenix
[   20.126670] bus: 'usb': add driver iuu_phoenix
[   20.132410] usbcore: registered new interface driver iuu_phoenix
[   20.136669] iuu_phoenix: v0.5:Infinity USB Unlimited Phoenix driver
[   20.143338] initcall iuu_init+0x0/0x58 returned 0 after 26041 usecs
[   20.150003] calling  moto_init+0x0/0x48 @ 1
[   20.153336] bus: 'usb-serial': add driver moto-modem
[   20.160359] USB Serial support registered for moto-modem
[   20.163337] bus: 'usb': add driver moto-modem
[   20.170293] usbcore: registered new interface driver moto-modem
[   20.173338] initcall moto_init+0x0/0x48 returned 0 after 19531 usecs
[   20.180004] calling  opticon_init+0x0/0x48 @ 1
[   20.186670] bus: 'usb-serial': add driver opticon
[   20.192006] USB Serial support registered for opticon
[   20.196671] bus: 'usb': add driver opticon
[   20.201422] usbcore: registered new interface driver opticon
[   20.206672] initcall opticon_init+0x0/0x48 returned 0 after 19531 usecs
[   20.213417] calling  option_init+0x0/0x59 @ 1
[   20.216670] bus: 'usb-serial': add driver option1
[   20.223098] USB Serial support registered for GSM modem (1-port)
[   20.226671] bus: 'usb': add driver option
[   20.233396] usbcore: registered new interface driver option
[   20.236670] option: v0.7.2:USB Driver for GSM modems
[   20.243344] initcall option_init+0x0/0x59 returned 0 after 26041 usecs
[   20.250004] calling  pl2303_init+0x0/0x59 @ 1
[   20.253336] bus: 'usb-serial': add driver pl2303
[   20.259729] USB Serial support registered for pl2303
[   20.263338] bus: 'usb': add driver pl2303
[   20.268973] usbcore: registered new interface driver pl2303
[   20.273336] pl2303: Prolific PL2303 USB to serial adaptor driver
[   20.280007] initcall pl2303_init+0x0/0x59 returned 0 after 26041 usecs
[   20.286670] calling  sierra_init+0x0/0x58 @ 1
[   20.290002] bus: 'usb-serial': add driver sierra
[   20.296312] USB Serial support registered for Sierra USB modem
[   20.300004] bus: 'usb': add driver sierra
[   20.306433] usbcore: registered new interface driver sierra
[   20.310003] sierra: v.1.3.2:USB Driver for Sierra Wireless USB modems
[   20.316670] initcall sierra_init+0x0/0x58 returned 0 after 26041 usecs
[   20.323337] calling  spcp8x5_init+0x0/0x59 @ 1
[   20.326669] bus: 'usb-serial': add driver SPCP8x5
[   20.334391] USB Serial support registered for SPCP8x5
[   20.336670] bus: 'usb': add driver spcp8x5
[   20.343810] usbcore: registered new interface driver spcp8x5
[   20.346669] spcp8x5: v0.04:SPCP8x5 USB to serial adaptor driver
[   20.353337] initcall spcp8x5_init+0x0/0x59 returned 0 after 26041 usecs
[   20.360003] calling  ti_init+0x0/0x150 @ 1
[   20.363337] bus: 'usb-serial': add driver ti_usb_3410_5052_1
[   20.372014] USB Serial support registered for TI USB 3410 1 port adapter
[   20.376671] bus: 'usb-serial': add driver ti_usb_3410_5052_2
[   20.384626] USB Serial support registered for TI USB 5052 2 port adapter
[   20.390004] bus: 'usb': add driver ti_usb_3410_5052
[   20.396467] usbcore: registered new interface driver ti_usb_3410_5052
[   20.400003] ti_usb_3410_5052: v0.9:TI USB 3410/5052 Serial Driver
[   20.406670] initcall ti_init+0x0/0x150 returned 0 after 42317 usecs
[   20.413337] calling  appledisplay_init+0x0/0x59 @ 1
[   20.420272] bus: 'usb': add driver appledisplay
[   20.425060] usbcore: registered new interface driver appledisplay
[   20.430007] initcall appledisplay_init+0x0/0x59 returned 0 after 9765 usecs
[   20.436670] calling  berry_init+0x0/0x1b @ 1
[   20.440002] bus: 'usb': add driver berry_charge
[   20.447182] usbcore: registered new interface driver berry_charge
[   20.450007] initcall berry_init+0x0/0x1b returned 0 after 9765 usecs
[   20.456670] calling  usb_cytherm_init+0x0/0x4a @ 1
[   20.463336] bus: 'usb': add driver cytherm
[   20.468767] usbcore: registered new interface driver cytherm
[   20.473338] cytherm: v1.0:Cypress USB Thermometer driver
[   20.476671] initcall usb_cytherm_init+0x0/0x4a returned 0 after 13020 usecs
[   20.486671] calling  emi26_init+0x0/0x1b @ 1
[   20.490002] bus: 'usb': add driver emi26 - firmware loader
[   20.496723] usbcore: registered new interface driver emi26 - firmware loader
[   20.503341] initcall emi26_init+0x0/0x1b returned 0 after 13020 usecs
[   20.510003] calling  ftdi_elan_init+0x0/0x16e @ 1
[   20.513336] driver ftdi-elan built at 14:10:26 on Mar 19 2009
[   20.521043] bus: 'usb': add driver ftdi-elan
[   20.525561] usbcore: registered new interface driver ftdi-elan
[   20.530015] initcall ftdi_elan_init+0x0/0x16e returned 0 after 16276 usecs
[   20.536671] calling  usb_idmouse_init+0x0/0x48 @ 1
[   20.540001] idmouse: 0.6:Siemens ID Mouse FingerTIP Sensor Driver
[   20.546670] bus: 'usb': add driver idmouse
[   20.553526] usbcore: registered new interface driver idmouse
[   20.556674] initcall usb_idmouse_init+0x0/0x48 returned 0 after 16276 usecs
[   20.563336] calling  isight_firmware_init+0x0/0x1b @ 1
[   20.570003] bus: 'usb': add driver isight_firmware
[   20.576333] usbcore: registered new interface driver isight_firmware
[   20.580008] initcall isight_firmware_init+0x0/0x1b returned 0 after 9765 usecs
[   20.586670] calling  usb_led_init+0x0/0x3a @ 1
[   20.593337] bus: 'usb': add driver usbled
[   20.598628] usbcore: registered new interface driver usbled
[   20.603341] initcall usb_led_init+0x0/0x3a returned 0 after 9765 usecs
[   20.610003] calling  lego_usb_tower_init+0x0/0x8b @ 1
[   20.613336] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
[   20.620002] bus: 'usb': add driver legousbtower
[   20.627195] usbcore: registered new interface driver legousbtower
[   20.630005] legousbtower: v0.96:LEGO USB Tower Driver
[   20.636669] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
[   20.643337] initcall lego_usb_tower_init+0x0/0x8b returned 0 after 29296 usecs
[   20.653337] calling  tv_init+0x0/0x4a @ 1
[   20.656669] bus: 'usb': add driver trancevibrator
[   20.662532] usbcore: registered new interface driver trancevibrator
[   20.666672] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[   20.673337] initcall tv_init+0x0/0x4a returned 0 after 16276 usecs
[   20.680004] calling  usb_sevseg_init+0x0/0x3b @ 1
[   20.683336] bus: 'usb': add driver usbsevseg
[   20.690654] usbcore: registered new interface driver usbsevseg
[   20.693340] initcall usb_sevseg_init+0x0/0x3b returned 0 after 9765 usecs
[   20.700004] calling  i8042_init+0x0/0x103 @ 1
[   20.706701] bus: 'platform': add driver i8042
[   20.712280] Registering platform device 'i8042'. Parent at platform
[   20.716673] device: 'i8042': device_add
[   20.720012] bus: 'platform': add device i8042
[   20.727010] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   20.733337] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   20.745431] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.750007] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.753338] driver: 'i8042': driver_bound: bound to device 'i8042'
[   20.760010] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   20.766677] initcall i8042_init+0x0/0x103 returned 0 after 58593 usecs
[   20.770021] device: 'serio0': device_add
[   20.770042] bus: 'serio': add device serio0
[   20.770333] device: 'serio1': device_add
[   20.770342] bus: 'serio': add device serio1
[   20.790005] calling  serport_init+0x0/0x34 @ 1
[   20.793338] initcall serport_init+0x0/0x34 returned 0 after 0 usecs
[   20.800004] calling  ct82c710_init+0x0/0x196 @ 1
[   20.806691] initcall ct82c710_init+0x0/0x196 returned -19 after 0 usecs
[   20.813337] calling  mousedev_init+0x0/0x8e @ 1
[   20.816688] device: 'mice': device_add
[   20.833338] device: 'mouse0': device_add
[   20.837681] device: 'psaux': device_add
[   20.841788] mice: PS/2 mouse device common for all mice
[   20.846672] initcall mousedev_init+0x0/0x8e returned 0 after 29296 usecs
[   20.853336] calling  evdev_init+0x0/0x12 @ 1
[   20.870004] device: 'event0': device_add
[   20.874327] initcall evdev_init+0x0/0x12 returned 0 after 16276 usecs
[   20.880004] calling  atkbd_init+0x0/0x27 @ 1
[   20.883337] bus: 'serio': add driver atkbd
[   20.889402] initcall atkbd_init+0x0/0x27 returned 0 after 3255 usecs
[   20.889430] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   20.889434] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   20.910006] calling  sunkbd_init+0x0/0x1b @ 1
[   20.913443] bus: 'serio': add driver sunkbd
[   20.915387] device: 'input1': device_add
[   20.915761] input: AT Translated Set 2 keyboard as /class/input/input1
[   20.930250] initcall sunkbd_init+0x0/0x1b returned 0 after 16276 usecs
[   20.936671] calling  xtkbd_init+0x0/0x1b @ 1
[   20.940002] bus: 'serio': add driver xtkbd
[   20.945405] initcall xtkbd_init+0x0/0x1b returned 0 after 3255 usecs
[   20.950005] calling  atp_init+0x0/0x1b @ 1
[   20.953337] bus: 'usb': add driver appletouch
[   20.960492] usbcore: registered new interface driver appletouch
[   20.963340] initcall atp_init+0x0/0x1b returned 0 after 9765 usecs
[   20.970004] calling  psmouse_init+0x0/0x74 @ 1
[   20.977166] bus: 'serio': add driver psmouse
[   20.981714] initcall psmouse_init+0x0/0x74 returned 0 after 3255 usecs
[   20.983456] device: 'event1': device_add
[   20.983769] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   20.983773] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   20.983779] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   20.983781] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   21.020006] calling  kbtab_init+0x0/0x38 @ 1
[   21.023336] bus: 'usb': add driver kbtab
[   21.029033] usbcore: registered new interface driver kbtab
[   21.033339] kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
[   21.040003] initcall kbtab_init+0x0/0x38 returned 0 after 16276 usecs
[   21.046671] calling  usb_keyspan_init+0x0/0x3a @ 1
[   21.050003] bus: 'usb': add driver keyspan_remote
[   21.056475] usbcore: registered new interface driver keyspan_remote
[   21.060008] initcall usb_keyspan_init+0x0/0x3a returned 0 after 9765 usecs
[   21.066670] calling  powermate_init+0x0/0x1b @ 1
[   21.073337] bus: 'usb': add driver powermate
[   21.078759] usbcore: registered new interface driver powermate
[   21.083341] initcall powermate_init+0x0/0x1b returned 0 after 9765 usecs
[   21.090003] calling  pcf50633_input_init+0x0/0x12 @ 1
[   21.093336] bus: 'platform': add driver pcf50633-input
[   21.101744] initcall pcf50633_input_init+0x0/0x12 returned 0 after 6510 usecs
[   21.106671] calling  ali1563_init+0x0/0x1b @ 1
[   21.113342] bus: 'pci': add driver ali1563_smbus
[   21.118248] initcall ali1563_init+0x0/0x1b returned 0 after 3255 usecs
[   21.123338] calling  amd756_init+0x0/0x1b @ 1
[   21.126671] bus: 'pci': add driver amd756_smbus
[   21.133940] initcall amd756_init+0x0/0x1b returned 0 after 6510 usecs
[   21.140005] calling  i2c_amd8111_init+0x0/0x1b @ 1
[   21.143337] bus: 'pci': add driver amd8111_smbus2
[   21.150118] initcall i2c_amd8111_init+0x0/0x1b returned 0 after 6510 usecs
[   21.156670] calling  i2c_sch_init+0x0/0x1b @ 1
[   21.160004] bus: 'pci': add driver isch_smbus
[   21.166141] initcall i2c_sch_init+0x0/0x1b returned 0 after 3255 usecs
[   21.170005] calling  i2c_sis5595_init+0x0/0x1b @ 1
[   21.176687] bus: 'pci': add driver sis5595_smbus
[   21.182376] initcall i2c_sis5595_init+0x0/0x1b returned 0 after 3255 usecs
[   21.186670] calling  i2c_adap_simtec_init+0x0/0x12 @ 1
[   21.193399] bus: 'platform': add driver simtec-i2c
[   21.199522] initcall i2c_adap_simtec_init+0x0/0x12 returned 0 after 3255 usecs
[   21.206671] calling  i2c_voodoo3_init+0x0/0x1b @ 1
[   21.210007] bus: 'pci': add driver voodoo3_smbus
[   21.216429] initcall i2c_voodoo3_init+0x0/0x1b returned 0 after 3255 usecs
[   21.220005] calling  i2c_pca_pf_init+0x0/0x12 @ 1
[   21.226673] bus: 'platform': add driver i2c-pca-platform
[   21.231242] bus: 'serio': driver_probe_device: matched device serio1 with driver psmouse
[   21.231245] bus: 'serio': really_probe: probing driver psmouse with device serio1
[   21.249140] initcall i2c_pca_pf_init+0x0/0x12 returned 0 after 19531 usecs
[   21.253337] calling  pcf8591_init+0x0/0x37 @ 1
[   21.260004] bus: 'i2c': add driver pcf8591
[   21.264816] initcall pcf8591_init+0x0/0x37 returned 0 after 3255 usecs
[   21.270006] calling  w1_init+0x0/0xa9 @ 1
[   21.273336] Driver for 1-wire Dallas network protocol.
[   21.280756] bus: 'w1': registered
[   21.283336] bus: 'w1': add driver w1_master_driver
[   21.289140] bus: 'w1': add driver w1_slave_driver
[   21.294112] initcall w1_init+0x0/0xa9 returned 0 after 19531 usecs
[   21.300003] calling  ds_init+0x0/0x3f @ 1
[   21.303338] bus: 'usb': add driver DS9490R
[   21.308668] usbcore: registered new interface driver DS9490R
[   21.313340] initcall ds_init+0x0/0x3f returned 0 after 9765 usecs
[   21.320003] calling  w1_therm_init+0x0/0x35 @ 1
[   21.323372] initcall w1_therm_init+0x0/0x35 returned 0 after 0 usecs
[   21.330004] calling  w1_smem_init+0x0/0x3f @ 1
[   21.333338] initcall w1_smem_init+0x0/0x3f returned 0 after 0 usecs
[   21.340003] calling  w1_f2d_init+0x0/0x12 @ 1
[   21.343338] initcall w1_f2d_init+0x0/0x12 returned 0 after 0 usecs
[   21.350003] calling  w1_ds2760_init+0x0/0x2c @ 1
[   21.356669] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   21.363337] initcall w1_ds2760_init+0x0/0x2c returned 0 after 6510 usecs
[   21.370004] calling  w1_bq27000_init+0x0/0x22 @ 1
[   21.376670] initcall w1_bq27000_init+0x0/0x22 returned -17 after 0 usecs
[   21.383337] initcall w1_bq27000_init+0x0/0x22 returned with error code -17 
[   21.390002] calling  pda_power_init+0x0/0x12 @ 1
[   21.393336] bus: 'platform': add driver pda-power
[   21.400648] initcall pda_power_init+0x0/0x12 returned 0 after 6510 usecs
[   21.406671] calling  ds2760_battery_init+0x0/0x12 @ 1
[   21.410002] bus: 'platform': add driver ds2760-battery
[   21.417793] initcall ds2760_battery_init+0x0/0x12 returned 0 after 6510 usecs
[   21.423338] calling  da903x_battery_init+0x0/0x17 @ 1
[   21.430004] bus: 'platform': add driver da903x-battery
[   21.435378] initcall da903x_battery_init+0x0/0x17 returned 0 after 3255 usecs
[   21.440004] calling  usb_pcwd_init+0x0/0x4b @ 1
[   21.446670] bus: 'usb': add driver pcwd_usb
[   21.451490] usbcore: registered new interface driver pcwd_usb
[   21.456671] pcwd_usb: Berkshire USB-PC Watchdog driver v1.02 (21 Jan 2007)
[   21.463337] initcall usb_pcwd_init+0x0/0x4b returned 0 after 16276 usecs
[   21.470002] calling  watchdog_init+0x0/0x16a @ 1
[   21.473355] initcall watchdog_init+0x0/0x16a returned -19 after 0 usecs
[   21.480002] calling  alim7101_wdt_init+0x0/0x196 @ 1
[   21.486669] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   21.490009] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   21.496670] initcall alim7101_wdt_init+0x0/0x196 returned -16 after 9765 usecs
[   21.503336] initcall alim7101_wdt_init+0x0/0x196 returned with error code -16 
[   21.510003] calling  ibwdt_init+0x0/0x5f @ 1
[   21.516668] ib700wdt: WDT driver for IB700 single board computer initialising.
[   21.523336] bus: 'platform': add driver ib700wdt
[   21.529428] Registering platform device 'ib700wdt'. Parent at platform
[   21.533338] device: 'ib700wdt': device_add
[   21.540010] bus: 'platform': add device ib700wdt
[   21.544941] bus: 'platform': driver_probe_device: matched device ib700wdt with driver ib700wdt
[   21.553337] bus: 'platform': really_probe: probing driver ib700wdt with device ib700wdt
[   21.560019] device: 'watchdog': device_add
[   21.565936] driver: 'ib700wdt': driver_bound: bound to device 'ib700wdt'
[   21.570003] bus: 'platform': really_probe: bound device ib700wdt to driver ib700wdt
[   21.580006] initcall ibwdt_init+0x0/0x5f returned 0 after 61848 usecs
[   21.586669] calling  wafwdt_init+0x0/0x16a @ 1
[   21.590002] WDT driver for Wafer 5823 single board computer initialising.
[   21.596672] Wafer 5823 WDT: I/O address 0x0443 already in use
[   21.603338] initcall wafwdt_init+0x0/0x16a returned -5 after 13020 usecs
[   21.610002] initcall wafwdt_init+0x0/0x16a returned with error code -5 
[   21.616670] calling  it87_wdt_init+0x0/0x4cb @ 1
[   21.620035] IT87 WDT: Unsupported Chip found, Chip 8712 Revision 07
[   21.626670] initcall it87_wdt_init+0x0/0x4cb returned -19 after 6510 usecs
[   21.633336] calling  hpwdt_init+0x0/0x1b @ 1
[   21.636672] bus: 'pci': add driver hpwdt
[   21.643286] initcall hpwdt_init+0x0/0x1b returned 0 after 3255 usecs
[   21.646671] calling  sc1200wdt_init+0x0/0x117 @ 1
[   21.653335] sc1200wdt: build 20020303
[   21.656668] sc1200wdt: io parameter must be specified
[   21.660002] initcall sc1200wdt_init+0x0/0x117 returned -22 after 6510 usecs
[   21.670003] initcall sc1200wdt_init+0x0/0x117 returned with error code -22 
[   21.676669] calling  sbc60xxwdt_init+0x0/0x185 @ 1
[   21.680005] sbc60xxwdt: I/O address 0x0443 already in use
[   21.686669] initcall sbc60xxwdt_init+0x0/0x185 returned -5 after 6510 usecs
[   21.693336] initcall sbc60xxwdt_init+0x0/0x185 returned with error code -5 
[   21.700002] calling  sbc8360_init+0x0/0x1a6 @ 1
[   21.703338] sbc8360: failed to register misc device
[   21.710005] initcall sbc8360_init+0x0/0x1a6 returned -16 after 6510 usecs
[   21.716670] initcall sbc8360_init+0x0/0x1a6 returned with error code -16 
[   21.723335] calling  telephony_init+0x0/0x4c @ 1
[   21.726673] Linux telephony interface: v1.00
[   21.730009] initcall telephony_init+0x0/0x4c returned 0 after 3255 usecs
[   21.736671] calling  kcapi_init+0x0/0x98 @ 1
[   21.743424] CAPI Subsystem Rev 1.1.2.8
[   21.746678] initcall kcapi_init+0x0/0x98 returned 0 after 3255 usecs
[   21.753343] calling  capi_init+0x0/0x2ca @ 1
[   21.756677] device class 'capi': registering
[   21.762971] device: 'capi': device_add
[   21.767007] device: 'capi0': device_add
[   21.771194] device: 'capi1': device_add
[   21.775295] device: 'capi2': device_add
[   21.779406] device: 'capi3': device_add
[   21.783614] device: 'capi4': device_add
[   21.787762] device: 'capi5': device_add
[   21.791878] device: 'capi6': device_add
[   21.796075] device: 'capi7': device_add
[   21.800203] device: 'capi8': device_add
[   21.804307] device: 'capi9': device_add
[   21.808424] device: 'capi10': device_add
[   21.812624] device: 'capi11': device_add
[   21.817018] device: 'capi12': device_add
[   21.821234] device: 'capi13': device_add
[   21.825427] device: 'capi14': device_add
[   21.829700] device: 'capi15': device_add
[   21.833911] device: 'capi16': device_add
[   21.838102] device: 'capi17': device_add
[   21.842293] device: 'capi18': device_add
[   21.846493] device: 'capi19': device_add
[   21.850738] device: 'capi20': device_add
[   21.854944] device: 'capi21': device_add
[   21.859148] device: 'capi22': device_add
[   21.863376] device: 'capi23': device_add
[   21.867570] device: 'capi24': device_add
[   21.871765] device: 'capi25': device_add
[   21.875965] device: 'capi26': device_add
[   21.880170] device: 'capi27': device_add
[   21.884392] device: 'capi28': device_add
[   21.888588] device: 'capi29': device_add
[   21.892801] device: 'capi30': device_add
[   21.896987] device: 'capi31': device_add
[   21.901217] capi20: Rev 1.1.2.7: started up with major 68 (no capifs)
[   21.906674] initcall capi_init+0x0/0x2ca returned 0 after 146484 usecs
[   21.913337] calling  cpufreq_stats_init+0x0/0xa4 @ 1
[   21.916693] initcall cpufreq_stats_init+0x0/0xa4 returned 0 after 0 usecs
[   21.923336] calling  pca9532_init+0x0/0x14 @ 1
[   21.930004] bus: 'i2c': add driver pca9532
[   21.934797] initcall pca9532_init+0x0/0x14 returned 0 after 3255 usecs
[   21.940005] calling  gpio_led_init+0x0/0x12 @ 1
[   21.943417] bus: 'platform': add driver leds-gpio
[   21.950920] initcall gpio_led_init+0x0/0x12 returned 0 after 6510 usecs
[   21.956671] calling  dcdbas_init+0x0/0x67 @ 1
[   21.960002] bus: 'platform': add driver dcdbas
[   21.966600] Registering platform device 'dcdbas'. Parent at platform
[   21.970003] device: 'dcdbas': device_add
[   21.976686] bus: 'platform': add device dcdbas
[   21.981606] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   21.986669] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   21.996703] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   22.003335] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   22.010003] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   22.016671] initcall dcdbas_init+0x0/0x67 returned 0 after 55338 usecs
[   22.023336] calling  hid_init+0x0/0x6b @ 1
[   22.029666] bus: 'hid': registered
[   22.033224] initcall hid_init+0x0/0x6b returned 0 after 3255 usecs
[   22.036674] calling  apple_init+0x0/0x3d @ 1
[   22.043337] bus: 'hid': add driver apple
[   22.047902] initcall apple_init+0x0/0x3d returned 0 after 3255 usecs
[   22.053337] calling  belkin_init+0x0/0x20 @ 1
[   22.056670] bus: 'hid': add driver belkin
[   22.062924] initcall belkin_init+0x0/0x20 returned 0 after 3255 usecs
[   22.066671] calling  ch_init+0x0/0x20 @ 1
[   22.073336] bus: 'hid': add driver chicony
[   22.077866] initcall ch_init+0x0/0x20 returned 0 after 3255 usecs
[   22.083336] calling  cp_init+0x0/0x20 @ 1
[   22.086670] bus: 'hid': add driver cypress
[   22.092335] initcall cp_init+0x0/0x20 returned 0 after 3255 usecs
[   22.096671] calling  gyration_init+0x0/0x20 @ 1
[   22.100012] bus: 'hid': add driver gyration
[   22.107417] initcall gyration_init+0x0/0x20 returned 0 after 6510 usecs
[   22.113336] calling  lg_init+0x0/0x20 @ 1
[   22.116670] bus: 'hid': add driver logitech
[   22.122490] initcall lg_init+0x0/0x20 returned 0 after 3255 usecs
[   22.126671] calling  mr_init+0x0/0x20 @ 1
[   22.130005] bus: 'hid': add driver monterey
[   22.137043] initcall mr_init+0x0/0x20 returned 0 after 6510 usecs
[   22.140003] calling  ntrig_init+0x0/0x20 @ 1
[   22.146671] bus: 'hid': add driver ntrig
[   22.151603] initcall ntrig_init+0x0/0x20 returned 0 after 3255 usecs
[   22.156671] calling  sony_init+0x0/0x20 @ 1
[   22.160002] bus: 'hid': add driver sony
[   22.166241] initcall sony_init+0x0/0x20 returned 0 after 3255 usecs
[   22.170004] calling  sp_init+0x0/0x20 @ 1
[   22.173336] bus: 'hid': add driver sunplus
[   22.180884] initcall sp_init+0x0/0x20 returned 0 after 6510 usecs
[   22.186670] calling  ga_init+0x0/0x1b @ 1
[   22.190003] bus: 'hid': add driver greenasia
[   22.195517] initcall ga_init+0x0/0x1b returned 0 after 3255 usecs
[   22.200004] calling  tm_init+0x0/0x20 @ 1
[   22.203336] bus: 'hid': add driver thrustmaster
[   22.210424] initcall tm_init+0x0/0x20 returned 0 after 6510 usecs
[   22.213336] calling  hid_init+0x0/0x78 @ 1
[   22.220003] bus: 'hid': add driver generic-usb
[   22.225338] bus: 'usb': add driver usbhid
[   22.229631] usbcore: registered new interface driver usbhid
[   22.233339] usbhid: v2.6:USB HID core driver
[   22.236669] initcall hid_init+0x0/0x78 returned 0 after 16276 usecs
[   22.243337] calling  usb_mouse_init+0x0/0x38 @ 1
[   22.250004] bus: 'usb': add driver usbmouse
[   22.254807] usbcore: registered new interface driver usbmouse
[   22.260005] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[   22.263337] initcall usb_mouse_init+0x0/0x38 returned 0 after 13020 usecs
[   22.270003] calling  oprofile_init+0x0/0x52 @ 1
[   22.276671] oprofile: using NMI interrupt.
[   22.280010] initcall oprofile_init+0x0/0x52 returned 0 after 3255 usecs
[   22.286670] calling  flow_cache_init+0x0/0x1a6 @ 1
[   22.293565] initcall flow_cache_init+0x0/0x1a6 returned 0 after 3255 usecs
[   22.300004] calling  nfnetlink_init+0x0/0x5f @ 1
[   22.303335] Netfilter messages via NETLINK v0.30.
[   22.306713] initcall nfnetlink_init+0x0/0x5f returned 0 after 3255 usecs
[   22.313337] calling  nfnetlink_log_init+0x0/0xa8 @ 1
[   22.320054] initcall nfnetlink_log_init+0x0/0xa8 returned 0 after 0 usecs
[   22.326670] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[   22.333338] nf_conntrack version 0.5.0 (8191 buckets, 32764 max)
[   22.341099] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 6510 usecs
[   22.346670] calling  xt_init+0x0/0xe3 @ 1
[   22.350027] initcall xt_init+0x0/0xe3 returned 0 after 0 usecs
[   22.356669] calling  tcpudp_mt_init+0x0/0x17 @ 1
[   22.363358] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 usecs
[   22.370003] calling  nflog_tg_init+0x0/0x12 @ 1
[   22.373337] initcall nflog_tg_init+0x0/0x12 returned 0 after 0 usecs
[   22.380002] calling  tcpmss_tg_init+0x0/0x17 @ 1
[   22.383338] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 0 usecs
[   22.390002] calling  mark_mt_init+0x0/0x17 @ 1
[   22.393338] initcall mark_mt_init+0x0/0x17 returned 0 after 0 usecs
[   22.400002] calling  ip_vs_init+0x0/0xbd @ 1
[   22.406780] IPVS: Registered protocols (TCP, AH, ESP)
[   22.412570] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
[   22.416670] IPVS: Each connection entry needs 296 bytes at least
[   22.423394] IPVS: ipvs loaded.
[   22.426671] initcall ip_vs_init+0x0/0xbd returned 0 after 19531 usecs
[   22.433336] calling  ip_vs_rr_init+0x0/0x12 @ 1
[   22.436685] IPVS: [rr] scheduler registered.
[   22.443336] initcall ip_vs_rr_init+0x0/0x12 returned 0 after 6510 usecs
[   22.450005] calling  ip_vs_lblcr_init+0x0/0x47 @ 1
[   22.453344] IPVS: [lblcr] scheduler registered.
[   22.460004] initcall ip_vs_lblcr_init+0x0/0x47 returned 0 after 6510 usecs
[   22.466669] calling  ip_vs_dh_init+0x0/0x12 @ 1
[   22.470003] IPVS: [dh] scheduler registered.
[   22.473336] initcall ip_vs_dh_init+0x0/0x12 returned 0 after 3255 usecs
[   22.480003] calling  ip_vs_nq_init+0x0/0x12 @ 1
[   22.486668] IPVS: [nq] scheduler registered.
[   22.490003] initcall ip_vs_nq_init+0x0/0x12 returned 0 after 3255 usecs
[   22.496669] calling  sysctl_ipv4_init+0x0/0x4e @ 1
[   22.500017] initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 0 usecs
[   22.506670] calling  init_syncookies+0x0/0x19 @ 1
[   22.513368] initcall init_syncookies+0x0/0x19 returned 0 after 0 usecs
[   22.520003] calling  xfrm4_beet_init+0x0/0x17 @ 1
[   22.523338] initcall xfrm4_beet_init+0x0/0x17 returned 0 after 0 usecs
[   22.530003] calling  ipv4_netfilter_init+0x0/0x17 @ 1
[   22.536683] initcall ipv4_netfilter_init+0x0/0x17 returned 0 after 0 usecs
[   22.543336] calling  ip_tables_init+0x0/0xaf @ 1
[   22.546696] ip_tables: (C) 2000-2006 Netfilter Core Team
[   22.553337] initcall ip_tables_init+0x0/0xaf returned 0 after 6510 usecs
[   22.560003] calling  iptable_mangle_init+0x0/0x44 @ 1
[   22.563375] initcall iptable_mangle_init+0x0/0x44 returned 0 after 0 usecs
[   22.570004] calling  tcpprobe_init+0x0/0xd7 @ 1
[   22.581010] TCP probe registered (port=0)
[   22.583339] initcall tcpprobe_init+0x0/0xd7 returned 0 after 6510 usecs
[   22.590008] calling  cubictcp_register+0x0/0x65 @ 1
[   22.596669] TCP cubic registered
[   22.596669] initcall cubictcp_register+0x0/0x65 returned 0 after 0 usecs
[   22.603337] calling  xfrm_user_init+0x0/0x4d @ 1
[   22.610001] Initializing XFRM netlink socket
[   22.613424] initcall xfrm_user_init+0x0/0x4d returned 0 after 3255 usecs
[   22.620003] calling  inet6_init+0x0/0x2ca @ 1
[   22.629009] NET: Registered protocol family 10
[   22.636045] initcall inet6_init+0x0/0x2ca returned 0 after 9765 usecs
[   22.640010] calling  tunnel6_init+0x0/0x68 @ 1
[   22.646672] initcall tunnel6_init+0x0/0x68 returned 0 after 0 usecs
[   22.653338] calling  ip6_tunnel_init+0x0/0xa2 @ 1
[   22.656760] device: 'ip6tnl0': device_add
[   22.662556] initcall ip6_tunnel_init+0x0/0xa2 returned 0 after 3255 usecs
[   22.666672] calling  packet_init+0x0/0x47 @ 1
[   22.673337] NET: Registered protocol family 17
[   22.676707] initcall packet_init+0x0/0x47 returned 0 after 3255 usecs
[   22.683336] calling  ipsec_pfkey_init+0x0/0x84 @ 1
[   22.686669] NET: Registered protocol family 15
[   22.693349] initcall ipsec_pfkey_init+0x0/0x84 returned 0 after 6510 usecs
[   22.700004] calling  sco_init+0x0/0xea @ 1
[   22.703352] Bluetooth: SCO (Voice Link) ver 0.6
[   22.706668] Bluetooth: SCO socket layer initialized
[   22.713337] initcall sco_init+0x0/0xea returned 0 after 9765 usecs
[   22.720003] calling  init_sunrpc+0x0/0x5d @ 1
[   22.726479] RPC: Registered udp transport module.
[   22.730003] RPC: Registered tcp transport module.
[   22.733340] initcall init_sunrpc+0x0/0x5d returned 0 after 9765 usecs
[   22.740003] calling  init_rpcsec_gss+0x0/0x4d @ 1
[   22.746741] initcall init_rpcsec_gss+0x0/0x4d returned 0 after 0 usecs
[   22.753338] calling  init_kerberos_module+0x0/0x2f @ 1
[   22.756702] initcall init_kerberos_module+0x0/0x2f returned 0 after 0 usecs
[   22.763341] calling  init_spkm3_module+0x0/0x2f @ 1
[   22.770010] initcall init_spkm3_module+0x0/0x2f returned 0 after 0 usecs
[   22.776677] calling  af_rxrpc_init+0x0/0x1a0 @ 1
[   22.783213] NET: Registered protocol family 33
[   22.786717] initcall af_rxrpc_init+0x0/0x1a0 returned 0 after 6510 usecs
[   22.793338] calling  lane_module_init+0x0/0x5c @ 1
[   22.796688] lec.c: Mar 19 2009 14:10:35 initialized
[   22.803338] initcall lane_module_init+0x0/0x5c returned 0 after 6510 usecs
[   22.810003] calling  atm_mpoa_init+0x0/0x39 @ 1
[   22.813343] mpc.c: Mar 19 2009 14:10:33 initialized
[   22.820003] initcall atm_mpoa_init+0x0/0x39 returned 0 after 6510 usecs
[   22.826670] calling  decnet_init+0x0/0x8b @ 1
[   22.830001] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   22.840530] DECnet: Routing cache hash table of 1024 buckets, 56Kbytes
[   22.846742] NET: Registered protocol family 12
[   22.850021] initcall decnet_init+0x0/0x8b returned 0 after 19531 usecs
[   22.856672] calling  phonet_init+0x0/0x77 @ 1
[   22.860002] NET: Registered protocol family 35
[   22.867334] initcall phonet_init+0x0/0x77 returned 0 after 6510 usecs
[   22.873337] calling  pep_register+0x0/0x17 @ 1
[   22.878632] initcall pep_register+0x0/0x17 returned 0 after 0 usecs
[   22.883337] calling  sctp_init+0x0/0x848 @ 1
[   22.891715] SCTP: Hash tables configured (established 18724 bind 18724)
[   22.923863] sctp_init_sock(sk: ffff88003d900000)
[   22.926698] initcall sctp_init+0x0/0x848 returned 0 after 39062 usecs
[   22.933337] calling  dcbnl_init+0x0/0x32 @ 1
[   22.936671] initcall dcbnl_init+0x0/0x32 returned 0 after 0 usecs
[   22.943338] calling  update_mp_table+0x0/0x695 @ 1
[   22.950004] initcall update_mp_table+0x0/0x695 returned 0 after 0 usecs
[   22.956672] calling  lapic_insert_resource+0x0/0x40 @ 1
[   22.960006] initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 usecs
[   22.966670] calling  ioapic_insert_resources+0x0/0x4f @ 1
[   22.973338] initcall ioapic_insert_resources+0x0/0x4f returned 0 after 0 usecs
[   22.980003] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[   22.986671] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[   22.993336] calling  uv_init_heartbeat+0x0/0x49 @ 1
[   22.996671] initcall uv_init_heartbeat+0x0/0x49 returned 0 after 0 usecs
[   23.003336] calling  check_early_ioremap_leak+0x0/0x4f @ 1
[   23.010004] initcall check_early_ioremap_leak+0x0/0x4f returned 0 after 0 usecs
[   23.016669] calling  sched_init_debug+0x0/0x24 @ 1
[   23.020020] initcall sched_init_debug+0x0/0x24 returned 0 after 0 usecs
[   23.026671] calling  init_oops_id+0x0/0x36 @ 1
[   23.033341] initcall init_oops_id+0x0/0x36 returned 0 after 0 usecs
[   23.040003] calling  disable_boot_consoles+0x0/0x3a @ 1
[   23.043337] initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 usecs
[   23.050003] calling  pm_qos_power_init+0x0/0xca @ 1
[   23.056680] device: 'cpu_dma_latency': device_add
[   23.062495] device: 'network_latency': device_add
[   23.067484] device: 'network_throughput': device_add
[   23.072820] initcall pm_qos_power_init+0x0/0xca returned 0 after 13020 usecs
[   23.076672] calling  debugfs_kprobe_init+0x0/0x89 @ 1
[   23.083375] initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 0 usecs
[   23.090004] calling  taskstats_init+0x0/0x95 @ 1
[   23.093385] registered taskstats version 1
[   23.100004] initcall taskstats_init+0x0/0x95 returned 0 after 6510 usecs
[   23.106672] calling  clear_boot_tracer+0x0/0x2d @ 1
[   23.110004] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[   23.116670] calling  afs_init+0x0/0x115 @ 1
[   23.120002] kAFS: Red Hat AFS client v0.1 registering.
[   23.129294] initcall afs_init+0x0/0x115 returned 0 after 6510 usecs
[   23.133339] calling  fail_io_timeout_debugfs+0x0/0xb @ 1
[   23.140010] initcall fail_io_timeout_debugfs+0x0/0xb returned -19 after 0 usecs
[   23.146670] calling  random32_reseed+0x0/0xab @ 1
[   23.150014] initcall random32_reseed+0x0/0xab returned 0 after 0 usecs
[   23.156672] calling  pci_sysfs_init+0x0/0x4c @ 1
[   23.163600] initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 usecs
[   23.170004] calling  seqgen_init+0x0/0xf @ 1
[   23.173350] initcall seqgen_init+0x0/0xf returned 0 after 0 usecs
[   23.180004] calling  hd_init+0x0/0x2f6 @ 1
[   23.183390] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   23.190138] initcall hd_init+0x0/0x2f6 returned -1 after 6510 usecs
[   23.196669] initcall hd_init+0x0/0x2f6 returned with error code -1 
[   23.203338] calling  scsi_complete_async_scans+0x0/0x125 @ 1
[   23.210003] initcall scsi_complete_async_scans+0x0/0x125 returned 0 after 0 usecs
[   23.216670] calling  edd_init+0x0/0x2ea @ 1
[   23.220002] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   23.226669] EDD information not available.
[   23.230002] initcall edd_init+0x0/0x2ea returned -19 after 9765 usecs
[   23.236670] calling  memmap_init+0x0/0x90 @ 1
[   23.243445] initcall memmap_init+0x0/0x90 returned 0 after 0 usecs
[   23.250004] calling  tcp_congestion_default+0x0/0x12 @ 1
[   23.253337] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[   23.260005] calling  ip_auto_config+0x0/0xc82 @ 1
[   23.266689] initcall ip_auto_config+0x0/0xc82 returned 0 after 0 usecs
[   23.273384] driver_probe_done: probe_count = 0
[   23.276668] async_waiting @ 1
[   23.280002] async_continuing @ 1 after 0 usec
[   23.295508] EXT3-fs: INFO: recovery required on readonly filesystem.
[   23.300022] EXT3-fs: write access will be enabled during recovery.
[   23.784185] kjournald starting.  Commit interval 5 seconds
[   23.784180] EXT3-fs: recovery complete.
[   23.784721] EXT3-fs: mounted filesystem with ordered data mode.
[   23.784813] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[   23.784902] async_waiting @ 1
[   23.784905] async_continuing @ 1 after 0 usec
[   23.784908] debug: unmapping init memory ffffffff80ffe000..ffffffff81095000
[   23.784908] Write protecting the kernel read-only data: 11720k
[   23.790425] Testing CPA: undo ffffffff80209000-ffffffff80d7b000
[   23.797033] Testing CPA: again
[   24.036367] device: 'vcs1': device_add
[   24.042833] khelper used greatest stack depth: 4792 bytes left
[   24.042833] device: 'vcsa1': device_add
[   24.053504] device: 'vcs1': device_unregister
[   24.057396] device: 'vcs1': device_create_release
[   24.057396] device: 'vcsa1': device_unregister
[   24.057676] device: 'vcsa1': device_create_release
[   24.304519] uname used greatest stack depth: 4480 bytes left
[   24.387398] mount used greatest stack depth: 4064 bytes left
[   24.761250] awk used greatest stack depth: 3664 bytes left
[   24.803104] device: 'vcs1': device_add
[   24.803597] device: 'vcsa1': device_add
[   24.914696] device: 'vcs1': device_unregister
[   24.915191] device: 'vcs1': device_create_release
[   24.915191] device: 'vcsa1': device_unregister
[   24.915478] device: 'vcsa1': device_create_release
[   27.005057] device: 'eth0': device_rename: renaming to 'eth0_rename'
[   27.049657] device: 'eth1': device_rename: renaming to 'eth0'
[   27.050459] udev: renamed network interface eth1 to eth0
[   27.066711] device: 'eth0_rename': device_rename: renaming to 'eth1'
[   27.073569] udev: renamed network interface eth0_rename to eth1
[   27.544206] eth1: no link during initialization.
[   27.547282] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   27.572120] eth0: link down
[   27.573620] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.148235] eth1: link up.
[   30.150217] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   30.163543] Mapped at:
[   30.165909]  [<ffffffffffffffff>] 0xffffffffffffffff
[   33.200019] CPA self-test:
[   33.209573]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   33.229282]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   33.248203]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   33.253341] ok.
[   33.589330] device: 'vcs1': device_add
[   33.589592] device: 'vcsa1': device_add
[   33.678551] device: 'vcs1': device_unregister
[   33.678668] device: 'vcs1': device_create_release
[   33.678678] device: 'vcsa1': device_unregister
[   33.678754] device: 'vcsa1': device_create_release
[   34.541376] EXT3 FS on sda6, internal journal
[   34.651630] kjournald starting.  Commit interval 5 seconds
[   34.653728] EXT3 FS on sda5, internal journal
[   34.658263] EXT3-fs: mounted filesystem with ordered data mode.
[   35.581893] rc.sysinit used greatest stack depth: 3568 bytes left
[   36.880120] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[   40.716428] device: 'vcs1': device_add
[   40.716556] device: 'vcsa1': device_add
[   40.718899] device: 'vcs1': device_unregister
[   40.719013] device: 'vcs1': device_create_release
[   40.719022] device: 'vcsa1': device_unregister
[   40.720019] device: 'vcsa1': device_create_release
[   40.723424] device: 'vcs1': device_add
[   40.723507] device: 'vcsa1': device_add
[   40.735722] device: 'vcs4': device_add
[   40.735847] device: 'vcsa4': device_add
[   40.743477] device: 'vcs4': device_unregister
[   40.743557] device: 'vcs4': device_create_release
[   40.743567] device: 'vcsa4': device_unregister
[   40.743638] device: 'vcsa4': device_create_release
[   40.760007] eth1: no IPv6 routers present
[   40.780110] device: 'vcs3': device_add
[   40.780228] device: 'vcsa3': device_add
[   40.783579] device: 'vcs3': device_unregister
[   40.783655] device: 'vcs3': device_create_release
[   40.783664] device: 'vcsa3': device_unregister
[   40.783736] device: 'vcsa3': device_create_release
[   40.786734] device: 'vcs3': device_add
[   40.786810] device: 'vcsa3': device_add
[   40.798114] device: 'vcs2': device_add
[   40.798235] device: 'vcsa2': device_add
[   40.800092] device: 'vcs2': device_unregister
[   40.800168] device: 'vcs2': device_create_release
[   40.800177] device: 'vcsa2': device_unregister
[   40.800244] device: 'vcsa2': device_create_release
[   40.803429] device: 'vcs2': device_add
[   40.803505] device: 'vcsa2': device_add
[   40.811420] device: 'vcs4': device_add
[   40.811547] device: 'vcsa4': device_add
[   40.821386] device: 'vcs6': device_add
[   40.821516] device: 'vcsa6': device_add
[   40.833948] device: 'vcs5': device_add
[   40.834073] device: 'vcsa5': device_add
[   40.860131] device: 'vcs5': device_unregister
[   40.860250] device: 'vcs5': device_create_release
[   40.860265] device: 'vcsa5': device_unregister
[   40.860339] device: 'vcsa5': device_create_release
[   40.863556] device: 'vcs5': device_add
[   40.863657] device: 'vcsa5': device_add
[   40.868130] device: 'vcs6': device_unregister
[   40.868241] device: 'vcs6': device_create_release
[   40.868253] device: 'vcsa6': device_unregister
[   40.868328] device: 'vcsa6': device_create_release
[   40.910103] device: 'vcs6': device_add
[   40.910226] device: 'vcsa6': device_add
