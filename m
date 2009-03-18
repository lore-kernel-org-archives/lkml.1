Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZCRLV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZCRLV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZCRLVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:21:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43774 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbZCRLVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:21:35 -0400
Date: Wed, 18 Mar 2009 12:20:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: forcedeth 0000:00:0a.0: DMA-API: device driver frees DMA memory
	with wrong function [device address=0x0000000035992232] [size=42
	bytes] [mapped as single] [unmapped as page]
Message-ID: <20090318112026.GA32233@elte.hu>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20090318093847.GC5879@elte.hu>
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


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


-tip testing found this DMA-debug assert:

[   19.648023] eth0: no link during initialization.
[   21.952553] eth0: link up.
[   22.684073] ------------[ cut here ]------------
[   22.688023] WARNING: at lib/dma-debug.c:562 check_unmap+0x30e/0x4b4()
[   22.688023] Hardware name: System Product Name
[   22.688023] 
forcedeth 0000:00:0a.0: DMA-API: device driver frees DMA memory with wrong function [device address=0x0000000035992232] [size=42 bytes] [mapped as single] [unmapped as page]
[   22.688023] Modules linked in:
[   22.688023] Pid: 1523, comm: arping Not tainted 2.6.29-rc8-tip #20999
[   22.688023] Call Trace:
[   22.688023]  [<c0140eae>] warn_slowpath+0x76/0xad
[   22.688023]  [<c0293a0b>] ? add_dma_entry+0x4b/0x51
[   22.688023]  [<c015eec5>] ? mark_lock+0x1c/0x16f
[   22.688023]  [<c015f1a4>] ? __lock_acquire+0x18c/0x296
[   22.688023]  [<c03473cc>] ? nv_start_xmit_optimized+0x3bd/0x3eb
[   22.688023]  [<c015eec5>] ? mark_lock+0x1c/0x16f
[   22.688023]  [<c015f1a4>] ? __lock_acquire+0x18c/0x296
[   22.688023]  [<c0293572>] check_unmap+0x30e/0x4b4
[   22.688023]  [<c055f7c3>] ? _spin_lock+0x27/0x2f
[   22.688023]  [<c0145ba1>] ? _local_bh_enable_ip+0xa1/0xa7
[   22.688023]  [<c049e0f8>] ? dev_queue_xmit+0x325/0x359
[   22.688023]  [<c0188922>] ? trace_hardirqs_on+0x21/0x23
[   22.688023]  [<c0145ba1>] ? _local_bh_enable_ip+0xa1/0xa7
[   22.688023]  [<c0145bc6>] ? local_bh_enable+0x10/0x12
[   22.688023]  [<c050225c>] ? packet_sendmsg+0x1b7/0x20a
[   22.688023]  [<c02939b8>] debug_dma_unmap_page+0x59/0x61
[   22.688023]  [<c034421f>] pci_unmap_page+0x5b/0x66
[   22.688023]  [<c03446fd>] nv_tx_done_optimized+0x46/0x1c5
[   22.688023]  [<c0345922>] nv_nic_irq_optimized+0xa7/0x233
[   22.688023]  [<c017706e>] handle_IRQ_event+0x85/0xdf
[   22.688023]  [<c01785df>] handle_fasteoi_irq+0x79/0xb9
[   22.688023]  [<c0119973>] handle_irq+0x1f/0x24
[   22.688023]  [<c0119332>] do_IRQ+0x45/0x88
[   22.688023]  [<c0118455>] common_interrupt+0x35/0x40
[   22.688023]  [<c0144515>] ? do_setitimer+0x160/0x2d9
[   22.688023]  [<c055f69b>] ? _spin_unlock_irq+0x29/0x2b
[   22.688023]  [<c0144515>] do_setitimer+0x160/0x2d9
[   22.688023]  [<c04926fa>] ? sys_socketcall+0xed/0x188
[   22.688023]  [<c014473b>] alarm_setitimer+0x39/0x58
[   22.688023]  [<c0149776>] sys_alarm+0x10/0x12
[   22.688023]  [<c0117d47>] sysenter_do_call+0x12/0x32
[   22.688023] ---[ end trace bf7fa25698012db6 ]---
[   22.688023] Mapped at:
[   22.688023]  [<c0293cc1>] debug_dma_map_page+0x6c/0x128
[   22.688023]  [<c0345bd0>] pci_map_single+0xb5/0xc1
[   22.688023]  [<c0347147>] nv_start_xmit_optimized+0x138/0x3eb
[   22.688023]  [<c049dc7c>] dev_hard_start_xmit+0x123/0x18f
[   22.688023]  [<c04acbb9>] __qdisc_run+0xd0/0x1b3
[   23.700081] arping used greatest stack depth: 5988 bytes left
[   24.545512] Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k 

