Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZFJLMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZFJLMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbZFJLMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:12:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59062 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbZFJLMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:12:02 -0400
Date: Wed, 10 Jun 2009 13:10:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       mark.langsdorf@amd.com
Subject: S06cpuspeed/2637 is trying to acquire lock
	(&(&dbs_info->work)->work (was: Re: [PATCH 4/6] x86/cpufreq: use
	cpumask_copy instead of =)
Message-ID: <20090610111035.GG27724@elte.hu>
References: <4A2835D8.6040903@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain> <200906101552.17397.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <200906101552.17397.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


With a v2.6.30 based kernel i'm still getting a cpufreq lockdep 
warning:

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.30-tip #10420
 -------------------------------------------------------
 S06cpuspeed/2637 is trying to acquire lock:
  (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff8106553d>] __cancel_work_timer+0xd6/0x22a

 but task is already holding lock:
  (dbs_mutex){+.+.+.}, at: [<ffffffff8193d630>] cpufreq_governor_dbs+0x28f/0x335

This bug got introduced somewhere late in the .30-rc cycle, this box 
was fine before.

	Ingo

-------------------->
Linux version 2.6.30-tip (mingo@titan) (gcc version 4.2.3) #10420 SMP PREEMPT Wed Jun 10 12:22:13 CEST 2009
Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi nmi_watchdog=0 nolapic_timer hpet=disable highmem=512m notsc pci=nomsi
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)
 BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
 BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)
 BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
 BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)
 BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data)
 BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)
