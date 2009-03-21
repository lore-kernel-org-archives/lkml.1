Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZCUQ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZCUQ6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZCUQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:58:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZCUQ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:58:30 -0400
Date: Sat, 21 Mar 2009 17:58:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090321165804.GA21366@elte.hu>
References: <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20090321100129.GC7201@elte.hu>
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


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Fri, 20 Mar 2009, Frederic Weisbecker wrote:
> > > > >  
> > > > >  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> > > > > -	set_user_nice(current, 19);
> > > > > +	set_user_nice(current, -1);
> > > > >  	if (irqreader && cur_ops->irqcapable)
> > > > >  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
> > > > 
> > > > i dont have a reproducer right now. Can you trigger it with latest 
> > > > -tip, which has this commit included:
> > > > 
> > > > 04cb9ac: rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to o
> > > > 
> > > > ?
> > > > 
> > > > 	Ingo
> > > 
> > > 
> > > I tested three times the same things but with 04cb9ac and... it didn't triggered
> > > anymore :-)
> > 
> > So lets hope that was the culprit.
> > 
> > Great work Frederic!
> 
> No new lockups of this nature in overnight -tip testing. It's 
> still a bit too early to tell for sure but it's promising ;-)

just got a lockup again :-/ It hangs here:

calling  init_mmio_trace+0x0/0x12 @ 1
initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
calling  init_graph_trace+0x0/0x12 @ 1
Testing tracer function_graph: 

and this time i got good stackdumps as well - see below. Config 
attached.

	Ingo

Linux version 2.6.29-rc8-tip-02752-g47b1aea-dirty (mingo@titan) (gcc version 4.2.3) #3264 SMP PREEMPT Sat Mar 21 11:01:24 CET 2009
Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi no_hz=off highres=0 nolapic_timer hpet=disable nopat notsc pci=nomsi
KERNEL supported cpus:
  Centaur CentaurHauls