Config and full bootlog attached.

	Ingo

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.29-rc8-tip (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #20999 SMP Wed Mar 18 11:07:17 CET 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x1000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ d79000-f3a000
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f5680] f5680
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f1400-f152c
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Warning! Not a NUMA-Q system!
[    0.000000] NUMA - single node, flat memory mode
[    0.000000] Node: 0, start_pfn: 0, end_pfn: 3fff0
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000 2c000 30000 34000 38000 3c000 
[    0.000000] node 0 pfn: [0 - 3fff0]
[    0.000000] Reserving 3584 pages of KVA for lmem_map of node 0 at 3f000
[    0.000000] remove_active_range (0, 258048, 261632)
[    0.000000] Reserving total of e00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 36a00 max_low_pfn ~ 379fe
[    0.000000] max_pfn = 3fff0
[    0.000000] 133MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000] max_low_pfn = 379fe, highstart_pfn = 379fe
[    0.000000] Low memory ends at vaddr f79fe000
[    0.000000] node 0 will remap to vaddr f6a00000 - f7800000
[    0.000000] allocate_pgdat: node 0 NODE_DATA f6a00000
[    0.000000] remap_numa_kva: node 0
[    0.000000] remap_numa_kva: f6a00000 to pfn 0003f000
[    0.000000] remap_numa_kva: f6c00000 to pfn 0003f200
[    0.000000] remap_numa_kva: f6e00000 to pfn 0003f400
[    0.000000] remap_numa_kva: f7000000 to pfn 0003f600
[    0.000000] remap_numa_kva: f7200000 to pfn 0003f800
[    0.000000] remap_numa_kva: f7400000 to pfn 0003fa00
[    0.000000] remap_numa_kva: f7600000 to pfn 0003fc00
[    0.000000] High memory starts at vaddr f79fe000
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000]   node 0 low ram: 00000000 - 379fe000
[    0.000000]   node 0 bootmap 00007000 - 0000df40
[    0.000000] (10 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000d2c7cc]    TEXT DATA BSS ==> [0000100000 - 0000d2c7cc]
[    0.000000]   #4 [0000d2d000 - 0000d79000]    INIT_PG_TABLE ==> [0000d2d000 - 0000d79000]
[    0.000000]   #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #6 [0000d79000 - 0000eea000]          PGTABLE ==> [0000d79000 - 0000eea000]
[    0.000000]   #7 [003f000000 - 003fe00000]          KVA RAM
[    0.000000]   #8 [0036a00000 - 0037800000]           KVA PG ==> [0036a00000 - 0037800000]
[    0.000000]   #9 [0000007000 - 000000e000]          BOOTMAP ==> [0000007000 - 000000e000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f000
[    0.000000]     0: 0x0003fe00 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 258447
[    0.000000] free_area_init_node: node 0, pgdat f6a00000, node_mem_map f6a02000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 2841 pages used for memmap
[    0.000000]   Normal zone: 220901 pages, LIFO batch:31
[    0.000000]   HighMem zone: 436 pages used for memmap
[    0.000000]   HighMem zone: 30270 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f1400-f152c
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Warning! Not a NUMA-Q system!
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
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:16
[    0.000000] PERCPU: Embedded 14 pages at c100d000, static data 33244 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255118
[    0.000000] Policy zone: HighMem
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1
[    0.000000] debug: sysrq always enabled.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.551 MHz processor.
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
[    0.004000]  memory used by lock dependency info: 2847 kB
[    0.004000]  per task-struct memory footprint: 1152 bytes
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
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Initializing HighMem for node 0 (000379fe:0003fff0)
[    0.004000] Memory: 1004160k/1048512k available (4492k kernel code, 29624k reserved, 2527k data, 448k init, 122824k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffe17000 - 0xfffff000   (1952 kB)
[    0.004000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.004000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.004000]       .init : 0xc07e3000 - 0xc0853000   ( 448 kB)
[    0.004000]       .data : 0xc0563398 - 0xc07db2e0   (2527 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0563398   (4492 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=16
[    0.004011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4021.10 BogoMIPS (lpj=8042204)
[    0.012084] Security Framework initialized
[    0.016048] Mount-cache hash table entries: 512
[    0.020540] Initializing cgroup subsys debug
[    0.024005] Initializing cgroup subsys ns
[    0.028005] Initializing cgroup subsys cpuacct
[    0.032005] Initializing cgroup subsys freezer
[    0.036004] Initializing cgroup subsys net_cls
[    0.040048] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.044003] CPU: L2 Cache: 512K (64 bytes/line)
[    0.048003] CPU: Physical Processor ID: 0
[    0.052003] CPU: Processor Core ID: 0
[    0.056005] Intel machine check architecture supported.
[    0.060004] Intel machine check reporting enabled on CPU#0.
[    0.064025] Checking 'hlt' instruction... OK.
[    0.084764] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.088009] ftrace: allocating 22427 entries in 44 pages
[    0.100290] enabled ExtINT on CPU#0
[    0.104053] ExtINT not setup in hardware but reported by MP table
[    0.108094] Mapping cpu 0 to node 0
[    0.112003] ENABLING IO-APIC IRQs
[    0.116004] init IO_APIC IRQs
[    0.120003]  2-0 (apicid-pin) not connected
[    0.124020] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.128014] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.132013] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
[    0.136001] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
[    0.136001] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
[    0.136001] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.136001] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.136001]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.136001] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.136001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.136001] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.136001] ..... (found apic 0 pin 0) ...
[    0.176356] ....... works.
[    0.178932] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.185213] Using local APIC timer interrupts.
[    0.185214] calibrating APIC timer ...
[    0.192001] ... lapic delta = 1256509
[    0.192001] ..... delta 1256509
[    0.192001] ..... mult: 53963277
[    0.192001] ..... calibration result: 804165
[    0.192001] ..... CPU clock speed is 2010.1657 MHz.
[    0.192001] ..... host bus clock speed is 201.0165 MHz.
[    0.192001] ... verify APIC timer
[    0.303453] ... jiffies delta = 25
[    0.304002] ... jiffies result ok
[    0.308018] calling  migration_init+0x0/0x4b @ 1
[    0.312111] initcall migration_init+0x0/0x4b returned 1 after 0 usecs
[    0.316004] initcall migration_init+0x0/0x4b returned with error code 1 
[    0.320004] calling  spawn_ksoftirqd+0x0/0x47 @ 1
[    0.324065] initcall spawn_ksoftirqd+0x0/0x47 returned 0 after 0 usecs
[    0.328006] calling  init_call_single_data+0x0/0x91 @ 1
[    0.332008] initcall init_call_single_data+0x0/0x91 returned 0 after 0 usecs
[    0.336005] calling  spawn_softlockup_task+0x0/0x5f @ 1
[    0.340066] initcall spawn_softlockup_task+0x0/0x5f returned 0 after 0 usecs
[    0.344004] calling  relay_init+0x0/0x11 @ 1
[    0.348006] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.352005] calling  tracer_alloc_buffers+0x0/0x209 @ 1
[    0.356086] Testing tracer nop: PASSED
[    0.360015] initcall tracer_alloc_buffers+0x0/0x209 returned 0 after 3906 usecs
[    0.364004] calling  init_trace_printk+0x0/0xf @ 1
[    0.368005] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.372272] lockdep: fixing up alternatives.
[    0.376067] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Mapping cpu 1 to node 0
[    0.004000] Calibrating delay using timer specific routine.. 4020.86 BogoMIPS (lpj=8041731)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Intel machine check architecture supported.
[    0.004000] Intel machine check reporting enabled on CPU#1.
[    0.468077] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.477250] Brought up 2 CPUs
[    0.480004] Total of 2 processors activated (8041.96 BogoMIPS).
[    0.484346] CPU0 attaching sched-domain:
[    0.488006]  domain 0: span 0-1 level CPU
[    0.492003]   groups: 0 1
[    0.494599]   domain 1: span 0-1 level NODE
[    0.497818]    groups: 0-1
[    0.500524] CPU1 attaching sched-domain:
[    0.504016]  domain 0: span 0-1 level CPU
[    0.508003]   groups: 1 0
[    0.512003]   domain 1: span 0-1 level NODE
[    0.516010]    groups: 0-1
[    0.518871] device: 'platform': device_add
[    0.520321] khelper used greatest stack depth: 7008 bytes left
[    0.528038] bus: 'platform': registered
[    0.532009] Registering sysdev class 'cpu'
[    0.536261] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.540009] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.544005] calling  net_ns_init+0x0/0xe8 @ 1
[    0.548011] net_namespace: 1196 bytes
[    0.552018] initcall net_ns_init+0x0/0xe8 returned 0 after 3906 usecs
[    0.556006] calling  cpufreq_tsc+0x0/0x25 @ 1
[    0.560005] initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
[    0.564004] calling  reboot_init+0x0/0x11 @ 1
[    0.568010] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.572006] calling  init_smp_flush+0x0/0x2f @ 1
[    0.576006] initcall init_smp_flush+0x0/0x2f returned 0 after 0 usecs
[    0.580011] calling  sysctl_init+0x0/0x29 @ 1
[    0.584187] initcall sysctl_init+0x0/0x29 returned 0 after 0 usecs
[    0.588004] calling  ksysfs_init+0x0/0x96 @ 1
[    0.592109] initcall ksysfs_init+0x0/0x96 returned 0 after 0 usecs
[    0.596005] calling  async_init+0x0/0x3c @ 1
[    0.600005] initcall async_init+0x0/0x3c returned 0 after 0 usecs
[    0.604005] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.612008] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.616005] calling  filelock_init+0x0/0x27 @ 1
[    0.620011] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.624004] calling  init_script_binfmt+0x0/0xf @ 1
[    0.628014] initcall init_script_binfmt+0x0/0xf returned 0 after 0 usecs
[    0.632004] calling  init_elf_binfmt+0x0/0xf @ 1
[    0.636005] initcall init_elf_binfmt+0x0/0xf returned 0 after 0 usecs
[    0.640005] calling  debugfs_init+0x0/0x41 @ 1
[    0.644018] initcall debugfs_init+0x0/0x41 returned 0 after 0 usecs
[    0.648005] calling  securityfs_init+0x0/0x41 @ 1
[    0.652010] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    0.656005] calling  random32_init+0x0/0x9d @ 1
[    0.660006] initcall random32_init+0x0/0x9d returned 0 after 0 usecs
[    0.664006] calling  regulator_init+0x0/0x23 @ 1
[    0.668004] regulator: core version 0.5
[    0.672004] device class 'regulator': registering
[    0.676108] initcall regulator_init+0x0/0x23 returned 0 after 7812 usecs
[    0.680005] calling  cpufreq_core_init+0x0/0x55 @ 1
[    0.684006] initcall cpufreq_core_init+0x0/0x55 returned 0 after 0 usecs
[    0.688004] calling  cpuidle_init+0x0/0x32 @ 1
[    0.692012] initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
[    0.696005] calling  sock_init+0x0/0x51 @ 1
[    0.700088] initcall sock_init+0x0/0x51 returned 0 after 0 usecs
[    0.704006] calling  netpoll_init+0x0/0x39 @ 1
[    0.708012] initcall netpoll_init+0x0/0x39 returned 0 after 0 usecs
[    0.712005] calling  netlink_proto_init+0x0/0x106 @ 1
[    0.716047] NET: Registered protocol family 16
[    0.720044] initcall netlink_proto_init+0x0/0x106 returned 0 after 3906 usecs
[    0.724004] calling  olpc_init+0x0/0x105 @ 1
[    0.728005] initcall olpc_init+0x0/0x105 returned 0 after 0 usecs
[    0.732006] calling  bdi_class_init+0x0/0x35 @ 1
[    0.736005] device class 'bdi': registering
[    0.740108] initcall bdi_class_init+0x0/0x35 returned 0 after 3906 usecs
[    0.744006] calling  kobject_uevent_init+0x0/0x3f @ 1
[    0.748013] initcall kobject_uevent_init+0x0/0x3f returned 0 after 0 usecs
[    0.752005] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.756004] device class 'pci_bus': registering
[    0.760107] initcall pcibus_class_init+0x0/0x14 returned 0 after 3906 usecs
[    0.764006] calling  pci_driver_init+0x0/0xf @ 1
[    0.768107] bus: 'pci': registered
[    0.772007] initcall pci_driver_init+0x0/0xf returned 0 after 3906 usecs
[    0.776005] calling  backlight_class_init+0x0/0x4d @ 1
[    0.780005] device class 'backlight': registering
[    0.784106] initcall backlight_class_init+0x0/0x4d returned 0 after 3906 usecs
[    0.788006] calling  video_output_class_init+0x0/0x14 @ 1
[    0.792004] device class 'video_output': registering
[    0.796106] initcall video_output_class_init+0x0/0x14 returned 0 after 3906 usecs
[    0.800006] calling  tty_class_init+0x0/0x2c @ 1
[    0.804005] device class 'tty': registering
[    0.808106] initcall tty_class_init+0x0/0x2c returned 0 after 3906 usecs
[    0.812006] calling  vtconsole_class_init+0x0/0xa1 @ 1
[    0.816005] device class 'vtconsole': registering
[    0.820107] device: 'vtcon0': device_add
[    0.824109] initcall vtconsole_class_init+0x0/0xa1 returned 0 after 7812 usecs
[    0.828005] calling  register_node_type+0x0/0x3a @ 1
[    0.832004] Registering sysdev class 'node'
[    0.836106] initcall register_node_type+0x0/0x3a returned 0 after 3906 usecs
[    0.840005] calling  eisa_init+0x0/0x26 @ 1
[    0.844106] bus: 'eisa': registered
[    0.848004] EISA bus registered
[    0.852005] initcall eisa_init+0x0/0x26 returned 0 after 7812 usecs
[    0.856005] calling  amd_postcore_init+0x0/0xa2 @ 1
[    0.860006] initcall amd_postcore_init+0x0/0xa2 returned 0 after 0 usecs
[    0.864005] calling  arch_kdebugfs_init+0x0/0x28 @ 1
[    0.868037] initcall arch_kdebugfs_init+0x0/0x28 returned 0 after 0 usecs
[    0.872005] calling  init_pit_clocksource+0x0/0x97 @ 1
[    0.876006] initcall init_pit_clocksource+0x0/0x97 returned 0 after 0 usecs
[    0.880006] calling  kdump_buf_page_init+0x0/0x59 @ 1
[    0.884023] initcall kdump_buf_page_init+0x0/0x59 returned 0 after 0 usecs
[    0.888005] calling  init_cyclone_clocksource+0x0/0x17d @ 1
[    0.892006] initcall init_cyclone_clocksource+0x0/0x17d returned -19 after 0 usecs
[    0.896005] calling  pci_arch_init+0x0/0x33 @ 1
[    0.908130] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[    0.912015] initcall pci_arch_init+0x0/0x33 returned 0 after 11718 usecs
[    0.916005] calling  topology_init+0x0/0xb0 @ 1
[    0.920005] Registering sys device of class 'node'
[    0.924009] Registering sys device 'node0'
[    0.928107] Registering sys device of class 'cpu'
[    0.932016] Registering sys device 'cpu0'
[    0.936064] Registering sys device of class 'cpu'
[    0.940009] Registering sys device 'cpu1'
[    0.948028] initcall topology_init+0x0/0xb0 returned 0 after 27343 usecs
[    0.952006] calling  mca_init+0x0/0x2a2 @ 1
[    0.956107] bus: 'MCA': registered
[    0.960007] initcall mca_init+0x0/0x2a2 returned -19 after 3906 usecs
[    0.964012] calling  param_sysfs_init+0x0/0xb2 @ 1
[    1.000173] initcall param_sysfs_init+0x0/0xb2 returned 0 after 31250 usecs
[    1.004153] calling  pm_sysrq_init+0x0/0x1b @ 1
[    1.008442] initcall pm_sysrq_init+0x0/0x1b returned 0 after 0 usecs
[    1.012007] calling  readahead_init+0x0/0x2f @ 1
[    1.016017] device: 'default': device_add
[    1.020143] initcall readahead_init+0x0/0x2f returned 0 after 3906 usecs
[    1.024007] calling  init_bio+0x0/0xa9 @ 1
[    1.028537] bio: create slab <bio-0> at 0
[    1.032294] initcall init_bio+0x0/0xa9 returned 0 after 3906 usecs
[    1.036007] calling  cryptomgr_init+0x0/0x29 @ 1
[    1.040036] initcall cryptomgr_init+0x0/0x29 returned 0 after 0 usecs
[    1.044006] calling  blk_settings_init+0x0/0x1d @ 1
[    1.048006] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    1.052005] calling  blk_ioc_init+0x0/0x24 @ 1
[    1.056011] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    1.060006] calling  blk_softirq_init+0x0/0x95 @ 1
[    1.064008] initcall blk_softirq_init+0x0/0x95 returned 0 after 0 usecs
[    1.068006] calling  genhd_device_init+0x0/0x50 @ 1
[    1.072005] device class 'block': registering
[    1.076098] initcall genhd_device_init+0x0/0x50 returned 0 after 3906 usecs
[    1.080007] calling  gpiolib_debugfs_init+0x0/0x1f @ 1
[    1.084496] initcall gpiolib_debugfs_init+0x0/0x1f returned 0 after 0 usecs
[    1.088123] calling  pci_slot_init+0x0/0x40 @ 1
[    1.092023] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    1.096006] calling  pnp_init+0x0/0xf @ 1
[    1.100114] bus: 'pnp': registered
[    1.104007] initcall pnp_init+0x0/0xf returned 0 after 3906 usecs
[    1.108180] calling  misc_init+0x0/0x84 @ 1
[    1.112032] device class 'misc': registering
[    1.116116] initcall misc_init+0x0/0x84 returned 0 after 3906 usecs
[    1.120006] calling  phy_init+0x0/0x29 @ 1
[    1.124091] device class 'mdio_bus': registering
[    1.128113] bus: 'mdio_bus': registered
[    1.132006] bus: 'mdio_bus': add driver Generic PHY
[    1.136109] initcall phy_init+0x0/0x29 returned 0 after 11718 usecs
[    1.140007] calling  init_scsi+0x0/0x89 @ 1
[    1.144380] device class 'scsi_host': registering
[    1.148115] bus: 'scsi': registered
[    1.152005] device class 'scsi_device': registering
[    1.156108] SCSI subsystem initialized
[    1.160007] initcall init_scsi+0x0/0x89 returned 0 after 15625 usecs
[    1.164006] calling  ata_init+0x0/0x81 @ 1
[    1.172059] libata version 3.00 loaded.
[    1.175724] initcall ata_init+0x0/0x81 returned 0 after 3906 usecs
[    1.176006] calling  usb_init+0x0/0xf6 @ 1
[    1.180110] bus: 'usb': registered
[    1.184007] device class 'usb_host': registering
[    1.188108] bus: 'usb': add driver usbfs
[    1.192109] usbcore: registered new interface driver usbfs
[    1.196020] bus: 'usb': add driver hub
[    1.200108] usbcore: registered new interface driver hub
[    1.204056] bus: 'usb': add driver usb
[    1.208108] usbcore: registered new device driver usb
[    1.212008] initcall usb_init+0x0/0xf6 returned 0 after 31250 usecs
[    1.216006] calling  serio_init+0x0/0x73 @ 1
[    1.220109] bus: 'serio': registered
[    1.223552] initcall serio_init+0x0/0x73 returned 0 after 0 usecs
[    1.224006] calling  gameport_init+0x0/0x73 @ 1
[    1.228109] bus: 'gameport': registered
[    1.232054] initcall gameport_init+0x0/0x73 returned 0 after 3906 usecs
[    1.236006] calling  input_init+0x0/0xe2 @ 1
[    1.240005] device class 'input': registering
[    1.244109] initcall input_init+0x0/0xe2 returned 0 after 3906 usecs
[    1.248007] calling  rtc_init+0x0/0x5e @ 1
[    1.252006] device class 'rtc': registering
[    1.260132] initcall rtc_init+0x0/0x5e returned 0 after 7812 usecs
[    1.264006] calling  power_supply_class_init+0x0/0x2f @ 1
[    1.268006] device class 'power_supply': registering
[    1.272110] initcall power_supply_class_init+0x0/0x2f returned 0 after 3906 usecs
[    1.276007] calling  pci_subsys_init+0x0/0x1b @ 1
[    1.280005] PCI: Probing PCI hardware
[    1.284021] PCI: Probing PCI hardware (bus 00)
[    1.288014] device: 'pci0000:00': device_add
[    1.292014] device: '0000:00': device_add
[    1.296110] PCI: Scanning bus 0000:00
[    1.300133] pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
[    1.308064] pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
[    1.312138] pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xa5
[    1.316005] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.320095] pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
[    1.324031] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    1.328072] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    1.332022] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    1.336083] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.340015] pci 0000:00:01.1: PME# disabled
[    1.344123] pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
[    1.348031] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    1.352165] pci 0000:00:02.0: supports D1 D2
[    1.356005] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.360015] pci 0000:00:02.0: PME# disabled
[    1.364121] pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
[    1.368031] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    1.372192] pci 0000:00:02.1: supports D1 D2
[    1.376005] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.380015] pci 0000:00:02.1: PME# disabled
[    1.384136] pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
[    1.388031] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    1.392022] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    1.396022] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    1.400132] pci 0000:00:04.0: supports D1 D2
[    1.404099] pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
[    1.408093] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    1.412165] pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
[    1.416150] pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
[    1.420031] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    1.424022] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    1.428149] pci 0000:00:0a.0: supports D1 D2
[    1.432005] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.436015] pci 0000:00:0a.0: PME# disabled
[    1.440124] pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
[    1.444165] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.448015] pci 0000:00:0b.0: PME# disabled
[    1.452148] pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
[    1.460094] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.464015] pci 0000:00:0c.0: PME# disabled
[    1.468148] pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
[    1.472156] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.476022] pci 0000:00:0d.0: PME# disabled
[    1.480148] pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
[    1.484157] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.488015] pci 0000:00:0e.0: PME# disabled
[    1.492187] pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
[    1.496232] pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
[    1.500182] pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
[    1.504182] pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
[    1.508198] PCI: Fixups for bus 0000:00
[    1.512011] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
[    1.516020] PCI: Scanning bus 0000:05
[    1.520113] pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
[    1.524033] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    1.528024] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    1.532157] pci 0000:05:07.0: supports D1 D2
[    1.536006] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.540016] pci 0000:05:07.0: PME# disabled
[    1.544133] PCI: Fixups for bus 0000:05
[    1.548006] pci 0000:00:09.0: transparent bridge
[    1.552014] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    1.556015] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    1.560014] PCI: Bus scan for 0000:05 returning with max=05
[    1.564016] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
[    1.568019] PCI: Scanning bus 0000:04
[    1.572152] PCI: Fixups for bus 0000:04
[    1.576048] PCI: Bus scan for 0000:04 returning with max=04
[    1.580016] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
[    1.584019] PCI: Scanning bus 0000:03
[    1.588152] PCI: Fixups for bus 0000:03
[    1.592047] PCI: Bus scan for 0000:03 returning with max=03
[    1.596016] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
[    1.600019] PCI: Scanning bus 0000:02
[    1.604152] PCI: Fixups for bus 0000:02
[    1.608047] PCI: Bus scan for 0000:02 returning with max=02
[    1.612016] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
[    1.612008] Clocksource tsc unstable (delta = 161446081 ns)
[    1.616020] PCI: Scanning bus 0000:01
[    1.620076] pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
[    1.624008] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x21
[    1.628033] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    1.632024] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    1.636024] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    1.640076] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.644091] pci 0000:01:00.0: supports D1 D2
[    1.648111] pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
[    1.652007] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x21
[    1.656028] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    1.660184] pci 0000:01:00.1: supports D1 D2
[    1.664199] PCI: Fixups for bus 0000:01
[    1.668023] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    1.672015] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    1.676023] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    1.680006] PCI: Bus scan for 0000:01 returning with max=01
[    1.684016] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
[    1.688026] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
[    1.692026] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
[    1.696026] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
[    1.700033] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
[    1.704021] PCI: Bus scan for 0000:00 returning with max=05
[    1.708006] device: '0000:00:00.0': device_add
[    1.712013] bus: 'pci': add device 0000:00:00.0
[    1.716117] device: '0000:00:01.0': device_add
[    1.720013] bus: 'pci': add device 0000:00:01.0
[    1.724109] device: '0000:00:01.1': device_add
[    1.728013] bus: 'pci': add device 0000:00:01.1
[    1.732108] device: '0000:00:02.0': device_add
[    1.736012] bus: 'pci': add device 0000:00:02.0
[    1.740109] device: '0000:00:02.1': device_add
[    1.744013] bus: 'pci': add device 0000:00:02.1
[    1.748108] device: '0000:00:04.0': device_add
[    1.752013] bus: 'pci': add device 0000:00:04.0
[    1.756110] device: '0000:00:06.0': device_add
[    1.760013] bus: 'pci': add device 0000:00:06.0
[    1.768021] device: '0000:00:09.0': device_add
[    1.772012] bus: 'pci': add device 0000:00:09.0
[    1.776109] device: '0000:00:0a.0': device_add
[    1.780013] bus: 'pci': add device 0000:00:0a.0
[    1.784108] device: '0000:00:0b.0': device_add
[    1.788013] bus: 'pci': add device 0000:00:0b.0
[    1.792109] device: '0000:00:0c.0': device_add
[    1.796013] bus: 'pci': add device 0000:00:0c.0
[    1.804111] device: '0000:00:0d.0': device_add
[    1.808013] bus: 'pci': add device 0000:00:0d.0
[    1.812109] device: '0000:00:0e.0': device_add
[    1.816013] bus: 'pci': add device 0000:00:0e.0
[    1.820108] device: '0000:00:18.0': device_add
[    1.824013] bus: 'pci': add device 0000:00:18.0
[    1.828107] device: '0000:00:18.1': device_add
[    1.832013] bus: 'pci': add device 0000:00:18.1
[    1.836108] device: '0000:00:18.2': device_add
[    1.840013] bus: 'pci': add device 0000:00:18.2
[    1.844109] device: '0000:00:18.3': device_add
[    1.848013] bus: 'pci': add device 0000:00:18.3
[    1.852108] device: '0000:05:07.0': device_add
[    1.856013] bus: 'pci': add device 0000:05:07.0
[    1.860109] device: '0000:05': device_add
[    1.864111] device: '0000:04': device_add
[    1.868108] device: '0000:03': device_add
[    1.872112] device: '0000:02': device_add
[    1.876110] device: '0000:01:00.0': device_add
[    1.880013] bus: 'pci': add device 0000:01:00.0
[    1.884109] device: '0000:01:00.1': device_add
[    1.888013] bus: 'pci': add device 0000:01:00.1
[    1.892109] device: '0000:01': device_add
[    1.896309] pci 0000:00:00.0: default IRQ router [10de:005e]
[    1.900141] pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 3
[    1.904029] pci 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.908074] pci 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
[    1.912014] pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 5
[    1.916347] initcall pci_subsys_init+0x0/0x1b returned 0 after 621094 usecs
[    1.920007] calling  proto_init+0x0/0xf @ 1
[    1.924014] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    1.928007] calling  net_dev_init+0x0/0x185 @ 1
[    1.932026] device class 'net': registering
[    1.936108] device: 'lo': device_add
[    1.940140] initcall net_dev_init+0x0/0x185 returned 0 after 7812 usecs
[    1.944008] calling  neigh_init+0x0/0x66 @ 1
[    1.948008] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    1.952007] calling  fib_rules_init+0x0/0x99 @ 1
[    1.956015] initcall fib_rules_init+0x0/0x99 returned 0 after 0 usecs
[    1.960007] calling  pktsched_init+0x0/0xa9 @ 1
[    1.964030] initcall pktsched_init+0x0/0xa9 returned 0 after 0 usecs
[    1.968007] calling  tc_filter_init+0x0/0x43 @ 1
[    1.972008] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    1.976007] calling  tc_action_init+0x0/0x43 @ 1
[    1.980008] initcall tc_action_init+0x0/0x43 returned 0 after 0 usecs
[    1.984007] calling  genl_init+0x0/0xb0 @ 1
[    2.004048] initcall genl_init+0x0/0xb0 returned 0 after 15625 usecs
[    2.008008] calling  cipso_v4_init+0x0/0x6d @ 1
[    2.012023] initcall cipso_v4_init+0x0/0x6d returned 0 after 0 usecs
[    2.016007] calling  atm_init+0x0/0xa0 @ 1
[    2.020008] NET: Registered protocol family 8
[    2.024006] NET: Registered protocol family 20
[    2.028028] device class 'atm': registering
[    2.032109] initcall atm_init+0x0/0xa0 returned 0 after 11718 usecs
[    2.036008] calling  wireless_nlevent_init+0x0/0x39 @ 1
[    2.040008] initcall wireless_nlevent_init+0x0/0x39 returned 0 after 0 usecs
[    2.044009] calling  cfg80211_init+0x0/0x69 @ 1
[    2.048006] device class 'ieee80211': registering
[    2.068059] Registering platform device 'regulatory.0'. Parent at platform
[    2.072007] device: 'regulatory.0': device_add
[    2.076012] bus: 'platform': add device regulatory.0
[    2.080109] cfg80211: Using static regulatory domain info
[    2.084007] cfg80211: Regulatory domain: US
[    2.088006] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    2.092007] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    2.096007] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.100007] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.104007] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.108007] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.112007] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    2.116008] cfg80211: Calling CRDA for country: US
[    2.120109] initcall cfg80211_init+0x0/0x69 returned 0 after 70312 usecs
[    2.124008] calling  netlbl_init+0x0/0x6d @ 1
[    2.128006] NetLabel: Initializing
[    2.132006] NetLabel:  domain hash size = 128
[    2.136006] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.140165] NetLabel:  unlabeled traffic allowed by default
[    2.144008] initcall netlbl_init+0x0/0x6d returned 0 after 15625 usecs
[    2.148007] calling  sysctl_init+0x0/0x3b @ 1
[    2.152009] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    2.156009] calling  pci_iommu_init+0x0/0x20 @ 1
[    2.195584] DMA-API: preallocated 32768 debug entries
[    2.196008] DMA-API: debugging enabled by kernel config
[    2.200014] initcall pci_iommu_init+0x0/0x20 returned 0 after 39062 usecs
[    2.204010] calling  print_all_ICs+0x0/0x5a @ 1
[    2.208007] 
[    2.208008] printing PIC contents
[    2.212018] ... PIC  IMR: fffa
[    2.215037] ... PIC  IRR: 0001
[    2.216006] ... PIC  ISR: 0001
[    2.220007] ... PIC ELCR: 0828
[    2.224008] 
[    2.224009] printing local APIC contents on CPU#0/0:
[    2.228005] ... APIC ID:      00000000 (0)
[    2.228005] ... APIC VERSION: 00040010
[    2.228005] ... APIC TASKPRI: 00000000 (00)
[    2.228005] ... APIC ARBPRI: 000000e0 (e0)
[    2.228005] ... APIC PROCPRI: 00000000
[    2.228005] ... APIC LDR: 01000000
[    2.228005] ... APIC DFR: ffffffff
[    2.228005] ... APIC SPIV: 000001ff
[    2.228005] ... APIC ISR field:
[    2.228005] 0123456789abcdef0123456789abcdef
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] ... APIC TMR field:
[    2.228005] 0123456789abcdef0123456789abcdef
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] ... APIC IRR field:
[    2.228005] 0123456789abcdef0123456789abcdef
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000000000000000000000
[    2.228005] 00000000000000010000000000000000
[    2.228005] ... APIC ESR: 00000000
[    2.228005] ... APIC ICR: 000008fd
[    2.228005] ... APIC ICR2: 02000000
[    2.228005] ... APIC LVTT: 000200ef
[    2.228005] ... APIC LVTPC: 00010000
[    2.228005] ... APIC LVT0: 00010700
[    2.228005] ... APIC LVT1: 00000400
[    2.228005] ... APIC LVTERR: 000000fe
[    2.228005] ... APIC TMICT: 0000c454
[    2.228005] ... APIC TMCCT: 000072a5
[    2.228005] ... APIC TDCR: 00000003
[    2.228005] 
[    2.228008] 
[    2.228009] printing local APIC contents on CPU#1/1:
[    2.232005] ... APIC ID:      01000000 (1)
[    2.232005] ... APIC VERSION: 00040010
[    2.232005] ... APIC TASKPRI: 00000000 (00)
[    2.232005] ... APIC ARBPRI: 000000e0 (e0)
[    2.232005] ... APIC PROCPRI: 00000000
[    2.232005] ... APIC LDR: 02000000
[    2.232005] ... APIC DFR: ffffffff
[    2.232005] ... APIC SPIV: 000001ff
[    2.232005] ... APIC ISR field:
[    2.232005] 0123456789abcdef0123456789abcdef
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] ... APIC TMR field:
[    2.232005] 0123456789abcdef0123456789abcdef
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] ... APIC IRR field:
[    2.232005] 0123456789abcdef0123456789abcdef
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000000000000000000000
[    2.232005] 00000000000000010000000000000000
[    2.232005] ... APIC ESR: 00000000
[    2.232005] ... APIC ICR: 000008fd
[    2.232005] ... APIC ICR2: 01000000
[    2.232005] ... APIC LVTT: 000200ef
[    2.232005] ... APIC LVTPC: 00010000
[    2.232005] ... APIC LVT0: 00010700
[    2.232005] ... APIC LVT1: 00010400
[    2.232005] ... APIC LVTERR: 000000fe
[    2.232005] ... APIC TMICT: 0000c454
[    2.232005] ... APIC TMCCT: 000023f8
[    2.232005] ... APIC TDCR: 00000003
[    2.232005] 
[    2.430966] number of MP IRQ sources: 17.
[    2.432007] number of IO-APIC #2 registers: 24.
[    2.436007] testing the IO APIC.......................
[    2.440010] 
[    2.441475] IO APIC #2......
[    2.444007] .... register #00: 00000000
[    2.448007] .......    : physical APIC id: 00
[    2.452007] .......    : Delivery Type: 0
[    2.456007] .......    : LTS          : 0
[    2.460007] .... register #01: 00170011
[    2.464007] .......     : max redirection entries: 0017
[    2.468012] .......     : PRQ implemented: 0
[    2.472007] .......     : IO APIC version: 0011
[    2.476007] .... register #02: 00000000
[    2.480007] .......     : arbitration: 00
[    2.484007] .... IRQ redirection table:
[    2.488007]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    2.492009]  00 003 0    0    0   0   0    1    1    30
[    2.496009]  01 003 0    0    0   0   0    1    1    31
[    2.500014]  02 000 1    0    0   0   0    0    0    00
[    2.507211]  03 003 1    1    0   1   0    1    1    33
[    2.512009]  04 003 0    0    0   0   0    1    1    34
[    2.516009]  05 003 1    1    0   1   0    1    1    35
[    2.523210]  06 003 0    0    0   0   0    1    1    36
[    2.528009]  07 003 1    0    0   0   0    1    1    37
[    2.532009]  08 003 0    0    0   0   0    1    1    38
[    2.536009]  09 003 0    0    0   0   0    1    1    39
[    2.544009]  0a 003 0    0    0   0   0    1    1    3A
[    2.548009]  0b 003 1    1    0   1   0    1    1    3B
[    2.552009]  0c 003 0    0    0   0   0    1    1    3C
[    2.559210]  0d 003 0    0    0   0   0    1    1    3D
[    2.564009]  0e 003 0    0    0   0   0    1    1    3E
[    2.568009]  0f 003 0    0    0   0   0    1    1    3F
[    2.575210]  10 000 1    0    0   0   0    0    0    00
[    2.580009]  11 000 1    0    0   0   0    0    0    00
[    2.584009]  12 000 1    0    0   0   0    0    0    00
[    2.588009]  13 000 1    0    0   0   0    0    0    00
[    2.596009]  14 000 1    0    0   0   0    0    0    00
[    2.600009]  15 000 1    0    0   0   0    0    0    00
[    2.604009]  16 000 1    0    0   0   0    0    0    00
[    2.611210]  17 000 1    0    0   0   0    0    0    00
[    2.616007] IRQ to pin mappings:
[    2.620008] IRQ0 -> 0:0
[    2.622429] IRQ1 -> 0:1
[    2.624698] IRQ3 -> 0:3
[    2.627122] IRQ4 -> 0:4
[    2.628697] IRQ5 -> 0:5
[    2.632178] IRQ6 -> 0:6
[    2.634603] IRQ7 -> 0:7
[    2.636697] IRQ8 -> 0:8
[    2.639122] IRQ9 -> 0:9
[    2.640697] IRQ10 -> 0:10
[    2.644177] IRQ11 -> 0:11
[    2.646775] IRQ12 -> 0:12
[    2.648784] IRQ13 -> 0:13
[    2.652178] IRQ14 -> 0:14
[    2.654776] IRQ15 -> 0:15
[    2.656787] .................................... done.
[    2.660010] initcall print_all_ICs+0x0/0x5a returned 0 after 441407 usecs
[    2.664008] calling  hpet_late_init+0x0/0xda @ 1
[    2.668009] initcall hpet_late_init+0x0/0xda returned -19 after 0 usecs
[    2.672010] calling  clocksource_done_booting+0x0/0x11 @ 1
[    2.676009] initcall clocksource_done_booting+0x0/0x11 returned 0 after 0 usecs
[    2.680009] calling  ftrace_init_debugfs+0x0/0x44 @ 1
[    2.684054] initcall ftrace_init_debugfs+0x0/0x44 returned 0 after 0 usecs
[    2.688009] calling  rb_init_debugfs+0x0/0x38 @ 1
[    2.692032] initcall rb_init_debugfs+0x0/0x38 returned 0 after 0 usecs
[    2.696009] calling  tracer_init_debugfs+0x0/0x2ad @ 1
[    2.700322] initcall tracer_init_debugfs+0x0/0x2ad returned 0 after 0 usecs
[    2.704009] calling  init_trace_printk_function_export+0x0/0x39 @ 1
[    2.708016] initcall init_trace_printk_function_export+0x0/0x39 returned 0 after 0 usecs
[    2.712009] calling  event_trace_init+0x0/0xd7 @ 1
[    2.720386] initcall event_trace_init+0x0/0xd7 returned 0 after 3906 usecs
[    2.724015] calling  init_pipe_fs+0x0/0x3d @ 1
[    2.728055] initcall init_pipe_fs+0x0/0x3d returned 0 after 0 usecs
[    2.732009] calling  init_mnt_writers+0x0/0x65 @ 1
[    2.736010] initcall init_mnt_writers+0x0/0x65 returned 0 after 0 usecs
[    2.740009] calling  anon_inode_init+0x0/0xe3 @ 1
[    2.744040] initcall anon_inode_init+0x0/0xe3 returned 0 after 0 usecs
[    2.748011] calling  pnpbios_init+0x0/0x90 @ 1
[    2.752010] PnPBIOS: Scanning system for PnP BIOS support...
[    2.756235] PnPBIOS: Found PnP BIOS installation structure at 0xc00fc550
[    2.760011] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc580, dseg 0xf0000
[    2.764034] device: 'pnp0': device_add
[    2.768047] device: '00:00': device_add
[    2.771821] bus: 'pnp': add device 00:00
[    2.772116] device: '00:01': device_add
[    2.776015] bus: 'pnp': add device 00:01
[    2.780111] device: '00:02': device_add
[    2.784014] bus: 'pnp': add device 00:02
[    2.788112] device: '00:03': device_add
[    2.792014] bus: 'pnp': add device 00:03
[    2.796109] device: '00:04': device_add
[    2.800017] bus: 'pnp': add device 00:04
[    2.804112] device: '00:05': device_add
[    2.808017] bus: 'pnp': add device 00:05
[    2.812112] device: '00:06': device_add
[    2.816014] bus: 'pnp': add device 00:06
[    2.820137] device: '00:07': device_add
[    2.824015] bus: 'pnp': add device 00:07
[    2.828121] device: '00:08': device_add
[    2.832015] bus: 'pnp': add device 00:08
[    2.836112] device: '00:09': device_add
[    2.840015] bus: 'pnp': add device 00:09
[    2.844127] device: '00:0b': device_add
[    2.848015] bus: 'pnp': add device 00:0b
[    2.852112] device: '00:0c': device_add
[    2.856015] bus: 'pnp': add device 00:0c
[    2.860159] device: '00:0e': device_add
[    2.864015] bus: 'pnp': add device 00:0e
[    2.868121] device: '00:0f': device_add
[    2.872015] bus: 'pnp': add device 00:0f
[    2.876119] device: '00:10': device_add
[    2.880015] bus: 'pnp': add device 00:10
[    2.884112] PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
[    2.888011] initcall pnpbios_init+0x0/0x90 returned 0 after 132812 usecs
[    2.892010] calling  pnp_system_init+0x0/0xf @ 1
[    2.896009] bus: 'pnp': add driver system
[    2.900019] bus: 'pnp': driver_probe_device: matched device 00:07 with driver system
[    2.904009] bus: 'pnp': really_probe: probing driver system with device 00:07
[    2.908034] system 00:07: iomem range 0x0-0x9ffff could not be reserved
[    2.912012] system 00:07: iomem range 0xfffffffffffe0000-0xffffffffffffffff has been reserved
[    2.916011] system 00:07: iomem range 0xfffffffffec00000-0xfffffffffec0ffff has been reserved
[    2.920012] system 00:07: iomem range 0xfffffffffee00000-0xfffffffffeefffff has been reserved
[    2.924011] system 00:07: iomem range 0xfffffffffefffc00-0xfffffffffeffffff has been reserved
[    2.928015] system 00:07: iomem range 0x100000-0xffffff could not be reserved
[    2.932008] driver: '00:07': driver_bound: bound to device 'system'
[    2.936009] bus: 'pnp': really_probe: bound device 00:07 to driver system
[    2.940027] bus: 'pnp': driver_probe_device: matched device 00:08 with driver system
[    2.944008] bus: 'pnp': really_probe: probing driver system with device 00:08
[    2.948021] system 00:08: iomem range 0xf0000-0xf3fff could not be reserved
[    2.952014] system 00:08: iomem range 0xf4000-0xf7fff could not be reserved
[    2.956014] system 00:08: iomem range 0xf8000-0xfbfff could not be reserved
[    2.960014] system 00:08: iomem range 0xfc000-0xfffff could not be reserved
[    2.964008] driver: '00:08': driver_bound: bound to device 'system'
[    2.968009] bus: 'pnp': really_probe: bound device 00:08 to driver system
[    2.972111] initcall pnp_system_init+0x0/0xf returned 0 after 74218 usecs
[    2.976010] calling  chr_dev_init+0x0/0x89 @ 1
[    2.980030] device class 'mem': registering
[    2.984113] device: 'mem': device_add
[    2.988113] device: 'kmem': device_add
[    2.992110] device: 'null': device_add
[    2.996114] device: 'port': device_add
[    3.000112] device: 'zero': device_add
[    3.004115] device: 'full': device_add
[    3.008111] device: 'random': device_add
[    3.012114] device: 'urandom': device_add
[    3.016115] device: 'kmsg': device_add
[    3.020113] device: 'oldmem': device_add
[    3.024111] initcall chr_dev_init+0x0/0x89 returned 0 after 42968 usecs
[    3.028010] calling  firmware_class_init+0x0/0x61 @ 1
[    3.032008] device class 'firmware': registering
[    3.036114] initcall firmware_class_init+0x0/0x61 returned 0 after 3906 usecs
[    3.040011] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    3.044025] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 0 usecs
[    3.048010] calling  pcibios_assign_resources+0x0/0x91 @ 1
[    3.052129] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    3.056013] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    3.060021] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    3.064016] pci 0000:00:09.0:   PREFETCH window: disabled
[    3.068026] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    3.072008] pci 0000:00:0b.0:   IO window: disabled
[    3.076020] pci 0000:00:0b.0:   MEM window: disabled
[    3.080016] pci 0000:00:0b.0:   PREFETCH window: disabled
[    3.084026] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    3.088008] pci 0000:00:0c.0:   IO window: disabled
[    3.092020] pci 0000:00:0c.0:   MEM window: disabled
[    3.096016] pci 0000:00:0c.0:   PREFETCH window: disabled
[    3.100026] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    3.104008] pci 0000:00:0d.0:   IO window: disabled
[    3.108020] pci 0000:00:0d.0:   MEM window: disabled
[    3.112016] pci 0000:00:0d.0:   PREFETCH window: disabled
[    3.116031] pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
[    3.120012] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    3.124013] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    3.128021] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    3.132017] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    3.136046] pci 0000:00:09.0: setting latency timer to 64
[    3.140041] pci 0000:00:0b.0: setting latency timer to 64
[    3.144041] pci 0000:00:0c.0: setting latency timer to 64
[    3.148041] pci 0000:00:0d.0: setting latency timer to 64
[    3.152041] pci 0000:00:0e.0: setting latency timer to 64
[    3.156015] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    3.160009] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    3.164009] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
[    3.168009] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
[    3.172009] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    3.176009] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    3.180009] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    3.184009] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    3.188009] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    3.192009] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    3.196009] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    3.200009] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    3.204009] pci_bus 0000:03: resource 1 mem: [0x0-0x0]
[    3.208009] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    3.212009] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    3.216009] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    3.220009] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    3.224009] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    3.228009] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    3.232009] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    3.236017] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
[    3.240009] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xd7ffffff]
[    3.244009] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    3.248010] initcall pcibios_assign_resources+0x0/0x91 returned 0 after 191406 usecs
[    3.252010] calling  sysctl_core_init+0x0/0x2d @ 1
[    3.256062] initcall sysctl_core_init+0x0/0x2d returned 0 after 0 usecs
[    3.260011] calling  inet_init+0x0/0x199 @ 1
[    3.264033] NET: Registered protocol family 2
[    3.316155] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    3.320793] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    3.328060] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    3.337980] TCP: Hash tables configured (established 131072 bind 65536)
[    3.340041] TCP reno registered
[    3.352206] initcall inet_init+0x0/0x199 returned 0 after 85937 usecs
[    3.356011] calling  af_unix_init+0x0/0x47 @ 1
[    3.360017] NET: Registered protocol family 1
[    3.364033] initcall af_unix_init+0x0/0x47 returned 0 after 3906 usecs
[    3.368010] calling  default_rootfs+0x0/0x65 @ 1
[    3.372154] initcall default_rootfs+0x0/0x65 returned 0 after 0 usecs
[    3.376010] calling  i8259A_init_sysfs+0x0/0x1d @ 1
[    3.380009] Registering sysdev class 'i8259'
[    3.384116] Registering sys device of class 'i8259'
[    3.388014] Registering sys device 'i82590'
[    3.392114] initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 11718 usecs
[    3.396010] calling  sbf_init+0x0/0xdd @ 1
[    3.400010] initcall sbf_init+0x0/0xdd returned 0 after 0 usecs
[    3.404010] calling  i8237A_init_sysfs+0x0/0x1d @ 1
[    3.408009] Registering sysdev class 'i8237'
[    3.412114] Registering sys device of class 'i8237'
[    3.416014] Registering sys device 'i82370'
[    3.420115] initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 11718 usecs
[    3.424010] calling  add_rtc_cmos+0x0/0x92 @ 1
[    3.428013] initcall add_rtc_cmos+0x0/0x92 returned 0 after 0 usecs
[    3.432011] calling  cache_sysfs_init+0x0/0x54 @ 1
[    3.436148] initcall cache_sysfs_init+0x0/0x54 returned 0 after 0 usecs
[    3.440011] calling  thermal_throttle_init_device+0x0/0xc0 @ 1
[    3.444011] initcall thermal_throttle_init_device+0x0/0xc0 returned 0 after 0 usecs
[    3.448010] calling  powernow_k6_init+0x0/0x8b @ 1
[    3.452011] initcall powernow_k6_init+0x0/0x8b returned -19 after 0 usecs
[    3.456010] calling  cpufreq_gx_init+0x0/0x16e @ 1
[    3.460011] initcall cpufreq_gx_init+0x0/0x16e returned -19 after 0 usecs
[    3.464011] calling  ioapic_init_sysfs+0x0/0x84 @ 1
[    3.468009] Registering sysdev class 'ioapic'
[    3.472116] Registering sys device of class 'ioapic'
[    3.476014] Registering sys device 'ioapic0'
[    3.480116] initcall ioapic_init_sysfs+0x0/0x84 returned 0 after 11718 usecs
[    3.484010] calling  add_pcspkr+0x0/0x28 @ 1
[    3.488014] Registering platform device 'pcspkr'. Parent at platform
[    3.492017] device: 'pcspkr': device_add
[    3.496017] bus: 'platform': add device pcspkr
[    3.500116] initcall add_pcspkr+0x0/0x28 returned 0 after 11718 usecs
[    3.504010] calling  scx200_init+0x0/0x20 @ 1
[    3.508009] scx200: NatSemi SCx200 Driver
[    3.512010] bus: 'pci': add driver scx200
[    3.516112] initcall scx200_init+0x0/0x20 returned 0 after 7812 usecs
[    3.520010] calling  microcode_init+0x0/0xf4 @ 1
[    3.524032] device: 'microcode': device_add
[    3.528111] Registering platform device 'microcode'. Parent at platform
[    3.532010] device: 'microcode': device_add
[    3.536015] bus: 'platform': add device microcode
[    3.540113] microcode: CPU0: AMD CPU family 0xf not supported
[    3.544043] microcode: CPU1: AMD CPU family 0xf not supported
[    3.548047] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.552011] initcall microcode_init+0x0/0xf4 returned 0 after 27343 usecs
[    3.556010] calling  pt_dump_init+0x0/0x69 @ 1
[    3.560021] initcall pt_dump_init+0x0/0x69 returned 0 after 0 usecs
[    3.564010] calling  aes_init+0x0/0xf @ 1
[    3.568109] initcall aes_init+0x0/0xf returned 0 after 0 usecs
[    3.572010] calling  init+0x0/0xf @ 1
[    3.576064] initcall init+0x0/0xf returned 0 after 0 usecs
[    3.580011] calling  init_sched_debug_procfs+0x0/0x27 @ 1
[    3.584018] initcall init_sched_debug_procfs+0x0/0x27 returned 0 after 0 usecs
[    3.588010] calling  proc_schedstat_init+0x0/0x1c @ 1
[    3.592015] initcall proc_schedstat_init+0x0/0x1c returned 0 after 0 usecs
[    3.596010] calling  proc_execdomains_init+0x0/0x1c @ 1
[    3.600015] initcall proc_execdomains_init+0x0/0x1c returned 0 after 0 usecs
[    3.604010] calling  ioresources_init+0x0/0x31 @ 1
[    3.608019] initcall ioresources_init+0x0/0x31 returned 0 after 0 usecs
[    3.612010] calling  uid_cache_init+0x0/0x76 @ 1
[    3.616032] initcall uid_cache_init+0x0/0x76 returned 0 after 0 usecs
[    3.620010] calling  init_posix_timers+0x0/0xa9 @ 1
[    3.624024] initcall init_posix_timers+0x0/0xa9 returned 0 after 0 usecs
[    3.628010] calling  init_posix_cpu_timers+0x0/0x8d @ 1
[    3.632010] initcall init_posix_cpu_timers+0x0/0x8d returned 0 after 0 usecs
[    3.636010] calling  nsproxy_cache_init+0x0/0x27 @ 1
[    3.640016] initcall nsproxy_cache_init+0x0/0x27 returned 0 after 0 usecs
[    3.644012] calling  create_proc_profile+0x0/0x65 @ 1
[    3.648011] initcall create_proc_profile+0x0/0x65 returned 0 after 0 usecs
[    3.652010] calling  timekeeping_init_device+0x0/0x1d @ 1
[    3.656009] Registering sysdev class 'timekeeping'
[    3.660120] Registering sys device of class 'timekeeping'
[    3.664014] Registering sys device 'timekeeping0'
[    3.668116] initcall timekeeping_init_device+0x0/0x1d returned 0 after 11718 usecs
[    3.672011] calling  init_clocksource_sysfs+0x0/0x43 @ 1
[    3.676009] Registering sysdev class 'clocksource'
[    3.684122] Registering sys device of class 'clocksource'
[    3.688014] Registering sys device 'clocksource0'
[    3.692114] initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 15625 usecs
[    3.696011] calling  init_timer_list_procfs+0x0/0x27 @ 1
[    3.700016] initcall init_timer_list_procfs+0x0/0x27 returned 0 after 0 usecs
[    3.704011] calling  init_tstats_procfs+0x0/0x27 @ 1
[    3.708015] initcall init_tstats_procfs+0x0/0x27 returned 0 after 0 usecs
[    3.712010] calling  lockdep_proc_init+0x0/0x37 @ 1
[    3.716020] initcall lockdep_proc_init+0x0/0x37 returned 0 after 0 usecs
[    3.720010] calling  futex_init+0x0/0x8a @ 1
[    3.724014] initcall futex_init+0x0/0x8a returned 0 after 0 usecs
[    3.728012] calling  init_rttest+0x0/0x107 @ 1
[    3.732010] Registering sysdev class 'rttest'
[    3.736123] Registering sys device of class 'rttest'
[    3.740015] Registering sys device 'rttest0'
[    3.744130] Registering sys device of class 'rttest'
[    3.748021] Registering sys device 'rttest1'
[    3.752123] Registering sys device of class 'rttest'
[    3.756014] Registering sys device 'rttest2'
[    3.760121] Registering sys device of class 'rttest'
[    3.764014] Registering sys device 'rttest3'
[    3.768122] Registering sys device of class 'rttest'
[    3.772015] Registering sys device 'rttest4'
[    3.776121] Registering sys device of class 'rttest'
[    3.780015] Registering sys device 'rttest5'
[    3.784123] Registering sys device of class 'rttest'
[    3.788015] Registering sys device 'rttest6'
[    3.792120] Registering sys device of class 'rttest'
[    3.796015] Registering sys device 'rttest7'
[    3.800116] Initializing RT-Tester: OK
[    3.804013] initcall init_rttest+0x0/0x107 returned 0 after 70312 usecs
[    3.808011] calling  proc_dma_init+0x0/0x1c @ 1
[    3.812017] initcall proc_dma_init+0x0/0x1c returned 0 after 0 usecs
[    3.816011] calling  proc_modules_init+0x0/0x1c @ 1
[    3.820016] initcall proc_modules_init+0x0/0x1c returned 0 after 0 usecs
[    3.824011] calling  kallsyms_init+0x0/0x1f @ 1
[    3.828016] initcall kallsyms_init+0x0/0x1f returned 0 after 0 usecs
[    3.832011] calling  audit_init+0x0/0x141 @ 1
[    3.836010] audit: initializing netlink socket (disabled)
[    3.840075] type=2000 audit(1237374493.840:1): initialized
[    3.844020] initcall audit_init+0x0/0x141 returned 0 after 7812 usecs
[    3.848011] calling  audit_tree_init+0x0/0x3b @ 1
[    3.852013] initcall audit_tree_init+0x0/0x3b returned 0 after 0 usecs
[    3.856011] calling  init_kprobes+0x0/0x11e @ 1
[    3.873536] initcall init_kprobes+0x0/0x11e returned 0 after 11718 usecs
[    3.876011] calling  hung_task_init+0x0/0x42 @ 1
[    3.880092] initcall hung_task_init+0x0/0x42 returned 0 after 0 usecs
[    3.884012] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    3.888052] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 0 usecs
[    3.892012] calling  init_markers+0x0/0x14 @ 1
[    3.896011] initcall init_markers+0x0/0x14 returned 0 after 0 usecs
[    3.900011] calling  init_tracepoints+0x0/0x14 @ 1
[    3.904011] initcall init_tracepoints+0x0/0x14 returned 0 after 0 usecs
[    3.908011] calling  init_lstats_procfs+0x0/0x1f @ 1
[    3.912023] initcall init_lstats_procfs+0x0/0x1f returned 0 after 0 usecs
[    3.916011] calling  ftrace_mod_cmd_init+0x0/0xf @ 1
[    3.920036] initcall ftrace_mod_cmd_init+0x0/0xf returned 0 after 0 usecs
[    3.924011] calling  init_events+0x0/0x5f @ 1
[    3.928015] initcall init_events+0x0/0x5f returned 0 after 0 usecs
[    3.932011] calling  init_sched_switch_trace+0x0/0xf @ 1
[    3.936013] Testing tracer sched_switch: PASSED
[    4.044654] initcall init_sched_switch_trace+0x0/0xf returned 0 after 105468 usecs
[    4.048014] calling  init_function_trace+0x0/0x35 @ 1
[    4.052012] Testing tracer function: PASSED
[    4.172827] Testing dynamic ftrace: PASSED
[    4.408754] initcall init_function_trace+0x0/0x35 returned 0 after 347656 usecs
[    4.412016] calling  init_irqsoff_tracer+0x0/0x11 @ 1
[    4.416012] Testing tracer irqsoff: PASSED
[    4.424622] initcall init_irqsoff_tracer+0x0/0x11 returned 0 after 7812 usecs
[    4.428024] calling  stack_trace_init+0x0/0x7a @ 1
[    4.432040] initcall stack_trace_init+0x0/0x7a returned 0 after 0 usecs
[    4.436013] calling  init_kmem_tracer+0x0/0xf @ 1
[    4.440014] initcall init_kmem_tracer+0x0/0xf returned 0 after 0 usecs
[    4.444012] calling  init_blk_tracer+0x0/0x4b @ 1
[    4.448015] initcall init_blk_tracer+0x0/0x4b returned 0 after 0 usecs
[    4.452012] calling  register_ftrace_syscalls+0x0/0x9d @ 1
[    4.456015] initcall register_ftrace_syscalls+0x0/0x9d returned 0 after 0 usecs
[    4.460013] calling  init_per_zone_pages_min+0x0/0x7b @ 1
[    4.464089] initcall init_per_zone_pages_min+0x0/0x7b returned 0 after 0 usecs
[    4.468012] calling  pdflush_init+0x0/0x11 @ 1
[    4.472075] initcall pdflush_init+0x0/0x11 returned 0 after 0 usecs
[    4.476014] calling  kswapd_init+0x0/0x5a @ 1
[    4.480100] initcall kswapd_init+0x0/0x5a returned 0 after 0 usecs
[    4.484013] calling  init_tmpfs+0x0/0xb9 @ 1
[    4.488150] initcall init_tmpfs+0x0/0xb9 returned 0 after 0 usecs
[    4.492013] calling  setup_vmstat+0x0/0xa2 @ 1
[    4.496052] initcall setup_vmstat+0x0/0xa2 returned 0 after 0 usecs
[    4.500012] calling  mm_sysfs_init+0x0/0x22 @ 1
[    4.504040] initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs
[    4.508013] calling  proc_vmalloc_init+0x0/0x1f @ 1
[    4.512020] initcall proc_vmalloc_init+0x0/0x1f returned 0 after 0 usecs
[    4.516012] calling  init_emergency_pool+0x0/0x57 @ 1
[    4.520211] highmem bounce pool size: 64 pages
[    4.524013] initcall init_emergency_pool+0x0/0x57 returned 0 after 3906 usecs
[    4.528012] calling  procswaps_init+0x0/0x1c @ 1
[    4.532020] initcall procswaps_init+0x0/0x1c returned 0 after 0 usecs
[    4.536012] calling  hugetlb_init+0x0/0x230 @ 1
[    4.540014] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.544040] initcall hugetlb_init+0x0/0x230 returned 0 after 3906 usecs
[    4.548012] calling  slab_proc_init+0x0/0x1f @ 1
[    4.552029] initcall slab_proc_init+0x0/0x1f returned 0 after 0 usecs
[    4.556012] calling  slab_sysfs_init+0x0/0xb6 @ 1
[    4.572238] khelper used greatest stack depth: 6988 bytes left
[    4.596353] initcall slab_sysfs_init+0x0/0xb6 returned 0 after 35156 usecs
[    4.600426] calling  fasync_init+0x0/0x24 @ 1
[    4.604316] initcall fasync_init+0x0/0x24 returned 0 after 0 usecs
[    4.608013] calling  proc_filesystems_init+0x0/0x1c @ 1
[    4.612035] initcall proc_filesystems_init+0x0/0x1c returned 0 after 0 usecs
[    4.616012] calling  inotify_setup+0x0/0x11 @ 1
[    4.620013] initcall inotify_setup+0x0/0x11 returned 0 after 0 usecs
[    4.624012] calling  inotify_user_setup+0x0/0x98 @ 1
[    4.628298] initcall inotify_user_setup+0x0/0x98 returned 0 after 0 usecs
[    4.632013] calling  aio_setup+0x0/0xa1 @ 1
[    4.636728] initcall aio_setup+0x0/0xa1 returned 0 after 0 usecs
[    4.640013] calling  proc_locks_init+0x0/0x1c @ 1
[    4.644025] initcall proc_locks_init+0x0/0x1c returned 0 after 0 usecs
[    4.648012] calling  init_mbcache+0x0/0x11 @ 1
[    4.652013] initcall init_mbcache+0x0/0x11 returned 0 after 0 usecs
[    4.656012] calling  dquot_init+0x0/0xc8 @ 1
[    4.660011] VFS: Disk quotas dquot_6.5.2
[    4.664323] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.668015] initcall dquot_init+0x0/0xc8 returned 0 after 7812 usecs
[    4.672117] calling  init_v1_quota_format+0x0/0xf @ 1
[    4.676014] initcall init_v1_quota_format+0x0/0xf returned 0 after 0 usecs
[    4.680013] calling  proc_cmdline_init+0x0/0x1c @ 1
[    4.684021] initcall proc_cmdline_init+0x0/0x1c returned 0 after 0 usecs
[    4.688012] calling  proc_cpuinfo_init+0x0/0x1c @ 1
[    4.692020] initcall proc_cpuinfo_init+0x0/0x1c returned 0 after 0 usecs
[    4.696013] calling  proc_devices_init+0x0/0x1c @ 1
[    4.700020] initcall proc_devices_init+0x0/0x1c returned 0 after 0 usecs
[    4.704013] calling  proc_interrupts_init+0x0/0x1c @ 1
[    4.708021] initcall proc_interrupts_init+0x0/0x1c returned 0 after 0 usecs
[    4.712013] calling  proc_loadavg_init+0x0/0x1c @ 1
[    4.716020] initcall proc_loadavg_init+0x0/0x1c returned 0 after 0 usecs
[    4.720013] calling  proc_meminfo_init+0x0/0x1c @ 1
[    4.724020] initcall proc_meminfo_init+0x0/0x1c returned 0 after 0 usecs
[    4.728013] calling  proc_stat_init+0x0/0x1c @ 1
[    4.732020] initcall proc_stat_init+0x0/0x1c returned 0 after 0 usecs
[    4.736013] calling  proc_uptime_init+0x0/0x27 @ 1
[    4.740020] initcall proc_uptime_init+0x0/0x27 returned 0 after 0 usecs
[    4.744013] calling  proc_version_init+0x0/0x1c @ 1
[    4.748020] initcall proc_version_init+0x0/0x1c returned 0 after 0 usecs
[    4.752013] calling  vmcore_init+0x0/0x75 @ 1
[    4.756013] initcall vmcore_init+0x0/0x75 returned 0 after 0 usecs
[    4.760013] calling  proc_kmsg_init+0x0/0x1f @ 1
[    4.764020] initcall proc_kmsg_init+0x0/0x1f returned 0 after 0 usecs
[    4.768013] calling  proc_page_init+0x0/0x37 @ 1
[    4.772028] initcall proc_page_init+0x0/0x37 returned 0 after 0 usecs
[    4.776013] calling  configfs_init+0x0/0xd6 @ 1
[    4.780232] initcall configfs_init+0x0/0xd6 returned 0 after 0 usecs
[    4.784013] calling  init_devpts_fs+0x0/0x33 @ 1
[    4.788134] initcall init_devpts_fs+0x0/0x33 returned 0 after 0 usecs
[    4.792013] calling  init_ext3_fs+0x0/0x64 @ 1
[    4.796262] initcall init_ext3_fs+0x0/0x64 returned 0 after 0 usecs
[    4.800014] calling  journal_init+0x0/0x85 @ 1
[    4.804249] initcall journal_init+0x0/0x85 returned 0 after 0 usecs
[    4.808014] calling  init_cramfs_fs+0x0/0x29 @ 1
[    4.812042] initcall init_cramfs_fs+0x0/0x29 returned 0 after 0 usecs
[    4.816013] calling  init_ramfs_fs+0x0/0xf @ 1
[    4.820014] initcall init_ramfs_fs+0x0/0xf returned 0 after 0 usecs
[    4.824013] calling  init_hugetlbfs_fs+0x0/0x82 @ 1
[    4.828239] initcall init_hugetlbfs_fs+0x0/0x82 returned 0 after 0 usecs
[    4.832015] calling  init_fat_fs+0x0/0x46 @ 1
[    4.836237] initcall init_fat_fs+0x0/0x46 returned 0 after 0 usecs
[    4.840014] calling  init_msdos_fs+0x0/0xf @ 1
[    4.844015] initcall init_msdos_fs+0x0/0xf returned 0 after 0 usecs
[    4.848013] calling  init_iso9660_fs+0x0/0x64 @ 1
[    4.852220] initcall init_iso9660_fs+0x0/0x64 returned 0 after 0 usecs
[    4.856014] calling  vxfs_init+0x0/0x4d @ 1
[    4.860226] initcall vxfs_init+0x0/0x4d returned 0 after 0 usecs
[    4.864014] calling  init_nls_cp737+0x0/0xf @ 1
[    4.868039] initcall init_nls_cp737+0x0/0xf returned 0 after 0 usecs
[    4.872013] calling  init_nls_cp857+0x0/0xf @ 1
[    4.876013] initcall init_nls_cp857+0x0/0xf returned 0 after 0 usecs
[    4.880013] calling  init_nls_cp865+0x0/0xf @ 1
[    4.884014] initcall init_nls_cp865+0x0/0xf returned 0 after 0 usecs
[    4.888013] calling  init_nls_cp869+0x0/0xf @ 1
[    4.892013] initcall init_nls_cp869+0x0/0xf returned 0 after 0 usecs
[    4.896013] calling  init_nls_cp874+0x0/0xf @ 1
[    4.900014] initcall init_nls_cp874+0x0/0xf returned 0 after 0 usecs
[    4.904013] calling  init_nls_cp932+0x0/0xf @ 1
[    4.908014] initcall init_nls_cp932+0x0/0xf returned 0 after 0 usecs
[    4.912013] calling  init_nls_euc_jp+0x0/0x39 @ 1
[    4.916014] initcall init_nls_euc_jp+0x0/0x39 returned 0 after 0 usecs
[    4.920022] calling  init_nls_cp1251+0x0/0xf @ 1
[    4.924014] initcall init_nls_cp1251+0x0/0xf returned 0 after 0 usecs
[    4.928013] calling  init_nls_iso8859_1+0x0/0xf @ 1
[    4.932014] initcall init_nls_iso8859_1+0x0/0xf returned 0 after 0 usecs
[    4.936013] calling  init_nls_iso8859_6+0x0/0xf @ 1
[    4.940014] initcall init_nls_iso8859_6+0x0/0xf returned 0 after 0 usecs
[    4.944013] calling  init_nls_iso8859_13+0x0/0xf @ 1
[    4.948014] initcall init_nls_iso8859_13+0x0/0xf returned 0 after 0 usecs
[    4.952013] calling  init_hpfs_fs+0x0/0x54 @ 1
[    4.956228] initcall init_hpfs_fs+0x0/0x54 returned 0 after 0 usecs
[    4.960014] calling  init_autofs_fs+0x0/0xf @ 1
[    4.964015] initcall init_autofs_fs+0x0/0xf returned 0 after 0 usecs
[    4.968013] calling  init_autofs4_fs+0x0/0x1e @ 1
[    4.972015] initcall init_autofs4_fs+0x0/0x1e returned -16 after 0 usecs
[    4.976013] initcall init_autofs4_fs+0x0/0x1e returned with error code -16 
[    4.980013] calling  fuse_init+0x0/0x10a @ 1
[    4.984012] fuse init (API version 7.11)
[    4.988245] device: 'fuse': device_add
[    4.992136] initcall fuse_init+0x0/0x10a returned 0 after 7812 usecs
[    4.996013] calling  init_udf_fs+0x0/0x54 @ 1
[    5.000224] initcall init_udf_fs+0x0/0x54 returned 0 after 0 usecs
[    5.004014] calling  ipc_init+0x0/0x20 @ 1
[    5.008036] msgmni has been set to 1721
[    5.012030] initcall ipc_init+0x0/0x20 returned 0 after 3906 usecs
[    5.016013] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    5.020135] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 0 usecs
[    5.024013] calling  init_mqueue_fs+0x0/0xb1 @ 1
[    5.028230] initcall init_mqueue_fs+0x0/0xb1 returned 0 after 0 usecs
[    5.032014] calling  key_proc_init+0x0/0x4e @ 1
[    5.036029] initcall key_proc_init+0x0/0x4e returned 0 after 0 usecs
[    5.040013] calling  crypto_algapi_init+0x0/0xc @ 1
[    5.044040] initcall crypto_algapi_init+0x0/0xc returned 0 after 0 usecs
[    5.048013] calling  chainiv_module_init+0x0/0xf @ 1
[    5.052016] initcall chainiv_module_init+0x0/0xf returned 0 after 0 usecs
[    5.056013] calling  eseqiv_module_init+0x0/0xf @ 1
[    5.060014] initcall eseqiv_module_init+0x0/0xf returned 0 after 0 usecs
[    5.064013] calling  seqiv_module_init+0x0/0xf @ 1
[    5.068014] initcall seqiv_module_init+0x0/0xf returned 0 after 0 usecs
[    5.072013] calling  hmac_module_init+0x0/0xf @ 1
[    5.076015] initcall hmac_module_init+0x0/0xf returned 0 after 0 usecs
[    5.080013] calling  crypto_null_mod_init+0x0/0x69 @ 1
[    5.084101] alg: No test for cipher_null (cipher_null-generic)
[    5.092192] alg: No test for digest_null (digest_null-generic)
[    5.096099] alg: No test for compress_null (compress_null-generic)
[    5.104037] initcall crypto_null_mod_init+0x0/0x69 returned 0 after 19531 usecs
[    5.108034] calling  md5_mod_init+0x0/0xf @ 1
[    5.112078] initcall md5_mod_init+0x0/0xf returned 0 after 0 usecs
[    5.112078] cryptomgr_test used greatest stack depth: 6940 bytes left
[    5.116014] calling  rmd128_mod_init+0x0/0xf @ 1
[    5.120092] initcall rmd128_mod_init+0x0/0xf returned 0 after 0 usecs
[    5.120092] cryptomgr_test used greatest stack depth: 6888 bytes left
[    5.124014] calling  rmd256_mod_init+0x0/0xf @ 1
[    5.128085] initcall rmd256_mod_init+0x0/0xf returned 0 after 0 usecs
[    5.132014] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    5.136085] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 0 usecs
[    5.140014] calling  sha512_generic_mod_init+0x0/0x33 @ 1
[    5.144095] initcall sha512_generic_mod_init+0x0/0x33 returned 0 after 0 usecs
[    5.148014] calling  crypto_ecb_module_init+0x0/0xf @ 1
[    5.152017] initcall crypto_ecb_module_init+0x0/0xf returned 0 after 0 usecs
[    5.156013] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    5.160015] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 0 usecs
[    5.164013] calling  crypto_cts_module_init+0x0/0xf @ 1
[    5.168015] initcall crypto_cts_module_init+0x0/0xf returned 0 after 0 usecs
[    5.172013] calling  des_generic_mod_init+0x0/0x33 @ 1
[    5.176099] initcall des_generic_mod_init+0x0/0x33 returned 0 after 0 usecs
[    5.180014] calling  fcrypt_mod_init+0x0/0xf @ 1
[    5.184083] alg: No test for fcrypt (fcrypt-generic)
[    5.188020] initcall fcrypt_mod_init+0x0/0xf returned 0 after 3906 usecs
[    5.192013] calling  twofish_mod_init+0x0/0xf @ 1
[    5.196138] initcall twofish_mod_init+0x0/0xf returned 0 after 0 usecs
[    5.200014] calling  aes_init+0x0/0xf @ 1
[    5.204081] initcall aes_init+0x0/0xf returned 0 after 0 usecs
[    5.208014] calling  camellia_init+0x0/0xf @ 1
[    5.212083] initcall camellia_init+0x0/0xf returned 0 after 0 usecs
[    5.216014] calling  arc4_init+0x0/0xf @ 1
[    5.220082] initcall arc4_init+0x0/0xf returned 0 after 0 usecs
[    5.224014] calling  khazad_mod_init+0x0/0xf @ 1
[    5.228083] initcall khazad_mod_init+0x0/0xf returned 0 after 0 usecs
[    5.232014] calling  seed_init+0x0/0xf @ 1
[    5.236082] initcall seed_init+0x0/0xf returned 0 after 0 usecs
[    5.240014] calling  michael_mic_init+0x0/0xf @ 1
[    5.248020] initcall michael_mic_init+0x0/0xf returned 0 after 3906 usecs
[    5.252014] calling  crc32c_mod_init+0x0/0xf @ 1
[    5.256083] initcall crc32c_mod_init+0x0/0xf returned 0 after 0 usecs
[    5.260014] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    5.264015] initcall crypto_authenc_module_init+0x0/0xf returned 0 after 0 usecs
[    5.268013] calling  krng_mod_init+0x0/0xf @ 1
[    5.272083] alg: No test for stdrng (krng)
[    5.276041] initcall krng_mod_init+0x0/0xf returned 0 after 3906 usecs
[    5.280014] calling  proc_genhd_init+0x0/0x31 @ 1
[    5.284029] initcall proc_genhd_init+0x0/0x31 returned 0 after 0 usecs
[    5.288013] calling  bsg_init+0x0/0x106 @ 1
[    5.292250] device class 'bsg': registering
[    5.296141] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    5.300015] initcall bsg_init+0x0/0x106 returned 0 after 7812 usecs
[    5.304014] calling  noop_init+0x0/0x11 @ 1
[    5.308039] io scheduler noop registered (default)
[    5.312014] initcall noop_init+0x0/0x11 returned 0 after 3906 usecs
[    5.316013] calling  percpu_counter_startup+0x0/0x16 @ 1
[    5.320016] initcall percpu_counter_startup+0x0/0x16 returned 0 after 0 usecs
[    5.324013] calling  audit_classes_init+0x0/0x4f @ 1
[    5.328023] initcall audit_classes_init+0x0/0x4f returned 0 after 0 usecs
[    5.332013] calling  dynamic_printk_init+0x0/0xe2 @ 1
[    5.341040] initcall dynamic_printk_init+0x0/0xe2 returned 0 after 3906 usecs
[    5.344015] calling  pci_init+0x0/0x31 @ 1
[    5.348023] pci 0000:00:00.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.352080] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.356015] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.360015] pci 0000:00:00.0: calling pci_fixup_video+0x0/0x9a
[    5.364020] pci 0000:00:01.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.368019] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.372014] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.376014] pci 0000:00:01.0: calling pci_fixup_video+0x0/0x9a
[    5.380019] pci 0000:00:01.1: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.384032] pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x26
[    5.388014] pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0x89
[    5.392014] pci 0000:00:01.1: calling pci_fixup_video+0x0/0x9a
[    5.396020] pci 0000:00:02.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.400032] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.404014] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.424042] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x9a
[    5.428029] pci 0000:00:02.1: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.436019] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x26
[    5.440014] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x89
[    5.444051] pci 0000:00:02.1: calling pci_fixup_video+0x0/0x9a
[    5.448020] pci 0000:00:04.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.452033] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.456014] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.460014] pci 0000:00:04.0: calling pci_fixup_video+0x0/0x9a
[    5.464020] pci 0000:00:06.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.468032] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.472015] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.476014] pci 0000:00:06.0: calling pci_fixup_video+0x0/0x9a
[    5.480020] pci 0000:00:09.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.484019] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.488015] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.492014] pci 0000:00:09.0: calling pci_fixup_video+0x0/0x9a
[    5.496052] pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.500034] pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.504015] pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.508015] pci 0000:00:0a.0: calling pci_fixup_video+0x0/0x9a
[    5.512020] pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.520182] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.524015] pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x6e
[    5.528053] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    5.532050] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.536015] pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x68
[    5.540015] pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.544015] pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.548015] pci 0000:00:0b.0: calling pci_fixup_video+0x0/0x9a
[    5.552020] pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.560212] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.564015] pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x6e
[    5.568052] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    5.572050] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.576015] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x68
[    5.580015] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.584015] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.588015] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0x9a
[    5.592020] pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.600291] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.604015] pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x6e
[    5.608052] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    5.612050] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.616015] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x68
[    5.620015] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.624015] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.628015] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0x9a
[    5.632020] pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk+0x0/0x1ba
[    5.636419] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.640015] pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x6e
[    5.644052] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    5.648050] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    5.652015] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x68
[    5.656016] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.660015] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.664015] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0x9a
[    5.668021] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.672015] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.676015] pci 0000:00:18.0: calling pci_fixup_video+0x0/0x9a
[    5.680032] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x26
[    5.684015] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x89
[    5.688015] pci 0000:00:18.1: calling pci_fixup_video+0x0/0x9a
[    5.692021] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x26
[    5.696015] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x89
[    5.700015] pci 0000:00:18.2: calling pci_fixup_video+0x0/0x9a
[    5.704021] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x26
[    5.708015] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x89
[    5.712015] pci 0000:00:18.3: calling pci_fixup_video+0x0/0x9a
[    5.716021] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.720015] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.724015] pci 0000:05:07.0: calling pci_fixup_video+0x0/0x9a
[    5.728021] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x26
[    5.732015] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x89
[    5.736015] pci 0000:01:00.0: calling pci_fixup_video+0x0/0x9a
[    5.740023] pci 0000:01:00.0: Boot video device
[    5.744021] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x26
[    5.748015] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x89
[    5.752015] pci 0000:01:00.1: calling pci_fixup_video+0x0/0x9a
[    5.756019] initcall pci_init+0x0/0x31 returned 0 after 398438 usecs
[    5.760015] calling  pci_proc_init+0x0/0x5b @ 1
[    5.764276] initcall pci_proc_init+0x0/0x5b returned 0 after 0 usecs
[    5.768015] calling  pcie_portdrv_init+0x0/0x41 @ 1
[    5.772141] bus: 'pci_express': registered
[    5.776015] bus: 'pci': add driver pcieport-driver
[    5.780030] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver pcieport-driver
[    5.784014] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0b.0
[    5.788089] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    5.796223]   alloc irq_desc for 24 on cpu 0 node 0
[    5.800011]   alloc kstat_irqs on cpu 0 node 0
[    5.800038] pcieport-driver 0000:00:0b.0: irq 24 for MSI/MSI-X
[    5.804059] device: '0000:00:0b.0:pcie00': device_add
[    5.808023] bus: 'pci_express': add device 0000:00:0b.0:pcie00
[    5.812207] driver: '0000:00:0b.0': driver_bound: bound to device 'pcieport-driver'
[    5.816041] bus: 'pci': really_probe: bound device 0000:00:0b.0 to driver pcieport-driver
[    5.820016] bus: 'pci': driver_probe_device: matched device 0000:00:0c.0 with driver pcieport-driver
[    5.824013] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0c.0
[    5.828084] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    5.832300]   alloc irq_desc for 25 on cpu 0 node 0
[    5.836011]   alloc kstat_irqs on cpu 0 node 0
[    5.836035] pcieport-driver 0000:00:0c.0: irq 25 for MSI/MSI-X
[    5.840059] device: '0000:00:0c.0:pcie00': device_add
[    5.844023] bus: 'pci_express': add device 0000:00:0c.0:pcie00
[    5.848205] driver: '0000:00:0c.0': driver_bound: bound to device 'pcieport-driver'
[    5.852015] bus: 'pci': really_probe: bound device 0000:00:0c.0 to driver pcieport-driver
[    5.856016] bus: 'pci': driver_probe_device: matched device 0000:00:0d.0 with driver pcieport-driver
[    5.860013] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0d.0
[    5.864084] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[    5.868300]   alloc irq_desc for 26 on cpu 0 node 0
[    5.872011]   alloc kstat_irqs on cpu 0 node 0
[    5.872035] pcieport-driver 0000:00:0d.0: irq 26 for MSI/MSI-X
[    5.876059] device: '0000:00:0d.0:pcie00': device_add
[    5.880022] bus: 'pci_express': add device 0000:00:0d.0:pcie00
[    5.884204] driver: '0000:00:0d.0': driver_bound: bound to device 'pcieport-driver'
[    5.888015] bus: 'pci': really_probe: bound device 0000:00:0d.0 to driver pcieport-driver
[    5.892016] bus: 'pci': driver_probe_device: matched device 0000:00:0e.0 with driver pcieport-driver
[    5.896013] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0e.0
[    5.900084] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    5.904307]   alloc irq_desc for 27 on cpu 0 node 0
[    5.908011]   alloc kstat_irqs on cpu 0 node 0
[    5.912013] pcieport-driver 0000:00:0e.0: irq 27 for MSI/MSI-X
[    5.916059] device: '0000:00:0e.0:pcie00': device_add
[    5.920023] bus: 'pci_express': add device 0000:00:0e.0:pcie00
[    5.924205] driver: '0000:00:0e.0': driver_bound: bound to device 'pcieport-driver'
[    5.928015] bus: 'pci': really_probe: bound device 0000:00:0e.0 to driver pcieport-driver
[    5.932137] initcall pcie_portdrv_init+0x0/0x41 returned 0 after 156250 usecs
[    5.936024] calling  genericbl_init+0x0/0xf @ 1
[    5.940014] bus: 'platform': add driver generic-bl
[    5.944137] initcall genericbl_init+0x0/0xf returned 0 after 3906 usecs
[    5.948016] calling  progearbl_init+0x0/0x49 @ 1
[    5.952014] bus: 'platform': add driver progear-bl
[    5.956137] Registering platform device 'progear-bl'. Parent at platform
[    5.960014] device: 'progear-bl': device_add
[    5.964023] bus: 'platform': add device progear-bl
[    5.968137] bus: 'platform': driver_probe_device: matched device progear-bl with driver progear-bl
[    5.972014] bus: 'platform': really_probe: probing driver progear-bl with device progear-bl
[    5.976031] ALI M7101 PMU not found.
[    5.980066] initcall progearbl_init+0x0/0x49 returned 0 after 27343 usecs
[    5.984015] calling  pnpbios_thread_init+0x0/0x4e @ 1
[    5.988085] initcall pnpbios_thread_init+0x0/0x4e returned 0 after 0 usecs
[    5.992016] calling  isapnp_init+0x0/0x288 @ 1
[    5.996019] device: 'pnp1': device_add
[    6.000023] isapnp: Scanning for PnP cards...
[    6.357641] isapnp: No Plug & Play device found
[    6.360016] initcall isapnp_init+0x0/0x288 returned 0 after 355469 usecs
[    6.364015] calling  bq24022_init+0x0/0x14 @ 1
[    6.368015] bus: 'platform': add driver bq24022
[    6.372139] bus: 'platform': remove driver bq24022
[    6.376142] driver: 'bq24022': driver_release
[    6.380022] initcall bq24022_init+0x0/0x14 returned -19 after 11718 usecs
[    6.384017] calling  rand_initialize+0x0/0x2a @ 1
[    6.388074] initcall rand_initialize+0x0/0x2a returned 0 after 0 usecs
[    6.392015] calling  tty_init+0x0/0xd5 @ 1
[    6.396022] device: 'tty': device_add
[    6.400141] device: 'console': device_add
[    6.404140] device: 'tty0': device_add
[    6.408138] device class 'vc': registering
[    6.412142] device: 'vcs': device_add
[    6.416138] device: 'vcsa': device_add
[    6.420137] device: 'tty1': device_add
[    6.424138] device: 'tty2': device_add
[    6.428140] device: 'tty3': device_add
[    6.432138] device: 'tty4': device_add
[    6.436034] device: 'tty5': device_add
[    6.439727] device: 'tty6': device_add
[    6.440136] device: 'tty7': device_add
[    6.444139] device: 'tty8': device_add
[    6.448138] device: 'tty9': device_add
[    6.452147] device: 'tty10': device_add
[    6.456133] device: 'tty11': device_add
[    6.460143] device: 'tty12': device_add
[    6.464181] device: 'tty13': device_add
[    6.468124] device: 'tty14': device_add
[    6.472168] device: 'tty15': device_add
[    6.476106] device: 'tty16': device_add
[    6.480102] device: 'tty17': device_add
[    6.484115] device: 'tty18': device_add
[    6.488123] device: 'tty19': device_add
[    6.492141] device: 'tty20': device_add
[    6.496146] device: 'tty21': device_add
[    6.500138] device: 'tty22': device_add
[    6.504142] device: 'tty23': device_add
[    6.508138] device: 'tty24': device_add
[    6.512139] device: 'tty25': device_add
[    6.516138] device: 'tty26': device_add
[    6.520138] device: 'tty27': device_add
[    6.524137] device: 'tty28': device_add
[    6.528137] device: 'tty29': device_add
[    6.532138] device: 'tty30': device_add
[    6.536142] device: 'tty31': device_add
[    6.540138] device: 'tty32': device_add
[    6.544137] device: 'tty33': device_add
[    6.548138] device: 'tty34': device_add
[    6.552137] device: 'tty35': device_add
[    6.556138] device: 'tty36': device_add
[    6.560138] device: 'tty37': device_add
[    6.564138] device: 'tty38': device_add
[    6.568138] device: 'tty39': device_add
[    6.572138] device: 'tty40': device_add
[    6.576137] device: 'tty41': device_add
[    6.580138] device: 'tty42': device_add
[    6.584138] device: 'tty43': device_add
[    6.588138] device: 'tty44': device_add
[    6.592138] device: 'tty45': device_add
[    6.596138] device: 'tty46': device_add
[    6.600137] device: 'tty47': device_add
[    6.604138] device: 'tty48': device_add
[    6.608138] device: 'tty49': device_add
[    6.612138] device: 'tty50': device_add
[    6.616137] device: 'tty51': device_add
[    6.620138] device: 'tty52': device_add
[    6.624140] device: 'tty53': device_add
[    6.628138] device: 'tty54': device_add
[    6.632138] device: 'tty55': device_add
[    6.636138] device: 'tty56': device_add
[    6.640138] device: 'tty57': device_add
[    6.644139] device: 'tty58': device_add
[    6.648140] device: 'tty59': device_add
[    6.652138] device: 'tty60': device_add
[    6.656138] device: 'tty61': device_add
[    6.660138] device: 'tty62': device_add
[    6.664137] device: 'tty63': device_add
[    6.668212] initcall tty_init+0x0/0xd5 returned 0 after 265625 usecs
[    6.672018] calling  pty_init+0x0/0xc @ 1
[    6.676076] device: 'ptmx': device_add
[    6.680139] initcall pty_init+0x0/0xc returned 0 after 3906 usecs
[    6.684017] calling  sysrq_init+0x0/0x1f @ 1
[    6.688030] initcall sysrq_init+0x0/0x1f returned 0 after 0 usecs
[    6.692015] calling  nozomi_init+0x0/0xf4 @ 1
[    6.696014] Initializing Nozomi driver 2.1d (build date: Mar 18 2009 11:06:49)
[    6.700039] bus: 'pci': add driver nozomi
[    6.704138] initcall nozomi_init+0x0/0xf4 returned 0 after 7812 usecs
[    6.708016] calling  raw_init+0x0/0xc0 @ 1
[    6.712020] device class 'raw': registering
[    6.716138] device: 'rawctl': device_add
[    6.720138] initcall raw_init+0x0/0xc0 returned 0 after 7812 usecs
[    6.724015] calling  nvram_init+0x0/0x70 @ 1
[    6.728019] device: 'nvram': device_add
[    6.732138] Non-volatile memory driver v1.3
[    6.736017] initcall nvram_init+0x0/0x70 returned 0 after 7812 usecs
[    6.740015] calling  scx200_gpio_init+0x0/0x112 @ 1
[    6.744014] scx200_gpio: no SCx200 gpio present
[    6.748016] initcall scx200_gpio_init+0x0/0x112 returned -19 after 3906 usecs
[    6.752015] calling  nsc_gpio_init+0x0/0x11 @ 1
[    6.756014] nsc_gpio initializing
[    6.759303] initcall nsc_gpio_init+0x0/0x11 returned 0 after 0 usecs
[    6.760015] calling  cs5535_gpio_init+0x0/0x146 @ 1
[    6.764027] cs5535_gpio: DIVIL not found
[    6.768016] initcall cs5535_gpio_init+0x0/0x146 returned -19 after 3906 usecs
[    6.772021] calling  mwave_init+0x0/0x265 @ 1
[    6.776022] smapi::smapi_init, ERROR invalid usSmapiID
[    6.780015] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    6.784015] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    6.788014] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.792016] initcall mwave_init+0x0/0x265 returned -5 after 15625 usecs
[    6.796016] initcall mwave_init+0x0/0x265 returned with error code -5 
[    6.800016] calling  ipmi_init_msghandler_mod+0x0/0xc @ 1
[    6.804016] bus: 'platform': add driver ipmi
[    6.808138] ipmi message handler version 39.2
[    6.812026] initcall ipmi_init_msghandler_mod+0x0/0xc returned 0 after 7812 usecs
[    6.816017] calling  ipmi_poweroff_init+0x0/0x7b @ 1
[    6.820015] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    6.824090] initcall ipmi_poweroff_init+0x0/0x7b returned 0 after 3906 usecs
[    6.828016] calling  serial8250_init+0x0/0xf3 @ 1
[    6.832015] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.836053] Registering platform device 'serial8250'. Parent at platform
[    6.840015] device: 'serial8250': device_add
[    6.844024] bus: 'platform': add device serial8250
[    6.848175] async_waiting @ 1
[    6.852040] async_continuing @ 1 after 0 usec
[    6.984088] async_waiting @ 1
[    6.986930] async_continuing @ 1 after 0 usec
[    7.116122] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.120022] device: 'ttyS0': device_add
[    7.124139] device: 'ttyS1': device_add
[    7.128138] device: 'ttyS2': device_add
[    7.132139] device: 'ttyS3': device_add
[    7.136139] bus: 'platform': add driver serial8250
[    7.140027] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    7.144015] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    7.148024] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    7.152016] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    7.156138] initcall serial8250_init+0x0/0xf3 returned 0 after 316406 usecs
[    7.160017] calling  mca_init+0x0/0x1d @ 1
[    7.164016] initcall mca_init+0x0/0x1d returned -19 after 0 usecs
[    7.168016] calling  jsm_init_module+0x0/0x3a @ 1
[    7.172066] bus: 'pci': add driver jsm
[    7.176138] initcall jsm_init_module+0x0/0x3a returned 0 after 3906 usecs
[    7.180017] calling  isa_bus_init+0x0/0x33 @ 1
[    7.188053] bus: 'isa': registered
[    7.191328] device: 'isa': device_add
[    7.192026] initcall isa_bus_init+0x0/0x33 returned 0 after 7812 usecs
[    7.196018] calling  topology_sysfs_init+0x0/0x8e @ 1
[    7.200058] initcall topology_sysfs_init+0x0/0x8e returned 0 after 0 usecs
[    7.204016] calling  cpqarray_init+0x0/0x5a @ 1
[    7.208015] Compaq SMART2 Driver (v 2.6.0)
[    7.212017] bus: 'pci': add driver cpqarray
[    7.216139] bus: 'pci': remove driver cpqarray
[    7.220139] driver: 'cpqarray': driver_release
[    7.224024] initcall cpqarray_init+0x0/0x5a returned -19 after 15625 usecs
[    7.228016] calling  mm_init+0x0/0x14a @ 1
[    7.232016] bus: 'pci': add driver umem
[    7.236138] MM: desc_per_page = 128
[    7.240028] initcall mm_init+0x0/0x14a returned 0 after 7812 usecs
[    7.244016] calling  nbd_init+0x0/0x277 @ 1
[    7.252512] nbd: registered device at major 43
[    7.256019] device: 'nbd0': device_add
[    7.260165] device: '43:0': device_add
[    7.264141] device: 'nbd1': device_add
[    7.268140] device: '43:1': device_add
[    7.272139] device: 'nbd2': device_add
[    7.276139] device: '43:2': device_add
[    7.280140] device: 'nbd3': device_add
[    7.284139] device: '43:3': device_add
[    7.288057] device: 'nbd4': device_add
[    7.292076] device: '43:4': device_add
[    7.295769] device: 'nbd5': device_add
[    7.296137] device: '43:5': device_add
[    7.300139] device: 'nbd6': device_add
[    7.304139] device: '43:6': device_add
[    7.308144] device: 'nbd7': device_add
[    7.312141] device: '43:7': device_add
[    7.316153] device: 'nbd8': device_add
[    7.320166] device: '43:8': device_add
[    7.324146] device: 'nbd9': device_add
[    7.328157] device: '43:9': device_add
[    7.332149] device: 'nbd10': device_add
[    7.336140] device: '43:10': device_add
[    7.340143] device: 'nbd11': device_add
[    7.344139] device: '43:11': device_add
[    7.348145] device: 'nbd12': device_add
[    7.352140] device: '43:12': device_add
[    7.356141] device: 'nbd13': device_add
[    7.360139] device: '43:13': device_add
[    7.364138] device: 'nbd14': device_add
[    7.368146] device: '43:14': device_add
[    7.372140] device: 'nbd15': device_add
[    7.376140] device: '43:15': device_add
[    7.380140] initcall nbd_init+0x0/0x277 returned 0 after 128906 usecs
[    7.384017] calling  ub_init+0x0/0x71 @ 1
[    7.388020] bus: 'usb': add driver ub
[    7.392140] usbcore: registered new interface driver ub
[    7.396051] initcall ub_init+0x0/0x71 returned 0 after 7812 usecs
[    7.400016] calling  ibmasm_init+0x0/0x56 @ 1
[    7.404024] bus: 'pci': add driver ibmasm
[    7.408139] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    7.412019] initcall ibmasm_init+0x0/0x56 returned 0 after 7812 usecs
[    7.416016] calling  enclosure_init+0x0/0x14 @ 1
[    7.420015] device class 'enclosure': registering
[    7.424103] initcall enclosure_init+0x0/0x14 returned 0 after 3906 usecs
[    7.428017] calling  e1000_init_module+0x0/0x6e @ 1
[    7.432015] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    7.436015] Copyright (c) 1999-2006 Intel Corporation.
[    7.440016] bus: 'pci': add driver e1000
[    7.444139] initcall e1000_init_module+0x0/0x6e returned 0 after 11718 usecs
[    7.448017] calling  e1000_init_module+0x0/0x53 @ 1
[    7.452015] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    7.456015] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    7.460016] bus: 'pci': add driver e1000e
[    7.464138] initcall e1000_init_module+0x0/0x53 returned 0 after 11718 usecs
[    7.468017] calling  atl1e_init_module+0x0/0x16 @ 1
[    7.472016] bus: 'pci': add driver ATL1E
[    7.476139] initcall atl1e_init_module+0x0/0x16 returned 0 after 3906 usecs
[    7.480017] calling  atl1c_init_module+0x0/0x16 @ 1
[    7.484016] bus: 'pci': add driver atl1c
[    7.488139] initcall atl1c_init_module+0x0/0x16 returned 0 after 3906 usecs
[    7.492017] calling  happy_meal_probe+0x0/0x16 @ 1
[    7.496024] bus: 'pci': add driver hme
[    7.500139] initcall happy_meal_probe+0x0/0x16 returned 0 after 3906 usecs
[    7.504017] calling  gem_init+0x0/0x16 @ 1
[    7.508016] bus: 'pci': add driver gem
[    7.512139] initcall gem_init+0x0/0x16 returned 0 after 3906 usecs
[    7.516017] calling  vortex_init+0x0/0xbf @ 1
[    7.520017] bus: 'pci': add driver 3c59x
[    7.524139] bus: 'eisa': add driver 3c59x
[    7.528139] initcall vortex_init+0x0/0xbf returned 0 after 7812 usecs
[    7.532016] calling  typhoon_init+0x0/0x16 @ 1
[    7.536017] bus: 'pci': add driver typhoon
[    7.540139] initcall typhoon_init+0x0/0x16 returned 0 after 3906 usecs
[    7.544017] calling  e100_init_module+0x0/0x4d @ 1
[    7.548016] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    7.552015] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.556016] bus: 'pci': add driver e100
[    7.560139] initcall e100_init_module+0x0/0x4d returned 0 after 11718 usecs
[    7.564017] calling  tlan_probe+0x0/0xba @ 1
[    7.568016] ThunderLAN driver v1.15a
[    7.571563] bus: 'pci': add driver tlan
[    7.576031] TLAN: 0 devices installed, PCI: 0  EISA: 0
[    7.580040] bus: 'pci': remove driver tlan
[    7.584140] driver: 'tlan': driver_release
[    7.588020] initcall tlan_probe+0x0/0xba returned -19 after 19531 usecs
[    7.592017] calling  sis190_init_module+0x0/0x16 @ 1
[    7.596017] bus: 'pci': add driver sis190
[    7.600139] initcall sis190_init_module+0x0/0x16 returned 0 after 3906 usecs
[    7.604017] calling  sis900_init_module+0x0/0x16 @ 1
[    7.608017] bus: 'pci': add driver sis900
[    7.612150] initcall sis900_init_module+0x0/0x16 returned 0 after 3906 usecs
[    7.616017] calling  r6040_init+0x0/0x16 @ 1
[    7.620017] bus: 'pci': add driver r6040
[    7.624139] initcall r6040_init+0x0/0x16 returned 0 after 3906 usecs
[    7.628017] calling  acenic_init+0x0/0x16 @ 1
[    7.632017] bus: 'pci': add driver acenic
[    7.636139] initcall acenic_init+0x0/0x16 returned 0 after 3906 usecs
[    7.640017] calling  natsemi_init_mod+0x0/0x16 @ 1
[    7.644016] bus: 'pci': add driver natsemi
[    7.648139] initcall natsemi_init_mod+0x0/0x16 returned 0 after 3906 usecs
[    7.652017] calling  ns83820_init+0x0/0x20 @ 1
[    7.656015] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    7.660016] bus: 'pci': add driver ns83820
[    7.664139] initcall ns83820_init+0x0/0x20 returned 0 after 7812 usecs
[    7.668017] calling  fealnx_init+0x0/0x16 @ 1
[    7.672017] bus: 'pci': add driver fealnx
[    7.676139] initcall fealnx_init+0x0/0x16 returned 0 after 3906 usecs
[    7.680017] calling  tg3_init+0x0/0x16 @ 1
[    7.684017] bus: 'pci': add driver tg3
[    7.688139] initcall tg3_init+0x0/0x16 returned 0 after 3906 usecs
[    7.692017] calling  velocity_init_module+0x0/0x16 @ 1
[    7.696017] bus: 'pci': add driver via-velocity
[    7.700139] initcall velocity_init_module+0x0/0x16 returned 0 after 3906 usecs
[    7.704017] calling  starfire_init+0x0/0x16 @ 1
[    7.708017] bus: 'pci': add driver starfire
[    7.712140] initcall starfire_init+0x0/0x16 returned 0 after 3906 usecs
[    7.716017] calling  davicom_init+0x0/0x4d @ 1
[    7.720017] bus: 'mdio_bus': add driver Davicom DM9161E
[    7.724139] bus: 'mdio_bus': add driver Davicom DM9161A
[    7.728140] bus: 'mdio_bus': add driver Davicom DM9131
[    7.732139] initcall davicom_init+0x0/0x4d returned 0 after 11718 usecs
[    7.736017] calling  qs6612_init+0x0/0xf @ 1
[    7.740016] bus: 'mdio_bus': add driver QS6612
[    7.744139] initcall qs6612_init+0x0/0xf returned 0 after 3906 usecs
[    7.748017] calling  vsc82xx_init+0x0/0x33 @ 1
[    7.752026] bus: 'mdio_bus': add driver Vitesse VSC8244
[    7.756139] bus: 'mdio_bus': add driver Vitesse VSC8221
[    7.760139] initcall vsc82xx_init+0x0/0x33 returned 0 after 7812 usecs
[    7.764017] calling  fixed_mdio_bus_init+0x0/0xae @ 1
[    7.768020] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[    7.772016] device: 'Fixed MDIO bus.0': device_add
[    7.776025] bus: 'platform': add device Fixed MDIO bus.0
[    7.780139] device: '0': device_add
[    7.784139] Fixed MDIO Bus: probed
[    7.788018] initcall fixed_mdio_bus_init+0x0/0xae returned 0 after 19531 usecs
[    7.792016] calling  ns_init+0x0/0xf @ 1
[    7.796017] bus: 'mdio_bus': add driver NatSemi DP83865
[    7.800139] initcall ns_init+0x0/0xf returned 0 after 3906 usecs
[    7.804017] calling  hamachi_init+0x0/0x16 @ 1
[    7.808023] bus: 'pci': add driver hamachi
[    7.812139] initcall hamachi_init+0x0/0x16 returned 0 after 3906 usecs
[    7.816017] calling  net_olddevs_init+0x0/0x18 @ 1
[    7.820207] cs89x0:cs89x0_probe(0x0)
[    7.824019] PP_addr at 300[a]: 0xffff
[    7.828017] eth0: incorrect signature at 300[c]: 0xffff!=0x630E
[    7.832021] PP_addr at 320[a]: 0xffff
[    7.836017] eth0: incorrect signature at 320[c]: 0xffff!=0x630E
[    7.840020] PP_addr at 340[a]: 0xffff
[    7.844017] eth0: incorrect signature at 340[c]: 0xffff!=0x630E
[    7.848020] PP_addr at 360[a]: 0xffff
[    7.851650] eth0: incorrect signature at 360[c]: 0xffff!=0x630E
[    7.852020] PP_addr at 200[a]: 0xffff
[    7.856017] eth0: incorrect signature at 200[c]: 0xffff!=0x630E
[    7.860020] PP_addr at 220[a]: 0xffff
[    7.864017] eth0: incorrect signature at 220[c]: 0xffff!=0x630E
[    7.868020] PP_addr at 240[a]: 0xffff
[    7.872017] eth0: incorrect signature at 240[c]: 0xffff!=0x630E
[    7.876020] PP_addr at 260[a]: 0xffff
[    7.880017] eth0: incorrect signature at 260[c]: 0xffff!=0x630E
[    7.884020] PP_addr at 280[a]: 0xffff
[    7.888017] eth0: incorrect signature at 280[c]: 0xffff!=0x630E
[    7.892021] PP_addr at 2a0[a]: 0xffff
[    7.896019] eth0: incorrect signature at 2a0[c]: 0xffff!=0x630E
[    7.900021] PP_addr at 2c0[a]: 0xffff
[    7.904019] eth0: incorrect signature at 2c0[c]: 0xffff!=0x630E
[    7.908021] PP_addr at 2e0[a]: 0xffff
[    7.911653] eth0: incorrect signature at 2e0[c]: 0xffff!=0x630E
[    7.912027] cs89x0: no cs8900 or cs8920 detected.  Be sure to disable PnP with SETUP
[    7.916801] initcall net_olddevs_init+0x0/0x18 returned 0 after 93750 usecs
[    7.920017] calling  hp100_module_init+0x0/0x46 @ 1
[    7.924017] bus: 'eisa': add driver hp100
[    7.928140] bus: 'pci': add driver hp100
[    7.932140] initcall hp100_module_init+0x0/0x46 returned 0 after 7812 usecs
[    7.936017] calling  init_nic+0x0/0x16 @ 1
[    7.940017] bus: 'pci': add driver forcedeth
[    7.944033] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
[    7.948016] bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
[    7.952038] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.62.
[    7.956075] forcedeth 0000:00:0a.0: setting latency timer to 64
[    7.960137] nv_probe: set workaround bit for reversed mac addr
[    8.484210] device: 'eth0': device_add
[    8.488550] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[    8.492019] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[    8.496027] driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
[    8.500019] bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
[    8.504140] initcall init_nic+0x0/0x16 returned 0 after 550781 usecs
[    8.508019] calling  ppp_init+0x0/0x8a @ 1
[    8.512017] PPP generic driver version 2.4.2
[    8.516025] device class 'ppp': registering
[    8.520142] device: 'ppp': device_add
[    8.524142] initcall ppp_init+0x0/0x8a returned 0 after 11718 usecs
[    8.528018] calling  ppp_async_init+0x0/0x2d @ 1
[    8.532019] initcall ppp_async_init+0x0/0x2d returned 0 after 0 usecs
[    8.536018] calling  ppp_sync_init+0x0/0x2d @ 1
[    8.540019] initcall ppp_sync_init+0x0/0x2d returned 0 after 0 usecs
[    8.544018] calling  deflate_init+0x0/0x30 @ 1
[    8.548039] PPP Deflate Compression module registered
[    8.552019] initcall deflate_init+0x0/0x30 returned 0 after 3906 usecs
[    8.556018] calling  bsdcomp_init+0x0/0x26 @ 1
[    8.560018] PPP BSD Compression module registered
[    8.564018] initcall bsdcomp_init+0x0/0x26 returned 0 after 3906 usecs
[    8.568018] calling  ppp_mppe_init+0x0/0xcf @ 1
[    8.572226] PPP MPPE Compression module registered
[    8.576019] initcall ppp_mppe_init+0x0/0xcf returned 0 after 3906 usecs
[    8.580018] calling  macvlan_init_module+0x0/0x45 @ 1
[    8.584021] initcall macvlan_init_module+0x0/0x45 returned 0 after 0 usecs
[    8.588018] calling  cp_init+0x0/0x16 @ 1
[    8.592019] bus: 'pci': add driver 8139cp
[    8.596039] bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139cp
[    8.600017] bus: 'pci': really_probe: probing driver 8139cp with device 0000:05:07.0
[    8.604037] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    8.608019] 8139cp 0000:05:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[    8.612144] initcall cp_init+0x0/0x16 returned 0 after 19531 usecs
[    8.616019] calling  rtl8139_init_module+0x0/0x16 @ 1
[    8.620018] bus: 'pci': add driver 8139too
[    8.624038] bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139too
[    8.628017] bus: 'pci': really_probe: probing driver 8139too with device 0000:05:07.0
[    8.632034] 8139too Fast Ethernet driver 0.9.28
[    8.636363] device: 'eth1': device_add
[    8.640537] eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 11
[    8.644018] eth1:  Identified 8139 chip type 'RTL-8139B'
[    8.648026] driver: '0000:05:07.0': driver_bound: bound to device '8139too'
[    8.652019] bus: 'pci': really_probe: bound device 0000:05:07.0 to driver 8139too
[    8.660040] initcall rtl8139_init_module+0x0/0x16 returned 0 after 39062 usecs
[    8.664018] calling  znet_probe+0x0/0x2f2 @ 1
[    8.676260] initcall znet_probe+0x0/0x2f2 returned -19 after 7812 usecs
[    8.680018] calling  sc92031_init+0x0/0x20 @ 1
[    8.684017] Silan SC92031 PCI Fast Ethernet Adapter driver 2.0c
[    8.688018] bus: 'pci': add driver sc92031
[    8.692140] initcall sc92031_init+0x0/0x20 returned 0 after 7812 usecs
[    8.696019] calling  rio_init+0x0/0x16 @ 1
[    8.700019] bus: 'pci': add driver dl2k
[    8.704141] initcall rio_init+0x0/0x16 returned 0 after 3906 usecs
[    8.708019] calling  rtl8169_init_module+0x0/0x16 @ 1
[    8.712020] bus: 'pci': add driver r8169
[    8.716140] initcall rtl8169_init_module+0x0/0x16 returned 0 after 3906 usecs
[    8.720019] calling  hdlc_module_init+0x0/0x37 @ 1
[    8.724017] HDLC support module revision 1.22
[    8.728021] initcall hdlc_module_init+0x0/0x37 returned 0 after 3906 usecs
[    8.732018] calling  mod_init+0x0/0x11 @ 1
[    8.736019] initcall mod_init+0x0/0x11 returned 0 after 0 usecs
[    8.740025] calling  mod_init+0x0/0x43 @ 1
[    8.744019] initcall mod_init+0x0/0x43 returned 0 after 0 usecs
[    8.748018] calling  init_dlci+0x0/0x2a @ 1
[    8.752048] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    8.756019] initcall init_dlci+0x0/0x2a returned 0 after 3906 usecs
[    8.760018] calling  init_sdla+0x0/0x57 @ 1
[    8.764017] SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org.
[    8.768029] sdla0 (): not using net_device_ops yet
[    8.772018] device: 'sdla0': device_add
[    8.776572] initcall init_sdla+0x0/0x57 returned 0 after 11718 usecs
[    8.780019] calling  c101_init+0x0/0xa4 @ 1
[    8.784019] initcall c101_init+0x0/0xa4 returned -22 after 0 usecs
[    8.788019] initcall c101_init+0x0/0xa4 returned with error code -22 
[    8.792018] calling  wanxl_init_module+0x0/0x16 @ 1
[    8.796019] bus: 'pci': add driver wanXL
[    8.800140] initcall wanxl_init_module+0x0/0x16 returned 0 after 3906 usecs
[    8.804019] calling  pc300_init_module+0x0/0x5b @ 1
[    8.808019] bus: 'pci': add driver PC300
[    8.812141] initcall pc300_init_module+0x0/0x5b returned 0 after 3906 usecs
[    8.816019] calling  arcnet_init+0x0/0x50 @ 1
[    8.820017] arcnet loaded.
[    8.824019] initcall arcnet_init+0x0/0x50 returned 0 after 3906 usecs
[    8.828018] calling  arcnet_rfc1201_init+0x0/0x65 @ 1
[    8.832017] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    8.836019] initcall arcnet_rfc1201_init+0x0/0x65 returned 0 after 3906 usecs
[    8.840018] calling  arcnet_rfc1051_init+0x0/0x3d @ 1
[    8.844017] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    8.848019] initcall arcnet_rfc1051_init+0x0/0x3d returned 0 after 3906 usecs
[    8.852018] calling  arcnet_raw_init+0x0/0x52 @ 1
[    8.856017] arcnet: raw mode (`r') encapsulation support loaded.
[    8.860020] initcall arcnet_raw_init+0x0/0x52 returned 0 after 3906 usecs
[    8.864018] calling  arc_rimi_init+0x0/0x6f @ 1
[    8.868038] arcnet: RIM I (entirely mem-mapped) support
[    8.872017] E-mail me if you actually test the RIM I driver, please!
[    8.876018]  arc%d: Given: node 00h, shmem 0h, irq 0
[    8.880017]  arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
[    8.884031] initcall arc_rimi_init+0x0/0x6f returned -5 after 15625 usecs
[    8.888019] initcall arc_rimi_init+0x0/0x6f returned with error code -5 
[    8.892018] calling  pegasus_init+0x0/0x3b @ 1
[    8.896018] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    8.900019] bus: 'usb': add driver pegasus
[    8.904140] usbcore: registered new interface driver pegasus
[    8.908024] initcall pegasus_init+0x0/0x3b returned 0 after 11718 usecs
[    8.912020] calling  init_orinoco+0x0/0x16 @ 1
[    8.916018] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[    8.920019] initcall init_orinoco+0x0/0x16 returned 0 after 3906 usecs
[    8.924019] calling  init_hermes+0x0/0x7 @ 1
[    8.928019] initcall init_hermes+0x0/0x7 returned 0 after 0 usecs
[    8.932019] calling  init_hermes_dld+0x0/0x7 @ 1
[    8.936019] initcall init_hermes_dld+0x0/0x7 returned 0 after 0 usecs
[    8.940019] calling  orinoco_tmd_init+0x0/0x25 @ 1
[    8.944017] orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
[    8.948020] bus: 'pci': add driver orinoco_tmd
[    8.952141] initcall orinoco_tmd_init+0x0/0x25 returned 0 after 7812 usecs
[    8.956020] calling  airo_init_module+0x0/0xce @ 1
[    8.960032] airo(): Probing for PCI adapters
[    8.964019] bus: 'pci': add driver airo
[    8.968141] airo(): Finished probing for PCI adapters
[    8.972020] initcall airo_init_module+0x0/0xce returned 0 after 11718 usecs
[    8.976019] calling  w840_init+0x0/0x20 @ 1
[    8.980017] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    8.980021]   http://www.scyld.com/network/drivers.html
[    8.984019] bus: 'pci': add driver winbond-840
[    8.988141] initcall w840_init+0x0/0x20 returned 0 after 7812 usecs
[    8.992020] calling  mkiss_init_driver+0x0/0x36 @ 1
[    8.996028] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    9.000020] initcall mkiss_init_driver+0x0/0x36 returned 0 after 3906 usecs
[    9.004019] calling  sixpack_init_driver+0x0/0x38 @ 1
[    9.008017] AX.25: 6pack driver, Revision: 0.3.0
[    9.012021] initcall sixpack_init_driver+0x0/0x38 returned 0 after 3906 usecs
[    9.016019] calling  yam_init_driver+0x0/0xe3 @ 1
[    9.020017] YAM driver version 0.8 by F1OAT/F6FBB
[    9.024039] yam0 (): not using net_device_ops yet
[    9.028019] device: 'yam0': device_add
[    9.032622] yam1 (): not using net_device_ops yet
[    9.036020] device: 'yam1': device_add
[    9.044097] yam2 (): not using net_device_ops yet
[    9.048019] device: 'yam2': device_add
[    9.052698] yam3 (): not using net_device_ops yet
[    9.056020] device: 'yam3': device_add
[    9.060713] initcall yam_init_driver+0x0/0xe3 returned 0 after 39062 usecs
[    9.064020] calling  init_netconsole+0x0/0x1b0 @ 1
[    9.068233] console [netcon0] enabled
[    9.072019] netconsole: network logging started
[    9.076021] initcall init_netconsole+0x0/0x1b0 returned 0 after 7812 usecs
[    9.080019] calling  zatm_init_module+0x0/0x16 @ 1
[    9.084022] bus: 'pci': add driver zatm
[    9.088142] initcall zatm_init_module+0x0/0x16 returned 0 after 3906 usecs
[    9.092021] calling  uPD98402_module_init+0x0/0x7 @ 1
[    9.096020] initcall uPD98402_module_init+0x0/0x7 returned 0 after 0 usecs
[    9.100020] calling  hrz_module_init+0x0/0xba @ 1
[    9.104018] Madge ATM Horizon [Ultra] driver version 1.2.1
[    9.108019] hrz: debug bitmap is 0
[    9.112021] bus: 'pci': add driver horizon
[    9.116141] initcall hrz_module_init+0x0/0xba returned 0 after 11718 usecs
[    9.120020] calling  ia_module_init+0x0/0x48 @ 1
[    9.124021] bus: 'pci': add driver ia
[    9.128141] initcall ia_module_init+0x0/0x48 returned 0 after 3906 usecs
[    9.132021] calling  eni_init+0x0/0x16 @ 1
[    9.136020] bus: 'pci': add driver eni
[    9.140142] initcall eni_init+0x0/0x16 returned 0 after 3906 usecs
[    9.144020] calling  he_init+0x0/0x16 @ 1
[    9.148022] bus: 'pci': add driver he
[    9.152141] initcall he_init+0x0/0x16 returned 0 after 3906 usecs
[    9.156021] calling  mac_hid_init+0x0/0xb3 @ 1
[    9.160037] device: 'input0': device_add
[    9.164165] input: Macintosh mouse button emulation as /class/input/input0
[    9.168088] initcall mac_hid_init+0x0/0xb3 returned 0 after 7812 usecs
[    9.172020] calling  scsi_tgt_init+0x0/0x7d @ 1
[    9.176262] device: 'tgt': device_add
[    9.180146] initcall scsi_tgt_init+0x0/0x7d returned 0 after 3906 usecs
[    9.184020] calling  raid_init+0x0/0xf @ 1
[    9.188020] device class 'raid_devices': registering
[    9.192142] initcall raid_init+0x0/0xf returned 0 after 3906 usecs
[    9.196021] calling  spi_transport_init+0x0/0x27 @ 1
[    9.200018] device class 'spi_transport': registering
[    9.204142] device class 'spi_host': registering
[    9.208144] initcall spi_transport_init+0x0/0x27 returned 0 after 7812 usecs
[    9.212022] calling  iscsi_transport_init+0x0/0x125 @ 1
[    9.216018] Loading iSCSI transport class v2.0-870.
[    9.220019] device class 'iscsi_transport': registering
[    9.224142] device class 'iscsi_endpoint': registering
[    9.228142] device class 'iscsi_host': registering
[    9.232141] device class 'iscsi_connection': registering
[    9.236144] device class 'iscsi_session': registering
[    9.240150] initcall iscsi_transport_init+0x0/0x125 returned 0 after 23437 usecs
[    9.244021] calling  sas_transport_init+0x0/0x9f @ 1
[    9.248019] device class 'sas_host': registering
[    9.256036] device class 'sas_phy': registering
[    9.260142] device class 'sas_port': registering
[    9.264143] device class 'sas_device': registering
[    9.268141] device class 'sas_end_device': registering
[    9.272144] device class 'sas_expander': registering
[    9.276142] initcall sas_transport_init+0x0/0x9f returned 0 after 27343 usecs
[    9.280020] calling  srp_transport_init+0x0/0x33 @ 1
[    9.284020] device class 'srp_host': registering
[    9.288142] device class 'srp_remote_ports': registering
[    9.292142] initcall srp_transport_init+0x0/0x33 returned 0 after 7812 usecs
[    9.296020] calling  ahc_linux_init+0x0/0x61 @ 1
[    9.300030] bus: 'pci': add driver aic7xxx
[    9.304142] bus: 'eisa': add driver aic7xxx
[    9.308144] initcall ahc_linux_init+0x0/0x61 returned 0 after 7812 usecs
[    9.312021] calling  init_st+0x0/0xe2 @ 1
[    9.316020] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[    9.320019] device class 'scsi_tape': registering
[    9.324142] Driver 'st' needs updating - please use bus_type methods
[    9.328019] bus: 'scsi': add driver st
[    9.332141] initcall init_st+0x0/0xe2 returned 0 after 15625 usecs
[    9.336020] calling  init_osst+0x0/0x10f @ 1
[    9.340020] osst :I: Tape driver with OnStream support version 0.99.4
[    9.340023] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    9.344019] device class 'onstream_tape': registering
[    9.348139] Driver 'osst' needs updating - please use bus_type methods
[    9.352019] bus: 'scsi': add driver osst
[    9.356142] initcall init_osst+0x0/0x10f returned 0 after 15625 usecs
[    9.360020] calling  init_sd+0x0/0xdb @ 1
[    9.364043] device class 'scsi_disk': registering
[    9.368142] Driver 'sd' needs updating - please use bus_type methods
[    9.372020] bus: 'scsi': add driver sd
[    9.376142] initcall init_sd+0x0/0xdb returned 0 after 11718 usecs
[    9.380021] calling  ahci_init+0x0/0x16 @ 1
[    9.384021] bus: 'pci': add driver ahci
[    9.388142] initcall ahci_init+0x0/0x16 returned 0 after 3906 usecs
[    9.392020] calling  k2_sata_init+0x0/0x16 @ 1
[    9.396022] bus: 'pci': add driver sata_svw
[    9.400142] initcall k2_sata_init+0x0/0x16 returned 0 after 3906 usecs
[    9.404021] calling  piix_init+0x0/0x24 @ 1
[    9.408021] bus: 'pci': add driver ata_piix
[    9.412142] initcall piix_init+0x0/0x24 returned 0 after 3906 usecs
[    9.416020] calling  qs_ata_init+0x0/0x16 @ 1
[    9.420022] bus: 'pci': add driver sata_qstor
[    9.424142] initcall qs_ata_init+0x0/0x16 returned 0 after 3906 usecs
[    9.428022] calling  sil_init+0x0/0x16 @ 1
[    9.432021] bus: 'pci': add driver sata_sil
[    9.436146] initcall sil_init+0x0/0x16 returned 0 after 3906 usecs
[    9.440021] calling  vsc_sata_init+0x0/0x16 @ 1
[    9.444022] bus: 'pci': add driver sata_vsc
[    9.448142] initcall vsc_sata_init+0x0/0x16 returned 0 after 3906 usecs
[    9.452021] calling  nv_init+0x0/0x16 @ 1
[    9.456022] bus: 'pci': add driver sata_nv
[    9.460141] initcall nv_init+0x0/0x16 returned 0 after 3906 usecs
[    9.464020] calling  uli_init+0x0/0x16 @ 1
[    9.468022] bus: 'pci': add driver sata_uli
[    9.472142] initcall uli_init+0x0/0x16 returned 0 after 3906 usecs
[    9.476021] calling  mv_init+0x0/0x3a @ 1
[    9.480022] bus: 'pci': add driver sata_mv
[    9.484146] bus: 'platform': add driver sata_mv
[    9.488143] initcall mv_init+0x0/0x3a returned 0 after 7812 usecs
[    9.492021] calling  amd_init+0x0/0x16 @ 1
[    9.496022] bus: 'pci': add driver pata_amd
[    9.500036] bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
[    9.504019] bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
[    9.508051] pata_amd 0000:00:06.0: version 0.4.1
[    9.512169] pata_amd 0000:00:06.0: setting latency timer to 64
[    9.516289] scsi0 : pata_amd
[    9.520301] device: 'host0': device_add
[    9.524031] device: 'host0': device_add
[    9.528152] scsi1 : pata_amd
[    9.532024] device: 'host1': device_add
[    9.536029] device: 'host1': device_add
[    9.540146] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    9.544020] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    9.720318] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[    9.728023] ata1.00: 488397168 sectors, multi 1: LBA48 
[    9.732049] ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[    9.764244] ata1.00: configured for UDMA/100
[    9.768028] async_waiting @ 12
[    9.772029] async_continuing @ 12 after 0 usec
[    9.776342] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[    9.780023] device: 'target0:0:0': device_add
[    9.784030] device: '0:0:0:0': device_add
[    9.788069] bus: 'scsi': add device 0:0:0:0
[    9.792148] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver st
[    9.796021] bus: 'scsi': really_probe: probing driver st with device 0:0:0:0
[    9.800051] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver osst
[    9.804020] bus: 'scsi': really_probe: probing driver osst with device 0:0:0:0
[    9.808047] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[    9.812027] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[    9.816137] device: '0:0:0:0': device_add
[    9.820170] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[    9.824084] sd 0:0:0:0: [sda] Write Protect is off
[    9.828021] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.832136] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.836028] device: 'sda': device_add
[    9.840273] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[    9.844081] sd 0:0:0:0: [sda] Write Protect is off
[    9.848020] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.852134] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.856041]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    9.940765] device: 'sda1': device_add
[    9.944084] device: 'sda2': device_add
[    9.948080] device: 'sda3': device_add
[    9.952089] device: 'sda5': device_add
[    9.956027] device: 'sda6': device_add
[    9.959755] device: 'sda7': device_add
[    9.960092] device: 'sda8': device_add
[    9.964093] device: 'sda9': device_add
[    9.968090] device: 'sda10': device_add
[    9.976209] device: '8:0': device_add
[    9.980148] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.984021] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[    9.988107] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[    9.992022] device: '0:0:0:0': device_add
[    9.996159] device: '0:0:0:0': device_add
[   10.000143] async_waiting @ 12
[   10.004218] async_continuing @ 12 after 0 usec
[   10.176313] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[   10.184048] ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[   10.208226] ata2.01: configured for UDMA/33
[   10.216035] async_waiting @ 12
[   10.218946] async_continuing @ 12 after 0 usec
[   10.220182] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   10.224027] device: 'target1:0:1': device_add
[   10.228034] device: '1:0:1:0': device_add
[   10.232069] bus: 'scsi': add device 1:0:1:0
[   10.236147] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver st
[   10.240020] bus: 'scsi': really_probe: probing driver st with device 1:0:1:0
[   10.244050] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver osst
[   10.248020] bus: 'scsi': really_probe: probing driver osst with device 1:0:1:0
[   10.252047] bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
[   10.256020] bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
[   10.260047] device: '1:0:1:0': device_add
[   10.264143] device: '1:0:1:0': device_add
[   10.268152] driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
[   10.272022] bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
[   10.276144] initcall amd_init+0x0/0x16 returned 0 after 761720 usecs
[   10.280023] calling  cs5535_init+0x0/0x16 @ 1
[   10.284027] bus: 'pci': add driver cs5535
[   10.288143] initcall cs5535_init+0x0/0x16 returned 0 after 3906 usecs
[   10.292023] calling  efar_init+0x0/0x16 @ 1
[   10.296024] bus: 'pci': add driver pata_efar
[   10.300144] initcall efar_init+0x0/0x16 returned 0 after 3906 usecs
[   10.304022] calling  jmicron_init+0x0/0x16 @ 1
[   10.308025] bus: 'pci': add driver pata_jmicron
[   10.312143] initcall jmicron_init+0x0/0x16 returned 0 after 3906 usecs
[   10.316023] calling  oldpiix_init+0x0/0x16 @ 1
[   10.320024] bus: 'pci': add driver pata_oldpiix
[   10.324143] initcall oldpiix_init+0x0/0x16 returned 0 after 3906 usecs
[   10.328022] calling  pdc202xx_init+0x0/0x16 @ 1
[   10.332025] bus: 'pci': add driver pata_pdc202xx_old
[   10.336143] initcall pdc202xx_init+0x0/0x16 returned 0 after 3906 usecs
[   10.340023] calling  rz1000_init+0x0/0x16 @ 1
[   10.344024] bus: 'pci': add driver pata_rz1000
[   10.352044] initcall rz1000_init+0x0/0x16 returned 0 after 7812 usecs
[   10.356023] calling  serverworks_init+0x0/0x16 @ 1
[   10.360024] bus: 'pci': add driver pata_serverworks
[   10.368143] initcall serverworks_init+0x0/0x16 returned 0 after 7812 usecs
[   10.372023] calling  sil680_init+0x0/0x16 @ 1
[   10.376024] bus: 'pci': add driver pata_sil680
[   10.380143] initcall sil680_init+0x0/0x16 returned 0 after 3906 usecs
[   10.384022] calling  via_init+0x0/0x16 @ 1
[   10.388025] bus: 'pci': add driver pata_via
[   10.392143] initcall via_init+0x0/0x16 returned 0 after 3906 usecs
[   10.396024] calling  winbond_init+0x0/0xca @ 1
[   10.400022] initcall winbond_init+0x0/0xca returned -19 after 0 usecs
[   10.404022] calling  ata_generic_init+0x0/0x16 @ 1
[   10.408024] bus: 'pci': add driver ata_generic
[   10.412144] initcall ata_generic_init+0x0/0x16 returned 0 after 3906 usecs
[   10.416023] calling  legacy_init+0x0/0x1e5 @ 1
[   10.420171] initcall legacy_init+0x0/0x1e5 returned -19 after 0 usecs
[   10.424022] calling  fusion_init+0x0/0x10c @ 1
[   10.428022] Fusion MPT base driver 3.04.07
[   10.432020] Copyright (c) 1999-2008 LSI Corporation
[   10.436051] initcall fusion_init+0x0/0x10c returned 0 after 7812 usecs
[   10.440022] calling  mptspi_init+0x0/0xb9 @ 1
[   10.444022] Fusion MPT SPI Host driver 3.04.07
[   10.448041] bus: 'pci': add driver mptspi
[   10.452144] initcall mptspi_init+0x0/0xb9 returned 0 after 7812 usecs
[   10.456023] calling  fw_core_init+0x0/0x9b @ 1
[   10.460144] bus: 'firewire': registered
[   10.464090] initcall fw_core_init+0x0/0x9b returned 0 after 3906 usecs
[   10.468023] calling  uio_init+0x0/0x7 @ 1
[   10.472031] initcall uio_init+0x0/0x7 returned 0 after 0 usecs
[   10.476023] calling  uio_pdrv_init+0x0/0xf @ 1
[   10.480022] bus: 'platform': add driver uio_pdrv
[   10.484143] initcall uio_pdrv_init+0x0/0xf returned 0 after 3906 usecs
[   10.488023] calling  sercos3_init_module+0x0/0x16 @ 1
[   10.492026] bus: 'pci': add driver sercos3
[   10.496144] initcall sercos3_init_module+0x0/0x16 returned 0 after 3906 usecs
[   10.500024] calling  aoe_init+0x0/0x9d @ 1
[   10.504030] device class 'aoe': registering
[   10.508144] device: 'err': device_add
[   10.512147] device: 'discover': device_add
[   10.516143] device: 'interfaces': device_add
[   10.520111] device: 'revalidate': device_add
[   10.524143] device: 'flush': device_add
[   10.528277] aoe: AoE v47 initialised.
[   10.532170] initcall aoe_init+0x0/0x9d returned 0 after 27343 usecs
[   10.536022] calling  uwb_subsys_init+0x0/0x46 @ 1
[   10.540050] device class 'uwb_rc': registering
[   10.544145] initcall uwb_subsys_init+0x0/0x46 returned 0 after 3906 usecs
[   10.548024] calling  hwarc_driver_init+0x0/0x16 @ 1
[   10.552023] bus: 'usb': add driver hwa-rc
[   10.556145] usbcore: registered new interface driver hwa-rc
[   10.560027] initcall hwarc_driver_init+0x0/0x16 returned 0 after 7812 usecs
[   10.564023] calling  mon_init+0x0/0xef @ 1
[   10.572025] device class 'usbmon': registering
[   10.576145] device: 'usbmon0': device_add
[   10.580144] initcall mon_init+0x0/0xef returned 0 after 11718 usecs
[   10.584023] calling  ehci_hcd_init+0x0/0xbe @ 1
[   10.588022] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.592021] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[   10.596035] bus: 'pci': add driver ehci_hcd
[   10.600035] bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
[   10.604022] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
[   10.608072] ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
[   10.612025] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[   10.616032] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[   10.620145] initcall ehci_hcd_init+0x0/0xbe returned 0 after 31250 usecs
[   10.624023] calling  ohci_hcd_mod_init+0x0/0x93 @ 1
[   10.628022] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   10.632020] ohci_hcd: block sizes: ed 64 td 64
[   10.636034] bus: 'pci': add driver ohci_hcd
[   10.640033] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
[   10.644022] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
[   10.648065] ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[   10.652023] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[   10.656031] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[   10.664044] initcall ohci_hcd_mod_init+0x0/0x93 returned 0 after 35156 usecs
[   10.668023] calling  uhci_hcd_init+0x0/0x106 @ 1
[   10.672021] uhci_hcd: USB Universal Host Controller Interface driver
[   10.676269] bus: 'pci': add driver uhci_hcd
[   10.680145] initcall uhci_hcd_init+0x0/0x106 returned 0 after 7812 usecs
[   10.684024] calling  hwahc_driver_init+0x0/0x16 @ 1
[   10.688022] bus: 'usb': add driver hwa-hc
[   10.692145] usbcore: registered new interface driver hwa-hc
[   10.696038] initcall hwahc_driver_init+0x0/0x16 returned 0 after 7812 usecs
[   10.700024] calling  wusbcore_init+0x0/0x6c @ 1
[   10.704143] initcall wusbcore_init+0x0/0x6c returned 0 after 0 usecs
[   10.708024] calling  usb_usual_init+0x0/0x32 @ 1
[   10.712057] bus: 'usb': add driver libusual
[   10.716149] usbcore: registered new interface driver libusual
[   10.720028] initcall usb_usual_init+0x0/0x32 returned 0 after 7812 usecs
[   10.724023] calling  microtek_drv_init+0x0/0x16 @ 1
[   10.728033] bus: 'usb': add driver microtekX6
[   10.736143] usbcore: registered new interface driver microtekX6
[   10.740028] initcall microtek_drv_init+0x0/0x16 returned 0 after 11718 usecs
[   10.744022] calling  usb_serial_init+0x0/0x1cc @ 1
[   10.748147] bus: 'usb-serial': registered
[   10.752045] bus: 'usb': add driver usbserial
[   10.756143] usbcore: registered new interface driver usbserial
[   10.760023] bus: 'usb-serial': add driver generic
[   10.764147] USB Serial support registered for generic
[   10.768022] bus: 'usb': add driver usbserial_generic
[   10.772144] usbcore: registered new interface driver usbserial_generic
[   10.776021] usbserial: USB Serial Driver core
[   10.780025] initcall usb_serial_init+0x0/0x1cc returned 0 after 31250 usecs
[   10.784023] calling  aircable_init+0x0/0x3a @ 1
[   10.788023] bus: 'usb-serial': add driver aircable
[   10.792147] USB Serial support registered for aircable
[   10.796024] bus: 'usb': add driver aircable
[   10.800144] usbcore: registered new interface driver aircable
[   10.804026] initcall aircable_init+0x0/0x3a returned 0 after 15625 usecs
[   10.808023] calling  ark3116_init+0x0/0x3a @ 1
[   10.812025] bus: 'usb-serial': add driver ark3116
[   10.816147] USB Serial support registered for ark3116
[   10.820029] bus: 'usb': add driver ark3116
[   10.824144] usbcore: registered new interface driver ark3116
[   10.828025] initcall ark3116_init+0x0/0x3a returned 0 after 15625 usecs
[   10.832023] calling  belkin_sa_init+0x0/0x49 @ 1
[   10.836023] bus: 'usb-serial': add driver belkin
[   10.840147] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   10.844024] bus: 'usb': add driver belkin
[   10.848144] usbcore: registered new interface driver belkin
[   10.852022] belkin_sa: v1.2:USB Belkin Serial converter driver
[   10.856023] initcall belkin_sa_init+0x0/0x49 returned 0 after 19531 usecs
[   10.860024] calling  cp2101_init+0x0/0x49 @ 1
[   10.864022] bus: 'usb-serial': add driver cp2101
[   10.868147] USB Serial support registered for cp2101
[   10.872023] bus: 'usb': add driver cp2101
[   10.876144] usbcore: registered new interface driver cp2101
[   10.880022] cp2101: v0.07:Silicon Labs CP2101/CP2102 RS232 serial adaptor driver
[   10.884024] initcall cp2101_init+0x0/0x49 returned 0 after 19531 usecs
[   10.888023] calling  cypress_init+0x0/0x9d @ 1
[   10.892023] drivers/usb/serial/cypress_m8.c: cypress_init
[   10.896022] bus: 'usb-serial': add driver earthmate
[   10.900147] USB Serial support registered for DeLorme Earthmate USB
[   10.904023] bus: 'usb-serial': add driver cyphidcom
[   10.908144] USB Serial support registered for HID->COM RS232 Adapter
[   10.912024] bus: 'usb-serial': add driver nokiaca42v2
[   10.916148] USB Serial support registered for Nokia CA-42 V2 Adapter
[   10.920023] bus: 'usb': add driver cypress
[   10.924144] usbcore: registered new interface driver cypress
[   10.928021] cypress_m8: v1.09:Cypress USB to Serial Driver
[   10.932025] initcall cypress_init+0x0/0x9d returned 0 after 39062 usecs
[   10.936023] calling  debug_init+0x0/0x3a @ 1
[   10.940024] bus: 'usb-serial': add driver debug
[   10.944147] USB Serial support registered for debug
[   10.948024] bus: 'usb': add driver debug
[   10.952192] usbcore: registered new interface driver debug
[   10.956025] initcall debug_init+0x0/0x3a returned 0 after 15625 usecs
[   10.960023] calling  edgeport_init+0x0/0xa5 @ 1
[   10.964024] bus: 'usb-serial': add driver edgeport_2
[   10.968148] USB Serial support registered for Edgeport 2 port adapter
[   10.972024] bus: 'usb-serial': add driver edgeport_4
[   10.976144] USB Serial support registered for Edgeport 4 port adapter
[   10.980024] bus: 'usb-serial': add driver edgeport_8
[   10.984148] USB Serial support registered for Edgeport 8 port adapter
[   10.988024] bus: 'usb-serial': add driver epic
[   10.992144] USB Serial support registered for EPiC device
[   10.996024] bus: 'usb': add driver io_edgeport
[   11.000147] usbcore: registered new interface driver io_edgeport
[   11.004023] io_edgeport: v2.7:Edgeport USB Serial Driver
[   11.008024] initcall edgeport_init+0x0/0xa5 returned 0 after 42968 usecs
[   11.012025] calling  usb_ipw_init+0x0/0x49 @ 1
[   11.016023] bus: 'usb-serial': add driver ipw
[   11.020144] USB Serial support registered for IPWireless converter
[   11.024023] bus: 'usb': add driver ipwtty
[   11.028148] usbcore: registered new interface driver ipwtty
[   11.032022] ipw: v0.3:IPWireless tty driver
[   11.036025] initcall usb_ipw_init+0x0/0x49 returned 0 after 19531 usecs
[   11.040023] calling  ir_init+0x0/0x49 @ 1
[   11.044024] bus: 'usb-serial': add driver ir-usb
[   11.048144] USB Serial support registered for IR Dongle
[   11.052024] bus: 'usb': add driver ir-usb
[   11.060039] usbcore: registered new interface driver ir-usb
[   11.064022] ir_usb: v0.4:USB IR Dongle driver
[   11.068025] initcall ir_init+0x0/0x49 returned 0 after 23437 usecs
[   11.072023] calling  keyspan_pda_init+0x0/0x7d @ 1
[   11.076024] bus: 'usb-serial': add driver keyspan_pda
[   11.080145] USB Serial support registered for Keyspan PDA
[   11.084024] bus: 'usb-serial': add driver keyspan_pda_pre
[   11.088146] USB Serial support registered for Keyspan PDA - (prerenumeration)
[   11.092024] bus: 'usb-serial': add driver xircom_no_firm
[   11.096145] USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[   11.100024] bus: 'usb': add driver keyspan_pda
[   11.104146] usbcore: registered new interface driver keyspan_pda
[   11.108024] keyspan_pda: v1.1:USB Keyspan PDA Converter driver
[   11.112025] initcall keyspan_pda_init+0x0/0x7d returned 0 after 35156 usecs
[   11.116024] calling  moto_init+0x0/0x3a @ 1
[   11.120023] bus: 'usb-serial': add driver moto-modem
[   11.124145] USB Serial support registered for moto-modem
[   11.128024] bus: 'usb': add driver moto-modem
[   11.132146] usbcore: registered new interface driver moto-modem
[   11.136025] initcall moto_init+0x0/0x3a returned 0 after 15625 usecs
[   11.140024] calling  omninet_init+0x0/0x49 @ 1
[   11.144023] bus: 'usb-serial': add driver omninet
[   11.148145] USB Serial support registered for ZyXEL - omni.net lcd plus usb
[   11.152024] bus: 'usb': add driver omninet
[   11.160146] usbcore: registered new interface driver omninet
[   11.164023] omninet: v1.1:USB ZyXEL omni.net LCD PLUS Driver
[   11.168024] initcall omninet_init+0x0/0x49 returned 0 after 23437 usecs
[   11.172024] calling  oti6858_init+0x0/0x3a @ 1
[   11.176023] bus: 'usb-serial': add driver oti6858
[   11.180124] USB Serial support registered for oti6858
[   11.184024] bus: 'usb': add driver oti6858
[   11.188146] usbcore: registered new interface driver oti6858
[   11.192025] initcall oti6858_init+0x0/0x3a returned 0 after 15625 usecs
[   11.196024] calling  safe_init+0x0/0xb4 @ 1
[   11.200021] safe_serial: v0.0b:USB Safe Encapsulated Serial
[   11.204024] bus: 'usb-serial': add driver safe_serial
[   11.208145] USB Serial support registered for safe_serial
[   11.212026] bus: 'usb': add driver safe_serial
[   11.216146] usbcore: registered new interface driver safe_serial
[   11.220026] initcall safe_init+0x0/0xb4 returned 0 after 19531 usecs
[   11.224023] calling  spcp8x5_init+0x0/0x49 @ 1
[   11.228024] bus: 'usb-serial': add driver SPCP8x5
[   11.232145] USB Serial support registered for SPCP8x5
[   11.236025] bus: 'usb': add driver spcp8x5
[   11.240146] usbcore: registered new interface driver spcp8x5
[   11.244023] spcp8x5: v0.04:SPCP8x5 USB to serial adaptor driver
[   11.248024] initcall spcp8x5_init+0x0/0x49 returned 0 after 19531 usecs
[   11.252024] calling  ti_init+0x0/0x130 @ 1
[   11.256024] bus: 'usb-serial': add driver ti_usb_3410_5052_1
[   11.260145] USB Serial support registered for TI USB 3410 1 port adapter
[   11.264024] bus: 'usb-serial': add driver ti_usb_3410_5052_2
[   11.268146] USB Serial support registered for TI USB 5052 2 port adapter
[   11.272024] bus: 'usb': add driver ti_usb_3410_5052
[   11.276145] usbcore: registered new interface driver ti_usb_3410_5052
[   11.280022] ti_usb_3410_5052: v0.9:TI USB 3410/5052 Serial Driver
[   11.284025] initcall ti_init+0x0/0x130 returned 0 after 27343 usecs
[   11.288023] calling  whiteheat_init+0x0/0x63 @ 1
[   11.292024] bus: 'usb-serial': add driver whiteheatnofirm
[   11.296146] USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[   11.300025] bus: 'usb-serial': add driver whiteheat
[   11.304145] USB Serial support registered for Connect Tech - WhiteHEAT
[   11.308026] bus: 'usb': add driver whiteheat
[   11.312146] usbcore: registered new interface driver whiteheat
[   11.316024] whiteheat: v2.0:USB ConnectTech WhiteHEAT driver
[   11.320024] initcall whiteheat_init+0x0/0x63 returned 0 after 27343 usecs
[   11.324024] calling  appledisplay_init+0x0/0x51 @ 1
[   11.328092] bus: 'usb': add driver appledisplay
[   11.332148] usbcore: registered new interface driver appledisplay
[   11.336028] initcall appledisplay_init+0x0/0x51 returned 0 after 7812 usecs
[   11.340024] calling  berry_init+0x0/0x16 @ 1
[   11.344024] bus: 'usb': add driver berry_charge
[   11.348110] usbcore: registered new interface driver berry_charge
[   11.352028] initcall berry_init+0x0/0x16 returned 0 after 7812 usecs
[   11.356024] calling  emi26_init+0x0/0x16 @ 1
[   11.360024] bus: 'usb': add driver emi26 - firmware loader
[   11.364147] usbcore: registered new interface driver emi26 - firmware loader
[   11.368028] initcall emi26_init+0x0/0x16 returned 0 after 7812 usecs
[   11.372024] calling  ld_usb_init+0x0/0x2f @ 1
[   11.376024] bus: 'usb': add driver ldusb
[   11.380146] usbcore: registered new interface driver ldusb
[   11.384028] initcall ld_usb_init+0x0/0x2f returned 0 after 7812 usecs
[   11.388024] calling  lego_usb_tower_init+0x0/0x75 @ 1
[   11.392022] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
[   11.396024] bus: 'usb': add driver legousbtower
[   11.400145] usbcore: registered new interface driver legousbtower
[   11.404027] legousbtower: v0.96:LEGO USB Tower Driver
[   11.408022] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
[   11.412026] initcall lego_usb_tower_init+0x0/0x75 returned 0 after 19531 usecs
[   11.416023] calling  tv_init+0x0/0x3c @ 1
[   11.420025] bus: 'usb': add driver trancevibrator
[   11.424146] usbcore: registered new interface driver trancevibrator
[   11.428027] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[   11.432024] initcall tv_init+0x0/0x3c returned 0 after 11718 usecs
[   11.436025] calling  usb_sevseg_init+0x0/0x2f @ 1
[   11.440024] bus: 'usb': add driver usbsevseg
[   11.444145] usbcore: registered new interface driver usbsevseg
[   11.452033] initcall usb_sevseg_init+0x0/0x2f returned 0 after 11718 usecs
[   11.456024] calling  vstusb_init+0x0/0x35 @ 1
[   11.460025] bus: 'usb': add driver vstusb
[   11.464158] usbcore: registered new interface driver vstusb
[   11.468031] initcall vstusb_init+0x0/0x35 returned 0 after 7812 usecs
[   11.472024] calling  i8042_init+0x0/0xf7 @ 1
[   11.476027] bus: 'pnp': add driver i8042 kbd
[   11.480038] bus: 'pnp': driver_probe_device: matched device 00:04 with driver i8042 kbd
[   11.484024] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:04
[   11.488037] driver: '00:04': driver_bound: bound to device 'i8042 kbd'
[   11.492024] bus: 'pnp': really_probe: bound device 00:04 to driver i8042 kbd
[   11.496145] bus: 'pnp': add driver i8042 aux
[   11.500146] PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
[   11.504022] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   11.508078] bus: 'platform': add driver i8042
[   11.512146] Registering platform device 'i8042'. Parent at platform
[   11.516024] device: 'i8042': device_add
[   11.520033] bus: 'platform': add device i8042
[   11.524145] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   11.528023] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   11.532395] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.536031] driver: 'i8042': driver_bound: bound to device 'i8042'
[   11.536028] device: 'serio0': device_add
[   11.536059] bus: 'serio': add device serio0
[   11.540024] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   11.544027] initcall i8042_init+0x0/0xf7 returned 0 after 66406 usecs
[   11.548024] calling  l4_init+0x0/0x7c @ 1
[   11.552038] initcall l4_init+0x0/0x7c returned -19 after 0 usecs
[   11.556024] calling  ns558_init+0x0/0x4e @ 1
[   11.560023] bus: 'pnp': add driver ns558
[   11.564065] bus: 'pnp': driver_probe_device: matched device 00:10 with driver ns558
[   11.568023] bus: 'pnp': really_probe: probing driver ns558 with device 00:10
[   11.572050] driver: '00:10': driver_bound: bound to device 'ns558'
[   11.576023] bus: 'pnp': really_probe: bound device 00:10 to driver ns558
[   11.584011] gameport: NS558 PnP Gameport is pnp00:10/gameport0, io 0x201, speed 662kHz
[   11.592066] device: 'gameport0': device_add
[   11.595201] initcall ns558_init+0x0/0x4e returned 0 after 31250 usecs
[   11.595206] calling  mousedev_init+0x0/0x78 @ 1
[   11.595236] device: 'mice': device_add
[   11.612035] bus: 'gameport': add device gameport0
[   11.628085] device: 'mouse0': device_add
[   11.632082] device: 'psaux': device_add
[   11.636046] mice: PS/2 mouse device common for all mice
[   11.640025] initcall mousedev_init+0x0/0x78 returned 0 after 46875 usecs
[   11.644042] calling  joydev_init+0x0/0xf @ 1
[   11.648025] initcall joydev_init+0x0/0xf returned 0 after 0 usecs
[   11.652024] calling  evdev_init+0x0/0xf @ 1
[   11.672036] device: 'event0': device_add
[   11.676050] initcall evdev_init+0x0/0xf returned 0 after 19531 usecs
[   11.680023] calling  atkbd_init+0x0/0x20 @ 1
[   11.684028] bus: 'serio': add driver atkbd
[   11.688160] initcall atkbd_init+0x0/0x20 returned 0 after 3906 usecs
[   11.688160] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   11.688160] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   11.692025] calling  lkkbd_init+0x0/0x16 @ 1
[   11.692056] device: 'input1': device_add
[   11.696024] bus: 'serio': add driver lkkbd
[   11.700151] input: AT Translated Set 2 keyboard as /class/input/input1
[   11.704134] initcall lkkbd_init+0x0/0x16 returned 0 after 7812 usecs
[   11.708025] calling  bcm5974_init+0x0/0x16 @ 1
[   11.712027] bus: 'usb': add driver bcm5974
[   11.716175] usbcore: registered new interface driver bcm5974
[   11.720029] initcall bcm5974_init+0x0/0x16 returned 0 after 7812 usecs
[   11.724024] calling  logibm_init+0x0/0x12c @ 1
[   11.728126] logibm.c: Didn't find Logitech busmouse at 0x23c
[   11.732027] initcall logibm_init+0x0/0x12c returned -19 after 3906 usecs
[   11.736023] calling  adi_init+0x0/0x16 @ 1
[   11.740024] bus: 'gameport': add driver adi
[   11.744155] initcall adi_init+0x0/0x16 returned 0 after 3906 usecs
[   11.748025] calling  gf2k_init+0x0/0x16 @ 1
[   11.752034] bus: 'gameport': add driver gf2k
[   11.756156] initcall gf2k_init+0x0/0x16 returned 0 after 3906 usecs
[   11.760024] calling  iforce_init+0x0/0x41 @ 1
[   11.764026] bus: 'usb': add driver iforce
[   11.768166] usbcore: registered new interface driver iforce
[   11.772029] bus: 'serio': add driver iforce
[   11.772078] device: 'event1': device_add
[   11.776156] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   11.784068] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   11.788117] initcall iforce_init+0x0/0x41 returned 0 after 23437 usecs
[   11.792024] calling  interact_init+0x0/0x16 @ 1
[   11.796024] bus: 'gameport': add driver interact
[   11.800166] initcall interact_init+0x0/0x16 returned 0 after 3906 usecs
[   11.804026] calling  joydump_init+0x0/0x16 @ 1
[   11.808024] bus: 'gameport': add driver joydump
[   11.812155] initcall joydump_init+0x0/0x16 returned 0 after 3906 usecs
[   11.816024] calling  magellan_init+0x0/0x16 @ 1
[   11.820025] bus: 'serio': add driver magellan
[   11.824168] initcall magellan_init+0x0/0x16 returned 0 after 3906 usecs
[   11.828026] calling  spaceball_init+0x0/0x16 @ 1
[   11.832024] bus: 'serio': add driver spaceball
[   11.836158] initcall spaceball_init+0x0/0x16 returned 0 after 3906 usecs
[   11.840024] calling  warrior_init+0x0/0x16 @ 1
[   11.844025] bus: 'serio': add driver warrior
[   11.848158] initcall warrior_init+0x0/0x16 returned 0 after 3906 usecs
[   11.852025] calling  usb_xpad_init+0x0/0x2d @ 1
[   11.856026] bus: 'usb': add driver xpad
[   11.860171] usbcore: registered new interface driver xpad
[   11.864036] xpad: X-Box pad driver
[   11.868026] initcall usb_xpad_init+0x0/0x2d returned 0 after 11718 usecs
[   11.872024] calling  zhenhua_init+0x0/0x16 @ 1
[   11.876025] bus: 'serio': add driver zhenhua
[   11.880157] initcall zhenhua_init+0x0/0x16 returned 0 after 3906 usecs
[   11.884025] calling  usb_acecad_init+0x0/0x2d @ 1
[   11.888026] bus: 'usb': add driver usb_acecad
[   11.892153] usbcore: registered new interface driver usb_acecad
[   11.896027] acecad: v3.2:USB Acecad Flair tablet driver
[   11.900026] initcall usb_acecad_init+0x0/0x2d returned 0 after 11718 usecs
[   11.904024] calling  elo_init+0x0/0x16 @ 1
[   11.908025] bus: 'serio': add driver elo
[   11.912158] initcall elo_init+0x0/0x16 returned 0 after 3906 usecs
[   11.916026] calling  fujitsu_init+0x0/0x16 @ 1
[   11.920024] bus: 'serio': add driver fujitsu_ts
[   11.924156] initcall fujitsu_init+0x0/0x16 returned 0 after 3906 usecs
[   11.928024] calling  mk712_init+0x0/0x1b7 @ 1
[   11.932028] mk712: device not present
[   11.936027] initcall mk712_init+0x0/0x1b7 returned -19 after 3906 usecs
[   11.940025] calling  tw_init+0x0/0x16 @ 1
[   11.944024] bus: 'serio': add driver touchwin
[   11.948158] initcall tw_init+0x0/0x16 returned 0 after 3906 usecs
[   11.952025] calling  yealink_dev_init+0x0/0x2d @ 1
[   11.956027] bus: 'usb': add driver yealink
[   11.960152] usbcore: registered new interface driver yealink
[   11.964028] yealink: yld-20051230:Yealink phone driver
[   11.968025] initcall yealink_dev_init+0x0/0x2d returned 0 after 11718 usecs
[   11.972025] calling  cm109_init+0x0/0x38 @ 1
[   11.976023] cm109: Keymap for Komunikate KIP1000 phone loaded
[   11.980026] bus: 'usb': add driver cm109
[   11.984170] usbcore: registered new interface driver cm109
[   11.988028] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   11.992025] initcall cm109_init+0x0/0x38 returned 0 after 15625 usecs
[   11.996025] calling  ds1286_init+0x0/0xf @ 1
[   12.000025] bus: 'platform': add driver rtc-ds1286
[   12.004162] initcall ds1286_init+0x0/0xf returned 0 after 3906 usecs
[   12.008033] calling  ds1553_init+0x0/0xf @ 1
[   12.012026] bus: 'platform': add driver rtc-ds1553
[   12.016149] initcall ds1553_init+0x0/0xf returned 0 after 3906 usecs
[   12.020026] calling  m48t35_init+0x0/0xf @ 1
[   12.024024] bus: 'platform': add driver rtc-m48t35
[   12.028149] initcall m48t35_init+0x0/0xf returned 0 after 3906 usecs
[   12.032025] calling  m48t59_rtc_init+0x0/0xf @ 1
[   12.036026] bus: 'platform': add driver rtc-m48t59
[   12.040149] initcall m48t59_rtc_init+0x0/0xf returned 0 after 3906 usecs
[   12.044026] calling  test_init+0x0/0x98 @ 1
[   12.048024] bus: 'platform': add driver rtc-test
[   12.052149] Registering platform device 'rtc-test.0'. Parent at platform
[   12.056024] device: 'rtc-test.0': device_add
[   12.060035] bus: 'platform': add device rtc-test.0
[   12.064146] bus: 'platform': driver_probe_device: matched device rtc-test.0 with driver rtc-test
[   12.068026] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.0
[   12.072126] device: 'rtc0': device_add
[   12.076186] test: dev (254:0)
[   12.078937] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   12.080028] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-test'
[   12.084025] bus: 'platform': really_probe: bound device rtc-test.0 to driver rtc-test
[   12.088026] Registering platform device 'rtc-test.1'. Parent at platform
[   12.092024] device: 'rtc-test.1': device_add
[   12.096032] bus: 'platform': add device rtc-test.1
[   12.100147] bus: 'platform': driver_probe_device: matched device rtc-test.1 with driver rtc-test
[   12.104024] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.1
[   12.108040] device: 'rtc1': device_add
[   12.112193] test: dev (254:1)
[   12.116026] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   12.120027] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-test'
[   12.124025] bus: 'platform': really_probe: bound device rtc-test.1 to driver rtc-test
[   12.128066] initcall test_init+0x0/0x98 returned 0 after 78125 usecs
[   12.132025] calling  v3020_init+0x0/0xf @ 1
[   12.136024] bus: 'platform': add driver v3020
[   12.144080] initcall v3020_init+0x0/0xf returned 0 after 7812 usecs
[   12.148026] calling  telephony_init+0x0/0x3f @ 1
[   12.152023] Linux telephony interface: v1.00
[   12.156033] initcall telephony_init+0x0/0x3f returned 0 after 3906 usecs
[   12.160024] calling  dm_init+0x0/0x38 @ 1
[   12.164323] device: 'device-mapper': device_add
[   12.168167] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   12.172027] initcall dm_init+0x0/0x38 returned 0 after 7812 usecs
[   12.176025] calling  dm_delay_init+0x0/0xad @ 1
[   12.180362] initcall dm_delay_init+0x0/0xad returned 0 after 0 usecs
[   12.184025] calling  edac_init+0x0/0xcb @ 1
[   12.188025] EDAC MC: Ver: 2.1.0 Mar 18 2009
[   12.192031] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.196040] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.200037] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.204038] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.208037] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.212039] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.216037] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.220038] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.224041] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.228038] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.232041] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.236042] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.240041] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.244042] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.248037] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.252037] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.256037] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.260037] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.264048] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.268038] EDAC DEBUG: edac_pci_dev_parity_clear()
[   12.272037] Registering sysdev class 'edac'
[   12.276137] EDAC DEBUG: edac_sysfs_setup_mc_kset()
[   12.280142] EDAC DEBUG: edac_sysfs_setup_mc_kset() Registered '.../edac/mc' kobject
[   12.284092] initcall edac_init+0x0/0xcb returned 0 after 93750 usecs
[   12.288025] calling  i5000_init+0x0/0x50 @ 1
[   12.292025] EDAC DEBUG: MC: drivers/edac/i5000_edac.c: i5000_init()
[   12.296031] bus: 'pci': add driver i5000_edac
[   12.300195] initcall i5000_init+0x0/0x50 returned 0 after 7812 usecs
[   12.304025] calling  i82875p_init+0x0/0xc5 @ 1
[   12.308029] bus: 'pci': add driver i82875p_edac
[   12.312181] EDAC DEBUG: 875p pci_get_device fail
[   12.316044] bus: 'pci': remove driver i82875p_edac
[   12.320143] driver: 'i82875p_edac': driver_release
[   12.324035] initcall i82875p_init+0x0/0xc5 returned -19 after 15625 usecs
[   12.328025] calling  i3000_init+0x0/0xcf @ 1
[   12.332029] bus: 'pci': add driver i3000_edac
[   12.336182] EDAC DEBUG: i3000 pci_get_device fail
[   12.340043] bus: 'pci': remove driver i3000_edac
[   12.348081] driver: 'i3000_edac': driver_release
[   12.352033] initcall i3000_init+0x0/0xcf returned -19 after 19531 usecs
[   12.356026] calling  x38_init+0x0/0xcf @ 1
[   12.360028] bus: 'pci': add driver x38_edac
[   12.364183] EDAC DEBUG: x38 pci_get_device fail
[   12.368041] bus: 'pci': remove driver x38_edac
[   12.372149] driver: 'x38_edac': driver_release
[   12.376035] initcall x38_init+0x0/0xcf returned -19 after 15625 usecs
[   12.380026] calling  r82600_init+0x0/0x29 @ 1
[   12.384029] bus: 'pci': add driver r82600_edac
[   12.388201] initcall r82600_init+0x0/0x29 returned 0 after 3906 usecs
[   12.392025] calling  cpufreq_stats_init+0x0/0x88 @ 1
[   12.396072] initcall cpufreq_stats_init+0x0/0x88 returned 0 after 0 usecs
[   12.400025] calling  cpufreq_gov_powersave_init+0x0/0xf @ 1
[   12.404028] initcall cpufreq_gov_powersave_init+0x0/0xf returned 0 after 0 usecs
[   12.408025] calling  cpufreq_gov_dbs_init+0x0/0xf @ 1
[   12.412028] initcall cpufreq_gov_dbs_init+0x0/0xf returned 0 after 0 usecs
[   12.416025] calling  init_ladder+0x0/0xf @ 1
[   12.420053] cpuidle: using governor ladder
[   12.424025] initcall init_ladder+0x0/0xf returned 0 after 3906 usecs
[   12.428026] calling  init_menu+0x0/0xf @ 1
[   12.432024] cpuidle: using governor menu
[   12.436026] initcall init_menu+0x0/0xf returned 0 after 3906 usecs
[   12.440025] calling  memstick_init+0x0/0x75 @ 1
[   12.444154] bus: 'memstick': registered
[   12.448025] device class 'memstick_host': registering
[   12.452151] initcall memstick_init+0x0/0x75 returned 0 after 7812 usecs
[   12.456025] calling  dcdrbu_init+0x0/0x10f @ 1
[   12.460030] Registering platform device 'dell_rbu'. Parent at platform
[   12.464024] device: 'dell_rbu': device_add
[   12.468035] bus: 'platform': add device dell_rbu
[   12.476080] initcall dcdrbu_init+0x0/0x10f returned 0 after 15625 usecs
[   12.480025] calling  geode_aes_init+0x0/0x16 @ 1
[   12.484031] bus: 'pci': add driver Geode LX AES
[   12.488171] initcall geode_aes_init+0x0/0x16 returned 0 after 3906 usecs
[   12.492027] calling  init_hrt_clocksource+0x0/0xda @ 1
[   12.496026] initcall init_hrt_clocksource+0x0/0xda returned -19 after 0 usecs
[   12.500026] calling  hid_init+0x0/0x3d @ 1
[   12.504139] bus: 'hid': registered
[   12.508030] device class 'hidraw': registering
[   12.512143] initcall hid_init+0x0/0x3d returned 0 after 7812 usecs
[   12.516029] calling  apple_init+0x0/0x32 @ 1
[   12.520037] bus: 'hid': add driver apple
[   12.524174] initcall apple_init+0x0/0x32 returned 0 after 3906 usecs
[   12.528026] calling  ch_init+0x0/0x1b @ 1
[   12.532026] bus: 'hid': add driver cherry
[   12.536152] initcall ch_init+0x0/0x1b returned 0 after 3906 usecs
[   12.540027] calling  ez_init+0x0/0x1b @ 1
[   12.544025] bus: 'hid': add driver ezkey
[   12.548153] initcall ez_init+0x0/0x1b returned 0 after 3906 usecs
[   12.552026] calling  pl_init+0x0/0x1b @ 1
[   12.556026] bus: 'hid': add driver pantherlord
[   12.560163] initcall pl_init+0x0/0x1b returned 0 after 3906 usecs
[   12.564028] calling  ga_init+0x0/0x16 @ 1
[   12.568025] bus: 'hid': add driver greenasia
[   12.572154] initcall ga_init+0x0/0x16 returned 0 after 3906 usecs
[   12.576026] calling  zp_init+0x0/0x1b @ 1
[   12.580026] bus: 'hid': add driver zeroplus
[   12.584152] initcall zp_init+0x0/0x1b returned 0 after 3906 usecs
[   12.588027] calling  hid_init+0x0/0x65 @ 1
[   12.592025] bus: 'hid': add driver generic-usb
[   12.596172] bus: 'usb': add driver usbhid
[   12.604044] usbcore: registered new interface driver usbhid
[   12.608028] usbhid: v2.6:USB HID core driver
[   12.612028] initcall hid_init+0x0/0x65 returned 0 after 19531 usecs
[   12.616025] calling  usb_mouse_init+0x0/0x2d @ 1
[   12.620029] bus: 'usb': add driver usbmouse
[   12.624156] usbcore: registered new interface driver usbmouse
[   12.628029] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[   12.632026] initcall usb_mouse_init+0x0/0x2d returned 0 after 11718 usecs
[   12.636026] calling  init_soundcore+0x0/0x64 @ 1
[   12.640033] device class 'sound': registering
[   12.644141] initcall init_soundcore+0x0/0x64 returned 0 after 3906 usecs
[   12.648026] calling  oprofile_init+0x0/0x47 @ 1
[   12.652027] oprofile: using NMI interrupt.
[   12.656033] initcall oprofile_init+0x0/0x47 returned 0 after 3906 usecs
[   12.660026] calling  flow_cache_init+0x0/0x149 @ 1
[   12.664329] initcall flow_cache_init+0x0/0x149 returned 0 after 0 usecs
[   12.668028] calling  llc_init+0x0/0x1b @ 1
[   12.672028] initcall llc_init+0x0/0x1b returned 0 after 0 usecs
[   12.676026] calling  snap_init+0x0/0x2a @ 1
[   12.680066] initcall snap_init+0x0/0x2a returned 0 after 0 usecs
[   12.684027] calling  blackhole_module_init+0x0/0xf @ 1
[   12.688027] initcall blackhole_module_init+0x0/0xf returned 0 after 0 usecs
[   12.692026] calling  prio_module_init+0x0/0xf @ 1
[   12.696026] initcall prio_module_init+0x0/0xf returned 0 after 0 usecs
[   12.700026] calling  netem_module_init+0x0/0x19 @ 1
[   12.704024] netem: version 1.2
[   12.708027] initcall netem_module_init+0x0/0x19 returned 0 after 3906 usecs
[   12.712026] calling  init_route4+0x0/0xf @ 1
[   12.716054] initcall init_route4+0x0/0xf returned 0 after 0 usecs
[   12.720025] calling  init_fw+0x0/0xf @ 1
[   12.724027] initcall init_fw+0x0/0xf returned 0 after 0 usecs
[   12.728025] calling  init_tcindex+0x0/0xf @ 1
[   12.732028] initcall init_tcindex+0x0/0xf returned 0 after 0 usecs
[   12.736025] calling  init_rsvp+0x0/0xf @ 1
[   12.740027] initcall init_rsvp+0x0/0xf returned 0 after 0 usecs
[   12.744025] calling  cls_flow_init+0x0/0xf @ 1
[   12.748028] initcall cls_flow_init+0x0/0xf returned 0 after 0 usecs
[   12.752025] calling  init_cgroup_cls+0x0/0xf @ 1
[   12.756027] initcall init_cgroup_cls+0x0/0xf returned 0 after 0 usecs
[   12.760025] calling  init_em_cmp+0x0/0xf @ 1
[   12.764054] initcall init_em_cmp+0x0/0xf returned 0 after 0 usecs
[   12.768026] calling  init_em_nbyte+0x0/0xf @ 1
[   12.772027] initcall init_em_nbyte+0x0/0xf returned 0 after 0 usecs
[   12.776035] calling  init_em_u32+0x0/0xf @ 1
[   12.780027] initcall init_em_u32+0x0/0xf returned 0 after 0 usecs
[   12.784025] calling  init_em_meta+0x0/0xf @ 1
[   12.788027] initcall init_em_meta+0x0/0xf returned 0 after 0 usecs
[   12.792025] calling  nfnetlink_init+0x0/0x4f @ 1
[   12.796025] Netfilter messages via NETLINK v0.30.
[   12.800042] initcall nfnetlink_init+0x0/0x4f returned 0 after 3906 usecs
[   12.808026] calling  nfnetlink_queue_init+0x0/0x87 @ 1
[   12.812070] initcall nfnetlink_queue_init+0x0/0x87 returned 0 after 0 usecs
[   12.816027] calling  nfnetlink_log_init+0x0/0x8a @ 1
[   12.820040] initcall nfnetlink_log_init+0x0/0x8a returned 0 after 0 usecs
[   12.824032] calling  sysctl_ipv4_init+0x0/0x3f @ 1
[   12.829325] initcall sysctl_ipv4_init+0x0/0x3f returned 0 after 0 usecs
[   12.832027] calling  ipip_init+0x0/0x5f @ 1
[   12.836024] IPv4 over IPv4 tunneling driver
[   12.840154] device: 'tunl0': device_add
[   12.844832] initcall ipip_init+0x0/0x5f returned 0 after 7812 usecs
[   12.848028] calling  init_syncookies+0x0/0x16 @ 1
[   12.852068] initcall init_syncookies+0x0/0x16 returned 0 after 0 usecs
[   12.856027] calling  esp4_init+0x0/0x5a @ 1
[   12.860028] initcall esp4_init+0x0/0x5a returned 0 after 0 usecs
[   12.864027] calling  tunnel4_init+0x0/0x5a @ 1
[   12.868027] initcall tunnel4_init+0x0/0x5a returned 0 after 0 usecs
[   12.872029] calling  ipv4_netfilter_init+0x0/0x14 @ 1
[   12.876061] initcall ipv4_netfilter_init+0x0/0x14 returned 0 after 0 usecs
[   12.880027] calling  ip_queue_init+0x0/0x10c @ 1
[   12.884114] initcall ip_queue_init+0x0/0x10c returned 0 after 0 usecs
[   12.888027] calling  cubictcp_register+0x0/0x7f @ 1
[   12.892025] TCP cubic registered
[   12.896027] initcall cubictcp_register+0x0/0x7f returned 0 after 3906 usecs
[   12.900026] calling  tcp_vegas_register+0x0/0x11 @ 1
[   12.904025] TCP vegas registered
[   12.908026] initcall tcp_vegas_register+0x0/0x11 returned 0 after 3906 usecs
[   12.912028] calling  tcp_veno_register+0x0/0x11 @ 1
[   12.916024] TCP veno registered
[   12.920027] initcall tcp_veno_register+0x0/0x11 returned 0 after 3906 usecs
[   12.924025] calling  packet_init+0x0/0x39 @ 1
[   12.928027] NET: Registered protocol family 17
[   12.932067] initcall packet_init+0x0/0x39 returned 0 after 3906 usecs
[   12.936026] calling  br_init+0x0/0xbe @ 1
[   12.940294] Bridge firewalling registered
[   12.944062] initcall br_init+0x0/0xbe returned 0 after 3906 usecs
[   12.948025] calling  dsa_init_module+0x0/0x11 @ 1
[   12.952027] initcall dsa_init_module+0x0/0x11 returned 0 after 0 usecs
[   12.956025] calling  trailer_init_module+0x0/0x11 @ 1
[   12.960027] initcall trailer_init_module+0x0/0x11 returned 0 after 0 usecs
[   12.964025] calling  mv88e6060_init+0x0/0x11 @ 1
[   12.968054] initcall mv88e6060_init+0x0/0x11 returned 0 after 0 usecs
[   12.972025] calling  mv88e6131_init+0x0/0x11 @ 1
[   12.976027] initcall mv88e6131_init+0x0/0x11 returned 0 after 0 usecs
[   12.980025] calling  dsa_init_module+0x0/0xf @ 1
[   12.984028] bus: 'platform': add driver dsa
[   12.988149] initcall dsa_init_module+0x0/0xf returned 0 after 3906 usecs
[   12.992027] calling  ipx_init+0x0/0xd2 @ 1
[   12.996251] NET: Registered protocol family 4
[   13.020101] initcall ipx_init+0x0/0xd2 returned 0 after 23437 usecs
[   13.024027] calling  x25_init+0x0/0x50 @ 1
[   13.028025] NET: Registered protocol family 9
[   13.032035] X.25 for Linux Version 0.2
[   13.036180] initcall x25_init+0x0/0x50 returned 0 after 7812 usecs
[   13.040026] calling  rose_proto_init+0x0/0x22c @ 1
[   13.044039] rose0 (): not using net_device_ops yet
[   13.048027] device: 'rose0': device_add
[   13.052920] rose1 (): not using net_device_ops yet
[   13.056028] device: 'rose1': device_add
[   13.064887] rose2 (): not using net_device_ops yet
[   13.068026] device: 'rose2': device_add
[   13.072997] rose3 (): not using net_device_ops yet
[   13.076027] device: 'rose3': device_add
[   13.084495] rose4 (): not using net_device_ops yet
[   13.088027] device: 'rose4': device_add
[   13.093058] rose5 (): not using net_device_ops yet
[   13.096028] device: 'rose5': device_add
[   13.104175] rose6 (): not using net_device_ops yet
[   13.108026] device: 'rose6': device_add
[   13.113139] rose7 (): not using net_device_ops yet
[   13.116027] device: 'rose7': device_add
[   13.121163] rose8 (): not using net_device_ops yet
[   13.124026] device: 'rose8': device_add
[   13.129216] rose9 (): not using net_device_ops yet
[   13.132027] device: 'rose9': device_add
[   13.137224] NET: Registered protocol family 11
[   13.140457] initcall rose_proto_init+0x0/0x22c returned 0 after 93750 usecs
[   13.144027] calling  ax25_init+0x0/0x8e @ 1
[   13.148025] NET: Registered protocol family 3
[   13.152117] initcall ax25_init+0x0/0x8e returned 0 after 3906 usecs
[   13.156026] calling  econet_proto_init+0x0/0x39 @ 1
[   13.160026] NET: Registered protocol family 19
[   13.164028] initcall econet_proto_init+0x0/0x39 returned 0 after 3906 usecs
[   13.168026] calling  phonet_init+0x0/0x6a @ 1
[   13.172025] NET: Registered protocol family 35
[   13.176324] initcall phonet_init+0x0/0x6a returned 0 after 3906 usecs
[   13.180026] calling  pep_register+0x0/0x14 @ 1
[   13.184249] initcall pep_register+0x0/0x14 returned 0 after 0 usecs
[   13.188026] calling  vlan_proto_init+0x0/0xa7 @ 1
[   13.192026] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   13.196025] All bugs added by David S. Miller <davem@redhat.com>
[   13.200087] initcall vlan_proto_init+0x0/0xa7 returned 0 after 7812 usecs
[   13.204026] calling  wimax_subsys_init+0x0/0x1d7 @ 1
[   13.224070] initcall wimax_subsys_init+0x0/0x1d7 returned 0 after 15625 usecs
[   13.228028] calling  update_mp_table+0x0/0x1b3 @ 1
[   13.232029] initcall update_mp_table+0x0/0x1b3 returned 0 after 0 usecs
[   13.236027] calling  lapic_insert_resource+0x0/0x45 @ 1
[   13.240030] initcall lapic_insert_resource+0x0/0x45 returned 0 after 0 usecs
[   13.244026] calling  print_ipi_mode+0x0/0x25 @ 1
[   13.248026] Using IPI No-Shortcut mode
[   13.252026] initcall print_ipi_mode+0x0/0x25 returned 0 after 3906 usecs
[   13.256028] calling  ioapic_insert_resources+0x0/0x42 @ 1
[   13.260028] initcall ioapic_insert_resources+0x0/0x42 returned 0 after 0 usecs
[   13.264027] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   13.268027] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 usecs
[   13.272027] calling  check_early_ioremap_leak+0x0/0x5e @ 1
[   13.276027] initcall check_early_ioremap_leak+0x0/0x5e returned 0 after 0 usecs
[   13.280027] calling  sched_init_debug+0x0/0x1f @ 1
[   13.284043] initcall sched_init_debug+0x0/0x1f returned 0 after 0 usecs
[   13.288041] calling  init_oops_id+0x0/0x3f @ 1
[   13.292032] initcall init_oops_id+0x0/0x3f returned 0 after 0 usecs
[   13.296027] calling  disable_boot_consoles+0x0/0x36 @ 1
[   13.300027] initcall disable_boot_consoles+0x0/0x36 returned 0 after 0 usecs
[   13.304027] calling  pm_qos_power_init+0x0/0xae @ 1
[   13.308031] device: 'cpu_dma_latency': device_add
[   13.312152] device: 'network_latency': device_add
[   13.316148] device: 'network_throughput': device_add
[   13.320150] initcall pm_qos_power_init+0x0/0xae returned 0 after 11718 usecs
[   13.324027] calling  debugfs_kprobe_init+0x0/0x78 @ 1
[   13.328053] initcall debugfs_kprobe_init+0x0/0x78 returned 0 after 0 usecs
[   13.332026] calling  taskstats_init+0x0/0x7d @ 1
[   13.336067] registered taskstats version 1
[   13.340027] initcall taskstats_init+0x0/0x7d returned 0 after 3906 usecs
[   13.344027] calling  clear_boot_tracer+0x0/0x27 @ 1
[   13.348027] initcall clear_boot_tracer+0x0/0x27 returned 0 after 0 usecs
[   13.352027] calling  max_swapfiles_check+0x0/0x7 @ 1
[   13.356026] initcall max_swapfiles_check+0x0/0x7 returned 0 after 0 usecs
[   13.360028] calling  random32_reseed+0x0/0x78 @ 1
[   13.364042] initcall random32_reseed+0x0/0x78 returned 0 after 0 usecs
[   13.368029] calling  pci_sysfs_init+0x0/0x44 @ 1
[   13.372324] initcall pci_sysfs_init+0x0/0x44 returned 0 after 0 usecs
[   13.376028] calling  seqgen_init+0x0/0xe @ 1
[   13.380044] initcall seqgen_init+0x0/0xe returned 0 after 0 usecs
[   13.384028] calling  scsi_complete_async_scans+0x0/0xf7 @ 1
[   13.388027] initcall scsi_complete_async_scans+0x0/0xf7 returned 0 after 0 usecs
[   13.392027] calling  rtc_hctosys+0x0/0x125 @ 1
[   13.396071] rtc-test rtc-test.0: setting system clock to 2009-03-18 11:08:23 UTC (1237374503)
[   13.400028] initcall rtc_hctosys+0x0/0x125 returned 0 after 3906 usecs
[   13.404026] calling  memmap_init+0x0/0x8e @ 1
[   13.408147] initcall memmap_init+0x0/0x8e returned 0 after 0 usecs
[   13.412028] calling  tcp_congestion_default+0x0/0xf @ 1
[   13.416030] initcall tcp_congestion_default+0x0/0xf returned 0 after 0 usecs
[   13.420027] calling  ip_auto_config+0x0/0x274 @ 1
[   13.424038] initcall ip_auto_config+0x0/0x274 returned 0 after 0 usecs
[   13.428071] driver_probe_done: probe_count = 0
[   13.432026] async_waiting @ 1
[   13.436026] async_continuing @ 1 after 0 usec
[   13.440521] EXT3-fs: INFO: recovery required on readonly filesystem.
[   13.448100] EXT3-fs: write access will be enabled during recovery.
[   13.496160] kjournald starting.  Commit interval 5 seconds
[   13.500061] EXT3-fs: recovery complete.
[   13.504190] EXT3-fs: mounted filesystem with ordered data mode.
[   13.512123] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[   13.520112] async_waiting @ 1
[   13.522967] async_continuing @ 1 after 0 usec
[   13.524025] debug: unmapping init memory c07e3000..c0853000
[   13.540303] device: 'vcs1': device_add
[   13.560099] khelper used greatest stack depth: 6600 bytes left
[   13.560141] device: 'vcsa1': device_add
[   13.932682] modprobe used greatest stack depth: 6508 bytes left
[   13.940301] device: 'vcs1': device_unregister
[   13.940492] device: 'vcs1': device_create_release
[   13.940492] device: 'vcsa1': device_unregister
[   13.940492] device: 'vcsa1': device_create_release
[   13.960102] device: 'vcs1': device_add
[   13.960241] device: 'vcsa1': device_add
[   13.968140] device: 'vcs1': device_unregister
[   13.968287] device: 'vcs1': device_create_release
[   13.968287] device: 'vcsa1': device_unregister
[   13.968287] device: 'vcsa1': device_create_release
[   13.996152] device: 'vcs1': device_add
[   13.996291] device: 'vcsa1': device_add
[   14.004095] device: 'vcs1': device_unregister
[   14.004244] device: 'vcs1': device_create_release
[   14.004244] device: 'vcsa1': device_unregister
[   14.008065] device: 'vcsa1': device_create_release
[   14.024094] device: 'vcs1': device_add
[   14.024232] device: 'vcsa1': device_add
[   14.032108] device: 'vcs1': device_unregister
[   14.032255] device: 'vcs1': device_create_release
[   14.032255] device: 'vcsa1': device_unregister
[   14.032255] device: 'vcsa1': device_create_release
[   14.052095] device: 'vcs1': device_add
[   14.052230] device: 'vcsa1': device_add
[   14.060137] device: 'vcs1': device_unregister
[   14.060284] device: 'vcs1': device_create_release
[   14.060284] device: 'vcsa1': device_unregister
[   14.060284] device: 'vcsa1': device_create_release
[   14.088255] device: 'vcs1': device_add
[   14.088446] device: 'vcsa1': device_add
[   14.380672] mount used greatest stack depth: 6236 bytes left
[   17.124206] fsck.ext3 used greatest stack depth: 6176 bytes left
[   17.308554] EXT3 FS on sda1, internal journal
[   17.384249] kjournald starting.  Commit interval 5 seconds
[   17.384249] EXT3 FS on sda5, internal journal
[   17.384249] EXT3-fs: mounted filesystem with ordered data mode.
[   18.639106] rc.sysinit used greatest stack depth: 6092 bytes left
[   18.644623] device: 'vcs1': device_unregister
[   18.644745] device: 'vcs1': device_create_release
[   18.644745] device: 'vcsa1': device_unregister
[   18.644745] device: 'vcsa1': device_create_release
[   18.672780] device: 'vcs1': device_add
[   18.672898] device: 'vcsa1': device_add
[   18.680127] device: 'vcs1': device_unregister
[   18.680227] device: 'vcs1': device_create_release
[   18.680227] device: 'vcsa1': device_unregister
[   18.680227] device: 'vcsa1': device_create_release
[   18.700136] device: 'vcs1': device_add
[   18.700271] device: 'vcsa1': device_add
[   18.708096] device: 'vcs1': device_unregister
[   18.708242] device: 'vcs1': device_create_release
[   18.708242] device: 'vcsa1': device_unregister
[   18.708242] device: 'vcsa1': device_create_release
[   18.728093] device: 'vcs1': device_add
[   18.728229] device: 'vcsa1': device_add
[   18.736138] device: 'vcs1': device_unregister
[   18.736282] device: 'vcs1': device_create_release
[   18.736282] device: 'vcsa1': device_unregister
[   18.736282] device: 'vcsa1': device_create_release
[   18.752383] device: 'vcs1': device_add
[   18.752412] device: 'vcsa1': device_add
[   19.648023] eth0: no link during initialization.
[   21.952553] eth0: link up.
[   22.684073] ------------[ cut here ]------------
[   22.688023] WARNING: at lib/dma-debug.c:562 check_unmap+0x30e/0x4b4()
[   22.688023] Hardware name: System Product Name
[   22.688023] forcedeth 0000:00:0a.0: DMA-API: device driver frees DMA memory with wrong function [device address=0x0000000035992232] [size=42 bytes] [mapped as single] [unmapped as page]
[   22.688023] Modules linked in:
[   22.688023] Pid: 1523, comm: arping Not tainted 2.6.29-rc8-tip #20999
[   22.688023] Call Trace:
[   22.688023]  [<c0140eae>] warn_slowpath+0x76/0xad
[   22.688023]  [<c0293a0b>] ? add_dma_entry+0x4b/0x51
[   22.688023]  [<c015eec5>] ? mark_lock+0x1c/0x16f
[   22.688023]  [<c015f1a4>] ? __lock_acquire+0x18c/0x296
[   22.688023]  [<c03473cc>] ? nv_start_xmit_optimized+0x3bd/0x3eb
[   22.688023]  [<c015eec5>] ? mark_lock+0x1c/0x16f
[   22.688023]  [<c015f1a4>] ? __lock_acquire+0x18c/0x296
[   22.688023]  [<c0293572>] check_unmap+0x30e/0x4b4
[   22.688023]  [<c055f7c3>] ? _spin_lock+0x27/0x2f
[   22.688023]  [<c0145ba1>] ? _local_bh_enable_ip+0xa1/0xa7
[   22.688023]  [<c049e0f8>] ? dev_queue_xmit+0x325/0x359
[   22.688023]  [<c0188922>] ? trace_hardirqs_on+0x21/0x23
[   22.688023]  [<c0145ba1>] ? _local_bh_enable_ip+0xa1/0xa7
[   22.688023]  [<c0145bc6>] ? local_bh_enable+0x10/0x12
[   22.688023]  [<c050225c>] ? packet_sendmsg+0x1b7/0x20a
[   22.688023]  [<c02939b8>] debug_dma_unmap_page+0x59/0x61
[   22.688023]  [<c034421f>] pci_unmap_page+0x5b/0x66
[   22.688023]  [<c03446fd>] nv_tx_done_optimized+0x46/0x1c5
[   22.688023]  [<c0345922>] nv_nic_irq_optimized+0xa7/0x233
[   22.688023]  [<c017706e>] handle_IRQ_event+0x85/0xdf
[   22.688023]  [<c01785df>] handle_fasteoi_irq+0x79/0xb9
[   22.688023]  [<c0119973>] handle_irq+0x1f/0x24
[   22.688023]  [<c0119332>] do_IRQ+0x45/0x88
[   22.688023]  [<c0118455>] common_interrupt+0x35/0x40
[   22.688023]  [<c0144515>] ? do_setitimer+0x160/0x2d9
[   22.688023]  [<c055f69b>] ? _spin_unlock_irq+0x29/0x2b
[   22.688023]  [<c0144515>] do_setitimer+0x160/0x2d9
[   22.688023]  [<c04926fa>] ? sys_socketcall+0xed/0x188
[   22.688023]  [<c014473b>] alarm_setitimer+0x39/0x58
[   22.688023]  [<c0149776>] sys_alarm+0x10/0x12
[   22.688023]  [<c0117d47>] sysenter_do_call+0x12/0x32
[   22.688023] ---[ end trace bf7fa25698012db6 ]---
[   22.688023] Mapped at:
[   22.688023]  [<c0293cc1>] debug_dma_map_page+0x6c/0x128
[   22.688023]  [<c0345bd0>] pci_map_single+0xb5/0xc1
[   22.688023]  [<c0347147>] nv_start_xmit_optimized+0x138/0x3eb
[   22.688023]  [<c049dc7c>] dev_hard_start_xmit+0x123/0x18f
[   22.688023]  [<c04acbb9>] __qdisc_run+0xd0/0x1b3
[   23.700081] arping used greatest stack depth: 5988 bytes left
[   24.545512] Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k 
[   25.694685] ssh used greatest stack depth: 5776 bytes left
[   25.954828] Unmapping cpu 1 from all nodes
[   25.956043] CPU 1 is now offline
[   25.960075] lockdep: fixing up alternatives.
[   25.964514] SMP alternatives: switching to UP code
[   26.019497] CPU0 attaching NULL sched-domain.
[   26.020232] CPU1 attaching NULL sched-domain.
[   26.030507] CPU0 attaching NULL sched-domain.
[   27.049073] lockdep: fixing up alternatives.
[   27.052032] SMP alternatives: switching to SMP code
[   27.062305] Booting processor 1 APIC 0x1 ip 0x6000
[   26.018837] Initializing CPU#1
[   26.018837] masked ExtINT on CPU#1
[   26.018837] Mapping cpu 1 to node 0
[   26.018837] Calibrating delay using timer specific routine.. 4020.86 BogoMIPS (lpj=8041727)
[   26.018837] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   26.018837] CPU: L2 Cache: 512K (64 bytes/line)
[   26.018837] CPU: Physical Processor ID: 0
[   26.018837] CPU: Processor Core ID: 1
[   26.018837] Intel machine check architecture supported.
[   26.018837] Intel machine check reporting enabled on CPU#1.
[   27.156138] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   27.165331] CPU0 attaching NULL sched-domain.
[   27.184315] CPU0 attaching sched-domain:
[   27.188031]  domain 0: span 0-1 level CPU
[   27.192034]   groups: 0 1
[   27.194621]   domain 1: span 0-1 level NODE
[   27.197840]    groups: 0-1
[   27.200546] CPU1 attaching sched-domain:
[   27.204153]  domain 0: span 0-1 level CPU
[   27.208026]   groups: 1 0
[   27.212027]   domain 1: span 0-1 level NODE
[   27.216028]    groups: 0-1
[   27.221331] microcode: CPU1: AMD CPU family 0xf not supported
[   28.245024] Unmapping cpu 1 from all nodes
[   28.248051] CPU 1 is now offline
[   28.252025] lockdep: fixing up alternatives.
[   28.256028] SMP alternatives: switching to UP code
[   28.266449] CPU0 attaching NULL sched-domain.
[   28.268030] CPU1 attaching NULL sched-domain.
[   28.272552] CPU0 attaching NULL sched-domain.
[   29.285037] lockdep: fixing up alternatives.
[   29.288034] SMP alternatives: switching to SMP code
[   29.298261] Booting processor 1 APIC 0x1 ip 0x6000
[   28.266156] Initializing CPU#1
[   28.266156] masked ExtINT on CPU#1
[   28.266156] Mapping cpu 1 to node 0
[   28.266156] Calibrating delay using timer specific routine.. 4020.86 BogoMIPS (lpj=8041728)
[   28.266156] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   28.266156] CPU: L2 Cache: 512K (64 bytes/line)
[   28.266156] CPU: Physical Processor ID: 0
[   28.266156] CPU: Processor Core ID: 1
[   28.266156] Intel machine check architecture supported.
[   28.266156] Intel machine check reporting enabled on CPU#1.
[   29.392085] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   29.401323] CPU0 attaching NULL sched-domain.
[   29.420311] CPU0 attaching sched-domain:
[   29.424032]  domain 0: span 0-1 level CPU
[   29.428031]   groups: 0 1
[   29.430620]   domain 1: span 0-1 level NODE
[   29.433922]    groups: 0-1
[   29.436550] CPU1 attaching sched-domain:
[   29.440028]  domain 0: span 0-1 level CPU
[   29.444027]   groups: 1 0
[   29.448026]   domain 1: span 0-1 level NODE
[   29.452025]    groups: 0-1
[   29.456251] microcode: CPU1: AMD CPU family 0xf not supported
[   29.486717] device: 'vcs9': device_add
[   29.488195] device: 'vcsa9': device_add
[   29.492188] device: 'vcs2': device_add
[   29.492486] device: 'vcsa2': device_add
[   29.496119] device: 'vcs4': device_add
[   29.496322] device: 'vcsa4': device_add
[   29.500180] device: 'vcs6': device_add
[   29.500382] device: 'vcsa6': device_add
[   29.504208] device: 'vcs8': device_add
[   29.504438] device: 'vcsa8': device_add
[   29.508107] device: 'vcs9': device_unregister
[   29.508410] device: 'vcs9': device_create_release
[   29.508419] device: 'vcsa9': device_unregister
[   29.508638] device: 'vcsa9': device_create_release
[   29.512266] device: 'vcs2': device_unregister
[   29.512469] device: 'vcs2': device_create_release
[   29.512477] device: 'vcsa2': device_unregister
[   29.512673] device: 'vcsa2': device_create_release
[   29.516222] device: 'vcs4': device_unregister
[   29.516434] device: 'vcs4': device_create_release
[   29.516442] device: 'vcsa4': device_unregister
[   29.516646] device: 'vcsa4': device_create_release
[   29.520343] device: 'vcs6': device_unregister
[   29.524053] device: 'vcs6': device_create_release
[   29.524062] device: 'vcsa6': device_unregister
[   29.524276] device: 'vcsa6': device_create_release
[   29.528218] device: 'vcs7': device_add
[   29.528428] device: 'vcsa7': device_add
[   29.532234] device: 'vcs8': device_unregister
[   29.532429] device: 'vcs8': device_create_release
[   29.532429] device: 'vcsa8': device_unregister
[   29.532429] device: 'vcsa8': device_create_release
[   29.536104] device: 'vcs9': device_add
[   29.536226] device: 'vcsa9': device_add
[   29.540187] device: 'vcs2': device_add
[   29.540309] device: 'vcsa2': device_add
[   29.544072] device: 'vcs5': device_add
[   29.544179] device: 'vcsa5': device_add
[   29.552083] device: 'vcs4': device_add
[   29.552266] device: 'vcsa4': device_add
[   29.556155] device: 'vcs3': device_add
[   29.556163] device: 'vcsa3': device_add
[   29.564032] device: 'vcs6': device_add
[   29.564259] device: 'vcsa6': device_add
[   29.568083] device: 'vcs10': device_add
[   29.568140] device: 'vcsa10': device_add
[   29.576086] device: 'vcs7': device_unregister
[   29.576252] device: 'vcs7': device_create_release
[   29.576263] device: 'vcsa7': device_unregister
[   29.576467] device: 'vcsa7': device_create_release
[   29.580101] device: 'vcs8': device_add
[   29.580224] device: 'vcsa8': device_add
[   29.584200] device: 'vcs5': device_unregister
[   29.584209] device: 'vcs5': device_create_release
[   29.584209] device: 'vcsa5': device_unregister
[   29.584211] device: 'vcsa5': device_create_release
[   29.600112] device: 'vcs3': device_unregister
[   29.600243] device: 'vcs3': device_create_release
[   29.600243] device: 'vcsa3': device_unregister
[   29.600243] device: 'vcsa3': device_create_release
[   29.620069] device: 'vcs10': device_unregister
[   29.620187] device: 'vcs10': device_create_release
[   29.620187] device: 'vcsa10': device_unregister
[   29.620187] device: 'vcsa10': device_create_release
[   29.640124] device: 'vcs7': device_add
[   29.640256] device: 'vcsa7': device_add
[   29.644147] device: 'vcs5': device_add
[   29.644287] device: 'vcsa5': device_add
[   29.652041] device: 'vcs3': device_add
[   29.652118] device: 'vcsa3': device_add
[   29.656130] device: 'vcs10': device_add
[   29.656255] device: 'vcsa10': device_add
[  180.820065] ssh used greatest stack depth: 5692 bytes left

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc8
# Wed Mar 18 12:19:31 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
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
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
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
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
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
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
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
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_IBS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_MIGRATE_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
CONFIG_X86_NUMAQ=y
# CONFIG_X86_SUMMIT is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_MEMTEST=y
CONFIG_X86_SUMMIT_NUMA=y
CONFIG_X86_CYCLONE_TIMER=y
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
CONFIG_MWINCHIP3D=y
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_X86_CPU_DEBUG=m
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_NUMA=y
CONFIG_NODES_SHIFT=4
CONFIG_HAVE_ARCH_BOOTMEM=y
CONFIG_ARCH_HAVE_MEMORY_PRESENT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_HAVE_ARCH_ALLOC_REMAP=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_MMU_NOTIFIER=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
# CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID is not set

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
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=m
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
CONFIG_PCI_DEBUG=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
# CONFIG_EISA_PCI_EISA is not set
# CONFIG_EISA_VIRTUAL_ROOT is not set
CONFIG_EISA_NAMES=y
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
# CONFIG_MCA_PROC_FS is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
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
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=m
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=m
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=m
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
# CONFIG_IP_NF_MATCH_ECN is not set
CONFIG_IP_NF_MATCH_TTL=m
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_IP_NF_TARGET_NETMAP is not set
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_TTL is not set
CONFIG_IP_NF_RAW=m
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=m
# CONFIG_IP_NF_ARPFILTER is not set
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
# CONFIG_IP6_NF_MATCH_EUI64 is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
# CONFIG_IP6_NF_MATCH_RT is not set
CONFIG_IP6_NF_TARGET_LOG=m
# CONFIG_IP6_NF_FILTER is not set
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
CONFIG_IP6_NF_SECURITY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
# CONFIG_BRIDGE_EBT_802_3 is not set
CONFIG_BRIDGE_EBT_AMONG=m
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
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
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=m
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=m
# CONFIG_SCC is not set
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
# CONFIG_BAYCOM_EPP is not set
CONFIG_YAM=y
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=m
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_PHONET=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
# CONFIG_PNPACPI is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_XD=m
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_93CX6=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
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
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_ENCLOSURE is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=y
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD640_PCI=m
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=m
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_ISAPNP=m
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
CONFIG_PATA_LEGACY=y
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=m
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_QDI is not set
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=m
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=m
CONFIG_PATA_WINBOND_VLB=y
CONFIG_PATA_PLATFORM=m
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_RAID5_RESHAPE is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=m
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=y
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
CONFIG_VETH=m
CONFIG_NET_SB1000=m
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=m
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
CONFIG_EL2=m
CONFIG_ELPLUS=m
CONFIG_EL16=m
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
CONFIG_ELMC=y
CONFIG_ELMC_II=m
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_LANCE=m
# CONFIG_NET_VENDOR_SMC is not set
CONFIG_NET_VENDOR_RACAL=y
# CONFIG_NI52 is not set
CONFIG_NI65=y
CONFIG_DNET=m
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=y
# CONFIG_DM9102 is not set
CONFIG_ULI526X=m
# CONFIG_AT1700 is not set
CONFIG_DEPCA=m
CONFIG_HP100=y
CONFIG_NET_ISA=y
# CONFIG_E2100 is not set
CONFIG_EWRK3=y
CONFIG_EEXPRESS=m
CONFIG_EEXPRESS_PRO=y
CONFIG_HPLAN=m
# CONFIG_LP486E is not set
CONFIG_ETH16I=m
CONFIG_NE2000=m
CONFIG_ZNET=y
CONFIG_SEEQ8005=m
CONFIG_NE2_MCA=y
CONFIG_IBMLANA=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_AC3200 is not set
CONFIG_APRICOT=y
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_CS89x0=y
CONFIG_E100=y
CONFIG_LNE390=m
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
# CONFIG_NE2K_PCI is not set
# CONFIG_NE3210 is not set
CONFIG_ES3210=m
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=y
CONFIG_SIS900=y
CONFIG_EPIC100=m
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=y
# CONFIG_VIA_RHINE is not set
CONFIG_SC92031=y
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=y
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
CONFIG_IGB=m
CONFIG_IGB_LRO=y
CONFIG_NS83820=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=m
CONFIG_R8169=y
CONFIG_R8169_VLAN=y
CONFIG_SIS190=y
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_JME=m
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=m
# CONFIG_IBMTR is not set
CONFIG_IBMOL=m
CONFIG_IBMLS=m
CONFIG_3C359=m
# CONFIG_TMS380TR is not set
# CONFIG_SMCTR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
# CONFIG_LIBERTAS_SDIO is not set
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=y
CONFIG_HERMES=y
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_PLX_HERMES is not set
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=m
# CONFIG_PCI_HERMES is not set
# CONFIG_ATMEL is not set
CONFIG_PRISM54=m
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_IPW2100=m
# CONFIG_IPW2100_MONITOR is not set
# CONFIG_IPW2100_DEBUG is not set
# CONFIG_IPW2200 is not set
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_HOSTAP is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_WAN=y
CONFIG_HOSTESS_SV11=m
# CONFIG_COSA is not set
# CONFIG_LANMEDIA is not set
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
CONFIG_HDLC_RAW_ETH=m
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=m
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_N2=m
CONFIG_C101=y
# CONFIG_FARSYNC is not set
CONFIG_DSCC4=m
# CONFIG_DSCC4_PCISYNC is not set
# CONFIG_DSCC4_PCI_RST is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=y
CONFIG_WAN_ROUTER_DRIVERS=m
# CONFIG_CYCLADES_SYNC is not set
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
# CONFIG_ATM_ENI_BURST_TX_16W is not set
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
# CONFIG_ATM_ENI_BURST_RX_16W is not set
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
# CONFIG_ATM_ENI_BURST_RX_2W is not set
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=m
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=y
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=m
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
# CONFIG_PPPOE is not set
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
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
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_INPORT=m
CONFIG_MOUSE_ATIXL=y
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
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
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_I2C is not set
CONFIG_SCx200_ACB=m

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_PCF8574=m
# CONFIG_PCF8575 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set
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
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_OLPC=m
CONFIG_BATTERY_BQ27x00=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_TPS65010=m
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_WM8400=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_BQ24022=y
CONFIG_REGULATOR_WM8400=m
CONFIG_REGULATOR_PCF50633=m

#
# Multimedia devices
#

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
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
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
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA7111=m
CONFIG_VIDEO_SAA7114=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
# CONFIG_VIDEO_PMS is not set
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
# CONFIG_VIDEO_W9966 is not set
CONFIG_VIDEO_CPIA=m
# CONFIG_VIDEO_CPIA_PP is not set
CONFIG_VIDEO_CPIA_USB=m
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
CONFIG_VIDEO_SAA5249=m
# CONFIG_VIDEO_STRADIS is not set
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
# CONFIG_VIDEO_ZORAN_LML33 is not set
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_USB_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_CADET=m
CONFIG_RADIO_RTRACK=m
CONFIG_RADIO_RTRACK2=m
# CONFIG_RADIO_AZTECH is not set
# CONFIG_RADIO_GEMTEK is not set
# CONFIG_RADIO_GEMTEK_PCI is not set
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
# CONFIG_RADIO_SF16FMI is not set
CONFIG_RADIO_SF16FMR2=m
CONFIG_RADIO_TERRATEC=m
# CONFIG_RADIO_TRUST is not set
# CONFIG_RADIO_TYPHOON is not set
# CONFIG_RADIO_ZOLTRIX is not set
CONFIG_USB_DSBR=m
CONFIG_USB_SI470X=m
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
# CONFIG_DVB_DYNAMIC_MINORS is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
CONFIG_DVB_BT8XX=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_PLL=m
CONFIG_DVB_ISL6421=m
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_HGA_ACCEL=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_CARILLO_RANCH=m
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
CONFIG_BACKLIGHT_SAHARA=m

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=m
CONFIG_SND_AD1816A=m
CONFIG_SND_AD1848=m
CONFIG_SND_ALS100=m
CONFIG_SND_AZT2320=m
CONFIG_SND_CMI8330=m
CONFIG_SND_CS4231=m
CONFIG_SND_CS4232=m
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
CONFIG_SND_ES1688=m
CONFIG_SND_ES18XX=m
CONFIG_SND_SC6000=m
CONFIG_SND_GUSCLASSIC=m
# CONFIG_SND_GUSEXTREME is not set
CONFIG_SND_GUSMAX=m
CONFIG_SND_INTERWAVE=m
CONFIG_SND_INTERWAVE_STB=m
CONFIG_SND_OPL3SA2=m
CONFIG_SND_OPTI92X_AD1848=m
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=m
CONFIG_SND_MIRO=m
# CONFIG_SND_SB8 is not set
CONFIG_SND_SB16=m
CONFIG_SND_SBAWE=m
CONFIG_SND_SB16_CSP=y
CONFIG_SND_SGALAXY=m
# CONFIG_SND_SSCAPE is not set
CONFIG_SND_WAVEFRONT=m
CONFIG_SND_WAVEFRONT_FIRMWARE_IN_KERNEL=y
# CONFIG_SND_PCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_MSNDCLAS=m
CONFIG_MSNDCLAS_INIT_FILE="/etc/sound/msndinit.bin"
CONFIG_MSNDCLAS_PERM_FILE="/etc/sound/msndperm.bin"
CONFIG_SOUND_MSNDPIN=m
CONFIG_MSNDPIN_INIT_FILE="/etc/sound/pndspini.bin"
CONFIG_MSNDPIN_PERM_FILE="/etc/sound/pndsperm.bin"
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_EZKEY=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_NTRIG=m
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SUNPLUS=m
CONFIG_GREENASIA_FF=y
# CONFIG_HID_TOPSEED is not set
CONFIG_THRUSTMASTER_FF=m
CONFIG_ZEROPLUS_FF=y
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
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
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
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=y
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIEMENS_MPI=m
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=y
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_NET48XX=m
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_ALIX2=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=y
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=y
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=y
CONFIG_EDAC_I5000=y
# CONFIG_EDAC_I5100 is not set
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
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_SMX=m
CONFIG_UIO_SERCOS3=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_OCFS2_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS is not set
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_EXPORTFS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_LKDTM=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
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
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_EVENT_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_KMEMTRACE=y
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_MMIOTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_PRINTK_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_SAMPLES=y
CONFIG_SAMPLE_MARKERS=m
CONFIG_SAMPLE_TRACEPOINTS=m
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_SAMPLE_KPROBES=m
CONFIG_SAMPLE_KRETPROBES=m
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=m
# CONFIG_KGDB_TESTS is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
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
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
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
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
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
# CONFIG_CRYPTO_CTR is not set
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
CONFIG_KVM_TRACE=y
# CONFIG_VIRTIO_PCI is not set
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
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y

--LZvS9be/3tNcYl/X--
