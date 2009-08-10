Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbZHJRf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbZHJRf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932316AbZHJRf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:35:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48549 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbZHJRf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:35:57 -0400
Subject: kmemcheck in linux-next causes NULL pointer dereference at
 task_rq_lock
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: vegardno@ifi.uio.no, penberg@cs.helsinki.fi, mingo@elte.hu
Content-Type: text/plain
Date: Mon, 10 Aug 2009 13:35:40 -0400
Message-Id: <1249925740.2501.9.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using 2.6.31-rc5-next-20090810 on a vmware server.  Originally I saw
messages about setting to one cpu, so I booted with maxcpu=1.  I get
this same panic with and without maxpu.  Booting with kmemcheck=0 boots
just fine.

I have not tested kmemcheck in linus' tree but will start looking for a
working version now.  Any suggestions or things I should try?


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc5-next-20090810 (***) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-44)) #11 SMP Mon Aug 10 10:22:38 EDT 2009
[    0.000000] Command line: ro root=/dev/VolGroup00/LogVol00 audit=1 console=tty0 console=ttyS0,9600 maxcpus=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feff000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x40000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 00000000000e0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fef0000 (usable)
[    0.000000]  modified: 000000003fef0000 - 000000003feff000 (ACPI data)
[    0.000000]  modified: 000000003feff000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  modified: 000000003ff00000 - 0000000040000000 (usable)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-0000000040000000
[    0.000000] RAMDISK: 37c56000 - 37fefbe1
[    0.000000] ACPI: RSDP 00000000000f6a30 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 000000003fefa138 0003C (v01 INTEL  440BX    06040000 VMW  01324272)
[    0.000000] ACPI: FACP 000000003fefee98 000F4 (v04 INTEL  440BX    06040000 PTL  000F4240)
[    0.000000] ACPI: DSDT 000000003fefa22a 04C6E (v01 PTLTD  Custom   06040000 MSFT 03000001)
[    0.000000] ACPI: FACS 000000003fefffc0 00040
[    0.000000] ACPI: BOOT 000000003fefa202 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: APIC 000000003fefa1a4 0005E (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000040000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000040000000
[    0.000000]   NODE_DATA [0000000000010000 - 0000000000027fff]
[    0.000000]   bootmap [0000000000028000 -  000000000002ffff] pages 8
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0040000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000261d1f0]    TEXT DATA BSS ==> [0001000000 - 000261d1f0]
[    0.000000]   #3 [0037c56000 - 0037fefbe1]          RAMDISK ==> [0037c56000 - 0037fefbe1]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [000261e000 - 000261e1e8]              BRK ==> [000261e000 - 000261e1e8]
[    0.000000]   #6 [0000100000 - 0000300000]          PGTABLE ==> [0000100000 - 0000300000]
[    0.000000] found SMP MP-table at [ffff8800000f6aa0] f6aa0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fef0
[    0.000000]     0: 0x0003ff00 -> 0x00040000
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages at ffff880002637000, static data 1926944 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 254236
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/VolGroup00/LogVol00 audit=1 console=tty0 console=ttyS0,9600 maxcpus=1
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 986920k/1048576k available (5194k kernel code, 516k absent, 61140k reserved, 2771k data, 3304k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: Frequency read from the hypervisor
[    0.000000] Detected 2666.725 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] console [ttyS0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        8191
[    0.000999] ... CLASSHASH_SIZE:          4096
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000999] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000999] ... CHAINHASH_SIZE:          16384
[    0.000999]  memory used by lock dependency info: 6367 kB
[    0.000999]  per task-struct memory footprint: 2688 bytes
[    0.001072] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.45 BogoMIPS (lpj=2666725)
[    0.146034] Security Framework initialized
[    0.147018] SELinux:  Initializing.
[    0.303965] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.395013] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.413405] Mount-cache hash table entries: 256
[    1.235014] Initializing cgroup subsys ns
[    1.243083] Initializing cgroup subsys cpuacct
[    1.249158] Initializing cgroup subsys devices
[    1.254233] Initializing cgroup subsys freezer
[    1.290186] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.292009] CPU: L2 cache: 4096K
[    1.293019] CPU 0/0x0 -> Node 0
[    1.294035] mce: CPU supports 0 MCE banks
[    1.295311] Performance Counters: Core2 events, Intel PMU driver.
[    1.298028] ... version:                 2
[    1.299009] ... bit width:               40
[    1.300009] ... generic counters:        2
[    1.301012] ... value mask:              000000ffffffffff
[    1.302009] ... max period:              000000007fffffff
[    1.303009] ... fixed-purpose counters:  3
[    1.304012] ... counter mask:            0000000700000003
[    1.312173] lockdep: fixing up alternatives.
[    1.313010] SMP alternatives: switching to UP code
[    1.400154] ACPI: Core revision 20090625
[   20.118223] Setting APIC routing to flat
[   20.180762] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[   20.192798] CPU0: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[   20.197016] kmemcheck: Initialized
[   20.198142] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   20.199016] IP: [<ffffffff810522b0>] task_rq_lock+0x50/0xc0
[   20.199016] PGD 0 
[   20.199016] Oops: 0000 [#1] SMP 
[   20.199016] last sysfs file: 
[   20.199016] CPU 0 
[   20.199016] Modules linked in:
[   20.199016] Pid: 1, comm: swapper Not tainted 2.6.31-rc5-next-20090810 #11 VMware Virtual Platform
[   20.199016] RIP: 0010:[<ffffffff810522b0>]  [<ffffffff810522b0>] task_rq_lock+0x50/0xc0
[   20.199016] RSP: 0018:ffff88003fba9bb0  EFLAGS: 00010046
[   20.199016] RAX: 0000000000000000 RBX: 00000000001d5cc0 RCX: ffff880002637000
[   20.199016] RDX: ffff88003fba0000 RSI: ffff88003fba9c18 RDI: ffffffff810522b0
[   20.199016] RBP: ffff88003fba9be0 R08: 0000000000000000 R09: 0000000000000000
[   20.199016] R10: 0000000000000001 R11: 0000000000000001 R12: 00000000001d5cc0
[   20.199016] R13: 0000000000000000 R14: ffff88003fba9c18 R15: 0000000000093ab0
[   20.199016] FS:  0000000000000000(0000) GS:ffff880002637000(0000) knlGS:0000000000000000
[   20.199016] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   20.199016] CR2: ffff88003f80605c CR3: 0000000001001000 CR4: 00000000000006f0
[   20.199016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   20.199016] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[   20.199016] Process swapper (pid: 1, threadinfo ffff88003fba8000, task ffff88003fba0000)
[   20.199016] Stack:
[   20.199016]  ffff88003fba9bc0 000000008279b5f0 ffff88003fba9c80 ffffffff81651d64
[   20.199016] <0> ffffffff817f5e30 0000000000000000 ffff88003fba9c50 ffffffff8106058d
[   20.199016] <0> ffff88003fba9c40 0000000000000246 0000000f00000000 ffffffff8170ac60
[   20.199016] Call Trace:
[   20.199016]  [<ffffffff817f5e30>] ? migration_init+0x0/0x90
[   20.199016]  [<ffffffff8106058d>] try_to_wake_up+0x4d/0x410
[   20.199016]  [<ffffffff817f5e30>] ? migration_init+0x0/0x90
[   20.199016]  [<ffffffff810609f3>] wake_up_process+0x23/0x40
[   20.199016]  [<ffffffff8108e25b>] kthread_create+0x9b/0x180
[   20.199016]  [<ffffffff81065930>] ? migration_thread+0x0/0x380
[   20.199016]  [<ffffffff817f3920>] ? kmemcheck_init+0x0/0x90
[   20.199016]  [<ffffffff8106f779>] ? printk+0x79/0xa0
[   20.199016]  [<ffffffff81503aa5>] migration_call+0x255/0x650
[   20.199016]  [<ffffffff817f5e30>] ? migration_init+0x0/0x90
[   20.199016]  [<ffffffff817f5e67>] migration_init+0x37/0x90
[   20.199016]  [<ffffffff817f396d>] ? kmemcheck_init+0x4d/0x90
[   20.199016]  [<ffffffff8100a07b>] do_one_initcall+0x4b/0x1b0
[   20.199016]  [<ffffffff817e5f04>] ? native_smp_prepare_cpus+0x384/0x4e0
[   20.199016]  [<ffffffff817d4140>] ? early_idt_handler+0x0/0x71
[   20.199016]  [<ffffffff817d514c>] kernel_init+0xec/0x2e0
[   20.199016]  [<ffffffff810152aa>] child_rip+0xa/0x20
[   20.199016]  [<ffffffff81014c10>] ? restore_args+0x0/0x30
[   20.199016]  [<ffffffff817d5060>] ? kernel_init+0x0/0x2e0
[   20.199016]  [<ffffffff810152a0>] ? child_rip+0x0/0x20
[   20.199016] Code: e0 49 89 f6 4c 89 65 e8 49 c7 c4 c0 5c 1d 00 9c 58 0f 1f 44 00 00 48 89 c2 fa 66 0f 1f 44 00 00 49 89 16 4c 89 e3 e8 80 0e 05 00 <49> 8b 45 08 8b 40 18 48 03 1c c5 c0 06 7c 81 48 89 df e8 b9 7f 
[   20.199016] RIP  [<ffffffff810522b0>] task_rq_lock+0x50/0xc0
[   20.199016]  RSP <ffff88003fba9bb0>
[   20.199016] CR2: 0000000000000008
[   20.199016] ---[ end trace a7919e7f17c0a725 ]---
[   20.237214] swapper used greatest stack depth: 4144 bytes left
[   20.238105] Kernel panic - not syncing: Attempted to kill init!
[   20.241061] Pid: 1, comm: swapper Tainted: G      D    2.6.31-rc5-next-20090810 #11
[   20.243056] Call Trace:
[   20.250062]  [<ffffffff8106dd92>] panic+0xb2/0x190
[   20.252071]  [<ffffffff810a90e0>] ? trace_hardirqs_on+0x20/0x40
[   20.255063]  [<ffffffff8150ad9a>] ? _write_unlock_irq+0x3a/0x60
[   20.256835]  [<ffffffff81071cca>] do_exit+0x77a/0x840
[   20.259061]  [<ffffffff8150c15b>] oops_end+0x10b/0x110
[   20.260016]  [<ffffffff8104300a>] no_context+0x17a/0x280
[   20.261016]  [<ffffffff810438cc>] __bad_area_nosemaphore+0x10c/0x1f0
[   20.265063]  [<ffffffff810a4a62>] ? find_usage_backwards+0x32/0x50
[   20.267059]  [<ffffffff81043ae1>] bad_area_nosemaphore+0x21/0x40
[   20.272067]  [<ffffffff8150df4e>] do_page_fault+0x27e/0x3e0
[   20.274059]  [<ffffffff81509cbe>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   20.276062]  [<ffffffff8150b195>] page_fault+0x25/0x30
[   20.279059]  [<ffffffff810522b0>] ? task_rq_lock+0x50/0xc0
[   20.281422]  [<ffffffff810522b0>] ? task_rq_lock+0x50/0xc0
[   20.286063]  [<ffffffff817f5e30>] ? migration_init+0x0/0x90
[   20.289060]  [<ffffffff8106058d>] try_to_wake_up+0x4d/0x410
[   20.293063]  [<ffffffff817f5e30>] ? migration_init+0x0/0x90
[   20.294059]  [<ffffffff810609f3>] wake_up_process+0x23/0x40
[   20.295016]  [<ffffffff8108e25b>] kthread_create+0x9b/0x180
[   20.297062]  [<ffffffff81065930>] ? migration_thread+0x0/0x380
[   20.298016]  [<ffffffff817f3920>] ? kmemcheck_init+0x0/0x90
[   20.302058]  [<ffffffff8106f779>] ? printk+0x79/0xa0
[   20.306063]  [<ffffffff81503aa5>] migration_call+0x255/0x650
[   20.307430]  [<ffffffff817f5e30>] ? migration_init+0x0/0x90
[   20.312060]  [<ffffffff817f5e67>] migration_init+0x37/0x90
[   20.314059]  [<ffffffff817f396d>] ? kmemcheck_init+0x4d/0x90
[   20.317953]  [<ffffffff8100a07b>] do_one_initcall+0x4b/0x1b0
[   20.318016]  [<ffffffff817e5f04>] ? native_smp_prepare_cpus+0x384/0x4e0
[   20.319059]  [<ffffffff817d4140>] ? early_idt_handler+0x0/0x71
[   20.323062]  [<ffffffff817d514c>] kernel_init+0xec/0x2e0
[   20.326062]  [<ffffffff810152aa>] child_rip+0xa/0x20
[   20.327016]  [<ffffffff81014c10>] ? restore_args+0x0/0x30
[   20.328059]  [<ffffffff817d5060>] ? kernel_init+0x0/0x2e0
[   20.331062]  [<ffffffff810152a0>] ? child_rip+0x0/0x20