CPU: vendor_id 'GenuineIntel' unknown, using generic init.
CPU: Your system may be unstable.
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
PAT support disabled.
DMI 2.3 present.
last_pfn = 0x3ff00 max_arch_pfn = 0x100000000
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
  get_mtrr: cpu0 reg00 base=0000000000 size=0000040000 write-back
  get_mtrr: cpu0 reg01 base=000003ff00 size=0000000100 uncachable
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
init_memory_mapping: 0000000000000000-000000003ff00000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ff00000 page 4k
kernel direct mapping tables up to 3ff00000 @ 8000-b000
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 3FEFDE48, 0050 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACP 3FEFCF10, 0074 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3FEF8010, 3E70 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACS 3FEDFC40, 0040
ACPI: APIC 3FEFCE10, 0078 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: WDDT 3FEF7F90, 0040 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: MCFG 3FEF7F10, 003C (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: ASF! 3FEFCD10, 00A6 (r32 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: HPET 3FEF7E90, 0038 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: SSDT 3FEFDC10, 01BC (r1 INTEL     CpuPm      4B9 MSFT  1000013)
ACPI: SSDT 3FEFDA10, 01B7 (r1 INTEL   Cpu0Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD810, 01B7 (r1 INTEL   Cpu1Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD610, 01B7 (r1 INTEL   Cpu2Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD410, 01B7 (r1 INTEL   Cpu3Ist      4B9 MSFT  1000013)
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 003ff00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00015d9448]    TEXT DATA BSS ==> [0000200000 - 00015d9448]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [00015da000 - 00015da22c]              BRK ==> [00015da000 - 00015da22c]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000fe680] fe680
  mpc: fe690-fe6d0
 [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff880001800000-ffff8800025fffff] on node 0
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
  DMA zone: 56 pages used for memmap
  DMA zone: 100 pages reserved
  DMA zone: 3838 pages, LIFO batch:0
  DMA32 zone: 3525 pages used for memmap
  DMA32 zone: 253992 pages, LIFO batch:31
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
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
Allocating PCI resources starting at 40000000 (gap: 3ff00000:c0100000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 28 pages at ffff88000160e000, static data 82080 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257830
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi no_hz=off highres=0 nolapic_timer hpet=disable nopat notsc pci=nomsi
debug: sysrq always enabled.
notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
Initializing CPU#0
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:4352 nr_irqs:440
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2933.375 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 1008464k/1047552k available (8242k kernel code, 1508k absent, 36928k reserved, 8645k data, 564k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Calibrating delay loop... 5816.32 BogoMIPS (lpj=2908160)
Security Framework initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 0K (0 bytes/line), D cache 0K (0 bytes/line)
CPU: L2 Cache: 4096K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Freeing SMP alternatives: 26k freed
ACPI: Core revision 20081204
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
CPU0: GenuineIntel Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
Disabling APIC timer
calling  migration_init+0x0/0x88 @ 1
initcall migration_init+0x0/0x88 returned 1 after 0 usecs
initcall migration_init+0x0/0x88 returned with error code 1 
calling  spawn_ksoftirqd+0x0/0x7a @ 1
initcall spawn_ksoftirqd+0x0/0x7a returned 0 after 0 usecs
calling  init_call_single_data+0x0/0x89 @ 1
initcall init_call_single_data+0x0/0x89 returned 0 after 0 usecs
calling  relay_init+0x0/0x8 @ 1
initcall relay_init+0x0/0x8 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x24d @ 1
Testing tracer nop: PASSED
initcall tracer_alloc_buffers+0x0/0x24d returned 0 after 976 usecs
calling  init_trace_printk+0x0/0x12 @ 1
initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
calling  trace_workqueue_early_init+0x0/0x121 @ 1
initcall trace_workqueue_early_init+0x0/0x121 returned 0 after 0 usecs
calling  perf_counter_init+0x0/0x30 @ 1
initcall perf_counter_init+0x0/0x30 returned 0 after 0 usecs
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay loop... 5849.08 BogoMIPS (lpj=2924544)
CPU: L1 I Cache: 0K (0 bytes/line), D cache 0K (0 bytes/line)
CPU: L2 Cache: 4096K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: GenuineIntel Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
Brought up 2 CPUs
Total of 2 processors activated (11665.40 BogoMIPS).
calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
calling  net_ns_init+0x0/0xce @ 1
net_namespace: 1400 bytes
initcall net_ns_init+0x0/0xce returned 0 after 976 usecs
calling  cpufreq_tsc+0x0/0x53 @ 1
initcall cpufreq_tsc+0x0/0x53 returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x2d @ 1
initcall init_smp_flush+0x0/0x2d returned 0 after 0 usecs
calling  sysctl_init+0x0/0x32 @ 1
initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x137 @ 1
initcall ksysfs_init+0x0/0x137 returned 0 after 0 usecs
calling  async_init+0x0/0x94 @ 1
initcall async_init+0x0/0x94 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
calling  pm_init+0x0/0x46 @ 1
initcall pm_init+0x0/0x46 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x63 @ 1
initcall init_misc_binfmt+0x0/0x63 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x12 @ 1
initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x12 @ 1
initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x12 @ 1
initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x75 @ 1
initcall debugfs_init+0x0/0x75 returned 0 after 0 usecs
calling  securityfs_init+0x0/0x75 @ 1
initcall securityfs_init+0x0/0x75 returned 0 after 0 usecs
calling  random32_init+0x0/0xc2 @ 1
initcall random32_init+0x0/0xc2 returned 0 after 0 usecs
calling  cpufreq_core_init+0x0/0x79 @ 1
initcall cpufreq_core_init+0x0/0x79 returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x48 @ 1
initcall cpuidle_init+0x0/0x48 returned 0 after 0 usecs
calling  virtio_init+0x0/0x3d @ 1
initcall virtio_init+0x0/0x3d returned 0 after 976 usecs
calling  sock_init+0x0/0x38 @ 1
initcall sock_init+0x0/0x38 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x14 @ 1
initcall netpoll_init+0x0/0x14 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x198 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x198 returned 0 after 976 usecs
calling  bdi_class_init+0x0/0x31 @ 1
initcall bdi_class_init+0x0/0x31 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x55 @ 1
initcall kobject_uevent_init+0x0/0x55 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x78 @ 1
initcall backlight_class_init+0x0/0x78 returned 0 after 0 usecs
calling  video_output_class_init+0x0/0x19 @ 1
initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
calling  tty_class_init+0x0/0x49 @ 1
initcall tty_class_init+0x0/0x49 returned 0 after 976 usecs
calling  vtconsole_class_init+0x0/0x10e @ 1
initcall vtconsole_class_init+0x0/0x10e returned 0 after 0 usecs
calling  spi_init+0x0/0xe2 @ 1
initcall spi_init+0x0/0xe2 returned 0 after 0 usecs
calling  i2c_init+0x0/0x9e @ 1
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x9e returned 0 after 976 usecs
calling  amd_postcore_init+0x0/0x2d @ 1
initcall amd_postcore_init+0x0/0x2d returned 0 after 0 usecs
calling  arch_kdebugfs_init+0x0/0x34 @ 1
initcall arch_kdebugfs_init+0x0/0x34 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x94 @ 1
initcall mtrr_if_init+0x0/0x94 returned 0 after 0 usecs
calling  uv_rtc_setup_clock+0x0/0x14b @ 1
initcall uv_rtc_setup_clock+0x0/0x14b returned -19 after 0 usecs
calling  acpi_pci_init+0x0/0x94 @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x94 returned 0 after 976 usecs
calling  init_acpi_device_notify+0x0/0x71 @ 1
initcall init_acpi_device_notify+0x0/0x71 returned 0 after 0 usecs
calling  dma_bus_init+0x0/0x3f @ 1
initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
calling  dma_channel_table_init+0x0/0x104 @ 1
initcall dma_channel_table_init+0x0/0x104 returned 0 after 0 usecs
calling  dca_init+0x0/0x20 @ 1
dca service started, version 1.8
initcall dca_init+0x0/0x20 returned 0 after 976 usecs
calling  pci_arch_init+0x0/0x80 @ 1
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x80 returned 0 after 2929 usecs
calling  topology_init+0x0/0x35 @ 1
initcall topology_init+0x0/0x35 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x78 @ 1
initcall mtrr_init_finialize+0x0/0x78 returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x6b @ 1
initcall param_sysfs_init+0x0/0x6b returned 0 after 10740 usecs
calling  pm_sysrq_init+0x0/0x1e @ 1
initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 usecs
calling  readahead_init+0x0/0x4a @ 1
initcall readahead_init+0x0/0x4a returned 0 after 0 usecs
calling  init_bio+0x0/0xbc @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xbc returned 0 after 976 usecs
calling  cryptomgr_init+0x0/0x59 @ 1
initcall cryptomgr_init+0x0/0x59 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x5a @ 1
initcall blk_softirq_init+0x0/0x5a returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x8c @ 1
initcall genhd_device_init+0x0/0x8c returned 0 after 0 usecs
calling  gpiolib_debugfs_init+0x0/0x24 @ 1
initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x5a @ 1
initcall pci_slot_init+0x0/0x5a returned 0 after 0 usecs
calling  fbmem_init+0x0/0xbb @ 1
initcall fbmem_init+0x0/0xbb returned 0 after 0 usecs
calling  acpi_init+0x0/0x14f @ 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
initcall acpi_init+0x0/0x14f returned 0 after 21481 usecs
calling  acpi_scan_init+0x0/0xff @ 1
initcall acpi_scan_init+0x0/0xff returned 0 after 6882 usecs
calling  acpi_ec_init+0x0/0x95 @ 1
initcall acpi_ec_init+0x0/0x95 returned 0 after 0 usecs
calling  acpi_pci_root_init+0x0/0x48 @ 1
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0x50404400-0x504047ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
pci 0000:00:1f.2: reg 24 32bit mmio: [0x50404000-0x504043ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x4000-0x401f]
pci 0000:01:00.0: reg 10 64bit mmio: [0x40000000-0x4fffffff]
pci 0000:01:00.0: reg 18 64bit mmio: [0x50300000-0x5030ffff]
pci 0000:01:00.0: reg 20 io port: [0x3000-0x30ff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 64bit mmio: [0x50310000-0x5031ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x4fffffff]
pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x502fffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0x50100000-0x5011ffff]
pci 0000:04:00.0: reg 18 io port: [0x2000-0x201f]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.5: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.5: bridge 32bit mmio: [0x50100000-0x501fffff]
pci 0000:05:02.0: reg 10 32bit mmio: [0x50000000-0x50007fff]
pci 0000:05:04.0: reg 10 32bit mmio: [0x5000c000-0x5000c7ff]
pci 0000:05:04.0: reg 14 32bit mmio: [0x50008000-0x5000bfff]
pci 0000:05:04.0: supports D1 D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
pci 0000:05:05.0: reg 10 io port: [0x1018-0x101f]
pci 0000:05:05.0: reg 14 io port: [0x1024-0x1027]
pci 0000:05:05.0: reg 18 io port: [0x1010-0x1017]
pci 0000:05:05.0: reg 1c io port: [0x1020-0x1023]
pci 0000:05:05.0: reg 20 io port: [0x1000-0x100f]
pci 0000:05:05.0: reg 24 32bit mmio: [0x5000c800-0x5000cbff]
pci 0000:05:05.0: reg 30 32bit mmio: [0xfff80000-0xffffffff]
pci 0000:05:05.0: supports D1 D2
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0x50000000-0x500fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
initcall acpi_pci_root_init+0x0/0x48 returned 0 after 86914 usecs
calling  acpi_pci_link_init+0x0/0xa0 @ 1
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
initcall acpi_pci_link_init+0x0/0xa0 returned 0 after 25390 usecs
calling  acpi_power_init+0x0/0xab @ 1
initcall acpi_power_init+0x0/0xab returned 0 after 0 usecs
calling  acpi_system_init+0x0/0x49 @ 1
initcall acpi_system_init+0x0/0x49 returned 0 after 0 usecs
calling  pnp_init+0x0/0x12 @ 1
initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
calling  misc_init+0x0/0xc7 @ 1
initcall misc_init+0x0/0xc7 returned 0 after 0 usecs
calling  phy_init+0x0/0x55 @ 1
initcall phy_init+0x0/0x55 returned 0 after 0 usecs
calling  init_scsi+0x0/0x107 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x107 returned 0 after 1953 usecs
calling  ata_init+0x0/0xa7 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0xa7 returned 0 after 976 usecs
calling  usb_init+0x0/0x1ee @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x1ee returned 0 after 2929 usecs
calling  serio_init+0x0/0xcd @ 1
initcall serio_init+0x0/0xcd returned 0 after 0 usecs
calling  gameport_init+0x0/0xcc @ 1
initcall gameport_init+0x0/0xcc returned 0 after 0 usecs
calling  input_init+0x0/0xc0 @ 1
initcall input_init+0x0/0xc0 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x52 @ 1
initcall power_supply_class_init+0x0/0x52 returned 0 after 0 usecs
calling  hwmon_init+0x0/0x55 @ 1
initcall hwmon_init+0x0/0x55 returned 0 after 976 usecs
calling  thermal_init+0x0/0x52 @ 1
initcall thermal_init+0x0/0x52 returned 0 after 976 usecs
calling  leds_init+0x0/0x5a @ 1
initcall leds_init+0x0/0x5a returned 0 after 976 usecs
calling  pci_subsys_init+0x0/0x1c @ 1
PCI: Using ACPI for IRQ routing
initcall pci_subsys_init+0x0/0x1c returned 0 after 976 usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x1cb @ 1
initcall net_dev_init+0x0/0x1cb returned 0 after 0 usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xc6 @ 1
initcall fib_rules_init+0x0/0xc6 returned 0 after 0 usecs
calling  genl_init+0x0/0x121 @ 1
initcall genl_init+0x0/0x121 returned 0 after 3906 usecs
calling  cipso_v4_init+0x0/0x33 @ 1
initcall cipso_v4_init+0x0/0x33 returned 0 after 0 usecs
calling  wanrouter_init+0x0/0x67 @ 1
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x67 returned 0 after 976 usecs
calling  wireless_nlevent_init+0x0/0x14 @ 1
initcall wireless_nlevent_init+0x0/0x14 returned 0 after 0 usecs
calling  netlbl_init+0x0/0xd3 @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0xd3 returned 0 after 3906 usecs
calling  rfkill_init+0x0/0x8c @ 1
initcall rfkill_init+0x0/0x8c returned 0 after 0 usecs
calling  sysctl_init+0x0/0x5b @ 1
initcall sysctl_init+0x0/0x5b returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x21 @ 1
initcall pci_iommu_init+0x0/0x21 returned 0 after 0 usecs
calling  print_all_ICs+0x0/0x17 @ 1

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
... APIC LVTPC: 00010000
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
... APIC LVTPC: 00010000
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
initcall print_all_ICs+0x0/0x17 returned 0 after 207031 usecs
calling  hpet_late_init+0x0/0x100 @ 1
initcall hpet_late_init+0x0/0x100 returned -19 after 0 usecs
calling  init_kmmio+0x0/0x2c @ 1
initcall init_kmmio+0x0/0x2c returned 0 after 0 usecs
calling  clocksource_done_booting+0x0/0x12 @ 1
initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
calling  ftrace_init_debugfs+0x0/0x69 @ 1
initcall ftrace_init_debugfs+0x0/0x69 returned 0 after 0 usecs
calling  rb_init_debugfs+0x0/0x54 @ 1
initcall rb_init_debugfs+0x0/0x54 returned 0 after 0 usecs
calling  tracer_init_debugfs+0x0/0x383 @ 1
initcall tracer_init_debugfs+0x0/0x383 returned 0 after 0 usecs
calling  init_trace_printk_function_export+0x0/0x69 @ 1
initcall init_trace_printk_function_export+0x0/0x69 returned 0 after 0 usecs
calling  all_annotated_branch_stats+0x0/0x3b @ 1
Warning: could not register all branches stats
initcall all_annotated_branch_stats+0x0/0x3b returned 1 after 976 usecs
initcall all_annotated_branch_stats+0x0/0x3b returned with error code 1 
calling  init_annotated_branch_stats+0x0/0x3b @ 1
Warning: could not register annotated branches stats
initcall init_annotated_branch_stats+0x0/0x3b returned 1 after 976 usecs
initcall init_annotated_branch_stats+0x0/0x3b returned with error code 1 
calling  stat_workqueue_init+0x0/0x3b @ 1
initcall stat_workqueue_init+0x0/0x3b returned 0 after 0 usecs
calling  event_trace_init+0x0/0x117 @ 1
initcall event_trace_init+0x0/0x117 returned 0 after 0 usecs
calling  init_pipe_fs+0x0/0x7a @ 1
initcall init_pipe_fs+0x0/0x7a returned 0 after 0 usecs
calling  init_mnt_writers+0x0/0x50 @ 1
initcall init_mnt_writers+0x0/0x50 returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xa4 @ 1
initcall eventpoll_init+0x0/0xa4 returned 0 after 0 usecs
calling  anon_inode_init+0x0/0xcc @ 1
initcall anon_inode_init+0x0/0xcc returned 0 after 0 usecs
calling  acpi_event_init+0x0/0x4c @ 1
initcall acpi_event_init+0x0/0x4c returned 0 after 3906 usecs
calling  pnpacpi_init+0x0/0xa3 @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0xa3 returned 0 after 13671 usecs
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
initcall pnp_system_init+0x0/0x12 returned 0 after 12695 usecs
calling  chr_dev_init+0x0/0xcf @ 1
initcall chr_dev_init+0x0/0xcf returned 0 after 0 usecs
calling  firmware_class_init+0x0/0x9d @ 1
initcall firmware_class_init+0x0/0x9d returned 0 after 0 usecs
calling  ieee1394_init+0x0/0x33f @ 1
initcall ieee1394_init+0x0/0x33f returned 0 after 0 usecs
calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
calling  ssb_modinit+0x0/0x71 @ 1
initcall ssb_modinit+0x0/0x71 returned 0 after 0 usecs
calling  pcibios_assign_resources+0x0/0xd5 @ 1
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
  alloc irq_desc for 16 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 17 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
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
pci_bus 0000:01: resource 2 mem: [0x40000000-0x4fffffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 mem: [0x0-0x0]
pci_bus 0000:02: resource 1 mem: [0x50200000-0x502fffff]
pci_bus 0000:02: resource 2 mem: [0x0-0x0]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 mem: [0x0-0x0]
pci_bus 0000:03: resource 1 mem: [0x0-0x0]
pci_bus 0000:03: resource 2 mem: [0x0-0x0]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:04: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:04: resource 1 mem: [0x50100000-0x501fffff]
pci_bus 0000:04: resource 2 mem: [0x0-0x0]
pci_bus 0000:04: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 io:  [0x1000-0x1fff]
pci_bus 0000:05: resource 1 mem: [0x50000000-0x500fffff]
pci_bus 0000:05: resource 2 mem: [0x0-0x0]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
initcall pcibios_assign_resources+0x0/0xd5 returned 0 after 54687 usecs
calling  sysctl_core_init+0x0/0x38 @ 1
initcall sysctl_core_init+0x0/0x38 returned 0 after 0 usecs
calling  inet_init+0x0/0x212 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
IPv4 FIB: Using LC-trie version 0.408
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x212 returned 0 after 23437 usecs
calling  af_unix_init+0x0/0x67 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x67 returned 0 after 976 usecs
calling  default_rootfs+0x0/0xa2 @ 1
initcall default_rootfs+0x0/0xa2 returned 0 after 0 usecs
calling  calgary_fixup_tce_spaces+0x0/0xff @ 1
initcall calgary_fixup_tce_spaces+0x0/0xff returned -19 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x3a @ 1
initcall i8259A_init_sysfs+0x0/0x3a returned 0 after 0 usecs
calling  vsyscall_init+0x0/0x60 @ 1
initcall vsyscall_init+0x0/0x60 returned 0 after 0 usecs
calling  sbf_init+0x0/0x6e @ 1
initcall sbf_init+0x0/0x6e returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x3a @ 1
initcall i8237A_init_sysfs+0x0/0x3a returned 0 after 0 usecs
calling  add_rtc_cmos+0x0/0xb9 @ 1
initcall add_rtc_cmos+0x0/0xb9 returned 0 after 0 usecs
calling  cache_sysfs_init+0x0/0x78 @ 1
initcall cache_sysfs_init+0x0/0x78 returned 0 after 0 usecs
calling  mce_init_device+0x0/0xd2 @ 1
initcall mce_init_device+0x0/0xd2 returned 0 after 976 usecs
calling  periodic_mcheck_init+0x0/0x14 @ 1
initcall periodic_mcheck_init+0x0/0x14 returned 0 after 0 usecs
calling  thermal_throttle_init_device+0x0/0xb7 @ 1
initcall thermal_throttle_init_device+0x0/0xb7 returned 0 after 0 usecs
calling  threshold_init_device+0x0/0x5a @ 1
initcall threshold_init_device+0x0/0x5a returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x5c @ 1
initcall init_lapic_sysfs+0x0/0x5c returned 0 after 0 usecs
calling  ioapic_init_sysfs+0x0/0xdb @ 1
initcall ioapic_init_sysfs+0x0/0xdb returned 0 after 0 usecs
calling  add_pcspkr+0x0/0x36 @ 1
initcall add_pcspkr+0x0/0x36 returned 0 after 0 usecs
calling  microcode_init+0x0/0x150 @ 1
microcode: no support for this CPU vendor
initcall microcode_init+0x0/0x150 returned -19 after 976 usecs
calling  start_periodic_check_for_corruption+0x0/0x58 @ 1
Scanning for low memory corruption every 60 seconds
initcall start_periodic_check_for_corruption+0x0/0x58 returned 0 after 976 usecs
calling  uv_ptc_init+0x0/0x76 @ 1
initcall uv_ptc_init+0x0/0x76 returned 0 after 0 usecs
calling  uv_bau_init+0x0/0x133 @ 1
initcall uv_bau_init+0x0/0x133 returned 0 after 0 usecs
calling  sgi_uv_sysfs_init+0x0/0xe0 @ 1
initcall sgi_uv_sysfs_init+0x0/0xe0 returned 0 after 0 usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after 0 usecs
calling  init+0x0/0x12 @ 1
initcall init+0x0/0x12 returned 0 after 0 usecs
calling  crc32c_intel_mod_init+0x0/0x34 @ 1
initcall crc32c_intel_mod_init+0x0/0x34 returned -19 after 0 usecs
calling  init_vdso_vars+0x0/0x202 @ 1
initcall init_vdso_vars+0x0/0x202 returned 0 after 0 usecs
calling  ia32_binfmt_init+0x0/0x14 @ 1
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 usecs
calling  sysenter_setup+0x0/0xd0 @ 1
initcall sysenter_setup+0x0/0xd0 returned 0 after 0 usecs
calling  proc_execdomains_init+0x0/0x1f @ 1
initcall proc_execdomains_init+0x0/0x1f returned 0 after 0 usecs
calling  ioresources_init+0x0/0x36 @ 1
initcall ioresources_init+0x0/0x36 returned 0 after 0 usecs
calling  uid_cache_init+0x0/0x6e @ 1
initcall uid_cache_init+0x0/0x6e returned 0 after 0 usecs
calling  init_posix_timers+0x0/0x108 @ 1
initcall init_posix_timers+0x0/0x108 returned 0 after 0 usecs
calling  init_posix_cpu_timers+0x0/0xd4 @ 1
initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x3a @ 1
initcall timekeeping_init_device+0x0/0x3a returned 0 after 0 usecs
calling  init_clocksource_sysfs+0x0/0x90 @ 1
initcall init_clocksource_sysfs+0x0/0x90 returned 0 after 0 usecs
calling  init_timer_list_procfs+0x0/0x39 @ 1
initcall init_timer_list_procfs+0x0/0x39 returned 0 after 0 usecs
calling  futex_init+0x0/0x81 @ 1
initcall futex_init+0x0/0x81 returned 0 after 0 usecs
calling  proc_dma_init+0x0/0x1f @ 1
initcall proc_dma_init+0x0/0x1f returned 0 after 0 usecs
calling  proc_modules_init+0x0/0x1f @ 1
initcall proc_modules_init+0x0/0x1f returned 0 after 0 usecs
calling  kallsyms_init+0x0/0x22 @ 1
initcall kallsyms_init+0x0/0x22 returned 0 after 0 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x4a0 @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x4a0 returned 0 after 0 usecs
calling  crash_notes_memory_init+0x0/0x46 @ 1
initcall crash_notes_memory_init+0x0/0x46 returned 0 after 0 usecs
calling  pid_namespaces_init+0x0/0x2d @ 1
initcall pid_namespaces_init+0x0/0x2d returned 0 after 0 usecs
calling  init_kprobes+0x0/0x1cf @ 1
initcall init_kprobes+0x0/0x1cf returned 0 after 4882 usecs
calling  utsname_sysctl_init+0x0/0x14 @ 1
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 usecs
calling  init_markers+0x0/0x17 @ 1
initcall init_markers+0x0/0x17 returned 0 after 0 usecs
calling  init_tracepoints+0x0/0x17 @ 1
initcall init_tracepoints+0x0/0x17 returned 0 after 0 usecs
calling  ftrace_nodyn_init+0x0/0x12 @ 1
initcall ftrace_nodyn_init+0x0/0x12 returned 0 after 0 usecs
calling  init_events+0x0/0xdb @ 1
initcall init_events+0x0/0xdb returned 0 after 0 usecs
calling  init_sched_switch_trace+0x0/0x12 @ 1
Testing tracer sched_switch: PASSED
initcall init_sched_switch_trace+0x0/0x12 returned 0 after 99609 usecs
calling  init_stack_trace+0x0/0x12 @ 1
Testing tracer sysprof: .. no entries found ..FAILED!
initcall init_stack_trace+0x0/0x12 returned -1 after 101562 usecs
initcall init_stack_trace+0x0/0x12 returned with error code -1 
calling  init_function_trace+0x0/0x12 @ 1
Testing tracer function: PASSED
initcall init_function_trace+0x0/0x12 returned 0 after 104492 usecs
calling  init_irqsoff_tracer+0x0/0x2c @ 1
Testing tracer irqsoff: .. no entries found ..FAILED!
Testing tracer preemptoff: .. no entries found ..FAILED!
Testing tracer preemptirqsoff: .. no entries found ..FAILED!
initcall init_irqsoff_tracer+0x0/0x2c returned 0 after 8789 usecs
calling  init_wakeup_tracer+0x0/0x58 @ 1
Testing tracer wakeup: .. no entries found ..FAILED!
initcall init_wakeup_tracer+0x0/0x58 returned -1 after 298828 usecs
initcall init_wakeup_tracer+0x0/0x58 returned with error code -1 
calling  stack_trace_init+0x0/0xc7 @ 1
initcall stack_trace_init+0x0/0xc7 returned 0 after 0 usecs
calling  init_mmio_trace+0x0/0x12 @ 1
initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
calling  init_graph_trace+0x0/0x12 @ 1
Testing tracer function_graph: <3>INFO: RCU detected CPU 0 stall (t=4294678940/10000 jiffies)
Pid: 1, comm: swapper Not tainted 2.6.29-rc8-tip-02752-g47b1aea-dirty #3264
Call Trace:
 <IRQ>  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211150>] print_context_stack+0xa0/0xd3
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fb26>] dump_trace+0x22d/0x2cc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211008>] show_trace_log_lvl+0x51/0x5d
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211029>] show_trace+0x15/0x17
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802111fa>] dump_stack+0x77/0x81
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e6dd>] print_cpu_stall+0x40/0xa4
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e8be>] check_cpu_stall+0x49/0x76
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e902>] __rcu_pending+0x17/0xfc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029ea13>] rcu_pending+0x2c/0x5e
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8026abef>] update_process_times+0x3c/0x77
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802875dd>] tick_periodic+0x6e/0x70
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287605>] tick_handle_periodic+0x26/0x89
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287ab4>] tick_do_broadcast+0x58/0x9c
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287be2>] tick_do_periodic_broadcast+0x3f/0x50
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287c07>] tick_handle_periodic_broadcast+0x14/0x75
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fe5c>] timer_interrupt+0x1f/0x26
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029a896>] handle_IRQ_event+0x11f/0x18a
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8029d172>] handle_edge_irq+0x169/0x1cf
 [<ffffffff80263e28>] ? __do_softirq+0x6a/0x1d3
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f39b>] generic_handle_irq_desc+0xf/0x11
 [<ffffffff8020f46e>] ? do_softirq+0x73/0x169
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f3ee>] handle_irq+0x51/0x5e
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a1af>] do_IRQ+0x5f/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff802af06e>] ? trace_graph_return+0xd7/0xe0
 [<ffffffff802b7542>] ? ftrace_return_to_handler+0x2d/0x88
 [<ffffffff802a30b6>] ? get_tracepoint+0xd/0x7f
 [<ffffffff802a35be>] ? tracepoint_update_probe_range+0x49/0xac
 [<ffffffff8020c7d2>] ? return_to_handler+0x35/0x73
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020db1c>] call_softirq+0x1c/0x28
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80263cd9>] irq_exit+0x5e/0xb8
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a226>] do_IRQ+0xd6/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 [<ffffffff802b22ee>] ? tracing_sched_register+0x49/0xc1
 [<ffffffff802b23a0>] ? tracing_start_sched_switch+0x3a/0x48
 [<ffffffff802b244a>] ? tracing_start_cmdline_record+0x9/0xb
 [<ffffffff802b61c4>] ? graph_trace_init+0x34/0x3a
 [<ffffffff802ace5e>] ? tracer_init+0x1d/0x22
 [<ffffffff802ad14b>] ? trace_selftest_startup_function_graph+0x18/0xbd
 [<ffffffff802ad721>] ? register_tracer+0x1c4/0x329
 [<ffffffff8027d494>] ? timespec_to_ktime+0x1a/0x1c
 [<ffffffff812aa14b>] ? init_graph_trace+0x0/0x12
 [<ffffffff812aa15b>] ? init_graph_trace+0x10/0x12
 [<ffffffff8020922b>] ? do_one_initcall+0x87/0x1ef
 [<ffffffff802ddbef>] ? zone_page_state_add+0x9/0x23
 [<ffffffff802de4b3>] ? __mod_zone_page_state+0x97/0xa7
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff803006d5>] ? PageTail+0x9/0x15
 [<ffffffff80302497>] ? kmem_cache_free+0xf1/0x100
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049ea79>] ? idr_pre_get+0x44/0x54
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8036f05a>] ? proc_register+0x1b5/0x1c0
 [<ffffffff8029da92>] ? register_irq_proc+0xc4/0xf5
 [<ffffffff8128f140>] ? early_idt_handler+0x0/0x6a
 [<ffffffff8128f700>] ? do_initcalls+0x1e/0x30
 [<ffffffff8128f72f>] ? do_basic_setup+0x1d/0x1f
 [<ffffffff8128fc04>] ? kernel_init+0x69/0xce
 [<ffffffff8020da1a>] ? child_rip+0xa/0x20
 [<ffffffff8020d3ad>] ? restore_args+0x0/0x30
 [<ffffffff8128fb9b>] ? kernel_init+0x0/0xce
 [<ffffffff8020da10>] ? child_rip+0x0/0x20
