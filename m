Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZELQsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZELQsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZELQrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:47:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZELQre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:47:34 -0400
Date: Tue, 12 May 2009 18:46:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090512164617.GA21673@elte.hu>
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512150631.GA32067@elte.hu>
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


got this on a testbox:

[    0.113333] WARNING: at arch/x86/kernel/apic/apic.c:253 warn_slowpath_null+0x28/0x50()

	Ingo

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.30-rc5-tip-01553-g4bc9bac-dirty (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #48764 SMP PREEMPT Tue May 12 18:30:18 CEST 2009
[    0.000000] Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty debug initcall_debug apic=verbose sysrq_always_enabled 5 ignore_loglevel nosmp no_hz=off highres=0 nmi_watchdog=0 noapic nolapic_timer hpet=disable idle=poll notsc acpi=off
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff30000 (usable)
[    0.000000]  BIOS-e820: 000000003ff30000 - 000000003ff40000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff40000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] using polling idle threads.
[    0.000000] MPS support code is not built-in.
[    0.000000] Using acpi=off or acpi=noirq or pci=noacpi may have problem
[    0.000000] last_pfn = 0x3ff30 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 00F8000000 mask FFFC000000 write-combining
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003ff30000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003ff30000 page 4k
[    0.000000] kernel direct mapping tables up to 3ff30000 @ 8000-b000
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003ff30000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00022b6818]    TEXT DATA BSS ==> [0000200000 - 00022b6818]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003ff30
[    0.000000] On node 0 totalpages: 261839
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 100 pages reserved
[    0.000000]   DMA zone: 3795 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6547 pages used for memmap
[    0.000000]   DMA32 zone: 251293 pages, LIFO batch:31
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] nr_irqs_gsi: 16
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bff80000)
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages at ffff88000235a000, static data 1927968 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255088
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty debug initcall_debug apic=verbose sysrq_always_enabled 5 ignore_loglevel nosmp no_hz=off highres=0 nmi_watchdog=0 noapic nolapic_timer hpet=disable idle=poll notsc acpi=off
[    0.000000] debug: sysrq always enabled.
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:256
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2002.813 MHz processor.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console handover: boot [earlyser0] -> real [tty0]
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000000] ... CHAINHASH_SIZE:          8192
[    0.000000]  memory used by lock dependency info: 5567 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Checking aperture...
[    0.000000] AGP bridge at 00:00:00
[    0.000000] Aperture from AGP @ f8000000 old size 32 MB
[    0.000000] Aperture from AGP @ f8000000 size 64 MB (APSIZE f30)
[    0.000000] Node 0: aperture @ f8000000 size 64 MB
[    0.000000] Memory: 982364k/1047744k available (11619k kernel code, 388k absent, 64400k reserved, 8148k data, 2420k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.003333] Calibrating delay loop... 1991.60 BogoMIPS (lpj=3317760)
[    0.086666] Security Framework initialized
[    0.089999] TOMOYO Linux initialized
[    0.093333] Mount-cache hash table entries: 256
[    0.096666] Initializing cgroup subsys debug
[    0.099999] Initializing cgroup subsys ns
[    0.103333] Initializing cgroup subsys cpuacct
[    0.106666] Initializing cgroup subsys devices
[    0.109999] ------------[ cut here ]------------
[    0.113333] WARNING: at arch/x86/kernel/apic/apic.c:253 warn_slowpath_null+0x28/0x50()
[    0.116666] Modules linked in:
[    0.119999] Pid: 0, comm: swapper Not tainted 2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    0.123333] Call Trace:
[    0.126666]  [<ffffffff80282d0b>] warn_slowpath_fmt+0xbb/0x110
[    0.129999]  [<ffffffff80335807>] ? __alloc_pages_internal+0x157/0x6b0
[    0.133333]  [<ffffffff8061bf9b>] ? debug_smp_processor_id+0x4b/0x150
[    0.136666]  [<ffffffff80369a81>] ? check_bytes_and_report+0x21/0x1b0
[    0.139999]  [<ffffffff803484ac>] ? __mod_zone_page_state+0x7c/0x110
[    0.143333]  [<ffffffff80369771>] ? slab_pad_check+0x21/0x1f0
[    0.146666]  [<ffffffff8061bf9b>] ? debug_smp_processor_id+0x4b/0x150
[    0.149999]  [<ffffffff802433ba>] ? native_cpuid+0xa/0x30
[    0.153333]  [<ffffffff80d3fede>] ? init_scattered_cpuid_features+0xdc/0x19e
[    0.156666]  [<ffffffff802433ba>] ? native_cpuid+0xa/0x30
[    0.159999]  [<ffffffff802224b3>] ? cpuid+0x73/0xa0
[    0.163333]  [<ffffffff802433ba>] ? native_cpuid+0xa/0x30
[    0.166666]  [<ffffffff80282d88>] warn_slowpath_null+0x28/0x50
[    0.169999]  [<ffffffff80234f29>] native_apic_read_dummy+0xe9/0x110
[    0.173333]  [<ffffffff802352be>] hard_smp_processor_id+0x2e/0x60
[    0.176666]  [<ffffffff8023b444>] flat_phys_pkg_id+0x24/0x50
[    0.179999]  [<ffffffff80d40a52>] identify_cpu+0xcd/0x220
[    0.183333]  [<ffffffff81605df5>] identify_boot_cpu+0x23/0x6b
[    0.186666]  [<ffffffff81605ebc>] check_bugs+0x1c/0x60
[    0.189999]  [<ffffffff815ff32d>] start_kernel+0x47b/0x5d5
[    0.193332]  [<ffffffff815fe140>] ? early_idt_handler+0x0/0x71
[    0.196666]  [<ffffffff815fe2a8>] x86_64_start_reservations+0xa8/0xde
[    0.199999]  [<ffffffff815fe4cf>] x86_64_start_kernel+0x1f1/0x222
[    0.203332] ---[ end trace a7919e7f17c0a725 ]---
[    0.206666] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.209999] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.213332] tseg: 0000000000
[    0.216666] AMD Performance Monitoring support detected.
[    0.219999] ... version:         0
[    0.223332] ... bit width:       48
[    0.226666] ... num counters:    4
[    0.229999] ... value mask:      0000ffffffffffff
[    0.233332] ... max period:      00007fffffffffff
[    0.236666] ... fixed counters:  0
[    0.239999] ... counter mask:    000000000000000f
[    0.243332] SMP alternatives: switching to UP code
[    0.263332] Freeing SMP alternatives: 46k freed
[    0.266666] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.269999] ftrace: allocating 32647 entries in 129 pages
[    0.279999] Failed to register trace ftrace module notifier
[    0.283332] Setting APIC routing to flat
[    0.286666] weird, boot CPU (#0) not listed by the BIOS.
[    0.289999] SMP motherboard not detected.
[    0.293332] Apic disabled
[    0.296666] Local APIC not detected. Using dummy APIC emulation.
[    0.299999] SMP disabled
[    0.303332] calling  migration_init+0x0/0x9f @ 1
[    0.306666] initcall migration_init+0x0/0x9f returned 1 after 0 usecs
[    0.309999] initcall migration_init+0x0/0x9f returned with error code 1 
[    0.313332] calling  spawn_ksoftirqd+0x0/0xa3 @ 1
[    0.316666] initcall spawn_ksoftirqd+0x0/0xa3 returned 0 after 0 usecs
[    0.319999] calling  init_call_single_data+0x0/0xe9 @ 1
[    0.323332] initcall init_call_single_data+0x0/0xe9 returned 0 after 0 usecs
[    0.326666] calling  relay_init+0x0/0x40 @ 1
[    0.329999] initcall relay_init+0x0/0x40 returned 0 after 0 usecs
[    0.333332] calling  tracer_alloc_buffers+0x0/0x2af @ 1
[    0.336666] Testing tracer nop: PASSED
[    0.339999] initcall tracer_alloc_buffers+0x0/0x2af returned 0 after 3255 usecs
[    0.343332] calling  init_trace_printk+0x0/0x43 @ 1
[    0.346666] initcall init_trace_printk+0x0/0x43 returned 0 after 0 usecs
[    0.349999] calling  trace_workqueue_early_init+0x0/0x15a @ 1
[    0.353332] initcall trace_workqueue_early_init+0x0/0x15a returned 0 after 0 usecs
[    0.356666] Brought up 1 CPUs
[    0.359999] Total of 1 processors activated (1991.60 BogoMIPS).
[    0.363332] CPU0 attaching NULL sched-domain.
[    0.369999] device: 'platform': device_add
[    0.373332] PM: Adding info for No Bus:platform
[    0.376665] khelper used greatest stack depth: 5576 bytes left
[    0.379999] bus: 'platform': registered
[    0.383332] Registering sysdev class 'cpu'
[    0.386665] Registering sysdev class 'memory'
[    0.389999] Registering sys device of class 'memory'
[    0.393332] Registering sys device 'memory0'
[    0.396665] Registering sys device of class 'memory'
[    0.399999] Registering sys device 'memory1'
[    0.403332] Registering sys device of class 'memory'
[    0.406665] Registering sys device 'memory2'
[    0.409999] Registering sys device of class 'memory'
[    0.413332] Registering sys device 'memory3'
[    0.416665] Registering sys device of class 'memory'
[    0.419999] Registering sys device 'memory4'
[    0.423332] Registering sys device of class 'memory'
[    0.426665] Registering sys device 'memory5'
[    0.433332] Registering sys device of class 'memory'
[    0.436665] Registering sys device 'memory6'
[    0.439999] Registering sys device of class 'memory'
[    0.443332] Registering sys device 'memory7'
[    0.453332] calling  init_cpufreq_transition_notifier_list+0x0/0x42 @ 1
[    0.456665] initcall init_cpufreq_transition_notifier_list+0x0/0x42 returned 0 after 0 usecs
[    0.459999] calling  net_ns_init+0x0/0x150 @ 1
[    0.463332] net_namespace: 2264 bytes
[    0.466665] initcall net_ns_init+0x0/0x150 returned 0 after 3255 usecs
[    0.469999] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.473332] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.476665] calling  init_lapic_sysfs+0x0/0x54 @ 1
[    0.479999] initcall init_lapic_sysfs+0x0/0x54 returned 0 after 0 usecs
[    0.483332] calling  print_banner+0x0/0xe @ 1
[    0.486665] Booting paravirtualized kernel on bare hardware
[    0.489999] initcall print_banner+0x0/0xe returned 0 after 3255 usecs
[    0.493332] calling  init_smp_flush+0x0/0x70 @ 1
[    0.496665] initcall init_smp_flush+0x0/0x70 returned 0 after 0 usecs
[    0.499999] calling  alloc_frozen_cpus+0x0/0x50 @ 1
[    0.503332] initcall alloc_frozen_cpus+0x0/0x50 returned 0 after 0 usecs
[    0.506665] calling  sysctl_init+0x0/0x60 @ 1
[    0.509999] initcall sysctl_init+0x0/0x60 returned 0 after 0 usecs
[    0.513332] calling  ksysfs_init+0x0/0xeb @ 1
[    0.516665] initcall ksysfs_init+0x0/0xeb returned 0 after 0 usecs
[    0.519999] calling  async_init+0x0/0xb5 @ 1
[    0.523332] initcall async_init+0x0/0xb5 returned 0 after 0 usecs
[    0.526665] calling  init_jiffies_clocksource+0x0/0x3d @ 1
[    0.529999] initcall init_jiffies_clocksource+0x0/0x3d returned 0 after 0 usecs
[    0.533332] calling  pm_init+0x0/0x70 @ 1
[    0.536665] initcall pm_init+0x0/0x70 returned 0 after 0 usecs
[    0.539999] calling  filelock_init+0x0/0x63 @ 1
[    0.543332] initcall filelock_init+0x0/0x63 returned 0 after 0 usecs
[    0.546665] calling  init_script_binfmt+0x0/0x40 @ 1
[    0.549999] initcall init_script_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.553332] calling  init_elf_binfmt+0x0/0x40 @ 1
[    0.556665] initcall init_elf_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.559998] calling  init_compat_elf_binfmt+0x0/0x40 @ 1
[    0.563332] initcall init_compat_elf_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.566665] calling  debugfs_init+0x0/0x88 @ 1
[    0.569998] initcall debugfs_init+0x0/0x88 returned 0 after 0 usecs
[    0.573332] calling  securityfs_init+0x0/0x80 @ 1
[    0.576665] initcall securityfs_init+0x0/0x80 returned 0 after 0 usecs
[    0.579998] calling  random32_init+0x0/0x101 @ 1
[    0.583332] initcall random32_init+0x0/0x101 returned 0 after 0 usecs
[    0.586665] calling  regulator_init+0x0/0x55 @ 1
[    0.589998] regulator: core version 0.5
[    0.593332] device class 'regulator': registering
[    0.596665] initcall regulator_init+0x0/0x55 returned 0 after 6510 usecs
[    0.599998] calling  early_resume_init+0x0/0x40 @ 1
[    0.603332] Time: 16:27:27  Date: 05/12/09
[    0.606665] initcall early_resume_init+0x0/0x40 returned 0 after 3255 usecs
[    0.609998] calling  cpufreq_core_init+0x0/0xae @ 1
[    0.613332] initcall cpufreq_core_init+0x0/0xae returned 0 after 0 usecs
[    0.616665] calling  cpuidle_init+0x0/0x66 @ 1
[    0.619998] initcall cpuidle_init+0x0/0x66 returned 0 after 0 usecs
[    0.623332] calling  sock_init+0x0/0x90 @ 1
[    0.626665] initcall sock_init+0x0/0x90 returned 0 after 0 usecs
[    0.629998] calling  net_inuse_init+0x0/0x4f @ 1
[    0.633332] initcall net_inuse_init+0x0/0x4f returned 0 after 0 usecs
[    0.636665] calling  netpoll_init+0x0/0x69 @ 1
[    0.639998] initcall netpoll_init+0x0/0x69 returned 0 after 0 usecs
[    0.643332] calling  netlink_proto_init+0x0/0x189 @ 1
[    0.646665] NET: Registered protocol family 16
[    0.649998] initcall netlink_proto_init+0x0/0x189 returned 0 after 3255 usecs
[    0.653332] calling  bdi_class_init+0x0/0x68 @ 1
[    0.656665] device class 'bdi': registering
[    0.659998] initcall bdi_class_init+0x0/0x68 returned 0 after 3255 usecs
[    0.663332] calling  kobject_uevent_init+0x0/0x7b @ 1
[    0.666665] initcall kobject_uevent_init+0x0/0x7b returned 0 after 0 usecs
[    0.669998] calling  gpiolib_sysfs_init+0x0/0xc0 @ 1
[    0.673332] device class 'gpio': registering
[    0.676665] initcall gpiolib_sysfs_init+0x0/0xc0 returned 0 after 3255 usecs
[    0.679998] calling  pcibus_class_init+0x0/0x43 @ 1
[    0.683332] device class 'pci_bus': registering
[    0.686665] initcall pcibus_class_init+0x0/0x43 returned 0 after 3255 usecs
[    0.689998] calling  pci_driver_init+0x0/0x40 @ 1
[    0.693332] bus: 'pci': registered
[    0.696665] initcall pci_driver_init+0x0/0x40 returned 0 after 3255 usecs
[    0.699998] calling  lcd_class_init+0x0/0x9c @ 1
[    0.703332] device class 'lcd': registering
[    0.706665] initcall lcd_class_init+0x0/0x9c returned 0 after 3255 usecs
[    0.709998] calling  backlight_class_init+0x0/0xac @ 1
[    0.713332] device class 'backlight': registering
[    0.716665] initcall backlight_class_init+0x0/0xac returned 0 after 3255 usecs
[    0.719998] calling  video_output_class_init+0x0/0x45 @ 1
[    0.723332] device class 'video_output': registering
[    0.726665] initcall video_output_class_init+0x0/0x45 returned 0 after 3255 usecs
[    0.729998] calling  tty_class_init+0x0/0x78 @ 1
[    0.733332] device class 'tty': registering
[    0.736665] initcall tty_class_init+0x0/0x78 returned 0 after 3255 usecs
[    0.739998] calling  vtconsole_class_init+0x0/0x138 @ 1
[    0.743332] device class 'vtconsole': registering
[    0.746665] device: 'vtcon0': device_add
[    0.749998] PM: Adding info for No Bus:vtcon0
[    0.753331] initcall vtconsole_class_init+0x0/0x138 returned 0 after 9765 usecs
[    0.756665] calling  spi_init+0x0/0xd6 @ 1
[    0.759998] bus: 'spi': registered
[    0.763331] device class 'spi_master': registering
[    0.766665] initcall spi_init+0x0/0xd6 returned 0 after 6510 usecs
[    0.769998] calling  i2c_init+0x0/0x97 @ 1
[    0.773331] bus: 'i2c': registered
[    0.776665] device class 'i2c-adapter': registering
[    0.779998] bus: 'i2c': add driver dummy
[    0.783331] i2c-core: driver [dummy] registered
[    0.786665] initcall i2c_init+0x0/0x97 returned 0 after 13020 usecs
[    0.789998] calling  amd_postcore_init+0x0/0x60 @ 1
[    0.793331] node 0 link 0: io port [1000, ffffff]
[    0.796665] TOM: 0000000040000000 aka 1024M
[    0.799998] node 0 link 0: mmio [a0000, bffff]
[    0.803331] node 0 link 0: mmio [40000000, fe0bffff]
[    0.806665] bus: [00,ff] on node 0 link 0
[    0.809998] bus: 00 index 0 io port: [0, ffff]
[    0.813331] bus: 00 index 1 mmio: [a0000, bffff]
[    0.816665] bus: 00 index 2 mmio: [40000000, fcffffffff]
[    0.819998] initcall amd_postcore_init+0x0/0x60 returned 0 after 26041 usecs
[    0.826665] calling  arch_kdebugfs_init+0x0/0x6b @ 1
[    0.829998] initcall arch_kdebugfs_init+0x0/0x6b returned 0 after 0 usecs
[    0.833331] calling  mtrr_if_init+0x0/0xa0 @ 1
[    0.836665] initcall mtrr_if_init+0x0/0xa0 returned 0 after 0 usecs
[    0.839998] calling  ffh_cstate_init+0x0/0x5d @ 1
[    0.843331] initcall ffh_cstate_init+0x0/0x5d returned -1 after 0 usecs
[    0.846665] initcall ffh_cstate_init+0x0/0x5d returned with error code -1 
[    0.849998] calling  acpi_pci_init+0x0/0x93 @ 1
[    0.853331] initcall acpi_pci_init+0x0/0x93 returned 0 after 0 usecs
[    0.856665] calling  pci_arch_init+0x0/0x90 @ 1
[    0.859998] PCI: Using configuration type 1 for base access
[    0.863331] initcall pci_arch_init+0x0/0x90 returned 0 after 3255 usecs
[    0.866665] calling  topology_init+0x0/0x123 @ 1
[    0.869998] Registering sys device of class 'cpu'
[    0.873331] Registering sys device 'cpu0'
[    0.876665] initcall topology_init+0x0/0x123 returned 0 after 6510 usecs
[    0.879998] calling  mtrr_init_finialize+0x0/0x65 @ 1
[    0.883331] initcall mtrr_init_finialize+0x0/0x65 returned 0 after 0 usecs
[    0.886665] calling  param_sysfs_init+0x0/0x113 @ 1
[    0.956664] initcall param_sysfs_init+0x0/0x113 returned 0 after 65104 usecs
[    0.959998] calling  pm_sysrq_init+0x0/0x50 @ 1
[    0.963331] initcall pm_sysrq_init+0x0/0x50 returned 0 after 0 usecs
[    0.966664] calling  init_slow_work+0x0/0x63 @ 1
[    0.969998] initcall init_slow_work+0x0/0x63 returned 0 after 0 usecs
[    0.973331] calling  default_bdi_init+0x0/0x63 @ 1
[    0.976664] device: 'default': device_add
[    0.979998] PM: Adding info for No Bus:default
[    0.983331] initcall default_bdi_init+0x0/0x63 returned 0 after 6510 usecs
[    0.986664] calling  init_bio+0x0/0x105 @ 1
[    0.993331] bio: create slab <bio-0> at 0
[    0.996664] initcall init_bio+0x0/0x105 returned 0 after 3255 usecs
[    0.999998] calling  cryptomgr_init+0x0/0x65 @ 1
[    1.003331] initcall cryptomgr_init+0x0/0x65 returned 0 after 0 usecs
[    1.006664] calling  blk_settings_init+0x0/0x53 @ 1
[    1.009998] initcall blk_settings_init+0x0/0x53 returned 0 after 0 usecs
[    1.013331] calling  blk_ioc_init+0x0/0x51 @ 1
[    1.016664] initcall blk_ioc_init+0x0/0x51 returned 0 after 0 usecs
[    1.019998] calling  blk_softirq_init+0x0/0xc0 @ 1
[    1.023331] initcall blk_softirq_init+0x0/0xc0 returned 0 after 0 usecs
[    1.026664] calling  genhd_device_init+0x0/0xae @ 1
[    1.029998] device class 'block': registering
[    1.033331] initcall genhd_device_init+0x0/0xae returned 0 after 3255 usecs
[    1.036664] calling  gpiolib_debugfs_init+0x0/0x59 @ 1
[    1.039998] initcall gpiolib_debugfs_init+0x0/0x59 returned 0 after 0 usecs
[    1.043331] calling  pca953x_init+0x0/0x40 @ 1
[    1.046664] bus: 'i2c': add driver pca953x
[    1.049998] i2c-core: driver [pca953x] registered
[    1.053331] initcall pca953x_init+0x0/0x40 returned 0 after 6510 usecs
[    1.056664] calling  pci_slot_init+0x0/0x80 @ 1
[    1.059998] initcall pci_slot_init+0x0/0x80 returned 0 after 0 usecs
[    1.063331] calling  fbmem_init+0x0/0xdd @ 1
[    1.066664] device class 'graphics': registering
[    1.069998] initcall fbmem_init+0x0/0xdd returned 0 after 3255 usecs
[    1.073331] calling  acpi_init+0x0/0x14c @ 1
[    1.076664] ACPI: Interpreter disabled.
[    1.079998] initcall acpi_init+0x0/0x14c returned -19 after 3255 usecs
[    1.083331] calling  dock_init+0x0/0xb4 @ 1
[    1.086664] initcall dock_init+0x0/0xb4 returned 0 after 0 usecs
[    1.089998] calling  acpi_pci_root_init+0x0/0x4f @ 1
[    1.093331] initcall acpi_pci_root_init+0x0/0x4f returned 0 after 0 usecs
[    1.096664] calling  acpi_pci_link_init+0x0/0x6a @ 1
[    1.099998] initcall acpi_pci_link_init+0x0/0x6a returned 0 after 0 usecs
[    1.103331] calling  pnp_init+0x0/0x3c @ 1
[    1.106664] bus: 'pnp': registered
[    1.109998] initcall pnp_init+0x0/0x3c returned 0 after 3255 usecs
[    1.113331] calling  twl4030reg_init+0x0/0x40 @ 1
[    1.116664] bus: 'platform': add driver twl4030_reg
[    1.119998] initcall twl4030reg_init+0x0/0x40 returned 0 after 3255 usecs
[    1.123331] calling  misc_init+0x0/0xe6 @ 1
[    1.126664] device class 'misc': registering
[    1.129998] initcall misc_init+0x0/0xe6 returned 0 after 3255 usecs
[    1.133331] calling  cn_init+0x0/0x127 @ 1
[    1.136664] initcall cn_init+0x0/0x127 returned 0 after 0 usecs
[    1.139997] calling  tps_init+0x0/0x120 @ 1
[    1.143331] tps65010: version 2 May 2005
[    1.146664] bus: 'i2c': add driver tps65010
[    1.149997] i2c-core: driver [tps65010] registered
[    1.153331] bus: 'i2c': remove driver tps65010
[    1.159997] driver: 'tps65010': driver_release
[    1.163331] i2c-core: driver [tps65010] unregistered
[    1.179997] bus: 'i2c': add driver tps65010
[    1.183331] i2c-core: driver [tps65010] registered
[    1.186664] bus: 'i2c': remove driver tps65010
[    1.189997] driver: 'tps65010': driver_release
[    1.193331] i2c-core: driver [tps65010] unregistered
[    1.209997] bus: 'i2c': add driver tps65010
[    1.213331] i2c-core: driver [tps65010] registered
[    1.216664] bus: 'i2c': remove driver tps65010
[    1.219997] driver: 'tps65010': driver_release
[    1.223331] i2c-core: driver [tps65010] unregistered
[    1.226664] tps65010: no chip?
[    1.229997] initcall tps_init+0x0/0x120 returned -19 after 84635 usecs
[    1.233331] calling  twl4030_init+0x0/0x40 @ 1
[    1.236664] bus: 'i2c': add driver twl4030
[    1.239997] i2c-core: driver [twl4030] registered
[    1.243331] initcall twl4030_init+0x0/0x40 returned 0 after 6510 usecs
[    1.246664] calling  init_scsi+0x0/0xd0 @ 1
[    1.249997] device class 'scsi_host': registering
[    1.256664] bus: 'scsi': registered
[    1.259997] device class 'scsi_device': registering
[    1.263331] SCSI subsystem initialized
[    1.266664] initcall init_scsi+0x0/0xd0 returned 0 after 16276 usecs
[    1.269997] calling  ata_init+0x0/0xb7 @ 1
[    1.273331] libata version 3.00 loaded.
[    1.276664] initcall ata_init+0x0/0xb7 returned 0 after 3255 usecs
[    1.279997] calling  phy_init+0x0/0x65 @ 1
[    1.283331] device class 'mdio_bus': registering
[    1.289997] bus: 'mdio_bus': registered
[    1.293331] bus: 'mdio_bus': add driver Generic PHY
[    1.296664] initcall phy_init+0x0/0x65 returned 0 after 13020 usecs
[    1.299997] calling  usb_init+0x0/0x190 @ 1
[    1.303331] bus: 'usb': registered
[    1.306664] device class 'usb_host': registering
[    1.309997] bus: 'usb': add driver usbfs
[    1.313331] usbcore: registered new interface driver usbfs
[    1.316664] device class 'usb_device': registering
[    1.319997] bus: 'usb': add driver hub
[    1.323331] usbcore: registered new interface driver hub
[    1.326664] bus: 'usb': add driver usb
[    1.329997] usbcore: registered new device driver usb
[    1.336664] initcall usb_init+0x0/0x190 returned 0 after 32552 usecs
[    1.339997] calling  serio_init+0x0/0x100 @ 1
[    1.343330] bus: 'serio': registered
[    1.346664] initcall serio_init+0x0/0x100 returned 0 after 3255 usecs
[    1.349997] calling  gameport_init+0x0/0x100 @ 1
[    1.353330] bus: 'gameport': registered
[    1.356664] initcall gameport_init+0x0/0x100 returned 0 after 3255 usecs
[    1.359997] calling  input_init+0x0/0x16c @ 1
[    1.363330] device class 'input': registering
[    1.366664] initcall input_init+0x0/0x16c returned 0 after 3255 usecs
[    1.369997] calling  hwmon_init+0x0/0x90 @ 1
[    1.373330] device class 'hwmon': registering
[    1.376664] initcall hwmon_init+0x0/0x90 returned 0 after 3255 usecs
[    1.379997] calling  leds_init+0x0/0x90 @ 1
[    1.383330] device class 'leds': registering
[    1.386664] initcall leds_init+0x0/0x90 returned 0 after 3255 usecs
[    1.389997] calling  pci_subsys_init+0x0/0x170 @ 1
[    1.393330] PCI: Probing PCI hardware
[    1.396664] PCI: Probing PCI hardware (bus 00)
[    1.399997] device: 'pci0000:00': device_add
[    1.403330] PM: Adding info for No Bus:pci0000:00
[    1.406664] device: '0000:00': device_add
[    1.409997] PM: Adding info for No Bus:0000:00
[    1.413330] pci 0000:00:00.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
[    1.416664] pci 0000:00:01.0: supports D1
[    1.419997] pci 0000:00:07.0: reg 10 32bit mmio: [0xfde00000-0xfde007ff]
[    1.423330] pci 0000:00:07.0: reg 14 io port: [0xec00-0xec7f]
[    1.426664] pci 0000:00:07.0: supports D2
[    1.429997] pci 0000:00:07.0: PME# supported from D2 D3hot D3cold
[    1.433330] pci 0000:00:07.0: PME# disabled
[    1.436664] pci 0000:00:0a.0: reg 10 32bit mmio: [0xfd900000-0xfd903fff]
[    1.439997] pci 0000:00:0a.0: reg 14 io port: [0xb000-0xb0ff]
[    1.443330] pci 0000:00:0a.0: supports D1 D2
[    1.446664] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.449997] pci 0000:00:0a.0: PME# disabled
[    1.453330] pci 0000:00:0d.0: reg 10 32bit mmio: [0xf7e00000-0xf7e00fff]
[    1.456664] pci 0000:00:0d.1: reg 10 32bit mmio: [0xf7f00000-0xf7f00fff]
[    1.459997] pci 0000:00:0f.0: reg 10 io port: [0xe800-0xe807]
[    1.463330] pci 0000:00:0f.0: reg 14 io port: [0xe400-0xe403]
[    1.466664] pci 0000:00:0f.0: reg 18 io port: [0xe000-0xe007]
[    1.469997] pci 0000:00:0f.0: reg 1c io port: [0xd800-0xd803]
[    1.473330] pci 0000:00:0f.0: reg 20 io port: [0xd400-0xd40f]
[    1.476664] pci 0000:00:0f.0: reg 24 io port: [0xd000-0xd0ff]
[    1.479997] pci 0000:00:0f.1: reg 20 io port: [0xfc00-0xfc0f]
[    1.486664] pci 0000:00:10.0: reg 20 io port: [0xb400-0xb41f]
[    1.489997] pci 0000:00:10.0: supports D1 D2
[    1.493330] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.496664] pci 0000:00:10.0: PME# disabled
[    1.499997] pci 0000:00:10.1: reg 20 io port: [0xb800-0xb81f]
[    1.503330] pci 0000:00:10.1: supports D1 D2
[    1.506664] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.509997] pci 0000:00:10.1: PME# disabled
[    1.513330] pci 0000:00:10.2: reg 20 io port: [0xc000-0xc01f]
[    1.516664] pci 0000:00:10.2: supports D1 D2
[    1.519997] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.523330] pci 0000:00:10.2: PME# disabled
[    1.526664] pci 0000:00:10.3: reg 20 io port: [0xc400-0xc41f]
[    1.529997] pci 0000:00:10.3: supports D1 D2
[    1.533330] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.536664] pci 0000:00:10.3: PME# disabled
[    1.539997] pci 0000:00:10.4: reg 10 32bit mmio: [0xfdf00000-0xfdf000ff]
[    1.543330] pci 0000:00:10.4: supports D1 D2
[    1.546663] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.549997] pci 0000:00:10.4: PME# disabled
[    1.553330] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.556663] pci 0000:00:11.0: Enabled onboard AC97/MC97 devices
[    1.559997] pci 0000:00:11.5: reg 10 io port: [0xc800-0xc8ff]
[    1.563330] pci 0000:00:11.5: supports D1 D2
[    1.566663] pci 0000:00:11.6: reg 10 io port: [0x00-0xff]
[    1.569997] pci 0000:01:00.0: reg 10 32bit mmio: [0xe8000000-0xefffffff]
[    1.573330] pci 0000:01:00.0: reg 14 io port: [0xa000-0xa0ff]
[    1.576663] pci 0000:01:00.0: reg 18 32bit mmio: [0xfd800000-0xfd80ffff]
[    1.579997] pci 0000:01:00.0: reg 30 32bit mmio: [0xfd700000-0xfd71ffff]
[    1.583330] pci 0000:01:00.0: supports D1 D2
[    1.586663] pci 0000:01:00.1: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
[    1.589997] pci 0000:01:00.1: reg 14 32bit mmio: [0xfd600000-0xfd60ffff]
[    1.593330] pci 0000:01:00.1: supports D1 D2
[    1.596663] pci 0000:00:01.0: bridge io port: [0xa000-0xafff]
[    1.599997] pci 0000:00:01.0: bridge 32bit mmio: [0xfd300000-0xfd8fffff]
[    1.603330] pci 0000:00:01.0: bridge 32bit mmio pref: [0xd7b00000-0xf7afffff]
[    1.606663] device: '0000:00:00.0': device_add
[    1.609997] bus: 'pci': add device 0000:00:00.0
[    1.613330] PM: Adding info for pci:0000:00:00.0
[    1.616663] device: '0000:00:01.0': device_add
[    1.619997] bus: 'pci': add device 0000:00:01.0
[    1.623330] PM: Adding info for pci:0000:00:01.0
[    1.629997] device: '0000:00:07.0': device_add
[    1.633330] bus: 'pci': add device 0000:00:07.0
[    1.636663] PM: Adding info for pci:0000:00:07.0
[    1.639997] device: '0000:00:0a.0': device_add
[    1.643330] bus: 'pci': add device 0000:00:0a.0
[    1.646663] PM: Adding info for pci:0000:00:0a.0
[    1.649997] device: '0000:00:0d.0': device_add
[    1.653330] bus: 'pci': add device 0000:00:0d.0
[    1.656663] PM: Adding info for pci:0000:00:0d.0
[    1.659997] device: '0000:00:0d.1': device_add
[    1.663330] bus: 'pci': add device 0000:00:0d.1
[    1.666663] PM: Adding info for pci:0000:00:0d.1
[    1.673330] device: '0000:00:0f.0': device_add
[    1.676663] bus: 'pci': add device 0000:00:0f.0
[    1.679997] PM: Adding info for pci:0000:00:0f.0
[    1.683330] device: '0000:00:0f.1': device_add
[    1.686663] bus: 'pci': add device 0000:00:0f.1
[    1.689997] PM: Adding info for pci:0000:00:0f.1
[    1.693330] device: '0000:00:10.0': device_add
[    1.696663] bus: 'pci': add device 0000:00:10.0
[    1.699997] PM: Adding info for pci:0000:00:10.0
[    1.703330] device: '0000:00:10.1': device_add
[    1.706663] bus: 'pci': add device 0000:00:10.1
[    1.709997] PM: Adding info for pci:0000:00:10.1
[    1.713330] device: '0000:00:10.2': device_add
[    1.716663] bus: 'pci': add device 0000:00:10.2
[    1.719997] PM: Adding info for pci:0000:00:10.2
[    1.723330] device: '0000:00:10.3': device_add
[    1.726663] bus: 'pci': add device 0000:00:10.3
[    1.729997] PM: Adding info for pci:0000:00:10.3
[    1.733330] device: '0000:00:10.4': device_add
[    1.736663] bus: 'pci': add device 0000:00:10.4
[    1.739997] PM: Adding info for pci:0000:00:10.4
[    1.743330] device: '0000:00:11.0': device_add
[    1.746663] bus: 'pci': add device 0000:00:11.0
[    1.749996] PM: Adding info for pci:0000:00:11.0
[    1.753330] device: '0000:00:11.5': device_add
[    1.756663] bus: 'pci': add device 0000:00:11.5
[    1.759996] PM: Adding info for pci:0000:00:11.5
[    1.763330] device: '0000:00:11.6': device_add
[    1.766663] bus: 'pci': add device 0000:00:11.6
[    1.769996] PM: Adding info for pci:0000:00:11.6
[    1.773330] device: '0000:00:18.0': device_add
[    1.779996] bus: 'pci': add device 0000:00:18.0
[    1.783330] PM: Adding info for pci:0000:00:18.0
[    1.786663] device: '0000:00:18.1': device_add
[    1.789996] bus: 'pci': add device 0000:00:18.1
[    1.793330] PM: Adding info for pci:0000:00:18.1
[    1.796663] device: '0000:00:18.2': device_add
[    1.799996] bus: 'pci': add device 0000:00:18.2
[    1.803330] PM: Adding info for pci:0000:00:18.2
[    1.806663] device: '0000:00:18.3': device_add
[    1.809996] bus: 'pci': add device 0000:00:18.3
[    1.813330] PM: Adding info for pci:0000:00:18.3
[    1.816663] device: '0000:01:00.0': device_add
[    1.819996] bus: 'pci': add device 0000:01:00.0
[    1.823330] PM: Adding info for pci:0000:01:00.0
[    1.826663] device: '0000:01:00.1': device_add
[    1.829996] bus: 'pci': add device 0000:01:00.1
[    1.833330] PM: Adding info for pci:0000:01:00.1
[    1.836663] device: '0000:01': device_add
[    1.839996] PM: Adding info for No Bus:0000:01
[    1.843330] pci 0000:00:11.0: VIA IRQ router [1106:3227]
[    1.846663] PCI: setting IRQ 11 as level-triggered
[    1.849996] pci 0000:00:0f.1: found PCI INT A -> IRQ 11
[    1.853330] pci 0000:00:0f.1: sharing IRQ 11 with 0000:00:07.0
[    1.856663] pci 0000:00:0f.1: sharing IRQ 11 with 0000:00:10.0
[    1.859996] pci 0000:00:0f.1: sharing IRQ 11 with 0000:00:10.1
[    1.866663] PCI: setting IRQ 5 as level-triggered
[    1.869996] pci 0000:00:11.6: found PCI INT C -> IRQ 5
[    1.873330] pci 0000:00:11.6: sharing IRQ 5 with 0000:00:0d.0
[    1.876663] pci 0000:00:11.6: sharing IRQ 5 with 0000:00:0d.1
[    1.879996] pci 0000:00:11.6: sharing IRQ 5 with 0000:00:10.4
[    1.883330] pci 0000:00:11.6: sharing IRQ 5 with 0000:00:11.5
[    1.886663] pci 0000:00:00.0: BAR 0: can't allocate resource
[    1.889996] initcall pci_subsys_init+0x0/0x170 returned 0 after 485025 usecs
[    1.893330] calling  proto_init+0x0/0x3b @ 1
[    1.896663] initcall proto_init+0x0/0x3b returned 0 after 0 usecs
[    1.899996] calling  net_dev_init+0x0/0x20d @ 1
[    1.903330] device class 'net': registering
[    1.906663] device: 'lo': device_add
[    1.909996] PM: Adding info for No Bus:lo
[    1.913330] initcall net_dev_init+0x0/0x20d returned 0 after 9765 usecs
[    1.916663] calling  neigh_init+0x0/0x9d @ 1
[    1.919996] initcall neigh_init+0x0/0x9d returned 0 after 0 usecs
[    1.923330] calling  fib_rules_init+0x0/0xcc @ 1
[    1.926663] initcall fib_rules_init+0x0/0xcc returned 0 after 0 usecs
[    1.929996] calling  pktsched_init+0x0/0xf0 @ 1
[    1.933330] initcall pktsched_init+0x0/0xf0 returned 0 after 0 usecs
[    1.936663] calling  tc_filter_init+0x0/0x80 @ 1
[    1.939996] initcall tc_filter_init+0x0/0x80 returned 0 after 0 usecs
[    1.943330] calling  tc_action_init+0x0/0x80 @ 1
[    1.946663] initcall tc_action_init+0x0/0x80 returned 0 after 0 usecs
[    1.949996] calling  genl_init+0x0/0x10a @ 1
[    1.953329] initcall genl_init+0x0/0x10a returned 0 after 0 usecs
[    1.956663] calling  cipso_v4_init+0x0/0xb3 @ 1
[    1.959996] initcall cipso_v4_init+0x0/0xb3 returned 0 after 0 usecs
[    1.963329] calling  atm_init+0x0/0xe0 @ 1
[    1.966663] NET: Registered protocol family 8
[    1.969996] NET: Registered protocol family 20
[    1.973329] device class 'atm': registering
[    1.976663] initcall atm_init+0x0/0xe0 returned 0 after 9765 usecs
[    1.979996] calling  wireless_nlevent_init+0x0/0x70 @ 1
[    1.983329] initcall wireless_nlevent_init+0x0/0x70 returned 0 after 0 usecs
[    1.986663] calling  netlbl_init+0x0/0xb5 @ 1
[    1.989996] NetLabel: Initializing
[    1.993329] NetLabel:  domain hash size = 128
[    1.996663] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.999996] NetLabel:  unlabeled traffic allowed by default
[    2.003329] initcall netlbl_init+0x0/0xb5 returned 0 after 13020 usecs
[    2.006663] calling  sysctl_init+0x0/0x6f @ 1
[    2.009996] initcall sysctl_init+0x0/0x6f returned 0 after 0 usecs
[    2.013329] calling  pci_iommu_init+0x0/0x68 @ 1
[    2.069996] DMA-API: preallocated 32768 debug entries
[    2.073329] DMA-API: debugging enabled by kernel config
[    2.079996] bus: 'pci': add driver agpgart-amd64
[    2.083329] bus: 'pci': driver_probe_device: matched device 0000:00:00.0 with driver agpgart-amd64
[    2.086663] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:00.0
[    2.089996] agpgart-amd64 0000:00:00.0: AGP bridge [1106/3188]
[    2.096663] device: 'agpgart': device_add
[    2.099996] PM: Adding info for No Bus:agpgart
[    2.103329] agpgart-amd64 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
[    2.106663] driver: '0000:00:00.0': driver_bound: bound to device 'agpgart-amd64'
[    2.109996] bus: 'pci': really_probe: bound device 0000:00:00.0 to driver agpgart-amd64
[    2.116663] initcall pci_iommu_init+0x0/0x68 returned 0 after 97656 usecs
[    2.119996] calling  print_all_ICs+0x0/0x63 @ 1
[    2.123329] 
[    2.123329] printing PIC contents
[    2.126663] ... PIC  IMR: fffa
[    2.126663] ... PIC  IRR: 0000
[    2.129996] ... PIC  ISR: 0000
[    2.133329] ... PIC ELCR: 0c20
[    2.136663] initcall print_all_ICs+0x0/0x63 returned 0 after 13020 usecs
[    2.139996] calling  hpet_late_init+0x0/0x169 @ 1
[    2.143329] initcall hpet_late_init+0x0/0x169 returned -19 after 0 usecs
[    2.146663] calling  clocksource_done_booting+0x0/0x37 @ 1
[    2.149996] initcall clocksource_done_booting+0x0/0x37 returned 0 after 0 usecs
[    2.153329] calling  ftrace_init_debugfs+0x0/0x101 @ 1
[    2.156662] initcall ftrace_init_debugfs+0x0/0x101 returned 0 after 0 usecs
[    2.159996] calling  rb_init_debugfs+0x0/0x60 @ 1
[    2.163329] initcall rb_init_debugfs+0x0/0x60 returned 0 after 0 usecs
[    2.166662] calling  tracer_init_debugfs+0x0/0x27b @ 1
[    2.173329] initcall tracer_init_debugfs+0x0/0x27b returned 0 after 3255 usecs
[    2.176662] calling  init_trace_printk_function_export+0x0/0x5d @ 1
[    2.179996] initcall init_trace_printk_function_export+0x0/0x5d returned 0 after 0 usecs
[    2.183329] calling  init_annotated_branch_stats+0x0/0x64 @ 1
[    2.186662] Warning: could not register annotated branches stats
[    2.189996] initcall init_annotated_branch_stats+0x0/0x64 returned 1 after 3255 usecs
[    2.193329] initcall init_annotated_branch_stats+0x0/0x64 returned with error code 1 
[    2.196662] calling  stat_workqueue_init+0x0/0x66 @ 1
[    2.199996] initcall stat_workqueue_init+0x0/0x66 returned 0 after 0 usecs
[    2.203329] calling  event_trace_init+0x0/0x1d0 @ 1
[    2.209996] Failed to register trace events module notifier
[    2.213329] initcall event_trace_init+0x0/0x1d0 returned 0 after 6510 usecs
[    2.216662] calling  trace_objects_mm_init+0x0/0x5d @ 1
[    2.219996] initcall trace_objects_mm_init+0x0/0x5d returned 0 after 0 usecs
[    2.223329] calling  init_pipe_fs+0x0/0x96 @ 1
[    2.226662] initcall init_pipe_fs+0x0/0x96 returned 0 after 0 usecs
[    2.229996] calling  init_mnt_writers+0x0/0xaf @ 1
[    2.233329] initcall init_mnt_writers+0x0/0xaf returned 0 after 0 usecs
[    2.236662] calling  anon_inode_init+0x0/0x1aa @ 1
[    2.239996] initcall anon_inode_init+0x0/0x1aa returned 0 after 0 usecs
[    2.243329] calling  tomoyo_initerface_init+0x0/0x186 @ 1
[    2.246662] initcall tomoyo_initerface_init+0x0/0x186 returned 0 after 0 usecs
[    2.249996] calling  acpi_event_init+0x0/0xa7 @ 1
[    2.253329] initcall acpi_event_init+0x0/0xa7 returned 0 after 0 usecs
[    2.256662] calling  pnpacpi_init+0x0/0xb5 @ 1
[    2.259996] pnp: PnP ACPI: disabled
[    2.263329] initcall pnpacpi_init+0x0/0xb5 returned 0 after 3255 usecs
[    2.266662] calling  pnp_system_init+0x0/0x40 @ 1
[    2.269996] bus: 'pnp': add driver system
[    2.273329] initcall pnp_system_init+0x0/0x40 returned 0 after 3255 usecs
[    2.276662] calling  chr_dev_init+0x0/0xe0 @ 1
[    2.279996] device class 'mem': registering
[    2.286662] device: 'mem': device_add
[    2.289996] PM: Adding info for No Bus:mem
[    2.293329] device: 'kmem': device_add
[    2.296662] PM: Adding info for No Bus:kmem
[    2.303329] device: 'null': device_add
[    2.306662] PM: Adding info for No Bus:null
[    2.309996] device: 'port': device_add
[    2.313329] PM: Adding info for No Bus:port
[    2.316662] device: 'zero': device_add
[    2.319996] PM: Adding info for No Bus:zero
[    2.323329] device: 'full': device_add
[    2.326662] PM: Adding info for No Bus:full
[    2.329996] device: 'random': device_add
[    2.333329] PM: Adding info for No Bus:random
[    2.336662] device: 'urandom': device_add
[    2.339996] PM: Adding info for No Bus:urandom
[    2.343329] device: 'kmsg': device_add
[    2.346662] PM: Adding info for No Bus:kmsg
[    2.349996] device: 'oldmem': device_add
[    2.353329] PM: Adding info for No Bus:oldmem
[    2.356662] initcall chr_dev_init+0x0/0xe0 returned 0 after 74869 usecs
[    2.359996] calling  firmware_class_init+0x0/0xab @ 1
[    2.363329] device class 'firmware': registering
[    2.366662] initcall firmware_class_init+0x0/0xab returned 0 after 3255 usecs
[    2.369995] calling  cpufreq_gov_userspace_init+0x0/0x40 @ 1
[    2.373329] initcall cpufreq_gov_userspace_init+0x0/0x40 returned 0 after 0 usecs
[    2.376662] calling  init_acpi_pm_clocksource+0x0/0x12f @ 1
[    2.379995] initcall init_acpi_pm_clocksource+0x0/0x12f returned -19 after 0 usecs
[    2.383329] calling  pcibios_assign_resources+0x0/0xb5 @ 1
[    2.386662] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    2.389995] pci 0000:00:01.0:   IO window: 0xa000-0xafff
[    2.393329] pci 0000:00:01.0:   MEM window: 0xfd300000-0xfd8fffff
[    2.396662] pci 0000:00:01.0:   PREFETCH window: 0x000000d7b00000-0x000000f7afffff
[    2.399995] pci 0000:00:01.0: setting latency timer to 64
[    2.403329] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.406662] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    2.409995] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    2.413329] pci_bus 0000:01: resource 1 mem: [0xfd300000-0xfd8fffff]
[    2.416662] pci_bus 0000:01: resource 2 pref mem [0xd7b00000-0xf7afffff]
[    2.419995] initcall pcibios_assign_resources+0x0/0xb5 returned 0 after 32552 usecs
[    2.423329] calling  sysctl_core_init+0x0/0x70 @ 1
[    2.426662] initcall sysctl_core_init+0x0/0x70 returned 0 after 0 usecs
[    2.429995] calling  inet_init+0x0/0x26e @ 1
[    2.433329] NET: Registered protocol family 2
[    2.436662] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.443329] IPv4 FIB: Using LC-trie version 0.408
[    2.446662] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.449995] TCP bind hash table entries: 32768 (order: 9, 2359296 bytes)
[    2.456662] TCP: Hash tables configured (established 131072 bind 32768)
[    2.459995] TCP reno registered
[    2.463329] initcall inet_init+0x0/0x26e returned 0 after 29296 usecs
[    2.466662] calling  af_unix_init+0x0/0x89 @ 1
[    2.469995] NET: Registered protocol family 1
[    2.473329] initcall af_unix_init+0x0/0x89 returned 0 after 3255 usecs
[    2.476662] calling  populate_rootfs+0x0/0x14b @ 1
[    2.479995] initcall populate_rootfs+0x0/0x14b returned 0 after 0 usecs
[    2.483329] calling  i8259A_init_sysfs+0x0/0x50 @ 1
[    2.486662] Registering sysdev class 'i8259'
[    2.489995] Registering sys device of class 'i8259'
[    2.493329] Registering sys device 'i82590'
[    2.496662] initcall i8259A_init_sysfs+0x0/0x50 returned 0 after 9765 usecs
[    2.499995] calling  vsyscall_init+0x0/0x6c @ 1
[    2.503329] initcall vsyscall_init+0x0/0x6c returned 0 after 0 usecs
[    2.506662] calling  sbf_init+0x0/0x140 @ 1
[    2.509995] initcall sbf_init+0x0/0x140 returned 0 after 0 usecs
[    2.516662] calling  i8237A_init_sysfs+0x0/0x4d @ 1
[    2.519995] Registering sysdev class 'i8237'
[    2.523329] Registering sys device of class 'i8237'
[    2.526662] Registering sys device 'i82370'
[    2.529995] initcall i8237A_init_sysfs+0x0/0x4d returned 0 after 9765 usecs
[    2.533329] calling  add_rtc_cmos+0x0/0xf6 @ 1
[    2.536662] Registering platform device 'rtc_cmos'. Parent at platform
[    2.539995] device: 'rtc_cmos': device_add
[    2.543329] bus: 'platform': add device rtc_cmos
[    2.546662] PM: Adding info for platform:rtc_cmos
[    2.549995] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    2.553329] initcall add_rtc_cmos+0x0/0xf6 returned 0 after 16276 usecs
[    2.556662] calling  ds_selftest+0x0/0x3a @ 1
[    2.559995] initcall ds_selftest+0x0/0x3a returned 0 after 0 usecs
[    2.563329] calling  cache_sysfs_init+0x0/0x90 @ 1
[    2.566662] initcall cache_sysfs_init+0x0/0x90 returned 0 after 0 usecs
[    2.569995] calling  mce_init_device+0x0/0x10f @ 1
[    2.573329] Registering sysdev class 'machinecheck'
[    2.576662] Registering sys device of class 'machinecheck'
[    2.579995] Registering sys device 'machinecheck0'
[    2.586662] device: 'mcelog': device_add
[    2.589995] PM: Adding info for No Bus:mcelog
[    2.593328] initcall mce_init_device+0x0/0x10f returned 0 after 19531 usecs
[    2.596662] calling  periodic_mcheck_init+0x0/0x3c @ 1
[    2.599995] initcall periodic_mcheck_init+0x0/0x3c returned 0 after 0 usecs
[    2.603328] calling  thermal_throttle_init_device+0x0/0x120 @ 1
[    2.606662] initcall thermal_throttle_init_device+0x0/0x120 returned 0 after 0 usecs
[    2.609995] calling  threshold_init_device+0x0/0xd0 @ 1
[    2.613328] initcall threshold_init_device+0x0/0xd0 returned 0 after 0 usecs
[    2.616662] calling  msr_init+0x0/0x150 @ 1
[    2.619995] device class 'msr': registering
[    2.626662] device: 'msr0': device_add
[    2.629995] PM: Adding info for No Bus:msr0
[    2.633328] initcall msr_init+0x0/0x150 returned 0 after 13020 usecs
[    2.636662] calling  cpuid_init+0x0/0x150 @ 1
[    2.639995] device class 'cpuid': registering
[    2.643328] device: 'cpu0': device_add
[    2.646662] PM: Adding info for No Bus:cpu0
[    2.649995] initcall cpuid_init+0x0/0x150 returned 0 after 9765 usecs
[    2.653328] calling  ioapic_init_sysfs+0x0/0xf3 @ 1
[    2.656662] Registering sysdev class 'ioapic'
[    2.659995] initcall ioapic_init_sysfs+0x0/0xf3 returned 0 after 3255 usecs
[    2.663328] calling  pt_dump_init+0x0/0x60 @ 1
[    2.666662] initcall pt_dump_init+0x0/0x60 returned 0 after 0 usecs
[    2.669995] calling  aes_init+0x0/0x3d @ 1
[    2.673328] initcall aes_init+0x0/0x3d returned 0 after 0 usecs
[    2.676662] calling  aesni_init+0x0/0xe3 @ 1
[    2.679995] Intel AES-NI instructions are not detected.
[    2.683328] initcall aesni_init+0x0/0xe3 returned -19 after 3255 usecs
[    2.686662] calling  init_vdso_vars+0x0/0x291 @ 1
[    2.689995] initcall init_vdso_vars+0x0/0x291 returned 0 after 0 usecs
[    2.693328] calling  ia32_binfmt_init+0x0/0x3c @ 1
[    2.696662] initcall ia32_binfmt_init+0x0/0x3c returned 0 after 0 usecs
[    2.699995] calling  sysenter_setup+0x0/0x10b @ 1
[    2.703328] initcall sysenter_setup+0x0/0x10b returned 0 after 0 usecs
[    2.706662] calling  init_sched_debug_procfs+0x0/0x53 @ 1
[    2.709995] initcall init_sched_debug_procfs+0x0/0x53 returned 0 after 0 usecs
[    2.713328] calling  proc_schedstat_init+0x0/0x50 @ 1
[    2.716662] initcall proc_schedstat_init+0x0/0x50 returned 0 after 0 usecs
[    2.719995] calling  proc_execdomains_init+0x0/0x50 @ 1
[    2.723328] initcall proc_execdomains_init+0x0/0x50 returned 0 after 0 usecs
[    2.726662] calling  ioresources_init+0x0/0x65 @ 1
[    2.733328] initcall ioresources_init+0x0/0x65 returned 0 after 3255 usecs
[    2.736662] calling  uid_cache_init+0x0/0xb5 @ 1
[    2.739995] initcall uid_cache_init+0x0/0xb5 returned 0 after 0 usecs
[    2.743328] calling  init_posix_timers+0x0/0x110 @ 1
[    2.746662] initcall init_posix_timers+0x0/0x110 returned 0 after 0 usecs
[    2.749995] calling  init_posix_cpu_timers+0x0/0xe0 @ 1
[    2.753328] initcall init_posix_cpu_timers+0x0/0xe0 returned 0 after 0 usecs
[    2.756662] calling  nsproxy_cache_init+0x0/0x5b @ 1
[    2.759995] initcall nsproxy_cache_init+0x0/0x5b returned 0 after 0 usecs
[    2.763328] calling  timekeeping_init_device+0x0/0x4d @ 1
[    2.766662] Registering sysdev class 'timekeeping'
[    2.769995] Registering sys device of class 'timekeeping'
[    2.773328] Registering sys device 'timekeeping0'
[    2.776662] initcall timekeeping_init_device+0x0/0x4d returned 0 after 9765 usecs
[    2.779995] calling  init_clocksource_sysfs+0x0/0x7b @ 1
[    2.783328] Registering sysdev class 'clocksource'
[    2.786662] Registering sys device of class 'clocksource'
[    2.789995] Registering sys device 'clocksource0'
[    2.793328] initcall init_clocksource_sysfs+0x0/0x7b returned 0 after 9765 usecs
[    2.796662] calling  init_timer_list_procfs+0x0/0x53 @ 1
[    2.799995] initcall init_timer_list_procfs+0x0/0x53 returned 0 after 0 usecs
[    2.803328] calling  lockdep_proc_init+0x0/0x8d @ 1
[    2.806661] initcall lockdep_proc_init+0x0/0x8d returned 0 after 0 usecs
[    2.809995] calling  futex_init+0x0/0xc3 @ 1
[    2.813328] initcall futex_init+0x0/0xc3 returned 0 after 0 usecs
[    2.816661] calling  proc_dma_init+0x0/0x50 @ 1
[    2.819995] initcall proc_dma_init+0x0/0x50 returned 0 after 0 usecs
[    2.823328] calling  proc_modules_init+0x0/0x50 @ 1
[    2.826661] initcall proc_modules_init+0x0/0x50 returned 0 after 0 usecs
[    2.829995] calling  kallsyms_init+0x0/0x50 @ 1
[    2.833328] initcall kallsyms_init+0x0/0x50 returned 0 after 0 usecs
[    2.836661] calling  crash_save_vmcoreinfo_init+0x0/0x4d4 @ 1
[    2.839995] initcall crash_save_vmcoreinfo_init+0x0/0x4d4 returned 0 after 0 usecs
[    2.843328] calling  crash_notes_memory_init+0x0/0x61 @ 1
[    2.846661] initcall crash_notes_memory_init+0x0/0x61 returned 0 after 0 usecs
[    2.849995] calling  backtrace_regression_test+0x0/0x120 @ 1
[    2.853328] ====[ backtrace testing ]===========
[    2.856661] Testing a backtrace from process context.
[    2.859995] The following trace is a kernel self test and not a bug!
[    2.863328] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    2.866661] Call Trace:
[    2.869995]  [<ffffffff802d6210>] ? backtrace_regression_test+0x0/0x120
[    2.873328]  [<ffffffff802d625a>] backtrace_regression_test+0x4a/0x120
[    2.876661]  [<ffffffff802ac1bb>] ? ktime_get+0x5b/0xa0
[    2.879995]  [<ffffffff8161a3f1>] ? crash_save_vmcoreinfo_init+0x0/0x4d4
[    2.883328]  [<ffffffff802d6210>] ? backtrace_regression_test+0x0/0x120
[    2.886661]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    2.889995]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    2.893328]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    2.896661]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    2.899995]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    2.903328]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    2.906661]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    2.909995]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    2.913328]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    2.916661]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    2.919995]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    2.923328]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    2.926661]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    2.929995]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    2.933328]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    2.936661]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    2.939995]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    2.943328]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    2.946661] Testing a backtrace from irq context.
[    2.949995] The following trace is a kernel self test and not a bug!
[    2.953328] Pid: 4, comm: ksoftirqd/0 Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    2.956661] Call Trace:
[    2.959995]  <IRQ>  [<ffffffff802d61e1>] backtrace_test_irq_callback+0x21/0x50
[    2.966661]  [<ffffffff8028bda5>] tasklet_action+0xc5/0x180
[    2.969995]  [<ffffffff8028d0e3>] __do_softirq+0x153/0x300
[    2.973328]  [<ffffffff8028dc80>] ? ksoftirqd+0x0/0x2c0
[    2.976661]  [<ffffffff8020e17c>] call_softirq+0x1c/0xb0
[    2.979995]  <EOI>  [<ffffffff80210bad>] do_softirq+0xbd/0x180
[    2.986661]  [<ffffffff80d534c1>] ? add_preempt_count+0x151/0x160
[    2.989995]  [<ffffffff8028dc80>] ? ksoftirqd+0x0/0x2c0
[    2.993328]  [<ffffffff8028deaf>] ksoftirqd+0x22f/0x2c0
[    2.996661]  [<ffffffff8026515f>] ? complete+0x5f/0x90
[    2.999995]  [<ffffffff8028dc80>] ? ksoftirqd+0x0/0x2c0
[    3.003328]  [<ffffffff802a6b5e>] kthread+0x6e/0xc0
[    3.006661]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    3.009995]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    3.013328]  [<ffffffff802a6af0>] ? kthread+0x0/0xc0
[    3.016661]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    3.019994] Testing a saved backtrace.
[    3.023328] The following trace is a kernel self test and not a bug!
[    3.026661]  [<ffffffff80220f9e>] save_stack_trace+0x3e/0x80
[    3.029994]  [<ffffffff802d62f8>] backtrace_regression_test+0xe8/0x120
[    3.036661]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    3.043328]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    3.049994]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    3.053328]  [<ffffffffffffffff>] 0xffffffffffffffff
[    3.059994] ====[ end of backtrace testing ]====
[    3.063328] initcall backtrace_regression_test+0x0/0x120 returned 0 after 205077 usecs
[    3.066661] calling  pid_namespaces_init+0x0/0x5e @ 1
[    3.069994] initcall pid_namespaces_init+0x0/0x5e returned 0 after 0 usecs
[    3.073328] calling  init_kprobes+0x0/0x1e5 @ 1
[    3.083328] Kprobe smoke test started
[    3.169994] Kprobe smoke test passed successfully
[    3.173328] initcall init_kprobes+0x0/0x1e5 returned 0 after 94400 usecs
[    3.176661] calling  utsname_sysctl_init+0x0/0x3d @ 1
[    3.179994] sysctl table check failed: /kernel/ostype .1.1 No proc_handler
[    3.186661] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    3.189994] Call Trace:
[    3.189994]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    3.193328]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    3.196661]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    3.199994]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    3.203328]  [<ffffffff8161bb50>] ? utsname_sysctl_init+0x0/0x3d
[    3.206661]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    3.209994]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    3.213328]  [<ffffffff8161bb73>] utsname_sysctl_init+0x23/0x3d
[    3.216661]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    3.219994]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    3.223328]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.226661]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.229994]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    3.233328]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    3.236661]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    3.239994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.243327]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.246661]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    3.249994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.253327]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    3.256661]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    3.259994]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    3.263327]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    3.266661]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    3.269994]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    3.273327]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    3.276661] sysctl table check failed: /kernel/osrelease .1.2 No proc_handler
[    3.283327] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    3.286661] Call Trace:
[    3.289994]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    3.293327]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    3.296661]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    3.299994]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    3.303327]  [<ffffffff8161bb50>] ? utsname_sysctl_init+0x0/0x3d
[    3.306661]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    3.309994]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    3.313327]  [<ffffffff8161bb73>] utsname_sysctl_init+0x23/0x3d
[    3.316661]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    3.319994]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    3.323327]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.326661]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.329994]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    3.333327]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    3.336661]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    3.339994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.343327]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.346661]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    3.349994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.353327]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    3.356661]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    3.359994]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    3.363327]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    3.366661]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    3.369994]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    3.373327]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    3.376661] sysctl table check failed: /kernel/version .1.4 No proc_handler
[    3.386661] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    3.389994] Call Trace:
[    3.393327]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    3.396661]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    3.399994]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    3.403327]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    3.406661]  [<ffffffff8161bb50>] ? utsname_sysctl_init+0x0/0x3d
[    3.409994]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    3.413327]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    3.416661]  [<ffffffff8161bb73>] utsname_sysctl_init+0x23/0x3d
[    3.419994]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    3.423327]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    3.426661]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.429994]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.433327]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    3.436661]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    3.439994]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    3.443327]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.446661]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.449994]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    3.453327]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.456661]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    3.459994]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    3.463327]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    3.466661]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    3.469994]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    3.473327]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    3.476660]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    3.479994] sysctl table check failed: /kernel/hostname .1.7 No proc_handler
[    3.486660] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    3.489994] Call Trace:
[    3.489994]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    3.493327]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    3.496660]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    3.499994]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    3.503327]  [<ffffffff8161bb50>] ? utsname_sysctl_init+0x0/0x3d
[    3.506660]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    3.509994]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    3.513327]  [<ffffffff8161bb73>] utsname_sysctl_init+0x23/0x3d
[    3.516660]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    3.519994]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    3.523327]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.526660]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.529994]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    3.533327]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    3.536660]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    3.539994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.543327]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.546660]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    3.549994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.553327]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    3.556660]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    3.559994]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    3.563327]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    3.566660]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    3.569994]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    3.573327]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    3.576660] sysctl table check failed: /kernel/domainname .1.8 No proc_handler
[    3.583327] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    3.586660] Call Trace:
[    3.589994]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    3.593327]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    3.596660]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    3.599994]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    3.603327]  [<ffffffff8161bb50>] ? utsname_sysctl_init+0x0/0x3d
[    3.606660]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    3.609994]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    3.613327]  [<ffffffff8161bb73>] utsname_sysctl_init+0x23/0x3d
[    3.616660]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    3.619994]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    3.623327]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.626660]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.629994]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    3.633327]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    3.636660]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    3.639994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.643327]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    3.646660]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    3.649994]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    3.653327]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    3.656660]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    3.659994]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    3.663327]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    3.666660]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    3.669994]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    3.673327]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    3.676660] initcall utsname_sysctl_init+0x0/0x3d returned 0 after 485025 usecs
[    3.679994] calling  init_markers+0x0/0x50 @ 1
[    3.683327] initcall init_markers+0x0/0x50 returned 0 after 0 usecs
[    3.686660] calling  init_tracepoints+0x0/0x50 @ 1
[    3.689994] initcall init_tracepoints+0x0/0x50 returned 0 after 0 usecs
[    3.693327] calling  init_lstats_procfs+0x0/0x50 @ 1
[    3.696660] initcall init_lstats_procfs+0x0/0x50 returned 0 after 0 usecs
[    3.699993] calling  ftrace_mod_cmd_init+0x0/0x3d @ 1
[    3.703327] initcall ftrace_mod_cmd_init+0x0/0x3d returned 0 after 0 usecs
[    3.706660] calling  init_events+0x0/0x9d @ 1
[    3.709993] initcall init_events+0x0/0x9d returned 0 after 0 usecs
[    3.713327] calling  init_sched_switch_trace+0x0/0x40 @ 1
[    3.716660] Testing tracer sched_switch: PASSED
[    3.823327] initcall init_sched_switch_trace+0x0/0x40 returned 0 after 104166 usecs
[    3.826660] calling  init_stack_trace+0x0/0x3d @ 1
[    3.829993] Testing tracer sysprof: .. no entries found ..FAILED!
[    3.936660] initcall init_stack_trace+0x0/0x3d returned -1 after 104166 usecs
[    3.939993] initcall init_stack_trace+0x0/0x3d returned with error code -1 
[    3.943326] calling  init_function_trace+0x0/0x73 @ 1
[    3.946660] Testing tracer function: PASSED
[    4.066660] Testing dynamic ftrace: PASSED
[    4.306659] initcall init_function_trace+0x0/0x73 returned 0 after 351562 usecs
[    4.309993] calling  init_irqsoff_tracer+0x0/0x60 @ 1
[    4.313326] Testing tracer irqsoff: .. no entries found ..FAILED!
[    4.323326] Testing tracer preemptoff: .. no entries found ..FAILED!
[    4.329993] Testing tracer preemptirqsoff: .. no entries found ..FAILED!
[    4.336659] initcall init_irqsoff_tracer+0x0/0x60 returned 0 after 22786 usecs
[    4.339993] calling  init_wakeup_tracer+0x0/0x4d @ 1
[    4.343326] Testing tracer wakeup: .. no entries found ..FAILED!
[    4.656659] initcall init_wakeup_tracer+0x0/0x4d returned -1 after 305989 usecs
[    4.659992] initcall init_wakeup_tracer+0x0/0x4d returned with error code -1 
[    4.663325] calling  stack_trace_init+0x0/0xa0 @ 1
[    4.666659] initcall stack_trace_init+0x0/0xa0 returned 0 after 0 usecs
[    4.669992] calling  init_mmio_trace+0x0/0x40 @ 1
[    4.673325] initcall init_mmio_trace+0x0/0x40 returned 0 after 0 usecs
[    4.676659] calling  init_graph_trace+0x0/0x40 @ 1
[    4.679992] Testing tracer function_graph: PASSED
[    4.789992] initcall init_graph_trace+0x0/0x40 returned 0 after 107421 usecs
[    4.793325] calling  init_branch_tracer+0x0/0x5c @ 1
[    4.796659] Testing tracer branch: PASSED
[    4.903325] initcall init_branch_tracer+0x0/0x5c returned 0 after 104166 usecs
[    4.906658] calling  init_bts_trace+0x0/0x50 @ 1
[    4.909992] Testing tracer hw-branch-tracer: <4>Failed to init hw-branch-tracer tracer, init returned -95
[    4.919992] FAILED!
[    4.919992] initcall init_bts_trace+0x0/0x50 returned -95 after 9765 usecs
[    4.923325] initcall init_bts_trace+0x0/0x50 returned with error code -95 
[    4.926658] calling  init_power_trace+0x0/0x40 @ 1
[    4.929992] initcall init_power_trace+0x0/0x40 returned 0 after 0 usecs
[    4.933325] calling  init_kmem_tracer+0x0/0x40 @ 1
[    4.936658] initcall init_kmem_tracer+0x0/0x40 returned 0 after 0 usecs
[    4.939992] calling  init_blk_tracer+0x0/0x90 @ 1
[    4.943325] initcall init_blk_tracer+0x0/0x90 returned 0 after 0 usecs
[    4.946658] calling  register_ftrace_syscalls+0x0/0xd3 @ 1
[    4.949992] initcall register_ftrace_syscalls+0x0/0xd3 returned 0 after 0 usecs
[    4.953325] calling  perf_counter_sysfs_init+0x0/0x45 @ 1
[    4.956658] initcall perf_counter_sysfs_init+0x0/0x45 returned 0 after 0 usecs
[    4.959992] calling  init_per_zone_pages_min+0x0/0xc1 @ 1
[    4.963325] initcall init_per_zone_pages_min+0x0/0xc1 returned 0 after 0 usecs
[    4.966658] calling  pdflush_init+0x0/0x57 @ 1
[    4.969992] initcall pdflush_init+0x0/0x57 returned 0 after 0 usecs
[    4.973325] calling  kswapd_init+0x0/0x4d @ 1
[    4.976658] initcall kswapd_init+0x0/0x4d returned 0 after 0 usecs
[    4.979992] calling  init_tmpfs+0x0/0x113 @ 1
[    4.983325] initcall init_tmpfs+0x0/0x113 returned 0 after 0 usecs
[    4.986658] calling  setup_vmstat+0x0/0xf5 @ 1
[    4.989992] initcall setup_vmstat+0x0/0xf5 returned 0 after 0 usecs
[    4.993325] calling  mm_sysfs_init+0x0/0x50 @ 1
[    4.996658] initcall mm_sysfs_init+0x0/0x50 returned 0 after 0 usecs
[    4.999992] calling  proc_vmalloc_init+0x0/0x50 @ 1
[    5.003325] initcall proc_vmalloc_init+0x0/0x50 returned 0 after 0 usecs
[    5.006658] calling  hugetlb_init+0x0/0x312 @ 1
[    5.009992] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.013325] initcall hugetlb_init+0x0/0x312 returned 0 after 3255 usecs
[    5.016658] calling  slab_proc_init+0x0/0x50 @ 1
[    5.019992] initcall slab_proc_init+0x0/0x50 returned 0 after 0 usecs
[    5.023325] calling  slab_sysfs_init+0x0/0x123 @ 1
[    5.029992] khelper used greatest stack depth: 5240 bytes left
[    5.069992] initcall slab_sysfs_init+0x0/0x123 returned 0 after 42317 usecs
[    5.073325] calling  fasync_init+0x0/0x55 @ 1
[    5.079992] initcall fasync_init+0x0/0x55 returned 0 after 3255 usecs
[    5.083325] calling  proc_filesystems_init+0x0/0x4d @ 1
[    5.086658] initcall proc_filesystems_init+0x0/0x4d returned 0 after 0 usecs
[    5.089992] calling  inotify_setup+0x0/0x37 @ 1
[    5.093325] initcall inotify_setup+0x0/0x37 returned 0 after 0 usecs
[    5.096658] calling  aio_setup+0x0/0x118 @ 1
[    5.099992] initcall aio_setup+0x0/0x118 returned 0 after 0 usecs
[    5.103325] calling  proc_locks_init+0x0/0x4d @ 1
[    5.106658] initcall proc_locks_init+0x0/0x4d returned 0 after 0 usecs
[    5.109992] calling  init_sys32_ioctl+0x0/0xc0 @ 1
[    5.113325] initcall init_sys32_ioctl+0x0/0xc0 returned 0 after 0 usecs
[    5.116658] calling  init_mbcache+0x0/0x40 @ 1
[    5.119992] initcall init_mbcache+0x0/0x40 returned 0 after 0 usecs
[    5.123325] calling  proc_cmdline_init+0x0/0x50 @ 1
[    5.126658] initcall proc_cmdline_init+0x0/0x50 returned 0 after 0 usecs
[    5.129992] calling  proc_cpuinfo_init+0x0/0x50 @ 1
[    5.133325] initcall proc_cpuinfo_init+0x0/0x50 returned 0 after 0 usecs
[    5.136658] calling  proc_devices_init+0x0/0x50 @ 1
[    5.139992] initcall proc_devices_init+0x0/0x50 returned 0 after 0 usecs
[    5.143325] calling  proc_interrupts_init+0x0/0x50 @ 1
[    5.146658] initcall proc_interrupts_init+0x0/0x50 returned 0 after 0 usecs
[    5.149992] calling  proc_loadavg_init+0x0/0x50 @ 1
[    5.153325] initcall proc_loadavg_init+0x0/0x50 returned 0 after 0 usecs
[    5.156658] calling  proc_meminfo_init+0x0/0x50 @ 1
[    5.159991] initcall proc_meminfo_init+0x0/0x50 returned 0 after 0 usecs
[    5.163325] calling  proc_stat_init+0x0/0x50 @ 1
[    5.166658] initcall proc_stat_init+0x0/0x50 returned 0 after 0 usecs
[    5.169991] calling  proc_uptime_init+0x0/0x50 @ 1
[    5.173325] initcall proc_uptime_init+0x0/0x50 returned 0 after 0 usecs
[    5.176658] calling  proc_version_init+0x0/0x50 @ 1
[    5.179991] initcall proc_version_init+0x0/0x50 returned 0 after 0 usecs
[    5.183325] calling  proc_kcore_init+0x0/0x7b @ 1
[    5.186658] initcall proc_kcore_init+0x0/0x7b returned 0 after 0 usecs
[    5.189991] calling  vmcore_init+0x0/0xa4 @ 1
[    5.193325] initcall vmcore_init+0x0/0xa4 returned 0 after 0 usecs
[    5.196658] calling  proc_kmsg_init+0x0/0x50 @ 1
[    5.199991] initcall proc_kmsg_init+0x0/0x50 returned 0 after 0 usecs
[    5.203325] calling  configfs_init+0x0/0xf9 @ 1
[    5.206658] initcall configfs_init+0x0/0xf9 returned 0 after 0 usecs
[    5.209991] calling  init_devpts_fs+0x0/0x8a @ 1
[    5.213325] initcall init_devpts_fs+0x0/0x8a returned 0 after 0 usecs
[    5.216658] calling  init_dlm+0x0/0xd6 @ 1
[    5.223325] device: 'dlm-control': device_add
[    5.226658] PM: Adding info for No Bus:dlm-control
[    5.229991] device: 'dlm-monitor': device_add
[    5.233325] PM: Adding info for No Bus:dlm-monitor
[    5.236658] device: 'dlm_plock': device_add
[    5.239991] PM: Adding info for No Bus:dlm_plock
[    5.243325] DLM (built May 12 2009 18:29:46) installed
[    5.246658] initcall init_dlm+0x0/0xd6 returned 0 after 26041 usecs
[    5.249991] calling  init_ext3_fs+0x0/0x95 @ 1
[    5.253325] initcall init_ext3_fs+0x0/0x95 returned 0 after 0 usecs
[    5.256658] calling  journal_init+0x0/0x91 @ 1
[    5.259991] initcall journal_init+0x0/0x91 returned 0 after 0 usecs
[    5.263325] calling  init_ramfs_fs+0x0/0x3d @ 1
[    5.266658] initcall init_ramfs_fs+0x0/0x3d returned 0 after 0 usecs
[    5.269991] calling  init_hugetlbfs_fs+0x0/0x100 @ 1
[    5.273325] initcall init_hugetlbfs_fs+0x0/0x100 returned 0 after 0 usecs
[    5.276658] calling  init_fat_fs+0x0/0x80 @ 1
[    5.283325] initcall init_fat_fs+0x0/0x80 returned 0 after 3255 usecs
[    5.286658] calling  init_vfat_fs+0x0/0x3d @ 1
[    5.289991] initcall init_vfat_fs+0x0/0x3d returned 0 after 0 usecs
[    5.293325] calling  init_iso9660_fs+0x0/0x95 @ 1
[    5.299991] initcall init_iso9660_fs+0x0/0x95 returned 0 after 3255 usecs
[    5.303325] calling  init_nfsd+0x0/0x132 @ 1
[    5.306658] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.313325] initcall init_nfsd+0x0/0x132 returned 0 after 6510 usecs
[    5.316658] calling  init_nlm+0x0/0x4e @ 1
[    5.319991] initcall init_nlm+0x0/0x4e returned 0 after 0 usecs
[    5.323325] calling  init_nls_cp775+0x0/0x40 @ 1
[    5.326658] initcall init_nls_cp775+0x0/0x40 returned 0 after 0 usecs
[    5.329991] calling  init_nls_cp850+0x0/0x40 @ 1
[    5.333325] initcall init_nls_cp850+0x0/0x40 returned 0 after 0 usecs
[    5.336658] calling  init_nls_cp852+0x0/0x40 @ 1
[    5.339991] initcall init_nls_cp852+0x0/0x40 returned 0 after 0 usecs
[    5.343325] calling  init_nls_cp863+0x0/0x40 @ 1
[    5.346658] initcall init_nls_cp863+0x0/0x40 returned 0 after 0 usecs
[    5.353325] calling  init_nls_cp866+0x0/0x40 @ 1
[    5.356658] initcall init_nls_cp866+0x0/0x40 returned 0 after 0 usecs
[    5.359991] calling  init_nls_cp932+0x0/0x40 @ 1
[    5.363325] initcall init_nls_cp932+0x0/0x40 returned 0 after 0 usecs
[    5.366658] calling  init_nls_euc_jp+0x0/0x80 @ 1
[    5.369991] initcall init_nls_euc_jp+0x0/0x80 returned 0 after 0 usecs
[    5.373325] calling  init_nls_cp936+0x0/0x40 @ 1
[    5.376658] initcall init_nls_cp936+0x0/0x40 returned 0 after 0 usecs
[    5.379991] calling  init_nls_cp949+0x0/0x40 @ 1
[    5.383325] initcall init_nls_cp949+0x0/0x40 returned 0 after 0 usecs
[    5.386658] calling  init_nls_iso8859_3+0x0/0x40 @ 1
[    5.389991] initcall init_nls_iso8859_3+0x0/0x40 returned 0 after 0 usecs
[    5.393325] calling  init_nls_iso8859_5+0x0/0x40 @ 1
[    5.396658] initcall init_nls_iso8859_5+0x0/0x40 returned 0 after 0 usecs
[    5.399991] calling  init_nls_iso8859_9+0x0/0x40 @ 1
[    5.403325] initcall init_nls_iso8859_9+0x0/0x40 returned 0 after 0 usecs
[    5.406658] calling  init_nls_iso8859_15+0x0/0x40 @ 1
[    5.409991] initcall init_nls_iso8859_15+0x0/0x40 returned 0 after 0 usecs
[    5.413324] calling  init_nls_utf8+0x0/0x4d @ 1
[    5.416658] initcall init_nls_utf8+0x0/0x4d returned 0 after 0 usecs
[    5.419991] calling  init_smb_fs+0x0/0xa3 @ 1
[    5.426658] initcall init_smb_fs+0x0/0xa3 returned 0 after 3255 usecs
[    5.429991] calling  init_autofs_fs+0x0/0x3d @ 1
[    5.433324] initcall init_autofs_fs+0x0/0x3d returned 0 after 0 usecs
[    5.436658] calling  init_udf_fs+0x0/0x93 @ 1
[    5.443324] initcall init_udf_fs+0x0/0x93 returned 0 after 3255 usecs
[    5.446658] calling  init_jfs_fs+0x0/0x315 @ 1
[    5.449991] JFS: nTxBlock = 7679, nTxLock = 61437
[    5.459991] initcall init_jfs_fs+0x0/0x315 returned 0 after 9765 usecs
[    5.463324] calling  init_xfs_fs+0x0/0xee @ 1
[    5.466658] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    5.479991] initcall init_xfs_fs+0x0/0xee returned 0 after 13020 usecs
[    5.483324] calling  init_gfs2_fs+0x0/0x220 @ 1
[    5.489991] GFS2 (built May 12 2009 18:29:55) installed
[    5.496658] initcall init_gfs2_fs+0x0/0x220 returned 0 after 9765 usecs
[    5.499991] calling  ipc_init+0x0/0x5d @ 1
[    5.503324] msgmni has been set to 1919
[    5.506658] initcall ipc_init+0x0/0x5d returned 0 after 3255 usecs
[    5.509991] calling  ipc_sysctl_init+0x0/0x3d @ 1
[    5.513324] sysctl table check failed: /kernel/shmmax .1.34 No proc_handler
[    5.519991] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    5.523324] Call Trace:
[    5.526658]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    5.529991]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    5.533324]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    5.536658]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    5.539991]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    5.543324]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    5.546658]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    5.549991]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    5.553324]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    5.556658]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    5.559991]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    5.563324]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    5.566658]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.569991]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.573324]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    5.576658]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    5.579991]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    5.583324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.586658]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.589991]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    5.593324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.596658]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    5.599991]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    5.603324]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    5.606658]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    5.609991]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    5.613324]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    5.616658]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    5.619991] sysctl table check failed: /kernel/shmall .1.41 No proc_handler
[    5.629991] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    5.633324] Call Trace:
[    5.636658]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    5.639991]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    5.643324]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    5.646658]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    5.649991]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    5.653324]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    5.656658]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    5.659991]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    5.663324]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    5.666658]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    5.669991]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    5.673324]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    5.676657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.679991]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.683324]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    5.686657]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    5.689991]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    5.693324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.696657]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.699991]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    5.703324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.706657]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    5.709991]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    5.713324]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    5.716657]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    5.719991]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    5.723324]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    5.726657]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    5.729991] sysctl table check failed: /kernel/shmmni .1.45 No proc_handler
[    5.736657] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    5.739991] Call Trace:
[    5.743324]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    5.746657]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    5.749991]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    5.753324]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    5.756657]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    5.759991]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    5.763324]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    5.766657]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    5.769991]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    5.773324]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    5.779991]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    5.783324]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    5.786657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.789991]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.793324]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    5.796657]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    5.799991]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    5.803324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.806657]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.809991]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    5.813324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.816657]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    5.819991]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    5.823324]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    5.826657]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    5.829991]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    5.833324]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    5.836657]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    5.839991] sysctl table check failed: /kernel/msgmax .1.35 No proc_handler
[    5.846657] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    5.849991] Call Trace:
[    5.849991]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    5.853324]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    5.856657]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    5.859991]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    5.863324]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    5.866657]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    5.869991]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    5.873324]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    5.876657]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    5.879991]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    5.883324]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    5.886657]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    5.889991]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.893324]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.896657]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    5.899991]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    5.903324]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    5.906657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.909991]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    5.913324]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    5.916657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    5.919991]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    5.923324]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    5.926657]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    5.929991]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    5.933324]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    5.936657]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    5.939990]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    5.943324] sysctl table check failed: /kernel/msgmni .1.42 No proc_handler
[    5.953324] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    5.956657] Call Trace:
[    5.959990]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    5.963324]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    5.966657]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    5.969990]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    5.973324]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    5.976657]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    5.979990]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    5.983324]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    5.986657]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    5.989990]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    5.993324]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    5.996657]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    5.999990]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.003324]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.006657]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    6.009990]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    6.013324]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    6.016657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.019990]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.023324]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    6.026657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.029990]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    6.033324]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    6.036657]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    6.039990]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    6.043324]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    6.046657]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    6.049990]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    6.053324] sysctl table check failed: /kernel/msgmnb .1.36 No proc_handler
[    6.059990] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    6.063324] Call Trace:
[    6.066657]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    6.069990]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    6.073324]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.076657]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    6.079990]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    6.083324]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    6.086657]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    6.089990]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    6.093324]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    6.096657]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    6.099990]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    6.103324]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    6.106657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.109990]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.113324]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    6.116657]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    6.119990]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    6.123324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.126657]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.129990]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    6.133324]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.136657]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    6.139990]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    6.143324]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    6.146657]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    6.149990]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    6.153324]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    6.156657]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    6.159990] sysctl table check failed: /kernel/sem .1.43 No proc_handler
[    6.166657] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    6.169990] Call Trace:
[    6.173324]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    6.176657]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    6.179990]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.183324]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    6.186657]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    6.189990]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    6.193324]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    6.196657]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    6.199990]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    6.203324]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    6.206657]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    6.209990]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    6.213323]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.216657]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.219990]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    6.223323]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    6.226657]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    6.229990]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.233323]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.236657]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    6.239990]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.243323]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    6.246657]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    6.249990]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    6.253323]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    6.256657]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    6.259990]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    6.263323]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    6.266657] sysctl table check failed: /kernel/auto_msgmni  No proc_handler
[    6.276657] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    6.279990] Call Trace:
[    6.283323]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    6.289990]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    6.293323]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.296657]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    6.299990]  [<ffffffff8028a03d>] ? set_normalized_timespec+0xd/0xb0
[    6.303323]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    6.306657]  [<ffffffff81627050>] ? ipc_sysctl_init+0x0/0x3d
[    6.309990]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    6.313323]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    6.316657]  [<ffffffff81627073>] ipc_sysctl_init+0x23/0x3d
[    6.319990]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    6.323323]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    6.326657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.329990]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.333323]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    6.336657]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    6.339990]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    6.343323]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.346657]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.349990]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    6.353323]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.356657]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    6.359990]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    6.363323]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    6.366657]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    6.369990]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    6.373323]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    6.376657]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    6.379990] initcall ipc_sysctl_init+0x0/0x3d returned 0 after 846353 usecs
[    6.383323] calling  init_mqueue_fs+0x0/0x103 @ 1
[    6.386657] sysctl table check failed: /fs/mqueue/queues_max  No proc_handler
[    6.393323] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    6.396657] Call Trace:
[    6.396657]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    6.399990]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    6.403323]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.406657]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.409990]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    6.413323]  [<ffffffff8036f9f2>] ? sysfs_slab_add+0x152/0x190
[    6.416657]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    6.419990]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    6.423323]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    6.426657]  [<ffffffff8059cbf8>] mq_register_sysctl_table+0x28/0x50
[    6.429990]  [<ffffffff816270da>] init_mqueue_fs+0x4d/0x103
[    6.433323]  [<ffffffff8162708d>] ? init_mqueue_fs+0x0/0x103
[    6.436657]  [<ffffffff8162708d>] ? init_mqueue_fs+0x0/0x103
[    6.439990]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    6.443323]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    6.446657]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.449990]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.453323]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    6.456657]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    6.459990]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    6.463323]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.466657]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.469990]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    6.473323]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.476656]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    6.479990]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    6.483323]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    6.486656]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    6.489990]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    6.493323]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    6.496656]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    6.499990] sysctl table check failed: /fs/mqueue/msg_max  No proc_handler
[    6.506656] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    6.509990] Call Trace:
[    6.509990]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    6.513323]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    6.516656]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.519990]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.523323]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    6.526656]  [<ffffffff8036f9f2>] ? sysfs_slab_add+0x152/0x190
[    6.529990]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    6.533323]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    6.536656]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    6.539990]  [<ffffffff8059cbf8>] mq_register_sysctl_table+0x28/0x50
[    6.543323]  [<ffffffff816270da>] init_mqueue_fs+0x4d/0x103
[    6.546656]  [<ffffffff8162708d>] ? init_mqueue_fs+0x0/0x103
[    6.549990]  [<ffffffff8162708d>] ? init_mqueue_fs+0x0/0x103
[    6.553323]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    6.556656]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    6.559990]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.563323]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.566656]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    6.569990]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    6.573323]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    6.576656]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.579990]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.583323]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    6.586656]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.589990]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    6.593323]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    6.596656]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    6.599990]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    6.603323]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    6.606656]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    6.609990]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    6.616656] sysctl table check failed: /fs/mqueue/msgsize_max  No proc_handler
[    6.623323] Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc5-tip-01553-g4bc9bac-dirty #48764
[    6.626656] Call Trace:
[    6.629990]  [<ffffffff802b2741>] set_fail+0x81/0x90
[    6.633323]  [<ffffffff802b2aba>] sysctl_check_table+0x17a/0x540
[    6.636656]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.639990]  [<ffffffff802b2acb>] sysctl_check_table+0x18b/0x540
[    6.643323]  [<ffffffff80290f7c>] __register_sysctl_paths+0x11c/0x390
[    6.646656]  [<ffffffff8036f9f2>] ? sysfs_slab_add+0x152/0x190
[    6.649990]  [<ffffffff8020cc16>] ? ftrace_call+0x5/0x2b
[    6.653323]  [<ffffffff80291231>] register_sysctl_paths+0x41/0x60
[    6.656656]  [<ffffffff8029127b>] register_sysctl_table+0x2b/0x50
[    6.659990]  [<ffffffff8059cbf8>] mq_register_sysctl_table+0x28/0x50
[    6.663323]  [<ffffffff816270da>] init_mqueue_fs+0x4d/0x103
[    6.666656]  [<ffffffff8162708d>] ? init_mqueue_fs+0x0/0x103
[    6.669990]  [<ffffffff8162708d>] ? init_mqueue_fs+0x0/0x103
[    6.673323]  [<ffffffff802090ee>] do_one_initcall+0x4e/0x1f0
[    6.676656]  [<ffffffff80216883>] ? native_sched_clock+0x23/0xb0
[    6.679990]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.683323]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.686656]  [<ffffffff802bea91>] ? put_lock_stats+0x21/0x60
[    6.689990]  [<ffffffff802c0ad0>] ? lock_release_holdtime+0xd0/0x170
[    6.693323]  [<ffffffff802c101a>] ? __lock_release+0x17a/0x1b0
[    6.696656]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.699990]  [<ffffffff80d53360>] ? sub_preempt_count+0x160/0x170
[    6.703323]  [<ffffffff80d4ee0b>] ? _spin_unlock+0x6b/0xa0
[    6.706656]  [<ffffffff803dde54>] ? proc_register+0xe4/0x190
[    6.709990]  [<ffffffff803de05d>] ? create_proc_entry+0x6d/0xe0
[    6.713323]  [<ffffffff802ecd44>] ? register_irq_proc+0xe4/0x110
[    6.716656]  [<ffffffff815feb4b>] kernel_init+0xde/0x148
[    6.719990]  [<ffffffff8020e07a>] child_rip+0xa/0x20
[    6.723323]  [<ffffffff8020d9d4>] ? restore_args+0x0/0x30
[    6.726656]  [<ffffffff815fea6d>] ? kernel_init+0x0/0x148
[    6.729990]  [<ffffffff8020e070>] ? child_rip+0x0/0x20
[    6.736656] initcall init_mqueue_fs+0x0/0x103 returned 0 after 341796 usecs
[    6.739990] calling  key_proc_init+0x0/0x90 @ 1
[    6.743323] initcall key_proc_init+0x0/0x90 returned 0 after 0 usecs
[    6.746656] calling  crypto_wq_init+0x0/0x80 @ 1
[    6.749990] initcall crypto_wq_init+0x0/0x80 returned 0 after 0 usecs
[    6.753323] calling  crypto_algapi_init+0x0/0x35 @ 1
[    6.756656] initcall crypto_algapi_init+0x0/0x35 returned 0 after 0 usecs
[    6.759989] calling  chainiv_module_init+0x0/0x40 @ 1
[    6.763323] initcall chainiv_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.766656] calling  eseqiv_module_init+0x0/0x40 @ 1
[    6.769989] initcall eseqiv_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.773323] calling  seqiv_module_init+0x0/0x40 @ 1
[    6.776656] initcall seqiv_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.779989] calling  hmac_module_init+0x0/0x40 @ 1
[    6.783323] initcall hmac_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.786656] calling  crypto_xcbc_module_init+0x0/0x3d @ 1
[    6.789989] initcall crypto_xcbc_module_init+0x0/0x3d returned 0 after 0 usecs
[    6.793323] calling  crypto_null_mod_init+0x0/0xa3 @ 1
[    6.796656] alg: No test for cipher_null (cipher_null-generic)
[    6.803323] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    6.806656] alg: No test for digest_null (digest_null-generic)
[    6.809989] alg: No test for compress_null (compress_null-generic)
[    6.813323] initcall crypto_null_mod_init+0x0/0xa3 returned 0 after 16276 usecs
[    6.816656] calling  md5_mod_init+0x0/0x40 @ 1
[    6.819989] initcall md5_mod_init+0x0/0x40 returned 0 after 0 usecs
[    6.823323] calling  sha1_generic_mod_init+0x0/0x3d @ 1
[    6.829989] initcall sha1_generic_mod_init+0x0/0x3d returned 0 after 3255 usecs
[    6.833323] calling  sha256_generic_mod_init+0x0/0x73 @ 1
[    6.839989] initcall sha256_generic_mod_init+0x0/0x73 returned 0 after 3255 usecs
[    6.843323] calling  crypto_ecb_module_init+0x0/0x40 @ 1
[    6.846656] initcall crypto_ecb_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.849989] calling  crypto_cbc_module_init+0x0/0x40 @ 1
[    6.853323] initcall crypto_cbc_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.856656] calling  crypto_pcbc_module_init+0x0/0x40 @ 1
[    6.859989] initcall crypto_pcbc_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.863323] calling  crypto_module_init+0x0/0x3d @ 1
[    6.866656] initcall crypto_module_init+0x0/0x3d returned 0 after 0 usecs
[    6.869989] calling  crypto_ctr_module_init+0x0/0x67 @ 1
[    6.873323] initcall crypto_ctr_module_init+0x0/0x67 returned 0 after 0 usecs
[    6.876656] calling  crypto_gcm_module_init+0x0/0x85 @ 1
[    6.879989] initcall crypto_gcm_module_init+0x0/0x85 returned 0 after 0 usecs
[    6.883323] calling  crypto_ccm_module_init+0x0/0x85 @ 1
[    6.886656] initcall crypto_ccm_module_init+0x0/0x85 returned 0 after 0 usecs
[    6.889989] calling  cryptd_init+0x0/0xf8 @ 1
[    6.893323] initcall cryptd_init+0x0/0xf8 returned 0 after 0 usecs
[    6.896656] calling  des_generic_mod_init+0x0/0x6a @ 1
[    6.899989] initcall des_generic_mod_init+0x0/0x6a returned 0 after 0 usecs
[    6.903323] calling  aes_init+0x0/0x40 @ 1
[    6.909989] initcall aes_init+0x0/0x40 returned 0 after 3255 usecs
[    6.913323] calling  cast6_mod_init+0x0/0x40 @ 1
[    6.916656] initcall cast6_mod_init+0x0/0x40 returned 0 after 0 usecs
[    6.919989] calling  arc4_init+0x0/0x40 @ 1
[    6.923323] initcall arc4_init+0x0/0x40 returned 0 after 0 usecs
[    6.926656] calling  anubis_mod_init+0x0/0x40 @ 1
[    6.933323] initcall anubis_mod_init+0x0/0x40 returned 0 after 0 usecs
[    6.936656] calling  zlib_mod_init+0x0/0x40 @ 1
[    6.939989] initcall zlib_mod_init+0x0/0x40 returned 0 after 0 usecs
[    6.943323] calling  michael_mic_init+0x0/0x40 @ 1
[    6.946656] initcall michael_mic_init+0x0/0x40 returned 0 after 0 usecs
[    6.949989] calling  crc32c_mod_init+0x0/0x40 @ 1
[    6.953323] initcall crc32c_mod_init+0x0/0x40 returned 0 after 0 usecs
[    6.956656] calling  crypto_authenc_module_init+0x0/0x40 @ 1
[    6.959989] initcall crypto_authenc_module_init+0x0/0x40 returned 0 after 0 usecs
[    6.963323] calling  lzo_mod_init+0x0/0x40 @ 1
[    6.966656] initcall lzo_mod_init+0x0/0x40 returned 0 after 0 usecs
[    6.969989] calling  krng_mod_init+0x0/0x40 @ 1
[    6.973323] alg: No test for stdrng (krng)
[    6.976656] initcall krng_mod_init+0x0/0x40 returned 0 after 3255 usecs
[    6.979989] calling  prng_mod_init+0x0/0x60 @ 1
[    6.983323] alg: No test for stdrng (ansi_cprng)
[    6.986656] initcall prng_mod_init+0x0/0x60 returned 0 after 3255 usecs
[    6.989989] calling  proc_genhd_init+0x0/0x65 @ 1
[    6.993323] initcall proc_genhd_init+0x0/0x65 returned 0 after 0 usecs
[    6.996656] calling  noop_init+0x0/0x40 @ 1
[    6.999989] io scheduler noop registered (default)
[    7.003323] initcall noop_init+0x0/0x40 returned 0 after 3255 usecs
[    7.006656] calling  libcrc32c_mod_init+0x0/0x73 @ 1
[    7.009989] initcall libcrc32c_mod_init+0x0/0x73 returned 0 after 0 usecs
[    7.013323] calling  init_kmp+0x0/0x40 @ 1
[    7.016656] initcall init_kmp+0x0/0x40 returned 0 after 0 usecs
[    7.019989] calling  percpu_counter_startup+0x0/0x50 @ 1
[    7.023323] initcall percpu_counter_startup+0x0/0x50 returned 0 after 0 usecs
[    7.026656] calling  dynamic_debug_init+0x0/0x175 @ 1
[    7.029989] initcall dynamic_debug_init+0x0/0x175 returned 0 after 0 usecs
[    7.033323] calling  pci_init+0x0/0x6b @ 1
[    7.036656] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    7.043322] pci 0000:01:00.0: Boot video device
[    7.046656] initcall pci_init+0x0/0x6b returned 0 after 9765 usecs
[    7.049989] calling  pci_proc_init+0x0/0x93 @ 1
[    7.053322] initcall pci_proc_init+0x0/0x93 returned 0 after 0 usecs
[    7.056656] calling  pcie_portdrv_init+0x0/0x80 @ 1
[    7.059989] bus: 'pci_express': registered
[    7.063322] bus: 'pci': add driver pcieport-driver
[    7.066656] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver pcieport-driver
[    7.069989] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:01.0
[    7.073322] initcall pcie_portdrv_init+0x0/0x80 returned 0 after 13020 usecs
[    7.076656] calling  aer_service_init+0x0/0x50 @ 1
[    7.079989] bus: 'pci_express': add driver aer
[    7.083322] initcall aer_service_init+0x0/0x50 returned 0 after 3255 usecs
[    7.086656] calling  pci_hotplug_init+0x0/0x45 @ 1
[    7.089989] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.093322] initcall pci_hotplug_init+0x0/0x45 returned 0 after 3255 usecs
[    7.096656] calling  pcied_init+0x0/0xa5 @ 1
[    7.099989] bus: 'pci_express': add driver pciehp_dummy
[    7.103322] bus: 'pci_express': remove driver pciehp_dummy
[    7.106656] driver: 'pciehp_dummy': driver_release
[    7.109989] bus: 'pci_express': add driver pciehp
[    7.113322] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    7.116656] initcall pcied_init+0x0/0xa5 returned 0 after 16276 usecs
[    7.119989] calling  shpcd_init+0x0/0x8b @ 1
[    7.123322] bus: 'pci': add driver shpchp
[    7.126656] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver shpchp
[    7.129989] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:01.0
[    7.133322] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.136656] initcall shpcd_init+0x0/0x8b returned 0 after 13020 usecs
[    7.139989] calling  init_legacy+0x0/0x77 @ 1
[    7.143322] initcall init_legacy+0x0/0x77 returned 0 after 0 usecs
[    7.146656] calling  pci_stub_init+0x0/0x50 @ 1
[    7.149989] bus: 'pci': add driver pci-stub
[    7.153322] initcall pci_stub_init+0x0/0x50 returned 0 after 3255 usecs
[    7.156656] calling  progearbl_init+0x0/0x9d @ 1
[    7.159989] bus: 'platform': add driver progear-bl
[    7.163322] Registering platform device 'progear-bl'. Parent at platform
[    7.166656] device: 'progear-bl': device_add
[    7.169989] bus: 'platform': add device progear-bl
[    7.173322] PM: Adding info for platform:progear-bl
[    7.176656] bus: 'platform': driver_probe_device: matched device progear-bl with driver progear-bl
[    7.179989] bus: 'platform': really_probe: probing driver progear-bl with device progear-bl
[    7.183322] ALI M7101 PMU not found.
[    7.186656] initcall progearbl_init+0x0/0x9d returned 0 after 26041 usecs
[    7.189989] calling  arcfb_init+0x0/0x9d @ 1
[    7.193322] initcall arcfb_init+0x0/0x9d returned -6 after 0 usecs
[    7.196656] initcall arcfb_init+0x0/0x9d returned with error code -6 
[    7.199989] calling  cyber2000fb_init+0x0/0x108 @ 1
[    7.203322] bus: 'pci': add driver CyberPro
[    7.206656] initcall cyber2000fb_init+0x0/0x108 returned 0 after 3255 usecs
[    7.209989] calling  matroxfb_init+0x0/0x9a @ 1
[    7.213322] bus: 'pci': add driver matroxfb
[    7.216656] initcall matroxfb_init+0x0/0x9a returned 0 after 3255 usecs
[    7.219989] calling  i2c_matroxfb_init+0x0/0x60 @ 1
[    7.223322] initcall i2c_matroxfb_init+0x0/0x60 returned 0 after 0 usecs
[    7.226656] calling  sisfb_init+0x0/0x7c @ 1
[    7.229989] bus: 'pci': add driver sisfb
[    7.233322] initcall sisfb_init+0x0/0x7c returned 0 after 3255 usecs
[    7.236656] calling  viafb_init+0x0/0x85 @ 1
[    7.239989] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[    7.243322] I2C adapter driver [via_i2c] forgot to specify physical device
[    7.246656] device: 'i2c-0': device_add
[    7.249989] PM: Adding info for No Bus:i2c-0
[    7.253322] i2c-adapter i2c-0: adapter [via_i2c] registered
[    7.256656] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    7.259989] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    7.333322] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.476655] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.619989] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.763322] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    7.766655] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    7.769988] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    7.843322] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    7.846655] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    7.919988] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.063321] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.206655] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.349988] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.353321] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    8.356654] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    8.429988] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    8.433321] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    8.506654] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.649987] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.793321] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.936654] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[    8.939987] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[    8.943320] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[    9.016654] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    9.019987] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    9.093320] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.236653] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.379987] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.523320] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.526653] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[    9.529986] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[    9.603320] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    9.606653] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    9.679986] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.823320] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[    9.966653] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.109986] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.113319] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   10.116653] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   10.189986] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   10.193319] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   10.266652] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.409986] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.553319] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.696652] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.699985] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   10.703319] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   10.776652] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   10.779985] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   10.853319] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.996652] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.139985] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.283318] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.286651] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.289985] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.363318] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   11.366651] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   11.439984] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.583317] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.726650] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.869983] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.873317] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.876650] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.949983] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   11.953317] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   12.026650] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   12.169983] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   12.313316] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   12.456649] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   12.459982] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   12.463316] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   12.536649] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   12.539982] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   12.613316] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.756649] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.899982] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.043315] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.046648] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   13.049982] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   13.123315] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   13.126648] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   13.199981] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.343314] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.486648] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.629981] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.633314] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   13.636647] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   13.709981] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   13.713314] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   13.786647] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   13.929980] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.073313] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.216647] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.219980] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   14.223313] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   14.296646] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   14.299980] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   14.373313] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.516646] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.659979] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.803312] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   14.806646] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   14.809979] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   14.883312] i2c-adapter i2c-0: master_xfer[0] W, addr=0x38, len=1
[   14.886646] i2c-adapter i2c-0: master_xfer[1] R, addr=0x38, len=1
[   14.959979] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   15.103312] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   15.246645] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   15.389978] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   15.393312] i2c-adapter i2c-0: Used 4 tries to write to client at 0x38: failed, timeout?
[   15.396645] i2c-adapter i2c-0: NAK from device addr 0x38 msg #0
[   15.469978] ioremap failed
[   15.469978] initcall viafb_init+0x0/0x85 returned -1 after 8037099 usecs
[   15.473312] initcall viafb_init+0x0/0x85 returned with error code -1 
[   15.476645] calling  gxfb_init+0x0/0xae @ 1
[   15.479978] bus: 'pci': add driver gxfb
[   15.483312] initcall gxfb_init+0x0/0xae returned 0 after 3255 usecs
[   15.486645] calling  neofb_init+0x0/0x83 @ 1
[   15.489978] bus: 'pci': add driver neofb
[   15.493312] initcall neofb_init+0x0/0x83 returned 0 after 3255 usecs
[   15.496645] calling  tdfxfb_init+0x0/0x7b @ 1
[   15.499978] bus: 'pci': add driver tdfxfb
[   15.503312] initcall tdfxfb_init+0x0/0x7b returned 0 after 3255 usecs
[   15.506645] calling  imsttfb_init+0x0/0x15c @ 1
[   15.509978] bus: 'pci': add driver imsttfb
[   15.513312] initcall imsttfb_init+0x0/0x15c returned 0 after 3255 usecs
[   15.516645] calling  vt8623fb_init+0x0/0xf4 @ 1
[   15.519978] bus: 'pci': add driver vt8623fb
[   15.526645] initcall vt8623fb_init+0x0/0xf4 returned 0 after 6510 usecs
[   15.529978] calling  hecubafb_init+0x0/0x3d @ 1
[   15.533312] bus: 'platform': add driver hecubafb
[   15.536645] initcall hecubafb_init+0x0/0x3d returned 0 after 3255 usecs
[   15.539978] calling  n411_init+0x0/0xd3 @ 1
[   15.543312] no IO addresses supplied
[   15.546645] initcall n411_init+0x0/0xd3 returned -22 after 3255 usecs
[   15.549978] initcall n411_init+0x0/0xd3 returned with error code -22 
[   15.553312] calling  s1d13xxxfb_init+0x0/0x55 @ 1
[   15.556645] bus: 'platform': add driver s1d13xxxfb
[   15.559978] initcall s1d13xxxfb_init+0x0/0x55 returned 0 after 3255 usecs
[   15.563312] calling  sm501fb_init+0x0/0x45 @ 1
[   15.566645] bus: 'platform': add driver sm501-fb
[   15.569978] initcall sm501fb_init+0x0/0x45 returned 0 after 3255 usecs
[   15.573312] calling  carminefb_init+0x0/0x5e @ 1
[   15.576645] bus: 'pci': add driver carminefb
[   15.583312] initcall carminefb_init+0x0/0x5e returned 0 after 6510 usecs
[   15.586645] calling  mb862xxfb_init+0x0/0x4d @ 1
[   15.589978] bus: 'pci': add driver mb862xxfb
[   15.593312] initcall mb862xxfb_init+0x0/0x4d returned 0 after 3255 usecs
[   15.596645] calling  uvesafb_init+0x0/0x123 @ 1
[   15.599978] bus: 'platform': add driver uvesafb
[   15.603312] Registering platform device 'uvesafb.0'. Parent at platform
[   15.606645] device: 'uvesafb.0': device_add
[   15.609978] bus: 'platform': add device uvesafb.0
[   15.613312] PM: Adding info for platform:uvesafb.0
[   15.616645] bus: 'platform': driver_probe_device: matched device uvesafb.0 with driver uvesafb
[   15.619978] bus: 'platform': really_probe: probing driver uvesafb with device uvesafb.0
[   15.623311] uvesafb: failed to execute /sbin/v86d
[   15.626645] uvesafb: make sure that the v86d helper is installed and executable
[   15.629978] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[   15.633311] uvesafb: vbe_init() failed with -22
[   15.636645] uvesafb: probe of uvesafb.0 failed with error -22
[   15.639978] initcall uvesafb_init+0x0/0x123 returned 0 after 39062 usecs
[   15.643311] calling  efifb_init+0x0/0xa8 @ 1
[   15.646645] initcall efifb_init+0x0/0xa8 returned -19 after 0 usecs
[   15.649978] calling  acpi_reserve_resources+0x0/0x112 @ 1
[   15.653311] initcall acpi_reserve_resources+0x0/0x112 returned 0 after 0 usecs
[   15.656645] calling  irqrouter_init_sysfs+0x0/0x5f @ 1
[   15.659978] initcall irqrouter_init_sysfs+0x0/0x5f returned 0 after 0 usecs
[   15.663311] calling  acpi_pci_slot_init+0x0/0x3b @ 1
[   15.666645] initcall acpi_pci_slot_init+0x0/0x3b returned 0 after 0 usecs
[   15.669978] calling  acpi_container_init+0x0/0x65 @ 1
[   15.673311] initcall acpi_container_init+0x0/0x65 returned -19 after 0 usecs
[   15.676645] calling  acpi_smb_hc_init+0x0/0x3f @ 1
[   15.679978] initcall acpi_smb_hc_init+0x0/0x3f returned -19 after 0 usecs
[   15.683311] calling  acpi_sbs_init+0x0/0x56 @ 1
[   15.686645] initcall acpi_sbs_init+0x0/0x56 returned -19 after 0 usecs
[   15.689978] calling  rand_initialize+0x0/0x60 @ 1
[   15.693311] initcall rand_initialize+0x0/0x60 returned 0 after 0 usecs
[   15.696645] calling  tty_init+0x0/0x125 @ 1
[   15.699978] device: 'tty': device_add
[   15.703311] PM: Adding info for No Bus:tty
[   15.706645] device: 'console': device_add
[   15.709978] PM: Adding info for No Bus:console
[   15.713311] device: 'tty0': device_add
[   15.716645] PM: Adding info for No Bus:tty0
[   15.719978] device class 'vc': registering
[   15.723311] device: 'vcs': device_add
[   15.729978] PM: Adding info for No Bus:vcs
[   15.733311] device: 'vcsa': device_add
[   15.736645] PM: Adding info for No Bus:vcsa
[   15.739978] device: 'tty1': device_add
[   15.743311] PM: Adding info for No Bus:tty1
[   15.746645] device: 'tty2': device_add
[   15.749978] PM: Adding info for No Bus:tty2
[   15.756645] device: 'tty3': device_add
[   15.759978] PM: Adding info for No Bus:tty3
[   15.763311] device: 'tty4': device_add
[   15.766645] PM: Adding info for No Bus:tty4
[   15.769978] device: 'tty5': device_add
[   15.773311] PM: Adding info for No Bus:tty5
[   15.776645] device: 'tty6': device_add
[   15.779978] PM: Adding info for No Bus:tty6
[   15.783311] device: 'tty7': device_add
[   15.786645] PM: Adding info for No Bus:tty7
[   15.789978] device: 'tty8': device_add
[   15.793311] PM: Adding info for No Bus:tty8
[   15.796645] device: 'tty9': device_add
[   15.799978] PM: Adding info for No Bus:tty9
[   15.803311] device: 'tty10': device_add
[   15.806645] PM: Adding info for No Bus:tty10
[   15.809978] device: 'tty11': device_add
[   15.813311] PM: Adding info for No Bus:tty11
[   15.816645] device: 'tty12': device_add
[   15.819978] PM: Adding info for No Bus:tty12
[   15.823311] device: 'tty13': device_add
[   15.826645] PM: Adding info for No Bus:tty13
[   15.829978] device: 'tty14': device_add
[   15.833311] PM: Adding info for No Bus:tty14
[   15.836645] device: 'tty15': device_add
[   15.839978] PM: Adding info for No Bus:tty15
[   15.843311] device: 'tty16': device_add
[   15.846645] PM: Adding info for No Bus:tty16
[   15.853311] device: 'tty17': device_add
[   15.856645] PM: Adding info for No Bus:tty17
[   15.859978] device: 'tty18': device_add
[   15.863311] PM: Adding info for No Bus:tty18
[   15.866645] device: 'tty19': device_add
[   15.869978] PM: Adding info for No Bus:tty19
[   15.873311] device: 'tty20': device_add
[   15.876645] PM: Adding info for No Bus:tty20
[   15.879978] device: 'tty21': device_add
[   15.883311] PM: Adding info for No Bus:tty21
[   15.889978] device: 'tty22': device_add
[   15.893311] PM: Adding info for No Bus:tty22
[   15.896645] device: 'tty23': device_add
[   15.899978] PM: Adding info for No Bus:tty23
[   15.903311] device: 'tty24': device_add
[   15.906645] PM: Adding info for No Bus:tty24
[   15.909978] device: 'tty25': device_add
[   15.916645] PM: Adding info for No Bus:tty25
[   15.919978] device: 'tty26': device_add
[   15.923311] PM: Adding info for No Bus:tty26
[   15.929978] device: 'tty27': device_add
[   15.933311] PM: Adding info for No Bus:tty27
[   15.936644] device: 'tty28': device_add
[   15.939978] PM: Adding info for No Bus:tty28
[   15.943311] device: 'tty29': device_add
[   15.946644] PM: Adding info for No Bus:tty29
[   15.949978] device: 'tty30': device_add
[   15.953311] PM: Adding info for No Bus:tty30
[   15.956644] device: 'tty31': device_add
[   15.959978] PM: Adding info for No Bus:tty31
[   15.963311] device: 'tty32': device_add
[   15.966644] PM: Adding info for No Bus:tty32
[   15.969978] device: 'tty33': device_add
[   15.973311] PM: Adding info for No Bus:tty33
[   15.976644] device: 'tty34': device_add
[   15.979978] PM: Adding info for No Bus:tty34
[   15.983311] device: 'tty35': device_add
[   15.986644] PM: Adding info for No Bus:tty35
[   15.989978] device: 'tty36': device_add
[   15.993311] PM: Adding info for No Bus:tty36
[   15.996644] device: 'tty37': device_add
[   15.999978] PM: Adding info for No Bus:tty37
[   16.003311] device: 'tty38': device_add
[   16.006644] PM: Adding info for No Bus:tty38
[   16.013311] device: 'tty39': device_add
[   16.016644] PM: Adding info for No Bus:tty39
[   16.019978] device: 'tty40': device_add
[   16.023311] PM: Adding info for No Bus:tty40
[   16.026644] device: 'tty41': device_add
[   16.029978] PM: Adding info for No Bus:tty41
[   16.033311] device: 'tty42': device_add
[   16.036644] PM: Adding info for No Bus:tty42
[   16.039978] device: 'tty43': device_add
[   16.043311] PM: Adding info for No Bus:tty43
[   16.049978] device: 'tty44': device_add
[   16.053311] PM: Adding info for No Bus:tty44
[   16.056644] device: 'tty45': device_add
[   16.059978] PM: Adding info for No Bus:tty45
[   16.063311] device: 'tty46': device_add
[   16.066644] PM: Adding info for No Bus:tty46
[   16.069978] device: 'tty47': device_add
[   16.073311] PM: Adding info for No Bus:tty47
[   16.076644] device: 'tty48': device_add
[   16.079978] PM: Adding info for No Bus:tty48
[   16.086644] device: 'tty49': device_add
[   16.089978] PM: Adding info for No Bus:tty49
[   16.093311] device: 'tty50': device_add
[   16.096644] PM: Adding info for No Bus:tty50
[   16.099978] device: 'tty51': device_add
[   16.103311] PM: Adding info for No Bus:tty51
[   16.106644] device: 'tty52': device_add
[   16.113311] PM: Adding info for No Bus:tty52
[   16.116644] device: 'tty53': device_add
[   16.119978] PM: Adding info for No Bus:tty53
[   16.126644] device: 'tty54': device_add
[   16.129978] PM: Adding info for No Bus:tty54
[   16.133311] device: 'tty55': device_add
[   16.136644] PM: Adding info for No Bus:tty55
[   16.139978] device: 'tty56': device_add
[   16.143311] PM: Adding info for No Bus:tty56
[   16.146644] device: 'tty57': device_add
[   16.149978] PM: Adding info for No Bus:tty57
[   16.153311] device: 'tty58': device_add
[   16.156644] PM: Adding info for No Bus:tty58
[   16.159978] device: 'tty59': device_add
[   16.163311] PM: Adding info for No Bus:tty59
[   16.166644] device: 'tty60': device_add
[   16.169978] PM: Adding info for No Bus:tty60
[   16.173311] device: 'tty61': device_add
[   16.176644] PM: Adding info for No Bus:tty61
[   16.179978] device: 'tty62': device_add
[   16.183311] PM: Adding info for No Bus:tty62
[   16.186644] device: 'tty63': device_add
[   16.189978] PM: Adding info for No Bus:tty63
[   16.193311] initcall tty_init+0x0/0x125 returned 0 after 481770 usecs
[   16.196644] calling  pty_init+0x0/0x40 @ 1
[   16.199978] device: 'ptyp0': device_add
[   16.203311] PM: Adding info for No Bus:ptyp0
[   16.206644] device: 'ptyp1': device_add
[   16.209978] PM: Adding info for No Bus:ptyp1
[   16.213311] device: 'ptyp2': device_add
[   16.216644] PM: Adding info for No Bus:ptyp2
[   16.219978] device: 'ptyp3': device_add
[   16.223311] PM: Adding info for No Bus:ptyp3
[   16.226644] device: 'ptyp4': device_add
[   16.229978] PM: Adding info for No Bus:ptyp4
[   16.233311] device: 'ptyp5': device_add
[   16.236644] PM: Adding info for No Bus:ptyp5
[   16.239978] device: 'ptyp6': device_add
[   16.243311] PM: Adding info for No Bus:ptyp6
[   16.246644] device: 'ptyp7': device_add
[   16.249978] PM: Adding info for No Bus:ptyp7
[   16.253311] device: 'ptyp8': device_add
[   16.256644] PM: Adding info for No Bus:ptyp8
[   16.259977] device: 'ptyp9': device_add
[   16.263311] PM: Adding info for No Bus:ptyp9
[   16.269977] device: 'ptypa': device_add
[   16.273311] PM: Adding info for No Bus:ptypa
[   16.276644] device: 'ptypb': device_add
[   16.279977] PM: Adding info for No Bus:ptypb
[   16.283311] device: 'ptypc': device_add
[   16.286644] PM: Adding info for No Bus:ptypc
[   16.289977] device: 'ptypd': device_add
[   16.293311] PM: Adding info for No Bus:ptypd
[   16.296644] device: 'ptype': device_add
[   16.299977] PM: Adding info for No Bus:ptype
[   16.306644] device: 'ptypf': device_add
[   16.309977] PM: Adding info for No Bus:ptypf
[   16.313311] device: 'ptyq0': device_add
[   16.316644] PM: Adding info for No Bus:ptyq0
[   16.319977] device: 'ptyq1': device_add
[   16.323311] PM: Adding info for No Bus:ptyq1
[   16.326644] device: 'ptyq2': device_add
[   16.329977] PM: Adding info for No Bus:ptyq2
[   16.333311] device: 'ptyq3': device_add
[   16.336644] PM: Adding info for No Bus:ptyq3
[   16.343311] device: 'ptyq4': device_add
[   16.346644] PM: Adding info for No Bus:ptyq4
[   16.349977] device: 'ptyq5': device_add
[   16.353311] PM: Adding info for No Bus:ptyq5
[   16.356644] device: 'ptyq6': device_add
[   16.359977] PM: Adding info for No Bus:ptyq6
[   16.363311] device: 'ptyq7': device_add
[   16.366644] PM: Adding info for No Bus:ptyq7
[   16.369977] device: 'ptyq8': device_add
[   16.373311] PM: Adding info for No Bus:ptyq8
[   16.379977] device: 'ptyq9': device_add
[   16.383311] PM: Adding info for No Bus:ptyq9
[   16.386644] device: 'ptyqa': device_add
[   16.389977] PM: Adding info for No Bus:ptyqa
[   16.393311] device: 'ptyqb': device_add
[   16.396644] PM: Adding info for No Bus:ptyqb
[   16.399977] device: 'ptyqc': device_add
[   16.406644] PM: Adding info for No Bus:ptyqc
[   16.409977] device: 'ptyqd': device_add
[   16.413311] PM: Adding info for No Bus:ptyqd
[   16.419977] device: 'ptyqe': device_add
[   16.423311] PM: Adding info for No Bus:ptyqe
[   16.426644] device: 'ptyqf': device_add
[   16.429977] PM: Adding info for No Bus:ptyqf
[   16.433311] device: 'ptyr0': device_add
[   16.436644] PM: Adding info for No Bus:ptyr0
[   16.439977] device: 'ptyr1': device_add
[   16.443311] PM: Adding info for No Bus:ptyr1
[   16.446644] device: 'ptyr2': device_add
[   16.449977] PM: Adding info for No Bus:ptyr2
[   16.453311] device: 'ptyr3': device_add
[   16.456644] PM: Adding info for No Bus:ptyr3
[   16.459977] device: 'ptyr4': device_add
[   16.463311] PM: Adding info for No Bus:ptyr4
[   16.466644] device: 'ptyr5': device_add
[   16.469977] PM: Adding info for No Bus:ptyr5
[   16.473311] device: 'ptyr6': device_add
[   16.476644] PM: Adding info for No Bus:ptyr6
[   16.479977] device: 'ptyr7': device_add
[   16.483311] PM: Adding info for No Bus:ptyr7
[   16.486644] device: 'ptyr8': device_add
[   16.489977] PM: Adding info for No Bus:ptyr8
[   16.493311] device: 'ptyr9': device_add
[   16.496644] PM: Adding info for No Bus:ptyr9
[   16.499977] device: 'ptyra': device_add
[   16.503311] PM: Adding info for No Bus:ptyra
[   16.506644] device: 'ptyrb': device_add
[   16.509977] PM: Adding info for No Bus:ptyrb
[   16.513311] device: 'ptyrc': device_add
[   16.516644] PM: Adding info for No Bus:ptyrc
[   16.523311] device: 'ptyrd': device_add
[   16.526644] PM: Adding info for No Bus:ptyrd
[   16.529977] device: 'ptyre': device_add
[   16.533311] PM: Adding info for No Bus:ptyre
[   16.536644] device: 'ptyrf': device_add
[   16.539977] PM: Adding info for No Bus:ptyrf
[   16.543311] device: 'ptys0': device_add
[   16.546644] PM: Adding info for No Bus:ptys0
[   16.549977] device: 'ptys1': device_add
[   16.553311] PM: Adding info for No Bus:ptys1
[   16.559977] device: 'ptys2': device_add
[   16.563311] PM: Adding info for No Bus:ptys2
[   16.566644] device: 'ptys3': device_add
[   16.569977] PM: Adding info for No Bus:ptys3
[   16.573311] device: 'ptys4': device_add
[   16.576644] PM: Adding info for No Bus:ptys4
[   16.579977] device: 'ptys5': device_add
[   16.583311] PM: Adding info for No Bus:ptys5
[   16.586644] device: 'ptys6': device_add
[   16.589977] PM: Adding info for No Bus:ptys6
[   16.596644] device: 'ptys7': device_add
[   16.599977] PM: Adding info for No Bus:ptys7
[   16.603310] device: 'ptys8': device_add
[   16.606644] PM: Adding info for No Bus:ptys8
[   16.609977] device: 'ptys9': device_add
[   16.613310] PM: Adding info for No Bus:ptys9
[   16.616644] device: 'ptysa': device_add
[   16.623310] PM: Adding info for No Bus:ptysa
[   16.626644] device: 'ptysb': device_add
[   16.629977] PM: Adding info for No Bus:ptysb
[   16.636644] device: 'ptysc': device_add
[   16.639977] PM: Adding info for No Bus:ptysc
[   16.643310] device: 'ptysd': device_add
[   16.646644] PM: Adding info for No Bus:ptysd
[   16.649977] device: 'ptyse': device_add
[   16.653310] PM: Adding info for No Bus:ptyse
[   16.656644] device: 'ptysf': device_add
[   16.659977] PM: Adding info for No Bus:ptysf
[   16.663310] device: 'ptyt0': device_add
[   16.666644] PM: Adding info for No Bus:ptyt0
[   16.669977] device: 'ptyt1': device_add
[   16.673310] PM: Adding info for No Bus:ptyt1
[   16.676644] device: 'ptyt2': device_add
[   16.679977] PM: Adding info for No Bus:ptyt2
[   16.683310] device: 'ptyt3': device_add
[   16.686644] PM: Adding info for No Bus:ptyt3
[   16.689977] device: 'ptyt4': device_add
[   16.693310] PM: Adding info for No Bus:ptyt4
[   16.696644] device: 'ptyt5': device_add
[   16.699977] PM: Adding info for No Bus:ptyt5
[   16.703310] device: 'ptyt6': device_add
[   16.706644] PM: Adding info for No Bus:ptyt6
[   16.709977] device: 'ptyt7': device_add
[   16.713310] PM: Adding info for No Bus:ptyt7
[   16.716644] device: 'ptyt8': device_add
[   16.719977] PM: Adding info for No Bus:ptyt8
[   16.723310] device: 'ptyt9': device_add
[   16.726644] PM: Adding info for No Bus:ptyt9
[   16.729977] device: 'ptyta': device_add
[   16.733310] PM: Adding info for No Bus:ptyta
[   16.736644] device: 'ptytb': device_add
[   16.739977] PM: Adding info for No Bus:ptytb
[   16.743310] device: 'ptytc': device_add
[   16.746644] PM: Adding info for No Bus:ptytc
[   16.753310] device: 'ptytd': device_add
[   16.756644] PM: Adding info for No Bus:ptytd
[   16.759977] device: 'ptyte': device_add
[   16.763310] PM: Adding info for No Bus:ptyte
[   16.766644] device: 'ptytf': device_add
[   16.769977] PM: Adding info for No Bus:ptytf
[   16.773310] device: 'ptyu0': device_add
[   16.776644] PM: Adding info for No Bus:ptyu0
[   16.779977] device: 'ptyu1': device_add
[   16.783310] PM: Adding info for No Bus:ptyu1
[   16.789977] device: 'ptyu2': device_add
[   16.793310] PM: Adding info for No Bus:ptyu2
[   16.796644] device: 'ptyu3': device_add
[   16.799977] PM: Adding info for No Bus:ptyu3
[   16.803310] device: 'ptyu4': device_add
[   16.806644] PM: Adding info for No Bus:ptyu4
[   16.809977] device: 'ptyu5': device_add
[   16.813310] PM: Adding info for No Bus:ptyu5
[   16.816644] device: 'ptyu6': device_add
[   16.819977] PM: Adding info for No Bus:ptyu6
[   16.826644] device: 'ptyu7': device_add
[   16.829977] PM: Adding info for No Bus:ptyu7
[   16.833310] device: 'ptyu8': device_add
[   16.836644] PM: Adding info for No Bus:ptyu8
[   16.839977] device: 'ptyu9': device_add
[   16.843310] PM: Adding info for No Bus:ptyu9
[   16.846644] device: 'ptyua': device_add
[   16.853310] PM: Adding info for No Bus:ptyua
[   16.856644] device: 'ptyub': device_add
[   16.859977] PM: Adding info for No Bus:ptyub
[   16.866644] device: 'ptyuc': device_add
[   16.869977] PM: Adding info for No Bus:ptyuc
[   16.873310] device: 'ptyud': device_add
[   16.876644] PM: Adding info for No Bus:ptyud
[   16.879977] device: 'ptyue': device_add
[   16.883310] PM: Adding info for No Bus:ptyue
[   16.886644] device: 'ptyuf': device_add
[   16.889977] PM: Adding info for No Bus:ptyuf
[   16.893310] device: 'ptyv0': device_add
[   16.896644] PM: Adding info for No Bus:ptyv0
[   16.899977] device: 'ptyv1': device_add
[   16.903310] PM: Adding info for No Bus:ptyv1
[   16.906644] device: 'ptyv2': device_add
[   16.909977] PM: Adding info for No Bus:ptyv2
[   16.913310] device: 'ptyv3': device_add
[   16.916644] PM: Adding info for No Bus:ptyv3
[   16.919977] device: 'ptyv4': device_add
[   16.923310] PM: Adding info for No Bus:ptyv4
[   16.926644] device: 'ptyv5': device_add
[   16.929977] PM: Adding info for No Bus:ptyv5
[   16.933310] device: 'ptyv6': device_add
[   16.936644] PM: Adding info for No Bus:ptyv6
[   16.939977] device: 'ptyv7': device_add
[   16.943310] PM: Adding info for No Bus:ptyv7
[   16.946643] device: 'ptyv8': device_add
[   16.949977] PM: Adding info for No Bus:ptyv8
[   16.953310] device: 'ptyv9': device_add
[   16.956643] PM: Adding info for No Bus:ptyv9
[   16.959977] device: 'ptyva': device_add
[   16.963310] PM: Adding info for No Bus:ptyva
[   16.966643] device: 'ptyvb': device_add
[   16.969977] PM: Adding info for No Bus:ptyvb
[   16.973310] device: 'ptyvc': device_add
[   16.976643] PM: Adding info for No Bus:ptyvc
[   16.983310] device: 'ptyvd': device_add
[   16.986643] PM: Adding info for No Bus:ptyvd
[   16.989977] device: 'ptyve': device_add
[   16.993310] PM: Adding info for No Bus:ptyve
[   16.996643] device: 'ptyvf': device_add
[   16.999977] PM: Adding info for No Bus:ptyvf
[   17.003310] device: 'ptyw0': device_add
[   17.006643] PM: Adding info for No Bus:ptyw0
[   17.009977] device: 'ptyw1': device_add
[   17.013310] PM: Adding info for No Bus:ptyw1
[   17.019977] device: 'ptyw2': device_add
[   17.023310] PM: Adding info for No Bus:ptyw2
[   17.026643] device: 'ptyw3': device_add
[   17.029977] PM: Adding info for No Bus:ptyw3
[   17.033310] device: 'ptyw4': device_add
[   17.036643] PM: Adding info for No Bus:ptyw4
[   17.039977] device: 'ptyw5': device_add
[   17.043310] PM: Adding info for No Bus:ptyw5
[   17.046643] device: 'ptyw6': device_add
[   17.049977] PM: Adding info for No Bus:ptyw6
[   17.056643] device: 'ptyw7': device_add
[   17.059977] PM: Adding info for No Bus:ptyw7
[   17.063310] device: 'ptyw8': device_add
[   17.066643] PM: Adding info for No Bus:ptyw8
[   17.069977] device: 'ptyw9': device_add
[   17.073310] PM: Adding info for No Bus:ptyw9
[   17.076643] device: 'ptywa': device_add
[   17.079977] PM: Adding info for No Bus:ptywa
[   17.083310] device: 'ptywb': device_add
[   17.086643] PM: Adding info for No Bus:ptywb
[   17.089977] device: 'ptywc': device_add
[   17.093310] PM: Adding info for No Bus:ptywc
[   17.096643] device: 'ptywd': device_add
[   17.099977] PM: Adding info for No Bus:ptywd
[   17.103310] device: 'ptywe': device_add
[   17.106643] PM: Adding info for No Bus:ptywe
[   17.109977] device: 'ptywf': device_add
[   17.113310] PM: Adding info for No Bus:ptywf
[   17.116643] device: 'ptyx0': device_add
[   17.119977] PM: Adding info for No Bus:ptyx0
[   17.123310] device: 'ptyx1': device_add
[   17.126643] PM: Adding info for No Bus:ptyx1
[   17.129977] device: 'ptyx2': device_add
[   17.133310] PM: Adding info for No Bus:ptyx2
[   17.136643] device: 'ptyx3': device_add
[   17.139977] PM: Adding info for No Bus:ptyx3
[   17.143310] device: 'ptyx4': device_add
[   17.146643] PM: Adding info for No Bus:ptyx4
[   17.149977] device: 'ptyx5': device_add
[   17.153310] PM: Adding info for No Bus:ptyx5
[   17.156643] device: 'ptyx6': device_add
[   17.159977] PM: Adding info for No Bus:ptyx6
[   17.163310] device: 'ptyx7': device_add
[   17.166643] PM: Adding info for No Bus:ptyx7
[   17.169977] device: 'ptyx8': device_add
[   17.173310] PM: Adding info for No Bus:ptyx8
[   17.176643] device: 'ptyx9': device_add
[   17.179977] PM: Adding info for No Bus:ptyx9
[   17.183310] device: 'ptyxa': device_add
[   17.186643] PM: Adding info for No Bus:ptyxa
[   17.193310] device: 'ptyxb': device_add
[   17.196643] PM: Adding info for No Bus:ptyxb
[   17.199977] device: 'ptyxc': device_add
[   17.203310] PM: Adding info for No Bus:ptyxc
[   17.206643] device: 'ptyxd': device_add
[   17.209977] PM: Adding info for No Bus:ptyxd
[   17.213310] device: 'ptyxe': device_add
[   17.216643] PM: Adding info for No Bus:ptyxe
[   17.219977] device: 'ptyxf': device_add
[   17.223310] PM: Adding info for No Bus:ptyxf
[   17.229977] device: 'ptyy0': device_add
[   17.233310] PM: Adding info for No Bus:ptyy0
[   17.236643] device: 'ptyy1': device_add
[   17.239977] PM: Adding info for No Bus:ptyy1
[   17.243310] device: 'ptyy2': device_add
[   17.246643] PM: Adding info for No Bus:ptyy2
[   17.249977] device: 'ptyy3': device_add
[   17.253310] PM: Adding info for No Bus:ptyy3
[   17.256643] device: 'ptyy4': device_add
[   17.259977] PM: Adding info for No Bus:ptyy4
[   17.266643] device: 'ptyy5': device_add
[   17.269977] PM: Adding info for No Bus:ptyy5
[   17.273310] device: 'ptyy6': device_add
[   17.276643] PM: Adding info for No Bus:ptyy6
[   17.279977] device: 'ptyy7': device_add
[   17.283310] PM: Adding info for No Bus:ptyy7
[   17.286643] device: 'ptyy8': device_add
[   17.289977] PM: Adding info for No Bus:ptyy8
[   17.293310] device: 'ptyy9': device_add
[   17.296643] PM: Adding info for No Bus:ptyy9
[   17.303310] device: 'ptyya': device_add
[   17.306643] PM: Adding info for No Bus:ptyya
[   17.309976] device: 'ptyyb': device_add
[   17.313310] PM: Adding info for No Bus:ptyyb
[   17.316643] device: 'ptyyc': device_add
[   17.319976] PM: Adding info for No Bus:ptyyc
[   17.323310] device: 'ptyyd': device_add
[   17.326643] PM: Adding info for No Bus:ptyyd
[   17.329976] device: 'ptyye': device_add
[   17.333310] PM: Adding info for No Bus:ptyye
[   17.339976] device: 'ptyyf': device_add
[   17.343310] PM: Adding info for No Bus:ptyyf
[   17.346643] device: 'ptyz0': device_add
[   17.349976] PM: Adding info for No Bus:ptyz0
[   17.353310] device: 'ptyz1': device_add
[   17.356643] PM: Adding info for No Bus:ptyz1
[   17.359976] device: 'ptyz2': device_add
[   17.363310] PM: Adding info for No Bus:ptyz2
[   17.366643] device: 'ptyz3': device_add
[   17.369976] PM: Adding info for No Bus:ptyz3
[   17.376643] device: 'ptyz4': device_add
[   17.379976] PM: Adding info for No Bus:ptyz4
[   17.383310] device: 'ptyz5': device_add
[   17.386643] PM: Adding info for No Bus:ptyz5
[   17.389976] device: 'ptyz6': device_add
[   17.393310] PM: Adding info for No Bus:ptyz6
[   17.396643] device: 'ptyz7': device_add
[   17.399976] PM: Adding info for No Bus:ptyz7
[   17.403310] device: 'ptyz8': device_add
[   17.406643] PM: Adding info for No Bus:ptyz8
[   17.413310] device: 'ptyz9': device_add
[   17.416643] PM: Adding info for No Bus:ptyz9
[   17.419976] device: 'ptyza': device_add
[   17.423310] PM: Adding info for No Bus:ptyza
[   17.426643] device: 'ptyzb': device_add
[   17.429976] PM: Adding info for No Bus:ptyzb
[   17.433310] device: 'ptyzc': device_add
[   17.436643] PM: Adding info for No Bus:ptyzc
[   17.439976] device: 'ptyzd': device_add
[   17.443310] PM: Adding info for No Bus:ptyzd
[   17.449976] device: 'ptyze': device_add
[   17.453310] PM: Adding info for No Bus:ptyze
[   17.456643] device: 'ptyzf': device_add
[   17.459976] PM: Adding info for No Bus:ptyzf
[   17.463310] device: 'ptya0': device_add
[   17.466643] PM: Adding info for No Bus:ptya0
[   17.469976] device: 'ptya1': device_add
[   17.473310] PM: Adding info for No Bus:ptya1
[   17.476643] device: 'ptya2': device_add
[   17.479976] PM: Adding info for No Bus:ptya2
[   17.486643] device: 'ptya3': device_add
[   17.489976] PM: Adding info for No Bus:ptya3
[   17.493310] device: 'ptya4': device_add
[   17.496643] PM: Adding info for No Bus:ptya4
[   17.499976] device: 'ptya5': device_add
[   17.503310] PM: Adding info for No Bus:ptya5
[   17.506643] device: 'ptya6': device_add
[   17.509976] PM: Adding info for No Bus:ptya6
[   17.513310] device: 'ptya7': device_add
[   17.516643] PM: Adding info for No Bus:ptya7
[   17.523310] device: 'ptya8': device_add
[   17.526643] PM: Adding info for No Bus:ptya8
[   17.529976] device: 'ptya9': device_add
[   17.533310] PM: Adding info for No Bus:ptya9
[   17.536643] device: 'ptyaa': device_add
[   17.539976] PM: Adding info for No Bus:ptyaa
[   17.543310] device: 'ptyab': device_add
[   17.546643] PM: Adding info for No Bus:ptyab
[   17.549976] device: 'ptyac': device_add
[   17.553310] PM: Adding info for No Bus:ptyac
[   17.559976] device: 'ptyad': device_add
[   17.563310] PM: Adding info for No Bus:ptyad
[   17.566643] device: 'ptyae': device_add
[   17.569976] PM: Adding info for No Bus:ptyae
[   17.573310] device: 'ptyaf': device_add
[   17.576643] PM: Adding info for No Bus:ptyaf
[   17.579976] device: 'ptyb0': device_add
[   17.583310] PM: Adding info for No Bus:ptyb0
[   17.586643] device: 'ptyb1': device_add
[   17.589976] PM: Adding info for No Bus:ptyb1
[   17.596643] device: 'ptyb2': device_add
[   17.599976] PM: Adding info for No Bus:ptyb2
[   17.603310] device: 'ptyb3': device_add
[   17.606643] PM: Adding info for No Bus:ptyb3
[   17.609976] device: 'ptyb4': device_add
[   17.613310] PM: Adding info for No Bus:ptyb4
[   17.616643] device: 'ptyb5': device_add
[   17.619976] PM: Adding info for No Bus:ptyb5
[   17.623310] device: 'ptyb6': device_add
[   17.626643] PM: Adding info for No Bus:ptyb6
[   17.633310] device: 'ptyb7': device_add
[   17.636643] PM: Adding info for No Bus:ptyb7
[   17.639976] device: 'ptyb8': device_add
[   17.643310] PM: Adding info for No Bus:ptyb8
[   17.646643] device: 'ptyb9': device_add
[   17.649976] PM: Adding info for No Bus:ptyb9
[   17.653310] device: 'ptyba': device_add
[   17.656643] spurious 8259A interrupt: IRQ7.
[   17.659976] PM: Adding info for No Bus:ptyba
[   17.663310] device: 'ptybb': device_add
[   17.666643] PM: Adding info for No Bus:ptybb
[   17.669976] device: 'ptybc': device_add
[   17.673310] PM: Adding info for No Bus:ptybc
[   17.676643] device: 'ptybd': device_add
[   17.679976] PM: Adding info for No Bus:ptybd
[   17.683310] device: 'ptybe': device_add
[   17.686643] PM: Adding info for No Bus:ptybe
[   17.693310] device: 'ptybf': device_add
[   17.696643] PM: Adding info for No Bus:ptybf
[   17.699976] device: 'ptyc0': device_add
[   17.703309] PM: Adding info for No Bus:ptyc0
[   17.706643] device: 'ptyc1': device_add
[   17.709976] PM: Adding info for No Bus:ptyc1
[   17.713309] device: 'ptyc2': device_add
[   17.716643] PM: Adding info for No Bus:ptyc2
[   17.719976] device: 'ptyc3': device_add
[   17.723309] PM: Adding info for No Bus:ptyc3
[   17.726643] device: 'ptyc4': device_add
[   17.729976] PM: Adding info for No Bus:ptyc4
[   17.733309] device: 'ptyc5': device_add
[   17.736643] PM: Adding info for No Bus:ptyc5
[   17.739976] device: 'ptyc6': device_add
[   17.743309] PM: Adding info for No Bus:ptyc6
[   17.746643] device: 'ptyc7': device_add
[   17.749976] PM: Adding info for No Bus:ptyc7
[   17.753309] device: 'ptyc8': device_add
[   17.756643] PM: Adding info for No Bus:ptyc8
[   17.759976] device: 'ptyc9': device_add
[   17.763309] PM: Adding info for No Bus:ptyc9
[   17.766643] device: 'ptyca': device_add
[   17.769976] PM: Adding info for No Bus:ptyca
[   17.773309] device: 'ptycb': device_add
[   17.776643] PM: Adding info for No Bus:ptycb
[   17.779976] device: 'ptycc': device_add
[   17.783309] PM: Adding info for No Bus:ptycc
[   17.786643] device: 'ptycd': device_add
[   17.789976] PM: Adding info for No Bus:ptycd
[   17.793309] device: 'ptyce': device_add
[   17.796643] PM: Adding info for No Bus:ptyce
[   17.799976] device: 'ptycf': device_add
[   17.803309] PM: Adding info for No Bus:ptycf
[   17.806643] device: 'ptyd0': device_add
[   17.809976] PM: Adding info for No Bus:ptyd0
[   17.813309] device: 'ptyd1': device_add
[   17.816643] PM: Adding info for No Bus:ptyd1
[   17.819976] device: 'ptyd2': device_add
[   17.823309] PM: Adding info for No Bus:ptyd2
[   17.826643] device: 'ptyd3': device_add
[   17.829976] PM: Adding info for No Bus:ptyd3
[   17.833309] device: 'ptyd4': device_add
[   17.836643] PM: Adding info for No Bus:ptyd4
[   17.839976] device: 'ptyd5': device_add
[   17.843309] PM: Adding info for No Bus:ptyd5
[   17.846643] device: 'ptyd6': device_add
[   17.849976] PM: Adding info for No Bus:ptyd6
[   17.853309] device: 'ptyd7': device_add
[   17.856643] PM: Adding info for No Bus:ptyd7
[   17.863309] device: 'ptyd8': device_add
[   17.866643] PM: Adding info for No Bus:ptyd8
[   17.869976] device: 'ptyd9': device_add
[   17.873309] PM: Adding info for No Bus:ptyd9
[   17.876643] device: 'ptyda': device_add
[   17.879976] PM: Adding info for No Bus:ptyda
[   17.883309] device: 'ptydb': device_add
[   17.886643] PM: Adding info for No Bus:ptydb
[   17.889976] device: 'ptydc': device_add
[   17.893309] PM: Adding info for No Bus:ptydc
[   17.899976] device: 'ptydd': device_add
[   17.903309] PM: Adding info for No Bus:ptydd
[   17.906643] device: 'ptyde': device_add
[   17.909976] PM: Adding info for No Bus:ptyde
[   17.913309] device: 'ptydf': device_add
[   17.916643] PM: Adding info for No Bus:ptydf
[   17.919976] device: 'ptye0': device_add
[   17.923309] PM: Adding info for No Bus:ptye0
[   17.926643] device: 'ptye1': device_add
[   17.929976] PM: Adding info for No Bus:ptye1
[   17.936643] device: 'ptye2': device_add
[   17.939976] PM: Adding info for No Bus:ptye2
[   17.943309] device: 'ptye3': device_add
[   17.946643] PM: Adding info for No Bus:ptye3
[   17.949976] device: 'ptye4': device_add
[   17.953309] PM: Adding info for No Bus:ptye4
[   17.956643] device: 'ptye5': device_add
[   17.959976] PM: Adding info for No Bus:ptye5
[   17.963309] device: 'ptye6': device_add
[   17.966643] PM: Adding info for No Bus:ptye6
[   17.973309] device: 'ptye7': device_add
[   17.976643] PM: Adding info for No Bus:ptye7
[   17.979976] device: 'ptye8': device_add
[   17.983309] PM: Adding info for No Bus:ptye8
[   17.986643] device: 'ptye9': device_add
[   17.989976] PM: Adding info for No Bus:ptye9
[   17.993309] device: 'ptyea': device_add
[   17.996643] PM: Adding info for No Bus:ptyea
[   17.999976] device: 'ptyeb': device_add
[   18.003309] PM: Adding info for No Bus:ptyeb
[   18.009976] device: 'ptyec': device_add
[   18.013309] PM: Adding info for No Bus:ptyec
[   18.016643] device: 'ptyed': device_add
[   18.019976] PM: Adding info for No Bus:ptyed
[   18.023309] device: 'ptyee': device_add
[   18.026643] PM: Adding info for No Bus:ptyee
[   18.029976] device: 'ptyef': device_add
[   18.033309] PM: Adding info for No Bus:ptyef
[   18.036643] device: 'ttyp0': device_add
[   18.039976] PM: Adding info for No Bus:ttyp0
[   18.046643] device: 'ttyp1': device_add
[   18.049976] PM: Adding info for No Bus:ttyp1
[   18.053309] device: 'ttyp2': device_add
[   18.056643] PM: Adding info for No Bus:ttyp2
[   18.059976] device: 'ttyp3': device_add
[   18.063309] PM: Adding info for No Bus:ttyp3
[   18.066643] device: 'ttyp4': device_add
[   18.069976] PM: Adding info for No Bus:ttyp4
[   18.073309] device: 'ttyp5': device_add
[   18.076643] PM: Adding info for No Bus:ttyp5
[   18.083309] device: 'ttyp6': device_add
[   18.086643] PM: Adding info for No Bus:ttyp6
[   18.089976] device: 'ttyp7': device_add
[   18.093309] PM: Adding info for No Bus:ttyp7
[   18.096643] device: 'ttyp8': device_add
[   18.099976] PM: Adding info for No Bus:ttyp8
[   18.103309] device: 'ttyp9': device_add
[   18.106642] PM: Adding info for No Bus:ttyp9
[   18.109976] device: 'ttypa': device_add
[   18.113309] PM: Adding info for No Bus:ttypa
[   18.119976] device: 'ttypb': device_add
[   18.123309] PM: Adding info for No Bus:ttypb
[   18.126642] device: 'ttypc': device_add
[   18.129976] PM: Adding info for No Bus:ttypc
[   18.133309] device: 'ttypd': device_add
[   18.136642] PM: Adding info for No Bus:ttypd
[   18.139976] device: 'ttype': device_add
[   18.143309] PM: Adding info for No Bus:ttype
[   18.146642] device: 'ttypf': device_add
[   18.149976] PM: Adding info for No Bus:ttypf
[   18.156642] device: 'ttyq0': device_add
[   18.159976] PM: Adding info for No Bus:ttyq0
[   18.163309] device: 'ttyq1': device_add
[   18.166642] PM: Adding info for No Bus:ttyq1
[   18.169976] device: 'ttyq2': device_add
[   18.173309] PM: Adding info for No Bus:ttyq2
[   18.176642] device: 'ttyq3': device_add
[   18.179976] PM: Adding info for No Bus:ttyq3
[   18.183309] device: 'ttyq4': device_add
[   18.186642] PM: Adding info for No Bus:ttyq4
[   18.193309] device: 'ttyq5': device_add
[   18.196642] PM: Adding info for No Bus:ttyq5
[   18.199976] device: 'ttyq6': device_add
[   18.203309] PM: Adding info for No Bus:ttyq6
[   18.206642] device: 'ttyq7': device_add
[   18.209976] PM: Adding info for No Bus:ttyq7
[   18.213309] device: 'ttyq8': device_add
[   18.216642] PM: Adding info for No Bus:ttyq8
[   18.219976] device: 'ttyq9': device_add
[   18.223309] PM: Adding info for No Bus:ttyq9
[   18.229976] device: 'ttyqa': device_add
[   18.233309] PM: Adding info for No Bus:ttyqa
[   18.236642] device: 'ttyqb': device_add
[   18.239976] PM: Adding info for No Bus:ttyqb
[   18.243309] device: 'ttyqc': device_add
[   18.246642] PM: Adding info for No Bus:ttyqc
[   18.249976] device: 'ttyqd': device_add
[   18.253309] PM: Adding info for No Bus:ttyqd
[   18.256642] device: 'ttyqe': device_add
[   18.259976] PM: Adding info for No Bus:ttyqe
[   18.266642] device: 'ttyqf': device_add
[   18.269976] PM: Adding info for No Bus:ttyqf
[   18.273309] device: 'ttyr0': device_add
[   18.276642] PM: Adding info for No Bus:ttyr0
[   18.279976] device: 'ttyr1': device_add
[   18.283309] PM: Adding info for No Bus:ttyr1
[   18.286642] device: 'ttyr2': device_add
[   18.289976] PM: Adding info for No Bus:ttyr2
[   18.293309] device: 'ttyr3': device_add
[   18.296642] PM: Adding info for No Bus:ttyr3
[   18.303309] device: 'ttyr4': device_add
[   18.306642] PM: Adding info for No Bus:ttyr4
[   18.309976] device: 'ttyr5': device_add
[   18.313309] PM: Adding info for No Bus:ttyr5
[   18.316642] device: 'ttyr6': device_add
[   18.319976] PM: Adding info for No Bus:ttyr6
[   18.323309] device: 'ttyr7': device_add
[   18.326642] PM: Adding info for No Bus:ttyr7
[   18.329976] device: 'ttyr8': device_add
[   18.333309] PM: Adding info for No Bus:ttyr8
[   18.339976] device: 'ttyr9': device_add
[   18.343309] PM: Adding info for No Bus:ttyr9
[   18.346642] device: 'ttyra': device_add
[   18.349976] PM: Adding info for No Bus:ttyra
[   18.353309] device: 'ttyrb': device_add
[   18.356642] PM: Adding info for No Bus:ttyrb
[   18.359976] device: 'ttyrc': device_add
[   18.363309] PM: Adding info for No Bus:ttyrc
[   18.366642] device: 'ttyrd': device_add
[   18.369976] PM: Adding info for No Bus:ttyrd
[   18.373309] device: 'ttyre': device_add
[   18.376642] PM: Adding info for No Bus:ttyre
[   18.379976] device: 'ttyrf': device_add
[   18.383309] PM: Adding info for No Bus:ttyrf
[   18.386642] device: 'ttys0': device_add
[   18.389976] PM: Adding info for No Bus:ttys0
[   18.393309] device: 'ttys1': device_add
[   18.396642] PM: Adding info for No Bus:ttys1
[   18.399976] device: 'ttys2': device_add
[   18.403309] PM: Adding info for No Bus:ttys2
[   18.406642] device: 'ttys3': device_add
[   18.409976] PM: Adding info for No Bus:ttys3
[   18.413309] device: 'ttys4': device_add
[   18.416642] PM: Adding info for No Bus:ttys4
[   18.419976] device: 'ttys5': device_add
[   18.423309] PM: Adding info for No Bus:ttys5
[   18.426642] device: 'ttys6': device_add
[   18.429976] PM: Adding info for No Bus:ttys6
[   18.433309] device: 'ttys7': device_add
[   18.436642] PM: Adding info for No Bus:ttys7
[   18.439976] device: 'ttys8': device_add
[   18.443309] PM: Adding info for No Bus:ttys8
[   18.446642] device: 'ttys9': device_add
[   18.449976] PM: Adding info for No Bus:ttys9
[   18.453309] device: 'ttysa': device_add
[   18.456642] PM: Adding info for No Bus:ttysa
[   18.459976] device: 'ttysb': device_add
[   18.463309] PM: Adding info for No Bus:ttysb
[   18.466642] device: 'ttysc': device_add
[   18.469976] PM: Adding info for No Bus:ttysc
[   18.473309] device: 'ttysd': device_add
[   18.476642] PM: Adding info for No Bus:ttysd
[   18.479976] device: 'ttyse': device_add
[   18.483309] PM: Adding info for No Bus:ttyse
[   18.486642] device: 'ttysf': device_add
[   18.489976] PM: Adding info for No Bus:ttysf
[   18.493309] device: 'ttyt0': device_add
[   18.496642] PM: Adding info for No Bus:ttyt0
[   18.499976] device: 'ttyt1': device_add
[   18.503309] PM: Adding info for No Bus:ttyt1
[   18.506642] device: 'ttyt2': device_add
[   18.509976] PM: Adding info for No Bus:ttyt2
[   18.513309] device: 'ttyt3': device_add
[   18.516642] PM: Adding info for No Bus:ttyt3
[   18.519976] device: 'ttyt4': device_add
[   18.523309] PM: Adding info for No Bus:ttyt4
[   18.526642] device: 'ttyt5': device_add
[   18.529975] PM: Adding info for No Bus:ttyt5
[   18.533309] device: 'ttyt6': device_add
[   18.536642] PM: Adding info for No Bus:ttyt6
[   18.543309] device: 'ttyt7': device_add
[   18.546642] PM: Adding info for No Bus:ttyt7
[   18.549975] device: 'ttyt8': device_add
[   18.553309] PM: Adding info for No Bus:ttyt8
[   18.556642] device: 'ttyt9': device_add
[   18.559975] PM: Adding info for No Bus:ttyt9
[   18.563309] device: 'ttyta': device_add
[   18.566642] PM: Adding info for No Bus:ttyta
[   18.569975] device: 'ttytb': device_add
[   18.573309] PM: Adding info for No Bus:ttytb
[   18.579975] device: 'ttytc': device_add
[   18.583309] PM: Adding info for No Bus:ttytc
[   18.586642] device: 'ttytd': device_add
[   18.589975] PM: Adding info for No Bus:ttytd
[   18.593309] device: 'ttyte': device_add
[   18.596642] PM: Adding info for No Bus:ttyte
[   18.599975] device: 'ttytf': device_add
[   18.603309] PM: Adding info for No Bus:ttytf
[   18.606642] device: 'ttyu0': device_add
[   18.609975] PM: Adding info for No Bus:ttyu0
[   18.616642] device: 'ttyu1': device_add
[   18.619975] PM: Adding info for No Bus:ttyu1
[   18.623309] device: 'ttyu2': device_add
[   18.626642] PM: Adding info for No Bus:ttyu2
[   18.629975] device: 'ttyu3': device_add
[   18.633309] PM: Adding info for No Bus:ttyu3
[   18.636642] device: 'ttyu4': device_add
[   18.639975] PM: Adding info for No Bus:ttyu4
[   18.643309] device: 'ttyu5': device_add
[   18.646642] PM: Adding info for No Bus:ttyu5
[   18.653309] device: 'ttyu6': device_add
[   18.656642] PM: Adding info for No Bus:ttyu6
[   18.659975] device: 'ttyu7': device_add
[   18.663309] PM: Adding info for No Bus:ttyu7
[   18.666642] device: 'ttyu8': device_add
[   18.669975] PM: Adding info for No Bus:ttyu8
[   18.673309] device: 'ttyu9': device_add
[   18.676642] PM: Adding info for No Bus:ttyu9
[   18.679975] device: 'ttyua': device_add
[   18.683309] PM: Adding info for No Bus:ttyua
[   18.689975] device: 'ttyub': device_add
[   18.693309] PM: Adding info for No Bus:ttyub
[   18.696642] device: 'ttyuc': device_add
[   18.699975] PM: Adding info for No Bus:ttyuc
[   18.703309] device: 'ttyud': device_add
[   18.706642] PM: Adding info for No Bus:ttyud
[   18.709975] device: 'ttyue': device_add
[   18.713309] PM: Adding info for No Bus:ttyue
[   18.716642] device: 'ttyuf': device_add
[   18.719975] PM: Adding info for No Bus:ttyuf
[   18.726642] device: 'ttyv0': device_add
[   18.729975] PM: Adding info for No Bus:ttyv0
[   18.733309] device: 'ttyv1': device_add
[   18.736642] PM: Adding info for No Bus:ttyv1
[   18.739975] device: 'ttyv2': device_add
[   18.743309] PM: Adding info for No Bus:ttyv2
[   18.746642] device: 'ttyv3': device_add
[   18.749975] PM: Adding info for No Bus:ttyv3
[   18.753309] device: 'ttyv4': device_add
[   18.756642] PM: Adding info for No Bus:ttyv4
[   18.763309] device: 'ttyv5': device_add
[   18.766642] PM: Adding info for No Bus:ttyv5
[   18.769975] device: 'ttyv6': device_add
[   18.773309] PM: Adding info for No Bus:ttyv6
[   18.776642] device: 'ttyv7': device_add
[   18.779975] PM: Adding info for No Bus:ttyv7
[   18.783309] device: 'ttyv8': device_add
[   18.786642] PM: Adding info for No Bus:ttyv8
[   18.789975] device: 'ttyv9': device_add
[   18.793309] PM: Adding info for No Bus:ttyv9
[   18.799975] device: 'ttyva': device_add
[   18.803309] PM: Adding info for No Bus:ttyva
[   18.806642] device: 'ttyvb': device_add
[   18.809975] PM: Adding info for No Bus:ttyvb
[   18.813309] device: 'ttyvc': device_add
[   18.816642] PM: Adding info for No Bus:ttyvc
[   18.819975] device: 'ttyvd': device_add
[   18.823309] PM: Adding info for No Bus:ttyvd
[   18.826642] device: 'ttyve': device_add
[   18.829975] PM: Adding info for No Bus:ttyve
[   18.836642] device: 'ttyvf': device_add
[   18.839975] PM: Adding info for No Bus:ttyvf
[   18.843309] device: 'ttyw0': device_add
[   18.846642] PM: Adding info for No Bus:ttyw0
[   18.849975] device: 'ttyw1': device_add
[   18.853309] PM: Adding info for No Bus:ttyw1
[   18.856642] device: 'ttyw2': device_add
[   18.859975] PM: Adding info for No Bus:ttyw2
[   18.863309] device: 'ttyw3': device_add
[   18.866642] PM: Adding info for No Bus:ttyw3
[   18.869975] device: 'ttyw4': device_add
[   18.873309] PM: Adding info for No Bus:ttyw4
[   18.876642] device: 'ttyw5': device_add
[   18.879975] PM: Adding info for No Bus:ttyw5
[   18.883309] device: 'ttyw6': device_add
[   18.886642] PM: Adding info for No Bus:ttyw6
[   18.889975] device: 'ttyw7': device_add
[   18.893309] PM: Adding info for No Bus:ttyw7
[   18.896642] device: 'ttyw8': device_add
[   18.899975] PM: Adding info for No Bus:ttyw8
[   18.906642] device: 'ttyw9': device_add
[   18.909975] PM: Adding info for No Bus:ttyw9
[   18.913309] device: 'ttywa': device_add
[   18.916642] PM: Adding info for No Bus:ttywa
[   18.919975] device: 'ttywb': device_add
[   18.923309] PM: Adding info for No Bus:ttywb
[   18.926642] device: 'ttywc': device_add
[   18.929975] PM: Adding info for No Bus:ttywc
[   18.933309] device: 'ttywd': device_add
[   18.936642] PM: Adding info for No Bus:ttywd
[   18.939975] device: 'ttywe': device_add
[   18.943309] PM: Adding info for No Bus:ttywe
[   18.946642] device: 'ttywf': device_add
[   18.949975] PM: Adding info for No Bus:ttywf
[   18.953309] device: 'ttyx0': device_add
[   18.956642] PM: Adding info for No Bus:ttyx0
[   18.959975] device: 'ttyx1': device_add
[   18.963309] PM: Adding info for No Bus:ttyx1
[   18.966642] device: 'ttyx2': device_add
[   18.969975] PM: Adding info for No Bus:ttyx2
[   18.973309] device: 'ttyx3': device_add
[   18.976642] PM: Adding info for No Bus:ttyx3
[   18.979975] device: 'ttyx4': device_add
[   18.983308] PM: Adding info for No Bus:ttyx4
[   18.986642] device: 'ttyx5': device_add
[   18.989975] PM: Adding info for No Bus:ttyx5
[   18.993308] device: 'ttyx6': device_add
[   18.996642] PM: Adding info for No Bus:ttyx6
[   18.999975] device: 'ttyx7': device_add
[   19.003308] PM: Adding info for No Bus:ttyx7
[   19.006642] device: 'ttyx8': device_add
[   19.009975] PM: Adding info for No Bus:ttyx8
[   19.013308] device: 'ttyx9': device_add
[   19.016642] PM: Adding info for No Bus:ttyx9
[   19.019975] device: 'ttyxa': device_add
[   19.023308] PM: Adding info for No Bus:ttyxa
[   19.029975] device: 'ttyxb': device_add
[   19.033308] PM: Adding info for No Bus:ttyxb
[   19.036642] device: 'ttyxc': device_add
[   19.039975] PM: Adding info for No Bus:ttyxc
[   19.043308] device: 'ttyxd': device_add
[   19.046642] PM: Adding info for No Bus:ttyxd
[   19.049975] device: 'ttyxe': device_add
[   19.053308] PM: Adding info for No Bus:ttyxe
[   19.056642] device: 'ttyxf': device_add
[   19.059975] PM: Adding info for No Bus:ttyxf
[   19.066642] device: 'ttyy0': device_add
[   19.069975] PM: Adding info for No Bus:ttyy0
[   19.073308] device: 'ttyy1': device_add
[   19.076642] PM: Adding info for No Bus:ttyy1
[   19.079975] device: 'ttyy2': device_add
[   19.083308] PM: Adding info for No Bus:ttyy2
[   19.086642] device: 'ttyy3': device_add
[   19.089975] PM: Adding info for No Bus:ttyy3
[   19.093308] device: 'ttyy4': device_add
[   19.096642] PM: Adding info for No Bus:ttyy4
[   19.103308] device: 'ttyy5': device_add
[   19.106642] PM: Adding info for No Bus:ttyy5
[   19.109975] device: 'ttyy6': device_add
[   19.113308] PM: Adding info for No Bus:ttyy6
[   19.116642] device: 'ttyy7': device_add
[   19.119975] PM: Adding info for No Bus:ttyy7
[   19.123308] device: 'ttyy8': device_add
[   19.126642] PM: Adding info for No Bus:ttyy8
[   19.129975] device: 'ttyy9': device_add
[   19.133308] PM: Adding info for No Bus:ttyy9
[   19.139975] device: 'ttyya': device_add
[   19.143308] PM: Adding info for No Bus:ttyya
[   19.146642] device: 'ttyyb': device_add
[   19.149975] PM: Adding info for No Bus:ttyyb
[   19.153308] device: 'ttyyc': device_add
[   19.156642] PM: Adding info for No Bus:ttyyc
[   19.159975] device: 'ttyyd': device_add
[   19.163308] PM: Adding info for No Bus:ttyyd
[   19.166642] device: 'ttyye': device_add
[   19.169975] PM: Adding info for No Bus:ttyye
[   19.173308] device: 'ttyyf': device_add
[   19.176642] PM: Adding info for No Bus:ttyyf
[   19.179975] device: 'ttyz0': device_add
[   19.183308] PM: Adding info for No Bus:ttyz0
[   19.186642] device: 'ttyz1': device_add
[   19.189975] PM: Adding info for No Bus:ttyz1
[   19.193308] device: 'ttyz2': device_add
[   19.196642] PM: Adding info for No Bus:ttyz2
[   19.199975] device: 'ttyz3': device_add
[   19.203308] PM: Adding info for No Bus:ttyz3
[   19.206642] device: 'ttyz4': device_add
[   19.209975] PM: Adding info for No Bus:ttyz4
[   19.213308] device: 'ttyz5': device_add
[   19.216642] PM: Adding info for No Bus:ttyz5
[   19.219975] device: 'ttyz6': device_add
[   19.223308] PM: Adding info for No Bus:ttyz6
[   19.226642] device: 'ttyz7': device_add
[   19.229975] PM: Adding info for No Bus:ttyz7
[   19.233308] device: 'ttyz8': device_add
[   19.236642] PM: Adding info for No Bus:ttyz8
[   19.239975] device: 'ttyz9': device_add
[   19.243308] PM: Adding info for No Bus:ttyz9
[   19.246642] device: 'ttyza': device_add
[   19.249975] PM: Adding info for No Bus:ttyza
[   19.253308] device: 'ttyzb': device_add
[   19.256642] PM: Adding info for No Bus:ttyzb
[   19.259975] device: 'ttyzc': device_add
[   19.263308] PM: Adding info for No Bus:ttyzc
[   19.266642] device: 'ttyzd': device_add
[   19.269975] PM: Adding info for No Bus:ttyzd
[   19.273308] device: 'ttyze': device_add
[   19.276642] PM: Adding info for No Bus:ttyze
[   19.279975] device: 'ttyzf': device_add
[   19.283308] PM: Adding info for No Bus:ttyzf
[   19.286642] device: 'ttya0': device_add
[   19.289975] PM: Adding info for No Bus:ttya0
[   19.293308] device: 'ttya1': device_add
[   19.296642] PM: Adding info for No Bus:ttya1
[   19.299975] device: 'ttya2': device_add
[   19.303308] PM: Adding info for No Bus:ttya2
[   19.306642] device: 'ttya3': device_add
[   19.309975] PM: Adding info for No Bus:ttya3
[   19.313308] device: 'ttya4': device_add
[   19.316642] PM: Adding info for No Bus:ttya4
[   19.319975] device: 'ttya5': device_add
[   19.323308] PM: Adding info for No Bus:ttya5
[   19.326642] device: 'ttya6': device_add
[   19.329975] PM: Adding info for No Bus:ttya6
[   19.333308] device: 'ttya7': device_add
[   19.336642] PM: Adding info for No Bus:ttya7
[   19.339975] device: 'ttya8': device_add
[   19.343308] PM: Adding info for No Bus:ttya8
[   19.346642] device: 'ttya9': device_add
[   19.349975] PM: Adding info for No Bus:ttya9
[   19.353308] device: 'ttyaa': device_add
[   19.356642] PM: Adding info for No Bus:ttyaa
[   19.359975] device: 'ttyab': device_add
[   19.363308] PM: Adding info for No Bus:ttyab
[   19.366642] device: 'ttyac': device_add
[   19.369975] PM: Adding info for No Bus:ttyac
[   19.373308] device: 'ttyad': device_add
[   19.376642] PM: Adding info for No Bus:ttyad
[   19.379975] device: 'ttyae': device_add
[   19.383308] PM: Adding info for No Bus:ttyae
[   19.386642] device: 'ttyaf': device_add
[   19.389975] PM: Adding info for No Bus:ttyaf
[   19.393308] device: 'ttyb0': device_add
[   19.396642] PM: Adding info for No Bus:ttyb0
[   19.399975] device: 'ttyb1': device_add
[   19.403308] PM: Adding info for No Bus:ttyb1
[   19.406642] device: 'ttyb2': device_add
[   19.409975] PM: Adding info for No Bus:ttyb2
[   19.413308] device: 'ttyb3': device_add
[   19.416642] PM: Adding info for No Bus:ttyb3
[   19.419975] device: 'ttyb4': device_add
[   19.423308] PM: Adding info for No Bus:ttyb4
[   19.429975] device: 'ttyb5': device_add
[   19.433308] PM: Adding info for No Bus:ttyb5
[   19.436642] device: 'ttyb6': device_add
[   19.439975] PM: Adding info for No Bus:ttyb6
[   19.443308] device: 'ttyb7': device_add
[   19.446642] PM: Adding info for No Bus:ttyb7
[   19.449975] device: 'ttyb8': device_add
[   19.456642] PM: Adding info for No Bus:ttyb8
[   19.459975] device: 'ttyb9': device_add
[   19.463308] PM: Adding info for No Bus:ttyb9
[   19.469975] device: 'ttyba': device_add
[   19.473308] PM: Adding info for No Bus:ttyba
[   19.476641] device: 'ttybb': device_add
[   19.479975] PM: Adding info for No Bus:ttybb
[   19.483308] device: 'ttybc': device_add
[   19.486641] PM: Adding info for No Bus:ttybc
[   19.489975] device: 'ttybd': device_add
[   19.493308] PM: Adding info for No Bus:ttybd
[   19.496641] device: 'ttybe': device_add
[   19.499975] PM: Adding info for No Bus:ttybe
[   19.506641] device: 'ttybf': device_add
[   19.509975] PM: Adding info for No Bus:ttybf
[   19.513308] device: 'ttyc0': device_add
[   19.516641] PM: Adding info for No Bus:ttyc0
[   19.519975] device: 'ttyc1': device_add
[   19.523308] PM: Adding info for No Bus:ttyc1
[   19.526641] device: 'ttyc2': device_add
[   19.529975] PM: Adding info for No Bus:ttyc2
[   19.533308] device: 'ttyc3': device_add
[   19.536641] PM: Adding info for No Bus:ttyc3
[   19.543308] device: 'ttyc4': device_add
[   19.546641] PM: Adding info for No Bus:ttyc4
[   19.549975] device: 'ttyc5': device_add
[   19.553308] PM: Adding info for No Bus:ttyc5
[   19.556641] device: 'ttyc6': device_add
[   19.559975] PM: Adding info for No Bus:ttyc6
[   19.563308] device: 'ttyc7': device_add
[   19.566641] PM: Adding info for No Bus:ttyc7
[   19.569975] device: 'ttyc8': device_add
[   19.573308] PM: Adding info for No Bus:ttyc8
[   19.579975] device: 'ttyc9': device_add
[   19.583308] PM: Adding info for No Bus:ttyc9
[   19.586641] device: 'ttyca': device_add
[   19.589975] PM: Adding info for No Bus:ttyca
[   19.593308] device: 'ttycb': device_add
[   19.596641] PM: Adding info for No Bus:ttycb
[   19.599975] device: 'ttycc': device_add
[   19.603308] PM: Adding info for No Bus:ttycc
[   19.606641] device: 'ttycd': device_add
[   19.609975] PM: Adding info for No Bus:ttycd
[   19.613308] device: 'ttyce': device_add
[   19.616641] PM: Adding info for No Bus:ttyce
[   19.619975] device: 'ttycf': device_add
[   19.623308] PM: Adding info for No Bus:ttycf
[   19.626641] device: 'ttyd0': device_add
[   19.629975] PM: Adding info for No Bus:ttyd0
[   19.633308] device: 'ttyd1': device_add
[   19.636641] PM: Adding info for No Bus:ttyd1
[   19.639975] device: 'ttyd2': device_add
[   19.643308] PM: Adding info for No Bus:ttyd2
[   19.646641] device: 'ttyd3': device_add
[   19.649975] PM: Adding info for No Bus:ttyd3
[   19.653308] device: 'ttyd4': device_add
[   19.656641] PM: Adding info for No Bus:ttyd4
[   19.659975] device: 'ttyd5': device_add
[   19.663308] PM: Adding info for No Bus:ttyd5
[   19.669975] device: 'ttyd6': device_add
[   19.673308] PM: Adding info for No Bus:ttyd6
[   19.676641] device: 'ttyd7': device_add
[   19.679975] PM: Adding info for No Bus:ttyd7
[   19.683308] device: 'ttyd8': device_add
[   19.686641] PM: Adding info for No Bus:ttyd8
[   19.689975] device: 'ttyd9': device_add
[   19.693308] PM: Adding info for No Bus:ttyd9
[   19.696641] device: 'ttyda': device_add
[   19.699975] PM: Adding info for No Bus:ttyda
[   19.703308] device: 'ttydb': device_add
[   19.706641] PM: Adding info for No Bus:ttydb
[   19.709975] device: 'ttydc': device_add
[   19.713308] PM: Adding info for No Bus:ttydc
[   19.716641] device: 'ttydd': device_add
[   19.719975] PM: Adding info for No Bus:ttydd
[   19.723308] device: 'ttyde': device_add
[   19.726641] PM: Adding info for No Bus:ttyde
[   19.729975] device: 'ttydf': device_add
[   19.733308] PM: Adding info for No Bus:ttydf
[   19.736641] device: 'ttye0': device_add
[   19.739975] PM: Adding info for No Bus:ttye0
[   19.743308] device: 'ttye1': device_add
[   19.746641] PM: Adding info for No Bus:ttye1
[   19.749975] device: 'ttye2': device_add
[   19.753308] PM: Adding info for No Bus:ttye2
[   19.756641] device: 'ttye3': device_add
[   19.759975] PM: Adding info for No Bus:ttye3
[   19.763308] device: 'ttye4': device_add
[   19.766641] PM: Adding info for No Bus:ttye4
[   19.769975] device: 'ttye5': device_add
[   19.773308] PM: Adding info for No Bus:ttye5
[   19.776641] device: 'ttye6': device_add
[   19.779975] PM: Adding info for No Bus:ttye6
[   19.783308] device: 'ttye7': device_add
[   19.786641] PM: Adding info for No Bus:ttye7
[   19.789975] device: 'ttye8': device_add
[   19.793308] PM: Adding info for No Bus:ttye8
[   19.796641] device: 'ttye9': device_add
[   19.799975] PM: Adding info for No Bus:ttye9
[   19.803308] device: 'ttyea': device_add
[   19.806641] PM: Adding info for No Bus:ttyea
[   19.809975] device: 'ttyeb': device_add
[   19.813308] PM: Adding info for No Bus:ttyeb
[   19.816641] device: 'ttyec': device_add
[   19.819975] PM: Adding info for No Bus:ttyec
[   19.823308] device: 'ttyed': device_add
[   19.826641] PM: Adding info for No Bus:ttyed
[   19.829975] device: 'ttyee': device_add
[   19.833308] PM: Adding info for No Bus:ttyee
[   19.836641] device: 'ttyef': device_add
[   19.839975] PM: Adding info for No Bus:ttyef
[   19.843308] device: 'ptmx': device_add
[   19.846641] PM: Adding info for No Bus:ptmx
[   19.849975] initcall pty_init+0x0/0x40 returned 0 after 3564450 usecs
[   19.853308] calling  sysrq_init+0x0/0x53 @ 1
[   19.856641] initcall sysrq_init+0x0/0x53 returned 0 after 0 usecs
[   19.859975] calling  lp_init_module+0x0/0xf7 @ 1
[   19.863308] device class 'printer': registering
[   19.866641] lp: driver loaded but no devices found
[   19.869975] initcall lp_init_module+0x0/0xf7 returned 0 after 6510 usecs
[   19.873308] calling  applicom_init+0x0/0x545 @ 1
[   19.876641] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   19.879975] ac.o: No PCI boards found.
[   19.883308] ac.o: For an ISA board you must supply memory and irq parameters.
[   19.886641] initcall applicom_init+0x0/0x545 returned -6 after 9765 usecs
[   19.889975] initcall applicom_init+0x0/0x545 returned with error code -6 
[   19.893308] calling  rtc_init+0x0/0x12e @ 1
[   19.896641] device: 'rtc': device_add
[   19.899975] PM: Adding info for No Bus:rtc
[   19.903308] Real Time Clock Driver v1.12b
[   19.906641] initcall rtc_init+0x0/0x12e returned 0 after 9765 usecs
[   19.909975] calling  nvram_init+0x0/0xad @ 1
[   19.913308] device: 'nvram': device_add
[   19.916641] PM: Adding info for No Bus:nvram
[   19.919975] Non-volatile memory driver v1.3
[   19.923308] initcall nvram_init+0x0/0xad returned 0 after 9765 usecs
[   19.926641] calling  agp_init+0x0/0x51 @ 1
[   19.929975] Linux agpgart interface v0.103
[   19.933308] initcall agp_init+0x0/0x51 returned 0 after 3255 usecs
[   19.936641] calling  agp_intel_init+0x0/0x60 @ 1
[   19.939975] bus: 'pci': add driver agpgart-intel
[   19.943308] initcall agp_intel_init+0x0/0x60 returned 0 after 3255 usecs
[   19.946641] calling  agp_sis_init+0x0/0x60 @ 1
[   19.949975] bus: 'pci': add driver agpgart-sis
[   19.953308] initcall agp_sis_init+0x0/0x60 returned 0 after 3255 usecs
[   19.956641] calling  ipmi_init_msghandler_mod+0x0/0x40 @ 1
[   19.959975] bus: 'platform': add driver ipmi
[   19.963308] ipmi message handler version 39.2
[   19.966641] initcall ipmi_init_msghandler_mod+0x0/0x40 returned 0 after 6510 usecs
[   19.973308] calling  ipmi_poweroff_init+0x0/0xc0 @ 1
[   19.976641] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   19.979975] initcall ipmi_poweroff_init+0x0/0xc0 returned 0 after 3255 usecs
[   19.983308] calling  drm_core_init+0x0/0x180 @ 1
[   19.986641] device class 'drm': registering
[   19.989974] [drm] Initialized drm 1.1.0 20060810
[   19.993308] initcall drm_core_init+0x0/0x180 returned 0 after 6510 usecs
[   19.996641] calling  radeon_init+0x0/0x50 @ 1
[   20.003308] device: 'card0': device_add
[   20.006641] PM: Adding info for No Bus:card0
[   20.009974] [drm] Initialized radeon 1.30.0 20080528 for 0000:01:00.0 on minor 0
[   20.019974] initcall radeon_init+0x0/0x50 returned 0 after 19531 usecs
[   20.023308] calling  mga_init+0x0/0x50 @ 1
[   20.026641] initcall mga_init+0x0/0x50 returned 0 after 0 usecs
[   20.029974] calling  sis_init+0x0/0x45 @ 1
[   20.033308] initcall sis_init+0x0/0x45 returned 0 after 0 usecs
[   20.036641] calling  cn_proc_init+0x0/0x65 @ 1
[   20.039974] initcall cn_proc_init+0x0/0x65 returned 0 after 0 usecs
[   20.043308] calling  intelfb_init+0x0/0x94 @ 1
[   20.046641] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[   20.049974] intelfb: Version 0.9.6
[   20.053308] bus: 'pci': add driver intelfb
[   20.056641] initcall intelfb_init+0x0/0x94 returned 0 after 9765 usecs
[   20.059974] calling  serial8250_init+0x0/0x15b @ 1
[   20.063308] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   20.066641] Registering platform device 'serial8250'. Parent at platform
[   20.069974] device: 'serial8250': device_add
[   20.073308] bus: 'platform': add device serial8250
[   20.076641] PM: Adding info for platform:serial8250
[   20.079974] async_waiting @ 1
[   20.083308] async_continuing @ 1 after 0 usec
[   20.213308] async_waiting @ 1
[   20.213308] async_continuing @ 1 after 0 usec
[   20.343308] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.346641] device: 'ttyS0': device_add
[   20.349974] PM: Adding info for No Bus:ttyS0
[   20.353308] async_waiting @ 1
[   20.356641] async_continuing @ 1 after 0 usec
[   20.486641] async_waiting @ 1
[   20.486641] async_continuing @ 1 after 0 usec
[   20.616641] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   20.619974] device: 'ttyS1': device_add
[   20.623307] PM: Adding info for No Bus:ttyS1
[   20.626641] device: 'ttyS2': device_add
[   20.629974] PM: Adding info for No Bus:ttyS2
[   20.636641] device: 'ttyS3': device_add
[   20.639974] PM: Adding info for No Bus:ttyS3
[   20.643307] bus: 'platform': add driver serial8250
[   20.646641] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   20.649974] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   20.653307] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   20.656641] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   20.663307] initcall serial8250_init+0x0/0x15b returned 0 after 585937 usecs
[   20.666641] calling  serial8250_pci_init+0x0/0x50 @ 1
[   20.669974] bus: 'pci': add driver serial
[   20.673307] initcall serial8250_pci_init+0x0/0x50 returned 0 after 3255 usecs
[   20.676641] calling  jsm_init_module+0x0/0x70 @ 1
[   20.679974] bus: 'pci': add driver jsm
[   20.686641] initcall jsm_init_module+0x0/0x70 returned 0 after 6510 usecs
[   20.689974] calling  parport_default_proc_register+0x0/0x47 @ 1
[   20.693307] initcall parport_default_proc_register+0x0/0x47 returned 0 after 0 usecs
[   20.696641] calling  topology_sysfs_init+0x0/0x144 @ 1
[   20.699974] initcall topology_sysfs_init+0x0/0x144 returned 0 after 0 usecs
[   20.703307] calling  cpqarray_init+0x0/0x9c @ 1
[   20.706641] Compaq SMART2 Driver (v 2.6.0)
[   20.709974] bus: 'pci': add driver cpqarray
[   20.713307] bus: 'pci': remove driver cpqarray
[   20.716641] driver: 'cpqarray': driver_release
[   20.719974] initcall cpqarray_init+0x0/0x9c returned -19 after 13020 usecs
[   20.723307] calling  DAC960_init_module+0x0/0x80 @ 1
[   20.726641] bus: 'pci': add driver DAC960
[   20.729974] device: 'dac960_gam': device_add
[   20.733307] PM: Adding info for No Bus:dac960_gam
[   20.736641] initcall DAC960_init_module+0x0/0x80 returned 0 after 9765 usecs
[   20.739974] calling  mm_init+0x0/0x200 @ 1
[   20.743307] bus: 'pci': add driver umem
[   20.746641] MM: desc_per_page = 128
[   20.749974] initcall mm_init+0x0/0x200 returned 0 after 6510 usecs
[   20.753307] calling  carm_init+0x0/0x45 @ 1
[   20.756641] bus: 'pci': add driver sx8
[   20.759974] initcall carm_init+0x0/0x45 returned 0 after 3255 usecs
[   20.763307] calling  phantom_init+0x0/0x160 @ 1
[   20.766641] device class 'phantom': registering
[   20.769974] bus: 'pci': add driver phantom
[   20.773307] Phantom Linux Driver, version n0.9.8, init OK
[   20.776641] initcall phantom_init+0x0/0x160 returned 0 after 9765 usecs
[   20.779974] calling  enclosure_init+0x0/0x50 @ 1
[   20.783307] device class 'enclosure': registering
[   20.786641] initcall enclosure_init+0x0/0x50 returned 0 after 3255 usecs
[   20.789974] calling  at25_init+0x0/0x40 @ 1
[   20.793307] bus: 'spi': add driver at25
[   20.796641] initcall at25_init+0x0/0x40 returned 0 after 3255 usecs
[   20.799974] calling  eeprom_init+0x0/0x40 @ 1
[   20.803307] bus: 'i2c': add driver eeprom
[   20.806641] i2c-core: driver [eeprom] registered
[   20.809974] initcall eeprom_init+0x0/0x40 returned 0 after 6510 usecs
[   20.813307] calling  sm501_base_init+0x0/0x55 @ 1
[   20.816641] bus: 'platform': add driver sm501
[   20.819974] bus: 'pci': add driver sm501
[   20.823307] initcall sm501_base_init+0x0/0x55 returned 0 after 6510 usecs
[   20.826641] calling  wm8400_module_init+0x0/0x5b @ 1
[   20.829974] bus: 'i2c': add driver WM8400
[   20.833307] i2c-core: driver [WM8400] registered
[   20.836641] initcall wm8400_module_init+0x0/0x5b returned 0 after 6510 usecs
[   20.839974] calling  da903x_init+0x0/0x40 @ 1
[   20.843307] bus: 'i2c': add driver da903x
[   20.846641] i2c-core: driver [da903x] registered
[   20.849974] initcall da903x_init+0x0/0x40 returned 0 after 6510 usecs
[   20.853307] calling  spi_transport_init+0x0/0x60 @ 1
[   20.856641] device class 'spi_transport': registering
[   20.859974] device class 'spi_host': registering
[   20.863307] initcall spi_transport_init+0x0/0x60 returned 0 after 6510 usecs
[   20.866641] calling  fc_transport_init+0x0/0x80 @ 1
[   20.869974] device class 'fc_host': registering
[   20.873307] device class 'fc_vports': registering
[   20.876641] device class 'fc_remote_ports': registering
[   20.879974] device class 'fc_transport': registering
[   20.883307] initcall fc_transport_init+0x0/0x80 returned 0 after 13020 usecs
[   20.886641] calling  advansys_init+0x0/0x45 @ 1
[   20.889974] bus: 'pci': add driver advansys
[   20.893307] initcall advansys_init+0x0/0x45 returned 0 after 3255 usecs
[   20.896641] calling  ahc_linux_init+0x0/0xb6 @ 1
[   20.899974] bus: 'pci': add driver aic7xxx
[   20.903307] initcall ahc_linux_init+0x0/0xb6 returned 0 after 3255 usecs
[   20.906641] calling  ahd_linux_init+0x0/0xc8 @ 1
[   20.909974] bus: 'pci': add driver aic79xx
[   20.913307] initcall ahd_linux_init+0x0/0xc8 returned 0 after 3255 usecs
[   20.916641] calling  init_this_scsi_driver+0x0/0x118 @ 1
[   20.919974] scsi: <fdomain> Detection failed (no card)
[   20.923307] initcall init_this_scsi_driver+0x0/0x118 returned -19 after 3255 usecs
[   20.926641] calling  lpfc_init+0x0/0x100 @ 1
[   20.929974] Emulex LightPulse Fibre Channel SCSI driver 8.3.1
[   20.933307] Copyright(c) 2004-2009 Emulex.  All rights reserved.
[   20.936641] bus: 'pci': add driver lpfc
[   20.939974] initcall lpfc_init+0x0/0x100 returned 0 after 9765 usecs
[   20.943307] calling  sym2_init+0x0/0x135 @ 1
[   20.946641] bus: 'pci': add driver sym53c8xx
[   20.949974] initcall sym2_init+0x0/0x135 returned 0 after 3255 usecs
[   20.953307] calling  atp870u_init+0x0/0x50 @ 1
[   20.956641] bus: 'pci': add driver atp870u
[   20.959974] initcall atp870u_init+0x0/0x50 returned 0 after 3255 usecs
[   20.963307] calling  initio_init_driver+0x0/0x50 @ 1
[   20.966641] bus: 'pci': add driver initio
[   20.973307] initcall initio_init_driver+0x0/0x50 returned 0 after 6510 usecs
[   20.976641] calling  hptiop_module_init+0x0/0x70 @ 1
[   20.979974] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[   20.983307] bus: 'pci': add driver hptiop
[   20.986641] initcall hptiop_module_init+0x0/0x70 returned 0 after 6510 usecs
[   20.989974] calling  init_st+0x0/0x148 @ 1
[   20.993307] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[   20.996641] device class 'scsi_tape': registering
[   20.999974] Driver 'st' needs updating - please use bus_type methods
[   21.003307] bus: 'scsi': add driver st
[   21.006641] initcall init_st+0x0/0x148 returned 0 after 13020 usecs
[   21.009974] calling  init_osst+0x0/0x17b @ 1
[   21.013307] osst :I: Tape driver with OnStream support version 0.99.4
[   21.013307] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   21.016641] device class 'onstream_tape': registering
[   21.019974] Driver 'osst' needs updating - please use bus_type methods
[   21.023307] bus: 'scsi': add driver osst
[   21.029974] initcall init_osst+0x0/0x17b returned 0 after 16276 usecs
[   21.033307] calling  init_sd+0x0/0x16a @ 1
[   21.036641] device class 'scsi_disk': registering
[   21.039974] Driver 'sd' needs updating - please use bus_type methods
[   21.043307] bus: 'scsi': add driver sd
[   21.046641] initcall init_sd+0x0/0x16a returned 0 after 9765 usecs
[   21.049974] calling  init_sr+0x0/0x76 @ 1
[   21.053307] Driver 'sr' needs updating - please use bus_type methods
[   21.056641] bus: 'scsi': add driver sr
[   21.059974] initcall init_sr+0x0/0x76 returned 0 after 6510 usecs
[   21.063307] calling  init_sg+0x0/0x1a0 @ 1
[   21.066641] device class 'scsi_generic': registering
[   21.073307] initcall init_sg+0x0/0x1a0 returned 0 after 6510 usecs
[   21.076641] calling  init_ch_module+0x0/0xf1 @ 1
[   21.079974] SCSI Media Changer driver v0.25 
[   21.083307] device class 'scsi_changer': registering
[   21.086641] Driver 'ch' needs updating - please use bus_type methods
[   21.089974] bus: 'scsi': add driver ch
[   21.093307] initcall init_ch_module+0x0/0xf1 returned 0 after 13020 usecs
[   21.096641] calling  ses_init+0x0/0x6f @ 1
[   21.099974] Driver 'ses' needs updating - please use bus_type methods
[   21.103307] bus: 'scsi': add driver ses
[   21.106641] initcall ses_init+0x0/0x6f returned 0 after 6510 usecs
[   21.109974] calling  ahci_init+0x0/0x50 @ 1
[   21.113307] bus: 'pci': add driver ahci
[   21.116641] initcall ahci_init+0x0/0x50 returned 0 after 3255 usecs
[   21.119974] calling  k2_sata_init+0x0/0x50 @ 1
[   21.123307] bus: 'pci': add driver sata_svw
[   21.129974] initcall k2_sata_init+0x0/0x50 returned 0 after 6510 usecs
[   21.133307] calling  piix_init+0x0/0x60 @ 1
[   21.136640] bus: 'pci': add driver ata_piix
[   21.139974] initcall piix_init+0x0/0x60 returned 0 after 3255 usecs
[   21.143307] calling  qs_ata_init+0x0/0x50 @ 1
[   21.149974] bus: 'pci': add driver sata_qstor
[   21.153307] initcall qs_ata_init+0x0/0x50 returned 0 after 3255 usecs
[   21.156640] calling  svia_init+0x0/0x50 @ 1
[   21.159974] bus: 'pci': add driver sata_via
[   21.163307] bus: 'pci': driver_probe_device: matched device 0000:00:0f.0 with driver sata_via
[   21.166640] bus: 'pci': really_probe: probing driver sata_via with device 0000:00:0f.0
[   21.169974] sata_via 0000:00:0f.0: version 2.4
[   21.173307] PCI: setting IRQ 10 as level-triggered
[   21.176640] sata_via 0000:00:0f.0: found PCI INT B -> IRQ 10
[   21.179974] sata_via 0000:00:0f.0: sharing IRQ 10 with 0000:00:0a.0
[   21.183307] sata_via 0000:00:0f.0: sharing IRQ 10 with 0000:00:10.2
[   21.186640] sata_via 0000:00:0f.0: sharing IRQ 10 with 0000:00:10.3
[   21.189974] sata_via 0000:00:0f.0: routed to hard irq line 10
[   21.193307] scsi0 : sata_via
[   21.196640] device: 'host0': device_add
[   21.199974] PM: Adding info for No Bus:host0
[   21.203307] device: 'host0': device_add
[   21.206640] PM: Adding info for No Bus:host0
[   21.209974] scsi1 : sata_via
[   21.213307] device: 'host1': device_add
[   21.216640] PM: Adding info for No Bus:host1
[   21.219974] device: 'host1': device_add
[   21.223307] PM: Adding info for No Bus:host1
[   21.226640] ata1: SATA max UDMA/133 cmd 0xe800 ctl 0xe400 bmdma 0xd400 irq 10
[   21.229974] ata2: SATA max UDMA/133 cmd 0xe000 ctl 0xd800 bmdma 0xd408 irq 10
[   21.436640] ata1: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[   21.443307] async_waiting @ 1
[   21.443307] async_continuing @ 1 after 0 usec
[   21.446640] async_waiting @ 1
[   21.449974] async_continuing @ 1 after 0 usec
[   21.656640] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[   21.663307] async_waiting @ 1
[   21.663307] async_continuing @ 1 after 0 usec
[   21.666640] driver: '0000:00:0f.0': driver_bound: bound to device 'sata_via'
[   21.669974] bus: 'pci': really_probe: bound device 0000:00:0f.0 to driver sata_via
[   21.673307] initcall svia_init+0x0/0x50 returned 0 after 501301 usecs
[   21.676640] calling  vsc_sata_init+0x0/0x50 @ 1
[   21.679974] bus: 'pci': add driver sata_vsc
[   21.683307] initcall vsc_sata_init+0x0/0x50 returned 0 after 3255 usecs
[   21.686640] calling  sis_init+0x0/0x50 @ 1
[   21.689974] bus: 'pci': add driver sata_sis
[   21.693307] initcall sis_init+0x0/0x50 returned 0 after 3255 usecs
[   21.696640] calling  pdc_sata_init+0x0/0x50 @ 1
[   21.699974] bus: 'pci': add driver sata_sx4
[   21.703307] initcall pdc_sata_init+0x0/0x50 returned 0 after 3255 usecs
[   21.706640] calling  nv_init+0x0/0x45 @ 1
[   21.709974] bus: 'pci': add driver sata_nv
[   21.713307] initcall nv_init+0x0/0x45 returned 0 after 3255 usecs
[   21.716640] calling  ali_init+0x0/0x7b @ 1
[   21.719974] bus: 'pci': add driver pata_ali
[   21.726640] initcall ali_init+0x0/0x7b returned 0 after 6510 usecs
[   21.729974] calling  amd_init+0x0/0x50 @ 1
[   21.733307] bus: 'pci': add driver pata_amd
[   21.736640] initcall amd_init+0x0/0x50 returned 0 after 3255 usecs
[   21.739974] calling  cs5520_init+0x0/0x50 @ 1
[   21.743307] bus: 'pci': add driver pata_cs5520
[   21.746640] initcall cs5520_init+0x0/0x50 returned 0 after 3255 usecs
[   21.749974] calling  hpt36x_init+0x0/0x50 @ 1
[   21.753307] bus: 'pci': add driver pata_hpt366
[   21.756640] initcall hpt36x_init+0x0/0x50 returned 0 after 3255 usecs
[   21.759974] calling  hpt37x_init+0x0/0x50 @ 1
[   21.763307] bus: 'pci': add driver pata_hpt37x
[   21.766640] initcall hpt37x_init+0x0/0x50 returned 0 after 3255 usecs
[   21.769974] calling  ns87410_init+0x0/0x50 @ 1
[   21.773307] bus: 'pci': add driver pata_ns87410
[   21.776640] initcall ns87410_init+0x0/0x50 returned 0 after 3255 usecs
[   21.779973] calling  optidma_init+0x0/0x50 @ 1
[   21.783307] bus: 'pci': add driver pata_optidma
[   21.786640] initcall optidma_init+0x0/0x50 returned 0 after 3255 usecs
[   21.789973] calling  marvell_init+0x0/0x50 @ 1
[   21.793307] bus: 'pci': add driver pata_marvell
[   21.796640] initcall marvell_init+0x0/0x50 returned 0 after 3255 usecs
[   21.799973] calling  oldpiix_init+0x0/0x50 @ 1
[   21.803307] bus: 'pci': add driver pata_oldpiix
[   21.806640] initcall oldpiix_init+0x0/0x50 returned 0 after 3255 usecs
[   21.809973] calling  sil680_init+0x0/0x50 @ 1
[   21.813307] bus: 'pci': add driver pata_sil680
[   21.819973] initcall sil680_init+0x0/0x50 returned 0 after 6510 usecs
[   21.823307] calling  via_init+0x0/0x50 @ 1
[   21.826640] bus: 'pci': add driver pata_via
[   21.829973] bus: 'pci': driver_probe_device: matched device 0000:00:0f.1 with driver pata_via
[   21.833307] bus: 'pci': really_probe: probing driver pata_via with device 0000:00:0f.1
[   21.836640] pata_via 0000:00:0f.1: version 0.3.4
[   21.839973] pata_via 0000:00:0f.1: found PCI INT A -> IRQ 11
[   21.843307] pata_via 0000:00:0f.1: sharing IRQ 11 with 0000:00:07.0
[   21.846640] pata_via 0000:00:0f.1: sharing IRQ 11 with 0000:00:10.0
[   21.849973] pata_via 0000:00:0f.1: sharing IRQ 11 with 0000:00:10.1
[   21.853307] pata_via 0000:00:0f.1: VIA VLink IRQ fixup, from 255 to 11
[   21.856640] scsi2 : pata_via
[   21.859973] device: 'host2': device_add
[   21.863307] PM: Adding info for No Bus:host2
[   21.866640] device: 'host2': device_add
[   21.869973] PM: Adding info for No Bus:host2
[   21.873307] scsi3 : pata_via
[   21.876640] device: 'host3': device_add
[   21.879973] PM: Adding info for No Bus:host3
[   21.883307] device: 'host3': device_add
[   21.886640] PM: Adding info for No Bus:host3
[   21.889973] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[   21.893307] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[   22.056640] async_waiting @ 1
[   22.059973] async_continuing @ 1 after 0 usec
[   22.063307] async_waiting @ 1
[   22.066640] async_continuing @ 1 after 0 usec
[   22.239973] ata4.01: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[   22.243307] ata4.01: 488397168 sectors, multi 16: LBA48 
[   22.266640] ata4.01: configured for UDMA/100
[   22.269973] async_waiting @ 1
[   22.273307] async_continuing @ 1 after 0 usec
[   22.276640] scsi 3:0:1:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[   22.279973] device: 'target3:0:1': device_add
[   22.283307] PM: Adding info for No Bus:target3:0:1
[   22.286640] device: '3:0:1:0': device_add
[   22.289973] bus: 'scsi': add device 3:0:1:0
[   22.293307] PM: Adding info for scsi:3:0:1:0
[   22.296640] bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver st
[   22.299973] bus: 'scsi': really_probe: probing driver st with device 3:0:1:0
[   22.303307] bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver osst
[   22.306640] bus: 'scsi': really_probe: probing driver osst with device 3:0:1:0
[   22.309973] bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver sd
[   22.313307] bus: 'scsi': really_probe: probing driver sd with device 3:0:1:0
[   22.316640] device: '3:0:1:0': device_add
[   22.319973] PM: Adding info for No Bus:3:0:1:0
[   22.323307] sd 3:0:1:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[   22.326640] sd 3:0:1:0: [sda] Write Protect is off
[   22.329973] sd 3:0:1:0: [sda] Mode Sense: 00 3a 00 00
[   22.333307] sd 3:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.336640] device: 'sda': device_add
[   22.339973] PM: Adding info for No Bus:sda
[   22.343307]  sda: sda1 sda2
[   22.373307] device: 'sda1': device_add
[   22.376640] PM: Adding info for No Bus:sda1
[   22.379973] device: 'sda2': device_add
[   22.383307] PM: Adding info for No Bus:sda2
[   22.386640] device: '8:0': device_add
[   22.389973] PM: Adding info for No Bus:8:0
[   22.393307] sd 3:0:1:0: [sda] Attached SCSI disk
[   22.396640] driver: '3:0:1:0': driver_bound: bound to device 'sd'
[   22.399973] bus: 'scsi': really_probe: bound device 3:0:1:0 to driver sd
[   22.403307] device: '3:0:1:0': device_add
[   22.406640] PM: Adding info for No Bus:3:0:1:0
[   22.409973] device: 'sg0': device_add
[   22.413307] PM: Adding info for No Bus:sg0
[   22.416640] sd 3:0:1:0: Attached scsi generic sg0 type 0
[   22.419973] driver: '0000:00:0f.1': driver_bound: bound to device 'pata_via'
[   22.423307] bus: 'pci': really_probe: bound device 0000:00:0f.1 to driver pata_via
[   22.426640] initcall via_init+0x0/0x50 returned 0 after 585937 usecs
[   22.429973] calling  sis_init+0x0/0x50 @ 1
[   22.433307] bus: 'pci': add driver pata_sis
[   22.436640] initcall sis_init+0x0/0x50 returned 0 after 3255 usecs
[   22.439973] calling  triflex_init+0x0/0x50 @ 1
[   22.443307] bus: 'pci': add driver pata_triflex
[   22.446640] initcall triflex_init+0x0/0x50 returned 0 after 3255 usecs
[   22.449973] calling  pata_platform_init+0x0/0x40 @ 1
[   22.453307] bus: 'platform': add driver pata_platform
[   22.456640] initcall pata_platform_init+0x0/0x40 returned 0 after 3255 usecs
[   22.459973] calling  e1000_init_module+0x0/0xab @ 1
[   22.463307] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[   22.466640] Copyright (c) 1999-2006 Intel Corporation.
[   22.469973] bus: 'pci': add driver e1000
[   22.476640] initcall e1000_init_module+0x0/0xab returned 0 after 13020 usecs
[   22.479973] calling  e1000_init_module+0x0/0x91 @ 1
[   22.483306] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[   22.486640] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   22.489973] bus: 'pci': add driver e1000e
[   22.493306] initcall e1000_init_module+0x0/0x91 returned 0 after 9765 usecs
[   22.496640] calling  igbvf_init_module+0x0/0x94 @ 1
[   22.499973] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[   22.503306] Copyright (c) 2009 Intel Corporation.
[   22.506640] bus: 'pci': add driver igbvf
[   22.513306] initcall igbvf_init_module+0x0/0x94 returned 0 after 13020 usecs
[   22.516640] calling  atl1_init_module+0x0/0x50 @ 1
[   22.519973] bus: 'pci': add driver atl1
[   22.523306] initcall atl1_init_module+0x0/0x50 returned 0 after 3255 usecs
[   22.526640] calling  atl1c_init_module+0x0/0x50 @ 1
[   22.529973] bus: 'pci': add driver atl1c
[   22.533306] initcall atl1c_init_module+0x0/0x50 returned 0 after 3255 usecs
[   22.536640] calling  happy_meal_probe+0x0/0x50 @ 1
[   22.539973] bus: 'pci': add driver hme
[   22.543306] initcall happy_meal_probe+0x0/0x50 returned 0 after 3255 usecs
[   22.546640] calling  gem_init+0x0/0x45 @ 1
[   22.549973] bus: 'pci': add driver gem
[   22.553306] initcall gem_init+0x0/0x45 returned 0 after 3255 usecs
[   22.556640] calling  vortex_init+0x0/0xe6 @ 1
[   22.559973] bus: 'pci': add driver 3c59x
[   22.563306] initcall vortex_init+0x0/0xe6 returned 0 after 3255 usecs
[   22.566640] calling  pcnet32_init_module+0x0/0x160 @ 1
[   22.569973] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   22.573306] bus: 'pci': add driver pcnet32
[   22.576640] initcall pcnet32_init_module+0x0/0x160 returned 0 after 6510 usecs
[   22.579973] calling  e100_init_module+0x0/0x85 @ 1
[   22.583306] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   22.586640] e100: Copyright(c) 1999-2006 Intel Corporation
[   22.589973] bus: 'pci': add driver e100
[   22.596640] initcall e100_init_module+0x0/0x85 returned 0 after 13020 usecs
[   22.599973] calling  epic_init+0x0/0x50 @ 1
[   22.603306] bus: 'pci': add driver epic100
[   22.606640] initcall epic_init+0x0/0x50 returned 0 after 3255 usecs
[   22.609973] calling  smsc9420_init_module+0x0/0x70 @ 1
[   22.613306] bus: 'pci': add driver smsc9420
[   22.616640] initcall smsc9420_init_module+0x0/0x70 returned 0 after 3255 usecs
[   22.619973] calling  sis190_init_module+0x0/0x50 @ 1
[   22.623306] bus: 'pci': add driver sis190
[   22.626640] initcall sis190_init_module+0x0/0x50 returned 0 after 3255 usecs
[   22.629973] calling  natsemi_init_mod+0x0/0x50 @ 1
[   22.633306] bus: 'pci': add driver natsemi
[   22.636640] initcall natsemi_init_mod+0x0/0x50 returned 0 after 3255 usecs
[   22.639973] calling  tg3_init+0x0/0x50 @ 1
[   22.643306] bus: 'pci': add driver tg3
[   22.646640] initcall tg3_init+0x0/0x50 returned 0 after 3255 usecs
[   22.649973] calling  bnx2_init+0x0/0x50 @ 1
[   22.653306] bus: 'pci': add driver bnx2
[   22.656640] initcall bnx2_init+0x0/0x50 returned 0 after 3255 usecs
[   22.659973] calling  skge_init_module+0x0/0x50 @ 1
[   22.663306] bus: 'pci': add driver skge
[   22.666640] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver skge
[   22.669973] bus: 'pci': really_probe: probing driver skge with device 0000:00:0a.0
[   22.673306] skge 0000:00:0a.0: found PCI INT A -> IRQ 10
[   22.676640] skge 0000:00:0a.0: sharing IRQ 10 with 0000:00:0f.0
[   22.679973] skge 0000:00:0a.0: sharing IRQ 10 with 0000:00:10.2
[   22.683306] skge 0000:00:0a.0: sharing IRQ 10 with 0000:00:10.3
[   22.686640] skge 0000:00:0a.0: PCI: Disallowing DAC for device
[   22.689973] skge 1.13 addr 0xfd900000 irq 10 chip Yukon rev 1
[   22.693306] device: 'eth0': device_add
[   22.696640] PM: Adding info for No Bus:eth0
[   22.699973] skge eth0: addr 00:0c:6e:b3:3d:c6
[   22.703306] driver: '0000:00:0a.0': driver_bound: bound to device 'skge'
[   22.706640] bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver skge
[   22.709973] initcall skge_init_module+0x0/0x50 returned 0 after 45572 usecs
[   22.713306] calling  sky2_init_module+0x0/0x60 @ 1
[   22.716640] sky2 driver version 1.22
[   22.719973] bus: 'pci': add driver sky2
[   22.723306] initcall sky2_init_module+0x0/0x60 returned 0 after 6510 usecs
[   22.726640] calling  starfire_init+0x0/0x50 @ 1
[   22.729973] bus: 'pci': add driver starfire
[   22.733306] initcall starfire_init+0x0/0x50 returned 0 after 3255 usecs
[   22.736640] calling  smsc_init+0x0/0xc8 @ 1
[   22.739973] bus: 'mdio_bus': add driver SMSC LAN83C185
[   22.743306] bus: 'mdio_bus': add driver SMSC LAN8187
[   22.746640] bus: 'mdio_bus': add driver SMSC LAN8700
[   22.749973] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[   22.753306] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[   22.756640] initcall smsc_init+0x0/0xc8 returned 0 after 16276 usecs
[   22.759973] calling  fixed_mdio_bus_init+0x0/0x125 @ 1
[   22.763306] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   22.766640] device: 'Fixed MDIO bus.0': device_add
[   22.769973] bus: 'platform': add device Fixed MDIO bus.0
[   22.773306] PM: Adding info for platform:Fixed MDIO bus.0
[   22.776640] device: '0': device_add
[   22.779973] PM: Adding info for No Bus:0
[   22.783306] Fixed MDIO Bus: probed
[   22.786640] initcall fixed_mdio_bus_init+0x0/0x125 returned 0 after 22786 usecs
[   22.789973] calling  sundance_init+0x0/0x50 @ 1
[   22.793306] bus: 'pci': add driver sundance
[   22.796640] initcall sundance_init+0x0/0x50 returned 0 after 3255 usecs
[   22.799973] calling  net_olddevs_init+0x0/0x66 @ 1
[   22.803306] initcall net_olddevs_init+0x0/0x66 returned 0 after 0 usecs
[   22.806640] calling  init_nic+0x0/0x45 @ 1
[   22.809973] bus: 'pci': add driver forcedeth
[   22.813306] initcall init_nic+0x0/0x45 returned 0 after 3255 usecs
[   22.816640] calling  de600_init+0x0/0x69 @ 1
[   22.819973] eth%d: D-Link DE-600 pocket adapter: not at I/O 0x378.
[   22.823306] initcall de600_init+0x0/0x69 returned -19 after 3255 usecs
[   22.826640] calling  cp_init+0x0/0x50 @ 1
[   22.829973] bus: 'pci': add driver 8139cp
[   22.833306] initcall cp_init+0x0/0x50 returned 0 after 3255 usecs
[   22.836640] calling  rtl8139_init_module+0x0/0x45 @ 1
[   22.839973] bus: 'pci': add driver 8139too
[   22.843306] initcall rtl8139_init_module+0x0/0x45 returned 0 after 3255 usecs
[   22.846640] calling  tun_init+0x0/0xbb @ 1
[   22.849973] tun: Universal TUN/TAP device driver, 1.6
[   22.853306] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   22.856640] device: 'tun': device_add
[   22.859973] PM: Adding info for No Bus:tun
[   22.863306] initcall tun_init+0x0/0xbb returned 0 after 13020 usecs
[   22.866640] calling  rio_init+0x0/0x50 @ 1
[   22.869973] bus: 'pci': add driver dl2k
[   22.873306] initcall rio_init+0x0/0x50 returned 0 after 3255 usecs
[   22.876640] calling  enc28j60_init+0x0/0x50 @ 1
[   22.879973] bus: 'spi': add driver enc28j60
[   22.883306] initcall enc28j60_init+0x0/0x50 returned 0 after 3255 usecs
[   22.886640] calling  dnet_init+0x0/0x40 @ 1
[   22.889973] bus: 'platform': add driver dnet
[   22.893306] initcall dnet_init+0x0/0x40 returned 0 after 3255 usecs
[   22.896640] calling  hdlc_module_init+0x0/0x70 @ 1
[   22.899973] HDLC support module revision 1.22
[   22.903306] initcall hdlc_module_init+0x0/0x70 returned 0 after 3255 usecs
[   22.906640] calling  mod_init+0x0/0x40 @ 1
[   22.909973] initcall mod_init+0x0/0x40 returned 0 after 0 usecs
[   22.913306] calling  init_lmc+0x0/0x50 @ 1
[   22.916640] bus: 'pci': add driver lmc
[   22.919973] initcall init_lmc+0x0/0x50 returned 0 after 3255 usecs
[   22.923306] calling  catc_init+0x0/0x60 @ 1
[   22.926640] bus: 'usb': add driver catc
[   22.929973] usbcore: registered new interface driver catc
[   22.933306] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   22.936640] initcall catc_init+0x0/0x60 returned 0 after 9765 usecs
[   22.939973] calling  kaweth_init+0x0/0x50 @ 1
[   22.943306] bus: 'usb': add driver kaweth
[   22.946640] usbcore: registered new interface driver kaweth
[   22.949973] initcall kaweth_init+0x0/0x50 returned 0 after 6510 usecs
[   22.953306] calling  asix_init+0x0/0x50 @ 1
[   22.956640] bus: 'usb': add driver asix
[   22.959973] usbcore: registered new interface driver asix
[   22.963306] initcall asix_init+0x0/0x50 returned 0 after 6510 usecs
[   22.966640] calling  cdc_init+0x0/0x50 @ 1
[   22.969973] bus: 'usb': add driver cdc_ether
[   22.973306] usbcore: registered new interface driver cdc_ether
[   22.976640] initcall cdc_init+0x0/0x50 returned 0 after 6510 usecs
[   22.979973] calling  dm9601_init+0x0/0x50 @ 1
[   22.983306] bus: 'usb': add driver dm9601
[   22.986640] usbcore: registered new interface driver dm9601
[   22.989973] initcall dm9601_init+0x0/0x50 returned 0 after 6510 usecs
[   22.993306] calling  rndis_init+0x0/0x50 @ 1
[   22.996640] bus: 'usb': add driver rndis_host
[   23.003306] usbcore: registered new interface driver rndis_host
[   23.006640] initcall rndis_init+0x0/0x50 returned 0 after 9765 usecs
[   23.009973] calling  cdc_subset_init+0x0/0x50 @ 1
[   23.013306] bus: 'usb': add driver cdc_subset
[   23.016640] usbcore: registered new interface driver cdc_subset
[   23.019973] initcall cdc_subset_init+0x0/0x50 returned 0 after 6510 usecs
[   23.023306] calling  mcs7830_init+0x0/0x45 @ 1
[   23.026640] bus: 'usb': add driver MOSCHIP usb-ethernet driver
[   23.029973] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   23.033306] initcall mcs7830_init+0x0/0x45 returned 0 after 6510 usecs
[   23.036640] calling  usbnet_init+0x0/0x5b @ 1
[   23.039973] initcall usbnet_init+0x0/0x5b returned 0 after 0 usecs
[   23.043306] calling  ipw2100_init+0x0/0x95 @ 1
[   23.046640] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   23.049973] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   23.053306] bus: 'pci': add driver ipw2100
[   23.056640] initcall ipw2100_init+0x0/0x95 returned 0 after 9765 usecs
[   23.059973] calling  ieee80211_init+0x0/0xeb @ 1
[   23.063306] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   23.066640] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   23.069973] initcall ieee80211_init+0x0/0xeb returned 0 after 6510 usecs
[   23.073306] calling  rndis_wlan_init+0x0/0x50 @ 1
[   23.076640] bus: 'usb': add driver rndis_wlan
[   23.079973] usbcore: registered new interface driver rndis_wlan
[   23.083306] initcall rndis_wlan_init+0x0/0x50 returned 0 after 6510 usecs
[   23.086640] calling  zd1201_init+0x0/0x50 @ 1
[   23.089973] bus: 'usb': add driver zd1201
[   23.093306] usbcore: registered new interface driver zd1201
[   23.096640] initcall zd1201_init+0x0/0x50 returned 0 after 6510 usecs
[   23.099973] calling  w840_init+0x0/0x60 @ 1
[   23.103306] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   23.103306]   http://www.scyld.com/network/drivers.html
[   23.106640] bus: 'pci': add driver winbond-840
[   23.109973] initcall w840_init+0x0/0x60 returned 0 after 6510 usecs
[   23.113306] calling  init_netconsole+0x0/0x1a3 @ 1
[   23.116640] console [netcon0] enabled
[   23.119973] netconsole: network logging started
[   23.123306] initcall init_netconsole+0x0/0x1a3 returned 0 after 6510 usecs
[   23.126640] calling  zatm_init_module+0x0/0x45 @ 1
[   23.129973] bus: 'pci': add driver zatm
[   23.133306] initcall zatm_init_module+0x0/0x45 returned 0 after 3255 usecs
[   23.136640] calling  uPD98402_module_init+0x0/0x3b @ 1
[   23.139973] initcall uPD98402_module_init+0x0/0x3b returned 0 after 0 usecs
[   23.143306] calling  eni_init+0x0/0x50 @ 1
[   23.146640] bus: 'pci': add driver eni
[   23.149973] initcall eni_init+0x0/0x50 returned 0 after 3255 usecs
[   23.153306] calling  idt77252_init+0x0/0x70 @ 1
[   23.156640] idt77252_init: at ffffffff8163da80
[   23.159973] bus: 'pci': add driver idt77252
[   23.163306] initcall idt77252_init+0x0/0x70 returned 0 after 6510 usecs
[   23.166640] calling  solos_pci_init+0x0/0x60 @ 1
[   23.169973] Solos PCI Driver Version 0.07
[   23.173306] bus: 'pci': add driver solos
[   23.176640] initcall solos_pci_init+0x0/0x60 returned 0 after 6510 usecs
[   23.179973] calling  firestream_init_module+0x0/0x50 @ 1
[   23.183306] bus: 'pci': add driver firestream
[   23.186640] initcall firestream_init_module+0x0/0x50 returned 0 after 3255 usecs
[   23.189973] calling  he_init+0x0/0x50 @ 1
[   23.193306] bus: 'pci': add driver he
[   23.196640] initcall he_init+0x0/0x50 returned 0 after 3255 usecs
[   23.199973] calling  fw_core_init+0x0/0xb0 @ 1
[   23.203306] bus: 'firewire': registered
[   23.206640] initcall fw_core_init+0x0/0xb0 returned 0 after 3255 usecs
[   23.209973] calling  sbp2_init+0x0/0x6d @ 1
[   23.213306] bus: 'firewire': add driver sbp2
[   23.216640] initcall sbp2_init+0x0/0x6d returned 0 after 3255 usecs
[   23.219973] calling  cdrom_init+0x0/0x9e @ 1
[   23.223306] initcall cdrom_init+0x0/0x9e returned 0 after 0 usecs
[   23.226640] calling  butterfly_init+0x0/0x40 @ 1
[   23.229973] initcall butterfly_init+0x0/0x40 returned 0 after 0 usecs
[   23.233306] calling  spi_gpio_init+0x0/0x45 @ 1
[   23.236640] bus: 'platform': add driver spi_gpio
[   23.239973] bus: 'platform': remove driver spi_gpio
[   23.243306] driver: 'spi_gpio': driver_release
[   23.246640] initcall spi_gpio_init+0x0/0x45 returned -19 after 9765 usecs
[   23.249973] calling  aoe_init+0x0/0xf0 @ 1
[   23.253306] device class 'aoe': registering
[   23.256639] device: 'err': device_add
[   23.259973] PM: Adding info for No Bus:err
[   23.263306] device: 'discover': device_add
[   23.266639] PM: Adding info for No Bus:discover
[   23.269973] device: 'interfaces': device_add
[   23.273306] PM: Adding info for No Bus:interfaces
[   23.279973] device: 'revalidate': device_add
[   23.283306] PM: Adding info for No Bus:revalidate
[   23.286639] device: 'flush': device_add
[   23.289973] PM: Adding info for No Bus:flush
[   23.293306] aoe: AoE v47 initialised.
[   23.296639] initcall aoe_init+0x0/0xf0 returned 0 after 42317 usecs
[   23.299973] calling  uwb_subsys_init+0x0/0x7a @ 1
[   23.303306] device class 'uwb_rc': registering
[   23.306639] initcall uwb_subsys_init+0x0/0x7a returned 0 after 3255 usecs
[   23.309973] calling  wlp_subsys_init+0x0/0x36 @ 1
[   23.313306] initcall wlp_subsys_init+0x0/0x36 returned 0 after 0 usecs
[   23.316639] calling  umc_bus_init+0x0/0x40 @ 1
[   23.319973] bus: 'umc': registered
[   23.323306] initcall umc_bus_init+0x0/0x40 returned 0 after 3255 usecs
[   23.326639] calling  whci_init+0x0/0x50 @ 1
[   23.329973] bus: 'pci': add driver whci
[   23.333306] initcall whci_init+0x0/0x50 returned 0 after 3255 usecs
[   23.336639] calling  whcrc_driver_init+0x0/0x50 @ 1
[   23.339973] bus: 'umc': add driver whc-rc
[   23.343306] initcall whcrc_driver_init+0x0/0x50 returned 0 after 3255 usecs
[   23.346639] calling  mon_init+0x0/0x14d @ 1
[   23.349973] device class 'usbmon': registering
[   23.353306] device: 'usbmon0': device_add
[   23.356639] PM: Adding info for No Bus:usbmon0
[   23.359973] initcall mon_init+0x0/0x14d returned 0 after 9765 usecs
[   23.363306] calling  ehci_hcd_init+0x0/0x140 @ 1
[   23.366639] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   23.369973] bus: 'pci': add driver ehci_hcd
[   23.373306] bus: 'pci': driver_probe_device: matched device 0000:00:10.4 with driver ehci_hcd
[   23.376639] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:10.4
[   23.379973] ehci_hcd 0000:00:10.4: found PCI INT C -> IRQ 5
[   23.383306] ehci_hcd 0000:00:10.4: sharing IRQ 5 with 0000:00:0d.0
[   23.386639] ehci_hcd 0000:00:10.4: sharing IRQ 5 with 0000:00:0d.1
[   23.389973] ehci_hcd 0000:00:10.4: sharing IRQ 5 with 0000:00:11.5
[   23.393306] ehci_hcd 0000:00:10.4: sharing IRQ 5 with 0000:00:11.6
[   23.396639] ehci_hcd 0000:00:10.4: EHCI Host Controller
[   23.403306] device: 'usb_host1': device_add
[   23.406639] PM: Adding info for No Bus:usb_host1
[   23.409973] device: 'usbmon1': device_add
[   23.413306] PM: Adding info for No Bus:usbmon1
[   23.416639] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[   23.423306] ehci_hcd 0000:00:10.4: irq 5, io mem 0xfdf00000
[   23.436639] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
[   23.439973] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   23.443306] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.446639] usb usb1: Product: EHCI Host Controller
[   23.449973] usb usb1: Manufacturer: Linux 2.6.30-rc5-tip-01553-g4bc9bac-dirty ehci_hcd
[   23.453306] usb usb1: SerialNumber: 0000:00:10.4
[   23.456639] device: 'usb1': device_add
[   23.459973] bus: 'usb': add device usb1
[   23.463306] PM: Adding info for usb:usb1
[   23.469973] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[   23.473306] bus: 'usb': really_probe: probing driver usb with device usb1
[   23.476639] usb usb1: configuration #1 chosen from 1 choice
[   23.479973] device: '1-0:1.0': device_add
[   23.483306] bus: 'usb': add device 1-0:1.0
[   23.486639] PM: Adding info for usb:1-0:1.0
[   23.493306] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[   23.496639] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[   23.499973] hub 1-0:1.0: USB hub found
[   23.503306] hub 1-0:1.0: 8 ports detected
[   23.509973] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[   23.513306] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[   23.516639] device class 'usb_endpoint': registering
[   23.519973] device: 'usbdev1.1_ep81': device_add
[   23.523306] PM: Adding info for No Bus:usbdev1.1_ep81
[   23.526639] device: 'usbdev1.1': device_add
[   23.533306] PM: Adding info for No Bus:usbdev1.1
[   23.536639] driver: 'usb1': driver_bound: bound to device 'usb'
[   23.539973] bus: 'usb': really_probe: bound device usb1 to driver usb
[   23.543306] device: 'usbdev1.1_ep00': device_add
[   23.546639] PM: Adding info for No Bus:usbdev1.1_ep00
[   23.549973] driver: '0000:00:10.4': driver_bound: bound to device 'ehci_hcd'
[   23.553306] bus: 'pci': really_probe: bound device 0000:00:10.4 to driver ehci_hcd
[   23.556639] initcall ehci_hcd_init+0x0/0x140 returned 0 after 185546 usecs
[   23.559973] calling  oxu_module_init+0x0/0x40 @ 1
[   23.563306] bus: 'platform': add driver oxu210hp-hcd
[   23.566639] initcall oxu_module_init+0x0/0x40 returned 0 after 3255 usecs
[   23.569973] calling  ohci_hcd_mod_init+0x0/0x140 @ 1
[   23.573306] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   23.576639] bus: 'pci': add driver ohci_hcd
[   23.579973] bus: 'platform': add driver sm501-usb
[   23.583306] initcall ohci_hcd_mod_init+0x0/0x140 returned 0 after 9765 usecs
[   23.586639] calling  uhci_hcd_init+0x0/0x100 @ 1
[   23.589973] uhci_hcd: USB Universal Host Controller Interface driver
[   23.596639] bus: 'pci': add driver uhci_hcd
[   23.599973] bus: 'pci': driver_probe_device: matched device 0000:00:10.0 with driver uhci_hcd
[   23.606639] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:10.0
[   23.609973] uhci_hcd 0000:00:10.0: found PCI INT A -> IRQ 11
[   23.613306] uhci_hcd 0000:00:10.0: sharing IRQ 11 with 0000:00:07.0
[   23.616639] uhci_hcd 0000:00:10.0: sharing IRQ 11 with 0000:00:0f.1
[   23.623306] uhci_hcd 0000:00:10.0: sharing IRQ 11 with 0000:00:10.1
[   23.626639] uhci_hcd 0000:00:10.0: UHCI Host Controller
[   23.629973] device: 'usb_host2': device_add
[   23.633306] PM: Adding info for No Bus:usb_host2
[   23.636639] device: 'usbmon2': device_add
[   23.639973] PM: Adding info for No Bus:usbmon2
[   23.643306] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[   23.646639] uhci_hcd 0000:00:10.0: irq 11, io base 0x0000b400
[   23.649973] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   23.653306] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.656639] usb usb2: Product: UHCI Host Controller
[   23.659973] usb usb2: Manufacturer: Linux 2.6.30-rc5-tip-01553-g4bc9bac-dirty uhci_hcd
[   23.663306] usb usb2: SerialNumber: 0000:00:10.0
[   23.666639] device: 'usb2': device_add
[   23.673306] bus: 'usb': add device usb2
[   23.676639] PM: Adding info for usb:usb2
[   23.679973] bus: 'usb': driver_probe_device: matched device usb2 with driver usb
[   23.683306] bus: 'usb': really_probe: probing driver usb with device usb2
[   23.686639] usb usb2: configuration #1 chosen from 1 choice
[   23.689973] device: '2-0:1.0': device_add
[   23.693306] bus: 'usb': add device 2-0:1.0
[   23.696639] PM: Adding info for usb:2-0:1.0
[   23.699973] bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
[   23.703306] bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
[   23.706639] hub 2-0:1.0: USB hub found
[   23.709973] hub 2-0:1.0: 2 ports detected
[   23.713306] driver: '2-0:1.0': driver_bound: bound to device 'hub'
[   23.716639] bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
[   23.719973] device: 'usbdev2.1_ep81': device_add
[   23.723306] PM: Adding info for No Bus:usbdev2.1_ep81
[   23.726639] device: 'usbdev2.1': device_add
[   23.729973] PM: Adding info for No Bus:usbdev2.1
[   23.733306] driver: 'usb2': driver_bound: bound to device 'usb'
[   23.736639] bus: 'usb': really_probe: bound device usb2 to driver usb
[   23.739973] device: 'usbdev2.1_ep00': device_add
[   23.743306] PM: Adding info for No Bus:usbdev2.1_ep00
[   23.749973] driver: '0000:00:10.0': driver_bound: bound to device 'uhci_hcd'
[   23.753306] bus: 'pci': really_probe: bound device 0000:00:10.0 to driver uhci_hcd
[   23.756639] bus: 'pci': driver_probe_device: matched device 0000:00:10.1 with driver uhci_hcd
[   23.759972] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:10.1
[   23.763306] uhci_hcd 0000:00:10.1: found PCI INT A -> IRQ 11
[   23.766639] uhci_hcd 0000:00:10.1: sharing IRQ 11 with 0000:00:07.0
[   23.769972] uhci_hcd 0000:00:10.1: sharing IRQ 11 with 0000:00:0f.1
[   23.773306] uhci_hcd 0000:00:10.1: sharing IRQ 11 with 0000:00:10.0
[   23.779972] uhci_hcd 0000:00:10.1: UHCI Host Controller
[   23.783306] device: 'usb_host3': device_add
[   23.786639] PM: Adding info for No Bus:usb_host3
[   23.789972] device: 'usbmon3': device_add
[   23.793306] PM: Adding info for No Bus:usbmon3
[   23.796639] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
[   23.799972] uhci_hcd 0000:00:10.1: irq 11, io base 0x0000b800
[   23.803306] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   23.806639] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.809972] usb usb3: Product: UHCI Host Controller
[   23.813306] usb usb3: Manufacturer: Linux 2.6.30-rc5-tip-01553-g4bc9bac-dirty uhci_hcd
[   23.816639] usb usb3: SerialNumber: 0000:00:10.1
[   23.819972] device: 'usb3': device_add
[   23.823306] bus: 'usb': add device usb3
[   23.826639] PM: Adding info for usb:usb3
[   23.829972] bus: 'usb': driver_probe_device: matched device usb3 with driver usb
[   23.833306] bus: 'usb': really_probe: probing driver usb with device usb3
[   23.836639] usb usb3: configuration #1 chosen from 1 choice
[   23.839972] device: '3-0:1.0': device_add
[   23.843306] bus: 'usb': add device 3-0:1.0
[   23.846639] PM: Adding info for usb:3-0:1.0
[   23.849972] bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub
[   23.853306] bus: 'usb': really_probe: probing driver hub with device 3-0:1.0
[   23.856639] hub 3-0:1.0: USB hub found
[   23.859972] hub 3-0:1.0: 2 ports detected
[   23.863306] driver: '3-0:1.0': driver_bound: bound to device 'hub'
[   23.866639] bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub
[   23.869972] device: 'usbdev3.1_ep81': device_add
[   23.873306] PM: Adding info for No Bus:usbdev3.1_ep81
[   23.876639] device: 'usbdev3.1': device_add
[   23.879972] PM: Adding info for No Bus:usbdev3.1
[   23.883306] driver: 'usb3': driver_bound: bound to device 'usb'
[   23.886639] bus: 'usb': really_probe: bound device usb3 to driver usb
[   23.889972] device: 'usbdev3.1_ep00': device_add
[   23.893306] PM: Adding info for No Bus:usbdev3.1_ep00
[   23.896639] driver: '0000:00:10.1': driver_bound: bound to device 'uhci_hcd'
[   23.899972] bus: 'pci': really_probe: bound device 0000:00:10.1 to driver uhci_hcd
[   23.903306] bus: 'pci': driver_probe_device: matched device 0000:00:10.2 with driver uhci_hcd
[   23.906639] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:10.2
[   23.909972] uhci_hcd 0000:00:10.2: found PCI INT B -> IRQ 10
[   23.913306] uhci_hcd 0000:00:10.2: sharing IRQ 10 with 0000:00:0a.0
[   23.916639] uhci_hcd 0000:00:10.2: sharing IRQ 10 with 0000:00:0f.0
[   23.919972] uhci_hcd 0000:00:10.2: sharing IRQ 10 with 0000:00:10.3
[   23.923306] uhci_hcd 0000:00:10.2: UHCI Host Controller
[   23.926639] device: 'usb_host4': device_add
[   23.929972] PM: Adding info for No Bus:usb_host4
[   23.933306] device: 'usbmon4': device_add
[   23.936639] PM: Adding info for No Bus:usbmon4
[   23.939972] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
[   23.943306] uhci_hcd 0000:00:10.2: irq 10, io base 0x0000c000
[   23.946639] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   23.949972] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.953306] usb usb4: Product: UHCI Host Controller
[   23.956639] usb usb4: Manufacturer: Linux 2.6.30-rc5-tip-01553-g4bc9bac-dirty uhci_hcd
[   23.959972] usb usb4: SerialNumber: 0000:00:10.2
[   23.966639] device: 'usb4': device_add
[   23.969972] bus: 'usb': add device usb4
[   23.973306] PM: Adding info for usb:usb4
[   23.976639] bus: 'usb': driver_probe_device: matched device usb4 with driver usb
[   23.979972] bus: 'usb': really_probe: probing driver usb with device usb4
[   23.983306] usb usb4: configuration #1 chosen from 1 choice
[   23.986639] device: '4-0:1.0': device_add
[   23.989972] bus: 'usb': add device 4-0:1.0
[   23.993306] PM: Adding info for usb:4-0:1.0
[   23.996639] bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub
[   23.999972] bus: 'usb': really_probe: probing driver hub with device 4-0:1.0
[   24.003306] hub 4-0:1.0: USB hub found
[   24.006639] hub 4-0:1.0: 2 ports detected
[   24.009972] driver: '4-0:1.0': driver_bound: bound to device 'hub'
[   24.013306] bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub
[   24.016639] device: 'usbdev4.1_ep81': device_add
[   24.019972] PM: Adding info for No Bus:usbdev4.1_ep81
[   24.023306] device: 'usbdev4.1': device_add
[   24.026639] PM: Adding info for No Bus:usbdev4.1
[   24.029972] driver: 'usb4': driver_bound: bound to device 'usb'
[   24.033306] bus: 'usb': really_probe: bound device usb4 to driver usb
[   24.036639] device: 'usbdev4.1_ep00': device_add
[   24.039972] PM: Adding info for No Bus:usbdev4.1_ep00
[   24.043306] driver: '0000:00:10.2': driver_bound: bound to device 'uhci_hcd'
[   24.046639] bus: 'pci': really_probe: bound device 0000:00:10.2 to driver uhci_hcd
[   24.049972] bus: 'pci': driver_probe_device: matched device 0000:00:10.3 with driver uhci_hcd
[   24.053306] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:10.3
[   24.056639] uhci_hcd 0000:00:10.3: found PCI INT B -> IRQ 10
[   24.059972] uhci_hcd 0000:00:10.3: sharing IRQ 10 with 0000:00:0a.0
[   24.063306] uhci_hcd 0000:00:10.3: sharing IRQ 10 with 0000:00:0f.0
[   24.066639] uhci_hcd 0000:00:10.3: sharing IRQ 10 with 0000:00:10.2
[   24.069972] uhci_hcd 0000:00:10.3: UHCI Host Controller
[   24.073306] device: 'usb_host5': device_add
[   24.076639] PM: Adding info for No Bus:usb_host5
[   24.079972] device: 'usbmon5': device_add
[   24.083306] PM: Adding info for No Bus:usbmon5
[   24.086639] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
[   24.089972] uhci_hcd 0000:00:10.3: irq 10, io base 0x0000c400
[   24.093306] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   24.096639] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   24.099972] usb usb5: Product: UHCI Host Controller
[   24.103306] usb usb5: Manufacturer: Linux 2.6.30-rc5-tip-01553-g4bc9bac-dirty uhci_hcd
[   24.106639] usb usb5: SerialNumber: 0000:00:10.3
[   24.109972] device: 'usb5': device_add
[   24.113306] bus: 'usb': add device usb5
[   24.116639] PM: Adding info for usb:usb5
[   24.119972] bus: 'usb': driver_probe_device: matched device usb5 with driver usb
[   24.123306] bus: 'usb': really_probe: probing driver usb with device usb5
[   24.126639] usb usb5: configuration #1 chosen from 1 choice
[   24.129972] device: '5-0:1.0': device_add
[   24.133306] bus: 'usb': add device 5-0:1.0
[   24.136639] PM: Adding info for usb:5-0:1.0
[   24.139972] bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub
[   24.143305] bus: 'usb': really_probe: probing driver hub with device 5-0:1.0
[   24.146639] hub 5-0:1.0: USB hub found
[   24.149972] hub 5-0:1.0: 2 ports detected
[   24.153305] driver: '5-0:1.0': driver_bound: bound to device 'hub'
[   24.156639] bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub
[   24.159972] device: 'usbdev5.1_ep81': device_add
[   24.163305] PM: Adding info for No Bus:usbdev5.1_ep81
[   24.166639] device: 'usbdev5.1': device_add
[   24.169972] PM: Adding info for No Bus:usbdev5.1
[   24.173305] driver: 'usb5': driver_bound: bound to device 'usb'
[   24.176639] bus: 'usb': really_probe: bound device usb5 to driver usb
[   24.179972] device: 'usbdev5.1_ep00': device_add
[   24.183305] PM: Adding info for No Bus:usbdev5.1_ep00
[   24.186639] driver: '0000:00:10.3': driver_bound: bound to device 'uhci_hcd'
[   24.189972] bus: 'pci': really_probe: bound device 0000:00:10.3 to driver uhci_hcd
[   24.193305] initcall uhci_hcd_init+0x0/0x100 returned 0 after 589192 usecs
[   24.196639] calling  wusbcore_init+0x0/0xa0 @ 1
[   24.199972] initcall wusbcore_init+0x0/0xa0 returned 0 after 0 usecs
[   24.203305] calling  wdm_init+0x0/0x45 @ 1
[   24.206639] bus: 'usb': add driver cdc_wdm
[   24.209972] usbcore: registered new interface driver cdc_wdm
[   24.213305] initcall wdm_init+0x0/0x45 returned 0 after 6510 usecs
[   24.216639] calling  usb_usual_init+0x0/0x6b @ 1
[   24.219972] bus: 'usb': add driver libusual
[   24.223305] usbcore: registered new interface driver libusual
[   24.226639] initcall usb_usual_init+0x0/0x6b returned 0 after 6510 usecs
[   24.229972] calling  appledisplay_init+0x0/0x80 @ 1
[   24.233305] bus: 'usb': add driver appledisplay
[   24.239972] usbcore: registered new interface driver appledisplay
[   24.243305] initcall appledisplay_init+0x0/0x80 returned 0 after 9765 usecs
[   24.246639] calling  iowarrior_init+0x0/0x50 @ 1
[   24.249972] bus: 'usb': add driver iowarrior
[   24.253305] usbcore: registered new interface driver iowarrior
[   24.256639] initcall iowarrior_init+0x0/0x50 returned 0 after 6510 usecs
[   24.259972] calling  isight_firmware_init+0x0/0x45 @ 1
[   24.263305] bus: 'usb': add driver isight_firmware
[   24.266639] usbcore: registered new interface driver isight_firmware
[   24.269972] initcall isight_firmware_init+0x0/0x45 returned 0 after 6510 usecs
[   24.273305] calling  usb_lcd_init+0x0/0x6b @ 1
[   24.276639] bus: 'usb': add driver usblcd
[   24.279972] usbcore: registered new interface driver usblcd
[   24.283305] initcall usb_lcd_init+0x0/0x6b returned 0 after 6510 usecs
[   24.286639] calling  i8042_init+0x0/0xed @ 1
[   24.289972] bus: 'pnp': add driver i8042 kbd
[   24.296639] bus: 'pnp': add driver i8042 aux
[   24.299972] bus: 'pnp': remove driver i8042 kbd
[   24.303305] driver: 'i8042 kbd': driver_release
[   24.306639] bus: 'pnp': remove driver i8042 aux
[   24.309972] driver: 'i8042 aux': driver_release
[   24.313305] PNP: No PS/2 controller found. Probing ports directly.
[   24.316639] bus: 'platform': add driver i8042
[   24.319972] Registering platform device 'i8042'. Parent at platform
[   24.323305] device: 'i8042': device_add
[   24.326639] bus: 'platform': add device i8042
[   24.329972] PM: Adding info for platform:i8042
[   24.333305] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   24.336639] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   24.339972] serio: i8042 KBD port at 0x60,0x64 irq 1
[   24.343305] serio: i8042 AUX port at 0x60,0x64 irq 12
[   24.346639] driver: 'i8042': driver_bound: bound to device 'i8042'
[   24.349972] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   24.353305] initcall i8042_init+0x0/0xed returned 0 after 61848 usecs
[   24.356639] calling  serport_init+0x0/0x5c @ 1
[   24.359972] initcall serport_init+0x0/0x5c returned 0 after 0 usecs
[   24.363305] calling  ct82c710_init+0x0/0xf9 @ 1
[   24.366639] initcall ct82c710_init+0x0/0xf9 returned -19 after 0 usecs
[   24.369972] calling  pcips2_init+0x0/0x50 @ 1
[   24.373305] bus: 'pci': add driver pcips2
[   24.376639] device: 'serio0': device_add
[   24.379972] bus: 'serio': add device serio0
[   24.383305] PM: Adding info for serio:serio0
[   24.386639] device: 'serio1': device_add
[   24.389972] bus: 'serio': add device serio1
[   24.393305] PM: Adding info for serio:serio1
[   24.396639] initcall pcips2_init+0x0/0x50 returned 0 after 22786 usecs
[   24.399972] calling  fm801_gp_init+0x0/0x45 @ 1
[   24.403305] bus: 'pci': add driver FM801_gameport
[   24.406639] initcall fm801_gp_init+0x0/0x45 returned 0 after 3255 usecs
[   24.409972] calling  ns558_init+0x0/0x9b @ 1
[   24.413305] bus: 'pnp': add driver ns558
[   24.433305] initcall ns558_init+0x0/0x9b returned 0 after 19531 usecs
[   24.436639] calling  mousedev_init+0x0/0xa4 @ 1
[   24.439972] device: 'mice': device_add
[   24.443305] PM: Adding info for No Bus:mice
[   24.446639] mice: PS/2 mouse device common for all mice
[   24.449972] initcall mousedev_init+0x0/0xa4 returned 0 after 9765 usecs
[   24.453305] calling  joydev_init+0x0/0x40 @ 1
[   24.456639] initcall joydev_init+0x0/0x40 returned 0 after 0 usecs
[   24.459972] calling  evdev_init+0x0/0x40 @ 1
[   24.463305] initcall evdev_init+0x0/0x40 returned 0 after 0 usecs
[   24.466639] calling  atkbd_init+0x0/0x48 @ 1
[   24.469972] bus: 'serio': add driver atkbd
[   24.473305] initcall atkbd_init+0x0/0x48 returned 0 after 3255 usecs
[   24.476639] calling  sunkbd_init+0x0/0x50 @ 1
[   24.479972] bus: 'serio': add driver sunkbd
[   24.483305] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   24.486639] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   24.489972] initcall sunkbd_init+0x0/0x50 returned 0 after 9765 usecs
[   24.493305] calling  xtkbd_init+0x0/0x50 @ 1
[   24.496639] bus: 'serio': add driver xtkbd
[   24.499972] initcall xtkbd_init+0x0/0x50 returned 0 after 3255 usecs
[   24.503305] calling  nkbd_init+0x0/0x50 @ 1
[   24.506639] bus: 'serio': add driver newtonkbd
[   24.509972] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   24.513305] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   24.516639] initcall nkbd_init+0x0/0x50 returned 0 after 9765 usecs
[   24.519972] calling  cobra_init+0x0/0x50 @ 1
[   24.523305] bus: 'gameport': add driver cobra
[   24.526639] initcall cobra_init+0x0/0x50 returned 0 after 3255 usecs
[   24.529972] calling  grip_init+0x0/0x50 @ 1
[   24.533305] bus: 'gameport': add driver grip_mp
[   24.536639] initcall grip_init+0x0/0x50 returned 0 after 3255 usecs
[   24.539972] calling  guillemot_init+0x0/0x50 @ 1
[   24.543305] bus: 'gameport': add driver guillemot
[   24.546639] initcall guillemot_init+0x0/0x50 returned 0 after 3255 usecs
[   24.549972] calling  interact_init+0x0/0x50 @ 1
[   24.553305] bus: 'gameport': add driver interact
[   24.556639] initcall interact_init+0x0/0x50 returned 0 after 3255 usecs
[   24.559972] calling  joydump_init+0x0/0x50 @ 1
[   24.563305] bus: 'gameport': add driver joydump
[   24.566638] initcall joydump_init+0x0/0x50 returned 0 after 3255 usecs
[   24.569972] calling  stinger_init+0x0/0x50 @ 1
[   24.573305] bus: 'serio': add driver stinger
[   24.576638] initcall stinger_init+0x0/0x50 returned 0 after 3255 usecs
[   24.579972] calling  tmdc_init+0x0/0x45 @ 1
[   24.583305] bus: 'gameport': add driver tmdc
[   24.589972] initcall tmdc_init+0x0/0x45 returned 0 after 6510 usecs
[   24.593305] calling  tgfx_init+0x0/0x119 @ 1
[   24.596638] initcall tgfx_init+0x0/0x119 returned -19 after 0 usecs
[   24.599972] calling  warrior_init+0x0/0x50 @ 1
[   24.603305] bus: 'serio': add driver warrior
[   24.606638] initcall warrior_init+0x0/0x50 returned 0 after 3255 usecs
[   24.609972] calling  walkera0701_init+0x0/0x45 @ 1
[   24.613305] initcall walkera0701_init+0x0/0x45 returned -19 after 0 usecs
[   24.616638] calling  usb_acecad_init+0x0/0x60 @ 1
[   24.619972] bus: 'usb': add driver usb_acecad
[   24.623305] usbcore: registered new interface driver usb_acecad
[   24.626638] acecad: v3.2:USB Acecad Flair tablet driver
[   24.629972] initcall usb_acecad_init+0x0/0x60 returned 0 after 9765 usecs
[   24.633305] calling  aiptek_init+0x0/0x7b @ 1
[   24.636638] bus: 'usb': add driver aiptek
[   24.639972] usbcore: registered new interface driver aiptek
[   24.643305] aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
[   24.646638] aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
[   24.649972] initcall aiptek_init+0x0/0x7b returned 0 after 13020 usecs
[   24.653305] calling  mk712_init+0x0/0x220 @ 1
[   24.656638] mk712: device not present
[   24.659972] initcall mk712_init+0x0/0x220 returned -19 after 3255 usecs
[   24.663305] calling  usbtouch_init+0x0/0x50 @ 1
[   24.666638] bus: 'usb': add driver usbtouchscreen
[   24.669972] usbcore: registered new interface driver usbtouchscreen
[   24.673305] initcall usbtouch_init+0x0/0x50 returned 0 after 6510 usecs
[   24.676638] calling  pm_init+0x0/0x50 @ 1
[   24.679972] bus: 'serio': add driver penmountlpc
[   24.686638] initcall pm_init+0x0/0x50 returned 0 after 6510 usecs
[   24.689972] calling  touchit213_init+0x0/0x50 @ 1
[   24.693305] bus: 'serio': add driver touchit213
[   24.696638] initcall touchit213_init+0x0/0x50 returned 0 after 3255 usecs
[   24.699972] calling  w8001_init+0x0/0x50 @ 1
[   24.703305] bus: 'serio': add driver w8001
[   24.706638] initcall w8001_init+0x0/0x50 returned 0 after 3255 usecs
[   24.709972] calling  apanel_init+0x0/0x1ed @ 1
[   24.713305] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   24.716638] initcall apanel_init+0x0/0x1ed returned -19 after 3255 usecs
[   24.719972] calling  ati_remote_init+0x0/0x70 @ 1
[   24.723305] bus: 'usb': add driver ati_remote
[   24.726638] usbcore: registered new interface driver ati_remote
[   24.729972] ati_remote: 2.2.1:ATI/X10 RF USB Remote Control
[   24.733305] initcall ati_remote_init+0x0/0x70 returned 0 after 9765 usecs
[   24.736638] calling  ati_remote2_init+0x0/0x70 @ 1
[   24.739972] bus: 'usb': add driver ati_remote2
[   24.743305] usbcore: registered new interface driver ati_remote2
[   24.746638] ati_remote2: ATI/Philips USB RF remote driver 0.3
[   24.749972] initcall ati_remote2_init+0x0/0x70 returned 0 after 9765 usecs
[   24.753305] calling  cm109_init+0x0/0x6b @ 1
[   24.756638] cm109: Keymap for Komunikate KIP1000 phone loaded
[   24.759972] bus: 'usb': add driver cm109
[   24.763305] usbcore: registered new interface driver cm109
[   24.766638] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   24.769972] initcall cm109_init+0x0/0x6b returned 0 after 13020 usecs
[   24.773305] calling  usb_keyspan_init+0x0/0x69 @ 1
[   24.776638] bus: 'usb': add driver keyspan_remote
[   24.779972] usbcore: registered new interface driver keyspan_remote
[   24.783305] initcall usb_keyspan_init+0x0/0x69 returned 0 after 6510 usecs
[   24.786638] calling  i2c_ali15x3_init+0x0/0x50 @ 1
[   24.789972] bus: 'pci': add driver ali15x3_smbus
[   24.793305] initcall i2c_ali15x3_init+0x0/0x50 returned 0 after 3255 usecs
[   24.796638] calling  i2c_amd8111_init+0x0/0x50 @ 1
[   24.799972] bus: 'pci': add driver amd8111_smbus2
[   24.803305] initcall i2c_amd8111_init+0x0/0x50 returned 0 after 3255 usecs
[   24.806638] calling  nforce2_init+0x0/0x50 @ 1
[   24.809972] bus: 'pci': add driver nForce2_smbus
[   24.813305] initcall nforce2_init+0x0/0x50 returned 0 after 3255 usecs
[   24.816638] calling  i2c_sis5595_init+0x0/0x50 @ 1
[   24.819972] bus: 'pci': add driver sis5595_smbus
[   24.823305] initcall i2c_sis5595_init+0x0/0x50 returned 0 after 3255 usecs
[   24.826638] calling  i2c_sis96x_init+0x0/0x50 @ 1
[   24.829972] bus: 'pci': add driver sis96x_smbus
[   24.833305] initcall i2c_sis96x_init+0x0/0x50 returned 0 after 3255 usecs
[   24.836638] calling  i2c_vt586b_init+0x0/0x50 @ 1
[   24.839972] bus: 'pci': add driver vt586b_smbus
[   24.843305] initcall i2c_vt586b_init+0x0/0x50 returned 0 after 3255 usecs
[   24.846638] calling  ocores_i2c_init+0x0/0x3d @ 1
[   24.849972] bus: 'platform': add driver ocores-i2c
[   24.853305] initcall ocores_i2c_init+0x0/0x3d returned 0 after 3255 usecs
[   24.856638] calling  i2c_parport_init+0x0/0x73 @ 1
[   24.859972] i2c-parport: adapter type unspecified
[   24.863305] initcall i2c_parport_init+0x0/0x73 returned -19 after 3255 usecs
[   24.866638] calling  taos_init+0x0/0x50 @ 1
[   24.869972] bus: 'serio': add driver taos-evm
[   24.873305] initcall taos_init+0x0/0x50 returned 0 after 3255 usecs
[   24.876638] calling  usb_i2c_tiny_usb_init+0x0/0x50 @ 1
[   24.879972] bus: 'usb': add driver i2c-tiny-usb
[   24.883305] usbcore: registered new interface driver i2c-tiny-usb
[   24.886638] initcall usb_i2c_tiny_usb_init+0x0/0x50 returned 0 after 6510 usecs
[   24.889972] calling  pcf8574_init+0x0/0x40 @ 1
[   24.893305] bus: 'i2c': add driver pcf8574
[   24.896638] i2c-core: driver [pcf8574] registered
[   24.899972] initcall pcf8574_init+0x0/0x40 returned 0 after 6510 usecs
[   24.906638] calling  sensors_w83781d_init+0x0/0x40 @ 1
[   24.909972] bus: 'i2c': add driver w83781d
[   24.913305] i2c-core: driver [w83781d] registered
[   24.916638] initcall sensors_w83781d_init+0x0/0x40 returned 0 after 6510 usecs
[   24.919972] calling  sensors_w83791d_init+0x0/0x40 @ 1
[   24.923305] bus: 'i2c': add driver w83791d
[   24.926638] i2c-core: driver [w83791d] registered
[   24.929972] initcall sensors_w83791d_init+0x0/0x40 returned 0 after 6510 usecs
[   24.933305] calling  abituguru3_init+0x0/0x1b0 @ 1
[   24.936638] abituguru3: no Abit uGuru3 found, data = 0xFF, cmd = 0xFF
[   24.939972] initcall abituguru3_init+0x0/0x1b0 returned -19 after 3255 usecs
[   24.943305] calling  ad7418_init+0x0/0x40 @ 1
[   24.949972] bus: 'i2c': add driver ad7418
[   24.953305] i2c-core: driver [ad7418] registered
[   24.956638] initcall ad7418_init+0x0/0x40 returned 0 after 6510 usecs
[   24.959972] calling  sensors_adm1021_init+0x0/0x40 @ 1
[   24.963305] bus: 'i2c': add driver adm1021
[   24.966638] i2c-core: driver [adm1021] registered
[   24.969972] initcall sensors_adm1021_init+0x0/0x40 returned 0 after 6510 usecs
[   24.973305] calling  sensors_adm9240_init+0x0/0x40 @ 1
[   24.976638] bus: 'i2c': add driver adm9240
[   24.979972] i2c-core: driver [adm9240] registered
[   24.983305] initcall sensors_adm9240_init+0x0/0x40 returned 0 after 6510 usecs
[   24.986638] calling  sensors_ads7828_init+0x0/0x90 @ 1
[   24.989972] bus: 'i2c': add driver ads7828
[   24.993305] i2c-core: driver [ads7828] registered
[   24.996638] initcall sensors_ads7828_init+0x0/0x90 returned 0 after 6510 usecs
[   24.999972] calling  adt7473_init+0x0/0x40 @ 1
[   25.003305] bus: 'i2c': add driver adt7473
[   25.006638] i2c-core: driver [adt7473] registered
[   25.009972] initcall adt7473_init+0x0/0x40 returned 0 after 6510 usecs
[   25.013305] calling  applesmc_init+0x0/0x55 @ 1
[   25.016638] applesmc: supported laptop not found!
[   25.019972] applesmc: driver init failed (ret=-19)!
[   25.023305] initcall applesmc_init+0x0/0x55 returned -19 after 6510 usecs
[   25.026638] calling  atk0110_init+0x0/0x5b @ 1
[   25.029972] atk: acpi_bus_register_driver failed: -19
[   25.033305] initcall atk0110_init+0x0/0x5b returned -19 after 3255 usecs
[   25.036638] calling  coretemp_init+0x0/0x290 @ 1
[   25.039971] initcall coretemp_init+0x0/0x290 returned -19 after 0 usecs
[   25.043305] calling  dme1737_init+0x0/0xeb @ 1
[   25.046638] bus: 'i2c': add driver dme1737
[   25.053305] i2c-core: driver [dme1737] registered
[   25.056638] initcall dme1737_init+0x0/0xeb returned 0 after 9765 usecs
[   25.059971] calling  i5k_amb_init+0x0/0x9b @ 1
[   25.063305] bus: 'platform': add driver i5k_amb
[   25.066638] Registering platform device 'i5k_amb.0'. Parent at platform
[   25.069971] device: 'i5k_amb.0': device_add
[   25.073305] bus: 'platform': add device i5k_amb.0
[   25.076638] PM: Adding info for platform:i5k_amb.0
[   25.079971] bus: 'platform': driver_probe_device: matched device i5k_amb.0 with driver i5k_amb
[   25.083305] bus: 'platform': really_probe: probing driver i5k_amb with device i5k_amb.0
[   25.086638] initcall i5k_amb_init+0x0/0x9b returned 0 after 22786 usecs
[   25.089971] calling  sm_it87_init+0x0/0x8f @ 1
[   25.093305] initcall sm_it87_init+0x0/0x8f returned -19 after 0 usecs
[   25.096638] calling  init_lm70+0x0/0x6e @ 1
[   25.099971] bus: 'spi': add driver lm70
[   25.103305] bus: 'spi': add driver tmp121
[   25.106638] initcall init_lm70+0x0/0x6e returned 0 after 6510 usecs
[   25.109971] calling  sensors_lm75_init+0x0/0x40 @ 1
[   25.113305] bus: 'i2c': add driver lm75
[   25.116638] i2c-core: driver [lm75] registered
[   25.119971] initcall sensors_lm75_init+0x0/0x40 returned 0 after 6510 usecs
[   25.123305] calling  lm93_init+0x0/0x3d @ 1
[   25.126638] bus: 'i2c': add driver lm93
[   25.129971] i2c-core: driver [lm93] registered
[   25.133305] initcall lm93_init+0x0/0x3d returned 0 after 6510 usecs
[   25.136638] calling  pcf8591_init+0x0/0x63 @ 1
[   25.139971] bus: 'i2c': add driver pcf8591
[   25.143305] i2c-core: driver [pcf8591] registered
[   25.146638] initcall pcf8591_init+0x0/0x63 returned 0 after 6510 usecs
[   25.149971] calling  smsc47b397_init+0x0/0x13f @ 1
[   25.153305] initcall smsc47b397_init+0x0/0x13f returned -19 after 0 usecs
[   25.156638] calling  sm_smsc47m1_init+0x0/0x84 @ 1
[   25.159971] initcall sm_smsc47m1_init+0x0/0x84 returned -19 after 0 usecs
[   25.163305] calling  sm_thmc50_init+0x0/0x40 @ 1
[   25.166638] bus: 'i2c': add driver thmc50
[   25.169971] i2c-core: driver [thmc50] registered
[   25.173305] initcall sm_thmc50_init+0x0/0x40 returned 0 after 6510 usecs
[   25.176638] calling  sm_vt8231_init+0x0/0x50 @ 1
[   25.179971] bus: 'pci': add driver vt8231
[   25.186638] initcall sm_vt8231_init+0x0/0x50 returned 0 after 6510 usecs
[   25.189971] calling  sensors_w83l785ts_init+0x0/0x40 @ 1
[   25.193305] bus: 'i2c': add driver w83l785ts
[   25.199971] i2c-core: driver [w83l785ts] registered
[   25.203305] initcall sensors_w83l785ts_init+0x0/0x40 returned 0 after 9765 usecs
[   25.206638] calling  pcipcwd_init_module+0x0/0x65 @ 1
[   25.209971] bus: 'pci': add driver pcwd_pci
[   25.213305] initcall pcipcwd_init_module+0x0/0x65 returned 0 after 3255 usecs
[   25.216638] calling  advwdt_init+0x0/0xa9 @ 1
[   25.219971] WDT driver for Advantech single board computer initialising.
[   25.223305] bus: 'platform': add driver advantechwdt
[   25.226638] Registering platform device 'advantechwdt'. Parent at platform
[   25.229971] device: 'advantechwdt': device_add
[   25.233305] bus: 'platform': add device advantechwdt
[   25.236638] PM: Adding info for platform:advantechwdt
[   25.239971] bus: 'platform': driver_probe_device: matched device advantechwdt with driver advantechwdt
[   25.243305] bus: 'platform': really_probe: probing driver advantechwdt with device advantechwdt
[   25.246638] device: 'watchdog': device_add
[   25.249971] PM: Adding info for No Bus:watchdog
[   25.253305] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[   25.256638] driver: 'advantechwdt': driver_bound: bound to device 'advantechwdt'
[   25.259971] bus: 'platform': really_probe: bound device advantechwdt to driver advantechwdt
[   25.263305] initcall advwdt_init+0x0/0xa9 returned 0 after 42317 usecs
[   25.266638] calling  sc520_wdt_init+0x0/0x113 @ 1
[   25.269971] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[   25.273305] initcall sc520_wdt_init+0x0/0x113 returned -16 after 3255 usecs
[   25.276638] initcall sc520_wdt_init+0x0/0x113 returned with error code -16 
[   25.283305] calling  ibwdt_init+0x0/0xa9 @ 1
[   25.286638] ib700wdt: WDT driver for IB700 single board computer initialising.
[   25.289971] bus: 'platform': add driver ib700wdt
[   25.296638] Registering platform device 'ib700wdt'. Parent at platform
[   25.303305] device: 'ib700wdt': device_add
[   25.306638] bus: 'platform': add device ib700wdt
[   25.309971] PM: Adding info for platform:ib700wdt
[   25.313305] bus: 'platform': driver_probe_device: matched device ib700wdt with driver ib700wdt
[   25.316638] bus: 'platform': really_probe: probing driver ib700wdt with device ib700wdt
[   25.319971] ib700wdt: START method I/O 443 is not available.
[   25.323305] ib700wdt: probe of ib700wdt failed with error -5
[   25.326638] initcall ibwdt_init+0x0/0xa9 returned 0 after 39062 usecs
[   25.329971] calling  watchdog_init+0x0/0xb6 @ 1
[   25.333305] i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
[   25.336638] bus: 'platform': add driver i6300ESB timer
[   25.339971] Registering platform device 'i6300ESB timer'. Parent at platform
[   25.343305] device: 'i6300ESB timer': device_add
[   25.346638] bus: 'platform': add device i6300ESB timer
[   25.349971] PM: Adding info for platform:i6300ESB timer
[   25.353305] bus: 'platform': driver_probe_device: matched device i6300ESB timer with driver i6300ESB timer
[   25.356638] bus: 'platform': really_probe: probing driver i6300ESB timer with device i6300ESB timer
[   25.359971] initcall watchdog_init+0x0/0xb6 returned 0 after 26041 usecs
[   25.363305] calling  it8712f_wdt_init+0x0/0x125 @ 1
[   25.366638] initcall it8712f_wdt_init+0x0/0x125 returned -19 after 0 usecs
[   25.369971] calling  hpwdt_init+0x0/0x45 @ 1
[   25.373305] bus: 'pci': add driver hpwdt
[   25.376638] initcall hpwdt_init+0x0/0x45 returned 0 after 3255 usecs
[   25.379971] calling  cpu5wdt_init_module+0x0/0x3a @ 1
[   25.383305] cpu5wdt: misc_register failed
[   25.386638] initcall cpu5wdt_init_module+0x0/0x3a returned -16 after 3255 usecs
[   25.389971] initcall cpu5wdt_init_module+0x0/0x3a returned with error code -16 
[   25.393305] calling  wb_smsc_wdt_init+0x0/0x1fa @ 1
[   25.396638] SMsC 37B787 watchdog component driver 1.1 initialising...
[   25.399971] smsc37b787_wdt: Unable to register miscdev on minor 130
[   25.403305] initcall wb_smsc_wdt_init+0x0/0x1fa returned -16 after 6510 usecs
[   25.406638] initcall wb_smsc_wdt_init+0x0/0x1fa returned with error code -16 
[   25.409971] calling  w83877f_wdt_init+0x0/0x1a1 @ 1
[   25.413305] w83877f_wdt: I/O address 0x0443 already in use
[   25.416638] initcall w83877f_wdt_init+0x0/0x1a1 returned -5 after 3255 usecs
[   25.419971] initcall w83877f_wdt_init+0x0/0x1a1 returned with error code -5 
[   25.423305] calling  cpufreq_gov_powersave_init+0x0/0x40 @ 1
[   25.426638] initcall cpufreq_gov_powersave_init+0x0/0x40 returned 0 after 0 usecs
[   25.429971] calling  init_ladder+0x0/0x40 @ 1
[   25.433305] cpuidle: using governor ladder
[   25.436638] initcall init_ladder+0x0/0x40 returned 0 after 3255 usecs
[   25.439971] calling  init_menu+0x0/0x40 @ 1
[   25.443305] cpuidle: using governor menu
[   25.446638] initcall init_menu+0x0/0x40 returned 0 after 3255 usecs
[   25.449971] calling  i7300_idle_init+0x0/0x1bd @ 1
[   25.453305] initcall i7300_idle_init+0x0/0x1bd returned -19 after 0 usecs
[   25.456638] calling  pca9532_init+0x0/0x40 @ 1
[   25.459971] bus: 'i2c': add driver pca9532
[   25.463305] i2c-core: driver [pca9532] registered
[   25.466638] initcall pca9532_init+0x0/0x40 returned 0 after 6510 usecs
[   25.469971] calling  dcdbas_init+0x0/0xa0 @ 1
[   25.473305] bus: 'platform': add driver dcdbas
[   25.476638] Registering platform device 'dcdbas'. Parent at platform
[   25.479971] device: 'dcdbas': device_add
[   25.483305] bus: 'platform': add device dcdbas
[   25.486638] PM: Adding info for platform:dcdbas
[   25.489971] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   25.493305] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   25.496638] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   25.499971] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   25.503305] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   25.506638] initcall dcdbas_init+0x0/0xa0 returned 0 after 32552 usecs
[   25.509971] calling  flow_cache_init+0x0/0x1e0 @ 1
[   25.513305] initcall flow_cache_init+0x0/0x1e0 returned 0 after 0 usecs
[   25.516638] calling  llc_init+0x0/0x50 @ 1
[   25.519971] initcall llc_init+0x0/0x50 returned 0 after 0 usecs
[   25.523305] calling  llc2_init+0x0/0xf8 @ 1
[   25.526638] NET: Registered protocol family 26
[   25.529971] initcall llc2_init+0x0/0xf8 returned 0 after 3255 usecs
[   25.536638] calling  snap_init+0x0/0x70 @ 1
[   25.539971] initcall snap_init+0x0/0x70 returned 0 after 0 usecs
[   25.543305] calling  rif_init+0x0/0xc0 @ 1
[   25.546638] initcall rif_init+0x0/0xc0 returned 0 after 0 usecs
[   25.549971] calling  blackhole_module_init+0x0/0x40 @ 1
[   25.553305] initcall blackhole_module_init+0x0/0x40 returned 0 after 0 usecs
[   25.556638] calling  hfsc_init+0x0/0x40 @ 1
[   25.559971] initcall hfsc_init+0x0/0x40 returned 0 after 0 usecs
[   25.563305] calling  tbf_module_init+0x0/0x40 @ 1
[   25.566638] initcall tbf_module_init+0x0/0x40 returned 0 after 0 usecs
[   25.569971] calling  teql_init+0x0/0x13a @ 1
[   25.573305] device: 'teql0': device_add
[   25.576638] PM: Adding info for No Bus:teql0
[   25.579971] initcall teql_init+0x0/0x13a returned 0 after 6510 usecs
[   25.583305] calling  atm_init+0x0/0x40 @ 1
[   25.586638] initcall atm_init+0x0/0x40 returned 0 after 0 usecs
[   25.589971] calling  netem_module_init+0x0/0x50 @ 1
[   25.593304] netem: version 1.2
[   25.596638] initcall netem_module_init+0x0/0x50 returned 0 after 3255 usecs
[   25.599971] calling  init_rsvp+0x0/0x40 @ 1
[   25.603304] initcall init_rsvp+0x0/0x40 returned 0 after 0 usecs
[   25.606638] calling  init_tcindex+0x0/0x40 @ 1
[   25.609971] initcall init_tcindex+0x0/0x40 returned 0 after 0 usecs
[   25.613304] calling  init_rsvp+0x0/0x3d @ 1
[   25.616638] initcall init_rsvp+0x0/0x3d returned 0 after 0 usecs
[   25.619971] calling  nfnetlink_init+0x0/0x88 @ 1
[   25.623304] Netfilter messages via NETLINK v0.30.
[   25.626638] initcall nfnetlink_init+0x0/0x88 returned 0 after 3255 usecs
[   25.629971] calling  nfnetlink_queue_init+0x0/0xd3 @ 1
[   25.633304] initcall nfnetlink_queue_init+0x0/0xd3 returned 0 after 0 usecs
[   25.636638] calling  nfnetlink_log_init+0x0/0x110 @ 1
[   25.639971] initcall nfnetlink_log_init+0x0/0x110 returned 0 after 0 usecs
[   25.643304] calling  nf_conntrack_standalone_init+0x0/0x3d @ 1
[   25.646638] nf_conntrack version 0.5.0 (8185 buckets, 32740 max)
[   25.653304] initcall nf_conntrack_standalone_init+0x0/0x3d returned 0 after 6510 usecs
[   25.656638] calling  nf_conntrack_proto_dccp_init+0x0/0x94 @ 1
[   25.659971] initcall nf_conntrack_proto_dccp_init+0x0/0x94 returned 0 after 0 usecs
[   25.663304] calling  nf_conntrack_proto_udplite_init+0x0/0x69 @ 1
[   25.666638] initcall nf_conntrack_proto_udplite_init+0x0/0x69 returned 0 after 0 usecs
[   25.669971] calling  ctnetlink_init+0x0/0x9a @ 1
[   25.673304] ctnetlink v0.93: registering with nfnetlink.
[   25.676638] initcall ctnetlink_init+0x0/0x9a returned 0 after 3255 usecs
[   25.679971] calling  nf_conntrack_amanda_init+0x0/0x10c @ 1
[   25.683304] initcall nf_conntrack_amanda_init+0x0/0x10c returned 0 after 0 usecs
[   25.686638] calling  nf_conntrack_netbios_ns_init+0x0/0x45 @ 1
[   25.689971] initcall nf_conntrack_netbios_ns_init+0x0/0x45 returned 0 after 0 usecs
[   25.693304] calling  nf_conntrack_sip_init+0x0/0x258 @ 1
[   25.696638] initcall nf_conntrack_sip_init+0x0/0x258 returned 0 after 0 usecs
[   25.699971] calling  xt_init+0x0/0x1a3 @ 1
[   25.703304] initcall xt_init+0x0/0x1a3 returned 0 after 0 usecs
[   25.706638] calling  tcpudp_mt_init+0x0/0x50 @ 1
[   25.709971] initcall tcpudp_mt_init+0x0/0x50 returned 0 after 0 usecs
[   25.713304] calling  connsecmark_tg_init+0x0/0x40 @ 1
[   25.716638] initcall connsecmark_tg_init+0x0/0x40 returned 0 after 0 usecs
[   25.719971] calling  hl_tg_init+0x0/0x50 @ 1
[   25.723304] initcall hl_tg_init+0x0/0x50 returned 0 after 0 usecs
[   25.726638] calling  nflog_tg_init+0x0/0x40 @ 1
[   25.729971] initcall nflog_tg_init+0x0/0x40 returned 0 after 0 usecs
[   25.733304] calling  xt_rateest_tg_init+0x0/0x70 @ 1
[   25.736638] initcall xt_rateest_tg_init+0x0/0x70 returned 0 after 0 usecs
[   25.739971] calling  secmark_tg_init+0x0/0x40 @ 1
[   25.743304] initcall secmark_tg_init+0x0/0x40 returned 0 after 0 usecs
[   25.746638] calling  tcpmss_tg_init+0x0/0x50 @ 1
[   25.749971] initcall tcpmss_tg_init+0x0/0x50 returned 0 after 0 usecs
[   25.753304] calling  tcpoptstrip_tg_init+0x0/0x50 @ 1
[   25.756638] initcall tcpoptstrip_tg_init+0x0/0x50 returned 0 after 0 usecs
[   25.759971] calling  connmark_mt_init+0x0/0x45 @ 1
[   25.763304] initcall connmark_mt_init+0x0/0x45 returned 0 after 0 usecs
[   25.766638] calling  dccp_mt_init+0x0/0xab @ 1
[   25.769971] initcall dccp_mt_init+0x0/0xab returned 0 after 0 usecs
[   25.773304] calling  dscp_mt_init+0x0/0x50 @ 1
[   25.776638] initcall dscp_mt_init+0x0/0x50 returned 0 after 0 usecs
[   25.779971] calling  helper_mt_init+0x0/0x40 @ 1
[   25.783304] initcall helper_mt_init+0x0/0x40 returned 0 after 0 usecs
[   25.786638] calling  length_mt_init+0x0/0x50 @ 1
[   25.789971] initcall length_mt_init+0x0/0x50 returned 0 after 0 usecs
[   25.793304] calling  realm_mt_init+0x0/0x3d @ 1
[   25.796638] initcall realm_mt_init+0x0/0x3d returned 0 after 0 usecs
[   25.799971] calling  recent_mt_init+0x0/0x103 @ 1
[   25.803304] initcall recent_mt_init+0x0/0x103 returned 0 after 0 usecs
[   25.806638] calling  sctp_mt_init+0x0/0x50 @ 1
[   25.809971] initcall sctp_mt_init+0x0/0x50 returned 0 after 0 usecs
[   25.813304] calling  tcpmss_mt_init+0x0/0x50 @ 1
[   25.816638] initcall tcpmss_mt_init+0x0/0x50 returned 0 after 0 usecs
[   25.819971] calling  u32_mt_init+0x0/0x40 @ 1
[   25.826638] initcall u32_mt_init+0x0/0x40 returned 0 after 0 usecs
[   25.829971] calling  sysctl_ipv4_init+0x0/0x76 @ 1
[   25.836638] initcall sysctl_ipv4_init+0x0/0x76 returned 0 after 3255 usecs
[   25.839971] calling  ipgre_init+0x0/0xe8 @ 1
[   25.843304] GRE over IPv4 tunneling driver
[   25.846638] device: 'gre0': device_add
[   25.853304] PM: Adding info for No Bus:gre0
[   25.856638] initcall ipgre_init+0x0/0xe8 returned 0 after 13020 usecs
[   25.859971] calling  init_syncookies+0x0/0x50 @ 1
[   25.863304] initcall init_syncookies+0x0/0x50 returned 0 after 0 usecs
[   25.866638] calling  ah4_init+0x0/0xa0 @ 1
[   25.869971] initcall ah4_init+0x0/0xa0 returned 0 after 0 usecs
[   25.873304] calling  esp4_init+0x0/0xa0 @ 1
[   25.876638] initcall esp4_init+0x0/0xa0 returned 0 after 0 usecs
[   25.879971] calling  xfrm4_beet_init+0x0/0x50 @ 1
[   25.883304] initcall xfrm4_beet_init+0x0/0x50 returned 0 after 0 usecs
[   25.886638] calling  tunnel4_init+0x0/0xa0 @ 1
[   25.889971] initcall tunnel4_init+0x0/0xa0 returned 0 after 0 usecs
[   25.893304] calling  xfrm4_transport_init+0x0/0x50 @ 1
[   25.896638] initcall xfrm4_transport_init+0x0/0x50 returned 0 after 0 usecs
[   25.899971] calling  ipv4_netfilter_init+0x0/0x50 @ 1
[   25.903304] initcall ipv4_netfilter_init+0x0/0x50 returned 0 after 0 usecs
[   25.906638] calling  inet_diag_init+0x0/0xc0 @ 1
[   25.909971] initcall inet_diag_init+0x0/0xc0 returned 0 after 0 usecs
[   25.913304] calling  tcp_diag_init+0x0/0x40 @ 1
[   25.916638] initcall tcp_diag_init+0x0/0x40 returned 0 after 0 usecs
[   25.919971] calling  tcpprobe_init+0x0/0x110 @ 1
[   25.929971] TCP probe registered (port=0)
[   25.933304] initcall tcpprobe_init+0x0/0x110 returned 0 after 9765 usecs
[   25.936638] calling  cubictcp_register+0x0/0x9d @ 1
[   25.939971] TCP cubic registered
[   25.943304] initcall cubictcp_register+0x0/0x9d returned 0 after 3255 usecs
[   25.946638] calling  xfrm_user_init+0x0/0x73 @ 1
[   25.949971] Initializing XFRM netlink socket
[   25.953304] initcall xfrm_user_init+0x0/0x73 returned 0 after 3255 usecs
[   25.956638] calling  inet6_init+0x0/0x330 @ 1
[   25.963304] NET: Registered protocol family 10
[   25.983304] initcall inet6_init+0x0/0x330 returned 0 after 22786 usecs
[   25.986638] calling  ah6_init+0x0/0xa0 @ 1
[   25.989971] initcall ah6_init+0x0/0xa0 returned 0 after 0 usecs
[   25.993304] calling  tunnel6_init+0x0/0xa0 @ 1
[   25.996638] initcall tunnel6_init+0x0/0xa0 returned 0 after 0 usecs
[   25.999971] calling  xfrm6_beet_init+0x0/0x50 @ 1
[   26.003304] initcall xfrm6_beet_init+0x0/0x50 returned 0 after 0 usecs
[   26.006638] calling  mip6_init+0x0/0xf0 @ 1
[   26.009971] Mobile IPv6
[   26.013304] initcall mip6_init+0x0/0xf0 returned 0 after 3255 usecs
[   26.016638] calling  ip6_tables_init+0x0/0xd1 @ 1
[   26.019971] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   26.023304] initcall ip6_tables_init+0x0/0xd1 returned 0 after 3255 usecs
[   26.026638] calling  ip6table_mangle_init+0x0/0x6f @ 1
[   26.029971] initcall ip6table_mangle_init+0x0/0x6f returned 0 after 0 usecs
[   26.033304] calling  ipv6header_mt6_init+0x0/0x40 @ 1
[   26.036638] initcall ipv6header_mt6_init+0x0/0x40 returned 0 after 0 usecs
[   26.039971] calling  mh_mt6_init+0x0/0x40 @ 1
[   26.043304] initcall mh_mt6_init+0x0/0x40 returned 0 after 0 usecs
[   26.046638] calling  hbh_mt6_init+0x0/0x50 @ 1
[   26.049971] initcall hbh_mt6_init+0x0/0x50 returned 0 after 0 usecs
[   26.053304] calling  rt_mt6_init+0x0/0x3d @ 1
[   26.056638] initcall rt_mt6_init+0x0/0x3d returned 0 after 0 usecs
[   26.059971] calling  sit_init+0x0/0x97 @ 1
[   26.063304] IPv6 over IPv4 tunneling driver
[   26.066638] device: 'sit0': device_add
[   26.069971] PM: Adding info for No Bus:sit0
[   26.076638] initcall sit_init+0x0/0x97 returned 0 after 13020 usecs
[   26.079971] calling  ip6_tunnel_init+0x0/0xc8 @ 1
[   26.083304] device: 'ip6tnl0': device_add
[   26.086638] PM: Adding info for No Bus:ip6tnl0
[   26.096638] initcall ip6_tunnel_init+0x0/0xc8 returned 0 after 13020 usecs
[   26.099971] calling  packet_init+0x0/0x74 @ 1
[   26.103304] NET: Registered protocol family 17
[   26.106638] initcall packet_init+0x0/0x74 returned 0 after 3255 usecs
[   26.109971] calling  br_init+0x0/0x100 @ 1
[   26.113304] Bridge firewalling registered
[   26.116638] initcall br_init+0x0/0x100 returned 0 after 3255 usecs
[   26.119971] calling  ipx_init+0x0/0x140 @ 1
[   26.123304] NET: Registered protocol family 4
[   26.126638] initcall ipx_init+0x0/0x140 returned 0 after 3255 usecs
[   26.129971] calling  init_sunrpc+0x0/0x9a @ 1
[   26.136638] RPC: Registered udp transport module.
[   26.139971] RPC: Registered tcp transport module.
[   26.143304] initcall init_sunrpc+0x0/0x9a returned 0 after 9765 usecs
[   26.146638] calling  init_rpcsec_gss+0x0/0x75 @ 1
[   26.149971] initcall init_rpcsec_gss+0x0/0x75 returned 0 after 0 usecs
[   26.153304] calling  init_kerberos_module+0x0/0x57 @ 1
[   26.156638] initcall init_kerberos_module+0x0/0x57 returned 0 after 0 usecs
[   26.159971] calling  af_rxrpc_init+0x0/0x1da @ 1
[   26.163304] NET: Registered protocol family 33
[   26.166638] initcall af_rxrpc_init+0x0/0x1da returned 0 after 3255 usecs
[   26.169971] calling  atm_clip_init+0x0/0xe5 @ 1
[   26.173304] initcall atm_clip_init+0x0/0xe5 returned 0 after 0 usecs
[   26.176638] calling  atm_mpoa_init+0x0/0x6b @ 1
[   26.179971] mpc.c: May 12 2009 18:29:43 initialized
[   26.183304] initcall atm_mpoa_init+0x0/0x6b returned 0 after 3255 usecs
[   26.186638] calling  sctp_init+0x0/0x85a @ 1
[   26.193304] SCTP: Hash tables configured (established 14563 bind 14563)
[   26.199971] sctp_init_sock(sk: ffff88003d51c000)
[   26.206638] initcall sctp_init+0x0/0x85a returned 0 after 16276 usecs
[   26.209971] calling  lib80211_init+0x0/0x50 @ 1
[   26.213304] lib80211: common routines for IEEE802.11 drivers
[   26.216638] lib80211_crypt: registered algorithm 'NULL'
[   26.219971] initcall lib80211_init+0x0/0x50 returned 0 after 6510 usecs
[   26.223304] calling  lib80211_crypto_wep_init+0x0/0x40 @ 1
[   26.226638] lib80211_crypt: registered algorithm 'WEP'
[   26.229971] initcall lib80211_crypto_wep_init+0x0/0x40 returned 0 after 3255 usecs
[   26.233304] calling  lib80211_crypto_ccmp_init+0x0/0x40 @ 1
[   26.236638] lib80211_crypt: registered algorithm 'CCMP'
[   26.239971] initcall lib80211_crypto_ccmp_init+0x0/0x40 returned 0 after 3255 usecs
[   26.243304] calling  lib80211_crypto_tkip_init+0x0/0x40 @ 1
[   26.246637] lib80211_crypt: registered algorithm 'TKIP'
[   26.249971] initcall lib80211_crypto_tkip_init+0x0/0x40 returned 0 after 3255 usecs
[   26.253304] calling  dcbnl_init+0x0/0x5d @ 1
[   26.256637] initcall dcbnl_init+0x0/0x5d returned 0 after 0 usecs
[   26.259971] calling  cpufreq_p4_init+0x0/0x90 @ 1
[   26.263304] initcall cpufreq_p4_init+0x0/0x90 returned -19 after 0 usecs
[   26.266637] calling  hpet_insert_resource+0x0/0x4a @ 1
[   26.269971] initcall hpet_insert_resource+0x0/0x4a returned 1 after 0 usecs
[   26.273304] initcall hpet_insert_resource+0x0/0x4a returned with error code 1 
[   26.276637] calling  lapic_insert_resource+0x0/0x6a @ 1
[   26.279971] initcall lapic_insert_resource+0x0/0x6a returned -1 after 0 usecs
[   26.283304] initcall lapic_insert_resource+0x0/0x6a returned with error code -1 
[   26.286637] calling  init_lapic_nmi_sysfs+0x0/0x60 @ 1
[   26.289971] initcall init_lapic_nmi_sysfs+0x0/0x60 returned 0 after 0 usecs
[   26.293304] calling  ioapic_insert_resources+0x0/0x90 @ 1
[   26.296637] initcall ioapic_insert_resources+0x0/0x90 returned 0 after 0 usecs
[   26.299971] calling  io_apic_bug_finalize+0x0/0x42 @ 1
[   26.303304] initcall io_apic_bug_finalize+0x0/0x42 returned 0 after 0 usecs
[   26.306637] calling  check_early_ioremap_leak+0x0/0xa0 @ 1
[   26.309971] initcall check_early_ioremap_leak+0x0/0xa0 returned 0 after 0 usecs
[   26.313304] calling  pat_memtype_list_init+0x0/0x50 @ 1
[   26.316637] initcall pat_memtype_list_init+0x0/0x50 returned 0 after 0 usecs
[   26.319971] calling  sched_init_debug+0x0/0x4d @ 1
[   26.323304] initcall sched_init_debug+0x0/0x4d returned 0 after 0 usecs
[   26.326637] calling  init_oops_id+0x0/0x70 @ 1
[   26.329971] initcall init_oops_id+0x0/0x70 returned 0 after 0 usecs
[   26.333304] calling  disable_boot_consoles+0x0/0x5f @ 1
[   26.336637] initcall disable_boot_consoles+0x0/0x5f returned 0 after 0 usecs
[   26.339971] calling  pm_qos_power_init+0x0/0x108 @ 1
[   26.343304] device: 'cpu_dma_latency': device_add
[   26.346637] PM: Adding info for No Bus:cpu_dma_latency
[   26.353304] device: 'network_latency': device_add
[   26.356637] PM: Adding info for No Bus:network_latency
[   26.359971] device: 'network_throughput': device_add
[   26.363304] PM: Adding info for No Bus:network_throughput
[   26.366637] initcall pm_qos_power_init+0x0/0x108 returned 0 after 22786 usecs
[   26.369971] calling  debugfs_kprobe_init+0x0/0xb0 @ 1
[   26.373304] initcall debugfs_kprobe_init+0x0/0xb0 returned 0 after 0 usecs
[   26.376637] calling  taskstats_init+0x0/0xbe @ 1
[   26.379971] registered taskstats version 1
[   26.383304] initcall taskstats_init+0x0/0xbe returned 0 after 3255 usecs
[   26.386637] calling  clear_boot_tracer+0x0/0x54 @ 1
[   26.389971] initcall clear_boot_tracer+0x0/0x54 returned 0 after 0 usecs
[   26.393304] calling  event_trace_self_tests_init+0x0/0x60 @ 1
[   26.396637] Running tests on trace events:
[   26.399971] Testing event kfree_skb: OK
[   26.409971] Testing event kmalloc: OK
[   26.419971] Testing event kmem_cache_alloc: OK
[   26.429971] Testing event kmalloc_node: OK
[   26.439971] Testing event kmem_cache_alloc_node: OK
[   26.449971] Testing event kfree: OK
[   26.459971] Testing event kmem_cache_free: OK
[   26.469971] Testing event dump_pages: OK
[   26.479971] Testing event lock_acquire: OK
[   26.489971] Testing event lock_release: OK
[   26.499971] Testing event lock_contended: OK
[   26.509971] Testing event lock_acquired: OK
[   26.519971] Testing event irq_handler_entry: OK
[   26.529971] Testing event irq_handler_exit: OK
[   26.539971] Testing event softirq_entry: OK
[   26.549971] Testing event softirq_exit: OK
[   26.559971] Testing event sched_kthread_stop: OK
[   26.569971] Testing event sched_kthread_stop_ret: OK
[   26.579971] Testing event sched_wait_task: OK
[   26.589971] Testing event sched_wakeup: OK
[   26.599971] Testing event sched_wakeup_new: OK
[   26.609971] Testing event sched_switch: OK
[   26.619971] Testing event sched_migrate_task: OK
[   26.629971] Testing event sched_process_free: OK
[   26.639971] Testing event sched_process_exit: OK
[   26.649971] Testing event sched_process_wait: OK
[   26.659971] Testing event sched_process_fork: OK
[   26.669971] Testing event sched_signal_send: OK
[   26.679971] Running tests on trace event systems:
[   26.683304] Testing event system skb: OK
[   26.693304] Testing event system kmem: OK
[   26.703304] Testing event system mm: OK
[   26.713304] Testing event system lockdep: OK
[   26.723304] Testing event system irq: OK
[   26.733304] Testing event system sched: OK
[   26.743304] Running tests on all trace events:
[   26.746637] Testing all events: OK
[   26.756637] Running tests again, along with the function tracer
[   26.759971] Running tests on trace events:
[   26.763304] Testing event kfree_skb: OK
[   26.773304] Testing event kmalloc: OK
[   26.783304] Testing event kmem_cache_alloc: OK
[   26.793304] Testing event kmalloc_node: OK
[   26.803304] Testing event kmem_cache_alloc_node: OK
[   26.813304] Testing event kfree: OK
[   26.823304] Testing event kmem_cache_free: OK
[   26.833304] Testing event dump_pages: OK
[   26.843304] Testing event lock_acquire: OK
[   26.853304] Testing event lock_release: OK
[   26.863304] Testing event lock_contended: OK
[   26.873304] Testing event lock_acquired: OK
[   26.883304] Testing event irq_handler_entry: OK
[   26.893304] Testing event irq_handler_exit: OK
[   26.903304] Testing event softirq_entry: OK
[   26.913304] Testing event softirq_exit: OK
[   26.923304] Testing event sched_kthread_stop: OK
[   26.933304] Testing event sched_kthread_stop_ret: OK
[   26.943304] Testing event sched_wait_task: OK
[   26.953304] Testing event sched_wakeup: OK
[   26.963304] Testing event sched_wakeup_new: OK
[   26.973304] Testing event sched_switch: OK
[   26.983304] Testing event sched_migrate_task: OK
[   26.993304] Testing event sched_process_free: OK
[   27.003304] Testing event sched_process_exit: OK
[   27.013304] Testing event sched_process_wait: OK
[   27.023304] Testing event sched_process_fork: OK
[   27.033304] Testing event sched_signal_send: OK
[   27.043304] Running tests on trace event systems:
[   27.046637] Testing event system skb: OK
[   27.056637] Testing event system kmem: OK
[   27.066637] Testing event system mm: OK
[   27.076637] Testing event system lockdep: OK
[   27.086637] Testing event system irq: OK
[   27.096637] Testing event system sched: OK
[   27.106637] Running tests on all trace events:
[   27.109970] Testing all events: OK
[   27.123304] initcall event_trace_self_tests_init+0x0/0x60 returned 0 after 709635 usecs
[   27.126637] calling  afs_init+0x0/0x16d @ 1
[   27.129970] kAFS: Red Hat AFS client v0.1 registering.
[   27.133304] initcall afs_init+0x0/0x16d returned 0 after 3255 usecs
[   27.136637] calling  fail_make_request_debugfs+0x0/0x32 @ 1
[   27.139970] initcall fail_make_request_debugfs+0x0/0x32 returned -19 after 0 usecs
[   27.143304] calling  fail_io_timeout_debugfs+0x0/0x32 @ 1
[   27.146637] initcall fail_io_timeout_debugfs+0x0/0x32 returned -19 after 0 usecs
[   27.149970] calling  random32_reseed+0x0/0xcf @ 1
[   27.153304] initcall random32_reseed+0x0/0xcf returned 0 after 0 usecs
[   27.156637] calling  pci_resource_alignment_sysfs_init+0x0/0x45 @ 1
[   27.159970] initcall pci_resource_alignment_sysfs_init+0x0/0x45 returned 0 after 0 usecs
[   27.163304] calling  pci_sysfs_init+0x0/0x7d @ 1
[   27.166637] initcall pci_sysfs_init+0x0/0x7d returned 0 after 0 usecs
[   27.169970] calling  regulator_init_complete+0x0/0x17b @ 1
[   27.173304] initcall regulator_init_complete+0x0/0x17b returned 0 after 0 usecs
[   27.176637] calling  seqgen_init+0x0/0x40 @ 1
[   27.179970] initcall seqgen_init+0x0/0x40 returned 0 after 0 usecs
[   27.183304] calling  late_resume_init+0x0/0x1d0 @ 1
[   27.186637]   Magic number: 9:517:489
[   27.189970] initcall late_resume_init+0x0/0x1d0 returned 0 after 3255 usecs
[   27.193304] calling  hd_init+0x0/0x370 @ 1
[   27.196637] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   27.199970] initcall hd_init+0x0/0x370 returned -1 after 3255 usecs
[   27.203304] initcall hd_init+0x0/0x370 returned with error code -1 
[   27.206637] calling  scsi_complete_async_scans+0x0/0x240 @ 1
[   27.209970] initcall scsi_complete_async_scans+0x0/0x240 returned 0 after 0 usecs
[   27.213304] calling  memmap_init+0x0/0x10d @ 1
[   27.216637] initcall memmap_init+0x0/0x10d returned 0 after 0 usecs
[   27.219970] calling  pci_mmcfg_late_insert_resources+0x0/0x18b @ 1
[   27.223304] initcall pci_mmcfg_late_insert_resources+0x0/0x18b returned 1 after 0 usecs
[   27.226637] initcall pci_mmcfg_late_insert_resources+0x0/0x18b returned with error code 1 
[   27.229970] calling  init_net_drop_monitor+0x0/0x244 @ 1
[   27.233304] Initalizing network drop monitor service
[   27.236637] initcall init_net_drop_monitor+0x0/0x244 returned 0 after 3255 usecs
[   27.239970] calling  tcp_congestion_default+0x0/0x40 @ 1
[   27.243304] initcall tcp_congestion_default+0x0/0x40 returned 0 after 0 usecs
[   27.246637] calling  ip_auto_config+0x0/0x346 @ 1
[   27.249970] initcall ip_auto_config+0x0/0x346 returned 0 after 0 usecs
[   27.253304] calling  initialize_hashrnd+0x0/0x40 @ 1
[   27.256637] initcall initialize_hashrnd+0x0/0x40 returned 0 after 0 usecs
[   27.259970] async_waiting @ 1
[   27.263304] async_continuing @ 1 after 0 usec
[   27.269970] EXT3-fs: INFO: recovery required on readonly filesystem.
[   27.273304] EXT3-fs: write access will be enabled during recovery.
[   27.359970] kjournald starting.  Commit interval 5 seconds
[   27.363304] EXT3-fs: recovery complete.
[   27.366637] EXT3-fs: mounted filesystem with ordered data mode.
[   27.369970] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[   27.373304] async_waiting @ 1
[   27.376637] async_continuing @ 1 after 0 usec
[   27.379970] Freeing unused kernel memory: 2420k freed
[   27.426637] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
[   28.039970] runlevel used greatest stack depth: 3976 bytes left
[   28.219970] mount used greatest stack depth: 3144 bytes left
[   55.933302] EXT3 FS on sda1, internal journal
[   57.676635] device: 'vcs3': device_add
[   57.676635] PM: Adding info for No Bus:vcs3
[   57.689969] device: 'vcsa3': device_add
[   57.689969] PM: Adding info for No Bus:vcsa3
[   57.699969] device: 'vcs4': device_add
[   57.699969] PM: Adding info for No Bus:vcs4
[   57.713302] device: 'vcsa4': device_add
[   57.713302] PM: Adding info for No Bus:vcsa4
[   57.719969] device: 'vcs5': device_add
[   57.719969] PM: Adding info for No Bus:vcs5
[   57.729969] device: 'vcsa5': device_add
[   57.729969] PM: Adding info for No Bus:vcsa5
[   57.743302] device: 'vcs6': device_add
[   57.743302] PM: Adding info for No Bus:vcs6
[   57.749969] device: 'vcsa6': device_add
[   57.749969] PM: Adding info for No Bus:vcsa6
[   57.756635] device: 'vcs2': device_add
[   57.756635] PM: Adding info for No Bus:vcs2
[   57.766635] device: 'vcsa2': device_add
[   57.766635] PM: Adding info for No Bus:vcsa2
[   58.006635] warning: `sudo' uses deprecated v2 capabilities in a way that may be insecure.
[   58.279969] skge eth0: enabling interface
[   58.353302] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   60.963302] skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   60.969969] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   71.823302] eth0: no IPv6 routers present
