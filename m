Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbZCSHev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbZCSHev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZCSHej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:34:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60600 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZCSHea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:34:30 -0400
Date: Thu, 19 Mar 2009 08:33:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090319073357.GA14615@elte.hu>
References: <20090318031423.981603258@goodmis.org> <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20090318073903.GA31341@elte.hu>
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


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> these latest ftrace changes caused a lockup on a -tip testsystem:

Note, even with Rusty's offstack-cpumask fix applied (in latest 
-tip), i can reproduce a lockup:

[    4.132872] calling  init_mmio_trace+0x0/0x12 @ 1
[    4.137551] initcall init_mmio_trace+0x0/0x12 returned 0 after 10 usecs
[    4.144149] calling  init_graph_trace+0x0/0x12 @ 1
[    4.148913] Testing tracer function_graph: <3>INFO: RCU detected CPU 0 stall (t=4294680313/10000 jiffies)
[   18.620342] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067
[   18.620342] Call Trace:
[   18.620342]  <IRQ>  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b2d5>] print_context_stack+0xbc/0x11e
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80219c2e>] dump_trace+0x221/0x271
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b180>] show_trace_log_lvl+0x51/0x5e
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b1a2>] show_trace+0x15/0x17
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b505>] dump_stack+0x77/0x82
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e343b>] print_cpu_stall+0x40/0x9b
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e384f>] check_cpu_stall+0x11e/0x15c
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e38a4>] __rcu_pending+0x17/0xff
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e39b8>] rcu_pending+0x2c/0x5e
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8028b89a>] update_process_times+0x3c/0x76
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a901e>] tick_periodic+0x7a/0x86
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a9050>] tick_handle_periodic+0x26/0x8a
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a97f8>] tick_do_broadcast+0x1d4/0x23a
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a9929>] tick_do_periodic_broadcast+0x4c/0x5d
[   18.620342]  [<ffffffff802e28b9>] ? rcu_torture_timer+0x0/0x12b
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a994e>] tick_handle_periodic_broadcast+0x14/0x75
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80219f0f>] timer_interrupt+0x1f/0x26
[   18.620342]  [<ffffffff811f1a6d>] ? _spin_unlock_irq+0x9/0x3b
[   18.620342]  [<ffffffff811f1a9b>] ? _spin_unlock_irq+0x37/0x3b
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802dd04c>] handle_IRQ_event+0x167/0x230
[   18.620342]  [<ffffffff8025e8e4>] ? idle_cpu+0x4/0x33
[   18.620342]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
[   18.620342]  [<ffffffff80284453>] ? __local_bh_disable+0x11/0x16c
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802dfc86>] handle_edge_irq+0x1bf/0x225
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80219305>] handle_irq+0x15d/0x171
[   18.620342]  [<ffffffff802195e9>] ? do_softirq+0x80/0x187
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff811f2457>] do_IRQ+0x5f/0xfc
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80215953>] ret_from_intr+0x0/0x16
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8028aa1d>] run_timer_softirq+0x1c1/0x2af
[   18.620342]  <EOI>  [<ffffffff802ce8f0>] ? ack_state+0x4/0x45
[   18.620342]  [<ffffffff802ced22>] ? stop_cpu+0x1c5/0x1d1
[   18.620342]  [<ffffffff80294a29>] ? run_workqueue+0x1a0/0x2e2
[   18.620342]  [<ffffffff802949d6>] ? run_workqueue+0x14d/0x2e2
[   18.620342]  [<ffffffff802ceb5d>] ? stop_cpu+0x0/0x1d1
[   18.620342]  [<ffffffff826b4140>] ? early_idt_handler+0x0/0x73
[   18.620342]  [<ffffffff80295d1b>] ? worker_thread+0x138/0x14c
[   18.620342]  [<ffffffff80299e63>] ? autoremove_wake_function+0x0/0x4f
[   18.620342]  [<ffffffff80295be3>] ? worker_thread+0x0/0x14c
[   18.620342]  [<ffffffff80299d20>] ? kthread+0x60/0xa0
[   18.620342]  [<ffffffff8021606a>] ? child_rip+0xa/0x20
[   18.620342]  [<ffffffff8026fd4b>] ? finish_task_switch+0x56/0x180
[   18.620342]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
[   18.620342]  [<ffffffff80299cc0>] ? kthread+0x0/0xa0
[   18.620342]  [<ffffffff80216060>] ? child_rip+0x0/0x20
[   64.758749] INFO: RCU detected CPU 0 stall (t=4294710313/40000 jiffies)
[   64.758749] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067

(the hang is real - it lasted overnight without the system ever 
managing to boot up.)