INFO: RCU detected CPU 0 stall (t=4294708940/40000 jiffies)
Pid: 1, comm: swapper Not tainted 2.6.29-rc8-tip-02752-g47b1aea-dirty #3264
Call Trace:
 <IRQ>  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211150>] print_context_stack+0xa0/0xd3
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fb26>] dump_trace+0x22d/0x2cc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211008>] show_trace_log_lvl+0x51/0x5d
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211029>] show_trace+0x15/0x17
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802111fa>] dump_stack+0x77/0x81
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e6dd>] print_cpu_stall+0x40/0xa4
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e8be>] check_cpu_stall+0x49/0x76
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e902>] __rcu_pending+0x17/0xfc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029ea13>] rcu_pending+0x2c/0x5e
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8026abef>] update_process_times+0x3c/0x77
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802875dd>] tick_periodic+0x6e/0x70
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287605>] tick_handle_periodic+0x26/0x89
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287ab4>] tick_do_broadcast+0x58/0x9c
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287be2>] tick_do_periodic_broadcast+0x3f/0x50
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287c07>] tick_handle_periodic_broadcast+0x14/0x75
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fe5c>] timer_interrupt+0x1f/0x26
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029a896>] handle_IRQ_event+0x11f/0x18a
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8029d172>] handle_edge_irq+0x169/0x1cf
 [<ffffffff80263e28>] ? __do_softirq+0x6a/0x1d3
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f39b>] generic_handle_irq_desc+0xf/0x11
 [<ffffffff8020f46e>] ? do_softirq+0x73/0x169
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f3ee>] handle_irq+0x51/0x5e
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a1af>] do_IRQ+0x5f/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff802af06e>] ? trace_graph_return+0xd7/0xe0
 [<ffffffff802b7542>] ? ftrace_return_to_handler+0x2d/0x88
 [<ffffffff802a30b6>] ? get_tracepoint+0xd/0x7f
 [<ffffffff802a35be>] ? tracepoint_update_probe_range+0x49/0xac
 [<ffffffff8020c7d2>] ? return_to_handler+0x35/0x73
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020db1c>] call_softirq+0x1c/0x28
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80263cd9>] irq_exit+0x5e/0xb8
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a226>] do_IRQ+0xd6/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 [<ffffffff802b22ee>] ? tracing_sched_register+0x49/0xc1
 [<ffffffff802b23a0>] ? tracing_start_sched_switch+0x3a/0x48
 [<ffffffff802b244a>] ? tracing_start_cmdline_record+0x9/0xb
 [<ffffffff802b61c4>] ? graph_trace_init+0x34/0x3a
 [<ffffffff802ace5e>] ? tracer_init+0x1d/0x22
 [<ffffffff802ad14b>] ? trace_selftest_startup_function_graph+0x18/0xbd
 [<ffffffff802ad721>] ? register_tracer+0x1c4/0x329
 [<ffffffff8027d494>] ? timespec_to_ktime+0x1a/0x1c
 [<ffffffff812aa14b>] ? init_graph_trace+0x0/0x12
 [<ffffffff812aa15b>] ? init_graph_trace+0x10/0x12
 [<ffffffff8020922b>] ? do_one_initcall+0x87/0x1ef
 [<ffffffff802ddbef>] ? zone_page_state_add+0x9/0x23
 [<ffffffff802de4b3>] ? __mod_zone_page_state+0x97/0xa7
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff803006d5>] ? PageTail+0x9/0x15
 [<ffffffff80302497>] ? kmem_cache_free+0xf1/0x100
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049ea79>] ? idr_pre_get+0x44/0x54
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8036f05a>] ? proc_register+0x1b5/0x1c0
 [<ffffffff8029da92>] ? register_irq_proc+0xc4/0xf5
 [<ffffffff8128f140>] ? early_idt_handler+0x0/0x6a
 [<ffffffff8128f700>] ? do_initcalls+0x1e/0x30
 [<ffffffff8128f72f>] ? do_basic_setup+0x1d/0x1f
 [<ffffffff8128fc04>] ? kernel_init+0x69/0xce
 [<ffffffff8020da1a>] ? child_rip+0xa/0x20
 [<ffffffff8020d3ad>] ? restore_args+0x0/0x30
 [<ffffffff8128fb9b>] ? kernel_init+0x0/0xce
 [<ffffffff8020da10>] ? child_rip+0x0/0x20
