Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYJWOdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYJWOdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYJWOc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:32:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbYJWOcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:32:52 -0400
Date: Thu, 23 Oct 2008 16:32:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct
	cpumask
Message-ID: <20081023143213.GA24830@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu> <490088BD.1060606@sgi.com> <20081023142842.GC22088@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023142842.GC22088@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i've attached the config that will build and boot with the 
> tip/cpus4096-v2 branch.
> 
> (I'm now double-checking whether it reproduces those slab corruption 
> messages.)

yes, it still does that slab corruption message, see the bootlog below.

	Ingo

[    0.000000] BIOS EBDA/lowmem at: 0009f800/0009f800
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-06574-g8c86407 (mingo@dione) (gcc version 4.2.3) #45103 SMP Thu Oct 23 16:24:51 CEST 2008
[    0.000000] Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=2 idle=poll panic=1
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
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] using polling idle threads.
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 233e000-2540000
[    0.000000] last_map_addr: 3fff0000 end: 3fff0000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000003fff0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [0000000000008000 - 000000000003cfff]
[    0.000000]   bootmap [000000000003d000 -  0000000000044fff] pages 8
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000233d950]    TEXT DATA BSS ==> [0000200000 - 000233d950]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [000233e000 - 000253e000]          PGTABLE ==> [000233e000 - 000253e000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f5680] 000f5680
[    0.000000]  [ffffe20000000000-ffffe200017fffff] PMD -> [ffff880002800000-ffff880003ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262031
[    0.000000]   DMA zone: 96 pages used for memmap
[    0.000000]   DMA zone: 101 pages reserved
[    0.000000]   DMA zone: 3802 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6048 pages used for memmap
[    0.000000]   DMA32 zone: 251984 pages, LIFO batch:31
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
[    0.000000] PERCPU: Allocating 1646592 bytes of per cpu data
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] per cpu data for cpu0 on node0 at 0000000002642000
[    0.000000] per cpu data for cpu1 on node0 at 0000000004000000
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255786
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=2 idle=poll panic=1
[    0.000000] debug: sysrq always enabled.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.301 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:           4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 4095 kB
[    0.004000]  per task-struct memory footprint: 2688 bytes
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 20000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] Memory: 983380k/1048512k available (6008k kernel code, 64744k reserved, 8753k data, 2096k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004016] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.60 BogoMIPS (lpj=8041204)
[    0.012147] Security Framework initialized
[    0.016024] SELinux:  Initializing.
[    0.020108] SELinux:  Starting in permissive mode
[    0.024562] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.028916] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.032375] Mount-cache hash table entries: 256
[    0.040538] Initializing cgroup subsys debug
[    0.044006] Initializing cgroup subsys devices
[    0.048007] Initializing cgroup subsys freezer
[    0.052030] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.056005] CPU: L2 Cache: 512K (64 bytes/line)
[    0.060005] CPU 0/0x0 -> Node 0
[    0.064005] tseg: 0000000000
[    0.066871] CPU: Physical Processor ID: 0
[    0.068004] CPU: Processor Core ID: 0
[    0.072010] numa_add_cpu cpu 0 node 0: mask now 0
[    0.076037] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.080014] ftrace: allocating 16064 hash entries in 126 pages
[    0.104309] Setting APIC routing to flat
[    0.108009] enabled ExtINT on CPU#0
[    0.112065] ExtINT not setup in hardware but reported by MP table
[    0.116115] ENABLING IO-APIC IRQs
[    0.120004] init IO_APIC IRQs
[    0.124005]  2-0 (apicid-pin) not connected
[    0.128016] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.132012] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.136011] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
[    0.140000] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
[    0.140000] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
[    0.140000] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.140000] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.140000]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.140000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.140000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.140000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.140000] ..... (found apic 0 pin 0) ...
[    0.183561] ....... works.
[    0.184003] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.192004] Using local APIC timer interrupts.
[    0.192004] calibrating APIC timer ...
[    0.200000] ... lapic delta = 1256518
[    0.200000] ..... delta 1256518
[    0.200000] ..... mult: 53963664
[    0.200000] ..... calibration result: 804171
[    0.200000] ..... CPU clock speed is 2010.1718 MHz.
[    0.200000] ..... host bus clock speed is 201.0171 MHz.
[    0.200000] ... verify APIC timer
[    0.311432] ... jiffies delta = 25
[    0.312003] ... jiffies result ok
[    0.316023] calling  migration_init+0x0/0x60 @ 1
[    0.320167] initcall migration_init+0x0/0x60 returned 1 after 0 usecs
[    0.324005] initcall migration_init+0x0/0x60 returned with error code 1 
[    0.328005] calling  spawn_ksoftirqd+0x0/0x60 @ 1
[    0.332087] initcall spawn_ksoftirqd+0x0/0x60 returned 0 after 0 usecs
[    0.336008] calling  init_call_single_data+0x0/0x80 @ 1
[    0.340006] initcall init_call_single_data+0x0/0x80 returned 0 after 0 usecs
[    0.344005] calling  spawn_softlockup_task+0x0/0x80 @ 1
[    0.348071] initcall spawn_softlockup_task+0x0/0x80 returned 0 after 0 usecs
[    0.352005] calling  relay_init+0x0/0x20 @ 1
[    0.356008] initcall relay_init+0x0/0x20 returned 0 after 0 usecs
[    0.360004] calling  tracer_alloc_buffers+0x0/0x1f0 @ 1
[    0.370658] Testing tracer nop: PASSED
[    0.372703] initcall tracer_alloc_buffers+0x0/0x1f0 returned 0 after 7812 usecs
[    0.376394] lockdep: fixing up alternatives.
[    0.380146] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4020.87 BogoMIPS (lpj=8041750)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.476391] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.488041] Brought up 2 CPUs
[    0.490944] Total of 2 processors activated (8041.47 BogoMIPS).
[    0.492070] Testing NMI watchdog ... OK.
[    0.576156] CPU0 attaching sched-domain:
[    0.580007]  domain 0: span 0-1 level CPU
[    0.584003]   groups: 0 1
[    0.586595]   domain 1: span 0-1 level NODE
[    0.589815]    groups: 0-1
[    0.592541] CPU1 attaching sched-domain:
[    0.596010]  domain 0: span 0-1 level CPU
[    0.600003]   groups: 1 0
[    0.604003]   domain 1: span 0-1 level NODE
[    0.608015]    groups: 0-1
[    0.610691] =============================================================================
[    0.612000] BUG kmalloc-8: Wrong object count. Counter is 15 but counted were 50
[    0.612000] -----------------------------------------------------------------------------
[    0.612000] 
[    0.612000] INFO: Slab 0xffffe200017dac80 objects=51 used=15 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
[    0.612000] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    0.612000] Call Trace:
[    0.612000]  [<ffffffff802ca480>] slab_err+0xa0/0xb0
[    0.612000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.612000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.612000]  [<ffffffff8023aef2>] ? cpu_attach_domain+0x172/0x6b0
[    0.612000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.612000]  [<ffffffff802ccb97>] on_freelist+0x197/0x240
[    0.612000]  [<ffffffff802cd8a6>] __slab_free+0x1a6/0x310
[    0.612000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.612000]  [<ffffffff802cdac7>] kfree+0xb7/0x140
[    0.612000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.612000]  [<ffffffff80412ad9>] free_cpumask_var+0x9/0x10
[    0.612000]  [<ffffffff8023b8cc>] __build_sched_domains+0x49c/0xd30
[    0.612000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.612000]  [<ffffffff81659afa>] sched_init_smp+0xba/0x2b0
[    0.612000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.612000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.612000]  [<ffffffff802ca9b8>] ? check_object+0x238/0x270
[    0.612000]  [<ffffffff802caa44>] ? init_object+0x54/0x90
[    0.612000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.612000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.612000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.612000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.612000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.612000]  [<ffffffff8164fb76>] ? native_smp_cpus_done+0x1a6/0x2b0
[    0.612000]  [<ffffffff81644f16>] kernel_init+0x176/0x240
[    0.612000]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    0.612000]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    0.612000]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    0.612000]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    0.612000] FIX kmalloc-8: Object count adjusted.
[    0.612000] =============================================================================
[    0.612000] BUG kmalloc-8: Redzone overwritten
[    0.612000] -----------------------------------------------------------------------------
[    0.612000] 
[    0.612000] INFO: 0xffff88003f9cc418-0xffff88003f9cc41f. First byte 0x0 instead of 0xcc
[    0.612000] INFO: Slab 0xffffe200017dac80 objects=51 used=50 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
[    0.612000] INFO: Object 0xffff88003f9cc410 @offset=1040 fp=0x0000000000000000
[    0.612000] 
[    0.612000] Bytes b4 0xffff88003f9cc400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.612000]   Object 0xffff88003f9cc410:  00 00 00 00 00 00 00 00                         ........        
[    0.612000]  Redzone 0xffff88003f9cc418:  00 00 00 00 00 00 00 00                         ........        
[    0.612000]  Padding 0xffff88003f9cc458:  00 00 00 00 00 00 00 00                         ........        
[    0.612000] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    0.612000] Call Trace:
[    0.612000]  [<ffffffff802ca58c>] print_trailer+0xfc/0x160
[    0.612000]  [<ffffffff802ca758>] check_bytes_and_report+0xb8/0xe0
[    0.612000]  [<ffffffff802ca7ea>] check_object+0x6a/0x270
[    0.612000]  [<ffffffff802cd908>] __slab_free+0x208/0x310
[    0.612000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.612000]  [<ffffffff802cdac7>] kfree+0xb7/0x140
[    0.612000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.612000]  [<ffffffff80412ad9>] free_cpumask_var+0x9/0x10
[    0.612000]  [<ffffffff8023b8cc>] __build_sched_domains+0x49c/0xd30
[    0.612000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.612000]  [<ffffffff81659afa>] sched_init_smp+0xba/0x2b0
[    0.612000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.612000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.612000]  [<ffffffff802ca9b8>] ? check_object+0x238/0x270
[    0.612000]  [<ffffffff802caa44>] ? init_object+0x54/0x90
[    0.612000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.612000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.612000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.612000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.612000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.612000]  [<ffffffff8164fb76>] ? native_smp_cpus_done+0x1a6/0x2b0
[    0.612000]  [<ffffffff81644f16>] kernel_init+0x176/0x240
[    0.612000]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    0.612000]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    0.612000]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    0.612000]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    0.612000] FIX kmalloc-8: Restoring 0xffff88003f9cc418-0xffff88003f9cc41f=0xcc
[    0.612000] 
[    0.612004] =============================================================================
[    0.616000] BUG kmalloc-8: Redzone overwritten
[    0.616000] -----------------------------------------------------------------------------
[    0.616000] 
[    0.616000] INFO: 0xffff88003f9cc3c8-0xffff88003f9cc3cf. First byte 0x0 instead of 0xcc
[    0.616000] INFO: Slab 0xffffe200017dac80 objects=51 used=50 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
[    0.616000] INFO: Object 0xffff88003f9cc3c0 @offset=960 fp=0x0000000000000000
[    0.616000] 
[    0.616000] Bytes b4 0xffff88003f9cc3b0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.616000]   Object 0xffff88003f9cc3c0:  00 00 00 00 00 00 00 00                         ........        
[    0.616000]  Redzone 0xffff88003f9cc3c8:  00 00 00 00 00 00 00 00                         ........        
[    0.616000]  Padding 0xffff88003f9cc408:  00 00 00 00 00 00 00 00                         ........        
[    0.616000] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    0.616000] Call Trace:
[    0.616000]  [<ffffffff802ca58c>] print_trailer+0xfc/0x160
[    0.616000]  [<ffffffff802ca758>] check_bytes_and_report+0xb8/0xe0
[    0.616000]  [<ffffffff802ca7ea>] check_object+0x6a/0x270
[    0.616000]  [<ffffffff802cd908>] __slab_free+0x208/0x310
[    0.616000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.616000]  [<ffffffff802cdac7>] kfree+0xb7/0x140
[    0.616000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.616000]  [<ffffffff80412ad9>] free_cpumask_var+0x9/0x10
[    0.616000]  [<ffffffff8023b8d5>] __build_sched_domains+0x4a5/0xd30
[    0.616000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.616000]  [<ffffffff81659afa>] sched_init_smp+0xba/0x2b0
[    0.616000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.616000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.616000]  [<ffffffff802ca9b8>] ? check_object+0x238/0x270
[    0.616000]  [<ffffffff802caa44>] ? init_object+0x54/0x90
[    0.616000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.616000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.616000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.616000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.616000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.616000]  [<ffffffff8164fb76>] ? native_smp_cpus_done+0x1a6/0x2b0
[    0.616000]  [<ffffffff81644f16>] kernel_init+0x176/0x240
[    0.616000]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    0.616000]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    0.616000]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    0.616000]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    0.616000] FIX kmalloc-8: Restoring 0xffff88003f9cc3c8-0xffff88003f9cc3cf=0xcc
[    0.616000] 
[    0.616004] =============================================================================
[    0.620000] BUG kmalloc-8: Redzone overwritten
[    0.620000] -----------------------------------------------------------------------------
[    0.620000] 
[    0.620000] INFO: 0xffff88003f9cc378-0xffff88003f9cc37f. First byte 0x0 instead of 0xcc
[    0.620000] INFO: Slab 0xffffe200017dac80 objects=51 used=50 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
[    0.620000] INFO: Object 0xffff88003f9cc370 @offset=880 fp=0x0000000000000000
[    0.620000] 
[    0.620000] Bytes b4 0xffff88003f9cc360:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.620000]   Object 0xffff88003f9cc370:  00 00 00 00 00 00 00 00                         ........        
[    0.620000]  Redzone 0xffff88003f9cc378:  00 00 00 00 00 00 00 00                         ........        
[    0.620000]  Padding 0xffff88003f9cc3b8:  00 00 00 00 00 00 00 00                         ........        
[    0.620000] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    0.620000] Call Trace:
[    0.620000]  [<ffffffff802ca58c>] print_trailer+0xfc/0x160
[    0.620000]  [<ffffffff802ca758>] check_bytes_and_report+0xb8/0xe0
[    0.620000]  [<ffffffff802ca7ea>] check_object+0x6a/0x270
[    0.620000]  [<ffffffff802cd908>] __slab_free+0x208/0x310
[    0.620000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.620000]  [<ffffffff802cdac7>] kfree+0xb7/0x140
[    0.620000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.620000]  [<ffffffff80412ad9>] free_cpumask_var+0x9/0x10
[    0.620000]  [<ffffffff8023b53d>] __build_sched_domains+0x10d/0xd30
[    0.620000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.620000]  [<ffffffff81659afa>] sched_init_smp+0xba/0x2b0
[    0.620000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.620000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.620000]  [<ffffffff802ca9b8>] ? check_object+0x238/0x270
[    0.620000]  [<ffffffff802caa44>] ? init_object+0x54/0x90
[    0.620000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.620000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.620000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.620000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.620000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.620000]  [<ffffffff8164fb76>] ? native_smp_cpus_done+0x1a6/0x2b0
[    0.620000]  [<ffffffff81644f16>] kernel_init+0x176/0x240
[    0.620000]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    0.620000]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    0.620000]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    0.620000]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    0.620000] FIX kmalloc-8: Restoring 0xffff88003f9cc378-0xffff88003f9cc37f=0xcc
[    0.620000] 
[    0.620004] =============================================================================
[    0.624000] BUG kmalloc-8: Redzone overwritten
[    0.624000] -----------------------------------------------------------------------------
[    0.624000] 
[    0.624000] INFO: 0xffff88003f9cc328-0xffff88003f9cc32f. First byte 0x0 instead of 0xcc
[    0.624000] INFO: Slab 0xffffe200017dac80 objects=51 used=50 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
[    0.624000] INFO: Object 0xffff88003f9cc320 @offset=800 fp=0x0000000000000000
[    0.624000] 
[    0.624000] Bytes b4 0xffff88003f9cc310:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.624000]   Object 0xffff88003f9cc320:  00 00 00 00 00 00 00 00                         ........        
[    0.624000]  Redzone 0xffff88003f9cc328:  00 00 00 00 00 00 00 00                         ........        
[    0.624000]  Padding 0xffff88003f9cc368:  00 00 00 00 00 00 00 00                         ........        
[    0.624000] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    0.624000] Call Trace:
[    0.624000]  [<ffffffff802ca58c>] print_trailer+0xfc/0x160
[    0.624000]  [<ffffffff802ca758>] check_bytes_and_report+0xb8/0xe0
[    0.624000]  [<ffffffff802ca7ea>] check_object+0x6a/0x270
[    0.624000]  [<ffffffff802cd908>] __slab_free+0x208/0x310
[    0.624000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.624000]  [<ffffffff802cdac7>] kfree+0xb7/0x140
[    0.624000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.624000]  [<ffffffff80412ad9>] free_cpumask_var+0x9/0x10
[    0.624000]  [<ffffffff8023b51d>] __build_sched_domains+0xed/0xd30
[    0.624000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.624000]  [<ffffffff81659afa>] sched_init_smp+0xba/0x2b0
[    0.624000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.624000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.624000]  [<ffffffff802ca9b8>] ? check_object+0x238/0x270
[    0.624000]  [<ffffffff802caa44>] ? init_object+0x54/0x90
[    0.624000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.624000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.624000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.624000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.624000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.624000]  [<ffffffff8164fb76>] ? native_smp_cpus_done+0x1a6/0x2b0
[    0.624000]  [<ffffffff81644f16>] kernel_init+0x176/0x240
[    0.624000]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    0.624000]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    0.624000]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    0.624000]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    0.624000] FIX kmalloc-8: Restoring 0xffff88003f9cc328-0xffff88003f9cc32f=0xcc
[    0.624000] 
[    0.624004] =============================================================================
[    0.628000] BUG kmalloc-8: Redzone overwritten
[    0.628000] -----------------------------------------------------------------------------
[    0.628000] 
[    0.628000] INFO: 0xffff88003f9cc2d8-0xffff88003f9cc2df. First byte 0x0 instead of 0xcc
[    0.628000] INFO: Slab 0xffffe200017dac80 objects=51 used=50 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
[    0.628000] INFO: Object 0xffff88003f9cc2d0 @offset=720 fp=0x0000000000000000
[    0.628000] 
[    0.628000] Bytes b4 0xffff88003f9cc2c0:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[    0.628000]   Object 0xffff88003f9cc2d0:  03 00 00 00 00 00 00 00                         ........        
[    0.628000]  Redzone 0xffff88003f9cc2d8:  00 00 00 00 00 00 00 00                         ........        
[    0.628000]  Padding 0xffff88003f9cc318:  00 00 00 00 00 00 00 00                         ........        
[    0.628000] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    0.628000] Call Trace:
[    0.628000]  [<ffffffff802ca58c>] print_trailer+0xfc/0x160
[    0.628000]  [<ffffffff802ca758>] check_bytes_and_report+0xb8/0xe0
[    0.628000]  [<ffffffff802ca7ea>] check_object+0x6a/0x270
[    0.628000]  [<ffffffff802cd908>] __slab_free+0x208/0x310
[    0.628000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.628000]  [<ffffffff802cdac7>] kfree+0xb7/0x140
[    0.628000]  [<ffffffff80412ad9>] ? free_cpumask_var+0x9/0x10
[    0.628000]  [<ffffffff80412ad9>] free_cpumask_var+0x9/0x10
[    0.628000]  [<ffffffff8023b4fd>] __build_sched_domains+0xcd/0xd30
[    0.628000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.628000]  [<ffffffff81659afa>] sched_init_smp+0xba/0x2b0
[    0.628000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.628000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.628000]  [<ffffffff802ca9b8>] ? check_object+0x238/0x270
[    0.628000]  [<ffffffff802caa44>] ? init_object+0x54/0x90
[    0.628000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.628000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.628000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.628000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.628000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.628000]  [<ffffffff8164fb76>] ? native_smp_cpus_done+0x1a6/0x2b0
[    0.628000]  [<ffffffff81644f16>] kernel_init+0x176/0x240
[    0.628000]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    0.628000]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    0.628000]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    0.628000]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    0.628000] FIX kmalloc-8: Restoring 0xffff88003f9cc2d8-0xffff88003f9cc2df=0xcc
[    0.628000] 
[    0.628025] =============================================================================
[    0.632000] BUG kmalloc-8: Redzone overwritten
[    0.632000] -----------------------------------------------------------------------------
[    0.632000] 
[    0.632000] INFO: 0xffff88003f9cc4b8-0xffff88003f9cc4bf. First byte 0x0 instead of 0xbb
[    0.632000] INFO: Slab 0xffffe200017dac80 objects=51 used=50 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
[    0.632000] INFO: Object 0xffff88003f9cc4b0 @offset=1200 fp=0x0000000000000000
[    0.632000] 
[    0.632000] Bytes b4 0xffff88003f9cc4a0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.632000]   Object 0xffff88003f9cc4b0:  00 00 00 00 00 00 00 00                         ........        
[    0.632000]  Redzone 0xffff88003f9cc4b8:  00 00 00 00 00 00 00 00                         ........        
[    0.632000]  Padding 0xffff88003f9cc4f8:  00 00 00 00 00 00 00 00                         ........        
[    0.632000] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    0.632000] Call Trace:
[    0.632000]  [<ffffffff802ca58c>] print_trailer+0xfc/0x160
[    0.632000]  [<ffffffff802ca758>] check_bytes_and_report+0xb8/0xe0
[    0.632000]  [<ffffffff802ca7ea>] check_object+0x6a/0x270
[    0.632000]  [<ffffffff802cd2bc>] __slab_alloc+0x37c/0x440
[    0.632000]  [<ffffffff8023985e>] ? register_sched_domain_sysctl+0xce/0x470
[    0.632000]  [<ffffffff8026ca2a>] ? mark_held_locks+0x8a/0xb0
[    0.632000]  [<ffffffff8023923a>] ? sd_alloc_ctl_entry+0x2a/0x40
[    0.632000]  [<ffffffff8023985e>] ? register_sched_domain_sysctl+0xce/0x470
[    0.632000]  [<ffffffff802ce7e6>] __kmalloc_track_caller+0x106/0x110
[    0.632000]  [<ffffffff802b1cc5>] kstrdup+0x45/0x120
[    0.632000]  [<ffffffff8023985e>] register_sched_domain_sysctl+0xce/0x470
[    0.632000]  [<ffffffff81659aff>] sched_init_smp+0xbf/0x2b0
[    0.632000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.632000]  [<ffffffff802ca6dd>] ? check_bytes_and_report+0x3d/0xe0
[    0.632000]  [<ffffffff802ca9b8>] ? check_object+0x238/0x270
[    0.632000]  [<ffffffff802caa44>] ? init_object+0x54/0x90
[    0.632000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.632000]  [<ffffffff8026cbbf>] ? trace_hardirqs_on_caller+0xcf/0x160
[    0.632000]  [<ffffffff8026cc5d>] ? trace_hardirqs_on+0xd/0x10
[    0.632000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.632000]  [<ffffffff81652384>] ? check_nmi_watchdog+0x204/0x260
[    0.632000]  [<ffffffff8164fb76>] ? native_smp_cpus_done+0x1a6/0x2b0
[    0.632000]  [<ffffffff81644f16>] kernel_init+0x176/0x240
[    0.632000]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    0.632000]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    0.632000]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    0.632000]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    0.632000] FIX kmalloc-8: Restoring 0xffff88003f9cc4b8-0xffff88003f9cc4bf=0xbb
[    0.632000] 
[    0.632000] FIX kmalloc-8: Marking all objects used
[    0.638221] calling  init_cpufreq_transition_notifier_list+0x0/0x20 @ 1
[    0.640021] initcall init_cpufreq_transition_notifier_list+0x0/0x20 returned 0 after 0 usecs
[    0.644005] calling  net_ns_init+0x0/0x180 @ 1
[    0.648003] net_namespace: 1416 bytes
[    0.652037] initcall net_ns_init+0x0/0x180 returned 0 after 3906 usecs
[    0.656006] calling  cpufreq_tsc+0x0/0x40 @ 1
[    0.660005] initcall cpufreq_tsc+0x0/0x40 returned 0 after 0 usecs
[    0.664006] calling  init_smp_flush+0x0/0x80 @ 1
[    0.668005] initcall init_smp_flush+0x0/0x80 returned 0 after 0 usecs
[    0.672011] calling  sysctl_init+0x0/0x40 @ 1
[    0.676254] initcall sysctl_init+0x0/0x40 returned 0 after 0 usecs
[    0.680005] calling  ksysfs_init+0x0/0xc0 @ 1
[    0.684215] initcall ksysfs_init+0x0/0xc0 returned 0 after 0 usecs
[    0.688007] calling  init_jiffies_clocksource+0x0/0x20 @ 1
[    0.692045] initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 usecs
[    0.696005] calling  filelock_init+0x0/0x30 @ 1
[    0.700018] initcall filelock_init+0x0/0x30 returned 0 after 0 usecs
[    0.704004] calling  init_misc_binfmt+0x0/0x50 @ 1
[    0.708020] initcall init_misc_binfmt+0x0/0x50 returned 0 after 0 usecs
[    0.712004] calling  init_script_binfmt+0x0/0x20 @ 1
[    0.716005] initcall init_script_binfmt+0x0/0x20 returned 0 after 0 usecs
[    0.720004] calling  init_elf_binfmt+0x0/0x20 @ 1
[    0.724005] initcall init_elf_binfmt+0x0/0x20 returned 0 after 0 usecs
[    0.728004] calling  init_compat_elf_binfmt+0x0/0x20 @ 1
[    0.732005] initcall init_compat_elf_binfmt+0x0/0x20 returned 0 after 0 usecs
[    0.736006] calling  debugfs_init+0x0/0x60 @ 1
[    0.740013] initcall debugfs_init+0x0/0x60 returned 0 after 0 usecs
[    0.744004] calling  securityfs_init+0x0/0x60 @ 1
[    0.748012] initcall securityfs_init+0x0/0x60 returned 0 after 0 usecs
[    0.752005] calling  random32_init+0x0/0x100 @ 1
[    0.756005] initcall random32_init+0x0/0x100 returned 0 after 0 usecs
[    0.760004] calling  cpufreq_core_init+0x0/0x90 @ 1
[    0.764005] initcall cpufreq_core_init+0x0/0x90 returned 0 after 0 usecs
[    0.768011] calling  cpuidle_init+0x0/0x50 @ 1
[    0.772017] initcall cpuidle_init+0x0/0x50 returned 0 after 0 usecs
[    0.776004] calling  sock_init+0x0/0x60 @ 1
[    0.780202] initcall sock_init+0x0/0x60 returned 0 after 0 usecs
[    0.784005] calling  netpoll_init+0x0/0x50 @ 1
[    0.788004] initcall netpoll_init+0x0/0x50 returned 0 after 0 usecs
[    0.792004] calling  netlink_proto_init+0x0/0x180 @ 1
[    0.796070] NET: Registered protocol family 16
[    0.800087] initcall netlink_proto_init+0x0/0x180 returned 0 after 3906 usecs
[    0.804005] calling  bdi_class_init+0x0/0x50 @ 1
[    0.808397] initcall bdi_class_init+0x0/0x50 returned 0 after 0 usecs
[    0.812007] calling  kobject_uevent_init+0x0/0x50 @ 1
[    0.816061] initcall kobject_uevent_init+0x0/0x50 returned 0 after 0 usecs
[    0.820005] calling  pcibus_class_init+0x0/0x20 @ 1
[    0.824120] initcall pcibus_class_init+0x0/0x20 returned 0 after 0 usecs
[    0.828025] calling  pci_driver_init+0x0/0x20 @ 1
[    0.836762] initcall pci_driver_init+0x0/0x20 returned 0 after 0 usecs
[    0.840006] calling  lcd_class_init+0x0/0x50 @ 1
[    0.844105] initcall lcd_class_init+0x0/0x50 returned 0 after 0 usecs
[    0.852007] calling  backlight_class_init+0x0/0x50 @ 1
[    0.859555] initcall backlight_class_init+0x0/0x50 returned 0 after 0 usecs
[    0.860007] calling  tty_class_init+0x0/0x40 @ 1
[    0.864107] initcall tty_class_init+0x0/0x40 returned 0 after 0 usecs
[    0.872006] calling  vtconsole_class_init+0x0/0xf0 @ 1
[    0.879054] initcall vtconsole_class_init+0x0/0xf0 returned 0 after 0 usecs
[    0.880007] calling  register_node_type+0x0/0x70 @ 1
[    0.884192] initcall register_node_type+0x0/0x70 returned 0 after 0 usecs
[    0.888006] calling  spi_init+0x0/0x90 @ 1
[    0.892131] initcall spi_init+0x0/0x90 returned 0 after 0 usecs
[    0.896007] calling  amd_postcore_init+0x0/0x8b0 @ 1
[    0.904025] node 0 link 0: io port [1000, fffff]
[    0.908005] TOM: 0000000040000000 aka 1024M
[    0.912004] node 0 link 0: mmio [e0000000, efffffff]
[    0.916173] node 0 link 0: mmio [feb00000, fec0ffff]
[    0.920173] node 0 link 0: mmio [a0000, bffff]
[    0.924173] node 0 link 0: mmio [40000000, fed3ffff]
[    0.932173] bus: [00,ff] on node 0 link 0
[    0.936004] bus: 00 index 0 io port: [0, ffff]
[    0.940004] bus: 00 index 1 mmio: [40000000, fcffffffff]
[    0.944004] bus: 00 index 2 mmio: [feb00000, fec0ffff]
[    0.948004] bus: 00 index 3 mmio: [a0000, bffff]
[    0.956005] initcall amd_postcore_init+0x0/0x8b0 returned 0 after 50781 usecs
[    0.960007] calling  arch_kdebugfs_init+0x0/0x1e0 @ 1
[    0.968085] initcall arch_kdebugfs_init+0x0/0x1e0 returned 0 after 0 usecs
[    0.972006] calling  mtrr_if_init+0x0/0x80 @ 1
[    0.976024] initcall mtrr_if_init+0x0/0x80 returned 0 after 0 usecs
[    0.984005] calling  pci_arch_init+0x0/0x50 @ 1
[    0.988455] PCI: Using configuration type 1 for base access
[    0.996005] initcall pci_arch_init+0x0/0x50 returned 0 after 7812 usecs
[    1.000005] calling  topology_init+0x0/0x90 @ 1
[    1.007938] initcall topology_init+0x0/0x90 returned 0 after 0 usecs
[    1.008008] calling  mtrr_init_finialize+0x0/0x50 @ 1
[    1.012005] initcall mtrr_init_finialize+0x0/0x50 returned 0 after 0 usecs
[    1.016005] calling  param_sysfs_init+0x0/0x240 @ 1
[    1.042760] initcall param_sysfs_init+0x0/0x240 returned 0 after 19531 usecs
[    1.048414] calling  readahead_init+0x0/0x40 @ 1
[    1.055825] initcall readahead_init+0x0/0x40 returned 0 after 0 usecs
[    1.056008] calling  init_bio+0x0/0x100 @ 1
[    1.060628] initcall init_bio+0x0/0x100 returned 0 after 0 usecs
[    1.064006] calling  integrity_init+0x0/0x40 @ 1
[    1.068031] initcall integrity_init+0x0/0x40 returned 0 after 0 usecs
[    1.072006] calling  cryptomgr_init+0x0/0x40 @ 1
[    1.080028] initcall cryptomgr_init+0x0/0x40 returned 0 after 0 usecs
[    1.084005] calling  blk_settings_init+0x0/0x30 @ 1
[    1.088005] initcall blk_settings_init+0x0/0x30 returned 0 after 0 usecs
[    1.096004] calling  blk_ioc_init+0x0/0x30 @ 1
[    1.100023] initcall blk_ioc_init+0x0/0x30 returned 0 after 0 usecs
[    1.108005] calling  blk_softirq_init+0x0/0x80 @ 1
[    1.112007] initcall blk_softirq_init+0x0/0x80 returned 0 after 0 usecs
[    1.120004] calling  genhd_device_init+0x0/0x60 @ 1
[    1.125496] initcall genhd_device_init+0x0/0x60 returned 0 after 0 usecs
[    1.128006] calling  blk_dev_integrity_init+0x0/0x30 @ 1
[    1.132014] initcall blk_dev_integrity_init+0x0/0x30 returned 0 after 0 usecs
[    1.136007] calling  pci_slot_init+0x0/0x50 @ 1
[    1.140021] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    1.144004] calling  misc_init+0x0/0xb0 @ 1
[    1.148264] initcall misc_init+0x0/0xb0 returned 0 after 0 usecs
[    1.152008] calling  cn_init+0x0/0x100 @ 1
[    1.156085] initcall cn_init+0x0/0x100 returned 0 after 0 usecs
[    1.160027] calling  phy_init+0x0/0x40 @ 1
[    1.168239] initcall phy_init+0x0/0x40 returned 0 after 3906 usecs
[    1.172005] calling  init_scsi+0x0/0xb0 @ 1
[    1.179477] SCSI subsystem initialized
[    1.180028] initcall init_scsi+0x0/0xb0 returned 0 after 3906 usecs
[    1.184005] calling  ata_init+0x0/0x3c0 @ 1
[    1.188026] libata version 3.00 loaded.
[    1.192006] initcall ata_init+0x0/0x3c0 returned 0 after 3906 usecs
[    1.196005] calling  usb_init+0x0/0xf0 @ 1
[    1.204319] usbcore: registered new interface driver usbfs
[    1.210092] usbcore: registered new interface driver hub
[    1.212283] usbcore: registered new device driver usb
[    1.220006] initcall usb_init+0x0/0xf0 returned 0 after 19531 usecs
[    1.224005] calling  serio_init+0x0/0xb0 @ 1
[    1.231256] initcall serio_init+0x0/0xb0 returned 0 after 0 usecs
[    1.232064] calling  gameport_init+0x0/0xb0 @ 1
[    1.236293] initcall gameport_init+0x0/0xb0 returned 0 after 0 usecs
[    1.240007] calling  input_init+0x0/0x130 @ 1
[    1.244132] initcall input_init+0x0/0x130 returned 0 after 0 usecs
[    1.248034] calling  hwmon_init+0x0/0x50 @ 1
[    1.255296] initcall hwmon_init+0x0/0x50 returned 0 after 0 usecs
[    1.256007] calling  md_init+0x0/0xe0 @ 1
[    1.260065] initcall md_init+0x0/0xe0 returned 0 after 0 usecs
[    1.264004] calling  pci_subsys_init+0x0/0x130 @ 1
[    1.268003] PCI: Probing PCI hardware
[    1.272033] PCI: Probing PCI hardware (bus 00)
[    1.280358] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.284075] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    1.288027] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    1.292010] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    1.296020] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.300007] pci 0000:00:01.1: PME# disabled
[    1.304068] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    1.308049] pci 0000:00:02.0: supports D1 D2
[    1.312004] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.316006] pci 0000:00:02.0: PME# disabled
[    1.320067] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    1.324052] pci 0000:00:02.1: supports D1 D2
[    1.328004] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.332007] pci 0000:00:02.1: PME# disabled
[    1.336094] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    1.340010] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    1.344010] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    1.348037] pci 0000:00:04.0: supports D1 D2
[    1.352080] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    1.356129] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    1.360010] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    1.364042] pci 0000:00:0a.0: supports D1 D2
[    1.368004] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.372006] pci 0000:00:0a.0: PME# disabled
[    1.376081] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.380006] pci 0000:00:0b.0: PME# disabled
[    1.384104] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.388006] pci 0000:00:0c.0: PME# disabled
[    1.392103] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.396006] pci 0000:00:0d.0: PME# disabled
[    1.400126] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.404006] pci 0000:00:0e.0: PME# disabled
[    1.412425] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    1.416011] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    1.420049] pci 0000:05:07.0: supports D1 D2
[    1.424004] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.428007] pci 0000:05:07.0: PME# disabled
[    1.432056] pci 0000:00:09.0: transparent bridge
[    1.436007] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    1.440007] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    1.448149] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    1.452011] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    1.456011] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    1.460030] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.464015] pci 0000:01:00.0: supports D1 D2
[    1.468087] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    1.472054] pci 0000:01:00.1: supports D1 D2
[    1.476087] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    1.480006] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    1.484009] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    1.494439] pci 0000:00:00.0: default IRQ router [10de:005e]
[    1.500121] pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 3
[    1.504024] pci 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.508063] pci 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.512011] pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 5
[    1.516326] initcall pci_subsys_init+0x0/0x130 returned 0 after 242187 usecs
[    1.520005] calling  proto_init+0x0/0x30 @ 1
[    1.524015] initcall proto_init+0x0/0x30 returned 0 after 0 usecs
[    1.528005] calling  net_dev_init+0x0/0x180 @ 1
[    1.536141] initcall net_dev_init+0x0/0x180 returned 0 after 3906 usecs
[    1.540005] calling  neigh_init+0x0/0x80 @ 1
[    1.544005] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    1.548004] calling  fib_rules_init+0x0/0xb0 @ 1
[    1.552007] initcall fib_rules_init+0x0/0xb0 returned 0 after 0 usecs
[    1.556005] calling  pktsched_init+0x0/0xd0 @ 1
[    1.560036] initcall pktsched_init+0x0/0xd0 returned 0 after 0 usecs
[    1.564005] calling  tc_filter_init+0x0/0x50 @ 1
[    1.568005] initcall tc_filter_init+0x0/0x50 returned 0 after 0 usecs
[    1.572004] calling  genl_init+0x0/0xe0 @ 1
[    1.592051] initcall genl_init+0x0/0xe0 returned 0 after 15625 usecs
[    1.596005] calling  cipso_v4_init+0x0/0x90 @ 1
[    1.600026] initcall cipso_v4_init+0x0/0x90 returned 0 after 0 usecs
[    1.604005] calling  atm_init+0x0/0xd0 @ 1
[    1.608007] NET: Registered protocol family 8
[    1.612004] NET: Registered protocol family 20
[    1.616141] initcall atm_init+0x0/0xd0 returned 0 after 7812 usecs
[    1.624008] calling  wireless_nlevent_init+0x0/0x50 @ 1
[    1.628005] initcall wireless_nlevent_init+0x0/0x50 returned 0 after 0 usecs
[    1.636005] calling  netlbl_init+0x0/0x90 @ 1
[    1.640003] NetLabel: Initializing
[    1.643376] NetLabel:  domain hash size = 128
[    1.648003] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.652204] NetLabel:  unlabeled traffic allowed by default
[    1.656006] initcall netlbl_init+0x0/0x90 returned 0 after 15625 usecs
[    1.664005] calling  sysctl_init+0x0/0x4c @ 1
[    1.668009] initcall sysctl_init+0x0/0x4c returned 0 after 0 usecs
[    1.676006] calling  pci_iommu_init+0x0/0x20 @ 1
[    1.681435] initcall pci_iommu_init+0x0/0x20 returned 0 after 0 usecs
[    1.684007] calling  print_all_ICs+0x0/0x500 @ 1
[    1.688004] 
[    1.688004] printing PIC contents
[    1.692006] ... PIC  IMR: fffa
[    1.695031] ... PIC  IRR: 0001
[    1.692006] Clocksource tsc unstable (delta = 120298514 ns)
[    1.696003] ... PIC  ISR: 0001
[    1.699022] ... PIC ELCR: 0828
[    1.700005] 
[    1.700005] printing local APIC contents on CPU#0/0:
[    1.704000] ... APIC ID:      00000000 (0)
[    1.704000] ... APIC VERSION: 00040010
[    1.704000] ... APIC TASKPRI: 00000000 (00)
[    1.704000] ... APIC ARBPRI: 000000e0 (e0)
[    1.704000] ... APIC PROCPRI: 00000000
[    1.704000] ... APIC LDR: 01000000
[    1.704000] ... APIC DFR: ffffffff
[    1.704000] ... APIC SPIV: 000001ff
[    1.704000] ... APIC ISR field:
[    1.704000] 0123456789abcdef0123456789abcdef
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] ... APIC TMR field:
[    1.704000] 0123456789abcdef0123456789abcdef
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] ... APIC IRR field:
[    1.704000] 0123456789abcdef0123456789abcdef
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000010000000000000000
[    1.704000] ... APIC ESR: 00000000
[    1.704000] ... APIC ICR: 000008fb
[    1.704000] ... APIC ICR2: 02000000
[    1.704000] ... APIC LVTT: 000200ef
[    1.704000] ... APIC LVTPC: 00000400
[    1.704000] ... APIC LVT0: 00010700
[    1.704000] ... APIC LVT1: 00000400
[    1.704000] ... APIC LVTERR: 000000fe
[    1.704000] ... APIC TMICT: 0000c454
[    1.704000] ... APIC TMCCT: 00003143
[    1.704000] ... APIC TDCR: 00000003
[    1.704000] 
[    1.703997] 
[    1.703997] printing local APIC contents on CPU#1/1:
[    1.704000] ... APIC ID:      01000000 (1)
[    1.704000] ... APIC VERSION: 00040010
[    1.704000] ... APIC TASKPRI: 00000000 (00)
[    1.704000] ... APIC ARBPRI: 000000e0 (e0)
[    1.704000] ... APIC PROCPRI: 00000000
[    1.704000] ... APIC LDR: 02000000
[    1.704000] ... APIC DFR: ffffffff
[    1.704000] ... APIC SPIV: 000001ff
[    1.704000] ... APIC ISR field:
[    1.704000] 0123456789abcdef0123456789abcdef
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] ... APIC TMR field:
[    1.704000] 0123456789abcdef0123456789abcdef
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] ... APIC IRR field:
[    1.704000] 0123456789abcdef0123456789abcdef
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000000000000000000000
[    1.704000] 00000000000000010000000000000000
[    1.704000] ... APIC ESR: 00000000
[    1.704000] ... APIC ICR: 00000000
[    1.704000] ... APIC ICR2: 00000000
[    1.704000] ... APIC LVTT: 000200ef
[    1.704000] ... APIC LVTPC: 00000400
[    1.704000] ... APIC LVT0: 00010700
[    1.704000] ... APIC LVT1: 00010400
[    1.704000] ... APIC LVTERR: 000000fe
[    1.704000] ... APIC TMICT: 0000c454
[    1.704000] ... APIC TMCCT: 00003865
[    1.704000] ... APIC TDCR: 00000003
[    1.704000] 
[    1.907763] number of MP IRQ sources: 17.
[    1.908004] number of IO-APIC #2 registers: 24.
[    1.912004] testing the IO APIC.......................
[    1.916007] 
[    1.917469] IO APIC #2......
[    1.920004] .... register #00: 00000000
[    1.924004] .......    : physical APIC id: 00
[    1.928004] .......    : Delivery Type: 0
[    1.932004] .......    : LTS          : 0
[    1.936004] .... register #01: 00170011
[    1.940004] .......     : max redirection entries: 0017
[    1.944004] .......     : PRQ implemented: 0
[    1.948004] .......     : IO APIC version: 0011
[    1.952004] .... register #02: 00000000
[    1.956004] .......     : arbitration: 00
[    1.960004] .... IRQ redirection table:
[    1.964004]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    1.968006]  00 003 0    0    0   0   0    1    1    30
[    1.972006]  01 003 0    0    0   0   0    1    1    31
[    1.979205]  02 000 1    0    0   0   0    0    0    00
[    1.984006]  03 003 1    1    0   1   0    1    1    33
[    1.988006]  04 003 0    0    0   0   0    1    1    34
[    1.992006]  05 003 1    1    0   1   0    1    1    35
[    2.000012]  06 003 0    0    0   0   0    1    1    36
[    2.004006]  07 003 1    0    0   0   0    1    1    37
[    2.008006]  08 003 0    0    0   0   0    1    1    38
[    2.015204]  09 003 0    0    0   0   0    1    1    39
[    2.020006]  0a 003 0    0    0   0   0    1    1    3A
[    2.024006]  0b 003 1    1    0   1   0    1    1    3B
[    2.031204]  0c 003 0    0    0   0   0    1    1    3C
[    2.036006]  0d 003 0    0    0   0   0    1    1    3D
[    2.040006]  0e 003 0    0    0   0   0    1    1    3E
[    2.044006]  0f 003 0    0    0   0   0    1    1    3F
[    2.052005]  10 000 1    0    0   0   0    0    0    00
[    2.056006]  11 000 1    0    0   0   0    0    0    00
[    2.060006]  12 000 1    0    0   0   0    0    0    00
[    2.067204]  13 000 1    0    0   0   0    0    0    00
[    2.072006]  14 000 1    0    0   0   0    0    0    00
[    2.076006]  15 000 1    0    0   0   0    0    0    00
[    2.083204]  16 000 1    0    0   0   0    0    0    00
[    2.088006]  17 000 1    0    0   0   0    0    0    00
[    2.092003] IRQ to pin mappings:
[    2.096004] IRQ0 -> 0:0
[    2.098423] IRQ1 -> 0:1
[    2.100690] IRQ3 -> 0:3
[    2.104171] IRQ4 -> 0:4
[    2.106596] IRQ5 -> 0:5
[    2.108690] IRQ6 -> 0:6
[    2.111115] IRQ7 -> 0:7
[    2.112690] IRQ8 -> 0:8
[    2.116171] IRQ9 -> 0:9
[    2.118596] IRQ10 -> 0:10
[    2.120776] IRQ11 -> 0:11
[    2.123374] IRQ12 -> 0:12
[    2.124776] IRQ13 -> 0:13
[    2.128777] IRQ14 -> 0:14
[    2.131375] IRQ15 -> 0:15
[    2.132778] .................................... done.
[    2.136005] initcall print_all_ICs+0x0/0x500 returned 0 after 437500 usecs
[    2.140005] calling  hpet_late_init+0x0/0xa0 @ 1
[    2.144005] initcall hpet_late_init+0x0/0xa0 returned -19 after 0 usecs
[    2.148005] calling  init_kmmio+0x0/0x40 @ 1
[    2.152008] initcall init_kmmio+0x0/0x40 returned 0 after 0 usecs
[    2.156005] calling  clocksource_done_booting+0x0/0x20 @ 1
[    2.160005] initcall clocksource_done_booting+0x0/0x20 returned 0 after 0 usecs
[    2.164005] calling  ftrace_init_debugfs+0x0/0x130 @ 1
[    2.168119] initcall ftrace_init_debugfs+0x0/0x130 returned 0 after 0 usecs
[    2.172005] calling  tracer_init_debugfs+0x0/0x350 @ 1
[    2.176246] initcall tracer_init_debugfs+0x0/0x350 returned 0 after 0 usecs
[    2.180006] calling  init_pipe_fs+0x0/0x60 @ 1
[    2.184128] initcall init_pipe_fs+0x0/0x60 returned 0 after 0 usecs
[    2.188005] calling  init_mnt_writers+0x0/0x90 @ 1
[    2.192006] initcall init_mnt_writers+0x0/0x90 returned 0 after 0 usecs
[    2.196005] calling  eventpoll_init+0x0/0xa0 @ 1
[    2.200035] initcall eventpoll_init+0x0/0xa0 returned 0 after 0 usecs
[    2.204005] calling  anon_inode_init+0x0/0x130 @ 1
[    2.208151] initcall anon_inode_init+0x0/0x130 returned 0 after 0 usecs
[    2.212006] calling  chr_dev_init+0x0/0xe0 @ 1
[    2.216148] initcall chr_dev_init+0x0/0xe0 returned 0 after 0 usecs
[    2.224008] calling  firmware_class_init+0x0/0x90 @ 1
[    2.230819] initcall firmware_class_init+0x0/0x90 returned 0 after 0 usecs
[    2.236006] calling  loopback_init+0x0/0x20 @ 1
[    2.242955] initcall loopback_init+0x0/0x20 returned 0 after 0 usecs
[    2.244007] calling  cpufreq_gov_performance_init+0x0/0x20 @ 1
[    2.248040] initcall cpufreq_gov_performance_init+0x0/0x20 returned 0 after 0 usecs
[    2.252004] calling  pcibios_assign_resources+0x0/0x90 @ 1
[    2.256148] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    2.260006] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    2.264009] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    2.268006] pci 0000:00:09.0:   PREFETCH window: disabled
[    2.272010] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    2.276003] pci 0000:00:0b.0:   IO window: disabled
[    2.280008] pci 0000:00:0b.0:   MEM window: disabled
[    2.284013] pci 0000:00:0b.0:   PREFETCH window: disabled
[    2.288010] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    2.292003] pci 0000:00:0c.0:   IO window: disabled
[    2.296008] pci 0000:00:0c.0:   MEM window: disabled
[    2.300006] pci 0000:00:0c.0:   PREFETCH window: disabled
[    2.304009] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    2.308003] pci 0000:00:0d.0:   IO window: disabled
[    2.312008] pci 0000:00:0d.0:   MEM window: disabled
[    2.316006] pci 0000:00:0d.0:   PREFETCH window: disabled
[    2.320016] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    2.324005] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    2.328008] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    2.332007] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    2.336018] pci 0000:00:09.0: setting latency timer to 64
[    2.340015] pci 0000:00:0b.0: setting latency timer to 64
[    2.344014] pci 0000:00:0c.0: setting latency timer to 64
[    2.348014] pci 0000:00:0d.0: setting latency timer to 64
[    2.352014] pci 0000:00:0e.0: setting latency timer to 64
[    2.356006] bus: 00 index 0 io port: [0x00-0xffff]
[    2.360004] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    2.364004] bus: 05 index 0 io port: [0xc000-0xcfff]
[    2.368004] bus: 05 index 1 mmio: [0xda000000-0xda0fffff]
[    2.372004] bus: 05 index 2 mmio: [0x0-0x0]
[    2.376004] bus: 05 index 3 io port: [0x00-0xffff]
[    2.380004] bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
[    2.384004] bus: 04 index 0 mmio: [0x0-0x0]
[    2.388003] bus: 04 index 1 mmio: [0x0-0x0]
[    2.392003] bus: 04 index 2 mmio: [0x0-0x0]
[    2.396003] bus: 04 index 3 mmio: [0x0-0x0]
[    2.400003] bus: 03 index 0 mmio: [0x0-0x0]
[    2.404003] bus: 03 index 1 mmio: [0x0-0x0]
[    2.408003] bus: 03 index 2 mmio: [0x0-0x0]
[    2.412003] bus: 03 index 3 mmio: [0x0-0x0]
[    2.416003] bus: 02 index 0 mmio: [0x0-0x0]
[    2.420003] bus: 02 index 1 mmio: [0x0-0x0]
[    2.424003] bus: 02 index 2 mmio: [0x0-0x0]
[    2.428003] bus: 02 index 3 mmio: [0x0-0x0]
[    2.432004] bus: 01 index 0 io port: [0xb000-0xbfff]
[    2.436004] bus: 01 index 1 mmio: [0xd8000000-0xd9ffffff]
[    2.440004] bus: 01 index 2 mmio: [0xd0000000-0xd7ffffff]
[    2.444003] bus: 01 index 3 mmio: [0x0-0x0]
[    2.448005] initcall pcibios_assign_resources+0x0/0x90 returned 0 after 187500 usecs
[    2.452005] calling  inet_init+0x0/0x210 @ 1
[    2.456065] NET: Registered protocol family 2
[    2.500400] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.509450] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.514908] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    2.526408] TCP: Hash tables configured (established 131072 bind 65536)
[    2.528049] TCP reno registered
[    2.544460] initcall inet_init+0x0/0x210 returned 0 after 85937 usecs
[    2.548007] calling  af_unix_init+0x0/0x70 @ 1
[    2.552022] NET: Registered protocol family 1
[    2.556044] initcall af_unix_init+0x0/0x70 returned 0 after 3906 usecs
[    2.560006] calling  populate_rootfs+0x0/0xb0 @ 1
[    2.564925] initcall populate_rootfs+0x0/0xb0 returned 0 after 0 usecs
[    2.568007] calling  i8259A_init_sysfs+0x0/0x30 @ 1
[    2.572146] initcall i8259A_init_sysfs+0x0/0x30 returned 0 after 0 usecs
[    2.580008] calling  vsyscall_init+0x0/0x70 @ 1
[    2.584043] initcall vsyscall_init+0x0/0x70 returned 0 after 0 usecs
[    2.592005] calling  sbf_init+0x0/0xe0 @ 1
[    2.596004] initcall sbf_init+0x0/0xe0 returned 0 after 0 usecs
[    2.600005] calling  i8237A_init_sysfs+0x0/0x30 @ 1
[    2.607805] initcall i8237A_init_sysfs+0x0/0x30 returned 0 after 0 usecs
[    2.612007] calling  add_rtc_cmos+0x0/0x40 @ 1
[    2.619009] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    2.624007] initcall add_rtc_cmos+0x0/0x40 returned 0 after 7812 usecs
[    2.632006] calling  cache_sysfs_init+0x0/0x70 @ 1
[    2.639506] initcall cache_sysfs_init+0x0/0x70 returned 0 after 0 usecs
[    2.640027] calling  mce_init_device+0x0/0xa0 @ 1
[    2.644957] initcall mce_init_device+0x0/0xa0 returned 0 after 0 usecs
[    2.648007] calling  periodic_mcheck_init+0x0/0x50 @ 1
[    2.652188] initcall periodic_mcheck_init+0x0/0x50 returned 0 after 0 usecs
[    2.656005] calling  thermal_throttle_init_device+0x0/0x90 @ 1
[    2.660005] initcall thermal_throttle_init_device+0x0/0x90 returned 0 after 0 usecs
[    2.664004] calling  ioapic_init_sysfs+0x0/0xd0 @ 1
[    2.668359] initcall ioapic_init_sysfs+0x0/0xd0 returned 0 after 0 usecs
[    2.672073] calling  uv_ptc_init+0x0/0x80 @ 1
[    2.676005] initcall uv_ptc_init+0x0/0x80 returned 0 after 0 usecs
[    2.684004] calling  uv_bau_init+0x0/0x670 @ 1
[    2.688004] initcall uv_bau_init+0x0/0x670 returned 0 after 0 usecs
[    2.696004] calling  sgi_uv_sysfs_init+0x0/0xb0 @ 1
[    2.700018] initcall sgi_uv_sysfs_init+0x0/0xb0 returned 0 after 0 usecs
[    2.708005] calling  audit_classes_init+0x0/0xb0 @ 1
[    2.712024] initcall audit_classes_init+0x0/0xb0 returned 0 after 0 usecs
[    2.716005] calling  start_pageattr_test+0x0/0x50 @ 1
[    2.724819] initcall start_pageattr_test+0x0/0x50 returned 0 after 0 usecs
[    2.728005] calling  aes_init+0x0/0x20 @ 1
[    2.732169] alg: cipher: Test 1 failed on encryption for aes-asm
[    2.740006] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
[    2.748064] initcall aes_init+0x0/0x20 returned 0 after 15625 usecs
[    2.752006] calling  init_vdso_vars+0x0/0x220 @ 1
[    2.756020] initcall init_vdso_vars+0x0/0x220 returned 0 after 0 usecs
[    2.764005] calling  ia32_binfmt_init+0x0/0x20 @ 1
[    2.768029] initcall ia32_binfmt_init+0x0/0x20 returned 0 after 0 usecs
[    2.776004] calling  sysenter_setup+0x0/0x380 @ 1
[    2.780011] initcall sysenter_setup+0x0/0x380 returned 0 after 0 usecs
[    2.788005] calling  init_sched_debug_procfs+0x0/0x30 @ 1
[    2.792022] initcall init_sched_debug_procfs+0x0/0x30 returned 0 after 0 usecs
[    2.800005] calling  ioresources_init+0x0/0x40 @ 1
[    2.804019] initcall ioresources_init+0x0/0x40 returned 0 after 0 usecs
[    2.812005] calling  uid_cache_init+0x0/0x80 @ 1
[    2.816052] initcall uid_cache_init+0x0/0x80 returned 0 after 0 usecs
[    2.820005] calling  init_posix_timers+0x0/0x110 @ 1
[    2.828028] initcall init_posix_timers+0x0/0x110 returned 0 after 0 usecs
[    2.832005] calling  init_posix_cpu_timers+0x0/0xe0 @ 1
[    2.840005] initcall init_posix_cpu_timers+0x0/0xe0 returned 0 after 0 usecs
[    2.844005] calling  nsproxy_cache_init+0x0/0x30 @ 1
[    2.848017] initcall nsproxy_cache_init+0x0/0x30 returned 0 after 0 usecs
[    2.856006] calling  create_proc_profile+0x0/0x2f0 @ 1
[    2.860005] initcall create_proc_profile+0x0/0x2f0 returned 0 after 0 usecs
[    2.868005] calling  timekeeping_init_device+0x0/0x30 @ 1
[    2.876488] initcall timekeeping_init_device+0x0/0x30 returned 0 after 0 usecs
[    2.880018] calling  init_clocksource_sysfs+0x0/0x60 @ 1
[    2.889256] initcall init_clocksource_sysfs+0x0/0x60 returned 0 after 0 usecs
[    2.892041] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    2.896023] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 0 usecs
[    2.900005] calling  lockdep_proc_init+0x0/0x80 @ 1
[    2.904032] initcall lockdep_proc_init+0x0/0x80 returned 0 after 0 usecs
[    2.908005] calling  futex_init+0x0/0xf0 @ 1
[    2.912047] initcall futex_init+0x0/0xf0 returned 0 after 0 usecs
[    2.916006] calling  init_rttest+0x0/0x160 @ 1
[    2.925090] Initializing RT-Tester: OK
[    2.928042] initcall init_rttest+0x0/0x160 returned 0 after 7812 usecs
[    2.932005] calling  proc_dma_init+0x0/0x30 @ 1
[    2.936014] initcall proc_dma_init+0x0/0x30 returned 0 after 0 usecs
[    2.940005] calling  percpu_modinit+0x0/0x80 @ 1
[    2.944005] initcall percpu_modinit+0x0/0x80 returned 0 after 0 usecs
[    2.948005] calling  kallsyms_init+0x0/0x30 @ 1
[    2.952012] initcall kallsyms_init+0x0/0x30 returned 0 after 0 usecs
[    2.956005] calling  backtrace_regression_test+0x0/0x100 @ 1
[    2.960003] ====[ backtrace testing ]===========
[    2.964003] Testing a backtrace from process context.
[    2.968003] The following trace is a kernel self test and not a bug!
[    2.972005] Pid: 1, comm: swapper Not tainted 2.6.27-06574-g8c86407 #45103
[    2.976003] Call Trace:
[    2.978426]  [<ffffffff80277bc0>] ? backtrace_regression_test+0x0/0x100
[    2.980005]  [<ffffffff80277bfd>] backtrace_regression_test+0x3d/0x100
[    2.984005]  [<ffffffff802642d9>] ? jiffies_read+0x9/0x20
[    2.988005]  [<ffffffff8026258f>] ? getnstimeofday+0x3f/0xc0
[    2.992006]  [<ffffffff8025e68f>] ? ktime_get_ts+0x4f/0x60
[    2.996005]  [<ffffffff80277bc0>] ? backtrace_regression_test+0x0/0x100
[    3.000005]  [<ffffffff8025e6b6>] ? ktime_get+0x16/0x50
[    3.004005]  [<ffffffff80209040>] do_one_initcall+0x40/0x180
[    3.008006]  [<ffffffff807d6ecb>] ? _spin_unlock+0x2b/0x40
[    3.012006]  [<ffffffff8032234d>] ? proc_register+0x11d/0x1e0
[    3.016005]  [<ffffffff8032252e>] ? create_proc_entry+0x5e/0xa0
[    3.020005]  [<ffffffff802922c6>] ? register_irq_proc+0xc6/0xe0
[    3.024006]  [<ffffffff81644f53>] kernel_init+0x1b3/0x240
[    3.028006]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    3.032005]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    3.036005]  [<ffffffff81644da0>] ? kernel_init+0x0/0x240
[    3.040005]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    3.044003] Testing a backtrace from irq context.
[    3.048003] The following trace is a kernel self test and not a bug!
[    3.052015] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.27-06574-g8c86407 #45103
[    3.056001] Call Trace:
[    3.058422]  <IRQ>  [<ffffffff8026cb79>] ? trace_hardirqs_on_caller+0x89/0x160
[    3.064003]  [<ffffffff80277bae>] backtrace_test_irq_callback+0xe/0x20
[    3.068004]  [<ffffffff802498dc>] tasklet_action+0x6c/0xf0
[    3.072003]  [<ffffffff8024968d>] __do_softirq+0x9d/0x180
[    3.076003]  [<ffffffff8020cccc>] call_softirq+0x1c/0x40
[    3.080001]  <EOI>  [<ffffffff8020e1aa>] do_softirq+0x6a/0xb0
[    3.084003]  [<ffffffff802497f5>] ksoftirqd+0x85/0x100
[    3.088004]  [<ffffffff80249770>] ? ksoftirqd+0x0/0x100
[    3.092003]  [<ffffffff8025adc3>] kthread+0x53/0x80
[    3.096004]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    3.100004]  [<ffffffff8020be84>] ? restore_args+0x0/0x30
[    3.104003]  [<ffffffff8025ad70>] ? kthread+0x0/0x80
[    3.108003]  [<ffffffff8020c95f>] ? child_rip+0x0/0x11
[    3.112015] Testing a saved backtrace.
[    3.116022] The following trace is a kernel self test and not a bug!
[    3.120006]  [<ffffffff80216edf>] save_stack_trace+0x2f/0x50
[    3.124003]  [<ffffffff80277c9b>] backtrace_regression_test+0xdb/0x100
[    3.128003]  [<ffffffff80209040>] do_one_initcall+0x40/0x180
[    3.132003]  [<ffffffff81644f53>] kernel_init+0x1b3/0x240
[    3.136003]  [<ffffffff8020c969>] child_rip+0xa/0x11
[    3.144010]  [<ffffffffffffffff>] 0xffffffffffffffff
[    3.148003] ====[ end of backtrace testing ]====
[    3.152005] initcall backtrace_regression_test+0x0/0x100 returned 0 after 187500 usecs
[    3.156005] calling  pid_namespaces_init+0x0/0x30 @ 1
[    3.160027] initcall pid_namespaces_init+0x0/0x30 returned 0 after 0 usecs
[    3.164005] calling  audit_init+0x0/0x180 @ 1
[    3.168004] audit: initializing netlink socket (disabled)
[    3.172078] type=2000 audit(1224773428.172:1): initialized
[    3.176014] initcall audit_init+0x0/0x180 returned 0 after 7812 usecs
[    3.184006] calling  audit_tree_init+0x0/0x50 @ 1
[    3.188008] initcall audit_tree_init+0x0/0x50 returned 0 after 0 usecs
[    3.192005] calling  init_kprobes+0x0/0x1d0 @ 1
[    3.208258] Kprobe smoke test started
[    3.262485] Kprobe smoke test passed successfully
[    3.264011] initcall init_kprobes+0x0/0x1d0 returned 0 after 66406 usecs
[    3.268006] calling  utsname_sysctl_init+0x0/0x20 @ 1
[    3.272078] initcall utsname_sysctl_init+0x0/0x20 returned 0 after 0 usecs
[    3.276005] calling  init_sched_switch_trace+0x0/0x50 @ 1
[    3.280009] Testing tracer sched_switch: PASSED
[    3.424596] initcall init_sched_switch_trace+0x0/0x50 returned 0 after 140625 usecs
[    3.428006] calling  init_stack_trace+0x0/0x20 @ 1
[    3.432006] Testing tracer sysprof: PASSED
[    3.540592] initcall init_stack_trace+0x0/0x20 returned 0 after 105468 usecs
[    3.548006] calling  init_function_trace+0x0/0x20 @ 1
[    3.552006] Testing tracer ftrace: PASSED
[    3.715685] Testing dynamic ftrace: PASSED
[    3.972897] initcall init_function_trace+0x0/0x20 returned 0 after 410156 usecs
[    3.980010] calling  init_wakeup_tracer+0x0/0x20 @ 1
[    3.984007] Testing tracer wakeup: PASSED
[    4.304019] initcall init_wakeup_tracer+0x0/0x20 returned 0 after 312500 usecs
[    4.308006] calling  stack_trace_init+0x0/0x90 @ 1
[    4.320030] initcall stack_trace_init+0x0/0x90 returned 0 after 3906 usecs
[    4.324007] calling  init_mmio_trace+0x0/0x20 @ 1
[    4.328007] initcall init_mmio_trace+0x0/0x20 returned 0 after 0 usecs
[    4.336005] calling  init_per_zone_pages_min+0x0/0x60 @ 1
[    4.340082] initcall init_per_zone_pages_min+0x0/0x60 returned 0 after 0 usecs
[    4.348005] calling  pdflush_init+0x0/0x20 @ 1
[    4.355554] initcall pdflush_init+0x0/0x20 returned 0 after 0 usecs
[    4.356006] calling  kswapd_init+0x0/0x70 @ 1
[    4.360084] initcall kswapd_init+0x0/0x70 returned 0 after 0 usecs
[    4.368005] calling  setup_vmstat+0x0/0x50 @ 1
[    4.372012] initcall setup_vmstat+0x0/0x50 returned 0 after 0 usecs
[    4.376005] calling  mm_sysfs_init+0x0/0x30 @ 1
[    4.380023] initcall mm_sysfs_init+0x0/0x30 returned 0 after 0 usecs
[    4.388005] calling  hugetlb_init+0x0/0x350 @ 1
[    4.392009] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.400044] initcall hugetlb_init+0x0/0x350 returned 0 after 7812 usecs
[    4.404005] calling  init_tmpfs+0x0/0x50 @ 1
[    4.408342] initcall init_tmpfs+0x0/0x50 returned 0 after 0 usecs
[    4.416005] calling  slab_sysfs_init+0x0/0x100 @ 1
[    4.450836] initcall slab_sysfs_init+0x0/0x100 returned 0 after 27343 usecs
[    4.452007] calling  fasync_init+0x0/0x30 @ 1
[    4.456584] initcall fasync_init+0x0/0x30 returned 0 after 0 usecs
[    4.464009] calling  inotify_setup+0x0/0x20 @ 1
[    4.468482] initcall inotify_setup+0x0/0x20 returned 0 after 0 usecs
[    4.472005] calling  inotify_user_setup+0x0/0xc0 @ 1
[    4.482013] initcall inotify_user_setup+0x0/0xc0 returned 0 after 0 usecs
[    4.484007] calling  aio_setup+0x0/0xc0 @ 1
[    4.488694] initcall aio_setup+0x0/0xc0 returned 0 after 0 usecs
[    4.492008] calling  init_sys32_ioctl+0x0/0x90 @ 1
[    4.500021] initcall init_sys32_ioctl+0x0/0x90 returned 0 after 0 usecs
[    4.504005] calling  init_mbcache+0x0/0x20 @ 1
[    4.508008] initcall init_mbcache+0x0/0x20 returned 0 after 0 usecs
[    4.516005] calling  dquot_init+0x0/0x100 @ 1
[    4.520004] VFS: Disk quotas dquot_6.5.1
[    4.526280] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.532010] initcall dquot_init+0x0/0x100 returned 0 after 11718 usecs
[    4.536046] calling  vmcore_init+0x0/0xa40 @ 1
[    4.540006] initcall vmcore_init+0x0/0xa40 returned 0 after 0 usecs
[    4.548005] calling  configfs_init+0x0/0xf0 @ 1
[    4.554661] initcall configfs_init+0x0/0xf0 returned 0 after 0 usecs
[    4.556025] calling  init_devpts_fs+0x0/0x50 @ 1
[    4.560505] initcall init_devpts_fs+0x0/0x50 returned 0 after 0 usecs
[    4.564006] calling  init_ext3_fs+0x0/0x80 @ 1
[    4.568279] initcall init_ext3_fs+0x0/0x80 returned 0 after 0 usecs
[    4.572008] calling  journal_init+0x0/0xf0 @ 1
[    4.581436] initcall journal_init+0x0/0xf0 returned 0 after 0 usecs
[    4.584050] calling  init_ramfs_fs+0x0/0x20 @ 1
[    4.592008] initcall init_ramfs_fs+0x0/0x20 returned 0 after 0 usecs
[    4.596005] calling  init_hugetlbfs_fs+0x0/0xc0 @ 1
[    4.604106] initcall init_hugetlbfs_fs+0x0/0xc0 returned 0 after 3906 usecs
[    4.608087] calling  init_fat_fs+0x0/0x60 @ 1
[    4.612267] initcall init_fat_fs+0x0/0x60 returned 0 after 3906 usecs
[    4.620007] calling  init_vfat_fs+0x0/0x20 @ 1
[    4.624008] initcall init_vfat_fs+0x0/0x20 returned 0 after 0 usecs
[    4.632005] calling  vxfs_init+0x0/0x70 @ 1
[    4.637488] initcall vxfs_init+0x0/0x70 returned 0 after 0 usecs
[    4.640007] calling  init_nfs_fs+0x0/0x130 @ 1
[    4.650092] initcall init_nfs_fs+0x0/0x130 returned 0 after 3906 usecs
[    4.652031] calling  init_nlm+0x0/0x30 @ 1
[    4.656121] initcall init_nlm+0x0/0x30 returned 0 after 0 usecs
[    4.660005] calling  init_nls_cp850+0x0/0x20 @ 1
[    4.664060] initcall init_nls_cp850+0x0/0x20 returned 0 after 0 usecs
[    4.668005] calling  init_nls_cp855+0x0/0x20 @ 1
[    4.672006] initcall init_nls_cp855+0x0/0x20 returned 0 after 0 usecs
[    4.676005] calling  init_nls_cp857+0x0/0x20 @ 1
[    4.680006] initcall init_nls_cp857+0x0/0x20 returned 0 after 0 usecs
[    4.684005] calling  init_nls_cp862+0x0/0x20 @ 1
[    4.688006] initcall init_nls_cp862+0x0/0x20 returned 0 after 0 usecs
[    4.692005] calling  init_nls_cp864+0x0/0x20 @ 1
[    4.696006] initcall init_nls_cp864+0x0/0x20 returned 0 after 0 usecs
[    4.700005] calling  init_nls_cp869+0x0/0x20 @ 1
[    4.704006] initcall init_nls_cp869+0x0/0x20 returned 0 after 0 usecs
[    4.708005] calling  init_nls_cp874+0x0/0x20 @ 1
[    4.712006] initcall init_nls_cp874+0x0/0x20 returned 0 after 0 usecs
[    4.716005] calling  init_nls_cp949+0x0/0x20 @ 1
[    4.720006] initcall init_nls_cp949+0x0/0x20 returned 0 after 0 usecs
[    4.724005] calling  init_nls_ascii+0x0/0x20 @ 1
[    4.728006] initcall init_nls_ascii+0x0/0x20 returned 0 after 0 usecs
[    4.732005] calling  init_nls_iso8859_2+0x0/0x20 @ 1
[    4.736006] initcall init_nls_iso8859_2+0x0/0x20 returned 0 after 0 usecs
[    4.740005] calling  init_nls_iso8859_3+0x0/0x20 @ 1
[    4.744006] initcall init_nls_iso8859_3+0x0/0x20 returned 0 after 0 usecs
[    4.748005] calling  init_nls_iso8859_5+0x0/0x20 @ 1
[    4.752006] initcall init_nls_iso8859_5+0x0/0x20 returned 0 after 0 usecs
[    4.756005] calling  init_nls_iso8859_6+0x0/0x20 @ 1
[    4.760006] initcall init_nls_iso8859_6+0x0/0x20 returned 0 after 0 usecs
[    4.764005] calling  init_nls_iso8859_7+0x0/0x20 @ 1
[    4.768006] initcall init_nls_iso8859_7+0x0/0x20 returned 0 after 0 usecs
[    4.776006] calling  init_hpfs_fs+0x0/0x70 @ 1
[    4.780362] initcall init_hpfs_fs+0x0/0x70 returned 0 after 0 usecs
[    4.784026] calling  init_qnx4_fs+0x0/0x80 @ 1
[    4.791712] QNX4 filesystem 0.2.3 registered.
[    4.792008] initcall init_qnx4_fs+0x0/0x80 returned 0 after 3906 usecs
[    4.796005] calling  init_jfs_fs+0x0/0x230 @ 1
[    4.800281] JFS: nTxBlock = 7682, nTxLock = 61461
[    4.817073] initcall init_jfs_fs+0x0/0x230 returned 0 after 15625 usecs
[    4.820005] calling  init_befs_fs+0x0/0x90 @ 1
[    4.824005] BeFS version: 0.9.3
[    4.828430] initcall init_befs_fs+0x0/0x90 returned 0 after 3906 usecs
[    4.832006] calling  init_mqueue_fs+0x0/0xe0 @ 1
[    4.836197] initcall init_mqueue_fs+0x0/0xe0 returned 0 after 0 usecs
[    4.844031] calling  key_proc_init+0x0/0x60 @ 1
[    4.848037] initcall key_proc_init+0x0/0x60 returned 0 after 0 usecs
[    4.856006] calling  selinux_nf_ip_init+0x0/0x70 @ 1
[    4.860005] SELinux:  Registering netfilter hooks
[    4.864057] initcall selinux_nf_ip_init+0x0/0x70 returned 0 after 3906 usecs
[    4.872006] calling  init_sel_fs+0x0/0x70 @ 1
[    4.877357] initcall init_sel_fs+0x0/0x70 returned 0 after 0 usecs
[    4.884006] calling  selnl_init+0x0/0x50 @ 1
[    4.888054] initcall selnl_init+0x0/0x50 returned 0 after 0 usecs
[    4.892006] calling  sel_netif_init+0x0/0x70 @ 1
[    4.896013] initcall sel_netif_init+0x0/0x70 returned 0 after 0 usecs
[    4.904006] calling  sel_netnode_init+0x0/0xb0 @ 1
[    4.908010] initcall sel_netnode_init+0x0/0xb0 returned 0 after 0 usecs
[    4.916006] calling  sel_netport_init+0x0/0xb0 @ 1
[    4.920010] initcall sel_netport_init+0x0/0xb0 returned 0 after 0 usecs
[    4.928006] calling  aurule_init+0x0/0x40 @ 1
[    4.932007] initcall aurule_init+0x0/0x40 returned 0 after 0 usecs
[    4.936006] calling  crypto_algapi_init+0x0/0x10 @ 1
[    4.944017] initcall crypto_algapi_init+0x0/0x10 returned 0 after 0 usecs
[    4.948006] calling  chainiv_module_init+0x0/0x20 @ 1
[    4.956073] initcall chainiv_module_init+0x0/0x20 returned 0 after 0 usecs
[    4.960006] calling  eseqiv_module_init+0x0/0x20 @ 1
[    4.968010] initcall eseqiv_module_init+0x0/0x20 returned 0 after 0 usecs
[    4.972006] calling  seqiv_module_init+0x0/0x20 @ 1
[    4.976010] initcall seqiv_module_init+0x0/0x20 returned 0 after 0 usecs
[    4.984006] calling  hmac_module_init+0x0/0x20 @ 1
[    4.988010] initcall hmac_module_init+0x0/0x20 returned 0 after 0 usecs
[    4.996006] calling  md4_mod_init+0x0/0x20 @ 1
[    5.002273] initcall md4_mod_init+0x0/0x20 returned 0 after 0 usecs
[    5.004008] calling  md5_mod_init+0x0/0x20 @ 1
[    5.008065] initcall md5_mod_init+0x0/0x20 returned 0 after 0 usecs
[    5.012007] calling  rmd160_mod_init+0x0/0x20 @ 1
[    5.020016] initcall rmd160_mod_init+0x0/0x20 returned 0 after 3906 usecs
[    5.024005] calling  rmd320_mod_init+0x0/0x20 @ 1
[    5.028066] initcall rmd320_mod_init+0x0/0x20 returned 0 after 0 usecs
[    5.036008] calling  sha1_generic_mod_init+0x0/0x20 @ 1
[    5.043254] initcall sha1_generic_mod_init+0x0/0x20 returned 0 after 0 usecs
[    5.044008] calling  sha256_generic_mod_init+0x0/0x50 @ 1
[    5.048067] initcall sha256_generic_mod_init+0x0/0x50 returned 0 after 0 usecs
[    5.056008] calling  wp512_mod_init+0x0/0x90 @ 1
[    5.064017] initcall wp512_mod_init+0x0/0x90 returned 0 after 3906 usecs
[    5.068006] calling  tgr192_mod_init+0x0/0x90 @ 1
[    5.072063] initcall tgr192_mod_init+0x0/0x90 returned 0 after 0 usecs
[    5.080007] calling  crypto_ecb_module_init+0x0/0x20 @ 1
[    5.084010] initcall crypto_ecb_module_init+0x0/0x20 returned 0 after 0 usecs
[    5.092013] calling  crypto_cbc_module_init+0x0/0x20 @ 1
[    5.096010] initcall crypto_cbc_module_init+0x0/0x20 returned 0 after 0 usecs
[    5.104005] calling  crypto_cts_module_init+0x0/0x20 @ 1
[    5.112009] initcall crypto_cts_module_init+0x0/0x20 returned 0 after 0 usecs
[    5.116005] calling  crypto_module_init+0x0/0x20 @ 1
[    5.124009] initcall crypto_module_init+0x0/0x20 returned 0 after 0 usecs
[    5.128005] calling  crypto_module_init+0x0/0x20 @ 1
[    5.136009] initcall crypto_module_init+0x0/0x20 returned 0 after 0 usecs
[    5.140005] calling  crypto_ctr_module_init+0x0/0x50 @ 1
[    5.148013] initcall crypto_ctr_module_init+0x0/0x50 returned 0 after 0 usecs
[    5.152005] calling  crypto_gcm_module_init+0x0/0x70 @ 1
[    5.160017] initcall crypto_gcm_module_init+0x0/0x70 returned 0 after 0 usecs
[    5.164005] calling  crypto_ccm_module_init+0x0/0x70 @ 1
[    5.172017] initcall crypto_ccm_module_init+0x0/0x70 returned 0 after 0 usecs
[    5.180005] calling  des_generic_mod_init+0x0/0x50 @ 1
[    5.185702] initcall des_generic_mod_init+0x0/0x50 returned 0 after 0 usecs
[    5.188007] calling  serpent_mod_init+0x0/0x50 @ 1
[    5.192065] initcall serpent_mod_init+0x0/0x50 returned 0 after 0 usecs
[    5.200008] calling  aes_init+0x0/0x360 @ 1
[    5.204453] initcall aes_init+0x0/0x360 returned 0 after 0 usecs
[    5.208008] calling  arc4_init+0x0/0x20 @ 1
[    5.212070] initcall arc4_init+0x0/0x20 returned 0 after 0 usecs
[    5.220008] calling  khazad_mod_init+0x0/0x20 @ 1
[    5.225400] initcall khazad_mod_init+0x0/0x20 returned 0 after 0 usecs
[    5.228008] calling  salsa20_generic_mod_init+0x0/0x20 @ 1
[    5.232069] initcall salsa20_generic_mod_init+0x0/0x20 returned 0 after 0 usecs
[    5.240007] calling  deflate_mod_init+0x0/0x20 @ 1
[    5.245990] initcall deflate_mod_init+0x0/0x20 returned 0 after 0 usecs
[    5.248010] calling  michael_mic_init+0x0/0x20 @ 1
[    5.252080] initcall michael_mic_init+0x0/0x20 returned 0 after 0 usecs
[    5.256008] calling  krng_mod_init+0x0/0x20 @ 1
[    5.264468] alg: No test for stdrng (krng)
[    5.268058] initcall krng_mod_init+0x0/0x20 returned 0 after 3906 usecs
[    5.272007] calling  bsg_init+0x0/0x150 @ 1
[    5.279893] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    5.280010] initcall bsg_init+0x0/0x150 returned 0 after 3906 usecs
[    5.284006] calling  noop_init+0x0/0x20 @ 1
[    5.288078] io scheduler noop registered
[    5.292006] initcall noop_init+0x0/0x20 returned 0 after 3906 usecs
[    5.296005] calling  cfq_init+0x0/0xa0 @ 1
[    5.304503] io scheduler cfq registered (default)
[    5.308008] initcall cfq_init+0x0/0xa0 returned 0 after 7812 usecs
[    5.312049] calling  debug_objects_init_debugfs+0x0/0x70 @ 1
[    5.316006] initcall debug_objects_init_debugfs+0x0/0x70 returned 0 after 0 usecs
[    5.320005] calling  percpu_counter_startup+0x0/0x20 @ 1
[    5.324009] initcall percpu_counter_startup+0x0/0x20 returned 0 after 0 usecs
[    5.328005] calling  dynamic_printk_init+0x0/0xa0 @ 1
[    5.336125] initcall dynamic_printk_init+0x0/0xa0 returned 0 after 3906 usecs
[    5.340007] calling  pci_init+0x0/0x40 @ 1
[    5.344047] pci 0000:00:00.0: Enabling HT MSI Mapping
[    5.364258] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    5.368040] pci 0000:00:0b.0: Found enabled HT MSI Mapping
[    5.372055] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    5.376027] pci 0000:00:0c.0: Found enabled HT MSI Mapping
[    5.380041] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    5.384027] pci 0000:00:0d.0: Found enabled HT MSI Mapping
[    5.388040] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    5.392027] pci 0000:00:0e.0: Found enabled HT MSI Mapping
[    5.396051] pci 0000:01:00.0: Boot video device
[    5.400019] initcall pci_init+0x0/0x40 returned 0 after 54687 usecs
[    5.404006] calling  pci_proc_init+0x0/0x70 @ 1
[    5.408357] initcall pci_proc_init+0x0/0x70 returned 0 after 0 usecs
[    5.412006] calling  vgg2432a4_init+0x0/0x20 @ 1
[    5.416253] initcall vgg2432a4_init+0x0/0x20 returned 0 after 0 usecs
[    5.420007] calling  tdo24m_init+0x0/0x20 @ 1
[    5.424071] initcall tdo24m_init+0x0/0x20 returned 0 after 0 usecs
[    5.432010] calling  rand_initialize+0x0/0x40 @ 1
[    5.436064] initcall rand_initialize+0x0/0x40 returned 0 after 0 usecs
[    5.444005] calling  tty_init+0x0/0x110 @ 1
[    5.465069] initcall tty_init+0x0/0x110 returned 0 after 15625 usecs
[    5.468009] calling  pty_init+0x0/0x5c0 @ 1
[    5.619412] initcall pty_init+0x0/0x5c0 returned 0 after 136718 usecs
[    5.624248] calling  sysrq_init+0x0/0x30 @ 1
[    5.628028] initcall sysrq_init+0x0/0x30 returned 0 after 0 usecs
[    5.636005] calling  rp_init+0x0/0x1a30 @ 1
[    5.640004] RocketPort device driver module, version 2.09, 12-June-2003
[    5.644066] No rocketport ports found; unloading driver
[    5.652109] initcall rp_init+0x0/0x1a30 returned -6 after 11718 usecs
[    5.656005] initcall rp_init+0x0/0x1a30 returned with error code -6 
[    5.664005] calling  ip2_loadmain+0x0/0x14d0 @ 1
[    5.668004] Computone IntelliPort Plus multiport driver version 1.2.14
[    5.676712] initcall ip2_loadmain+0x0/0x14d0 returned 0 after 7812 usecs
[    5.680229] calling  synclink_init+0x0/0x2c0 @ 1
[    5.684005] SyncLink serial driver $Revision: 4.38 $
[    5.732943] SyncLink serial driver $Revision: 4.38 $, tty major#253
[    5.736012] initcall synclink_init+0x0/0x2c0 returned 0 after 50781 usecs
[    5.744388] calling  n_hdlc_init+0x0/0xb0 @ 1
[    5.748005] HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
[    5.756005] N_HDLC line discipline registered.
[    5.760005] initcall n_hdlc_init+0x0/0xb0 returned 0 after 11718 usecs
[    5.768004] calling  rio_init+0x0/0x12a0 @ 1
[    5.776751] initcall rio_init+0x0/0x12a0 returned -5 after 3906 usecs
[    5.780078] initcall rio_init+0x0/0x12a0 returned with error code -5 
[    5.784005] calling  raw_init+0x0/0xf0 @ 1
[    5.788142] initcall raw_init+0x0/0xf0 returned 0 after 0 usecs
[    5.796008] calling  agp_init+0x0/0x30 @ 1
[    5.800004] Linux agpgart interface v0.103
[    5.804005] initcall agp_init+0x0/0x30 returned 0 after 3906 usecs
[    5.808005] calling  agp_via_init+0x0/0x30 @ 1
[    5.814999] initcall agp_via_init+0x0/0x30 returned 0 after 0 usecs
[    5.820007] calling  ipmi_init_msghandler_mod+0x0/0x10 @ 1
[    5.826901] ipmi message handler version 39.2
[    5.828034] initcall ipmi_init_msghandler_mod+0x0/0x10 returned 0 after 3906 usecs
[    5.832026] calling  ipmi_wdog_init+0x0/0x160 @ 1
[    5.836157] IPMI Watchdog: driver initialized
[    5.840005] initcall ipmi_wdog_init+0x0/0x160 returned 0 after 3906 usecs
[    5.844005] calling  hangcheck_init+0x0/0x90 @ 1
[    5.848004] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    5.852004] Hangcheck: Using get_cycles().
[    5.856006] initcall hangcheck_init+0x0/0x90 returned 0 after 7812 usecs
[    5.860005] calling  serial8250_init+0x0/0x160 @ 1
[    5.864004] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    5.868199] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.878975] initcall serial8250_init+0x0/0x160 returned 0 after 11718 usecs
[    5.880010] calling  jsm_init_module+0x0/0x60 @ 1
[    5.884221] initcall jsm_init_module+0x0/0x60 returned 0 after 0 usecs
[    5.892031] calling  init_kgdboc+0x0/0x20 @ 1
[    5.896006] initcall init_kgdboc+0x0/0x20 returned 0 after 0 usecs
[    5.900007] calling  topology_sysfs_init+0x0/0x50 @ 1
[    5.908071] initcall topology_sysfs_init+0x0/0x50 returned 0 after 0 usecs
[    5.912005] calling  cpqarray_init+0x0/0x2a0 @ 1
[    5.920004] Compaq SMART2 Driver (v 2.6.0)
[    5.924590] initcall cpqarray_init+0x0/0x2a0 returned 0 after 3906 usecs
[    5.928108] calling  cciss_init+0x0/0x30 @ 1
[    5.932004] HP CISS Driver (v 3.6.20)
[    5.936266] initcall cciss_init+0x0/0x30 returned 0 after 3906 usecs
[    5.940009] calling  DAC960_init_module+0x0/0x60 @ 1
[    5.944175] initcall DAC960_init_module+0x0/0x60 returned 0 after 0 usecs
[    5.952010] calling  init_kgdbts+0x0/0x20 @ 1
[    5.956027] initcall init_kgdbts+0x0/0x20 returned 0 after 0 usecs
[    5.964005] calling  sm501_base_init+0x0/0x30 @ 1
[    5.969283] initcall sm501_base_init+0x0/0x30 returned 0 after 0 usecs
[    5.972007] calling  e1000_init_module+0x0/0x70 @ 1
[    5.980042] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    5.984004] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    5.992664] initcall e1000_init_module+0x0/0x70 returned 0 after 11718 usecs
[    5.996006] calling  cas_init+0x0/0x40 @ 1
[    6.004046] initcall cas_init+0x0/0x40 returned 0 after 3906 usecs
[    6.008026] calling  eepro100_init_module+0x0/0x20 @ 1
[    6.012213] initcall eepro100_init_module+0x0/0x20 returned 0 after 0 usecs
[    6.020007] calling  e100_init_module+0x0/0x60 @ 1
[    6.024004] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    6.032004] e100: Copyright(c) 1999-2006 Intel Corporation
[    6.038964] initcall e100_init_module+0x0/0x60 returned 0 after 11718 usecs
[    6.040006] calling  r6040_init+0x0/0x20 @ 1
[    6.044167] initcall r6040_init+0x0/0x20 returned 0 after 0 usecs
[    6.052007] calling  acenic_init+0x0/0x20 @ 1
[    6.056914] initcall acenic_init+0x0/0x20 returned 0 after 0 usecs
[    6.060007] calling  natsemi_init_mod+0x0/0x20 @ 1
[    6.064184] initcall natsemi_init_mod+0x0/0x20 returned 0 after 3906 usecs
[    6.072007] calling  tg3_init+0x0/0x20 @ 1
[    6.079148] initcall tg3_init+0x0/0x20 returned 0 after 0 usecs
[    6.080007] calling  sky2_init_module+0x0/0x60 @ 1
[    6.084004] sky2 driver version 1.22
[    6.088219] initcall sky2_init_module+0x0/0x60 returned 0 after 3906 usecs
[    6.096007] calling  starfire_init+0x0/0x20 @ 1
[    6.101133] initcall starfire_init+0x0/0x20 returned 0 after 0 usecs
[    6.104007] calling  davicom_init+0x0/0x70 @ 1
[    6.112479] initcall davicom_init+0x0/0x70 returned 0 after 3906 usecs
[    6.116027] calling  cicada_init+0x0/0x50 @ 1
[    6.120401] initcall cicada_init+0x0/0x50 returned 0 after 0 usecs
[    6.124007] calling  lxt_init+0x0/0x50 @ 1
[    6.128165] initcall lxt_init+0x0/0x50 returned 0 after 0 usecs
[    6.136008] calling  fixed_mdio_bus_init+0x0/0x110 @ 1
[    6.141618] Fixed MDIO Bus: probed
[    6.144008] initcall fixed_mdio_bus_init+0x0/0x110 returned 0 after 3906 usecs
[    6.152042] calling  hamachi_init+0x0/0x20 @ 1
[    6.156856] initcall hamachi_init+0x0/0x20 returned 0 after 0 usecs
[    6.160007] calling  net_olddevs_init+0x0/0xb0 @ 1
[    6.164010] initcall net_olddevs_init+0x0/0xb0 returned 0 after 0 usecs
[    6.172005] calling  init_nic+0x0/0x20 @ 1
[    6.176051] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[    6.184033] forcedeth 0000:00:0a.0: setting latency timer to 64
[    6.188078] nv_probe: set workaround bit for reversed mac addr
[    6.718088] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[    6.720008] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[    6.724176] initcall init_nic+0x0/0x20 returned 0 after 535156 usecs
[    6.728008] calling  ql3xxx_init_module+0x0/0x20 @ 1
[    6.737012] initcall ql3xxx_init_module+0x0/0x20 returned 0 after 0 usecs
[    6.740007] calling  dummy_init_module+0x0/0xf0 @ 1
[    6.744457] initcall dummy_init_module+0x0/0xf0 returned 0 after 0 usecs
[    6.752009] calling  dfx_init+0x0/0x20 @ 1
[    6.757576] initcall dfx_init+0x0/0x20 returned 0 after 0 usecs
[    6.760007] calling  cp_init+0x0/0x20 @ 1
[    6.764068] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    6.768005] 8139cp 0000:05:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
[    6.772004] 8139cp 0000:05:07.0: Try the "8139too" driver instead.
[    6.776169] initcall cp_init+0x0/0x20 returned 0 after 11718 usecs
[    6.780007] calling  rtl8139_init_module+0x0/0x20 @ 1
[    6.784067] 8139too Fast Ethernet driver 0.9.28
[    6.793791] eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 11
[    6.796006] eth1:  Identified 8139 chip type 'RTL-8139B'
[    6.800169] initcall rtl8139_init_module+0x0/0x20 returned 0 after 15625 usecs
[    6.808007] calling  eql_init_module+0x0/0x80 @ 1
[    6.812004] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    6.823557] initcall eql_init_module+0x0/0x80 returned 0 after 7812 usecs
[    6.824007] calling  tun_init+0x0/0xb0 @ 1
[    6.828007] tun: Universal TUN/TAP device driver, 1.6
[    6.832004] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    6.836364] initcall tun_init+0x0/0xb0 returned 0 after 7812 usecs
[    6.840007] calling  rio_init+0x0/0x20 @ 1
[    6.848383] initcall rio_init+0x0/0x20 returned 0 after 0 usecs
[    6.852007] calling  rtl8169_init_module+0x0/0x20 @ 1
[    6.856196] initcall rtl8169_init_module+0x0/0x20 returned 0 after 0 usecs
[    6.864007] calling  enc28j60_init+0x0/0x30 @ 1
[    6.870992] initcall enc28j60_init+0x0/0x30 returned 0 after 0 usecs
[    6.872007] calling  olympic_pci_init+0x0/0x20 @ 1
[    6.876198] initcall olympic_pci_init+0x0/0x20 returned 0 after 0 usecs
[    6.884007] calling  xl_pci_init+0x0/0x20 @ 1
[    6.889418] initcall xl_pci_init+0x0/0x20 returned 0 after 0 usecs
[    6.892007] calling  init_dlci+0x0/0x40 @ 1
[    6.896063] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    6.900005] initcall init_dlci+0x0/0x40 returned 0 after 3906 usecs
[    6.904005] calling  catc_init+0x0/0x40 @ 1
[    6.908164] usbcore: registered new interface driver catc
[    6.912012] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    6.916006] initcall catc_init+0x0/0x40 returned 0 after 7812 usecs
[    6.924005] calling  usb_rtl8150_init+0x0/0x30 @ 1
[    6.928004] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    6.937704] usbcore: registered new interface driver rtl8150
[    6.940014] initcall usb_rtl8150_init+0x0/0x30 returned 0 after 11718 usecs
[    6.944005] calling  cdc_init+0x0/0x20 @ 1
[    6.948134] usbcore: registered new interface driver cdc_ether
[    6.956014] initcall cdc_init+0x0/0x20 returned 0 after 7812 usecs
[    6.960005] calling  usbnet_init+0x0/0x20 @ 1
[    6.966898] usbcore: registered new interface driver gl620a
[    6.968014] initcall usbnet_init+0x0/0x20 returned 0 after 3906 usecs
[    6.972013] calling  net1080_init+0x0/0x20 @ 1
[    6.976134] usbcore: registered new interface driver net1080
[    6.984021] initcall net1080_init+0x0/0x20 returned 0 after 7812 usecs
[    6.988005] calling  plusb_init+0x0/0x20 @ 1
[    6.995915] usbcore: registered new interface driver plusb
[    6.996014] initcall plusb_init+0x0/0x20 returned 0 after 3906 usecs
[    7.000005] calling  rndis_init+0x0/0x20 @ 1
[    7.004134] usbcore: registered new interface driver rndis_host
[    7.012014] initcall rndis_init+0x0/0x20 returned 0 after 7812 usecs
[    7.020005] calling  zaurus_init+0x0/0x20 @ 1
[    7.024763] usbcore: registered new interface driver zaurus
[    7.028016] initcall zaurus_init+0x0/0x20 returned 0 after 3906 usecs
[    7.032005] calling  usbnet_init+0x0/0x30 @ 1
[    7.036014] initcall usbnet_init+0x0/0x30 returned 0 after 0 usecs
[    7.040005] calling  ipw2100_init+0x0/0x90 @ 1
[    7.044004] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    7.048004] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    7.056186] initcall ipw2100_init+0x0/0x90 returned 0 after 11718 usecs
[    7.060007] calling  strip_init_driver+0x0/0x70 @ 1
[    7.064004] STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
[    7.072025] initcall strip_init_driver+0x0/0x70 returned 0 after 7812 usecs
[    7.080005] calling  init_orinoco+0x0/0x20 @ 1
[    7.084004] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[    7.092005] initcall init_orinoco+0x0/0x20 returned 0 after 7812 usecs
[    7.100005] calling  init_hermes+0x0/0x10 @ 1
[    7.104005] initcall init_hermes+0x0/0x10 returned 0 after 0 usecs
[    7.112005] calling  init_hermes_dld+0x0/0x10 @ 1
[    7.116005] initcall init_hermes_dld+0x0/0x10 returned 0 after 0 usecs
[    7.120005] calling  prism54_module_init+0x0/0x40 @ 1
[    7.128004] Loaded prism54 driver, version 1.2
[    7.133082] initcall prism54_module_init+0x0/0x40 returned 0 after 3906 usecs
[    7.136007] calling  hostap_init+0x0/0x50 @ 1
[    7.140022] initcall hostap_init+0x0/0x50 returned 0 after 0 usecs
[    7.144005] calling  init_prism2_pci+0x0/0x20 @ 1
[    7.148198] initcall init_prism2_pci+0x0/0x20 returned 0 after 0 usecs
[    7.156007] calling  rndis_wlan_init+0x0/0x20 @ 1
[    7.162892] usbcore: registered new interface driver rndis_wlan
[    7.164015] initcall rndis_wlan_init+0x0/0x20 returned 0 after 3906 usecs
[    7.168005] calling  sixpack_init_driver+0x0/0x50 @ 1
[    7.172004] AX.25: 6pack driver, Revision: 0.3.0
[    7.176006] initcall sixpack_init_driver+0x0/0x50 returned 0 after 3906 usecs
[    7.180005] calling  yam_init_driver+0x0/0x150 @ 1
[    7.184004] YAM driver version 0.8 by F1OAT/F6FBB
[    7.196044] initcall yam_init_driver+0x0/0x150 returned 0 after 11718 usecs
[    7.200050] calling  init_netconsole+0x0/0x260 @ 1
[    7.208540] console [netcon0] enabled
[    7.212007] netconsole: network logging started
[    7.216007] initcall init_netconsole+0x0/0x260 returned 0 after 7812 usecs
[    7.220005] calling  videodev_init+0x0/0xa0 @ 1
[    7.228006] Linux video capture interface: v2.00
[    7.233208] initcall videodev_init+0x0/0xa0 returned 0 after 3906 usecs
[    7.236046] calling  zatm_init_module+0x0/0x20 @ 1
[    7.240177] initcall zatm_init_module+0x0/0x20 returned 0 after 0 usecs
[    7.244016] calling  uPD98402_module_init+0x0/0x10 @ 1
[    7.252007] initcall uPD98402_module_init+0x0/0x10 returned 0 after 0 usecs
[    7.256005] calling  ia_module_init+0x0/0x80 @ 1
[    7.264200] initcall ia_module_init+0x0/0x80 returned 0 after 3906 usecs
[    7.268007] calling  fore200e_module_init+0x0/0x30 @ 1
[    7.272004] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    7.276165] initcall fore200e_module_init+0x0/0x30 returned 0 after 3906 usecs
[    7.284008] calling  eni_init+0x0/0x20 @ 1
[    7.290271] initcall eni_init+0x0/0x20 returned 0 after 0 usecs
[    7.292007] calling  spi_transport_init+0x0/0x30 @ 1
[    7.296122] initcall spi_transport_init+0x0/0x30 returned 0 after 0 usecs
[    7.304009] calling  fc_transport_init+0x0/0x50 @ 1
[    7.309714] initcall fc_transport_init+0x0/0x50 returned 0 after 0 usecs
[    7.316009] calling  scsi_dh_init+0x0/0x50 @ 1
[    7.320045] initcall scsi_dh_init+0x0/0x50 returned 0 after 0 usecs
[    7.324007] calling  rdac_init+0x0/0x40 @ 1
[    7.328051] rdac: device handler registered
[    7.332007] initcall rdac_init+0x0/0x40 returned 0 after 3906 usecs
[    7.340006] calling  adpt_init+0x0/0x1110 @ 1
[    7.344004] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.348005] Detecting Adaptec I2O RAID controllers...
[    7.356029] initcall adpt_init+0x0/0x1110 returned -19 after 11718 usecs
[    7.360005] calling  ahc_linux_init+0x0/0x70 @ 1
[    7.368024] initcall ahc_linux_init+0x0/0x70 returned 0 after 3906 usecs
[    7.372080] calling  ips_module_init+0x0/0x220 @ 1
[    7.376182] initcall ips_module_init+0x0/0x220 returned -19 after 0 usecs
[    7.384019] calling  init_this_scsi_driver+0x0/0x110 @ 1
[    7.388075] scsi: <fdomain> Detection failed (no card)
[    7.396008] initcall init_this_scsi_driver+0x0/0x110 returned -19 after 7812 usecs
[    7.404007] calling  qla1280_init+0x0/0x20 @ 1
[    7.409188] initcall qla1280_init+0x0/0x20 returned 0 after 0 usecs
[    7.412007] calling  dc395x_module_init+0x0/0x20 @ 1
[    7.416194] initcall dc395x_module_init+0x0/0x20 returned 0 after 0 usecs
[    7.420008] calling  megasas_init+0x0/0x170 @ 1
[    7.424004] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[    7.433864] initcall megasas_init+0x0/0x170 returned 0 after 7812 usecs
[    7.436007] calling  atp870u_init+0x0/0x20 @ 1
[    7.440177] initcall atp870u_init+0x0/0x20 returned 0 after 0 usecs
[    7.444008] calling  inia100_init+0x0/0x20 @ 1
[    7.451891] initcall inia100_init+0x0/0x20 returned 0 after 0 usecs
[    7.452007] calling  hptiop_module_init+0x0/0x40 @ 1
[    7.456004] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[    7.460165] initcall hptiop_module_init+0x0/0x40 returned 0 after 3906 usecs
[    7.468009] calling  stex_init+0x0/0x30 @ 1
[    7.472004] stex: Promise SuperTrak EX Driver version: 3.6.0000.1
[    7.478642] initcall stex_init+0x0/0x30 returned 0 after 3906 usecs
[    7.480007] calling  init_osst+0x0/0x150 @ 1
[    7.484004] osst :I: Tape driver with OnStream support version 0.99.4
[    7.484008] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.488123] Driver 'osst' needs updating - please use bus_type methods
[    7.496984] initcall init_osst+0x0/0x150 returned 0 after 11718 usecs
[    7.500007] calling  init_sd+0x0/0x100 @ 1
[    7.504261] Driver 'sd' needs updating - please use bus_type methods
[    7.508127] initcall init_sd+0x0/0x100 returned 0 after 3906 usecs
[    7.516028] calling  init_sg+0x0/0x170 @ 1
[    7.520583] initcall init_sg+0x0/0x170 returned 0 after 0 usecs
[    7.524028] calling  init_ch_module+0x0/0xc0 @ 1
[    7.528006] SCSI Media Changer driver v0.25 
[    7.532122] Driver 'ch' needs updating - please use bus_type methods
[    7.541936] initcall init_ch_module+0x0/0xc0 returned 0 after 11718 usecs
[    7.544007] calling  ahci_init+0x0/0x20 @ 1
[    7.548206] initcall ahci_init+0x0/0x20 returned 0 after 0 usecs
[    7.552027] calling  piix_init+0x0/0x30 @ 1
[    7.559374] initcall piix_init+0x0/0x30 returned 0 after 0 usecs
[    7.560007] calling  qs_ata_init+0x0/0x20 @ 1
[    7.564212] initcall qs_ata_init+0x0/0x20 returned 0 after 0 usecs
[    7.568009] calling  sil_init+0x0/0x20 @ 1
[    7.576351] initcall sil_init+0x0/0x20 returned 0 after 0 usecs
[    7.580007] calling  nv_init+0x0/0x20 @ 1
[    7.584189] initcall nv_init+0x0/0x20 returned 0 after 0 usecs
[    7.592009] calling  ali_init+0x0/0x20 @ 1
[    7.596497] initcall ali_init+0x0/0x20 returned 0 after 0 usecs
[    7.600007] calling  amd_init+0x0/0x20 @ 1
[    7.604052] pata_amd 0000:00:06.0: version 0.3.10
[    7.608145] pata_amd 0000:00:06.0: setting latency timer to 64
[    7.612378] scsi0 : pata_amd
[    7.618667] scsi1 : pata_amd
[    7.620352] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    7.624007] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    7.800536] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[    7.804006] ata1.00: 488397168 sectors, multi 1: LBA48 
[    7.812016] ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[    7.844470] ata1.00: configured for UDMA/100
[    8.008299] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[    8.012013] ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[    8.032192] ata2.01: configured for UDMA/33
[    8.037223] isa bounce pool size: 16 pages
[    8.041392] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[    8.053223] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250GB/232GiB)
[    8.060101] sd 0:0:0:0: [sda] Write Protect is off
[    8.064007] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.068196] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.081954] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250GB/232GiB)
[    8.088094] sd 0:0:0:0: [sda] Write Protect is off
[    8.092005] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.096169] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.108013]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    8.192481] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.196163] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.206515] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[    8.216446] scsi 1:0:1:0: Attached scsi generic sg1 type 5
[    8.220222] initcall amd_init+0x0/0x20 returned 0 after 601562 usecs
[    8.228052] calling  atiixp_init+0x0/0x20 @ 1
[    8.233202] initcall atiixp_init+0x0/0x20 returned 0 after 0 usecs
[    8.236009] calling  cmd64x_init+0x0/0x20 @ 1
[    8.243929] initcall cmd64x_init+0x0/0x20 returned 0 after 0 usecs
[    8.244008] calling  cs5520_init+0x0/0x20 @ 1
[    8.248214] initcall cs5520_init+0x0/0x20 returned 0 after 0 usecs
[    8.256009] calling  efar_init+0x0/0x20 @ 1
[    8.261069] initcall efar_init+0x0/0x20 returned 0 after 0 usecs
[    8.264009] calling  it8213_init+0x0/0x20 @ 1
[    8.271598] initcall it8213_init+0x0/0x20 returned 0 after 0 usecs
[    8.272008] calling  ninja32_init+0x0/0x20 @ 1
[    8.276189] initcall ninja32_init+0x0/0x20 returned 0 after 0 usecs
[    8.284009] calling  ns87410_init+0x0/0x20 @ 1
[    8.289209] initcall ns87410_init+0x0/0x20 returned 0 after 0 usecs
[    8.292007] calling  mpiix_init+0x0/0x20 @ 1
[    8.296168] initcall mpiix_init+0x0/0x20 returned 0 after 0 usecs
[    8.304009] calling  oldpiix_init+0x0/0x20 @ 1
[    8.310531] initcall oldpiix_init+0x0/0x20 returned 0 after 0 usecs
[    8.312007] calling  pdc202xx_init+0x0/0x20 @ 1
[    8.316167] initcall pdc202xx_init+0x0/0x20 returned 0 after 0 usecs
[    8.320017] calling  sc1200_init+0x0/0x20 @ 1
[    8.328311] initcall sc1200_init+0x0/0x20 returned 0 after 3906 usecs
[    8.332007] calling  serverworks_init+0x0/0x20 @ 1
[    8.336169] initcall serverworks_init+0x0/0x20 returned 0 after 0 usecs
[    8.344009] calling  sil680_init+0x0/0x20 @ 1
[    8.350755] initcall sil680_init+0x0/0x20 returned 0 after 0 usecs
[    8.352007] calling  ata_generic_init+0x0/0x20 @ 1
[    8.356195] initcall ata_generic_init+0x0/0x20 returned 0 after 0 usecs
[    8.364009] calling  at25_init+0x0/0x20 @ 1
[    8.368752] initcall at25_init+0x0/0x20 returned 0 after 0 usecs
[    8.372007] calling  tle62x0_init+0x0/0x20 @ 1
[    8.376147] initcall tle62x0_init+0x0/0x20 returned 0 after 0 usecs
[    8.384009] calling  aoe_init+0x0/0xc0 @ 1
[    8.391525] aoe: AoE v47 initialised.
[    8.392264] initcall aoe_init+0x0/0xc0 returned 0 after 3906 usecs
[    8.396006] calling  mon_init+0x0/0x140 @ 1
[    8.400718] initcall mon_init+0x0/0x140 returned 0 after 0 usecs
[    8.404008] calling  ehci_hcd_init+0x0/0x120 @ 1
[    8.408144] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.412146] ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
[    8.416017] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[    8.420008] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[    8.424211] initcall ehci_hcd_init+0x0/0x120 returned 0 after 15625 usecs
[    8.432047] calling  ohci_hcd_mod_init+0x0/0x120 @ 1
[    8.436005] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.440094] ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[    8.448007] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[    8.460010] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[    8.466406] initcall ohci_hcd_mod_init+0x0/0x120 returned 0 after 27343 usecs
[    8.468007] calling  uhci_hcd_init+0x0/0x100 @ 1
[    8.472004] uhci_hcd: USB Universal Host Controller Interface driver
[    8.476673] initcall uhci_hcd_init+0x0/0x100 returned 0 after 3906 usecs
[    8.480007] calling  c67x00_init+0x0/0x20 @ 1
[    8.488054] initcall c67x00_init+0x0/0x20 returned 0 after 3906 usecs
[    8.492009] calling  acm_init+0x0/0x150 @ 1
[    8.498932] usbcore: registered new interface driver cdc_acm
[    8.500013] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    8.504006] initcall acm_init+0x0/0x150 returned 0 after 7812 usecs
[    8.508005] calling  usb_stor_init+0x0/0x50 @ 1
[    8.512004] Initializing USB Mass Storage driver...
[    8.516174] usbcore: registered new interface driver usb-storage
[    8.520027] USB Mass Storage support registered.
[    8.524007] initcall usb_stor_init+0x0/0x50 returned 0 after 11718 usecs
[    8.532008] calling  adu_init+0x0/0xa0 @ 1
[    8.536005] drivers/usb/misc/adutux.c :  adu_init : enter 
[    8.543770] usbcore: registered new interface driver adutux
[    8.544013] adutux adutux (see www.ontrak.net) v0.0.13
[    8.548004] adutux is an experimental driver. Use at your own risk
[    8.552004] drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
[    8.556006] initcall adu_init+0x0/0xa0 returned 0 after 19531 usecs
[    8.560005] calling  cypress_init+0x0/0x40 @ 1
[    8.564137] usbcore: registered new interface driver cypress_cy7c63
[    8.572016] initcall cypress_init+0x0/0x40 returned 0 after 7812 usecs
[    8.576013] calling  usb_cytherm_init+0x0/0x60 @ 1
[    8.583855] usbcore: registered new interface driver cytherm
[    8.584012] cytherm: v1.0:Cypress USB Thermometer driver
[    8.588006] initcall usb_cytherm_init+0x0/0x60 returned 0 after 7812 usecs
[    8.592005] calling  emi26_init+0x0/0x20 @ 1
[    8.596135] usbcore: registered new interface driver emi26 - firmware loader
[    8.604016] initcall emi26_init+0x0/0x20 returned 0 after 7812 usecs
[    8.608006] calling  ftdi_elan_init+0x0/0x180 @ 1
[    8.612006] driver ftdi-elan built at 16:24:24 on Oct 23 2008
[    8.622161] usbcore: registered new interface driver ftdi-elan
[    8.624013] initcall ftdi_elan_init+0x0/0x180 returned 0 after 11718 usecs
[    8.628008] calling  usb_lcd_init+0x0/0x40 @ 1
[    8.632218] usbcore: registered new interface driver usblcd
[    8.636012] initcall usb_lcd_init+0x0/0x40 returned 0 after 3906 usecs
[    8.640026] calling  lego_usb_tower_init+0x0/0x90 @ 1
[    8.644004] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
[    8.648156] usbcore: registered new interface driver legousbtower
[    8.656034] legousbtower: v0.96:LEGO USB Tower Driver
[    8.660005] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
[    8.668008] initcall lego_usb_tower_init+0x0/0x90 returned 0 after 23437 usecs
[    8.676007] calling  usb_rio_init+0x0/0x40 @ 1
[    8.681950] usbcore: registered new interface driver rio500
[    8.684012] rio500: v1.1:USB Rio 500 driver
[    8.688006] initcall usb_rio_init+0x0/0x40 returned 0 after 7812 usecs
[    8.692005] calling  usb_sisusb_init+0x0/0x20 @ 1
[    8.696135] usbcore: registered new interface driver sisusb
[    8.704016] initcall usb_sisusb_init+0x0/0x20 returned 0 after 7812 usecs
[    8.708006] calling  i8042_init+0x0/0xd0 @ 1
[    8.718415] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.720135] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.728021] initcall i8042_init+0x0/0xd0 returned 0 after 15625 usecs
[    8.732006] calling  pcips2_init+0x0/0x20 @ 1
[    8.739902] initcall pcips2_init+0x0/0x20 returned 0 after 0 usecs
[    8.740044] calling  mousedev_init+0x0/0x70 @ 1
[    8.744721] mice: PS/2 mouse device common for all mice
[    8.748009] initcall mousedev_init+0x0/0x70 returned 0 after 3906 usecs
[    8.752026] calling  atkbd_init+0x0/0x20 @ 1
[    8.756117] initcall atkbd_init+0x0/0x20 returned 0 after 0 usecs
[    8.764063] calling  xtkbd_init+0x0/0x20 @ 1
[    8.769841] initcall xtkbd_init+0x0/0x20 returned 0 after 0 usecs
[    8.772008] calling  nkbd_init+0x0/0x20 @ 1
[    8.780121] initcall nkbd_init+0x0/0x20 returned 0 after 3906 usecs
[    8.784010] calling  skbd_init+0x0/0x20 @ 1
[    8.790795] initcall skbd_init+0x0/0x20 returned 0 after 0 usecs
[    8.792008] calling  adi_init+0x0/0x20 @ 1
[    8.792242] input: AT Translated Set 2 keyboard as /class/input/input0
[    8.796087] initcall adi_init+0x0/0x20 returned 0 after 0 usecs
[    8.804008] calling  analog_init+0x0/0x130 @ 1
[    8.810067] initcall analog_init+0x0/0x130 returned 0 after 0 usecs
[    8.812007] calling  gf2k_init+0x0/0x20 @ 1
[    8.816243] initcall gf2k_init+0x0/0x20 returned 0 after 0 usecs
[    8.820008] calling  iforce_init+0x0/0x60 @ 1
[    8.824157] usbcore: registered new interface driver iforce
[    8.832772] initcall iforce_init+0x0/0x60 returned 0 after 7812 usecs
[    8.836007] calling  joydump_init+0x0/0x20 @ 1
[    8.840138] initcall joydump_init+0x0/0x20 returned 0 after 0 usecs
[    8.848027] calling  twidjoy_init+0x0/0x20 @ 1
[    8.854556] initcall twidjoy_init+0x0/0x20 returned 0 after 0 usecs
[    8.856027] calling  warrior_init+0x0/0x20 @ 1
[    8.860169] initcall warrior_init+0x0/0x20 returned 0 after 0 usecs
[    8.864010] calling  zhenhua_init+0x0/0x20 @ 1
[    8.872143] initcall zhenhua_init+0x0/0x20 returned 0 after 3906 usecs
[    8.876009] calling  usb_acecad_init+0x0/0x40 @ 1
[    8.884015] usbcore: registered new interface driver usb_acecad
[    8.888031] acecad: v3.2:USB Acecad Flair tablet driver
[    8.892007] initcall usb_acecad_init+0x0/0x40 returned 0 after 11718 usecs
[    8.896006] calling  ads7846_init+0x0/0x20 @ 1
[    8.900194] initcall ads7846_init+0x0/0x20 returned 0 after 0 usecs
[    8.908010] calling  gunze_init+0x0/0x20 @ 1
[    8.913222] initcall gunze_init+0x0/0x20 returned 0 after 0 usecs
[    8.916008] calling  fujitsu_init+0x0/0x20 @ 1
[    8.920156] initcall fujitsu_init+0x0/0x20 returned 0 after 0 usecs
[    8.928010] calling  inexio_init+0x0/0x20 @ 1
[    8.934594] initcall inexio_init+0x0/0x20 returned 0 after 0 usecs
[    8.936008] calling  usb_keyspan_init+0x0/0x40 @ 1
[    8.940161] usbcore: registered new interface driver keyspan_remote
[    8.944017] initcall usb_keyspan_init+0x0/0x40 returned 0 after 3906 usecs
[    8.952007] calling  abituguru_init+0x0/0x180 @ 1
[    8.956008] abituguru: no Abit uGuru found, data = 0xFF, cmd = 0xFF
[    8.964008] initcall abituguru_init+0x0/0x180 returned -19 after 7812 usecs
[    8.972007] calling  f71882fg_init+0x0/0x120 @ 1
[    8.976014] f71882fg: Not a Fintek device
[    8.980017] f71882fg: Not a Fintek device
[    8.984007] initcall f71882fg_init+0x0/0x120 returned -19 after 7812 usecs
[    8.988007] calling  sm_it87_init+0x0/0x390 @ 1
[    8.996029] it87: Found IT8712F chip at 0x290, revision 7
[    9.000010] it87: in3 is VCC (+5V)
[    9.004005] it87: in7 is VCCH (+5V Stand-By)
[    9.009953] it87 it87.656: Detected broken BIOS defaults, disabling PWM interface
[    9.012924] initcall sm_it87_init+0x0/0x390 returned 0 after 15625 usecs
[    9.016007] calling  max1111_init+0x0/0x20 @ 1
[    9.020164] initcall max1111_init+0x0/0x20 returned 0 after 0 usecs
[    9.024010] calling  smsc47b397_init+0x0/0x1e0 @ 1
[    9.032033] initcall smsc47b397_init+0x0/0x1e0 returned -19 after 0 usecs
[    9.036006] calling  sm_via686a_init+0x0/0x20 @ 1
[    9.044127] initcall sm_via686a_init+0x0/0x20 returned 0 after 3906 usecs
[    9.048007] calling  wdtpci_init+0x0/0x20 @ 1
[    9.052222] initcall wdtpci_init+0x0/0x20 returned 0 after 0 usecs
[    9.060010] calling  acq_init+0x0/0x70 @ 1
[    9.064004] WDT driver for Acquire single board computer initialising.
[    9.072581] acquirewdt: I/O address 0x0043 already in use
[    9.076023] acquirewdt: probe of acquirewdt failed with error -5
[    9.080011] initcall acq_init+0x0/0x70 returned 0 after 15625 usecs
[    9.084006] calling  advwdt_init+0x0/0x70 @ 1
[    9.088004] WDT driver for Advantech single board computer initialising.
[    9.092800] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[    9.096015] initcall advwdt_init+0x0/0x70 returned 0 after 7812 usecs
[    9.100030] calling  watchdog_init+0x0/0x1b0 @ 1
[    9.104049] initcall watchdog_init+0x0/0x1b0 returned -19 after 0 usecs
[    9.108005] calling  alim7101_wdt_init+0x0/0x200 @ 1
[    9.112004] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[    9.116023] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    9.120006] initcall alim7101_wdt_init+0x0/0x200 returned -16 after 7812 usecs
[    9.124006] initcall alim7101_wdt_init+0x0/0x200 returned with error code -16 
[    9.128008] calling  wafwdt_init+0x0/0x190 @ 1
[    9.132004] WDT driver for Wafer 5823 single board computer initialising.
[    9.136010] Wafer 5823 WDT: I/O address 0x0443 already in use
[    9.140008] initcall wafwdt_init+0x0/0x190 returned -5 after 7812 usecs
[    9.144005] initcall wafwdt_init+0x0/0x190 returned with error code -5 
[    9.148005] calling  pc87413_init+0x0/0xb0 @ 1
[    9.152004] pc87413 WDT: Version 1.1 at io 0x2E
[    9.156006] pc87413 WDT: cannot register miscdev on minor=130 (err=-16)
[    9.160006] initcall pc87413_init+0x0/0xb0 returned -16 after 7812 usecs
[    9.164006] initcall pc87413_init+0x0/0xb0 returned with error code -16 
[    9.168006] calling  cpu5wdt_init_module+0x0/0x160 @ 1
[    9.172008] cpu5wdt: sorry, was my fault
[    9.176005] cpu5wdt: misc_register failed
[    9.180008] initcall cpu5wdt_init_module+0x0/0x160 returned -16 after 7812 usecs
[    9.184006] initcall cpu5wdt_init_module+0x0/0x160 returned with error code -16 
[    9.188006] calling  wdt_init+0x0/0x210 @ 1
[    9.192004] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
[    9.196024] w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
[    9.200020] w83627hf/thf/hg WDT: cannot register miscdev on minor=130 (err=-16)
[    9.204008] initcall wdt_init+0x0/0x210 returned -16 after 11718 usecs
[    9.208006] initcall wdt_init+0x0/0x210 returned with error code -16 
[    9.212006] calling  telephony_init+0x0/0x50 @ 1
[    9.216004] Linux telephony interface: v1.00
[    9.220027] initcall telephony_init+0x0/0x50 returned 0 after 3906 usecs
[    9.224006] calling  raid0_init+0x0/0x20 @ 1
[    9.228072] md: raid0 personality registered for level 0
[    9.232007] initcall raid0_init+0x0/0x20 returned 0 after 3906 usecs
[    9.236006] calling  raid_init+0x0/0x20 @ 1
[    9.240005] md: raid10 personality registered for level 10
[    9.244006] initcall raid_init+0x0/0x20 returned 0 after 3906 usecs
[    9.248006] calling  kcapi_init+0x0/0xa0 @ 1
[    9.252089] CAPI Subsystem Rev 1.1.2.8
[    9.256006] initcall kcapi_init+0x0/0xa0 returned 0 after 3906 usecs
[    9.260005] calling  cpufreq_gov_dbs_init+0x0/0x20 @ 1
[    9.264007] initcall cpufreq_gov_dbs_init+0x0/0x20 returned 0 after 0 usecs
[    9.268005] calling  init_ladder+0x0/0x20 @ 1
[    9.272051] cpuidle: using governor ladder
[    9.276006] initcall init_ladder+0x0/0x20 returned 0 after 3906 usecs
[    9.280005] calling  heartbeat_trig_init+0x0/0x20 @ 1
[    9.284189] initcall heartbeat_trig_init+0x0/0x20 returned 0 after 0 usecs
[    9.288005] calling  init_soundcore+0x0/0x70 @ 1
[    9.292149] initcall init_soundcore+0x0/0x70 returned 0 after 0 usecs
[    9.296067] calling  sysctl_core_init+0x0/0x30 @ 1
[    9.300600] initcall sysctl_core_init+0x0/0x30 returned 0 after 3906 usecs
[    9.308007] calling  flow_cache_init+0x0/0x1e0 @ 1
[    9.316029] initcall flow_cache_init+0x0/0x1e0 returned 0 after 3906 usecs
[    9.320005] calling  llc_init+0x0/0x20 @ 1
[    9.324008] initcall llc_init+0x0/0x20 returned 0 after 0 usecs
[    9.328007] calling  snap_init+0x0/0x40 @ 1
[    9.332043] initcall snap_init+0x0/0x40 returned 0 after 0 usecs
[    9.336005] calling  rif_init+0x0/0xa0 @ 1
[    9.340112] initcall rif_init+0x0/0xa0 returned 0 after 0 usecs
[    9.344005] calling  blackhole_module_init+0x0/0x20 @ 1
[    9.348007] initcall blackhole_module_init+0x0/0x20 returned 0 after 0 usecs
[    9.352005] calling  hfsc_init+0x0/0x20 @ 1
[    9.356006] initcall hfsc_init+0x0/0x20 returned 0 after 0 usecs
[    9.360005] calling  sfq_module_init+0x0/0x20 @ 1
[    9.364006] initcall sfq_module_init+0x0/0x20 returned 0 after 0 usecs
[    9.368005] calling  teql_init+0x0/0xf0 @ 1
[    9.376170] initcall teql_init+0x0/0xf0 returned 0 after 3906 usecs
[    9.380005] calling  prio_module_init+0x0/0x20 @ 1
[    9.384008] initcall prio_module_init+0x0/0x20 returned 0 after 0 usecs
[    9.392006] calling  init_route4+0x0/0x20 @ 1
[    9.396073] initcall init_route4+0x0/0x20 returned 0 after 0 usecs
[    9.404007] calling  init_basic+0x0/0x20 @ 1
[    9.408016] initcall init_basic+0x0/0x20 returned 0 after 0 usecs
[    9.412007] calling  cls_flow_init+0x0/0x20 @ 1
[    9.416006] initcall cls_flow_init+0x0/0x20 returned 0 after 0 usecs
[    9.424028] calling  nfnetlink_init+0x0/0x70 @ 1
[    9.428004] Netfilter messages via NETLINK v0.30.
[    9.432062] initcall nfnetlink_init+0x0/0x70 returned 0 after 3906 usecs
[    9.440007] calling  nfnetlink_queue_init+0x0/0xd0 @ 1
[    9.444074] initcall nfnetlink_queue_init+0x0/0xd0 returned 0 after 0 usecs
[    9.452007] calling  nfnetlink_log_init+0x0/0xd0 @ 1
[    9.456025] initcall nfnetlink_log_init+0x0/0xd0 returned 0 after 0 usecs
[    9.464007] calling  sysctl_ipv4_init+0x0/0x60 @ 1
[    9.472491] initcall sysctl_ipv4_init+0x0/0x60 returned 0 after 3906 usecs
[    9.476006] calling  ipgre_init+0x0/0xd0 @ 1
[    9.480006] GRE over IPv4 tunneling driver
[    9.490216] initcall ipgre_init+0x0/0xd0 returned 0 after 7812 usecs
[    9.492007] calling  ah4_init+0x0/0x70 @ 1
[    9.496009] initcall ah4_init+0x0/0x70 returned 0 after 0 usecs
[    9.500005] calling  ipcomp4_init+0x0/0x70 @ 1
[    9.504007] initcall ipcomp4_init+0x0/0x70 returned 0 after 0 usecs
[    9.508005] calling  ipip_init+0x0/0xc0 @ 1
[    9.512064] initcall ipip_init+0x0/0xc0 returned 0 after 0 usecs
[    9.516005] calling  xfrm4_beet_init+0x0/0x20 @ 1
[    9.520007] initcall xfrm4_beet_init+0x0/0x20 returned 0 after 0 usecs
[    9.524005] calling  tunnel4_init+0x0/0x70 @ 1
[    9.528010] initcall tunnel4_init+0x0/0x70 returned 0 after 0 usecs
[    9.532006] calling  ipv4_netfilter_init+0x0/0x20 @ 1
[    9.536052] initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 0 usecs
[    9.540005] calling  cubictcp_register+0x0/0x70 @ 1
[    9.544005] TCP cubic registered
[    9.548006] initcall cubictcp_register+0x0/0x70 returned 0 after 3906 usecs
[    9.552005] calling  packet_init+0x0/0x50 @ 1
[    9.556007] NET: Registered protocol family 17
[    9.560078] initcall packet_init+0x0/0x50 returned 0 after 3906 usecs
[    9.564006] calling  ipsec_pfkey_init+0x0/0xa0 @ 1
[    9.568013] NET: Registered protocol family 15
[    9.572047] initcall ipsec_pfkey_init+0x0/0xa0 returned 0 after 3906 usecs
[    9.576006] calling  br_init+0x0/0xf0 @ 1
[    9.580754] Bridge firewalling registered
[    9.584064] initcall br_init+0x0/0xf0 returned 0 after 3906 usecs
[    9.588030] calling  dsa_init_module+0x0/0x20 @ 1
[    9.592007] initcall dsa_init_module+0x0/0x20 returned 0 after 0 usecs
[    9.596005] calling  edsa_init_module+0x0/0x20 @ 1
[    9.600007] initcall edsa_init_module+0x0/0x20 returned 0 after 0 usecs
[    9.604005] calling  trailer_init_module+0x0/0x20 @ 1
[    9.608007] initcall trailer_init_module+0x0/0x20 returned 0 after 0 usecs
[    9.612005] calling  mv88e6060_init+0x0/0x20 @ 1
[    9.616051] initcall mv88e6060_init+0x0/0x20 returned 0 after 0 usecs
[    9.620006] calling  mv88e6123_61_65_init+0x0/0x20 @ 1
[    9.624007] initcall mv88e6123_61_65_init+0x0/0x20 returned 0 after 0 usecs
[    9.628008] calling  mv88e6131_init+0x0/0x20 @ 1
[    9.632007] initcall mv88e6131_init+0x0/0x20 returned 0 after 0 usecs
[    9.636005] calling  dsa_init_module+0x0/0x20 @ 1
[    9.640158] initcall dsa_init_module+0x0/0x20 returned 0 after 0 usecs
[    9.648029] calling  x25_init+0x0/0x70 @ 1
[    9.652008] NET: Registered protocol family 9
[    9.656011] X.25 for Linux Version 0.2
[    9.660350] initcall x25_init+0x0/0x70 returned 0 after 7812 usecs
[    9.668007] calling  rose_proto_init+0x0/0x2f0 @ 1
[    9.699054] NET: Registered protocol family 11
[    9.704192] initcall rose_proto_init+0x0/0x2f0 returned 0 after 31250 usecs
[    9.708008] calling  ax25_init+0x0/0xb0 @ 1
[    9.712006] NET: Registered protocol family 3
[    9.716139] initcall ax25_init+0x0/0xb0 returned 0 after 7812 usecs
[    9.724007] calling  init_sunrpc+0x0/0x80 @ 1
[    9.732845] RPC: Registered udp transport module.
[    9.736005] RPC: Registered tcp transport module.
[    9.740014] initcall init_sunrpc+0x0/0x80 returned 0 after 11718 usecs
[    9.744006] calling  econet_proto_init+0x0/0x1e0 @ 1
[    9.748008] NET: Registered protocol family 19
[    9.752281] initcall econet_proto_init+0x0/0x1e0 returned 0 after 3906 usecs
[    9.756006] calling  phonet_init+0x0/0x90 @ 1
[    9.760005] NET: Registered protocol family 35
[    9.764706] initcall phonet_init+0x0/0x90 returned 0 after 3906 usecs
[    9.768008] calling  pep_register+0x0/0x20 @ 1
[    9.772337] initcall pep_register+0x0/0x20 returned 0 after 0 usecs
[    9.776009] calling  ieee80211_init+0x0/0x30 @ 1
[    9.784028] ieee80211: 802.11 data/management/control stack, git-1.1.13
[    9.788004] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[    9.796007] initcall ieee80211_init+0x0/0x30 returned 0 after 11718 usecs
[    9.804007] calling  ieee80211_crypto_init+0x0/0x20 @ 1
[    9.808034] ieee80211_crypt: registered algorithm 'NULL'
[    9.816008] initcall ieee80211_crypto_init+0x0/0x20 returned 0 after 7812 usecs
[    9.820005] calling  ieee80211_crypto_wep_init+0x0/0x20 @ 1
[    9.828008] ieee80211_crypt: registered algorithm 'WEP'
[    9.832006] initcall ieee80211_crypto_wep_init+0x0/0x20 returned 0 after 3906 usecs
[    9.840008] calling  ieee80211_crypto_tkip_init+0x0/0x20 @ 1
[    9.844007] ieee80211_crypt: registered algorithm 'TKIP'
[    9.852008] initcall ieee80211_crypto_tkip_init+0x0/0x20 returned 0 after 7812 usecs
[    9.860007] calling  tipc_init+0x0/0xd0 @ 1
[    9.864039] TIPC: Activated (version 1.6.4 compiled Oct 23 2008 16:24:21)
[    9.873619] NET: Registered protocol family 30
[    9.876029] TIPC: Started in single node mode
[    9.880008] initcall tipc_init+0x0/0xd0 returned 0 after 15625 usecs
[    9.888009] calling  update_mp_table+0x0/0x520 @ 1
[    9.892014] initcall update_mp_table+0x0/0x520 returned 0 after 0 usecs
[    9.900007] calling  lapic_insert_resource+0x0/0x50 @ 1
[    9.904009] initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 usecs
[    9.912007] calling  ioapic_insert_resources+0x0/0x60 @ 1
[    9.916007] initcall ioapic_insert_resources+0x0/0x60 returned 0 after 0 usecs
[    9.924007] calling  io_apic_bug_finalize+0x0/0x20 @ 1
[    9.928006] initcall io_apic_bug_finalize+0x0/0x20 returned 0 after 0 usecs
[    9.936008] calling  check_early_ioremap_leak+0x0/0x70 @ 1
[    9.940006] initcall check_early_ioremap_leak+0x0/0x70 returned 0 after 0 usecs
[    9.948007] calling  pat_memtype_list_init+0x0/0x30 @ 1
[    9.952034] initcall pat_memtype_list_init+0x0/0x30 returned 0 after 0 usecs
[    9.960008] calling  sched_init_debug+0x0/0x30 @ 1
[    9.964025] initcall sched_init_debug+0x0/0x30 returned 0 after 0 usecs
[    9.972009] calling  init_oops_id+0x0/0x30 @ 1
[    9.976013] initcall init_oops_id+0x0/0x30 returned 0 after 0 usecs
[    9.980007] calling  disable_boot_consoles+0x0/0x40 @ 1
[    9.988008] initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 usecs
[    9.996008] calling  pm_qos_power_init+0x0/0x90 @ 1
[   10.001969] initcall pm_qos_power_init+0x0/0x90 returned 0 after 0 usecs
[   10.004039] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[   10.008071] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 0 usecs
[   10.012007] calling  fail_make_request_debugfs+0x0/0x20 @ 1
[   10.016145] initcall fail_make_request_debugfs+0x0/0x20 returned 0 after 0 usecs
[   10.020006] calling  fail_io_timeout_debugfs+0x0/0x20 @ 1
[   10.024144] initcall fail_io_timeout_debugfs+0x0/0x20 returned 0 after 0 usecs
[   10.028009] calling  random32_reseed+0x0/0xb0 @ 1
[   10.032027] initcall random32_reseed+0x0/0xb0 returned 0 after 0 usecs
[   10.036015] calling  pci_sysfs_init+0x0/0x60 @ 1
[   10.040527] initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 usecs
[   10.044006] calling  seqgen_init+0x0/0x10 @ 1
[   10.048024] initcall seqgen_init+0x0/0x10 returned 0 after 0 usecs
[   10.052005] calling  hd_init+0x0/0x350 @ 1
[   10.056101] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   10.060419] initcall hd_init+0x0/0x350 returned -1 after 3906 usecs
[   10.064005] initcall hd_init+0x0/0x350 returned with error code -1 
[   10.068007] calling  scsi_complete_async_scans+0x0/0x110 @ 1
[   10.072006] initcall scsi_complete_async_scans+0x0/0x110 returned 0 after 0 usecs
[   10.076005] calling  memmap_init+0x0/0xb0 @ 1
[   10.080183] initcall memmap_init+0x0/0xb0 returned 0 after 0 usecs
[   10.084006] calling  tcp_congestion_default+0x0/0x20 @ 1
[   10.088007] initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 usecs
[   10.092005] calling  ip_auto_config+0x0/0xf80 @ 1
[   10.096025] initcall ip_auto_config+0x0/0xf80 returned 0 after 0 usecs
[   10.100189] md: Waiting for all devices to be available before autodetect
[   10.104005] md: If you don't use raid, use raid=noautodetect
[   10.113134] md: Autodetecting RAID arrays.
[   10.116006] md: Scanned 0 and added 0 devices.
[   10.120006] md: autorun ...
[   10.124004] md: ... autorun DONE.
[   10.140491] EXT3-fs: INFO: recovery required on readonly filesystem.
[   10.144017] EXT3-fs: write access will be enabled during recovery.
[   10.170398] kjournald starting.  Commit interval 5 seconds
[   10.172225] EXT3-fs: recovery complete.
[   10.180877] EXT3-fs: mounted filesystem with ordered data mode.
[   10.184336] VFS: Mounted root (ext3 filesystem) readonly.
[   10.192086] debug: unmapping init memory ffffffff81644000..ffffffff81850000
[   10.196247] Write protecting the kernel read-only data: 2888k
[   10.204290] Testing CPA: undo ffffffff807e2000-ffffffff80ab4000
[   10.208160] Testing CPA: again
[   10.482334] SELinux:  Disabled at runtime.
[   10.484007] SELinux:  Unregistering netfilter hooks
[   10.548034] type=1404 audit(1224773435.548:2): selinux=0 auid=4294967295 ses=4294967295
[   13.239555] udev: renamed network interface eth0 to eth1
[   13.256430] udev: renamed network interface eth1_rename to eth0
[   14.370522] eth0: link down
[   21.557656] EXT3 FS on sda6, internal journal
[   21.683374] kjournald starting.  Commit interval 5 seconds
[   21.688302] EXT3 FS on sda5, internal journal
[   21.692016] EXT3-fs: mounted filesystem with ordered data mode.
[   25.073543] warning: `sudo' uses 32-bit capabilities (legacy support in use)
[   32.732022] CPA self-test:
[   32.746184]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   32.770375]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   32.793581]  4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
[   32.796004] ok.