console [earlyser0] enabled
debug: ignoring loglevel setting.
last_pfn = 0x3ff00 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 03FF00000 mask FFFF00000 uncachable
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
Scanning 1 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000001000 (usable)
 modified: 0000000000001000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 000000000009fc00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000003ed94000 (usable)
 modified: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
 modified: 000000003ee4e000 - 000000003fea2000 (usable)
 modified: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
 modified: 000000003fee9000 - 000000003feed000 (usable)
 modified: 000000003feed000 - 000000003feff000 (ACPI data)
 modified: 000000003feff000 - 000000003ff00000 (usable)
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000003ff00000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ff00000 page 4k
kernel direct mapping tables up to 3ff00000 @ 8000-b000
ACPI: RSDP 00000000000fe020 00014 (v00 INTEL )
ACPI: RSDT 000000003fefde48 00050 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: FACP 000000003fefcf10 00074 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: DSDT 000000003fef8010 03E70 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: FACS 000000003fedfc40 00040
ACPI: APIC 000000003fefce10 00078 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: WDDT 000000003fef7f90 00040 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: MCFG 000000003fef7f10 0003C (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: ASF! 000000003fefcd10 000A6 (v32 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: HPET 000000003fef7e90 00038 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
ACPI: SSDT 000000003fefdc10 001BC (v01 INTEL     CpuPm 000004B9 MSFT 01000013)
ACPI: SSDT 000000003fefda10 001B7 (v01 INTEL   Cpu0Ist 000004B9 MSFT 01000013)
ACPI: SSDT 000000003fefd810 001B7 (v01 INTEL   Cpu1Ist 000004B9 MSFT 01000013)
ACPI: SSDT 000000003fefd610 001B7 (v01 INTEL   Cpu2Ist 000004B9 MSFT 01000013)
ACPI: SSDT 000000003fefd410 001B7 (v01 INTEL   Cpu3Ist 000004B9 MSFT 01000013)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000003ff00000
Bootmem setup node 0 0000000000000000-000000003ff00000
  NODE_DATA [0000000000009000 - 0000000000047fff]
  bootmap [0000000000048000 -  000000000004ffdf] pages 8
(5 early reservations) ==> bootmem [0000000000 - 003ff00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 00033f1a70]    TEXT DATA BSS ==> [0001000000 - 00033f1a70]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
 [ffffea0000000000-ffffea00019fffff] PMD -> [ffff880003800000-ffff8800051fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000000 -> 0x00000001
    0: 0x00000006 -> 0x0000009f
    0: 0x00000100 -> 0x0003ed94
    0: 0x0003ee4e -> 0x0003fea2
    0: 0x0003fee9 -> 0x0003feed
    0: 0x0003feff -> 0x0003ff00
On node 0 totalpages: 261511
  DMA zone: 104 pages used for memmap
  DMA zone: 100 pages reserved
  DMA zone: 3790 pages, LIFO batch:0
  DMA32 zone: 6546 pages used for memmap
  DMA32 zone: 250971 pages, LIFO batch:31
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
mapped APIC to ffffffffff5fc000 (fee00000)
mapped IOAPIC to ffffffffff5fb000 (fec00000)
nr_irqs_gsi: 24
Allocating PCI resources starting at 3ff00000 (gap: 3ff00000:c0100000)
NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 478 pages at ffff880005200000, static data 1935456 bytes
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 254761
Policy zone: DMA32
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi nmi_watchdog=0 nolapic_timer hpet=disable highmem=512m notsc pci=nomsi
debug: sysrq always enabled.
notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
Initializing CPU#0
Experimental hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
Experimental hierarchical RCU init done.
NR_IRQS:33024 nr_irqs:440
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2933.232 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6207 kB
 per task-struct memory footprint: 2688 bytes
Memory: 973804k/1047552k available (11515k kernel code, 1508k absent, 72240k reserved, 7701k data, 2596k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
ODEBUG: 0 of 0 active objects replaced
Calibrating delay loop... 5858.91 BogoMIPS (lpj=29294592)
Security Framework initialized
TOMOYO Linux initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
[ds] sizes: address: 64 bit, bts/pebs record: 24/144 bytes
CPU 0/0x0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using mwait in idle threads.
Performance Counters: Nehalem/Corei7 events, Intel PMU driver.
... version:                 2
... bit width:               40
... generic counters:        2
... value mask:              000000ffffffffff
... max period:              000000007fffffff
... fixed-purpose counters:  3
... counter mask:            0000000700000003
ACPI: Core revision 20090320
Setting APIC routing to flat
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 2-0 (apicid-pin) not connected
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
Disabling APIC timer
calling  migration_init+0x0/0x58 @ 1
initcall migration_init+0x0/0x58 returned 1 after 0 usecs
initcall migration_init+0x0/0x58 returned with error code 1 
calling  spawn_ksoftirqd+0x0/0x55 @ 1
initcall spawn_ksoftirqd+0x0/0x55 returned 0 after 0 usecs
calling  init_call_single_data+0x0/0xa9 @ 1
initcall init_call_single_data+0x0/0xa9 returned 0 after 0 usecs
calling  relay_init+0x0/0x14 @ 1
initcall relay_init+0x0/0x14 returned 0 after 0 usecs
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay loop... 5832.70 BogoMIPS (lpj=29163520)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (11691.62 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
PM: Adding info for No Bus:platform
khelper used greatest stack depth: 5344 bytes left
calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
calling  net_ns_init+0x0/0xf1 @ 1
net_namespace: 1728 bytes
initcall net_ns_init+0x0/0xf1 returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x28 @ 1
initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x2d @ 1
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 usecs
calling  print_banner+0x0/0xe @ 1
Booting paravirtualized kernel on bare hardware
initcall print_banner+0x0/0xe returned 0 after 9765 usecs
calling  init_smp_flush+0x0/0x39 @ 1
initcall init_smp_flush+0x0/0x39 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0x1e @ 1
initcall alloc_frozen_cpus+0x0/0x1e returned 0 after 0 usecs
calling  sysctl_init+0x0/0x16 @ 1
initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0xbb @ 1
initcall ksysfs_init+0x0/0xbb returned 0 after 0 usecs
calling  async_init+0x0/0x44 @ 1
initcall async_init+0x0/0x44 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
calling  pm_init+0x0/0x34 @ 1
initcall pm_init+0x0/0x34 returned 0 after 0 usecs
calling  init_hw_breakpoint+0x0/0x12 @ 1
initcall init_hw_breakpoint+0x0/0x12 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x41 @ 1
initcall init_misc_binfmt+0x0/0x41 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x14 @ 1
initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x14 @ 1
initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x14 @ 1
initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x5a @ 1
initcall debugfs_init+0x0/0x5a returned 0 after 0 usecs
calling  securityfs_init+0x0/0x51 @ 1
initcall securityfs_init+0x0/0x51 returned 0 after 0 usecs
calling  random32_init+0x0/0xce @ 1
initcall random32_init+0x0/0xce returned 0 after 0 usecs
calling  gnttab_init+0x0/0x183 @ 1
initcall gnttab_init+0x0/0x183 returned -19 after 0 usecs
calling  regulator_init+0x0/0x2e @ 1
regulator: core version 0.5
initcall regulator_init+0x0/0x2e returned 0 after 0 usecs
calling  cpufreq_core_init+0x0/0x81 @ 1
initcall cpufreq_core_init+0x0/0x81 returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x40 @ 1
initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
calling  sock_init+0x0/0x5e @ 1
initcall sock_init+0x0/0x5e returned 0 after 0 usecs
calling  net_inuse_init+0x0/0x26 @ 1
initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x41 @ 1
initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x1dc @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x1dc returned 0 after 9765 usecs
calling  bdi_class_init+0x0/0x41 @ 1
initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x54 @ 1
initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
calling  lcd_class_init+0x0/0x4d @ 1
initcall lcd_class_init+0x0/0x4d returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x5d @ 1
initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
calling  video_output_class_init+0x0/0x19 @ 1
initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
calling  xenbus_probe_init+0x0/0x10a @ 1
initcall xenbus_probe_init+0x0/0x10a returned -19 after 0 usecs
calling  tty_class_init+0x0/0x31 @ 1
initcall tty_class_init+0x0/0x31 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc2 @ 1
PM: Adding info for No Bus:vtcon0
initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
calling  register_node_type+0x0/0x45 @ 1
initcall register_node_type+0x0/0x45 returned 0 after 0 usecs
calling  i2c_init+0x0/0x67 @ 1
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x67 returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x8a1 @ 1
initcall amd_postcore_init+0x0/0x8a1 returned 0 after 0 usecs
calling  arch_kdebugfs_init+0x0/0x28e @ 1
initcall arch_kdebugfs_init+0x0/0x28e returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x63 @ 1
initcall mtrr_if_init+0x0/0x63 returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x2a @ 1
initcall ffh_cstate_init+0x0/0x2a returned 0 after 0 usecs
calling  acpi_pci_init+0x0/0x57 @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x57 returned 0 after 0 usecs
calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
initcall setup_vcpu_hotplug_event+0x0/0x22 returned -19 after 0 usecs
calling  pci_arch_init+0x0/0x57 @ 1
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x57 returned 0 after 9765 usecs
calling  topology_init+0x0/0x88 @ 1
initcall topology_init+0x0/0x88 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x3d @ 1
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x37e @ 1
initcall param_sysfs_init+0x0/0x37e returned 0 after 87890 usecs
calling  pm_sysrq_init+0x0/0x19 @ 1
initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0x38 @ 1
PM: Adding info for No Bus:default
initcall default_bdi_init+0x0/0x38 returned 0 after 9765 usecs
calling  init_bio+0x0/0x165 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0x165 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x31 @ 1
initcall cryptomgr_init+0x0/0x31 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x72 @ 1
initcall blk_softirq_init+0x0/0x72 returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x67 @ 1
initcall genhd_device_init+0x0/0x67 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x45 @ 1
initcall pci_slot_init+0x0/0x45 returned 0 after 0 usecs
calling  acpi_init+0x0/0x25e @ 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
PM: Adding info for acpi:LNXSYSTM:00
PM: Adding info for acpi:LNXPWRBN:00
PM: Adding info for acpi:ACPI_CPU:00
PM: Adding info for acpi:ACPI_CPU:01
PM: Adding info for acpi:ACPI_CPU:02
PM: Adding info for acpi:ACPI_CPU:03
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:PNP0A03:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:PNP0401:00
PM: Adding info for acpi:PNP0F03:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:PNP0003:00
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:LNXTHERM:00
initcall acpi_init+0x0/0x25e returned 0 after 253906 usecs
calling  dock_init+0x0/0x8d @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0x8d returned 0 after 9765 usecs
calling  acpi_pci_root_init+0x0/0x28 @ 1
ACPI: PCI Root Bridge [PCI0] (0000:00)
PM: Adding info for No Bus:pci0000:00
PM: Adding info for No Bus:0000:00
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [8086:277c] class 000600 header type 00
pci 0000:00:01.0: found [8086:277d] class 000604 header type 01
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: found [8086:27d8] class 000403 header type 00
pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: found [8086:27d0] class 000604 header type 01
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: found [8086:27e0] class 000604 header type 01
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: found [8086:27e2] class 000604 header type 01
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: found [8086:27c8] class 000c03 header type 00
pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
pci 0000:00:1d.1: found [8086:27c9] class 000c03 header type 00
pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
pci 0000:00:1d.2: found [8086:27ca] class 000c03 header type 00
pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
pci 0000:00:1d.3: found [8086:27cb] class 000c03 header type 00
pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
pci 0000:00:1d.7: found [8086:27cc] class 000c03 header type 00
pci 0000:00:1d.7: reg 10 32bit mmio: [0x50404400-0x504047ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
pci 0000:00:1f.0: found [8086:27b0] class 000601 header type 00
pci 0000:00:1f.1: found [8086:27df] class 000101 header type 00
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
pci 0000:00:1f.2: found [8086:27c0] class 000101 header type 00
pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
pci 0000:00:1f.2: reg 24 32bit mmio: [0x50404000-0x504043ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: found [8086:27da] class 000c05 header type 00
pci 0000:00:1f.3: reg 20 io port: [0x4000-0x401f]
PCI: Fixups for bus 0000:00
pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
PCI: Scanning bus 0000:01
pci 0000:01:00.0: found [1002:7249] class 000300 header type 00
pci 0000:01:00.0: reg 10 64bit mmio: [0x40000000-0x4fffffff]
pci 0000:01:00.0: reg 18 64bit mmio: [0x50300000-0x5030ffff]
pci 0000:01:00.0: reg 20 io port: [0x3000-0x30ff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: found [1002:7269] class 000380 header type 00
pci 0000:01:00.1: reg 10 64bit mmio: [0x50310000-0x5031ffff]
pci 0000:01:00.1: supports D1 D2
PCI: Fixups for bus 0000:01
pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x4fffffff]
PCI: Bus scan for 0000:01 returning with max=01
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
pci 0000:02:00.0: found [1131:7162] class 000480 header type 00
pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x502fffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2
pci 0000:02:00.0: PME# disabled
PCI: Fixups for bus 0000:02
pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 0
PCI: Scanning bus 0000:03
PCI: Fixups for bus 0000:03
PCI: Bus scan for 0000:03 returning with max=03
pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 0
PCI: Scanning bus 0000:04
pci 0000:04:00.0: found [8086:109a] class 000200 header type 00
pci 0000:04:00.0: reg 10 32bit mmio: [0x50100000-0x5011ffff]
pci 0000:04:00.0: reg 18 io port: [0x2000-0x201f]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
PCI: Fixups for bus 0000:04
pci 0000:00:1c.5: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.5: bridge 32bit mmio: [0x50100000-0x501fffff]
PCI: Bus scan for 0000:04 returning with max=04
pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 0
PCI: Scanning bus 0000:05
pci 0000:05:02.0: found [1814:0301] class 000280 header type 00
pci 0000:05:02.0: reg 10 32bit mmio: [0x50000000-0x50007fff]
pci 0000:05:04.0: found [104c:8024] class 000c00 header type 00
pci 0000:05:04.0: reg 10 32bit mmio: [0x5000c000-0x5000c7ff]
pci 0000:05:04.0: reg 14 32bit mmio: [0x50008000-0x5000bfff]
pci 0000:05:04.0: supports D1 D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
pci 0000:05:05.0: found [1095:3114] class 000104 header type 00
pci 0000:05:05.0: reg 10 io port: [0x1018-0x101f]
pci 0000:05:05.0: reg 14 io port: [0x1024-0x1027]
pci 0000:05:05.0: reg 18 io port: [0x1010-0x1017]
pci 0000:05:05.0: reg 1c io port: [0x1020-0x1023]
pci 0000:05:05.0: reg 20 io port: [0x1000-0x100f]
pci 0000:05:05.0: reg 24 32bit mmio: [0x5000c800-0x5000cbff]
pci 0000:05:05.0: reg 30 32bit mmio: [0xfff80000-0xffffffff]
pci 0000:05:05.0: supports D1 D2
PCI: Fixups for bus 0000:05
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0x50000000-0x500fffff]
PCI: Bus scan for 0000:05 returning with max=05
pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 1
pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 1
pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 1
PCI: Bus scan for 0000:00 returning with max=05
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.4
PM: Adding info for pci:0000:00:1c.5
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.3
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:01:00.1
PM: Adding info for No Bus:0000:01
PM: Adding info for pci:0000:02:00.0
PM: Adding info for No Bus:0000:02
PM: Adding info for No Bus:0000:03
PM: Adding info for pci:0000:04:00.0
PM: Adding info for No Bus:0000:04
PM: Adding info for pci:0000:05:02.0
PM: Adding info for pci:0000:05:04.0
PM: Adding info for pci:0000:05:05.0
PM: Adding info for No Bus:0000:05
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 693359 usecs
calling  acpi_pci_link_init+0x0/0x43 @ 1
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
initcall acpi_pci_link_init+0x0/0x43 returned 0 after 39062 usecs
calling  pnp_init+0x0/0x12 @ 1
initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
calling  setup_shutdown_event+0x0/0x14 @ 1
initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 usecs
calling  balloon_init+0x0/0x1c6 @ 1
initcall balloon_init+0x0/0x1c6 returned -19 after 0 usecs
calling  misc_init+0x0/0x9f @ 1
initcall misc_init+0x0/0x9f returned 0 after 0 usecs
calling  cn_init+0x0/0xee @ 1
initcall cn_init+0x0/0xee returned 0 after 0 usecs
calling  tifm_init+0x0/0x85 @ 1
initcall tifm_init+0x0/0x85 returned 0 after 0 usecs
calling  twl4030_init+0x0/0x14 @ 1
i2c-core: driver [twl4030] registered
initcall twl4030_init+0x0/0x14 returned 0 after 0 usecs
calling  init_scsi+0x0/0x91 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 0 usecs
calling  ata_init+0x0/0x368 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x368 returned 0 after 0 usecs
calling  phy_init+0x0/0x31 @ 1
initcall phy_init+0x0/0x31 returned 0 after 0 usecs
calling  init_pcmcia_cs+0x0/0x2f @ 1
initcall init_pcmcia_cs+0x0/0x2f returned 0 after 0 usecs
calling  usb_init+0x0/0x146 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x146 returned 0 after 9765 usecs
calling  serio_init+0x0/0x98 @ 1
initcall serio_init+0x0/0x98 returned 0 after 0 usecs
calling  gameport_init+0x0/0x98 @ 1
initcall gameport_init+0x0/0x98 returned 0 after 0 usecs
calling  input_init+0x0/0x132 @ 1
initcall input_init+0x0/0x132 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x38 @ 1
initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
calling  thermal_init+0x0/0x58 @ 1
initcall thermal_init+0x0/0x58 returned 0 after 0 usecs
calling  mmc_init+0x0/0x76 @ 1
initcall mmc_init+0x0/0x76 returned 0 after 0 usecs
calling  leds_init+0x0/0x40 @ 1
initcall leds_init+0x0/0x40 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0x12a @ 1
PCI: Using ACPI for IRQ routing
initcall pci_subsys_init+0x0/0x12a returned 0 after 0 usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x1a3 @ 1
PM: Adding info for No Bus:lo
initcall net_dev_init+0x0/0x1a3 returned 0 after 0 usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xc4 @ 1
initcall pktsched_init+0x0/0xc4 returned 0 after 9765 usecs
calling  tc_filter_init+0x0/0x4c @ 1
initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
calling  tc_action_init+0x0/0x4c @ 1
initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
calling  genl_init+0x0/0xd9 @ 1
initcall genl_init+0x0/0xd9 returned 0 after 39062 usecs
calling  bt_init+0x0/0x5d @ 1
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
initcall bt_init+0x0/0x5d returned 0 after 19531 usecs
calling  atm_init+0x0/0xb4 @ 1
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall atm_init+0x0/0xb4 returned 0 after 9765 usecs
calling  wireless_nlevent_init+0x0/0x41 @ 1
initcall wireless_nlevent_init+0x0/0x41 returned 0 after 0 usecs
calling  rfkill_init+0x0/0x64 @ 1
initcall rfkill_init+0x0/0x64 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x49 @ 1
initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
calling  xen_mc_debugfs+0x0/0x118 @ 1
initcall xen_mc_debugfs+0x0/0x118 returned 0 after 0 usecs
calling  xen_mmu_debugfs+0x0/0x2be @ 1
initcall xen_mmu_debugfs+0x0/0x2be returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x17 @ 1
initcall pci_iommu_init+0x0/0x17 returned 0 after 0 usecs
calling  print_all_ICs+0x0/0x50a @ 1

printing PIC contents
... PIC  IMR: ffff
... PIC  IRR: 0c01
... PIC  ISR: 0000
... PIC ELCR: 0e00

printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00050014
... APIC TASKPRI: 00000000 (00)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000001000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008ef
... APIC ICR2: 02000000
... APIC LVTT: 00010000
... APIC LVTPC: 00000400
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 00000000
... APIC TMCCT: 00000000
... APIC TDCR: 00000000


printing local APIC contents on CPU#1/1:
... APIC ID:      01000000 (1)
... APIC VERSION: 00050014
... APIC TASKPRI: 00000000 (00)
... APIC PROCPRI: 00000000
... APIC LDR: 02000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR2: 01000000
... APIC LVTT: 00010000
... APIC LVTPC: 00010400
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 00000000
... APIC TMCCT: 00000000
... APIC TDCR: 00000000

number of MP IRQ sources: 15.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 003 0    0    0   0   0    1    1    31
 02 003 0    0    0   0   0    1    1    30
 03 003 0    0    0   0   0    1    1    33
 04 003 0    0    0   0   0    1    1    34
 05 003 0    0    0   0   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 0    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    1    0   0   0    1    1    39
 0a 003 0    0    0   0   0    1    1    3A
 0b 003 0    0    0   0   0    1    1    3B
 0c 003 0    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
initcall print_all_ICs+0x0/0x50a returned 0 after 302734 usecs
calling  hpet_late_init+0x0/0x1cb @ 1
initcall hpet_late_init+0x0/0x1cb returned -19 after 0 usecs
calling  clocksource_done_booting+0x0/0x12 @ 1
initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
calling  init_pipe_fs+0x0/0x4c @ 1
initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
calling  init_mnt_writers+0x0/0x8e @ 1
initcall init_mnt_writers+0x0/0x8e returned 0 after 0 usecs
calling  eventpoll_init+0x0/0x9d @ 1
initcall eventpoll_init+0x0/0x9d returned 0 after 0 usecs
calling  anon_inode_init+0x0/0x11d @ 1
initcall anon_inode_init+0x0/0x11d returned 0 after 0 usecs
calling  tomoyo_initerface_init+0x0/0x11c @ 1
initcall tomoyo_initerface_init+0x0/0x11c returned 0 after 9765 usecs
calling  acpi_event_init+0x0/0x80 @ 1
initcall acpi_event_init+0x0/0x80 returned 0 after 29296 usecs
calling  pnpacpi_init+0x0/0x8c @ 1
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
PM: Adding info for pnp:00:03
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
PM: Adding info for pnp:00:07
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
PM: Adding info for pnp:00:08
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
PM: Adding info for pnp:00:09
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
PM: Adding info for pnp:00:0a
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
PM: Adding info for pnp:00:0b
PM: Adding info for pnp:00:0c
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 107421 usecs
calling  pnp_system_init+0x0/0x12 @ 1
system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff has been reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 68359 usecs
calling  chr_dev_init+0x0/0xb4 @ 1
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
initcall chr_dev_init+0x0/0xb4 returned 0 after 29296 usecs
calling  firmware_class_init+0x0/0x79 @ 1
initcall firmware_class_init+0x0/0x79 returned 0 after 0 usecs
calling  ieee1394_init+0x0/0x264 @ 1
initcall ieee1394_init+0x0/0x264 returned 0 after 0 usecs
calling  init_pcmcia_bus+0x0/0x84 @ 1
initcall init_pcmcia_bus+0x0/0x84 returned 0 after 9765 usecs
calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0x68 @ 1
initcall cpufreq_gov_dbs_init+0x0/0x68 returned 0 after 0 usecs
calling  ssb_modinit+0x0/0x4a @ 1
initcall ssb_modinit+0x0/0x4a returned 0 after 0 usecs
calling  pcibios_assign_resources+0x0/0x88 @ 1
pci 0000:01:00.0: BAR 6: got res [0x50320000-0x5033ffff] bus [0x50320000-0x5033ffff] flags 0x27200
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x3000-0x3fff
pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x0000004fffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: disabled
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.5:   IO window: 0x2000-0x2fff
pci 0000:00:1c.5:   MEM window: 0x50100000-0x501fffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
pci 0000:00:1e.0:   MEM window: 0x50000000-0x500fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
  alloc irq_desc for 16 on node 0
  alloc kstat_irqs on node 0
IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 17 on node 0
  alloc kstat_irqs on node 0
IOAPIC[0]: Set routing entry (2-17 -> 0x51 -> IRQ 17 Mode:1 Active:1)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:01: resource 1 mem: [0x50300000-0x503fffff]
pci_bus 0000:01: resource 2 pref mem [0x40000000-0x4fffffff]
pci_bus 0000:02: resource 1 mem: [0x50200000-0x502fffff]
pci_bus 0000:04: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:04: resource 1 mem: [0x50100000-0x501fffff]
pci_bus 0000:05: resource 0 io:  [0x1000-0x1fff]
pci_bus 0000:05: resource 1 mem: [0x50000000-0x500fffff]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
initcall pcibios_assign_resources+0x0/0x88 returned 0 after 214843 usecs
calling  sysctl_core_init+0x0/0x38 @ 1
initcall sysctl_core_init+0x0/0x38 returned 0 after 0 usecs
calling  inet_init+0x0/0x1ca @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x1ca returned 0 after 185546 usecs
calling  af_unix_init+0x0/0x55 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 9765 usecs
calling  populate_rootfs+0x0/0x28e @ 1
initcall populate_rootfs+0x0/0x28e returned 0 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x22 @ 1
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
calling  vsyscall_init+0x0/0x6c @ 1
initcall vsyscall_init+0x0/0x6c returned 0 after 0 usecs
calling  sbf_init+0x0/0xd5 @ 1
initcall sbf_init+0x0/0xd5 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x22 @ 1
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
calling  add_rtc_cmos+0x0/0xaa @ 1
initcall add_rtc_cmos+0x0/0xaa returned 0 after 0 usecs
calling  ds_selftest+0x0/0x6e @ 1
[ds] bts selftest...no resume progress/overflow...passed.
initcall ds_selftest+0x0/0x6e returned 0 after 0 usecs
calling  cache_sysfs_init+0x0/0x64 @ 1
initcall cache_sysfs_init+0x0/0x64 returned 0 after 0 usecs
calling  mce_init_device+0x0/0x163 @ 1
PM: Adding info for No Bus:mcelog
initcall mce_init_device+0x0/0x163 returned 0 after 0 usecs
calling  thermal_throttle_init_device+0x0/0x8d @ 1
initcall thermal_throttle_init_device+0x0/0x8d returned 0 after 0 usecs
calling  threshold_init_device+0x0/0x4f @ 1
initcall threshold_init_device+0x0/0x4f returned 0 after 0 usecs
calling  inject_init+0x0/0x21 @ 1
Machine check injector initialized
initcall inject_init+0x0/0x21 returned 0 after 9765 usecs
calling  cpuid_init+0x0/0x114 @ 1
PM: Adding info for No Bus:cpu0
PM: Adding info for No Bus:cpu1
initcall cpuid_init+0x0/0x114 returned 0 after 9765 usecs
calling  ioapic_init_sysfs+0x0/0xa6 @ 1
initcall ioapic_init_sysfs+0x0/0xa6 returned 0 after 0 usecs
calling  add_pcspkr+0x0/0x28 @ 1
PM: Adding info for platform:pcspkr
initcall add_pcspkr+0x0/0x28 returned 0 after 0 usecs
calling  microcode_init+0x0/0x123 @ 1
PM: Adding info for platform:microcode
microcode: CPU0 sig=0x6f5, pf=0x1, revision=0x33
microcode: CPU1 sig=0x6f5, pf=0x1, revision=0x33
PM: Adding info for No Bus:microcode
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
initcall microcode_init+0x0/0x123 returned 0 after 19531 usecs
calling  start_periodic_check_for_corruption+0x0/0x37 @ 1
Scanning for low memory corruption every 60 seconds
initcall start_periodic_check_for_corruption+0x0/0x37 returned 0 after 9765 usecs
calling  audit_classes_init+0x0/0xaf @ 1
initcall audit_classes_init+0x0/0xaf returned 0 after 0 usecs
calling  pt_dump_init+0x0/0x2b @ 1
initcall pt_dump_init+0x0/0x2b returned 0 after 0 usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after 9765 usecs
calling  init+0x0/0x12 @ 1
initcall init+0x0/0x12 returned 0 after 0 usecs
calling  init+0x0/0x12 @ 1
initcall init+0x0/0x12 returned 0 after 0 usecs
calling  aesni_init+0x0/0xba @ 1
Intel AES-NI instructions are not detected.
initcall aesni_init+0x0/0xba returned -19 after 0 usecs
calling  crc32c_intel_mod_init+0x0/0x20 @ 1
initcall crc32c_intel_mod_init+0x0/0x20 returned -19 after 0 usecs
calling  init_vdso_vars+0x0/0x1f9 @ 1
initcall init_vdso_vars+0x0/0x1f9 returned 0 after 0 usecs
calling  ia32_binfmt_init+0x0/0x14 @ 1
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 usecs
calling  sysenter_setup+0x0/0x2d5 @ 1
initcall sysenter_setup+0x0/0x2d5 returned 0 after 0 usecs
calling  init_sched_debug_procfs+0x0/0x2c @ 1
initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 0 usecs
calling  proc_schedstat_init+0x0/0x22 @ 1
initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_execdomains_init+0x0/0x22 @ 1
initcall proc_execdomains_init+0x0/0x22 returned 0 after 0 usecs
calling  ioresources_init+0x0/0x3c @ 1
initcall ioresources_init+0x0/0x3c returned 0 after 0 usecs
calling  uid_cache_init+0x0/0x6e @ 1
initcall uid_cache_init+0x0/0x6e returned 0 after 0 usecs
calling  init_posix_timers+0x0/0x108 @ 1
initcall init_posix_timers+0x0/0x108 returned 0 after 0 usecs
calling  init_posix_cpu_timers+0x0/0xd4 @ 1
initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x22 @ 1
initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 usecs
calling  init_clocksource_sysfs+0x0/0x50 @ 1
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 usecs
calling  init_timer_list_procfs+0x0/0x2c @ 1
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 usecs
calling  lockdep_proc_init+0x0/0x7c @ 1
initcall lockdep_proc_init+0x0/0x7c returned 0 after 0 usecs
calling  futex_init+0x0/0x92 @ 1
initcall futex_init+0x0/0x92 returned 0 after 0 usecs
calling  init_rttest+0x0/0x14e @ 1
Initializing RT-Tester: OK
initcall init_rttest+0x0/0x14e returned 0 after 0 usecs
calling  proc_dma_init+0x0/0x22 @ 1
initcall proc_dma_init+0x0/0x22 returned 0 after 0 usecs
calling  kallsyms_init+0x0/0x25 @ 1
initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
calling  pid_namespaces_init+0x0/0x2d @ 1
initcall pid_namespaces_init+0x0/0x2d returned 0 after 0 usecs
calling  audit_init+0x0/0x16a @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1244629415.610:1): initialized
audit: cannot initialize inotify handle
initcall audit_init+0x0/0x16a returned 0 after 19531 usecs
calling  rcu_torture_init+0x0/0x6f0 @ 1
rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
initcall rcu_torture_init+0x0/0x6f0 returned 0 after 9765 usecs
calling  rcuclassic_trace_init+0x0/0x156 @ 1
initcall rcuclassic_trace_init+0x0/0x156 returned 0 after 0 usecs
calling  utsname_sysctl_init+0x0/0x14 @ 1
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 usecs
calling  init_lstats_procfs+0x0/0x25 @ 1
initcall init_lstats_procfs+0x0/0x25 returned 0 after 0 usecs
calling  perf_counter_sysfs_init+0x0/0x19 @ 1
initcall perf_counter_sysfs_init+0x0/0x19 returned 0 after 0 usecs
calling  init_per_zone_pages_min+0x0/0x89 @ 1
initcall init_per_zone_pages_min+0x0/0x89 returned 0 after 0 usecs
calling  pdflush_init+0x0/0x27 @ 1
initcall pdflush_init+0x0/0x27 returned 0 after 0 usecs
calling  kswapd_init+0x0/0x68 @ 1
initcall kswapd_init+0x0/0x68 returned 0 after 0 usecs
calling  init_tmpfs+0x0/0x3d @ 1
initcall init_tmpfs+0x0/0x3d returned 0 after 0 usecs
calling  setup_vmstat+0x0/0xc5 @ 1
initcall setup_vmstat+0x0/0xc5 returned 0 after 0 usecs
calling  mm_sysfs_init+0x0/0x29 @ 1
initcall mm_sysfs_init+0x0/0x29 returned 0 after 0 usecs
calling  proc_vmalloc_init+0x0/0x25 @ 1
initcall proc_vmalloc_init+0x0/0x25 returned 0 after 0 usecs
calling  hugetlb_init+0x0/0x2bf @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x2bf returned 0 after 9765 usecs
calling  slab_proc_init+0x0/0x25 @ 1
initcall slab_proc_init+0x0/0x25 returned 0 after 0 usecs
calling  slab_sysfs_init+0x0/0xf0 @ 1
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 19531 usecs
calling  fasync_init+0x0/0x2a @ 1
initcall fasync_init+0x0/0x2a returned 0 after 0 usecs
calling  proc_filesystems_init+0x0/0x22 @ 1
initcall proc_filesystems_init+0x0/0x22 returned 0 after 0 usecs
calling  dnotify_init+0x0/0x2a @ 1
initcall dnotify_init+0x0/0x2a returned 0 after 0 usecs
calling  aio_setup+0x0/0xa3 @ 1
initcall aio_setup+0x0/0xa3 returned 0 after 0 usecs
calling  proc_locks_init+0x0/0x22 @ 1
initcall proc_locks_init+0x0/0x22 returned 0 after 0 usecs
calling  init_sys32_ioctl+0x0/0x85 @ 1
initcall init_sys32_ioctl+0x0/0x85 returned 0 after 0 usecs
calling  init_mbcache+0x0/0x14 @ 1
initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
calling  dquot_init+0x0/0xe0 @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0xe0 returned 0 after 9765 usecs
calling  init_v1_quota_format+0x0/0x12 @ 1
initcall init_v1_quota_format+0x0/0x12 returned 0 after 0 usecs
calling  init_v2_quota_format+0x0/0x12 @ 1
initcall init_v2_quota_format+0x0/0x12 returned 0 after 0 usecs
calling  proc_cmdline_init+0x0/0x22 @ 1
initcall proc_cmdline_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_cpuinfo_init+0x0/0x22 @ 1
initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_devices_init+0x0/0x22 @ 1
initcall proc_devices_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_interrupts_init+0x0/0x22 @ 1
initcall proc_interrupts_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_loadavg_init+0x0/0x22 @ 1
initcall proc_loadavg_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_meminfo_init+0x0/0x22 @ 1
initcall proc_meminfo_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_stat_init+0x0/0x22 @ 1
initcall proc_stat_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_uptime_init+0x0/0x22 @ 1
initcall proc_uptime_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_version_init+0x0/0x22 @ 1
initcall proc_version_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_kcore_init+0x0/0x49 @ 1
initcall proc_kcore_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_kmsg_init+0x0/0x25 @ 1
initcall proc_kmsg_init+0x0/0x25 returned 0 after 0 usecs
calling  proc_page_init+0x0/0x42 @ 1
initcall proc_page_init+0x0/0x42 returned 0 after 0 usecs
calling  configfs_init+0x0/0xb3 @ 1
initcall configfs_init+0x0/0xb3 returned 0 after 0 usecs
calling  init_devpts_fs+0x0/0x3f @ 1
initcall init_devpts_fs+0x0/0x3f returned 0 after 0 usecs
calling  init_dlm+0x0/0x98 @ 1
PM: Adding info for No Bus:dlm-control
PM: Adding info for No Bus:dlm-monitor
PM: Adding info for No Bus:dlm_plock
DLM (built Jun 10 2009 12:19:54) installed
initcall init_dlm+0x0/0x98 returned 0 after 9765 usecs
calling  init_reiserfs_fs+0x0/0x83 @ 1
initcall init_reiserfs_fs+0x0/0x83 returned 0 after 0 usecs
calling  init_ext3_fs+0x0/0x6a @ 1
initcall init_ext3_fs+0x0/0x6a returned 0 after 0 usecs
calling  init_ext2_fs+0x0/0x6a @ 1
initcall init_ext2_fs+0x0/0x6a returned 0 after 0 usecs
calling  journal_init+0x0/0x93 @ 1
initcall journal_init+0x0/0x93 returned 0 after 0 usecs
calling  init_ramfs_fs+0x0/0x12 @ 1
initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
calling  init_hugetlbfs_fs+0x0/0x98 @ 1
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 0 usecs
calling  init_coda+0x0/0x13c @ 1
PM: Adding info for No Bus:cfs0
PM: Adding info for No Bus:cfs1
PM: Adding info for No Bus:cfs2
PM: Adding info for No Bus:cfs3
PM: Adding info for No Bus:cfs4
initcall init_coda+0x0/0x13c returned 0 after 19531 usecs
calling  init_fat_fs+0x0/0x4f @ 1
initcall init_fat_fs+0x0/0x4f returned 0 after 0 usecs
calling  init_vfat_fs+0x0/0x12 @ 1
initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
calling  init_iso9660_fs+0x0/0x6c @ 1
initcall init_iso9660_fs+0x0/0x6c returned 0 after 0 usecs
calling  init_nfsd+0x0/0xe3 @ 1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0xe3 returned 0 after 9765 usecs
calling  init_nlm+0x0/0x22 @ 1
initcall init_nlm+0x0/0x22 returned 0 after 0 usecs
calling  init_nls_cp437+0x0/0x12 @ 1
initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp737+0x0/0x12 @ 1
initcall init_nls_cp737+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp775+0x0/0x12 @ 1
initcall init_nls_cp775+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp850+0x0/0x12 @ 1
initcall init_nls_cp850+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp852+0x0/0x12 @ 1
initcall init_nls_cp852+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp855+0x0/0x12 @ 1
initcall init_nls_cp855+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp857+0x0/0x12 @ 1
initcall init_nls_cp857+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp861+0x0/0x12 @ 1
initcall init_nls_cp861+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp862+0x0/0x12 @ 1
initcall init_nls_cp862+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp863+0x0/0x12 @ 1
initcall init_nls_cp863+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp864+0x0/0x12 @ 1
initcall init_nls_cp864+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp865+0x0/0x12 @ 1
initcall init_nls_cp865+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp869+0x0/0x12 @ 1
initcall init_nls_cp869+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp874+0x0/0x12 @ 1
initcall init_nls_cp874+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp949+0x0/0x12 @ 1
initcall init_nls_cp949+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp1250+0x0/0x12 @ 1
initcall init_nls_cp1250+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp1251+0x0/0x12 @ 1
initcall init_nls_cp1251+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_ascii+0x0/0x12 @ 1
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_2+0x0/0x12 @ 1
initcall init_nls_iso8859_2+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_3+0x0/0x12 @ 1
initcall init_nls_iso8859_3+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_4+0x0/0x12 @ 1
initcall init_nls_iso8859_4+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_6+0x0/0x12 @ 1
initcall init_nls_iso8859_6+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp1255+0x0/0x12 @ 1
initcall init_nls_cp1255+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_15+0x0/0x12 @ 1
initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 usecs
calling  init_smb_fs+0x0/0x6c @ 1
initcall init_smb_fs+0x0/0x6c returned 0 after 0 usecs
calling  init_ncp_fs+0x0/0x5a @ 1
initcall init_ncp_fs+0x0/0x5a returned 0 after 0 usecs
calling  init_ntfs_fs+0x0/0x1d1 @ 1
NTFS driver 2.1.29 [Flags: R/W].
initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 9765 usecs
calling  init_autofs_fs+0x0/0x12 @ 1
initcall init_autofs_fs+0x0/0x12 returned 0 after 0 usecs
calling  init_autofs4_fs+0x0/0x26 @ 1
initcall init_autofs4_fs+0x0/0x26 returned -16 after 0 usecs
initcall init_autofs4_fs+0x0/0x26 returned with error code -16 
calling  fuse_init+0x0/0x125 @ 1
fuse init (API version 7.11)
PM: Adding info for No Bus:fuse
initcall fuse_init+0x0/0x125 returned 0 after 0 usecs
calling  init_udf_fs+0x0/0x5a @ 1
initcall init_udf_fs+0x0/0x5a returned 0 after 0 usecs
calling  init_xfs_fs+0x0/0xa9 @ 1
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
initcall init_xfs_fs+0x0/0xa9 returned 0 after 19531 usecs
calling  init_btrfs_fs+0x0/0x8f @ 1
PM: Adding info for No Bus:btrfs-control
Btrfs loaded
initcall init_btrfs_fs+0x0/0x8f returned 0 after 9765 usecs
calling  ipc_init+0x0/0x2f @ 1
msgmni has been set to 1901
initcall ipc_init+0x0/0x2f returned 0 after 0 usecs
calling  ipc_sysctl_init+0x0/0x14 @ 1
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 0 usecs
calling  init_mqueue_fs+0x0/0xc8 @ 1
initcall init_mqueue_fs+0x0/0xc8 returned 0 after 0 usecs
calling  key_proc_init+0x0/0x33 @ 1
initcall key_proc_init+0x0/0x33 returned 0 after 0 usecs
calling  crypto_wq_init+0x0/0x32 @ 1
initcall crypto_wq_init+0x0/0x32 returned 0 after 0 usecs
calling  crypto_algapi_init+0x0/0xd @ 1
initcall crypto_algapi_init+0x0/0xd returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x12 @ 1
initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  eseqiv_module_init+0x0/0x12 @ 1
initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  seqiv_module_init+0x0/0x12 @ 1
initcall seqiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  hmac_module_init+0x0/0x12 @ 1
initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_null_mod_init+0x0/0x7b @ 1
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
initcall crypto_null_mod_init+0x0/0x7b returned 0 after 19531 usecs
calling  md5_mod_init+0x0/0x12 @ 1
initcall md5_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  rmd160_mod_init+0x0/0x12 @ 1
initcall rmd160_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  rmd256_mod_init+0x0/0x12 @ 1
initcall rmd256_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  rmd320_mod_init+0x0/0x12 @ 1
initcall rmd320_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  sha1_generic_mod_init+0x0/0x12 @ 1
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  sha256_generic_mod_init+0x0/0x3f @ 1
initcall sha256_generic_mod_init+0x0/0x3f returned 0 after 0 usecs
calling  sha512_generic_mod_init+0x0/0x3f @ 1
initcall sha512_generic_mod_init+0x0/0x3f returned 0 after 0 usecs
calling  wp512_mod_init+0x0/0x64 @ 1
initcall wp512_mod_init+0x0/0x64 returned 0 after 0 usecs
calling  crypto_ecb_module_init+0x0/0x12 @ 1
initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_cbc_module_init+0x0/0x12 @ 1
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_pcbc_module_init+0x0/0x12 @ 1
initcall crypto_pcbc_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_module_init+0x0/0x12 @ 1
initcall crypto_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_module_init+0x0/0x12 @ 1
initcall crypto_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_ctr_module_init+0x0/0x3f @ 1
initcall crypto_ctr_module_init+0x0/0x3f returned 0 after 0 usecs
calling  crypto_gcm_module_init+0x0/0x5d @ 1
initcall crypto_gcm_module_init+0x0/0x5d returned 0 after 0 usecs
calling  crypto_ccm_module_init+0x0/0x5d @ 1
initcall crypto_ccm_module_init+0x0/0x5d returned 0 after 0 usecs
calling  cryptd_init+0x0/0xeb @ 1
initcall cryptd_init+0x0/0xeb returned 0 after 0 usecs
calling  des_generic_mod_init+0x0/0x3f @ 1
initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 usecs
calling  fcrypt_mod_init+0x0/0x12 @ 1
alg: No test for fcrypt (fcrypt-generic)
initcall fcrypt_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  twofish_mod_init+0x0/0x12 @ 1
initcall twofish_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after 0 usecs
calling  camellia_init+0x0/0x12 @ 1
initcall camellia_init+0x0/0x12 returned 0 after 0 usecs
calling  cast5_mod_init+0x0/0x12 @ 1
initcall cast5_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  cast6_mod_init+0x0/0x12 @ 1
initcall cast6_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  arc4_init+0x0/0x12 @ 1
initcall arc4_init+0x0/0x12 returned 0 after 0 usecs
calling  tea_mod_init+0x0/0x64 @ 1
initcall tea_mod_init+0x0/0x64 returned 0 after 0 usecs
calling  khazad_mod_init+0x0/0x12 @ 1
initcall khazad_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  anubis_mod_init+0x0/0x12 @ 1
initcall anubis_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  seed_init+0x0/0x12 @ 1
initcall seed_init+0x0/0x12 returned 0 after 0 usecs
calling  salsa20_generic_mod_init+0x0/0x12 @ 1
initcall salsa20_generic_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  deflate_mod_init+0x0/0x12 @ 1
initcall deflate_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  michael_mic_init+0x0/0x12 @ 1
initcall michael_mic_init+0x0/0x12 returned 0 after 0 usecs
calling  crc32c_mod_init+0x0/0x12 @ 1
initcall crc32c_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_authenc_module_init+0x0/0x12 @ 1
initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
calling  krng_mod_init+0x0/0x12 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  proc_genhd_init+0x0/0x3c @ 1
initcall proc_genhd_init+0x0/0x3c returned 0 after 0 usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 0 usecs
calling  as_init+0x0/0x14 @ 1
io scheduler anticipatory registered (default)
initcall as_init+0x0/0x14 returned 0 after 0 usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 0 usecs
calling  cfq_init+0x0/0x94 @ 1
io scheduler cfq registered
initcall cfq_init+0x0/0x94 returned 0 after 29296 usecs
calling  debug_objects_init_debugfs+0x0/0x64 @ 1
initcall debug_objects_init_debugfs+0x0/0x64 returned 0 after 0 usecs
calling  libcrc32c_mod_init+0x0/0x2c @ 1
initcall libcrc32c_mod_init+0x0/0x2c returned 0 after 0 usecs
calling  init_kmp+0x0/0x12 @ 1
initcall init_kmp+0x0/0x12 returned 0 after 0 usecs
calling  init_bm+0x0/0x12 @ 1
initcall init_bm+0x0/0x12 returned 0 after 0 usecs
calling  init_fsm+0x0/0x12 @ 1
initcall init_fsm+0x0/0x12 returned 0 after 0 usecs
calling  percpu_counter_startup+0x0/0x19 @ 1
initcall percpu_counter_startup+0x0/0x19 returned 0 after 0 usecs
calling  dynamic_debug_init+0x0/0x12c @ 1
initcall dynamic_debug_init+0x0/0x12c returned 0 after 0 usecs
calling  pci_init+0x0/0x35 @ 1
initcall pci_init+0x0/0x35 returned 0 after 0 usecs
calling  pci_proc_init+0x0/0x6a @ 1
initcall pci_proc_init+0x0/0x6a returned 0 after 0 usecs
calling  pci_hotplug_init+0x0/0x1d @ 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x1d returned 0 after 9765 usecs
calling  acpiphp_init+0x0/0x5f @ 1
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: can't get bus number, assuming 0
initcall acpiphp_init+0x0/0x5f returned -19 after 9765 usecs
calling  shpcd_init+0x0/0x62 @ 1
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x62 returned 0 after 19531 usecs
calling  genericbl_init+0x0/0x12 @ 1
initcall genericbl_init+0x0/0x12 returned 0 after 9765 usecs
calling  progearbl_init+0x0/0x55 @ 1
PM: Adding info for platform:progear-bl
ALI M7101 PMU not found.
initcall progearbl_init+0x0/0x55 returned 0 after 39062 usecs
calling  da903x_backlight_init+0x0/0x12 @ 1
initcall da903x_backlight_init+0x0/0x12 returned 0 after 29296 usecs
calling  mbp_init+0x0/0xb @ 1
initcall mbp_init+0x0/0xb returned -19 after 0 usecs
calling  acpi_reserve_resources+0x0/0xeb @ 1
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 usecs
calling  irqrouter_init_sysfs+0x0/0x38 @ 1
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 9765 usecs
calling  acpi_ac_init+0x0/0x45 @ 1
initcall acpi_ac_init+0x0/0x45 returned 0 after 9765 usecs
calling  acpi_fan_init+0x0/0x56 @ 1
initcall acpi_fan_init+0x0/0x56 returned 0 after 0 usecs
calling  acpi_video_init+0x0/0xb @ 1
initcall acpi_video_init+0x0/0xb returned 0 after 0 usecs
calling  acpi_pci_slot_init+0x0/0x14 @ 1
initcall acpi_pci_slot_init+0x0/0x14 returned 0 after 0 usecs
calling  acpi_processor_init+0x0/0xf3 @ 1
PM: Adding info for No Bus:cooling_device0
processor ACPI_CPU:00: registered as cooling_device0
PM: Adding info for No Bus:cooling_device1
processor ACPI_CPU:01: registered as cooling_device1
initcall acpi_processor_init+0x0/0xf3 returned 0 after 39062 usecs
calling  acpi_container_init+0x0/0x42 @ 1
initcall acpi_container_init+0x0/0x42 returned 0 after 9765 usecs
calling  acpi_thermal_init+0x0/0x6f @ 1
initcall acpi_thermal_init+0x0/0x6f returned 0 after 39062 usecs
calling  xenfs_init+0x0/0x2d @ 1
XENFS: not registering filesystem on non-xen platform
initcall xenfs_init+0x0/0x2d returned 0 after 9765 usecs
calling  regulator_virtual_consumer_init+0x0/0x12 @ 1
initcall regulator_virtual_consumer_init+0x0/0x12 returned 0 after 19531 usecs
calling  wm8400_regulator_init+0x0/0x12 @ 1
initcall wm8400_regulator_init+0x0/0x12 returned 0 after 29296 usecs
calling  pcf50633_regulator_init+0x0/0x12 @ 1
initcall pcf50633_regulator_init+0x0/0x12 returned 0 after 29296 usecs
calling  rand_initialize+0x0/0x2c @ 1
initcall rand_initialize+0x0/0x2c returned 0 after 0 usecs
calling  tty_init+0x0/0xf5 @ 1
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
initcall tty_init+0x0/0xf5 returned 0 after 615234 usecs
calling  pty_init+0x0/0x284 @ 1
PM: Adding info for No Bus:ptmx
initcall pty_init+0x0/0x284 returned 0 after 9765 usecs
calling  sysrq_init+0x0/0x25 @ 1
initcall sysrq_init+0x0/0x25 returned 0 after 0 usecs
calling  rp_init+0x0/0x1288 @ 1
RocketPort device driver module, version 2.09, 12-June-2003
No rocketport ports found; unloading driver
initcall rp_init+0x0/0x1288 returned -6 after 9765 usecs
initcall rp_init+0x0/0x1288 returned with error code -6 
calling  cy_init+0x0/0x123 @ 1
Cyclades driver 2.5 (built Jun 10 2009 12:19:15)
initcall cy_init+0x0/0x123 returned 0 after 29296 usecs
calling  nozomi_init+0x0/0x12a @ 1
Initializing Nozomi driver 2.1d (build date: Jun 10 2009 12:19:16)
initcall nozomi_init+0x0/0x12a returned 0 after 39062 usecs
calling  epca_module_init+0x0/0x466 @ 1
DIGI epca driver version 1.3.0.1-LK2.6 loaded.
PM: Adding info for No Bus:ttyD0
PM: Adding info for No Bus:ttyD1
PM: Adding info for No Bus:ttyD2
PM: Adding info for No Bus:ttyD3
PM: Adding info for No Bus:ttyD4
PM: Adding info for No Bus:ttyD5
PM: Adding info for No Bus:ttyD6
PM: Adding info for No Bus:ttyD7
PM: Adding info for No Bus:ttyD8
PM: Adding info for No Bus:ttyD9
PM: Adding info for No Bus:ttyD10
PM: Adding info for No Bus:ttyD11
PM: Adding info for No Bus:ttyD12
PM: Adding info for No Bus:ttyD13
PM: Adding info for No Bus:ttyD14
PM: Adding info for No Bus:ttyD15
PM: Adding info for No Bus:ttyD16
PM: Adding info for No Bus:ttyD17
PM: Adding info for No Bus:ttyD18
PM: Adding info for No Bus:ttyD19
PM: Adding info for No Bus:ttyD20
PM: Adding info for No Bus:ttyD21
PM: Adding info for No Bus:ttyD22
PM: Adding info for No Bus:ttyD23
PM: Adding info for No Bus:ttyD24
PM: Adding info for No Bus:ttyD25
PM: Adding info for No Bus:ttyD26
PM: Adding info for No Bus:ttyD27
PM: Adding info for No Bus:ttyD28
PM: Adding info for No Bus:ttyD29
PM: Adding info for No Bus:ttyD30
PM: Adding info for No Bus:ttyD31
PM: Adding info for No Bus:ttyD32
PM: Adding info for No Bus:ttyD33
PM: Adding info for No Bus:ttyD34
PM: Adding info for No Bus:ttyD35
PM: Adding info for No Bus:ttyD36
PM: Adding info for No Bus:ttyD37
PM: Adding info for No Bus:ttyD38
PM: Adding info for No Bus:ttyD39
PM: Adding info for No Bus:ttyD40
PM: Adding info for No Bus:ttyD41
PM: Adding info for No Bus:ttyD42
PM: Adding info for No Bus:ttyD43
PM: Adding info for No Bus:ttyD44
PM: Adding info for No Bus:ttyD45
PM: Adding info for No Bus:ttyD46
PM: Adding info for No Bus:ttyD47
PM: Adding info for No Bus:ttyD48
PM: Adding info for No Bus:ttyD49
PM: Adding info for No Bus:ttyD50
PM: Adding info for No Bus:ttyD51
PM: Adding info for No Bus:ttyD52
PM: Adding info for No Bus:ttyD53
PM: Adding info for No Bus:ttyD54
PM: Adding info for No Bus:ttyD55
PM: Adding info for No Bus:ttyD56
PM: Adding info for No Bus:ttyD57
PM: Adding info for No Bus:ttyD58
PM: Adding info for No Bus:ttyD59
PM: Adding info for No Bus:ttyD60
PM: Adding info for No Bus:ttyD61
PM: Adding info for No Bus:ttyD62
PM: Adding info for No Bus:ttyD63
PM: Adding info for No Bus:ttyD64
PM: Adding info for No Bus:ttyD65
PM: Adding info for No Bus:ttyD66
PM: Adding info for No Bus:ttyD67
PM: Adding info for No Bus:ttyD68
PM: Adding info for No Bus:ttyD69
PM: Adding info for No Bus:ttyD70
PM: Adding info for No Bus:ttyD71
PM: Adding info for No Bus:ttyD72
PM: Adding info for No Bus:ttyD73
PM: Adding info for No Bus:ttyD74
PM: Adding info for No Bus:ttyD75
PM: Adding info for No Bus:ttyD76
PM: Adding info for No Bus:ttyD77
PM: Adding info for No Bus:ttyD78
PM: Adding info for No Bus:ttyD79
PM: Adding info for No Bus:ttyD80
PM: Adding info for No Bus:ttyD81
PM: Adding info for No Bus:ttyD82
PM: Adding info for No Bus:ttyD83
PM: Adding info for No Bus:ttyD84
PM: Adding info for No Bus:ttyD85
PM: Adding info for No Bus:ttyD86
PM: Adding info for No Bus:ttyD87
PM: Adding info for No Bus:ttyD88
PM: Adding info for No Bus:ttyD89
PM: Adding info for No Bus:ttyD90
PM: Adding info for No Bus:ttyD91
PM: Adding info for No Bus:ttyD92
PM: Adding info for No Bus:ttyD93
PM: Adding info for No Bus:ttyD94
PM: Adding info for No Bus:ttyD95
PM: Adding info for No Bus:ttyD96
PM: Adding info for No Bus:ttyD97
PM: Adding info for No Bus:ttyD98
PM: Adding info for No Bus:ttyD99
PM: Adding info for No Bus:ttyD100
PM: Adding info for No Bus:ttyD101
PM: Adding info for No Bus:ttyD102
PM: Adding info for No Bus:ttyD103
PM: Adding info for No Bus:ttyD104
PM: Adding info for No Bus:ttyD105
PM: Adding info for No Bus:ttyD106
PM: Adding info for No Bus:ttyD107
PM: Adding info for No Bus:ttyD108
PM: Adding info for No Bus:ttyD109
PM: Adding info for No Bus:ttyD110
PM: Adding info for No Bus:ttyD111
PM: Adding info for No Bus:ttyD112
PM: Adding info for No Bus:ttyD113
PM: Adding info for No Bus:ttyD114
PM: Adding info for No Bus:ttyD115
PM: Adding info for No Bus:ttyD116
PM: Adding info for No Bus:ttyD117
PM: Adding info for No Bus:ttyD118
PM: Adding info for No Bus:ttyD119
PM: Adding info for No Bus:ttyD120
PM: Adding info for No Bus:ttyD121
PM: Adding info for No Bus:ttyD122
PM: Adding info for No Bus:ttyD123
PM: Adding info for No Bus:ttyD124
PM: Adding info for No Bus:ttyD125
PM: Adding info for No Bus:ttyD126
PM: Adding info for No Bus:ttyD127
PM: Adding info for No Bus:ttyD128
PM: Adding info for No Bus:ttyD129
PM: Adding info for No Bus:ttyD130
PM: Adding info for No Bus:ttyD131
PM: Adding info for No Bus:ttyD132
PM: Adding info for No Bus:ttyD133
PM: Adding info for No Bus:ttyD134
PM: Adding info for No Bus:ttyD135
PM: Adding info for No Bus:ttyD136
PM: Adding info for No Bus:ttyD137
PM: Adding info for No Bus:ttyD138
PM: Adding info for No Bus:ttyD139
PM: Adding info for No Bus:ttyD140
PM: Adding info for No Bus:ttyD141
PM: Adding info for No Bus:ttyD142
PM: Adding info for No Bus:ttyD143
PM: Adding info for No Bus:ttyD144
PM: Adding info for No Bus:ttyD145
PM: Adding info for No Bus:ttyD146
PM: Adding info for No Bus:ttyD147
PM: Adding info for No Bus:ttyD148
PM: Adding info for No Bus:ttyD149
PM: Adding info for No Bus:ttyD150
PM: Adding info for No Bus:ttyD151
PM: Adding info for No Bus:ttyD152
PM: Adding info for No Bus:ttyD153
PM: Adding info for No Bus:ttyD154
PM: Adding info for No Bus:ttyD155
PM: Adding info for No Bus:ttyD156
PM: Adding info for No Bus:ttyD157
PM: Adding info for No Bus:ttyD158
PM: Adding info for No Bus:ttyD159
PM: Adding info for No Bus:ttyD160
PM: Adding info for No Bus:ttyD161
PM: Adding info for No Bus:ttyD162
PM: Adding info for No Bus:ttyD163
PM: Adding info for No Bus:ttyD164
PM: Adding info for No Bus:ttyD165
PM: Adding info for No Bus:ttyD166
PM: Adding info for No Bus:ttyD167
PM: Adding info for No Bus:ttyD168
PM: Adding info for No Bus:ttyD169
PM: Adding info for No Bus:ttyD170
PM: Adding info for No Bus:ttyD171
PM: Adding info for No Bus:ttyD172
PM: Adding info for No Bus:ttyD173
PM: Adding info for No Bus:ttyD174
PM: Adding info for No Bus:ttyD175
PM: Adding info for No Bus:ttyD176
PM: Adding info for No Bus:ttyD177
PM: Adding info for No Bus:ttyD178
PM: Adding info for No Bus:ttyD179
PM: Adding info for No Bus:ttyD180
PM: Adding info for No Bus:ttyD181
PM: Adding info for No Bus:ttyD182
PM: Adding info for No Bus:ttyD183
PM: Adding info for No Bus:ttyD184
PM: Adding info for No Bus:ttyD185
PM: Adding info for No Bus:ttyD186
PM: Adding info for No Bus:ttyD187
PM: Adding info for No Bus:ttyD188
PM: Adding info for No Bus:ttyD189
PM: Adding info for No Bus:ttyD190
PM: Adding info for No Bus:ttyD191
PM: Adding info for No Bus:ttyD192
PM: Adding info for No Bus:ttyD193
PM: Adding info for No Bus:ttyD194
PM: Adding info for No Bus:ttyD195
PM: Adding info for No Bus:ttyD196
PM: Adding info for No Bus:ttyD197
PM: Adding info for No Bus:ttyD198
PM: Adding info for No Bus:ttyD199
PM: Adding info for No Bus:ttyD200
PM: Adding info for No Bus:ttyD201
PM: Adding info for No Bus:ttyD202
PM: Adding info for No Bus:ttyD203
PM: Adding info for No Bus:ttyD204
PM: Adding info for No Bus:ttyD205
PM: Adding info for No Bus:ttyD206
PM: Adding info for No Bus:ttyD207
PM: Adding info for No Bus:ttyD208
PM: Adding info for No Bus:ttyD209
PM: Adding info for No Bus:ttyD210
PM: Adding info for No Bus:ttyD211
PM: Adding info for No Bus:ttyD212
PM: Adding info for No Bus:ttyD213
PM: Adding info for No Bus:ttyD214
PM: Adding info for No Bus:ttyD215
PM: Adding info for No Bus:ttyD216
PM: Adding info for No Bus:ttyD217
PM: Adding info for No Bus:ttyD218
PM: Adding info for No Bus:ttyD219
PM: Adding info for No Bus:ttyD220
PM: Adding info for No Bus:ttyD221
PM: Adding info for No Bus:ttyD222
PM: Adding info for No Bus:ttyD223
PM: Adding info for No Bus:ttyD224
PM: Adding info for No Bus:ttyD225
PM: Adding info for No Bus:ttyD226
PM: Adding info for No Bus:ttyD227
PM: Adding info for No Bus:ttyD228
PM: Adding info for No Bus:ttyD229
PM: Adding info for No Bus:ttyD230
PM: Adding info for No Bus:ttyD231
PM: Adding info for No Bus:ttyD232
PM: Adding info for No Bus:ttyD233
PM: Adding info for No Bus:ttyD234
PM: Adding info for No Bus:ttyD235
PM: Adding info for No Bus:ttyD236
PM: Adding info for No Bus:ttyD237
PM: Adding info for No Bus:ttyD238
PM: Adding info for No Bus:ttyD239
PM: Adding info for No Bus:ttyD240
PM: Adding info for No Bus:ttyD241
PM: Adding info for No Bus:ttyD242
PM: Adding info for No Bus:ttyD243
PM: Adding info for No Bus:ttyD244
PM: Adding info for No Bus:ttyD245
PM: Adding info for No Bus:ttyD246
PM: Adding info for No Bus:ttyD247
PM: Adding info for No Bus:ttyD248
PM: Adding info for No Bus:ttyD249
PM: Adding info for No Bus:ttyD250
PM: Adding info for No Bus:ttyD251
PM: Adding info for No Bus:ttyD252
PM: Adding info for No Bus:ttyD253
PM: Adding info for No Bus:ttyD254
PM: Adding info for No Bus:ttyD255
PM: Adding info for No Bus:digi_ctl0
PM: Adding info for No Bus:digi_ctl1
PM: Adding info for No Bus:digi_ctl2
PM: Adding info for No Bus:digi_ctl3
PM: Adding info for No Bus:digi_ctl4
PM: Adding info for No Bus:digi_ctl5
PM: Adding info for No Bus:digi_ctl6
PM: Adding info for No Bus:digi_ctl7
PM: Adding info for No Bus:digi_ctl8
PM: Adding info for No Bus:digi_ctl9
PM: Adding info for No Bus:digi_ctl10
PM: Adding info for No Bus:digi_ctl11
PM: Adding info for No Bus:digi_ctl12
PM: Adding info for No Bus:digi_ctl13
PM: Adding info for No Bus:digi_ctl14
PM: Adding info for No Bus:digi_ctl15
PM: Adding info for No Bus:digi_ctl16
PM: Adding info for No Bus:digi_ctl17
PM: Adding info for No Bus:digi_ctl18
PM: Adding info for No Bus:digi_ctl19
PM: Adding info for No Bus:digi_ctl20
PM: Adding info for No Bus:digi_ctl21
PM: Adding info for No Bus:digi_ctl22
PM: Adding info for No Bus:digi_ctl23
PM: Adding info for No Bus:digi_ctl24
PM: Adding info for No Bus:digi_ctl25
PM: Adding info for No Bus:digi_ctl26
PM: Adding info for No Bus:digi_ctl27
PM: Adding info for No Bus:digi_ctl28
PM: Adding info for No Bus:digi_ctl29
PM: Adding info for No Bus:digi_ctl30
PM: Adding info for No Bus:digi_ctl31
PM: Adding info for No Bus:digi_ctl32
PM: Adding info for No Bus:digi_ctl33
PM: Adding info for No Bus:digi_ctl34
PM: Adding info for No Bus:digi_ctl35
PM: Adding info for No Bus:digi_ctl36
PM: Adding info for No Bus:digi_ctl37
PM: Adding info for No Bus:digi_ctl38
PM: Adding info for No Bus:digi_ctl39
PM: Adding info for No Bus:digi_ctl40
PM: Adding info for No Bus:digi_ctl41
PM: Adding info for No Bus:digi_ctl42
PM: Adding info for No Bus:digi_ctl43
PM: Adding info for No Bus:digi_ctl44
PM: Adding info for No Bus:digi_ctl45
PM: Adding info for No Bus:digi_ctl46
PM: Adding info for No Bus:digi_ctl47
PM: Adding info for No Bus:digi_ctl48
PM: Adding info for No Bus:digi_ctl49
PM: Adding info for No Bus:digi_ctl50
PM: Adding info for No Bus:digi_ctl51
PM: Adding info for No Bus:digi_ctl52
PM: Adding info for No Bus:digi_ctl53
PM: Adding info for No Bus:digi_ctl54
PM: Adding info for No Bus:digi_ctl55
PM: Adding info for No Bus:digi_ctl56
PM: Adding info for No Bus:digi_ctl57
PM: Adding info for No Bus:digi_ctl58
PM: Adding info for No Bus:digi_ctl59
PM: Adding info for No Bus:digi_ctl60
PM: Adding info for No Bus:digi_ctl61
PM: Adding info for No Bus:digi_ctl62
PM: Adding info for No Bus:digi_ctl63
PM: Adding info for No Bus:digi_ctl64
PM: Adding info for No Bus:digi_ctl65
PM: Adding info for No Bus:digi_ctl66
PM: Adding info for No Bus:digi_ctl67
PM: Adding info for No Bus:digi_ctl68
PM: Adding info for No Bus:digi_ctl69
PM: Adding info for No Bus:digi_ctl70
PM: Adding info for No Bus:digi_ctl71
PM: Adding info for No Bus:digi_ctl72
PM: Adding info for No Bus:digi_ctl73
PM: Adding info for No Bus:digi_ctl74
PM: Adding info for No Bus:digi_ctl75
PM: Adding info for No Bus:digi_ctl76
PM: Adding info for No Bus:digi_ctl77
PM: Adding info for No Bus:digi_ctl78
PM: Adding info for No Bus:digi_ctl79
PM: Adding info for No Bus:digi_ctl80
PM: Adding info for No Bus:digi_ctl81
PM: Adding info for No Bus:digi_ctl82
PM: Adding info for No Bus:digi_ctl83
PM: Adding info for No Bus:digi_ctl84
PM: Adding info for No Bus:digi_ctl85
PM: Adding info for No Bus:digi_ctl86
PM: Adding info for No Bus:digi_ctl87
PM: Adding info for No Bus:digi_ctl88
PM: Adding info for No Bus:digi_ctl89
PM: Adding info for No Bus:digi_ctl90
PM: Adding info for No Bus:digi_ctl91
PM: Adding info for No Bus:digi_ctl92
PM: Adding info for No Bus:digi_ctl93
PM: Adding info for No Bus:digi_ctl94
PM: Adding info for No Bus:digi_ctl95
PM: Adding info for No Bus:digi_ctl96
PM: Adding info for No Bus:digi_ctl97
PM: Adding info for No Bus:digi_ctl98
PM: Adding info for No Bus:digi_ctl99
PM: Adding info for No Bus:digi_ctl100
PM: Adding info for No Bus:digi_ctl101
PM: Adding info for No Bus:digi_ctl102
PM: Adding info for No Bus:digi_ctl103
PM: Adding info for No Bus:digi_ctl104
PM: Adding info for No Bus:digi_ctl105
PM: Adding info for No Bus:digi_ctl106
PM: Adding info for No Bus:digi_ctl107
PM: Adding info for No Bus:digi_ctl108
PM: Adding info for No Bus:digi_ctl109
PM: Adding info for No Bus:digi_ctl110
PM: Adding info for No Bus:digi_ctl111
PM: Adding info for No Bus:digi_ctl112
PM: Adding info for No Bus:digi_ctl113
PM: Adding info for No Bus:digi_ctl114
PM: Adding info for No Bus:digi_ctl115
PM: Adding info for No Bus:digi_ctl116
PM: Adding info for No Bus:digi_ctl117
PM: Adding info for No Bus:digi_ctl118
PM: Adding info for No Bus:digi_ctl119
PM: Adding info for No Bus:digi_ctl120
PM: Adding info for No Bus:digi_ctl121
PM: Adding info for No Bus:digi_ctl122
PM: Adding info for No Bus:digi_ctl123
PM: Adding info for No Bus:digi_ctl124
PM: Adding info for No Bus:digi_ctl125
PM: Adding info for No Bus:digi_ctl126
PM: Adding info for No Bus:digi_ctl127
PM: Adding info for No Bus:digi_ctl128
PM: Adding info for No Bus:digi_ctl129
PM: Adding info for No Bus:digi_ctl130
PM: Adding info for No Bus:digi_ctl131
PM: Adding info for No Bus:digi_ctl132
PM: Adding info for No Bus:digi_ctl133
PM: Adding info for No Bus:digi_ctl134
PM: Adding info for No Bus:digi_ctl135
PM: Adding info for No Bus:digi_ctl136
PM: Adding info for No Bus:digi_ctl137
PM: Adding info for No Bus:digi_ctl138
PM: Adding info for No Bus:digi_ctl139
PM: Adding info for No Bus:digi_ctl140
PM: Adding info for No Bus:digi_ctl141
PM: Adding info for No Bus:digi_ctl142
PM: Adding info for No Bus:digi_ctl143
PM: Adding info for No Bus:digi_ctl144
PM: Adding info for No Bus:digi_ctl145
PM: Adding info for No Bus:digi_ctl146
PM: Adding info for No Bus:digi_ctl147
PM: Adding info for No Bus:digi_ctl148
PM: Adding info for No Bus:digi_ctl149
PM: Adding info for No Bus:digi_ctl150
PM: Adding info for No Bus:digi_ctl151
PM: Adding info for No Bus:digi_ctl152
PM: Adding info for No Bus:digi_ctl153
PM: Adding info for No Bus:digi_ctl154
PM: Adding info for No Bus:digi_ctl155
PM: Adding info for No Bus:digi_ctl156
PM: Adding info for No Bus:digi_ctl157
PM: Adding info for No Bus:digi_ctl158
PM: Adding info for No Bus:digi_ctl159
PM: Adding info for No Bus:digi_ctl160
PM: Adding info for No Bus:digi_ctl161
PM: Adding info for No Bus:digi_ctl162
PM: Adding info for No Bus:digi_ctl163
PM: Adding info for No Bus:digi_ctl164
PM: Adding info for No Bus:digi_ctl165
PM: Adding info for No Bus:digi_ctl166
PM: Adding info for No Bus:digi_ctl167
PM: Adding info for No Bus:digi_ctl168
PM: Adding info for No Bus:digi_ctl169
PM: Adding info for No Bus:digi_ctl170
PM: Adding info for No Bus:digi_ctl171
PM: Adding info for No Bus:digi_ctl172
PM: Adding info for No Bus:digi_ctl173
PM: Adding info for No Bus:digi_ctl174
PM: Adding info for No Bus:digi_ctl175
PM: Adding info for No Bus:digi_ctl176
PM: Adding info for No Bus:digi_ctl177
PM: Adding info for No Bus:digi_ctl178
PM: Adding info for No Bus:digi_ctl179
PM: Adding info for No Bus:digi_ctl180
PM: Adding info for No Bus:digi_ctl181
PM: Adding info for No Bus:digi_ctl182
PM: Adding info for No Bus:digi_ctl183
PM: Adding info for No Bus:digi_ctl184
PM: Adding info for No Bus:digi_ctl185
PM: Adding info for No Bus:digi_ctl186
PM: Adding info for No Bus:digi_ctl187
PM: Adding info for No Bus:digi_ctl188
PM: Adding info for No Bus:digi_ctl189
PM: Adding info for No Bus:digi_ctl190
PM: Adding info for No Bus:digi_ctl191
PM: Adding info for No Bus:digi_ctl192
PM: Adding info for No Bus:digi_ctl193
PM: Adding info for No Bus:digi_ctl194
PM: Adding info for No Bus:digi_ctl195
PM: Adding info for No Bus:digi_ctl196
PM: Adding info for No Bus:digi_ctl197
PM: Adding info for No Bus:digi_ctl198
PM: Adding info for No Bus:digi_ctl199
PM: Adding info for No Bus:digi_ctl200
PM: Adding info for No Bus:digi_ctl201
PM: Adding info for No Bus:digi_ctl202
PM: Adding info for No Bus:digi_ctl203
PM: Adding info for No Bus:digi_ctl204
PM: Adding info for No Bus:digi_ctl205
PM: Adding info for No Bus:digi_ctl206
PM: Adding info for No Bus:digi_ctl207
PM: Adding info for No Bus:digi_ctl208
PM: Adding info for No Bus:digi_ctl209
PM: Adding info for No Bus:digi_ctl210
PM: Adding info for No Bus:digi_ctl211
PM: Adding info for No Bus:digi_ctl212
PM: Adding info for No Bus:digi_ctl213
PM: Adding info for No Bus:digi_ctl214
PM: Adding info for No Bus:digi_ctl215
PM: Adding info for No Bus:digi_ctl216
PM: Adding info for No Bus:digi_ctl217
PM: Adding info for No Bus:digi_ctl218
PM: Adding info for No Bus:digi_ctl219
PM: Adding info for No Bus:digi_ctl220
PM: Adding info for No Bus:digi_ctl221
PM: Adding info for No Bus:digi_ctl222
PM: Adding info for No Bus:digi_ctl223
PM: Adding info for No Bus:digi_ctl224
PM: Adding info for No Bus:digi_ctl225
PM: Adding info for No Bus:digi_ctl226
PM: Adding info for No Bus:digi_ctl227
PM: Adding info for No Bus:digi_ctl228
PM: Adding info for No Bus:digi_ctl229
PM: Adding info for No Bus:digi_ctl230
PM: Adding info for No Bus:digi_ctl231
PM: Adding info for No Bus:digi_ctl232
PM: Adding info for No Bus:digi_ctl233
PM: Adding info for No Bus:digi_ctl234
PM: Adding info for No Bus:digi_ctl235
PM: Adding info for No Bus:digi_ctl236
PM: Adding info for No Bus:digi_ctl237
PM: Adding info for No Bus:digi_ctl238
PM: Adding info for No Bus:digi_ctl239
PM: Adding info for No Bus:digi_ctl240
PM: Adding info for No Bus:digi_ctl241
PM: Adding info for No Bus:digi_ctl242
PM: Adding info for No Bus:digi_ctl243
PM: Adding info for No Bus:digi_ctl244
PM: Adding info for No Bus:digi_ctl245
PM: Adding info for No Bus:digi_ctl246
PM: Adding info for No Bus:digi_ctl247
PM: Adding info for No Bus:digi_ctl248
PM: Adding info for No Bus:digi_ctl249
PM: Adding info for No Bus:digi_ctl250
PM: Adding info for No Bus:digi_ctl251
PM: Adding info for No Bus:digi_ctl252
PM: Adding info for No Bus:digi_ctl253
PM: Adding info for No Bus:digi_ctl254
PM: Adding info for No Bus:digi_ctl255
initcall epca_module_init+0x0/0x466 returned 0 after 3300781 usecs
calling  moxa_init+0x0/0x126 @ 1
MOXA Intellio family driver version 6.0k
PM: Adding info for No Bus:ttyMX0
PM: Adding info for No Bus:ttyMX1
PM: Adding info for No Bus:ttyMX2
PM: Adding info for No Bus:ttyMX3
PM: Adding info for No Bus:ttyMX4
PM: Adding info for No Bus:ttyMX5
PM: Adding info for No Bus:ttyMX6
PM: Adding info for No Bus:ttyMX7
PM: Adding info for No Bus:ttyMX8
PM: Adding info for No Bus:ttyMX9
PM: Adding info for No Bus:ttyMX10
PM: Adding info for No Bus:ttyMX11
PM: Adding info for No Bus:ttyMX12
PM: Adding info for No Bus:ttyMX13
PM: Adding info for No Bus:ttyMX14
PM: Adding info for No Bus:ttyMX15
PM: Adding info for No Bus:ttyMX16
PM: Adding info for No Bus:ttyMX17
PM: Adding info for No Bus:ttyMX18
PM: Adding info for No Bus:ttyMX19
PM: Adding info for No Bus:ttyMX20
PM: Adding info for No Bus:ttyMX21
PM: Adding info for No Bus:ttyMX22
PM: Adding info for No Bus:ttyMX23
PM: Adding info for No Bus:ttyMX24
PM: Adding info for No Bus:ttyMX25
PM: Adding info for No Bus:ttyMX26
PM: Adding info for No Bus:ttyMX27
PM: Adding info for No Bus:ttyMX28
PM: Adding info for No Bus:ttyMX29
PM: Adding info for No Bus:ttyMX30
PM: Adding info for No Bus:ttyMX31
PM: Adding info for No Bus:ttyMX32
PM: Adding info for No Bus:ttyMX33
PM: Adding info for No Bus:ttyMX34
PM: Adding info for No Bus:ttyMX35
PM: Adding info for No Bus:ttyMX36
PM: Adding info for No Bus:ttyMX37
PM: Adding info for No Bus:ttyMX38
PM: Adding info for No Bus:ttyMX39
PM: Adding info for No Bus:ttyMX40
PM: Adding info for No Bus:ttyMX41
PM: Adding info for No Bus:ttyMX42
PM: Adding info for No Bus:ttyMX43
PM: Adding info for No Bus:ttyMX44
PM: Adding info for No Bus:ttyMX45
PM: Adding info for No Bus:ttyMX46
PM: Adding info for No Bus:ttyMX47
PM: Adding info for No Bus:ttyMX48
PM: Adding info for No Bus:ttyMX49
PM: Adding info for No Bus:ttyMX50
PM: Adding info for No Bus:ttyMX51
PM: Adding info for No Bus:ttyMX52
PM: Adding info for No Bus:ttyMX53
PM: Adding info for No Bus:ttyMX54
PM: Adding info for No Bus:ttyMX55
PM: Adding info for No Bus:ttyMX56
PM: Adding info for No Bus:ttyMX57
PM: Adding info for No Bus:ttyMX58
PM: Adding info for No Bus:ttyMX59
PM: Adding info for No Bus:ttyMX60
PM: Adding info for No Bus:ttyMX61
PM: Adding info for No Bus:ttyMX62
PM: Adding info for No Bus:ttyMX63
PM: Adding info for No Bus:ttyMX64
PM: Adding info for No Bus:ttyMX65
PM: Adding info for No Bus:ttyMX66
PM: Adding info for No Bus:ttyMX67
PM: Adding info for No Bus:ttyMX68
PM: Adding info for No Bus:ttyMX69
PM: Adding info for No Bus:ttyMX70
PM: Adding info for No Bus:ttyMX71
PM: Adding info for No Bus:ttyMX72
PM: Adding info for No Bus:ttyMX73
PM: Adding info for No Bus:ttyMX74
PM: Adding info for No Bus:ttyMX75
PM: Adding info for No Bus:ttyMX76
PM: Adding info for No Bus:ttyMX77
PM: Adding info for No Bus:ttyMX78
PM: Adding info for No Bus:ttyMX79
PM: Adding info for No Bus:ttyMX80
PM: Adding info for No Bus:ttyMX81
PM: Adding info for No Bus:ttyMX82
PM: Adding info for No Bus:ttyMX83
PM: Adding info for No Bus:ttyMX84
PM: Adding info for No Bus:ttyMX85
PM: Adding info for No Bus:ttyMX86
PM: Adding info for No Bus:ttyMX87
PM: Adding info for No Bus:ttyMX88
PM: Adding info for No Bus:ttyMX89
PM: Adding info for No Bus:ttyMX90
PM: Adding info for No Bus:ttyMX91
PM: Adding info for No Bus:ttyMX92
PM: Adding info for No Bus:ttyMX93
PM: Adding info for No Bus:ttyMX94
PM: Adding info for No Bus:ttyMX95
PM: Adding info for No Bus:ttyMX96
PM: Adding info for No Bus:ttyMX97
PM: Adding info for No Bus:ttyMX98
PM: Adding info for No Bus:ttyMX99
PM: Adding info for No Bus:ttyMX100
PM: Adding info for No Bus:ttyMX101
PM: Adding info for No Bus:ttyMX102
PM: Adding info for No Bus:ttyMX103
PM: Adding info for No Bus:ttyMX104
PM: Adding info for No Bus:ttyMX105
PM: Adding info for No Bus:ttyMX106
PM: Adding info for No Bus:ttyMX107
PM: Adding info for No Bus:ttyMX108
PM: Adding info for No Bus:ttyMX109
PM: Adding info for No Bus:ttyMX110
PM: Adding info for No Bus:ttyMX111
PM: Adding info for No Bus:ttyMX112
PM: Adding info for No Bus:ttyMX113
PM: Adding info for No Bus:ttyMX114
PM: Adding info for No Bus:ttyMX115
PM: Adding info for No Bus:ttyMX116
PM: Adding info for No Bus:ttyMX117
PM: Adding info for No Bus:ttyMX118
PM: Adding info for No Bus:ttyMX119
PM: Adding info for No Bus:ttyMX120
PM: Adding info for No Bus:ttyMX121
PM: Adding info for No Bus:ttyMX122
PM: Adding info for No Bus:ttyMX123
PM: Adding info for No Bus:ttyMX124
PM: Adding info for No Bus:ttyMX125
PM: Adding info for No Bus:ttyMX126
PM: Adding info for No Bus:ttyMX127
PM: Adding info for No Bus:ttyMX128
initcall moxa_init+0x0/0x126 returned 0 after 419921 usecs
calling  mxser_module_init+0x0/0x603 @ 1
MOXA Smartio/Industio family driver version 2.0.4
initcall mxser_module_init+0x0/0x603 returned 0 after 9765 usecs
calling  ip2_loadmain+0x0/0xa81 @ 1
Computone IntelliPort Plus multiport driver version 1.2.14
initcall ip2_loadmain+0x0/0xa81 returned 0 after 0 usecs
calling  slgt_init+0x0/0x1b8 @ 1
SyncLink GT
SyncLink GT, tty major#252
SyncLink GT no devices found
initcall slgt_init+0x0/0x1b8 returned 0 after 0 usecs
calling  rio_init+0x0/0xfad @ 1
PM: Adding info for No Bus:rioctl
PM: Removing info for No Bus:rioctl
initcall rio_init+0x0/0xfad returned -5 after 9765 usecs
initcall rio_init+0x0/0xfad returned with error code -5 
calling  lp_init_module+0x0/0x261 @ 1
lp: driver loaded but no devices found
initcall lp_init_module+0x0/0x261 returned 0 after 9765 usecs
calling  r3964_init+0x0/0x44 @ 1
r3964: Philips r3964 Driver $Revision: 1.10 $
initcall r3964_init+0x0/0x44 returned 0 after 0 usecs
calling  applicom_init+0x0/0x4fa @ 1
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
initcall applicom_init+0x0/0x4fa returned -6 after 9765 usecs
initcall applicom_init+0x0/0x4fa returned with error code -6 
calling  rtc_init+0x0/0xa6 @ 1
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12b
initcall rtc_init+0x0/0xa6 returned 0 after 0 usecs
calling  hpet_init+0x0/0x6a @ 1
PM: Adding info for No Bus:hpet
initcall hpet_init+0x0/0x6a returned 0 after 0 usecs
calling  nvram_init+0x0/0x82 @ 1
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x82 returned 0 after 9765 usecs
calling  i8k_init+0x0/0x15c @ 1
initcall i8k_init+0x0/0x15c returned -19 after 0 usecs
calling  mod_init+0x0/0xba @ 1
initcall mod_init+0x0/0xba returned -19 after 0 usecs
calling  ppdev_init+0x0/0xb8 @ 1
ppdev: user-space parallel port driver
initcall ppdev_init+0x0/0xb8 returned 0 after 0 usecs
calling  agp_init+0x0/0x26 @ 1
Linux agpgart interface v0.103
initcall agp_init+0x0/0x26 returned 0 after 0 usecs
calling  agp_amd64_init+0x0/0xd3 @ 1
initcall agp_amd64_init+0x0/0xd3 returned -19 after 0 usecs
calling  agp_sis_init+0x0/0x29 @ 1
initcall agp_sis_init+0x0/0x29 returned 0 after 0 usecs
calling  agp_via_init+0x0/0x29 @ 1
initcall agp_via_init+0x0/0x29 returned 0 after 0 usecs
calling  init_ipwireless+0x0/0x3f @ 1
ipwireless 1.1 by Stephen Blackheath, Ben Martel, Jiri Kosina and David Sterba
initcall init_ipwireless+0x0/0x3f returned 0 after 0 usecs
calling  ipmi_init_msghandler_mod+0x0/0xd @ 1
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 9765 usecs
calling  init_ipmi_devintf+0x0/0xfa @ 1
ipmi device interface
initcall init_ipmi_devintf+0x0/0xfa returned 0 after 0 usecs
calling  init_ipmi_si+0x0/0x764 @ 1
IPMI System Interface driver.
ipmi_si: Unable to find any System Interface(s)
initcall init_ipmi_si+0x0/0x764 returned -19 after 87890 usecs
calling  ipmi_poweroff_init+0x0/0x8d @ 1
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
initcall ipmi_poweroff_init+0x0/0x8d returned 0 after 9765 usecs
calling  init_tis+0x0/0x91 @ 1
initcall init_tis+0x0/0x91 returned 0 after 0 usecs
calling  init_inf+0x0/0x12 @ 1
initcall init_inf+0x0/0x12 returned 0 after 0 usecs
calling  drm_core_init+0x0/0x122 @ 1
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0x122 returned 0 after 0 usecs
calling  tdfx_init+0x0/0x12 @ 1
initcall tdfx_init+0x0/0x12 returned 0 after 0 usecs
calling  r128_init+0x0/0x1e @ 1
initcall r128_init+0x0/0x1e returned 0 after 0 usecs
calling  radeon_init+0x0/0x1e @ 1
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:01:00.0: setting latency timer to 64
PM: Adding info for No Bus:card0
[drm] Initialized radeon 1.30.0 20080528 for 0000:01:00.0 on minor 0
initcall radeon_init+0x0/0x1e returned 0 after 19531 usecs
calling  sis_init+0x0/0x1e @ 1
initcall sis_init+0x0/0x1e returned 0 after 0 usecs
calling  savage_init+0x0/0x1e @ 1
initcall savage_init+0x0/0x1e returned 0 after 0 usecs
calling  via_init+0x0/0x23 @ 1
initcall via_init+0x0/0x23 returned 0 after 0 usecs
calling  cn_proc_init+0x0/0x3d @ 1
initcall cn_proc_init+0x0/0x3d returned 0 after 0 usecs
calling  serial8250_init+0x0/0x147 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
initcall serial8250_init+0x0/0x147 returned 0 after 19531 usecs
calling  serial8250_pci_init+0x0/0x1b @ 1
initcall serial8250_pci_init+0x0/0x1b returned 0 after 0 usecs
calling  init_serial_cs+0x0/0x12 @ 1
initcall init_serial_cs+0x0/0x12 returned 0 after 0 usecs
calling  jsm_init_module+0x0/0x48 @ 1
initcall jsm_init_module+0x0/0x48 returned 0 after 0 usecs
calling  parport_default_proc_register+0x0/0x1b @ 1
initcall parport_default_proc_register+0x0/0x1b returned 0 after 0 usecs
calling  parport_pc_init+0x0/0x357 @ 1
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
PM: Adding info for No Bus:parport0
PM: Adding info for No Bus:lp0
lp0: using parport0 (interrupt-driven).
lp0: console ready
PM: Adding info for platform:parport_pc.956
PM: Removing info for platform:parport_pc.956
PM: Adding info for platform:parport_pc.888
PM: Removing info for platform:parport_pc.888
PM: Adding info for platform:parport_pc.632
PM: Removing info for platform:parport_pc.632
initcall parport_pc_init+0x0/0x357 returned 0 after 48828 usecs
calling  init_parport_cs+0x0/0x12 @ 1
initcall init_parport_cs+0x0/0x12 returned 0 after 0 usecs
calling  topology_sysfs_init+0x0/0x50 @ 1
initcall topology_sysfs_init+0x0/0x50 returned 0 after 0 usecs
calling  brd_init+0x0/0x16b @ 1
PM: Adding info for No Bus:ram0
PM: Adding info for No Bus:1:0
PM: Adding info for No Bus:ram1
PM: Adding info for No Bus:1:1
PM: Adding info for No Bus:ram2
PM: Adding info for No Bus:1:2
PM: Adding info for No Bus:ram3
PM: Adding info for No Bus:1:3
PM: Adding info for No Bus:ram4
PM: Adding info for No Bus:1:4
PM: Adding info for No Bus:ram5
PM: Adding info for No Bus:1:5
PM: Adding info for No Bus:ram6
PM: Adding info for No Bus:1:6
PM: Adding info for No Bus:ram7
PM: Adding info for No Bus:1:7
PM: Adding info for No Bus:ram8
PM: Adding info for No Bus:1:8
PM: Adding info for No Bus:ram9
PM: Adding info for No Bus:1:9
PM: Adding info for No Bus:ram10
PM: Adding info for No Bus:1:10
PM: Adding info for No Bus:ram11
PM: Adding info for No Bus:1:11
PM: Adding info for No Bus:ram12
PM: Adding info for No Bus:1:12
PM: Adding info for No Bus:ram13
PM: Adding info for No Bus:1:13
PM: Adding info for No Bus:ram14
PM: Adding info for No Bus:1:14
PM: Adding info for No Bus:ram15
PM: Adding info for No Bus:1:15
brd: module loaded
initcall brd_init+0x0/0x16b returned 0 after 97656 usecs
calling  loop_init+0x0/0x193 @ 1
PM: Adding info for No Bus:loop0
PM: Adding info for No Bus:7:0
PM: Adding info for No Bus:loop1
PM: Adding info for No Bus:7:1
PM: Adding info for No Bus:loop2
PM: Adding info for No Bus:7:2
PM: Adding info for No Bus:loop3
PM: Adding info for No Bus:7:3
PM: Adding info for No Bus:loop4
PM: Adding info for No Bus:7:4
PM: Adding info for No Bus:loop5
PM: Adding info for No Bus:7:5
PM: Adding info for No Bus:loop6
PM: Adding info for No Bus:7:6
PM: Adding info for No Bus:loop7
PM: Adding info for No Bus:7:7
loop: module loaded
initcall loop_init+0x0/0x193 returned 0 after 48828 usecs
calling  cpqarray_init+0x0/0x284 @ 1
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x284 returned -19 after 0 usecs
calling  cciss_init+0x0/0x29 @ 1
HP CISS Driver (v 3.6.20)
initcall cciss_init+0x0/0x29 returned 0 after 0 usecs
calling  DAC960_init_module+0x0/0x4d @ 1
PM: Adding info for No Bus:dac960_gam
initcall DAC960_init_module+0x0/0x4d returned 0 after 9765 usecs
calling  mm_init+0x0/0x19e @ 1
MM: desc_per_page = 128
initcall mm_init+0x0/0x19e returned 0 after 9765 usecs
calling  nbd_init+0x0/0x2e4 @ 1
nbd: registered device at major 43
PM: Adding info for No Bus:nbd0
PM: Adding info for No Bus:43:0
PM: Adding info for No Bus:nbd1
PM: Adding info for No Bus:43:1
PM: Adding info for No Bus:nbd2
PM: Adding info for No Bus:43:2
PM: Adding info for No Bus:nbd3
PM: Adding info for No Bus:43:3
PM: Adding info for No Bus:nbd4
PM: Adding info for No Bus:43:4
PM: Adding info for No Bus:nbd5
PM: Adding info for No Bus:43:5
PM: Adding info for No Bus:nbd6
PM: Adding info for No Bus:43:6
PM: Adding info for No Bus:nbd7
PM: Adding info for No Bus:43:7
PM: Adding info for No Bus:nbd8
PM: Adding info for No Bus:43:8
PM: Adding info for No Bus:nbd9
PM: Adding info for No Bus:43:9
PM: Adding info for No Bus:nbd10
PM: Adding info for No Bus:43:10
PM: Adding info for No Bus:nbd11
PM: Adding info for No Bus:43:11
PM: Adding info for No Bus:nbd12
PM: Adding info for No Bus:43:12
PM: Adding info for No Bus:nbd13
PM: Adding info for No Bus:43:13
PM: Adding info for No Bus:nbd14
PM: Adding info for No Bus:43:14
PM: Adding info for No Bus:nbd15
PM: Adding info for No Bus:43:15
initcall nbd_init+0x0/0x2e4 returned 0 after 97656 usecs
calling  carm_init+0x0/0x1b @ 1
initcall carm_init+0x0/0x1b returned 0 after 0 usecs
calling  init_kgdbts+0x0/0x16 @ 1
initcall init_kgdbts+0x0/0x16 returned 0 after 0 usecs
calling  sm501_base_init+0x0/0x27 @ 1
initcall sm501_base_init+0x0/0x27 returned 0 after 0 usecs
calling  wm8400_module_init+0x0/0x33 @ 1
i2c-core: driver [WM8400] registered
initcall wm8400_module_init+0x0/0x33 returned 0 after 9765 usecs
calling  da903x_init+0x0/0x14 @ 1
i2c-core: driver [da903x] registered
initcall da903x_init+0x0/0x14 returned 0 after 9765 usecs
calling  pcf50633_init+0x0/0x14 @ 1
i2c-core: driver [pcf50633] registered
initcall pcf50633_init+0x0/0x14 returned 0 after 0 usecs
calling  pcf50633_adc_init+0x0/0x12 @ 1
initcall pcf50633_adc_init+0x0/0x12 returned 0 after 0 usecs
calling  scsi_tgt_init+0x0/0x86 @ 1
PM: Adding info for No Bus:tgt
initcall scsi_tgt_init+0x0/0x86 returned 0 after 0 usecs
calling  spi_transport_init+0x0/0x2e @ 1
initcall spi_transport_init+0x0/0x2e returned 0 after 0 usecs
calling  fc_transport_init+0x0/0x4c @ 1
initcall fc_transport_init+0x0/0x4c returned 0 after 0 usecs
calling  iscsi_transport_init+0x0/0x14f @ 1
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x14f returned 0 after 0 usecs
calling  sas_transport_init+0x0/0xbb @ 1
initcall sas_transport_init+0x0/0xbb returned 0 after 0 usecs
calling  libfc_init+0x0/0x77 @ 1
initcall libfc_init+0x0/0x77 returned 0 after 0 usecs
calling  fcoe_init+0x0/0x1a3 @ 1
initcall fcoe_init+0x0/0x1a3 returned 0 after 0 usecs
calling  BusLogic_init+0x0/0xed9 @ 1
initcall BusLogic_init+0x0/0xed9 returned 0 after 0 usecs
calling  adpt_init+0x0/0xc42 @ 1
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
initcall adpt_init+0x0/0xc42 returned -19 after 9765 usecs
calling  ahc_linux_init+0x0/0x66 @ 1
initcall ahc_linux_init+0x0/0x66 returned 0 after 0 usecs
calling  ahd_linux_init+0x0/0x81 @ 1
initcall ahd_linux_init+0x0/0x81 returned 0 after 0 usecs
calling  aac_init+0x0/0x70 @ 1
Adaptec aacraid driver 1.1-5[2461]-ms
initcall aac_init+0x0/0x70 returned 0 after 0 usecs
calling  qla1280_init+0x0/0x1b @ 1
initcall qla1280_init+0x0/0x1b returned 0 after 0 usecs
calling  qla2x00_module_init+0x0/0x12c @ 1
QLogic Fibre Channel HBA Driver: 8.03.01-k1
initcall qla2x00_module_init+0x0/0x12c returned 0 after 0 usecs
calling  qla4xxx_module_init+0x0/0xe2 @ 1
PM: Adding info for No Bus:qla4xxx
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
initcall qla4xxx_module_init+0x0/0xe2 returned 0 after 9765 usecs
calling  lpfc_init+0x0/0xcd @ 1
Emulex LightPulse Fibre Channel SCSI driver 8.3.1
Copyright(c) 2004-2009 Emulex.  All rights reserved.
initcall lpfc_init+0x0/0xcd returned 0 after 9765 usecs
calling  dc395x_module_init+0x0/0x1b @ 1
initcall dc395x_module_init+0x0/0x1b returned 0 after 0 usecs
calling  dc390_module_init+0x0/0x9a @ 1
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=1" and report to maintainers
initcall dc390_module_init+0x0/0x9a returned 0 after 9765 usecs
calling  megasas_init+0x0/0x15f @ 1
megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
initcall megasas_init+0x0/0x15f returned 0 after 0 usecs
calling  scsih_init+0x0/0xf3 @ 1
mpt2sas version 01.100.02.00 loaded
PM: Adding info for No Bus:mpt2ctl
initcall scsih_init+0x0/0xf3 returned 0 after 9765 usecs
calling  atp870u_init+0x0/0x1b @ 1
initcall atp870u_init+0x0/0x1b returned 0 after 0 usecs
calling  inia100_init+0x0/0x1b @ 1
initcall inia100_init+0x0/0x1b returned 0 after 0 usecs
calling  tw_init+0x0/0x30 @ 1
3ware Storage Controller device driver for Linux v1.26.02.002.
initcall tw_init+0x0/0x30 returned 0 after 9765 usecs
calling  twa_init+0x0/0x30 @ 1
3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
initcall twa_init+0x0/0x30 returned 0 after 9765 usecs
calling  ppa_driver_init+0x0/0x27 @ 1
ppa: Version 2.07 (for Linux 2.4.x)
initcall ppa_driver_init+0x0/0x27 returned 0 after 9765 usecs
calling  imm_driver_init+0x0/0x27 @ 1
imm: Version 2.05 (for Linux 2.4.0)
initcall imm_driver_init+0x0/0x27 returned 0 after 9765 usecs
calling  ipr_init+0x0/0x37 @ 1
ipr: IBM Power RAID SCSI Device Driver version: 2.4.2 (January 21, 2009)
initcall ipr_init+0x0/0x37 returned 0 after 0 usecs
calling  hptiop_module_init+0x0/0x37 @ 1
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
initcall hptiop_module_init+0x0/0x37 returned 0 after 9765 usecs
calling  stex_init+0x0/0x30 @ 1
stex: Promise SuperTrak EX Driver version: 4.6.0000.3
initcall stex_init+0x0/0x30 returned 0 after 9765 usecs
calling  init_st+0x0/0x188 @ 1
st: Version 20081215, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
initcall init_st+0x0/0x188 returned 0 after 9765 usecs
calling  init_osst+0x0/0x135 @ 1
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
Driver 'osst' needs updating - please use bus_type methods
initcall init_osst+0x0/0x135 returned 0 after 9765 usecs
calling  init_sd+0x0/0xf9 @ 1
Driver 'sd' needs updating - please use bus_type methods
initcall init_sd+0x0/0xf9 returned 0 after 9765 usecs
calling  init_ch_module+0x0/0xa9 @ 1
SCSI Media Changer driver v0.25 
Driver 'ch' needs updating - please use bus_type methods
initcall init_ch_module+0x0/0xa9 returned 0 after 9765 usecs
calling  osd_uld_init+0x0/0xd7 @ 1
Driver 'osd' needs updating - please use bus_type methods
osd: LOADED open-osd 0.1.0
initcall osd_uld_init+0x0/0xd7 returned 0 after 9765 usecs
calling  ahci_init+0x0/0x1b @ 1
initcall ahci_init+0x0/0x1b returned 0 after 0 usecs
calling  k2_sata_init+0x0/0x1b @ 1
initcall k2_sata_init+0x0/0x1b returned 0 after 0 usecs
calling  piix_init+0x0/0x29 @ 1
ata_piix 0000:00:1f.1: version 2.13
  alloc irq_desc for 18 on node 0
  alloc kstat_irqs on node 0
IOAPIC[0]: Set routing entry (2-18 -> 0x59 -> IRQ 18 Mode:1 Active:1)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
PM: Adding info for No Bus:host0
PM: Adding info for No Bus:host0
scsi1 : ata_piix
PM: Adding info for No Bus:host1
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
async_waiting @ 1872
async_continuing @ 1872 after 0 usec
async_waiting @ 1872
async_continuing @ 1872 after 0 usec
ata2: port disabled. ignoring.
async_waiting @ 1872
async_continuing @ 1872 after 0 usec
work_for_cpu used greatest stack depth: 4560 bytes left
  alloc irq_desc for 19 on node 0
  alloc kstat_irqs on node 0
IOAPIC[0]: Set routing entry (2-19 -> 0x61 -> IRQ 19 Mode:1 Active:1)
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
PM: Adding info for No Bus:host2
PM: Adding info for No Bus:host2
scsi3 : ata_piix
PM: Adding info for No Bus:host3
PM: Adding info for No Bus:host3
ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
ata3.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
async_waiting @ 1879
async_continuing @ 1879 after 0 usec
scsi 2:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
PM: Adding info for No Bus:target2:0:0
PM: Adding info for scsi:2:0:0:0
PM: Adding info for No Bus:2:0:0:0
sd 2:0:0:0: [sda] 321672960 512-byte hardware sectors: (164 GB/153 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:sda
 sda: sda1 sda2
PM: Adding info for No Bus:sda1
PM: Adding info for No Bus:sda2
PM: Adding info for No Bus:8:0
sd 2:0:0:0: [sda] Attached SCSI disk
PM: Adding info for No Bus:2:0:0:0
async_waiting @ 1879
async_continuing @ 1879 after 0 usec
ata4.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata4.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.01: ATAPI: PLEXTOR DVDR   PX-755A, 1.03, max UDMA/66
ata4.00: configured for UDMA/133
ata4.01: configured for UDMA/66
async_waiting @ 1879
async_continuing @ 1879 after 0 usec
scsi 3:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
PM: Adding info for No Bus:target3:0:0
PM: Adding info for scsi:3:0:0:0
PM: Adding info for No Bus:3:0:0:0
sd 3:0:0:0: [sdb] 321672960 512-byte hardware sectors: (164 GB/153 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:sdb
 sdb: sdb1
PM: Adding info for No Bus:sdb1
PM: Adding info for No Bus:8:16
sd 3:0:0:0: [sdb] Attached SCSI disk
PM: Adding info for No Bus:3:0:0:0
scsi 3:0:1:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.03 PQ: 0 ANSI: 5
PM: Adding info for No Bus:target3:0:1
PM: Adding info for scsi:3:0:1:0
PM: Adding info for No Bus:3:0:1:0
work_for_cpu used greatest stack depth: 3544 bytes left
initcall piix_init+0x0/0x29 returned 0 after 947265 usecs
calling  qs_ata_init+0x0/0x1b @ 1
initcall qs_ata_init+0x0/0x1b returned 0 after 0 usecs
calling  sil24_init+0x0/0x1b @ 1
initcall sil24_init+0x0/0x1b returned 0 after 0 usecs
calling  nv_init+0x0/0x1b @ 1
initcall nv_init+0x0/0x1b returned 0 after 0 usecs
calling  uli_init+0x0/0x1b @ 1
initcall uli_init+0x0/0x1b returned 0 after 0 usecs
calling  mv_init+0x0/0x48 @ 1
initcall mv_init+0x0/0x48 returned 0 after 0 usecs
calling  adma_ata_init+0x0/0x1b @ 1
initcall adma_ata_init+0x0/0x1b returned 0 after 0 usecs
calling  amd_init+0x0/0x1b @ 1
initcall amd_init+0x0/0x1b returned 0 after 0 usecs
calling  artop_init+0x0/0x1b @ 1
initcall artop_init+0x0/0x1b returned 0 after 0 usecs
calling  atiixp_init+0x0/0x1b @ 1
initcall atiixp_init+0x0/0x1b returned 0 after 0 usecs
calling  cs5520_init+0x0/0x1b @ 1
initcall cs5520_init+0x0/0x1b returned 0 after 0 usecs
calling  cy82c693_init+0x0/0x1b @ 1
initcall cy82c693_init+0x0/0x1b returned 0 after 0 usecs
calling  efar_init+0x0/0x1b @ 1
initcall efar_init+0x0/0x1b returned 0 after 0 usecs
calling  hpt36x_init+0x0/0x1b @ 1
initcall hpt36x_init+0x0/0x1b returned 0 after 0 usecs
calling  hpt3x2n_init+0x0/0x1b @ 1
initcall hpt3x2n_init+0x0/0x1b returned 0 after 0 usecs
calling  hpt3x3_init+0x0/0x1b @ 1
initcall hpt3x3_init+0x0/0x1b returned 0 after 0 usecs
calling  it8213_init+0x0/0x1b @ 1
initcall it8213_init+0x0/0x1b returned 0 after 0 usecs
calling  jmicron_init+0x0/0x1b @ 1
initcall jmicron_init+0x0/0x1b returned 0 after 0 usecs
calling  netcell_init+0x0/0x1b @ 1
initcall netcell_init+0x0/0x1b returned 0 after 0 usecs
calling  ninja32_init+0x0/0x1b @ 1
initcall ninja32_init+0x0/0x1b returned 0 after 0 usecs
calling  ns87410_init+0x0/0x1b @ 1
initcall ns87410_init+0x0/0x1b returned 0 after 0 usecs
calling  ns87415_init+0x0/0x1b @ 1
initcall ns87415_init+0x0/0x1b returned 0 after 0 usecs
calling  opti_init+0x0/0x1b @ 1
initcall opti_init+0x0/0x1b returned 0 after 0 usecs
calling  oldpiix_init+0x0/0x1b @ 1
initcall oldpiix_init+0x0/0x1b returned 0 after 0 usecs
calling  pcmcia_init+0x0/0x12 @ 1
initcall pcmcia_init+0x0/0x12 returned 0 after 0 usecs
calling  pdc2027x_init+0x0/0x1b @ 1
initcall pdc2027x_init+0x0/0x1b returned 0 after 0 usecs
calling  pdc202xx_init+0x0/0x1b @ 1
initcall pdc202xx_init+0x0/0x1b returned 0 after 0 usecs
calling  radisys_init+0x0/0x1b @ 1
initcall radisys_init+0x0/0x1b returned 0 after 0 usecs
calling  rz1000_init+0x0/0x1b @ 1
initcall rz1000_init+0x0/0x1b returned 0 after 0 usecs
calling  sc1200_init+0x0/0x1b @ 1
initcall sc1200_init+0x0/0x1b returned 0 after 0 usecs
calling  serverworks_init+0x0/0x1b @ 1
initcall serverworks_init+0x0/0x1b returned 0 after 0 usecs
calling  sil680_init+0x0/0x1b @ 1
initcall sil680_init+0x0/0x1b returned 0 after 0 usecs
calling  via_init+0x0/0x1b @ 1
initcall via_init+0x0/0x1b returned 0 after 0 usecs
calling  sl82c105_init+0x0/0x1b @ 1
initcall sl82c105_init+0x0/0x1b returned 0 after 0 usecs
calling  sis_init+0x0/0x1b @ 1
initcall sis_init+0x0/0x1b returned 0 after 0 usecs
calling  triflex_init+0x0/0x1b @ 1
initcall triflex_init+0x0/0x1b returned 0 after 0 usecs
calling  sch_init+0x0/0x1b @ 1
initcall sch_init+0x0/0x1b returned 0 after 0 usecs
calling  ata_generic_init+0x0/0x1b @ 1
initcall ata_generic_init+0x0/0x1b returned 0 after 0 usecs
calling  e1000_init_module+0x0/0x6b @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000e 0000:04:00.0: setting latency timer to 64
0000:04:00.0: 0000:04:00.0: Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
PM: Adding info for No Bus:eth0
0000:04:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:ab:6e:84
0000:04:00.0: eth0: Intel(R) PRO/1000 Network Connection
0000:04:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
initcall e1000_init_module+0x0/0x6b returned 0 after 205078 usecs
calling  igb_init_module+0x0/0x56 @ 1
Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
Copyright (c) 2007-2009 Intel Corporation.
initcall igb_init_module+0x0/0x56 returned 0 after 9765 usecs
calling  igbvf_init_module+0x0/0x6b @ 1
Intel(R) Virtual Function Network Driver - version 1.0.0-k0
Copyright (c) 2009 Intel Corporation.
initcall igbvf_init_module+0x0/0x6b returned 0 after 9765 usecs
calling  ixgb_init_module+0x0/0x4c @ 1
Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
Copyright (c) 1999-2008 Intel Corporation.
initcall ixgb_init_module+0x0/0x4c returned 0 after 9765 usecs
calling  ipg_init_module+0x0/0x1b @ 1
initcall ipg_init_module+0x0/0x1b returned 0 after 0 usecs
calling  t1_init_module+0x0/0x1b @ 1
initcall t1_init_module+0x0/0x1b returned 0 after 0 usecs
calling  atl2_init_module+0x0/0x4c @ 1
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
initcall atl2_init_module+0x0/0x4c returned 0 after 9765 usecs
calling  atl1e_init_module+0x0/0x1b @ 1
initcall atl1e_init_module+0x0/0x1b returned 0 after 0 usecs
calling  bdx_module_init+0x0/0x8d @ 1
tehuti: Tehuti Networks(R) Network Driver, 7.29.3
tehuti: Options: hw_csum 
initcall bdx_module_init+0x0/0x8d returned 0 after 9765 usecs
calling  enic_init_module+0x0/0x37 @ 1
enic: Cisco 10G Ethernet Driver, ver 1.0.0.933
initcall enic_init_module+0x0/0x37 returned 0 after 0 usecs
calling  jme_init_module+0x0/0x30 @ 1
jme: JMicron JMC2XX ethernet driver version 1.0.4
initcall jme_init_module+0x0/0x30 returned 0 after 9765 usecs
calling  rr_init_module+0x0/0x1b @ 1
initcall rr_init_module+0x0/0x1b returned 0 after 0 usecs
calling  happy_meal_probe+0x0/0x1b @ 1
initcall happy_meal_probe+0x0/0x1b returned 0 after 0 usecs
calling  cas_init+0x0/0x3a @ 1
initcall cas_init+0x0/0x3a returned 0 after 0 usecs
calling  vortex_init+0x0/0xad @ 1
initcall vortex_init+0x0/0xad returned 0 after 0 usecs
calling  ne2k_pci_init+0x0/0x1b @ 1
initcall ne2k_pci_init+0x0/0x1b returned 0 after 0 usecs
calling  pcnet32_init_module+0x0/0x12d @ 1
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
initcall pcnet32_init_module+0x0/0x12d returned 0 after 0 usecs
calling  e100_init_module+0x0/0x5d @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x5d returned 0 after 9765 usecs
calling  tlan_probe+0x0/0xe4 @ 1
ThunderLAN driver v1.15a
TLAN: 0 devices installed, PCI: 0  EISA: 0
initcall tlan_probe+0x0/0xe4 returned -19 after 9765 usecs
calling  smsc9420_init_module+0x0/0x3d @ 1
initcall smsc9420_init_module+0x0/0x3d returned 0 after 0 usecs
calling  sis190_init_module+0x0/0x1b @ 1
initcall sis190_init_module+0x0/0x1b returned 0 after 0 usecs
calling  sis900_init_module+0x0/0x1b @ 1
initcall sis900_init_module+0x0/0x1b returned 0 after 0 usecs
calling  r6040_init+0x0/0x1b @ 1
initcall r6040_init+0x0/0x1b returned 0 after 0 usecs
calling  yellowfin_init+0x0/0x1b @ 1
initcall yellowfin_init+0x0/0x1b returned 0 after 0 usecs
calling  acenic_init+0x0/0x1b @ 1
initcall acenic_init+0x0/0x1b returned 0 after 0 usecs
calling  fealnx_init+0x0/0x1b @ 1
initcall fealnx_init+0x0/0x1b returned 0 after 0 usecs
calling  tg3_init+0x0/0x1b @ 1
initcall tg3_init+0x0/0x1b returned 0 after 0 usecs
calling  bnx2_init+0x0/0x1b @ 1
initcall bnx2_init+0x0/0x1b returned 0 after 0 usecs
calling  bnx2x_init+0x0/0x59 @ 1
initcall bnx2x_init+0x0/0x59 returned 0 after 0 usecs
calling  skge_init_module+0x0/0x1b @ 1
initcall skge_init_module+0x0/0x1b returned 0 after 0 usecs
calling  sky2_init_module+0x0/0x29 @ 1
sky2 driver version 1.22
initcall sky2_init_module+0x0/0x29 returned 0 after 0 usecs
calling  rhine_init+0x0/0x39 @ 1
initcall rhine_init+0x0/0x39 returned 0 after 0 usecs
calling  velocity_init_module+0x0/0x3b @ 1
initcall velocity_init_module+0x0/0x3b returned 0 after 0 usecs
calling  starfire_init+0x0/0x1b @ 1
initcall starfire_init+0x0/0x1b returned 0 after 0 usecs
calling  marvell_init+0x0/0x5e @ 1
initcall marvell_init+0x0/0x5e returned 0 after 0 usecs
calling  davicom_init+0x0/0x5d @ 1
initcall davicom_init+0x0/0x5d returned 0 after 0 usecs
calling  cicada_init+0x0/0x3f @ 1
initcall cicada_init+0x0/0x3f returned 0 after 0 usecs
calling  lxt_init+0x0/0x3f @ 1
initcall lxt_init+0x0/0x3f returned 0 after 0 usecs
calling  qs6612_init+0x0/0x12 @ 1
initcall qs6612_init+0x0/0x12 returned 0 after 0 usecs
calling  smsc_init+0x0/0x99 @ 1
initcall smsc_init+0x0/0x99 returned 0 after 0 usecs
calling  ip175c_init+0x0/0x12 @ 1
initcall ip175c_init+0x0/0x12 returned 0 after 0 usecs
calling  et1011c_init+0x0/0x12 @ 1
initcall et1011c_init+0x0/0x12 returned 0 after 0 usecs
calling  ste10Xp_init+0x0/0x22 @ 1
initcall ste10Xp_init+0x0/0x22 returned 0 after 0 usecs
calling  sundance_init+0x0/0x1b @ 1
initcall sundance_init+0x0/0x1b returned 0 after 0 usecs
calling  hamachi_init+0x0/0x1b @ 1
initcall hamachi_init+0x0/0x1b returned 0 after 0 usecs
calling  net_olddevs_init+0x0/0xb0 @ 1
D-Link DE-620 pocket adapter io 0x378, which is busy.
initcall net_olddevs_init+0x0/0xb0 returned 0 after 0 usecs
calling  sb1000_init+0x0/0x12 @ 1
initcall sb1000_init+0x0/0x12 returned 0 after 0 usecs
calling  hp100_module_init+0x0/0x1b @ 1
initcall hp100_module_init+0x0/0x1b returned 0 after 0 usecs
calling  b44_init+0x0/0x63 @ 1
initcall b44_init+0x0/0x63 returned 0 after 0 usecs
calling  init_nic+0x0/0x1b @ 1
initcall init_nic+0x0/0x1b returned 0 after 0 usecs
calling  ql3xxx_init_module+0x0/0x1b @ 1
initcall ql3xxx_init_module+0x0/0x1b returned 0 after 0 usecs
calling  qlge_init_module+0x0/0x1b @ 1
initcall qlge_init_module+0x0/0x1b returned 0 after 0 usecs
calling  ppp_init+0x0/0xe0 @ 1
PPP generic driver version 2.4.2
PM: Adding info for No Bus:ppp
initcall ppp_init+0x0/0xe0 returned 0 after 9765 usecs
calling  ppp_async_init+0x0/0x36 @ 1
initcall ppp_async_init+0x0/0x36 returned 0 after 0 usecs
calling  ppp_sync_init+0x0/0x36 @ 1
initcall ppp_sync_init+0x0/0x36 returned 0 after 0 usecs
calling  deflate_init+0x0/0x3b @ 1
PPP Deflate Compression module registered
initcall deflate_init+0x0/0x3b returned 0 after 0 usecs
calling  bsdcomp_init+0x0/0x2f @ 1
PPP BSD Compression module registered
initcall bsdcomp_init+0x0/0x2f returned 0 after 0 usecs
calling  ppp_mppe_init+0x0/0x143 @ 1
PPP MPPE Compression module registered
initcall ppp_mppe_init+0x0/0x143 returned 0 after 9765 usecs
calling  pppox_init+0x0/0x12 @ 1
NET: Registered protocol family 24
initcall pppox_init+0x0/0x12 returned 0 after 0 usecs
calling  pppoe_init+0x0/0x89 @ 1
initcall pppoe_init+0x0/0x89 returned 0 after 0 usecs
calling  pppol2tp_init+0x0/0x80 @ 1
PPPoL2TP kernel driver, V1.0
initcall pppol2tp_init+0x0/0x80 returned 0 after 9765 usecs
calling  slip_init+0x0/0xc0 @ 1
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
initcall slip_init+0x0/0xc0 returned 0 after 19531 usecs
calling  netif_init+0x0/0x52 @ 1
initcall netif_init+0x0/0x52 returned -19 after 0 usecs
calling  dummy_init_module+0x0/0xb5 @ 1
PM: Adding info for No Bus:dummy0
initcall dummy_init_module+0x0/0xb5 returned 0 after 0 usecs
calling  ifb_init_module+0x0/0xba @ 1
PM: Adding info for No Bus:ifb0
PM: Adding info for No Bus:ifb1
initcall ifb_init_module+0x0/0xba returned 0 after 9765 usecs
calling  macvlan_init_module+0x0/0x53 @ 1
initcall macvlan_init_module+0x0/0x53 returned 0 after 0 usecs
calling  de600_init+0x0/0x342 @ 1
DE600: port 0x378 busy
initcall de600_init+0x0/0x342 returned -16 after 9765 usecs
initcall de600_init+0x0/0x342 returned with error code -16 
calling  cp_init+0x0/0x1b @ 1
initcall cp_init+0x0/0x1b returned 0 after 0 usecs
calling  rtl8139_init_module+0x0/0x1b @ 1
initcall rtl8139_init_module+0x0/0x1b returned 0 after 0 usecs
calling  eql_init_module+0x0/0x65 @ 1
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
PM: Adding info for No Bus:eql
initcall eql_init_module+0x0/0x65 returned 0 after 9765 usecs
calling  tun_init+0x0/0x93 @ 1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
PM: Adding info for No Bus:tun
initcall tun_init+0x0/0x93 returned 0 after 9765 usecs
calling  veth_init+0x0/0x12 @ 1
initcall veth_init+0x0/0x12 returned 0 after 0 usecs
calling  rtl8169_init_module+0x0/0x1b @ 1
initcall rtl8169_init_module+0x0/0x1b returned 0 after 0 usecs
calling  amd8111e_init+0x0/0x1b @ 1
initcall amd8111e_init+0x0/0x1b returned 0 after 0 usecs
calling  s2io_starter+0x0/0x1b @ 1
initcall s2io_starter+0x0/0x1b returned 0 after 0 usecs
calling  myri10ge_init_module+0x0/0x74 @ 1
myri10ge: Version 1.4.4-1.401
initcall myri10ge_init_module+0x0/0x74 returned 0 after 0 usecs
calling  ethoc_init+0x0/0x12 @ 1
initcall ethoc_init+0x0/0x12 returned 0 after 0 usecs
calling  dnet_init+0x0/0x12 @ 1
initcall dnet_init+0x0/0x12 returned 0 after 0 usecs
calling  olympic_pci_init+0x0/0x1b @ 1
initcall olympic_pci_init+0x0/0x1b returned 0 after 0 usecs
calling  abyss_init+0x0/0x49 @ 1
initcall abyss_init+0x0/0x49 returned 0 after 0 usecs
calling  tms_pci_init+0x0/0x1b @ 1
initcall tms_pci_init+0x0/0x1b returned 0 after 0 usecs
calling  xl_pci_init+0x0/0x1b @ 1
initcall xl_pci_init+0x0/0x1b returned 0 after 0 usecs
calling  hdlc_module_init+0x0/0x42 @ 1
HDLC support module revision 1.22
initcall hdlc_module_init+0x0/0x42 returned 0 after 0 usecs
calling  mod_init+0x0/0x14 @ 1
initcall mod_init+0x0/0x14 returned 0 after 0 usecs
calling  mod_init+0x0/0x14 @ 1
initcall mod_init+0x0/0x14 returned 0 after 0 usecs
calling  mod_init+0x0/0x14 @ 1
initcall mod_init+0x0/0x14 returned 0 after 0 usecs
calling  mod_init+0x0/0x14 @ 1
initcall mod_init+0x0/0x14 returned 0 after 0 usecs
calling  fst_init+0x0/0x4c @ 1
initcall fst_init+0x0/0x4c returned 0 after 0 usecs
calling  wanxl_init_module+0x0/0x1b @ 1
initcall wanxl_init_module+0x0/0x1b returned 0 after 9765 usecs
calling  pci200_init_module+0x0/0x42 @ 1
initcall pci200_init_module+0x0/0x42 returned 0 after 0 usecs
calling  pc300_init_module+0x0/0x65 @ 1
initcall pc300_init_module+0x0/0x65 returned 0 after 19531 usecs
calling  arcnet_init+0x0/0x5d @ 1
arcnet loaded.
initcall arcnet_init+0x0/0x5d returned 0 after 9765 usecs
calling  com90xx_init+0x0/0xfbf @ 1
arcnet: COM90xx chipset support
S3: No ARCnet cards found.
initcall com90xx_init+0x0/0xfbf returned -5 after 292968 usecs
initcall com90xx_init+0x0/0xfbf returned with error code -5 
calling  com90io_init+0x0/0x4a9 @ 1
arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
E-mail me if you actually test this driver, please!
 arc%d: No autoprobe for IO mapped cards; you must specify the base address!
initcall com90io_init+0x0/0x4a9 returned -19 after 19531 usecs
calling  arc_rimi_init+0x0/0x4b9 @ 1
arcnet: RIM I (entirely mem-mapped) support
E-mail me if you actually test the RIM I driver, please!
 arc%d: Given: node 00h, shmem 0h, irq 0
 arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
initcall arc_rimi_init+0x0/0x4b9 returned -5 after 19531 usecs
initcall arc_rimi_init+0x0/0x4b9 returned with error code -5 
calling  init_tc589+0x0/0x12 @ 1
initcall init_tc589+0x0/0x12 returned 0 after 9765 usecs
calling  init_tc574+0x0/0x12 @ 1
initcall init_tc574+0x0/0x12 returned 0 after 0 usecs
calling  init_fmvj18x_cs+0x0/0x12 @ 1
initcall init_fmvj18x_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_pcnet_cs+0x0/0x12 @ 1
initcall init_pcnet_cs+0x0/0x12 returned 0 after 19531 usecs
calling  init_xirc2ps_cs+0x0/0x12 @ 1
initcall init_xirc2ps_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_axnet_cs+0x0/0x12 @ 1
initcall init_axnet_cs+0x0/0x12 returned 0 after 19531 usecs
calling  init_ibmtr_cs+0x0/0x12 @ 1
initcall init_ibmtr_cs+0x0/0x12 returned 0 after 0 usecs
calling  catc_init+0x0/0x38 @ 1
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
initcall catc_init+0x0/0x38 returned 0 after 9765 usecs
calling  pegasus_init+0x0/0x168 @ 1
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
initcall pegasus_init+0x0/0x168 returned 0 after 48828 usecs
calling  cdc_init+0x0/0x1b @ 1
usbcore: registered new interface driver cdc_ether
initcall cdc_init+0x0/0x1b returned 0 after 29296 usecs
calling  eem_init+0x0/0x1b @ 1
usbcore: registered new interface driver cdc_eem
initcall eem_init+0x0/0x1b returned 0 after 0 usecs
calling  dm9601_init+0x0/0x1b @ 1
usbcore: registered new interface driver dm9601
initcall dm9601_init+0x0/0x1b returned 0 after 19531 usecs
calling  usbnet_init+0x0/0x1b @ 1
usbcore: registered new interface driver gl620a
initcall usbnet_init+0x0/0x1b returned 0 after 0 usecs
calling  net1080_init+0x0/0x1b @ 1
usbcore: registered new interface driver net1080
initcall net1080_init+0x0/0x1b returned 0 after 19531 usecs
calling  plusb_init+0x0/0x1b @ 1
usbcore: registered new interface driver plusb
initcall plusb_init+0x0/0x1b returned 0 after 0 usecs
calling  rndis_init+0x0/0x1b @ 1
usbcore: registered new interface driver rndis_host
initcall rndis_init+0x0/0x1b returned 0 after 19531 usecs
calling  mcs7830_init+0x0/0x1b @ 1
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
initcall mcs7830_init+0x0/0x1b returned 0 after 9765 usecs
calling  usbnet_init+0x0/0x2b @ 1
initcall usbnet_init+0x0/0x2b returned 0 after 0 usecs
calling  ipw2100_init+0x0/0x6f @ 1
ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
ipw2100: Copyright(c) 2003-2006 Intel Corporation
initcall ipw2100_init+0x0/0x6f returned 0 after 48828 usecs
calling  ipw_init+0x0/0x8a @ 1
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kdmpr
ipw2200: Copyright(c) 2003-2006 Intel Corporation
initcall ipw_init+0x0/0x8a returned 0 after 29296 usecs
calling  ieee80211_init+0x0/0xb3 @ 1
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
initcall ieee80211_init+0x0/0xb3 returned 0 after 19531 usecs
calling  strip_init_driver+0x0/0x6a @ 1
STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
initcall strip_init_driver+0x0/0x6a returned 0 after 0 usecs
calling  init_wavelan_cs+0x0/0x12 @ 1
initcall init_wavelan_cs+0x0/0x12 returned 0 after 9765 usecs
calling  init_orinoco+0x0/0x1d @ 1
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
initcall init_orinoco+0x0/0x1d returned 0 after 9765 usecs
calling  init_orinoco_cs+0x0/0x27 @ 1
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
initcall init_orinoco_cs+0x0/0x27 returned 0 after 19531 usecs
calling  orinoco_pci_init+0x0/0x30 @ 1
orinoco_pci 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au> & Jean Tourrilhes <jt@hpl.hp.com>)
initcall orinoco_pci_init+0x0/0x30 returned 0 after 29296 usecs
calling  orinoco_tmd_init+0x0/0x30 @ 1
orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
initcall orinoco_tmd_init+0x0/0x30 returned 0 after 19531 usecs
calling  orinoco_nortel_init+0x0/0x30 @ 1
orinoco_nortel 0.15 (Tobias Hoffmann & Christoph Jungegger <disdos@traum404.de>)
initcall orinoco_nortel_init+0x0/0x30 returned 0 after 19531 usecs
calling  init_spectrum_cs+0x0/0x27 @ 1
spectrum_cs 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au>, et al)
initcall init_spectrum_cs+0x0/0x27 returned 0 after 29296 usecs
calling  airo_init_module+0x0/0xed @ 1
airo(): Probing for PCI adapters
airo(): Finished probing for PCI adapters
initcall airo_init_module+0x0/0xed returned 0 after 9765 usecs
calling  airo_cs_init+0x0/0x12 @ 1
initcall airo_cs_init+0x0/0x12 returned 0 after 9765 usecs
calling  hostap_init+0x0/0x45 @ 1
initcall hostap_init+0x0/0x45 returned 0 after 0 usecs
calling  init_prism2_pccard+0x0/0x12 @ 1
initcall init_prism2_pccard+0x0/0x12 returned 0 after 19531 usecs
calling  init_prism2_plx+0x0/0x1b @ 1
initcall init_prism2_plx+0x0/0x1b returned 0 after 9765 usecs
calling  init_prism2_pci+0x0/0x1b @ 1
initcall init_prism2_pci+0x0/0x1b returned 0 after 9765 usecs
calling  init_ray_cs+0x0/0x98 @ 1
initcall init_ray_cs+0x0/0x98 returned 0 after 9765 usecs
calling  wl3501_init_module+0x0/0x12 @ 1
initcall wl3501_init_module+0x0/0x12 returned 0 after 9765 usecs
calling  zd1201_init+0x0/0x1b @ 1
usbcore: registered new interface driver zd1201
initcall zd1201_init+0x0/0x1b returned 0 after 9765 usecs
calling  lbs_init_module+0x0/0xcc @ 1
initcall lbs_init_module+0x0/0xcc returned 0 after 0 usecs
calling  if_usb_init_module+0x0/0xbd @ 1
usbcore: registered new interface driver usb8xxx
initcall if_usb_init_module+0x0/0xbd returned 0 after 19531 usecs
calling  if_cs_init+0x0/0xb9 @ 1
initcall if_cs_init+0x0/0xb9 returned 0 after 9765 usecs
calling  if_sdio_init_module+0x0/0xd7 @ 1
libertas_sdio: Libertas SDIO driver
libertas_sdio: Copyright Pierre Ossman
initcall if_sdio_init_module+0x0/0xd7 returned 0 after 39062 usecs
calling  xircom_init+0x0/0x1b @ 1
initcall xircom_init+0x0/0x1b returned 0 after 9765 usecs
calling  dmfe_init_module+0x0/0xea @ 1
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
initcall dmfe_init_module+0x0/0xea returned 0 after 19531 usecs
calling  w840_init+0x0/0x29 @ 1
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
initcall w840_init+0x0/0x29 returned 0 after 19531 usecs
calling  de_init+0x0/0x1b @ 1
initcall de_init+0x0/0x1b returned 0 after 9765 usecs
calling  tulip_init+0x0/0x33 @ 1
initcall tulip_init+0x0/0x33 returned 0 after 9765 usecs
calling  de4x5_module_init+0x0/0x1b @ 1
initcall de4x5_module_init+0x0/0x1b returned 0 after 0 usecs
calling  uli526x_init_module+0x0/0x9e @ 1
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
initcall uli526x_init_module+0x0/0x9e returned 0 after 39062 usecs
calling  mkiss_init_driver+0x0/0x44 @ 1
mkiss: AX.25 Multikiss, Hans Albas PE1AYX
initcall mkiss_init_driver+0x0/0x44 returned 0 after 9765 usecs
calling  sixpack_init_driver+0x0/0x44 @ 1
AX.25: 6pack driver, Revision: 0.3.0
initcall sixpack_init_driver+0x0/0x44 returned 0 after 0 usecs
calling  yam_init_driver+0x0/0x12d @ 1
YAM driver version 0.8 by F1OAT/F6FBB
PM: Adding info for No Bus:yam0
PM: Adding info for No Bus:yam1
PM: Adding info for No Bus:yam2
PM: Adding info for No Bus:yam3
initcall yam_init_driver+0x0/0x12d returned 0 after 39062 usecs
calling  init_baycomserhdx+0x0/0xf2 @ 1
baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
baycom_ser_hdx: version 0.10 compiled 12:20:46 Jun 10 2009
PM: Adding info for No Bus:bcsh0
PM: Adding info for No Bus:bcsh1
PM: Adding info for No Bus:bcsh2
PM: Adding info for No Bus:bcsh3
initcall init_baycomserhdx+0x0/0xf2 returned 0 after 48828 usecs
calling  hdlcdrv_init_driver+0x0/0x24 @ 1
hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
hdlcdrv: version 0.8 compiled 12:20:46 Jun 10 2009
initcall hdlcdrv_init_driver+0x0/0x24 returned 0 after 9765 usecs
calling  init_netconsole+0x0/0x289 @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x289 returned 0 after 9765 usecs
calling  efx_init_module+0x0/0xd9 @ 1
Solarflare NET driver v2.3
initcall efx_init_module+0x0/0xd9 returned 0 after 0 usecs
calling  amb_module_init+0x0/0x14b @ 1
Madge ATM Ambassador driver version 1.2.4
amb: debug bitmap is 0
initcall amb_module_init+0x0/0x14b returned 0 after 9765 usecs
calling  ia_module_init+0x0/0x5a @ 1
initcall ia_module_init+0x0/0x5a returned 0 after 9765 usecs
calling  fore200e_module_init+0x0/0x29 @ 1
fore200e: FORE Systems 200E-series ATM driver - version 0.3e
initcall fore200e_module_init+0x0/0x29 returned 0 after 19531 usecs
calling  solos_pci_init+0x0/0x30 @ 1
Solos PCI Driver Version 0.07
initcall solos_pci_init+0x0/0x30 returned 0 after 39062 usecs
calling  adummy_init+0x0/0x12f @ 1
adummy: version 1.0
PM: Adding info for No Bus:adummy0
initcall adummy_init+0x0/0x12f returned 0 after 19531 usecs
calling  atmtcp_init+0x0/0x14 @ 1
initcall atmtcp_init+0x0/0x14 returned 0 after 0 usecs
calling  firestream_init_module+0x0/0x1b @ 1
initcall firestream_init_module+0x0/0x1b returned 0 after 29296 usecs
calling  lanai_module_init+0x0/0x38 @ 1
initcall lanai_module_init+0x0/0x38 returned 0 after 19531 usecs
calling  he_init+0x0/0x1b @ 1
initcall he_init+0x0/0x1b returned 0 after 0 usecs
calling  fusion_init+0x0/0xf8 @ 1
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
initcall fusion_init+0x0/0xf8 returned 0 after 9765 usecs
calling  mptspi_init+0x0/0xde @ 1
Fusion MPT SPI Host driver 3.04.07
initcall mptspi_init+0x0/0xde returned 0 after 9765 usecs
calling  mptsas_init+0x0/0xf5 @ 1
Fusion MPT SAS Host driver 3.04.07
initcall mptsas_init+0x0/0xf5 returned 0 after 39062 usecs
calling  mptctl_init+0x0/0x105 @ 1
Fusion MPT misc device (ioctl) driver 3.04.07
PM: Adding info for No Bus:mptctl
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
initcall mptctl_init+0x0/0x105 returned 0 after 39062 usecs
calling  fw_core_init+0x0/0x89 @ 1
initcall fw_core_init+0x0/0x89 returned 0 after 29296 usecs
calling  sbp2_init+0x0/0x46 @ 1
initcall sbp2_init+0x0/0x46 returned 0 after 0 usecs
calling  ohci1394_init+0x0/0x1b @ 1
ohci1394 0000:05:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
PM: Adding info for ieee1394:fw-host0
PM: Adding info for No Bus:fw-host0
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[5000c000-5000c7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
initcall ohci1394_init+0x0/0x1b returned 0 after 87890 usecs
calling  init_raw1394+0x0/0xf4 @ 1
PM: Adding info for No Bus:raw1394
ieee1394: raw1394: /dev/raw1394 device initialized
initcall init_raw1394+0x0/0xf4 returned 0 after 9765 usecs
calling  dv1394_init_module+0x0/0x9f @ 1
PM: Adding info for No Bus:dv1394-0
initcall dv1394_init_module+0x0/0x9f returned 0 after 19531 usecs
calling  ether1394_init_module+0x0/0x70 @ 1
PM: Adding info for No Bus:eth1
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
initcall ether1394_init_module+0x0/0x70 returned 0 after 29296 usecs
calling  uio_init+0x0/0x8 @ 1
initcall uio_init+0x0/0x8 returned 0 after 0 usecs
calling  hilscher_init_module+0x0/0x1b @ 1
initcall hilscher_init_module+0x0/0x1b returned 0 after 19531 usecs
calling  uio_pdrv_genirq_init+0x0/0x12 @ 1
initcall uio_pdrv_genirq_init+0x0/0x12 returned 0 after 19531 usecs
calling  smx_ce_init_module+0x0/0x12 @ 1
initcall smx_ce_init_module+0x0/0x12 returned 0 after 9765 usecs
calling  aectc_init+0x0/0x1b @ 1
initcall aectc_init+0x0/0x1b returned 0 after 0 usecs
calling  sercos3_init_module+0x0/0x1b @ 1
initcall sercos3_init_module+0x0/0x1b returned 0 after 19531 usecs
calling  ks0108_init+0x0/0xba @ 1
parport0: cannot grant exclusive access for device ks0108
ks0108: ERROR: parport didn't register new device
initcall ks0108_init+0x0/0xba returned -22 after 9765 usecs
initcall ks0108_init+0x0/0xba returned with error code -22 
calling  nonstatic_sysfs_init+0x0/0x12 @ 1
initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 0 usecs
calling  i82092aa_module_init+0x0/0x1b @ 1
initcall i82092aa_module_init+0x0/0x1b returned 0 after 9765 usecs
calling  aoe_init+0x0/0xa7 @ 1
PM: Adding info for No Bus:err
PM: Adding info for No Bus:discover
PM: Adding info for No Bus:interfaces
PM: Adding info for No Bus:revalidate
PM: Adding info for No Bus:flush
aoe: AoE v47 initialised.
initcall aoe_init+0x0/0xa7 returned 0 after 68359 usecs
calling  uwb_subsys_init+0x0/0x51 @ 1
initcall uwb_subsys_init+0x0/0x51 returned 0 after 29296 usecs
calling  wlp_subsys_init+0x0/0x8 @ 1
initcall wlp_subsys_init+0x0/0x8 returned 0 after 0 usecs
calling  umc_bus_init+0x0/0x12 @ 1
initcall umc_bus_init+0x0/0x12 returned 0 after 29296 usecs
calling  whci_init+0x0/0x1b @ 1
initcall whci_init+0x0/0x1b returned 0 after 19531 usecs
calling  whcrc_driver_init+0x0/0x1b @ 1
initcall whcrc_driver_init+0x0/0x1b returned 0 after 0 usecs
calling  hwarc_driver_init+0x0/0x1b @ 1
usbcore: registered new interface driver hwa-rc
initcall hwarc_driver_init+0x0/0x1b returned 0 after 9765 usecs
calling  i1480_dfu_driver_init+0x0/0x1b @ 1
usbcore: registered new interface driver i1480-dfu-usb
initcall i1480_dfu_driver_init+0x0/0x1b returned 0 after 19531 usecs
calling  i1480_est_init+0x0/0x81 @ 1
initcall i1480_est_init+0x0/0x81 returned 0 after 0 usecs
calling  i1480u_driver_init+0x0/0x1b @ 1
usbcore: registered new interface driver i1480u_wlp
initcall i1480u_driver_init+0x0/0x1b returned 0 after 19531 usecs
calling  mon_init+0x0/0x115 @ 1
PM: Adding info for No Bus:usbmon0
initcall mon_init+0x0/0x115 returned 0 after 29296 usecs
calling  ehci_hcd_init+0x0/0xdd @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
  alloc irq_desc for 23 on node 0
  alloc kstat_irqs on node 0
IOAPIC[0]: Set routing entry (2-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
PM: Adding info for No Bus:usb_host1
PM: Adding info for No Bus:usbmon1
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50404400
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30-tip ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
PM: Adding info for usb:usb1
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
PM: Adding info for usb:1-0:1.0
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
PM: Adding info for No Bus:usbdev1.1_ep00
initcall ehci_hcd_init+0x0/0xdd returned 0 after 234374 usecs
calling  oxu_module_init+0x0/0x12 @ 1
initcall oxu_module_init+0x0/0x12 returned 0 after 0 usecs
calling  ohci_hcd_mod_init+0x0/0xf2 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
initcall ohci_hcd_mod_init+0x0/0xf2 returned 0 after 9765 usecs
calling  uhci_hcd_init+0x0/0x167 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
PM: Adding info for No Bus:usb_host2
PM: Adding info for No Bus:usbmon2
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
usb usb2: default language 0x0409
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30-tip uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
PM: Adding info for usb:usb2
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
PM: Adding info for usb:2-0:1.0
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
PM: Adding info for No Bus:usbdev2.1_ep00
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
PM: Adding info for No Bus:usb_host3
PM: Adding info for No Bus:usbmon3
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: default language 0x0409
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30-tip uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
PM: Adding info for usb:usb3
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
PM: Adding info for usb:3-0:1.0
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
PM: Adding info for No Bus:usbdev3.1_ep00
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
PM: Adding info for No Bus:usb_host4
PM: Adding info for No Bus:usbmon4
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: default language 0x0409
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30-tip uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
PM: Adding info for usb:usb4
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
PM: Adding info for usb:4-0:1.0
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev4.1_ep81
PM: Adding info for ieee1394:0090270001ab6fc2
PM: Adding info for No Bus:usbdev4.1
PM: Adding info for No Bus:0090270001ab6fc2
PM: Adding info for No Bus:usbdev4.1_ep00
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090270001ab6fc2]
PM: Adding info for ieee1394:0090270001ab6fc2-0
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
PM: Adding info for No Bus:usb_host5
PM: Adding info for No Bus:0090270001ab6fc2-0
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
PM: Adding info for No Bus:usbmon5
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: supports USB remote wakeup
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
usb usb5: default language 0x0409
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.30-tip uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
PM: Adding info for usb:usb5
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
PM: Adding info for usb:5-0:1.0
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev5.1_ep81
PM: Adding info for No Bus:usbdev5.1
PM: Adding info for No Bus:usbdev5.1_ep00
initcall uhci_hcd_init+0x0/0x167 returned 0 after 791015 usecs
calling  sl811h_init+0x0/0x3e @ 1
sl811: driver sl811-hcd, 19 May 2005
initcall sl811h_init+0x0/0x3e returned 0 after 39062 usecs
calling  r8a66597_init+0x0/0x3e @ 1
r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
initcall r8a66597_init+0x0/0x3e returned 0 after 9765 usecs
calling  c67x00_init+0x0/0x12 @ 1
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
initcall c67x00_init+0x0/0x12 returned 0 after 19531 usecs
calling  wusbcore_init+0x0/0x75 @ 1
initcall wusbcore_init+0x0/0x75 returned 0 after 0 usecs
calling  cbaf_driver_init+0x0/0x1b @ 1
usbcore: registered new interface driver wusb-cbaf
initcall cbaf_driver_init+0x0/0x1b returned 0 after 9765 usecs
calling  usblp_init+0x0/0x1b @ 1
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x1b returned 0 after 9765 usecs
calling  wdm_init+0x0/0x1b @ 1
usbcore: registered new interface driver cdc_wdm
initcall wdm_init+0x0/0x1b returned 0 after 0 usecs
calling  usbtmc_init+0x0/0x38 @ 1
usbcore: registered new interface driver usbtmc
initcall usbtmc_init+0x0/0x38 returned 0 after 19531 usecs
calling  usb_usual_init+0x0/0x40 @ 1
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x40 returned 0 after 0 usecs
calling  usb_serial_init+0x0/0x235 @ 1
usbcore: registered new interface driver usbserial
usbserial: USB Serial Driver core
initcall usb_serial_init+0x0/0x235 returned 0 after 19531 usecs
calling  aircable_init+0x0/0x49 @ 1
USB Serial support registered for aircable
usbcore: registered new interface driver aircable
initcall aircable_init+0x0/0x49 returned 0 after 29296 usecs
calling  belkin_sa_init+0x0/0x58 @ 1
USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
usbcore: registered new interface driver belkin
belkin_sa: v1.2:USB Belkin Serial converter driver
initcall belkin_sa_init+0x0/0x58 returned 0 after 29296 usecs
calling  ch341_init+0x0/0x49 @ 1
USB Serial support registered for ch341-uart
usbcore: registered new interface driver ch341
initcall ch341_init+0x0/0x49 returned 0 after 29296 usecs
calling  cp2101_init+0x0/0x58 @ 1
USB Serial support registered for cp2101
usbcore: registered new interface driver cp2101
cp210x: v0.08:Silicon Labs CP2101/CP2102 RS232 serial adaptor driver
initcall cp2101_init+0x0/0x58 returned 0 after 9765 usecs
calling  cyberjack_init+0x0/0x66 @ 1
USB Serial support registered for Reiner SCT Cyberjack USB card reader
usbcore: registered new interface driver cyberjack
cyberjack: v1.01 Matthias Bruestle
cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
initcall cyberjack_init+0x0/0x66 returned 0 after 29296 usecs
calling  cypress_init+0x0/0xb9 @ 1
USB Serial support registered for DeLorme Earthmate USB
USB Serial support registered for HID->COM RS232 Adapter
USB Serial support registered for Nokia CA-42 V2 Adapter
usbcore: registered new interface driver cypress
usb usb2: suspend_rh (auto-stop)
cypress_m8: v1.09:Cypress USB to Serial Driver
initcall cypress_init+0x0/0xb9 returned 0 after 39062 usecs
calling  digi_init+0x0/0x76 @ 1
USB Serial support registered for Digi 2 port USB adapter
USB Serial support registered for Digi 4 port USB adapter
usbcore: registered new interface driver digi_acceleport
digi_acceleport: v1.80.1.2:Digi AccelePort USB-2/USB-4 Serial Converter driver
initcall digi_init+0x0/0x76 returned 0 after 29296 usecs
calling  edgeport_init+0x0/0x76 @ 1
USB Serial support registered for Edgeport TI 1 port adapter
USB Serial support registered for Edgeport TI 2 port adapter
usbcore: registered new interface driver io_ti
io_ti: v0.7mode043006:Edgeport USB Serial Driver
initcall edgeport_init+0x0/0x76 returned 0 after 48828 usecs
calling  empeg_init+0x0/0x199 @ 1
USB Serial support registered for empeg
usbcore: registered new interface driver empeg
empeg: v1.2:USB Empeg Mark I/II Driver
initcall empeg_init+0x0/0x199 returned 0 after 29296 usecs
calling  ftdi_init+0x0/0xc6 @ 1
USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
initcall ftdi_init+0x0/0xc6 returned 0 after 19531 usecs
calling  funsoft_init+0x0/0x48 @ 1
USB Serial support registered for funsoft
usbcore: registered new interface driver funsoft
initcall funsoft_init+0x0/0x48 returned 0 after 9765 usecs
calling  garmin_init+0x0/0x59 @ 1
USB Serial support registered for Garmin GPS usb/tty
usbcore: registered new interface driver garmin_gps
garmin_gps: v0.31:garmin gps driver
initcall garmin_init+0x0/0x59 returned 0 after 29296 usecs
calling  hp49gp_init+0x0/0x58 @ 1
usb usb3: suspend_rh (auto-stop)
USB Serial support registered for hp4X
usbcore: registered new interface driver hp4X
hp4x: v1.00:HP4x (48/49) Generic Serial driver
initcall hp49gp_init+0x0/0x58 returned 0 after 9765 usecs
calling  ir_init+0x0/0x58 @ 1
USB Serial support registered for IR Dongle
usbcore: registered new interface driver ir-usb
ir_usb: v0.4:USB IR Dongle driver
initcall ir_init+0x0/0x58 returned 0 after 0 usecs
calling  iuu_init+0x0/0x59 @ 1
USB Serial support registered for iuu_phoenix
usbcore: registered new interface driver iuu_phoenix
iuu_phoenix: v0.5:Infinity USB Unlimited Phoenix driver
initcall iuu_init+0x0/0x59 returned 0 after 0 usecs
calling  klsi_105_init+0x0/0x58 @ 1
USB Serial support registered for KL5KUSB105D / PalmConnect
usbcore: registered new interface driver kl5kusb105d
kl5kusb105: v0.3a:KLSI KL5KUSB105 chipset USB->Serial Converter driver
initcall klsi_105_init+0x0/0x58 returned 0 after 0 usecs
calling  mct_u232_init+0x0/0x58 @ 1
USB Serial support registered for MCT U232
usbcore: registered new interface driver mct_u232
mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
initcall mct_u232_init+0x0/0x58 returned 0 after 0 usecs
calling  moschip7720_init+0x0/0x7b @ 1
USB Serial support registered for Moschip 2 port adapter
mos7720: 1.0.0.4F:Moschip USB Serial Driver
usbcore: registered new interface driver moschip7720
initcall moschip7720_init+0x0/0x7b returned 0 after 0 usecs
calling  moschip7840_init+0x0/0xcc @ 1
USB Serial support registered for Moschip 7840/7820 USB Serial Driver
mos7840: 1.3.2:Moschip 7840/7820 USB Serial Driver
usbcore: registered new interface driver mos7840
initcall moschip7840_init+0x0/0xcc returned 0 after 0 usecs
calling  moto_init+0x0/0x48 @ 1
USB Serial support registered for moto-modem
usbcore: registered new interface driver moto-modem
initcall moto_init+0x0/0x48 returned 0 after 0 usecs
calling  navman_init+0x0/0x48 @ 1
USB Serial support registered for navman
usbcore: registered new interface driver navman
initcall navman_init+0x0/0x48 returned 0 after 0 usecs
calling  opticon_init+0x0/0x48 @ 1
USB Serial support registered for opticon
usbcore: registered new interface driver opticon
initcall opticon_init+0x0/0x48 returned 0 after 0 usecs
calling  oti6858_init+0x0/0x48 @ 1
USB Serial support registered for oti6858
usbcore: registered new interface driver oti6858
initcall oti6858_init+0x0/0x48 returned 0 after 0 usecs
calling  pl2303_init+0x0/0x58 @ 1
USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
initcall pl2303_init+0x0/0x58 returned 0 after 0 usecs
calling  qcinit+0x0/0x48 @ 1
USB Serial support registered for Qualcomm USB modem
usbcore: registered new interface driver qcserial
initcall qcinit+0x0/0x48 returned 0 after 0 usecs
calling  safe_init+0x0/0xcf @ 1
safe_serial: v0.0b:USB Safe Encapsulated Serial
USB Serial support registered for safe_serial
usbcore: registered new interface driver safe_serial
initcall safe_init+0x0/0xcf returned 0 after 0 usecs
calling  siemens_usb_mpi_init+0x0/0x66 @ 1
USB Serial support registered for siemens_mpi
usbcore: registered new interface driver siemens_mpi
Driver for Siemens USB/MPI adapter
Version 0.1 09/26/2005 Thomas Hergenhahn@web.de http://libnodave.sf.net
initcall siemens_usb_mpi_init+0x0/0x66 returned 0 after 0 usecs
calling  sierra_init+0x0/0x58 @ 1
USB Serial support registered for Sierra USB modem
usbcore: registered new interface driver sierra
sierra: v.1.3.3:USB Driver for Sierra Wireless USB modems
initcall sierra_init+0x0/0x58 returned 0 after 0 usecs
calling  symbol_init+0x0/0x48 @ 1
USB Serial support registered for symbol
usbcore: registered new interface driver symbol
initcall symbol_init+0x0/0x48 returned 0 after 0 usecs
calling  visor_init+0x0/0x199 @ 1
USB Serial support registered for Handspring Visor / Palm OS
USB Serial support registered for Sony Clie 3.5
USB Serial support registered for Sony Clie 5.0
usbcore: registered new interface driver visor
visor: USB HandSpring Visor / Palm OS driver
initcall visor_init+0x0/0x199 returned 0 after 0 usecs
calling  keyspan_pda_init+0x0/0x77 @ 1
USB Serial support registered for Keyspan PDA
USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
usbcore: registered new interface driver keyspan_pda
keyspan_pda: v1.1:USB Keyspan PDA Converter driver
initcall keyspan_pda_init+0x0/0x77 returned 0 after 0 usecs
calling  adu_init+0x0/0x96 @ 1
drivers/usb/misc/adutux.c :  adu_init : enter 
usbcore: registered new interface driver adutux
adutux adutux (see www.ontrak.net) v0.0.13
adutux is an experimental driver. Use at your own risk
drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
initcall adu_init+0x0/0x96 returned 0 after 0 usecs
calling  appledisplay_init+0x0/0x59 @ 1
usbcore: registered new interface driver appledisplay
initcall appledisplay_init+0x0/0x59 returned 0 after 19531 usecs
calling  berry_init+0x0/0x1b @ 1
usbcore: registered new interface driver berry_charge
initcall berry_init+0x0/0x1b returned 0 after 9765 usecs
calling  usb_cytherm_init+0x0/0x4a @ 1
usbcore: registered new interface driver cytherm
cytherm: v1.0:Cypress USB Thermometer driver
initcall usb_cytherm_init+0x0/0x4a returned 0 after 9765 usecs
calling  emi26_init+0x0/0x1b @ 1
usbcore: registered new interface driver emi26 - firmware loader
initcall emi26_init+0x0/0x1b returned 0 after 9765 usecs
calling  emi62_init+0x0/0x38 @ 1
usbcore: registered new interface driver emi62 - firmware loader
initcall emi62_init+0x0/0x38 returned 0 after 0 usecs
calling  ftdi_elan_init+0x0/0x16e @ 1
driver ftdi-elan built at 12:21:31 on Jun 10 2009
usbcore: registered new interface driver ftdi-elan
initcall ftdi_elan_init+0x0/0x16e returned 0 after 19531 usecs
calling  iowarrior_init+0x0/0x1b @ 1
usbcore: registered new interface driver iowarrior
initcall iowarrior_init+0x0/0x1b returned 0 after 19531 usecs
calling  ld_usb_init+0x0/0x3a @ 1
usbcore: registered new interface driver ldusb
initcall ld_usb_init+0x0/0x3a returned 0 after 29296 usecs
calling  usb_led_init+0x0/0x3a @ 1
usbcore: registered new interface driver usbled
initcall usb_led_init+0x0/0x3a returned 0 after 29296 usecs
calling  usb_rio_init+0x0/0x38 @ 1
usb usb4: suspend_rh (auto-stop)
usbcore: registered new interface driver rio500
rio500: v1.1:USB Rio 500 driver
initcall usb_rio_init+0x0/0x38 returned 0 after 19531 usecs
calling  tv_init+0x0/0x4a @ 1
usbcore: registered new interface driver trancevibrator
trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
initcall tv_init+0x0/0x4a returned 0 after 19531 usecs
calling  usb_sevseg_init+0x0/0x3a @ 1
usbcore: registered new interface driver usbsevseg
initcall usb_sevseg_init+0x0/0x3a returned 0 after 19531 usecs
calling  vstusb_init+0x0/0x41 @ 1
usbcore: registered new interface driver vstusb
initcall vstusb_init+0x0/0x41 returned 0 after 9765 usecs
calling  cxacru_init+0x0/0x1b @ 1
usbcore: registered new interface driver cxacru
initcall cxacru_init+0x0/0x1b returned 0 after 9765 usecs
calling  speedtch_usb_init+0x0/0x3e @ 1
drivers/usb/atm/speedtch.c: speedtch_usb_init: driver version 1.10
usbcore: registered new interface driver speedtch
initcall speedtch_usb_init+0x0/0x3e returned 0 after 29296 usecs
calling  uea_init+0x0/0x2b @ 1
[ueagle-atm] driver ueagle 1.4 loaded
usbcore: registered new interface driver ueagle-atm
initcall uea_init+0x0/0x2b returned 0 after 29296 usecs
calling  usbatm_usb_init+0x0/0x65 @ 1
drivers/usb/atm/usbatm.c: usbatm_usb_init: driver version 1.10
initcall usbatm_usb_init+0x0/0x65 returned 0 after 0 usecs
calling  xusbatm_init+0x0/0x16c @ 1
drivers/usb/atm/xusbatm.c: xusbatm_init
xusbatm: malformed module parameters
initcall xusbatm_init+0x0/0x16c returned -22 after 9765 usecs
initcall xusbatm_init+0x0/0x16c returned with error code -22 
calling  i8042_init+0x0/0x32e @ 1
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
usb usb5: suspend_rh (auto-stop)
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x32e returned 0 after 48828 usecs
calling  ct82c710_init+0x0/0x196 @ 1
initcall ct82c710_init+0x0/0x196 returned -19 after 0 usecs
calling  serio_raw_init+0x0/0x1b @ 1
PM: Adding info for serio:serio0
PM: Adding info for serio:serio1
initcall serio_raw_init+0x0/0x1b returned 0 after 19531 usecs
calling  emu_init+0x0/0x1b @ 1
initcall emu_init+0x0/0x1b returned 0 after 29296 usecs
calling  fm801_gp_init+0x0/0x1b @ 1
initcall fm801_gp_init+0x0/0x1b returned 0 after 0 usecs
calling  mousedev_init+0x0/0x62 @ 1
PM: Adding info for No Bus:mice
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x62 returned 0 after 9765 usecs
calling  joydev_init+0x0/0x12 @ 1
initcall joydev_init+0x0/0x12 returned 0 after 0 usecs
calling  atkbd_init+0x0/0x1b @ 1
initcall atkbd_init+0x0/0x1b returned 0 after 0 usecs
calling  sunkbd_init+0x0/0x1b @ 1
initcall sunkbd_init+0x0/0x1b returned 0 after 0 usecs
calling  lkkbd_init+0x0/0x1b @ 1
initcall lkkbd_init+0x0/0x1b returned 0 after 0 usecs
calling  xtkbd_init+0x0/0x1b @ 1
initcall xtkbd_init+0x0/0x1b returned 0 after 0 usecs
calling  adi_init+0x0/0x1b @ 1
PM: Adding info for No Bus:input0
input: AT Translated Set 2 keyboard as /class/input/input0
initcall adi_init+0x0/0x1b returned 0 after 9765 usecs
calling  analog_init+0x0/0xf7 @ 1
initcall analog_init+0x0/0xf7 returned 0 after 0 usecs
calling  cobra_init+0x0/0x1b @ 1
initcall cobra_init+0x0/0x1b returned 0 after 0 usecs
calling  db9_init+0x0/0x4a4 @ 1
initcall db9_init+0x0/0x4a4 returned -19 after 0 usecs
calling  gc_init+0x0/0x65d @ 1
initcall gc_init+0x0/0x65d returned -19 after 0 usecs
calling  gf2k_init+0x0/0x1b @ 1
initcall gf2k_init+0x0/0x1b returned 0 after 0 usecs
calling  grip_init+0x0/0x1b @ 1
initcall grip_init+0x0/0x1b returned 0 after 0 usecs
calling  guillemot_init+0x0/0x1b @ 1
initcall guillemot_init+0x0/0x1b returned 0 after 0 usecs
calling  iforce_init+0x0/0x51 @ 1
usbcore: registered new interface driver iforce
initcall iforce_init+0x0/0x51 returned 0 after 9765 usecs
calling  interact_init+0x0/0x1b @ 1
initcall interact_init+0x0/0x1b returned 0 after 0 usecs
calling  joydump_init+0x0/0x1b @ 1
initcall joydump_init+0x0/0x1b returned 0 after 0 usecs
calling  spaceball_init+0x0/0x1b @ 1
initcall spaceball_init+0x0/0x1b returned 0 after 0 usecs
calling  stinger_init+0x0/0x1b @ 1
initcall stinger_init+0x0/0x1b returned 0 after 0 usecs
calling  tgfx_init+0x0/0x479 @ 1
initcall tgfx_init+0x0/0x479 returned -19 after 0 usecs
calling  twidjoy_init+0x0/0x1b @ 1
initcall twidjoy_init+0x0/0x1b returned 0 after 0 usecs
calling  usb_xpad_init+0x0/0x38 @ 1
usbcore: registered new interface driver xpad
xpad: X-Box pad driver
initcall usb_xpad_init+0x0/0x38 returned 0 after 9765 usecs
calling  zhenhua_init+0x0/0x1b @ 1
initcall zhenhua_init+0x0/0x1b returned 0 after 0 usecs
calling  usb_acecad_init+0x0/0x38 @ 1
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
initcall usb_acecad_init+0x0/0x38 returned 0 after 0 usecs
calling  gtco_init+0x0/0x51 @ 1
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006initcall gtco_init+0x0/0x51 returned 0 after 9765 usecs
calling  wacom_init+0x0/0x44 @ 1
usbcore: registered new interface driver wacom
wacom: v1.50:USB Wacom Graphire and Wacom Intuos tablet driver
initcall wacom_init+0x0/0x44 returned 0 after 9765 usecs
calling  elo_init+0x0/0x1b @ 1
initcall elo_init+0x0/0x1b returned 0 after 0 usecs
calling  fujitsu_init+0x0/0x1b @ 1
initcall fujitsu_init+0x0/0x1b returned 0 after 0 usecs
calling  inexio_init+0x0/0x1b @ 1
initcall inexio_init+0x0/0x1b returned 0 after 0 usecs
calling  mtouch_init+0x0/0x1b @ 1
initcall mtouch_init+0x0/0x1b returned 0 after 0 usecs
calling  mk712_init+0x0/0x1e3 @ 1
mk712: device not present
initcall mk712_init+0x0/0x1e3 returned -19 after 0 usecs
calling  pm_init+0x0/0x1b @ 1
initcall pm_init+0x0/0x1b returned 0 after 0 usecs
calling  touchit213_init+0x0/0x1b @ 1
initcall touchit213_init+0x0/0x1b returned 0 after 0 usecs
calling  tr_init+0x0/0x1b @ 1
initcall tr_init+0x0/0x1b returned 0 after 0 usecs
calling  tw_init+0x0/0x1b @ 1
initcall tw_init+0x0/0x1b returned 0 after 0 usecs
calling  w8001_init+0x0/0x1b @ 1
initcall w8001_init+0x0/0x1b returned 0 after 0 usecs
calling  apanel_init+0x0/0x18b @ 1
apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
initcall apanel_init+0x0/0x18b returned -19 after 0 usecs
calling  ati_remote_init+0x0/0x4a @ 1
usbcore: registered new interface driver ati_remote
ati_remote: 2.2.1:ATI/X10 RF USB Remote Control
initcall ati_remote_init+0x0/0x4a returned 0 after 9765 usecs
calling  ati_remote2_init+0x0/0x4a @ 1
usbcore: registered new interface driver ati_remote2
ati_remote2: ATI/Philips USB RF remote driver 0.3
initcall ati_remote2_init+0x0/0x4a returned 0 after 9765 usecs
calling  atlas_acpi_init+0x0/0x3b @ 1
initcall atlas_acpi_init+0x0/0x3b returned 0 after 0 usecs
calling  cm109_init+0x0/0xfd @ 1
cm109: Keymap for Komunikate KIP1000 phone loaded
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
initcall cm109_init+0x0/0xfd returned 0 after 19531 usecs
calling  usb_keyspan_init+0x0/0x3a @ 1
usbcore: registered new interface driver keyspan_remote
initcall usb_keyspan_init+0x0/0x3a returned 0 after 0 usecs
calling  pcspkr_init+0x0/0x12 @ 1
PM: Adding info for No Bus:input1
input: PC Speaker as /class/input/input1
initcall pcspkr_init+0x0/0x12 returned 0 after 9765 usecs
calling  powermate_init+0x0/0x1b @ 1
usbcore: registered new interface driver powermate
initcall powermate_init+0x0/0x1b returned 0 after 9765 usecs
calling  uinput_init+0x0/0x12 @ 1
PM: Adding info for No Bus:uinput
initcall uinput_init+0x0/0x12 returned 0 after 0 usecs
calling  yealink_dev_init+0x0/0x39 @ 1
usbcore: registered new interface driver yealink
yealink: yld-20051230:Yealink phone driver
initcall yealink_dev_init+0x0/0x39 returned 0 after 9765 usecs
calling  ali1563_init+0x0/0x1b @ 1
initcall ali1563_init+0x0/0x1b returned 0 after 0 usecs
calling  amd756_init+0x0/0x1b @ 1
initcall amd756_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_sch_init+0x0/0x1b @ 1
initcall i2c_sch_init+0x0/0x1b returned 0 after 0 usecs
calling  nforce2_init+0x0/0x1b @ 1
initcall nforce2_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_piix4_init+0x0/0x1b @ 1
initcall i2c_piix4_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_sis5595_init+0x0/0x1b @ 1
initcall i2c_sis5595_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_sis96x_init+0x0/0x1b @ 1
initcall i2c_sis96x_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_vt596_init+0x0/0x1b @ 1
initcall i2c_vt596_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_parport_init+0x0/0x14d @ 1
i2c-parport-light: adapter type unspecified
initcall i2c_parport_init+0x0/0x14d returned -19 after 9765 usecs
calling  usb_i2c_tiny_usb_init+0x0/0x1b @ 1
usbcore: registered new interface driver i2c-tiny-usb
initcall usb_i2c_tiny_usb_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_pca_pf_init+0x0/0x12 @ 1
initcall i2c_pca_pf_init+0x0/0x12 returned 0 after 0 usecs
calling  max6875_init+0x0/0x14 @ 1
i2c-core: driver [max6875] registered
initcall max6875_init+0x0/0x14 returned 0 after 0 usecs
calling  pca9539_init+0x0/0x14 @ 1
i2c-core: driver [pca9539] registered
initcall pca9539_init+0x0/0x14 returned 0 after 0 usecs
calling  pcf8574_init+0x0/0x14 @ 1
i2c-core: driver [pcf8574] registered
initcall pcf8574_init+0x0/0x14 returned 0 after 9765 usecs
calling  pcf8575_init+0x0/0x14 @ 1
i2c-core: driver [pcf8575] registered
initcall pcf8575_init+0x0/0x14 returned 0 after 9765 usecs
calling  tsl2550_init+0x0/0x14 @ 1
i2c-core: driver [tsl2550] registered
initcall tsl2550_init+0x0/0x14 returned 0 after 0 usecs
calling  videodev_init+0x0/0x89 @ 1
Linux video capture interface: v2.00
initcall videodev_init+0x0/0x89 returned 0 after 0 usecs
calling  dabusb_init+0x0/0xec @ 1
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
initcall dabusb_init+0x0/0xec returned 0 after 9765 usecs
calling  w1_init+0x0/0xa4 @ 1
Driver for 1-wire Dallas network protocol.
initcall w1_init+0x0/0xa4 returned 0 after 0 usecs
calling  matrox_w1_init+0x0/0x1b @ 1
initcall matrox_w1_init+0x0/0x1b returned 0 after 0 usecs
calling  ds_init+0x0/0x3b @ 1
usbcore: registered new interface driver DS9490R
initcall ds_init+0x0/0x3b returned 0 after 0 usecs
calling  sensors_ds2482_init+0x0/0x14 @ 1
i2c-core: driver [ds2482] registered
initcall sensors_ds2482_init+0x0/0x14 returned 0 after 0 usecs
calling  w1_f23_init+0x0/0x12 @ 1
initcall w1_f23_init+0x0/0x12 returned 0 after 0 usecs
calling  w1_ds2760_init+0x0/0x2c @ 1
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
initcall w1_ds2760_init+0x0/0x2c returned 0 after 9765 usecs
calling  pda_power_init+0x0/0x12 @ 1
initcall pda_power_init+0x0/0x12 returned 0 after 0 usecs
calling  ds2760_battery_init+0x0/0x12 @ 1
initcall ds2760_battery_init+0x0/0x12 returned 0 after 0 usecs
calling  bq27x00_battery_init+0x0/0x31 @ 1
i2c-core: driver [bq27200-battery] registered
initcall bq27x00_battery_init+0x0/0x31 returned 0 after 9765 usecs
calling  da903x_battery_init+0x0/0x12 @ 1
initcall da903x_battery_init+0x0/0x12 returned 0 after 0 usecs
calling  pcf50633_mbc_init+0x0/0x12 @ 1
initcall pcf50633_mbc_init+0x0/0x12 returned 0 after 0 usecs
calling  pcipcwd_init_module+0x0/0x35 @ 1
initcall pcipcwd_init_module+0x0/0x35 returned 0 after 0 usecs
calling  wdtpci_init+0x0/0x1b @ 1
initcall wdtpci_init+0x0/0x1b returned 0 after 9765 usecs
calling  watchdog_init+0x0/0x16a @ 1
initcall watchdog_init+0x0/0x16a returned -19 after 0 usecs
calling  sc520_wdt_init+0x0/0xe9 @ 1
PM: Adding info for No Bus:watchdog
sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
initcall sc520_wdt_init+0x0/0xe9 returned 0 after 9765 usecs
calling  ibwdt_init+0x0/0x5f @ 1
ib700wdt: WDT driver for IB700 single board computer initialising.
PM: Adding info for platform:ib700wdt
ib700wdt: failed to register misc device
ib700wdt: probe of ib700wdt failed with error -16
initcall ibwdt_init+0x0/0x5f returned 0 after 19531 usecs
calling  ibmasr_init+0x0/0x248 @ 1
initcall ibmasr_init+0x0/0x248 returned -19 after 0 usecs
calling  watchdog_init+0x0/0x66 @ 1
i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
PM: Adding info for platform:i6300ESB timer
initcall watchdog_init+0x0/0x66 returned 0 after 9765 usecs
calling  iTCO_wdt_init_module+0x0/0x67 @ 1
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
PM: Adding info for platform:iTCO_wdt
iTCO_wdt: Found a ICH7DH TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: cannot register miscdev on minor=130 (err=-16)
iTCO_wdt: No card detected
initcall iTCO_wdt_init_module+0x0/0x67 returned 0 after 19531 usecs
calling  it8712f_wdt_init+0x0/0x1d1 @ 1
initcall it8712f_wdt_init+0x0/0x1d1 returned -19 after 0 usecs
calling  it87_wdt_init+0x0/0x4c8 @ 1
IT87 WDT: Unknown Chip found, Chip 7401 Revision 0009
initcall it87_wdt_init+0x0/0x4c8 returned -19 after 9765 usecs
calling  hpwdt_init+0x0/0x1b @ 1
initcall hpwdt_init+0x0/0x1b returned 0 after 0 usecs
calling  sc1200wdt_init+0x0/0x166 @ 1
sc1200wdt: build 20020303
sc1200wdt: io parameter must be specified
initcall sc1200wdt_init+0x0/0x166 returned -22 after 0 usecs
initcall sc1200wdt_init+0x0/0x166 returned with error code -22 
calling  sbc8360_init+0x0/0x1a4 @ 1
sbc8360: failed to register misc device
initcall sbc8360_init+0x0/0x1a4 returned -16 after 0 usecs
initcall sbc8360_init+0x0/0x1a4 returned with error code -16 
calling  cpu5wdt_init_module+0x0/0x140 @ 1
cpu5wdt: sorry, was my fault
cpu5wdt: misc_register failed
initcall cpu5wdt_init_module+0x0/0x140 returned -16 after 9765 usecs
initcall cpu5wdt_init_module+0x0/0x140 returned with error code -16 
calling  sch311x_wdt_init+0x0/0x147 @ 1
initcall sch311x_wdt_init+0x0/0x147 returned -19 after 0 usecs
calling  wdt_init+0x0/0x1d7 @ 1
WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
w83627hf/thf/hg WDT: cannot register miscdev on minor=130 (err=-16)
initcall wdt_init+0x0/0x1d7 returned -16 after 19531 usecs
initcall wdt_init+0x0/0x1d7 returned with error code -16 
calling  wdt_init+0x0/0x1e1 @ 1
w83697hf/hg WDT: WDT driver for W83697HF/HG initializing
w83697hf/hg WDT: Looking for watchdog at address 0x2e
w83697hf/hg WDT: watchdog not found at address 0x2e
w83697hf/hg WDT: No W83697HF/HG could be found
initcall wdt_init+0x0/0x1e1 returned -5 after 9765 usecs
initcall wdt_init+0x0/0x1e1 returned with error code -5 
calling  wdt_init+0x0/0x1ad @ 1
WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising.
w83697ug/uf WDT: No W83697UG/UF could be found
initcall wdt_init+0x0/0x1ad returned -19 after 9765 usecs
calling  w83977f_wdt_init+0x0/0x119 @ 1
W83977F WDT: W83977F WDT driver, v1.00
W83977F WDT: cannot register miscdev on minor=130 (err=-16)
initcall w83977f_wdt_init+0x0/0x119 returned -16 after 9765 usecs
initcall w83977f_wdt_init+0x0/0x119 returned with error code -16 
calling  zf_init+0x0/0x163 @ 1
machzwd: MachZ ZF-Logic Watchdog driver initializing.
machzwd: no ZF-Logic found
initcall zf_init+0x0/0x163 returned -19 after 9765 usecs
calling  watchdog_init+0x0/0xb8 @ 1
epx_c3: cannot register miscdev on minor=130 (err=-16)
initcall watchdog_init+0x0/0xb8 returned -16 after 0 usecs
initcall watchdog_init+0x0/0xb8 returned with error code -16 
calling  telephony_init+0x0/0x4c @ 1
Linux telephony interface: v1.00
initcall telephony_init+0x0/0x4c returned 0 after 9765 usecs
calling  vhci_init+0x0/0x5b @ 1
Bluetooth: Virtual HCI driver ver 1.2
PM: Adding info for No Bus:vhci
initcall vhci_init+0x0/0x5b returned 0 after 0 usecs
calling  hci_uart_init+0x0/0xe4 @ 1
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
initcall hci_uart_init+0x0/0xe4 returned 0 after 9765 usecs
calling  bcm203x_init+0x0/0x54 @ 1
Bluetooth: Broadcom Blutonium firmware driver ver 1.2
usbcore: registered new interface driver bcm203x
initcall bcm203x_init+0x0/0x54 returned 0 after 9765 usecs
calling  bfusb_init+0x0/0x55 @ 1
Bluetooth: BlueFRITZ! USB driver ver 1.2
usbcore: registered new interface driver bfusb
initcall bfusb_init+0x0/0x55 returned 0 after 9765 usecs
calling  init_dtl1_cs+0x0/0x12 @ 1
initcall init_dtl1_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_bt3c_cs+0x0/0x12 @ 1
initcall init_bt3c_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_bluecard_cs+0x0/0x12 @ 1
initcall init_bluecard_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_btuart_cs+0x0/0x12 @ 1
initcall init_btuart_cs+0x0/0x12 returned 0 after 0 usecs
calling  btusb_init+0x0/0x30 @ 1
Bluetooth: Generic Bluetooth USB driver ver 0.5
usbcore: registered new interface driver btusb
initcall btusb_init+0x0/0x30 returned 0 after 9765 usecs
calling  btsdio_init+0x0/0x27 @ 1
Bluetooth: Generic Bluetooth SDIO driver ver 0.1
initcall btsdio_init+0x0/0x27 returned 0 after 0 usecs
calling  isdn_init+0x0/0x308 @ 1
ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/none/none/1.1.2.2
initcall isdn_init+0x0/0x308 returned 0 after 9765 usecs
calling  kcapi_init+0x0/0x98 @ 1
CAPI Subsystem Rev 1.1.2.8
initcall kcapi_init+0x0/0x98 returned 0 after 9765 usecs
calling  capidrv_init+0x0/0x167 @ 1
capidrv: Rev 1.1.2.2: loaded
initcall capidrv_init+0x0/0x167 returned 0 after 9765 usecs
calling  divadidd_init+0x0/0xf4 @ 1
Eicon DIVA - DIDD table (http://www.melware.net)
divadidd: Rel:2.0  Rev:1.13.6.4  Build:102-51(local)
initcall divadidd_init+0x0/0xf4 returned 0 after 0 usecs
calling  divas_init+0x0/0x15f @ 1
Eicon DIVA Server driver (http://www.melware.net)
divas: Rel:2.0  Rev:1.55.4.6  Build: 102-52(local)
divas: support for: PRI/PCI adapters
divas: started with major 243
initcall divas_init+0x0/0x15f returned 0 after 19531 usecs
calling  divacapi_init+0x0/0xec @ 1
Eicon DIVA - CAPI Interface driver (http://www.melware.net)
divacapi: Rel:2.0  Rev:1.24  Build: 102-28(local)
initcall divacapi_init+0x0/0xec returned 0 after 9765 usecs
calling  HiSax_init+0x0/0x34f @ 1
HiSax: Linux Driver for passive ISDN cards
HiSax: Version 3.5 (kernel)
HiSax: Layer1 Revision 2.46.2.5
HiSax: Layer2 Revision 2.30.2.4
HiSax: TeiMgr Revision 2.20.2.3
HiSax: Layer3 Revision 2.22.2.3
HiSax: LinkLayer Revision 2.59.2.4
HiSax: Total 1 card defined
HiSax: Card 1 Protocol NI1 Id=HiSax (0)
Gazel: Driver Revision 2.19.2.4
Gazel: ISA PnP card automatic recognition
Gazel: Card ISA R647/R648 found
Gazel: config irq:15 isac:0x8180  cfg:0xC180
Gazel: hscx A:0x180  hscx B:0x4180
Gazel: ISAC version (ff): 2085 V2.3
Gazel: HSCX version A: ???  B: ???
Gazel: wrong HSCX versions check IO address
HiSax: Card Gazel not installed !
initcall HiSax_init+0x0/0x34f returned -19 after 175781 usecs
calling  init_sedlbauer_cs+0x0/0x12 @ 1
initcall init_sedlbauer_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_elsa_cs+0x0/0x12 @ 1
initcall init_elsa_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_avma1_cs+0x0/0x12 @ 1
initcall init_avma1_cs+0x0/0x12 returned 0 after 0 usecs
calling  init_teles_cs+0x0/0x12 @ 1
initcall init_teles_cs+0x0/0x12 returned 0 after 0 usecs
calling  st5481_usb_init+0x0/0x4c @ 1
hisax_st5481: ST5481 USB ISDN driver $Revision: 2.4.2.3 $
usbcore: registered new interface driver st5481_usb
initcall st5481_usb_init+0x0/0x4c returned 0 after 9765 usecs
calling  hfc4s8s_module_init+0x0/0x62 @ 1
HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, Revision: 1.10
HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult.de
HFC-4S/8S: found 0 cards
initcall hfc4s8s_module_init+0x0/0x62 returned 0 after 19531 usecs
calling  gigaset_init_module+0x0/0x29 @ 1
gigaset: Driver for Gigaset 307x
initcall gigaset_init_module+0x0/0x29 returned 0 after 0 usecs
calling  bas_gigaset_init+0x0/0x97 @ 1
usbcore: registered new interface driver bas_gigaset
bas_gigaset: USB Driver for Gigaset 307x
initcall bas_gigaset_init+0x0/0x97 returned 0 after 9765 usecs
calling  ser_gigaset_init+0x0/0xb2 @ 1
initcall ser_gigaset_init+0x0/0xb2 returned 0 after 0 usecs
calling  cpufreq_stats_init+0x0/0xb0 @ 1
initcall cpufreq_stats_init+0x0/0xb0 returned 0 after 0 usecs
calling  cpufreq_gov_powersave_init+0x0/0x12 @ 1
initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 0 usecs
calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0xc2 @ 1
initcall cpufreq_gov_dbs_init+0x0/0xc2 returned 0 after 0 usecs
calling  init_ladder+0x0/0x12 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 0 usecs
calling  init_menu+0x0/0x12 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x12 returned 0 after 0 usecs
calling  sdhci_drv_init+0x0/0x24 @ 1
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
initcall sdhci_drv_init+0x0/0x24 returned 0 after 9765 usecs
calling  tifm_sd_init+0x0/0x12 @ 1
initcall tifm_sd_init+0x0/0x12 returned 0 after 0 usecs
calling  memstick_init+0x0/0x85 @ 1
initcall memstick_init+0x0/0x85 returned 0 after 0 usecs
calling  mspro_block_init+0x0/0x72 @ 1
initcall mspro_block_init+0x0/0x72 returned 0 after 0 usecs
calling  tifm_ms_init+0x0/0x12 @ 1
initcall tifm_ms_init+0x0/0x12 returned 0 after 0 usecs
calling  jmb38x_ms_init+0x0/0x1b @ 1
initcall jmb38x_ms_init+0x0/0x1b returned 0 after 0 usecs
calling  alix_led_init+0x0/0xf9 @ 1
initcall alix_led_init+0x0/0xf9 returned -19 after 0 usecs
calling  pca9532_init+0x0/0x14 @ 1
i2c-core: driver [pca9532] registered
initcall pca9532_init+0x0/0x14 returned 0 after 9765 usecs
calling  da903x_led_init+0x0/0x12 @ 1
initcall da903x_led_init+0x0/0x12 returned 0 after 0 usecs
calling  timer_trig_init+0x0/0x12 @ 1
initcall timer_trig_init+0x0/0x12 returned 0 after 0 usecs
calling  heartbeat_trig_init+0x0/0x12 @ 1
initcall heartbeat_trig_init+0x0/0x12 returned 0 after 0 usecs
calling  defon_trig_init+0x0/0x12 @ 1
initcall defon_trig_init+0x0/0x12 returned 0 after 0 usecs
calling  dcdbas_init+0x0/0x67 @ 1
PM: Adding info for platform:dcdbas
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
initcall dcdbas_init+0x0/0x67 returned 0 after 9765 usecs
calling  hid_init+0x0/0x2f @ 1
initcall hid_init+0x0/0x2f returned 0 after 0 usecs
calling  a4_init+0x0/0x1b @ 1
initcall a4_init+0x0/0x1b returned 0 after 0 usecs
calling  ez_init+0x0/0x1b @ 1
initcall ez_init+0x0/0x1b returned 0 after 0 usecs
calling  gyration_init+0x0/0x1b @ 1
initcall gyration_init+0x0/0x1b returned 0 after 0 usecs
calling  ks_init+0x0/0x1b @ 1
initcall ks_init+0x0/0x1b returned 0 after 0 usecs
calling  kye_init+0x0/0x1b @ 1
initcall kye_init+0x0/0x1b returned 0 after 0 usecs
calling  lg_init+0x0/0x1b @ 1
initcall lg_init+0x0/0x1b returned 0 after 0 usecs
calling  ms_init+0x0/0x1b @ 1
initcall ms_init+0x0/0x1b returned 0 after 0 usecs
calling  mr_init+0x0/0x1b @ 1
initcall mr_init+0x0/0x1b returned 0 after 0 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 0 usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after 0 usecs
calling  samsung_init+0x0/0x1b @ 1
initcall samsung_init+0x0/0x1b returned 0 after 0 usecs
calling  sony_init+0x0/0x1b @ 1
initcall sony_init+0x0/0x1b returned 0 after 0 usecs
calling  ga_init+0x0/0x1b @ 1
initcall ga_init+0x0/0x1b returned 0 after 0 usecs
calling  tm_init+0x0/0x1b @ 1
initcall tm_init+0x0/0x1b returned 0 after 0 usecs
calling  ts_init+0x0/0x1b @ 1
initcall ts_init+0x0/0x1b returned 0 after 0 usecs
calling  zp_init+0x0/0x1b @ 1
initcall zp_init+0x0/0x1b returned 0 after 0 usecs
calling  hid_init+0x0/0xcc @ 1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
initcall hid_init+0x0/0xcc returned 0 after 19531 usecs
calling  usb_mouse_init+0x0/0x38 @ 1
usbcore: registered new interface driver usbmouse
usbmouse: v1.6:USB HID Boot Protocol mouse driver
initcall usb_mouse_init+0x0/0x38 returned 0 after 9765 usecs
calling  flow_cache_init+0x0/0x1ad @ 1
initcall flow_cache_init+0x0/0x1ad returned 0 after 0 usecs
calling  pg_init+0x0/0x346 @ 1
pktgen v2.70: Packet Generator for packet performance testing.
initcall pg_init+0x0/0x346 returned 0 after 9765 usecs
calling  llc_init+0x0/0x20 @ 1
initcall llc_init+0x0/0x20 returned 0 after 0 usecs
calling  llc2_init+0x0/0xca @ 1
NET: Registered protocol family 26
initcall llc2_init+0x0/0xca returned 0 after 0 usecs
calling  snap_init+0x0/0x38 @ 1
initcall snap_init+0x0/0x38 returned 0 after 0 usecs
calling  rif_init+0x0/0x8e @ 1
initcall rif_init+0x0/0x8e returned 0 after 0 usecs
calling  blackhole_module_init+0x0/0x12 @ 1
initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
calling  gact_init_module+0x0/0x20 @ 1
GACT probability NOT on
initcall gact_init_module+0x0/0x20 returned 0 after 0 usecs
calling  mirred_init_module+0x0/0x20 @ 1
Mirror/redirect action on
initcall mirred_init_module+0x0/0x20 returned 0 after 0 usecs
calling  nat_init_module+0x0/0x12 @ 1
initcall nat_init_module+0x0/0x12 returned 0 after 0 usecs
calling  pedit_init_module+0x0/0x12 @ 1
initcall pedit_init_module+0x0/0x12 returned 0 after 0 usecs
calling  simp_init_module+0x0/0x2f @ 1
Simple TC action Loaded
initcall simp_init_module+0x0/0x2f returned 0 after 0 usecs
calling  skbedit_init_module+0x0/0x12 @ 1
initcall skbedit_init_module+0x0/0x12 returned 0 after 0 usecs
calling  htb_module_init+0x0/0x12 @ 1
initcall htb_module_init+0x0/0x12 returned 0 after 0 usecs
calling  hfsc_init+0x0/0x12 @ 1
initcall hfsc_init+0x0/0x12 returned 0 after 0 usecs
calling  gred_module_init+0x0/0x12 @ 1
initcall gred_module_init+0x0/0x12 returned 0 after 0 usecs
calling  ingress_module_init+0x0/0x12 @ 1
initcall ingress_module_init+0x0/0x12 returned 0 after 0 usecs
calling  dsmark_module_init+0x0/0x12 @ 1
initcall dsmark_module_init+0x0/0x12 returned 0 after 0 usecs
calling  sfq_module_init+0x0/0x12 @ 1
initcall sfq_module_init+0x0/0x12 returned 0 after 0 usecs
calling  tbf_module_init+0x0/0x12 @ 1
initcall tbf_module_init+0x0/0x12 returned 0 after 0 usecs
calling  teql_init+0x0/0xd1 @ 1
PM: Adding info for No Bus:teql0
initcall teql_init+0x0/0xd1 returned 0 after 0 usecs
calling  prio_module_init+0x0/0x12 @ 1
initcall prio_module_init+0x0/0x12 returned 0 after 0 usecs
calling  netem_module_init+0x0/0x20 @ 1
netem: version 1.2
initcall netem_module_init+0x0/0x20 returned 0 after 0 usecs
calling  init_route4+0x0/0x12 @ 1
initcall init_route4+0x0/0x12 returned 0 after 0 usecs
calling  init_fw+0x0/0x12 @ 1
initcall init_fw+0x0/0x12 returned 0 after 0 usecs
calling  init_rsvp+0x0/0x12 @ 1
initcall init_rsvp+0x0/0x12 returned 0 after 0 usecs
calling  init_rsvp+0x0/0x12 @ 1
initcall init_rsvp+0x0/0x12 returned 0 after 0 usecs
calling  init_basic+0x0/0x12 @ 1
initcall init_basic+0x0/0x12 returned 0 after 0 usecs
calling  cls_flow_init+0x0/0x12 @ 1
initcall cls_flow_init+0x0/0x12 returned 0 after 0 usecs
calling  init_em_nbyte+0x0/0x12 @ 1
initcall init_em_nbyte+0x0/0x12 returned 0 after 0 usecs
calling  init_em_meta+0x0/0x12 @ 1
initcall init_em_meta+0x0/0x12 returned 0 after 0 usecs
calling  init_em_text+0x0/0x12 @ 1
initcall init_em_text+0x0/0x12 returned 0 after 0 usecs
calling  nfnetlink_init+0x0/0x5f @ 1
Netfilter messages via NETLINK v0.30.
initcall nfnetlink_init+0x0/0x5f returned 0 after 0 usecs
calling  nfnetlink_log_init+0x0/0xd5 @ 1
initcall nfnetlink_log_init+0x0/0xd5 returned 0 after 0 usecs
calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
nf_conntrack version 0.5.0 (8184 buckets, 32736 max)
initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 0 usecs
calling  ctnetlink_init+0x0/0x76 @ 1
ctnetlink v0.93: registering with nfnetlink.
initcall ctnetlink_init+0x0/0x76 returned 0 after 9765 usecs
calling  nf_conntrack_irc_init+0x0/0x1e0 @ 1
initcall nf_conntrack_irc_init+0x0/0x1e0 returned 0 after 0 usecs
calling  ip_vs_init+0x0/0xbb @ 1
IPVS: Registered protocols (UDP, AH, ESP)
IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
IPVS: Each connection entry needs 328 bytes at least
IPVS: ipvs loaded.
initcall ip_vs_init+0x0/0xbb returned 0 after 9765 usecs
calling  ip_vs_rr_init+0x0/0x12 @ 1
IPVS: [rr] scheduler registered.
initcall ip_vs_rr_init+0x0/0x12 returned 0 after 0 usecs
calling  ip_vs_wlc_init+0x0/0x12 @ 1
IPVS: [wlc] scheduler registered.
initcall ip_vs_wlc_init+0x0/0x12 returned 0 after 9765 usecs
calling  ip_vs_lblcr_init+0x0/0x47 @ 1
IPVS: [lblcr] scheduler registered.
initcall ip_vs_lblcr_init+0x0/0x47 returned 0 after 9765 usecs
calling  ip_vs_dh_init+0x0/0x12 @ 1
IPVS: [dh] scheduler registered.
initcall ip_vs_dh_init+0x0/0x12 returned 0 after 0 usecs
calling  ip_vs_sh_init+0x0/0x12 @ 1
IPVS: [sh] scheduler registered.
initcall ip_vs_sh_init+0x0/0x12 returned 0 after 0 usecs
calling  sysctl_ipv4_init+0x0/0x4e @ 1
initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 0 usecs
calling  ipgre_init+0x0/0xb3 @ 1
GRE over IPv4 tunneling driver
PM: Adding info for No Bus:gre0
initcall ipgre_init+0x0/0xb3 returned 0 after 9765 usecs
calling  ah4_init+0x0/0x68 @ 1
initcall ah4_init+0x0/0x68 returned 0 after 0 usecs
calling  xfrm4_transport_init+0x0/0x17 @ 1
initcall xfrm4_transport_init+0x0/0x17 returned 0 after 0 usecs
calling  ipv4_netfilter_init+0x0/0x12 @ 1
initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 0 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x12d @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x12d returned 0 after 0 usecs
calling  nf_defrag_init+0x0/0x17 @ 1
initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
calling  bictcp_register+0x0/0x12 @ 1
TCP bic registered
initcall bictcp_register+0x0/0x12 returned 0 after 0 usecs
calling  cubictcp_register+0x0/0x68 @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x68 returned 0 after 0 usecs
calling  tcp_westwood_register+0x0/0x12 @ 1
TCP westwood registered
initcall tcp_westwood_register+0x0/0x12 returned 0 after 0 usecs
calling  hstcp_register+0x0/0x12 @ 1
TCP highspeed registered
initcall hstcp_register+0x0/0x12 returned 0 after 0 usecs
calling  htcp_register+0x0/0x12 @ 1
TCP htcp registered
initcall htcp_register+0x0/0x12 returned 0 after 0 usecs
calling  tcp_vegas_register+0x0/0x14 @ 1
TCP vegas registered
initcall tcp_vegas_register+0x0/0x14 returned 0 after 0 usecs
calling  tcp_veno_register+0x0/0x14 @ 1
TCP veno registered
initcall tcp_veno_register+0x0/0x14 returned 0 after 9765 usecs
calling  tcp_scalable_register+0x0/0x12 @ 1
TCP scalable registered
initcall tcp_scalable_register+0x0/0x12 returned 0 after 0 usecs
calling  tcp_lp_register+0x0/0x12 @ 1
TCP lp registered
initcall tcp_lp_register+0x0/0x12 returned 0 after 0 usecs
calling  tcp_yeah_register+0x0/0x14 @ 1
TCP yeah registered
initcall tcp_yeah_register+0x0/0x14 returned 0 after 0 usecs
calling  tcp_illinois_register+0x0/0x12 @ 1
TCP illinois registered
initcall tcp_illinois_register+0x0/0x12 returned 0 after 0 usecs
calling  xfrm_user_init+0x0/0x4d @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x4d returned 0 after 0 usecs
calling  packet_init+0x0/0x47 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 0 usecs
calling  ipsec_pfkey_init+0x0/0x82 @ 1
NET: Registered protocol family 15
initcall ipsec_pfkey_init+0x0/0x82 returned 0 after 0 usecs
calling  br_init+0x0/0xc6 @ 1
initcall br_init+0x0/0xc6 returned 0 after 0 usecs
calling  trailer_init_module+0x0/0x14 @ 1
initcall trailer_init_module+0x0/0x14 returned 0 after 0 usecs
calling  mv88e6060_init+0x0/0x14 @ 1
initcall mv88e6060_init+0x0/0x14 returned 0 after 0 usecs
calling  dsa_init_module+0x0/0x12 @ 1
initcall dsa_init_module+0x0/0x12 returned 0 after 0 usecs
calling  lapb_init+0x0/0x8 @ 1
initcall lapb_init+0x0/0x8 returned 0 after 0 usecs
calling  ax25_init+0x0/0xad @ 1
NET: Registered protocol family 3
initcall ax25_init+0x0/0xad returned 0 after 9765 usecs
calling  l2cap_init+0x0/0xe4 @ 1
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
initcall l2cap_init+0x0/0xe4 returned 0 after 0 usecs
calling  rfcomm_init+0x0/0xbe @ 1
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.11
initcall rfcomm_init+0x0/0xbe returned 0 after 9765 usecs
calling  cmtp_init+0x0/0x27 @ 1
Bluetooth: CMTP (CAPI Emulation) ver 1.0
initcall cmtp_init+0x0/0x27 returned 0 after 0 usecs
calling  init_sunrpc+0x0/0x5d @ 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
initcall init_sunrpc+0x0/0x5d returned 0 after 9765 usecs
calling  init_rpcsec_gss+0x0/0x4d @ 1
initcall init_rpcsec_gss+0x0/0x4d returned 0 after 0 usecs
calling  init_kerberos_module+0x0/0x2f @ 1
initcall init_kerberos_module+0x0/0x2f returned 0 after 0 usecs
calling  init_spkm3_module+0x0/0x2f @ 1
initcall init_spkm3_module+0x0/0x2f returned 0 after 0 usecs
calling  af_rxrpc_init+0x0/0x19e @ 1
NET: Registered protocol family 33
initcall af_rxrpc_init+0x0/0x19e returned 0 after 0 usecs
calling  atm_clip_init+0x0/0xb2 @ 1
initcall atm_clip_init+0x0/0xb2 returned 0 after 0 usecs
calling  lane_module_init+0x0/0x5c @ 1
lec.c: Jun 10 2009 12:19:29 initialized
initcall lane_module_init+0x0/0x5c returned 0 after 9765 usecs
calling  atm_mpoa_init+0x0/0x39 @ 1
mpc.c: Jun 10 2009 12:19:22 initialized
initcall atm_mpoa_init+0x0/0x39 returned 0 after 9765 usecs
calling  decnet_init+0x0/0x8b @ 1
NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
DECnet: Routing cache hash table of 512 buckets, 36Kbytes
NET: Registered protocol family 12
initcall decnet_init+0x0/0x8b returned 0 after 9765 usecs
calling  econet_proto_init+0x0/0x3b @ 1
NET: Registered protocol family 19
initcall econet_proto_init+0x0/0x3b returned 0 after 0 usecs
calling  phonet_init+0x0/0x78 @ 1
NET: Registered protocol family 35
initcall phonet_init+0x0/0x78 returned 0 after 9765 usecs
calling  pep_register+0x0/0x17 @ 1
initcall pep_register+0x0/0x17 returned 0 after 0 usecs
calling  vlan_proto_init+0x0/0xc7 @ 1
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
initcall vlan_proto_init+0x0/0xc7 returned 0 after 9765 usecs
calling  sctp_init+0x0/0x7eb @ 1
SCTP: Hash tables configured (established 14563 bind 14563)
sctp_init_sock(sk: ffff88003cc18000)
initcall sctp_init+0x0/0x7eb returned 0 after 58593 usecs
calling  lib80211_init+0x0/0x20 @ 1
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
initcall lib80211_init+0x0/0x20 returned 0 after 0 usecs
calling  lib80211_crypto_wep_init+0x0/0x12 @ 1
lib80211_crypt: registered algorithm 'WEP'
initcall lib80211_crypto_wep_init+0x0/0x12 returned 0 after 9765 usecs
calling  lib80211_crypto_ccmp_init+0x0/0x12 @ 1
lib80211_crypt: registered algorithm 'CCMP'
initcall lib80211_crypto_ccmp_init+0x0/0x12 returned 0 after 0 usecs
calling  lib80211_crypto_tkip_init+0x0/0x12 @ 1
lib80211_crypt: registered algorithm 'TKIP'
initcall lib80211_crypto_tkip_init+0x0/0x12 returned 0 after 9765 usecs
calling  tipc_init+0x0/0xb6 @ 1
TIPC: Activated (version 1.6.4 compiled Jun 10 2009 12:20:13)
NET: Registered protocol family 30
TIPC: Started in single node mode
initcall tipc_init+0x0/0xb6 returned 0 after 9765 usecs
calling  rfkill_handler_init+0x0/0x45 @ 1
initcall rfkill_handler_init+0x0/0x45 returned 0 after 0 usecs
calling  powernowk8_init+0x0/0xa1 @ 1
initcall powernowk8_init+0x0/0xa1 returned -19 after 0 usecs
calling  acpi_cpufreq_init+0x0/0x119 @ 1
initcall acpi_cpufreq_init+0x0/0x119 returned 0 after 9765 usecs
calling  hpet_insert_resource+0x0/0x23 @ 1
initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x40 @ 1
initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 usecs
calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 0 usecs
calling  ioapic_insert_resources+0x0/0x58 @ 1
initcall ioapic_insert_resources+0x0/0x58 returned 0 after 0 usecs
calling  io_apic_bug_finalize+0x0/0x1b @ 1
initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x65 @ 1
initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
calling  sched_init_debug+0x0/0x24 @ 1
initcall sched_init_debug+0x0/0x24 returned 0 after 0 usecs
calling  init_oops_id+0x0/0x31 @ 1
initcall init_oops_id+0x0/0x31 returned 0 after 0 usecs
calling  disable_boot_consoles+0x0/0x3a @ 1
initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0x61 @ 1
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
initcall pm_qos_power_init+0x0/0x61 returned 0 after 9765 usecs
calling  taskstats_init+0x0/0x95 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 0 usecs
calling  failslab_debugfs_init+0x0/0x6b @ 1
initcall failslab_debugfs_init+0x0/0x6b returned 0 after 0 usecs
calling  afs_init+0x0/0x1a9 @ 1
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x1a9 returned 0 after 0 usecs
calling  fail_make_request_debugfs+0x0/0x19 @ 1
initcall fail_make_request_debugfs+0x0/0x19 returned 0 after 0 usecs
calling  random32_reseed+0x0/0xac @ 1
initcall random32_reseed+0x0/0xac returned 0 after 0 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_sysfs_init+0x0/0x4c @ 1
initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 usecs
calling  boot_wait_for_devices+0x0/0x19 @ 1
initcall boot_wait_for_devices+0x0/0x19 returned 0 after 0 usecs
calling  regulator_init_complete+0x0/0x141 @ 1
initcall regulator_init_complete+0x0/0x141 returned 0 after 0 usecs
calling  seqgen_init+0x0/0xf @ 1
initcall seqgen_init+0x0/0xf returned 0 after 0 usecs
calling  hd_init+0x0/0x314 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x314 returned -1 after 9765 usecs
initcall hd_init+0x0/0x314 returned with error code -1 
calling  scsi_complete_async_scans+0x0/0x179 @ 1
initcall scsi_complete_async_scans+0x0/0x179 returned 0 after 0 usecs
calling  memmap_init+0x0/0xa3 @ 1
initcall memmap_init+0x0/0xa3 returned 0 after 0 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x161 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x161 returned 0 after 0 usecs
calling  init_net_drop_monitor+0x0/0x15b @ 1
Initalizing network drop monitor service
initcall init_net_drop_monitor+0x0/0x15b returned 0 after 9765 usecs
calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
calling  ip_auto_config+0x0/0xde5 @ 1
initcall ip_auto_config+0x0/0xde5 returned 0 after 0 usecs
calling  initialize_hashrnd+0x0/0x19 @ 1
initcall initialize_hashrnd+0x0/0x19 returned 0 after 0 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
async_waiting @ 1
async_continuing @ 1 after 0 usec
Freeing unused kernel memory: 2596k freed
Write protecting the kernel read-only data: 16828k
Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
mount used greatest stack depth: 3024 bytes left
PM: Adding info for No Bus:hci0
PM: Removing info for No Bus:hci0
PM: Adding info for No Bus:hci0
PM: Removing info for No Bus:hci0
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.30-tip #10420
-------------------------------------------------------
S06cpuspeed/2637 is trying to acquire lock:
 (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff8106553d>] __cancel_work_timer+0xd6/0x22a

but task is already holding lock:
 (dbs_mutex){+.+.+.}, at: [<ffffffff8193d630>] cpufreq_governor_dbs+0x28f/0x335

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (dbs_mutex){+.+.+.}:
       [<ffffffff81078575>] validate_chain+0x995/0xc62
       [<ffffffff81078fc6>] __lock_acquire+0x784/0x801
       [<ffffffff8107914a>] lock_acquire+0x107/0x133
       [<ffffffff81b3940b>] mutex_lock_nested+0x60/0x36b
       [<ffffffff8193d421>] cpufreq_governor_dbs+0x80/0x335
       [<ffffffff81939c09>] __cpufreq_governor+0x67/0x6c
       [<ffffffff81939da3>] __cpufreq_set_policy+0x195/0x211
       [<ffffffff8193afc0>] cpufreq_add_dev+0x5c2/0x6ed
       [<ffffffff8143789e>] sysdev_driver_register+0xbe/0x118
       [<ffffffff81939ab0>] cpufreq_register_driver+0xbc/0x1ae
       [<ffffffff823b6f58>] acpi_cpufreq_init+0x104/0x119
       [<ffffffff8100a05c>] do_one_initcall+0x56/0x13b
       [<ffffffff823ad998>] kernel_init+0x133/0x189
       [<ffffffff8101231a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
       [<ffffffff81078575>] validate_chain+0x995/0xc62
       [<ffffffff81078fc6>] __lock_acquire+0x784/0x801
       [<ffffffff8107914a>] lock_acquire+0x107/0x133
       [<ffffffff81b3a1bd>] down_write+0x43/0x77
       [<ffffffff8193a813>] lock_policy_rwsem_write+0x48/0x79
       [<ffffffff8193d14c>] do_dbs_timer+0x44/0x299
       [<ffffffff81065d47>] worker_thread+0x225/0x33d
       [<ffffffff81068d9a>] kthread+0x56/0x84
       [<ffffffff8101231a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&(&dbs_info->work)->work){+.+...}:
       [<ffffffff81078271>] validate_chain+0x691/0xc62
       [<ffffffff81078fc6>] __lock_acquire+0x784/0x801
       [<ffffffff8107914a>] lock_acquire+0x107/0x133
       [<ffffffff81065571>] __cancel_work_timer+0x10a/0x22a
       [<ffffffff8106569e>] cancel_delayed_work_sync+0xd/0xf
       [<ffffffff8193d640>] cpufreq_governor_dbs+0x29f/0x335
       [<ffffffff81939c09>] __cpufreq_governor+0x67/0x6c
       [<ffffffff81939d8d>] __cpufreq_set_policy+0x17f/0x211
       [<ffffffff8193a31a>] store_scaling_governor+0x14e/0x18c
       [<ffffffff8193b143>] store+0x58/0x7b
       [<ffffffff8111d49a>] sysfs_write_file+0xe4/0x119
       [<ffffffff810cc6dc>] vfs_write+0xab/0x10a
       [<ffffffff810ccb66>] sys_write+0x47/0x6f
       [<ffffffff81011142>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

3 locks held by S06cpuspeed/2637:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8111d3ee>] sysfs_write_file+0x38/0x119
 #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff8193a813>] lock_policy_rwsem_write+0x48/0x79
 #2:  (dbs_mutex){+.+.+.}, at: [<ffffffff8193d630>] cpufreq_governor_dbs+0x28f/0x335

stack backtrace:
Pid: 2637, comm: S06cpuspeed Not tainted 2.6.30-tip #10420
Call Trace:
 [<ffffffff81077ab8>] print_circular_bug_tail+0xc3/0xce
 [<ffffffff81078271>] validate_chain+0x691/0xc62
 [<ffffffff810748e6>] ? get_lock_stats+0x19/0x4c
 [<ffffffff81078fc6>] __lock_acquire+0x784/0x801
 [<ffffffff8107914a>] lock_acquire+0x107/0x133
 [<ffffffff8106553d>] ? __cancel_work_timer+0xd6/0x22a
 [<ffffffff81065571>] __cancel_work_timer+0x10a/0x22a
 [<ffffffff8106553d>] ? __cancel_work_timer+0xd6/0x22a
 [<ffffffff8193d630>] ? cpufreq_governor_dbs+0x28f/0x335
 [<ffffffff810761d2>] ? mark_held_locks+0x49/0x67
 [<ffffffff81b396bc>] ? mutex_lock_nested+0x311/0x36b
 [<ffffffff81076308>] ? trace_hardirqs_on_caller+0x118/0x143
 [<ffffffff8107400c>] ? debug_mutex_free_waiter+0x4f/0x53
 [<ffffffff81b396f0>] ? mutex_lock_nested+0x345/0x36b
 [<ffffffff8193d630>] ? cpufreq_governor_dbs+0x28f/0x335
 [<ffffffff8106569e>] cancel_delayed_work_sync+0xd/0xf
 [<ffffffff8193d640>] cpufreq_governor_dbs+0x29f/0x335
 [<ffffffff8106c52e>] ? up_read+0x26/0x2a
 [<ffffffff8106cfa6>] ? __blocking_notifier_call_chain+0x5e/0x70
 [<ffffffff81939c09>] __cpufreq_governor+0x67/0x6c
 [<ffffffff81939d8d>] __cpufreq_set_policy+0x17f/0x211
 [<ffffffff8193a31a>] store_scaling_governor+0x14e/0x18c
 [<ffffffff8193a96a>] ? handle_update+0x0/0x34
 [<ffffffff8193a800>] ? lock_policy_rwsem_write+0x35/0x79
 [<ffffffff8193b143>] store+0x58/0x7b
 [<ffffffff8111d49a>] sysfs_write_file+0xe4/0x119
 [<ffffffff810cc6dc>] vfs_write+0xab/0x10a
 [<ffffffff810ccb66>] sys_write+0x47/0x6f
 [<ffffffff81011142>] system_call_fastpath+0x16/0x1b
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs11
PM: Adding info for No Bus:vcsa11
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30
# Wed Jun 10 13:06:17 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
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
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
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
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
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
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
# CONFIG_STRIP_ASM_SYMS is not set
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
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_PCI_QUIRKS is not set
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
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
# CONFIG_X86_X2APIC is not set
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_MEMTEST is not set
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
CONFIG_X86_INTERNODE_CACHE_BYTES=4096
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_NEW_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_X86_CPU_DEBUG is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
# CONFIG_X86_64_ACPI_NUMA is not set
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=9
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
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_MIGRATION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_HAVE_MLOCK=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_EFI=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_PCI_SLOT=y
# CONFIG_X86_PM_TIMER is not set
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
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
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
# CONFIG_DMAR_GFX_WA is not set
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

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
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
CONFIG_DEFAULT_WESTWOOD=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="westwood"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CONNTRACK_FTP is not set
CONFIG_NF_CONNTRACK_IRC=y
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CT_NETLINK=y
# CONFIG_NETFILTER_XTABLES is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=y
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
# CONFIG_IP_VS_NQ is not set

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
# CONFIG_ATM_BR2684 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
# CONFIG_ECONET_NATIVE is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=y
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
# CONFIG_BPQETHER is not set
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_BAYCOM_PAR is not set
CONFIG_YAM=y
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
CONFIG_BT_CMTP=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
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
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_XEN_BLKDEV_FRONTEND is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
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
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
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
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
CONFIG_SCSI_IZIP_SLOW_CTR=y
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=y
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=y
CONFIG_PATA_NS87415=y
CONFIG_PATA_OPTI=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_SCH=y
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=y
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
# CONFIG_IEEE1394_PCILYNX is not set
# CONFIG_IEEE1394_SBP2 is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
# CONFIG_IEEE1394_VIDEO1394 is not set
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_COMPAT_NET_DEV_OPS is not set
CONFIG_IFB=y
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_NET_SB1000=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_ETHOC=y
CONFIG_DNET=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
CONFIG_PCMCIA_XIRCOM=y
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
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=y
CONFIG_SIS900=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC9420=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
# CONFIG_ATP is not set
CONFIG_DE600=y
CONFIG_DE620=y
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=y
CONFIG_IGBVF=y
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
CONFIG_R8169=y
CONFIG_R8169_VLAN=y
CONFIG_SIS190=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_QLA3XXX=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_JME=y
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
CONFIG_ENIC=y
# CONFIG_IXGBE is not set
CONFIG_IXGB=y
CONFIG_S2IO=y
CONFIG_MYRI10GE=y
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_TEHUTI=y
CONFIG_BNX2X=y
CONFIG_QLGE=y
CONFIG_SFC=y
# CONFIG_BE2NET is not set
CONFIG_TR=y
CONFIG_IBMOL=y
CONFIG_3C359=y
CONFIG_TMS380TR=y
CONFIG_TMSPCI=y
CONFIG_ABYSS=y

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=y
CONFIG_PCMCIA_WAVELAN=y
# CONFIG_PCMCIA_NETWAVE is not set
CONFIG_WLAN_80211=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
CONFIG_LIBERTAS_CS=y
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=y
CONFIG_ATMEL=y
# CONFIG_PCI_ATMEL is not set
# CONFIG_PCMCIA_ATMEL is not set
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
# CONFIG_USB_NET_RNDIS_WLAN is not set
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=y
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
# CONFIG_IPW2200_QOS is not set
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
CONFIG_HOSTAP_CS=y
CONFIG_HERMES=y
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_PLX_HERMES is not set
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCI_HERMES=y
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_HSO is not set
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_PCMCIA_PCNET=y
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_PCMCIA_AXNET=y
# CONFIG_ARCNET_COM20020_CS is not set
CONFIG_PCMCIA_IBMTR=y
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set
CONFIG_HDLC_X25=y
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
# CONFIG_DLCI is not set
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_IDT77252 is not set
CONFIG_ATM_AMBASSADOR=y
CONFIG_ATM_AMBASSADOR_DEBUG=y
# CONFIG_ATM_HORIZON is not set
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=y
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=y
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
# CONFIG_PPPOATM is not set
CONFIG_PPPOL2TP=y
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_PPP is not set
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
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_S0BOX=y
# CONFIG_HISAX_FRITZPCI is not set
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_DIEHLDIVA is not set
CONFIG_HISAX_SEDLBAUER=y
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_SX=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=y
CONFIG_HISAX_ELSA_CS=y
CONFIG_HISAX_AVM_A1_CS=y
CONFIG_HISAX_TELES_CS=y

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
CONFIG_GIGASET_BASE=y
# CONFIG_GIGASET_M105 is not set
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_GIGASET_UNDOCREQ is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
# CONFIG_ISDN_CAPI_CAPI20 is not set
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=y
# CONFIG_ISDN_DIVAS_BRIPCI is not set
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=y
# CONFIG_ISDN_DIVAS_USERIDI is not set
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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
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
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
CONFIG_RIO=y
CONFIG_RIO_OLDPCI=y
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
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
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_HVC_XEN is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=y

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_PCF8574=y
CONFIG_PCF8575=y
CONFIG_SENSORS_PCA9539=y
CONFIG_SENSORS_MAX6875=y
CONFIG_SENSORS_TSL2550=y
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
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_DA9030=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
CONFIG_SC520_WDT=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
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
# CONFIG_USBPCWATCHDOG is not set
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
CONFIG_SSB_PCMCIAHOST=y
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
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_REGULATOR_TWL4030 is not set
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
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DAB=y
CONFIG_USB_DABUSB=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
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
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_MBP_NVIDIA=y
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
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
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
# CONFIG_HID_NTRIG is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_GREENASIA_FF=y
CONFIG_HID_TOPSEED=y
CONFIG_THRUSTMASTER_FF=y
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
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_CS is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_GARMIN=y
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_WLP=y
CONFIG_UWB_I1480U=y
CONFIG_UWB_I1480U_WLP=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_SDRICOH_CS is not set
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
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_ALIX2=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_SMX=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y

#
# Caches
#
# CONFIG_FSCACHE is not set

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
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
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
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=y
CONFIG_SMB_FS=y
# CONFIG_SMB_NLS_DEFAULT is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ALLOW_WARNINGS=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
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
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
# CONFIG_KGDB_SERIAL_CONSOLE is not set
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_IOMMU_STRESS=y
CONFIG_X86_DS_SELFTEST=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
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
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_TOMOYO=y
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
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
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
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
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
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y

--gatW/ieO32f1wygP--