Config (note, it's different from the config i sent last) and full 
bootlog attached.

	Ingo

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hang.log"

[    0.000000] Linux version 2.6.29-rc8-tip-02638-g1c002f5-dirty (mingo@titan) (gcc version 4.2.3) #3067 SMP Thu Mar 19 08:22:22 CET 2009
[    0.000000] Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi no_hz=off highres=0 nmi_watchdog=0 nolapic_timer hpet=disable idle=mwait idle=poll nopat notsc
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)
[    0.000000]  BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)
[    0.000000]  BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)
[    0.000000]  BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] using polling idle threads.
[    0.000000] last_pfn = 0x3ff00 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 03FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   get_mtrr: cpu0 reg00 base=0000000000 size=0000040000 write-back
[    0.000000]   get_mtrr: cpu0 reg01 base=000003ff00 size=0000000100 uncachable
[    0.000000] init_memory_mapping: 0000000000000000-000000003ff00000
[    0.000000]  0000000000 - 003ff00000 page 4k
[    0.000000] kernel direct mapping tables up to 3ff00000 @ 35d2000-37d4000
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 3FEFDE48, 0050 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] ACPI: FACP 3FEFCF10, 0074 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 3FEF8010, 3E70 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] ACPI: FACS 3FEDFC40, 0040
[    0.000000] ACPI: APIC 3FEFCE10, 0078 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] ACPI: WDDT 3FEF7F90, 0040 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] ACPI: MCFG 3FEF7F10, 003C (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] ACPI: ASF! 3FEFCD10, 00A6 (r32 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] ACPI: HPET 3FEF7E90, 0038 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] ACPI: SSDT 3FEFDC10, 01BC (r1 INTEL     CpuPm      4B9 MSFT  1000013)
[    0.000000] ACPI: SSDT 3FEFDA10, 01B7 (r1 INTEL   Cpu0Ist      4B9 MSFT  1000013)
[    0.000000] ACPI: SSDT 3FEFD810, 01B7 (r1 INTEL   Cpu1Ist      4B9 MSFT  1000013)
[    0.000000] ACPI: SSDT 3FEFD610, 01B7 (r1 INTEL   Cpu2Ist      4B9 MSFT  1000013)
[    0.000000] ACPI: SSDT 3FEFD410, 01B7 (r1 INTEL   Cpu3Ist      4B9 MSFT  1000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003ff00000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00035d1fb0]    TEXT DATA BSS ==> [0000200000 - 00035d1fb0]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [00035d2000 - 00037d2000]          PGTABLE ==> [00035d2000 - 00037d2000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000fe680] fe680
[    0.000000]   mpc: fe690-fe6d0
[    0.000000]  [ffffe20000000000-ffffe200019fffff] PMD -> [ffff880003a00000-ffff8800053fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003ed94
[    0.000000]     0: 0x0003ee4e -> 0x0003fea2
[    0.000000]     0: 0x0003fee9 -> 0x0003feed
[    0.000000]     0: 0x0003feff -> 0x0003ff00
[    0.000000] On node 0 totalpages: 261516
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 99 pages reserved
[    0.000000]   DMA zone: 3796 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6546 pages used for memmap
[    0.000000]   DMA32 zone: 250971 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000003ed94000 - 000000003ee4e000
[    0.000000] PM: Registered nosave memory: 000000003fea2000 - 000000003fee9000
[    0.000000] PM: Registered nosave memory: 000000003feed000 - 000000003feff000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3ff00000:c0100000)
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages at ffff880005400000, static data 1922592 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 254767
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi no_hz=off highres=0 nmi_watchdog=0 nolapic_timer hpet=disable idle=mwait idle=poll nopat notsc
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:440
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2933.032 MHz processor.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000000] ... CHAINHASH_SIZE:          8192
[    0.000000]  memory used by lock dependency info: 5119 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 888664k/1047552k available (16337k kernel code, 1488k absent, 156680k reserved, 20532k data, 2664k init)
[    0.000000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000999] Calibrating delay loop... 5783.55 BogoMIPS (lpj=2891776)
[    0.026995] Security Framework initialized
[    0.027995] SELinux:  Initializing.
[    0.028995] SELinux:  Starting in enforcing mode
[    0.029995] Mount-cache hash table entries: 256
[    0.031995] Initializing cgroup subsys ns
[    0.032994] Initializing cgroup subsys cpuacct
[    0.033994] Initializing cgroup subsys devices
[    0.034994] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.036994] CPU: L2 cache: 4096K
[    0.037994] [ds] using Core 2/Atom configuration
[    0.038994] CPU: Physical Processor ID: 0
[    0.039993] CPU: Processor Core ID: 0
[    0.040993] Intel Performance Monitoring support detected.
[    0.041993] ... version:         2
[    0.042993] ... bit width:       40
[    0.043993] ... mask length:     7
[    0.044993] ... num counters:    2
[    0.045993] ... value mask:      000000ffffffffff
[    0.046992] ... fixed counters:  0
[    0.047992] ... counter mask:    0000000000000003
[    0.049992] ACPI: Core revision 20081204
[    0.072988] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.073988] ftrace: allocating 37382 entries in 147 pages
[    0.076988] Setting APIC routing to flat
[    0.077988] enabled ExtINT on CPU#0
[    0.079987] ENABLING IO-APIC IRQs
[    0.080987] init IO_APIC IRQs
[    0.081987]  2-0 (apicid-pin) not connected
[    0.083987] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.084987] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.085986] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.086986] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.087986] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.088986] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.089986] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.090986] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.091985] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.092985] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.093985] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.094985] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.095985] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.096985] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.097985] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.098984]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.103984] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.114982] CPU0: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
[    0.117982] Disabling APIC timer
[    0.119981] calling  migration_init+0x0/0x87 @ 1
[    0.120981] initcall migration_init+0x0/0x87 returned 1 after 0 usecs
[    0.121981] initcall migration_init+0x0/0x87 returned with error code 1 
[    0.122981] calling  spawn_ksoftirqd+0x0/0x7a @ 1
[    0.123981] initcall spawn_ksoftirqd+0x0/0x7a returned 0 after 0 usecs
[    0.124980] calling  init_call_single_data+0x0/0x18a @ 1
[    0.125980] initcall init_call_single_data+0x0/0x18a returned 0 after 0 usecs
[    0.126980] calling  spawn_softlockup_task+0x0/0x99 @ 1
[    0.127980] initcall spawn_softlockup_task+0x0/0x99 returned 0 after 0 usecs
[    0.128980] calling  relay_init+0x0/0x14 @ 1
[    0.129980] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.130980] calling  tracer_alloc_buffers+0x0/0x437 @ 1
[    0.131979] Testing tracer nop: PASSED
[    0.132979] initcall tracer_alloc_buffers+0x0/0x437 returned 0 after 976 usecs
[    0.133979] calling  init_trace_printk+0x0/0x8 @ 1
[    0.134979] initcall init_trace_printk+0x0/0x8 returned 0 after 0 usecs
[    0.135979] calling  trace_workqueue_early_init+0x0/0x261 @ 1
[    0.136979] initcall trace_workqueue_early_init+0x0/0x261 returned 0 after 0 usecs
[    0.137978] calling  perf_counter_init+0x0/0x30 @ 1
[    0.138978] initcall perf_counter_init+0x0/0x30 returned 0 after 0 usecs
[    0.139978] lockdep: fixing up alternatives.
[    0.140978] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] masked ExtINT on CPU#1
[    0.000999] Calibrating delay loop... 5849.08 BogoMIPS (lpj=2924544)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] [ds] using Core 2/Atom configuration
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.176973] CPU1: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
[    0.179972] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.180972] Brought up 2 CPUs
[    0.181972] Total of 2 processors activated (11632.64 BogoMIPS).
[    0.183971] CPU0 attaching sched-domain:
[    0.184971]  domain 0: span 0-1 level CPU
[    0.186971]   groups: 0 1
[    0.187971] CPU1 attaching sched-domain:
[    0.188971]  domain 0: span 0-1 level CPU
[    0.190970]   groups: 1 0
[    0.193970] device: 'platform': device_add
[    0.194970] PM: Adding info for No Bus:platform
[    0.196969] bus: 'platform': registered
[    0.197969] Registering sysdev class 'cpu'
[    0.199969] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.200969] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.201969] calling  net_ns_init+0x0/0xbf @ 1
[    0.202969] net_namespace: 2224 bytes
[    0.203968] initcall net_ns_init+0x0/0xbf returned 0 after 976 usecs
[    0.204968] calling  e820_mark_nvs_memory+0x0/0x53 @ 1
[    0.206968] initcall e820_mark_nvs_memory+0x0/0x53 returned 0 after 976 usecs
[    0.207968] calling  cpufreq_tsc+0x0/0x53 @ 1
[    0.208968] initcall cpufreq_tsc+0x0/0x53 returned 0 after 0 usecs
[    0.209967] calling  print_banner+0x0/0xe @ 1
[    0.210967] Booting paravirtualized kernel on bare hardware
[    0.211967] initcall print_banner+0x0/0xe returned 0 after 976 usecs
[    0.212967] calling  init_smp_flush+0x0/0x41 @ 1
[    0.213967] initcall init_smp_flush+0x0/0x41 returned 0 after 0 usecs
[    0.214967] calling  alloc_frozen_cpus+0x0/0x33 @ 1
[    0.215967] initcall alloc_frozen_cpus+0x0/0x33 returned 0 after 0 usecs
[    0.216966] calling  sysctl_init+0x0/0x16 @ 1
[    0.217966] initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
[    0.218966] calling  ksysfs_init+0x0/0x137 @ 1
[    0.219966] initcall ksysfs_init+0x0/0x137 returned 0 after 0 usecs
[    0.220966] calling  async_init+0x0/0xb7 @ 1
[    0.221966] initcall async_init+0x0/0xb7 returned 0 after 0 usecs
[    0.222966] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.223965] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.224965] calling  pm_init+0x0/0x46 @ 1
[    0.225965] initcall pm_init+0x0/0x46 returned 0 after 0 usecs
[    0.226965] calling  pm_disk_init+0x0/0x19 @ 1
[    0.227965] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.228965] calling  swsusp_header_init+0x0/0x45 @ 1
[    0.229964] initcall swsusp_header_init+0x0/0x45 returned 0 after 0 usecs
[    0.230964] calling  filelock_init+0x0/0x2e @ 1
[    0.231964] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.232964] calling  init_misc_binfmt+0x0/0x63 @ 1
[    0.233964] initcall init_misc_binfmt+0x0/0x63 returned 0 after 0 usecs
[    0.234964] calling  init_script_binfmt+0x0/0x12 @ 1
[    0.235964] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.236963] calling  init_elf_binfmt+0x0/0x12 @ 1
[    0.237963] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.238963] calling  init_compat_elf_binfmt+0x0/0x12 @ 1
[    0.239963] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.240963] calling  debugfs_init+0x0/0x75 @ 1
[    0.241963] initcall debugfs_init+0x0/0x75 returned 0 after 0 usecs
[    0.242962] calling  securityfs_init+0x0/0x75 @ 1
[    0.244962] initcall securityfs_init+0x0/0x75 returned 0 after 0 usecs
[    0.245962] calling  random32_init+0x0/0x1a5 @ 1
[    0.246962] initcall random32_init+0x0/0x1a5 returned 0 after 0 usecs
[    0.247962] calling  gnttab_init+0x0/0x1d7 @ 1
[    0.248962] initcall gnttab_init+0x0/0x1d7 returned -19 after 0 usecs
[    0.249961] calling  regulator_init+0x0/0x2e @ 1
[    0.250961] regulator: core version 0.5
[    0.251961] device class 'regulator': registering
[    0.252961] initcall regulator_init+0x0/0x2e returned 0 after 1952 usecs
[    0.253961] calling  early_resume_init+0x0/0x18 @ 1
[    0.254961] Time:  7:23:40  Date: 03/19/09
[    0.255960] initcall early_resume_init+0x0/0x18 returned 0 after 976 usecs
[    0.256960] calling  cpufreq_core_init+0x0/0x169 @ 1
[    0.257960] initcall cpufreq_core_init+0x0/0x169 returned 0 after 0 usecs
[    0.258960] calling  cpuidle_init+0x0/0x4d @ 1
[    0.259960] initcall cpuidle_init+0x0/0x4d returned 0 after 0 usecs
[    0.260960] calling  virtio_init+0x0/0x3d @ 1
[    0.262959] bus: 'virtio': registered
[    0.263959] initcall virtio_init+0x0/0x3d returned 0 after 1952 usecs
[    0.264959] calling  sock_init+0x0/0x3d @ 1
[    0.265959] initcall sock_init+0x0/0x3d returned 0 after 0 usecs
[    0.266959] calling  netpoll_init+0x0/0x41 @ 1
[    0.267959] initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
[    0.268958] calling  netlink_proto_init+0x0/0x1ab @ 1
[    0.269958] NET: Registered protocol family 16
[    0.270958] initcall netlink_proto_init+0x0/0x1ab returned 0 after 976 usecs
[    0.271958] calling  bdi_class_init+0x0/0x31 @ 1
[    0.272958] device class 'bdi': registering
[    0.274958] initcall bdi_class_init+0x0/0x31 returned 0 after 1952 usecs
[    0.275957] calling  kobject_uevent_init+0x0/0x55 @ 1
[    0.276957] initcall kobject_uevent_init+0x0/0x55 returned 0 after 0 usecs
[    0.277957] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.278957] device class 'pci_bus': registering
[    0.279957] initcall pcibus_class_init+0x0/0x19 returned 0 after 976 usecs
[    0.280957] calling  pci_driver_init+0x0/0x12 @ 1
[    0.282956] bus: 'pci': registered
[    0.283956] initcall pci_driver_init+0x0/0x12 returned 0 after 1952 usecs
[    0.284956] calling  lcd_class_init+0x0/0x7a @ 1
[    0.285956] device class 'lcd': registering
[    0.286956] initcall lcd_class_init+0x0/0x7a returned 0 after 976 usecs
[    0.287956] calling  backlight_class_init+0x0/0x8a @ 1
[    0.288955] device class 'backlight': registering
[    0.290955] initcall backlight_class_init+0x0/0x8a returned 0 after 1952 usecs
[    0.291955] calling  xenbus_probe_init+0x0/0x18b @ 1
[    0.292955] initcall xenbus_probe_init+0x0/0x18b returned -19 after 0 usecs
[    0.293955] calling  tty_class_init+0x0/0x5b @ 1
[    0.294955] device class 'tty': registering
[    0.296954] initcall tty_class_init+0x0/0x5b returned 0 after 1952 usecs
[    0.297954] calling  vtconsole_class_init+0x0/0x12a @ 1
[    0.298954] device class 'vtconsole': registering
[    0.299954] device: 'vtcon0': device_add
[    0.300954] PM: Adding info for No Bus:vtcon0
[    0.301953] initcall vtconsole_class_init+0x0/0x12a returned 0 after 2929 usecs
[    0.302953] calling  i2c_init+0x0/0xa1 @ 1
[    0.304953] bus: 'i2c': registered
[    0.305953] device class 'i2c-adapter': registering
[    0.307953] bus: 'i2c': add driver dummy
[    0.309952] i2c-core: driver [dummy] registered
[    0.310952] initcall i2c_init+0x0/0xa1 returned 0 after 6834 usecs
[    0.311952] calling  amd_postcore_init+0x0/0x2d @ 1
[    0.312952] initcall amd_postcore_init+0x0/0x2d returned 0 after 0 usecs
[    0.313952] calling  arch_kdebugfs_init+0x0/0x3c @ 1
[    0.314951] initcall arch_kdebugfs_init+0x0/0x3c returned 0 after 0 usecs
[    0.315951] calling  mtrr_if_init+0x0/0x97 @ 1
[    0.316971] initcall mtrr_if_init+0x0/0x97 returned 0 after 0 usecs
[    0.317991] calling  ffh_cstate_init+0x0/0x3c @ 1
[    0.318996] initcall ffh_cstate_init+0x0/0x3c returned 0 after 0 usecs
[    0.319999] calling  acpi_pci_init+0x0/0x94 @ 1
[    0.321000] ACPI: bus type pci registered
[    0.322000] initcall acpi_pci_init+0x0/0x94 returned 0 after 976 usecs
[    0.323000] calling  init_acpi_device_notify+0x0/0x71 @ 1
[    0.324000] initcall init_acpi_device_notify+0x0/0x71 returned 0 after 0 usecs
[    0.325000] calling  setup_vcpu_hotplug_event+0x0/0x34 @ 1
[    0.326000] initcall setup_vcpu_hotplug_event+0x0/0x34 returned -19 after 0 usecs
[    0.327000] calling  pci_arch_init+0x0/0x80 @ 1
[    0.328000] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
[    0.329000] PCI: Not using MMCONFIG.
[    0.330000] PCI: Using configuration type 1 for base access
[    0.331000] initcall pci_arch_init+0x0/0x80 returned 0 after 2929 usecs
[    0.332000] calling  topology_init+0x0/0x122 @ 1
[    0.333000] Registering sys device of class 'cpu'
[    0.334000] Registering sys device 'cpu0'
[    0.335000] Registering sys device of class 'cpu'
[    0.336000] Registering sys device 'cpu1'
[    0.337000] initcall topology_init+0x0/0x122 returned 0 after 3906 usecs
[    0.338000] calling  mtrr_init_finialize+0x0/0x78 @ 1
[    0.339000] initcall mtrr_init_finialize+0x0/0x78 returned 0 after 0 usecs
[    0.340000] calling  param_sysfs_init+0x0/0x6b @ 1
[    0.687000] initcall param_sysfs_init+0x0/0x6b returned 0 after 337890 usecs
[    0.688000] calling  pm_sysrq_init+0x0/0x1e @ 1
[    0.689000] initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 usecs
[    0.690000] calling  readahead_init+0x0/0x4a @ 1
[    0.691000] device: 'default': device_add
[    0.692000] PM: Adding info for No Bus:default
[    0.694000] initcall readahead_init+0x0/0x4a returned 0 after 2929 usecs
[    0.695000] calling  init_bio+0x0/0xd8 @ 1
[    0.696000] bio: create slab <bio-0> at 0
[    0.697000] initcall init_bio+0x0/0xd8 returned 0 after 976 usecs
[    0.698000] calling  integrity_init+0x0/0x50 @ 1
[    0.699000] initcall integrity_init+0x0/0x50 returned 0 after 0 usecs
[    0.700000] calling  cryptomgr_init+0x0/0x59 @ 1
[    0.701000] initcall cryptomgr_init+0x0/0x59 returned 0 after 0 usecs
[    0.702000] calling  blk_settings_init+0x0/0x2a @ 1
[    0.703000] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.704000] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.705000] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.706000] calling  blk_softirq_init+0x0/0x159 @ 1
[    0.707000] initcall blk_softirq_init+0x0/0x159 returned 0 after 0 usecs
[    0.708000] calling  genhd_device_init+0x0/0x8c @ 1
[    0.709000] device class 'block': registering
[    0.710000] initcall genhd_device_init+0x0/0x8c returned 0 after 976 usecs
[    0.711000] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    0.713000] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    0.714000] calling  pci_slot_init+0x0/0x5a @ 1
[    0.715000] initcall pci_slot_init+0x0/0x5a returned 0 after 0 usecs
[    0.716000] calling  acpi_init+0x0/0x13e @ 1
[    0.723000] ACPI: EC: Look up EC in DSDT
[    0.757000] ACPI: Interpreter enabled
[    0.758000] ACPI: (supports S0 S1 S3 S4 S5)
[    0.761000] ACPI: Using IOAPIC for interrupt routing
[    0.763000] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
[    0.780000] PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
[    0.781000] PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.797000] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.798000] initcall acpi_init+0x0/0x13e returned 0 after 79101 usecs
[    0.799000] calling  acpi_scan_init+0x0/0x101 @ 1
[    0.800000] bus: 'acpi': registered
[    0.801000] device: 'LNXSYSTM:00': device_add
[    0.802000] bus: 'acpi': add device LNXSYSTM:00
[    0.803000] PM: Adding info for acpi:LNXSYSTM:00
[    0.805000] device: 'LNXPWRBN:00': device_add
[    0.806000] bus: 'acpi': add device LNXPWRBN:00
[    0.807000] PM: Adding info for acpi:LNXPWRBN:00
[    0.809000] device: 'ACPI_CPU:00': device_add
[    0.810000] bus: 'acpi': add device ACPI_CPU:00
[    0.811000] PM: Adding info for acpi:ACPI_CPU:00
[    0.813000] device: 'ACPI_CPU:01': device_add
[    0.814000] bus: 'acpi': add device ACPI_CPU:01
[    0.815000] PM: Adding info for acpi:ACPI_CPU:01
[    0.817000] device: 'ACPI_CPU:02': device_add
[    0.818000] bus: 'acpi': add device ACPI_CPU:02
[    0.820000] PM: Adding info for acpi:ACPI_CPU:02
[    0.822000] device: 'ACPI_CPU:03': device_add
[    0.823000] bus: 'acpi': add device ACPI_CPU:03
[    0.825000] PM: Adding info for acpi:ACPI_CPU:03
[    0.827000] device: 'device:00': device_add
[    0.828000] bus: 'acpi': add device device:00
[    0.829000] PM: Adding info for acpi:device:00
[    0.830000] device: 'device:00': dev_uevent: bus uevent() returned -12
[    0.832000] device: 'PNP0C0E:00': device_add
[    0.833000] bus: 'acpi': add device PNP0C0E:00
[    0.834000] PM: Adding info for acpi:PNP0C0E:00
[    0.835000] device: 'PNP0A03:00': device_add
[    0.836000] bus: 'acpi': add device PNP0A03:00
[    0.837000] PM: Adding info for acpi:PNP0A03:00
[    0.838000] device: 'PNP0C02:00': device_add
[    0.840000] bus: 'acpi': add device PNP0C02:00
[    0.841000] PM: Adding info for acpi:PNP0C02:00
[    0.843000] device: 'device:01': device_add
[    0.844000] bus: 'acpi': add device device:01
[    0.845000] PM: Adding info for acpi:device:01
[    0.846000] device: 'device:01': dev_uevent: bus uevent() returned -12
[    0.847000] device: 'device:02': device_add
[    0.848000] bus: 'acpi': add device device:02
[    0.849000] PM: Adding info for acpi:device:02
[    0.850000] device: 'device:02': dev_uevent: bus uevent() returned -12
[    0.852000] device: 'PNP0C0F:00': device_add
[    0.853000] bus: 'acpi': add device PNP0C0F:00
[    0.854000] PM: Adding info for acpi:PNP0C0F:00
[    0.856000] device: 'PNP0C0F:01': device_add
[    0.857000] bus: 'acpi': add device PNP0C0F:01
[    0.858000] PM: Adding info for acpi:PNP0C0F:01
[    0.860000] device: 'PNP0C0F:02': device_add
[    0.861000] bus: 'acpi': add device PNP0C0F:02
[    0.862000] PM: Adding info for acpi:PNP0C0F:02
[    0.865000] device: 'PNP0C0F:03': device_add
[    0.866000] bus: 'acpi': add device PNP0C0F:03
[    0.867000] PM: Adding info for acpi:PNP0C0F:03
[    0.869000] device: 'PNP0C0F:04': device_add
[    0.870000] bus: 'acpi': add device PNP0C0F:04
[    0.871000] PM: Adding info for acpi:PNP0C0F:04
[    0.873000] device: 'PNP0C0F:05': device_add
[    0.874000] bus: 'acpi': add device PNP0C0F:05
[    0.875000] PM: Adding info for acpi:PNP0C0F:05
[    0.877000] device: 'PNP0C0F:06': device_add
[    0.878000] bus: 'acpi': add device PNP0C0F:06
[    0.879000] PM: Adding info for acpi:PNP0C0F:06
[    0.881000] device: 'PNP0C0F:07': device_add
[    0.882000] bus: 'acpi': add device PNP0C0F:07
[    0.883000] PM: Adding info for acpi:PNP0C0F:07
[    0.884000] device: 'PNP0200:00': device_add
[    0.885000] bus: 'acpi': add device PNP0200:00
[    0.886000] PM: Adding info for acpi:PNP0200:00
[    0.887000] device: 'PNP0B00:00': device_add
[    0.889000] bus: 'acpi': add device PNP0B00:00
[    0.890000] PM: Adding info for acpi:PNP0B00:00
[    0.891000] device: 'PNP0000:00': device_add
[    0.892000] bus: 'acpi': add device PNP0000:00
[    0.893000] PM: Adding info for acpi:PNP0000:00
[    0.895000] device: 'PNP0C04:00': device_add
[    0.896000] bus: 'acpi': add device PNP0C04:00
[    0.897000] PM: Adding info for acpi:PNP0C04:00
[    0.899000] device: 'PNP0100:00': device_add
[    0.900000] bus: 'acpi': add device PNP0100:00
[    0.901000] PM: Adding info for acpi:PNP0100:00
[    0.903000] device: 'PNP0800:00': device_add
[    0.904000] bus: 'acpi': add device PNP0800:00
[    0.905000] PM: Adding info for acpi:PNP0800:00
[    0.906000] device: 'PNP0C02:01': device_add
[    0.907000] bus: 'acpi': add device PNP0C02:01
[    0.908000] PM: Adding info for acpi:PNP0C02:01
[    0.910000] device: 'PNP0700:00': device_add
[    0.911000] bus: 'acpi': add device PNP0700:00
[    0.912000] PM: Adding info for acpi:PNP0700:00
[    0.915000] device: 'PNP0401:00': device_add
[    0.916000] bus: 'acpi': add device PNP0401:00
[    0.917000] PM: Adding info for acpi:PNP0401:00
[    0.919000] device: 'PNP0303:00': device_add
[    0.920000] bus: 'acpi': add device PNP0303:00
[    0.921000] PM: Adding info for acpi:PNP0303:00
[    0.924000] device: 'PNP0501:00': device_add
[    0.925000] bus: 'acpi': add device PNP0501:00
[    0.926000] PM: Adding info for acpi:PNP0501:00
[    0.929000] device: 'device:03': device_add
[    0.930000] bus: 'acpi': add device device:03
[    0.931000] PM: Adding info for acpi:device:03
[    0.932000] device: 'device:03': dev_uevent: bus uevent() returned -12
[    0.934000] device: 'device:04': device_add
[    0.935000] bus: 'acpi': add device device:04
[    0.936000] PM: Adding info for acpi:device:04
[    0.937000] device: 'device:04': dev_uevent: bus uevent() returned -12
[    0.938000] device: 'device:05': device_add
[    0.939000] bus: 'acpi': add device device:05
[    0.940000] PM: Adding info for acpi:device:05
[    0.941000] device: 'device:05': dev_uevent: bus uevent() returned -12
[    0.942000] device: 'device:06': device_add
[    0.944000] bus: 'acpi': add device device:06
[    0.945000] PM: Adding info for acpi:device:06
[    0.946000] device: 'device:06': dev_uevent: bus uevent() returned -12
[    0.947000] device: 'device:07': device_add
[    0.948000] bus: 'acpi': add device device:07
[    0.949000] PM: Adding info for acpi:device:07
[    0.950000] device: 'device:07': dev_uevent: bus uevent() returned -12
[    0.951000] device: 'device:08': device_add
[    0.952000] bus: 'acpi': add device device:08
[    0.953000] PM: Adding info for acpi:device:08
[    0.954000] device: 'device:08': dev_uevent: bus uevent() returned -12
[    0.955000] device: 'PNP0003:00': device_add
[    0.956000] bus: 'acpi': add device PNP0003:00
[    0.957000] PM: Adding info for acpi:PNP0003:00
[    0.959000] device: 'device:09': device_add
[    0.960000] bus: 'acpi': add device device:09
[    0.961000] PM: Adding info for acpi:device:09
[    0.962000] device: 'device:09': dev_uevent: bus uevent() returned -12
[    0.964000] device: 'device:0a': device_add
[    0.965000] bus: 'acpi': add device device:0a
[    0.966000] PM: Adding info for acpi:device:0a
[    0.967000] device: 'device:0a': dev_uevent: bus uevent() returned -12
[    0.969000] device: 'device:0b': device_add
[    0.970000] bus: 'acpi': add device device:0b
[    0.971000] PM: Adding info for acpi:device:0b
[    0.972000] device: 'device:0b': dev_uevent: bus uevent() returned -12
[    0.974000] device: 'device:0c': device_add
[    0.975000] bus: 'acpi': add device device:0c
[    0.976000] PM: Adding info for acpi:device:0c
[    0.977000] device: 'device:0c': dev_uevent: bus uevent() returned -12
[    0.979000] device: 'device:0d': device_add
[    0.980000] bus: 'acpi': add device device:0d
[    0.982000] PM: Adding info for acpi:device:0d
[    0.983000] device: 'device:0d': dev_uevent: bus uevent() returned -12
[    0.985000] device: 'device:0e': device_add
[    0.986000] bus: 'acpi': add device device:0e
[    0.987000] PM: Adding info for acpi:device:0e
[    0.988000] device: 'device:0e': dev_uevent: bus uevent() returned -12
[    0.989000] device: 'device:0f': device_add
[    0.990000] bus: 'acpi': add device device:0f
[    0.991000] PM: Adding info for acpi:device:0f
[    0.992000] device: 'device:0f': dev_uevent: bus uevent() returned -12
[    0.993000] device: 'device:10': device_add
[    0.994000] bus: 'acpi': add device device:10
[    0.995000] PM: Adding info for acpi:device:10
[    0.996000] device: 'device:10': dev_uevent: bus uevent() returned -12
[    0.998000] device: 'device:11': device_add
[    0.999000] bus: 'acpi': add device device:11
[    1.000000] PM: Adding info for acpi:device:11
[    1.001000] device: 'device:11': dev_uevent: bus uevent() returned -12
[    1.003000] device: 'device:12': device_add
[    1.004000] bus: 'acpi': add device device:12
[    1.005000] PM: Adding info for acpi:device:12
[    1.007000] device: 'device:12': dev_uevent: bus uevent() returned -12
[    1.008000] device: 'device:13': device_add
[    1.009000] bus: 'acpi': add device device:13
[    1.010000] PM: Adding info for acpi:device:13
[    1.011000] device: 'device:13': dev_uevent: bus uevent() returned -12
[    1.012000] device: 'device:14': device_add
[    1.013000] bus: 'acpi': add device device:14
[    1.014000] PM: Adding info for acpi:device:14
[    1.015000] device: 'device:14': dev_uevent: bus uevent() returned -12
[    1.016000] device: 'device:15': device_add
[    1.017000] bus: 'acpi': add device device:15
[    1.018000] PM: Adding info for acpi:device:15
[    1.019000] device: 'device:15': dev_uevent: bus uevent() returned -12
[    1.021000] device: 'device:16': device_add
[    1.022000] bus: 'acpi': add device device:16
[    1.023000] PM: Adding info for acpi:device:16
[    1.024000] device: 'device:16': dev_uevent: bus uevent() returned -12
[    1.025000] device: 'device:17': device_add
[    1.026000] bus: 'acpi': add device device:17
[    1.027000] PM: Adding info for acpi:device:17
[    1.028000] device: 'device:17': dev_uevent: bus uevent() returned -12
[    1.029000] device: 'device:18': device_add
[    1.030000] bus: 'acpi': add device device:18
[    1.031000] PM: Adding info for acpi:device:18
[    1.032000] device: 'device:18': dev_uevent: bus uevent() returned -12
[    1.033000] device: 'device:19': device_add
[    1.034000] bus: 'acpi': add device device:19
[    1.035000] PM: Adding info for acpi:device:19
[    1.036000] device: 'device:19': dev_uevent: bus uevent() returned -12
[    1.037000] device: 'device:1a': device_add
[    1.038000] bus: 'acpi': add device device:1a
[    1.039000] PM: Adding info for acpi:device:1a
[    1.040000] device: 'device:1a': dev_uevent: bus uevent() returned -12
[    1.042000] device: 'LNXTHERM:00': device_add
[    1.043000] bus: 'acpi': add device LNXTHERM:00
[    1.044000] PM: Adding info for acpi:LNXTHERM:00
[    1.046000] initcall acpi_scan_init+0x0/0x101 returned 0 after 240234 usecs
[    1.047000] calling  acpi_ec_init+0x0/0x95 @ 1
[    1.048000] bus: 'acpi': add driver ec
[    1.049000] initcall acpi_ec_init+0x0/0x95 returned 0 after 976 usecs
[    1.051000] calling  dock_init+0x0/0xb5 @ 1
[    1.053000] ACPI: No dock devices found.
[    1.054000] initcall dock_init+0x0/0xb5 returned 0 after 1953 usecs
[    1.055000] calling  acpi_pci_root_init+0x0/0x48 @ 1
[    1.056000] bus: 'acpi': add driver pci_root
[    1.057000] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    1.058000] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    1.059000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.060000] device: 'pci0000:00': device_add
[    1.061000] PM: Adding info for No Bus:pci0000:00
[    1.062000] device: '0000:00': device_add
[    1.063000] PM: Adding info for No Bus:0000:00
[    1.065000] PCI: Scanning bus 0000:00
[    1.067000] pci 0000:00:00.0: found [8086:277c] class 000600 header type 00
[    1.069000] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.071000] pci 0000:00:01.0: found [8086:277d] class 000604 header type 01
[    1.072000] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.074000] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.075000] pci 0000:00:01.0: PME# disabled
[    1.076000] pci 0000:00:1b.0: found [8086:27d8] class 000403 header type 00
[    1.077000] pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
[    1.079000] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.081000] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.082000] pci 0000:00:1b.0: PME# disabled
[    1.083000] pci 0000:00:1c.0: found [8086:27d0] class 000604 header type 01
[    1.084000] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.085000] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.086000] pci 0000:00:1c.0: PME# disabled
[    1.087000] pci 0000:00:1c.4: found [8086:27e0] class 000604 header type 01
[    1.088000] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.089000] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.090000] pci 0000:00:1c.4: PME# disabled
[    1.091000] pci 0000:00:1c.5: found [8086:27e2] class 000604 header type 01
[    1.092000] pci 0000:00:1c.5: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.093000] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.094000] pci 0000:00:1c.5: PME# disabled
[    1.095000] pci 0000:00:1d.0: found [8086:27c8] class 000c03 header type 00
[    1.096000] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
[    1.097000] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.098000] pci 0000:00:1d.1: found [8086:27c9] class 000c03 header type 00
[    1.099000] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
[    1.100000] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.102000] pci 0000:00:1d.2: found [8086:27ca] class 000c03 header type 00
[    1.104000] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
[    1.105000] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.106000] pci 0000:00:1d.3: found [8086:27cb] class 000c03 header type 00
[    1.107000] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
[    1.108000] pci 0000:00:1d.3: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.109000] pci 0000:00:1d.7: found [8086:27cc] class 000c03 header type 00
[    1.110000] pci 0000:00:1d.7: reg 10 32bit mmio: [0x50404400-0x504047ff]
[    1.111000] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.112000] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.113000] pci 0000:00:1d.7: PME# disabled
[    1.114000] pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
[    1.115000] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.117000] pci 0000:00:1f.0: found [8086:27b0] class 000601 header type 00
[    1.118000] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.119000] pci 0000:00:1f.1: found [8086:27df] class 000101 header type 00
[    1.120000] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    1.121000] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    1.122000] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    1.123000] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    1.124000] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
[    1.125000] pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.126000] pci 0000:00:1f.2: found [8086:27c0] class 000101 header type 00
[    1.127000] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
[    1.128000] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
[    1.129000] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
[    1.130000] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
[    1.131000] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
[    1.133000] pci 0000:00:1f.2: reg 24 32bit mmio: [0x50404000-0x504043ff]
[    1.134000] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.135000] pci 0000:00:1f.2: PME# supported from D3hot
[    1.136000] pci 0000:00:1f.2: PME# disabled
[    1.137000] pci 0000:00:1f.3: found [8086:27da] class 000c05 header type 00
[    1.138000] pci 0000:00:1f.3: reg 20 io port: [0x4000-0x401f]
[    1.139000] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.140000] PCI: Fixups for bus 0000:00
[    1.141000] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
[    1.142000] PCI: Scanning bus 0000:01
[    1.143000] pci 0000:01:00.0: found [1002:7249] class 000300 header type 00
[    1.144000] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x32
[    1.145000] pci 0000:01:00.0: reg 10 64bit mmio: [0x40000000-0x4fffffff]
[    1.146000] pci 0000:01:00.0: reg 18 64bit mmio: [0x50300000-0x5030ffff]
[    1.147000] pci 0000:01:00.0: reg 20 io port: [0x3000-0x30ff]
[    1.148000] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    1.150000] pci 0000:01:00.0: supports D1 D2
[    1.151000] pci 0000:01:00.1: found [1002:7269] class 000380 header type 00
[    1.152000] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x32
[    1.153000] pci 0000:01:00.1: reg 10 64bit mmio: [0x50310000-0x5031ffff]
[    1.154000] pci 0000:01:00.1: supports D1 D2
[    1.155000] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.156000] PCI: Fixups for bus 0000:01
[    1.157000] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    1.158000] pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
[    1.159000] pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x4fffffff]
[    1.160000] PCI: Bus scan for 0000:01 returning with max=01
[    1.161000] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
[    1.162000] PCI: Scanning bus 0000:02
[    1.163000] pci 0000:02:00.0: found [1131:7162] class 000480 header type 00
[    1.164000] pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x502fffff]
[    1.165000] pci 0000:02:00.0: supports D1 D2
[    1.166000] pci 0000:02:00.0: PME# supported from D0 D1 D2
[    1.167000] pci 0000:02:00.0: PME# disabled
[    1.168000] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.169000] PCI: Fixups for bus 0000:02
[    1.170000] pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
[    1.172000] PCI: Bus scan for 0000:02 returning with max=02
[    1.173000] pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 0
[    1.174000] PCI: Scanning bus 0000:03
[    1.175000] PCI: Fixups for bus 0000:03
[    1.176000] PCI: Bus scan for 0000:03 returning with max=03
[    1.177000] pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 0
[    1.178000] PCI: Scanning bus 0000:04
[    1.179000] pci 0000:04:00.0: found [8086:109a] class 000200 header type 00
[    1.180000] pci 0000:04:00.0: reg 10 32bit mmio: [0x50100000-0x5011ffff]
[    1.181000] pci 0000:04:00.0: reg 18 io port: [0x2000-0x201f]
[    1.182000] pci 0000:04:00.0: calling pci_fixup_transparent_bridge+0x0/0x43
[    1.183000] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.184000] pci 0000:04:00.0: PME# disabled
[    1.185000] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.186000] PCI: Fixups for bus 0000:04
[    1.187000] pci 0000:00:1c.5: bridge io port: [0x2000-0x2fff]
[    1.188000] pci 0000:00:1c.5: bridge 32bit mmio: [0x50100000-0x501fffff]
[    1.189000] PCI: Bus scan for 0000:04 returning with max=04
[    1.190000] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 0
[    1.191000] PCI: Scanning bus 0000:05
[    1.192000] pci 0000:05:02.0: found [1814:0301] class 000280 header type 00
[    1.193000] pci 0000:05:02.0: reg 10 32bit mmio: [0x50000000-0x50007fff]
[    1.195000] pci 0000:05:04.0: found [104c:8024] class 000c00 header type 00
[    1.196000] pci 0000:05:04.0: reg 10 32bit mmio: [0x5000c000-0x5000c7ff]
[    1.197000] pci 0000:05:04.0: reg 14 32bit mmio: [0x50008000-0x5000bfff]
[    1.198000] pci 0000:05:04.0: supports D1 D2
[    1.199000] pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
[    1.200000] pci 0000:05:04.0: PME# disabled
[    1.201000] pci 0000:05:05.0: found [1095:3114] class 000104 header type 00
[    1.202000] pci 0000:05:05.0: reg 10 io port: [0x1018-0x101f]
[    1.203000] pci 0000:05:05.0: reg 14 io port: [0x1024-0x1027]
[    1.204000] pci 0000:05:05.0: reg 18 io port: [0x1010-0x1017]
[    1.205000] pci 0000:05:05.0: reg 1c io port: [0x1020-0x1023]
[    1.206000] pci 0000:05:05.0: reg 20 io port: [0x1000-0x100f]
[    1.207000] pci 0000:05:05.0: reg 24 32bit mmio: [0x5000c800-0x5000cbff]
[    1.208000] pci 0000:05:05.0: reg 30 32bit mmio: [0xfff80000-0xffffffff]
[    1.209000] pci 0000:05:05.0: supports D1 D2
[    1.210000] PCI: Fixups for bus 0000:05
[    1.211000] pci 0000:00:1e.0: transparent bridge
[    1.212000] pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
[    1.213000] pci 0000:00:1e.0: bridge 32bit mmio: [0x50000000-0x500fffff]
[    1.214000] PCI: Bus scan for 0000:05 returning with max=05
[    1.215000] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
[    1.216000] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
[    1.217000] pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 1
[    1.218000] pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 1
[    1.219000] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 1
[    1.220000] PCI: Bus scan for 0000:00 returning with max=05
[    1.221000] pci_bus 0000:00: on NUMA node 0
[    1.222000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.226000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    1.228000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.229000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    1.230000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    1.232000] device: '0000:00:00.0': device_add
[    1.235000] bus: 'pci': add device 0000:00:00.0
[    1.236000] PM: Adding info for pci:0000:00:00.0
[    1.237000] device: '0000:00:01.0': device_add
[    1.241000] bus: 'pci': add device 0000:00:01.0
[    1.242000] PM: Adding info for pci:0000:00:01.0
[    1.243000] device: '0000:00:1b.0': device_add
[    1.246000] bus: 'pci': add device 0000:00:1b.0
[    1.247000] PM: Adding info for pci:0000:00:1b.0
[    1.249000] device: '0000:00:1c.0': device_add
[    1.253000] bus: 'pci': add device 0000:00:1c.0
[    1.254000] PM: Adding info for pci:0000:00:1c.0
[    1.255000] device: '0000:00:1c.4': device_add
[    1.258000] bus: 'pci': add device 0000:00:1c.4
[    1.260000] PM: Adding info for pci:0000:00:1c.4
[    1.262000] device: '0000:00:1c.5': device_add
[    1.266000] bus: 'pci': add device 0000:00:1c.5
[    1.267000] PM: Adding info for pci:0000:00:1c.5
[    1.268000] device: '0000:00:1d.0': device_add
[    1.271000] bus: 'pci': add device 0000:00:1d.0
[    1.272000] PM: Adding info for pci:0000:00:1d.0
[    1.273000] device: '0000:00:1d.1': device_add
[    1.277000] bus: 'pci': add device 0000:00:1d.1
[    1.278000] PM: Adding info for pci:0000:00:1d.1
[    1.280000] device: '0000:00:1d.2': device_add
[    1.284000] bus: 'pci': add device 0000:00:1d.2
[    1.285000] PM: Adding info for pci:0000:00:1d.2
[    1.286000] device: '0000:00:1d.3': device_add
[    1.289000] bus: 'pci': add device 0000:00:1d.3
[    1.290000] PM: Adding info for pci:0000:00:1d.3
[    1.291000] device: '0000:00:1d.7': device_add
[    1.295000] bus: 'pci': add device 0000:00:1d.7
[    1.297000] PM: Adding info for pci:0000:00:1d.7
[    1.299000] device: '0000:00:1e.0': device_add
[    1.303000] bus: 'pci': add device 0000:00:1e.0
[    1.304000] PM: Adding info for pci:0000:00:1e.0
[    1.305000] device: '0000:00:1f.0': device_add
[    1.308000] bus: 'pci': add device 0000:00:1f.0
[    1.309000] PM: Adding info for pci:0000:00:1f.0
[    1.311000] device: '0000:00:1f.1': device_add
[    1.315000] bus: 'pci': add device 0000:00:1f.1
[    1.316000] PM: Adding info for pci:0000:00:1f.1
[    1.317000] device: '0000:00:1f.2': device_add
[    1.320000] bus: 'pci': add device 0000:00:1f.2
[    1.321000] PM: Adding info for pci:0000:00:1f.2
[    1.323000] device: '0000:00:1f.3': device_add
[    1.327000] bus: 'pci': add device 0000:00:1f.3
[    1.329000] PM: Adding info for pci:0000:00:1f.3
[    1.330000] device: '0000:01:00.0': device_add
[    1.331000] bus: 'pci': add device 0000:01:00.0
[    1.332000] PM: Adding info for pci:0000:01:00.0
[    1.333000] device: '0000:01:00.1': device_add
[    1.334000] bus: 'pci': add device 0000:01:00.1
[    1.335000] PM: Adding info for pci:0000:01:00.1
[    1.336000] device: '0000:01': device_add
[    1.337000] PM: Adding info for No Bus:0000:01
[    1.338000] device: '0000:02:00.0': device_add
[    1.339000] bus: 'pci': add device 0000:02:00.0
[    1.340000] PM: Adding info for pci:0000:02:00.0
[    1.341000] device: '0000:02': device_add
[    1.342000] PM: Adding info for No Bus:0000:02
[    1.344000] device: '0000:03': device_add
[    1.345000] PM: Adding info for No Bus:0000:03
[    1.347000] device: '0000:04:00.0': device_add
[    1.348000] bus: 'pci': add device 0000:04:00.0
[    1.349000] PM: Adding info for pci:0000:04:00.0
[    1.351000] device: '0000:04': device_add
[    1.352000] PM: Adding info for No Bus:0000:04
[    1.354000] device: '0000:05:02.0': device_add
[    1.355000] bus: 'pci': add device 0000:05:02.0
[    1.357000] PM: Adding info for pci:0000:05:02.0
[    1.359000] device: '0000:05:04.0': device_add
[    1.360000] bus: 'pci': add device 0000:05:04.0
[    1.361000] PM: Adding info for pci:0000:05:04.0
[    1.363000] device: '0000:05:05.0': device_add
[    1.364000] bus: 'pci': add device 0000:05:05.0
[    1.365000] PM: Adding info for pci:0000:05:05.0
[    1.366000] device: '0000:05': device_add
[    1.367000] PM: Adding info for No Bus:0000:05
[    1.369000] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    1.370000] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    1.372000] initcall acpi_pci_root_init+0x0/0x48 returned 0 after 308594 usecs
[    1.373000] calling  acpi_pci_link_init+0x0/0xa0 @ 1
[    1.374000] bus: 'acpi': add driver pci_link
[    1.375000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    1.376000] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    1.377000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    1.380000] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    1.381000] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    1.382000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    1.383000] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    1.384000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    1.388000] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    1.389000] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    1.390000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    1.391000] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    1.393000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
[    1.396000] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    1.397000] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    1.398000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    1.399000] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    1.400000] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
[    1.403000] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    1.404000] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    1.405000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    1.406000] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    1.408000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    1.413000] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    1.414000] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    1.415000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
[    1.416000] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
[    1.418000] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    1.422001] driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
[    1.423001] bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
[    1.424001] bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
[    1.425001] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
[    1.426001] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    1.429001] driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
[    1.430001] bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
[    1.431001] bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
[    1.432001] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
[    1.433001] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    1.437001] driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
[    1.438001] bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
[    1.439001] initcall acpi_pci_link_init+0x0/0xa0 returned 0 after 63476 usecs
[    1.440001] calling  acpi_power_init+0x0/0xab @ 1
[    1.441001] bus: 'acpi': add driver power
[    1.443001] initcall acpi_power_init+0x0/0xab returned 0 after 1953 usecs
[    1.444001] calling  acpi_system_init+0x0/0x28 @ 1
[    1.445001] initcall acpi_system_init+0x0/0x28 returned 0 after 0 usecs
[    1.446001] calling  pnp_init+0x0/0x12 @ 1
[    1.448001] bus: 'pnp': registered
[    1.449001] initcall pnp_init+0x0/0x12 returned 0 after 1953 usecs
[    1.450001] calling  setup_shutdown_event+0x0/0x14 @ 1
[    1.451001] initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 usecs
[    1.452001] calling  balloon_init+0x0/0x14c @ 1
[    1.453001] initcall balloon_init+0x0/0x14c returned -19 after 0 usecs
[    1.454001] calling  misc_init+0x0/0xd6 @ 1
[    1.455001] device class 'misc': registering
[    1.457001] initcall misc_init+0x0/0xd6 returned 0 after 1953 usecs
[    1.458001] calling  cn_init+0x0/0x129 @ 1
[    1.459001] initcall cn_init+0x0/0x129 returned 0 after 0 usecs
[    1.460001] calling  tifm_init+0x0/0xbf @ 1
[    1.462001] bus: 'tifm': registered
[    1.463001] device class 'tifm_adapter': registering
[    1.465001] initcall tifm_init+0x0/0xbf returned 0 after 3906 usecs
[    1.466001] calling  twl4030_init+0x0/0x14 @ 1
[    1.467001] bus: 'i2c': add driver twl4030
[    1.468001] i2c-core: driver [twl4030] registered
[    1.469001] initcall twl4030_init+0x0/0x14 returned 0 after 1953 usecs
[    1.470001] calling  phy_init+0x0/0x55 @ 1
[    1.471001] device class 'mdio_bus': registering
[    1.473001] bus: 'mdio_bus': registered
[    1.474001] bus: 'mdio_bus': add driver Generic PHY
[    1.476001] initcall phy_init+0x0/0x55 returned 0 after 4882 usecs
[    1.477001] calling  init_scsi+0x0/0x107 @ 1
[    1.479001] device class 'scsi_host': registering
[    1.480001] bus: 'scsi': registered
[    1.481001] device class 'scsi_device': registering
[    1.482001] SCSI subsystem initialized
[    1.483001] initcall init_scsi+0x0/0x107 returned 0 after 4882 usecs
[    1.484001] calling  ata_init+0x0/0xaf @ 1
[    1.486001] libata version 3.00 loaded.
[    1.487001] initcall ata_init+0x0/0xaf returned 0 after 1953 usecs
[    1.488001] calling  init_pcmcia_cs+0x0/0x2f @ 1
[    1.489001] device class 'pcmcia_socket': registering
[    1.491001] initcall init_pcmcia_cs+0x0/0x2f returned 0 after 1953 usecs
[    1.492001] calling  twl4030_usb_init+0x0/0x12 @ 1
[    1.493001] bus: 'platform': add driver twl4030_usb
[    1.494001] initcall twl4030_usb_init+0x0/0x12 returned 0 after 976 usecs
[    1.495001] calling  usb_init+0x0/0x1f7 @ 1
[    1.497001] bus: 'usb': registered
[    1.498001] device class 'usb_host': registering
[    1.499001] bus: 'usb': add driver usbfs
[    1.500001] usbcore: registered new interface driver usbfs
[    1.501001] bus: 'usb': add driver hub
[    1.502001] usbcore: registered new interface driver hub
[    1.504001] bus: 'usb': add driver usb
[    1.506001] usbcore: registered new device driver usb
[    1.507001] initcall usb_init+0x0/0x1f7 returned 0 after 10742 usecs
[    1.508001] calling  serio_init+0x0/0xec @ 1
[    1.510001] bus: 'serio': registered
[    1.512001] initcall serio_init+0x0/0xec returned 0 after 2929 usecs
[    1.513001] calling  gameport_init+0x0/0xec @ 1
[    1.515001] bus: 'gameport': registered
[    1.516001] initcall gameport_init+0x0/0xec returned 0 after 1953 usecs
[    1.517001] calling  input_init+0x0/0xc0 @ 1
[    1.518001] device class 'input': registering
[    1.519001] initcall input_init+0x0/0xc0 returned 0 after 976 usecs
[    1.520001] calling  rtc_init+0x0/0xa1 @ 1
[    1.521001] device class 'rtc': registering
[    1.522001] initcall rtc_init+0x0/0xa1 returned 0 after 976 usecs
[    1.523001] calling  power_supply_class_init+0x0/0x64 @ 1
[    1.524001] device class 'power_supply': registering
[    1.525001] initcall power_supply_class_init+0x0/0x64 returned 0 after 976 usecs
[    1.526001] calling  hwmon_init+0x0/0x67 @ 1
[    1.527001] device class 'hwmon': registering
[    1.528001] initcall hwmon_init+0x0/0x67 returned 0 after 976 usecs
[    1.529001] calling  thermal_init+0x0/0x6a @ 1
[    1.530001] device class 'thermal': registering
[    1.532001] initcall thermal_init+0x0/0x6a returned 0 after 1953 usecs
[    1.533001] calling  mmc_init+0x0/0xc2 @ 1
[    1.535001] bus: 'mmc': registered
[    1.536001] device class 'mmc_host': registering
[    1.538001] bus: 'sdio': registered
[    1.539001] initcall mmc_init+0x0/0xc2 returned 0 after 4882 usecs
[    1.541001] calling  leds_init+0x0/0x6c @ 1
[    1.542001] device class 'leds': registering
[    1.543001] initcall leds_init+0x0/0x6c returned 0 after 976 usecs
[    1.544001] calling  acpi_wmi_init+0x0/0x7c @ 1
[    1.545001] bus: 'acpi': add driver wmi
[    1.546001] ACPI: WMI: Mapper loaded
[    1.547001] initcall acpi_wmi_init+0x0/0x7c returned 0 after 1953 usecs
[    1.548001] calling  pci_subsys_init+0x0/0x1c @ 1
[    1.549001] PCI: Using ACPI for IRQ routing
[    1.551001] initcall pci_subsys_init+0x0/0x1c returned 0 after 1953 usecs
[    1.552001] calling  proto_init+0x0/0x12 @ 1
[    1.553001] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    1.554001] calling  net_dev_init+0x0/0x2e6 @ 1
[    1.555001] device class 'net': registering
[    1.556001] device: 'lo': device_add
[    1.558001] PM: Adding info for No Bus:lo
[    1.559001] initcall net_dev_init+0x0/0x2e6 returned 0 after 3906 usecs
[    1.560001] calling  neigh_init+0x0/0x71 @ 1
[    1.561001] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    1.562001] calling  fib_rules_init+0x0/0xc6 @ 1
[    1.563001] initcall fib_rules_init+0x0/0xc6 returned 0 after 0 usecs
[    1.564001] calling  pktsched_init+0x0/0xc4 @ 1
[    1.565001] initcall pktsched_init+0x0/0xc4 returned 0 after 0 usecs
[    1.566001] calling  tc_filter_init+0x0/0x4c @ 1
[    1.567001] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    1.568001] calling  tc_action_init+0x0/0x4c @ 1
[    1.569001] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    1.570001] calling  genl_init+0x0/0x121 @ 1
[    1.575001] initcall genl_init+0x0/0x121 returned 0 after 3906 usecs
[    1.576001] calling  irda_init+0x0/0xd7 @ 1
[    1.577001] irda_init()
[    1.579001] NET: Registered protocol family 23
[    1.580001] initcall irda_init+0x0/0xd7 returned 0 after 2929 usecs
[    1.581001] calling  bt_init+0x0/0x7d @ 1
[    1.582001] Bluetooth: Core ver 2.14
[    1.584001] device class 'bluetooth': registering
[    1.585001] NET: Registered protocol family 31
[    1.586001] Bluetooth: HCI device and connection manager initialized
[    1.587001] Bluetooth: HCI socket layer initialized
[    1.588001] initcall bt_init+0x0/0x7d returned 0 after 5859 usecs
[    1.589001] calling  atm_init+0x0/0x107 @ 1
[    1.590001] NET: Registered protocol family 8
[    1.591001] NET: Registered protocol family 20
[    1.593001] device class 'atm': registering
[    1.594001] initcall atm_init+0x0/0x107 returned 0 after 3906 usecs
[    1.595001] calling  wireless_nlevent_init+0x0/0x41 @ 1
[    1.596001] initcall wireless_nlevent_init+0x0/0x41 returned 0 after 0 usecs
[    1.597001] calling  cfg80211_init+0x0/0xc9 @ 1
[    1.598001] device class 'ieee80211': registering
[    1.603001] Registering platform device 'regulatory.0'. Parent at platform
[    1.604001] device: 'regulatory.0': device_add
[    1.605001] bus: 'platform': add device regulatory.0
[    1.606001] PM: Adding info for platform:regulatory.0
[    1.607001] cfg80211: Using static regulatory domain info
[    1.608001] cfg80211: Regulatory domain: US
[    1.609001] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    1.610001] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    1.611001] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.612001] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.613001] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.614001] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.615001] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    1.616001] cfg80211: Calling CRDA for country: US
[    1.618001] initcall cfg80211_init+0x0/0xc9 returned 0 after 19531 usecs
[    1.619001] calling  rfkill_init+0x0/0x8c @ 1
[    1.620001] device class 'rfkill': registering
[    1.621001] initcall rfkill_init+0x0/0x8c returned 0 after 976 usecs
[    1.622001] calling  sysctl_init+0x0/0x5b @ 1
[    1.623001] initcall sysctl_init+0x0/0x5b returned 0 after 0 usecs
[    1.624001] calling  xen_mc_debugfs+0x0/0x12a @ 1
[    1.625001] initcall xen_mc_debugfs+0x0/0x12a returned 0 after 0 usecs
[    1.627001] calling  xen_mmu_debugfs+0x0/0x2d0 @ 1
[    1.629001] initcall xen_mmu_debugfs+0x0/0x2d0 returned 0 after 976 usecs
[    1.630001] calling  xen_spinlock_debugfs+0x0/0x260 @ 1
[    1.631001] initcall xen_spinlock_debugfs+0x0/0x260 returned 0 after 0 usecs
[    1.632001] calling  pci_iommu_init+0x0/0x1c @ 1
[    1.633001] initcall pci_iommu_init+0x0/0x1c returned 0 after 0 usecs
[    1.634001] calling  print_all_ICs+0x0/0x17 @ 1
[    1.635001] 
[    1.635001] printing PIC contents
[    1.636001] ... PIC  IMR: ffff
[    1.636001] ... PIC  IRR: 0c01
[    1.637001] ... PIC  ISR: 0000
[    1.638001] ... PIC ELCR: 0e00
[    1.639001] 
[    1.639001] printing local APIC contents on CPU#0/0:
[    1.639001] ... APIC ID:      00000000 (0)
[    1.639001] ... APIC VERSION: 00050014
[    1.639001] ... APIC TASKPRI: 00000000 (00)
[    1.639001] ... APIC PROCPRI: 00000000
[    1.639001] ... APIC LDR: 01000000
[    1.639001] ... APIC DFR: ffffffff
[    1.639001] ... APIC SPIV: 000001ff
[    1.639001] ... APIC ISR field:
[    1.639001] 0123456789abcdef0123456789abcdef
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] ... APIC TMR field:
[    1.639001] 0123456789abcdef0123456789abcdef
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] ... APIC IRR field:
[    1.639001] 0123456789abcdef0123456789abcdef
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000001000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] 00000000000000000000000000000000
[    1.639001] ... APIC ESR: 00000000
[    1.639001] ... APIC ICR: 000008ef
[    1.639001] ... APIC ICR2: 02000000
[    1.639001] ... APIC LVTT: 00010000
[    1.639001] ... APIC LVTPC: 000000ee
[    1.639001] ... APIC LVT0: 00010700
[    1.639001] ... APIC LVT1: 00000400
[    1.639001] ... APIC LVTERR: 000000fe
[    1.639001] ... APIC TMICT: 00000000
[    1.639001] ... APIC TMCCT: 00000000
[    1.639001] ... APIC TDCR: 00000000
[    1.639001] 
[    1.640001] 
[    1.640001] printing local APIC contents on CPU#1/1:
[    1.641001] ... APIC ID:      01000000 (1)
[    1.641001] ... APIC VERSION: 00050014
[    1.641001] ... APIC TASKPRI: 00000000 (00)
[    1.641001] ... APIC PROCPRI: 00000000
[    1.641001] ... APIC LDR: 02000000
[    1.641001] ... APIC DFR: ffffffff
[    1.641001] ... APIC SPIV: 000001ff
[    1.641001] ... APIC ISR field:
[    1.641001] 0123456789abcdef0123456789abcdef
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] ... APIC TMR field:
[    1.641001] 0123456789abcdef0123456789abcdef
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] ... APIC IRR field:
[    1.641001] 0123456789abcdef0123456789abcdef
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000000000000000000000
[    1.641001] 00000000000000010000000000000000
[    1.641001] ... APIC ESR: 00000000
[    1.641001] ... APIC ICR: 000008fd
[    1.641001] ... APIC ICR2: 01000000
[    1.641001] ... APIC LVTT: 00010000
[    1.641001] ... APIC LVTPC: 000100ee
[    1.641001] ... APIC LVT0: 00010700
[    1.641001] ... APIC LVT1: 00010400
[    1.641001] ... APIC LVTERR: 000000fe
[    1.641001] ... APIC TMICT: 00000000
[    1.641001] ... APIC TMCCT: 00000000
[    1.641001] ... APIC TDCR: 00000000
[    1.641001] 
[    1.837001] number of MP IRQ sources: 15.
[    1.838001] number of IO-APIC #2 registers: 24.
[    1.839001] testing the IO APIC.......................
[    1.840001] 
[    1.841001] IO APIC #2......
[    1.842001] .... register #00: 00000000
[    1.843001] .......    : physical APIC id: 00
[    1.844001] .......    : Delivery Type: 0
[    1.845001] .......    : LTS          : 0
[    1.846001] .... register #01: 00170020
[    1.847001] .......     : max redirection entries: 0017
[    1.848001] .......     : PRQ implemented: 0
[    1.849001] .......     : IO APIC version: 0020
[    1.850001] .... IRQ redirection table:
[    1.851001]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    1.852001]  00 000 1    0    0   0   0    0    0    00
[    1.854001]  01 003 0    0    0   0   0    1    1    31
[    1.856001]  02 003 0    0    0   0   0    1    1    30
[    1.858001]  03 003 0    0    0   0   0    1    1    33
[    1.860001]  04 003 0    0    0   0   0    1    1    34
[    1.862001]  05 003 0    0    0   0   0    1    1    35
[    1.864001]  06 003 0    0    0   0   0    1    1    36
[    1.866001]  07 003 0    0    0   0   0    1    1    37
[    1.868001]  08 003 0    0    0   0   0    1    1    38
[    1.870001]  09 003 0    1    0   0   0    1    1    39
[    1.872001]  0a 003 0    0    0   0   0    1    1    3A
[    1.874001]  0b 003 0    0    0   0   0    1    1    3B
[    1.876001]  0c 003 0    0    0   0   0    1    1    3C
[    1.878001]  0d 003 0    0    0   0   0    1    1    3D
[    1.880001]  0e 003 0    0    0   0   0    1    1    3E
[    1.882001]  0f 003 0    0    0   0   0    1    1    3F
[    1.884001]  10 000 1    0    0   0   0    0    0    00
[    1.886001]  11 000 1    0    0   0   0    0    0    00
[    1.888001]  12 000 1    0    0   0   0    0    0    00
[    1.890001]  13 000 1    0    0   0   0    0    0    00
[    1.892001]  14 000 1    0    0   0   0    0    0    00
[    1.894001]  15 000 1    0    0   0   0    0    0    00
[    1.896001]  16 000 1    0    0   0   0    0    0    00
[    1.898001]  17 000 1    0    0   0   0    0    0    00
[    1.900001] IRQ to pin mappings:
[    1.901001] IRQ0 -> 0:2
[    1.903001] IRQ1 -> 0:1
[    1.905001] IRQ3 -> 0:3
[    1.907001] IRQ4 -> 0:4
[    1.908001] IRQ5 -> 0:5
[    1.910001] IRQ6 -> 0:6
[    1.911001] IRQ7 -> 0:7
[    1.913001] IRQ8 -> 0:8
[    1.915001] IRQ9 -> 0:9
[    1.917001] IRQ10 -> 0:10
[    1.919001] IRQ11 -> 0:11
[    1.921001] IRQ12 -> 0:12
[    1.922001] IRQ13 -> 0:13
[    1.924001] IRQ14 -> 0:14
[    1.926001] IRQ15 -> 0:15
[    1.928001] .................................... done.
[    1.929001] initcall print_all_ICs+0x0/0x17 returned 0 after 287109 usecs
[    1.930001] calling  hpet_late_init+0x0/0x1f6 @ 1
[    1.931001] initcall hpet_late_init+0x0/0x1f6 returned -19 after 0 usecs
[    1.932001] calling  init_kmmio+0x0/0x2c @ 1
[    1.933001] initcall init_kmmio+0x0/0x2c returned 0 after 0 usecs
[    1.934001] calling  clocksource_done_booting+0x0/0x12 @ 1
[    1.935001] initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
[    1.936001] calling  ftrace_init_debugfs+0x0/0x79 @ 1
[    1.938001] initcall ftrace_init_debugfs+0x0/0x79 returned 0 after 976 usecs
[    1.939001] calling  rb_init_debugfs+0x0/0x54 @ 1
[    1.940001] initcall rb_init_debugfs+0x0/0x54 returned 0 after 0 usecs
[    1.941001] calling  tracer_init_debugfs+0x0/0x4c2 @ 1
[    1.943001] initcall tracer_init_debugfs+0x0/0x4c2 returned 0 after 976 usecs
[    1.944001] calling  init_trace_printk_function_export+0x0/0x69 @ 1
[    1.945001] initcall init_trace_printk_function_export+0x0/0x69 returned 0 after 0 usecs
[    1.946001] calling  all_annotated_branch_stats+0x0/0x3b @ 1
[    1.947001] Warning: could not register all branches stats
[    1.948001] initcall all_annotated_branch_stats+0x0/0x3b returned 1 after 976 usecs
[    1.949001] initcall all_annotated_branch_stats+0x0/0x3b returned with error code 1 
[    1.950001] calling  init_annotated_branch_stats+0x0/0x3b @ 1
[    1.951001] Warning: could not register annotated branches stats
[    1.952001] initcall init_annotated_branch_stats+0x0/0x3b returned 1 after 976 usecs
[    1.953001] initcall init_annotated_branch_stats+0x0/0x3b returned with error code 1 
[    1.954001] calling  stat_workqueue_init+0x0/0x3b @ 1
[    1.955001] initcall stat_workqueue_init+0x0/0x3b returned 0 after 0 usecs
[    1.956001] calling  event_trace_init+0x0/0x117 @ 1
[    1.960001] initcall event_trace_init+0x0/0x117 returned 0 after 2929 usecs
[    1.961001] calling  init_pipe_fs+0x0/0x86 @ 1
[    1.962001] initcall init_pipe_fs+0x0/0x86 returned 0 after 0 usecs
[    1.964001] calling  init_mnt_writers+0x0/0x169 @ 1
[    1.965001] initcall init_mnt_writers+0x0/0x169 returned 0 after 0 usecs
[    1.966001] calling  eventpoll_init+0x0/0x91 @ 1
[    1.967001] initcall eventpoll_init+0x0/0x91 returned 0 after 0 usecs
[    1.968001] calling  anon_inode_init+0x0/0x103 @ 1
[    1.969001] initcall anon_inode_init+0x0/0x103 returned 0 after 0 usecs
[    1.970001] calling  acpi_event_init+0x0/0x8a @ 1
[    1.976001] initcall acpi_event_init+0x0/0x8a returned 0 after 4882 usecs
[    1.977001] calling  pnpacpi_init+0x0/0xa3 @ 1
[    1.978001] pnp: PnP ACPI init
[    1.979001] device: 'pnp0': device_add
[    1.981001] PM: Adding info for No Bus:pnp0
[    1.982001] ACPI: bus type pnp registered
[    1.994001] device: '00:00': device_add
[    1.995001] bus: 'pnp': add device 00:00
[    1.996001] PM: Adding info for pnp:00:00
[    1.998001] device: '00:01': device_add
[    1.999001] bus: 'pnp': add device 00:01
[    2.001001] PM: Adding info for pnp:00:01
[    2.004001] device: '00:02': device_add
[    2.006001] bus: 'pnp': add device 00:02
[    2.008001] PM: Adding info for pnp:00:02
[    2.010001] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    2.011001] device: '00:03': device_add
[    2.012001] bus: 'pnp': add device 00:03
[    2.013001] PM: Adding info for pnp:00:03
[    2.015001] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    2.016001] device: '00:04': device_add
[    2.017001] bus: 'pnp': add device 00:04
[    2.018001] PM: Adding info for pnp:00:04
[    2.019001] device: '00:05': device_add
[    2.020001] bus: 'pnp': add device 00:05
[    2.021001] PM: Adding info for pnp:00:05
[    2.023001] device: '00:06': device_add
[    2.024001] bus: 'pnp': add device 00:06
[    2.025001] PM: Adding info for pnp:00:06
[    2.028001] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    2.030001] device: '00:07': device_add
[    2.032001] bus: 'pnp': add device 00:07
[    2.034001] PM: Adding info for pnp:00:07
[    2.038001] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    2.039001] device: '00:08': device_add
[    2.040001] bus: 'pnp': add device 00:08
[    2.041001] PM: Adding info for pnp:00:08
[    2.042001] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    2.043001] device: '00:09': device_add
[    2.044001] bus: 'pnp': add device 00:09
[    2.045001] PM: Adding info for pnp:00:09
[    2.047001] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    2.049001] device: '00:0a': device_add
[    2.051001] bus: 'pnp': add device 00:0a
[    2.052001] PM: Adding info for pnp:00:0a
[    2.053001] device: '00:0b': device_add
[    2.054001] bus: 'pnp': add device 00:0b
[    2.055001] PM: Adding info for pnp:00:0b
[    2.057001] pnp: PnP ACPI: found 12 devices
[    2.058001] ACPI: ACPI bus type pnp unregistered
[    2.059001] initcall pnpacpi_init+0x0/0xa3 returned 0 after 79101 usecs
[    2.060001] calling  pnp_system_init+0x0/0x12 @ 1
[    2.061001] bus: 'pnp': add driver system
[    2.062001] bus: 'pnp': driver_probe_device: matched device 00:01 with driver system
[    2.063001] bus: 'pnp': really_probe: probing driver system with device 00:01
[    2.064001] system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
[    2.065001] system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[    2.066001] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    2.067001] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    2.068001] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    2.069001] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    2.071001] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    2.072001] system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
[    2.073001] system 00:01: iomem range 0xc0000-0xdffff has been reserved
[    2.074001] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[    2.075001] driver: '00:01': driver_bound: bound to device 'system'
[    2.076001] bus: 'pnp': really_probe: bound device 00:01 to driver system
[    2.077001] bus: 'pnp': driver_probe_device: matched device 00:06 with driver system
[    2.078001] bus: 'pnp': really_probe: probing driver system with device 00:06
[    2.079001] system 00:06: ioport range 0x500-0x53f has been reserved
[    2.080001] system 00:06: ioport range 0x400-0x47f has been reserved
[    2.081001] system 00:06: ioport range 0x680-0x6ff has been reserved
[    2.082001] driver: '00:06': driver_bound: bound to device 'system'
[    2.083001] bus: 'pnp': really_probe: bound device 00:06 to driver system
[    2.084001] initcall pnp_system_init+0x0/0x12 returned 0 after 22460 usecs
[    2.085001] calling  chr_dev_init+0x0/0xcf @ 1
[    2.086001] device class 'mem': registering
[    2.087001] device: 'mem': device_add
[    2.088001] PM: Adding info for No Bus:mem
[    2.089001] device: 'kmem': device_add
[    2.090001] PM: Adding info for No Bus:kmem
[    2.092001] device: 'null': device_add
[    2.093001] PM: Adding info for No Bus:null
[    2.095001] device: 'port': device_add
[    2.096001] PM: Adding info for No Bus:port
[    2.097001] device: 'zero': device_add
[    2.098001] PM: Adding info for No Bus:zero
[    2.099001] device: 'full': device_add
[    2.100001] PM: Adding info for No Bus:full
[    2.102001] device: 'random': device_add
[    2.104001] PM: Adding info for No Bus:random
[    2.106001] device: 'urandom': device_add
[    2.107001] PM: Adding info for No Bus:urandom
[    2.108001] device: 'kmsg': device_add
[    2.109001] PM: Adding info for No Bus:kmsg
[    2.111001] initcall chr_dev_init+0x0/0xcf returned 0 after 24414 usecs
[    2.112001] calling  firmware_class_init+0x0/0x9d @ 1
[    2.113001] device class 'firmware': registering
[    2.114001] initcall firmware_class_init+0x0/0x9d returned 0 after 976 usecs
[    2.115001] calling  ieee1394_init+0x0/0x368 @ 1
[    2.117001] bus: 'ieee1394': registered
[    2.118001] device class 'ieee1394_host': registering
[    2.119001] device class 'ieee1394_protocol': registering
[    2.120001] device class 'ieee1394_node': registering
[    2.121001] device class 'ieee1394': registering
[    2.122001] bus: 'ieee1394': add driver nodemgr
[    2.123001] initcall ieee1394_init+0x0/0x368 returned 0 after 6835 usecs
[    2.124001] calling  init_pcmcia_bus+0x0/0x9f @ 1
[    2.125001] bus: 'pcmcia': registered
[    2.126001] initcall init_pcmcia_bus+0x0/0x9f returned 0 after 976 usecs
[    2.127001] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    2.128001] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    2.129001] calling  init_acpi_pm_clocksource+0x0/0x14c @ 1
[    2.135001] initcall init_acpi_pm_clocksource+0x0/0x14c returned 0 after 4882 usecs
[    2.136008] Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
[    2.136023] Could not switch to high resolution mode on CPU 1
[    2.136008]  lapic is not functional.
[    2.157384] Could not switch to high resolution mode on CPU 0
[    2.163098] calling  ssb_modinit+0x0/0x72 @ 1
[    2.167761] bus: 'ssb': registered
[    2.171168] initcall ssb_modinit+0x0/0x72 returned 0 after 3671 usecs
[    2.177573] calling  pcibios_assign_resources+0x0/0xd5 @ 1
[    2.184026] pci 0000:01:00.0: BAR 6: got res [0x50320000-0x5033ffff] bus [0x50320000-0x5033ffff] flags 0x27200
[    2.193307] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    2.199193] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    2.204472] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    2.210531] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x0000004fffffff
[    2.218101] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    2.223986] pci 0000:00:1c.0:   IO window: disabled
[    2.228833] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    2.234891] pci 0000:00:1c.0:   PREFETCH window: disabled
[    2.240257] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    2.246141] pci 0000:00:1c.4:   IO window: disabled
[    2.250988] pci 0000:00:1c.4:   MEM window: disabled
[    2.255921] pci 0000:00:1c.4:   PREFETCH window: disabled
[    2.261286] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
[    2.267171] pci 0000:00:1c.5:   IO window: 0x2000-0x2fff
[    2.272451] pci 0000:00:1c.5:   MEM window: 0x50100000-0x501fffff
[    2.278509] pci 0000:00:1c.5:   PREFETCH window: disabled
[    2.283874] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    2.289760] pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
[    2.295038] pci 0000:00:1e.0:   MEM window: 0x50000000-0x500fffff
[    2.301096] pci 0000:00:1e.0:   PREFETCH window: disabled
[    2.306462]   alloc irq_desc for 16 on cpu 0 node 0
[    2.306462]   alloc kstat_irqs on cpu 0 node 0
[    2.315737] IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
[    2.323224] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.329889] pci 0000:00:01.0: setting latency timer to 64
[    2.335256]   alloc irq_desc for 17 on cpu 0 node 0
[    2.335256]   alloc kstat_irqs on cpu 0 node 0
[    2.344563] IOAPIC[0]: Set routing entry (2-17 -> 0x51 -> IRQ 17 Mode:1 Active:1)
[    2.352055] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.358722] pci 0000:00:1c.0: setting latency timer to 64
[    2.364087] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.370750] pci 0000:00:1c.4: setting latency timer to 64
[    2.376117] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.382779] pci 0000:00:1c.5: setting latency timer to 64
[    2.388146] pci 0000:00:1e.0: setting latency timer to 64
[    2.393510] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.398965] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    2.405801] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
[    2.411426] pci_bus 0000:01: resource 1 mem: [0x50300000-0x503fffff]
[    2.417744] pci_bus 0000:01: resource 2 mem: [0x40000000-0x4fffffff]
[    2.424061] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    2.429167] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    2.434274] pci_bus 0000:02: resource 1 mem: [0x50200000-0x502fffff]
[    2.440591] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    2.445697] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    2.450803] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    2.455910] pci_bus 0000:03: resource 1 mem: [0x0-0x0]
[    2.461016] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    2.466123] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    2.471228] pci_bus 0000:04: resource 0 io:  [0x2000-0x2fff]
[    2.476853] pci_bus 0000:04: resource 1 mem: [0x50100000-0x501fffff]
[    2.483171] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    2.488278] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    2.493383] pci_bus 0000:05: resource 0 io:  [0x1000-0x1fff]
[    2.499009] pci_bus 0000:05: resource 1 mem: [0x50000000-0x500fffff]
[    2.505326] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    2.510432] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    2.518199] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    2.525035] initcall pcibios_assign_resources+0x0/0xd5 returned 0 after 333965 usecs
[    2.532775] calling  sysctl_core_init+0x0/0x38 @ 1
[    2.537534] initcall sysctl_core_init+0x0/0x38 returned 0 after 30 usecs
[    2.544197] calling  inet_init+0x0/0x269 @ 1
[    2.548440] NET: Registered protocol family 2
[    2.564983] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.572283] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.582989] TCP bind hash table entries: 32768 (order: 9, 2359296 bytes)
[    2.591987] TCP: Hash tables configured (established 131072 bind 32768)
[    2.599029] TCP reno registered
[    2.605976] initcall inet_init+0x0/0x269 returned 0 after 55751 usecs
[    2.611906] calling  af_unix_init+0x0/0x67 @ 1
[    2.616320] NET: Registered protocol family 1
[    2.620647] initcall af_unix_init+0x0/0x67 returned 0 after 4291 usecs
[    2.627172] calling  populate_rootfs+0x0/0x132 @ 1
[    2.632981] initcall populate_rootfs+0x0/0x132 returned 0 after 1055 usecs
[    2.639817] calling  i8259A_init_sysfs+0x0/0x3a @ 1
[    2.644665] Registering sysdev class 'i8259'
[    2.649904] Registering sys device of class 'i8259'
[    2.654250] Registering sys device 'i82590'
[    2.658750] initcall i8259A_init_sysfs+0x0/0x3a returned 0 after 13783 usecs
[    2.665754] calling  vsyscall_init+0x0/0x6c @ 1
[    2.670255] initcall vsyscall_init+0x0/0x6c returned 0 after 30 usecs
[    2.676660] calling  sbf_init+0x0/0x6e @ 1
[    2.680729] initcall sbf_init+0x0/0x6e returned 0 after 3 usecs
[    2.686613] calling  i8237A_init_sysfs+0x0/0x3a @ 1
[    2.691460] Registering sysdev class 'i8237'
[    2.696961] Registering sys device of class 'i8237'
[    2.701934] Registering sys device 'i82370'
[    2.705416] initcall i8237A_init_sysfs+0x0/0x3a returned 0 after 13656 usecs
[    2.712420] calling  add_rtc_cmos+0x0/0xb9 @ 1
[    2.716837] initcall add_rtc_cmos+0x0/0xb9 returned 0 after 6 usecs
[    2.723068] calling  cache_sysfs_init+0x0/0x17c @ 1
[    2.731949] initcall cache_sysfs_init+0x0/0x17c returned 0 after 3567 usecs
[    2.738458] calling  cpu_debug_init+0x0/0x25 @ 1
[    2.750964] cpu0(4) debug files 132
[    2.762960] cpu1(4) debug files 132
[    2.766671] cpu2(4) debug files 3
[    2.770160] cpu3(4) debug files 3
[    2.773646] initcall cpu_debug_init+0x0/0x25 returned 0 after 29881 usecs
[    2.780396] calling  mce_init_device+0x0/0x1e7 @ 1
[    2.785157] Registering sysdev class 'machinecheck'
[    2.790407] Registering sys device of class 'machinecheck'
[    2.795851] Registering sys device 'machinecheck0'
[    2.801944] Registering sys device of class 'machinecheck'
[    2.807821] Registering sys device 'machinecheck1'
[    2.812943] device: 'mcelog': device_add
[    2.816094] PM: Adding info for No Bus:mcelog
[    2.821925] initcall mce_init_device+0x0/0x1e7 returned 0 after 35051 usecs
[    2.828940] calling  periodic_mcheck_init+0x0/0x14 @ 1
[    2.833101] initcall periodic_mcheck_init+0x0/0x14 returned 0 after 10 usecs
[    2.840110] calling  thermal_throttle_init_device+0x0/0x1bd @ 1
[    2.845997] initcall thermal_throttle_init_device+0x0/0x1bd returned 0 after 1 usecs
[    2.853736] calling  threshold_init_device+0x0/0x14b @ 1
[    2.859015] initcall threshold_init_device+0x0/0x14b returned 0 after 3 usecs
[    2.866111] calling  msr_init+0x0/0x318 @ 1
[    2.870266] device class 'msr': registering
[    2.874759] device: 'msr0': device_add
[    2.878478] PM: Adding info for No Bus:msr0
[    2.883932] device: 'msr1': device_add
[    2.886754] PM: Adding info for No Bus:msr1
[    2.891282] initcall msr_init+0x0/0x318 returned 0 after 20557 usecs
[    2.897599] calling  init_lapic_sysfs+0x0/0x5c @ 1
[    2.902361] Registering sysdev class 'lapic'
[    2.907930] Registering sys device of class 'lapic'
[    2.911806] Registering sys device 'lapic0'
[    2.916273] initcall init_lapic_sysfs+0x0/0x5c returned 0 after 13614 usecs
[    2.923190] calling  ioapic_init_sysfs+0x0/0xe3 @ 1
[    2.928037] Registering sysdev class 'ioapic'
[    2.932696] Registering sys device of class 'ioapic'
[    2.937621] Registering sys device 'ioapic0'
[    2.942863] initcall ioapic_init_sysfs+0x0/0xe3 returned 0 after 13871 usecs
[    2.949215] calling  add_pcspkr+0x0/0x45 @ 1
[    2.953457] Registering platform device 'pcspkr'. Parent at platform
[    2.959778] device: 'pcspkr': device_add
[    2.963672] bus: 'platform': add device pcspkr
[    2.968090] PM: Adding info for platform:pcspkr
[    2.973920] initcall add_pcspkr+0x0/0x45 returned 0 after 19089 usecs
[    2.979374] calling  microcode_init+0x0/0x163 @ 1
[    2.984048] microcode: no support for this CPU vendor
[    2.989068] initcall microcode_init+0x0/0x163 returned -19 after 4902 usecs
[    2.995992] calling  start_periodic_check_for_corruption+0x0/0x58 @ 1
[    3.002396] initcall start_periodic_check_for_corruption+0x0/0x58 returned 0 after 2 usecs
[    3.010654] calling  audit_classes_init+0x0/0xaf @ 1
[    3.015589] initcall audit_classes_init+0x0/0xaf returned 0 after 27 usecs
[    3.022423] calling  aes_init+0x0/0x12 @ 1
[    3.029356] initcall aes_init+0x0/0x12 returned 0 after 439 usecs
[    3.037965] calling  init+0x0/0x12 @ 1
[    3.042911] initcall init+0x0/0x12 returned 0 after 340 usecs
[    3.047715] calling  crc32c_intel_mod_init+0x0/0x34 @ 1
[    3.053906] initcall crc32c_intel_mod_init+0x0/0x34 returned -19 after 1 usecs
[    3.060141] calling  init_vdso_vars+0x0/0x2ac @ 1
[    3.064814] initcall init_vdso_vars+0x0/0x2ac returned 0 after 35 usecs
[    3.071394] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    3.076156] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 11 usecs
[    3.082819] calling  sysenter_setup+0x0/0xd0 @ 1
[    3.087406] initcall sysenter_setup+0x0/0xd0 returned 0 after 10 usecs
[    3.094895] calling  init_aout_binfmt+0x0/0x12 @ 1
[    3.098656] initcall init_aout_binfmt+0x0/0x12 returned 0 after 3 usecs
[    3.105234] calling  init_sched_debug_procfs+0x0/0x3c @ 1
[    3.110600] initcall init_sched_debug_procfs+0x0/0x3c returned 0 after 27 usecs
[    3.117928] calling  proc_schedstat_init+0x0/0x22 @ 1
[    3.122950] initcall proc_schedstat_init+0x0/0x22 returned 0 after 18 usecs
[    3.129872] calling  proc_execdomains_init+0x0/0x22 @ 1
[    3.135067] initcall proc_execdomains_init+0x0/0x22 returned 0 after 19 usecs
[    3.142162] calling  ioresources_init+0x0/0x3c @ 1
[    3.146922] initcall ioresources_init+0x0/0x3c returned 0 after 31 usecs
[    3.153585] calling  uid_cache_init+0x0/0x6e @ 1
[    3.158174] initcall uid_cache_init+0x0/0x6e returned 0 after 30 usecs
[    3.164662] calling  init_posix_timers+0x0/0x108 @ 1
[    3.169596] initcall init_posix_timers+0x0/0x108 returned 0 after 13 usecs
[    3.176432] calling  init_posix_cpu_timers+0x0/0xd4 @ 1
[    3.181627] initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 1 usecs
[    3.188636] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    3.193570] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 13 usecs
[    3.200405] calling  create_proc_profile+0x0/0x9d @ 1
[    3.205426] initcall create_proc_profile+0x0/0x9d returned 0 after 40 usecs
[    3.212357] calling  timekeeping_init_device+0x0/0x3a @ 1
[    3.217724] Registering sysdev class 'timekeeping'
[    3.222823] Registering sys device of class 'timekeeping'
[    3.228175] Registering sys device 'timekeeping0'
[    3.233851] initcall timekeeping_init_device+0x0/0x3a returned 0 after 15138 usecs
[    3.240786] calling  init_clocksource_sysfs+0x0/0x90 @ 1
[    3.246065] Registering sysdev class 'clocksource'
[    3.251827] Registering sys device of class 'clocksource'
[    3.256538] Registering sys device 'clocksource0'
[    3.261530] initcall init_clocksource_sysfs+0x0/0x90 returned 0 after 15146 usecs
[    3.269047] calling  init_timer_list_procfs+0x0/0x3c @ 1
[    3.274326] initcall init_timer_list_procfs+0x0/0x3c returned 0 after 23 usecs
[    3.281563] calling  lockdep_proc_init+0x0/0x7c @ 1
[    3.286411] initcall lockdep_proc_init+0x0/0x7c returned 0 after 59 usecs
[    3.293188] calling  futex_init+0x0/0xa8 @ 1
[    3.297430] initcall futex_init+0x0/0xa8 returned 0 after 33 usecs
[    3.303575] calling  proc_dma_init+0x0/0x22 @ 1
[    3.308077] initcall proc_dma_init+0x0/0x22 returned 0 after 16 usecs
[    3.314479] calling  kallsyms_init+0x0/0x25 @ 1
[    3.318981] initcall kallsyms_init+0x0/0x25 returned 0 after 37 usecs
[    3.325389] calling  snapshot_device_init+0x0/0x12 @ 1
[    3.330497] device: 'snapshot': device_add
[    3.334563] PM: Adding info for No Bus:snapshot
[    3.339440] initcall snapshot_device_init+0x0/0x12 returned 0 after 8769 usecs
[    3.346691] calling  audit_init+0x0/0x1ca @ 1
[    3.351019] audit: initializing netlink socket (disabled)
[    3.356386] type=2000 audit(1237447421.356:1): initialized
[    3.361881] initcall audit_init+0x0/0x1ca returned 0 after 10628 usecs
[    3.368372] calling  audit_tree_init+0x0/0x72 @ 1
[    3.373048] initcall audit_tree_init+0x0/0x72 returned 0 after 7 usecs
[    3.379537] calling  rcu_torture_init+0x0/0xb11 @ 1
[    3.384385] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[    3.403875] initcall rcu_torture_init+0x0/0xb11 returned 0 after 19018 usecs
[    3.411849] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    3.415907] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 11 usecs
[    3.423832] calling  init_lstats_procfs+0x0/0x25 @ 1
[    3.427776] initcall init_lstats_procfs+0x0/0x25 returned 0 after 27 usecs
[    3.434626] calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
[    3.439648] initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 15 usecs
[    3.446581] calling  init_events+0x0/0xdb @ 1
[    3.450910] initcall init_events+0x0/0xdb returned 0 after 28 usecs
[    3.457161] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    3.462526] Testing tracer sched_switch: PASSED
[    3.568846] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 104704 usecs
[    3.577411] calling  init_stack_trace+0x0/0x12 @ 1
[    3.582173] Testing tracer sysprof: PASSED
[    3.687242] initcall init_stack_trace+0x0/0x12 returned 0 after 102596 usecs
[    3.694252] calling  init_function_trace+0x0/0x17 @ 1
[    3.699270] Testing tracer function: PASSED
[    3.824508] Testing dynamic ftrace: PASSED
[    4.090767] initcall init_function_trace+0x0/0x17 returned 0 after 383244 usecs
[    4.099036] calling  init_irqsoff_tracer+0x0/0x14 @ 1
[    4.104072] Testing tracer irqsoff: .. no entries found ..FAILED!
[    4.124863] initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 21039 usecs
[    4.132872] calling  init_mmio_trace+0x0/0x12 @ 1
[    4.137551] initcall init_mmio_trace+0x0/0x12 returned 0 after 10 usecs
[    4.144149] calling  init_graph_trace+0x0/0x12 @ 1
[    4.148913] Testing tracer function_graph: <3>INFO: RCU detected CPU 0 stall (t=4294680313/10000 jiffies)
[   18.620342] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067
[   18.620342] Call Trace:
[   18.620342]  <IRQ>  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b2d5>] print_context_stack+0xbc/0x11e
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80219c2e>] dump_trace+0x221/0x271
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b180>] show_trace_log_lvl+0x51/0x5e
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b1a2>] show_trace+0x15/0x17
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8021b505>] dump_stack+0x77/0x82
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e343b>] print_cpu_stall+0x40/0x9b
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e384f>] check_cpu_stall+0x11e/0x15c
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e38a4>] __rcu_pending+0x17/0xff
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802e39b8>] rcu_pending+0x2c/0x5e
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8028b89a>] update_process_times+0x3c/0x76
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a901e>] tick_periodic+0x7a/0x86
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a9050>] tick_handle_periodic+0x26/0x8a
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a97f8>] tick_do_broadcast+0x1d4/0x23a
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a9929>] tick_do_periodic_broadcast+0x4c/0x5d
[   18.620342]  [<ffffffff802e28b9>] ? rcu_torture_timer+0x0/0x12b
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802a994e>] tick_handle_periodic_broadcast+0x14/0x75
[   18.620342]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80219f0f>] timer_interrupt+0x1f/0x26
[   18.620342]  [<ffffffff811f1a6d>] ? _spin_unlock_irq+0x9/0x3b
[   18.620342]  [<ffffffff811f1a9b>] ? _spin_unlock_irq+0x37/0x3b
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802dd04c>] handle_IRQ_event+0x167/0x230
[   18.620342]  [<ffffffff8025e8e4>] ? idle_cpu+0x4/0x33
[   18.620342]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
[   18.620342]  [<ffffffff80284453>] ? __local_bh_disable+0x11/0x16c
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff802dfc86>] handle_edge_irq+0x1bf/0x225
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80219305>] handle_irq+0x15d/0x171
[   18.620342]  [<ffffffff802195e9>] ? do_softirq+0x80/0x187
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff811f2457>] do_IRQ+0x5f/0xfc
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff80215953>] ret_from_intr+0x0/0x16
[   18.620342]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   18.620342]  [<ffffffff8028aa1d>] run_timer_softirq+0x1c1/0x2af
[   18.620342]  <EOI>  [<ffffffff802ce8f0>] ? ack_state+0x4/0x45
[   18.620342]  [<ffffffff802ced22>] ? stop_cpu+0x1c5/0x1d1
[   18.620342]  [<ffffffff80294a29>] ? run_workqueue+0x1a0/0x2e2
[   18.620342]  [<ffffffff802949d6>] ? run_workqueue+0x14d/0x2e2
[   18.620342]  [<ffffffff802ceb5d>] ? stop_cpu+0x0/0x1d1
[   18.620342]  [<ffffffff826b4140>] ? early_idt_handler+0x0/0x73
[   18.620342]  [<ffffffff80295d1b>] ? worker_thread+0x138/0x14c
[   18.620342]  [<ffffffff80299e63>] ? autoremove_wake_function+0x0/0x4f
[   18.620342]  [<ffffffff80295be3>] ? worker_thread+0x0/0x14c
[   18.620342]  [<ffffffff80299d20>] ? kthread+0x60/0xa0
[   18.620342]  [<ffffffff8021606a>] ? child_rip+0xa/0x20
[   18.620342]  [<ffffffff8026fd4b>] ? finish_task_switch+0x56/0x180
[   18.620342]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
[   18.620342]  [<ffffffff80299cc0>] ? kthread+0x0/0xa0
[   18.620342]  [<ffffffff80216060>] ? child_rip+0x0/0x20
[   64.758749] INFO: RCU detected CPU 0 stall (t=4294710313/40000 jiffies)
[   64.758749] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067
[   64.758749] Call Trace:
[   64.758749]  <IRQ>  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff8021b2d5>] print_context_stack+0xbc/0x11e
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff80219c2e>] dump_trace+0x221/0x271
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff8021b180>] show_trace_log_lvl+0x51/0x5e
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff8021b1a2>] show_trace+0x15/0x17
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff8021b505>] dump_stack+0x77/0x82
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802e343b>] print_cpu_stall+0x40/0x9b
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802e384f>] check_cpu_stall+0x11e/0x15c
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802e38a4>] __rcu_pending+0x17/0xff
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802e39b8>] rcu_pending+0x2c/0x5e
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff8028b89a>] update_process_times+0x3c/0x76
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802a901e>] tick_periodic+0x7a/0x86
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802a9050>] tick_handle_periodic+0x26/0x8a
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802a97f8>] tick_do_broadcast+0x1d4/0x23a
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802a9929>] tick_do_periodic_broadcast+0x4c/0x5d
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802a994e>] tick_handle_periodic_broadcast+0x14/0x75
[   64.758749]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff80219f0f>] timer_interrupt+0x1f/0x26
[   64.758749]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[   64.758749]  [<ffffffff802f897d>] ? trace_graph_return+0xf0/0xfe
[   64.758749]  [<ffffffff80301787>] ? ftrace_return_to_handler+0x2d/0x88
[   64.758749]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[   64.758749]  [<ffffffff807ab48f>] ? __delay+0xf/0x11
[   64.758749]  [<ffffffff80214c72>] ? return_to_handler+0x35/0x73
[   64.758749]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802dd04c>] handle_IRQ_event+0x167/0x230
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802dfc86>] handle_edge_irq+0x1bf/0x225
[   64.758749]  [<ffffffff802e28b9>] ? rcu_torture_timer+0x0/0x12b
[   64.758749]  [<ffffffff807b0947>] ? _raw_spin_lock+0x131/0x156
[   64.758749]  [<ffffffff811f150d>] ? _spin_lock+0x68/0x7d
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff80219305>] handle_irq+0x15d/0x171
[   64.758749]  [<ffffffff802e2bdc>] ? rcu_batches_completed+0x4/0x12
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff811f2457>] do_IRQ+0x5f/0xfc
[   64.758749]  [<ffffffff8028aa65>] ? run_timer_softirq+0x209/0x2af
[   64.758749]  [<ffffffff8028a9d1>] ? run_timer_softirq+0x175/0x2af
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff80215953>] ret_from_intr+0x0/0x16
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff807b0619>] __spin_lock_debug+0x87/0xea
[   64.758749]  [<ffffffff802195e9>] ? do_softirq+0x80/0x187
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff802e2932>] rcu_torture_timer+0x79/0x12b
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff80284ef0>] __do_softirq+0x10f/0x2ba
[   64.758749]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[   64.758749]  [<ffffffff8021616c>] call_softirq+0x1c/0x30
[   64.758749]  <EOI>  [<ffffffff802ce8f0>] ? ack_state+0x4/0x45
[   64.758749]  [<ffffffff802ced22>] ? stop_cpu+0x1c5/0x1d1
[   64.758749]  [<ffffffff80294a29>] ? run_workqueue+0x1a0/0x2e2
[   64.758749]  [<ffffffff802949d6>] ? run_workqueue+0x14d/0x2e2
[   64.758749]  [<ffffffff802ceb5d>] ? stop_cpu+0x0/0x1d1
[   64.758749]  [<ffffffff826b4140>] ? early_idt_handler+0x0/0x73
[   64.758749]  [<ffffffff80295d1b>] ? worker_thread+0x138/0x14c
[   64.758749]  [<ffffffff80299e63>] ? autoremove_wake_function+0x0/0x4f
[   64.758749]  [<ffffffff80295be3>] ? worker_thread+0x0/0x14c
[   64.758749]  [<ffffffff80299d20>] ? kthread+0x60/0xa0
[   64.758749]  [<ffffffff8021606a>] ? child_rip+0xa/0x20
[   64.758749]  [<ffffffff8026fd4b>] ? finish_task_switch+0x56/0x180
[   64.758749]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
[   64.758749]  [<ffffffff80299cc0>] ? kthread+0x0/0xa0
[   64.758749]  [<ffffffff80216060>] ? child_rip+0x0/0x20
[  111.076761] INFO: RCU detected CPU 0 stall (t=4294740313/70000 jiffies)
[  111.076761] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067
[  111.076761] Call Trace:
[  111.076761]  <IRQ>  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff8021b2d5>] print_context_stack+0xbc/0x11e
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff80219c2e>] dump_trace+0x221/0x271
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff8021b180>] show_trace_log_lvl+0x51/0x5e
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff8021b1a2>] show_trace+0x15/0x17
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff8021b505>] dump_stack+0x77/0x82
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802e343b>] print_cpu_stall+0x40/0x9b
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802e384f>] check_cpu_stall+0x11e/0x15c
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802e38a4>] __rcu_pending+0x17/0xff
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802e39b8>] rcu_pending+0x2c/0x5e
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff8028b89a>] update_process_times+0x3c/0x76
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802a901e>] tick_periodic+0x7a/0x86
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802a9050>] tick_handle_periodic+0x26/0x8a
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802a97f8>] tick_do_broadcast+0x1d4/0x23a
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802a9929>] tick_do_periodic_broadcast+0x4c/0x5d
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802a994e>] tick_handle_periodic_broadcast+0x14/0x75
[  111.076761]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff80219f0f>] timer_interrupt+0x1f/0x26
[  111.076761]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[  111.076761]  [<ffffffff802f897d>] ? trace_graph_return+0xf0/0xfe
[  111.076761]  [<ffffffff80301787>] ? ftrace_return_to_handler+0x2d/0x88
[  111.076761]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[  111.076761]  [<ffffffff807ab48f>] ? __delay+0xf/0x11
[  111.076761]  [<ffffffff80214c72>] ? return_to_handler+0x35/0x73
[  111.076761]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802dd04c>] handle_IRQ_event+0x167/0x230
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802dfc86>] handle_edge_irq+0x1bf/0x225
[  111.076761]  [<ffffffff802e28b9>] ? rcu_torture_timer+0x0/0x12b
[  111.076761]  [<ffffffff807b0947>] ? _raw_spin_lock+0x131/0x156
[  111.076761]  [<ffffffff811f150d>] ? _spin_lock+0x68/0x7d
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff80219305>] handle_irq+0x15d/0x171
[  111.076761]  [<ffffffff802e2bdc>] ? rcu_batches_completed+0x4/0x12
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff811f2457>] do_IRQ+0x5f/0xfc
[  111.076761]  [<ffffffff8028aa65>] ? run_timer_softirq+0x209/0x2af
[  111.076761]  [<ffffffff8028a9d1>] ? run_timer_softirq+0x175/0x2af
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff80215953>] ret_from_intr+0x0/0x16
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff807b0619>] __spin_lock_debug+0x87/0xea
[  111.076761]  [<ffffffff802195e9>] ? do_softirq+0x80/0x187
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff802e2932>] rcu_torture_timer+0x79/0x12b
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff80284ef0>] __do_softirq+0x10f/0x2ba
[  111.076761]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  111.076761]  [<ffffffff8021616c>] call_softirq+0x1c/0x30
[  111.076761]  <EOI>  [<ffffffff802ce8f0>] ? ack_state+0x4/0x45
[  111.076761]  [<ffffffff802ced22>] ? stop_cpu+0x1c5/0x1d1
[  111.076761]  [<ffffffff80294a29>] ? run_workqueue+0x1a0/0x2e2
[  111.076761]  [<ffffffff802949d6>] ? run_workqueue+0x14d/0x2e2
[  111.076761]  [<ffffffff802ceb5d>] ? stop_cpu+0x0/0x1d1
[  111.076761]  [<ffffffff826b4140>] ? early_idt_handler+0x0/0x73
[  111.076761]  [<ffffffff80295d1b>] ? worker_thread+0x138/0x14c
[  111.076761]  [<ffffffff80299e63>] ? autoremove_wake_function+0x0/0x4f
[  111.076761]  [<ffffffff80295be3>] ? worker_thread+0x0/0x14c
[  111.076761]  [<ffffffff80299d20>] ? kthread+0x60/0xa0
[  111.076761]  [<ffffffff8021606a>] ? child_rip+0xa/0x20
[  111.076761]  [<ffffffff8026fd4b>] ? finish_task_switch+0x56/0x180
[  111.076761]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
[  111.076761]  [<ffffffff80299cc0>] ? kthread+0x0/0xa0
[  111.076761]  [<ffffffff80216060>] ? child_rip+0x0/0x20
[  157.371831] INFO: RCU detected CPU 0 stall (t=4294770313/100000 jiffies)
[  157.371831] Pid: 858, comm: kstop/0 Not tainted 2.6.29-rc8-tip-02638-g1c002f5-dirty #3067
[  157.371831] Call Trace:
[  157.371831]  <IRQ>  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff8021b2d5>] print_context_stack+0xbc/0x11e
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff80219c2e>] dump_trace+0x221/0x271
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff8021b180>] show_trace_log_lvl+0x51/0x5e
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff8021b1a2>] show_trace+0x15/0x17
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff8021b505>] dump_stack+0x77/0x82
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802e343b>] print_cpu_stall+0x40/0x9b
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802e384f>] check_cpu_stall+0x11e/0x15c
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802e38a4>] __rcu_pending+0x17/0xff
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802e39b8>] rcu_pending+0x2c/0x5e
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff8028b89a>] update_process_times+0x3c/0x76
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802a901e>] tick_periodic+0x7a/0x86
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802a9050>] tick_handle_periodic+0x26/0x8a
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802a97f8>] tick_do_broadcast+0x1d4/0x23a
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802a9929>] tick_do_periodic_broadcast+0x4c/0x5d
[  157.371831]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802a994e>] tick_handle_periodic_broadcast+0x14/0x75
[  157.371831]  [<ffffffff80214c3d>] return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff80219f0f>] timer_interrupt+0x1f/0x26
[  157.371831]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[  157.371831]  [<ffffffff802f8876>] ? trace_graph_entry+0x1bc/0x1d3
[  157.371831]  [<ffffffff807ab48f>] ? __delay+0xf/0x11
[  157.371831]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[  157.371831]  [<ffffffff8024200f>] ? prepare_ftrace_return+0x124/0x15a
[  157.371831]  [<ffffffff807ab434>] ? delay_loop+0x4/0x3a
[  157.371831]  [<ffffffff80214c16>] ? ftrace_graph_caller+0x46/0x6d
[  157.371831]  [<ffffffff807ab439>] ? delay_loop+0x9/0x3a
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802dd04c>] handle_IRQ_event+0x167/0x230
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802dfc86>] handle_edge_irq+0x1bf/0x225
[  157.371831]  [<ffffffff802e28b9>] ? rcu_torture_timer+0x0/0x12b
[  157.371831]  [<ffffffff807b0947>] ? _raw_spin_lock+0x131/0x156
[  157.371831]  [<ffffffff811f150d>] ? _spin_lock+0x68/0x7d
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff80219305>] handle_irq+0x15d/0x171
[  157.371831]  [<ffffffff802e2bdc>] ? rcu_batches_completed+0x4/0x12
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff811f2457>] do_IRQ+0x5f/0xfc
[  157.371831]  [<ffffffff8028aa65>] ? run_timer_softirq+0x209/0x2af
[  157.371831]  [<ffffffff8028a9d1>] ? run_timer_softirq+0x175/0x2af
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff80215953>] ret_from_intr+0x0/0x16
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff807ab48f>] __delay+0xf/0x11
[  157.371831]  [<ffffffff802195e9>] ? do_softirq+0x80/0x187
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff807b0619>] __spin_lock_debug+0x87/0xea
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff802e2932>] rcu_torture_timer+0x79/0x12b
[  157.371831]  [<ffffffff80214c3d>] ? return_to_handler+0x0/0x73
[  157.371831]  [<ffffffff80284ef0>] __do_softirq+0x10f/0x2ba
[  157.371831]  <EOI>  [<ffffffff802ce8f0>] ? ack_state+0x4/0x45
[  157.371831]  [<ffffffff802ced22>] ? stop_cpu+0x1c5/0x1d1
[  157.371831]  [<ffffffff80294a29>] ? run_workqueue+0x1a0/0x2e2
[  157.371831]  [<ffffffff802949d6>] ? run_workqueue+0x14d/0x2e2
[  157.371831]  [<ffffffff802ceb5d>] ? stop_cpu+0x0/0x1d1
[  157.371831]  [<ffffffff826b4140>] ? early_idt_handler+0x0/0x73
[  157.371831]  [<ffffffff80295d1b>] ? worker_thread+0x138/0x14c
[  157.371831]  [<ffffffff80299e63>] ? autoremove_wake_function+0x0/0x4f
[  157.371831]  [<ffffffff80295be3>] ? worker_thread+0x0/0x14c
[  157.371831]  [<ffffffff80299d20>] ? kthread+0x60/0xa0
[  157.371831]  [<ffffffff8021606a>] ? child_rip+0xa/0x20
[  157.371831]  [<ffffffff8026fd4b>] ? finish_task_switch+0x56/0x180
[  157.371831]  [<ffffffff80215a10>] ? restore_args+0x0/0x30
[  157.371831]  [<ffffffff80299cc0>] ? kthread+0x0/0xa0
[  157.371831]  [<ffffffff80216060>] ? child_rip+0x0/0x20

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc8
# Thu Mar 19 09:30:34 2009
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
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_INITRAMFS_COMPRESSION_NONE is not set
CONFIG_INITRAMFS_COMPRESSION_GZIP=y
# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
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
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_SPARSE_IRQ=y
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
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_X86_CPU_DEBUG=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
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
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
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
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
CONFIG_PCI_DEBUG=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_PCMCIA_IOCTL is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_PIMSM_V2 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=y
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=y

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_MATCH_AH=y
# CONFIG_IP_NF_MATCH_ECN is not set
CONFIG_IP_NF_MATCH_TTL=y
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_ECN is not set
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_SECURITY=y
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_QUEUE=y
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_ROUTE=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_IPT=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_AF_RXRPC is not set
CONFIG_PHONET=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=y
CONFIG_DELL_LAPTOP=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_LIBFC=y
CONFIG_FCOE=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=y
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=y
# CONFIG_PATA_ACPI is not set
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=y
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=y
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OPTI=y
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_SCH=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_IEEE1394=y
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=y
# CONFIG_IEEE1394_SBP2 is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VERBOSEDEBUG=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_NET_SB1000=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
CONFIG_DNET=y
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
# CONFIG_PCNET32 is not set
CONFIG_AMD8111_ETH=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_E100=y
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=y
# CONFIG_SIS900 is not set
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_SC92031=y
CONFIG_NET_POCKET=y
# CONFIG_ATP is not set
CONFIG_DE600=y
CONFIG_DE620=y
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=y
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=y
CONFIG_IGB_LRO=y
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
CONFIG_SIS190=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=y
# CONFIG_PCMCIA_WAVELAN is not set
CONFIG_PCMCIA_NETWAVE=y
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
CONFIG_USB_NET_PLUSB=y
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_HSO=y
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_PCMCIA_PCNET=y
CONFIG_PCMCIA_NMCLAN=y
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_PCMCIA_XIRC2PS=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_ARCNET_COM20020_CS=y
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
# CONFIG_PPPOATM is not set
CONFIG_PPPOL2TP=y
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
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
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
# CONFIG_CONSOLE_TRANSLATIONS is not set
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
CONFIG_DIGIEPCA=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_N_HDLC=y
CONFIG_RISCOM8=y
CONFIG_SPECIALIX=y
CONFIG_SX=y
CONFIG_RIO=y
CONFIG_RIO_OLDPCI=y
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
# CONFIG_SENSORS_PCF8574 is not set
CONFIG_PCF8575=y
CONFIG_SENSORS_PCA9539=y
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_MAX6875=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_DA9030 is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7473=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHER is not set
CONFIG_SENSORS_FSCPOS=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_SC520_WDT=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_PCF50633=y

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
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_IR=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=y
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TDA9875=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_M52790=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_CX25840=y
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y
CONFIG_VIDEO_VIVI=y
CONFIG_VIDEO_BT848=y
CONFIG_VIDEO_SAA6588=y
CONFIG_VIDEO_BWQCAM=y
CONFIG_VIDEO_CQCAM=y
CONFIG_VIDEO_W9966=y
CONFIG_VIDEO_CPIA=y
CONFIG_VIDEO_CPIA_PP=y
CONFIG_VIDEO_CPIA_USB=y
CONFIG_VIDEO_CPIA2=y
# CONFIG_VIDEO_SAA5246A is not set
CONFIG_VIDEO_SAA5249=y
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
CONFIG_VIDEO_MEYE=y
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_MXB=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_IVTV=y
CONFIG_VIDEO_CAFE_CCIC=y
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_MT9M001=y
# CONFIG_SOC_CAMERA_MT9M111 is not set
# CONFIG_SOC_CAMERA_MT9T031 is not set
CONFIG_SOC_CAMERA_MT9V022=y
CONFIG_SOC_CAMERA_TW9910=y
# CONFIG_SOC_CAMERA_PLATFORM is not set
CONFIG_SOC_CAMERA_OV772X=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=y
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GSPCA_CONEX is not set
CONFIG_USB_GSPCA_ETOMS=y
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_OV519 is not set
CONFIG_USB_GSPCA_OV534=y
CONFIG_USB_GSPCA_PAC207=y
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SONIXB is not set
CONFIG_USB_GSPCA_SONIXJ=y
CONFIG_USB_GSPCA_SPCA500=y
CONFIG_USB_GSPCA_SPCA501=y
CONFIG_USB_GSPCA_SPCA505=y
CONFIG_USB_GSPCA_SPCA506=y
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
CONFIG_USB_GSPCA_STK014=y
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
CONFIG_USB_GSPCA_TV8532=y
CONFIG_USB_GSPCA_VC032X=y
CONFIG_USB_GSPCA_ZC3XX=y
CONFIG_VIDEO_PVRUSB2=y
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_USBVISION=y
CONFIG_VIDEO_USBVIDEO=y
# CONFIG_USB_VICAM is not set
CONFIG_USB_IBMCAM=y
CONFIG_USB_KONICAWC=y
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
CONFIG_VIDEO_OVCAMCHIP=y
# CONFIG_USB_W9968CF is not set
CONFIG_USB_OV511=y
CONFIG_USB_SE401=y
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
CONFIG_USB_ZC0301=y
CONFIG_USB_PWC=y
CONFIG_USB_PWC_DEBUG=y
# CONFIG_USB_ZR364XX is not set
CONFIG_USB_STKWEBCAM=y
CONFIG_USB_S2255=y
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_MAESTRO=y
CONFIG_USB_DSBR=y
CONFIG_USB_SI470X=y
# CONFIG_USB_MR800 is not set
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
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
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_MBP_NVIDIA=y
# CONFIG_BACKLIGHT_SAHARA is not set

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
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
# CONFIG_HID_APPLE is not set
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
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

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
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP2101=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_TI=y
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_TWL4030_USB=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_WLP is not set
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_ALIX2=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_DA903X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_UIO is not set
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
# CONFIG_XENFS is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_HP_WMI=y
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_BAY is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ACPI_WMI=y
CONFIG_ACPI_ASUS=y
CONFIG_ACPI_TOSHIBA=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_OCFS2_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

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
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_EXPORTFS=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
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
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_EVENT_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
CONFIG_POWER_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_HW_BRANCH_TRACER is not set
# CONFIG_KMEMTRACE is not set
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_MMIOTRACE=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_PRINTK_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_IOMMU_DEBUG=y
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
CONFIG_SECURITY_SELINUX_DISABLE=y
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
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
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y

--qDbXVdCdHGoSgWSk--
