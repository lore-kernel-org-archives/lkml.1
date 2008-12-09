Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbYLICi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbYLICi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 21:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYLICis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 21:38:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYLICil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 21:38:41 -0500
Date: Tue, 9 Dec 2008 03:38:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [crash] Re: [PATCH 1/3] tracing/function-graph-tracer: introduce
	__notrace_funcgraph to filter special functions
Message-ID: <20081209023822.GA3602@elte.hu>
References: <4939E600.804@gmail.com> <20081208141406.GA14856@elte.hu> <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com> <20081208155018.GB405@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20081208155018.GB405@elte.hu>
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


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> yes - but there's a few pending regressions right now delaying the 
> reintegration.

one of them is a new type of ftrace crash that started triggering in 
tip/master:

[    3.610253] initcall init_stack_trace+0x0/0x12 returned 0 after 105468 usecs
[    3.616017] calling  init_function_trace+0x0/0x12 @ 1
[    3.620014] Testing tracer function: <1>BUG: unable to handle kernel paging request at ffffffffffffff89
[    3.648007] IP: [<ffffffff802113a9>] save_rest+0x9/0x70
[    3.648007] PGD 203067 PUD 204067 PMD 0 
[    3.648007] Thread overran stack, or stack corrupted
[    3.648007] Oops: 0000 [#1] SMP 
[    3.648007] last sysfs file: 
[    3.648007] CPU 0 
[    3.648007] Pid: 0, comm: swapper Not tainted 2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
[    3.648007] RIP: 0010:[<ffffffff802113a9>]  [<ffffffff802113a9>] save_rest+0x9/0x70
[    3.648007] RSP: 0018:ffffffff816fde40  EFLAGS: 00010296
[    3.648007] RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 0000000000000003
[    3.648007] RDX: 0000000000000000 RSI: ffffffff80218b1c RDI: ffffffff80218acc
[    3.648007] RBP: ffffffff816fde88 R08: ffffffff8025e538 R09: 0000000000000001
[    3.648007] R10: ffffffff80242084 R11: 0000000000000000 R12: 0000000000000001
[    3.648007] R13: ffffffff8177f3a0 R14: ffffffff81782390 R15: 0000000000092f70
[    3.648007] FS:  0000000000000000(0000) GS:ffffffff816f1b00(0000) knlGS:0000000000000000
[    3.648007] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    3.648007] CR2: ffffffffffffff89 CR3: 0000000000201000 CR4: 00000000000006e0
[    3.648007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.648007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.648007] Process swapper (pid: 0, threadinfo ffffffff816fc000, task ffffffff8150d4a0)
[    3.648007] Stack:
[    3.648007]  ffffffff802112d6 0000000000000000 0000000000000003 0000000000000000
[    3.648007]  ffffffff816fc010 0000000000000003 ffffffff8025e538 0000000000000001
[    3.648007]  ffffffff80218ad1 ffffffff816fde98 ffffffff80218b1c ffffffff816fdec8
[    3.648007] Call Trace:
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218ad1>] ? constant_test_bit+0x9/0x26
[    3.648007]  [<ffffffff80218b1c>] need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218dff>] poll_idle+0x33/0x42
[    3.648007]  [<ffffffff8025e5ce>] ? atomic_notifier_call_chain+0xf/0x11
[    3.648007]  [<ffffffff8029230c>] ? stop_critical_timings+0x9/0x21
[    3.648007]  [<ffffffff802100c9>] cpu_idle+0xac/0xe0
[    3.648007]  [<ffffffff80e28bf2>] rest_init+0x66/0x68
[    3.648007]  [<ffffffff8172be75>] start_kernel+0x47d/0x488
[    3.648007]  [<ffffffff8172b140>] ? early_idt_handler+0x0/0x73
[    3.648007]  [<ffffffff8172b2c3>] x86_64_start_reservations+0xae/0xb2
[    3.648007]  [<ffffffff8172b421>] x86_64_start_kernel+0x137/0x146
[    3.648007] Code: 00 00 00 75 0b 58 65 48 8b 24 25 30 00 00 00 50 e8 78 6e c7 00 c3 66 66 66 90 66 66 66 90 66 66 66 90 4c 8b 5c 24 38 48 89 5c 24 <38> 48 89 6c 24 30 4c 89 64 24 28 4c 89 6c 24 20 4c 89 74 24 18 
[    3.648007] RIP  [<ffffffff802113a9>] save_rest+0x9/0x70
[    3.648007]  RSP <ffffffff816fde40>
[    3.648007] CR2: ffffffffffffff89
[    3.648007] ---[ end trace 5a5d197966b56a2e ]---
[    3.648007] Kernel panic - not syncing: Attempted to kill the idle task!
[    3.648007] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-tip-01358-g7c567b4-dirty #6311

Full crashlog and config attached.

	Ingo

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

