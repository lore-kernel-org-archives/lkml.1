Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZG3XUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZG3XUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZG3XUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:20:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36924 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZG3XUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:20:33 -0400
Message-ID: <4A722ABA.1090903@us.ibm.com>
Date: Thu, 30 Jul 2009 16:20:26 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain> <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain> <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain> <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain> <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain> <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
 > We are pleased to announce the next update to our new preempt-rt
 > series.
 >
 >     - update to 2.6.31-rc4
 >
 > This is a major rework of the rt patch series. Thanks to Clark
 > Williams and John Kacur for providing the merge to 2.6.30 while I was
 > stabilizing .29-rt. While the 30-rt series looked quite stable, we
 > decided to skip 30-rt entirely to keep track with the ongoing mainline
 > development for various reaons. The .31-rt series is planned to be
 > stabilized as we have done with .29-rt.

I hit this on boot on an IBM Thinkpad T60p (Intel Core Duo).  Haven't
had a chance to dig in yet, but wanted to post sooner rather than later.

[    4.764702] Freeing unused kernel memory: 552k freed
[    4.765205] Write protecting the kernel text: 4552k
[    4.765389] Write protecting the kernel read-only data: 1776k
[    4.766458] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[    4.766596] in_atomic(): 1, irqs_disabled(): 0, pid: 103, name: init
[    4.766723] Pid: 103, comm: init Not tainted 2.6.31-rc4-rt1-dvh01 #1
[    4.766848] Call Trace:
[    4.766973]  [<c012d881>] __might_sleep+0xe1/0x100
[    4.767099]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[    4.767224]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[    4.767350]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[    4.767477]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[    4.767604]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[    4.767728]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[    4.767852]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[    4.767977]  [<c037d634>] ? get_random_int+0xb4/0xe0
[    4.768114]  [<c0140481>] mmput+0x51/0xc0
[    4.768237]  [<c01ef651>] flush_old_exec+0x381/0x6c0
[    4.768361]  [<c01ea0c6>] ? vfs_read+0x126/0x190
[    4.768484]  [<c01eea3f>] ? kernel_read+0x3f/0x60
[    4.768609]  [<c02228cb>] load_elf_binary+0x33b/0x18c0
[    4.768734]  [<c012f06f>] ? __wake_up+0x3f/0x50
[    4.768859]  [<c01ccfee>] ? kunmap_high+0x7e/0xb0
[    4.768983]  [<c01ccede>] ? page_address+0x8e/0x90
[    4.769125]  [<c01cd15b>] ? kmap_high+0x13b/0x4c0
[    4.769248]  [<c01d1752>] ? __get_user_pages+0x112/0x3d0
[    4.769374]  [<c012f06f>] ? __wake_up+0x3f/0x50
[    4.769498]  [<c056cd9a>] ? __rt_spin_lock+0x2a/0x70
[    4.769623]  [<c0222590>] ? load_elf_binary+0x0/0x18c0
[    4.769747]  [<c01eedbd>] search_binary_handler+0xfd/0x300
[    4.769872]  [<c01f0568>] do_execve+0x228/0x300
[    4.769996]  [<c0319626>] ? strncpy_from_user+0x46/0x70
[    4.770121]  [<c0101b16>] sys_execve+0x36/0x60
[    4.770244]  [<c0103025>] syscall_call+0x7/0xb