INFO: RCU detected CPU 0 stall (t=4294738940/70000 jiffies)
Pid: 1, comm: swapper Not tainted 2.6.29-rc8-tip-02752-g47b1aea-dirty #3264
Call Trace:
 <IRQ>  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211150>] print_context_stack+0xa0/0xd3
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fb26>] dump_trace+0x22d/0x2cc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211008>] show_trace_log_lvl+0x51/0x5d
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211029>] show_trace+0x15/0x17
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802111fa>] dump_stack+0x77/0x81
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e6dd>] print_cpu_stall+0x40/0xa4
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e8be>] check_cpu_stall+0x49/0x76
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e902>] __rcu_pending+0x17/0xfc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029ea13>] rcu_pending+0x2c/0x5e
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8026abef>] update_process_times+0x3c/0x77
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802875dd>] tick_periodic+0x6e/0x70
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287605>] tick_handle_periodic+0x26/0x89
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287ab4>] tick_do_broadcast+0x58/0x9c
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287be2>] tick_do_periodic_broadcast+0x3f/0x50
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287c07>] tick_handle_periodic_broadcast+0x14/0x75
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fe5c>] timer_interrupt+0x1f/0x26
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029a896>] handle_IRQ_event+0x11f/0x18a
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8029d172>] handle_edge_irq+0x169/0x1cf
 [<ffffffff80263e28>] ? __do_softirq+0x6a/0x1d3
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f39b>] generic_handle_irq_desc+0xf/0x11
 [<ffffffff8020f46e>] ? do_softirq+0x73/0x169
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f3ee>] handle_irq+0x51/0x5e
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a1af>] do_IRQ+0x5f/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff802af06e>] ? trace_graph_return+0xd7/0xe0
 [<ffffffff802b7542>] ? ftrace_return_to_handler+0x2d/0x88
 [<ffffffff802a30b6>] ? get_tracepoint+0xd/0x7f
 [<ffffffff802a35be>] ? tracepoint_update_probe_range+0x49/0xac
 [<ffffffff8020c7d2>] ? return_to_handler+0x35/0x73
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020db1c>] call_softirq+0x1c/0x28
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80263cd9>] irq_exit+0x5e/0xb8
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a226>] do_IRQ+0xd6/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 [<ffffffff802b22ee>] ? tracing_sched_register+0x49/0xc1
 [<ffffffff802b23a0>] ? tracing_start_sched_switch+0x3a/0x48
 [<ffffffff802b244a>] ? tracing_start_cmdline_record+0x9/0xb
 [<ffffffff802b61c4>] ? graph_trace_init+0x34/0x3a
 [<ffffffff802ace5e>] ? tracer_init+0x1d/0x22
 [<ffffffff802ad14b>] ? trace_selftest_startup_function_graph+0x18/0xbd
 [<ffffffff802ad721>] ? register_tracer+0x1c4/0x329
 [<ffffffff8027d494>] ? timespec_to_ktime+0x1a/0x1c
 [<ffffffff812aa14b>] ? init_graph_trace+0x0/0x12
 [<ffffffff812aa15b>] ? init_graph_trace+0x10/0x12
 [<ffffffff8020922b>] ? do_one_initcall+0x87/0x1ef
 [<ffffffff802ddbef>] ? zone_page_state_add+0x9/0x23
 [<ffffffff802de4b3>] ? __mod_zone_page_state+0x97/0xa7
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff803006d5>] ? PageTail+0x9/0x15
 [<ffffffff80302497>] ? kmem_cache_free+0xf1/0x100
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049ea79>] ? idr_pre_get+0x44/0x54
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8036f05a>] ? proc_register+0x1b5/0x1c0
 [<ffffffff8029da92>] ? register_irq_proc+0xc4/0xf5
 [<ffffffff8128f140>] ? early_idt_handler+0x0/0x6a
 [<ffffffff8128f700>] ? do_initcalls+0x1e/0x30
 [<ffffffff8128f72f>] ? do_basic_setup+0x1d/0x1f
 [<ffffffff8128fc04>] ? kernel_init+0x69/0xce
 [<ffffffff8020da1a>] ? child_rip+0xa/0x20
 [<ffffffff8020d3ad>] ? restore_args+0x0/0x30
 [<ffffffff8128fb9b>] ? kernel_init+0x0/0xce
 [<ffffffff8020da10>] ? child_rip+0x0/0x20