[    0.000000] Linux version 2.6.28-rc7-tip-01358-g7c567b4-dirty (mingo@dione) (gcc version 4.2.3) #6311 SMP Mon Dec 8 21:38:23 CET 2008
[    0.000000] Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=2 idle=poll panic=1 3
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] PAT disabled. Not yet verified on this CPU type.
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
[    0.000000] using polling idle threads.
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x3ffffffff
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000008000 (usable)
[    0.000000]  modified: 0000000000008000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  modified: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  modified: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 10000-13000
[    0.000000] last_map_addr: 3fff0000 end: 3fff0000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000003fff0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [0000000000011000 - 0000000000015fff]
[    0.000000]   bootmap [0000000000016000 -  000000000001dfff] pages 8
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000241a838]    TEXT DATA BSS ==> [0000200000 - 000241a838]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f5680] 000f5680
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x00000008
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262005
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3767 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6552 pages used for memmap
[    0.000000]   DMA32 zone: 251480 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Intel MultiProcessor Specification v1.4
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
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] PERCPU: Allocating 1888256 bytes of per cpu data
[    0.000000] per cpu data for cpu0 on node0 at 0000000003f1d000
[    0.000000] per cpu data for cpu1 on node0 at 00000000040ea000
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255247
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=2 idle=poll panic=1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.351 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:          4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 4351 kB
[    0.004000]  per task-struct memory footprint: 2688 bytes
[    0.004000] ------------------------
[    0.004000] | Locking API testsuite:
[    0.004000] ----------------------------------------------------------------------------
[    0.004000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]               recursive read-lock:             |  ok  |             |failed|
[    0.004000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.004000]             mixed read-write-lock:             |failed|             |failed|
[    0.004000]             mixed write-read-lock:             |failed|             |failed|
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.004000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.004000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.004000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.004000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.004000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.004000]       hard-irq read-recursion/123:  ok  |
[    0.004000]       soft-irq read-recursion/123:  ok  |
[    0.004000]       hard-irq read-recursion/132:  ok  |
[    0.004000]       soft-irq read-recursion/132:  ok  |
[    0.004000]       hard-irq read-recursion/213:  ok  |
[    0.004000]       soft-irq read-recursion/213:  ok  |
[    0.004000]       hard-irq read-recursion/231:  ok  |
[    0.004000]       soft-irq read-recursion/231:  ok  |
[    0.004000]       hard-irq read-recursion/312:  ok  |
[    0.004000]       soft-irq read-recursion/312:  ok  |
[    0.004000]       hard-irq read-recursion/321:  ok  |
[    0.004000]       soft-irq read-recursion/321:  ok  |
[    0.004000] --------------------------------------------------------
[    0.004000] 133 out of 218 testcases failed, as expected. |
[    0.004000] ----------------------------------------------------
[    0.004000] allocated 10485760 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 971748k/1048512k available (12849k kernel code, 492k absent, 76272k reserved, 8452k data, 2520k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] ODEBUG: selftest passed
[    0.004013] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.70 BogoMIPS (lpj=8041404)
[    0.012047] Security Framework initialized
[    0.016019] SELinux:  Initializing.
[    0.020054] SELinux:  Starting in enforcing mode
[    0.024293] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.028802] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.032341] Mount-cache hash table entries: 256
[    0.036599] Initializing cgroup subsys ns
[    0.040013] Initializing cgroup subsys memory
[    0.044008] Initializing cgroup subsys devices
[    0.048021] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.052006] CPU: L2 Cache: 512K (64 bytes/line)
[    0.056012] numa_add_cpu cpu 0 node 0: mask now 0
[    0.060624] Freeing SMP alternatives: 44k freed
[    0.064093] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.068009] ftrace: allocating 44898 entries in 354 pages
[    0.076182] Setting APIC routing to flat
[    0.080009] enabled ExtINT on CPU#0
[    0.084061] ExtINT not setup in hardware but reported by MP table
[    0.088105] NMI watchdog: CPU not supported
[    0.092004] ENABLING IO-APIC IRQs
[    0.096004] init IO_APIC IRQs
[    0.100005]  2-0 (apicid-pin) not connected
[    0.104006]   alloc irq_2_pin on cpu 0 node 0
[    0.108012] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.112010]   alloc irq_2_pin on cpu 0 node 0
[    0.116006] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.120009]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.124001]   alloc irq_2_pin on cpu 0 node 0
[    0.124001] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.124001]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.124001] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.124001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.124001] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.124001] ..... (found apic 0 pin 0) ...
[    0.166786] ....... works.
[    0.168004] CPU0: AuthenticAMD AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.177255] Using local APIC timer interrupts.
[    0.177256] calibrating APIC timer ...
[    0.184001] ... lapic delta = 1256509
[    0.184001] ..... delta 1256509
[    0.184001] ..... mult: 53963277
[    0.184001] ..... calibration result: 804165
[    0.184001] ..... CPU clock speed is 2010.1659 MHz.
[    0.184001] ..... host bus clock speed is 201.0165 MHz.
[    0.184001] ... verify APIC timer
[    0.295511] ... jiffies delta = 25
[    0.296003] ... jiffies result ok
[    0.300023] calling  migration_init+0x0/0x5b @ 1
[    0.304089] initcall migration_init+0x0/0x5b returned 1 after 0 usecs
[    0.308006] initcall migration_init+0x0/0x5b returned with error code 1 
[    0.312005] calling  spawn_ksoftirqd+0x0/0x58 @ 1
[    0.316055] initcall spawn_ksoftirqd+0x0/0x58 returned 0 after 0 usecs
[    0.320007] calling  init_call_single_data+0x0/0x73 @ 1
[    0.324006] initcall init_call_single_data+0x0/0x73 returned 0 after 0 usecs
[    0.328005] calling  spawn_softlockup_task+0x0/0x7a @ 1
[    0.332053] initcall spawn_softlockup_task+0x0/0x7a returned 0 after 0 usecs
[    0.336005] calling  tracer_alloc_buffers+0x0/0x1be @ 1
[    0.344050] Testing tracer nop: PASSED
[    0.347654] initcall tracer_alloc_buffers+0x0/0x1be returned 0 after 3906 usecs
[    0.348159] lockdep: fixing up alternatives.
[    0.352047] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4020.87 BogoMIPS (lpj=8041750)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.444145] CPU1: AuthenticAMD AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.453267] Brought up 2 CPUs
[    0.456005] Total of 2 processors activated (8041.57 BogoMIPS).
[    0.460174] khelper used greatest stack depth: 5656 bytes left
[    0.471738] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.472008] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.476005] calling  net_ns_init+0x0/0x12d @ 1
[    0.480004] net_namespace: 1392 bytes
[    0.484015] initcall net_ns_init+0x0/0x12d returned 0 after 3906 usecs
[    0.488005] calling  cpufreq_tsc+0x0/0x40 @ 1
[    0.492006] initcall cpufreq_tsc+0x0/0x40 returned 0 after 0 usecs
[    0.496006] calling  init_smp_flush+0x0/0x60 @ 1
[    0.500006] initcall init_smp_flush+0x0/0x60 returned 0 after 0 usecs
[    0.504006] calling  print_banner+0x0/0xe @ 1
[    0.508005] Booting paravirtualized kernel on bare hardware
[    0.512005] initcall print_banner+0x0/0xe returned 0 after 3906 usecs
[    0.516005] calling  ksysfs_init+0x0/0xbb @ 1
[    0.520080] initcall ksysfs_init+0x0/0xbb returned 0 after 0 usecs
[    0.524006] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.528012] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.532006] calling  filelock_init+0x0/0x2e @ 1
[    0.536011] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.540005] calling  init_misc_binfmt+0x0/0x3f @ 1
[    0.544014] initcall init_misc_binfmt+0x0/0x3f returned 0 after 0 usecs
[    0.548005] calling  init_script_binfmt+0x0/0x12 @ 1
[    0.552006] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.556005] calling  init_elf_binfmt+0x0/0x12 @ 1
[    0.560006] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.564005] calling  init_compat_elf_binfmt+0x0/0x12 @ 1
[    0.568006] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.572006] calling  debugfs_init+0x0/0x51 @ 1
[    0.576010] initcall debugfs_init+0x0/0x51 returned 0 after 0 usecs
[    0.580005] calling  securityfs_init+0x0/0x51 @ 1
[    0.584010] initcall securityfs_init+0x0/0x51 returned 0 after 0 usecs
[    0.588006] calling  calibrate_xor_blocks+0x0/0xa7 @ 1
[    0.592013] xor: automatically using best checksumming function: generic_sse
[    0.616005]    generic_sse:  6155.000 MB/sec
[    0.620004] xor: using function: generic_sse (6155.000 MB/sec)
[    0.624013] initcall calibrate_xor_blocks+0x0/0xa7 returned 0 after 31250 usecs
[    0.628005] calling  random32_init+0x0/0xc7 @ 1
[    0.632006] initcall random32_init+0x0/0xc7 returned 0 after 0 usecs
[    0.636007] calling  gnttab_init+0x0/0x16c @ 1
[    0.640007] initcall gnttab_init+0x0/0x16c returned -19 after 0 usecs
[    0.644005] calling  cpufreq_core_init+0x0/0x86 @ 1
[    0.648006] initcall cpufreq_core_init+0x0/0x86 returned 0 after 0 usecs
[    0.652005] calling  cpuidle_init+0x0/0x40 @ 1
[    0.656014] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.660006] calling  regulator_init+0x0/0x2e @ 1
[    0.664004] regulator: core version 0.5
[    0.668077] initcall regulator_init+0x0/0x2e returned 0 after 3906 usecs
[    0.672006] calling  sock_init+0x0/0x5e @ 1
[    0.676188] initcall sock_init+0x0/0x5e returned 0 after 0 usecs
[    0.680006] calling  netpoll_init+0x0/0x14 @ 1
[    0.684006] initcall netpoll_init+0x0/0x14 returned 0 after 0 usecs
[    0.688006] calling  netlink_proto_init+0x0/0x14b @ 1
[    0.692020] NET: Registered protocol family 16
[    0.696039] initcall netlink_proto_init+0x0/0x14b returned 0 after 3906 usecs
[    0.700006] calling  bdi_class_init+0x0/0x41 @ 1
[    0.704075] initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
[    0.708007] calling  kobject_uevent_init+0x0/0x45 @ 1
[    0.712015] initcall kobject_uevent_init+0x0/0x45 returned 0 after 0 usecs
[    0.716006] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.720074] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.724007] calling  pci_driver_init+0x0/0x12 @ 1
[    0.728070] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.732007] calling  lcd_class_init+0x0/0x4d @ 1
[    0.736070] initcall lcd_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.740007] calling  video_output_class_init+0x0/0x19 @ 1
[    0.744065] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.748008] calling  xenbus_probe_init+0x0/0x139 @ 1
[    0.752006] initcall xenbus_probe_init+0x0/0x139 returned -19 after 0 usecs
[    0.756006] calling  tty_class_init+0x0/0x31 @ 1
[    0.764075] initcall tty_class_init+0x0/0x31 returned 0 after 3906 usecs
[    0.768007] calling  vtconsole_class_init+0x0/0xc3 @ 1
[    0.776072] initcall vtconsole_class_init+0x0/0xc3 returned 0 after 3906 usecs
[    0.780006] calling  register_node_type+0x0/0x45 @ 1
[    0.784069] initcall register_node_type+0x0/0x45 returned 0 after 0 usecs
[    0.788007] calling  spi_init+0x0/0x83 @ 1
[    0.792076] initcall spi_init+0x0/0x83 returned 0 after 0 usecs
[    0.796007] calling  i2c_init+0x0/0x66 @ 1
[    0.800076] initcall i2c_init+0x0/0x66 returned 0 after 0 usecs
[    0.804006] calling  amd_postcore_init+0x0/0x856 @ 1
[    0.808006] initcall amd_postcore_init+0x0/0x856 returned 0 after 0 usecs
[    0.812005] calling  arch_kdebugfs_init+0x0/0x219 @ 1
[    0.816057] initcall arch_kdebugfs_init+0x0/0x219 returned 0 after 0 usecs
[    0.820006] calling  mtrr_if_init+0x0/0x94 @ 1
[    0.824011] initcall mtrr_if_init+0x0/0x94 returned 0 after 0 usecs
[    0.828006] calling  pci_arch_init+0x0/0x40 @ 1
[    0.832395] PCI: Using configuration type 1 for base access
[    0.836006] initcall pci_arch_init+0x0/0x40 returned 0 after 3906 usecs
[    0.840005] calling  topology_init+0x0/0x8e @ 1
[    0.844075] initcall topology_init+0x0/0x8e returned 0 after 0 usecs
[    0.848011] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.852006] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    0.856005] calling  param_sysfs_init+0x0/0x2fe @ 1
[    0.964533] initcall param_sysfs_init+0x0/0x2fe returned 0 after 101562 usecs
[    0.968010] calling  readahead_init+0x0/0x38 @ 1
[    0.972085] initcall readahead_init+0x0/0x38 returned 0 after 0 usecs
[    0.976008] calling  init_bio+0x0/0xca @ 1
[    0.980271] initcall init_bio+0x0/0xca returned 0 after 0 usecs
[    0.984156] calling  integrity_init+0x0/0x3c @ 1
[    0.988054] initcall integrity_init+0x0/0x3c returned 0 after 0 usecs
[    0.992009] calling  cryptomgr_init+0x0/0x31 @ 1
[    0.996018] initcall cryptomgr_init+0x0/0x31 returned 0 after 0 usecs
[    1.000006] calling  blk_settings_init+0x0/0x2a @ 1
[    1.004006] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    1.008006] calling  blk_ioc_init+0x0/0x2a @ 1
[    1.012012] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    1.016006] calling  blk_softirq_init+0x0/0x5c @ 1
[    1.020007] initcall blk_softirq_init+0x0/0x5c returned 0 after 0 usecs
[    1.024006] calling  genhd_device_init+0x0/0x67 @ 1
[    1.028058] initcall genhd_device_init+0x0/0x67 returned 0 after 0 usecs
[    1.032006] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    1.036014] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    1.040006] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    1.044019] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    1.048006] calling  max7301_init+0x0/0x12 @ 1
[    1.052080] initcall max7301_init+0x0/0x12 returned 0 after 0 usecs
[    1.056006] calling  max732x_init+0x0/0x14 @ 1
[    1.060067] initcall max732x_init+0x0/0x14 returned 0 after 0 usecs
[    1.064007] calling  mcp23s08_init+0x0/0x12 @ 1
[    1.068065] initcall mcp23s08_init+0x0/0x12 returned 0 after 0 usecs
[    1.072007] calling  pca953x_init+0x0/0x14 @ 1
[    1.076068] initcall pca953x_init+0x0/0x14 returned 0 after 0 usecs
[    1.080007] calling  pcf857x_init+0x0/0x14 @ 1
[    1.084064] initcall pcf857x_init+0x0/0x14 returned 0 after 0 usecs
[    1.088008] calling  pci_slot_init+0x0/0x4a @ 1
[    1.092012] initcall pci_slot_init+0x0/0x4a returned 0 after 0 usecs
[    1.096007] calling  setup_shutdown_event+0x0/0x14 @ 1
[    1.100007] initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 usecs
[    1.104011] calling  balloon_init+0x0/0x1d0 @ 1
[    1.108007] initcall balloon_init+0x0/0x1d0 returned -19 after 0 usecs
[    1.112006] calling  misc_init+0x0/0x9f @ 1
[    1.116064] initcall misc_init+0x0/0x9f returned 0 after 0 usecs
[    1.120009] calling  cn_init+0x0/0xf3 @ 1
[    1.124052] initcall cn_init+0x0/0xf3 returned 0 after 0 usecs
[    1.128007] calling  tifm_init+0x0/0x85 @ 1
[    1.132075] initcall tifm_init+0x0/0x85 returned 0 after 0 usecs
[    1.136007] calling  phy_init+0x0/0x31 @ 1
[    1.140081] initcall phy_init+0x0/0x31 returned 0 after 0 usecs
[    1.144008] calling  init_dvbdev+0x0/0xc3 @ 1
[    1.148059] initcall init_dvbdev+0x0/0xc3 returned 0 after 0 usecs
[    1.152008] calling  init_scsi+0x0/0x71 @ 1
[    1.156137] SCSI subsystem initialized
[    1.160008] initcall init_scsi+0x0/0x71 returned 0 after 3906 usecs
[    1.164006] calling  ata_init+0x0/0x36b @ 1
[    1.168047] libata version 3.00 loaded.
[    1.172007] initcall ata_init+0x0/0x36b returned 0 after 3906 usecs
[    1.176006] calling  usb_init+0x0/0xd1 @ 1
[    1.180076] usbcore: registered new interface driver usbfs
[    1.184070] usbcore: registered new interface driver hub
[    1.188073] usbcore: registered new device driver usb
[    1.192007] initcall usb_init+0x0/0xd1 returned 0 after 11718 usecs
[    1.196007] calling  serio_init+0x0/0x98 @ 1
[    1.200059] initcall serio_init+0x0/0x98 returned 0 after 0 usecs
[    1.204008] calling  gameport_init+0x0/0x98 @ 1
[    1.208059] initcall gameport_init+0x0/0x98 returned 0 after 0 usecs
[    1.212008] calling  input_init+0x0/0x108 @ 1
[    1.216055] initcall input_init+0x0/0x108 returned 0 after 0 usecs
[    1.220008] calling  rtc_init+0x0/0x65 @ 1
[    1.224056] initcall rtc_init+0x0/0x65 returned 0 after 0 usecs
[    1.228008] calling  tps_init+0x0/0xdf @ 1
[    1.232006] tps65010: version 2 May 2005
[    1.268069] tps65010: no chip?
[    1.271014] initcall tps_init+0x0/0xdf returned -19 after 35156 usecs
[    1.272007] calling  power_supply_class_init+0x0/0x38 @ 1
[    1.276056] initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
[    1.280007] calling  hwmon_init+0x0/0x42 @ 1
[    1.284059] initcall hwmon_init+0x0/0x42 returned 0 after 0 usecs
[    1.288007] calling  thermal_init+0x0/0x58 @ 1
[    1.292056] initcall thermal_init+0x0/0x58 returned 0 after 0 usecs
[    1.296007] calling  md_init+0x0/0xd0 @ 1
[    1.300017] initcall md_init+0x0/0xd0 returned 0 after 0 usecs
[    1.304007] calling  mmc_init+0x0/0x76 @ 1
[    1.308075] initcall mmc_init+0x0/0x76 returned 0 after 0 usecs
[    1.312008] calling  leds_init+0x0/0x31 @ 1
[    1.316061] initcall leds_init+0x0/0x31 returned 0 after 0 usecs
[    1.320008] calling  dma_bus_init+0x0/0x33 @ 1
[    1.324056] initcall dma_bus_init+0x0/0x33 returned 0 after 0 usecs
[    1.328008] calling  dca_init+0x0/0x20 @ 1
[    1.332006] dca service started, version 1.4
[    1.336056] initcall dca_init+0x0/0x20 returned 0 after 3906 usecs
[    1.340008] calling  bq24022_init+0x0/0x19 @ 1
[    1.344072] initcall bq24022_init+0x0/0x19 returned -19 after 0 usecs
[    1.348009] calling  pci_subsys_init+0x0/0x12c @ 1
[    1.352006] PCI: Probing PCI hardware
[    1.356026] PCI: Probing PCI hardware (bus 00)
[    1.360172] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.364038] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    1.368022] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    1.372010] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    1.376018] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.380008] pci 0000:00:01.1: PME# disabled
[    1.384044] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    1.388037] pci 0000:00:02.0: supports D1 D2
[    1.392006] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.396008] pci 0000:00:02.0: PME# disabled
[    1.400042] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    1.404039] pci 0000:00:02.1: supports D1 D2
[    1.408006] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.412008] pci 0000:00:02.1: PME# disabled
[    1.416047] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    1.420010] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    1.424010] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    1.428029] pci 0000:00:04.0: supports D1 D2
[    1.432052] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    1.436080] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    1.440010] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    1.444033] pci 0000:00:0a.0: supports D1 D2
[    1.448006] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.452008] pci 0000:00:0a.0: PME# disabled
[    1.456056] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.460008] pci 0000:00:0b.0: PME# disabled
[    1.464058] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.468008] pci 0000:00:0c.0: PME# disabled
[    1.472058] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.476008] pci 0000:00:0d.0: PME# disabled
[    1.480058] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.484008] pci 0000:00:0e.0: PME# disabled
[    1.488265] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    1.492012] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    1.496041] pci 0000:05:07.0: supports D1 D2
[    1.500006] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.504008] pci 0000:05:07.0: PME# disabled
[    1.508045] pci 0000:00:09.0: transparent bridge
[    1.512008] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    1.516008] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    1.520235] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    1.524011] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    1.528011] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    1.528011] Clocksource tsc unstable (delta = 163733744 ns)
[    1.532026] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.536014] pci 0000:01:00.0: supports D1 D2
[    1.540044] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    1.544044] pci 0000:01:00.1: supports D1 D2
[    1.548030] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.552053] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    1.556008] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    1.560010] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    1.569798] pci 0000:00:00.0: default IRQ router [10de:005e]
[    1.572096] pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 3
[    1.576021] pci 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.580049] pci 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.584012] pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 5
[    1.588242] initcall pci_subsys_init+0x0/0x12c returned 0 after 230469 usecs
[    1.592007] calling  proto_init+0x0/0x2e @ 1
[    1.596014] initcall proto_init+0x0/0x2e returned 0 after 0 usecs
[    1.600007] calling  net_dev_init+0x0/0x1e0 @ 1
[    1.604082] initcall net_dev_init+0x0/0x1e0 returned 0 after 0 usecs
[    1.608008] calling  neigh_init+0x0/0x71 @ 1
[    1.612008] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    1.616011] calling  pktsched_init+0x0/0xc4 @ 1
[    1.620019] initcall pktsched_init+0x0/0xc4 returned 0 after 0 usecs
[    1.624007] calling  tc_filter_init+0x0/0x4c @ 1
[    1.628007] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    1.632007] calling  tc_action_init+0x0/0x4c @ 1
[    1.636007] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    1.640007] calling  genl_init+0x0/0xd9 @ 1
[    1.660020] initcall genl_init+0x0/0xd9 returned 0 after 15625 usecs
[    1.664008] calling  cipso_v4_init+0x0/0x88 @ 1
[    1.668025] initcall cipso_v4_init+0x0/0x88 returned 0 after 0 usecs
[    1.672008] calling  wanrouter_init+0x0/0x55 @ 1
[    1.676007] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    1.680021] initcall wanrouter_init+0x0/0x55 returned 0 after 3906 usecs
[    1.684007] calling  bt_init+0x0/0x5d @ 1
[    1.688006] Bluetooth: Core ver 2.13
[    1.692070] NET: Registered protocol family 31
[    1.696006] Bluetooth: HCI device and connection manager initialized
[    1.700020] Bluetooth: HCI socket layer initialized
[    1.704008] initcall bt_init+0x0/0x5d returned 0 after 15625 usecs
[    1.708007] calling  atm_init+0x0/0xb4 @ 1
[    1.712008] NET: Registered protocol family 8
[    1.716007] NET: Registered protocol family 20
[    1.720081] initcall atm_init+0x0/0xb4 returned 0 after 7812 usecs
[    1.724009] calling  wireless_nlevent_init+0x0/0x41 @ 1
[    1.728008] initcall wireless_nlevent_init+0x0/0x41 returned 0 after 0 usecs
[    1.732008] calling  cfg80211_init+0x0/0x79 @ 1
[    1.752095] cfg80211: Calling CRDA to update world regulatory domain
[    1.756053] cfg80211: Failed calling CRDA
[    1.760007] cfg80211: calling CRDA failed - unable to update world regulatory domain, using static definition
[    1.764008] initcall cfg80211_init+0x0/0x79 returned 0 after 27343 usecs
[    1.768007] calling  ieee80211_init+0x0/0x1f @ 1
[    1.772017] initcall ieee80211_init+0x0/0x1f returned 0 after 0 usecs
[    1.776007] calling  netlbl_init+0x0/0x83 @ 1
[    1.780006] NetLabel: Initializing
[    1.784006] NetLabel:  domain hash size = 128
[    1.788006] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.792059] NetLabel:  unlabeled traffic allowed by default
[    1.796008] initcall netlbl_init+0x0/0x83 returned 0 after 15625 usecs
[    1.800007] calling  rfkill_init+0x0/0x72 @ 1
[    1.804058] initcall rfkill_init+0x0/0x72 returned 0 after 0 usecs
[    1.808009] calling  pci_iommu_init+0x0/0x12 @ 1
[    1.812008] initcall pci_iommu_init+0x0/0x12 returned 0 after 0 usecs
[    1.816008] calling  print_all_ICs+0x0/0x4c2 @ 1
[    1.820006] 
[    1.820007] printing PIC contents
[    1.824008] ... PIC  IMR: fffa
[    1.827034] ... PIC  IRR: 0001
[    1.828006] ... PIC  ISR: 0001
[    1.831028] ... PIC ELCR: 0828
[    1.832008] 
[    1.832009] printing local APIC contents on CPU#0/0:
[    1.836004] ... APIC ID:      00000000 (0)
[    1.836004] ... APIC VERSION: 00040010
[    1.836004] ... APIC TASKPRI: 00000000 (00)
[    1.836004] ... APIC ARBPRI: 000000e0 (e0)
[    1.836004] ... APIC PROCPRI: 00000000
[    1.836004] ... APIC LDR: 01000000
[    1.836004] ... APIC DFR: ffffffff
[    1.836004] ... APIC SPIV: 000001ff
[    1.836004] ... APIC ISR field:
[    1.836004] 0123456789abcdef0123456789abcdef
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] ... APIC TMR field:
[    1.836004] 0123456789abcdef0123456789abcdef
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] ... APIC IRR field:
[    1.836004] 0123456789abcdef0123456789abcdef
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000000000000000000000
[    1.836004] 00000000000000010000000000000000
[    1.836004] ... APIC ESR: 00000000
[    1.836004] ... APIC ICR: 00000606
[    1.836004] ... APIC ICR2: 01000000
[    1.836004] ... APIC LVTT: 000200ef
[    1.836004] ... APIC LVTPC: 00010000
[    1.836004] ... APIC LVT0: 00010700
[    1.836004] ... APIC LVT1: 00000400
[    1.836004] ... APIC LVTERR: 000000fe
[    1.836004] ... APIC TMICT: 0000c454
[    1.836004] ... APIC TMCCT: 0000b63c
[    1.836004] ... APIC TDCR: 00000003
[    1.836004] 
[    1.836008] 
[    1.836009] printing local APIC contents on CPU#1/1:
[    1.840004] ... APIC ID:      01000000 (1)
[    1.840004] ... APIC VERSION: 00040010
[    1.840004] ... APIC TASKPRI: 00000000 (00)
[    1.840004] ... APIC ARBPRI: 000000e0 (e0)
[    1.840004] ... APIC PROCPRI: 00000000
[    1.840004] ... APIC LDR: 02000000
[    1.840004] ... APIC DFR: ffffffff
[    1.840004] ... APIC SPIV: 000001ff
[    1.840004] ... APIC ISR field:
[    1.840004] 0123456789abcdef0123456789abcdef
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] ... APIC TMR field:
[    1.840004] 0123456789abcdef0123456789abcdef
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] ... APIC IRR field:
[    1.840004] 0123456789abcdef0123456789abcdef
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000000000000000000000
[    1.840004] 00000000000000010000000000000000
[    1.840004] ... APIC ESR: 00000000
[    1.840004] ... APIC ICR: 000008fd
[    1.840004] ... APIC ICR2: 01000000
[    1.840004] ... APIC LVTT: 000200ef
[    1.840004] ... APIC LVTPC: 00010000
[    1.840004] ... APIC LVT0: 00010700
[    1.840004] ... APIC LVT1: 00010400
[    1.840004] ... APIC LVTERR: 000000fe
[    1.840004] ... APIC TMICT: 0000c454
[    1.840004] ... APIC TMCCT: 0000b2cc
[    1.840004] ... APIC TDCR: 00000003
[    1.840004] 
[    2.037060] number of MP IRQ sources: 17.
[    2.040007] number of IO-APIC #2 registers: 24.
[    2.044007] testing the IO APIC.......................
[    2.048010] 
[    2.052007] IO APIC #2......
[    2.054860] .... register #00: 00000000
[    2.056007] .......    : physical APIC id: 00
[    2.060007] .......    : Delivery Type: 0
[    2.064007] .......    : LTS          : 0
[    2.068007] .... register #01: 00170011
[    2.072007] .......     : max redirection entries: 0017
[    2.076007] .......     : PRQ implemented: 0
[    2.080007] .......     : IO APIC version: 0011
[    2.084007] .... register #02: 00000000
[    2.088007] .......     : arbitration: 00
[    2.092007] .... IRQ redirection table:
[    2.096007]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    2.100009]  00 0FF 0    0    0   0   0    1    1    30
[    2.107209]  01 003 0    0    0   0   0    1    1    31
[    2.112009]  02 000 1    0    0   0   0    0    0    00
[    2.116009]  03 003 1    1    0   1   0    1    1    33
[    2.120009]  04 003 0    0    0   0   0    1    1    34
[    2.128011]  05 003 1    1    0   1   0    1    1    35
[    2.132009]  06 003 0    0    0   0   0    1    1    36
[    2.136009]  07 003 1    0    0   0   0    1    1    37
[    2.143209]  08 003 0    0    0   0   0    1    1    38
[    2.148009]  09 003 0    0    0   0   0    1    1    39
[    2.152009]  0a 003 0    0    0   0   0    1    1    3A
[    2.159209]  0b 003 1    1    0   1   0    1    1    3B
[    2.164009]  0c 003 0    0    0   0   0    1    1    3C
[    2.168009]  0d 003 0    0    0   0   0    1    1    3D
[    2.172009]  0e 003 0    0    0   0   0    1    1    3E
[    2.180009]  0f 003 0    0    0   0   0    1    1    3F
[    2.184009]  10 000 1    0    0   0   0    0    0    00
[    2.188009]  11 000 1    0    0   0   0    0    0    00
[    2.195209]  12 000 1    0    0   0   0    0    0    00
[    2.200009]  13 000 1    0    0   0   0    0    0    00
[    2.204009]  14 000 1    0    0   0   0    0    0    00
[    2.211209]  15 000 1    0    0   0   0    0    0    00
[    2.216009]  16 000 1    0    0   0   0    0    0    00
[    2.220009]  17 000 1    0    0   0   0    0    0    00
[    2.224007] IRQ to pin mappings:
[    2.228007] IRQ0 -> 0:0
[    2.232176] IRQ1 -> 0:1
[    2.234601] IRQ3 -> 0:3
[    2.236695] IRQ4 -> 0:4
[    2.239120] IRQ5 -> 0:5
[    2.240695] IRQ6 -> 0:6
[    2.244696] IRQ7 -> 0:7
[    2.247121] IRQ8 -> 0:8
[    2.248696] IRQ9 -> 0:9
[    2.252007] IRQ10 -> 0:10
[    2.254601] IRQ11 -> 0:11
[    2.256783] IRQ12 -> 0:12
[    2.259380] IRQ13 -> 0:13
[    2.260783] IRQ14 -> 0:14
[    2.264782] IRQ15 -> 0:15
[    2.267422] .................................... done.
[    2.268009] initcall print_all_ICs+0x0/0x4c2 returned 0 after 437500 usecs
[    2.272009] calling  hpet_late_init+0x0/0x63 @ 1
[    2.276009] initcall hpet_late_init+0x0/0x63 returned -19 after 0 usecs
[    2.280009] calling  init_kmmio+0x0/0x2c @ 1
[    2.284012] initcall init_kmmio+0x0/0x2c returned 0 after 0 usecs
[    2.288009] calling  clocksource_done_booting+0x0/0x12 @ 1
[    2.292009] initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
[    2.296009] calling  ftrace_init_debugfs+0x0/0x106 @ 1
[    2.300070] initcall ftrace_init_debugfs+0x0/0x106 returned 0 after 0 usecs
[    2.304008] calling  rb_init_debugfs+0x0/0x40 @ 1
[    2.308019] initcall rb_init_debugfs+0x0/0x40 returned 0 after 0 usecs
[    2.312008] calling  tracer_init_debugfs+0x0/0x2d0 @ 1
[    2.316185] initcall tracer_init_debugfs+0x0/0x2d0 returned 0 after 0 usecs
[    2.320009] calling  init_pipe_fs+0x0/0x4c @ 1
[    2.324052] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
[    2.332009] calling  init_mnt_writers+0x0/0x84 @ 1
[    2.336010] initcall init_mnt_writers+0x0/0x84 returned 0 after 0 usecs
[    2.340009] calling  eventpoll_init+0x0/0xb5 @ 1
[    2.344022] initcall eventpoll_init+0x0/0xb5 returned 0 after 0 usecs
[    2.348009] calling  anon_inode_init+0x0/0x115 @ 1
[    2.352041] initcall anon_inode_init+0x0/0x115 returned 0 after 0 usecs
[    2.356010] calling  pcie_aspm_init+0x0/0x8 @ 1
[    2.360009] initcall pcie_aspm_init+0x0/0x8 returned 0 after 0 usecs
[    2.364009] calling  chr_dev_init+0x0/0xb4 @ 1
[    2.368084] initcall chr_dev_init+0x0/0xb4 returned 0 after 0 usecs
[    2.372011] calling  firmware_class_init+0x0/0x79 @ 1
[    2.376060] initcall firmware_class_init+0x0/0x79 returned 0 after 0 usecs
[    2.380009] calling  gru_init+0x0/0x47f @ 1
[    2.384013] initcall gru_init+0x0/0x47f returned 0 after 0 usecs
[    2.388009] calling  loopback_init+0x0/0x12 @ 1
[    2.392169] initcall loopback_init+0x0/0x12 returned 0 after 0 usecs
[    2.396010] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    2.400016] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    2.404009] calling  ssb_modinit+0x0/0x4f @ 1
[    2.408122] initcall ssb_modinit+0x0/0x4f returned 0 after 0 usecs
[    2.416011] calling  pcibios_assign_resources+0x0/0x88 @ 1
[    2.420097] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    2.424009] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    2.428011] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    2.432009] pci 0000:00:09.0:   PREFETCH window: disabled
[    2.436012] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    2.440007] pci 0000:00:0b.0:   IO window: disabled
[    2.444010] pci 0000:00:0b.0:   MEM window: disabled
[    2.448009] pci 0000:00:0b.0:   PREFETCH window: disabled
[    2.452011] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    2.456007] pci 0000:00:0c.0:   IO window: disabled
[    2.460010] pci 0000:00:0c.0:   MEM window: disabled
[    2.464009] pci 0000:00:0c.0:   PREFETCH window: disabled
[    2.468012] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    2.472007] pci 0000:00:0d.0:   IO window: disabled
[    2.476010] pci 0000:00:0d.0:   MEM window: disabled
[    2.480009] pci 0000:00:0d.0:   PREFETCH window: disabled
[    2.484016] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    2.488009] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    2.492010] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    2.496010] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    2.500019] pci 0000:00:09.0: setting latency timer to 64
[    2.504015] pci 0000:00:0b.0: setting latency timer to 64
[    2.508015] pci 0000:00:0c.0: setting latency timer to 64
[    2.512015] pci 0000:00:0d.0: setting latency timer to 64
[    2.516015] pci 0000:00:0e.0: setting latency timer to 64
[    2.520009] bus: 00 index 0 io port: [0x00-0xffff]
[    2.524008] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    2.528008] bus: 05 index 0 io port: [0xc000-0xcfff]
[    2.532008] bus: 05 index 1 mmio: [0xda000000-0xda0fffff]
[    2.536008] bus: 05 index 2 mmio: [0x0-0x0]
[    2.540008] bus: 05 index 3 io port: [0x00-0xffff]
[    2.544008] bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
[    2.548008] bus: 04 index 0 mmio: [0x0-0x0]
[    2.552008] bus: 04 index 1 mmio: [0x0-0x0]
[    2.556008] bus: 04 index 2 mmio: [0x0-0x0]
[    2.560008] bus: 04 index 3 mmio: [0x0-0x0]
[    2.564008] bus: 03 index 0 mmio: [0x0-0x0]
[    2.568008] bus: 03 index 1 mmio: [0x0-0x0]
[    2.572008] bus: 03 index 2 mmio: [0x0-0x0]
[    2.576008] bus: 03 index 3 mmio: [0x0-0x0]
[    2.580008] bus: 02 index 0 mmio: [0x0-0x0]
[    2.584008] bus: 02 index 1 mmio: [0x0-0x0]
[    2.588008] bus: 02 index 2 mmio: [0x0-0x0]
[    2.592008] bus: 02 index 3 mmio: [0x0-0x0]
[    2.596008] bus: 01 index 0 io port: [0xb000-0xbfff]
[    2.600008] bus: 01 index 1 mmio: [0xd8000000-0xd9ffffff]
[    2.604008] bus: 01 index 2 mmio: [0xd0000000-0xd7ffffff]
[    2.608008] bus: 01 index 3 mmio: [0x0-0x0]
[    2.612010] initcall pcibios_assign_resources+0x0/0x88 returned 0 after 187500 usecs
[    2.616009] calling  inet_init+0x0/0x1c1 @ 1
[    2.620026] NET: Registered protocol family 2
[    2.664121] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.668709] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.677325] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    2.685089] TCP: Hash tables configured (established 131072 bind 65536)
[    2.688042] TCP reno registered
[    2.704149] initcall inet_init+0x0/0x1c1 returned 0 after 82031 usecs
[    2.708011] calling  af_unix_init+0x0/0x55 @ 1
[    2.712019] NET: Registered protocol family 1
[    2.716019] initcall af_unix_init+0x0/0x55 returned 0 after 3906 usecs
[    2.720011] calling  populate_rootfs+0x0/0xea @ 1
[    2.724381] initcall populate_rootfs+0x0/0xea returned 0 after 0 usecs
[    2.728012] calling  calgary_fixup_tce_spaces+0x0/0xf0 @ 1
[    2.732010] initcall calgary_fixup_tce_spaces+0x0/0xf0 returned -19 after 0 usecs
[    2.736010] calling  i8259A_init_sysfs+0x0/0x22 @ 1
[    2.740103] initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
[    2.744011] calling  vsyscall_init+0x0/0x54 @ 1
[    2.748021] initcall vsyscall_init+0x0/0x54 returned 0 after 0 usecs
[    2.752009] calling  sbf_init+0x0/0xd5 @ 1
[    2.756010] initcall sbf_init+0x0/0xd5 returned 0 after 0 usecs
[    2.760009] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    2.764065] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
[    2.768010] calling  add_rtc_cmos+0x0/0x38 @ 1
[    2.772084] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    2.776010] initcall add_rtc_cmos+0x0/0x38 returned 0 after 3906 usecs
[    2.780010] calling  cache_sysfs_init+0x0/0x572 @ 1
[    2.784010] initcall cache_sysfs_init+0x0/0x572 returned 0 after 0 usecs
[    2.788009] calling  mce_init_device+0x0/0x1d6 @ 1
[    2.792109] initcall mce_init_device+0x0/0x1d6 returned 0 after 0 usecs
[    2.796010] calling  periodic_mcheck_init+0x0/0x3f @ 1
[    2.800021] initcall periodic_mcheck_init+0x0/0x3f returned 0 after 0 usecs
[    2.804009] calling  thermal_throttle_init_device+0x0/0x62 @ 1
[    2.808009] initcall thermal_throttle_init_device+0x0/0x62 returned 0 after 0 usecs
[    2.812009] calling  threshold_init_device+0x0/0x3f @ 1
[    2.816010] initcall threshold_init_device+0x0/0x3f returned 0 after 0 usecs
[    2.820009] calling  msr_init+0x0/0x100 @ 1
[    2.824087] initcall msr_init+0x0/0x100 returned 0 after 0 usecs
[    2.828010] calling  cpuid_init+0x0/0x100 @ 1
[    2.832085] initcall cpuid_init+0x0/0x100 returned 0 after 0 usecs
[    2.836011] calling  ioapic_init_sysfs+0x0/0x99 @ 1
[    2.840066] initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 0 usecs
[    2.844010] calling  add_pcspkr+0x0/0x28 @ 1
[    2.848075] initcall add_pcspkr+0x0/0x28 returned 0 after 0 usecs
[    2.852010] calling  microcode_init+0x0/0xf9 @ 1
[    2.856008] microcode: no support for this CPU vendor
[    2.860010] initcall microcode_init+0x0/0xf9 returned -19 after 3906 usecs
[    2.864011] calling  start_periodic_check_for_corruption+0x0/0x3c @ 1
[    2.868009] Scanning for low memory corruption every 60 seconds
[    2.872015] initcall start_periodic_check_for_corruption+0x0/0x3c returned 0 after 3906 usecs
[    2.876011] calling  uv_ptc_init+0x0/0x4f @ 1
[    2.880010] initcall uv_ptc_init+0x0/0x4f returned 0 after 0 usecs
[    2.884010] calling  uv_bau_init+0x0/0x4e4 @ 1
[    2.888011] initcall uv_bau_init+0x0/0x4e4 returned 0 after 0 usecs
[    2.892010] calling  sgi_uv_sysfs_init+0x0/0x94 @ 1
[    2.896019] initcall sgi_uv_sysfs_init+0x0/0x94 returned 0 after 0 usecs
[    2.900010] calling  audit_classes_init+0x0/0xaf @ 1
[    2.904014] initcall audit_classes_init+0x0/0xaf returned 0 after 0 usecs
[    2.908011] calling  start_pageattr_test+0x0/0x4b @ 1
[    2.912088] initcall start_pageattr_test+0x0/0x4b returned 0 after 0 usecs
[    2.916011] calling  aes_init+0x0/0x12 @ 1
[    2.920053] alg: cipher: Test 1 failed on encryption for aes-asm
[    2.928011] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
[    2.932017] initcall aes_init+0x0/0x12 returned 0 after 11718 usecs
[    2.936010] calling  init+0x0/0x12 @ 1
[    2.940113] initcall init+0x0/0x12 returned 0 after 0 usecs
[    2.944011] calling  init+0x0/0x12 @ 1
[    2.948048] initcall init+0x0/0x12 returned 0 after 0 usecs
[    2.952011] calling  crc32c_intel_mod_init+0x0/0x20 @ 1
[    2.956010] initcall crc32c_intel_mod_init+0x0/0x20 returned -19 after 0 usecs
[    2.960010] calling  init_vdso_vars+0x0/0x1d3 @ 1
[    2.964023] initcall init_vdso_vars+0x0/0x1d3 returned 0 after 0 usecs
[    2.968010] calling  sysenter_setup+0x0/0x2ea @ 1
[    2.972026] initcall sysenter_setup+0x0/0x2ea returned 0 after 0 usecs
[    2.976011] calling  proc_schedstat_init+0x0/0x22 @ 1
[    2.980018] initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 usecs
[    2.984009] calling  proc_execdomains_init+0x0/0x22 @ 1
[    2.988014] initcall proc_execdomains_init+0x0/0x22 returned 0 after 0 usecs
[    2.992009] calling  ioresources_init+0x0/0x36 @ 1
[    2.996018] initcall ioresources_init+0x0/0x36 returned 0 after 0 usecs
[    3.000009] calling  uid_cache_init+0x0/0x6c @ 1
[    3.004022] initcall uid_cache_init+0x0/0x6c returned 0 after 0 usecs
[    3.008010] calling  init_posix_timers+0x0/0xfd @ 1
[    3.012017] initcall init_posix_timers+0x0/0xfd returned 0 after 0 usecs
[    3.016010] calling  init_posix_cpu_timers+0x0/0xd4 @ 1
[    3.020010] initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 usecs
[    3.024010] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    3.028014] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
[    3.032010] calling  create_proc_profile+0x0/0x28e @ 1
[    3.036010] initcall create_proc_profile+0x0/0x28e returned 0 after 0 usecs
[    3.040009] calling  timekeeping_init_device+0x0/0x22 @ 1
[    3.044067] initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 usecs
[    3.048011] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    3.052067] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 usecs
[    3.056011] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    3.060015] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 usecs
[    3.064010] calling  init_tstats_procfs+0x0/0x2c @ 1
[    3.068017] initcall init_tstats_procfs+0x0/0x2c returned 0 after 0 usecs
[    3.072010] calling  lockdep_proc_init+0x0/0x56 @ 1
[    3.076022] initcall lockdep_proc_init+0x0/0x56 returned 0 after 0 usecs
[    3.080009] calling  futex_init+0x0/0x67 @ 1
[    3.084014] initcall futex_init+0x0/0x67 returned 0 after 0 usecs
[    3.088011] calling  init_rttest+0x0/0x15b @ 1
[    3.092104] Initializing RT-Tester: OK
[    3.096011] initcall init_rttest+0x0/0x15b returned 0 after 3906 usecs
[    3.100010] calling  proc_dma_init+0x0/0x22 @ 1
[    3.104015] initcall proc_dma_init+0x0/0x22 returned 0 after 0 usecs
[    3.108010] calling  kallsyms_init+0x0/0x25 @ 1
[    3.112014] initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
[    3.116010] calling  crash_save_vmcoreinfo_init+0x0/0x468 @ 1
[    3.120028] initcall crash_save_vmcoreinfo_init+0x0/0x468 returned 0 after 0 usecs
[    3.124010] calling  crash_notes_memory_init+0x0/0x3d @ 1
[    3.128012] initcall crash_notes_memory_init+0x0/0x3d returned 0 after 0 usecs
[    3.132011] calling  backtrace_regression_test+0x0/0xfd @ 1
[    3.136009] ====[ backtrace testing ]===========
[    3.140009] Testing a backtrace from process context.
[    3.144009] The following trace is a kernel self test and not a bug!
[    3.148010] Pid: 1, comm: swapper Not tainted 2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
[    3.152009] Call Trace:
[    3.154433]  [<ffffffff80270170>] backtrace_regression_test+0x3d/0xfd
[    3.156011]  [<ffffffff8025fe40>] ? clocksource_read+0xc/0xe
[    3.160011]  [<ffffffff8026002f>] ? getnstimeofday+0x41/0xa3
[    3.164012]  [<ffffffff8025c6b3>] ? timespec_to_ktime+0x1a/0x1c
[    3.168011]  [<ffffffff8025d20d>] ? ktime_get+0x23/0x25
[    3.172011]  [<ffffffff8020a09b>] do_one_initcall+0x5b/0x142
[    3.176015]  [<ffffffff80285341>] ? register_irq_proc+0xb3/0xcf
[    3.180012]  [<ffffffff80300000>] ? vfs_quota_on_path+0x2f/0x59
[    3.184012]  [<ffffffff8172b9a4>] kernel_init+0x12c/0x180
[    3.188012]  [<ffffffff80e88206>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    3.192012]  [<ffffffff8021292a>] child_rip+0xa/0x20
[    3.196011]  [<ffffffff8021223e>] ? restore_args+0x0/0x30
[    3.200011]  [<ffffffff8172b878>] ? kernel_init+0x0/0x180
[    3.204011]  [<ffffffff80212920>] ? child_rip+0x0/0x20
[    3.208009] Testing a backtrace from irq context.
[    3.212009] The following trace is a kernel self test and not a bug!
[    3.216017] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
[    3.220009] Call Trace:
[    3.222429]  <IRQ>  [<ffffffff8024c563>] ? __do_softirq+0x143/0x14f
[    3.228011]  [<ffffffff80270125>] backtrace_test_irq_callback+0xe/0x1c
[    3.232010]  [<ffffffff8024c7f2>] tasklet_action+0x94/0x105
[    3.236010]  [<ffffffff8024c4b7>] __do_softirq+0x97/0x14f
[    3.240010]  [<ffffffff8024c0b6>] ? ksoftirqd+0x0/0xb9
[    3.244010]  [<ffffffff80212a2c>] call_softirq+0x1c/0x30
[    3.248008]  <EOI>  [<ffffffff80214507>] do_softirq+0x52/0xbb
[    3.252010]  [<ffffffff8024c0fe>] ksoftirqd+0x48/0xb9
[    3.256010]  [<ffffffff8025a09b>] kthread+0x4e/0x7b
[    3.260010]  [<ffffffff8021292a>] child_rip+0xa/0x20
[    3.264010]  [<ffffffff8021223e>] ? restore_args+0x0/0x30
[    3.268011]  [<ffffffff80242084>] ? finish_task_switch+0x0/0xb1
[    3.272010]  [<ffffffff8025a04d>] ? kthread+0x0/0x7b
[    3.276010]  [<ffffffff80212920>] ? child_rip+0x0/0x20
[    3.280017] Testing a saved backtrace.
[    3.284009] The following trace is a kernel self test and not a bug!
[    3.288011]  [<ffffffff8021c076>] save_stack_trace+0x2f/0x4d
[    3.292009]  [<ffffffff8027020e>] backtrace_regression_test+0xdb/0xfd
[    3.300009]  [<ffffffff8020a09b>] do_one_initcall+0x5b/0x142
[    3.304009]  [<ffffffff8172b9a4>] kernel_init+0x12c/0x180
[    3.312009]  [<ffffffff8021292a>] child_rip+0xa/0x20
[    3.316008]  [<ffffffffffffffff>] 0xffffffffffffffff
[    3.320009] ====[ end of backtrace testing ]====
[    3.324011] initcall backtrace_regression_test+0x0/0xfd returned 0 after 183594 usecs
[    3.328010] calling  pid_namespaces_init+0x0/0x2d @ 1
[    3.332013] initcall pid_namespaces_init+0x0/0x2d returned 0 after 0 usecs
[    3.336010] calling  ikconfig_init+0x0/0x39 @ 1
[    3.340015] initcall ikconfig_init+0x0/0x39 returned 0 after 0 usecs
[    3.344010] calling  audit_init+0x0/0x111 @ 1
[    3.348009] audit: initializing netlink socket (disabled)
[    3.352056] type=2000 audit(1228770188.352:1): initialized
[    3.356014] initcall audit_init+0x0/0x111 returned 0 after 7812 usecs
[    3.360010] calling  audit_tree_init+0x0/0x49 @ 1
[    3.364016] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    3.368010] calling  rcu_torture_init+0x0/0x612 @ 1
[    3.372012] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[    3.376065] initcall rcu_torture_init+0x0/0x612 returned 0 after 3906 usecs
[    3.380010] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    3.384015] Testing tracer sched_switch: PASSED
[    3.492794] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 105468 usecs
[    3.496012] calling  init_stack_trace+0x0/0x12 @ 1
[    3.500012] Testing tracer sysprof: PASSED
[    3.610253] initcall init_stack_trace+0x0/0x12 returned 0 after 105468 usecs
[    3.616017] calling  init_function_trace+0x0/0x12 @ 1
[    3.620014] Testing tracer function: <1>BUG: unable to handle kernel paging request at ffffffffffffff89
[    3.648007] IP: [<ffffffff802113a9>] save_rest+0x9/0x70
[    3.648007] PGD 203067 PUD 204067 PMD 0 
[    3.648007] Thread overran stack, or stack corrupted
[    3.648007] Oops: 0000 [#1] SMP 
[    3.648007] last sysfs file: 
[    3.648007] CPU 0 
[    3.648007] Pid: 0, comm: swapper Not tainted 2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
[    3.648007] RIP: 0010:[<ffffffff802113a9>]  [<ffffffff802113a9>] save_rest+0x9/0x70
[    3.648007] RSP: 0018:ffffffff816fde40  EFLAGS: 00010296
[    3.648007] RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 0000000000000003
[    3.648007] RDX: 0000000000000000 RSI: ffffffff80218b1c RDI: ffffffff80218acc
[    3.648007] RBP: ffffffff816fde88 R08: ffffffff8025e538 R09: 0000000000000001
[    3.648007] R10: ffffffff80242084 R11: 0000000000000000 R12: 0000000000000001
[    3.648007] R13: ffffffff8177f3a0 R14: ffffffff81782390 R15: 0000000000092f70
[    3.648007] FS:  0000000000000000(0000) GS:ffffffff816f1b00(0000) knlGS:0000000000000000
[    3.648007] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    3.648007] CR2: ffffffffffffff89 CR3: 0000000000201000 CR4: 00000000000006e0
[    3.648007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.648007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.648007] Process swapper (pid: 0, threadinfo ffffffff816fc000, task ffffffff8150d4a0)
[    3.648007] Stack:
[    3.648007]  ffffffff802112d6 0000000000000000 0000000000000003 0000000000000000
[    3.648007]  ffffffff816fc010 0000000000000003 ffffffff8025e538 0000000000000001
[    3.648007]  ffffffff80218ad1 ffffffff816fde98 ffffffff80218b1c ffffffff816fdec8
[    3.648007] Call Trace:
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218ad1>] ? constant_test_bit+0x9/0x26
[    3.648007]  [<ffffffff80218b1c>] need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218dff>] poll_idle+0x33/0x42
[    3.648007]  [<ffffffff8025e5ce>] ? atomic_notifier_call_chain+0xf/0x11
[    3.648007]  [<ffffffff8029230c>] ? stop_critical_timings+0x9/0x21
[    3.648007]  [<ffffffff802100c9>] cpu_idle+0xac/0xe0
[    3.648007]  [<ffffffff80e28bf2>] rest_init+0x66/0x68
[    3.648007]  [<ffffffff8172be75>] start_kernel+0x47d/0x488
[    3.648007]  [<ffffffff8172b140>] ? early_idt_handler+0x0/0x73
[    3.648007]  [<ffffffff8172b2c3>] x86_64_start_reservations+0xae/0xb2
[    3.648007]  [<ffffffff8172b421>] x86_64_start_kernel+0x137/0x146
[    3.648007] Code: 00 00 00 75 0b 58 65 48 8b 24 25 30 00 00 00 50 e8 78 6e c7 00 c3 66 66 66 90 66 66 66 90 66 66 66 90 4c 8b 5c 24 38 48 89 5c 24 <38> 48 89 6c 24 30 4c 89 64 24 28 4c 89 6c 24 20 4c 89 74 24 18 
[    3.648007] RIP  [<ffffffff802113a9>] save_rest+0x9/0x70
[    3.648007]  RSP <ffffffff816fde40>
[    3.648007] CR2: ffffffffffffff89
[    3.648007] ---[ end trace 5a5d197966b56a2e ]---
[    3.648007] Kernel panic - not syncing: Attempted to kill the idle task!
[    3.648007] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
[    3.648007] Call Trace:
[    3.648007]  [<ffffffff80247222>] panic+0xa5/0x168
[    3.648007]  [<ffffffff8025e389>] ? __blocking_notifier_call_chain+0x16/0x75
[    3.648007]  [<ffffffff8025e3fc>] ? blocking_notifier_call_chain+0x14/0x16
[    3.648007]  [<ffffffff8024a18a>] do_exit+0x81/0x84a
[    3.648007]  [<ffffffff805b94b8>] ? get_random_bytes+0x20/0x22
[    3.648007]  [<ffffffff802156eb>] oops_end+0xcf/0xd7
[    3.648007]  [<ffffffff8022eb9b>] do_page_fault+0x941/0xa22
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80e89045>] page_fault+0x25/0x30
[    3.648007]  [<ffffffff80242084>] ? finish_task_switch+0x0/0xb1
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218b1c>] ? need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218acc>] ? constant_test_bit+0x4/0x26
[    3.648007]  [<ffffffff802113a9>] ? save_rest+0x9/0x70
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218ad1>] ? constant_test_bit+0x9/0x26
[    3.648007]  [<ffffffff80218b1c>] need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218dff>] poll_idle+0x33/0x42
[    3.648007]  [<ffffffff8025e5ce>] ? atomic_notifier_call_chain+0xf/0x11
[    3.648007]  [<ffffffff8029230c>] ? stop_critical_timings+0x9/0x21
[    3.648007]  [<ffffffff802100c9>] cpu_idle+0xac/0xe0
[    3.648007]  [<ffffffff80e28bf2>] rest_init+0x66/0x68
[    3.648007]  [<ffffffff8172be75>] start_kernel+0x47d/0x488
[    3.648007]  [<ffffffff8172b140>] ? early_idt_handler+0x0/0x73
[    3.648007]  [<ffffffff8172b2c3>] x86_64_start_reservations+0xae/0xb2
[    3.648007]  [<ffffffff8172b421>] x86_64_start_kernel+0x137/0x146
[    3.648007] ------------[ cut here ]------------
[    3.648007] WARNING: at kernel/smp.c:333 smp_call_function_mask+0x4f/0x1f5()
[    3.648007] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
[    3.648007] Call Trace:
[    3.648007]  [<ffffffff8024715e>] warn_slowpath+0xb3/0xd2
[    3.648007]  [<ffffffff8028c056>] ? rb_reserve_next_event+0x288/0x2bb
[    3.648007]  [<ffffffff8028cf20>] ? need_resched+0x1e/0x28
[    3.648007]  [<ffffffff8028a8d6>] ? rb_commit+0x35/0x3a
[    3.648007]  [<ffffffff8028ca44>] ? ring_buffer_unlock_commit+0x1e/0x22
[    3.648007]  [<ffffffff8028e332>] ? trace_function+0x8d/0x9c
[    3.648007]  [<ffffffff8026d12f>] ? smp_call_function+0x20/0x22
[    3.648007]  [<ffffffff80292092>] ? trace_hardirqs_off+0x9/0x20
[    3.648007]  [<ffffffff80291342>] ? function_trace_call+0x99/0xb7
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff80218c6f>] ? stop_this_cpu+0x0/0x45
[    3.648007]  [<ffffffff8026cf69>] smp_call_function_mask+0x4f/0x1f5
[    3.648007]  [<ffffffff80218c6f>] ? stop_this_cpu+0x0/0x45
[    3.648007]  [<ffffffff8028cf20>] ? need_resched+0x1e/0x28
[    3.648007]  [<ffffffff8028a8d6>] ? rb_commit+0x35/0x3a
[    3.648007]  [<ffffffff8028ca44>] ? ring_buffer_unlock_commit+0x1e/0x22
[    3.648007]  [<ffffffff8028e332>] ? trace_function+0x8d/0x9c
[    3.648007]  [<ffffffff80222015>] ? native_smp_send_stop+0x27/0x72
[    3.648007]  [<ffffffff8026d113>] ? smp_call_function+0x4/0x22
[    3.648007]  [<ffffffff80247236>] ? panic+0xb9/0x168
[    3.648007]  [<ffffffff80221ff7>] ? native_smp_send_stop+0x9/0x72
[    3.648007]  [<ffffffff80222015>] ? native_smp_send_stop+0x27/0x72
[    3.648007]  [<ffffffff80292092>] ? trace_hardirqs_off+0x9/0x20
[    3.648007]  [<ffffffff80291342>] ? function_trace_call+0x99/0xb7
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8026d12f>] smp_call_function+0x20/0x22
[    3.648007]  [<ffffffff80222015>] native_smp_send_stop+0x27/0x72
[    3.648007]  [<ffffffff80247236>] panic+0xb9/0x168
[    3.648007]  [<ffffffff8025e389>] ? __blocking_notifier_call_chain+0x16/0x75
[    3.648007]  [<ffffffff8025e3fc>] ? blocking_notifier_call_chain+0x14/0x16
[    3.648007]  [<ffffffff8024a18a>] do_exit+0x81/0x84a
[    3.648007]  [<ffffffff805b94b8>] ? get_random_bytes+0x20/0x22
[    3.648007]  [<ffffffff802156eb>] oops_end+0xcf/0xd7
[    3.648007]  [<ffffffff8022eb9b>] do_page_fault+0x941/0xa22
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80e89045>] page_fault+0x25/0x30
[    3.648007]  [<ffffffff80242084>] ? finish_task_switch+0x0/0xb1
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218b1c>] ? need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218acc>] ? constant_test_bit+0x4/0x26
[    3.648007]  [<ffffffff802113a9>] ? save_rest+0x9/0x70
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218ad1>] ? constant_test_bit+0x9/0x26
[    3.648007]  [<ffffffff80218b1c>] need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218dff>] poll_idle+0x33/0x42
[    3.648007]  [<ffffffff8025e5ce>] ? atomic_notifier_call_chain+0xf/0x11
[    3.648007]  [<ffffffff8029230c>] ? stop_critical_timings+0x9/0x21
[    3.648007]  [<ffffffff802100c9>] cpu_idle+0xac/0xe0
[    3.648007]  [<ffffffff80e28bf2>] rest_init+0x66/0x68
[    3.648007]  [<ffffffff8172be75>] start_kernel+0x47d/0x488
[    3.648007]  [<ffffffff8172b140>] ? early_idt_handler+0x0/0x73
[    3.648007]  [<ffffffff8172b2c3>] x86_64_start_reservations+0xae/0xb2
[    3.648007]  [<ffffffff8172b421>] x86_64_start_kernel+0x137/0x146
[    3.648007] ---[ end trace 5a5d197966b56a2e ]---
[    3.648007] ------------[ cut here ]------------
[    3.648007] WARNING: at kernel/smp.c:220 smp_call_function_single+0x4c/0x101()
[    3.648007] Pid: 0, comm: swapper Tainted: G      D W  2.6.28-rc7-tip-01358-g7c567b4-dirty #6311
[    3.648007] Call Trace:
[    3.648007]  [<ffffffff8024715e>] warn_slowpath+0xb3/0xd2
[    3.648007]  [<ffffffff8028c056>] ? rb_reserve_next_event+0x288/0x2bb
[    3.648007]  [<ffffffff8028cf20>] ? need_resched+0x1e/0x28
[    3.648007]  [<ffffffff8028a8d6>] ? rb_commit+0x35/0x3a
[    3.648007]  [<ffffffff8028ca44>] ? ring_buffer_unlock_commit+0x1e/0x22
[    3.648007]  [<ffffffff8028e332>] ? trace_function+0x8d/0x9c
[    3.648007]  [<ffffffff8026cfd2>] ? smp_call_function_mask+0xb8/0x1f5
[    3.648007]  [<ffffffff80292092>] ? trace_hardirqs_off+0x9/0x20
[    3.648007]  [<ffffffff80291342>] ? function_trace_call+0x99/0xb7
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8026ce65>] smp_call_function_single+0x4c/0x101
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8026cfd2>] smp_call_function_mask+0xb8/0x1f5
[    3.648007]  [<ffffffff80218c6f>] ? stop_this_cpu+0x0/0x45
[    3.648007]  [<ffffffff8028cf20>] ? need_resched+0x1e/0x28
[    3.648007]  [<ffffffff8028a8d6>] ? rb_commit+0x35/0x3a
[    3.648007]  [<ffffffff8028ca44>] ? ring_buffer_unlock_commit+0x1e/0x22
[    3.648007]  [<ffffffff8028e332>] ? trace_function+0x8d/0x9c
[    3.648007]  [<ffffffff80222015>] ? native_smp_send_stop+0x27/0x72
[    3.648007]  [<ffffffff8026d113>] ? smp_call_function+0x4/0x22
[    3.648007]  [<ffffffff80247236>] ? panic+0xb9/0x168
[    3.648007]  [<ffffffff80221ff7>] ? native_smp_send_stop+0x9/0x72
[    3.648007]  [<ffffffff80222015>] ? native_smp_send_stop+0x27/0x72
[    3.648007]  [<ffffffff80292092>] ? trace_hardirqs_off+0x9/0x20
[    3.648007]  [<ffffffff80291342>] ? function_trace_call+0x99/0xb7
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8026d12f>] smp_call_function+0x20/0x22
[    3.648007]  [<ffffffff80222015>] native_smp_send_stop+0x27/0x72
[    3.648007]  [<ffffffff80247236>] panic+0xb9/0x168
[    3.648007]  [<ffffffff8025e389>] ? __blocking_notifier_call_chain+0x16/0x75
[    3.648007]  [<ffffffff8025e3fc>] ? blocking_notifier_call_chain+0x14/0x16
[    3.648007]  [<ffffffff8024a18a>] do_exit+0x81/0x84a
[    3.648007]  [<ffffffff805b94b8>] ? get_random_bytes+0x20/0x22
[    3.648007]  [<ffffffff802156eb>] oops_end+0xcf/0xd7
[    3.648007]  [<ffffffff8022eb9b>] do_page_fault+0x941/0xa22
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80e89045>] page_fault+0x25/0x30
[    3.648007]  [<ffffffff80242084>] ? finish_task_switch+0x0/0xb1
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218b1c>] ? need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218acc>] ? constant_test_bit+0x4/0x26
[    3.648007]  [<ffffffff802113a9>] ? save_rest+0x9/0x70
[    3.648007]  [<ffffffff802112d6>] ? ftrace_call+0x5/0x2b
[    3.648007]  [<ffffffff8025e538>] ? __atomic_notifier_call_chain+0x0/0x87
[    3.648007]  [<ffffffff80218ad1>] ? constant_test_bit+0x9/0x26
[    3.648007]  [<ffffffff80218b1c>] need_resched+0x23/0x2d
[    3.648007]  [<ffffffff80218dff>] poll_idle+0x33/0x42
[    3.648007]  [<ffffffff8025e5ce>] ? atomic_notifier_call_chain+0xf/0x11
[    3.648007]  [<ffffffff8029230c>] ? stop_critical_timings+0x9/0x21
[    3.648007]  [<ffffffff802100c9>] cpu_idle+0xac/0xe0
[    3.648007]  [<ffffffff80e28bf2>] rest_init+0x66/0x68
[    3.648007]  [<ffffffff8172be75>] start_kernel+0x47d/0x488
[    3.648007]  [<ffffffff8172b140>] ? early_idt_handler+0x0/0x73
[    3.648007]  [<ffffffff8172b2c3>] x86_64_start_reservations+0xae/0xb2
[    3.648007]  [<ffffffff8172b421>] x86_64_start_kernel+0x137/0x146
[    3.648007] ---[ end trace 5a5d197966b56a2e ]---

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config.bad"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-rc7
# Mon Dec  8 21:34:53 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
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
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_BOOT_ALLOWED4=y
# CONFIG_BROKEN_BOOT_ALLOWED3 is not set
CONFIG_BROKEN_BOOT_EUROPE=y
CONFIG_BROKEN_BOOT_TITAN=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MM_OWNER=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_PROC_PID_CPUSET=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
# CONFIG_PERF_COUNTERS is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_IBS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP_SUPPORT is not set
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
# CONFIG_UP_WANTED_1 is not set
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
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
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR_64 is not set
# CONFIG_X86_DS is not set
# CONFIG_X86_PTRACE_BTS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_K8_NUMA is not set
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_MMU_NOTIFIER=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
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
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
# CONFIG_ATM_BR2684 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_NET_DSA_TAG_EDSA is not set
# CONFIG_NET_DSA_TAG_TRAILER is not set
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_ECONET=y
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_IPT=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=y
CONFIG_BT_HCIUSB_SCO=y
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIVHCI=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_PHONET=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
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
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_MPL_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
CONFIG_IEEE80211_CRYPT_TKIP=y
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
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
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_EEPROM_93CX6=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_SGI_XP=y
CONFIG_HP_ILO=y
CONFIG_SGI_GRU=y
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
# CONFIG_MEGARAID_MAILBOX is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=y
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=y
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=y
CONFIG_PATA_NS87415=y
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SC1200=y
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_PLATFORM=y
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_IEEE1394=y
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=y
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VERBOSEDEBUG=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=y
# CONFIG_DUMMY is not set
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
CONFIG_ENC28J60=y
# CONFIG_ENC28J60_WRITEVERIFY is not set
# CONFIG_NET_TULIP is not set
CONFIG_HP100=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=y
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
CONFIG_SC92031=y
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=y
CONFIG_IGB_LRO=y
CONFIG_IGB_DCA=y
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=y
CONFIG_R8169=y
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_QLA3XXX=y
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
CONFIG_JME=y
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_ENIC=y
CONFIG_IXGBE=y
# CONFIG_IXGBE_DCA is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NIU=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_TEHUTI is not set
CONFIG_BNX2X=y
CONFIG_QLGE=y
# CONFIG_SFC is not set
CONFIG_TR=y
CONFIG_IBMOL=y
CONFIG_3C359=y
CONFIG_TMS380TR=y
# CONFIG_TMSPCI is not set
CONFIG_ABYSS=y

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_STRIP is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
# CONFIG_LIBERTAS_SDIO is not set
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM=y
# CONFIG_LIBERTAS_THINFIRM_USB is not set
CONFIG_AIRO=y
# CONFIG_HERMES is not set
CONFIG_ATMEL=y
# CONFIG_PCI_ATMEL is not set
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_P54_COMMON=y
CONFIG_P54_USB=y
# CONFIG_P54_PCI is not set
# CONFIG_ATH5K is not set
CONFIG_ATH9K=y
CONFIG_IWLWIFI=y
CONFIG_IWLCORE=y
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=y
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=y
CONFIG_IWL3945_RFKILL=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
# CONFIG_IWL3945_DEBUG is not set
# CONFIG_HOSTAP is not set
CONFIG_B43=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_LEDS=y
CONFIG_B43_RFKILL=y
CONFIG_B43_DEBUG=y
# CONFIG_B43_FORCE_PIO is not set
# CONFIG_B43LEGACY is not set
CONFIG_ZD1211RW=y
CONFIG_ZD1211RW_DEBUG=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
# CONFIG_USB_NET_NET1080 is not set
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_HSO is not set
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
# CONFIG_ATM_ENI_BURST_RX_16W is not set
# CONFIG_ATM_ENI_BURST_RX_8W is not set
CONFIG_ATM_ENI_BURST_RX_4W=y
# CONFIG_ATM_ENI_BURST_RX_2W is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
CONFIG_ATM_HORIZON=y
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=y
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
# CONFIG_PPPOE is not set
CONFIG_PPPOATM=y
CONFIG_PPPOL2TP=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
# CONFIG_ISDN_AUDIO is not set

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
# CONFIG_HISAX_1TR6 is not set
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
# CONFIG_HISAX_SEDLBAUER is not set
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_GAZEL=y
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=y
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=y
CONFIG_HISAX_HDLC=y