Followed by numerous other instances of the same BUG point from various
processes.  The entire dmesg follows.


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc4-rt1-dvh01 (dvhart@aeon) (gcc 
version 4.1.3 20080623 (prerelease) (Ubuntu 4.1.2-24ubuntu1)) #1 SMP 
PREEMPT RT Thu Jul 30 14:42:05 PDT 2009
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
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfedf000 - 00000000bff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0xbfed0 max_arch_pfn = 0x100000
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
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bfed0000 (usable)
[    0.000000]  modified: 00000000bfed0000 - 00000000bfedf000 (ACPI data)
[    0.000000]  modified: 00000000bfedf000 - 00000000bff00000 (ACPI NVS)
[    0.000000]  modified: 00000000bff00000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37c6b000 - 37fefa92
[    0.000000] Allocated new RAMDISK: 008c1000 - 00c45a92
[    0.000000] Move RAMDISK from 0000000037c6b000 - 0000000037fefa91 to 
008c1000 - 00c45a91
[    0.000000] ACPI: RSDP 000f67e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT bfed14a0 00084 (v01 LENOVO TP-79    00002220 
LTP 00000000)
[    0.000000] ACPI: FACP bfed1600 000F4 (v03 LENOVO TP-79    00002220 
LNVO 00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 
20090521 tbfadt-527
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address 
or length: 000000000000102C/0 20090521 tbfadt-558
[    0.000000] ACPI: DSDT bfed195e 0D467 (v01 LENOVO TP-79    00002220 
MSFT 0100000E)
[    0.000000] ACPI: FACS bfef4000 00040
[    0.000000] ACPI: SSDT bfed17b4 001AA (v01 LENOVO TP-79    00002220 
MSFT 0100000E)
[    0.000000] ACPI: ECDT bfededc5 00052 (v01 LENOVO TP-79    00002220 
LNVO 00000001)
[    0.000000] ACPI: TCPA bfedee17 00032 (v02 LENOVO TP-79    00002220 
LNVO 00000001)
[    0.000000] ACPI: APIC bfedee49 00068 (v01 LENOVO TP-79    00002220 
LNVO 00000001)
[    0.000000] ACPI: MCFG bfedeeb1 0003C (v01 LENOVO TP-79    00002220 
LNVO 00000001)
[    0.000000] ACPI: HPET bfedeeed 00038 (v01 LENOVO TP-79    00002220 
LNVO 00000001)
[    0.000000] ACPI: BOOT bfedefd8 00028 (v01 LENOVO TP-79    00002220 
LTP 00000001)
[    0.000000] ACPI: SSDT bfef2697 0025F (v01 LENOVO TP-79    00002220 
INTL 20050513)
[    0.000000] ACPI: SSDT bfef28f6 000A6 (v01 LENOVO TP-79    00002220 
INTL 20050513)
[    0.000000] ACPI: SSDT bfef299c 004F7 (v01 LENOVO TP-79    00002220 
INTL 20050513)
[    0.000000] ACPI: SSDT bfef2e93 001D8 (v01 LENOVO TP-79    00002220 
INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2182MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00008bc4cc]    TEXT DATA BSS ==> 
[0000100000 - 00008bc4cc]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> 
[000009f000 - 0000100000]
[    0.000000]   #5 [00008bd000 - 00008c0138]              BRK ==> 
[00008bd000 - 00008c0138]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> 
[0000007000 - 0000008000]
[    0.000000]   #7 [00008c1000 - 0000c45a92]      NEW RAMDISK ==> 
[00008c1000 - 0000c45a92]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> 
[0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00f6810] f6810
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000bfed0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfed0
[    0.000000] On node 0 totalpages: 786027
[    0.000000] free_area_init_node: node 0, pgdat c076ae80, node_mem_map 
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4366 pages used for memmap
[    0.000000]   HighMem zone: 554436 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 
00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 
00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: 
c0000000:30000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages at c282e000, static data 31876 
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 779885
[    0.000000] Kernel command line: root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 15722560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:000bfed0)
[    0.000000] Memory: 3090592k/3144512k available (4551k kernel code, 
52584k reserved, 2141k data, 552k init, 2235208k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1d000 - 0xfffff000   ( 904 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc0791000 - 0xc081b000   ( 552 kB)
[    0.000000]       .data : 0xc0571f24 - 0xc0789468   (2141 kB)
[    0.000000]       .text : 0xc0100000 - 0xc0571f24   (4551 kB)
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000000] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2161.452 MHz processor.
[    0.003161] Console: colour VGA+ 80x25
[    0.003165] console [tty0] enabled
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4322.90 BogoMIPS (lpj=8645808)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] Performance Counters: no PMU driver, software counters only.
[    0.004000] Checking 'hlt' instruction... OK.
[    0.017786] ACPI: Core revision 20090521
[    0.044008] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.044136] ftrace: allocating 20522 entries in 41 pages
[    0.048461] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.089536] CPU0: Genuine Intel(R) CPU           T2600  @ 2.16GHz 
stepping 08
[    0.116025] Booting processor 1 APIC 0x1 ip 0x6000
[    0.092001] Initializing CPU#1
[    0.092001] Calibrating delay using timer specific routine.. 4322.55 
BogoMIPS (lpj=8645106)
[    0.092001] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.092001] CPU: L2 cache: 2048K
[    0.092001] CPU: Physical Processor ID: 0
[    0.092001] CPU: Processor Core ID: 1
[    0.204552] CPU1: Genuine Intel(R) CPU           T2600  @ 2.16GHz 
stepping 08
[    0.205622] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.208001] Measured 615849 cycles TSC warp between CPUs, turning off 
TSC clock.
[    0.208001] Marking TSC unstable due to check_tsc_sync_source failed
[    0.208082] Brought up 2 CPUs
[    0.208202] Total of 2 processors activated (8645.45 BogoMIPS).
[    0.208379] CPU0 attaching sched-domain:
[    0.208382]  domain 0: span 0-1 level MC
[    0.208384]   groups: 0 1
[    0.208390] CPU1 attaching sched-domain:
[    0.208392]  domain 0: span 0-1 level MC
[    0.208394]   groups: 1 0
[    0.212156] Booting paravirtualized kernel on bare hardware
[    0.212459] regulator: core version 0.5
[    0.212459] Time: 23:09:12  Date: 07/30/09
[    0.212459] NET: Registered protocol family 16
[    0.212635] EISA bus registered
[    0.212760] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    0.212895] ACPI: bus type pci registered
[    0.213091] PCI: MCFG configuration 0: base f0000000 segment 0 buses 
0 - 63
[    0.213218] PCI: MCFG area at f0000000 reserved in E820
[    0.213340] PCI: Using MMCONFIG for extended config space
[    0.213462] PCI: Using configuration type 1 for base access
[    0.216061] bio: create slab <bio-0> at 0
[    0.216810] ACPI: EC: EC description table is found, configuring boot EC
[    0.224028] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.876428] ACPI: Interpreter enabled
[    0.876559] ACPI: (supports S0 S3 S4 S5)
[    0.877126] ACPI: Using IOAPIC for interrupt routing
[    1.513077] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    1.513204] ACPI: EC: driver started in interrupt mode
[    1.516055] ACPI: Power Resource [PUBS] (on)
[    2.768822] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    2.769480] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    2.769709] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.769835] pci 0000:00:01.0: PME# disabled
[    2.770041] pci 0000:00:1b.0: reg 10 64bit mmio: [0xee400000-0xee403fff]
[    2.770102] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.770229] pci 0000:00:1b.0: PME# disabled
[    2.770431] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.770558] pci 0000:00:1c.0: PME# disabled
[    2.770761] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    2.770888] pci 0000:00:1c.1: PME# disabled
[    2.771092] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    2.772088] pci 0000:00:1c.2: PME# disabled
[    2.772292] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    2.772419] pci 0000:00:1c.3: PME# disabled
[    2.772602] pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
[    2.772666] pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
[    2.772729] pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
[    2.772793] pci 0000:00:1d.3: reg 20 io port: [0x1860-0x187f]
[    2.772862] pci 0000:00:1d.7: reg 10 32bit mmio: [0xee404000-0xee4043ff]
[    2.772924] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.773052] pci 0000:00:1d.7: PME# disabled
[    2.773334] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 
ACPI/GPIO/TCO
[    2.773472] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 
GPIO
[    2.773600] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
1600 (mask 007f)
[    2.773737] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 
15e0 (mask 000f)
[    2.773874] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 
1680 (mask 001f)
[    2.774059] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    2.774067] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    2.774075] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    2.774083] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    2.774091] pci 0000:00:1f.1: reg 20 io port: [0x1880-0x188f]
[    2.774156] pci 0000:00:1f.2: reg 10 io port: [0x18c8-0x18cf]
[    2.774164] pci 0000:00:1f.2: reg 14 io port: [0x18ac-0x18af]
[    2.774173] pci 0000:00:1f.2: reg 18 io port: [0x18c0-0x18c7]
[    2.774181] pci 0000:00:1f.2: reg 1c io port: [0x18a8-0x18ab]
[    2.774189] pci 0000:00:1f.2: reg 20 io port: [0x18b0-0x18bf]
[    2.774197] pci 0000:00:1f.2: reg 24 32bit mmio: [0xee404400-0xee4047ff]
[    2.774234] pci 0000:00:1f.2: PME# supported from D3hot
[    2.774359] pci 0000:00:1f.2: PME# disabled
[    2.774541] pci 0000:00:1f.3: reg 20 io port: [0x18e0-0x18ff]
[    2.774638] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
[    2.774651] pci 0000:01:00.0: reg 14 io port: [0x2000-0x20ff]
[    2.774664] pci 0000:01:00.0: reg 18 32bit mmio: [0xee100000-0xee10ffff]
[    2.774701] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.774753] pci 0000:01:00.0: supports D1 D2
[    2.774823] pci 0000:00:01.0: bridge io port: [0x2000-0x2fff]
[    2.774827] pci 0000:00:01.0: bridge 32bit mmio: [0xee100000-0xee1fffff]
[    2.774832] pci 0000:00:01.0: bridge 64bit mmio pref: 
[0xd0000000-0xdfffffff]
[    2.774974] pci 0000:02:00.0: reg 10 32bit mmio: [0xee000000-0xee01ffff]
[    2.774999] pci 0000:02:00.0: reg 18 io port: [0x3000-0x301f]
[    2.775105] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.775295] pci 0000:02:00.0: PME# disabled
[    2.775552] pci 0000:00:1c.0: bridge io port: [0x3000-0x3fff]
[    2.775558] pci 0000:00:1c.0: bridge 32bit mmio: [0xee000000-0xee0fffff]
[    2.775635] pci 0000:03:00.0: reg 10 64bit mmio: [0xedf00000-0xedf0ffff]
[    2.775799] pci 0000:00:1c.1: bridge io port: [0x4000-0x5fff]
[    2.775804] pci 0000:00:1c.1: bridge 32bit mmio: [0xec000000-0xedffffff]
[    2.775812] pci 0000:00:1c.1: bridge 64bit mmio pref: 
[0xe4000000-0xe40fffff]
[    2.775872] pci 0000:00:1c.2: bridge io port: [0x6000-0x7fff]
[    2.775877] pci 0000:00:1c.2: bridge 32bit mmio: [0xe8000000-0xe9ffffff]
[    2.775885] pci 0000:00:1c.2: bridge 64bit mmio pref: 
[0xe4100000-0xe41fffff]
[    2.775945] pci 0000:00:1c.3: bridge io port: [0x8000-0x9fff]
[    2.775950] pci 0000:00:1c.3: bridge 32bit mmio: [0xea000000-0xebffffff]
[    2.776015] pci 0000:00:1c.3: bridge 64bit mmio pref: 
[0xe4200000-0xe42fffff]
[    2.776069] pci 0000:15:00.0: reg 10 32bit mmio: [0xe4300000-0xe4300fff]
[    2.776099] pci 0000:15:00.0: supports D1 D2
[    2.776102] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.776231] pci 0000:15:00.0: PME# disabled
[    2.776420] pci 0000:00:1e.0: transparent bridge
[    2.776544] pci 0000:00:1e.0: bridge io port: [0xa000-0xdfff]
[    2.776549] pci 0000:00:1e.0: bridge 32bit mmio: [0xe4300000-0xe7ffffff]
[    2.776557] pci 0000:00:1e.0: bridge 64bit mmio pref: 
[0xe0000000-0xe3ffffff]
[    2.776615] pci_bus 0000:00: on NUMA node 0
[    2.776620] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.776778] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    2.776855] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    2.776934] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    2.777013] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    2.777099] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    2.777185] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    2.781981] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    2.783352] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    2.784697] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    2.786070] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    2.787441] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    2.788851] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    2.790220] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    2.791589] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    2.792994] SCSI subsystem initialized
[    2.793121] libata version 3.00 loaded.
[    2.793121] usbcore: registered new interface driver usbfs
[    2.793121] usbcore: registered new interface driver hub
[    2.793121] usbcore: registered new device driver usb
[    2.793121] ACPI: WMI: Mapper loaded
[    2.793121] PCI: Using ACPI for IRQ routing
[    2.828022] Bluetooth: Core ver 2.15
[    2.828145] NET: Registered protocol family 31
[    2.828145] Bluetooth: HCI device and connection manager initialized
[    2.828264] Bluetooth: HCI socket layer initialized
[    2.828386] NET: Registered protocol family 8
[    2.828506] NET: Registered protocol family 20
[    2.828636] NetLabel: Initializing
[    2.828755] NetLabel:  domain hash size = 128
[    2.828874] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.829010] NetLabel:  unlabeled traffic allowed by default
[    2.829166] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.829708] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.885024] pnp: PnP ACPI init
[    2.885159] ACPI: bus type pnp registered
[    2.890774] pnp: PnP ACPI: found 14 devices
[    2.890895] ACPI: ACPI bus type pnp unregistered
[    2.891017] PnPBIOS: Disabled by ACPI PNP
[    2.891147] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    2.891274] system 00:00: iomem range 0xc0000-0xc3fff could not be 
reserved
[    2.891400] system 00:00: iomem range 0xc4000-0xc7fff could not be 
reserved
[    2.891527] system 00:00: iomem range 0xc8000-0xcbfff could not be 
reserved
[    2.891653] system 00:00: iomem range 0xcc000-0xcffff could not be 
reserved
[    2.891780] system 00:00: iomem range 0xd0000-0xd3fff could not be 
reserved
[    2.891908] system 00:00: iomem range 0xdc000-0xdffff could not be 
reserved
[    2.892037] system 00:00: iomem range 0xe0000-0xe3fff could not be 
reserved
[    2.892163] system 00:00: iomem range 0xe4000-0xe7fff could not be 
reserved
[    2.892290] system 00:00: iomem range 0xe8000-0xebfff could not be 
reserved
[    2.892417] system 00:00: iomem range 0xec000-0xeffff could not be 
reserved
[    2.892544] system 00:00: iomem range 0xf0000-0xfffff could not be 
reserved
[    2.892671] system 00:00: iomem range 0x100000-0xbfffffff could not 
be reserved
[    2.892805] system 00:00: iomem range 0xfec00000-0xfed3ffff could not 
be reserved
[    2.892942] system 00:00: iomem range 0xfed41000-0xffffffff could not 
be reserved
[    2.893103] system 00:02: ioport range 0x164e-0x164f has been reserved
[    2.893228] system 00:02: ioport range 0x1000-0x107f has been reserved
[    2.893354] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    2.893480] system 00:02: ioport range 0x800-0x80f has been reserved
[    2.893605] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    2.893731] system 00:02: ioport range 0x1600-0x165f could not be 
reserved
[    2.893858] system 00:02: iomem range 0xf0000000-0xf3ffffff has been 
reserved
[    2.893986] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[    2.894113] system 00:02: iomem range 0xfed14000-0xfed17fff has been 
reserved
[    2.894245] system 00:02: iomem range 0xfed18000-0xfed18fff has been 
reserved
[    2.894372] system 00:02: iomem range 0xfed19000-0xfed19fff has been 
reserved
[    2.929244] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    2.929369] pci 0000:00:01.0:   IO window: 0x2000-0x2fff
[    2.929494] pci 0000:00:01.0:   MEM window: 0xee100000-0xee1fffff
[    2.929620] pci 0000:00:01.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    2.929757] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    2.929882] pci 0000:00:1c.0:   IO window: 0x3000-0x3fff
[    2.930009] pci 0000:00:1c.0:   MEM window: 0xee000000-0xee0fffff
[    2.930135] pci 0000:00:1c.0:   PREFETCH window: disabled
[    2.930260] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    2.930385] pci 0000:00:1c.1:   IO window: 0x4000-0x5fff
[    2.930512] pci 0000:00:1c.1:   MEM window: 0xec000000-0xedffffff
[    2.930638] pci 0000:00:1c.1:   PREFETCH window: 
0x000000e4000000-0x000000e40fffff
[    2.930779] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    2.930904] pci 0000:00:1c.2:   IO window: 0x6000-0x7fff
[    2.931031] pci 0000:00:1c.2:   MEM window: 0xe8000000-0xe9ffffff
[    2.931157] pci 0000:00:1c.2:   PREFETCH window: 
0x000000e4100000-0x000000e41fffff
[    2.931298] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0c
[    2.931423] pci 0000:00:1c.3:   IO window: 0x8000-0x9fff
[    2.931549] pci 0000:00:1c.3:   MEM window: 0xea000000-0xebffffff
[    2.931676] pci 0000:00:1c.3:   PREFETCH window: 
0x000000e4200000-0x000000e42fffff
[    2.931819] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    2.931944] pci 0000:15:00.0:   IO window: 0x00a000-0x00a0ff
[    2.932076] pci 0000:15:00.0:   IO window: 0x00a400-0x00a4ff
[    2.932203] pci 0000:15:00.0:   PREFETCH window: 0xe0000000-0xe3ffffff
[    2.932332] pci 0000:15:00.0:   MEM window: 0xc0000000-0xc3ffffff
[    2.932460] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
[    2.932585] pci 0000:00:1e.0:   IO window: 0xa000-0xdfff
[    2.932712] pci 0000:00:1e.0:   MEM window: 0xe4300000-0xe7ffffff
[    2.932840] pci 0000:00:1e.0:   PREFETCH window: 
0x000000e0000000-0x000000e3ffffff
[    2.932989] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.933138] pci 0000:00:01.0: setting latency timer to 64
[    2.933148] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.933276] pci 0000:00:1c.0: setting latency timer to 64
[    2.933286] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.933415] pci 0000:00:1c.1: setting latency timer to 64
[    2.933424] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.933552] pci 0000:00:1c.2: setting latency timer to 64
[    2.933562] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.933690] pci 0000:00:1c.3: setting latency timer to 64
[    2.933696] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    2.933823] pci 0000:00:1e.0: setting latency timer to 64
[    2.933834] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.933965] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.933968] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    2.933971] pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]
[    2.933974] pci_bus 0000:01: resource 1 mem: [0xee100000-0xee1fffff]
[    2.933977] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    2.933980] pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
[    2.933982] pci_bus 0000:02: resource 1 mem: [0xee000000-0xee0fffff]
[    2.933985] pci_bus 0000:03: resource 0 io:  [0x4000-0x5fff]
[    2.933988] pci_bus 0000:03: resource 1 mem: [0xec000000-0xedffffff]
[    2.933991] pci_bus 0000:03: resource 2 pref mem [0xe4000000-0xe40fffff]
[    2.933994] pci_bus 0000:04: resource 0 io:  [0x6000-0x7fff]
[    2.933997] pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe9ffffff]
[    2.933999] pci_bus 0000:04: resource 2 pref mem [0xe4100000-0xe41fffff]
[    2.934002] pci_bus 0000:0c: resource 0 io:  [0x8000-0x9fff]
[    2.934005] pci_bus 0000:0c: resource 1 mem: [0xea000000-0xebffffff]
[    2.934008] pci_bus 0000:0c: resource 2 pref mem [0xe4200000-0xe42fffff]
[    2.934011] pci_bus 0000:15: resource 0 io:  [0xa000-0xdfff]
[    2.934014] pci_bus 0000:15: resource 1 mem: [0xe4300000-0xe7ffffff]
[    2.934017] pci_bus 0000:15: resource 2 pref mem [0xe0000000-0xe3ffffff]
[    2.934019] pci_bus 0000:15: resource 3 io:  [0x00-0xffff]
[    2.934022] pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffff]
[    2.934025] pci_bus 0000:16: resource 0 io:  [0xa000-0xa0ff]
[    2.934027] pci_bus 0000:16: resource 1 io:  [0xa400-0xa4ff]
[    2.934030] pci_bus 0000:16: resource 2 pref mem [0xe0000000-0xe3ffffff]
[    2.934033] pci_bus 0000:16: resource 3 mem: [0xc0000000-0xc3ffffff]
[    2.934089] NET: Registered protocol family 2
[    2.934323] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    2.934830] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    2.935740] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    2.937135] TCP: Hash tables configured (established 131072 bind 65536)
[    2.937268] TCP reno registered
[    2.937535] NET: Registered protocol family 1
[    2.937728] Trying to unpack rootfs image as initramfs...
[    3.032566] Freeing initrd memory: 3602k freed
[    3.036474] Simple Boot Flag at 0x35 set to 0x1
[    3.036744] cpufreq-nforce2: No nForce2 chipset.
[    3.036904] Scanning for low memory corruption every 60 seconds
[    3.037277] audit: initializing netlink socket (disabled)
[    3.037420] type=2000 audit(1248995354.037:1): initialized
[    3.041807] highmem bounce pool size: 64 pages
[    3.041932] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.050200] VFS: Disk quotas dquot_6.5.2
[    3.050366] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.050839] fuse init (API version 7.12)
[    3.050999] msgmni has been set to 1679
[    3.059383] alg: No test for stdrng (krng)
[    3.059518] io scheduler noop registered
[    3.059638] io scheduler anticipatory registered
[    3.059760] io scheduler deadline registered
[    3.059896] io scheduler cfq registered (default)
[    3.060144] pci 0000:01:00.0: Boot video device
[    3.060285] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    3.060292] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    3.060422] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    3.060432] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    3.060596] pcieport-driver 0000:00:1c.1: irq 26 for MSI/MSI-X
[    3.060607] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    3.060771] pcieport-driver 0000:00:1c.2: irq 27 for MSI/MSI-X
[    3.060782] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    3.060943] pcieport-driver 0000:00:1c.3: irq 28 for MSI/MSI-X
[    3.060954] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    3.061075] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.061822] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 
27d0 ss_vid 0 ss_did 0
[    3.062034] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    3.062057] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 
27d2 ss_vid 0 ss_did 0
[    3.062263] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    3.062285] pciehp 0000:00:1c.2:pcie04: HPC vendor_id 8086 device_id 
27d4 ss_vid 0 ss_did 0
[    3.062491] pciehp 0000:00:1c.2:pcie04: service driver pciehp loaded
[    3.062514] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 
27d6 ss_vid 0 ss_did 0
[    3.062721] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    3.062731] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.063554] ACPI: AC Adapter [AC] (on-line)
[    3.063764] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.063900] ACPI: Power Button [PWRF]
[    3.064086] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    3.064738] ACPI: Lid Switch [LID]
[    3.064907] input: Sleep Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    3.065081] ACPI: Sleep Button [SLPB]
[    3.065958] ACPI: SSDT bfef1d36 00282 (v01  PmRef  Cpu0Ist 00000100 
INTL 20050513)
[    3.066975] ACPI: SSDT bfef203d 0065A (v01  PmRef  Cpu0Cst 00000100 
INTL 20050513)
[    3.070496] ACPI Warning: Invalid throttling state, reset 20090521 
processor_throttling-843
[    3.071828] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.072415] processor LNXCPU:00: registered as cooling_device0
[    3.072540] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.073300] ACPI: SSDT bfef1c6e 000C8 (v01  PmRef  Cpu1Ist 00000100 
INTL 20050513)
[    3.074111] ACPI: SSDT bfef1fb8 00085 (v01  PmRef  Cpu1Cst 00000100 
INTL 20050513)
[    3.075178] ACPI Warning: Invalid throttling state, reset 20090521 
processor_throttling-843
[    3.076357] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.076916] processor LNXCPU:01: registered as cooling_device1
[    3.077057] ACPI: Processor [CPU1] (supports 8 throttling states)
[    3.713844] thermal LNXTHERM:01: registered as thermal_zone0
[    3.713974] ACPI: Thermal Zone [THM0] (60 C)
[    3.715529] thermal LNXTHERM:02: registered as thermal_zone1
[    3.715660] ACPI: Thermal Zone [THM1] (58 C)
[    3.715845] isapnp: Scanning for PnP cards...
[    3.760269] ACPI: Battery Slot [BAT0] (battery present)
[    4.070958] isapnp: No Plug & Play device found
[    4.072378] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.072673] Platform driver 'serial8250' needs updating - please use 
dev_pm_ops
[    4.073727] serial 00:0a: activated
[    4.073988] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.075361] brd: module loaded
[    4.076030] loop: module loaded
[    4.076236] input: Macintosh mouse button emulation as 
/devices/virtual/input/input3
[    4.076456] ahci 0000:00:1f.2: version 3.0
[    4.076471] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    4.076636] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    4.076706] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 
Gbps 0x1 impl SATA mode
[    4.076844] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part
[    4.076972] ahci 0000:00:1f.2: setting latency timer to 64
[    4.077147] scsi0 : ahci
[    4.077369] scsi1 : ahci
[    4.077561] scsi2 : ahci
[    4.077755] scsi3 : ahci
[    4.077966] ata1: SATA max UDMA/133 abar m1024@0xee404400 port 
0xee404500 irq 29
[    4.078101] ata2: DUMMY
[    4.078217] ata3: DUMMY
[    4.078333] ata4: DUMMY
[    4.078528] ata_piix 0000:00:1f.1: version 2.13
[    4.078538] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) 
-> IRQ 16
[    4.078702] ata_piix 0000:00:1f.1: setting latency timer to 64
[    4.078845] scsi4 : ata_piix
[    4.079037] scsi5 : ata_piix
[    4.079887] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 
irq 14
[    4.080016] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 
irq 15
[    4.080382] ata6: port disabled. ignoring.
[    4.080950] Fixed MDIO Bus: probed
[    4.081089] PPP generic driver version 2.4.2
[    4.081315] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.081944] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.082078] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) 
-> IRQ 19
[    4.082213] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.082217] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.082395] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    4.086454] ehci_hcd 0000:00:1d.7: debug port 1
[    4.086580] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.086629] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee404000
[    4.100027] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.100233] usb usb1: configuration #1 chosen from 1 choice
[    4.100387] hub 1-0:1.0: USB hub found
[    4.100513] hub 1-0:1.0: 8 ports detected
[    4.100716] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.100857] uhci_hcd: USB Universal Host Controller Interface driver
[    4.101608] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.101736] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    4.101867] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.101871] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.102030] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    4.102234] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
[    4.102450] usb usb2: configuration #1 chosen from 1 choice
[    4.102600] hub 2-0:1.0: USB hub found
[    4.102725] hub 2-0:1.0: 2 ports detected
[    4.102901] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) 
-> IRQ 17
[    4.103032] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.103036] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.103194] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    4.103393] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
[    4.103605] usb usb3: configuration #1 chosen from 1 choice
[    4.103759] hub 3-0:1.0: USB hub found
[    4.103883] hub 3-0:1.0: 2 ports detected
[    4.104512] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    4.104642] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.104772] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.104776] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.104934] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    4.105148] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    4.105363] usb usb4: configuration #1 chosen from 1 choice
[    4.105515] hub 4-0:1.0: USB hub found
[    4.105640] hub 4-0:1.0: 2 ports detected
[    4.105815] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) 
-> IRQ 19
[    4.105946] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    4.105949] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.106107] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    4.106300] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
[    4.106515] usb usb5: configuration #1 chosen from 1 choice
[    4.106668] hub 5-0:1.0: USB hub found
[    4.106792] hub 5-0:1.0: 2 ports detected
[    4.107029] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 
0x60,0x64 irq 1,12
[    4.107182] Platform driver 'i8042' needs updating - please use 
dev_pm_ops
[    4.115608] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.115733] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.115955] mice: PS/2 mouse device common for all mice
[    4.116213] rtc_cmos 00:07: RTC can wake from S4
[    4.116372] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    4.116557] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.116734] device-mapper: uevent: version 1.0.3
[    4.116917] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) 
initialised: dm-devel@redhat.com
[    4.117179] device-mapper: multipath: version 1.1.0 loaded
[    4.117307] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.117536] EISA: Probing bus 0 at eisa.0
[    4.117661] Cannot allocate resource for EISA slot 1
[    4.117783] Cannot allocate resource for EISA slot 2
[    4.117915] Cannot allocate resource for EISA slot 3
[    4.118036] Cannot allocate resource for EISA slot 4
[    4.118158] Cannot allocate resource for EISA slot 5
[    4.118279] Cannot allocate resource for EISA slot 6
[    4.118408] Cannot allocate resource for EISA slot 7
[    4.118530] Cannot allocate resource for EISA slot 8
[    4.118651] EISA: Detected 0 cards.
[    4.118975] cpuidle: using governor ladder
[    4.119246] cpuidle: using governor menu
[    4.119865] TCP cubic registered
[    4.120031] NET: Registered protocol family 10
[    4.120666] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input4
[    4.120677] lo: Disabled Privacy Extensions
[    4.121132] NET: Registered protocol family 17
[    4.121271] Bluetooth: L2CAP ver 2.13
[    4.121389] Bluetooth: L2CAP socket layer initialized
[    4.121512] Bluetooth: SCO (Voice Link) ver 0.6
[    4.121632] Bluetooth: SCO socket layer initialized
[    4.121793] Bluetooth: RFCOMM socket layer initialized
[    4.121931] Bluetooth: RFCOMM TTY layer initialized
[    4.122052] Bluetooth: RFCOMM ver 1.11
[    4.122915] Using IPI No-Shortcut mode
[    4.123098] PM: Resume from disk failed.
[    4.123116] registered taskstats version 1
[    4.123363]   Magic number: 1:319:202
[    4.125428] rtc_cmos 00:07: setting system clock to 2009-07-30 
23:09:16 UTC (1248995356)
[    4.125566] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.125690] EDD information not available.
[    4.244468] ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-4083N, 1.08, max UDMA/33
[    4.260366] ata5.00: configured for UDMA/33
[    4.396075] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.397600] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.397604] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.397979] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.397983] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.399225] ata1.00: ATA-7: HTS721010G9SA00, MCZIC10V, max UDMA/100
[    4.399351] ata1.00: 195371568 sectors, multi 16: LBA48
[    4.401105] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.401108] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.401484] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.401487] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.402740] ata1.00: configured for UDMA/100
[    4.412075] usb 1-6: new high speed USB device using ehci_hcd and 
address 2
[    4.418573] ata1.00: configured for UDMA/100
[    4.418696] ata1: EH complete
[    4.418948] scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9SA00 
  MCZI PQ: 0 ANSI: 5