INFO: RCU detected CPU 0 stall (t=4294768940/100000 jiffies)
Pid: 1, comm: swapper Not tainted 2.6.29-rc8-tip-02752-g47b1aea-dirty #3264
Call Trace:
 <IRQ>  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211150>] print_context_stack+0xa0/0xd3
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fb26>] dump_trace+0x22d/0x2cc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211008>] show_trace_log_lvl+0x51/0x5d
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80211029>] show_trace+0x15/0x17
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802111fa>] dump_stack+0x77/0x81
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e6dd>] print_cpu_stall+0x40/0xa4
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e8be>] check_cpu_stall+0x49/0x76
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029e902>] __rcu_pending+0x17/0xfc
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029ea13>] rcu_pending+0x2c/0x5e
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8026abef>] update_process_times+0x3c/0x77
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff802875dd>] tick_periodic+0x6e/0x70
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287605>] tick_handle_periodic+0x26/0x89
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287ab4>] tick_do_broadcast+0x58/0x9c
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287be2>] tick_do_periodic_broadcast+0x3f/0x50
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff80287c07>] tick_handle_periodic_broadcast+0x14/0x75
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8020fe5c>] timer_interrupt+0x1f/0x26
 [<ffffffff8020c79d>] return_to_handler+0x0/0x73
 [<ffffffff8029a896>] handle_IRQ_event+0x11f/0x18a
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8029d172>] handle_edge_irq+0x169/0x1cf
 [<ffffffff80263e28>] ? __do_softirq+0x6a/0x1d3
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f39b>] generic_handle_irq_desc+0xf/0x11
 [<ffffffff8020f46e>] ? do_softirq+0x73/0x169
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020f3ee>] handle_irq+0x51/0x5e
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a1af>] do_IRQ+0x5f/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff802af06e>] ? trace_graph_return+0xd7/0xe0
 [<ffffffff802b7542>] ? ftrace_return_to_handler+0x2d/0x88
 [<ffffffff802a30b6>] ? get_tracepoint+0xd/0x7f
 [<ffffffff802a35be>] ? tracepoint_update_probe_range+0x49/0xac
 [<ffffffff8020c7d2>] ? return_to_handler+0x35/0x73
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020db1c>] call_softirq+0x1c/0x28
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80263cd9>] irq_exit+0x5e/0xb8
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff80a0a226>] do_IRQ+0xd6/0xed
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020d353>] ret_from_intr+0x0/0xf
 [<ffffffff802b22ee>] ? tracing_sched_register+0x49/0xc1
 [<ffffffff802b23a0>] ? tracing_start_sched_switch+0x3a/0x48
 [<ffffffff802b244a>] ? tracing_start_cmdline_record+0x9/0xb
 [<ffffffff802b61c4>] ? graph_trace_init+0x34/0x3a
 [<ffffffff802ace5e>] ? tracer_init+0x1d/0x22
 [<ffffffff802ad14b>] ? trace_selftest_startup_function_graph+0x18/0xbd
 [<ffffffff802ad721>] ? register_tracer+0x1c4/0x329
 [<ffffffff8027d494>] ? timespec_to_ktime+0x1a/0x1c
 [<ffffffff812aa14b>] ? init_graph_trace+0x0/0x12
 [<ffffffff812aa15b>] ? init_graph_trace+0x10/0x12
 [<ffffffff8020922b>] ? do_one_initcall+0x87/0x1ef
 [<ffffffff802ddbef>] ? zone_page_state_add+0x9/0x23
 [<ffffffff802de4b3>] ? __mod_zone_page_state+0x97/0xa7
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff8049e091>] ? sub_alloc+0x74/0x200
 [<ffffffff803006d5>] ? PageTail+0x9/0x15
 [<ffffffff80302497>] ? kmem_cache_free+0xf1/0x100
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049e60d>] ? ida_get_new_above+0x225/0x241
 [<ffffffff8049ea79>] ? idr_pre_get+0x44/0x54
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04c9e>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8036f05a>] ? proc_register+0x1b5/0x1c0
 [<ffffffff8029da92>] ? register_irq_proc+0xc4/0xf5
 [<ffffffff8128f140>] ? early_idt_handler+0x0/0x6a
 [<ffffffff8128f700>] ? do_initcalls+0x1e/0x30
 [<ffffffff8128f72f>] ? do_basic_setup+0x1d/0x1f
 [<ffffffff8128fc04>] ? kernel_init+0x69/0xce
 [<ffffffff8020da1a>] ? child_rip+0xa/0x20
 [<ffffffff8020d3ad>] ? restore_args+0x0/0x30
 [<ffffffff8128fb9b>] ? kernel_init+0x0/0xce
 [<ffffffff8020da10>] ? child_rip+0x0/0x20

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