#
# Active cards
#
CONFIG_ISDN_DRV_GIGASET=y
# CONFIG_GIGASET_BASE is not set
# CONFIG_GIGASET_M105 is not set
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
CONFIG_GIGASET_UNDOCREQ=y
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=y
CONFIG_ISDN_DIVAS_BRIPCI=y
# CONFIG_ISDN_DIVAS_PRIPCI is not set
CONFIG_ISDN_DIVAS_DIVACAPI=y
CONFIG_ISDN_DIVAS_USERIDI=y
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
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
# CONFIG_CONSOLE_TRANSLATIONS is not set
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
# CONFIG_AT24 is not set
CONFIG_SENSORS_EEPROM=y
CONFIG_SENSORS_PCF8591=y
CONFIG_TPS65010=y
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_LM70_LLP is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=y
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
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
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCF857X=y

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
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=y
CONFIG_SENSORS_FSCPOS=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_WM8400 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_BQ24022=y
# CONFIG_REGULATOR_DA903X is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_IR=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
CONFIG_VIDEO_IR_I2C=y

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TDA9875=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_M52790=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# Video decoders
#
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_TCM825X=y
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA7111 is not set
# CONFIG_VIDEO_SAA7114 is not set
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y
CONFIG_VIDEO_VIVI=y
CONFIG_VIDEO_BT848=y
# CONFIG_VIDEO_BT848_DVB is not set
CONFIG_VIDEO_SAA6588=y
# CONFIG_VIDEO_BWQCAM is not set
CONFIG_VIDEO_CQCAM=y
# CONFIG_VIDEO_W9966 is not set
CONFIG_VIDEO_CPIA=y
CONFIG_VIDEO_CPIA_PP=y
# CONFIG_VIDEO_CPIA_USB is not set
CONFIG_VIDEO_CPIA2=y
# CONFIG_VIDEO_SAA5246A is not set
CONFIG_VIDEO_SAA5249=y
CONFIG_VIDEO_STRADIS=y
# CONFIG_VIDEO_ZORAN is not set
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
CONFIG_VIDEO_SAA7134_DVB=y
# CONFIG_VIDEO_MXB is not set
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
CONFIG_VIDEO_IVTV=y
# CONFIG_VIDEO_CX18 is not set
CONFIG_VIDEO_CAFE_CCIC=y
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_USB_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
CONFIG_RADIO_MAXIRADIO=y
CONFIG_RADIO_MAESTRO=y
CONFIG_USB_DSBR=y
CONFIG_USB_SI470X=y
CONFIG_USB_MR800=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_AV7110=y
# CONFIG_DVB_AV7110_OSD is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_DVB_SIANO_SMS1XXX=y
# CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=y

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_DRX397XD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_TDA10048=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
# CONFIG_DVB_S5H1411 is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
# CONFIG_DVB_LGS8GL5 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y
# CONFIG_DVB_AF9013 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
# CONFIG_AGP_VIA is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set

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
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_PCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
CONFIG_SND_USB_US122L=y
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_SSCAPE=y
CONFIG_SOUND_VMIDI=y
# CONFIG_SOUND_TRIX is not set
# CONFIG_SOUND_MSS is not set
CONFIG_SOUND_MPU401=y
# CONFIG_SOUND_PAS is not set
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
# CONFIG_SOUND_AEDSP16 is not set
# CONFIG_SOUND_KAHLUA is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_APPLE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_DPCM is not set
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP2101=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_SPCP8X5=y
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_TI=y
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_WLP=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_DA903X=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_IPATH is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_MLX4_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_ISER is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_V3020=y

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
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_SMX=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_STAGING_EXCLUDE_BUILD=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_OCFS2_COMPAT_JBD=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_CRAMFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_ROMFS_FS=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V3 is not set
CONFIG_NFS_V4=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_SUNRPC_REGISTER_V4=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=y
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_BACKTRACE_SELF_TEST=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_BOOT_TRACER is not set
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_PRINTK_DEBUG=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_MMIOTRACE=y
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
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
CONFIG_SECURITY_SELINUX_DISABLE=y
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
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
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_64=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y

--TB36FDmn/VVEgNH/--
