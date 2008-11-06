Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYKFFX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYKFFX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYKFFXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:23:49 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:58603 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750704AbYKFFXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:23:44 -0500
Date: Thu, 6 Nov 2008 00:23:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
Message-ID: <20081106052340.GA12762@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>
References: <20081104224510.GA7672@mit.edu> <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com> <20081105153508.GB22998@mit.edu> <86802c440811050922o53f494c6y7b007f094a6ece2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <86802c440811050922o53f494c6y7b007f094a6ece2e@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 05, 2008 at 09:22:38AM -0800, Yinghai Lu wrote:
> > What is your theory for why this was causing a failure in the timer
> > subsystem?  Were we overrunning the end of irq_desc array and stomping
> > on some other data structure?
> 
> Yes. Please do apply that two patches at first.
> 

Success!  Applying these two patches, as found at:

	http://lkml.org/lkml/2008/11/4/431
        http://lkml.org/lkml/2008/11/5/81

... and my 2.6.28-rc3-git2 based kernel successfully booted on my
system.

I'll update:  http://bugzilla.kernel.org/show_bug.cgi?id=11951
accordingly.   Are these two patches scheduled to be pushed to 
mainstream, hopefully ASAP since they are a regression fix?

						- Ted

P.S.  I've attached the dmesg of the patched 2.6.28-rc3-git2 kernel.