# head: d9937cb8
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc8
# Sat Mar 21 10:54:53 2009
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
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_BOOT_ALLOWED4=y
CONFIG_BROKEN_BOOT_ALLOWED3=y
CONFIG_BROKEN_BOOT_ALLOWED2=y
# CONFIG_BROKEN_BOOT_ALLOWED is not set
# CONFIG_BROKEN_BOOT_EUROPE is not set
# CONFIG_BROKEN_BOOT_TITAN is not set
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
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_EVENT_PROFILE=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_PCI_QUIRKS is not set
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_BOOTPARAM_NO_HZ_OFF=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_BOOTPARAM_HIGHRES_OFF=y
CONFIG_SMP_SUPPORT=y
CONFIG_X86_X2APIC=y
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
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
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_X86_CPU_DEBUG is not set
CONFIG_UP_WANTED_1=y
# CONFIG_UP_WANTED_2 is not set
CONFIG_SMP=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
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
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
# CONFIG_X86_PM_TIMER is not set
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_MEMORY=m
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K8=m
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
# CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0 is not set
CONFIG_BOOTPARAM_NOLAPIC_TIMER=y
CONFIG_BOOTPARAM_LAPIC=y
CONFIG_BOOTPARAM_HPET_DISABLE=y
# CONFIG_BOOTPARAM_IDLE_MWAIT is not set
# CONFIG_BOOTPARAM_IDLE_POLL is not set
# CONFIG_BOOTPARAM_HIGHMEM_512M is not set
CONFIG_BOOTPARAM_NOPAT=y
CONFIG_BOOTPARAM_NOTSC=y
CONFIG_BOOTPARAM_PCI_NOMSI=y

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
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=m
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
CONFIG_HOTPLUG_PCI_SHPC=m

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
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=m
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_ECONET=y
CONFIG_ECONET_AUNUDP=y
# CONFIG_ECONET_NATIVE is not set
CONFIG_WAN_ROUTER=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=m
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=m
CONFIG_YAM=m
CONFIG_CAN=m
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_L2CAP is not set
CONFIG_BT_SCO=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
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
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
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
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_DELL_LAPTOP=m
CONFIG_HAVE_IDE=y

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
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_SCSI_CXGB3_ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_LIBFC=m
# CONFIG_FCOE is not set
CONFIG_SCSI_DMX3191D=y
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=m
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=m
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=y
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=y
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=y
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=m
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_SCH=m
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
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=m
# CONFIG_IEEE1394_SBP2 is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VERBOSEDEBUG=y
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=m
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=y
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
CONFIG_ARCNET=m
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_ENC28J60=m
# CONFIG_ENC28J60_WRITEVERIFY is not set
CONFIG_DNET=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=y
CONFIG_HP100=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
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
CONFIG_NE2K_PCI=m
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=y
CONFIG_SIS900=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC9420=y
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=y
# CONFIG_NET_POCKET is not set
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=y
CONFIG_IGB_LRO=y
CONFIG_IGB_DCA=y
CONFIG_NS83820=m
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
# CONFIG_R8169 is not set
CONFIG_SIS190=m
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
CONFIG_ATL1E=m
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=m
# CONFIG_ENIC is not set
CONFIG_IXGBE=m
# CONFIG_IXGBE_DCA is not set
CONFIG_IXGB=y
# CONFIG_S2IO is not set
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_TEHUTI=y
# CONFIG_BNX2X is not set
CONFIG_QLGE=m
CONFIG_SFC=m
CONFIG_BE2NET=m
CONFIG_TR=y
CONFIG_IBMOL=y
CONFIG_3C359=y
CONFIG_TMS380TR=y
CONFIG_TMSPCI=y
# CONFIG_ABYSS is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=m
# CONFIG_PCMCIA_WAVELAN is not set
# CONFIG_PCMCIA_NETWAVE is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_HSO is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PLIP=m
CONFIG_PPP=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=m
# CONFIG_PPPOE is not set
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
# CONFIG_ISDN is not set
CONFIG_PHONE=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=m
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_UCB1400 is not set
CONFIG_TOUCHSCREEN_WM97XX=m
# CONFIG_TOUCHSCREEN_WM9705 is not set
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=m
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=m
# CONFIG_SX is not set
CONFIG_RIO=y
# CONFIG_RIO_OLDPCI is not set
CONFIG_STALDRV=y
CONFIG_STALLION=y
CONFIG_ISTALLION=m
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
CONFIG_RTC=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
CONFIG_TELCLOCK=y
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
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=m
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=y

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_SENSORS_MAX6875 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=y
# CONFIG_SPI_LM70_LLP is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=y
# CONFIG_SC520_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=m
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
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
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=m
CONFIG_UCB1400_CORE=m
CONFIG_TPS65010=m
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_MFD_WM8400=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

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
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
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
CONFIG_VIDEO_ADV_DEBUG=y
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
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_STRADIS=m
# CONFIG_VIDEO_ZORAN is not set
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_SAA7134=m
# CONFIG_VIDEO_SAA7134_ALSA is not set
# CONFIG_VIDEO_SAA7134_DVB is not set
CONFIG_VIDEO_MXB=m
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_FB_IVTV is not set
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
# CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV is not set
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_ALSA is not set
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
CONFIG_USB_ZC0301=m
CONFIG_USB_PWC=m
CONFIG_USB_PWC_DEBUG=y
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_GEMTEK_PCI=m
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_MAESTRO=m
# CONFIG_USB_DSBR is not set
CONFIG_USB_SI470X=m
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_CAPTURE_DRIVERS is not set
CONFIG_DVB_BT8XX=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
# CONFIG_AGP_VIA is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=m
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_ARC=m
# CONFIG_FB_IMSTT is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_HGA_ACCEL=y
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_MATROX_MULTIHEAD=y
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
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
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=m
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
# CONFIG_SND_RTCTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=m
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=m
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=m
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=m
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5530=m
# CONFIG_SND_DARLA20 is not set
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
# CONFIG_SND_DARLA24 is not set
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
# CONFIG_SND_MIA is not set
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
# CONFIG_SND_ES1968 is not set
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=m
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=m
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
CONFIG_SND_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=y
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=m
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP2101=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_PHIDGET=y
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=y
CONFIG_USB_PHIDGETSERVO=m
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=m
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=y
# CONFIG_USB_ATM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_UWB_I1480U=m
# CONFIG_UWB_I1480U_WLP is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
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
CONFIG_DMATEST=m
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_SMX is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
CONFIG_ACPI_ASUS=y
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
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
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_OCFS2_FS_POSIX_ACL=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_EXPORTFS=m

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
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ALLOW_WARNINGS=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
# CONFIG_DEBUG_KERNEL is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_EVENT_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
CONFIG_TRACE_BRANCH_PROFILING=y
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_POWER_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_HW_BRANCH_TRACER=y
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
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
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
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
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

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
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
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
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_TRACE is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_64=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y

--EVF5PPMfhYS0aIcm--