[    4.419225] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.419274] sd 0:0:0:0: [sda] 195371568 512-byte logical blocks: (100 
GB/93.1 GiB)
[    4.419331] sd 0:0:0:0: [sda] Write Protect is off
[    4.419334] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.419364] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.419524]  sda:
[    4.423553] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4083N 
1.08 PQ: 0 ANSI: 5
[    4.427007] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    4.427145] Uniform CD-ROM driver Revision: 3.20
[    4.427353] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    4.427400] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    4.500039] Clocksource tsc unstable (delta = -172051710 ns)
[    4.544503] usb 1-6: configuration #1 chosen from 1 choice
[    4.544729] hub 1-6:1.0: USB hub found
[    4.544951] hub 1-6:1.0: 7 ports detected
[    4.749126]  sda1 sda2 sda3 sda4
[    4.764539] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.764702] Freeing unused kernel memory: 552k freed
[    4.765205] Write protecting the kernel text: 4552k
[    4.765389] Write protecting the kernel read-only data: 1776k
[    4.766458] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[    4.766596] in_atomic(): 1, irqs_disabled(): 0, pid: 103, name: init
[    4.766723] Pid: 103, comm: init Not tainted 2.6.31-rc4-rt1-dvh01 #1
[    4.766848] Call Trace:
[    4.766973]  [<c012d881>] __might_sleep+0xe1/0x100
[    4.767099]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[    4.767224]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[    4.767350]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[    4.767477]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[    4.767604]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[    4.767728]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[    4.767852]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[    4.767977]  [<c037d634>] ? get_random_int+0xb4/0xe0
[    4.768114]  [<c0140481>] mmput+0x51/0xc0
[    4.768237]  [<c01ef651>] flush_old_exec+0x381/0x6c0
[    4.768361]  [<c01ea0c6>] ? vfs_read+0x126/0x190
[    4.768484]  [<c01eea3f>] ? kernel_read+0x3f/0x60
[    4.768609]  [<c02228cb>] load_elf_binary+0x33b/0x18c0
[    4.768734]  [<c012f06f>] ? __wake_up+0x3f/0x50
[    4.768859]  [<c01ccfee>] ? kunmap_high+0x7e/0xb0
[    4.768983]  [<c01ccede>] ? page_address+0x8e/0x90
[    4.769125]  [<c01cd15b>] ? kmap_high+0x13b/0x4c0
[    4.769248]  [<c01d1752>] ? __get_user_pages+0x112/0x3d0
[    4.769374]  [<c012f06f>] ? __wake_up+0x3f/0x50
[    4.769498]  [<c056cd9a>] ? __rt_spin_lock+0x2a/0x70
[    4.769623]  [<c0222590>] ? load_elf_binary+0x0/0x18c0
[    4.769747]  [<c01eedbd>] search_binary_handler+0xfd/0x300
[    4.769872]  [<c01f0568>] do_execve+0x228/0x300
[    4.769996]  [<c0319626>] ? strncpy_from_user+0x46/0x70
[    4.770121]  [<c0101b16>] sys_execve+0x36/0x60
[    4.770244]  [<c0103025>] syscall_call+0x7/0xb
[    4.820201] usb 1-6.1: new high speed USB device using ehci_hcd and 
address 3
[    4.914790] usb 1-6.1: configuration #1 chosen from 1 choice
[    5.004207] usb 1-6.7: new full speed USB device using ehci_hcd and 
address 4
[    5.095913] usb 1-6.7: configuration #1 chosen from 1 choice
[    5.096341] hub 1-6.7:1.0: USB hub found
[    5.096806] hub 1-6.7:1.0: 4 ports detected
[    5.372342] usb 1-6.7.3: new low speed USB device using ehci_hcd and 
address 5
[    5.478548] usb 1-6.7.3: configuration #1 chosen from 1 choice
[    5.677319] usb 1-6.7.4: new low speed USB device using ehci_hcd and 
address 6
[    5.778048] usb 1-6.7.4: configuration #1 chosen from 1 choice
[    5.778265] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[    5.778403] in_atomic(): 1, irqs_disabled(): 0, pid: 217, name: udevd
[    5.778544] Pid: 217, comm: udevd Not tainted 2.6.31-rc4-rt1-dvh01 #1
[    5.778670] Call Trace:
[    5.778795]  [<c012d881>] __might_sleep+0xe1/0x100
[    5.778921]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[    5.779046]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[    5.779172]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[    5.779299]  [<c01e6f7f>] mem_cgroup_uncharge_cache_page+0xf/0x20
[    5.779426]  [<c01b87e3>] remove_from_page_cache+0x33/0x40
[    5.779552]  [<c01c1589>] truncate_complete_page+0x39/0x70
[    5.779677]  [<c01c1a82>] truncate_inode_pages_range+0xc2/0x330
[    5.779803]  [<c01cfd66>] ? unmap_mapping_range+0xd6/0x250
[    5.779929]  [<c047ca1e>] ? sock_recvmsg+0x10e/0x130
[    5.780072]  [<c01c1d0f>] truncate_inode_pages+0x1f/0x30
[    5.780197]  [<c01d00bf>] vmtruncate+0xdf/0x170
[    5.780320]  [<c01fe3dd>] inode_setattr+0x6d/0x1a0
[    5.780445]  [<c01c8669>] shmem_notify_change+0x69/0x120
[    5.780570]  [<c01fe651>] notify_change+0x141/0x330
[    5.780694]  [<c056c83d>] ? rt_mutex_lock+0x1d/0x50
[    5.780819]  [<c01e8cac>] do_truncate+0x6c/0x90
[    5.780944]  [<c01f46bd>] may_open+0x1cd/0x280
[    5.781084]  [<c01f490f>] do_filp_open+0x19f/0x820
[    5.781209]  [<c01e8128>] do_sys_open+0x58/0x120
[    5.781333]  [<c01e825e>] sys_open+0x2e/0x40
[    5.781456]  [<c0103025>] syscall_call+0x7/0xb
[    6.848637] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[    6.848778] in_atomic(): 1, irqs_disabled(): 0, pid: 822, name: sleep
[    6.848905] Pid: 822, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[    6.849047] Call Trace:
[    6.849171]  [<c012d881>] __might_sleep+0xe1/0x100
[    6.849296]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[    6.849421]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[    6.849546]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[    6.849672]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[    6.849797]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[    6.849920]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[    6.850043]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[    6.850167]  [<c0140481>] mmput+0x51/0xc0
[    6.850289]  [<c0146465>] exit_mm+0x105/0x140
[    6.850411]  [<c01465b5>] do_exit+0x115/0x760
[    6.850534]  [<c0146cc4>] sys_exit+0x14/0x20
[    6.850656]  [<c0103025>] syscall_call+0x7/0xb
[    7.854489] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[    7.854626] in_atomic(): 1, irqs_disabled(): 0, pid: 832, name: sleep
[    7.854752] Pid: 832, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[    7.854878] Call Trace:
[    7.854997]  [<c012d881>] __might_sleep+0xe1/0x100
[    7.855121]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[    7.855244]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[    7.855368]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[    7.855494]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[    7.855619]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[    7.855741]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[    7.855865]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[    7.855988]  [<c0140481>] mmput+0x51/0xc0
[    7.856119]  [<c0146465>] exit_mm+0x105/0x140
[    7.856241]  [<c01465b5>] do_exit+0x115/0x760
[    7.856363]  [<c0146cc4>] sys_exit+0x14/0x20
[    7.856485]  [<c0103025>] syscall_call+0x7/0xb
[    8.860301] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[    8.860438] in_atomic(): 1, irqs_disabled(): 0, pid: 842, name: sleep
[    8.860564] Pid: 842, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[    8.860689] Call Trace:
[    8.860809]  [<c012d881>] __might_sleep+0xe1/0x100
[    8.860932]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[    8.861088]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[    8.861212]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[    8.861338]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[    8.861463]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[    8.861586]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[    8.861710]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[    8.861833]  [<c0140481>] mmput+0x51/0xc0
[    8.861955]  [<c0146465>] exit_mm+0x105/0x140
[    8.862078]  [<c01465b5>] do_exit+0x115/0x760
[    8.862200]  [<c0146cc4>] sys_exit+0x14/0x20
[    8.862322]  [<c0103025>] syscall_call+0x7/0xb
[    9.866131] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[    9.867960] in_atomic(): 1, irqs_disabled(): 0, pid: 852, name: sleep
[    9.868102] Pid: 852, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[    9.868227] Call Trace:
[    9.868346]  [<c012d881>] __might_sleep+0xe1/0x100
[    9.868469]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[    9.868592]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[    9.868716]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[    9.868842]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[    9.868966]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[    9.869105]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[    9.869229]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[    9.869352]  [<c0140481>] mmput+0x51/0xc0
[    9.869474]  [<c0146465>] exit_mm+0x105/0x140
[    9.869597]  [<c01465b5>] do_exit+0x115/0x760
[    9.869719]  [<c0146cc4>] sys_exit+0x14/0x20
[    9.869841]  [<c0103025>] syscall_call+0x7/0xb
[   10.908948] EXT3-fs: mounted filesystem with writeback data mode.
[   10.909108] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   10.909244] in_atomic(): 1, irqs_disabled(): 0, pid: 863, name: exe
[   10.909371] Pid: 863, comm: exe Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   10.909496] Call Trace:
[   10.909616]  [<c012d881>] __might_sleep+0xe1/0x100
[   10.909740]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   10.909863]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   10.909987]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   10.910113]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   10.910237]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   10.910360]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   10.910484]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   10.910607]  [<c0140481>] mmput+0x51/0xc0
[   10.910729]  [<c0146465>] exit_mm+0x105/0x140
[   10.910852]  [<c01465b5>] do_exit+0x115/0x760
[   10.910973]  [<c01e208c>] ? kmem_cache_free+0x7c/0x120
[   10.911097]  [<c016df6d>] ? rt_up_read+0xd/0x10
[   10.911221]  [<c01be309>] ? __free_pages+0x29/0x30
[   10.911344]  [<c0146c36>] do_group_exit+0x36/0x90
[   10.911467]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   10.911590]  [<c0103025>] syscall_call+0x7/0xb
[   10.911737] kjournald starting.  Commit interval 5 seconds
[   11.909928] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   11.910069] in_atomic(): 1, irqs_disabled(): 0, pid: 893, name: rc
[   11.910195] Pid: 893, comm: rc Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   11.910320] Call Trace:
[   11.910444]  [<c012d881>] __might_sleep+0xe1/0x100
[   11.910569]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   11.910694]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   11.910818]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   11.910944]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   11.911069]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   11.911191]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   11.911315]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   11.911439]  [<c037d634>] ? get_random_int+0xb4/0xe0
[   11.911564]  [<c0140481>] mmput+0x51/0xc0
[   11.911686]  [<c01ef651>] flush_old_exec+0x381/0x6c0
[   11.911810]  [<c01ea0c6>] ? vfs_read+0x126/0x190
[   11.911933]  [<c01eea3f>] ? kernel_read+0x3f/0x60
[   11.912082]  [<c02228cb>] load_elf_binary+0x33b/0x18c0
[   11.912206]  [<c012f06f>] ? __wake_up+0x3f/0x50
[   11.912330]  [<c01ccfee>] ? kunmap_high+0x7e/0xb0
[   11.912453]  [<c01ccede>] ? page_address+0x8e/0x90
[   11.912576]  [<c01cd15b>] ? kmap_high+0x13b/0x4c0
[   11.912699]  [<c01d1752>] ? __get_user_pages+0x112/0x3d0
[   11.912825]  [<c012f06f>] ? __wake_up+0x3f/0x50
[   11.912948]  [<c056cd9a>] ? __rt_spin_lock+0x2a/0x70
[   11.913090]  [<c0222590>] ? load_elf_binary+0x0/0x18c0
[   11.913213]  [<c01eedbd>] search_binary_handler+0xfd/0x300
[   11.913338]  [<c01f0568>] do_execve+0x228/0x300
[   11.913462]  [<c0319626>] ? strncpy_from_user+0x46/0x70
[   11.913586]  [<c0101b16>] sys_execve+0x36/0x60
[   11.913708]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   13.923619] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   13.923769] in_atomic(): 1, irqs_disabled(): 0, pid: 933, name: 
readahead-list
[   13.923904] Pid: 933, comm: readahead-list Not tainted 
2.6.31-rc4-rt1-dvh01 #1
[   13.924057] Call Trace:
[   13.924180]  [<c012d881>] __might_sleep+0xe1/0x100
[   13.924306]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   13.924431]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   13.924557]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   13.924682]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   13.924808]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   13.924930]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   13.925079]  [<c01d478d>] unmap_region+0xad/0x180
[   13.925204]  [<c02004ab>] ? mntput_no_expire+0x1b/0xa0
[   13.925328]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   13.925450]  [<c01d4d42>] sys_munmap+0x42/0x60
[   13.925574]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   17.255052] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   17.255197] in_atomic(): 1, irqs_disabled(): 0, pid: 933, name: 
readahead-list
[   17.255334] Pid: 933, comm: readahead-list Not tainted 
2.6.31-rc4-rt1-dvh01 #1
[   17.255469] Call Trace:
[   17.255594]  [<c012d881>] __might_sleep+0xe1/0x100
[   17.255719]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   17.255845]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   17.255970]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   17.256123]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   17.256249]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   17.256372]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   17.256496]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   17.256621]  [<c0140481>] mmput+0x51/0xc0
[   17.256745]  [<c0146465>] exit_mm+0x105/0x140
[   17.256869]  [<c01465b5>] do_exit+0x115/0x760
[   17.256992]  [<c016df6d>] ? rt_up_read+0xd/0x10
[   17.257149]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   17.257271]  [<c0146c36>] do_group_exit+0x36/0x90
[   17.257394]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   17.257516]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   17.649188] udev: starting version 141
[   17.811554] Linux agpgart interface v0.103
[   18.161949] Non-volatile memory driver v1.3
[   18.214316] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   18.214449] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   18.214694] e1000e 0000:02:00.0: Disabling L1 ASPM
[   18.214896] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[   18.215033] e1000e 0000:02:00.0: setting latency timer to 64
[   18.215228] e1000e 0000:02:00.0: irq 30 for MSI/MSI-X
[   18.252914] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   18.253086] in_atomic(): 1, irqs_disabled(): 0, pid: 1458, name: udevd
[   18.253217] Pid: 1458, comm: udevd Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   18.253342] Call Trace:
[   18.253465]  [<c012d881>] __might_sleep+0xe1/0x100
[   18.253590]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   18.253715]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   18.253840]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   18.253966]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   18.254092]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   18.254214]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   18.254337]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   18.254462]  [<c0140481>] mmput+0x51/0xc0
[   18.254583]  [<c0146465>] exit_mm+0x105/0x140
[   18.254705]  [<c01465b5>] do_exit+0x115/0x760
[   18.254828]  [<c016df6d>] ? rt_up_read+0xd/0x10
[   18.254951]  [<c0146c36>] do_group_exit+0x36/0x90
[   18.255074]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   18.255196]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   18.270476] e1000e 0000:02:00.0: Warning: detected ASPM enabled in EEPROM
[   18.316454] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   18.328998] 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 
00:15:58:2a:18:74
[   18.329161] 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   18.329365] 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
[   18.370242] intel_rng: FWH not detected
[   18.401762] Initializing USB Mass Storage driver...
[   18.494659] scsi6 : SCSI emulation for USB Mass Storage devices
[   18.521265] usbcore: registered new interface driver usb-storage
[   18.521397] USB Mass Storage support registered.
[   18.522557] usb-storage: device found at 3
[   18.522560] usb-storage: waiting for device to settle before scanning
[   18.579860] usbcore: registered new interface driver hiddev
[   18.587789] input: Lite-On Tech IBM USB Keyboard with UltraNav as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.7/1-6.7.3/1-6.7.3:1.0/input/input6
[   18.588264] generic-usb 0003:04B3:3018.0001: input,hidraw0: USB HID 
v1.10 Keyboard [Lite-On Tech IBM USB Keyboard with UltraNav] on 
usb-0000:00:1d.7-6.7.3/input0
[   18.594654] input: Lite-On Tech IBM USB Keyboard with UltraNav as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.7/1-6.7.3/1-6.7.3:1.1/input/input7
[   18.594888] generic-usb 0003:04B3:3018.0002: input,hidraw1: USB HID 
v1.10 Device [Lite-On Tech IBM USB Keyboard with UltraNav] on 
usb-0000:00:1d.7-6.7.3/input1
[   18.597578] input: Synaptics Inc. Composite TouchPad / TrackPoint as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.7/1-6.7.4/1-6.7.4:1.0/input/input8
[   18.597824] generic-usb 0003:06CB:0009.0003: input,hidraw2: USB HID 
v1.00 Mouse [Synaptics Inc. Composite TouchPad / TrackPoint] on 
usb-0000:00:1d.7-6.7.4/input0
[   18.602219] input: Synaptics Inc. Composite TouchPad / TrackPoint as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6.7/1-6.7.4/1-6.7.4:1.1/input/input9
[   18.604150] generic-usb 0003:06CB:0009.0004: input,hidraw3: USB HID 
v1.00 Mouse [Synaptics Inc. Composite TouchPad / TrackPoint] on 
usb-0000:00:1d.7-6.7.4/input1
[   18.604338] usbcore: registered new interface driver usbhid
[   18.604465] usbhid: v2.6:USB HID core driver
[   18.652515] acpi device:08: registered as cooling_device2
[   18.652860] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:06/device:07/input/input10
[   18.653438] ACPI: Video Device [VID1] (multi-head: yes  rom: no 
post: no)
[   19.227728] parport_pc 00:0b: reported by Plug and Play ACPI
[   19.227916] parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
[   19.293347] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   19.293492] in_atomic(): 1, irqs_disabled(): 0, pid: 1000, name: udevd
[   19.293618] Pid: 1000, comm: udevd Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   19.293744] Call Trace:
[   19.293868]  [<c012d881>] __might_sleep+0xe1/0x100
[   19.293993]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   19.294118]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   19.294244]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   19.294370]  [<c01e6f7f>] mem_cgroup_uncharge_cache_page+0xf/0x20
[   19.294497]  [<c01b87e3>] remove_from_page_cache+0x33/0x40
[   19.294622]  [<c01c1589>] truncate_complete_page+0x39/0x70
[   19.294745]  [<c01c1a82>] truncate_inode_pages_range+0xc2/0x330
[   19.294871]  [<c01cfd66>] ? unmap_mapping_range+0xd6/0x250
[   19.294996]  [<c047ca1e>] ? sock_recvmsg+0x10e/0x130
[   19.295119]  [<c01c1d0f>] truncate_inode_pages+0x1f/0x30
[   19.295243]  [<c01d00bf>] vmtruncate+0xdf/0x170
[   19.295366]  [<c01fe3dd>] inode_setattr+0x6d/0x1a0
[   19.295489]  [<c01c8669>] shmem_notify_change+0x69/0x120
[   19.295613]  [<c01fe651>] notify_change+0x141/0x330
[   19.295737]  [<c056c83d>] ? rt_mutex_lock+0x1d/0x50
[   19.295860]  [<c01e8cac>] do_truncate+0x6c/0x90
[   19.295984]  [<c01f46bd>] may_open+0x1cd/0x280
[   19.296117]  [<c01f490f>] do_filp_open+0x19f/0x820
[   19.296243]  [<c01e8128>] do_sys_open+0x58/0x120
[   19.296365]  [<c01e825e>] sys_open+0x2e/0x40
[   19.296487]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   19.384283] irda_init()
[   19.384299] NET: Registered protocol family 23
[   19.413167] iTCO_vendor_support: vendor-support=0
[   19.466930] ppdev: user-space parallel port driver
[   19.481438] psmouse serio1: ID: 10 00 64
[   19.557917] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2012]
[   19.558072] yenta_cardbus 0000:15:00.0: Using INTVAL to route CSC 
interrupts to PCI
[   19.558208] yenta_cardbus 0000:15:00.0: Routing CardBus interrupts to PCI
[   19.558339] yenta_cardbus 0000:15:00.0: TI: mfunc 0x01d01002, devctl 0x64
[   19.583912] Platform driver 'thinkpad_acpi' needs updating - please 
use dev_pm_ops
[   19.584530] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[   19.584653] thinkpad_acpi: http://ibm-acpi.sf.net/
[   19.584775] thinkpad_acpi: ThinkPad BIOS 79ETE2WW (2.22 ), EC 
79HT50WW-1.07
[   19.584902] thinkpad_acpi: Lenovo ThinkPad T60p, model 2007AD1
[   19.586059] thinkpad_acpi: radio switch found; radios are disabled
[   19.586288] thinkpad_acpi: This ThinkPad has standard ACPI backlight 
brightness control, supported by the ACPI video driver
[   19.586432] thinkpad_acpi: Disabling thinkpad-acpi brightness events 
by default...
[   19.596994] Registered led device: tpacpi::thinklight
[   19.597177] Registered led device: tpacpi::power
[   19.597316] Registered led device: tpacpi::standby
[   19.597454] Registered led device: tpacpi::thinkvantage
[   19.600479] thinkpad_acpi: Standard ACPI backlight interface 
available, not loading native one.
[   19.600939] input: ThinkPad Extra Buttons as 
/devices/virtual/input/input11
[   19.624824] Platform driver 'nsc-ircc' needs updating - please use 
dev_pm_ops
[   19.625848] nsc-ircc 00:0c: activated
[   19.625971] nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; 
irq 3 ; dma 1.
[   19.626012] nsc-ircc, chip->init
[   19.626146] nsc-ircc, Found chip at base=0x164e
[   19.626307] nsc-ircc, driver loaded (Dag Brattli)
[   19.627222] IrDA: Registered device irda0
[   19.627344] nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
[   19.627517] nsc-ircc, chip->init
[   19.627658] nsc-ircc, Found chip at base=0x02e
[   19.627819] nsc-ircc, driver loaded (Dag Brattli)
[   19.627943] nsc_ircc_open(), can't get iobase of 0x2f8
[   19.628228] nsc-ircc, chip->init
[   19.646285] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   19.646512] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, 
TCOBASE=0x1060)
[   19.646715] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   19.687827] ip_tables: (C) 2000-2006 Netfilter Core Team
[   19.788860] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0c70, PCI irq 16
[   19.788997] yenta_cardbus 0000:15:00.0: Socket status: 30000007
[   19.789139] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O 
window: 0xa000 - 0xdfff
[   19.789277] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0xa000-0xdfff: clean.
[   19.792271] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge 
Memory window: 0xe4300000 - 0xe7ffffff
[   19.792411] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge 
Memory window: 0xe0000000 - 0xe3ffffff
[   19.802505] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   19.819365] input: TPPS/2 IBM TrackPoint as 
/devices/platform/i8042/serio1/input/input12
[   20.011825] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.012121] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. 
Please use
[   20.012257] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack 
module option or
[   20.012393] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   20.273059] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x100-0x3af: clean.
[   20.275526] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x3e0-0x4ff: excluding 0x4d0-0x4d7
[   20.276924] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x820-0x8ff: clean.
[   20.277983] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0xc00-0xcf7: clean.
[   20.279203] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0xa00-0xaff: clean.
[   20.318940] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   20.319082] in_atomic(): 1, irqs_disabled(): 0, pid: 1985, name: modprobe
[   20.319209] Pid: 1985, comm: modprobe Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   20.319333] Call Trace:
[   20.319456]  [<c012d881>] __might_sleep+0xe1/0x100
[   20.319582]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   20.319706]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   20.319831]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   20.319957]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   20.320101]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   20.320224]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   20.320348]  [<c01d478d>] unmap_region+0xad/0x180
[   20.320471]  [<c01d396d>] ? split_vma+0xed/0x140
[   20.320593]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   20.320715]  [<c01d4d42>] sys_munmap+0x42/0x60
[   20.320839]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   20.588481] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) 
-> IRQ 17
[   20.588622] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[   20.589773] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   21.195404] lp0: using parport0 (interrupt-driven).
[   21.271450] padlock: VIA PadLock not detected.
[   21.348123] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   21.348272] in_atomic(): 1, irqs_disabled(): 0, pid: 2252, name: modprobe
[   21.348398] Pid: 2252, comm: modprobe Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   21.348524] Call Trace:
[   21.348647]  [<c012d881>] __might_sleep+0xe1/0x100
[   21.348772]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   21.348896]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   21.349024]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   21.349163]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   21.349288]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   21.349411]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   21.349534]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   21.349658]  [<c0140481>] mmput+0x51/0xc0
[   21.349781]  [<c0146465>] exit_mm+0x105/0x140
[   21.349903]  [<c01465b5>] do_exit+0x115/0x760
[   21.350025]  [<c01eb59e>] ? fput+0x1e/0x30
[   21.350146]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   21.350270]  [<c0146c36>] do_group_exit+0x36/0x90
[   21.350392]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   21.350515]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   21.818195] EXT3 FS on sda1, internal journal
[   23.520281] usb-storage: device scan complete
[   23.522980] scsi 6:0:0:0: Direct-Access     HTS72101 0G9SA00 
  0000 PQ: 0 ANSI: 0