--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] BIOS EBDA/lowmem at: 0009b400/0009b400
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.28-rc3-00123-g72a0780 (root@closure) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #97 SMP Wed Nov 5 22:59:25 EST 2008
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b400 (usable)
[    0.000000]  BIOS-e820: 000000000009b400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
[    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff78000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff78000 - 00000000cff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 3792a000 - 37fef6ae
[    0.000000] Allocated new RAMDISK: 00cb3000 - 013786ae
[    0.000000] Move RAMDISK from 000000003792a000 - 0000000037fef6ad to 00cb3000 - 013786ad
[    0.000000] ACPI: RSDP 000F6860, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT CFF72D76, 003C (r1 PTLTD    RSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP CFF77E20, 0074 (r1 INTEL  LINDHRST  6040000 PTL         3)
[    0.000000] ACPI: DSDT CFF731CC, 4C54 (r1  Intel LINDHRST  6040000 MSFT  100000E)
[    0.000000] ACPI: FACS CFF78FC0, 0040
[    0.000000] ACPI: APIC CFF77E94, 00B4 (r1 PTLTD  	 APIC    6040000  LTP        0)
[    0.000000] ACPI: BOOT CFF77F48, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: SPCR CFF77F70, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
[    0.000000] ACPI: MCFG CFF77FC0, 0040 (r1 PTLTD  	 MCFG    6040000  LTP        0)
[    0.000000] ACPI: SSDT CFF72DB2, 041A (r1  PmRef    CpuPm     3000 INTL 20030224)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3974MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 00000000 - 379fe000
[    0.000000]   bootmap 0000a000 - 00010f40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000ca725c]    TEXT DATA BSS ==> [0000100000 - 0000ca725c]
[    0.000000]   #4 [0000ca8000 - 0000cb3000]    INIT_PG_TABLE ==> [0000ca8000 - 0000cb3000]
[    0.000000]   #5 [000009b400 - 0000100000]    BIOS reserved ==> [000009b400 - 0000100000]
[    0.000000]   #6 [0000007000 - 000000a000]          PGTABLE ==> [0000007000 - 000000a000]
[    0.000000]   #7 [0000cb3000 - 00013786ae]      NEW RAMDISK ==> [0000cb3000 - 00013786ae]
[    0.000000]   #8 [000000a000 - 0000011000]          BOOTMAP ==> [000000a000 - 0000011000]
[    0.000000] found SMP MP-table at [c00f6800] 000f6800
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000cff70
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048331
[    0.000000] free_area_init_node: node 0, pgdat c06a7e80, node_mem_map c1379000
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 3059 pages used for memmap
[    0.000000]   Normal zone: 220683 pages, LIFO batch:31
[    0.000000]   HighMem zone: 13910 pages used for memmap
[    0.000000]   HighMem zone: 806684 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec80400] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec84000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec84400] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 8, version 32, address 0xfec84400, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 5 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/io_apic.c:3614 probe_nr_irqs+0x44/0x4d()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28-rc3-00123-g72a0780 #97
[    0.000000] Call Trace:
[    0.000000]  [<c01418f1>] warn_on_slowpath+0x46/0x60
[    0.000000]  [<c0160a3e>] ? __lock_acquire+0x3d9/0xa5b
[    0.000000]  [<c06dd463>] ? alloc_bootmem_core+0x1bf/0x221
[    0.000000]  [<c012db8b>] ? native_pmd_val+0x8/0xa
[    0.000000]  [<c01324a2>] ? pmd_val+0x11/0x21
[    0.000000]  [<c011bb31>] ? sched_clock+0xc/0x1c
[    0.000000]  [<c015e5fb>] ? lock_release_holdtime+0x43/0x48
[    0.000000]  [<c016142c>] ? lock_release+0x14c/0x155
[    0.000000]  [<c015e46b>] ? trace_hardirqs_off_caller+0x79/0x84
[    0.000000]  [<c04ab040>] ? _spin_unlock_irqrestore+0x3e/0x55
[    0.000000]  [<c015e5b6>] ? trace_hardirqs_off+0xb/0xd
[    0.000000]  [<c04ab040>] ? _spin_unlock_irqrestore+0x3e/0x55
[    0.000000]  [<c06d5853>] probe_nr_irqs+0x44/0x4d
[    0.000000]  [<c06cbfe8>] setup_arch+0xa90/0xb00
[    0.000000]  [<c015e46b>] ? trace_hardirqs_off_caller+0x79/0x84
[    0.000000]  [<c015e5b6>] ? trace_hardirqs_off+0xb/0xd
[    0.000000]  [<c015e91a>] ? lockdep_init_map+0x6b/0xc7
[    0.000000]  [<c06c65e2>] start_kernel+0x85/0x30e
[    0.000000]  [<c06c6080>] __init_begin+0x80/0x88
[    0.000000] ---[ end trace 8305b6ae03c24dde ]---
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
[    0.000000] PERCPU: Allocating 1216512 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1031306
[    0.000000] Kernel command line: root=UUID=051dd1fd-28e9-4b92-b970-03406cf78bf3 ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c084f000 soft=c0847000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2992.467 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:           4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2463 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 4099644k/4980736k available (3770k kernel code, 92804k reserved, 2121k data, 1528k init, 3282376k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff50000 - 0xfffff000   ( 700 kB)
[    0.003333]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.003333]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.003333]       .init : 0xc06c6000 - 0xc0844000   (1528 kB)
[    0.003333]       .data : 0xc04aeb44 - 0xc06c10c4   (2121 kB)
[    0.003333]       .text : 0xc0100000 - 0xc04aeb44   (3770 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.003350] Calibrating delay loop (skipped), value calculated using timer frequency.. 5987.30 BogoMIPS (lpj=9974890)
[    0.003383] Security Framework initialized
[    0.003398] SELinux:  Disabled at boot.
[    0.003418] Mount-cache hash table entries: 512
[    0.003736] Initializing cgroup subsys debug
[    0.003742] Initializing cgroup subsys ns
[    0.003747] Initializing cgroup subsys cpuacct
[    0.003753] Initializing cgroup subsys devices
[    0.003756] Initializing cgroup subsys freezer
[    0.003780] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003785] CPU: L2 cache: 2048K
[    0.003789] CPU: Physical Processor ID: 0
[    0.003792] CPU: Processor Core ID: 0
[    0.003796] Intel machine check architecture supported.
[    0.003804] Intel machine check reporting enabled on CPU#0.
[    0.003808] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.003812] using mwait in idle threads.
[    0.003833] Checking 'hlt' instruction... OK.
[    0.018444] ACPI: Core revision 20080926
[    0.030008] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.030016] ftrace: allocating 23328 entries in 91 pages
[    0.034024] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.067858] CPU0: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.069998] lockdep: fixing up alternatives.
[    0.069998] CPU 1 irqstacks, hard=c0850000 soft=c0848000
[    0.069998] Booting processor 1 APIC 0x6 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6055.16 BogoMIPS (lpj=10088261)
[    0.003333] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 3
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.003333] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.161229] CPU1: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.161244] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.163495] lockdep: fixing up alternatives.
[    0.163518] CPU 2 irqstacks, hard=c0851000 soft=c0849000
[    0.163522] Booting processor 2 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 5987.97 BogoMIPS (lpj=9974362)
[    0.003333] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#2.
[    0.003333] CPU2: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.257984] CPU2: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.258012] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.260184] lockdep: fixing up alternatives.
[    0.260212] CPU 3 irqstacks, hard=c0852000 soft=c084a000
[    0.260216] Booting processor 3 APIC 0x7 ip 0x6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 5987.20 BogoMIPS (lpj=9974721)
[    0.003333] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 3
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#3.
[    0.003333] CPU3: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.354577] CPU3: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.354603] checking TSC synchronization [CPU#0 -> CPU#3]:
[    0.356665] Measured 210 cycles TSC warp between CPUs, turning off TSC clock.
[    0.356665] Marking TSC unstable due to check_tsc_sync_source failed
[    0.356682] Brought up 4 CPUs
[    0.356688] Total of 4 processors activated (24016.64 BogoMIPS).
[    0.356769] CPU0 attaching sched-domain:
[    0.356774]  domain 0: span 0,2 level SIBLING
[    0.356778]   groups: 0 2
[    0.356785]   domain 1: span 0-3 level CPU
[    0.356788]    groups: 0,2 1,3
[    0.356798] CPU1 attaching sched-domain:
[    0.356801]  domain 0: span 1,3 level SIBLING
[    0.356805]   groups: 1 3
[    0.356810]   domain 1: span 0-3 level CPU
[    0.356814]    groups: 1,3 0,2
[    0.356823] CPU2 attaching sched-domain:
[    0.356826]  domain 0: span 0,2 level SIBLING
[    0.356829]   groups: 2 0
[    0.356834]   domain 1: span 0-3 level CPU
[    0.356838]    groups: 0,2 1,3
[    0.356846] CPU3 attaching sched-domain:
[    0.356849]  domain 0: span 1,3 level SIBLING
[    0.356852]   groups: 3 1
[    0.356858]   domain 1: span 0-3 level CPU
[    0.356861]    groups: 1,3 0,2
[    0.357057] khelper used greatest stack depth: 3012 bytes left
[    0.357057] net_namespace: 832 bytes
[    0.357057] Booting paravirtualized kernel on bare hardware
[    0.357131] NET: Registered protocol family 16
[    0.360075] ACPI: bus type pci registered
[    0.360092] PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG support.
[    0.360092] PCI: Using MMCONFIG for extended config space
[    0.360092] PCI: Using configuration type 1 for base access
[    0.374278] ACPI: EC: Look up EC in DSDT
[    0.379349] ACPI: Interpreter enabled
[    0.379356] ACPI: (supports S0 S1 S4 S5)
[    0.379388] ACPI: Using IOAPIC for interrupt routing
[    0.390136] ACPI: No dock devices found.
[    0.390164] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.390227] pci 0000:00:01.0: reg 10 32bit mmio: [0xdd000000-0xdd000fff]
[    0.390323] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.390329] pci 0000:00:02.0: PME# disabled
[    0.390401] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.390407] pci 0000:00:04.0: PME# disabled
[    0.390478] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.390484] pci 0000:00:06.0: PME# disabled
[    0.390582] pci 0000:00:1d.0: reg 20 io port: [0x1400-0x141f]
[    0.390654] pci 0000:00:1d.1: reg 20 io port: [0x1420-0x143f]
[    0.390726] pci 0000:00:1d.2: reg 20 io port: [0x1440-0x145f]
[    0.390797] pci 0000:00:1d.3: reg 20 io port: [0x1460-0x147f]
[    0.390877] pci 0000:00:1d.7: reg 10 32bit mmio: [0xdd001000-0xdd0013ff]
[    0.390937] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.390945] pci 0000:00:1d.7: PME# disabled
[    0.391063] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.391072] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[    0.391077] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
[    0.391109] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.391124] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.391139] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.391152] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.391163] pci 0000:00:1f.1: reg 20 io port: [0x14a0-0x14af]
[    0.391173] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
[    0.391243] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.391325] pci 0000:01:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.391359] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.391365] pci 0000:01:00.0: PME# disabled
[    0.391409] pci 0000:01:00.1: reg 10 32bit mmio: [0xdd100000-0xdd100fff]
[    0.391505] pci 0000:01:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.391539] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    0.391544] pci 0000:01:00.2: PME# disabled
[    0.391590] pci 0000:01:00.3: reg 10 32bit mmio: [0xdd101000-0xdd101fff]
[    0.391706] pci 0000:00:02.0: bridge io port: [0x2000-0x3fff]
[    0.391712] pci 0000:00:02.0: bridge 32bit mmio: [0xdd100000-0xdd3fffff]
[    0.391786] pci 0000:02:03.0: reg 10 io port: [0x2000-0x20ff]
[    0.391802] pci 0000:02:03.0: reg 14 64bit mmio: [0xdd220000-0xdd23ffff]
[    0.391818] pci 0000:02:03.0: reg 1c 64bit mmio: [0xdd200000-0xdd21ffff]
[    0.391834] pci 0000:02:03.0: reg 30 32bit mmio: [0x000000-0x0fffff]
[    0.391848] pci 0000:02:03.0: supports D1 D2
[    0.391916] pci 0000:02:03.1: reg 10 io port: [0x2400-0x24ff]
[    0.391932] pci 0000:02:03.1: reg 14 64bit mmio: [0xdd260000-0xdd27ffff]
[    0.391948] pci 0000:02:03.1: reg 1c 64bit mmio: [0xdd240000-0xdd25ffff]
[    0.391963] pci 0000:02:03.1: reg 30 32bit mmio: [0x000000-0x0fffff]
[    0.391977] pci 0000:02:03.1: supports D1 D2
[    0.392048] pci 0000:01:00.0: bridge io port: [0x2000-0x2fff]
[    0.392054] pci 0000:01:00.0: bridge 32bit mmio: [0xdd200000-0xdd2fffff]
[    0.392128] pci 0000:03:02.0: reg 10 64bit mmio: [0xdd300000-0xdd31ffff]
[    0.392149] pci 0000:03:02.0: reg 20 io port: [0x3000-0x303f]
[    0.392175] pci 0000:03:02.0: PME# supported from D0 D3hot D3cold
[    0.392181] pci 0000:03:02.0: PME# disabled
[    0.392250] pci 0000:03:02.1: reg 10 64bit mmio: [0xdd320000-0xdd33ffff]
[    0.392272] pci 0000:03:02.1: reg 20 io port: [0x3040-0x307f]
[    0.392297] pci 0000:03:02.1: PME# supported from D0 D3hot D3cold
[    0.392303] pci 0000:03:02.1: PME# disabled
[    0.392373] pci 0000:01:00.2: bridge io port: [0x3000-0x3fff]
[    0.392379] pci 0000:01:00.2: bridge 32bit mmio: [0xdd300000-0xdd3fffff]
[    0.392518] pci 0000:05:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.392551] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.392557] pci 0000:05:00.0: PME# disabled
[    0.392601] pci 0000:05:00.1: reg 10 32bit mmio: [0xdd400000-0xdd400fff]
[    0.392697] pci 0000:05:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.392730] pci 0000:05:00.2: PME# supported from D0 D3hot D3cold
[    0.392735] pci 0000:05:00.2: PME# disabled
[    0.392776] pci 0000:05:00.3: reg 10 32bit mmio: [0xdd401000-0xdd401fff]
[    0.392893] pci 0000:00:06.0: bridge 32bit mmio: [0xdd400000-0xdd5fffff]
[    0.392903] pci 0000:00:06.0: bridge 64bit mmio pref: [0xdf400000-0xdf7fffff]
[    0.393039] pci 0000:07:01.0: supports D1
[    0.393381] pci 0000:05:00.2: bridge 32bit mmio: [0xdd500000-0xdd5fffff]
[    0.393391] pci 0000:05:00.2: bridge 64bit mmio pref: [0xdf400000-0xdf7fffff]
[    0.393496] pci 0000:08:0e.0: reg 10 32bit mmio: [0xdd500000-0xdd500fff]
[    0.393515] pci 0000:08:0e.0: reg 18 32bit mmio: [0xdf400000-0xdf7fffff]
[    0.393551] pci 0000:08:0e.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.393567] pci 0000:08:0e.0: supports D1
[    0.393626] pci 0000:07:01.0: bridge 32bit mmio: [0xdd500000-0xdd5fffff]
[    0.393636] pci 0000:07:01.0: bridge 64bit mmio pref: [0xdf400000-0xdf7fffff]
[    0.393708] pci 0000:09:01.0: reg 10 32bit mmio: [0xde000000-0xdeffffff]
[    0.393718] pci 0000:09:01.0: reg 14 io port: [0x4000-0x40ff]
[    0.393728] pci 0000:09:01.0: reg 18 32bit mmio: [0xdd600000-0xdd600fff]
[    0.393758] pci 0000:09:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.393772] pci 0000:09:01.0: supports D1 D2
[    0.393830] pci 0000:00:1e.0: transparent bridge
[    0.393836] pci 0000:00:1e.0: bridge io port: [0x4000-0x4fff]
[    0.393843] pci 0000:00:1e.0: bridge 32bit mmio: [0xdd600000-0xdeffffff]
[    0.393875] bus 00 -> node 0
[    0.393885] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.394544] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.394734] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH0._PRT]
[    0.395051] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH1._PRT]
[    0.395278] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEY0._PRT]
[    0.395458] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0._PRT]
[    0.395639] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0.PXH0._PRT]
[    0.395819] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0.PXH1._PRT]
[    0.396018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.403467] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.406756] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.406907] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15)
[    0.407056] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.407206] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.407357] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    0.407507] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.407658] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 *10 11 14 15)
[    0.407756] ACPI: WMI: Mapper loaded
[    0.407756] SCSI subsystem initialized
[    0.407756] libata version 3.00 loaded.
[    0.407756] PCI: Using ACPI for IRQ routing
[    0.413347] NET: Registered protocol family 8
[    0.413352] NET: Registered protocol family 20
[    0.423402] cfg80211: Using static regulatory domain info
[    0.423402] cfg80211: Regulatory domain: US
[    0.423402] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.423402] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.423402] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.423402] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.423402] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.423402] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.423402] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.423402] cfg80211: Calling CRDA for country: US
[    0.423455] hpet clockevent registered
[    0.423465] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.423471] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.423479] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.433345] Switched to high resolution mode on CPU 0
[    0.434358] Switched to high resolution mode on CPU 1
[    0.434382] Switched to high resolution mode on CPU 3
[    0.434718] Switched to high resolution mode on CPU 2
[    0.436697] pnp: PnP ACPI init
[    0.436717] ACPI: bus type pnp registered
[    0.443231] pnp: PnP ACPI: found 12 devices
[    0.443236] ACPI: ACPI bus type pnp unregistered
[    0.443241] PnPBIOS: Disabled by ACPI PNP
[    0.443273] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.443278] system 00:01: ioport range 0x800-0x8df has been reserved
[    0.443283] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.443287] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    0.443291] system 00:01: ioport range 0xca2-0xca3 has been reserved
[    0.443295] system 00:01: ioport range 0xca8-0xcaf has been reserved
[    0.443299] system 00:01: ioport range 0x900-0x90f has been reserved
[    0.443303] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    0.443308] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.480179] pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
[    0.480186] pci 0000:01:00.0:   IO window: 0x2000-0x2fff
[    0.480194] pci 0000:01:00.0:   MEM window: 0xdd200000-0xdd2fffff
[    0.480200] pci 0000:01:00.0:   PREFETCH window: 0x000000d1000000-0x000000d11fffff
[    0.480210] pci 0000:01:00.2: PCI bridge, secondary bus 0000:03
[    0.480215] pci 0000:01:00.2:   IO window: 0x3000-0x3fff
[    0.480222] pci 0000:01:00.2:   MEM window: 0xdd300000-0xdd3fffff
[    0.480228] pci 0000:01:00.2:   PREFETCH window: disabled
[    0.480236] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.480241] pci 0000:00:02.0:   IO window: 0x2000-0x3fff
[    0.480248] pci 0000:00:02.0:   MEM window: 0xdd100000-0xdd3fffff
[    0.480255] pci 0000:00:02.0:   PREFETCH window: 0x000000d1000000-0x000000d11fffff
[    0.480264] pci 0000:00:04.0: PCI bridge, secondary bus 0000:04
[    0.480267] pci 0000:00:04.0:   IO window: disabled
[    0.480274] pci 0000:00:04.0:   MEM window: disabled
[    0.480280] pci 0000:00:04.0:   PREFETCH window: disabled
[    0.480292] pci 0000:05:00.0: PCI bridge, secondary bus 0000:06
[    0.480295] pci 0000:05:00.0:   IO window: disabled
[    0.480301] pci 0000:05:00.0:   MEM window: disabled
[    0.480307] pci 0000:05:00.0:   PREFETCH window: disabled
[    0.480318] pci 0000:07:01.0: PCI bridge, secondary bus 0000:08
[    0.480321] pci 0000:07:01.0:   IO window: disabled
[    0.480329] pci 0000:07:01.0:   MEM window: 0xdd500000-0xdd5fffff
[    0.480335] pci 0000:07:01.0:   PREFETCH window: 0x000000df400000-0x000000df7fffff
[    0.480344] pci 0000:05:00.2: PCI bridge, secondary bus 0000:07
[    0.480347] pci 0000:05:00.2:   IO window: disabled
[    0.480354] pci 0000:05:00.2:   MEM window: 0xdd500000-0xdd5fffff
[    0.480360] pci 0000:05:00.2:   PREFETCH window: 0x000000df400000-0x000000df7fffff
[    0.480369] pci 0000:00:06.0: PCI bridge, secondary bus 0000:05
[    0.480372] pci 0000:00:06.0:   IO window: disabled
[    0.480379] pci 0000:00:06.0:   MEM window: 0xdd400000-0xdd5fffff
[    0.480385] pci 0000:00:06.0:   PREFETCH window: 0x000000df400000-0x000000df7fffff
[    0.480395] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
[    0.480401] pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
[    0.480409] pci 0000:00:1e.0:   MEM window: 0xdd600000-0xdeffffff
[    0.480415] pci 0000:00:1e.0:   PREFETCH window: 0x000000d1200000-0x000000d12fffff
[    0.480440] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.480447] pci 0000:00:02.0: setting latency timer to 64
[    0.480461] pci 0000:01:00.0: setting latency timer to 64
[    0.480475] pci 0000:01:00.2: setting latency timer to 64
[    0.480487] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.480493] pci 0000:00:04.0: setting latency timer to 64
[    0.480504] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.480510] pci 0000:00:06.0: setting latency timer to 64
[    0.480522] pci 0000:05:00.0: setting latency timer to 64
[    0.480535] pci 0000:05:00.2: setting latency timer to 64
[    0.480553] pci 0000:00:1e.0: setting latency timer to 64
[    0.480559] bus: 00 index 0 io port: [0x00-0xffff]
[    0.480563] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.480567] bus: 01 index 0 io port: [0x2000-0x3fff]
[    0.480570] bus: 01 index 1 mmio: [0xdd100000-0xdd3fffff]
[    0.480573] bus: 01 index 2 mmio: [0xd1000000-0xd11fffff]
[    0.480576] bus: 01 index 3 mmio: [0x0-0x0]
[    0.480579] bus: 02 index 0 io port: [0x2000-0x2fff]
[    0.480582] bus: 02 index 1 mmio: [0xdd200000-0xdd2fffff]
[    0.480585] bus: 02 index 2 mmio: [0xd1000000-0xd11fffff]
[    0.480588] bus: 02 index 3 mmio: [0x0-0x0]
[    0.480591] bus: 03 index 0 io port: [0x3000-0x3fff]
[    0.480594] bus: 03 index 1 mmio: [0xdd300000-0xdd3fffff]
[    0.480597] bus: 03 index 2 mmio: [0x0-0x0]
[    0.480600] bus: 03 index 3 mmio: [0x0-0x0]
[    0.480603] bus: 04 index 0 mmio: [0x0-0x0]
[    0.480606] bus: 04 index 1 mmio: [0x0-0x0]
[    0.480608] bus: 04 index 2 mmio: [0x0-0x0]
[    0.480611] bus: 04 index 3 mmio: [0x0-0x0]
[    0.480614] bus: 05 index 0 mmio: [0x0-0x0]
[    0.480617] bus: 05 index 1 mmio: [0xdd400000-0xdd5fffff]
[    0.480620] bus: 05 index 2 mmio: [0xdf400000-0xdf7fffff]
[    0.480623] bus: 05 index 3 mmio: [0x0-0x0]
[    0.480625] bus: 06 index 0 mmio: [0x0-0x0]
[    0.480628] bus: 06 index 1 mmio: [0x0-0x0]
[    0.480631] bus: 06 index 2 mmio: [0x0-0x0]
[    0.480634] bus: 06 index 3 mmio: [0x0-0x0]
[    0.480636] bus: 07 index 0 mmio: [0x0-0x0]
[    0.480639] bus: 07 index 1 mmio: [0xdd500000-0xdd5fffff]
[    0.480642] bus: 07 index 2 mmio: [0xdf400000-0xdf7fffff]
[    0.480645] bus: 07 index 3 mmio: [0x0-0x0]
[    0.480648] bus: 08 index 0 mmio: [0x0-0x0]
[    0.480651] bus: 08 index 1 mmio: [0xdd500000-0xdd5fffff]
[    0.480654] bus: 08 index 2 mmio: [0xdf400000-0xdf7fffff]
[    0.480657] bus: 08 index 3 mmio: [0x0-0x0]
[    0.480660] bus: 09 index 0 io port: [0x4000-0x4fff]
[    0.480663] bus: 09 index 1 mmio: [0xdd600000-0xdeffffff]
[    0.480666] bus: 09 index 2 mmio: [0xd1200000-0xd12fffff]
[    0.480669] bus: 09 index 3 io port: [0x00-0xffff]
[    0.480673] bus: 09 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.480688] NET: Registered protocol family 2
[    0.490966] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.491518] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.492341] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    0.493761] TCP: Hash tables configured (established 131072 bind 65536)
[    0.493767] TCP reno registered
[    0.497711] NET: Registered protocol family 1
[    0.497923] checking if image is initramfs... it is
[    1.114907] Freeing initrd memory: 6933k freed
[    1.115222] Simple Boot Flag at 0x39 set to 0x1
[    1.118203] alg: cipher: Test 1 failed on encryption for aes-asm
[    1.118271] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
[    1.118286] cryptomgr_test used greatest stack depth: 2824 bytes left
[    1.119046] audit: initializing netlink socket (disabled)
[    1.119080] type=2000 audit(1225947629.116:1): initialized
[    1.129720] highmem bounce pool size: 64 pages
[    1.129730] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.137038] VFS: Disk quotas dquot_6.5.1
[    1.137286] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.139529] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.140308] fuse init (API version 7.10)
[    1.140726] msgmni has been set to 1611
[    1.141169] alg: No test for cipher_null (cipher_null-generic)
[    1.141389] alg: No test for digest_null (digest_null-generic)
[    1.141487] alg: No test for compress_null (compress_null-generic)
[    1.141739] cryptomgr_test used greatest stack depth: 1912 bytes left
[    1.143550] alg: No test for stdrng (krng)
[    1.143892] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.143900] io scheduler noop registered
[    1.143930] io scheduler cfq registered (default)
[    1.144873] pci 0000:09:01.0: Boot video device
[    1.147502] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    1.147553] pci_express 0000:00:02.0:pcie00: allocate port service
[    1.147680] pci_express 0000:00:02.0:pcie01: allocate port service
[    1.147905] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    1.147952] pci_express 0000:00:04.0:pcie00: allocate port service
[    1.148067] pci_express 0000:00:04.0:pcie01: allocate port service
[    1.148284] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    1.148327] pci_express 0000:00:06.0:pcie00: allocate port service
[    1.148439] pci_express 0000:00:06.0:pcie01: allocate port service
[    1.150041] aer 0000:00:02.0:pcie01: AER service couldn't init device: no _OSC support
[    1.151187] aer 0000:00:04.0:pcie01: AER service couldn't init device: no _OSC support
[    1.152323] aer 0000:00:06.0:pcie01: AER service couldn't init device: no _OSC support
[    1.152928] input: Power Button (FF) as /class/input/input0
[    1.152937] ACPI: Power Button (FF) [PWRF]
[    1.153154] input: Power Button (CM) as /class/input/input1
[    1.153163] ACPI: Power Button (CM) [PWRB]
[    1.154226] processor ACPI0007:00: registered as cooling_device0
[    1.154567] processor ACPI0007:01: registered as cooling_device1
[    1.154918] processor ACPI0007:02: registered as cooling_device2
[    1.155259] processor ACPI0007:03: registered as cooling_device3
[    1.157574] isapnp: Scanning for PnP cards...
[    1.516148] isapnp: No Plug & Play device found
[    1.605958] Non-volatile memory driver v1.2
[    1.605964] Linux agpgart interface v0.103
[    1.606075] [drm] Initialized drm 1.1.0 20060810
[    1.606080] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.606294] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.606534] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.607850] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.608488] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.613570] brd: module loaded
[    1.615848] loop: module loaded
[    1.615882] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    1.615886] Copyright (c) 1999-2006 Intel Corporation.
[    1.615947] e1000 0000:03:02.0: PCI INT A -> GSI 54 (level, low) -> IRQ 54
[    1.881797] e1000: 0000:03:02.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:78:2c:7e
[    1.913408] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    1.913441] e1000 0000:03:02.1: PCI INT B -> GSI 55 (level, low) -> IRQ 55
[    2.181800] e1000: 0000:03:02.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:78:2c:7f
[    2.213399] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    2.213539] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    2.213543] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    2.213900] input: Macintosh mouse button emulation as /class/input/input2
[    2.213959] Uniform Multi-Platform E-IDE driver
[    2.214199] ide-gd driver 1.18
[    2.214553] arcmsr 0000:08:0e.0: PCI INT A -> GSI 98 (level, low) -> IRQ 64
[    2.226715] ARECA RAID ADAPTER0: FIRMWARE VERSION V1.41 2006-5-24  
[    2.240022] scsi0 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[    2.240024]  Driver Version 1.20.00.15 2008/02/27
[    2.241308] Driver 'sd' needs updating - please use bus_type methods
[    2.241466] scsi 0:0:0:0: Direct-Access     ABERDEEN Boot Vol         R001 PQ: 0 ANSI: 3
[    2.241690] Fusion MPT base driver 3.04.07
[    2.241696] Copyright (c) 1999-2008 LSI Corporation
[    2.241718] Fusion MPT SPI Host driver 3.04.07
[    2.241726] scsi 0:0:0:1: Direct-Access     ABERDEEN Ted Data #1      R001 PQ: 0 ANSI: 3
[    2.241791] mptspi 0000:02:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    2.241909] scsi 0:0:0:2: Direct-Access     ABERDEEN Ted Data #2      R001 PQ: 0 ANSI: 3
[    2.241936] mptbase: ioc0: Initiating bringup
[    2.242087] scsi 0:0:0:3: Direct-Access     ABERDEEN Ted Data #3      R001 PQ: 0 ANSI: 3
[    2.243679] scsi 0:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[    2.244260] sd 0:0:0:0: [sda] 39061504 512-byte hardware sectors: (19.9 GB/18.6 GiB)
[    2.244330] sd 0:0:0:0: [sda] Write Protect is off
[    2.244335] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    2.244466] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.244675] sd 0:0:0:0: [sda] 39061504 512-byte hardware sectors: (19.9 GB/18.6 GiB)
[    2.244743] sd 0:0:0:0: [sda] Write Protect is off
[    2.244749] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    2.244864] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.244873]  sda: sda1 sda2 < sda5 >
[    2.257385] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.258218] sd 0:0:0:1: [sdb] 1464842240 512-byte hardware sectors: (749 GB/698 GiB)
[    2.258287] sd 0:0:0:1: [sdb] Write Protect is off
[    2.258292] sd 0:0:0:1: [sdb] Mode Sense: cb 00 00 08
[    2.258398] sd 0:0:0:1: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.258569] sd 0:0:0:1: [sdb] 1464842240 512-byte hardware sectors: (749 GB/698 GiB)
[    2.258638] sd 0:0:0:1: [sdb] Write Protect is off
[    2.258643] sd 0:0:0:1: [sdb] Mode Sense: cb 00 00 08
[    2.258756] sd 0:0:0:1: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.258765]  sdb: unknown partition table
[    2.259789] sd 0:0:0:1: [sdb] Attached SCSI disk
[    2.260491] sd 0:0:0:2: [sdc] 1464842240 512-byte hardware sectors: (749 GB/698 GiB)
[    2.260563] sd 0:0:0:2: [sdc] Write Protect is off
[    2.260569] sd 0:0:0:2: [sdc] Mode Sense: cb 00 00 08
[    2.260689] sd 0:0:0:2: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.260861] sd 0:0:0:2: [sdc] 1464842240 512-byte hardware sectors: (749 GB/698 GiB)
[    2.260927] sd 0:0:0:2: [sdc] Write Protect is off
[    2.260932] sd 0:0:0:2: [sdc] Mode Sense: cb 00 00 08
[    2.261053] sd 0:0:0:2: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.261063]  sdc: unknown partition table
[    2.262043] sd 0:0:0:2: [sdc] Attached SCSI disk
[    2.262732] sd 0:0:0:3: [sdd] 937496576 512-byte hardware sectors: (479 GB/447 GiB)
[    2.262794] sd 0:0:0:3: [sdd] Write Protect is off
[    2.262799] sd 0:0:0:3: [sdd] Mode Sense: cb 00 00 08
[    2.262928] sd 0:0:0:3: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.263131] sd 0:0:0:3: [sdd] 937496576 512-byte hardware sectors: (479 GB/447 GiB)
[    2.263201] sd 0:0:0:3: [sdd] Write Protect is off
[    2.263207] sd 0:0:0:3: [sdd] Mode Sense: cb 00 00 08
[    2.263333] sd 0:0:0:3: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.263341]  sdd: sdd1 sdd2
[    2.264222] sd 0:0:0:3: [sdd] Attached SCSI disk
[    2.646685] ioc0: LSI53C1030 C0: Capabilities={Initiator}
[    3.013449] scsi1 : ioc0: LSI53C1030 C0, FwRev=01030700h, Ports=1, MaxQ=222, IRQ=28
[    3.620139] mptspi 0000:02:03.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
[    3.620298] mptbase: ioc1: Initiating bringup
[    4.026684] ioc1: LSI53C1030 C0: Capabilities={Initiator}
[    4.393457] scsi2 : ioc1: LSI53C1030 C0, FwRev=01030700h, Ports=1, MaxQ=222, IRQ=29
[    5.000578] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    5.003539] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.003553] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.010330] mice: PS/2 mouse device common for all mice
[    5.015044] cpuidle: using governor ladder
[    5.015049] cpuidle: using governor menu
[    5.015243] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    5.020497] ALSA device list:
[    5.020501]   No soundcards found.
[    5.021833] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.021858] TCP cubic registered
[    5.022590] RPC: Registered udp transport module.
[    5.022594] RPC: Registered tcp transport module.
[    5.022713] Using IPI No-Shortcut mode
[    5.023565] scsi: waiting for bus probes to complete ...
[    5.047515] input: AT Translated Set 2 keyboard as /class/input/input3
[    5.680315] input: PS/2 Generic Mouse as /class/input/input4
[    8.755082] Freeing unused kernel memory: 1528k freed
[    8.755371] Write protecting the kernel read-only data: 1808k
[    9.066797] usplash[1538]: segfault at c1471 ip 00001471 sp 00000ffa error 15 in zero (deleted)[1000+9f000]
[   10.138762] device-mapper: uevent: version 1.0.3
[   10.139310] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   10.178456] md: linear personality registered for level -1
[   10.186457] md: multipath personality registered for level -4
[   10.193863] md: raid0 personality registered for level 0
[   10.203628] md: raid1 personality registered for level 1
[   10.210393] xor: automatically using best checksumming function: pIII_sse
[   10.227922]    pIII_sse  :  5544.000 MB/sec
[   10.227927] xor: using function: pIII_sse (5544.000 MB/sec)
[   10.228935] async_tx: api initialized (sync-only)
[   10.291308] raid6: int32x1    725 MB/s
[   10.347954] raid6: int32x2    727 MB/s
[   10.404658] raid6: int32x4    652 MB/s
[   10.461286] raid6: int32x8    598 MB/s
[   10.517939] raid6: mmxx1     1812 MB/s
[   10.574613] raid6: mmxx2     2058 MB/s
[   10.631257] raid6: sse1x1    1094 MB/s
[   10.687931] raid6: sse1x2    1927 MB/s
[   10.744594] raid6: sse2x1    2183 MB/s
[   10.801273] raid6: sse2x2    3132 MB/s
[   10.801276] raid6: using algorithm sse2x2 (3132 MB/s)
[   10.801282] md: raid6 personality registered for level 6
[   10.801286] md: raid5 personality registered for level 5
[   10.801289] md: raid4 personality registered for level 4
[   10.837081] md: raid10 personality registered for level 10
[   11.363730] kjournald starting.  Commit interval 5 seconds
[   11.363771] EXT3-fs: mounted filesystem with ordered data mode.
[   15.808959] udevd used greatest stack depth: 1800 bytes left
[   16.194963] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   16.587198] NET: Registered protocol family 10
[   16.589961] lo: Disabled Privacy Extensions
[   16.594335] modprobe used greatest stack depth: 1760 bytes left
[   17.111098] EDAC MC: Ver: 2.1.0 Nov  5 2008
[   17.271832] EDAC e752x: tolm = d0000, remapbase = 100000, remaplimit = 12c000
[   17.271932] EDAC MC0: Giving out device to 'e752x_edac' 'E7520': DEV 0000:00:00.0
[   17.272148] EDAC PCI0: Giving out device to module 'e752x_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
[   17.337020] usbcore: registered new interface driver usbfs
[   17.337178] usbcore: registered new interface driver hub
[   17.351997] ata_piix 0000:00:1f.1: version 2.12
[   17.352028] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   17.352118] ata_piix 0000:00:1f.1: setting latency timer to 64
[   17.374716] usbcore: registered new device driver usb
[   17.388278] uhci_hcd: USB Universal Host Controller Interface driver
[   17.388386] scsi3 : ata_piix
[   17.396082] scsi4 : ata_piix
[   17.398167] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x14a0 irq 14
[   17.398175] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x14a8 irq 15
[   17.409044] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   17.617915] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   17.617922] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[   17.678924] input: PC Speaker as /class/input/input5
[   17.710381] ata2.00: ATAPI: _NEC DVD+/-RW ND-6650A, 1.23, max UDMA/33
[   17.723636] ata2.00: configured for UDMA/33
[   17.734037] scsi 4:0:0:0: CD-ROM            _NEC     DVD+-RW ND-6650A 1.23 PQ: 0 ANSI: 5
[   17.734640] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.734659] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   17.734669] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.734867] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   17.734922] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001400
[   17.735204] usb usb1: configuration #1 chosen from 1 choice
[   17.735333] hub 1-0:1.0: USB hub found
[   17.735352] hub 1-0:1.0: 2 ports detected
[   17.735889] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   17.735896] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.735902] usb usb1: Product: UHCI Host Controller
[   17.735907] usb usb1: Manufacturer: Linux 2.6.28-rc3-00123-g72a0780 uhci_hcd
[   17.735912] usb usb1: SerialNumber: 0000:00:1d.0
[   17.735990] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   17.736379] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   17.736388] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   17.736512] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   17.740448] ehci_hcd 0000:00:1d.7: debug port 1
[   17.740461] ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
[   17.740492] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdd001000
[   17.744509] iTCO_vendor_support: vendor-support=0
[   17.750849] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   17.751086] iTCO_wdt: Found a ICH5 or ICH5R TCO device (Version=1, TCOBASE=0x1060)
[   17.751245] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   17.754196] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   17.754498] usb usb2: configuration #1 chosen from 1 choice
[   17.754641] hub 2-0:1.0: USB hub found
[   17.754664] hub 2-0:1.0: 8 ports detected
[   17.755163] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   17.755171] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.755176] usb usb2: Product: EHCI Host Controller
[   17.755182] usb usb2: Manufacturer: Linux 2.6.28-rc3-00123-g72a0780 ehci_hcd
[   17.755187] usb usb2: SerialNumber: 0000:00:1d.7
[   17.755267] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   17.755283] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   17.755291] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.755402] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   17.755454] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001420
[   17.755727] usb usb3: configuration #1 chosen from 1 choice
[   17.755860] hub 3-0:1.0: USB hub found
[   17.755879] hub 3-0:1.0: 2 ports detected
[   17.760170] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   17.760178] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.760184] usb usb3: Product: UHCI Host Controller
[   17.760189] usb usb3: Manufacturer: Linux 2.6.28-rc3-00123-g72a0780 uhci_hcd
[   17.760194] usb usb3: SerialNumber: 0000:00:1d.1
[   17.760256] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   17.760271] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   17.760279] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   17.760394] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   17.760446] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001440
[   17.760729] usb usb4: configuration #1 chosen from 1 choice
[   17.760901] hub 4-0:1.0: USB hub found
[   17.760921] hub 4-0:1.0: 2 ports detected
[   17.761356] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   17.761363] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.761370] usb usb4: Product: UHCI Host Controller
[   17.761375] usb usb4: Manufacturer: Linux 2.6.28-rc3-00123-g72a0780 uhci_hcd
[   17.761381] usb usb4: SerialNumber: 0000:00:1d.2
[   17.761444] uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.761465] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   17.761474] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   17.761586] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   17.761619] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001460
[   17.761902] usb usb5: configuration #1 chosen from 1 choice
[   17.762032] hub 5-0:1.0: USB hub found
[   17.762050] hub 5-0:1.0: 2 ports detected
[   17.762504] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   17.762511] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.762517] usb usb5: Product: UHCI Host Controller
[   17.762522] usb usb5: Manufacturer: Linux 2.6.28-rc3-00123-g72a0780 uhci_hcd
[   17.762527] usb usb5: SerialNumber: 0000:00:1d.3
[   17.762941] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   17.810816] Floppy drive(s): fd0 is 1.44M
[   17.837594] FDC 0 is a National Semiconductor PC87306
[   17.850961] intel_rng: FWH not detected
[   18.716834] Driver 'sr' needs updating - please use bus_type methods
[   18.724398] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[   18.742826] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   18.742835] Uniform CD-ROM driver Revision: 3.20
[   18.743182] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   18.813068] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.813180] sd 0:0:0:1: Attached scsi generic sg1 type 0
[   18.813293] sd 0:0:0:2: Attached scsi generic sg2 type 0
[   18.813445] sd 0:0:0:3: Attached scsi generic sg3 type 0
[   18.813585] scsi 0:0:16:0: Attached scsi generic sg4 type 3
[   18.813723] sr 4:0:0:0: Attached scsi generic sg5 type 5
[   19.745910] lp: driver loaded but no devices found
[   19.876784] Adding 827308k swap on /dev/sda5.  Priority:-1 extents:1 across:827308k
[   20.187676] EXT3 FS on sda1, internal journal
[   20.826311] kjournald starting.  Commit interval 5 seconds
[   20.826638] EXT3 FS on sdc, internal journal
[   20.826653] EXT3-fs: mounted filesystem with ordered data mode.
[   21.012483] ISO 9660 Extensions: Microsoft Joliet Level 3
[   21.103968] ISO 9660 Extensions: RRIP_1991A
[   23.369385] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[   24.657314] ppdev: user-space parallel port driver
[   24.949010] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   24.949015] apm: disabled - APM is not SMP safe.
[   26.790428] eth0: no IPv6 routers present
[   27.807225] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   27.817857] NFSD: starting 90-second grace period
[   30.007422] lsb_release used greatest stack depth: 1752 bytes left
[   32.115122] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   32.685297] NET: Registered protocol family 17
[   32.891483] mtrr: type mismatch for de000000,800000 old: write-back new: write-combining
[   32.915222] mtrr: type mismatch for de000000,800000 old: write-back new: write-combining

--SLDf9lqlvOQaIe6s--
