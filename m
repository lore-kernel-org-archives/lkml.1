Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZHILK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZHILK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZHILKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:10:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47920 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbZHILKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:10:40 -0400
Date: Sun, 9 Aug 2009 13:10:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add second diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090809111008.GA1829@elte.hu>
References: <20090806012645.GA24800@linux.vnet.ibm.com> <tip-86f044729ee3e4d8885c17371ce5a76f6f321dc7@git.kernel.org> <20090809110019.GA20236@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20090809110019.GA20236@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_00,URI_HEX autolearn=no SpamAssassin version=3.2.5
	0.4 URI_HEX                URI: URI hostname has long hexadecimal sequence
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> > rcu: Add second diagnostic check for a possible CPU-hotplug race
> 
> has a build problem too:
> 
>  kernel/built-in.o: In function `rcu_cpu_notified':
>  (.text+0x1d787): undefined reference to `cpu_notified'
>  kernel/built-in.o: In function `rcu_init':
>  (.init.text+0x1174): undefined reference to `cpu_notified'
>  kernel/built-in.o: In function `rcu_init':
>  (.init.text+0x11a8): undefined reference to `cpu_notified'
> 
> Maybe we should simplify all those Kconfig rules? It's a maze.

a testbox still managed to sneak in, build another config, boot it 
and trigger the warning below - is this what you were after? Bootlog 
below, config attached.

	Ingo

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc5-tip (mingo@europe) (gcc version 4.2.2) #7134 SMP Sun Aug 9 13:04:19 CEST 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6e0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6e0000 - 000000007f6f3000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f6f3000 - 000000007f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x7f6e0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f6e0000 (usable)
[    0.000000]  modified: 000000007f6e0000 - 000000007f6f3000 (ACPI data)
[    0.000000]  modified: 000000007f6f3000 - 000000007f700000 (ACPI NVS)
[    0.000000]  modified: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000f68a0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 7f6e631f 00074 (v01 LENOVO TP-79    00001020  LTP 00000000)
[    0.000000] ACPI: FACP 7f6e6400 000F4 (v03 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 20090521 tbfadt-527
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 000000000000102C/0 20090521 tbfadt-558
[    0.000000] ACPI: DSDT 7f6e65e7 0C765 (v01 LENOVO TP-79    00001020 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f6f4000 00040
[    0.000000] ACPI: SSDT 7f6e65b4 00033 (v01 LENOVO TP-79    00001020 MSFT 0100000E)
[    0.000000] ACPI: ECDT 7f6f2d4c 00052 (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: TCPA 7f6f2d9e 00032 (v02 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: APIC 7f6f2dd0 00068 (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: MCFG 7f6f2e38 0003E (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: HPET 7f6f2e76 00038 (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: BOOT 7f6f2fd8 00028 (v01 LENOVO TP-79    00001020  LTP 00000001)
[    0.000000] ACPI: SSDT 7f6e58da 00507 (v01 LENOVO TP-79    00001020 INTL 20050513)
[    0.000000] ACPI: SSDT 7f6e5702 001D8 (v01 LENOVO TP-79    00001020 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00018150c8]    TEXT DATA BSS ==> [0001000000 - 00018150c8]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0001816000 - 000181d138]              BRK ==> [0001816000 - 000181d138]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f68e0] f68e0
[    0.000000]   mpc: 9f5a1-9f6b5
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f6e0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f6e0
[    0.000000] On node 0 totalpages: 521851
[    0.000000] free_area_init_node: node 0, pgdat c16f3c20, node_mem_map c181e000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2302 pages used for memmap
[    0.000000]   HighMem zone: 292324 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
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
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c2818000, static data 33436 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517773
[    0.000000] Kernel command line: root=/dev/sda1 console=tty profile=0 debug initcall_debug enforcing=0 apic=verbose sysrq_always_enabled ignore_loglevel selinux=1 relaxed_check=1 3 netconsole=4444@10.0.1.15/eth0,4444@10.0.1.21/00:30:48:c6:86:26
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f6e0)
[    0.000000] Memory: 2061020k/2087808k available (4496k kernel code, 25604k reserved, 2686k data, 376k init, 1178504k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc170b000 - 0xc1769000   ( 376 kB)
[    0.000000]       .data : 0xc14643fd - 0xc1703f68   (2686 kB)
[    0.000000]       .text : 0xc1000000 - 0xc14643fd   (4496 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/rcupdate.c:259 rcu_init+0x2b/0xa0()
[    0.000000] Hardware name: 1951A26
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc5-tip #7134
[    0.000000] Call Trace:
[    0.000000]  [<c102ec3b>] warn_slowpath_common+0x60/0x77
[    0.000000]  [<c102ec5f>] warn_slowpath_null+0xd/0x10
[    0.000000]  [<c171c929>] rcu_init+0x2b/0xa0
[    0.000000]  [<c170b6f3>] start_kernel+0x184/0x2ca
[    0.000000]  [<c170b06a>] __init_begin+0x6a/0x6f
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1828.477 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 3656.95 BogoMIPS (lpj=1828477)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] Initializing cgroup subsys ns
[    0.000999] Initializing cgroup subsys cpuacct
[    0.001013] Initializing cgroup subsys freezer
[    0.001119] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001249] CPU: L2 cache: 2048K
[    0.001336] CPU: Physical Processor ID: 0
[    0.001422] CPU: Processor Core ID: 0
[    0.001510] mce: CPU supports 6 MCE banks
[    0.001605] CPU0: Thermal monitoring enabled (TM2)
[    0.001694] using mwait in idle threads.
[    0.001786] Performance Counters: no PMU driver, software counters only.
[    0.002005] Checking 'hlt' instruction... OK.
[    0.006584] ACPI: Core revision 20090521
[    0.027076] enabled ExtINT on CPU#0
[    0.028075] ENABLING IO-APIC IRQs
[    0.028161] init IO_APIC IRQs
[    0.028246]  1-0 (apicid-pin) not connected
[    0.028377] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.028508] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.028640] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.028772] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.028904] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.029001] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.029132] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.029264] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.029397] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.029528] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.029659] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.029791] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.029923] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.030000] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.030131] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.030261]  1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 (apicid-pin) not connected
[    0.030875] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.041069] CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.041248] Using local APIC timer interrupts.
[    0.041250] calibrating APIC timer ...
[    0.041993] ... lapic delta = 1039050
[    0.041993] ... PM-Timer delta = 357950
[    0.041993] ... PM-Timer result ok
[    0.041993] ..... delta 1039050
[    0.041993] ..... mult: 44633642
[    0.041993] ..... calibration result: 166248
[    0.041993] ..... CPU clock speed is 1828.0727 MHz.
[    0.041993] ..... host bus clock speed is 166.0248 MHz.
[    0.041993] calling  migration_init+0x0/0x47 @ 1
[    0.041993] initcall migration_init+0x0/0x47 returned 0 after 0 usecs
[    0.041993] calling  spawn_ksoftirqd+0x0/0x47 @ 1
[    0.041993] initcall spawn_ksoftirqd+0x0/0x47 returned 0 after 0 usecs
[    0.041993] calling  init_call_single_data+0x0/0x6d @ 1
[    0.041993] initcall init_call_single_data+0x0/0x6d returned 0 after 0 usecs
[    0.041993] calling  relay_init+0x0/0x11 @ 1
[    0.041993] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.041993] calling  tracer_alloc_buffers+0x0/0x12d @ 1
[    0.041993] initcall tracer_alloc_buffers+0x0/0x12d returned 0 after 0 usecs
[    0.041998] calling  init_trace_printk+0x0/0xf @ 1
[    0.042087] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.042253] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] masked ExtINT on CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3657.34 BogoMIPS (lpj=1828674)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.113434] CPU1: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.114126] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.114982] Measured 579865 cycles TSC warp between CPUs, turning off TSC clock.
[    0.114982] Marking TSC unstable due to check_tsc_sync_source failed
[    0.115008] Brought up 2 CPUs
[    0.115095] Total of 2 processors activated (7314.30 BogoMIPS).
[    0.116092] khelper used greatest stack depth: 6944 bytes left
[    0.116167] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.116167] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.116275] calling  net_ns_init+0x0/0xc0 @ 1
[    0.116384] initcall net_ns_init+0x0/0xc0 returned 0 after 0 usecs
[    0.116384] calling  e820_mark_nvs_memory+0x0/0x37 @ 1
[    0.116989] initcall e820_mark_nvs_memory+0x0/0x37 returned 0 after 0 usecs
[    0.117084] calling  cpufreq_tsc+0x0/0x25 @ 1
[    0.117172] initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
[    0.117265] calling  pci_reboot_init+0x0/0x11 @ 1
[    0.117355] initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.117447] calling  reboot_init+0x0/0x11 @ 1
[    0.117540] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.117633] calling  init_lapic_sysfs+0x0/0x28 @ 1
[    0.117730] initcall init_lapic_sysfs+0x0/0x28 returned 0 after 0 usecs
[    0.117989] calling  init_smp_flush+0x0/0x20 @ 1
[    0.118078] initcall init_smp_flush+0x0/0x20 returned 0 after 0 usecs
[    0.118172] calling  alloc_frozen_cpus+0x0/0x9 @ 1
[    0.118262] initcall alloc_frozen_cpus+0x0/0x9 returned 0 after 0 usecs
[    0.118355] calling  sysctl_init+0x0/0x29 @ 1
[    0.118584] initcall sysctl_init+0x0/0x29 returned 0 after 0 usecs
[    0.118676] calling  ksysfs_init+0x0/0x96 @ 1
[    0.118773] initcall ksysfs_init+0x0/0x96 returned 0 after 0 usecs
[    0.118865] calling  async_init+0x0/0x3c @ 1
[    0.118954] initcall async_init+0x0/0x3c returned 0 after 0 usecs
[    0.118986] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.119078] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.119206] calling  pm_init+0x0/0x2d @ 1
[    0.119299] initcall pm_init+0x0/0x2d returned 0 after 0 usecs
[    0.119389] calling  pm_disk_init+0x0/0x14 @ 1
[    0.119480] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    0.119573] calling  swsusp_header_init+0x0/0x26 @ 1
[    0.119663] initcall swsusp_header_init+0x0/0x26 returned 0 after 0 usecs
[    0.119756] calling  init_hw_breakpoint+0x0/0xf @ 1
[    0.119848] initcall init_hw_breakpoint+0x0/0xf returned 0 after 0 usecs
[    0.119986] calling  filelock_init+0x0/0x27 @ 1
[    0.120075] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.120167] calling  init_misc_binfmt+0x0/0x35 @ 1
[    0.120259] initcall init_misc_binfmt+0x0/0x35 returned 0 after 0 usecs
[    0.120351] calling  init_script_binfmt+0x0/0x11 @ 1
[    0.120442] initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.120534] calling  init_elf_binfmt+0x0/0x11 @ 1
[    0.120623] initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.120716] calling  debugfs_init+0x0/0x4a @ 1
[    0.120808] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    0.120901] calling  random32_init+0x0/0xa4 @ 1
[    0.120985] initcall random32_init+0x0/0xa4 returned 0 after 0 usecs
[    0.121079] calling  early_resume_init+0x0/0x183 @ 1
[    0.121985] Time: 11:05:10  Date: 08/09/09
[    0.122072] initcall early_resume_init+0x0/0x183 returned 0 after 976 usecs
[    0.122164] calling  cpufreq_core_init+0x0/0x59 @ 1
[    0.122253] initcall cpufreq_core_init+0x0/0x59 returned 0 after 0 usecs
[    0.122345] calling  cpuidle_init+0x0/0x32 @ 1
[    0.122437] initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
[    0.122529] calling  sock_init+0x0/0x51 @ 1
[    0.122662] initcall sock_init+0x0/0x51 returned 0 after 0 usecs
[    0.122754] calling  net_inuse_init+0x0/0x1f @ 1
[    0.122845] initcall net_inuse_init+0x0/0x1f returned 0 after 0 usecs
[    0.122937] calling  netpoll_init+0x0/0x11 @ 1
[    0.122985] initcall netpoll_init+0x0/0x11 returned 0 after 0 usecs
[    0.123077] calling  netlink_proto_init+0x0/0x102 @ 1
[    0.123170] NET: Registered protocol family 16
[    0.123269] initcall netlink_proto_init+0x0/0x102 returned 0 after 0 usecs
[    0.123362] calling  bdi_class_init+0x0/0x35 @ 1
[    0.123464] initcall bdi_class_init+0x0/0x35 returned 0 after 0 usecs
[    0.123464] calling  kobject_uevent_init+0x0/0x4e @ 1
[    0.123464] initcall kobject_uevent_init+0x0/0x4e returned 0 after 0 usecs
[    0.123464] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.123464] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.123992] calling  pci_driver_init+0x0/0xf @ 1
[    0.124091] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    0.124091] calling  backlight_class_init+0x0/0x4d @ 1
[    0.124182] initcall backlight_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.124182] calling  video_output_class_init+0x0/0x14 @ 1
[    0.124182] initcall video_output_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.124182] calling  tty_class_init+0x0/0x28 @ 1
[    0.124212] initcall tty_class_init+0x0/0x28 returned 0 after 0 usecs
[    0.124987] calling  vtconsole_class_init+0x0/0xa1 @ 1
[    0.125087] initcall vtconsole_class_init+0x0/0xa1 returned 0 after 0 usecs
[    0.125087] calling  i2c_init+0x0/0x54 @ 1
[    0.125177] initcall i2c_init+0x0/0x54 returned 0 after 0 usecs
[    0.125177] calling  amd_postcore_init+0x0/0x66 @ 1
[    0.125177] initcall amd_postcore_init+0x0/0x66 returned 0 after 0 usecs
[    0.125260] calling  arch_kdebugfs_init+0x0/0x261 @ 1
[    0.125361] initcall arch_kdebugfs_init+0x0/0x261 returned 0 after 0 usecs
[    0.125986] calling  init_pit_clocksource+0x0/0x94 @ 1
[    0.126077] initcall init_pit_clocksource+0x0/0x94 returned 0 after 0 usecs
[    0.126170] calling  mtrr_if_init+0x0/0x44 @ 1
[    0.126261] initcall mtrr_if_init+0x0/0x44 returned 0 after 0 usecs
[    0.126353] calling  ffh_cstate_init+0x0/0x27 @ 1
[    0.126442] initcall ffh_cstate_init+0x0/0x27 returned 0 after 0 usecs
[    0.126535] calling  kdump_buf_page_init+0x0/0x54 @ 1
[    0.126626] initcall kdump_buf_page_init+0x0/0x54 returned 0 after 0 usecs
[    0.126719] calling  acpi_pci_init+0x0/0x4c @ 1
[    0.126807] ACPI: bus type pci registered
[    0.126895] initcall acpi_pci_init+0x0/0x4c returned 0 after 0 usecs
[    0.126983] calling  dmi_id_init+0x0/0x28f @ 1
[    0.127083] initcall dmi_id_init+0x0/0x28f returned 0 after 0 usecs
[    0.127083] calling  pci_arch_init+0x0/0x53 @ 1
[    0.127190] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.127283] PCI: MCFG area at f0000000 reserved in E820
[    0.127372] PCI: Using MMCONFIG for extended config space
[    0.127461] PCI: Using configuration type 1 for base access
[    0.127560] initcall pci_arch_init+0x0/0x53 returned 0 after 0 usecs
[    0.127653] calling  topology_init+0x0/0x36 @ 1
[    0.128010] initcall topology_init+0x0/0x36 returned 0 after 976 usecs
[    0.128103] calling  mtrr_init_finialize+0x0/0x35 @ 1
[    0.128193] initcall mtrr_init_finialize+0x0/0x35 returned 0 after 0 usecs
[    0.128287] calling  param_sysfs_init+0x0/0x1a6 @ 1
[    0.138109] initcall param_sysfs_init+0x0/0x1a6 returned 0 after 9764 usecs
[    0.138109] calling  pm_sysrq_init+0x0/0x16 @ 1
[    0.138195] initcall pm_sysrq_init+0x0/0x16 returned 0 after 0 usecs
[    0.138287] calling  audit_watch_init+0x0/0x27 @ 1
[    0.138376] initcall audit_watch_init+0x0/0x27 returned 0 after 0 usecs
[    0.138469] calling  default_bdi_init+0x0/0x2f @ 1
[    0.138584] initcall default_bdi_init+0x0/0x2f returned 0 after 0 usecs
[    0.138584] calling  init_bio+0x0/0xc0 @ 1
[    0.139024] bio: create slab <bio-0> at 0
[    0.139118] initcall init_bio+0x0/0xc0 returned 0 after 0 usecs
[    0.139210] calling  fsnotify_init+0x0/0xf @ 1
[    0.139300] initcall fsnotify_init+0x0/0xf returned 0 after 0 usecs
[    0.139392] calling  fsnotify_notification_init+0x0/0x5b @ 1
[    0.139485] initcall fsnotify_notification_init+0x0/0x5b returned 0 after 0 usecs
[    0.139615] calling  cryptomgr_init+0x0/0xf @ 1
[    0.139704] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    0.139795] calling  blk_settings_init+0x0/0x1d @ 1
[    0.139885] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    0.140016] calling  blk_ioc_init+0x0/0x24 @ 1
[    0.140106] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    0.140198] calling  blk_softirq_init+0x0/0x5b @ 1
[    0.140288] initcall blk_softirq_init+0x0/0x5b returned 0 after 0 usecs
[    0.140379] calling  genhd_device_init+0x0/0x50 @ 1
[    0.140516] initcall genhd_device_init+0x0/0x50 returned 0 after 0 usecs
[    0.140516] calling  pci_slot_init+0x0/0x3b @ 1
[    0.140516] initcall pci_slot_init+0x0/0x3b returned 0 after 0 usecs
[    0.140516] calling  fbmem_init+0x0/0x78 @ 1
[    0.140516] initcall fbmem_init+0x0/0x78 returned 0 after 0 usecs
[    0.141018] calling  acpi_init+0x0/0x25e @ 1
[    0.142435] ACPI: EC: EC description table is found, configuring boot EC
[    0.150150] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.156229] ACPI: Interpreter enabled
[    0.156318] ACPI: (supports S0 S3 S4 S5)
[    0.156596] ACPI: Using IOAPIC for interrupt routing
[    0.173122] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.173215] ACPI: EC: driver started in interrupt mode
[    0.173323] ACPI: Power Resource [PUBS] (on)
[    0.174221] initcall acpi_init+0x0/0x25e returned 0 after 32221 usecs
[    0.174314] calling  dock_init+0x0/0x7d @ 1
[    0.177366] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.177460] initcall dock_init+0x0/0x7d returned 0 after 2929 usecs
[    0.177553] calling  acpi_pci_root_init+0x0/0x25 @ 1
[    0.177668] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.177785] pci 0000:00:02.0: reg 10 32bit mmio: [0xee100000-0xee17ffff]
[    0.177979] pci 0000:00:02.0: reg 14 io port: [0x1800-0x1807]
[    0.178072] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.178166] pci 0000:00:02.0: reg 1c 32bit mmio: [0xee200000-0xee23ffff]
[    0.178296] pci 0000:00:02.1: reg 10 32bit mmio: [0xee180000-0xee1fffff]
[    0.178500] pci 0000:00:1b.0: reg 10 64bit mmio: [0xee240000-0xee243fff]
[    0.178650] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.178743] pci 0000:00:1b.0: PME# disabled
[    0.178913] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.178978] pci 0000:00:1c.0: PME# disabled
[    0.179149] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.179243] pci 0000:00:1c.1: PME# disabled
[    0.179414] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.179508] pci 0000:00:1c.2: PME# disabled
[    0.179678] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.179771] pci 0000:00:1c.3: PME# disabled
[    0.179919] pci 0000:00:1d.0: reg 20 io port: [0x1820-0x183f]
[    0.180039] pci 0000:00:1d.1: reg 20 io port: [0x1840-0x185f]
[    0.180191] pci 0000:00:1d.2: reg 20 io port: [0x1860-0x187f]
[    0.180342] pci 0000:00:1d.3: reg 20 io port: [0x1880-0x189f]
[    0.180498] pci 0000:00:1d.7: reg 10 32bit mmio: [0xee444000-0xee4443ff]
[    0.180649] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.180744] pci 0000:00:1d.7: PME# disabled
[    0.181077] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.181209] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.181303] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.181435] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.181567] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.181748] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.181843] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.181939] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.181980] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.182075] pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
[    0.182227] pci 0000:00:1f.2: reg 10 io port: [0x18d0-0x18d7]
[    0.182323] pci 0000:00:1f.2: reg 14 io port: [0x18c4-0x18c7]
[    0.182419] pci 0000:00:1f.2: reg 18 io port: [0x18c8-0x18cf]
[    0.182514] pci 0000:00:1f.2: reg 1c io port: [0x18c0-0x18c3]
[    0.182610] pci 0000:00:1f.2: reg 20 io port: [0x18b0-0x18bf]
[    0.182705] pci 0000:00:1f.2: reg 24 32bit mmio: [0xee444400-0xee4447ff]
[    0.182833] pci 0000:00:1f.2: PME# supported from D3hot
[    0.182977] pci 0000:00:1f.2: PME# disabled
[    0.183126] pci 0000:00:1f.3: reg 20 io port: [0x18e0-0x18ff]
[    0.183388] pci 0000:02:00.0: reg 10 32bit mmio: [0xee000000-0xee01ffff]
[    0.183563] pci 0000:02:00.0: reg 18 io port: [0x2000-0x201f]
[    0.183819] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.183977] pci 0000:02:00.0: PME# disabled
[    0.184201] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.184295] pci 0000:00:1c.0: bridge 32bit mmio: [0xee000000-0xee0fffff]
[    0.184575] pci 0000:03:00.0: reg 10 32bit mmio: [0xedf00000-0xedf00fff]
[    0.184946] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.185025] pci 0000:03:00.0: PME# disabled
[    0.185254] pci 0000:00:1c.1: bridge io port: [0x3000-0x4fff]
[    0.185348] pci 0000:00:1c.1: bridge 32bit mmio: [0xec000000-0xedffffff]
[    0.185446] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xe4000000-0xe40fffff]
[    0.185596] pci 0000:00:1c.2: bridge io port: [0x5000-0x6fff]
[    0.185690] pci 0000:00:1c.2: bridge 32bit mmio: [0xe8000000-0xe9ffffff]
[    0.185789] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xe4100000-0xe41fffff]
[    0.186016] pci 0000:00:1c.3: bridge io port: [0x7000-0x8fff]
[    0.186109] pci 0000:00:1c.3: bridge 32bit mmio: [0xea000000-0xebffffff]
[    0.186206] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xe4200000-0xe42fffff]
[    0.186352] pci 0000:15:00.0: reg 10 32bit mmio: [0xe4300000-0xe4300fff]
[    0.186471] pci 0000:15:00.0: supports D1 D2
[    0.186558] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.186653] pci 0000:15:00.0: PME# disabled
[    0.186808] pci 0000:00:1e.0: transparent bridge
[    0.186898] pci 0000:00:1e.0: bridge io port: [0x9000-0xcfff]
[    0.186980] pci 0000:00:1e.0: bridge 32bit mmio: [0xe4300000-0xe7ffffff]
[    0.187845] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xe0000000-0xe3ffffff]
[    0.188012] pci_bus 0000:00: on NUMA node 0
[    0.188103] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.188345] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.188515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.188683] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.188857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.189037] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.194071] initcall acpi_pci_root_init+0x0/0x25 returned 0 after 16599 usecs
[    0.194071] calling  acpi_pci_link_init+0x0/0x3f @ 1
[    0.194320] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.195402] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.196167] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.196895] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.197608] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.198349] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.199103] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.199834] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.200436] initcall acpi_pci_link_init+0x0/0x3f returned 0 after 5858 usecs
[    0.200436] calling  pnp_init+0x0/0xf @ 1
[    0.200436] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    0.200436] calling  misc_init+0x0/0x92 @ 1
[    0.200436] initcall misc_init+0x0/0x92 returned 0 after 0 usecs
[    0.200979] calling  cn_init+0x0/0xcb @ 1
[    0.201078] initcall cn_init+0x0/0xcb returned 0 after 0 usecs
[    0.201170] calling  init_scsi+0x0/0x84 @ 1
[    0.201338] SCSI subsystem initialized
[    0.201338] initcall init_scsi+0x0/0x84 returned 0 after 0 usecs
[    0.201338] calling  ata_init+0x0/0x29d @ 1
[    0.201338] libata version 3.00 loaded.
[    0.201338] initcall ata_init+0x0/0x29d returned 0 after 0 usecs
[    0.201975] calling  phy_init+0x0/0x29 @ 1
[    0.202074] initcall phy_init+0x0/0x29 returned 0 after 0 usecs
[    0.202074] calling  init_pcmcia_cs+0x0/0x1e @ 1
[    0.202163] initcall init_pcmcia_cs+0x0/0x1e returned 0 after 0 usecs
[    0.202163] calling  usb_init+0x0/0x177 @ 1
[    0.202177] usbcore: registered new interface driver usbfs
[    0.202177] usbcore: registered new interface driver hub
[    0.203006] usbcore: registered new device driver usb
[    0.203063] initcall usb_init+0x0/0x177 returned 0 after 976 usecs
[    0.203155] calling  serio_init+0x0/0x82 @ 1
[    0.203252] initcall serio_init+0x0/0x82 returned 0 after 0 usecs
[    0.203252] calling  input_init+0x0/0xfb @ 1
[    0.203252] initcall input_init+0x0/0xfb returned 0 after 0 usecs
[    0.203252] calling  rtc_init+0x0/0x5e @ 1
[    0.203252] initcall rtc_init+0x0/0x5e returned 0 after 0 usecs
[    0.203973] calling  power_supply_class_init+0x0/0x2b @ 1
[    0.204074] initcall power_supply_class_init+0x0/0x2b returned 0 after 0 usecs
[    0.204101] calling  hwmon_init+0x0/0xe9 @ 1
[    0.204202] initcall hwmon_init+0x0/0xe9 returned 0 after 0 usecs
[    0.204202] calling  thermal_init+0x0/0x32 @ 1
[    0.204202] initcall thermal_init+0x0/0x32 returned 0 after 0 usecs
[    0.204202] calling  md_init+0x0/0xb5 @ 1
[    0.204202] initcall md_init+0x0/0xb5 returned 0 after 0 usecs
[    0.204252] calling  leds_init+0x0/0x32 @ 1
[    0.204983] initcall leds_init+0x0/0x32 returned 0 after 0 usecs
[    0.205065] calling  pci_subsys_init+0x0/0xdf @ 1
[    0.205153] PCI: Using ACPI for IRQ routing
[    0.205553] initcall pci_subsys_init+0x0/0xdf returned 0 after 0 usecs
[    0.205646] calling  proto_init+0x0/0xf @ 1
[    0.205736] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    0.205827] calling  net_dev_init+0x0/0x142 @ 1
[    0.206028] initcall net_dev_init+0x0/0x142 returned 0 after 0 usecs
[    0.206075] calling  neigh_init+0x0/0x66 @ 1
[    0.206164] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    0.206256] calling  fib_rules_init+0x0/0x99 @ 1
[    0.206346] initcall fib_rules_init+0x0/0x99 returned 0 after 0 usecs
[    0.206439] calling  pktsched_init+0x0/0xa9 @ 1
[    0.206530] initcall pktsched_init+0x0/0xa9 returned 0 after 0 usecs
[    0.206622] calling  tc_filter_init+0x0/0x43 @ 1
[    0.206712] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    0.206804] calling  tc_action_init+0x0/0x43 @ 1
[    0.206972] initcall tc_action_init+0x0/0x43 returned 0 after 0 usecs
[    0.207065] calling  genl_init+0x0/0xb0 @ 1
[    0.208976] initcall genl_init+0x0/0xb0 returned 0 after 1952 usecs
[    0.209068] calling  cipso_v4_init+0x0/0x52 @ 1
[    0.209159] initcall cipso_v4_init+0x0/0x52 returned 0 after 0 usecs
[    0.209250] calling  wireless_nlevent_init+0x0/0x2f @ 1
[    0.209341] initcall wireless_nlevent_init+0x0/0x2f returned 0 after 0 usecs
[    0.209436] calling  cfg80211_init+0x0/0x64 @ 1
[    0.219994] cfg80211: Using static regulatory domain info
[    0.220082] cfg80211: Regulatory domain: US
[    0.220169] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.220298] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.220391] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.220485] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.220577] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.220669] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.220762] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.220858] cfg80211: Calling CRDA for country: US
[    0.220985] initcall cfg80211_init+0x0/0x64 returned 0 after 11716 usecs
[    0.221068] calling  ieee80211_init+0x0/0xa @ 1
[    0.221158] initcall ieee80211_init+0x0/0xa returned 0 after 0 usecs
[    0.221250] calling  netlbl_init+0x0/0x6d @ 1
[    0.221336] NetLabel: Initializing
[    0.221421] NetLabel:  domain hash size = 128
[    0.221508] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.221610] NetLabel:  unlabeled traffic allowed by default
[    0.221702] initcall netlbl_init+0x0/0x6d returned 0 after 0 usecs
[    0.221793] calling  rfkill_init+0x0/0x75 @ 1
[    0.222006] initcall rfkill_init+0x0/0x75 returned 0 after 976 usecs
[    0.222087] calling  sysctl_init+0x0/0x3b @ 1
[    0.222175] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    0.222267] calling  pci_iommu_init+0x0/0xc @ 1
[    0.222356] initcall pci_iommu_init+0x0/0xc returned 0 after 0 usecs
[    0.222449] calling  print_all_ICs+0x0/0x441 @ 1
[    0.222538] 
[    0.222539] printing PIC contents
[    0.222707] ... PIC  IMR: ffff
[    0.222795] ... PIC  IRR: 0800
[    0.222888] ... PIC  ISR: 0000
[    0.222972] ... PIC ELCR: 0800
[    0.223058] printing local APIC contents on CPU#0/0:
[    0.223146] ... APIC ID:      00000000 (0)
[    0.223233] ... APIC VERSION: 00050014
[    0.223318] ... APIC TASKPRI: 00000000 (00)
[    0.223406] ... APIC PROCPRI: 00000000
[    0.223491] ... APIC LDR: 01000000
[    0.223576] ... APIC DFR: ffffffff
[    0.223661] ... APIC SPIV: 000001ff
[    0.223747] ... APIC ISR field:
[    0.223832] 0000000000000000000000000000000000000000000000000000000000000000
[    0.223965] ... APIC TMR field:
[    0.223965] 0000000002000000000000000000000000000000000000000000000000000000
[    0.223965] ... APIC IRR field:
[    0.223965] 0000000000000000000000000000000000000000000000000000000000008000
[    0.223965] ... APIC ESR: 00000000
[    0.223965] ... APIC ICR: 000008fb
[    0.223965] ... APIC ICR2: 02000000
[    0.223965] ... APIC LVTT: 000200ef
[    0.223965] ... APIC LVTPC: 00010000
[    0.223965] ... APIC LVT0: 00010700
[    0.223965] ... APIC LVT1: 00000400
[    0.223965] ... APIC LVTERR: 000000fe
[    0.223965] ... APIC TMICT: 00002896
[    0.223965] ... APIC TMCCT: 000021a7
[    0.223965] ... APIC TDCR: 00000003
[    0.223965] 
[    0.223577] printing local APIC contents on CPU#1/1:
[    0.223668] ... APIC ID:      01000000 (1)
[    0.223754] ... APIC VERSION: 00050014
[    0.223840] ... APIC TASKPRI: 00000000 (00)
[    0.223928] ... APIC PROCPRI: 00000000
[    0.223965] ... APIC LDR: 02000000
[    0.223965] ... APIC DFR: ffffffff
[    0.223965] ... APIC SPIV: 000001ff
[    0.223965] ... APIC ISR field:
[    0.223965] 0000000000000000000000000000000000000000000000000000000000000000
[    0.223965] ... APIC TMR field:
[    0.223965] 0000000000000000000000000000000000000000000000000000000000000000
[    0.223965] ... APIC IRR field:
[    0.223965] 0000000000000000000000000000000000000000000000000000000000008000
[    0.223965] ... APIC ESR: 00000000
[    0.223965] ... APIC ICR: 000008fd
[    0.223965] ... APIC ICR2: 01000000
[    0.223965] ... APIC LVTT: 000200ef
[    0.223965] ... APIC LVTPC: 00010000
[    0.223965] ... APIC LVT0: 00010700
[    0.223965] ... APIC LVT1: 00010400
[    0.223965] ... APIC LVTERR: 000000fe
[    0.223965] ... APIC TMICT: 00002896
[    0.223965] ... APIC TMCCT: 00000f04
[    0.223965] ... APIC TDCR: 00000003
[    0.223965] 
[    0.227664] number of MP IRQ sources: 15.
[    0.227752] number of IO-APIC #1 registers: 24.
[    0.227839] testing the IO APIC.......................
[    0.227933] 
[    0.227967] IO APIC #1......
[    0.228050] .... register #00: 02000000
[    0.228136] .......    : physical APIC id: 02
[    0.228223] .......    : Delivery Type: 0
[    0.228309] .......    : LTS          : 0
[    0.228396] .... register #01: 00170020
[    0.228482] .......     : max redirection entries: 0017
[    0.228570] .......     : PRQ implemented: 0
[    0.228656] .......     : IO APIC version: 0020
[    0.228743] .... IRQ redirection table:
[    0.228966]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    0.229059]  00 000 1    0    0   0   0    0    0    00
[    0.229195]  01 003 0    0    0   0   0    1    1    31
[    0.229970]  02 003 0    0    0   0   0    1    1    30
[    0.230105]  03 003 0    0    0   0   0    1    1    33
[    0.230241]  04 003 0    0    0   0   0    1    1    34
[    0.230377]  05 003 0    0    0   0   0    1    1    35
[    0.230514]  06 003 0    0    0   0   0    1    1    36
[    0.230650]  07 003 0    0    0   0   0    1    1    37
[    0.230787]  08 003 0    0    0   0   0    1    1    38
[    0.230967]  09 003 0    1    0   0   0    1    1    39
[    0.231103]  0a 003 0    0    0   0   0    1    1    3A
[    0.231239]  0b 003 0    0    0   0   0    1    1    3B
[    0.231375]  0c 003 0    0    0   0   0    1    1    3C
[    0.231511]  0d 003 0    0    0   0   0    1    1    3D
[    0.231646]  0e 003 0    0    0   0   0    1    1    3E
[    0.231782]  0f 003 0    0    0   0   0    1    1    3F
[    0.231918]  10 000 1    0    0   0   0    0    0    00
[    0.232055]  11 000 1    0    0   0   0    0    0    00
[    0.232192]  12 000 1    0    0   0   0    0    0    00
[    0.232329]  13 000 1    0    0   0   0    0    0    00
[    0.232465]  14 000 1    0    0   0   0    0    0    00
[    0.232602]  15 000 1    0    0   0   0    0    0    00
[    0.232737]  16 000 1    0    0   0   0    0    0    00
[    0.232873]  17 000 1    0    0   0   0    0    0    00
[    0.232966] IRQ to pin mappings:
[    0.233051] IRQ0 -> 0:2
[    0.233219] IRQ1 -> 0:1
[    0.233389] IRQ3 -> 0:3
[    0.233559] IRQ4 -> 0:4
[    0.233729] IRQ5 -> 0:5
[    0.233897] IRQ6 -> 0:6
[    0.234088] IRQ7 -> 0:7
[    0.234258] IRQ8 -> 0:8
[    0.234426] IRQ9 -> 0:9
[    0.234596] IRQ10 -> 0:10
[    0.234765] IRQ11 -> 0:11
[    0.234933] IRQ12 -> 0:12
[    0.235087] IRQ13 -> 0:13
[    0.235256] IRQ14 -> 0:14
[    0.235426] IRQ15 -> 0:15
[    0.235599] .................................... done.
[    0.235690] initcall print_all_ICs+0x0/0x441 returned 0 after 12693 usecs
[    0.235783] calling  hpet_late_init+0x0/0x183 @ 1
[    0.235877] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.236179] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.238971] initcall hpet_late_init+0x0/0x183 returned 0 after 3905 usecs
[    0.239062] calling  clocksource_done_booting+0x0/0x11 @ 1
[    0.239968] initcall clocksource_done_booting+0x0/0x11 returned 0 after 0 usecs
[    0.240097] calling  rb_init_debugfs+0x0/0x27 @ 1
[    0.240191] initcall rb_init_debugfs+0x0/0x27 returned 0 after 0 usecs
[    0.240283] calling  tracer_init_debugfs+0x0/0x26b @ 1
[    0.240459] initcall tracer_init_debugfs+0x0/0x26b returned 0 after 0 usecs
[    0.240553] calling  init_trace_printk_function_export+0x0/0x2a @ 1
[    0.240647] initcall init_trace_printk_function_export+0x0/0x2a returned 0 after 0 usecs
[    0.240776] calling  event_trace_init+0x0/0x17e @ 1
[    0.240979] Switched to high resolution mode on CPU 0
[    0.241783] Switched to high resolution mode on CPU 1
[    0.242167] initcall event_trace_init+0x0/0x17e returned 0 after 2148 usecs
[    0.242265] calling  init_pipe_fs+0x0/0x41 @ 1
[    0.242366] initcall init_pipe_fs+0x0/0x41 returned 0 after 11 usecs
[    0.242459] calling  eventpoll_init+0x0/0xac @ 1
[    0.242554] initcall eventpoll_init+0x0/0xac returned 0 after 5 usecs
[    0.242647] calling  anon_inode_init+0x0/0xed @ 1
[    0.242744] initcall anon_inode_init+0x0/0xed returned 0 after 6 usecs
[    0.242836] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
[    0.242929] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 1 usecs
[    0.243031] calling  acpi_event_init+0x0/0x6f @ 1
[    0.246021] initcall acpi_event_init+0x0/0x6f returned 0 after 2830 usecs
[    0.246114] calling  pnpacpi_init+0x0/0x7b @ 1
[    0.246202] pnp: PnP ACPI init
[    0.246298] ACPI: bus type pnp registered
[    0.248505] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.248733] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.248956] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.249185] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.250518] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.253081] pnp: PnP ACPI: found 11 devices
[    0.253168] ACPI: ACPI bus type pnp unregistered
[    0.253266] initcall pnpacpi_init+0x0/0x7b returned 0 after 6895 usecs
[    0.253359] calling  pnp_system_init+0x0/0xf @ 1
[    0.253456] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.253548] system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
[    0.253641] system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
[    0.253735] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.253828] system 00:00: iomem range 0xcc000-0xcffff could not be reserved
[    0.253921] system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
[    0.254025] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.254118] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.254211] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.254313] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.254406] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.254499] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.254592] system 00:00: iomem range 0x100000-0x7fffffff could not be reserved
[    0.254723] system 00:00: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.254859] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.254952] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.255050] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.255143] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.255235] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.255334] system 00:02: ioport range 0x1600-0x165f could not be reserved
[    0.255428] system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.255522] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.255616] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.255710] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.255804] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.255954] initcall pnp_system_init+0x0/0xf returned 0 after 2446 usecs
[    0.256056] calling  chr_dev_init+0x0/0x8d @ 1
[    0.256797] initcall chr_dev_init+0x0/0x8d returned 0 after 636 usecs
[    0.256891] calling  firmware_class_init+0x0/0x61 @ 1
[    0.257046] initcall firmware_class_init+0x0/0x61 returned 0 after 62 usecs
[    0.257140] calling  init_pcmcia_bus+0x0/0x62 @ 1
[    0.257308] initcall init_pcmcia_bus+0x0/0x62 returned 0 after 75 usecs
[    0.257402] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    0.257497] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 1 usecs
[    0.257625] calling  cpufreq_gov_userspace_init+0x0/0xf @ 1
[    0.257719] initcall cpufreq_gov_userspace_init+0x0/0xf returned 0 after 1 usecs
[    0.257849] calling  init_acpi_pm_clocksource+0x0/0x1b5 @ 1
[    0.292492] initcall init_acpi_pm_clocksource+0x0/0x1b5 returned 0 after 33741 usecs
[    0.292622] calling  pcibios_assign_resources+0x0/0x66 @ 1
[    0.292785] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.292876] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.292970] pci 0000:00:1c.0:   MEM window: 0xee000000-0xee0fffff
[    0.293076] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.293169] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.293267] pci 0000:00:1c.1:   IO window: 0x3000-0x4fff
[    0.293360] pci 0000:00:1c.1:   MEM window: 0xec000000-0xedffffff
[    0.293453] pci 0000:00:1c.1:   PREFETCH window: 0x000000e4000000-0x000000e40fffff
[    0.293588] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.293679] pci 0000:00:1c.2:   IO window: 0x5000-0x6fff
[    0.293773] pci 0000:00:1c.2:   MEM window: 0xe8000000-0xe9ffffff
[    0.293866] pci 0000:00:1c.2:   PREFETCH window: 0x000000e4100000-0x000000e41fffff
[    0.294009] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0c
[    0.294100] pci 0000:00:1c.3:   IO window: 0x7000-0x8fff
[    0.294194] pci 0000:00:1c.3:   MEM window: 0xea000000-0xebffffff
[    0.294293] pci 0000:00:1c.3:   PREFETCH window: 0x000000e4200000-0x000000e42fffff
[    0.294431] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    0.294524] pci 0000:15:00.0:   IO window: 0x009000-0x0090ff
[    0.294618] pci 0000:15:00.0:   IO window: 0x009400-0x0094ff
[    0.294712] pci 0000:15:00.0:   PREFETCH window: 0xe0000000-0xe3ffffff
[    0.294807] pci 0000:15:00.0:   MEM window: 0x80000000-0x83ffffff
[    0.294902] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
[    0.294994] pci 0000:00:1e.0:   IO window: 0x9000-0xcfff
[    0.295094] pci 0000:00:1e.0:   MEM window: 0xe4300000-0xe7ffffff
[    0.295188] pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e3ffffff
[    0.295338]   alloc irq_desc for 20 on node -1
[    0.295425]   alloc kstat_irqs on node -1
[    0.295514] IOAPIC[0]: Set routing entry (1-20 -> 0x49 -> IRQ 20 Mode:1 Active:1)
[    0.295645] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.295741] pci 0000:00:1c.0: setting latency timer to 64
[    0.295836]   alloc irq_desc for 21 on node -1
[    0.295923]   alloc kstat_irqs on node -1
[    0.296019] IOAPIC[0]: Set routing entry (1-21 -> 0x51 -> IRQ 21 Mode:1 Active:1)
[    0.296149] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.296243] pci 0000:00:1c.1: setting latency timer to 64
[    0.296347]   alloc irq_desc for 22 on node -1
[    0.296435]   alloc kstat_irqs on node -1
[    0.296522] IOAPIC[0]: Set routing entry (1-22 -> 0x59 -> IRQ 22 Mode:1 Active:1)
[    0.296651] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.296747] pci 0000:00:1c.2: setting latency timer to 64
[    0.296843]   alloc irq_desc for 23 on node -1
[    0.297013]   alloc kstat_irqs on node -1
[    0.297803] IOAPIC[0]: Set routing entry (1-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
[    0.297933] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.298033] pci 0000:00:1c.3: setting latency timer to 64
[    0.298126] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.298219] pci 0000:00:1e.0: setting latency timer to 64
[    0.298326]   alloc irq_desc for 16 on node -1
[    0.298413]   alloc kstat_irqs on node -1
[    0.298501] IOAPIC[0]: Set routing entry (1-16 -> 0x69 -> IRQ 16 Mode:1 Active:1)
[    0.298631] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.298729] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.298819] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.298910] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.299000] pci_bus 0000:02: resource 1 mem: [0xee000000-0xee0fffff]
[    0.299099] pci_bus 0000:03: resource 0 io:  [0x3000-0x4fff]
[    0.299189] pci_bus 0000:03: resource 1 mem: [0xec000000-0xedffffff]
[    0.299287] pci_bus 0000:03: resource 2 pref mem [0xe4000000-0xe40fffff]
[    0.299380] pci_bus 0000:04: resource 0 io:  [0x5000-0x6fff]
[    0.299471] pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe9ffffff]
[    0.299563] pci_bus 0000:04: resource 2 pref mem [0xe4100000-0xe41fffff]
[    0.299655] pci_bus 0000:0c: resource 0 io:  [0x7000-0x8fff]
[    0.299745] pci_bus 0000:0c: resource 1 mem: [0xea000000-0xebffffff]
[    0.299837] pci_bus 0000:0c: resource 2 pref mem [0xe4200000-0xe42fffff]
[    0.299929] pci_bus 0000:15: resource 0 io:  [0x9000-0xcfff]
[    0.300026] pci_bus 0000:15: resource 1 mem: [0xe4300000-0xe7ffffff]
[    0.300117] pci_bus 0000:15: resource 2 pref mem [0xe0000000-0xe3ffffff]
[    0.300210] pci_bus 0000:15: resource 3 io:  [0x00-0xffff]
[    0.300309] pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffff]
[    0.300400] pci_bus 0000:16: resource 0 io:  [0x9000-0x90ff]
[    0.300491] pci_bus 0000:16: resource 1 io:  [0x9400-0x94ff]
[    0.300581] pci_bus 0000:16: resource 2 pref mem [0xe0000000-0xe3ffffff]
[    0.300673] pci_bus 0000:16: resource 3 mem: [0x80000000-0x83ffffff]
[    0.300767] initcall pcibios_assign_resources+0x0/0x66 returned 0 after 7864 usecs
[    0.300897] calling  sysctl_core_init+0x0/0x2d @ 1
[    0.301023] initcall sysctl_core_init+0x0/0x2d returned 0 after 33 usecs
[    0.301115] calling  inet_init+0x0/0x1c3 @ 1
[    0.301213] NET: Registered protocol family 2
[    0.301404] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.301831] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.302659] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.303110] TCP: Hash tables configured (established 131072 bind 65536)
[    0.303202] TCP reno registered
[    0.303404] initcall inet_init+0x0/0x1c3 returned 0 after 2142 usecs
[    0.303499] calling  af_unix_init+0x0/0x47 @ 1
[    0.303589] NET: Registered protocol family 1
[    0.303688] initcall af_unix_init+0x0/0x47 returned 0 after 97 usecs
[    0.303781] calling  populate_rootfs+0x0/0x1ea @ 1
[    0.303938] initcall populate_rootfs+0x0/0x1ea returned 0 after 63 usecs
[    0.304045] calling  i8259A_init_sysfs+0x0/0x1d @ 1
[    0.304311] initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 169 usecs
[    0.304404] calling  sbf_init+0x0/0xc0 @ 1
[    0.304495] Simple Boot Flag at 0x35 set to 0x1
[    0.304589] initcall sbf_init+0x0/0xc0 returned 0 after 93 usecs
[    0.304681] calling  i8237A_init_sysfs+0x0/0x1d @ 1
[    0.304886] initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 111 usecs
[    0.304980] calling  add_rtc_cmos+0x0/0x7e @ 1
[    0.305095] initcall add_rtc_cmos+0x0/0x7e returned 0 after 5 usecs
[    0.305188] calling  cache_sysfs_init+0x0/0x4b @ 1
[    0.305753] initcall cache_sysfs_init+0x0/0x4b returned 0 after 457 usecs
[    0.305847] calling  mce_init_device+0x0/0xc1 @ 1
[    0.306201] initcall mce_init_device+0x0/0xc1 returned 0 after 257 usecs
[    0.306305] calling  threshold_init_device+0x0/0x3a @ 1
[    0.306398] initcall threshold_init_device+0x0/0x3a returned 0 after 1 usecs
[    0.306492] calling  thermal_throttle_init_device+0x0/0x77 @ 1
[    0.306590] initcall thermal_throttle_init_device+0x0/0x77 returned 0 after 5 usecs
[    0.306720] calling  msr_init+0x0/0xda @ 1
[    0.307020] initcall msr_init+0x0/0xda returned 0 after 189 usecs
[    0.307111] calling  cpuid_init+0x0/0xda @ 1
[    0.307389] initcall cpuid_init+0x0/0xda returned 0 after 181 usecs
[    0.307482] calling  ioapic_init_sysfs+0x0/0x84 @ 1
[    0.307679] initcall ioapic_init_sysfs+0x0/0x84 returned 0 after 104 usecs
[    0.307772] calling  add_pcspkr+0x0/0x24 @ 1
[    0.307929] initcall add_pcspkr+0x0/0x24 returned 0 after 65 usecs
[    0.308034] calling  microcode_init+0x0/0xf2 @ 1
[    0.308192] microcode: CPU0 sig=0x6e8, pf=0x20, revision=0x39
[    0.308297] microcode: CPU1 sig=0x6e8, pf=0x20, revision=0x39
[    0.308450] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.308583] initcall microcode_init+0x0/0xf2 returned 0 after 447 usecs
[    0.308678] calling  start_periodic_check_for_corruption+0x0/0x32 @ 1
[    0.308770] Scanning for low memory corruption every 60 seconds
[    0.308864] initcall start_periodic_check_for_corruption+0x0/0x32 returned 0 after 91 usecs
[    0.308996] calling  aes_init+0x0/0xf @ 1
[    0.309202] initcall aes_init+0x0/0xf returned 0 after 90 usecs
[    0.309304] calling  proc_schedstat_init+0x0/0x1c @ 1
[    0.309401] initcall proc_schedstat_init+0x0/0x1c returned 0 after 6 usecs
[    0.309495] calling  proc_execdomains_init+0x0/0x1c @ 1
[    0.309588] initcall proc_execdomains_init+0x0/0x1c returned 0 after 2 usecs
[    0.309681] calling  ioresources_init+0x0/0x2d @ 1
[    0.309775] initcall ioresources_init+0x0/0x2d returned 0 after 3 usecs
[    0.309867] calling  uid_cache_init+0x0/0x5b @ 1
[    0.309963] initcall uid_cache_init+0x0/0x5b returned 0 after 5 usecs
[    0.310078] calling  init_posix_timers+0x0/0xb3 @ 1
[    0.310174] initcall init_posix_timers+0x0/0xb3 returned 0 after 5 usecs
[    0.310274] calling  init_posix_cpu_timers+0x0/0xba @ 1
[    0.310367] initcall init_posix_cpu_timers+0x0/0xba returned 0 after 1 usecs
[    0.310460] calling  nsproxy_cache_init+0x0/0x27 @ 1
[    0.310553] initcall nsproxy_cache_init+0x0/0x27 returned 0 after 1 usecs
[    0.310647] calling  create_proc_profile+0x0/0x16f @ 1
[    0.310749] initcall create_proc_profile+0x0/0x16f returned 0 after 9 usecs
[    0.310843] calling  timekeeping_init_device+0x0/0x1d @ 1
[    0.311038] initcall timekeeping_init_device+0x0/0x1d returned 0 after 100 usecs
[    0.311170] calling  init_clocksource_sysfs+0x0/0x43 @ 1
[    0.311377] initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 106 usecs
[    0.311508] calling  init_timer_list_procfs+0x0/0x27 @ 1
[    0.311602] initcall init_timer_list_procfs+0x0/0x27 returned 0 after 2 usecs
[    0.311695] calling  init_tstats_procfs+0x0/0x27 @ 1
[    0.311789] initcall init_tstats_procfs+0x0/0x27 returned 0 after 2 usecs
[    0.311881] calling  futex_init+0x0/0x65 @ 1
[    0.311979] initcall futex_init+0x0/0x65 returned 0 after 8 usecs
[    0.312086] calling  proc_dma_init+0x0/0x1c @ 1
[    0.312179] initcall proc_dma_init+0x0/0x1c returned 0 after 2 usecs
[    0.312277] calling  proc_modules_init+0x0/0x1c @ 1
[    0.312370] initcall proc_modules_init+0x0/0x1c returned 0 after 2 usecs
[    0.312462] calling  kallsyms_init+0x0/0x1f @ 1
[    0.312553] initcall kallsyms_init+0x0/0x1f returned 0 after 2 usecs
[    0.312646] calling  snapshot_device_init+0x0/0xf @ 1
[    0.312801] initcall snapshot_device_init+0x0/0xf returned 0 after 61 usecs
[    0.312895] calling  crash_save_vmcoreinfo_init+0x0/0x348 @ 1
[    0.313023] initcall crash_save_vmcoreinfo_init+0x0/0x348 returned 0 after 34 usecs
[    0.313153] calling  crash_notes_memory_init+0x0/0x31 @ 1
[    0.313247] initcall crash_notes_memory_init+0x0/0x31 returned 0 after 3 usecs
[    0.313384] calling  pid_namespaces_init+0x0/0x27 @ 1
[    0.313477] initcall pid_namespaces_init+0x0/0x27 returned 0 after 2 usecs
[    0.313570] calling  audit_init+0x0/0xd2 @ 1
[    0.313657] audit: initializing netlink socket (disabled)
[    0.313756] type=2000 audit(1249815910.313:1): initialized
[    0.313848] initcall audit_init+0x0/0xd2 returned 0 after 186 usecs
[    0.313941] calling  audit_tree_init+0x0/0x3b @ 1
[    0.314048] initcall audit_tree_init+0x0/0x3b returned 0 after 3 usecs
[    0.314140] calling  init_kprobes+0x0/0x11c @ 1
[    0.324102] initcall init_kprobes+0x0/0x11c returned 0 after 9640 usecs
[    0.324195] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    0.324314] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 22 usecs
[    0.324409] calling  init_markers+0x0/0xf @ 1
[    0.324499] initcall init_markers+0x0/0xf returned 0 after 1 usecs
[    0.324591] calling  init_tracepoints+0x0/0xf @ 1
[    0.324683] initcall init_tracepoints+0x0/0xf returned 0 after 1 usecs
[    0.324774] calling  init_events+0x0/0x5a @ 1
[    0.324867] initcall init_events+0x0/0x5a returned 0 after 2 usecs
[    0.324958] calling  init_sched_switch_trace+0x0/0xf @ 1
[    0.325059] initcall init_sched_switch_trace+0x0/0xf returned 0 after 2 usecs
[    0.325152] calling  init_blk_tracer+0x0/0x4b @ 1
[    0.325243] initcall init_blk_tracer+0x0/0x4b returned 0 after 1 usecs
[    0.325343] calling  perf_counter_sysfs_init+0x0/0x14 @ 1
[    0.325439] initcall perf_counter_sysfs_init+0x0/0x14 returned 0 after 4 usecs
[    0.325569] calling  init_per_zone_wmark_min+0x0/0x59 @ 1
[    0.325746] initcall init_per_zone_wmark_min+0x0/0x59 returned 0 after 83 usecs
[    0.325877] calling  pdflush_init+0x0/0x20 @ 1
[    0.326037] initcall pdflush_init+0x0/0x20 returned 0 after 68 usecs
[    0.326131] calling  kswapd_init+0x0/0x1d @ 1
[    0.326255] initcall kswapd_init+0x0/0x1d returned 0 after 33 usecs
[    0.326350] calling  init_tmpfs+0x0/0xb9 @ 1
[    0.326466] initcall init_tmpfs+0x0/0xb9 returned 0 after 26 usecs
[    0.326558] calling  setup_vmstat+0x0/0x9a @ 1
[    0.326658] initcall setup_vmstat+0x0/0x9a returned 0 after 9 usecs
[    0.326751] calling  mm_sysfs_init+0x0/0x22 @ 1
[    0.326844] initcall mm_sysfs_init+0x0/0x22 returned 0 after 4 usecs
[    0.326936] calling  proc_vmalloc_init+0x0/0x1f @ 1
[    0.327037] initcall proc_vmalloc_init+0x0/0x1f returned 0 after 2 usecs
[    0.327131] calling  init_emergency_pool+0x0/0x57 @ 1
[    0.327243] highmem bounce pool size: 64 pages
[    0.327340] initcall init_emergency_pool+0x0/0x57 returned 0 after 115 usecs
[    0.327433] calling  procswaps_init+0x0/0x1c @ 1
[    0.327527] initcall procswaps_init+0x0/0x1c returned 0 after 2 usecs
[    0.327619] calling  hugetlb_init+0x0/0x230 @ 1
[    0.327709] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.327811] initcall hugetlb_init+0x0/0x230 returned 0 after 99 usecs
[    0.328692] calling  slab_proc_init+0x0/0x1f @ 1
[    0.328784] initcall slab_proc_init+0x0/0x1f returned 0 after 2 usecs
[    0.328876] calling  slab_sysfs_init+0x0/0xb7 @ 1
[    0.333074] initcall slab_sysfs_init+0x0/0xb7 returned 0 after 4008 usecs
[    0.333169] calling  fasync_init+0x0/0x24 @ 1
[    0.333268] initcall fasync_init+0x0/0x24 returned 0 after 6 usecs
[    0.333360] calling  proc_filesystems_init+0x0/0x1c @ 1
[    0.333455] initcall proc_filesystems_init+0x0/0x1c returned 0 after 3 usecs
[    0.333548] calling  dnotify_init+0x0/0x6f @ 1
[    0.333649] initcall dnotify_init+0x0/0x6f returned 0 after 10 usecs
[    0.333741] calling  inotify_setup+0x0/0x11 @ 1
[    0.333833] initcall inotify_setup+0x0/0x11 returned 0 after 1 usecs
[    0.333925] calling  inotify_user_setup+0x0/0x9e @ 1
[    0.334044] initcall inotify_user_setup+0x0/0x9e returned 0 after 20 usecs
[    0.334138] calling  aio_setup+0x0/0x60 @ 1
[    0.334295] initcall aio_setup+0x0/0x60 returned 0 after 65 usecs
[    0.334389] calling  proc_locks_init+0x0/0x1c @ 1
[    0.334483] initcall proc_locks_init+0x0/0x1c returned 0 after 2 usecs
[    0.334575] calling  init_mbcache+0x0/0x11 @ 1
[    0.334665] initcall init_mbcache+0x0/0x11 returned 0 after 1 usecs
[    0.334757] calling  dquot_init+0x0/0xdd @ 1
[    0.334845] VFS: Disk quotas dquot_6.5.2
[    0.335056] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.335156] initcall dquot_init+0x0/0xdd returned 0 after 301 usecs
[    0.335249] calling  init_v2_quota_format+0x0/0xf @ 1
[    0.335349] initcall init_v2_quota_format+0x0/0xf returned 0 after 1 usecs
[    0.335442] calling  proc_cmdline_init+0x0/0x1c @ 1
[    0.335535] initcall proc_cmdline_init+0x0/0x1c returned 0 after 2 usecs
[    0.335629] calling  proc_cpuinfo_init+0x0/0x1c @ 1
[    0.335723] initcall proc_cpuinfo_init+0x0/0x1c returned 0 after 2 usecs
[    0.335815] calling  proc_devices_init+0x0/0x1c @ 1
[    0.335909] initcall proc_devices_init+0x0/0x1c returned 0 after 2 usecs
[    0.336010] calling  proc_interrupts_init+0x0/0x1c @ 1
[    0.336103] initcall proc_interrupts_init+0x0/0x1c returned 0 after 2 usecs
[    0.336197] calling  proc_loadavg_init+0x0/0x1c @ 1
[    0.336297] initcall proc_loadavg_init+0x0/0x1c returned 0 after 2 usecs
[    0.336390] calling  proc_meminfo_init+0x0/0x1c @ 1
[    0.336483] initcall proc_meminfo_init+0x0/0x1c returned 0 after 2 usecs
[    0.336576] calling  proc_stat_init+0x0/0x1c @ 1
[    0.336668] initcall proc_stat_init+0x0/0x1c returned 0 after 2 usecs
[    0.336759] calling  proc_uptime_init+0x0/0x1c @ 1
[    0.336851] initcall proc_uptime_init+0x0/0x1c returned 0 after 2 usecs
[    0.336943] calling  proc_version_init+0x0/0x1c @ 1
[    0.337060] initcall proc_version_init+0x0/0x1c returned 0 after 2 usecs
[    0.337152] calling  proc_softirqs_init+0x0/0x1c @ 1
[    0.337245] initcall proc_softirqs_init+0x0/0x1c returned 0 after 2 usecs
[    0.337347] calling  proc_kcore_init+0x0/0x40 @ 1
[    0.337439] initcall proc_kcore_init+0x0/0x40 returned 0 after 2 usecs
[    0.337532] calling  vmcore_init+0x0/0xa0b @ 1
[    0.337624] initcall vmcore_init+0x0/0xa0b returned 0 after 2 usecs
[    0.337716] calling  proc_kmsg_init+0x0/0x1f @ 1
[    0.337808] initcall proc_kmsg_init+0x0/0x1f returned 0 after 2 usecs
[    0.337901] calling  proc_page_init+0x0/0x33 @ 1
[    0.337995] initcall proc_page_init+0x0/0x33 returned 0 after 3 usecs
[    0.338093] calling  init_devpts_fs+0x0/0x41 @ 1
[    0.338196] initcall init_devpts_fs+0x0/0x41 returned 0 after 12 usecs
[    0.338296] calling  init_ext3_fs+0x0/0x5f @ 1
[    0.338545] initcall init_ext3_fs+0x0/0x5f returned 0 after 154 usecs
[    0.338636] calling  journal_init+0x0/0x85 @ 1
[    0.338965] initcall journal_init+0x0/0x85 returned 0 after 232 usecs
[    0.339070] calling  init_ramfs_fs+0x0/0xf @ 1
[    0.339161] initcall init_ramfs_fs+0x0/0xf returned 0 after 2 usecs
[    0.339254] calling  init_hugetlbfs_fs+0x0/0x84 @ 1
[    0.339441] initcall init_hugetlbfs_fs+0x0/0x84 returned 0 after 88 usecs
[    0.339535] calling  init_fat_fs+0x0/0x46 @ 1
[    0.339774] initcall init_fat_fs+0x0/0x46 returned 0 after 145 usecs
[    0.339866] calling  init_vfat_fs+0x0/0xf @ 1
[    0.339957] initcall init_vfat_fs+0x0/0xf returned 0 after 2 usecs
[    0.340057] calling  init_msdos_fs+0x0/0xf @ 1
[    0.340148] initcall init_msdos_fs+0x0/0xf returned 0 after 2 usecs
[    0.340240] calling  init_iso9660_fs+0x0/0x61 @ 1
[    0.340422] initcall init_iso9660_fs+0x0/0x61 returned 0 after 81 usecs
[    0.340515] calling  init_nfs_fs+0x0/0xf9 @ 1
[    0.340839] initcall init_nfs_fs+0x0/0xf9 returned 0 after 228 usecs
[    0.340931] calling  init_nlm+0x0/0x1c @ 1
[    0.341054] initcall init_nlm+0x0/0x1c returned 0 after 20 usecs
[    0.341146] calling  init_nls_cp437+0x0/0xf @ 1
[    0.341238] initcall init_nls_cp437+0x0/0xf returned 0 after 2 usecs
[    0.341339] calling  init_nls_ascii+0x0/0xf @ 1
[    0.341430] initcall init_nls_ascii+0x0/0xf returned 0 after 1 usecs
[    0.341523] calling  init_nls_iso8859_1+0x0/0xf @ 1
[    0.341615] initcall init_nls_iso8859_1+0x0/0xf returned 0 after 1 usecs
[    0.341707] calling  init_nls_utf8+0x0/0x1f @ 1
[    0.341798] initcall init_nls_utf8+0x0/0x1f returned 0 after 1 usecs
[    0.341891] calling  init_autofs4_fs+0x0/0x1e @ 1
[    0.342055] initcall init_autofs4_fs+0x0/0x1e returned 0 after 71 usecs
[    0.342148] calling  ipc_init+0x0/0x20 @ 1
[    0.342239] msgmni has been set to 1725
[    0.342337] initcall ipc_init+0x0/0x20 returned 0 after 98 usecs
[    0.342430] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    0.342553] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 32 usecs
[    0.342647] calling  init_mqueue_fs+0x0/0x9e @ 1
[    0.342845] initcall init_mqueue_fs+0x0/0x9e returned 0 after 104 usecs
[    0.342938] calling  key_proc_init+0x0/0x48 @ 1
[    0.343041] initcall key_proc_init+0x0/0x48 returned 0 after 4 usecs
[    0.343134] calling  selinux_nf_ip_init+0x0/0x54 @ 1
[    0.343222] SELinux:  Registering netfilter hooks
[    0.343321] initcall selinux_nf_ip_init+0x0/0x54 returned 0 after 94 usecs
[    0.343414] calling  init_sel_fs+0x0/0x5a @ 1
[    0.343585] initcall init_sel_fs+0x0/0x5a returned 0 after 76 usecs
[    0.343677] calling  selnl_init+0x0/0x46 @ 1
[    0.343773] initcall selnl_init+0x0/0x46 returned 0 after 6 usecs
[    0.343864] calling  sel_netif_init+0x0/0x57 @ 1
[    0.343957] initcall sel_netif_init+0x0/0x57 returned 0 after 3 usecs
[    0.344056] calling  sel_netnode_init+0x0/0x68 @ 1
[    0.344149] initcall sel_netnode_init+0x0/0x68 returned 0 after 2 usecs
[    0.344241] calling  sel_netport_init+0x0/0x68 @ 1
[    0.344340] initcall sel_netport_init+0x0/0x68 returned 0 after 2 usecs
[    0.344433] calling  aurule_init+0x0/0x30 @ 1
[    0.344523] initcall aurule_init+0x0/0x30 returned 0 after 1 usecs
[    0.344615] calling  crypto_wq_init+0x0/0x29 @ 1
[    0.344761] initcall crypto_wq_init+0x0/0x29 returned 0 after 54 usecs
[    0.344854] calling  crypto_algapi_init+0x0/0xc @ 1
[    0.344947] initcall crypto_algapi_init+0x0/0xc returned 0 after 3 usecs
[    0.345048] calling  chainiv_module_init+0x0/0xf @ 1
[    0.345141] initcall chainiv_module_init+0x0/0xf returned 0 after 1 usecs
[    0.345234] calling  eseqiv_module_init+0x0/0xf @ 1
[    0.345333] initcall eseqiv_module_init+0x0/0xf returned 0 after 1 usecs
[    0.345425] calling  hmac_module_init+0x0/0xf @ 1
[    0.345517] initcall hmac_module_init+0x0/0xf returned 0 after 1 usecs
[    0.345609] calling  md5_mod_init+0x0/0xf @ 1
[    0.345762] initcall md5_mod_init+0x0/0xf returned 0 after 62 usecs
[    0.345855] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    0.345998] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 50 usecs
[    0.346100] calling  crypto_ecb_module_init+0x0/0xf @ 1
[    0.346193] initcall crypto_ecb_module_init+0x0/0xf returned 0 after 1 usecs
[    0.346291] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    0.346384] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 1 usecs
[    0.346477] calling  des_generic_mod_init+0x0/0x33 @ 1
[    0.346690] initcall des_generic_mod_init+0x0/0x33 returned 0 after 119 usecs
[    0.346785] calling  aes_init+0x0/0xf @ 1
[    0.346945] initcall aes_init+0x0/0xf returned 0 after 69 usecs
[    0.347046] calling  arc4_init+0x0/0xf @ 1
[    0.347226] initcall arc4_init+0x0/0xf returned 0 after 88 usecs
[    0.347324] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    0.347417] initcall crypto_authenc_module_init+0x0/0xf returned 0 after 1 usecs
[    0.347547] calling  krng_mod_init+0x0/0xf @ 1
[    0.347669] alg: No test for stdrng (krng)
[    0.347767] initcall krng_mod_init+0x0/0xf returned 0 after 126 usecs
[    0.347861] calling  proc_genhd_init+0x0/0x2d @ 1
[    0.347956] initcall proc_genhd_init+0x0/0x2d returned 0 after 4 usecs
[    0.348056] calling  bsg_init+0x0/0x10d @ 1
[    0.348296] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.348427] initcall bsg_init+0x0/0x10d returned 0 after 275 usecs
[    0.348519] calling  noop_init+0x0/0x11 @ 1
[    0.348608] io scheduler noop registered
[    0.348696] initcall noop_init+0x0/0x11 returned 0 after 85 usecs
[    0.348786] calling  as_init+0x0/0x11 @ 1
[    0.348874] io scheduler anticipatory registered
[    0.348964] initcall as_init+0x0/0x11 returned 0 after 86 usecs
[    0.349062] calling  deadline_init+0x0/0x11 @ 1
[    0.349150] io scheduler deadline registered
[    0.349239] initcall deadline_init+0x0/0x11 returned 0 after 85 usecs
[    0.349338] calling  cfq_init+0x0/0x91 @ 1
[    0.349515] io scheduler cfq registered (default)
[    0.349605] initcall cfq_init+0x0/0x91 returned 0 after 173 usecs
[    0.349696] calling  percpu_counter_startup+0x0/0x16 @ 1
[    0.349789] initcall percpu_counter_startup+0x0/0x16 returned 0 after 1 usecs
[    0.349882] calling  audit_classes_init+0x0/0x4f @ 1
[    0.349978] initcall audit_classes_init+0x0/0x4f returned 0 after 4 usecs
[    0.350079] calling  pci_init+0x0/0x2c @ 1
[    0.350177] pci 0000:00:02.0: Boot video device
[    0.350285] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
[    0.350377] pci 0000:00:1d.0: Performing full reset
[    0.350482] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.350573] pci 0000:00:1d.1: Performing full reset
[    0.350677] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.350769] pci 0000:00:1d.2: Performing full reset
[    0.350873] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
[    0.350964] pci 0000:00:1d.3: Performing full reset
[    0.351107] initcall pci_init+0x0/0x2c returned 0 after 917 usecs
[    0.351199] calling  pci_proc_init+0x0/0x5b @ 1
[    0.351347] initcall pci_proc_init+0x0/0x5b returned 0 after 49 usecs
[    0.351440] calling  pcie_portdrv_init+0x0/0x41 @ 1
[    0.351664]   alloc irq_desc for 24 on node -1
[    0.351752]   alloc kstat_irqs on node -1
[    0.351850] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.351950] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.353132]   alloc irq_desc for 25 on node -1
[    0.353220]   alloc kstat_irqs on node -1
[    0.353324] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.353421] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.353816]   alloc irq_desc for 26 on node -1
[    0.353904]   alloc kstat_irqs on node -1
[    0.353998] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.354105] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.354480]   alloc irq_desc for 27 on node -1
[    0.354567]   alloc kstat_irqs on node -1
[    0.354660] pcieport-driver 0000:00:1c.3: irq 27 for MSI/MSI-X
[    0.354759] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.355139] initcall pcie_portdrv_init+0x0/0x41 returned 0 after 3523 usecs
[    0.355233] calling  aer_service_init+0x0/0x1d @ 1
[    0.355390] initcall aer_service_init+0x0/0x1d returned 0 after 57 usecs
[    0.355483] calling  pci_hotplug_init+0x0/0x18 @ 1
[    0.355573] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.355665] initcall pci_hotplug_init+0x0/0x18 returned 0 after 88 usecs
[    0.355757] calling  fb_console_init+0x0/0xf5 @ 1
[    0.355912] initcall fb_console_init+0x0/0xf5 returned 0 after 63 usecs
[    0.356014] calling  genericbl_init+0x0/0xf @ 1
[    0.356161] initcall genericbl_init+0x0/0xf returned 0 after 55 usecs
[    0.356253] calling  efifb_init+0x0/0x1b8 @ 1
[    0.356357] initcall efifb_init+0x0/0x1b8 returned -19 after 9 usecs
[    0.356450] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    0.356544] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 3 usecs
[    0.356638] calling  irqrouter_init_sysfs+0x0/0x33 @ 1
[    0.356829] initcall irqrouter_init_sysfs+0x0/0x33 returned 0 after 97 usecs
[    0.356923] calling  acpi_ac_init+0x0/0x3d @ 1
[    0.357536] ACPI: AC Adapter [AC] (on-line)
[    0.357690] initcall acpi_ac_init+0x0/0x3d returned 0 after 643 usecs
[    0.357785] calling  acpi_button_init+0x0/0x4a @ 1
[    0.357978] input: Power Button as /class/input/input0
[    0.358075] ACPI: Power Button [PWRF]
[    0.358286] input: Lid Switch as /class/input/input1
[    0.358958] ACPI: Lid Switch [LID]
[    0.359153] input: Sleep Button as /class/input/input2
[    0.359245] ACPI: Sleep Button [SLPB]
[    0.359403] initcall acpi_button_init+0x0/0x4a returned 0 after 1490 usecs
[    0.359496] calling  acpi_fan_init+0x0/0x4a @ 1
[    0.359649] initcall acpi_fan_init+0x0/0x4a returned 0 after 61 usecs
[    0.359741] calling  acpi_video_init+0x0/0x6b @ 1
[    0.360402] input: Video Bus as /class/input/input3
[    0.360492] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.360659] initcall acpi_video_init+0x0/0x6b returned 0 after 807 usecs
[    0.360753] calling  acpi_processor_init+0x0/0xe9 @ 1
[    0.361333] ACPI: SSDT 7f6e609e 001ED (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.362054] ACPI: SSDT 7f6e5de1 00238 (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.363535] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.363866] processor LNXCPU:00: registered as cooling_device0
[    0.363960] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.364541] ACPI: SSDT 7f6e628b 00094 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.365193] ACPI: SSDT 7f6e6019 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.366681] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.367015] processor LNXCPU:01: registered as cooling_device1
[    0.367108] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.367390] initcall acpi_processor_init+0x0/0xe9 returned 0 after 6391 usecs
[    0.367484] calling  acpi_container_init+0x0/0x3d @ 1
[    0.372921] initcall acpi_container_init+0x0/0x3d returned 0 after 5219 usecs
[    0.373026] calling  acpi_thermal_init+0x0/0x6f @ 1
[    0.376397] thermal LNXTHERM:01: registered as thermal_zone0
[    0.376493] ACPI: Thermal Zone [THM0] (55 C)
[    0.378159] thermal LNXTHERM:02: registered as thermal_zone1
[    0.378256] ACPI: Thermal Zone [THM1] (56 C)
[    0.378400] initcall acpi_thermal_init+0x0/0x6f returned 0 after 5157 usecs
[    0.378494] calling  acpi_battery_init+0x0/0x13 @ 1
[    0.420206] ACPI: Battery Slot [BAT0] (battery present)
[    0.420371] initcall acpi_battery_init+0x0/0x13 returned 0 after 40805 usecs
[    0.420467] calling  rand_initialize+0x0/0x25 @ 1
[    0.420582] initcall rand_initialize+0x0/0x25 returned 0 after 23 usecs
[    0.420675] calling  tty_init+0x0/0xd5 @ 1
[    0.425266] initcall tty_init+0x0/0xd5 returned 0 after 4393 usecs
[    0.425361] calling  pty_init+0x0/0x20d @ 1
[    0.425540] initcall pty_init+0x0/0x20d returned 0 after 86 usecs
[    0.425633] calling  sysrq_init+0x0/0x1f @ 1
[    0.425726] initcall sysrq_init+0x0/0x1f returned 0 after 4 usecs
[    0.425818] calling  hpet_init+0x0/0x57 @ 1
[    0.426111] initcall hpet_init+0x0/0x57 returned 0 after 197 usecs
[    0.426202] calling  nvram_init+0x0/0x70 @ 1
[    0.426358] Non-volatile memory driver v1.3
[    0.426448] initcall nvram_init+0x0/0x70 returned 0 after 144 usecs
[    0.426540] calling  mod_init+0x0/0x1ba @ 1
[    0.426734] intel_rng: FWH not detected
[    0.426854] initcall mod_init+0x0/0x1ba returned -19 after 219 usecs
[    0.426948] calling  mod_init+0x0/0x9f @ 1
[    0.427073] initcall mod_init+0x0/0x9f returned -19 after 16 usecs
[    0.427165] calling  mod_init+0x0/0x91 @ 1
[    0.427270] initcall mod_init+0x0/0x91 returned -19 after 15 usecs
[    0.427362] calling  mod_init+0x0/0x41 @ 1
[    0.427451] initcall mod_init+0x0/0x41 returned -19 after 0 usecs
[    0.427543] calling  agp_init+0x0/0x21 @ 1
[    0.427631] Linux agpgart interface v0.103
[    0.427720] initcall agp_init+0x0/0x21 returned 0 after 85 usecs
[    0.427811] calling  agp_amd64_init+0x0/0xc0 @ 1
[    0.427970] initcall agp_amd64_init+0x0/0xc0 returned -19 after 65 usecs
[    0.428083] calling  agp_intel_init+0x0/0x24 @ 1
[    0.428184] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[    0.428933] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.432042] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.432221] initcall agp_intel_init+0x0/0x24 returned 0 after 3948 usecs
[    0.432324] calling  drm_core_init+0x0/0xea @ 1
[    0.432486] [drm] Initialized drm 1.1.0 20060810
[    0.432577] initcall drm_core_init+0x0/0xea returned 0 after 159 usecs
[    0.432669] calling  i915_init+0x0/0x58 @ 1
[    0.432856] pci 0000:00:02.0: power state changed by ACPI to D0
[    0.432952] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.433066] pci 0000:00:02.0: setting latency timer to 64
[    0.435959] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.436130] initcall i915_init+0x0/0x58 returned 0 after 3288 usecs
[    0.436223] calling  cn_proc_init+0x0/0x30 @ 1
[    0.436325] initcall cn_proc_init+0x0/0x30 returned 0 after 3 usecs
[    0.436416] calling  serial8250_init+0x0/0x113 @ 1
[    0.436506] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.436900] async_waiting @ 1
[    0.436986] async_continuing @ 1 after 1 usec
[    0.558108] async_waiting @ 1
[    0.558195] async_continuing @ 1 after 1 usec
[    0.680159] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    0.680516] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[    0.680720] initcall serial8250_init+0x0/0x113 returned 0 after 238488 usecs
[    0.680814] calling  serial8250_pnp_init+0x0/0xf @ 1
[    0.681118] initcall serial8250_pnp_init+0x0/0xf returned 0 after 208 usecs
[    0.681212] calling  serial8250_pci_init+0x0/0x16 @ 1
[    0.681414] initcall serial8250_pci_init+0x0/0x16 returned 0 after 99 usecs
[    0.681510] calling  topology_sysfs_init+0x0/0x3f @ 1
[    0.681615] initcall topology_sysfs_init+0x0/0x3f returned 0 after 14 usecs
[    0.681709] calling  brd_init+0x0/0x14e @ 1
[    0.684430] brd: module loaded
[    0.684519] initcall brd_init+0x0/0x14e returned 0 after 2657 usecs
[    0.684612] calling  loop_init+0x0/0x166 @ 1
[    0.685961] loop: module loaded
[    0.686059] initcall loop_init+0x0/0x166 returned 0 after 1325 usecs
[    0.686152] calling  cpqarray_init+0x0/0x22b @ 1
[    0.686240] Compaq SMART2 Driver (v 2.6.0)
[    0.686452] initcall cpqarray_init+0x0/0x22b returned -19 after 204 usecs
[    0.686546] calling  mac_hid_init+0x0/0x75 @ 1
[    0.686729] input: Macintosh mouse button emulation as /class/input/input4
[    0.686851] initcall mac_hid_init+0x0/0x75 returned 0 after 209 usecs
[    0.686943] calling  spi_transport_init+0x0/0x6c @ 1
[    0.687171] initcall spi_transport_init+0x0/0x6c returned 0 after 101 usecs
[    0.687272] calling  ahc_linux_init+0x0/0x5c @ 1
[    0.687446] initcall ahc_linux_init+0x0/0x5c returned 0 after 81 usecs
[    0.687538] calling  init_sd+0x0/0xb6 @ 1
[    0.687733] initcall init_sd+0x0/0xb6 returned 0 after 103 usecs
[    0.687825] calling  init_sr+0x0/0x3d @ 1
[    0.687968] initcall init_sr+0x0/0x3d returned 0 after 52 usecs
[    0.688080] calling  init_sg+0x0/0x133 @ 1
[    0.688234] initcall init_sg+0x0/0x133 returned 0 after 62 usecs
[    0.688333] calling  ahci_init+0x0/0x16 @ 1
[    0.688446] ahci 0000:00:1f.2: version 3.0
[    0.688549] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.688679]   alloc irq_desc for 28 on node -1
[    0.688767]   alloc kstat_irqs on node -1
[    0.688863] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    0.689024] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    0.689157] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    0.689255] ahci 0000:00:1f.2: setting latency timer to 64
[    0.689459] scsi0 : ahci
[    0.689686] scsi1 : ahci
[    0.689879] scsi2 : ahci
[    0.690070] scsi3 : ahci
[    0.690291] ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 28
[    0.690419] ata2: DUMMY
[    0.690502] ata3: DUMMY
[    0.690585] ata4: DUMMY
[    1.250038] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.251600] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    1.251693] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.251785] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.253078] ata1.00: ATA-7: HTS541080G9SA00, MB4IC60H, max UDMA/100
[    1.253170] ata1.00: 156301488 sectors, multi 16: LBA48 
[    1.254937] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    1.255050] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.255932] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.257229] ata1.00: configured for UDMA/100
[    1.270677] ata1.00: configured for UDMA/100
[    1.270768] ata1: EH complete
[    1.270855] async_waiting @ 1
[    1.270941] async_continuing @ 1 after 1 usec
[    1.271148] scsi 0:0:0:0: Direct-Access     ATA      HTS541080G9SA00  MB4I PQ: 0 ANSI: 5
[    1.271477] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    1.271659] sd 0:0:0:0: [sda] Write Protect is off
[    1.271748] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.271864] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.272142]  sda: sda1 sda2
[    1.659535] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.659772] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.659958] async_waiting @ 1
[    1.660055] async_continuing @ 1 after 1 usec
[    1.660159] async_waiting @ 1
[    1.660245] async_continuing @ 1 after 1 usec
[    1.660355] async_waiting @ 1
[    1.660442] async_continuing @ 1 after 1 usec
[    1.660601] initcall ahci_init+0x0/0x16 returned 0 after 949390 usecs
[    1.660693] calling  piix_init+0x0/0x27 @ 1
[    1.660798] ata_piix 0000:00:1f.1: version 2.13
[    1.660893] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    1.661028] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.661196] scsi4 : ata_piix
[    1.661393] scsi5 : ata_piix
[    1.662298] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    1.662391] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    1.816409] ata5.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4246N, 0X05, max UDMA/33
[    1.822317] ata5.00: configured for UDMA/33
[    1.823055] async_waiting @ 1
[    1.823142] async_continuing @ 1 after 1 usec
[    1.827280] scsi 4:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4246N 0X05 PQ: 0 ANSI: 5
[    1.838286] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.838379] Uniform CD-ROM driver Revision: 3.20
[    1.838690] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    1.838933] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    1.839145] ata6: port disabled. ignoring.
[    1.839241] async_waiting @ 1
[    1.839335] async_continuing @ 1 after 1 usec
[    1.839489] initcall piix_init+0x0/0x27 returned 0 after 174516 usecs
[    1.839582] calling  nv_init+0x0/0x16 @ 1
[    1.839737] initcall nv_init+0x0/0x16 returned 0 after 64 usecs
[    1.839829] calling  amd_init+0x0/0x16 @ 1
[    1.839979] initcall amd_init+0x0/0x16 returned 0 after 59 usecs
[    1.840080] calling  mpiix_init+0x0/0x16 @ 1
[    1.840230] initcall mpiix_init+0x0/0x16 returned 0 after 58 usecs
[    1.840327] calling  oldpiix_init+0x0/0x16 @ 1
[    1.840478] initcall oldpiix_init+0x0/0x16 returned 0 after 59 usecs
[    1.840570] calling  sch_init+0x0/0x16 @ 1
[    1.840719] initcall sch_init+0x0/0x16 returned 0 after 57 usecs
[    1.840810] calling  ata_generic_init+0x0/0x16 @ 1
[    1.840963] initcall ata_generic_init+0x0/0x16 returned 0 after 60 usecs
[    1.841065] calling  e1000_init_module+0x0/0x6e @ 1
[    1.841154] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    1.841246] Copyright (c) 1999-2006 Intel Corporation.
[    1.841412] initcall e1000_init_module+0x0/0x6e returned 0 after 251 usecs
[    1.841505] calling  e1000_init_module+0x0/0x53 @ 1
[    1.841594] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    1.841683] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.841874] e1000e 0000:02:00.0: Disabling L1 ASPM
[    1.842048] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.842149] e1000e 0000:02:00.0: setting latency timer to 64
[    1.842419]   alloc irq_desc for 29 on node -1
[    1.842507]   alloc kstat_irqs on node -1
[    1.842609] e1000e 0000:02:00.0: irq 29 for MSI/MSI-X
[    1.883473] e1000e 0000:02:00.0: Warning: detected ASPM enabled in EEPROM
[    1.925641] 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:41:17:49:d2
[    1.925771] 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.925937] 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
[    1.926107] initcall e1000_init_module+0x0/0x53 returned 0 after 82530 usecs
[    1.926200] calling  vortex_init+0x0/0x9b @ 1
[    1.926364] initcall vortex_init+0x0/0x9b returned 0 after 66 usecs
[    1.926457] calling  ne2k_pci_init+0x0/0x16 @ 1
[    1.926608] initcall ne2k_pci_init+0x0/0x16 returned 0 after 60 usecs
[    1.926701] calling  e100_init_module+0x0/0x4d @ 1
[    1.926790] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.926880] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.927046] initcall e100_init_module+0x0/0x4d returned 0 after 248 usecs
[    1.927138] calling  tg3_init+0x0/0x16 @ 1
[    1.927304] initcall tg3_init+0x0/0x16 returned 0 after 74 usecs
[    1.927396] calling  bnx2_init+0x0/0x16 @ 1
[    1.927547] initcall bnx2_init+0x0/0x16 returned 0 after 59 usecs
[    1.927639] calling  sky2_init_module+0x0/0x20 @ 1
[    1.927727] sky2 driver version 1.23
[    1.927880] initcall sky2_init_module+0x0/0x20 returned 0 after 147 usecs
[    1.927973] calling  net_olddevs_init+0x0/0x81 @ 1
[    1.928076] initcall net_olddevs_init+0x0/0x81 returned 0 after 5 usecs
[    1.928169] calling  init_nic+0x0/0x16 @ 1
[    1.928328] initcall init_nic+0x0/0x16 returned 0 after 66 usecs
[    1.928420] calling  rtl8139_init_module+0x0/0x16 @ 1
[    1.928576] initcall rtl8139_init_module+0x0/0x16 returned 0 after 64 usecs
[    1.928670] calling  rtl8169_init_module+0x0/0x16 @ 1
[    1.928823] initcall rtl8169_init_module+0x0/0x16 returned 0 after 60 usecs
[    1.928917] calling  init_ath5k_pci+0x0/0x2d @ 1
[    1.929084] initcall init_ath5k_pci+0x0/0x2d returned 0 after 68 usecs
[    1.929176] calling  init_netconsole+0x0/0x1a2 @ 1
[    1.929275] netconsole: local port 4444
[    1.929361] netconsole: local IP 10.0.1.15
[    1.929448] netconsole: interface eth0
[    1.929535] netconsole: remote port 4444
[    1.929621] netconsole: remote IP 10.0.1.21
[    1.929709] netconsole: remote ethernet address 00:30:48:c6:86:26
[    1.929801] netconsole: device eth0 not up yet, forcing it
[    1.943283] e1000e 0000:02:00.0: irq 29 for MSI/MSI-X
[    1.994113] e1000e 0000:02:00.0: irq 29 for MSI/MSI-X
[    4.659020] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[    4.817190] console [netcon0] enabled
[    4.817294] netconsole: network logging started
[    4.817394] initcall init_netconsole+0x0/0x1a2 returned 0 after 2820429 usecs
[    4.817497] calling  cdrom_init+0x0/0xc @ 1
[    4.817596] initcall cdrom_init+0x0/0xc returned 0 after 1 usecs
[    4.817697] calling  nonstatic_sysfs_init+0x0/0xf @ 1
[    4.817803] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 5 usecs
[    4.817906] calling  yenta_socket_init+0x0/0x16 @ 1
[    4.818039] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2012]
[    4.818164] yenta_cardbus 0000:15:00.0: Using INTVAL to route CSC interrupts to PCI
[    4.818312] yenta_cardbus 0000:15:00.0: Routing CardBus interrupts to PCI
[    4.818417] yenta_cardbus 0000:15:00.0: TI: mfunc 0x01d01002, devctl 0x64
[    4.919062] async_waiting @ 1
[    4.919152] async_continuing @ 1 after 1 usec
[    5.041827] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
[    5.041922] yenta_cardbus 0000:15:00.0: Socket status: 30000007
[    5.042032] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
[    5.042173] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
[    5.042326] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
[    5.293140] initcall yenta_socket_init+0x0/0x16 returned 0 after 463995 usecs
[    5.293235] calling  mon_init+0x0/0xe2 @ 1
[    5.293480] initcall mon_init+0x0/0xe2 returned 0 after 131 usecs
[    5.293574] calling  ehci_hcd_init+0x0/0xbf @ 1
[    5.293672] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.293774] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    5.294375] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    5.294474]   alloc irq_desc for 19 on node -1
[    5.294564]   alloc kstat_irqs on node -1
[    5.294664] IOAPIC[0]: Set routing entry (1-19 -> 0xb1 -> IRQ 19 Mode:1 Active:1)
[    5.294802] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.294912] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.295024] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.295145] drivers/usb/core/inode.c: creating file 'devices'
[    5.295247] drivers/usb/core/inode.c: creating file '001'
[    5.295428] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    5.295566] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    5.295707] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    5.295867] ehci_hcd 0000:00:1d.7: reset command 080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
[    5.299905] ehci_hcd 0000:00:1d.7: debug port 1
[    5.300000] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    5.300108] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    5.300219] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
[    5.300328] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.304353] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    5.310015] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.310158] usb usb1: default language 0x0409
[    5.310254] usb usb1: udev 1, busnum 1, minor = 0
[    5.310353] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.310454] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.310591] usb usb1: Product: EHCI Host Controller
[    5.310687] usb usb1: Manufacturer: Linux 2.6.31-rc5-tip ehci_hcd
[    5.310786] usb usb1: SerialNumber: 0000:00:1d.7
[    5.310930] usb usb1: uevent
[    5.311098] usb usb1: usb_probe_device
[    5.311187] usb usb1: configuration #1 chosen from 1 choice
[    5.311297] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.311412] usb 1-0:1.0: uevent
[    5.311563] hub 1-0:1.0: usb_probe_interface
[    5.311653] hub 1-0:1.0: usb_probe_interface - got id
[    5.311751] hub 1-0:1.0: USB hub found
[    5.311851] hub 1-0:1.0: 8 ports detected
[    5.311946] hub 1-0:1.0: standalone hub
[    5.312049] hub 1-0:1.0: no power switching (usb 1.0)
[    5.312145] hub 1-0:1.0: individual port over-current protection
[    5.312245] hub 1-0:1.0: power on to power good time: 20ms
[    5.312352] hub 1-0:1.0: local power source is good
[    5.312450] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    5.312599] drivers/usb/core/inode.c: creating file '001'
[    5.312771] initcall ehci_hcd_init+0x0/0xbf returned 0 after 18649 usecs
[    5.312865] calling  ohci_hcd_mod_init+0x0/0x94 @ 1
[    5.312963] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.313070] ohci_hcd: block sizes: ed 64 td 64
[    5.313243] initcall ohci_hcd_mod_init+0x0/0x94 returned 0 after 271 usecs
[    5.313344] calling  uhci_hcd_init+0x0/0x10a @ 1
[    5.313441] uhci_hcd: USB Universal Host Controller Interface driver
[    5.314123] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    5.314220] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.314334] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.314433] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.314535] drivers/usb/core/inode.c: creating file '002'
[    5.314718] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.314853] uhci_hcd 0000:00:1d.0: detected 2 ports
[    5.314954] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.315062] uhci_hcd 0000:00:1d.0: Performing full reset
[    5.315182] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    5.315284] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[    5.315433] usb usb2: default language 0x0409
[    5.315529] usb usb2: udev 1, busnum 2, minor = 128
[    5.315627] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.315728] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.315865] usb usb2: Product: UHCI Host Controller
[    5.315961] usb usb2: Manufacturer: Linux 2.6.31-rc5-tip uhci_hcd
[    5.316068] usb usb2: SerialNumber: 0000:00:1d.0
[    5.316207] usb usb2: uevent
[    5.316373] usb usb2: usb_probe_device
[    5.317244] usb usb2: configuration #1 chosen from 1 choice
[    5.317354] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.317470] usb 2-0:1.0: uevent
[    5.317619] hub 2-0:1.0: usb_probe_interface
[    5.317717] hub 2-0:1.0: usb_probe_interface - got id
[    5.317813] hub 2-0:1.0: USB hub found
[    5.317913] hub 2-0:1.0: 2 ports detected
[    5.318015] hub 2-0:1.0: standalone hub
[    5.318111] hub 2-0:1.0: no power switching (usb 1.0)
[    5.318208] hub 2-0:1.0: individual port over-current protection
[    5.318315] hub 2-0:1.0: power on to power good time: 2ms
[    5.318416] hub 2-0:1.0: local power source is good
[    5.318513] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.318631] drivers/usb/core/inode.c: creating file '001'
[    5.318767]   alloc irq_desc for 17 on node -1
[    5.318857]   alloc kstat_irqs on node -1
[    5.318956] IOAPIC[0]: Set routing entry (1-17 -> 0xb9 -> IRQ 17 Mode:1 Active:1)
[    5.319103] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.319208] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.319316] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.319417] drivers/usb/core/inode.c: creating file '003'
[    5.319593] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    5.319729] uhci_hcd 0000:00:1d.1: detected 2 ports
[    5.319830] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.319930] uhci_hcd 0000:00:1d.1: Performing full reset
[    5.320048] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    5.320159] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[    5.320293] usb usb3: default language 0x0409
[    5.320397] usb usb3: udev 1, busnum 3, minor = 256
[    5.320494] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.320595] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.320731] usb usb3: Product: UHCI Host Controller
[    5.320828] usb usb3: Manufacturer: Linux 2.6.31-rc5-tip uhci_hcd
[    5.320927] usb usb3: SerialNumber: 0000:00:1d.1
[    5.321082] usb usb3: uevent
[    5.321232] usb usb3: usb_probe_device
[    5.321327] usb usb3: configuration #1 chosen from 1 choice
[    5.321430] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    5.321545] usb 3-0:1.0: uevent
[    5.321699] hub 3-0:1.0: usb_probe_interface
[    5.321787] hub 3-0:1.0: usb_probe_interface - got id
[    5.321883] hub 3-0:1.0: USB hub found
[    5.321985] hub 3-0:1.0: 2 ports detected
[    5.322087] hub 3-0:1.0: standalone hub
[    5.322182] hub 3-0:1.0: no power switching (usb 1.0)
[    5.322285] hub 3-0:1.0: individual port over-current protection
[    5.322385] hub 3-0:1.0: power on to power good time: 2ms
[    5.322485] hub 3-0:1.0: local power source is good
[    5.322582] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    5.322702] drivers/usb/core/inode.c: creating file '001'
[    5.323510] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    5.323605]   alloc irq_desc for 18 on node -1
[    5.323693]   alloc kstat_irqs on node -1
[    5.323791] IOAPIC[0]: Set routing entry (1-18 -> 0xc1 -> IRQ 18 Mode:1 Active:1)
[    5.323929] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.324043] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.324143] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.324244] drivers/usb/core/inode.c: creating file '004'
[    5.324427] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    5.324563] uhci_hcd 0000:00:1d.2: detected 2 ports
[    5.324663] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.324763] uhci_hcd 0000:00:1d.2: Performing full reset
[    5.324875] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    5.324985] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    5.325132] usb usb4: default language 0x0409
[    5.325227] usb usb4: udev 1, busnum 4, minor = 384
[    5.325331] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.325432] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.325568] usb usb4: Product: UHCI Host Controller
[    5.325665] usb usb4: Manufacturer: Linux 2.6.31-rc5-tip uhci_hcd
[    5.325765] usb usb4: SerialNumber: 0000:00:1d.2
[    5.325905] usb usb4: uevent
[    5.326071] usb usb4: usb_probe_device
[    5.326160] usb usb4: configuration #1 chosen from 1 choice
[    5.326264] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    5.326382] usb 4-0:1.0: uevent
[    5.326533] hub 4-0:1.0: usb_probe_interface
[    5.326622] hub 4-0:1.0: usb_probe_interface - got id
[    5.326719] hub 4-0:1.0: USB hub found
[    5.326820] hub 4-0:1.0: 2 ports detected
[    5.326915] hub 4-0:1.0: standalone hub
[    5.327017] hub 4-0:1.0: no power switching (usb 1.0)
[    5.327114] hub 4-0:1.0: individual port over-current protection
[    5.327213] hub 4-0:1.0: power on to power good time: 2ms
[    5.327322] hub 4-0:1.0: local power source is good
[    5.327418] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    5.327536] drivers/usb/core/inode.c: creating file '001'
[    5.327677] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.327774] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.327876] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.327977] drivers/usb/core/inode.c: creating file '005'
[    5.328167] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    5.328311] uhci_hcd 0000:00:1d.3: detected 2 ports
[    5.328411] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    5.328512] uhci_hcd 0000:00:1d.3: Performing full reset
[    5.328627] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[    5.328768] usb usb5: default language 0x0409
[    5.328863] usb usb5: udev 1, busnum 5, minor = 512
[    5.328961] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.329070] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.329208] usb usb5: Product: UHCI Host Controller
[    5.329313] usb usb5: Manufacturer: Linux 2.6.31-rc5-tip uhci_hcd
[    5.329413] usb usb5: SerialNumber: 0000:00:1d.3
[    5.329563] usb usb5: uevent
[    5.329713] usb usb5: usb_probe_device
[    5.329801] usb usb5: configuration #1 chosen from 1 choice
[    5.329906] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    5.330029] usb 5-0:1.0: uevent
[    5.330179] hub 5-0:1.0: usb_probe_interface
[    5.330275] hub 5-0:1.0: usb_probe_interface - got id
[    5.330372] hub 5-0:1.0: USB hub found
[    5.330472] hub 5-0:1.0: 2 ports detected
[    5.330568] hub 5-0:1.0: standalone hub
[    5.330663] hub 5-0:1.0: no power switching (usb 1.0)
[    5.330761] hub 5-0:1.0: individual port over-current protection
[    5.330861] hub 5-0:1.0: power on to power good time: 2ms
[    5.330961] hub 5-0:1.0: local power source is good
[    5.331067] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    5.331184] drivers/usb/core/inode.c: creating file '001'
[    5.331381] initcall uhci_hcd_init+0x0/0x10a returned 0 after 17516 usecs
[    5.331476] calling  usblp_init+0x0/0x16 @ 1
[    5.331635] usbcore: registered new interface driver usblp
[    5.331730] initcall usblp_init+0x0/0x16 returned 0 after 152 usecs
[    5.331830] calling  usb_stor_init+0x0/0x42 @ 1
[    5.331927] Initializing USB Mass Storage driver...
[    5.332119] usbcore: registered new interface driver usb-storage
[    5.332211] USB Mass Storage support registered.
[    5.332319] initcall usb_stor_init+0x0/0x42 returned 0 after 381 usecs
[    5.332420] calling  usb_usual_init+0x0/0x30 @ 1
[    5.332603] usbcore: registered new interface driver libusual
[    5.332699] initcall usb_usual_init+0x0/0x30 returned 0 after 176 usecs
[    5.332801] calling  i8042_init+0x0/0x35f @ 1
[    5.333051] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.333202] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    5.341619] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.341716] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.341854] initcall i8042_init+0x0/0x35f returned 0 after 8744 usecs
[    5.341949] calling  serport_init+0x0/0x2b @ 1
[    5.342057] initcall serport_init+0x0/0x2b returned 0 after 1 usecs
[    5.342157] calling  mousedev_init+0x0/0x51 @ 1
[    5.342433] mice: PS/2 mouse device common for all mice
[    5.342526] initcall mousedev_init+0x0/0x51 returned 0 after 263 usecs
[    5.342627] calling  evdev_init+0x0/0xf @ 1
[    5.343079] initcall evdev_init+0x0/0xf returned 0 after 345 usecs
[    5.343173] calling  atkbd_init+0x0/0x20 @ 1
[    5.343350] initcall atkbd_init+0x0/0x20 returned 0 after 72 usecs
[    5.343444] calling  psmouse_init+0x0/0x61 @ 1
[    5.343667] initcall psmouse_init+0x0/0x61 returned 0 after 121 usecs
[    5.343761] calling  cmos_init+0x0/0x65 @ 1
[    5.343890] rtc_cmos 00:07: RTC can wake from S4
[    5.344078] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    5.344201] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.344386] initcall cmos_init+0x0/0x65 returned 0 after 513 usecs
[    5.344480] calling  i2c_i801_init+0x0/0x16 @ 1
[    5.344596] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.344903] initcall i2c_i801_init+0x0/0x16 returned 0 after 316 usecs
[    5.344997] calling  dm_init+0x0/0x39 @ 1
[    5.345454] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    5.345590] initcall dm_init+0x0/0x39 returned 0 after 474 usecs
[    5.345690] calling  dm_mirror_init+0x0/0x69 @ 1
[    5.345811] initcall dm_mirror_init+0x0/0x69 returned 0 after 16 usecs
[    5.345912] calling  dm_dirty_log_init+0x0/0x49 @ 1
[    5.346021] initcall dm_dirty_log_init+0x0/0x49 returned 0 after 1 usecs
[    5.346122] calling  dm_zero_init+0x0/0x28 @ 1
[    5.346221] initcall dm_zero_init+0x0/0x28 returned 0 after 1 usecs
[    5.346330] calling  cpufreq_gov_dbs_init+0x0/0x9f @ 1
[    5.346526] initcall cpufreq_gov_dbs_init+0x0/0x9f returned 0 after 88 usecs
[    5.346621] calling  init_ladder+0x0/0xf @ 1
[    5.347188] cpuidle: using governor ladder
[    5.348068] initcall init_ladder+0x0/0xf returned 0 after 1315 usecs
[    5.348169] calling  init_menu+0x0/0xf @ 1
[    5.349088] input: AT Translated Set 2 keyboard as /class/input/input5
[    5.349518] cpuidle: using governor menu
[    5.349610] initcall init_menu+0x0/0xf returned 0 after 1308 usecs
[    5.349711] calling  efivars_init+0x0/0x187 @ 1
[    5.349810] initcall efivars_init+0x0/0x187 returned -19 after 1 usecs
[    5.349912] calling  hid_init+0x0/0x3d @ 1
[    5.350186] initcall hid_init+0x0/0x3d returned 0 after 165 usecs
[    5.350284] calling  a4_init+0x0/0x16 @ 1
[    5.350470] initcall a4_init+0x0/0x16 returned 0 after 71 usecs
[    5.350563] calling  apple_init+0x0/0x2d @ 1
[    5.350740] initcall apple_init+0x0/0x2d returned 0 after 76 usecs
[    5.350833] calling  belkin_init+0x0/0x16 @ 1
[    5.350989] initcall belkin_init+0x0/0x16 returned 0 after 56 usecs
[    5.351097] calling  ch_init+0x0/0x16 @ 1
[    5.351275] initcall ch_init+0x0/0x16 returned 0 after 77 usecs
[    5.351369] calling  ch_init+0x0/0x16 @ 1
[    5.351539] initcall ch_init+0x0/0x16 returned 0 after 70 usecs
[    5.351632] calling  cp_init+0x0/0x16 @ 1
[    5.351791] initcall cp_init+0x0/0x16 returned 0 after 60 usecs
[    5.351885] calling  dr_init+0x0/0x16 @ 1
[    5.352056] initcall dr_init+0x0/0x16 returned 0 after 71 usecs
[    5.352149] calling  ez_init+0x0/0x16 @ 1
[    5.352342] initcall ez_init+0x0/0x16 returned 0 after 93 usecs
[    5.352435] calling  gyration_init+0x0/0x16 @ 1
[    5.352620] initcall gyration_init+0x0/0x16 returned 0 after 83 usecs
[    5.352715] calling  ks_init+0x0/0x16 @ 1
[    5.352904] initcall ks_init+0x0/0x16 returned 0 after 89 usecs
[    5.352998] calling  kye_init+0x0/0x16 @ 1
[    5.353189] initcall kye_init+0x0/0x16 returned 0 after 73 usecs
[    5.353285] calling  lg_init+0x0/0x16 @ 1
[    5.353468] initcall lg_init+0x0/0x16 returned 0 after 71 usecs
[    5.353562] calling  ms_init+0x0/0x16 @ 1
[    5.353974] initcall ms_init+0x0/0x16 returned 0 after 300 usecs
[    5.354089] calling  mr_init+0x0/0x16 @ 1
[    5.354263] initcall mr_init+0x0/0x16 returned 0 after 72 usecs
[    5.354364] calling  ntrig_init+0x0/0x16 @ 1
[    5.354534] initcall ntrig_init+0x0/0x16 returned 0 after 69 usecs
[    5.354628] calling  pl_init+0x0/0x16 @ 1
[    5.354794] initcall pl_init+0x0/0x16 returned 0 after 66 usecs
[    5.354887] calling  pl_init+0x0/0x16 @ 1
[    5.355059] initcall pl_init+0x0/0x16 returned 0 after 72 usecs
[    5.355151] calling  samsung_init+0x0/0x16 @ 1
[    5.355343] initcall samsung_init+0x0/0x16 returned 0 after 90 usecs
[    5.355436] calling  sjoy_init+0x0/0x16 @ 1
[    5.355616] initcall sjoy_init+0x0/0x16 returned 0 after 79 usecs
[    5.355710] calling  sony_init+0x0/0x16 @ 1
[    5.355898] initcall sony_init+0x0/0x16 returned 0 after 87 usecs
[    5.355992] calling  sp_init+0x0/0x16 @ 1
[    5.356194] initcall sp_init+0x0/0x16 returned 0 after 85 usecs
[    5.356290] calling  ga_init+0x0/0x16 @ 1
[    5.356481] initcall ga_init+0x0/0x16 returned 0 after 75 usecs
[    5.356574] calling  tm_init+0x0/0x16 @ 1
[    5.356733] initcall tm_init+0x0/0x16 returned 0 after 59 usecs
[    5.356826] calling  ts_init+0x0/0x16 @ 1
[    5.357000] initcall ts_init+0x0/0x16 returned 0 after 67 usecs
[    5.357106] calling  zp_init+0x0/0x16 @ 1
[    5.357289] initcall zp_init+0x0/0x16 returned 0 after 82 usecs
[    5.357382] calling  hid_init+0x0/0xaa @ 1
[    5.357681] usbcore: registered new interface driver hiddev
[    5.357859] usbcore: registered new interface driver usbhid
[    5.357951] usbhid: v2.6:USB HID core driver
[    5.358071] initcall hid_init+0x0/0xaa returned 0 after 576 usecs
[    5.358171] calling  usb_mouse_init+0x0/0x2d @ 1
[    5.358602] usbcore: registered new interface driver usbmouse
[    5.358695] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[    5.358797] initcall usb_mouse_init+0x0/0x2d returned 0 after 511 usecs
[    5.358899] calling  eeepc_laptop_init+0x0/0x3e1 @ 1
[    5.359180] initcall eeepc_laptop_init+0x0/0x3e1 returned -19 after 176 usecs
[    5.359277] calling  init_soundcore+0x0/0x64 @ 1
[    5.359459] initcall init_soundcore+0x0/0x64 returned 0 after 66 usecs
[    5.359553] calling  alsa_sound_init+0x0/0x77 @ 1
[    5.359667] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    5.359770] initcall alsa_sound_init+0x0/0x77 returned 0 after 113 usecs
[    5.359872] calling  alsa_hwdep_init+0x0/0x46 @ 1
[    5.359974] initcall alsa_hwdep_init+0x0/0x46 returned 0 after 3 usecs
[    5.360098] calling  alsa_timer_init+0x0/0x12c @ 1
[    5.360287] initcall alsa_timer_init+0x0/0x12c returned 0 after 88 usecs
[    5.360382] calling  snd_hrtimer_init+0x0/0xd4 @ 1
[    5.360482] initcall snd_hrtimer_init+0x0/0xd4 returned 0 after 1 usecs
[    5.360584] calling  alsa_pcm_init+0x0/0x4d @ 1
[    5.360684] initcall alsa_pcm_init+0x0/0x4d returned 0 after 2 usecs
[    5.360785] calling  snd_mem_init+0x0/0x24 @ 1
[    5.360887] initcall snd_mem_init+0x0/0x24 returned 0 after 3 usecs
[    5.360987] calling  alsa_mixer_oss_init+0x0/0x2d @ 1
[    5.361111] initcall alsa_mixer_oss_init+0x0/0x2d returned 0 after 8 usecs
[    5.361206] calling  alsa_pcm_oss_init+0x0/0x76 @ 1
[    5.361322] initcall alsa_pcm_oss_init+0x0/0x76 returned 0 after 1 usecs
[    5.361431] calling  alsa_seq_init+0x0/0x51 @ 1
[    5.361905] initcall alsa_seq_init+0x0/0x51 returned 0 after 366 usecs
[    5.362000] calling  alsa_seq_device_init+0x0/0x4e @ 1
[    5.362110] initcall alsa_seq_device_init+0x0/0x4e returned 0 after 2 usecs
[    5.362212] calling  alsa_seq_midi_event_init+0x0/0x7 @ 1
[    5.362317] initcall alsa_seq_midi_event_init+0x0/0x7 returned 0 after 1 usecs
[    5.362466] calling  alsa_seq_oss_init+0x0/0x130 @ 1
[    5.362833] initcall alsa_seq_oss_init+0x0/0x130 returned 0 after 260 usecs
[    5.362929] calling  alsa_seq_dummy_init+0x0/0xa7 @ 1
[    5.363059] initcall alsa_seq_dummy_init+0x0/0xa7 returned 0 after 14 usecs
[    5.363153] calling  patch_realtek_init+0x0/0xf @ 1
[    5.363258] initcall patch_realtek_init+0x0/0xf returned 0 after 4 usecs
[    5.363371] calling  patch_cmedia_init+0x0/0xf @ 1
[    5.363472] initcall patch_cmedia_init+0x0/0xf returned 0 after 1 usecs
[    5.363572] calling  patch_analog_init+0x0/0xf @ 1
[    5.363673] initcall patch_analog_init+0x0/0xf returned 0 after 1 usecs
[    5.363773] calling  patch_sigmatel_init+0x0/0xf @ 1
[    5.363874] initcall patch_sigmatel_init+0x0/0xf returned 0 after 1 usecs
[    5.363975] calling  patch_si3054_init+0x0/0xf @ 1
[    5.364082] initcall patch_si3054_init+0x0/0xf returned 0 after 1 usecs
[    5.364183] calling  patch_atihdmi_init+0x0/0xf @ 1
[    5.364286] initcall patch_atihdmi_init+0x0/0xf returned 0 after 1 usecs
[    5.364397] calling  patch_ca0110_init+0x0/0xf @ 1
[    5.364497] initcall patch_ca0110_init+0x0/0xf returned 0 after 1 usecs
[    5.364597] calling  patch_conexant_init+0x0/0xf @ 1
[    5.364697] initcall patch_conexant_init+0x0/0xf returned 0 after 1 usecs
[    5.364798] calling  patch_via_init+0x0/0xf @ 1
[    5.364898] initcall patch_via_init+0x0/0xf returned 0 after 1 usecs
[    5.364998] calling  patch_nvhdmi_init+0x0/0xf @ 1
[    5.365106] initcall patch_nvhdmi_init+0x0/0xf returned 0 after 1 usecs
[    5.365208] calling  patch_intelhdmi_init+0x0/0xf @ 1
[    5.365312] initcall patch_intelhdmi_init+0x0/0xf returned 0 after 1 usecs
[    5.365425] calling  alsa_card_azx_init+0x0/0x16 @ 1
[    5.365557] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.365689] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[    5.365808] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.399675] initcall alsa_card_azx_init+0x0/0x16 returned 0 after 33348 usecs
[    5.399772] calling  alsa_sound_last_init+0x0/0x50 @ 1
[    5.399872] ALSA device list:
[    5.399965]   #0: HDA Intel at 0xee240000 irq 17
[    5.400078] initcall alsa_sound_last_init+0x0/0x50 returned 0 after 199 usecs
[    5.400181] calling  flow_cache_init+0x0/0x141 @ 1
[    5.400318] initcall flow_cache_init+0x0/0x141 returned 0 after 33 usecs
[    5.400412] calling  llc_init+0x0/0x1b @ 1
[    5.400512] initcall llc_init+0x0/0x1b returned 0 after 1 usecs
[    5.400612] calling  snap_init+0x0/0x31 @ 1
[    5.400710] initcall snap_init+0x0/0x31 returned 0 after 1 usecs
[    5.400811] calling  rif_init+0x0/0x6b @ 1
[    5.400934] initcall rif_init+0x0/0x6b returned 0 after 24 usecs
[    5.401056] calling  blackhole_module_init+0x0/0xf @ 1
[    5.401158] initcall blackhole_module_init+0x0/0xf returned 0 after 1 usecs
[    5.401263] calling  nfnetlink_init+0x0/0x51 @ 1
[    5.401372] Netfilter messages via NETLINK v0.30.
[    5.401479] initcall nfnetlink_init+0x0/0x51 returned 0 after 102 usecs
[    5.401581] calling  nfnetlink_log_init+0x0/0xb3 @ 1
[    5.401699] initcall nfnetlink_log_init+0x0/0xb3 returned 0 after 10 usecs
[    5.401802] calling  nf_conntrack_standalone_init+0x0/0xf @ 1
[    5.401903] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.402740] initcall nf_conntrack_standalone_init+0x0/0xf returned 0 after 816 usecs
[    5.402874] calling  ctnetlink_init+0x0/0x62 @ 1
[    5.402971] ctnetlink v0.93: registering with nfnetlink.
[    5.403091] initcall ctnetlink_init+0x0/0x62 returned 0 after 115 usecs
[    5.403194] calling  nf_conntrack_ftp_init+0x0/0x189 @ 1
[    5.403300] initcall nf_conntrack_ftp_init+0x0/0x189 returned 0 after 3 usecs
[    5.403412] calling  nf_conntrack_irc_init+0x0/0x17e @ 1
[    5.403517] initcall nf_conntrack_irc_init+0x0/0x17e returned 0 after 2 usecs
[    5.403619] calling  nf_conntrack_sip_init+0x0/0x159 @ 1
[    5.403721] initcall nf_conntrack_sip_init+0x0/0x159 returned 0 after 1 usecs
[    5.403823] calling  xt_init+0x0/0xda @ 1
[    5.403922] initcall xt_init+0x0/0xda returned 0 after 1 usecs
[    5.404029] calling  tcpudp_mt_init+0x0/0x14 @ 1
[    5.404130] initcall tcpudp_mt_init+0x0/0x14 returned 0 after 2 usecs
[    5.404231] calling  connsecmark_tg_init+0x0/0xf @ 1
[    5.404345] initcall connsecmark_tg_init+0x0/0xf returned 0 after 10 usecs
[    5.404447] calling  mark_tg_init+0x0/0x14 @ 1
[    5.404547] initcall mark_tg_init+0x0/0x14 returned 0 after 1 usecs
[    5.404648] calling  nflog_tg_init+0x0/0xf @ 1
[    5.404747] initcall nflog_tg_init+0x0/0xf returned 0 after 1 usecs
[    5.404848] calling  secmark_tg_init+0x0/0xf @ 1
[    5.404948] initcall secmark_tg_init+0x0/0xf returned 0 after 1 usecs
[    5.405057] calling  tcpmss_tg_init+0x0/0x14 @ 1
[    5.405156] initcall tcpmss_tg_init+0x0/0x14 returned 0 after 1 usecs
[    5.405259] calling  conntrack_mt_init+0x0/0x14 @ 1
[    5.405374] initcall conntrack_mt_init+0x0/0x14 returned 0 after 1 usecs
[    5.405475] calling  mark_mt_init+0x0/0x14 @ 1
[    5.405757] initcall mark_mt_init+0x0/0x14 returned 0 after 172 usecs
[    5.405851] calling  policy_mt_init+0x0/0x14 @ 1
[    5.405952] initcall policy_mt_init+0x0/0x14 returned 0 after 1 usecs
[    5.406838] calling  state_mt_init+0x0/0x14 @ 1
[    5.406946] initcall state_mt_init+0x0/0x14 returned 0 after 1 usecs
[    5.407052] calling  sysctl_ipv4_init+0x0/0x3f @ 1
[    5.407600] initcall sysctl_ipv4_init+0x0/0x3f returned 0 after 438 usecs
[    5.407694] calling  init_syncookies+0x0/0x16 @ 1
[    5.407844] initcall init_syncookies+0x0/0x16 returned 0 after 48 usecs
[    5.407938] calling  tunnel4_init+0x0/0x5a @ 1
[    5.408045] initcall tunnel4_init+0x0/0x5a returned 0 after 1 usecs
[    5.408147] calling  ipv4_netfilter_init+0x0/0xf @ 1
[    5.408248] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 1 usecs
[    5.408352] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x11d @ 1
[    5.409022] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x11d returned 0 after 535 usecs
[    5.409154] calling  nf_nat_init+0x0/0xea @ 1
[    5.409290] initcall nf_nat_init+0x0/0xea returned 0 after 36 usecs
[    5.409383] calling  nf_defrag_init+0x0/0x14 @ 1
[    5.409483] initcall nf_defrag_init+0x0/0x14 returned 0 after 1 usecs
[    5.409584] calling  nf_nat_ftp_init+0x0/0x1e @ 1
[    5.409684] initcall nf_nat_ftp_init+0x0/0x1e returned 0 after 1 usecs
[    5.409784] calling  nf_nat_irc_init+0x0/0x1e @ 1
[    5.409884] initcall nf_nat_irc_init+0x0/0x1e returned 0 after 1 usecs
[    5.409983] calling  nf_nat_sip_init+0x0/0x91 @ 1
[    5.410091] initcall nf_nat_sip_init+0x0/0x91 returned 0 after 1 usecs
[    5.410191] calling  ip_tables_init+0x0/0x92 @ 1
[    5.410298] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.410407] initcall ip_tables_init+0x0/0x92 returned 0 after 112 usecs
[    5.410507] calling  iptable_filter_init+0x0/0x5d @ 1
[    5.410615] initcall iptable_filter_init+0x0/0x5d returned 0 after 8 usecs
[    5.410716] calling  iptable_mangle_init+0x0/0x38 @ 1
[    5.410822] initcall iptable_mangle_init+0x0/0x38 returned 0 after 5 usecs
[    5.410924] calling  nf_nat_standalone_init+0x0/0x73 @ 1
[    5.411036] initcall nf_nat_standalone_init+0x0/0x73 returned 0 after 5 usecs
[    5.411139] calling  log_tg_init+0x0/0x24 @ 1
[    5.411239] initcall log_tg_init+0x0/0x24 returned 0 after 1 usecs
[    5.411342] calling  masquerade_tg_init+0x0/0x2d @ 1
[    5.411693] initcall masquerade_tg_init+0x0/0x2d returned 0 after 225 usecs
[    5.411788] calling  reject_tg_init+0x0/0xf @ 1
[    5.411888] initcall reject_tg_init+0x0/0xf returned 0 after 1 usecs
[    5.411989] calling  ulog_tg_init+0x0/0xbe @ 1
[    5.412099] initcall ulog_tg_init+0x0/0xbe returned 0 after 4 usecs
[    5.412199] calling  cubictcp_register+0x0/0x93 @ 1
[    5.412301] TCP cubic registered
[    5.412410] initcall cubictcp_register+0x0/0x93 returned 0 after 105 usecs
[    5.412512] calling  xfrm_user_init+0x0/0x40 @ 1
[    5.412608] Initializing XFRM netlink socket
[    5.412709] initcall xfrm_user_init+0x0/0x40 returned 0 after 97 usecs
[    5.412810] calling  inet6_init+0x0/0x277 @ 1
[    5.413051] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 001803 POWER sig=j CSC CONNECT
[    5.413184] hub 1-0:1.0: port 8: status 0501 change 0001
[    5.413671] NET: Registered protocol family 10
[    5.415678] initcall inet6_init+0x0/0x277 returned 0 after 2703 usecs
[    5.415774] calling  ah6_init+0x0/0x5a @ 1
[    5.415875] initcall ah6_init+0x0/0x5a returned 0 after 1 usecs
[    5.415974] calling  esp6_init+0x0/0x5a @ 1
[    5.416081] initcall esp6_init+0x0/0x5a returned 0 after 1 usecs
[    5.416181] calling  xfrm6_transport_init+0x0/0x14 @ 1
[    5.416285] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 1 usecs
[    5.416396] calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1
[    5.416497] initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after 1 usecs
[    5.416598] calling  xfrm6_beet_init+0x0/0x14 @ 1
[    5.416698] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 1 usecs
[    5.416799] calling  ip6_tables_init+0x0/0x92 @ 1
[    5.416904] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.417011] initcall ip6_tables_init+0x0/0x92 returned 0 after 110 usecs
[    5.417113] calling  ip6table_filter_init+0x0/0x5d @ 1
[    5.417459] initcall ip6table_filter_init+0x0/0x5d returned 0 after 233 usecs
[    5.417560] calling  ip6table_mangle_init+0x0/0x38 @ 1
[    5.417668] initcall ip6table_mangle_init+0x0/0x38 returned 0 after 6 usecs
[    5.417769] calling  nf_conntrack_l3proto_ipv6_init+0x0/0xef @ 1
[    5.417937] initcall nf_conntrack_l3proto_ipv6_init+0x0/0xef returned 0 after 64 usecs
[    5.418102] calling  ipv6header_mt6_init+0x0/0xf @ 1
[    5.418205] initcall ipv6header_mt6_init+0x0/0xf returned 0 after 1 usecs
[    5.418309] calling  log_tg6_init+0x0/0x24 @ 1
[    5.418419] initcall log_tg6_init+0x0/0x24 returned 0 after 1 usecs
[    5.418520] calling  reject_tg6_init+0x0/0xf @ 1
[    5.418619] initcall reject_tg6_init+0x0/0xf returned 0 after 1 usecs
[    5.418719] calling  sit_init+0x0/0x5f @ 1
[    5.418815] IPv6 over IPv4 tunneling driver
[    5.419018] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.419887] initcall sit_init+0x0/0x5f returned 0 after 1044 usecs
[    5.419980] calling  packet_init+0x0/0x39 @ 1
[    5.420086] NET: Registered protocol family 17
[    5.420426] initcall packet_init+0x0/0x39 returned 0 after 329 usecs
[    5.420528] calling  init_sunrpc+0x0/0x53 @ 1
[    5.420932] RPC: Registered udp transport module.
[    5.421031] RPC: Registered tcp transport module.
[    5.421131] initcall init_sunrpc+0x0/0x53 returned 0 after 492 usecs
[    5.421232] calling  init_rpcsec_gss+0x0/0x3f @ 1
[    5.421344] initcall init_rpcsec_gss+0x0/0x3f returned 0 after 8 usecs
[    5.421453] calling  init_kerberos_module+0x0/0x26 @ 1
[    5.421556] initcall init_kerberos_module+0x0/0x26 returned 0 after 4 usecs
[    5.421661] calling  severities_debugfs_init+0x0/0x4e @ 1
[    5.421770] initcall severities_debugfs_init+0x0/0x4e returned 0 after 9 usecs
[    5.421910] calling  acpi_cpufreq_init+0x0/0xbf @ 1
[    5.422347] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.426065] initcall acpi_cpufreq_init+0x0/0xbf returned 0 after 3951 usecs
[    5.426162] calling  hpet_insert_resource+0x0/0x1e @ 1
[    5.426271] initcall hpet_insert_resource+0x0/0x1e returned 0 after 4 usecs
[    5.426381] calling  update_mp_table+0x0/0x3ad @ 1
[    5.426482] initcall update_mp_table+0x0/0x3ad returned 0 after 1 usecs
[    5.426590] calling  lapic_insert_resource+0x0/0x33 @ 1
[    5.426691] initcall lapic_insert_resource+0x0/0x33 returned 0 after 1 usecs
[    5.426793] calling  print_ipi_mode+0x0/0x26 @ 1
[    5.426890] Using IPI No-Shortcut mode
[    5.426986] initcall print_ipi_mode+0x0/0x26 returned 0 after 92 usecs
[    5.427096] calling  init_lapic_nmi_sysfs+0x0/0x33 @ 1
[    5.427196] initcall init_lapic_nmi_sysfs+0x0/0x33 returned 0 after 1 usecs
[    5.427301] calling  io_apic_bug_finalize+0x0/0x1c @ 1
[    5.427415] initcall io_apic_bug_finalize+0x0/0x1c returned 0 after 2 usecs
[    5.427517] calling  check_early_ioremap_leak+0x0/0x5e @ 1
[    5.427619] initcall check_early_ioremap_leak+0x0/0x5e returned 0 after 1 usecs
[    5.427758] calling  pat_memtype_list_init+0x0/0x23 @ 1
[    5.428110] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.428218] initcall pat_memtype_list_init+0x0/0x23 returned 0 after 351 usecs
[    5.428361] calling  init_oops_id+0x0/0x3a @ 1
[    5.428473] initcall init_oops_id+0x0/0x3a returned 0 after 1 usecs
[    5.428574] calling  disable_boot_consoles+0x0/0x3a @ 1
[    5.428675] initcall disable_boot_consoles+0x0/0x3a returned 0 after 1 usecs
[    5.428777] calling  pm_qos_power_init+0x0/0x54 @ 1
[    5.429120] initcall pm_qos_power_init+0x0/0x54 returned 0 after 237 usecs
[    5.429216] calling  software_resume+0x0/0x19d @ 1
[    5.429319] PM: Resume from disk failed.
[    5.429429] initcall software_resume+0x0/0x19d returned -2 after 105 usecs
[    5.429531] initcall software_resume+0x0/0x19d returned with error code -2 
[    5.429635] calling  debugfs_kprobe_init+0x0/0x78 @ 1
[    5.429742] initcall debugfs_kprobe_init+0x0/0x78 returned 0 after 7 usecs
[    5.429844] calling  taskstats_init+0x0/0x7d @ 1
[    5.429945] registered taskstats version 1
[    5.430051] initcall taskstats_init+0x0/0x7d returned 0 after 107 usecs
[    5.430153] calling  clear_boot_tracer+0x0/0x27 @ 1
[    5.430253] initcall clear_boot_tracer+0x0/0x27 returned 0 after 1 usecs
[    5.430358] calling  max_swapfiles_check+0x0/0x7 @ 1
[    5.430470] initcall max_swapfiles_check+0x0/0x7 returned 0 after 1 usecs
[    5.430571] calling  random32_reseed+0x0/0x7e @ 1
[    5.430684] initcall random32_reseed+0x0/0x7e returned 0 after 14 usecs
[    5.430786] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[    5.430892] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 3 usecs
[    5.431048] calling  pci_sysfs_init+0x0/0x44 @ 1
[    5.431161] uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
[    5.431714] initcall pci_sysfs_init+0x0/0x44 returned 0 after 554 usecs
[    5.431811] calling  seqgen_init+0x0/0xe @ 1
[    5.431927] initcall seqgen_init+0x0/0xe returned 0 after 16 usecs
[    5.432038] calling  late_resume_init+0x0/0xc2 @ 1
[    5.432136]   Magic number: 5:366:74
[    5.432316] initcall late_resume_init+0x0/0xc2 returned 0 after 174 usecs
[    5.432410] calling  scsi_complete_async_scans+0x0/0xf4 @ 1
[    5.432511] initcall scsi_complete_async_scans+0x0/0xf4 returned 0 after 1 usecs
[    5.432649] calling  memmap_init+0x0/0x8a @ 1
[    5.432807] initcall memmap_init+0x0/0x8a returned 0 after 59 usecs
[    5.432901] calling  pci_mmcfg_late_insert_resources+0x0/0x12e @ 1
[    5.433013] initcall pci_mmcfg_late_insert_resources+0x0/0x12e returned 0 after 10 usecs
[    5.433153] calling  tcp_congestion_default+0x0/0xf @ 1
[    5.433257] initcall tcp_congestion_default+0x0/0xf returned 0 after 1 usecs
[    5.433372] calling  ip_auto_config+0x0/0xd22 @ 1
[    5.433475] initcall ip_auto_config+0x0/0xd22 returned 0 after 4 usecs
[    5.433576] calling  initialize_hashrnd+0x0/0x16 @ 1
[    5.433680] initcall initialize_hashrnd+0x0/0x16 returned 0 after 4 usecs
[    5.512059] hub 1-0:1.0: state 7 ports 8 chg 0100 evt 0000
[    5.512156] hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
[    5.563254] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[    5.563350] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
[    5.563490] hub 1-0:1.0: port 8 not reset yet, waiting 50ms
[    5.614058] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
[    5.614211] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.614311] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
[    5.704097] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    5.704195] uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
[    5.704315] hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    5.808059] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    5.910056] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    6.000070] Clocksource tsc unstable (delta = -270104002 ns)
[    6.011844] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
[    6.011976] serio: Synaptics pass-through port at isa0060/serio1/input0
[    6.030026] usb 5-2: ep0 maxpacket = 8
[    6.053781] usb 5-2: default language 0x0409
[    6.054626] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[    6.058807] async_waiting @ 1
[    6.058903] async_continuing @ 1 after 1 usec
[    6.059373] md: Waiting for all devices to be available before autodetect
[    6.059470] md: If you don't use raid, use raid=noautodetect
[    6.072781] usb 5-2: udev 2, busnum 5, minor = 513
[    6.072872] usb 5-2: New USB device found, idVendor=0483, idProduct=2016
[    6.072973] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.073094] usb 5-2: Product: Biometric Coprocessor
[    6.073190] usb 5-2: Manufacturer: STMicroelectronics
[    6.073349] usb 5-2: uevent
[    6.073630] usb 5-2: usb_probe_device
[    6.073719] usb 5-2: configuration #1 chosen from 1 choice
[    6.075783] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    6.075892] usb 5-2:1.0: uevent
[    6.076112] drivers/usb/core/inode.c: creating file '002'
[    6.076222] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    6.454033] usb usb2: suspend_rh (auto-stop)
[    6.454146] usb usb3: suspend_rh (auto-stop)
[    6.454261] usb usb4: suspend_rh (auto-stop)
[    7.704063] hub 2-0:1.0: hub_suspend
[    7.704155] usb usb2: bus auto-suspend
[    7.704249] usb usb2: suspend_rh
[    7.704367] hub 3-0:1.0: hub_suspend
[    7.704456] usb usb3: bus auto-suspend
[    7.704551] usb usb3: suspend_rh
[    7.704660] hub 4-0:1.0: hub_suspend
[    7.704748] usb usb4: bus auto-suspend
[    7.704843] usb usb4: suspend_rh
[    7.704952] hub 1-0:1.0: hub_suspend
[    7.705050] usb usb1: bus auto-suspend
[    7.705154] ehci_hcd 0000:00:1d.7: suspend root hub
[   11.497204] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   11.725545] input: TPPS/2 IBM TrackPoint as /class/input/input7
[   11.807485] async_waiting @ 1
[   11.807575] async_continuing @ 1 after 1 usec
[   11.807943] md: Autodetecting RAID arrays.
[   11.808049] md: Scanned 0 and added 0 devices.
[   11.808146] md: autorun ...
[   11.808240] md: ... autorun DONE.
[   12.181957] kjournald starting.  Commit interval 5 seconds
[   12.181982] EXT3-fs: mounted filesystem with writeback data mode.
[   12.181993] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[   12.182046] async_waiting @ 1
[   12.182050] async_continuing @ 1 after 1 usec
[   12.182062] Freeing unused kernel memory: 376k freed
[   12.182560] Write protecting the kernel text: 4500k
[   12.182721] Write protecting the kernel read-only data: 2196k
[   13.464436] sh used greatest stack depth: 6284 bytes left
[   14.209169] mount used greatest stack depth: 6256 bytes left
[   15.252079] awk used greatest stack depth: 5956 bytes left
[   16.155028] eth0: no IPv6 routers present
[   16.398723] readahead[895]: segfault at 0 ip 00c693b3 sp bfdbd30c error 4 in libc-2.9.so[bf2000+16e000]
[   16.929854] usb usb2: uevent
[   16.929976] usb 2-0:1.0: uevent
[   16.930154] usb usb3: uevent
[   16.930269] usb 3-0:1.0: uevent
[   16.930424] usb usb4: uevent
[   16.930547] usb 4-0:1.0: uevent
[   16.930696] usb usb5: uevent
[   16.930809] usb 5-0:1.0: uevent
[   16.930935] usb 5-2: uevent
[   16.931069] usb 5-2:1.0: uevent
[   16.931226] usb usb1: uevent
[   16.931350] usb 1-0:1.0: uevent
[   25.714165] EXT3 FS on sda1, internal journal
[   27.705850] Adding 4096564k swap on /dev/sda2.  Priority:-1 extents:1 across:4096564k 
[   29.035661] ip used greatest stack depth: 5752 bytes left
[   45.490796] CPUFREQ: ondemand sampling_rate_max sysfs file is deprecated - used by: cat
[  102.555904] ssh used greatest stack depth: 5312 bytes left

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

# head: baace7ea
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31-rc5
# Sun Aug  9 12:56:59 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
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
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
# CONFIG_BOOTPARAM_SUPPORT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
# CONFIG_BROKEN_BOOT_EUROPE is not set
# CONFIG_BROKEN_BOOT_TITAN is not set
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
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
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
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
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
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_EVENT_PROFILE=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_COMPAT_BRK is not set
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
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

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
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP_SUPPORT is not set
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
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
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_CPU_DEBUG is not set
# CONFIG_UP_WANTED_1 is not set
CONFIG_SMP=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

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
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
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
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
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
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_DEFAULT_PS=y
CONFIG_MAC80211_DEFAULT_PS_VALUE=1

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y

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
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_AIC7XXX=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

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
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
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
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
CONFIG_TR=y
# CONFIG_IBMOL is not set
# CONFIG_IBMLS is not set
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH_COMMON=y
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH9K is not set
# CONFIG_AR9170_USB is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_HERMES is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_PCMCIA_IBMTR is not set
# CONFIG_WAN is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

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
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
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
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
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
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

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
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
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
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_KSYM_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

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
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
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
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--sdtB3X0nJg68CQEu--