[   23.523369] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   23.523372] in_atomic(): 1, irqs_disabled(): 0, pid: 1000, name: udevd
[   23.523377] Pid: 1000, comm: udevd Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   23.523379] Call Trace:
[   23.523388]  [<c012d881>] __might_sleep+0xe1/0x100
[   23.523395]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   23.523401]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   23.523406]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   23.523410]  [<c01e6f7f>] mem_cgroup_uncharge_cache_page+0xf/0x20
[   23.523415]  [<c01b87e3>] remove_from_page_cache+0x33/0x40
[   23.523420]  [<c01c1589>] truncate_complete_page+0x39/0x70
[   23.523423]  [<c01c1a82>] truncate_inode_pages_range+0xc2/0x330
[   23.523427]  [<c01cfd66>] ? unmap_mapping_range+0xd6/0x250
[   23.523430] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   23.523437]  [<c01c1d0f>] truncate_inode_pages+0x1f/0x30
[   23.523443]  [<c01d00bf>] vmtruncate+0xdf/0x170
[   23.523448]  [<c01fe3dd>] inode_setattr+0x6d/0x1a0
[   23.523452]  [<c01c8669>] shmem_notify_change+0x69/0x120
[   23.523456]  [<c01fe651>] notify_change+0x141/0x330
[   23.523461]  [<c056c83d>] ? rt_mutex_lock+0x1d/0x50
[   23.523465]  [<c01e8cac>] do_truncate+0x6c/0x90
[   23.523470]  [<c01f46bd>] may_open+0x1cd/0x280
[   23.523474]  [<c01f490f>] do_filp_open+0x19f/0x820
[   23.523479]  [<c01e8128>] do_sys_open+0x58/0x120
[   23.523483]  [<c01e825e>] sys_open+0x2e/0x40
[   23.523487]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   23.524950] sd 6:0:0:0: [sdb] 195371568 512-byte logical blocks: (100 
GB/93.1 GiB)
[   23.528197] sd 6:0:0:0: [sdb] Write Protect is off
[   23.528201] sd 6:0:0:0: [sdb] Mode Sense: 27 00 00 00
[   23.528204] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   23.532209] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   23.532215]  sdb: sdb1 sdb2 sdb3 sdb4
[   25.955213] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   25.955216] in_atomic(): 1, irqs_disabled(): 0, pid: 2482, name: async/0
[   25.955221] Pid: 2482, comm: async/0 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   25.955223] Call Trace:
[   25.955232]  [<c012d881>] __might_sleep+0xe1/0x100
[   25.955237]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   25.955242]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   25.955247]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   25.955251]  [<c01e6f7f>] mem_cgroup_uncharge_cache_page+0xf/0x20
[   25.955255]  [<c01b87e3>] remove_from_page_cache+0x33/0x40
[   25.955260]  [<c01c1589>] truncate_complete_page+0x39/0x70
[   25.955263]  [<c01c1a82>] truncate_inode_pages_range+0xc2/0x330
[   25.955268]  [<c016e7f9>] ? smp_call_function_many+0xa9/0x1c0
[   25.955273]  [<c020ba27>] ? invalidate_bh_lru+0x57/0x80
[   25.955277]  [<c01c1d0f>] truncate_inode_pages+0x1f/0x30
[   25.955281]  [<c0210942>] kill_bdev+0x32/0x40
[   25.955284]  [<c0211c81>] __blkdev_put+0x111/0x140
[   25.955288]  [<c0211cbf>] blkdev_put+0xf/0x20
[   25.955292]  [<c0235e61>] register_disk+0x121/0x130
[   25.955297]  [<c0308ec4>] ? blk_register_region+0x34/0x40
[   25.955301]  [<c0308910>] ? exact_match+0x0/0x10
[   25.955304]  [<c030918f>] add_disk+0x9f/0x120
[   25.955307]  [<c0308910>] ? exact_match+0x0/0x10
[   25.955311]  [<c0309480>] ? exact_lock+0x0/0x20
[   25.955316]  [<c03c411e>] sd_probe_async+0xde/0x1d0
[   25.955320]  [<c056ccba>] ? rt_spin_lock+0x2a/0x70
[   25.955324]  [<c01619f3>] async_thread+0xe3/0x240
[   25.955328]  [<c056c2d0>] ? rt_spin_lock_slowunlock+0x60/0x70
[   25.955333]  [<c013e120>] ? default_wake_function+0x0/0x20
[   25.955336]  [<c0161910>] ? async_thread+0x0/0x240
[   25.955340]  [<c015a76a>] kthread+0x7a/0x90
[   25.955343]  [<c015a6f0>] ? kthread+0x0/0x90
[   25.955347]  [<c0103ac7>] kernel_thread_helper+0x7/0x10
[   25.959324] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   25.959329] sd 6:0:0:0: [sdb] Attached SCSI disk
[   28.158392] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   28.160263] in_atomic(): 1, irqs_disabled(): 0, pid: 2474, name: askpass
[   28.160389] Pid: 2474, comm: askpass Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   28.160514] Call Trace:
[   28.160639]  [<c012d881>] __might_sleep+0xe1/0x100
[   28.160764]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   28.160889]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   28.161031]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   28.161157]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   28.161283]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   28.161405]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   28.161529]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   28.161652]  [<c0140481>] mmput+0x51/0xc0
[   28.161775]  [<c0146465>] exit_mm+0x105/0x140
[   28.161898]  [<c01465b5>] do_exit+0x115/0x760
[   28.162020]  [<c02cc06c>] ? cap_syslog+0x1c/0x30
[   28.162143]  [<c02cd351>] ? security_syslog+0x11/0x20
[   28.162266]  [<c016df6d>] ? rt_up_read+0xd/0x10
[   28.162391]  [<c0380410>] ? redirected_tty_write+0x0/0x90
[   28.162515]  [<c0146c36>] do_group_exit+0x36/0x90
[   28.162638]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   28.162762]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   28.695618] padlock: VIA PadLock Hash Engine not detected.
[   29.240310] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   29.240455] in_atomic(): 1, irqs_disabled(): 0, pid: 2475, name: 
cryptsetup
[   29.240583] Pid: 2475, comm: cryptsetup Not tainted 
2.6.31-rc4-rt1-dvh01 #1
[   29.240708] Call Trace:
[   29.240833]  [<c012d881>] __might_sleep+0xe1/0x100
[   29.240958]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   29.241109]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   29.241234]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   29.241360]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   29.241486]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   29.241608]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   29.241733]  [<c01d478d>] unmap_region+0xad/0x180
[   29.241857]  [<c01d396d>] ? split_vma+0xed/0x140
[   29.241979]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   29.242102]  [<c01d4d42>] sys_munmap+0x42/0x60
[   29.242225]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   33.214321] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   33.214465] in_atomic(): 1, irqs_disabled(): 0, pid: 1000, name: udevd
[   33.214592] Pid: 1000, comm: udevd Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   33.214717] Call Trace:
[   33.214841]  [<c012d881>] __might_sleep+0xe1/0x100
[   33.214966]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   33.215091]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   33.215217]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   33.215342]  [<c01e6f7f>] mem_cgroup_uncharge_cache_page+0xf/0x20
[   33.215469]  [<c01b87e3>] remove_from_page_cache+0x33/0x40
[   33.215594]  [<c01c1589>] truncate_complete_page+0x39/0x70
[   33.215718]  [<c01c1a82>] truncate_inode_pages_range+0xc2/0x330
[   33.215843]  [<c01cfd66>] ? unmap_mapping_range+0xd6/0x250
[   33.215969]  [<c013561c>] ? update_curr+0xec/0x160
[   33.216114]  [<c01c1d0f>] truncate_inode_pages+0x1f/0x30
[   33.216237]  [<c01d00bf>] vmtruncate+0xdf/0x170
[   33.216361]  [<c01fe3dd>] inode_setattr+0x6d/0x1a0
[   33.216485]  [<c01c8669>] shmem_notify_change+0x69/0x120
[   33.216609]  [<c01fe651>] notify_change+0x141/0x330
[   33.216731]  [<c056c83d>] ? rt_mutex_lock+0x1d/0x50
[   33.216854]  [<c01e8cac>] do_truncate+0x6c/0x90
[   33.216979]  [<c01f46bd>] may_open+0x1cd/0x280
[   33.217123]  [<c01f490f>] do_filp_open+0x19f/0x820
[   33.217249]  [<c01e8128>] do_sys_open+0x58/0x120
[   33.217372]  [<c01e825e>] sys_open+0x2e/0x40
[   33.217494]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   33.804372] kjournald starting.  Commit interval 5 seconds
[   33.804516] EXT3-fs warning: maximal mount count reached, running 
e2fsck is recommended
[   33.808265] EXT3 FS on dm-0, internal journal
[   33.808493] EXT3-fs: mounted filesystem with writeback data mode.
[   33.942267] Adding 2096472k swap on /dev/mapper/swap.  Priority:-1 
extents:1 across:2096472k
[   34.212034] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   34.212179] in_atomic(): 1, irqs_disabled(): 0, pid: 2862, name: pidof
[   34.212305] Pid: 2862, comm: pidof Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   34.212430] Call Trace:
[   34.212555]  [<c012d881>] __might_sleep+0xe1/0x100
[   34.212680]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   34.212804]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   34.212930]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   34.213081]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   34.213216]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   34.213339]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   34.213463]  [<c01d478d>] unmap_region+0xad/0x180
[   34.213586]  [<c01d396d>] ? split_vma+0xed/0x140
[   34.213709]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   34.213831]  [<c01d4d42>] sys_munmap+0x42/0x60
[   34.213954]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   35.212130] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   35.212270] in_atomic(): 1, irqs_disabled(): 0, pid: 3089, name: tput
[   35.212397] Pid: 3089, comm: tput Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   35.212521] Call Trace:
[   35.212934]  [<c012d881>] __might_sleep+0xe1/0x100
[   35.213091]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   35.213216]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   35.213342]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   35.213468]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   35.213594]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   35.213717]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   35.213840]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   35.213966]  [<c0140481>] mmput+0x51/0xc0
[   35.214088]  [<c0146465>] exit_mm+0x105/0x140
[   35.214210]  [<c01465b5>] do_exit+0x115/0x760
[   35.214333]  [<c016df6d>] ? rt_up_read+0xd/0x10
[   35.214458]  [<c037b380>] ? write_null+0x0/0x10
[   35.214581]  [<c0146c36>] do_group_exit+0x36/0x90
[   35.214704]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   35.214827]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   36.224649] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   36.224799] in_atomic(): 1, irqs_disabled(): 0, pid: 3183, name: 
dbus-daemon
[   36.224925] Pid: 3183, comm: dbus-daemon Not tainted 
2.6.31-rc4-rt1-dvh01 #1
[   36.225067] Call Trace:
[   36.225191]  [<c012d881>] __might_sleep+0xe1/0x100
[   36.225317]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   36.225441]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   36.225567]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   36.225693]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   36.225819]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   36.225942]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   36.226066]  [<c01d478d>] unmap_region+0xad/0x180
[   36.226189]  [<c01d396d>] ? split_vma+0xed/0x140
[   36.226312]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   36.226435]  [<c01d4d42>] sys_munmap+0x42/0x60
[   36.226558]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   37.230733] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   37.230877] in_atomic(): 1, irqs_disabled(): 0, pid: 3192, name: 
lsb_release
[   37.231005] Pid: 3192, comm: lsb_release Not tainted 
2.6.31-rc4-rt1-dvh01 #1
[   37.231131] Call Trace:
[   37.231256]  [<c012d881>] __might_sleep+0xe1/0x100
[   37.231381]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   37.231506]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   37.231631]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   37.231757]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   37.231882]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   37.232005]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   37.232141]  [<c01d478d>] unmap_region+0xad/0x180
[   37.232265]  [<c01d396d>] ? split_vma+0xed/0x140
[   37.232387]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   37.232510]  [<c01d4d42>] sys_munmap+0x42/0x60
[   37.232632]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   38.237451] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   38.239281] in_atomic(): 1, irqs_disabled(): 0, pid: 3333, name: 
automount
[   38.239409] Pid: 3333, comm: automount Not tainted 
2.6.31-rc4-rt1-dvh01 #1
[   38.239535] Call Trace:
[   38.239659]  [<c012d881>] __might_sleep+0xe1/0x100
[   38.239785]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   38.239909]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   38.240039]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   38.240178]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   38.240303]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   38.240425]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   38.240548]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   38.240672]  [<c037d634>] ? get_random_int+0xb4/0xe0
[   38.240798]  [<c0140481>] mmput+0x51/0xc0
[   38.240920]  [<c01ef651>] flush_old_exec+0x381/0x6c0
[   38.241063]  [<c01ea0c6>] ? vfs_read+0x126/0x190
[   38.241186]  [<c01eea3f>] ? kernel_read+0x3f/0x60
[   38.241310]  [<c02228cb>] load_elf_binary+0x33b/0x18c0
[   38.241434]  [<c012f06f>] ? __wake_up+0x3f/0x50
[   38.241557]  [<c01b7b0d>] ? unlock_page+0x1d/0x20
[   38.241680]  [<c01d042a>] ? __do_fault+0x29a/0x490
[   38.241803]  [<c01d0f5b>] ? handle_mm_fault+0x15b/0x840
[   38.241929]  [<c01ccede>] ? page_address+0x8e/0x90
[   38.242053]  [<c01d1752>] ? __get_user_pages+0x112/0x3d0
[   38.242177]  [<c016df6d>] ? rt_up_read+0xd/0x10
[   38.242300]  [<c056f694>] ? do_page_fault+0x344/0x450
[   38.242424]  [<c056d346>] ? error_code+0x66/0x70
[   38.242546]  [<c012f06f>] ? __wake_up+0x3f/0x50
[   38.242669]  [<c056cd9a>] ? __rt_spin_lock+0x2a/0x70
[   38.242793]  [<c0222590>] ? load_elf_binary+0x0/0x18c0
[   38.242916]  [<c01eedbd>] search_binary_handler+0xfd/0x300
[   38.243041]  [<c01f0568>] do_execve+0x228/0x300
[   38.243164]  [<c0101b16>] sys_execve+0x36/0x60
[   38.243286]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   38.658188] tun: Universal TUN/TAP device driver, 1.6
[   38.658340] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   39.251816] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   39.251962] in_atomic(): 1, irqs_disabled(): 0, pid: 3402, name: rpmq
[   39.252122] Pid: 3402, comm: rpmq Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   39.252247] Call Trace:
[   39.252371]  [<c012d881>] __might_sleep+0xe1/0x100
[   39.252497]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   39.252623]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   39.252749]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   39.252875]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   39.253017]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   39.253140]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   39.253264]  [<c01d478d>] unmap_region+0xad/0x180
[   39.253387]  [<c01d396d>] ? split_vma+0xed/0x140
[   39.253510]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   39.253633]  [<c01d4d42>] sys_munmap+0x42/0x60
[   39.253756]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   40.370681] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   40.370831] in_atomic(): 1, irqs_disabled(): 0, pid: 3446, name: find
[   40.370958] Pid: 3446, comm: find Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   40.371083] Call Trace:
[   40.371207]  [<c012d881>] __might_sleep+0xe1/0x100
[   40.371332]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   40.371457]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   40.371582]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   40.371708]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   40.371834]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   40.371957]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   40.372081]  [<c01d478d>] unmap_region+0xad/0x180
[   40.372205]  [<c01d396d>] ? split_vma+0xed/0x140
[   40.372327]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   40.372450]  [<c01d4d42>] sys_munmap+0x42/0x60
[   40.372572]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   41.369588] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   41.369739] in_atomic(): 1, irqs_disabled(): 0, pid: 3574, name: sed
[   41.369865] Pid: 3574, comm: sed Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   41.369990] Call Trace:
[   41.370113]  [<c012d881>] __might_sleep+0xe1/0x100
[   41.370239]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   41.370363]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   41.370489]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   41.370614]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   41.370740]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   41.370863]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   41.370986]  [<c01d478d>] unmap_region+0xad/0x180
[   41.371109]  [<c01d396d>] ? split_vma+0xed/0x140
[   41.371231]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   41.371354]  [<c01d4d42>] sys_munmap+0x42/0x60
[   41.371477]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   42.427007] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   42.427148] in_atomic(): 1, irqs_disabled(): 0, pid: 3595, name: cc1
[   42.427275] Pid: 3595, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   42.427399] Call Trace:
[   42.427523]  [<c012d881>] __might_sleep+0xe1/0x100
[   42.427650]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   42.427776]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   42.427902]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   42.428031]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   42.428162]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   42.428284]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   42.428408]  [<c01d478d>] unmap_region+0xad/0x180
[   42.428531]  [<c01d39a0>] ? split_vma+0x120/0x140
[   42.428654]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   42.428777]  [<c01d4d42>] sys_munmap+0x42/0x60
[   42.428899]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   43.425724] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   43.425871] in_atomic(): 1, irqs_disabled(): 0, pid: 3727, name: as
[   43.425998] Pid: 3727, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   43.426123] Call Trace:
[   43.426249]  [<c012d881>] __might_sleep+0xe1/0x100
[   43.426374]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   43.426499]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   43.426626]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   43.426752]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   43.426878]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   43.427001]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   43.427125]  [<c01d478d>] unmap_region+0xad/0x180
[   43.427249]  [<c01d39a0>] ? split_vma+0x120/0x140
[   43.427372]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   43.427494]  [<c01d4d42>] sys_munmap+0x42/0x60
[   43.427617]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   44.585982] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   44.586124] in_atomic(): 1, irqs_disabled(): 0, pid: 3587, name: sleep
[   44.586252] Pid: 3587, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   44.586376] Call Trace:
[   44.586501]  [<c012d881>] __might_sleep+0xe1/0x100
[   44.586627]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   44.586752]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   44.586877]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   44.587004]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   44.587129]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   44.587252]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   44.587376]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   44.587500]  [<c0140481>] mmput+0x51/0xc0
[   44.587622]  [<c0146465>] exit_mm+0x105/0x140
[   44.587744]  [<c01465b5>] do_exit+0x115/0x760
[   44.587867]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   44.587989]  [<c0146c36>] do_group_exit+0x36/0x90
[   44.588122]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   44.588245]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   46.551088] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   46.551230] in_atomic(): 1, irqs_disabled(): 0, pid: 3738, name: as
[   46.551357] Pid: 3738, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   46.551481] Call Trace:
[   46.551605]  [<c012d881>] __might_sleep+0xe1/0x100
[   46.551731]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   46.551855]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   46.551980]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   46.552122]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   46.552247]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   46.552370]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   46.552493]  [<c01d478d>] unmap_region+0xad/0x180
[   46.552617]  [<c01d39a0>] ? split_vma+0x120/0x140
[   46.552740]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   46.552862]  [<c01d4d42>] sys_munmap+0x42/0x60
[   46.552984]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   47.589864] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   47.590009] in_atomic(): 1, irqs_disabled(): 0, pid: 3740, name: sleep
[   47.590135] Pid: 3740, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   47.590260] Call Trace:
[   47.590383]  [<c012d881>] __might_sleep+0xe1/0x100
[   47.590508]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   47.590632]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   47.590758]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   47.590883]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   47.591008]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   47.591130]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   47.591254]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   47.591379]  [<c0140481>] mmput+0x51/0xc0
[   47.591500]  [<c0146465>] exit_mm+0x105/0x140
[   47.591622]  [<c01465b5>] do_exit+0x115/0x760
[   47.593468]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   47.593591]  [<c0146c36>] do_group_exit+0x36/0x90
[   47.593714]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   47.593837]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   50.025219] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   50.025361] in_atomic(): 1, irqs_disabled(): 0, pid: 3741, name: sleep
[   50.025487] Pid: 3741, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   50.025612] Call Trace:
[   50.025734]  [<c012d881>] __might_sleep+0xe1/0x100
[   50.025859]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   50.025983]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   50.026108]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   50.026234]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   50.026359]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   50.026481]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   50.026605]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   50.026729]  [<c0140481>] mmput+0x51/0xc0
[   50.026850]  [<c0146465>] exit_mm+0x105/0x140
[   50.026972]  [<c01465b5>] do_exit+0x115/0x760
[   50.027095]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   50.027219]  [<c0146c36>] do_group_exit+0x36/0x90
[   50.027341]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   50.027463]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   51.073549] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   51.073701] in_atomic(): 1, irqs_disabled(): 0, pid: 3903, name: cp
[   51.073827] Pid: 3903, comm: cp Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   51.073951] Call Trace:
[   51.074076]  [<c012d881>] __might_sleep+0xe1/0x100
[   51.074202]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   51.074326]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   51.074452]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   51.074578]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   51.074704]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   51.074827]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   51.074951]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   51.075075]  [<c0140481>] mmput+0x51/0xc0
[   51.075197]  [<c0146465>] exit_mm+0x105/0x140
[   51.075319]  [<c01465b5>] do_exit+0x115/0x760
[   51.075441]  [<c016df6d>] ? rt_up_read+0xd/0x10
[   51.075564]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   51.075687]  [<c0146c36>] do_group_exit+0x36/0x90
[   51.075811]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   51.075934]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   53.561232] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   53.561381] in_atomic(): 1, irqs_disabled(): 0, pid: 3854, name: sleep
[   53.561508] Pid: 3854, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   53.561633] Call Trace:
[   53.561757]  [<c012d881>] __might_sleep+0xe1/0x100
[   53.561882]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   53.562006]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   53.562132]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   53.562258]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   53.562382]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   53.562505]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   53.562628]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   53.562752]  [<c0140481>] mmput+0x51/0xc0
[   53.562874]  [<c0146465>] exit_mm+0x105/0x140
[   53.562996]  [<c01465b5>] do_exit+0x115/0x760
[   53.563119]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   53.563242]  [<c0146c36>] do_group_exit+0x36/0x90
[   53.563366]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   53.563488]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   54.563486] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   54.563632] in_atomic(): 1, irqs_disabled(): 0, pid: 4160, name: ld
[   54.563757] Pid: 4160, comm: ld Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   54.563881] Call Trace:
[   54.564031]  [<c012d881>] __might_sleep+0xe1/0x100
[   54.564157]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   54.564282]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   54.564408]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   54.564534]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   54.564659]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   54.564782]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   54.564906]  [<c01d478d>] unmap_region+0xad/0x180
[   54.565033]  [<c01d39a0>] ? split_vma+0x120/0x140
[   54.565170]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   54.565292]  [<c01d4d42>] sys_munmap+0x42/0x60
[   54.565415]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   55.570470] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   55.570615] in_atomic(): 1, irqs_disabled(): 0, pid: 4177, name: cc1
[   55.570742] Pid: 4177, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   55.570867] Call Trace:
[   55.570992]  [<c012d881>] __might_sleep+0xe1/0x100
[   55.571117]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   55.571240]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   55.571366]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   55.571492]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   55.571618]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   55.571740]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   55.571864]  [<c01d478d>] unmap_region+0xad/0x180
[   55.571986]  [<c01d39a0>] ? split_vma+0x120/0x140
[   55.572129]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   55.572251]  [<c01d4e4d>] sys_brk+0xed/0x100
[   55.572373]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   56.894109] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   56.894254] in_atomic(): 1, irqs_disabled(): 0, pid: 4199, name: as
[   56.894380] Pid: 4199, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   56.894505] Call Trace:
[   56.894628]  [<c012d881>] __might_sleep+0xe1/0x100
[   56.894757]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   56.894897]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   56.895022]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   56.895148]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   56.895273]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   56.895395]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   56.895520]  [<c01d478d>] unmap_region+0xad/0x180
[   56.895644]  [<c01d39a0>] ? split_vma+0x120/0x140
[   56.895766]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   56.895889]  [<c01d4d42>] sys_munmap+0x42/0x60
[   56.896032]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   57.896512] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   57.896657] in_atomic(): 1, irqs_disabled(): 0, pid: 4213, name: cc1
[   57.896783] Pid: 4213, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   57.896908] Call Trace:
[   57.897037]  [<c012d881>] __might_sleep+0xe1/0x100
[   57.897175]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   57.897298]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   57.897423]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   57.897549]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   57.897674]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   57.897797]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   57.897921]  [<c01d478d>] unmap_region+0xad/0x180
[   57.898043]  [<c01d39a0>] ? split_vma+0x120/0x140
[   57.898166]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   57.898289]  [<c01d4e4d>] sys_brk+0xed/0x100
[   57.898411]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   59.355504] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   59.355650] in_atomic(): 1, irqs_disabled(): 0, pid: 4249, name: cc1
[   59.355776] Pid: 4249, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   59.355901] Call Trace:
[   59.356054]  [<c012d881>] __might_sleep+0xe1/0x100
[   59.356180]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   59.356304]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   59.356430]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   59.356556]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   59.356682]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   59.356805]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   59.356929]  [<c01d478d>] unmap_region+0xad/0x180
[   59.357073]  [<c01d396d>] ? split_vma+0xed/0x140
[   59.357196]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   59.357319]  [<c01d4d42>] sys_munmap+0x42/0x60
[   59.357441]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   60.471267] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   60.471412] in_atomic(): 1, irqs_disabled(): 0, pid: 4256, name: cc1
[   60.471539] Pid: 4256, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   60.471663] Call Trace:
[   60.471788]  [<c012d881>] __might_sleep+0xe1/0x100
[   60.471913]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   60.472062]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   60.472188]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   60.472315]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   60.472441]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   60.472563]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   60.472687]  [<c01d478d>] unmap_region+0xad/0x180
[   60.472811]  [<c01d396d>] ? split_vma+0xed/0x140
[   60.472934]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   60.473082]  [<c01d4d42>] sys_munmap+0x42/0x60
[   60.473209]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   62.068684] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   62.068826] in_atomic(): 1, irqs_disabled(): 0, pid: 4274, name: cc1
[   62.068953] Pid: 4274, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   62.069097] Call Trace:
[   62.069220]  [<c012d881>] __might_sleep+0xe1/0x100
[   62.069346]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   62.069470]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   62.069596]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   62.069722]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   62.069848]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   62.071625]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   62.071748]  [<c01d478d>] unmap_region+0xad/0x180
[   62.071872]  [<c01d39a0>] ? split_vma+0x120/0x140
[   62.072013]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   62.072136]  [<c01d4d42>] sys_munmap+0x42/0x60
[   62.072259]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   63.104279] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   63.104421] in_atomic(): 1, irqs_disabled(): 0, pid: 4252, name: sleep
[   63.104547] Pid: 4252, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   63.104673] Call Trace:
[   63.104797]  [<c012d881>] __might_sleep+0xe1/0x100
[   63.104922]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   63.105051]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   63.105191]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   63.105317]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   63.105442]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   63.105565]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   63.105689]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   63.105813]  [<c0140481>] mmput+0x51/0xc0
[   63.105935]  [<c0146465>] exit_mm+0x105/0x140
[   63.106057]  [<c01465b5>] do_exit+0x115/0x760
[   63.106179]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   63.106302]  [<c0146c36>] do_group_exit+0x36/0x90
[   63.106425]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   63.106547]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   64.721425] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   64.721571] in_atomic(): 1, irqs_disabled(): 0, pid: 4299, name: as
[   64.721698] Pid: 4299, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   64.721823] Call Trace:
[   64.721948]  [<c012d881>] __might_sleep+0xe1/0x100
[   64.722073]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   64.722199]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   64.722324]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   64.722450]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   64.722576]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   64.722700]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   64.722824]  [<c01d478d>] unmap_region+0xad/0x180
[   64.722948]  [<c01d39a0>] ? split_vma+0x120/0x140
[   64.723071]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   64.723194]  [<c01d4d42>] sys_munmap+0x42/0x60
[   64.723317]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   65.935403] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   65.935549] in_atomic(): 1, irqs_disabled(): 0, pid: 4322, name: cc1
[   65.935677] Pid: 4322, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   65.935802] Call Trace:
[   65.935928]  [<c012d881>] __might_sleep+0xe1/0x100
[   65.936077]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   65.936203]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   65.936329]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   65.936455]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   65.936581]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   65.936705]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   65.936829]  [<c01d478d>] unmap_region+0xad/0x180
[   65.936954]  [<c01d39a0>] ? split_vma+0x120/0x140
[   65.937103]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   65.937226]  [<c01d4d42>] sys_munmap+0x42/0x60
[   65.937349]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   67.053599] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   67.053726] in_atomic(): 1, irqs_disabled(): 0, pid: 4367, name: cc1
[   67.053845] Pid: 4367, comm: cc1 Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   67.053991] Call Trace:
[   67.054114]  [<c012d881>] __might_sleep+0xe1/0x100
[   67.054121]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   67.054126]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   67.054131]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   67.054135]  [<c01e6f7f>] mem_cgroup_uncharge_cache_page+0xf/0x20
[   67.054139]  [<c01b87e3>] remove_from_page_cache+0x33/0x40
[   67.054143]  [<c01c1589>] truncate_complete_page+0x39/0x70
[   67.054147]  [<c01c1a82>] truncate_inode_pages_range+0xc2/0x330
[   67.054150]  [<c01cfd66>] ? unmap_mapping_range+0xd6/0x250
[   67.054154]  [<c01c1d0f>] truncate_inode_pages+0x1f/0x30
[   67.054157]  [<c01d00bf>] vmtruncate+0xdf/0x170
[   67.054162]  [<c01fe3dd>] inode_setattr+0x6d/0x1a0
[   67.054168]  [<c024561f>] ext3_setattr+0xcf/0x1d0
[   67.054171]  [<c01fe651>] notify_change+0x141/0x330
[   67.054175]  [<c056c83d>] ? rt_mutex_lock+0x1d/0x50
[   67.054179]  [<c01e8cac>] do_truncate+0x6c/0x90
[   67.054184]  [<c01f46bd>] may_open+0x1cd/0x280
[   67.054188]  [<c01f490f>] do_filp_open+0x19f/0x820
[   67.054192]  [<c0136464>] ? finish_task_switch+0x64/0x110
[   67.054196]  [<c01e8128>] do_sys_open+0x58/0x120
[   67.054200]  [<c01e825e>] sys_open+0x2e/0x40
[   67.054204]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   68.368098] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   68.368244] in_atomic(): 1, irqs_disabled(): 0, pid: 4405, name: as
[   68.368370] Pid: 4405, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   68.368495] Call Trace:
[   68.368619]  [<c012d881>] __might_sleep+0xe1/0x100
[   68.368744]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   68.368868]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   68.368993]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   68.369155]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   68.369280]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   68.369402]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   68.369526]  [<c01d478d>] unmap_region+0xad/0x180
[   68.369650]  [<c01d39a0>] ? split_vma+0x120/0x140
[   68.369773]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   68.369896]  [<c01d4d42>] sys_munmap+0x42/0x60
[   68.370018]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   69.427951] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   69.428117] in_atomic(): 1, irqs_disabled(): 0, pid: 4449, name: as
[   69.428244] Pid: 4449, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   69.428368] Call Trace:
[   69.428491]  [<c012d881>] __might_sleep+0xe1/0x100
[   69.428616]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   69.428741]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   69.428867]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   69.428993]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   69.429138]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   69.429261]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   69.429385]  [<c01d478d>] unmap_region+0xad/0x180
[   69.429509]  [<c01d39a0>] ? split_vma+0x120/0x140
[   69.429631]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   69.429754]  [<c01d4d42>] sys_munmap+0x42/0x60
[   69.429876]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   70.433386] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   70.433531] in_atomic(): 1, irqs_disabled(): 0, pid: 4482, name: as
[   70.433657] Pid: 4482, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   70.433782] Call Trace:
[   70.433906]  [<c012d881>] __might_sleep+0xe1/0x100
[   70.434031]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   70.434155]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   70.434281]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   70.434406]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   70.434532]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   70.434654]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   70.434778]  [<c01d478d>] unmap_region+0xad/0x180
[   70.434901]  [<c01d39a0>] ? split_vma+0x120/0x140
[   70.435024]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   70.435147]  [<c01d4d42>] sys_munmap+0x42/0x60
[   70.435269]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   71.572121] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   71.572265] in_atomic(): 1, irqs_disabled(): 0, pid: 4415, name: sleep
[   71.572393] Pid: 4415, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   71.572518] Call Trace:
[   71.572643]  [<c012d881>] __might_sleep+0xe1/0x100
[   71.572768]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   71.572893]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   71.573021]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   71.573160]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   71.573285]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   71.573408]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   71.573532]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   71.573656]  [<c0140481>] mmput+0x51/0xc0
[   71.573778]  [<c0146465>] exit_mm+0x105/0x140
[   71.573901]  [<c01465b5>] do_exit+0x115/0x760
[   71.574023]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   71.574146]  [<c0146c36>] do_group_exit+0x36/0x90
[   71.574269]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   71.574392]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   72.774641] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   72.774787] in_atomic(): 1, irqs_disabled(): 0, pid: 4570, name: as
[   72.774913] Pid: 4570, comm: as Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   72.775038] Call Trace:
[   72.775162]  [<c012d881>] __might_sleep+0xe1/0x100
[   72.775287]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   72.775410]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   72.775535]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   72.775661]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   72.775786]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   72.775909]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   72.776054]  [<c01d478d>] unmap_region+0xad/0x180
[   72.776178]  [<c01d39a0>] ? split_vma+0x120/0x140
[   72.776301]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   72.776425]  [<c01d4d42>] sys_munmap+0x42/0x60
[   72.776547]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   74.030400] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   74.030539] in_atomic(): 1, irqs_disabled(): 0, pid: 3044, name: login
[   74.030666] Pid: 3044, comm: login Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   74.030791] Call Trace:
[   74.030915]  [<c012d881>] __might_sleep+0xe1/0x100
[   74.031040]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   74.031165]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   74.031291]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   74.031417]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   74.031543]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   74.031666]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   74.031789]  [<c01d478d>] unmap_region+0xad/0x180
[   74.031913]  [<c01d396d>] ? split_vma+0xed/0x140
[   74.032040]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   74.032172]  [<c01d4d42>] sys_munmap+0x42/0x60
[   74.032295]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   75.112281] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   75.112425] in_atomic(): 1, irqs_disabled(): 0, pid: 4552, name: sleep
[   75.112552] Pid: 4552, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   75.112679] Call Trace:
[   75.112819]  [<c012d881>] __might_sleep+0xe1/0x100
[   75.112945]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   75.113103]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   75.113229]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   75.113356]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   75.113481]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   75.113603]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   75.113726]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   75.113869]  [<c0140481>] mmput+0x51/0xc0
[   75.113991]  [<c0146465>] exit_mm+0x105/0x140
[   75.114113]  [<c01465b5>] do_exit+0x115/0x760
[   75.114235]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   75.114358]  [<c0146c36>] do_group_exit+0x36/0x90
[   75.114481]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   75.114605]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   76.209214] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   76.209356] in_atomic(): 1, irqs_disabled(): 0, pid: 4869, name: git
[   76.209482] Pid: 4869, comm: git Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   76.209607] Call Trace:
[   76.209732]  [<c012d881>] __might_sleep+0xe1/0x100
[   76.209857]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   76.209981]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   76.210107]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   76.210233]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   76.210359]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   76.210481]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   76.210605]  [<c01d478d>] unmap_region+0xad/0x180
[   76.210727]  [<c01d396d>] ? split_vma+0xed/0x140
[   76.210850]  [<c01d4a10>] do_munmap+0x1b0/0x250
[   76.210973]  [<c01d4d42>] sys_munmap+0x42/0x60
[   76.211095]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   77.577425] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   77.577564] in_atomic(): 1, irqs_disabled(): 0, pid: 4654, name: sleep
[   77.577691] Pid: 4654, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   77.577816] Call Trace:
[   77.577940]  [<c012d881>] __might_sleep+0xe1/0x100
[   77.578065]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   77.578189]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   77.578314]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   77.578440]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   77.578565]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   77.578688]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   77.578811]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   77.578935]  [<c0140481>] mmput+0x51/0xc0
[   77.579057]  [<c0146465>] exit_mm+0x105/0x140
[   77.579179]  [<c01465b5>] do_exit+0x115/0x760
[   77.579302]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   77.579425]  [<c0146c36>] do_group_exit+0x36/0x90
[   77.579548]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   77.579671]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   80.581241] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   80.581386] in_atomic(): 1, irqs_disabled(): 0, pid: 4881, name: sleep
[   80.581512] Pid: 4881, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   80.581637] Call Trace:
[   80.581761]  [<c012d881>] __might_sleep+0xe1/0x100
[   80.581886]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   80.583670]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   80.583795]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   80.583921]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   80.584079]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   80.584202]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   80.584326]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   80.584451]  [<c0140481>] mmput+0x51/0xc0
[   80.584573]  [<c0146465>] exit_mm+0x105/0x140
[   80.584695]  [<c01465b5>] do_exit+0x115/0x760
[   80.584817]  [<c01e7fdc>] ? filp_close+0x4c/0x80
[   80.584941]  [<c0146c36>] do_group_exit+0x36/0x90
[   80.585095]  [<c0146ca4>] sys_exit_group+0x14/0x20
[   80.585218]  [<c0102f4c>] sysenter_do_call+0x12/0x28
[   82.475617] BUG: sleeping function called from invalid context at 
kernel/rtmutex.c:684
[   82.475760] in_atomic(): 1, irqs_disabled(): 0, pid: 4943, name: bash
[   82.475886] Pid: 4943, comm: bash Not tainted 2.6.31-rc4-rt1-dvh01 #1
[   82.476012] Call Trace:
[   82.476150]  [<c012d881>] __might_sleep+0xe1/0x100
[   82.476275]  [<c056ccba>] rt_spin_lock+0x2a/0x70
[   82.476400]  [<c018243a>] res_counter_uncharge+0x2a/0x50
[   82.476524]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
[   82.476650]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
[   82.476776]  [<c01d6b87>] page_remove_rmap+0x47/0x50
[   82.476899]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
[   82.477036]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
[   82.477160]  [<c037d634>] ? get_random_int+0xb4/0xe0
[   82.477285]  [<c0140481>] mmput+0x51/0xc0
[   82.477408]  [<c01ef651>] flush_old_exec+0x381/0x6c0
[   82.477531]  [<c01ea0c6>] ? vfs_read+0x126/0x190
[   82.477653]  [<c01eea3f>] ? kernel_read+0x3f/0x60
[   82.477777]  [<c02228cb>] load_elf_binary+0x33b/0x18c0
[   82.477902]  [<c012f06f>] ? __wake_up+0x3f/0x50
[   82.478026]  [<c01ccfee>] ? kunmap_high+0x7e/0xb0
[   82.478149]  [<c01ccede>] ? page_address+0x8e/0x90
[   82.478272]  [<c01cd15b>] ? kmap_high+0x13b/0x4c0
[   82.478396]  [<c01d1752>] ? __get_user_pages+0x112/0x3d0
[   82.478521]  [<c012f06f>] ? __wake_up+0x3f/0x50
[   82.478644]  [<c056cd9a>] ? __rt_spin_lock+0x2a/0x70
[   82.478768]  [<c0222590>] ? load_elf_binary+0x0/0x18c0
[   82.478891]  [<c01eedbd>] search_binary_handler+0xfd/0x300
[   82.479015]  [<c01f0568>] do_execve+0x228/0x300
[   82.479138]  [<c0319626>] ? strncpy_from_user+0x46/0x70
[   82.479261]  [<c0101b16>] sys_execve+0x36/0x60
[   82.479383]  [<c0102f4c>] sysenter_do_call+0x12/0x28

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
