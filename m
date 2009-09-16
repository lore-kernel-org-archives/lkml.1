Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZIPNDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZIPNDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZIPND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:03:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZIPNDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:03:15 -0400
Date: Wed, 16 Sep 2009 15:02:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] security / creds fixes
Message-ID: <20090916130224.GA27519@elte.hu>
References: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk> <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


i'm still getting crashes even with latest -git [0cb583f]:


EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
async_waiting @ 1
async_continuing @ 1 after 0 usec
debug: unmapping init memory ffffffff81f1e000..ffffffff81fb1000
SELinux:  Disabled at runtime.
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
PGD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: 
CPU 1 
Modules linked in:
Pid: 12, comm: khelper Not tainted 2.6.31-tip-05525-g0eeacc6-dirty #14819 System Product Name
RIP: 0010:[<ffffffff81122537>]  [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
RSP: 0018:ffff88003f9258b0  EFLAGS: 00010086
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000078c0129e
RDX: 0000000000000000 RSI: ffffffff8130b626 RDI: ffffffff81122528
RBP: ffff88003f925900 R08: 0000000078c0129e R09: 0000000000000001
R10: 0000000000000000 R11: 0000000078c0129e R12: 0000000000000246
R13: 0000000000008020 R14: ffff88003f8586d8 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff880002b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: ffffffff827bd420 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khelper (pid: 12, threadinfo ffff88003f924000, task ffff88003f928000)
Stack:
 0000000000000246 0000802000000246 ffffffff8130b626 0000000000000001
<0> 0000000078c0129e 0000000000000000 ffff88003f925a70 0000000000000002
<0> 0000000000000001 0000000000000001 ffff88003f925960 ffffffff8130b626
Call Trace:
 [<ffffffff8130b626>] ? avc_alloc_node+0x36/0x273
 [<ffffffff8130b626>] avc_alloc_node+0x36/0x273
 [<ffffffff8130b545>] ? avc_latest_notif_update+0x7d/0x9e
 [<ffffffff8130b8b4>] avc_insert+0x51/0x18d
 [<ffffffff8130bcce>] avc_has_perm_noaudit+0x9d/0x128
 [<ffffffff8130bf20>] avc_has_perm+0x45/0x88
 [<ffffffff8130f99d>] current_has_perm+0x52/0x6d
 [<ffffffff8130fbb2>] selinux_task_create+0x2f/0x45
 [<ffffffff81303bf7>] security_task_create+0x29/0x3f
 [<ffffffff8105c6ba>] copy_process+0x82/0xdf0
 [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
 [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
 [<ffffffff8105d596>] do_fork+0x16e/0x382
 [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
 [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
 [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
 [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
 [<ffffffff8100cdb2>] kernel_thread+0x82/0xe0
 [<ffffffff81078b1f>] ? ____call_usermodehelper+0x0/0x139
 [<ffffffff8100ce10>] ? child_rip+0x0/0x20
 [<ffffffff81078aea>] ? __call_usermodehelper+0x65/0x9a
 [<ffffffff8107a5c7>] run_workqueue+0x171/0x27e
 [<ffffffff8107a573>] ? run_workqueue+0x11d/0x27e
 [<ffffffff81078a85>] ? __call_usermodehelper+0x0/0x9a
 [<ffffffff8107a7bc>] worker_thread+0xe8/0x10f
 [<ffffffff810808e2>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff8107a6d4>] ? worker_thread+0x0/0x10f
 [<ffffffff8108042e>] kthread+0x91/0x99
 [<ffffffff8100ce1a>] child_rip+0xa/0x20
 [<ffffffff8100c754>] ? restore_args+0x0/0x30
 [<ffffffff8108039d>] ? kthread+0x0/0x99
 [<ffffffff8100ce10>] ? child_rip+0x0/0x20
Code: 0f 85 99 00 00 00 9c 58 66 66 90 66 90 49 89 c4 fa 66 66 90 66 66 90 e8 83 34 fb ff e8 d7 e9 26 00 48 98 49 8b 94 c6 10 01 00 00 <48> 8b 1a 44 8b 7a 18 48 85 db 74 0f 8b 42 14 48 8b 04 c3 ff 42 
RIP  [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
 RSP <ffff88003f9258b0>
CR2: 0000000000000000
---[ end trace 42f41a982344e606 ]---
Kernel panic - not syncing: Fatal exception

config and full crashlog attached as well.

	Ingo

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

Linux version 2.6.31-tip-05525-g0eeacc6-dirty (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #14819 SMP PREEMPT Wed Sep 16 13:09:50 CEST 2009
Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
bootconsole [earlyser0] enabled
debug: ignoring loglevel setting.
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.3 present.
last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000003fff0000
 0000000000 - 003fff0000 page 4k
kernel direct mapping tables up to 3fff0000 @ 100000-302000
(6 early reservations) ==> bootmem [0000000000 - 003fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0002914300]    TEXT DATA BSS ==> [0001000000 - 0002914300]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [0002915000 - 0002915149]              BRK ==> [0002915000 - 0002915149]
  #5 [0000100000 - 0000300000]          PGTABLE ==> [0000100000 - 0000300000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000f5680] f5680
  mpc: f1400-f152c
 [ffffea0000000000-ffffea00015fffff] PMD -> [ffff880002e00000-ffff8800043fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262031
  DMA zone: 88 pages used for memmap
  DMA zone: 611 pages reserved
  DMA zone: 3300 pages, LIFO batch:0
  DMA32 zone: 5544 pages used for memmap
  DMA32 zone: 252488 pages, LIFO batch:31
Intel MultiProcessor Specification v1.4
  mpc: f1400-f152c
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
Bus #0 is PCI   
Bus #1 is PCI   
Bus #2 is PCI   
Bus #3 is PCI   
Bus #4 is PCI   
Bus #5 is PCI   
Bus #6 is ISA   
I/O APIC #2 Version 17 at 0xFEC00000.
Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC INT 0b
Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC INT 03
Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC INT 05
Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC INT 0b
Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 00
Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC INT 01
Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 02
Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC INT 04
Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC INT 06
Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC INT 07
Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC INT 08
Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC INT 09
Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC INT 0d
Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC INT 0f
Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffffffff5fc000 (fee00000)
mapped IOAPIC to ffffffffff5fb000 (fec00000)
nr_irqs_gsi: 24
Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 29 pages/cpu @ffff880002a00000 s89632 r8192 d20960 u1048576
pcpu-alloc: s89632 r8192 d20960 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255788
Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
debug: sysrq always enabled.
PID hash table entries: 4096 (order: 12, 32768 bytes)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Memory: 994796k/1048512k available (8352k kernel code, 388k absent, 52628k reserved, 7120k data, 588k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:512
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [ttyS0] enabled, bootconsole disabled
console [ttyS0] enabled, bootconsole disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 5823 kB
 per task-struct memory footprint: 1920 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:failed|failed|  ok  |failed|failed|failed|
                 A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
             A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
             A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |failed|
           recursive read-lock #2:             |  ok  |             |failed|
            mixed read-write-lock:             |failed|             |failed|
            mixed write-read-lock:             |failed|             |failed|
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
     soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
     hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
     soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
       sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
       sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
         hard-safe-A + irqs-on/12:failed|failed|  ok  |
         soft-safe-A + irqs-on/12:failed|failed|  ok  |
         hard-safe-A + irqs-on/21:failed|failed|  ok  |
         soft-safe-A + irqs-on/21:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
      hard-irq lock-inversion/123:failed|failed|  ok  |
      soft-irq lock-inversion/123:failed|failed|  ok  |
      hard-irq lock-inversion/132:failed|failed|  ok  |
      soft-irq lock-inversion/132:failed|failed|  ok  |
      hard-irq lock-inversion/213:failed|failed|  ok  |
      soft-irq lock-inversion/213:failed|failed|  ok  |
      hard-irq lock-inversion/231:failed|failed|  ok  |
      soft-irq lock-inversion/231:failed|failed|  ok  |
      hard-irq lock-inversion/312:failed|failed|  ok  |
      soft-irq lock-inversion/312:failed|failed|  ok  |
      hard-irq lock-inversion/321:failed|failed|  ok  |
      soft-irq lock-inversion/321:failed|failed|  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
--------------------------------------------------------
133 out of 218 testcases failed, as expected. |
----------------------------------------------------
allocated 10485760 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
ODEBUG: 8 of 8 active objects replaced
Fast TSC calibration using PIT
Detected 2010.404 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.80 BogoMIPS (lpj=2010404)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 256
Initializing cgroup subsys debug
Initializing cgroup subsys memory
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
Performance Counters: AMD PMU driver.
... version:                 0
... bit width:               48
... generic counters:        4
... value mask:              0000ffffffffffff
... max period:              00007fffffffffff
... fixed-purpose counters:  0
... counter mask:            000000000000000f
Setting APIC routing to flat
enabled ExtINT on CPU#0
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 2-0 (apicid-pin) not connected
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1256252
..... delta 1256252
..... mult: 53963815
..... calibration result: 201000
..... CPU clock speed is 2010.0004 MHz.
..... host bus clock speed is 201.0000 MHz.
... verify APIC timer
... jiffies delta = 100
... jiffies result ok
calling  migration_init+0x0/0x7b @ 1
initcall migration_init+0x0/0x7b returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x7b @ 1
initcall spawn_ksoftirqd+0x0/0x7b returned 0 after 976 usecs
calling  init_call_single_data+0x0/0xe2 @ 1
initcall init_call_single_data+0x0/0xe2 returned 0 after 0 usecs
calling  spawn_softlockup_task+0x0/0x97 @ 1
initcall spawn_softlockup_task+0x0/0x97 returned 0 after 0 usecs
calling  relay_init+0x0/0x3b @ 1
initcall relay_init+0x0/0x3b returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x29d @ 1
Testing tracer nop: PASSED
initcall tracer_alloc_buffers+0x0/0x29d returned 0 after 1953 usecs
calling  init_trace_printk+0x0/0x39 @ 1
initcall init_trace_printk+0x0/0x39 returned 0 after 0 usecs
calling  trace_workqueue_early_init+0x0/0x157 @ 1
initcall trace_workqueue_early_init+0x0/0x157 returned 0 after 0 usecs
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4019.90 BogoMIPS (lpj=2009954)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (8040.71 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
device: 'platform': device_add
bus: 'platform': registered
Registering sysdev class 'cpu'
Registering sysdev class 'memory'
Registering sys device of class 'memory'
Registering sys device 'memory0'
Registering sys device of class 'memory'
Registering sys device 'memory1'
Registering sys device of class 'memory'
Registering sys device 'memory2'
Registering sys device of class 'memory'
Registering sys device 'memory3'
Registering sys device of class 'memory'
Registering sys device 'memory4'
Registering sys device of class 'memory'
Registering sys device 'memory5'
Registering sys device of class 'memory'
Registering sys device 'memory6'
Registering sys device of class 'memory'
Registering sys device 'memory7'
calling  init_mmap_min_addr+0x0/0x4d @ 1
initcall init_mmap_min_addr+0x0/0x4d returned 0 after 0 usecs
calling  net_ns_init+0x0/0x12c @ 1
initcall net_ns_init+0x0/0x12c returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x3b @ 1
initcall pci_reboot_init+0x0/0x3b returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x64 @ 1
initcall init_smp_flush+0x0/0x64 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x59 @ 1
initcall sysctl_init+0x0/0x59 returned 0 after 976 usecs
calling  ksysfs_init+0x0/0xe4 @ 1
initcall ksysfs_init+0x0/0xe4 returned 0 after 0 usecs
calling  async_init+0x0/0x69 @ 1
initcall async_init+0x0/0x69 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x39 @ 1
initcall init_jiffies_clocksource+0x0/0x39 returned 0 after 0 usecs
calling  init_hw_breakpoint+0x0/0x39 @ 1
initcall init_hw_breakpoint+0x0/0x39 returned 0 after 0 usecs
calling  filelock_init+0x0/0x55 @ 1
initcall filelock_init+0x0/0x55 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x3b @ 1
initcall init_script_binfmt+0x0/0x3b returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x3b @ 1
initcall init_elf_binfmt+0x0/0x3b returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x3b @ 1
initcall init_compat_elf_binfmt+0x0/0x3b returned 0 after 0 usecs
calling  debugfs_init+0x0/0x80 @ 1
initcall debugfs_init+0x0/0x80 returned 0 after 0 usecs
calling  securityfs_init+0x0/0x77 @ 1
initcall securityfs_init+0x0/0x77 returned 0 after 0 usecs
calling  random32_init+0x0/0xf3 @ 1
initcall random32_init+0x0/0xf3 returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x66 @ 1
initcall cpuidle_init+0x0/0x66 returned 0 after 0 usecs
calling  sock_init+0x0/0x85 @ 1
initcall sock_init+0x0/0x85 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x69 @ 1
initcall netpoll_init+0x0/0x69 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x169 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x169 returned 0 after 976 usecs
calling  bdi_class_init+0x0/0x68 @ 1
device class 'bdi': registering
initcall bdi_class_init+0x0/0x68 returned 0 after 976 usecs
calling  kobject_uevent_init+0x0/0x7b @ 1
initcall kobject_uevent_init+0x0/0x7b returned 0 after 0 usecs
calling  gpiolib_sysfs_init+0x0/0xbc @ 1
device class 'gpio': registering
initcall gpiolib_sysfs_init+0x0/0xbc returned 0 after 1953 usecs
calling  pcibus_class_init+0x0/0x40 @ 1
device class 'pci_bus': registering
initcall pcibus_class_init+0x0/0x40 returned 0 after 1953 usecs
calling  pci_driver_init+0x0/0x39 @ 1
bus: 'pci': registered
initcall pci_driver_init+0x0/0x39 returned 0 after 976 usecs
calling  backlight_class_init+0x0/0x84 @ 1
device class 'backlight': registering
initcall backlight_class_init+0x0/0x84 returned 0 after 976 usecs
calling  tty_class_init+0x0/0x58 @ 1
device class 'tty': registering
initcall tty_class_init+0x0/0x58 returned 0 after 976 usecs
calling  vtconsole_class_init+0x0/0xe8 @ 1
device class 'vtconsole': registering
device: 'vtcon0': device_add
initcall vtconsole_class_init+0x0/0xe8 returned 0 after 1953 usecs
calling  spi_init+0x0/0xd4 @ 1
bus: 'spi': registered
device class 'spi_master': registering
initcall spi_init+0x0/0xd4 returned 0 after 2929 usecs
calling  i2c_init+0x0/0x8c @ 1
bus: 'i2c': registered
device class 'i2c-adapter': registering
bus: 'i2c': add driver dummy
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x8c returned 0 after 5859 usecs
calling  amd_postcore_init+0x0/0xdc @ 1
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [feb00000, fec0ffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fed3ffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [40000000, fcffffffff]
bus: 00 index 2 mmio: [feb00000, fec0ffff]
bus: 00 index 3 mmio: [a0000, bffff]
initcall amd_postcore_init+0x0/0xdc returned 0 after 11718 usecs
calling  arch_kdebugfs_init+0x0/0x4b @ 1
initcall arch_kdebugfs_init+0x0/0x4b returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x8a @ 1
initcall mtrr_if_init+0x0/0x8a returned 0 after 0 usecs
calling  dmi_id_init+0x0/0xf7 @ 1
device class 'dmi': registering
device: 'id': device_add
initcall dmi_id_init+0x0/0xf7 returned 0 after 2929 usecs
calling  dma_bus_init+0x0/0x66 @ 1
device class 'dma': registering
initcall dma_bus_init+0x0/0x66 returned 0 after 976 usecs
calling  dma_channel_table_init+0x0/0x137 @ 1
initcall dma_channel_table_init+0x0/0x137 returned 0 after 0 usecs
calling  dca_init+0x0/0x45 @ 1
dca service started, version 1.8
device class 'dca': registering
initcall dca_init+0x0/0x45 returned 0 after 1953 usecs
calling  pci_arch_init+0x0/0x67 @ 1
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x67 returned 0 after 976 usecs
calling  topology_init+0x0/0x9a @ 1
Registering sys device of class 'cpu'
Registering sys device 'cpu0'
Registering sys device of class 'cpu'
Registering sys device 'cpu1'
initcall topology_init+0x0/0x9a returned 0 after 4882 usecs
calling  mtrr_init_finialize+0x0/0x64 @ 1
initcall mtrr_init_finialize+0x0/0x64 returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0xf6 @ 1
initcall param_sysfs_init+0x0/0xf6 returned 0 after 42968 usecs
calling  pm_sysrq_init+0x0/0x45 @ 1
initcall pm_sysrq_init+0x0/0x45 returned 0 after 0 usecs
calling  audit_watch_init+0x0/0x56 @ 1
initcall audit_watch_init+0x0/0x56 returned 0 after 0 usecs
calling  init_slow_work+0x0/0x5f @ 1
initcall init_slow_work+0x0/0x5f returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xe9 @ 1
device: 'default': device_add
initcall default_bdi_init+0x0/0xe9 returned 0 after 976 usecs
calling  init_bio+0x0/0xf4 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xf4 returned 0 after 976 usecs
calling  fsnotify_init+0x0/0x39 @ 1
initcall fsnotify_init+0x0/0x39 returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0x129 @ 1
initcall fsnotify_notification_init+0x0/0x129 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x39 @ 1
initcall cryptomgr_init+0x0/0x39 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x51 @ 1
initcall blk_settings_init+0x0/0x51 returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x51 @ 1
initcall blk_ioc_init+0x0/0x51 returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0xd3 @ 1
initcall blk_softirq_init+0x0/0xd3 returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0xd3 @ 1
initcall blk_iopoll_setup+0x0/0xd3 returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x8c @ 1
device class 'block': registering
initcall genhd_device_init+0x0/0x8c returned 0 after 1953 usecs
calling  blk_dev_integrity_init+0x0/0x51 @ 1
initcall blk_dev_integrity_init+0x0/0x51 returned 0 after 0 usecs
calling  gpiolib_debugfs_init+0x0/0x4b @ 1
initcall gpiolib_debugfs_init+0x0/0x4b returned 0 after 0 usecs
calling  max7301_init+0x0/0x39 @ 1
bus: 'spi': add driver max7301
initcall max7301_init+0x0/0x39 returned 0 after 976 usecs
calling  max732x_init+0x0/0x3b @ 1
bus: 'i2c': add driver max732x
i2c-core: driver [max732x] registered
initcall max732x_init+0x0/0x3b returned 0 after 1953 usecs
calling  pci_slot_init+0x0/0x73 @ 1
initcall pci_slot_init+0x0/0x73 returned 0 after 0 usecs
calling  misc_init+0x0/0xdd @ 1
device class 'misc': registering
initcall misc_init+0x0/0xdd returned 0 after 976 usecs
calling  tifm_init+0x0/0xab @ 1
bus: 'tifm': registered
device class 'tifm_adapter': registering
initcall tifm_init+0x0/0xab returned 0 after 2929 usecs
calling  wm8400_module_init+0x0/0x59 @ 1
bus: 'i2c': add driver WM8400
i2c-core: driver [WM8400] registered
initcall wm8400_module_init+0x0/0x59 returned 0 after 1953 usecs
calling  tps_init+0x0/0xd8 @ 1
tps65010: version 2 May 2005
bus: 'i2c': add driver tps65010
i2c-core: driver [tps65010] registered
bus: 'i2c': remove driver tps65010
driver: 'tps65010': driver_release
i2c-core: driver [tps65010] unregistered
bus: 'i2c': add driver tps65010
i2c-core: driver [tps65010] registered
bus: 'i2c': remove driver tps65010
driver: 'tps65010': driver_release
i2c-core: driver [tps65010] unregistered
bus: 'i2c': add driver tps65010
i2c-core: driver [tps65010] registered
bus: 'i2c': remove driver tps65010
driver: 'tps65010': driver_release
i2c-core: driver [tps65010] unregistered
tps65010: no chip?
initcall tps_init+0x0/0xd8 returned -19 after 43945 usecs
calling  twl4030_init+0x0/0x3b @ 1
bus: 'i2c': add driver twl4030
i2c-core: driver [twl4030] registered
initcall twl4030_init+0x0/0x3b returned 0 after 1953 usecs
calling  pcf50633_init+0x0/0x3b @ 1
bus: 'i2c': add driver pcf50633
i2c-core: driver [pcf50633] registered
initcall pcf50633_init+0x0/0x3b returned 0 after 1953 usecs
calling  init_scsi+0x0/0xa7 @ 1
device class 'scsi_host': registering
bus: 'scsi': registered
device class 'scsi_device': registering
SCSI subsystem initialized
initcall init_scsi+0x0/0xa7 returned 0 after 6835 usecs
calling  ata_init+0x0/0xb4 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0xb4 returned 0 after 976 usecs
calling  phy_init+0x0/0x57 @ 1
device class 'mdio_bus': registering
bus: 'mdio_bus': registered
bus: 'mdio_bus': add driver Generic PHY
initcall phy_init+0x0/0x57 returned 0 after 2929 usecs
calling  usb_init+0x0/0x199 @ 1
bus: 'usb': registered
bus: 'usb': add driver usbfs
usbcore: registered new interface driver usbfs
bus: 'usb': add driver hub
usbcore: registered new interface driver hub
bus: 'usb': add driver usb
usbcore: registered new device driver usb
initcall usb_init+0x0/0x199 returned 0 after 8789 usecs
calling  serio_init+0x0/0xb2 @ 1
bus: 'serio': registered
initcall serio_init+0x0/0xb2 returned 0 after 976 usecs
calling  gameport_init+0x0/0xb2 @ 1
bus: 'gameport': registered
initcall gameport_init+0x0/0xb2 returned 0 after 976 usecs
calling  input_init+0x0/0x164 @ 1
device class 'input': registering
initcall input_init+0x0/0x164 returned 0 after 1953 usecs
calling  rtc_init+0x0/0x87 @ 1
device class 'rtc': registering
initcall rtc_init+0x0/0x87 returned 0 after 1953 usecs
calling  pps_init+0x0/0xd7 @ 1
device class 'pps': registering
LinuxPPS API ver. 1 registered
Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
initcall pps_init+0x0/0xd7 returned 0 after 2929 usecs
calling  power_supply_class_init+0x0/0x5f @ 1
device class 'power_supply': registering
initcall power_supply_class_init+0x0/0x5f returned 0 after 976 usecs
calling  hwmon_init+0x0/0x6e @ 1
device class 'hwmon': registering
initcall hwmon_init+0x0/0x6e returned 0 after 976 usecs
calling  leds_init+0x0/0x67 @ 1
device class 'leds': registering
initcall leds_init+0x0/0x67 returned 0 after 1953 usecs
calling  pci_subsys_init+0x0/0x125 @ 1
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
device: 'pci0000:00': device_add
device: '0000:00': device_add
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xec
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
pci 0000:00:01.1: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
pci 0000:00:0a.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0b.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0c.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0d.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0e.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x1dd
PCI: Fixups for bus 0000:00
pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
PCI: Scanning bus 0000:05
pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:05:07.0: supports D1 D2
pci 0000:05:07.0: PME# supported from D1 D2 D3hot
pci 0000:05:07.0: PME# disabled
PCI: Fixups for bus 0000:05
pci 0000:00:09.0: transparent bridge
pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
PCI: Bus scan for 0000:05 returning with max=05
pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
PCI: Scanning bus 0000:04
PCI: Fixups for bus 0000:04
PCI: Bus scan for 0000:04 returning with max=04
pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
PCI: Scanning bus 0000:03
PCI: Fixups for bus 0000:03
PCI: Bus scan for 0000:03 returning with max=03
pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
PCI: Fixups for bus 0000:02
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
PCI: Scanning bus 0000:01
pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x47
pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x47
pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x1dd
pci 0000:01:00.1: supports D1 D2
PCI: Fixups for bus 0000:01
pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
PCI: Bus scan for 0000:01 returning with max=01
pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
PCI: Bus scan for 0000:00 returning with max=05
device: '0000:00:00.0': device_add
bus: 'pci': add device 0000:00:00.0
device: '0000:00:01.0': device_add
bus: 'pci': add device 0000:00:01.0
device: '0000:00:01.1': device_add
bus: 'pci': add device 0000:00:01.1
device: '0000:00:02.0': device_add
bus: 'pci': add device 0000:00:02.0
device: '0000:00:02.1': device_add
bus: 'pci': add device 0000:00:02.1
device: '0000:00:04.0': device_add
bus: 'pci': add device 0000:00:04.0
device: '0000:00:06.0': device_add
bus: 'pci': add device 0000:00:06.0
device: '0000:00:09.0': device_add
bus: 'pci': add device 0000:00:09.0
device: '0000:00:0a.0': device_add
bus: 'pci': add device 0000:00:0a.0
device: '0000:00:0b.0': device_add
bus: 'pci': add device 0000:00:0b.0
device: '0000:00:0c.0': device_add
bus: 'pci': add device 0000:00:0c.0
device: '0000:00:0d.0': device_add
bus: 'pci': add device 0000:00:0d.0
device: '0000:00:0e.0': device_add
bus: 'pci': add device 0000:00:0e.0
device: '0000:00:18.0': device_add
bus: 'pci': add device 0000:00:18.0
device: '0000:00:18.1': device_add
bus: 'pci': add device 0000:00:18.1
device: '0000:00:18.2': device_add
bus: 'pci': add device 0000:00:18.2
device: '0000:00:18.3': device_add
bus: 'pci': add device 0000:00:18.3
device: '0000:05:07.0': device_add
bus: 'pci': add device 0000:05:07.0
device: '0000:05': device_add
device: '0000:04': device_add
device: '0000:03': device_add
device: '0000:02': device_add
device: '0000:01:00.0': device_add
bus: 'pci': add device 0000:01:00.0
device: '0000:01:00.1': device_add
bus: 'pci': add device 0000:01:00.1
device: '0000:01': device_add
pci 0000:00:00.0: default IRQ router [10de:005e]
initcall pci_subsys_init+0x0/0x125 returned 0 after 178710 usecs
calling  proto_init+0x0/0x39 @ 1
initcall proto_init+0x0/0x39 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x201 @ 1
device class 'net': registering
device: 'lo': device_add
initcall net_dev_init+0x0/0x201 returned 0 after 1953 usecs
calling  neigh_init+0x0/0x98 @ 1
initcall neigh_init+0x0/0x98 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xf7 @ 1
initcall pktsched_init+0x0/0xf7 returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x73 @ 1
initcall tc_filter_init+0x0/0x73 returned 0 after 0 usecs
calling  tc_action_init+0x0/0x73 @ 1
initcall tc_action_init+0x0/0x73 returned 0 after 0 usecs
calling  genl_init+0x0/0xb8 @ 1
initcall genl_init+0x0/0xb8 returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0xae @ 1
initcall cipso_v4_init+0x0/0xae returned 0 after 0 usecs
calling  wanrouter_init+0x0/0x79 @ 1
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x79 returned 0 after 976 usecs
calling  netlbl_init+0x0/0xa8 @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0xa8 returned 0 after 3906 usecs
calling  sysctl_init+0x0/0x6f @ 1
initcall sysctl_init+0x0/0x6f returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x3e @ 1
initcall pci_iommu_init+0x0/0x3e returned 0 after 0 usecs
calling  print_all_ICs+0x0/0xdd @ 1

printing PIC contents
... PIC  IMR: fffa
... PIC  IRR: 0001
... PIC  ISR: 0001
... PIC ELCR: 0828
printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00000400
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 00003112
... APIC TMCCT: 00001533
... APIC TDCR: 00000003

printing local APIC contents on CPU#1/1:
... APIC ID:      01000000 (1)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 02000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR2: 01000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010400
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 00003112
... APIC TMCCT: 000018ec
... APIC TDCR: 00000003

number of MP IRQ sources: 17.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 003 0    0    0   0   0    1    1    30
 01 003 0    0    0   0   0    1    1    31
 02 000 1    0    0   0   0    0    0    00
 03 003 1    1    0   1   0    1    1    33
 04 003 0    0    0   0   0    1    1    34
 05 003 1    1    0   1   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 1    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    0    0   0   0    1    1    39
 0a 003 0    0    0   0   0    1    1    3A
 0b 003 1    1    0   1   0    1    1    3B
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
IRQ0 -> 0:0
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
initcall print_all_ICs+0x0/0xdd returned 0 after 152343 usecs
calling  hpet_late_init+0x0/0xee @ 1
initcall hpet_late_init+0x0/0xee returned -19 after 0 usecs
calling  clocksource_done_booting+0x0/0x5f @ 1
Switching to clocksource jiffies
initcall clocksource_done_booting+0x0/0x5f returned 0 after 976 usecs
calling  ftrace_init_debugfs+0x0/0x67 @ 1
initcall ftrace_init_debugfs+0x0/0x67 returned 0 after 0 usecs
calling  rb_init_debugfs+0x0/0x56 @ 1
initcall rb_init_debugfs+0x0/0x56 returned 0 after 0 usecs
calling  tracer_init_debugfs+0x0/0x267 @ 1
initcall tracer_init_debugfs+0x0/0x267 returned 0 after 976 usecs
calling  init_trace_printk_function_export+0x0/0x56 @ 1
initcall init_trace_printk_function_export+0x0/0x56 returned 0 after 0 usecs
calling  stat_workqueue_init+0x0/0x54 @ 1
initcall stat_workqueue_init+0x0/0x54 returned 0 after 0 usecs
calling  event_trace_init+0x0/0x210 @ 1
initcall event_trace_init+0x0/0x210 returned 0 after 11718 usecs
calling  ksym_tracer_stat_init+0x0/0x54 @ 1
initcall ksym_tracer_stat_init+0x0/0x54 returned 0 after 0 usecs
calling  init_pipe_fs+0x0/0x72 @ 1
initcall init_pipe_fs+0x0/0x72 returned 0 after 0 usecs
calling  eventpoll_init+0x0/0x102 @ 1
initcall eventpoll_init+0x0/0x102 returned 0 after 0 usecs
calling  anon_inode_init+0x0/0x150 @ 1
initcall anon_inode_init+0x0/0x150 returned 0 after 0 usecs
calling  tomoyo_initerface_init+0x0/0x181 @ 1
initcall tomoyo_initerface_init+0x0/0x181 returned 0 after 0 usecs
calling  blk_scsi_ioctl_init+0x0/0x2ad @ 1
initcall blk_scsi_ioctl_init+0x0/0x2ad returned 0 after 0 usecs
calling  chr_dev_init+0x0/0xd6 @ 1
device class 'mem': registering
device: 'mem': device_add
device: 'kmem': device_add
device: 'null': device_add
device: 'port': device_add
device: 'zero': device_add
device: 'full': device_add
device: 'random': device_add
device: 'urandom': device_add
device: 'kmsg': device_add
device: 'oldmem': device_add
initcall chr_dev_init+0x0/0xd6 returned 0 after 14648 usecs
calling  firmware_class_init+0x0/0x9f @ 1
device class 'firmware': registering
initcall firmware_class_init+0x0/0x9f returned 0 after 976 usecs
calling  pcibios_assign_resources+0x0/0x9a @ 1
pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
pci 0000:00:09.0:   IO window: 0xc000-0xcfff
pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: disabled
pci 0000:00:0c.0:   PREFETCH window: disabled
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: disabled
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
initcall pcibios_assign_resources+0x0/0x9a returned 0 after 34179 usecs
calling  sysctl_core_init+0x0/0x5f @ 1
initcall sysctl_core_init+0x0/0x5f returned 0 after 0 usecs
calling  inet_init+0x0/0x1c5 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
IPv4 FIB: Using LC-trie version 0.409
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x1c5 returned 0 after 13671 usecs
calling  af_unix_init+0x0/0x7b @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x7b returned 0 after 976 usecs
calling  populate_rootfs+0x0/0x12d @ 1
initcall populate_rootfs+0x0/0x12d returned 0 after 976 usecs
calling  calgary_fixup_tce_spaces+0x0/0x121 @ 1
initcall calgary_fixup_tce_spaces+0x0/0x121 returned -19 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x49 @ 1
Registering sysdev class 'i8259'
Registering sys device of class 'i8259'
Registering sys device 'i82590'
initcall i8259A_init_sysfs+0x0/0x49 returned 0 after 2929 usecs
calling  vsyscall_init+0x0/0x6c @ 1
initcall vsyscall_init+0x0/0x6c returned 0 after 0 usecs
calling  sbf_init+0x0/0x118 @ 1
initcall sbf_init+0x0/0x118 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x49 @ 1
Registering sysdev class 'i8237'
Registering sys device of class 'i8237'
Registering sys device 'i82370'
initcall i8237A_init_sysfs+0x0/0x49 returned 0 after 3906 usecs
calling  add_rtc_cmos+0x0/0x68 @ 1
Registering platform device 'rtc_cmos'. Parent at platform
device: 'rtc_cmos': device_add
bus: 'platform': add device rtc_cmos
platform rtc_cmos: registered platform RTC device (no PNP device found)
initcall add_rtc_cmos+0x0/0x68 returned 0 after 4882 usecs
calling  cache_sysfs_init+0x0/0x87 @ 1
initcall cache_sysfs_init+0x0/0x87 returned 0 after 1953 usecs
calling  mce_init_device+0x0/0x125 @ 1
Registering sysdev class 'machinecheck'
Registering sys device of class 'machinecheck'
Registering sys device 'machinecheck0'
Registering sys device of class 'machinecheck'
Registering sys device 'machinecheck1'
device: 'mcelog': device_add
initcall mce_init_device+0x0/0x125 returned 0 after 6835 usecs
calling  threshold_init_device+0x0/0xb4 @ 1
initcall threshold_init_device+0x0/0xb4 returned 0 after 0 usecs
calling  inject_init+0x0/0x57 @ 1
Machine check injector initialized
initcall inject_init+0x0/0x57 returned 0 after 976 usecs
calling  ioapic_init_sysfs+0x0/0xd2 @ 1
Registering sysdev class 'ioapic'
Registering sys device of class 'ioapic'
Registering sys device 'ioapic0'
initcall ioapic_init_sysfs+0x0/0xd2 returned 0 after 2929 usecs
calling  add_pcspkr+0x0/0x4f @ 1
Registering platform device 'pcspkr'. Parent at platform
device: 'pcspkr': device_add
bus: 'platform': add device pcspkr
initcall add_pcspkr+0x0/0x4f returned 0 after 2929 usecs
calling  audit_classes_init+0x0/0xd6 @ 1
initcall audit_classes_init+0x0/0xd6 returned 0 after 0 usecs
calling  start_pageattr_test+0x0/0x6c @ 1
initcall start_pageattr_test+0x0/0x6c returned 0 after 0 usecs
calling  pt_dump_init+0x0/0x57 @ 1
initcall pt_dump_init+0x0/0x57 returned 0 after 0 usecs
calling  aes_init+0x0/0x39 @ 1
initcall aes_init+0x0/0x39 returned 0 after 976 usecs
calling  init_vdso_vars+0x0/0x24e @ 1
initcall init_vdso_vars+0x0/0x24e returned 0 after 0 usecs
calling  ia32_binfmt_init+0x0/0x3b @ 1
initcall ia32_binfmt_init+0x0/0x3b returned 0 after 0 usecs
calling  sysenter_setup+0x0/0xd5 @ 1
initcall sysenter_setup+0x0/0xd5 returned 0 after 0 usecs
calling  init_aout_binfmt+0x0/0x3b @ 1
initcall init_aout_binfmt+0x0/0x3b returned 0 after 0 usecs
calling  init_sched_debug_procfs+0x0/0x53 @ 1
initcall init_sched_debug_procfs+0x0/0x53 returned 0 after 0 usecs
calling  proc_schedstat_init+0x0/0x49 @ 1
initcall proc_schedstat_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_execdomains_init+0x0/0x49 @ 1
initcall proc_execdomains_init+0x0/0x49 returned 0 after 0 usecs
calling  ioresources_init+0x0/0x63 @ 1
initcall ioresources_init+0x0/0x63 returned 0 after 0 usecs
calling  uid_cache_init+0x0/0xb4 @ 1
initcall uid_cache_init+0x0/0xb4 returned 0 after 0 usecs
calling  init_posix_timers+0x0/0x1b4 @ 1
initcall init_posix_timers+0x0/0x1b4 returned 0 after 0 usecs
calling  init_posix_cpu_timers+0x0/0x109 @ 1
initcall init_posix_cpu_timers+0x0/0x109 returned 0 after 0 usecs
calling  nsproxy_cache_init+0x0/0x54 @ 1
initcall nsproxy_cache_init+0x0/0x54 returned 0 after 0 usecs
calling  create_proc_profile+0x0/0x91 @ 1
initcall create_proc_profile+0x0/0x91 returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x49 @ 1
Registering sysdev class 'timekeeping'
Registering sys device of class 'timekeeping'
Registering sys device 'timekeeping0'
initcall timekeeping_init_device+0x0/0x49 returned 0 after 2929 usecs
calling  init_clocksource_sysfs+0x0/0x77 @ 1
Registering sysdev class 'clocksource'
Registering sys device of class 'clocksource'
Registering sys device 'clocksource0'
initcall init_clocksource_sysfs+0x0/0x77 returned 0 after 3906 usecs
calling  init_timer_list_procfs+0x0/0x53 @ 1
initcall init_timer_list_procfs+0x0/0x53 returned 0 after 0 usecs
calling  lockdep_proc_init+0x0/0x69 @ 1
initcall lockdep_proc_init+0x0/0x69 returned 0 after 0 usecs
calling  futex_init+0x0/0xac @ 1
initcall futex_init+0x0/0xac returned 0 after 0 usecs
calling  proc_dma_init+0x0/0x49 @ 1
initcall proc_dma_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_modules_init+0x0/0x49 @ 1
initcall proc_modules_init+0x0/0x49 returned 0 after 0 usecs
calling  kallsyms_init+0x0/0x4c @ 1
initcall kallsyms_init+0x0/0x4c returned 0 after 0 usecs
calling  ikconfig_init+0x0/0x60 @ 1
initcall ikconfig_init+0x0/0x60 returned 0 after 0 usecs
calling  audit_init+0x0/0x17a @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1253120958.249:1): initialized
initcall audit_init+0x0/0x17a returned 0 after 1953 usecs
calling  audit_tree_init+0x0/0x70 @ 1
initcall audit_tree_init+0x0/0x70 returned 0 after 0 usecs
calling  hung_task_init+0x0/0x79 @ 1
initcall hung_task_init+0x0/0x79 returned 0 after 0 usecs
calling  rcuclassic_trace_init+0x0/0x11e @ 1
initcall rcuclassic_trace_init+0x0/0x11e returned 0 after 0 usecs
calling  utsname_sysctl_init+0x0/0x3b @ 1
initcall utsname_sysctl_init+0x0/0x3b returned 0 after 0 usecs
calling  init_markers+0x0/0x3e @ 1
initcall init_markers+0x0/0x3e returned 0 after 0 usecs
calling  init_tracepoints+0x0/0x3e @ 1
initcall init_tracepoints+0x0/0x3e returned 0 after 0 usecs
calling  init_lstats_procfs+0x0/0x4c @ 1
initcall init_lstats_procfs+0x0/0x4c returned 0 after 0 usecs
calling  ftrace_nodyn_init+0x0/0x37 @ 1
initcall ftrace_nodyn_init+0x0/0x37 returned 0 after 0 usecs
calling  init_events+0x0/0x8c @ 1
initcall init_events+0x0/0x8c returned 0 after 0 usecs
calling  init_sched_switch_trace+0x0/0x39 @ 1
Testing tracer sched_switch: 
Clocksource tsc unstable (delta = 1015958002 ns)
PASSED
initcall init_sched_switch_trace+0x0/0x39 returned 0 after 111328 usecs
calling  init_stack_trace+0x0/0x39 @ 1
Testing tracer sysprof: .. no entries found ..FAILED!
initcall init_stack_trace+0x0/0x39 returned -1 after 105468 usecs
initcall init_stack_trace+0x0/0x39 returned with error code -1 
calling  init_function_trace+0x0/0x39 @ 1
Testing tracer function: PASSED
initcall init_function_trace+0x0/0x39 returned 0 after 111328 usecs
calling  init_irqsoff_tracer+0x0/0x3b @ 1
Testing tracer irqsoff: PASSED
initcall init_irqsoff_tracer+0x0/0x3b returned 0 after 10742 usecs
calling  init_wakeup_tracer+0x0/0x49 @ 1
Testing tracer wakeup: PASSED
Testing tracer wakeup_rt: PASSED
initcall init_wakeup_tracer+0x0/0x49 returned 0 after 614257 usecs
calling  stack_trace_init+0x0/0x91 @ 1
initcall stack_trace_init+0x0/0x91 returned 0 after 0 usecs
calling  init_mmio_trace+0x0/0x39 @ 1
initcall init_mmio_trace+0x0/0x39 returned 0 after 0 usecs
calling  init_power_trace+0x0/0x39 @ 1
initcall init_power_trace+0x0/0x39 returned 0 after 0 usecs
calling  init_kmem_tracer+0x0/0x7d @ 1
Warning: could not register the kmem tracer
initcall init_kmem_tracer+0x0/0x7d returned 1 after 976 usecs
initcall init_kmem_tracer+0x0/0x7d returned with error code 1 
calling  init_blk_tracer+0x0/0x7e @ 1
initcall init_blk_tracer+0x0/0x7e returned 0 after 0 usecs
calling  init_ksym_trace+0x0/0x76 @ 1
Testing tracer ksym_tracer: PASSED
initcall init_ksym_trace+0x0/0x76 returned 0 after 26367 usecs
calling  perf_counter_sysfs_init+0x0/0x40 @ 1
initcall perf_counter_sysfs_init+0x0/0x40 returned 0 after 0 usecs
calling  init_per_zone_wmark_min+0x0/0x8d @ 1
initcall init_per_zone_wmark_min+0x0/0x8d returned 0 after 0 usecs
calling  kswapd_init+0x0/0x47 @ 1
initcall kswapd_init+0x0/0x47 returned 0 after 0 usecs
calling  init_tmpfs+0x0/0x103 @ 1
initcall init_tmpfs+0x0/0x103 returned 0 after 0 usecs
calling  setup_vmstat+0x0/0xe4 @ 1
initcall setup_vmstat+0x0/0xe4 returned 0 after 0 usecs
calling  mm_sysfs_init+0x0/0x50 @ 1
initcall mm_sysfs_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_vmalloc_init+0x0/0x4c @ 1
initcall proc_vmalloc_init+0x0/0x4c returned 0 after 0 usecs
calling  procswaps_init+0x0/0x49 @ 1
initcall procswaps_init+0x0/0x49 returned 0 after 0 usecs
calling  hugetlb_init+0x0/0x1fd @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x1fd returned 0 after 976 usecs
calling  slab_proc_init+0x0/0x4c @ 1
initcall slab_proc_init+0x0/0x4c returned 0 after 0 usecs
calling  slab_sysfs_init+0x0/0x119 @ 1
initcall slab_sysfs_init+0x0/0x119 returned 0 after 39062 usecs
calling  fasync_init+0x0/0x51 @ 1
initcall fasync_init+0x0/0x51 returned 0 after 976 usecs
calling  proc_filesystems_init+0x0/0x49 @ 1
initcall proc_filesystems_init+0x0/0x49 returned 0 after 0 usecs
calling  inotify_setup+0x0/0x37 @ 1
initcall inotify_setup+0x0/0x37 returned 0 after 0 usecs
calling  inotify_user_setup+0x0/0xe5 @ 1
initcall inotify_user_setup+0x0/0xe5 returned 0 after 976 usecs
calling  aio_setup+0x0/0xce @ 1
initcall aio_setup+0x0/0xce returned 0 after 976 usecs
calling  proc_locks_init+0x0/0x49 @ 1
initcall proc_locks_init+0x0/0x49 returned 0 after 0 usecs
calling  init_sys32_ioctl+0x0/0xac @ 1
initcall init_sys32_ioctl+0x0/0xac returned 0 after 0 usecs
calling  init_mbcache+0x0/0x3b @ 1
initcall init_mbcache+0x0/0x3b returned 0 after 0 usecs
calling  dquot_init+0x0/0x10c @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x10c returned 0 after 2929 usecs
calling  init_v1_quota_format+0x0/0x39 @ 1
initcall init_v1_quota_format+0x0/0x39 returned 0 after 0 usecs
calling  proc_cmdline_init+0x0/0x49 @ 1
initcall proc_cmdline_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_cpuinfo_init+0x0/0x49 @ 1
initcall proc_cpuinfo_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_devices_init+0x0/0x49 @ 1
initcall proc_devices_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_interrupts_init+0x0/0x49 @ 1
initcall proc_interrupts_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_loadavg_init+0x0/0x49 @ 1
initcall proc_loadavg_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_meminfo_init+0x0/0x49 @ 1
initcall proc_meminfo_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_stat_init+0x0/0x49 @ 1
initcall proc_stat_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_uptime_init+0x0/0x49 @ 1
initcall proc_uptime_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_version_init+0x0/0x49 @ 1
initcall proc_version_init+0x0/0x49 returned 0 after 0 usecs
calling  proc_softirqs_init+0x0/0x49 @ 1
initcall proc_softirqs_init+0x0/0x49 returned 0 after 0 usecs
calling  vmcore_init+0x0/0x9e @ 1
initcall vmcore_init+0x0/0x9e returned 0 after 0 usecs
calling  proc_kmsg_init+0x0/0x4c @ 1
initcall proc_kmsg_init+0x0/0x4c returned 0 after 0 usecs
calling  proc_page_init+0x0/0x69 @ 1
initcall proc_page_init+0x0/0x69 returned 0 after 0 usecs
calling  configfs_init+0x0/0xfb @ 1
initcall configfs_init+0x0/0xfb returned 0 after 0 usecs
calling  init_devpts_fs+0x0/0x72 @ 1
initcall init_devpts_fs+0x0/0x72 returned 0 after 0 usecs
calling  init_ext3_fs+0x0/0x99 @ 1
initcall init_ext3_fs+0x0/0x99 returned 0 after 976 usecs
calling  init_ext2_fs+0x0/0x99 @ 1
initcall init_ext2_fs+0x0/0x99 returned 0 after 976 usecs
calling  init_ext4_fs+0x0/0x11f @ 1
initcall init_ext4_fs+0x0/0x11f returned 0 after 1953 usecs
calling  journal_init+0x0/0xb9 @ 1
initcall journal_init+0x0/0xb9 returned 0 after 1953 usecs
calling  journal_init+0x0/0xd6 @ 1
initcall journal_init+0x0/0xd6 returned 0 after 1953 usecs
calling  init_cramfs_fs+0x0/0x57 @ 1
initcall init_cramfs_fs+0x0/0x57 returned 0 after 0 usecs
calling  init_squashfs_fs+0x0/0x93 @ 1
squashfs: version 4.0 (2009/01/31) Phillip Lougher
initcall init_squashfs_fs+0x0/0x93 returned 0 after 976 usecs
calling  init_ramfs_fs+0x0/0x39 @ 1
initcall init_ramfs_fs+0x0/0x39 returned 0 after 0 usecs
calling  init_hugetlbfs_fs+0x0/0xbe @ 1
initcall init_hugetlbfs_fs+0x0/0xbe returned 0 after 976 usecs
calling  init_minix_fs+0x0/0x89 @ 1
initcall init_minix_fs+0x0/0x89 returned 0 after 0 usecs
calling  init_fat_fs+0x0/0x75 @ 1
initcall init_fat_fs+0x0/0x75 returned 0 after 976 usecs
calling  init_msdos_fs+0x0/0x39 @ 1
initcall init_msdos_fs+0x0/0x39 returned 0 after 0 usecs
calling  init_bfs_fs+0x0/0x89 @ 1
initcall init_bfs_fs+0x0/0x89 returned 0 after 976 usecs
calling  init_iso9660_fs+0x0/0x99 @ 1
initcall init_iso9660_fs+0x0/0x99 returned 0 after 976 usecs
calling  init_hfsplus_fs+0x0/0x83 @ 1
initcall init_hfsplus_fs+0x0/0x83 returned 0 after 0 usecs
calling  init_hfs_fs+0x0/0x83 @ 1
initcall init_hfs_fs+0x0/0x83 returned 0 after 976 usecs
calling  ecryptfs_init+0x0/0x220 @ 1
device: 'ecryptfs': device_add
initcall ecryptfs_init+0x0/0x220 returned 0 after 6835 usecs
calling  vxfs_init+0x0/0x7f @ 1
initcall vxfs_init+0x0/0x7f returned 0 after 976 usecs
calling  init_nls_cp437+0x0/0x39 @ 1
initcall init_nls_cp437+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_cp737+0x0/0x39 @ 1
initcall init_nls_cp737+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_cp857+0x0/0x39 @ 1
initcall init_nls_cp857+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_cp860+0x0/0x39 @ 1
initcall init_nls_cp860+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_cp936+0x0/0x39 @ 1
initcall init_nls_cp936+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_ascii+0x0/0x39 @ 1
initcall init_nls_ascii+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_iso8859_2+0x0/0x39 @ 1
initcall init_nls_iso8859_2+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_iso8859_3+0x0/0x39 @ 1
initcall init_nls_iso8859_3+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_iso8859_7+0x0/0x39 @ 1
initcall init_nls_iso8859_7+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_koi8_u+0x0/0x39 @ 1
initcall init_nls_koi8_u+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_koi8_ru+0x0/0x6f @ 1
initcall init_nls_koi8_ru+0x0/0x6f returned 0 after 0 usecs
calling  init_nls_utf8+0x0/0x4a @ 1
initcall init_nls_utf8+0x0/0x4a returned 0 after 0 usecs
calling  init_sysv_fs+0x0/0x75 @ 1
initcall init_sysv_fs+0x0/0x75 returned 0 after 0 usecs
calling  init_efs_fs+0x0/0x95 @ 1
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall init_efs_fs+0x0/0x95 returned 0 after 976 usecs
calling  init_qnx4_fs+0x0/0x99 @ 1
QNX4 filesystem 0.2.3 registered.
initcall init_qnx4_fs+0x0/0x99 returned 0 after 1953 usecs
calling  fuse_init+0x0/0x15c @ 1
fuse init (API version 7.12)
device: 'fuse': device_add
initcall fuse_init+0x0/0x15c returned 0 after 2929 usecs
calling  init_befs_fs+0x0/0xa4 @ 1
BeFS version: 0.9.3
initcall init_befs_fs+0x0/0xa4 returned 0 after 1953 usecs
calling  ocfs2_init+0x0/0x352 @ 1
OCFS2 1.5.0
initcall ocfs2_init+0x0/0x352 returned 0 after 2929 usecs
calling  ocfs2_stack_glue_init+0x0/0xbb @ 1
initcall ocfs2_stack_glue_init+0x0/0xbb returned 0 after 0 usecs
calling  init_o2nm+0x0/0xcf @ 1
OCFS2 Node Manager 1.5.0
initcall init_o2nm+0x0/0xcf returned 0 after 3906 usecs
calling  key_proc_init+0x0/0x80 @ 1
initcall key_proc_init+0x0/0x80 returned 0 after 0 usecs
calling  selinux_nf_ip_init+0x0/0x85 @ 1
SELinux:  Registering netfilter hooks
initcall selinux_nf_ip_init+0x0/0x85 returned 0 after 976 usecs
calling  init_sel_fs+0x0/0x8e @ 1
initcall init_sel_fs+0x0/0x8e returned 0 after 0 usecs
calling  selnl_init+0x0/0x74 @ 1
initcall selnl_init+0x0/0x74 returned 0 after 0 usecs
calling  sel_netif_init+0x0/0x8d @ 1
initcall sel_netif_init+0x0/0x8d returned 0 after 0 usecs
calling  sel_netnode_init+0x0/0x9a @ 1
initcall sel_netnode_init+0x0/0x9a returned 0 after 0 usecs
calling  sel_netport_init+0x0/0x9a @ 1
initcall sel_netport_init+0x0/0x9a returned 0 after 0 usecs
calling  aurule_init+0x0/0x5e @ 1
initcall aurule_init+0x0/0x5e returned 0 after 0 usecs
calling  crypto_wq_init+0x0/0x59 @ 1
initcall crypto_wq_init+0x0/0x59 returned 0 after 976 usecs
calling  crypto_algapi_init+0x0/0x34 @ 1
initcall crypto_algapi_init+0x0/0x34 returned 0 after 0 usecs
calling  skcipher_module_init+0x0/0x5d @ 1
initcall skcipher_module_init+0x0/0x5d returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x39 @ 1
initcall chainiv_module_init+0x0/0x39 returned 0 after 0 usecs
calling  eseqiv_module_init+0x0/0x39 @ 1
initcall eseqiv_module_init+0x0/0x39 returned 0 after 0 usecs
calling  seqiv_module_init+0x0/0x39 @ 1
initcall seqiv_module_init+0x0/0x39 returned 0 after 0 usecs
calling  hmac_module_init+0x0/0x39 @ 1
initcall hmac_module_init+0x0/0x39 returned 0 after 0 usecs
calling  vmac_module_init+0x0/0x39 @ 1
initcall vmac_module_init+0x0/0x39 returned 0 after 0 usecs
calling  md5_mod_init+0x0/0x39 @ 1
initcall md5_mod_init+0x0/0x39 returned 0 after 0 usecs
calling  rmd128_mod_init+0x0/0x39 @ 1
initcall rmd128_mod_init+0x0/0x39 returned 0 after 976 usecs
calling  rmd160_mod_init+0x0/0x39 @ 1
initcall rmd160_mod_init+0x0/0x39 returned 0 after 976 usecs
calling  rmd320_mod_init+0x0/0x39 @ 1
initcall rmd320_mod_init+0x0/0x39 returned 0 after 0 usecs
calling  sha1_generic_mod_init+0x0/0x39 @ 1
initcall sha1_generic_mod_init+0x0/0x39 returned 0 after 0 usecs
calling  crypto_cbc_module_init+0x0/0x39 @ 1
initcall crypto_cbc_module_init+0x0/0x39 returned 0 after 0 usecs
calling  crypto_pcbc_module_init+0x0/0x39 @ 1
initcall crypto_pcbc_module_init+0x0/0x39 returned 0 after 0 usecs
calling  crypto_ctr_module_init+0x0/0x69 @ 1
initcall crypto_ctr_module_init+0x0/0x69 returned 0 after 0 usecs
calling  crypto_gcm_module_init+0x0/0xaf @ 1
initcall crypto_gcm_module_init+0x0/0xaf returned 0 after 0 usecs
calling  cryptd_init+0x0/0xfd @ 1
initcall cryptd_init+0x0/0xfd returned 0 after 0 usecs
calling  des_generic_mod_init+0x0/0x65 @ 1
initcall des_generic_mod_init+0x0/0x65 returned 0 after 976 usecs
calling  fcrypt_mod_init+0x0/0x39 @ 1
alg: No test for fcrypt (fcrypt-generic)
initcall fcrypt_mod_init+0x0/0x39 returned 0 after 3906 usecs
calling  twofish_mod_init+0x0/0x39 @ 1
initcall twofish_mod_init+0x0/0x39 returned 0 after 0 usecs
calling  serpent_mod_init+0x0/0x65 @ 1
initcall serpent_mod_init+0x0/0x65 returned 0 after 976 usecs
calling  aes_init+0x0/0x39 @ 1
initcall aes_init+0x0/0x39 returned 0 after 0 usecs
calling  seed_init+0x0/0x39 @ 1
initcall seed_init+0x0/0x39 returned 0 after 0 usecs
calling  deflate_mod_init+0x0/0x39 @ 1
initcall deflate_mod_init+0x0/0x39 returned 0 after 976 usecs
calling  crc32c_mod_init+0x0/0x39 @ 1
initcall crc32c_mod_init+0x0/0x39 returned 0 after 0 usecs
calling  crypto_authenc_module_init+0x0/0x39 @ 1
initcall crypto_authenc_module_init+0x0/0x39 returned 0 after 0 usecs
calling  lzo_mod_init+0x0/0x39 @ 1
initcall lzo_mod_init+0x0/0x39 returned 0 after 0 usecs
calling  krng_mod_init+0x0/0x39 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x39 returned 0 after 2929 usecs
calling  ghash_mod_init+0x0/0x39 @ 1
alg: No test for ghash (ghash-generic)
initcall ghash_mod_init+0x0/0x39 returned 0 after 3906 usecs
calling  proc_genhd_init+0x0/0x63 @ 1
initcall proc_genhd_init+0x0/0x63 returned 0 after 0 usecs
calling  bsg_init+0x0/0x155 @ 1
device class 'bsg': registering
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
initcall bsg_init+0x0/0x155 returned 0 after 1953 usecs
calling  noop_init+0x0/0x3b @ 1
io scheduler noop registered
initcall noop_init+0x0/0x3b returned 0 after 976 usecs
calling  as_init+0x0/0x3b @ 1
io scheduler anticipatory registered
initcall as_init+0x0/0x3b returned 0 after 976 usecs
calling  cfq_init+0x0/0xbb @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0xbb returned 0 after 1953 usecs
calling  debug_objects_init_debugfs+0x0/0x8a @ 1
initcall debug_objects_init_debugfs+0x0/0x8a returned 0 after 0 usecs
calling  libcrc32c_mod_init+0x0/0x53 @ 1
initcall libcrc32c_mod_init+0x0/0x53 returned 0 after 0 usecs
calling  percpu_counter_startup+0x0/0x40 @ 1
initcall percpu_counter_startup+0x0/0x40 returned 0 after 0 usecs
calling  dynamic_debug_init+0x0/0x14f @ 1
initcall dynamic_debug_init+0x0/0x14f returned 0 after 0 usecs
calling  pci_init+0x0/0x60 @ 1
pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:00.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:01.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:01.1: calling pci_fixup_video+0x0/0xe3
pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:02.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:02.1: calling pci_fixup_video+0x0/0xe3
pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:04.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:06.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:09.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:0a.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:0b.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa1
pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:18.0: calling pci_fixup_video+0x0/0xe3
pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:18.1: calling pci_fixup_video+0x0/0xe3
pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:18.2: calling pci_fixup_video+0x0/0xe3
pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:00:18.3: calling pci_fixup_video+0x0/0xe3
pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:05:07.0: calling pci_fixup_video+0x0/0xe3
pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:01:00.0: calling pci_fixup_video+0x0/0xe3
pci 0000:01:00.0: Boot video device
pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x4e
pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0xc4
pci 0000:01:00.1: calling pci_fixup_video+0x0/0xe3
initcall pci_init+0x0/0x60 returned 0 after 74218 usecs
calling  pci_proc_init+0x0/0x90 @ 1
initcall pci_proc_init+0x0/0x90 returned 0 after 976 usecs
calling  pci_stub_init+0x0/0x42 @ 1
bus: 'pci': add driver pci-stub
initcall pci_stub_init+0x0/0x42 returned 0 after 976 usecs
calling  display_class_init+0x0/0xa5 @ 1
device class 'display': registering
initcall display_class_init+0x0/0xa5 returned 0 after 1953 usecs
calling  rand_initialize+0x0/0x58 @ 1
initcall rand_initialize+0x0/0x58 returned 0 after 0 usecs
calling  tty_init+0x0/0x11c @ 1
device: 'tty': device_add
device: 'console': device_add
device: 'tty0': device_add
device class 'vc': registering
device: 'vcs': device_add
device: 'vcsa': device_add
device: 'vcs1': device_add
device: 'vcsa1': device_add
device: 'tty1': device_add
device: 'tty2': device_add
device: 'tty3': device_add
device: 'tty4': device_add
device: 'tty5': device_add
device: 'tty6': device_add
device: 'tty7': device_add
device: 'tty8': device_add
device: 'tty9': device_add
device: 'tty10': device_add
device: 'tty11': device_add
device: 'tty12': device_add
device: 'tty13': device_add
device: 'tty14': device_add
device: 'tty15': device_add
device: 'tty16': device_add
device: 'tty17': device_add
device: 'tty18': device_add
device: 'tty19': device_add
device: 'tty20': device_add
device: 'tty21': device_add
device: 'tty22': device_add
device: 'tty23': device_add
device: 'tty24': device_add
device: 'tty25': device_add
device: 'tty26': device_add
device: 'tty27': device_add
device: 'tty28': device_add
device: 'tty29': device_add
device: 'tty30': device_add
device: 'tty31': device_add
device: 'tty32': device_add
device: 'tty33': device_add
device: 'tty34': device_add
device: 'tty35': device_add
device: 'tty36': device_add
device: 'tty37': device_add
device: 'tty38': device_add
device: 'tty39': device_add
device: 'tty40': device_add
device: 'tty41': device_add
device: 'tty42': device_add
device: 'tty43': device_add
device: 'tty44': device_add
device: 'tty45': device_add
device: 'tty46': device_add
device: 'tty47': device_add
device: 'tty48': device_add
device: 'tty49': device_add
device: 'tty50': device_add
device: 'tty51': device_add
device: 'tty52': device_add
device: 'tty53': device_add
device: 'tty54': device_add
device: 'tty55': device_add
device: 'tty56': device_add
device: 'tty57': device_add
device: 'tty58': device_add
device: 'tty59': device_add
device: 'tty60': device_add
device: 'tty61': device_add
device: 'tty62': device_add
device: 'tty63': device_add
initcall tty_init+0x0/0x11c returned 0 after 91796 usecs
calling  pty_init+0x0/0x34 @ 1
device: 'ptmx': device_add
initcall pty_init+0x0/0x34 returned 0 after 976 usecs
calling  sysrq_init+0x0/0x4c @ 1
initcall sysrq_init+0x0/0x4c returned 0 after 0 usecs
calling  r3964_init+0x0/0x68 @ 1
r3964: Philips r3964 Driver $Revision: 1.10 $
initcall r3964_init+0x0/0x68 returned 0 after 976 usecs
calling  pc8736x_gpio_init+0x0/0x3b5 @ 1
Registering platform device 'pc8736x_gpio.0'. Parent at platform
device: 'pc8736x_gpio.0': device_add
bus: 'platform': add device pc8736x_gpio.0
platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
platform pc8736x_gpio.0: no device found
bus: 'platform': remove device pc8736x_gpio.0
initcall pc8736x_gpio_init+0x0/0x3b5 returned -19 after 5859 usecs
calling  nsc_gpio_init+0x0/0x3b @ 1
nsc_gpio initializing
initcall nsc_gpio_init+0x0/0x3b returned 0 after 976 usecs
calling  tlclk_init+0x0/0x226 @ 1
telclk_interrup = 0xf non-mcpbl0010 hw.
initcall tlclk_init+0x0/0x226 returned -6 after 1953 usecs
initcall tlclk_init+0x0/0x226 returned with error code -6 
calling  serial8250_init+0x0/0x16f @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Registering platform device 'serial8250'. Parent at platform
device: 'serial8250': device_add
bus: 'platform': add device serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
device: 'ttyS1': device_add
device: 'ttyS2': device_add
device: 'ttyS3': device_add
bus: 'platform': add driver serial8250
bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250
driver: 'serial8250': driver_bound: bound to device 'serial8250'
bus: 'platform': really_probe: bound device serial8250 to driver serial8250
initcall serial8250_init+0x0/0x16f returned 0 after 15625 usecs
calling  serial8250_pci_init+0x0/0x42 @ 1
bus: 'pci': add driver serial
initcall serial8250_pci_init+0x0/0x42 returned 0 after 976 usecs
calling  topology_sysfs_init+0x0/0xbf @ 1
initcall topology_sysfs_init+0x0/0xbf returned 0 after 0 usecs
calling  floppy_init+0x0/0x5bf @ 1
bus: 'platform': add driver floppy
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Registering platform device 'floppy.0'. Parent at platform
device: 'floppy.0': device_add
bus: 'platform': add device floppy.0
bus: 'platform': driver_probe_device: matched device floppy.0 with driver floppy
bus: 'platform': really_probe: probing driver floppy with device floppy.0
driver: 'floppy.0': driver_bound: bound to device 'floppy'
bus: 'platform': really_probe: bound device floppy.0 to driver floppy
device: 'fd0': device_add
device: '2:0': device_add
initcall floppy_init+0x0/0x5bf returned 0 after 26367 usecs
calling  brd_init+0x0/0x193 @ 1
device: 'ram0': device_add
device: '1:0': device_add
device: 'ram1': device_add
device: '1:1': device_add
device: 'ram2': device_add
device: '1:2': device_add
device: 'ram3': device_add
device: '1:3': device_add
device: 'ram4': device_add
device: '1:4': device_add
device: 'ram5': device_add
device: '1:5': device_add
device: 'ram6': device_add
device: '1:6': device_add
device: 'ram7': device_add
device: '1:7': device_add
device: 'ram8': device_add
device: '1:8': device_add
device: 'ram9': device_add
device: '1:9': device_add
device: 'ram10': device_add
device: '1:10': device_add
device: 'ram11': device_add
device: '1:11': device_add
device: 'ram12': device_add
device: '1:12': device_add
device: 'ram13': device_add
device: '1:13': device_add
device: 'ram14': device_add
device: '1:14': device_add
device: 'ram15': device_add
device: '1:15': device_add
brd: module loaded
initcall brd_init+0x0/0x193 returned 0 after 45898 usecs
calling  cpqarray_init+0x0/0x92 @ 1
Compaq SMART2 Driver (v 2.6.0)
bus: 'pci': add driver cpqarray
bus: 'pci': remove driver cpqarray
driver: 'cpqarray': driver_release
initcall cpqarray_init+0x0/0x92 returned -19 after 4882 usecs
calling  DAC960_init_module+0x0/0x78 @ 1
bus: 'pci': add driver DAC960
device: 'dac960_gam': device_add
initcall DAC960_init_module+0x0/0x78 returned 0 after 1953 usecs
calling  mm_init+0x0/0x1b9 @ 1
bus: 'pci': add driver umem
MM: desc_per_page = 128
initcall mm_init+0x0/0x1b9 returned 0 after 2929 usecs
calling  ibmasm_init+0x0/0x8a @ 1
bus: 'pci': add driver ibmasm
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
initcall ibmasm_init+0x0/0x8a returned 0 after 1953 usecs
calling  tifm_7xx1_init+0x0/0x42 @ 1
bus: 'pci': add driver tifm_7xx1
initcall tifm_7xx1_init+0x0/0x42 returned 0 after 976 usecs
calling  at24_init+0x0/0x5d @ 1
bus: 'i2c': add driver at24
i2c-core: driver [at24] registered
initcall at24_init+0x0/0x5d returned 0 after 1953 usecs
calling  eeprom_init+0x0/0x3b @ 1
bus: 'i2c': add driver eeprom
i2c-core: driver [eeprom] registered
initcall eeprom_init+0x0/0x3b returned 0 after 1953 usecs
calling  sm501_base_init+0x0/0x4e @ 1
bus: 'platform': add driver sm501
bus: 'pci': add driver sm501
initcall sm501_base_init+0x0/0x4e returned 0 after 1953 usecs
calling  pasic3_base_init+0x0/0x40 @ 1
bus: 'platform': add driver pasic3
bus: 'platform': remove driver pasic3
driver: 'pasic3': driver_release
initcall pasic3_base_init+0x0/0x40 returned -19 after 3906 usecs
calling  pcf50633_adc_init+0x0/0x39 @ 1
bus: 'platform': add driver pcf50633-adc
initcall pcf50633_adc_init+0x0/0x39 returned 0 after 976 usecs
calling  mac_hid_init+0x0/0xfd @ 1
device: 'input0': device_add
input: Macintosh mouse button emulation as /class/input/input0
initcall mac_hid_init+0x0/0xfd returned 0 after 1953 usecs
calling  raid_init+0x0/0x39 @ 1
device class 'raid_devices': registering
initcall raid_init+0x0/0x39 returned 0 after 976 usecs
calling  spi_transport_init+0x0/0x9f @ 1
device class 'spi_transport': registering
device class 'spi_host': registering
initcall spi_transport_init+0x0/0x9f returned 0 after 1953 usecs
calling  fc_transport_init+0x0/0x73 @ 1
device class 'fc_host': registering
device class 'fc_vports': registering
device class 'fc_remote_ports': registering
device class 'fc_transport': registering
initcall fc_transport_init+0x0/0x73 returned 0 after 5859 usecs
calling  iscsi_transport_init+0x0/0x173 @ 1
Loading iSCSI transport class v2.0-870.
device class 'iscsi_transport': registering
device class 'iscsi_endpoint': registering
device class 'iscsi_host': registering
device class 'iscsi_connection': registering
device class 'iscsi_session': registering
initcall iscsi_transport_init+0x0/0x173 returned 0 after 5859 usecs
calling  sas_transport_init+0x0/0xe1 @ 1
device class 'sas_host': registering
device class 'sas_phy': registering
device class 'sas_port': registering
device class 'sas_device': registering
device class 'sas_end_device': registering
device class 'sas_expander': registering
initcall sas_transport_init+0x0/0xe1 returned 0 after 7812 usecs
calling  sas_class_init+0x0/0x58 @ 1
initcall sas_class_init+0x0/0x58 returned 0 after 0 usecs
calling  scsi_dh_init+0x0/0x65 @ 1
initcall scsi_dh_init+0x0/0x65 returned 0 after 0 usecs
calling  clariion_init+0x0/0x5c @ 1
emc: device handler registered
initcall clariion_init+0x0/0x5c returned 0 after 976 usecs
calling  libfc_init+0x0/0x96 @ 1
initcall libfc_init+0x0/0x96 returned 0 after 976 usecs
calling  fnic_init_module+0x0/0x20d @ 1
fnic: Cisco FCoE HBA Driver, ver 1.0.0.1121
bus: 'pci': add driver fnic
initcall fnic_init_module+0x0/0x20d returned 0 after 4882 usecs
calling  iscsi_sw_tcp_init+0x0/0x67 @ 1
device: 'tcp': device_add
iscsi: registered transport (tcp)
initcall iscsi_sw_tcp_init+0x0/0x67 returned 0 after 1953 usecs
calling  advansys_init+0x0/0x42 @ 1
bus: 'pci': add driver advansys
initcall advansys_init+0x0/0x42 returned 0 after 976 usecs
calling  adpt_init+0x0/0xae @ 1
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
initcall adpt_init+0x0/0xae returned -19 after 1953 usecs
calling  ahc_linux_init+0x0/0x8d @ 1
bus: 'pci': add driver aic7xxx
initcall ahc_linux_init+0x0/0x8d returned 0 after 1953 usecs
calling  init_this_scsi_driver+0x0/0x10c @ 1
initcall init_this_scsi_driver+0x0/0x10c returned -19 after 0 usecs
calling  qla2x00_module_init+0x0/0x152 @ 1
QLogic Fibre Channel HBA Driver: 8.03.01-k6
bus: 'pci': add driver qla2xxx
initcall qla2x00_module_init+0x0/0x152 returned 0 after 2929 usecs
calling  lpfc_init+0x0/0xfb @ 1
Emulex LightPulse Fibre Channel SCSI driver 8.3.4
Copyright(c) 2004-2009 Emulex.  All rights reserved.
bus: 'pci': add driver lpfc
initcall lpfc_init+0x0/0xfb returned 0 after 3906 usecs
calling  dc395x_module_init+0x0/0x42 @ 1
bus: 'pci': add driver dc395x
initcall dc395x_module_init+0x0/0x42 returned 0 after 976 usecs
calling  megasas_init+0x0/0x18e @ 1
megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
bus: 'pci': add driver megaraid_sas
initcall megasas_init+0x0/0x18e returned 0 after 1953 usecs
calling  gdth_init+0x0/0x123 @ 1
GDT-HA: Storage RAID Controller Driver. Version: 3.05
bus: 'pci': add driver gdth
initcall gdth_init+0x0/0x123 returned 0 after 1953 usecs
calling  hptiop_module_init+0x0/0x5c @ 1
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
bus: 'pci': add driver hptiop
initcall hptiop_module_init+0x0/0x5c returned 0 after 2929 usecs
calling  mvs_init+0x0/0x79 @ 1
bus: 'pci': add driver mvsas
initcall mvs_init+0x0/0x79 returned 0 after 976 usecs
calling  init_osst+0x0/0x16e @ 1
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
device class 'onstream_tape': registering
bus: 'scsi': add driver osst
initcall init_osst+0x0/0x16e returned 0 after 2929 usecs
calling  init_sd+0x0/0x106 @ 1
device class 'scsi_disk': registering
bus: 'scsi': add driver sd
initcall init_sd+0x0/0x106 returned 0 after 2929 usecs
calling  init_sg+0x0/0xec @ 1
device class 'scsi_generic': registering
initcall init_sg+0x0/0xec returned 0 after 976 usecs
calling  osd_uld_init+0x0/0xfe @ 1
device class 'scsi_osd': registering
bus: 'scsi': add driver osd
osd: LOADED open-osd 0.1.0
initcall osd_uld_init+0x0/0xfe returned 0 after 2929 usecs
calling  ahci_init+0x0/0x42 @ 1
bus: 'pci': add driver ahci
initcall ahci_init+0x0/0x42 returned 0 after 1953 usecs
calling  piix_init+0x0/0x50 @ 1
bus: 'pci': add driver ata_piix
initcall piix_init+0x0/0x50 returned 0 after 1953 usecs
calling  pdc_ata_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_promise
initcall pdc_ata_init+0x0/0x42 returned 0 after 976 usecs
calling  sil24_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_sil24
initcall sil24_init+0x0/0x42 returned 0 after 976 usecs
calling  svia_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_via
initcall svia_init+0x0/0x42 returned 0 after 976 usecs
calling  vsc_sata_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_vsc
initcall vsc_sata_init+0x0/0x42 returned 0 after 976 usecs
calling  sis_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_sis
initcall sis_init+0x0/0x42 returned 0 after 976 usecs
calling  pdc_sata_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_sx4
initcall pdc_sata_init+0x0/0x42 returned 0 after 976 usecs
calling  nv_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_nv
initcall nv_init+0x0/0x42 returned 0 after 1953 usecs
calling  uli_init+0x0/0x42 @ 1
bus: 'pci': add driver sata_uli
initcall uli_init+0x0/0x42 returned 0 after 976 usecs
calling  ali_init+0x0/0x74 @ 1
bus: 'pci': add driver pata_ali
initcall ali_init+0x0/0x74 returned 0 after 976 usecs
calling  amd_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_amd
bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
scsi0 : pata_amd
device: 'host0': device_add
device: 'host0': device_add
scsi1 : pata_amd
device: 'host1': device_add
device: 'host1': device_add
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
ata1.00: configured for UDMA/100
async_waiting @ 1
async_continuing @ 1 after 0 usec
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
device: 'target0:0:0': device_add
device: '0:0:0:0': device_add
bus: 'scsi': add device 0:0:0:0
bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver osst
bus: 'scsi': really_probe: probing driver osst with device 0:0:0:0
bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
device: '0:0:0:0': device_add
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
device: 'sda': device_add
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
device: 'sda1': device_add
device: 'sda2': device_add
device: 'sda3': device_add
device: 'sda5': device_add
device: 'sda6': device_add
device: 'sda7': device_add
device: 'sda8': device_add
device: 'sda9': device_add
device: 'sda10': device_add
device: '8:0': device_add
sd 0:0:0:0: [sda] Attached SCSI disk
driver: '0:0:0:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
device: '0:0:0:0': device_add
device: 'sg0': device_add
sd 0:0:0:0: Attached scsi generic sg0 type 0
device: '0:0:0:0': device_add
async_waiting @ 1
async_continuing @ 1 after 0 usec
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
ata2.01: configured for UDMA/33
async_waiting @ 1
async_continuing @ 1 after 0 usec
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
device: 'target1:0:1': device_add
device: '1:0:1:0': device_add
bus: 'scsi': add device 1:0:1:0
bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver osst
bus: 'scsi': really_probe: probing driver osst with device 1:0:1:0
bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver osd
bus: 'scsi': really_probe: probing driver osd with device 1:0:1:0
device: '1:0:1:0': device_add
device: 'sg1': device_add
scsi 1:0:1:0: Attached scsi generic sg1 type 5
device: '1:0:1:0': device_add
driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
initcall amd_init+0x0/0x42 returned 0 after 533203 usecs
calling  artop_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_artop
initcall artop_init+0x0/0x42 returned 0 after 976 usecs
calling  atiixp_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_atiixp
initcall atiixp_init+0x0/0x42 returned 0 after 976 usecs
calling  cmd640_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_cmd640
initcall cmd640_init+0x0/0x42 returned 0 after 976 usecs
calling  cs5520_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_cs5520
initcall cs5520_init+0x0/0x42 returned 0 after 976 usecs
calling  cy82c693_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_cypress
initcall cy82c693_init+0x0/0x42 returned 0 after 976 usecs
calling  efar_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_efar
initcall efar_init+0x0/0x42 returned 0 after 1953 usecs
calling  hpt3x2n_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_hpt3x2n
initcall hpt3x2n_init+0x0/0x42 returned 0 after 976 usecs
calling  hpt3x3_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_hpt3x3
initcall hpt3x3_init+0x0/0x42 returned 0 after 1953 usecs
calling  it8213_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_it8213
initcall it8213_init+0x0/0x42 returned 0 after 976 usecs
calling  netcell_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_netcell
initcall netcell_init+0x0/0x42 returned 0 after 976 usecs
calling  ns87415_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_ns87415
initcall ns87415_init+0x0/0x42 returned 0 after 976 usecs
calling  oldpiix_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_oldpiix
initcall oldpiix_init+0x0/0x42 returned 0 after 1953 usecs
calling  rz1000_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_rz1000
initcall rz1000_init+0x0/0x42 returned 0 after 976 usecs
calling  sc1200_init+0x0/0x42 @ 1
bus: 'pci': add driver sc1200
initcall sc1200_init+0x0/0x42 returned 0 after 1953 usecs
calling  via_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_via
initcall via_init+0x0/0x42 returned 0 after 1953 usecs
calling  sl82c105_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_sl82c105
initcall sl82c105_init+0x0/0x42 returned 0 after 976 usecs
calling  sis_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_sis
initcall sis_init+0x0/0x42 returned 0 after 1953 usecs
calling  triflex_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_triflex
initcall triflex_init+0x0/0x42 returned 0 after 976 usecs
calling  sch_init+0x0/0x42 @ 1
bus: 'pci': add driver pata_sch
initcall sch_init+0x0/0x42 returned 0 after 976 usecs
calling  e1000_init_module+0x0/0x8f @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
bus: 'pci': add driver e1000e
initcall e1000_init_module+0x0/0x8f returned 0 after 3906 usecs
calling  t1_init_module+0x0/0x42 @ 1
bus: 'pci': add driver cxgb
initcall t1_init_module+0x0/0x42 returned 0 after 1953 usecs
calling  cxgb3_init_module+0x0/0x47 @ 1
bus: 'pci': add driver cxgb3
initcall cxgb3_init_module+0x0/0x47 returned 0 after 1953 usecs
calling  atl1_init_module+0x0/0x42 @ 1
bus: 'pci': add driver atl1
initcall atl1_init_module+0x0/0x42 returned 0 after 1953 usecs
calling  bdx_module_init+0x0/0xb0 @ 1
tehuti: Tehuti Networks(R) Network Driver, 7.29.3
tehuti: Options: hw_csum 
bus: 'pci': add driver tehuti
initcall bdx_module_init+0x0/0xb0 returned 0 after 2929 usecs
calling  jme_init_module+0x0/0x55 @ 1
jme: JMicron JMC2XX ethernet driver version 1.0.5
bus: 'pci': add driver jme
initcall jme_init_module+0x0/0x55 returned 0 after 1953 usecs
calling  gem_init+0x0/0x42 @ 1
bus: 'pci': add driver gem
initcall gem_init+0x0/0x42 returned 0 after 976 usecs
calling  vortex_init+0x0/0xd8 @ 1
bus: 'pci': add driver 3c59x
initcall vortex_init+0x0/0xd8 returned 0 after 976 usecs
calling  typhoon_init+0x0/0x42 @ 1
bus: 'pci': add driver typhoon
initcall typhoon_init+0x0/0x42 returned 0 after 976 usecs
calling  e100_init_module+0x0/0x81 @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
bus: 'pci': add driver e100
initcall e100_init_module+0x0/0x81 returned 0 after 2929 usecs
calling  epic_init+0x0/0x42 @ 1
bus: 'pci': add driver epic100
initcall epic_init+0x0/0x42 returned 0 after 976 usecs
calling  smsc9420_init_module+0x0/0x64 @ 1
bus: 'pci': add driver smsc9420
initcall smsc9420_init_module+0x0/0x64 returned 0 after 976 usecs
calling  tg3_init+0x0/0x42 @ 1
bus: 'pci': add driver tg3
initcall tg3_init+0x0/0x42 returned 0 after 1953 usecs
calling  bnx2_init+0x0/0x42 @ 1
bus: 'pci': add driver bnx2
initcall bnx2_init+0x0/0x42 returned 0 after 976 usecs
calling  bnx2x_init+0x0/0xbb @ 1
Broadcom NetXtreme II 5771x 10Gigabit Ethernet Driver bnx2x 1.52.1 (2009/08/12)
bus: 'pci': add driver bnx2x
initcall bnx2x_init+0x0/0xbb returned 0 after 1953 usecs
calling  skfd_init+0x0/0x42 @ 1
bus: 'pci': add driver skfddi
initcall skfd_init+0x0/0x42 returned 0 after 976 usecs
calling  ks8851_init+0x0/0x39 @ 1
bus: 'spi': add driver ks8851
initcall ks8851_init+0x0/0x39 returned 0 after 976 usecs
calling  rhine_init+0x0/0x8a @ 1
bus: 'pci': add driver via-rhine
initcall rhine_init+0x0/0x8a returned 0 after 976 usecs
calling  marvell_init+0x0/0x84 @ 1
bus: 'mdio_bus': add driver Marvell 88E1101
bus: 'mdio_bus': add driver Marvell 88E1112
bus: 'mdio_bus': add driver Marvell 88E1111
bus: 'mdio_bus': add driver Marvell 88E1118
bus: 'mdio_bus': add driver Marvell 88E1121R
bus: 'mdio_bus': add driver Marvell 88E1145
bus: 'mdio_bus': add driver Marvell 88E1240
initcall marvell_init+0x0/0x84 returned 0 after 10742 usecs
calling  davicom_init+0x0/0x83 @ 1
bus: 'mdio_bus': add driver Davicom DM9161E
bus: 'mdio_bus': add driver Davicom DM9161A
bus: 'mdio_bus': add driver Davicom DM9131
initcall davicom_init+0x0/0x83 returned 0 after 4882 usecs
calling  qs6612_init+0x0/0x39 @ 1
bus: 'mdio_bus': add driver QS6612
initcall qs6612_init+0x0/0x39 returned 0 after 976 usecs
calling  smsc_init+0x0/0xbf @ 1
bus: 'mdio_bus': add driver SMSC LAN83C185
bus: 'mdio_bus': add driver SMSC LAN8187
bus: 'mdio_bus': add driver SMSC LAN8700
bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
initcall smsc_init+0x0/0xbf returned 0 after 4882 usecs
calling  fixed_mdio_bus_init+0x0/0xf6 @ 1
Registering platform device 'Fixed MDIO bus.0'. Parent at platform
device: 'Fixed MDIO bus.0': device_add
bus: 'platform': add device Fixed MDIO bus.0
device: '0': device_add
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0xf6 returned 0 after 5859 usecs
calling  ste10Xp_init+0x0/0x49 @ 1
bus: 'mdio_bus': add driver STe100p
bus: 'mdio_bus': add driver STe101p
initcall ste10Xp_init+0x0/0x49 returned 0 after 2929 usecs
calling  sundance_init+0x0/0x42 @ 1
bus: 'pci': add driver sundance
initcall sundance_init+0x0/0x42 returned 0 after 1953 usecs
calling  net_olddevs_init+0x0/0x55 @ 1
initcall net_olddevs_init+0x0/0x55 returned 0 after 976 usecs
calling  init_nic+0x0/0x42 @ 1
bus: 'pci': add driver forcedeth
bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
forcedeth 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
forcedeth 0000:00:0a.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
device: 'eth0': device_add
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
initcall init_nic+0x0/0x42 returned 0 after 515625 usecs
calling  slip_init+0x0/0xd8 @ 1
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
SLIP linefill/keepalive option.
initcall slip_init+0x0/0xd8 returned 0 after 1953 usecs
calling  rtl8139_init_module+0x0/0x42 @ 1
bus: 'pci': add driver 8139too
bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139too
bus: 'pci': really_probe: probing driver 8139too with device 0000:05:07.0
8139too Fast Ethernet driver 0.9.28
8139too 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
device: 'eth1': device_add
eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 11
driver: '0000:05:07.0': driver_bound: bound to device '8139too'
bus: 'pci': really_probe: bound device 0000:05:07.0 to driver 8139too
initcall rtl8139_init_module+0x0/0x42 returned 0 after 10742 usecs
calling  veth_init+0x0/0x39 @ 1
initcall veth_init+0x0/0x39 returned 0 after 0 usecs
calling  rio_init+0x0/0x42 @ 1
bus: 'pci': add driver dl2k
initcall rio_init+0x0/0x42 returned 0 after 976 usecs
calling  arcnet_init+0x0/0x84 @ 1
arcnet loaded.
initcall arcnet_init+0x0/0x84 returned 0 after 976 usecs
calling  com90io_init+0x0/0x91 @ 1
arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
E-mail me if you actually test this driver, please!
 arc%d: No autoprobe for IO mapped cards; you must specify the base address!
initcall com90io_init+0x0/0x91 returned -19 after 2929 usecs
calling  arc_rimi_init+0x0/0xaa @ 1
arcnet: RIM I (entirely mem-mapped) support
E-mail me if you actually test the RIM I driver, please!
 arc%d: Given: node 00h, shmem 0h, irq 0
 arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
initcall arc_rimi_init+0x0/0xaa returned -5 after 3906 usecs
initcall arc_rimi_init+0x0/0xaa returned with error code -5 
calling  catc_init+0x0/0x5e @ 1
bus: 'usb': add driver catc
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
initcall catc_init+0x0/0x5e returned 0 after 2929 usecs
calling  kaweth_init+0x0/0x42 @ 1
bus: 'usb': add driver kaweth
usbcore: registered new interface driver kaweth
initcall kaweth_init+0x0/0x42 returned 0 after 1953 usecs
calling  tulip_init+0x0/0x5a @ 1
bus: 'pci': add driver tulip
initcall tulip_init+0x0/0x5a returned 0 after 976 usecs
calling  init_netconsole+0x0/0x184 @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x184 returned 0 after 1953 usecs
calling  spidev_init+0x0/0xd4 @ 1
device class 'spidev': registering
bus: 'spi': add driver spidev
initcall spidev_init+0x0/0xd4 returned 0 after 1953 usecs
calling  uwb_subsys_init+0x0/0x77 @ 1
device class 'uwb_rc': registering
initcall uwb_subsys_init+0x0/0x77 returned 0 after 976 usecs
calling  umc_bus_init+0x0/0x39 @ 1
bus: 'umc': registered
initcall umc_bus_init+0x0/0x39 returned 0 after 976 usecs
calling  whci_init+0x0/0x42 @ 1
bus: 'pci': add driver whci
initcall whci_init+0x0/0x42 returned 0 after 976 usecs
calling  whcrc_driver_init+0x0/0x42 @ 1
bus: 'umc': add driver whc-rc
initcall whcrc_driver_init+0x0/0x42 returned 0 after 976 usecs
calling  gpio_vbus_init+0x0/0x40 @ 1
bus: 'platform': add driver gpio-vbus
bus: 'platform': remove driver gpio-vbus
driver: 'gpio-vbus': driver_release
initcall gpio_vbus_init+0x0/0x40 returned -19 after 2929 usecs
calling  mon_init+0x0/0x141 @ 1
device class 'usbmon': registering
device: 'usbmon0': device_add
initcall mon_init+0x0/0x141 returned 0 after 1953 usecs
calling  ehci_hcd_init+0x0/0x10e @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
bus: 'pci': add driver ehci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
initcall ehci_hcd_init+0x0/0x10e returned 0 after 7812 usecs
calling  ohci_hcd_mod_init+0x0/0xff @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
bus: 'pci': add driver ohci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
bus: 'platform': add driver sm501-usb
initcall ohci_hcd_mod_init+0x0/0xff returned 0 after 8789 usecs
calling  uhci_hcd_init+0x0/0x15a @ 1
uhci_hcd: USB Universal Host Controller Interface driver
bus: 'pci': add driver uhci_hcd
initcall uhci_hcd_init+0x0/0x15a returned 0 after 3906 usecs
calling  xhci_hcd_init+0x0/0x52 @ 1
bus: 'pci': add driver xhci_hcd
initcall xhci_hcd_init+0x0/0x52 returned 0 after 1953 usecs
calling  isp1760_init+0x0/0x76 @ 1
bus: 'platform': add driver isp1760
bus: 'pci': add driver isp1760
initcall isp1760_init+0x0/0x76 returned 0 after 2929 usecs
calling  acm_init+0x0/0x128 @ 1
bus: 'usb': add driver cdc_acm
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
initcall acm_init+0x0/0x128 returned 0 after 3906 usecs
calling  usblp_init+0x0/0x42 @ 1
bus: 'usb': add driver usblp
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x42 returned 0 after 1953 usecs
calling  wdm_init+0x0/0x42 @ 1
bus: 'usb': add driver cdc_wdm
usbcore: registered new interface driver cdc_wdm
initcall wdm_init+0x0/0x42 returned 0 after 1953 usecs
calling  usb_stor_init+0x0/0x74 @ 1
Initializing USB Mass Storage driver...
bus: 'usb': add driver usb-storage
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x74 returned 0 after 4882 usecs
calling  usb_usual_init+0x0/0x66 @ 1
bus: 'usb': add driver libusual
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x66 returned 0 after 1953 usecs
calling  jumpshot_init+0x0/0x42 @ 1
bus: 'usb': add driver ums-jumpshot
usbcore: registered new interface driver ums-jumpshot
initcall jumpshot_init+0x0/0x42 returned 0 after 1953 usecs
calling  usbat_init+0x0/0x42 @ 1
bus: 'usb': add driver ums-usbat
usbcore: registered new interface driver ums-usbat
initcall usbat_init+0x0/0x42 returned 0 after 1953 usecs
calling  usb_mdc800_init+0x0/0x33a @ 1
bus: 'usb': add driver mdc800
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
initcall usb_mdc800_init+0x0/0x33a returned 0 after 2929 usecs
calling  microtek_drv_init+0x0/0x42 @ 1
bus: 'usb': add driver microtekX6
usbcore: registered new interface driver microtekX6
initcall microtek_drv_init+0x0/0x42 returned 0 after 2929 usecs
calling  emi62_init+0x0/0x5e @ 1
bus: 'usb': add driver emi62 - firmware loader
usbcore: registered new interface driver emi62 - firmware loader
initcall emi62_init+0x0/0x5e returned 0 after 1953 usecs
calling  iowarrior_init+0x0/0x42 @ 1
bus: 'usb': add driver iowarrior
usbcore: registered new interface driver iowarrior
initcall iowarrior_init+0x0/0x42 returned 0 after 2929 usecs
calling  usb_lcd_init+0x0/0x60 @ 1
bus: 'usb': add driver usblcd
usbcore: registered new interface driver usblcd
initcall usb_lcd_init+0x0/0x60 returned 0 after 2929 usecs
calling  usbtest_init+0x0/0x66 @ 1
bus: 'usb': add driver usbtest
usbcore: registered new interface driver usbtest
initcall usbtest_init+0x0/0x66 returned 0 after 1953 usecs
calling  vstusb_init+0x0/0x67 @ 1
bus: 'usb': add driver vstusb
usbcore: registered new interface driver vstusb
initcall vstusb_init+0x0/0x67 returned 0 after 1953 usecs
calling  i8042_init+0x0/0x13e @ 1
Registering platform device 'i8042'. Parent at platform
device: 'i8042': device_add
bus: 'platform': add device i8042
bus: 'platform': add driver i8042
bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
bus: 'platform': really_probe: probing driver i8042 with device i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
device: 'serio0': device_add
bus: 'serio': add device serio0
driver: 'i8042': driver_bound: bound to device 'i8042'
bus: 'platform': really_probe: bound device i8042 to driver i8042
device: 'serio1': device_add
bus: 'serio': add device serio1
initcall i8042_init+0x0/0x13e returned 0 after 14648 usecs
calling  serport_init+0x0/0x5a @ 1
initcall serport_init+0x0/0x5a returned 0 after 0 usecs
calling  ns558_init+0x0/0x60 @ 1
initcall ns558_init+0x0/0x60 returned -19 after 0 usecs
calling  mousedev_init+0x0/0x87 @ 1
device: 'mice': device_add
device: 'mouse0': device_add
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x87 returned 0 after 0 usecs
calling  joydev_init+0x0/0x39 @ 1
initcall joydev_init+0x0/0x39 returned 0 after 0 usecs
calling  evdev_init+0x0/0x39 @ 1
device: 'event0': device_add
initcall evdev_init+0x0/0x39 returned 0 after 0 usecs
calling  atkbd_init+0x0/0x4e @ 1
bus: 'serio': add driver atkbd
initcall atkbd_init+0x0/0x4e returned 0 after 0 usecs
calling  gpio_keys_init+0x0/0x39 @ 1
bus: 'platform': add driver gpio-keys
initcall gpio_keys_init+0x0/0x39 returned 0 after 0 usecs
calling  lkkbd_init+0x0/0x42 @ 1
bus: 'serio': add driver lkkbd
initcall lkkbd_init+0x0/0x42 returned 0 after 0 usecs
calling  lm8323_init+0x0/0x3b @ 1
bus: 'i2c': add driver lm8323
i2c-core: driver [lm8323] registered
initcall lm8323_init+0x0/0x3b returned 0 after 0 usecs
calling  matrix_keypad_init+0x0/0x39 @ 1
bus: 'platform': add driver matrix-keypad
initcall matrix_keypad_init+0x0/0x39 returned 0 after 0 usecs
calling  xtkbd_init+0x0/0x42 @ 1
bus: 'serio': add driver xtkbd
initcall xtkbd_init+0x0/0x42 returned 0 after 0 usecs
calling  gpio_mouse_init+0x0/0x39 @ 1
bus: 'platform': add driver gpio_mouse
initcall gpio_mouse_init+0x0/0x39 returned 0 after 0 usecs
calling  vsxxxaa_init+0x0/0x42 @ 1
bus: 'serio': add driver vsxxxaa
initcall vsxxxaa_init+0x0/0x42 returned 0 after 0 usecs
calling  gf2k_init+0x0/0x42 @ 1
bus: 'gameport': add driver gf2k
initcall gf2k_init+0x0/0x42 returned 0 after 0 usecs
calling  grip_init+0x0/0x42 @ 1
bus: 'gameport': add driver grip
initcall grip_init+0x0/0x42 returned 0 after 0 usecs
calling  guillemot_init+0x0/0x42 @ 1
bus: 'gameport': add driver guillemot
initcall guillemot_init+0x0/0x42 returned 0 after 0 usecs
calling  spaceorb_init+0x0/0x42 @ 1
bus: 'serio': add driver spaceorb
initcall spaceorb_init+0x0/0x42 returned 0 after 0 usecs
calling  twidjoy_init+0x0/0x42 @ 1
bus: 'serio': add driver twidjoy
initcall twidjoy_init+0x0/0x42 returned 0 after 0 usecs
calling  usb_xpad_init+0x0/0x5e @ 1
bus: 'usb': add driver xpad
usbcore: registered new interface driver xpad
xpad: X-Box pad driver
initcall usb_xpad_init+0x0/0x5e returned 0 after 0 usecs
calling  aiptek_init+0x0/0x6c @ 1
bus: 'usb': add driver aiptek
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
initcall aiptek_init+0x0/0x6c returned 0 after 0 usecs
calling  elo_init+0x0/0x42 @ 1
bus: 'serio': add driver elo
initcall elo_init+0x0/0x42 returned 0 after 0 usecs
calling  mk712_init+0x0/0x20a @ 1
mk712: device not present
initcall mk712_init+0x0/0x20a returned -19 after 0 usecs
calling  usbtouch_init+0x0/0x42 @ 1
bus: 'usb': add driver usbtouchscreen
usbcore: registered new interface driver usbtouchscreen
initcall usbtouch_init+0x0/0x42 returned 0 after 0 usecs
calling  pm_init+0x0/0x42 @ 1
bus: 'serio': add driver penmountlpc
initcall pm_init+0x0/0x42 returned 0 after 0 usecs
calling  tr_init+0x0/0x42 @ 1
bus: 'serio': add driver touchright
initcall tr_init+0x0/0x42 returned 0 after 0 usecs
calling  tsc2007_init+0x0/0x3b @ 1
bus: 'i2c': add driver tsc2007
i2c-core: driver [tsc2007] registered
initcall tsc2007_init+0x0/0x3b returned 0 after 0 usecs
calling  ati_remote2_init+0x0/0x70 @ 1
bus: 'usb': add driver ati_remote2
usbcore: registered new interface driver ati_remote2
ati_remote2: ATI/Philips USB RF remote driver 0.3
initcall ati_remote2_init+0x0/0x70 returned 0 after 0 usecs
calling  usb_keyspan_init+0x0/0x60 @ 1
bus: 'usb': add driver keyspan_remote
usbcore: registered new interface driver keyspan_remote
initcall usb_keyspan_init+0x0/0x60 returned 0 after 0 usecs
calling  pcf50633_input_init+0x0/0x39 @ 1
bus: 'platform': add driver pcf50633-input
initcall pcf50633_input_init+0x0/0x39 returned 0 after 0 usecs
calling  ds1307_init+0x0/0x3b @ 1
bus: 'i2c': add driver rtc-ds1307
i2c-core: driver [rtc-ds1307] registered
initcall ds1307_init+0x0/0x3b returned 0 after 0 usecs
calling  ds1374_init+0x0/0x3b @ 1
bus: 'i2c': add driver rtc-ds1374
i2c-core: driver [rtc-ds1374] registered
initcall ds1374_init+0x0/0x3b returned 0 after 0 usecs
calling  fm3130_init+0x0/0x3b @ 1
bus: 'i2c': add driver rtc-fm3130
i2c-core: driver [rtc-fm3130] registered
initcall fm3130_init+0x0/0x3b returned 0 after 0 usecs
calling  isl1208_init+0x0/0x3b @ 1
bus: 'i2c': add driver rtc-isl1208
i2c-core: driver [rtc-isl1208] registered
initcall isl1208_init+0x0/0x3b returned 0 after 0 usecs
calling  m41t94_init+0x0/0x39 @ 1
bus: 'spi': add driver rtc-m41t94
initcall m41t94_init+0x0/0x39 returned 0 after 0 usecs
calling  m48t59_rtc_init+0x0/0x39 @ 1
bus: 'platform': add driver rtc-m48t59
initcall m48t59_rtc_init+0x0/0x39 returned 0 after 0 usecs
calling  stk17ta8_init+0x0/0x39 @ 1
bus: 'platform': add driver stk17ta8
initcall stk17ta8_init+0x0/0x39 returned 0 after 0 usecs
calling  x1205_init+0x0/0x3b @ 1
bus: 'i2c': add driver rtc-x1205
i2c-core: driver [rtc-x1205] registered
initcall x1205_init+0x0/0x3b returned 0 after 0 usecs
calling  i2c_ali1535_init+0x0/0x42 @ 1
bus: 'pci': add driver ali1535_smbus
initcall i2c_ali1535_init+0x0/0x42 returned 0 after 0 usecs
calling  amd756_init+0x0/0x42 @ 1
bus: 'pci': add driver amd756_smbus
initcall amd756_init+0x0/0x42 returned 0 after 0 usecs
calling  nforce2_init+0x0/0x42 @ 1
bus: 'pci': add driver nForce2_smbus
bus: 'pci': driver_probe_device: matched device 0000:00:01.1 with driver nForce2_smbus
bus: 'pci': really_probe: probing driver nForce2_smbus with device 0000:00:01.1
device: 'i2c-0': device_add
i2c-adapter i2c-0: adapter [SMBus nForce2 adapter at 4c00] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio1
i2c-adapter i2c-0: Creating eeprom at 0x50
device: '0-0050': device_add
bus: 'i2c': add device 0-0050
i2c 0-0050: uevent
bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
bus: 'i2c': driver_probe_device: matched device 0-0050 with driver eeprom
bus: 'i2c': really_probe: probing driver eeprom with device 0-0050
eeprom 0-0050: probe
driver: '0-0050': driver_bound: bound to device 'eeprom'
bus: 'i2c': really_probe: bound device 0-0050 to driver eeprom
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0050
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x51
bus: 'serio': really_probe: probing driver atkbd with device serio0
i2c-adapter i2c-0: Creating eeprom at 0x51
device: '0-0051': device_add
bus: 'i2c': add device 0-0051
i2c 0-0051: uevent
bus: 'i2c': driver_probe_device: matched device 0-0051 with driver eeprom
bus: 'i2c': really_probe: probing driver eeprom with device 0-0051
eeprom 0-0051: probe
driver: '0-0051': driver_bound: bound to device 'eeprom'
bus: 'i2c': really_probe: bound device 0-0051 to driver eeprom
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0051
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x52
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x53
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x54
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x55
device: 'input1': device_add
input: AT Translated Set 2 keyboard as /class/input/input1
device: 'event1': device_add
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x56
driver: 'serio0': driver_bound: bound to device 'atkbd'
bus: 'serio': really_probe: bound device serio0 to driver atkbd
bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio1
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x57
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
device: 'i2c-1': device_add
i2c-adapter i2c-1: adapter [SMBus nForce2 adapter at 4c40] registered
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x50
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x51
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x52
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x53
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x54
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x55
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x56
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x57
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
driver: '0000:00:01.1': driver_bound: bound to device 'nForce2_smbus'
bus: 'pci': really_probe: bound device 0000:00:01.1 to driver nForce2_smbus
initcall nforce2_init+0x0/0x42 returned 0 after 83984 usecs
calling  i2c_sis5595_init+0x0/0x42 @ 1
bus: 'pci': add driver sis5595_smbus
initcall i2c_sis5595_init+0x0/0x42 returned 0 after 1953 usecs
calling  i2c_sis96x_init+0x0/0x42 @ 1
bus: 'pci': add driver sis96x_smbus
initcall i2c_sis96x_init+0x0/0x42 returned 0 after 976 usecs
calling  i2c_gpio_init+0x0/0x57 @ 1
bus: 'platform': add driver i2c-gpio
initcall i2c_gpio_init+0x0/0x57 returned 0 after 976 usecs
calling  taos_init+0x0/0x42 @ 1
bus: 'serio': add driver taos-evm
initcall taos_init+0x0/0x42 returned 0 after 1953 usecs
calling  usb_i2c_tiny_usb_init+0x0/0x42 @ 1
bus: 'usb': add driver i2c-tiny-usb
usbcore: registered new interface driver i2c-tiny-usb
initcall usb_i2c_tiny_usb_init+0x0/0x42 returned 0 after 1953 usecs
calling  i2c_pca_pf_init+0x0/0x39 @ 1
bus: 'platform': add driver i2c-pca-platform
initcall i2c_pca_pf_init+0x0/0x39 returned 0 after 1953 usecs
calling  w1_init+0x0/0xcd @ 1
Driver for 1-wire Dallas network protocol.
bus: 'w1': registered
bus: 'w1': add driver w1_master_driver
bus: 'w1': add driver w1_slave_driver
initcall w1_init+0x0/0xcd returned 0 after 4882 usecs
calling  sensors_ds2482_init+0x0/0x3b @ 1
bus: 'i2c': add driver ds2482
i2c-core: driver [ds2482] registered
initcall sensors_ds2482_init+0x0/0x3b returned 0 after 1953 usecs
calling  w1_therm_init+0x0/0x5b @ 1
initcall w1_therm_init+0x0/0x5b returned 0 after 0 usecs
calling  w1_f23_init+0x0/0x39 @ 1
initcall w1_f23_init+0x0/0x39 returned 0 after 0 usecs
calling  abituguru_init+0x0/0x1a2 @ 1
initcall abituguru_init+0x0/0x1a2 returned -19 after 0 usecs
calling  abituguru3_init+0x0/0x185 @ 1
initcall abituguru3_init+0x0/0x185 returned -19 after 0 usecs
calling  sensors_adt7475_init+0x0/0x3b @ 1
bus: 'i2c': add driver adt7475
i2c-core: driver [adt7475] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
initcall sensors_adt7475_init+0x0/0x3b returned 0 after 7812 usecs
calling  applesmc_init+0x0/0x455 @ 1
applesmc: supported laptop not found!
applesmc: driver init failed (ret=-19)!
initcall applesmc_init+0x0/0x455 returned -19 after 1953 usecs
calling  dme1737_init+0x0/0xdb @ 1
bus: 'i2c': add driver dme1737
i2c-core: driver [dme1737] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
initcall dme1737_init+0x0/0xdb returned 0 after 20507 usecs
calling  f71805f_init+0x0/0x9f @ 1
initcall f71805f_init+0x0/0x9f returned -19 after 0 usecs
calling  sensors_fscher_init+0x0/0x3b @ 1
bus: 'i2c': add driver fscher
i2c-core: driver [fscher] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x73
initcall sensors_fscher_init+0x0/0x3b returned 0 after 7812 usecs
calling  fschmd_init+0x0/0x3b @ 1
bus: 'i2c': add driver fschmd
i2c-core: driver [fschmd] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x73
initcall fschmd_init+0x0/0x3b returned 0 after 7812 usecs
calling  g760a_init+0x0/0x3b @ 1
bus: 'i2c': add driver g760a
i2c-core: driver [g760a] registered
initcall g760a_init+0x0/0x3b returned 0 after 1953 usecs
calling  k8temp_init+0x0/0x42 @ 1
bus: 'pci': add driver k8temp
bus: 'pci': driver_probe_device: matched device 0000:00:18.3 with driver k8temp
bus: 'pci': really_probe: probing driver k8temp with device 0000:00:18.3
device: 'hwmon0': device_add
driver: '0000:00:18.3': driver_bound: bound to device 'k8temp'
bus: 'pci': really_probe: bound device 0000:00:18.3 to driver k8temp
initcall k8temp_init+0x0/0x42 returned 0 after 5859 usecs
calling  lis302dl_init+0x0/0x39 @ 1
bus: 'spi': add driver lis3lv02d_spi
initcall lis302dl_init+0x0/0x39 returned 0 after 976 usecs
calling  init_lm70+0x0/0x65 @ 1
bus: 'spi': add driver lm70
bus: 'spi': add driver tmp121
initcall init_lm70+0x0/0x65 returned 0 after 1953 usecs
calling  sensors_lm75_init+0x0/0x3b @ 1
bus: 'i2c': add driver lm75
i2c-core: driver [lm75] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4f
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x48
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x49
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4a
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4b
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4c
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4d
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4e
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4f
initcall sensors_lm75_init+0x0/0x3b returned 0 after 48828 usecs
calling  sensors_lm77_init+0x0/0x3b @ 1
bus: 'i2c': add driver lm77
i2c-core: driver [lm77] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x48
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x49
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4a
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4b
initcall sensors_lm77_init+0x0/0x3b returned 0 after 26367 usecs
calling  ltc4245_init+0x0/0x3b @ 1
bus: 'i2c': add driver ltc4245
i2c-core: driver [ltc4245] registered
initcall ltc4245_init+0x0/0x3b returned 0 after 1953 usecs
calling  sensors_max1619_init+0x0/0x3b @ 1
bus: 'i2c': add driver max1619
i2c-core: driver [max1619] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x18
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x19
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x1a
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x29
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2a
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2b
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4c
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4d
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4e
initcall sensors_max1619_init+0x0/0x3b returned 0 after 54687 usecs
calling  pc87360_init+0x0/0xe9 @ 1
pc87360: PC8736x not detected, module not inserted.
initcall pc87360_init+0x0/0xe9 returned -19 after 976 usecs
calling  sht15_init+0x0/0x83 @ 1
bus: 'platform': add driver sht10
bus: 'platform': add driver sht11
bus: 'platform': add driver sht15
bus: 'platform': add driver sht71
bus: 'platform': add driver sht75
initcall sht15_init+0x0/0x83 returned 0 after 5859 usecs
calling  sm_sis5595_init+0x0/0x42 @ 1
bus: 'pci': add driver sis5595
initcall sm_sis5595_init+0x0/0x42 returned 0 after 1953 usecs
calling  sm_smsc47m1_init+0x0/0x80 @ 1
initcall sm_smsc47m1_init+0x0/0x80 returned -19 after 0 usecs
calling  smsc47m192_init+0x0/0x3b @ 1
bus: 'i2c': add driver smsc47m192
i2c-core: driver [smsc47m192] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
initcall smsc47m192_init+0x0/0x3b returned 0 after 13671 usecs
calling  sm_thmc50_init+0x0/0x3b @ 1
bus: 'i2c': add driver thmc50
i2c-core: driver [thmc50] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
initcall sm_thmc50_init+0x0/0x3b returned 0 after 19531 usecs
calling  tmp401_init+0x0/0x3b @ 1
bus: 'i2c': add driver tmp401
i2c-core: driver [tmp401] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4c
initcall tmp401_init+0x0/0x3b returned 0 after 7812 usecs
calling  sm_via686a_init+0x0/0x42 @ 1
bus: 'pci': add driver via686a
initcall sm_via686a_init+0x0/0x42 returned 0 after 976 usecs
calling  sensors_w83627ehf_init+0x0/0x175 @ 1
initcall sensors_w83627ehf_init+0x0/0x175 returned -19 after 0 usecs
calling  sensors_w83l786ng_init+0x0/0x3b @ 1
bus: 'i2c': add driver w83l786ng
i2c-core: driver [w83l786ng] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2f
initcall sensors_w83l786ng_init+0x0/0x3b returned 0 after 13671 usecs
calling  usb_pcwd_init+0x0/0x70 @ 1
bus: 'usb': add driver pcwd_usb
usbcore: registered new interface driver pcwd_usb
pcwd_usb: Berkshire USB-PC Watchdog driver v1.02
initcall usb_pcwd_init+0x0/0x70 returned 0 after 2929 usecs
calling  acq_init+0x0/0x83 @ 1
WDT driver for Acquire single board computer initialising.
bus: 'platform': add driver acquirewdt
Registering platform device 'acquirewdt'. Parent at platform
device: 'acquirewdt': device_add
bus: 'platform': add device acquirewdt
bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
acquirewdt: I/O address 0x0043 already in use
acquirewdt: probe of acquirewdt failed with error -5
initcall acq_init+0x0/0x83 returned 0 after 8789 usecs
calling  advwdt_init+0x0/0x83 @ 1
WDT driver for Advantech single board computer initialising.
bus: 'platform': add driver advantechwdt
Registering platform device 'advantechwdt'. Parent at platform
device: 'advantechwdt': device_add
bus: 'platform': add device advantechwdt
bus: 'platform': driver_probe_device: matched device advantechwdt with driver advantechwdt
bus: 'platform': really_probe: probing driver advantechwdt with device advantechwdt
device: 'watchdog': device_add
advantechwdt: initialized. timeout=60 sec (nowayout=1)
driver: 'advantechwdt': driver_bound: bound to device 'advantechwdt'
bus: 'platform': really_probe: bound device advantechwdt to driver advantechwdt
initcall advwdt_init+0x0/0x83 returned 0 after 11718 usecs
calling  ibmasr_init+0x0/0xdb @ 1
initcall ibmasr_init+0x0/0xdb returned -19 after 0 usecs
calling  iTCO_wdt_init_module+0x0/0x8a @ 1
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
bus: 'platform': add driver iTCO_wdt
Registering platform device 'iTCO_wdt'. Parent at platform
device: 'iTCO_wdt': device_add
bus: 'platform': add device iTCO_wdt
bus: 'platform': driver_probe_device: matched device iTCO_wdt with driver iTCO_wdt
bus: 'platform': really_probe: probing driver iTCO_wdt with device iTCO_wdt
iTCO_wdt: No card detected
initcall iTCO_wdt_init_module+0x0/0x8a returned 0 after 8789 usecs
calling  iTCO_vendor_init_module+0x0/0x41 @ 1
iTCO_vendor_support: vendor-support=0
initcall iTCO_vendor_init_module+0x0/0x41 returned 0 after 976 usecs
calling  hpwdt_init+0x0/0x42 @ 1
bus: 'pci': add driver hpwdt
initcall hpwdt_init+0x0/0x42 returned 0 after 1953 usecs
calling  sc1200wdt_init+0x0/0x13a @ 1
sc1200wdt: build 20020303
sc1200wdt: io parameter must be specified
initcall sc1200wdt_init+0x0/0x13a returned -22 after 1953 usecs
initcall sc1200wdt_init+0x0/0x13a returned with error code -22 
calling  pc87413_init+0x0/0xb5 @ 1
pc87413 WDT: Version 1.1 at io 0x2E
pc87413 WDT: cannot register miscdev on minor=130 (err=-16)
initcall pc87413_init+0x0/0xb5 returned -16 after 1953 usecs
initcall pc87413_init+0x0/0xb5 returned with error code -16 
calling  sbc60xxwdt_init+0x0/0x1ab @ 1
sbc60xxwdt: I/O address 0x0443 already in use
initcall sbc60xxwdt_init+0x0/0x1ab returned -5 after 976 usecs
initcall sbc60xxwdt_init+0x0/0x1ab returned with error code -5 
calling  sbc8360_init+0x0/0x1ca @ 1
sbc8360: failed to register misc device
initcall sbc8360_init+0x0/0x1ca returned -16 after 976 usecs
initcall sbc8360_init+0x0/0x1ca returned with error code -16 
calling  w83877f_wdt_init+0x0/0x183 @ 1
w83877f_wdt: I/O address 0x0443 already in use
initcall w83877f_wdt_init+0x0/0x183 returned -5 after 976 usecs
initcall w83877f_wdt_init+0x0/0x183 returned with error code -5 
calling  zf_init+0x0/0x185 @ 1
machzwd: MachZ ZF-Logic Watchdog driver initializing.
machzwd: no ZF-Logic found
initcall zf_init+0x0/0x185 returned -19 after 1953 usecs
calling  watchdog_init+0x0/0xde @ 1
epx_c3: cannot register miscdev on minor=130 (err=-16)
initcall watchdog_init+0x0/0xde returned -16 after 976 usecs
initcall watchdog_init+0x0/0xde returned with error code -16 
calling  telephony_init+0x0/0x78 @ 1
Linux telephony interface: v1.00
initcall telephony_init+0x0/0x78 returned 0 after 976 usecs
calling  dm_init+0x0/0x6f @ 1
device-mapper: uevent: version 1.0.3
device: 'device-mapper': device_add
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x6f returned 0 after 4882 usecs
calling  dm_multipath_init+0x0/0x155 @ 1
device-mapper: multipath: version 1.1.0 loaded
initcall dm_multipath_init+0x0/0x155 returned 0 after 1953 usecs
calling  dm_rr_init+0x0/0x65 @ 1
device-mapper: multipath round-robin: version 1.0.0 loaded
initcall dm_rr_init+0x0/0x65 returned 0 after 1953 usecs
calling  dm_ql_init+0x0/0x65 @ 1
device-mapper: multipath queue-length: version 0.1.0 loaded
initcall dm_ql_init+0x0/0x65 returned 0 after 976 usecs
calling  dm_st_init+0x0/0x65 @ 1
device-mapper: multipath service-time: version 0.2.0 loaded
initcall dm_st_init+0x0/0x65 returned 0 after 976 usecs
calling  dm_mirror_init+0x0/0x9f @ 1
initcall dm_mirror_init+0x0/0x9f returned 0 after 976 usecs
calling  dm_dirty_log_init+0x0/0x7f @ 1
initcall dm_dirty_log_init+0x0/0x7f returned 0 after 0 usecs
calling  init_ladder+0x0/0x39 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x39 returned 0 after 976 usecs
calling  pca9532_init+0x0/0x3b @ 1
bus: 'i2c': add driver pca9532
i2c-core: driver [pca9532] registered
initcall pca9532_init+0x0/0x3b returned 0 after 1953 usecs
calling  clevo_mail_led_init+0x0/0xba @ 1
initcall clevo_mail_led_init+0x0/0xba returned -19 after 0 usecs
calling  pca955x_leds_init+0x0/0x3b @ 1
bus: 'i2c': add driver leds-pca955x
i2c-core: driver [leds-pca955x] registered
initcall pca955x_leds_init+0x0/0x3b returned 0 after 1953 usecs
calling  dac124s085_leds_init+0x0/0x39 @ 1
bus: 'spi': add driver dac124s085
initcall dac124s085_leds_init+0x0/0x39 returned 0 after 976 usecs
calling  timer_trig_init+0x0/0x39 @ 1
initcall timer_trig_init+0x0/0x39 returned 0 after 0 usecs
calling  bl_trig_init+0x0/0x39 @ 1
initcall bl_trig_init+0x0/0x39 returned 0 after 0 usecs
calling  ioat_init_module+0x0/0x42 @ 1
bus: 'pci': add driver ioatdma
initcall ioat_init_module+0x0/0x42 returned 0 after 976 usecs
calling  flow_cache_init+0x0/0x1c5 @ 1
initcall flow_cache_init+0x0/0x1c5 returned 0 after 976 usecs
calling  llc_init+0x0/0x47 @ 1
initcall llc_init+0x0/0x47 returned 0 after 0 usecs
calling  snap_init+0x0/0x61 @ 1
initcall snap_init+0x0/0x61 returned 0 after 0 usecs
calling  blackhole_module_init+0x0/0x39 @ 1
initcall blackhole_module_init+0x0/0x39 returned 0 after 0 usecs
calling  hfsc_init+0x0/0x39 @ 1
initcall hfsc_init+0x0/0x39 returned 0 after 0 usecs
calling  red_module_init+0x0/0x39 @ 1
initcall red_module_init+0x0/0x39 returned 0 after 0 usecs
calling  ingress_module_init+0x0/0x39 @ 1
initcall ingress_module_init+0x0/0x39 returned 0 after 0 usecs
calling  dsmark_module_init+0x0/0x39 @ 1
initcall dsmark_module_init+0x0/0x39 returned 0 after 0 usecs
calling  teql_init+0x0/0xf7 @ 1
device: 'teql0': device_add
initcall teql_init+0x0/0xf7 returned 0 after 1953 usecs
calling  drr_init+0x0/0x39 @ 1
initcall drr_init+0x0/0x39 returned 0 after 0 usecs
calling  init_u32+0x0/0x61 @ 1
u32 classifier
    Performance counters on
    Actions configured 
initcall init_u32+0x0/0x61 returned 0 after 3906 usecs
calling  init_tcindex+0x0/0x39 @ 1
initcall init_tcindex+0x0/0x39 returned 0 after 0 usecs
calling  init_rsvp+0x0/0x39 @ 1
initcall init_rsvp+0x0/0x39 returned 0 after 0 usecs
calling  init_cgroup_cls+0x0/0x39 @ 1
initcall init_cgroup_cls+0x0/0x39 returned 0 after 0 usecs
calling  init_em_cmp+0x0/0x39 @ 1
initcall init_em_cmp+0x0/0x39 returned 0 after 0 usecs
calling  init_em_nbyte+0x0/0x39 @ 1
initcall init_em_nbyte+0x0/0x39 returned 0 after 0 usecs
calling  nfnetlink_init+0x0/0x86 @ 1
Netfilter messages via NETLINK v0.30.
initcall nfnetlink_init+0x0/0x86 returned 0 after 976 usecs
calling  nfnetlink_log_init+0x0/0xfd @ 1
initcall nfnetlink_log_init+0x0/0xfd returned 0 after 0 usecs
calling  xt_init+0x0/0x18e @ 1
initcall xt_init+0x0/0x18e returned 0 after 0 usecs
calling  tcpudp_mt_init+0x0/0x3e @ 1
initcall tcpudp_mt_init+0x0/0x3e returned 0 after 0 usecs
calling  mark_mt_init+0x0/0x39 @ 1
initcall mark_mt_init+0x0/0x39 returned 0 after 0 usecs
calling  policy_mt_init+0x0/0x3e @ 1
initcall policy_mt_init+0x0/0x3e returned 0 after 0 usecs
calling  sysctl_ipv4_init+0x0/0x74 @ 1
initcall sysctl_ipv4_init+0x0/0x74 returned 0 after 976 usecs
calling  init_syncookies+0x0/0x40 @ 1
initcall init_syncookies+0x0/0x40 returned 0 after 0 usecs
calling  esp4_init+0x0/0x8f @ 1
initcall esp4_init+0x0/0x8f returned 0 after 0 usecs
calling  ipcomp4_init+0x0/0x8f @ 1
initcall ipcomp4_init+0x0/0x8f returned 0 after 0 usecs
calling  ipip_init+0x0/0xc5 @ 1
initcall ipip_init+0x0/0xc5 returned 0 after 0 usecs
calling  tunnel4_init+0x0/0x8f @ 1
initcall tunnel4_init+0x0/0x8f returned 0 after 0 usecs
calling  xfrm4_mode_tunnel_init+0x0/0x3e @ 1
initcall xfrm4_mode_tunnel_init+0x0/0x3e returned 0 after 0 usecs
calling  ipv4_netfilter_init+0x0/0x3e @ 1
initcall ipv4_netfilter_init+0x0/0x3e returned 0 after 0 usecs
calling  ip_tables_init+0x0/0xd5 @ 1
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall ip_tables_init+0x0/0xd5 returned 0 after 976 usecs
calling  cubictcp_register+0x0/0x88 @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x88 returned 0 after 976 usecs
calling  packet_init+0x0/0x6d @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x6d returned 0 after 976 usecs
calling  br_init+0x0/0xe1 @ 1
initcall br_init+0x0/0xe1 returned 0 after 0 usecs
calling  dsa_init_module+0x0/0x39 @ 1
bus: 'platform': add driver dsa
initcall dsa_init_module+0x0/0x39 returned 0 after 976 usecs
calling  ipx_init+0x0/0x120 @ 1
NET: Registered protocol family 4
initcall ipx_init+0x0/0x120 returned 0 after 3906 usecs
calling  lapb_init+0x0/0x2d @ 1
initcall lapb_init+0x0/0x2d returned 0 after 0 usecs
calling  can_init+0x0/0x144 @ 1
can: controller area network core (rev 20090105 abi 8)
NET: Registered protocol family 29
initcall can_init+0x0/0x144 returned 0 after 1953 usecs
calling  raw_module_init+0x0/0x61 @ 1
can: raw protocol (rev 20090105)
initcall raw_module_init+0x0/0x61 returned 0 after 976 usecs
calling  af_rxrpc_init+0x0/0x1c6 @ 1
NET: Registered protocol family 33
initcall af_rxrpc_init+0x0/0x1c6 returned 0 after 1953 usecs
calling  rxkad_init+0x0/0x90 @ 1
RxRPC: Registered security type 2 'rxkad'
initcall rxkad_init+0x0/0x90 returned 0 after 1953 usecs
calling  vlan_proto_init+0x0/0xeb @ 1
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
initcall vlan_proto_init+0x0/0xeb returned 0 after 1953 usecs
calling  dccp_init+0x0/0x3d1 @ 1
CCID: Activated CCID 2 (TCP-like)
CCID: Activated CCID 3 (TCP-Friendly Rate Control)
initcall dccp_init+0x0/0x3d1 returned 0 after 11718 usecs
calling  dccp_v4_init+0x0/0xae @ 1
initcall dccp_v4_init+0x0/0xae returned 0 after 976 usecs
calling  mce_debugfs_init+0x0/0x62 @ 1
initcall mce_debugfs_init+0x0/0x62 returned 0 after 0 usecs
calling  severities_debugfs_init+0x0/0x62 @ 1
initcall severities_debugfs_init+0x0/0x62 returned 0 after 0 usecs
calling  update_mp_table+0x0/0x245 @ 1
initcall update_mp_table+0x0/0x245 returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x67 @ 1
initcall lapic_insert_resource+0x0/0x67 returned 0 after 0 usecs
calling  io_apic_bug_finalize+0x0/0x42 @ 1
initcall io_apic_bug_finalize+0x0/0x42 returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x8e @ 1
initcall check_early_ioremap_leak+0x0/0x8e returned 0 after 0 usecs
calling  sched_init_debug+0x0/0x4b @ 1
initcall sched_init_debug+0x0/0x4b returned 0 after 0 usecs
calling  init_oops_id+0x0/0x5d @ 1
initcall init_oops_id+0x0/0x5d returned 0 after 0 usecs
calling  disable_boot_consoles+0x0/0x97 @ 1
initcall disable_boot_consoles+0x0/0x97 returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0xf0 @ 1
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xf0 returned 0 after 3906 usecs
calling  taskstats_init+0x0/0xbe @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0xbe returned 0 after 976 usecs
calling  clear_boot_tracer+0x0/0x52 @ 1
initcall clear_boot_tracer+0x0/0x52 returned 0 after 0 usecs
calling  event_trace_self_tests_init+0x0/0x68 @ 1
Running tests on trace events:
Testing event kfree_skb: OK
Testing event skb_copy_datagram_iovec: OK
Testing event block_rq_abort: OK
Testing event block_rq_insert: OK
Testing event block_rq_issue: OK
Testing event block_rq_requeue: OK
Testing event block_rq_complete: OK
Testing event block_bio_bounce: OK
Testing event block_bio_complete: OK
Testing event block_bio_backmerge: OK
Testing event block_bio_frontmerge: OK
Testing event block_bio_queue: OK
Testing event block_getrq: OK
Testing event block_sleeprq: OK
Testing event block_plug: OK
Testing event block_unplug_timer: OK
Testing event block_unplug_io: OK
Testing event block_split: OK
Testing event block_remap: OK
Testing event jbd2_checkpoint: OK
Testing event jbd2_start_commit: OK
Testing event jbd2_commit_locking: OK
Testing event jbd2_commit_flushing: OK
Testing event jbd2_commit_logging: OK
Testing event jbd2_end_commit: OK
Testing event jbd2_submit_inode_data: OK
Testing event ext4_free_inode: OK
Testing event ext4_request_inode: OK
Testing event ext4_allocate_inode: OK
Testing event ext4_write_begin: OK
Testing event ext4_ordered_write_end: OK
Testing event ext4_writeback_write_end: OK
Testing event ext4_journalled_write_end: OK
Testing event ext4_writepage: OK
Testing event ext4_da_writepages: OK
Testing event ext4_da_writepages_result: OK
Testing event ext4_da_write_begin: OK
Testing event ext4_da_write_end: OK
Testing event ext4_discard_blocks: OK
Testing event ext4_mb_new_inode_pa: OK
Testing event ext4_mb_new_group_pa: OK
Testing event ext4_mb_release_inode_pa: OK
Testing event ext4_mb_release_group_pa: OK
Testing event ext4_discard_preallocations: OK
Testing event ext4_mb_discard_preallocations: OK
Testing event ext4_request_blocks: OK
Testing event ext4_allocate_blocks: OK
Testing event ext4_free_blocks: OK
Testing event ext4_sync_file: OK
Testing event ext4_sync_fs: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event module_load: OK
Testing event module_free: OK
Testing event module_get: OK
Testing event module_put: OK
Testing event module_request: OK
Testing event lock_acquire: OK
Testing event lock_release: OK
Testing event workqueue_insertion: OK
Testing event workqueue_execution: OK
Testing event workqueue_creation: OK
Testing event workqueue_destruction: OK
Testing event timer_init: OK
Testing event timer_start: OK
Testing event timer_expire_entry: OK
Testing event timer_expire_exit: OK
Testing event timer_cancel: OK
Testing event hrtimer_init: OK
Testing event hrtimer_start: OK
Testing event hrtimer_expire_entry: OK
Testing event hrtimer_expire_exit: OK
Testing event hrtimer_cancel: OK
Testing event itimer_state: OK
Testing event itimer_expire: OK
Testing event irq_handler_entry: OK
Testing event irq_handler_exit: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wait_task: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_signal_send: OK
Testing event sched_stat_wait: OK
Testing event sched_stat_runtime: OK
Testing event sched_stat_sleep: OK
Testing event sched_stat_iowait: OK
Testing event sys_enter: OK
Testing event sys_exit: OK
Running tests on trace event systems:
Testing event system skb: OK
Testing event system block: OK
Testing event system jbd2: OK
Testing event system ext4: OK
Testing event system kmem: OK
Testing event system module: OK
Testing event system lockdep: OK
Testing event system workqueue: OK
Testing event system timer: OK
Testing event system irq: OK
Testing event system sched: OK
Testing event system syscalls: OK
Running tests on all trace events:
Testing all events: OK
Running tests again, along with the function tracer
Running tests on trace events:
Testing event kfree_skb: OK
Testing event skb_copy_datagram_iovec: OK
Testing event block_rq_abort: OK
Testing event block_rq_insert: OK
Testing event block_rq_issue: OK
Testing event block_rq_requeue: OK
Testing event block_rq_complete: OK
Testing event block_bio_bounce: OK
Testing event block_bio_complete: OK
Testing event block_bio_backmerge: OK
Testing event block_bio_frontmerge: OK
Testing event block_bio_queue: OK
Testing event block_getrq: OK
Testing event block_sleeprq: OK
Testing event block_plug: OK
Testing event block_unplug_timer: OK
Testing event block_unplug_io: OK
Testing event block_split: OK
Testing event block_remap: OK
Testing event jbd2_checkpoint: OK
Testing event jbd2_start_commit: OK
Testing event jbd2_commit_locking: OK
Testing event jbd2_commit_flushing: OK
Testing event jbd2_commit_logging: OK
Testing event jbd2_end_commit: OK
Testing event jbd2_submit_inode_data: OK
Testing event ext4_free_inode: OK
Testing event ext4_request_inode: OK
Testing event ext4_allocate_inode: OK
Testing event ext4_write_begin: OK
Testing event ext4_ordered_write_end: OK
Testing event ext4_writeback_write_end: OK
Testing event ext4_journalled_write_end: OK
Testing event ext4_writepage: OK
Testing event ext4_da_writepages: OK
Testing event ext4_da_writepages_result: OK
Testing event ext4_da_write_begin: OK
Testing event ext4_da_write_end: OK
Testing event ext4_discard_blocks: OK
Testing event ext4_mb_new_inode_pa: OK
Testing event ext4_mb_new_group_pa: OK
Testing event ext4_mb_release_inode_pa: OK
Testing event ext4_mb_release_group_pa: OK
Testing event ext4_discard_preallocations: OK
Testing event ext4_mb_discard_preallocations: OK
Testing event ext4_request_blocks: OK
Testing event ext4_allocate_blocks: OK
Testing event ext4_free_blocks: OK
Testing event ext4_sync_file: OK
Testing event ext4_sync_fs: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event module_load: OK
Testing event module_free: OK
Testing event module_get: OK
Testing event module_put: OK
Testing event module_request: OK
Testing event lock_acquire: OK
Testing event lock_release: OK
Testing event workqueue_insertion: OK
Testing event workqueue_execution: OK
Testing event workqueue_creation: OK
Testing event workqueue_destruction: OK
Testing event timer_init: OK
Testing event timer_start: OK
Testing event timer_expire_entry: OK
Testing event timer_expire_exit: OK
Testing event timer_cancel: OK
Testing event hrtimer_init: OK
Testing event hrtimer_start: OK
Testing event hrtimer_expire_entry: OK
Testing event hrtimer_expire_exit: OK
Testing event hrtimer_cancel: OK
Testing event itimer_state: OK
Testing event itimer_expire: OK
Testing event irq_handler_entry: OK
Testing event irq_handler_exit: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wait_task: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_signal_send: OK
Testing event sched_stat_wait: OK
Testing event sched_stat_runtime: OK
Testing event sched_stat_sleep: OK
Testing event sched_stat_iowait: OK
Testing event sys_enter: OK
Testing event sys_exit: OK
Running tests on trace event systems:
Testing event system skb: OK
Testing event system block: OK
Testing event system jbd2: OK
Testing event system ext4: OK
Testing event system kmem: OK
Testing event system module: OK
Testing event system lockdep: OK
Testing event system workqueue: OK
Testing event system timer: OK
Testing event system irq: OK
Testing event system sched: OK
Testing event system syscalls: OK
Running tests on all trace events:
Testing all events: OK
initcall event_trace_self_tests_init+0x0/0x68 returned 0 after 1592773 usecs
calling  fail_page_alloc_debugfs+0x0/0x10d @ 1
initcall fail_page_alloc_debugfs+0x0/0x10d returned 0 after 976 usecs
calling  max_swapfiles_check+0x0/0x2d @ 1
initcall max_swapfiles_check+0x0/0x2d returned 0 after 0 usecs
calling  failslab_debugfs_init+0x0/0x91 @ 1
initcall failslab_debugfs_init+0x0/0x91 returned 0 after 0 usecs
calling  afs_init+0x0/0x1d0 @ 1
kAFS: Red Hat AFS client v0.1 registering.
initcall afs_init+0x0/0x1d0 returned 0 after 4882 usecs
calling  random32_reseed+0x0/0xc2 @ 1
initcall random32_reseed+0x0/0xc2 returned 0 after 0 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x40 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x40 returned 0 after 0 usecs
calling  pci_sysfs_init+0x0/0x77 @ 1
initcall pci_sysfs_init+0x0/0x77 returned 0 after 0 usecs
calling  seqgen_init+0x0/0x36 @ 1
initcall seqgen_init+0x0/0x36 returned 0 after 0 usecs
calling  hd_init+0x0/0x321 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x321 returned -1 after 976 usecs
initcall hd_init+0x0/0x321 returned with error code -1 
calling  scsi_complete_async_scans+0x0/0x142 @ 1
initcall scsi_complete_async_scans+0x0/0x142 returned 0 after 0 usecs
calling  rtc_hctosys+0x0/0x193 @ 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
initcall rtc_hctosys+0x0/0x193 returned -19 after 976 usecs
calling  memmap_init+0x0/0xce @ 1
initcall memmap_init+0x0/0xce returned 0 after 0 usecs
calling  init_net_drop_monitor+0x0/0x1d7 @ 1
Initalizing network drop monitor service
initcall init_net_drop_monitor+0x0/0x1d7 returned 0 after 976 usecs
calling  tcp_congestion_default+0x0/0x39 @ 1
initcall tcp_congestion_default+0x0/0x39 returned 0 after 0 usecs
calling  ip_auto_config+0x0/0x317 @ 1
initcall ip_auto_config+0x0/0x317 returned 0 after 0 usecs
calling  initialize_hashrnd+0x0/0x40 @ 1
initcall initialize_hashrnd+0x0/0x40 returned 0 after 0 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
EXT3-fs: recovery complete.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
async_waiting @ 1
async_continuing @ 1 after 0 usec
debug: unmapping init memory ffffffff81f1e000..ffffffff81fb1000
SELinux:  Disabled at runtime.
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
PGD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: 
CPU 1 
Modules linked in:
Pid: 12, comm: khelper Not tainted 2.6.31-tip-05525-g0eeacc6-dirty #14819 System Product Name
RIP: 0010:[<ffffffff81122537>]  [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
RSP: 0018:ffff88003f9258b0  EFLAGS: 00010086
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000078c0129e
RDX: 0000000000000000 RSI: ffffffff8130b626 RDI: ffffffff81122528
RBP: ffff88003f925900 R08: 0000000078c0129e R09: 0000000000000001
R10: 0000000000000000 R11: 0000000078c0129e R12: 0000000000000246
R13: 0000000000008020 R14: ffff88003f8586d8 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff880002b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: ffffffff827bd420 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khelper (pid: 12, threadinfo ffff88003f924000, task ffff88003f928000)
Stack:
 0000000000000246 0000802000000246 ffffffff8130b626 0000000000000001
<0> 0000000078c0129e 0000000000000000 ffff88003f925a70 0000000000000002
<0> 0000000000000001 0000000000000001 ffff88003f925960 ffffffff8130b626
Call Trace:
 [<ffffffff8130b626>] ? avc_alloc_node+0x36/0x273
 [<ffffffff8130b626>] avc_alloc_node+0x36/0x273
 [<ffffffff8130b545>] ? avc_latest_notif_update+0x7d/0x9e
 [<ffffffff8130b8b4>] avc_insert+0x51/0x18d
 [<ffffffff8130bcce>] avc_has_perm_noaudit+0x9d/0x128
 [<ffffffff8130bf20>] avc_has_perm+0x45/0x88
 [<ffffffff8130f99d>] current_has_perm+0x52/0x6d
 [<ffffffff8130fbb2>] selinux_task_create+0x2f/0x45
 [<ffffffff81303bf7>] security_task_create+0x29/0x3f
 [<ffffffff8105c6ba>] copy_process+0x82/0xdf0
 [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
 [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
 [<ffffffff8105d596>] do_fork+0x16e/0x382
 [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
 [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
 [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
 [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
 [<ffffffff8100cdb2>] kernel_thread+0x82/0xe0
 [<ffffffff81078b1f>] ? ____call_usermodehelper+0x0/0x139
 [<ffffffff8100ce10>] ? child_rip+0x0/0x20
 [<ffffffff81078aea>] ? __call_usermodehelper+0x65/0x9a
 [<ffffffff8107a5c7>] run_workqueue+0x171/0x27e
 [<ffffffff8107a573>] ? run_workqueue+0x11d/0x27e
 [<ffffffff81078a85>] ? __call_usermodehelper+0x0/0x9a
 [<ffffffff8107a7bc>] worker_thread+0xe8/0x10f
 [<ffffffff810808e2>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff8107a6d4>] ? worker_thread+0x0/0x10f
 [<ffffffff8108042e>] kthread+0x91/0x99
 [<ffffffff8100ce1a>] child_rip+0xa/0x20
 [<ffffffff8100c754>] ? restore_args+0x0/0x30
 [<ffffffff8108039d>] ? kthread+0x0/0x99
 [<ffffffff8100ce10>] ? child_rip+0x0/0x20
Code: 0f 85 99 00 00 00 9c 58 66 66 90 66 90 49 89 c4 fa 66 66 90 66 66 90 e8 83 34 fb ff e8 d7 e9 26 00 48 98 49 8b 94 c6 10 01 00 00 <48> 8b 1a 44 8b 7a 18 48 85 db 74 0f 8b 42 14 48 8b 04 c3 ff 42 
RIP  [<ffffffff81122537>] kmem_cache_alloc+0x9a/0x185
 RSP <ffff88003f9258b0>
CR2: 0000000000000000
---[ end trace 42f41a982344e606 ]---
Kernel panic - not syncing: Fatal exception
Pid: 12, comm: khelper Tainted: G      D    2.6.31-tip-05525-g0eeacc6-dirty #14819
Call Trace:
 [<ffffffff81821fa4>] panic+0x93/0x147
 [<ffffffff81010b4b>] oops_end+0x9c/0xbf
 [<ffffffff81032d50>] no_context+0x14c/0x16f
 [<ffffffff81032f2d>] __bad_area_nosemaphore+0x1ba/0x1f4
 [<ffffffff8103450e>] ? static_protections+0x81/0xc4
 [<ffffffff8102e6a5>] ? native_set_pte+0x9/0xe
 [<ffffffff81034cb7>] ? __change_page_attr+0x1aa/0x20b
 [<ffffffff81034d61>] ? __change_page_attr_set_clr+0x49/0xab
 [<ffffffff81032f8d>] bad_area_nosemaphore+0x26/0x3c
 [<ffffffff810d5995>] ? trace_hardirqs_off_caller+0x3b/0x51
 [<ffffffff81033326>] do_page_fault+0x17e/0x2fc
 [<ffffffff81824a5c>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81825f35>] page_fault+0x25/0x30
 [<ffffffff8130b626>] ? avc_alloc_node+0x36/0x273
 [<ffffffff81122528>] ? kmem_cache_alloc+0x8b/0x185
 [<ffffffff81122537>] ? kmem_cache_alloc+0x9a/0x185
 [<ffffffff8130b626>] ? avc_alloc_node+0x36/0x273
 [<ffffffff8130b626>] avc_alloc_node+0x36/0x273
 [<ffffffff8130b545>] ? avc_latest_notif_update+0x7d/0x9e
 [<ffffffff8130b8b4>] avc_insert+0x51/0x18d
 [<ffffffff8130bcce>] avc_has_perm_noaudit+0x9d/0x128
 [<ffffffff8130bf20>] avc_has_perm+0x45/0x88
 [<ffffffff8130f99d>] current_has_perm+0x52/0x6d
 [<ffffffff8130fbb2>] selinux_task_create+0x2f/0x45
 [<ffffffff81303bf7>] security_task_create+0x29/0x3f
 [<ffffffff8105c6ba>] copy_process+0x82/0xdf0
 [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
 [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
 [<ffffffff8105d596>] do_fork+0x16e/0x382
 [<ffffffff81091578>] ? register_lock_class+0x2f/0x36c
 [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
 [<ffffffff81091a13>] ? mark_lock+0x2e/0x1e1
 [<ffffffff810d9166>] ? probe_workqueue_execution+0x57/0xf9
 [<ffffffff8100cdb2>] kernel_thread+0x82/0xe0
 [<ffffffff81078b1f>] ? ____call_usermodehelper+0x0/0x139
 [<ffffffff8100ce10>] ? child_rip+0x0/0x20
 [<ffffffff81078aea>] ? __call_usermodehelper+0x65/0x9a
 [<ffffffff8107a5c7>] run_workqueue+0x171/0x27e
 [<ffffffff8107a573>] ? run_workqueue+0x11d/0x27e
 [<ffffffff81078a85>] ? __call_usermodehelper+0x0/0x9a
 [<ffffffff8107a7bc>] worker_thread+0xe8/0x10f
 [<ffffffff810808e2>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff8107a6d4>] ? worker_thread+0x0/0x10f
 [<ffffffff8108042e>] kthread+0x91/0x99
 [<ffffffff8100ce1a>] child_rip+0xa/0x20
 [<ffffffff8100c754>] ? restore_args+0x0/0x30
 [<ffffffff8108039d>] ? kthread+0x0/0x99
 [<ffffffff8100ce10>] ? child_rip+0x0/0x20

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31
# Wed Sep 16 14:59:39 2009
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
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
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
CONFIG_CONSTRUCTORS=y

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
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_NS is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
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
CONFIG_STRIP_ASM_SYMS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_IBS=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
# CONFIG_IOSCHED_DEADLINE is not set
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_PARAVIRT=y
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
# CONFIG_MATOM is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_NEW_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_PM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=m
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
# CONFIG_NET_DSA_TAG_EDSA is not set
# CONFIG_NET_DSA_TAG_TRAILER is not set
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_ECONET=m
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
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
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=m
CONFIG_YAM=m
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_KVASER_PCI=m
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEFAULT_PS_VALUE=0
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_TKIP_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_MPL_DEBUG is not set
CONFIG_MAC80211_DRIVER_API_TRACER=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set

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
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
# CONFIG_DELL_LAPTOP is not set
CONFIG_ISL29003=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_SCSI_CXGB3_ISCSI=m
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=m
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=m
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=y
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=m
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_HPT366=m
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=y
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=y
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RDC=m
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID6_PQ=m
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_LOG_USERSPACE=m
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
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
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
# CONFIG_IEEE1394_PCILYNX is not set
# CONFIG_IEEE1394_SBP2 is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
# CONFIG_ENC28J60 is not set
# CONFIG_ETHOC is not set
CONFIG_DNET=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
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
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=m
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_TLAN is not set
CONFIG_KS8842=m
CONFIG_KS8851=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
CONFIG_DL2K=y
CONFIG_E1000=m
CONFIG_E1000E=y
CONFIG_IP1000=m
CONFIG_IGB=m
# CONFIG_IGB_DCA is not set
CONFIG_IGBVF=m
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
# CONFIG_R8169_VLAN is not set
CONFIG_SIS190=m
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_JME=y
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=y
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
CONFIG_IXGB=m
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=y
CONFIG_BNX2X=y
CONFIG_QLGE=m
# CONFIG_SFC is not set
CONFIG_BE2NET=m
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_NET_PCMCIA is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
CONFIG_CYCLOMX_X25=y
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=m
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
CONFIG_FDDI=y
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
# CONFIG_PPPOE is not set
# CONFIG_PPPOATM is not set
CONFIG_PPPOL2TP=m
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
CONFIG_PHONE=y
# CONFIG_PHONE_IXJ is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=m
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATI_REMOTE is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=m
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
CONFIG_TELCLOCK=y
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=m
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_TSL2550=m
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_I2C_DEBUG_CHIP=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_TWL4030 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_MAX17040=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=y
# CONFIG_SENSORS_FSCPOS is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_LIS3_SPI=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=m
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
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

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
# CONFIG_UCB1400_CORE is not set
CONFIG_TPS65010=y
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA5246A is not set
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
# CONFIG_VIDEO_SAA7134 is not set
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
# CONFIG_VIDEO_CX88 is not set
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
# CONFIG_USB_GSPCA_JEILINJ is not set
# CONFIG_USB_GSPCA_MARS is not set
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SN9C20X_EVDEV=y
CONFIG_USB_GSPCA_SONIXB=m
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
# CONFIG_USB_GSPCA_SPCA506 is not set
CONFIG_USB_GSPCA_SPCA508=m
# CONFIG_USB_GSPCA_SPCA561 is not set
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
# CONFIG_USB_GSPCA_ZC3XX is not set
CONFIG_VIDEO_PVRUSB2=m
# CONFIG_VIDEO_PVRUSB2_SYSFS is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_ALSA is not set
# CONFIG_VIDEO_CX231XX is not set
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC_INPUT_EVDEV is not set
# CONFIG_USB_ZR364XX is not set
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_MAESTRO=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
CONFIG_USB_DSBR=m
CONFIG_RADIO_SI470X=y
# CONFIG_USB_SI470X is not set
CONFIG_I2C_SI470X=m
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
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
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_HGA_ACCEL is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_MATROX_MULTIHEAD=y
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=m
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
# CONFIG_FB_MB862XX_PCI_GDC is not set
CONFIG_FB_BROADSHEET=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=m

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
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_SB_COMMON=m
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=m
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
# CONFIG_SND_GINA24 is not set
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
# CONFIG_SND_MIA is not set
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
# CONFIG_SND_INDIGOIOX is not set
CONFIG_SND_INDIGODJX=m
# CONFIG_SND_EMU10K1 is not set
CONFIG_SND_EMU10K1X=m
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
CONFIG_SND_USB_US122L=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
CONFIG_SND_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
# CONFIG_HID is not set

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=m

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
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=m
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=y
CONFIG_USB_BERRY_CHARGE=m
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=y
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=m
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=y
CONFIG_UWB_WLP=m
CONFIG_UWB_I1480U=m
# CONFIG_UWB_I1480U_WLP is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

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
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_BD2802=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_TWL4030 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=m
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
# CONFIG_RTC_DRV_DS3234 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
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
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_SMX=m
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_OCFS2_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFS_FSCACHE=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
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
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_MARKERS is not set
CONFIG_SAMPLE_TRACEPOINTS=m
CONFIG_SAMPLE_TRACE_EVENTS=m
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
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
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
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
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
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
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y

--KsGdsel6WgEHnImy--
