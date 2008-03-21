Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYCUOgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYCUOgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYCUOgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:36:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbYCUOgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:36:01 -0400
Date: Fri, 21 Mar 2008 15:35:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080321143533.GA32096@elte.hu>
References: <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu> <47E19085.2020308@goop.org> <20080319235212.GA22786@elte.hu> <47E2C7E3.40109@goop.org> <20080321131738.GI27245@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20080321131738.GI27245@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> > Hm.  I think the problem was that the patch changed the ordering so 
> > that the %ebp fault test was happening with interrupts disabled, 
> > meaning that any fault-in would happen with interrupts disabled.
> >
> > Could you tell me if this revised patch still provokes a problem?
> 
> it's looking good so far - queued it up.

it just crashed again, crashlog and config attached. This time it didnt 
need an irq flood.

	Ingo

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

Linux version 2.6.25-rc6-sched-devel.git-x86-latest.git (mingo@dione) (gcc version 4.2.2) #321 SMP PREEMPT Fri Mar 21 15:12:31 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
debug: ignoring loglevel setting.
127MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f5680] 000f5680
CPU and/or kernel does not support PAT.
Entering add_active_range(0, 0, 262128) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262128
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262128
On node 0 totalpages: 262128
  DMA zone: 52 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4044 pages, LIFO batch:0
  Normal zone: 2860 pages used for memmap
  Normal zone: 222420 pages, LIFO batch:31
  HighMem zone: 415 pages used for memmap
  HighMem zone: 32337 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37636 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258801
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0
debug: sysrq always enabled.
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
CPU 0 irqstacks, hard=c0711000 soft=c06f1000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2010.322 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1920 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1023748k/1048512k available (3669k kernel code, 24164k reserved, 2068k data, 312k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc54000 - 0xfffff000   (3756 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc06a0000 - 0xc06ee000   ( 312 kB)
      .data : 0xc04957c8 - 0xc069ab9c   (2068 kB)
      .text : 0xc0100000 - 0xc04957c8   (3669 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 4022.92 BogoMIPS (lpj=2011463)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...  failed.
...trying to set up timer as Virtual Wire IRQ... failed.
...trying to set up timer as ExtINT IRQ... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1256247
... PM timer delta = 357900
... PM timer result ok
..... delta 1256247
..... mult: 53963600
..... calibration result: 200999
..... CPU clock speed is 2009.0993 MHz.
..... host bus clock speed is 200.0999 MHz.
lockdep: fixing up alternatives.
CPU 1 irqstacks, hard=c0712000 soft=c06f2000
Booting processor 1/1 ip 4000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4019.91 BogoMIPS (lpj=2009958)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (8042.84 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
Calling initcall 0xc06bf966: init_cpufreq_transition_notifier_list+0x0/0x11()
initcall 0xc06bf966: init_cpufreq_transition_notifier_list+0x0/0x11() returned 0.
initcall 0xc06bf966 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x11()
Calling initcall 0xc06c31e5: net_ns_init+0x0/0xcd()
net_namespace: 608 bytes
initcall 0xc06c31e5: net_ns_init+0x0/0xcd() returned 0.
initcall 0xc06c31e5 ran for 0 msecs: net_ns_init+0x0/0xcd()
Calling initcall 0xc06a83ad: cpufreq_tsc+0x0/0x11()
initcall 0xc06a83ad: cpufreq_tsc+0x0/0x11() returned 0.
initcall 0xc06a83ad ran for 0 msecs: cpufreq_tsc+0x0/0x11()
Calling initcall 0xc06aabb4: reboot_init+0x0/0x11()
initcall 0xc06aabb4: reboot_init+0x0/0x11() returned 0.
initcall 0xc06aabb4 ran for 0 msecs: reboot_init+0x0/0x11()
Calling initcall 0xc06b132c: sysctl_init+0x0/0x29()
initcall 0xc06b132c: sysctl_init+0x0/0x29() returned 0.
initcall 0xc06b132c ran for 0 msecs: sysctl_init+0x0/0x29()
Calling initcall 0xc06b1997: ksysfs_init+0x0/0x96()
initcall 0xc06b1997: ksysfs_init+0x0/0x96() returned 0.
initcall 0xc06b1997 ran for 0 msecs: ksysfs_init+0x0/0x96()
Calling initcall 0xc06b1cc8: init_jiffies_clocksource+0x0/0xf()
initcall 0xc06b1cc8: init_jiffies_clocksource+0x0/0xf() returned 0.
initcall 0xc06b1cc8 ran for 0 msecs: init_jiffies_clocksource+0x0/0xf()
Calling initcall 0xc06b1fca: pm_init+0x0/0x2d()
initcall 0xc06b1fca: pm_init+0x0/0x2d() returned 0.
initcall 0xc06b1fca ran for 0 msecs: pm_init+0x0/0x2d()
Calling initcall 0xc06b4a64: filelock_init+0x0/0x27()
initcall 0xc06b4a64: filelock_init+0x0/0x27() returned 0.
initcall 0xc06b4a64 ran for 0 msecs: filelock_init+0x0/0x27()
Calling initcall 0xc06b52f2: init_misc_binfmt+0x0/0x33()
initcall 0xc06b52f2: init_misc_binfmt+0x0/0x33() returned 0.
initcall 0xc06b52f2 ran for 0 msecs: init_misc_binfmt+0x0/0x33()
Calling initcall 0xc06b5325: init_script_binfmt+0x0/0xf()
initcall 0xc06b5325: init_script_binfmt+0x0/0xf() returned 0.
initcall 0xc06b5325 ran for 0 msecs: init_script_binfmt+0x0/0xf()
Calling initcall 0xc06b5334: init_elf_binfmt+0x0/0xf()
initcall 0xc06b5334: init_elf_binfmt+0x0/0xf() returned 0.
initcall 0xc06b5334 ran for 0 msecs: init_elf_binfmt+0x0/0xf()
Calling initcall 0xc06b5c59: debugfs_init+0x0/0x41()
initcall 0xc06b5c59: debugfs_init+0x0/0x41() returned 0.
initcall 0xc06b5c59 ran for 0 msecs: debugfs_init+0x0/0x41()
Calling initcall 0xc06b5ffc: securityfs_init+0x0/0x41()
initcall 0xc06b5ffc: securityfs_init+0x0/0x41() returned 0.
initcall 0xc06b5ffc ran for 0 msecs: securityfs_init+0x0/0x41()
Calling initcall 0xc06b6f51: random32_init+0x0/0x48()
initcall 0xc06b6f51: random32_init+0x0/0x48() returned 0.
initcall 0xc06b6f51 ran for 0 msecs: random32_init+0x0/0x48()
Calling initcall 0xc06bf977: cpufreq_core_init+0x0/0x5a()
initcall 0xc06bf977: cpufreq_core_init+0x0/0x5a() returned 0.
initcall 0xc06bf977 ran for 0 msecs: cpufreq_core_init+0x0/0x5a()
Calling initcall 0xc06c30d5: sock_init+0x0/0x51()
initcall 0xc06c30d5: sock_init+0x0/0x51() returned 0.
initcall 0xc06c30d5 ran for 0 msecs: sock_init+0x0/0x51()
Calling initcall 0xc06c3900: netpoll_init+0x0/0x39()
initcall 0xc06c3900: netpoll_init+0x0/0x39() returned 0.
initcall 0xc06c3900 ran for 0 msecs: netpoll_init+0x0/0x39()
Calling initcall 0xc06c3c40: netlink_proto_init+0x0/0x102()
NET: Registered protocol family 16
initcall 0xc06c3c40: netlink_proto_init+0x0/0x102() returned 0.
initcall 0xc06c3c40 ran for 0 msecs: netlink_proto_init+0x0/0x102()
Calling initcall 0xc06b6e8f: kobject_uevent_init+0x0/0x3f()
initcall 0xc06b6e8f: kobject_uevent_init+0x0/0x3f() returned 0.
initcall 0xc06b6e8f ran for 0 msecs: kobject_uevent_init+0x0/0x3f()
Calling initcall 0xc06b7110: pcibus_class_init+0x0/0xf()
initcall 0xc06b7110: pcibus_class_init+0x0/0xf() returned 0.
initcall 0xc06b7110 ran for 0 msecs: pcibus_class_init+0x0/0xf()
Calling initcall 0xc06b7632: pci_driver_init+0x0/0xf()
initcall 0xc06b7632: pci_driver_init+0x0/0xf() returned 0.
initcall 0xc06b7632 ran for 0 msecs: pci_driver_init+0x0/0xf()
Calling initcall 0xc06b7918: backlight_class_init+0x0/0x3d()
initcall 0xc06b7918: backlight_class_init+0x0/0x3d() returned 0.
initcall 0xc06b7918 ran for 0 msecs: backlight_class_init+0x0/0x3d()
Calling initcall 0xc06b8c43: dock_init+0x0/0x4a()
No dock devices found.
initcall 0xc06b8c43: dock_init+0x0/0x4a() returned 0.
initcall 0xc06b8c43 ran for 0 msecs: dock_init+0x0/0x4a()
Calling initcall 0xc06bad09: tty_class_init+0x0/0x23()
initcall 0xc06bad09: tty_class_init+0x0/0x23() returned 0.
initcall 0xc06bad09 ran for 0 msecs: tty_class_init+0x0/0x23()
Calling initcall 0xc06bb543: vtconsole_class_init+0x0/0x9a()
initcall 0xc06bb543: vtconsole_class_init+0x0/0x9a() returned 0.
initcall 0xc06bb543 ran for 0 msecs: vtconsole_class_init+0x0/0x9a()
Calling initcall 0xc06a8150: arch_kdebugfs_init+0x0/0x7()
initcall 0xc06a8150: arch_kdebugfs_init+0x0/0x7() returned 0.
initcall 0xc06a8150 ran for 0 msecs: arch_kdebugfs_init+0x0/0x7()
Calling initcall 0xc06a828e: init_pit_clocksource+0x0/0x71()
initcall 0xc06a828e: init_pit_clocksource+0x0/0x71() returned 0.
initcall 0xc06a828e ran for 0 msecs: init_pit_clocksource+0x0/0x71()
Calling initcall 0xc06a8e39: mtrr_if_init+0x0/0x56()
initcall 0xc06a8e39: mtrr_if_init+0x0/0x56() returned 0.
initcall 0xc06a8e39 ran for 0 msecs: mtrr_if_init+0x0/0x56()
Calling initcall 0xc06aaae8: ffh_cstate_init+0x0/0x2c()
initcall 0xc06aaae8: ffh_cstate_init+0x0/0x2c() returned -1.
initcall 0xc06aaae8 ran for 0 msecs: ffh_cstate_init+0x0/0x2c()
initcall at 0xc06aaae8: ffh_cstate_init+0x0/0x2c(): returned with error code -1
Calling initcall 0xc06b77de: acpi_pci_init+0x0/0x3d()
ACPI: bus type pci registered
initcall 0xc06b77de: acpi_pci_init+0x0/0x3d() returned 0.
initcall 0xc06b77de ran for 0 msecs: acpi_pci_init+0x0/0x3d()
Calling initcall 0xc06b8951: init_acpi_device_notify+0x0/0x43()
initcall 0xc06b8951: init_acpi_device_notify+0x0/0x43() returned 0.
initcall 0xc06b8951 ran for 0 msecs: init_acpi_device_notify+0x0/0x43()
Calling initcall 0xc06c0270: dmi_id_init+0x0/0x266()
initcall 0xc06c0270: dmi_id_init+0x0/0x266() returned 0.
initcall 0xc06c0270 ran for 0 msecs: dmi_id_init+0x0/0x266()
Calling initcall 0xc06c04d6: init_cyclone_clocksource+0x0/0x169()
initcall 0xc06c04d6: init_cyclone_clocksource+0x0/0x169() returned -19.
initcall 0xc06c04d6 ran for 0 msecs: init_cyclone_clocksource+0x0/0x169()
Calling initcall 0xc06c1a10: pci_access_init+0x0/0x40()
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
initcall 0xc06c1a10: pci_access_init+0x0/0x40() returned 0.
initcall 0xc06c1a10 ran for 3 msecs: pci_access_init+0x0/0x40()
Calling initcall 0xc06a696b: request_standard_resources+0x0/0x57()
Setting up standard PCI resources
initcall 0xc06a696b: request_standard_resources+0x0/0x57() returned 0.
initcall 0xc06a696b ran for 4 msecs: request_standard_resources+0x0/0x57()
Calling initcall 0xc06a8121: topology_init+0x0/0x2f()
initcall 0xc06a8121: topology_init+0x0/0x2f() returned 0.
initcall 0xc06a8121 ran for 0 msecs: topology_init+0x0/0x2f()
Calling initcall 0xc06a8add: mtrr_init_finialize+0x0/0x2c()
initcall 0xc06a8add: mtrr_init_finialize+0x0/0x2c() returned 0.
initcall 0xc06a8add ran for 0 msecs: mtrr_init_finialize+0x0/0x2c()
Calling initcall 0xc06b1693: param_sysfs_init+0x0/0x153()
initcall 0xc06b1693: param_sysfs_init+0x0/0x153() returned 0.
initcall 0xc06b1693 ran for 4 msecs: param_sysfs_init+0x0/0x153()
Calling initcall 0xc015fa70: pm_sysrq_init+0x0/0x16()
initcall 0xc015fa70: pm_sysrq_init+0x0/0x16() returned 0.
initcall 0xc015fa70 ran for 0 msecs: pm_sysrq_init+0x0/0x16()
Calling initcall 0xc06b41b8: readahead_init+0x0/0xf()
initcall 0xc06b41b8: readahead_init+0x0/0xf() returned 0.
initcall 0xc06b41b8 ran for 0 msecs: readahead_init+0x0/0xf()
Calling initcall 0xc06b4fe1: init_bio+0x0/0xa6()
initcall 0xc06b4fe1: init_bio+0x0/0xa6() returned 0.
initcall 0xc06b4fe1 ran for 0 msecs: init_bio+0x0/0xa6()
Calling initcall 0xc06b6c10: blk_settings_init+0x0/0x1d()
initcall 0xc06b6c10: blk_settings_init+0x0/0x1d() returned 0.
initcall 0xc06b6c10 ran for 0 msecs: blk_settings_init+0x0/0x1d()
Calling initcall 0xc06b6c2d: blk_ioc_init+0x0/0x24()
initcall 0xc06b6c2d: blk_ioc_init+0x0/0x24() returned 0.
initcall 0xc06b6c2d ran for 0 msecs: blk_ioc_init+0x0/0x24()
Calling initcall 0xc06b6c51: genhd_device_init+0x0/0x32()
initcall 0xc06b6c51: genhd_device_init+0x0/0x32() returned 0.
initcall 0xc06b6c51 ran for 0 msecs: genhd_device_init+0x0/0x32()
Calling initcall 0xc06b781b: fbmem_init+0x0/0x7c()
initcall 0xc06b781b: fbmem_init+0x0/0x7c() returned 0.
initcall 0xc06b781b ran for 0 msecs: fbmem_init+0x0/0x7c()
Calling initcall 0xc06b8735: acpi_init+0x0/0x21c()
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
initcall 0xc06b8735: acpi_init+0x0/0x21c() returned 0.
initcall 0xc06b8735 ran for 14 msecs: acpi_init+0x0/0x21c()
Calling initcall 0xc06b8994: acpi_scan_init+0x0/0xed()
initcall 0xc06b8994: acpi_scan_init+0x0/0xed() returned 0.
initcall 0xc06b8994 ran for 12 msecs: acpi_scan_init+0x0/0xed()
Calling initcall 0xc06b8a81: acpi_ec_init+0x0/0x55()
initcall 0xc06b8a81: acpi_ec_init+0x0/0x55() returned 0.
initcall 0xc06b8a81 ran for 0 msecs: acpi_ec_init+0x0/0x55()
Calling initcall 0xc06b8c8d: acpi_pci_root_init+0x0/0x25()
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
initcall 0xc06b8c8d: acpi_pci_root_init+0x0/0x25() returned 0.
initcall 0xc06b8c8d ran for 73 msecs: acpi_pci_root_init+0x0/0x25()
Calling initcall 0xc06b8d8b: acpi_pci_link_init+0x0/0x43()
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
initcall 0xc06b8d8b: acpi_pci_link_init+0x0/0x43() returned 0.
initcall 0xc06b8d8b ran for 118 msecs: acpi_pci_link_init+0x0/0x43()
Calling initcall 0xc06b8e4d: acpi_power_init+0x0/0x69()
initcall 0xc06b8e4d: acpi_power_init+0x0/0x69() returned 0.
initcall 0xc06b8e4d ran for 0 msecs: acpi_power_init+0x0/0x69()
Calling initcall 0xc06b903d: acpi_system_init+0x0/0x1fe()
initcall 0xc06b903d: acpi_system_init+0x0/0x1fe() returned 0.
initcall 0xc06b903d ran for 0 msecs: acpi_system_init+0x0/0x1fe()
Calling initcall 0xc06b92aa: acpi_cm_sbs_init+0x0/0x7()
initcall 0xc06b92aa: acpi_cm_sbs_init+0x0/0x7() returned 0.
initcall 0xc06b92aa ran for 0 msecs: acpi_cm_sbs_init+0x0/0x7()
Calling initcall 0xc06b92b1: pnp_init+0x0/0x19()
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall 0xc06b92b1: pnp_init+0x0/0x19() returned 0.
initcall 0xc06b92b1 ran for 0 msecs: pnp_init+0x0/0x19()
Calling initcall 0xc06b947e: pnpacpi_init+0x0/0x7b()
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnpacpi: exceeded the max number of mem resources: 12
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
initcall 0xc06b947e: pnpacpi_init+0x0/0x7b() returned 0.
initcall 0xc06b947e ran for 11 msecs: pnpacpi_init+0x0/0x7b()
Calling initcall 0xc06bb0e1: misc_init+0x0/0x71()
initcall 0xc06bb0e1: misc_init+0x0/0x71() returned 0.
initcall 0xc06bb0e1 ran for 0 msecs: misc_init+0x0/0x71()
Calling initcall 0xc04742e3: cn_init+0x0/0xaf()
initcall 0xc04742e3: cn_init+0x0/0xaf() returned 0.
initcall 0xc04742e3 ran for 0 msecs: cn_init+0x0/0xaf()
Calling initcall 0xc06bd673: init_scsi+0x0/0x89()
SCSI subsystem initialized
initcall 0xc06bd673: init_scsi+0x0/0x89() returned 0.
initcall 0xc06bd673 ran for 0 msecs: init_scsi+0x0/0x89()
Calling initcall 0xc06bdead: ata_init+0x0/0x2b3()
libata version 3.00 loaded.
initcall 0xc06bdead: ata_init+0x0/0x2b3() returned 0.
initcall 0xc06bdead ran for 0 msecs: ata_init+0x0/0x2b3()
Calling initcall 0xc06bebba: init_pcmcia_cs+0x0/0x31()
initcall 0xc06bebba: init_pcmcia_cs+0x0/0x31() returned 0.
initcall 0xc06bebba ran for 0 msecs: init_pcmcia_cs+0x0/0x31()
Calling initcall 0xc06bece3: usb_init+0x0/0x10d()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xc06bece3: usb_init+0x0/0x10d() returned 0.
initcall 0xc06bece3 ran for 2 msecs: usb_init+0x0/0x10d()
Calling initcall 0xc06bf1ea: serio_init+0x0/0x82()
initcall 0xc06bf1ea: serio_init+0x0/0x82() returned 0.
initcall 0xc06bf1ea ran for 0 msecs: serio_init+0x0/0x82()
Calling initcall 0xc06bf5c7: input_init+0x0/0xf3()
initcall 0xc06bf5c7: input_init+0x0/0xf3() returned 0.
initcall 0xc06bf5c7 ran for 0 msecs: input_init+0x0/0xf3()
Calling initcall 0xc06bf843: power_supply_class_init+0x0/0x29()
initcall 0xc06bf843: power_supply_class_init+0x0/0x29() returned 0.
initcall 0xc06bf843 ran for 0 msecs: power_supply_class_init+0x0/0x29()
Calling initcall 0xc06bf86c: thermal_init+0x0/0x41()
initcall 0xc06bf86c: thermal_init+0x0/0x41() returned 0.
initcall 0xc06bf86c ran for 0 msecs: thermal_init+0x0/0x41()
Calling initcall 0xc06bf8ad: md_init+0x0/0xb9()
initcall 0xc06bf8ad: md_init+0x0/0xb9() returned 0.
initcall 0xc06bf8ad ran for 0 msecs: md_init+0x0/0xb9()
Calling initcall 0xc06bf9ef: leds_init+0x0/0x23()
initcall 0xc06bf9ef: leds_init+0x0/0x23() returned 0.
initcall 0xc06bf9ef ran for 0 msecs: leds_init+0x0/0x23()
Calling initcall 0xc06c1704: ac97_bus_init+0x0/0xf()
initcall 0xc06c1704: ac97_bus_init+0x0/0xf() returned 0.
initcall 0xc06c1704 ran for 0 msecs: ac97_bus_init+0x0/0xf()
Calling initcall 0xc06c26a0: pci_acpi_init+0x0/0x98()
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 16.
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
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 003 03  1    0    0   0   0    0    0    00
 01 003 03  1    0    0   0   0    1    1    39
 02 003 03  0    0    0   0   0    1    1    41
 03 003 03  1    0    0   0   0    1    1    49
 04 003 03  1    0    0   0   0    1    1    51
 05 003 03  1    0    0   0   0    1    1    59
 06 003 03  1    0    0   0   0    1    1    61
 07 003 03  1    0    0   0   0    1    1    69
 08 003 03  1    0    0   0   0    1    1    71
 09 003 03  0    1    0   0   0    1    1    79
 0a 003 03  1    0    0   0   0    1    1    81
 0b 003 03  1    0    0   0   0    1    1    89
 0c 003 03  1    0    0   0   0    1    1    91
 0d 003 03  1    0    0   0   0    1    1    99
 0e 003 03  0    0    0   0   0    1    1    A1
 0f 003 03  0    0    0   0   0    1    1    A9
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
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
initcall 0xc06c26a0: pci_acpi_init+0x0/0x98() returned 0.
initcall 0xc06c26a0 ran for 82 msecs: pci_acpi_init+0x0/0x98()
Calling initcall 0xc06c2738: pci_legacy_init+0x0/0xd7()
initcall 0xc06c2738: pci_legacy_init+0x0/0xd7() returned 0.
initcall 0xc06c2738 ran for 0 msecs: pci_legacy_init+0x0/0xd7()
Calling initcall 0xc06c2c15: pcibios_irq_init+0x0/0x444()
initcall 0xc06c2c15: pcibios_irq_init+0x0/0x444() returned 0.
initcall 0xc06c2c15 ran for 0 msecs: pcibios_irq_init+0x0/0x444()
Calling initcall 0xc06c3059: pcibios_init+0x0/0x7c()
initcall 0xc06c3059: pcibios_init+0x0/0x7c() returned 0.
initcall 0xc06c3059 ran for 0 msecs: pcibios_init+0x0/0x7c()
Calling initcall 0xc06c317c: proto_init+0x0/0x27()
initcall 0xc06c317c: proto_init+0x0/0x27() returned 0.
initcall 0xc06c317c ran for 0 msecs: proto_init+0x0/0x27()
Calling initcall 0xc06c34e5: net_dev_init+0x0/0x13c()
initcall 0xc06c34e5: net_dev_init+0x0/0x13c() returned 0.
initcall 0xc06c34e5 ran for 0 msecs: net_dev_init+0x0/0x13c()
Calling initcall 0xc06c365e: neigh_init+0x0/0x66()
initcall 0xc06c365e: neigh_init+0x0/0x66() returned 0.
initcall 0xc06c365e ran for 0 msecs: neigh_init+0x0/0x66()
Calling initcall 0xc06c3939: fib_rules_init+0x0/0x99()
initcall 0xc06c3939: fib_rules_init+0x0/0x99() returned 0.
initcall 0xc06c3939 ran for 0 msecs: fib_rules_init+0x0/0x99()
Calling initcall 0xc06c3ae3: pktsched_init+0x0/0xa9()
initcall 0xc06c3ae3: pktsched_init+0x0/0xa9() returned 0.
initcall 0xc06c3ae3 ran for 0 msecs: pktsched_init+0x0/0xa9()
Calling initcall 0xc06c3b9b: tc_filter_init+0x0/0x43()
initcall 0xc06c3b9b: tc_filter_init+0x0/0x43() returned 0.
initcall 0xc06c3b9b ran for 0 msecs: tc_filter_init+0x0/0x43()
Calling initcall 0xc06c3bde: tc_action_init+0x0/0x43()
initcall 0xc06c3bde: tc_action_init+0x0/0x43() returned 0.
initcall 0xc06c3bde ran for 0 msecs: tc_action_init+0x0/0x43()
Calling initcall 0xc06c3d42: genl_init+0x0/0xad()
initcall 0xc06c3d42: genl_init+0x0/0xad() returned 0.
initcall 0xc06c3d42 ran for 5 msecs: genl_init+0x0/0xad()
Calling initcall 0xc06c51e1: cipso_v4_init+0x0/0x6d()
initcall 0xc06c51e1: cipso_v4_init+0x0/0x6d() returned 0.
initcall 0xc06c51e1 ran for 0 msecs: cipso_v4_init+0x0/0x6d()
Calling initcall 0xc06c5551: wireless_nlevent_init+0x0/0x39()
initcall 0xc06c5551: wireless_nlevent_init+0x0/0x39() returned 0.
initcall 0xc06c5551 ran for 0 msecs: wireless_nlevent_init+0x0/0x39()
Calling initcall 0xc06c55a6: netlbl_init+0x0/0x6d()
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall 0xc06c55a6: netlbl_init+0x0/0x6d() returned 0.
initcall 0xc06c55a6 ran for 3 msecs: netlbl_init+0x0/0x6d()
Calling initcall 0xc06c58a1: sysctl_init+0x0/0x23()
initcall 0xc06c58a1: sysctl_init+0x0/0x23() returned 0.
initcall 0xc06c58a1 ran for 0 msecs: sysctl_init+0x0/0x23()
Calling initcall 0xc06af506: hpet_late_init+0x0/0xfc()
initcall 0xc06af506: hpet_late_init+0x0/0xfc() returned -19.
initcall 0xc06af506 ran for 0 msecs: hpet_late_init+0x0/0xfc()
Calling initcall 0xc06b1bfb: clocksource_done_booting+0x0/0x11()
initcall 0xc06b1bfb: clocksource_done_booting+0x0/0x11() returned 0.
initcall 0xc06b1bfb ran for 0 msecs: clocksource_done_booting+0x0/0x11()
Calling initcall 0xc06b49ff: init_pipe_fs+0x0/0x41()
initcall 0xc06b49ff: init_pipe_fs+0x0/0x41() returned 0.
initcall 0xc06b49ff ran for 0 msecs: init_pipe_fs+0x0/0x41()
Calling initcall 0xc06b5196: eventpoll_init+0x0/0x7d()
initcall 0xc06b5196: eventpoll_init+0x0/0x7d() returned 0.
initcall 0xc06b5196 ran for 0 msecs: eventpoll_init+0x0/0x7d()
Calling initcall 0xc06b5213: anon_inode_init+0x0/0xdf()
initcall 0xc06b5213: anon_inode_init+0x0/0xdf() returned 0.
initcall 0xc06b5213 ran for 0 msecs: anon_inode_init+0x0/0xdf()
Calling initcall 0xc06b923b: acpi_event_init+0x0/0x6f()
initcall 0xc06b923b: acpi_event_init+0x0/0x6f() returned 0.
initcall 0xc06b923b ran for 5 msecs: acpi_event_init+0x0/0x6f()
Calling initcall 0xc06b93a2: pnp_system_init+0x0/0xf()
system 00:01: ioport range 0x4000-0x407f has been reserved
system 00:01: ioport range 0x4080-0x40ff has been reserved
system 00:01: ioport range 0x4400-0x447f has been reserved
system 00:01: ioport range 0x4480-0x44ff has been reserved
system 00:01: ioport range 0x4800-0x487f has been reserved
system 00:01: ioport range 0x4880-0x48ff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x805 has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
system 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
system 00:0f: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:0f: iomem range 0xffff0000-0xffffffff could not be reserved
Clocksource tsc unstable (delta = 564025945 ns)
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0f: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:0f: iomem range 0xfefff000-0xfeffffff could not be reserved
system 00:0f: iomem range 0xfff80000-0xfff80fff could not be reserved
initcall 0xc06b93a2: pnp_system_init+0x0/0xf() returned 0.
initcall 0xc06b93a2 ran for 20 msecs: pnp_system_init+0x0/0xf()
Calling initcall 0xc06bac50: chr_dev_init+0x0/0x86()
initcall 0xc06bac50: chr_dev_init+0x0/0x86() returned 0.
initcall 0xc06bac50 ran for 0 msecs: chr_dev_init+0x0/0x86()
Calling initcall 0xc06bc644: firmware_class_init+0x0/0x5c()
initcall 0xc06bc644: firmware_class_init+0x0/0x5c() returned 0.
initcall 0xc06bc644 ran for 0 msecs: firmware_class_init+0x0/0x5c()
Calling initcall 0xc06bd445: loopback_init+0x0/0xf()
initcall 0xc06bd445: loopback_init+0x0/0xf() returned 0.
initcall 0xc06bd445 ran for 0 msecs: loopback_init+0x0/0xf()
Calling initcall 0xc06bebeb: init_pcmcia_bus+0x0/0x6c()
initcall 0xc06bebeb: init_pcmcia_bus+0x0/0x6c() returned 0.
initcall 0xc06bebeb ran for 0 msecs: init_pcmcia_bus+0x0/0x6c()
Calling initcall 0xc06bf9d1: cpufreq_gov_performance_init+0x0/0xf()
initcall 0xc06bf9d1: cpufreq_gov_performance_init+0x0/0xf() returned 0.
initcall 0xc06bf9d1 ran for 0 msecs: cpufreq_gov_performance_init+0x0/0xf()
Calling initcall 0xc06bf9e0: cpufreq_gov_userspace_init+0x0/0xf()
initcall 0xc06bf9e0: cpufreq_gov_userspace_init+0x0/0xf() returned 0.
initcall 0xc06bf9e0 ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0xf()
Calling initcall 0xc06c0653: init_acpi_pm_clocksource+0x0/0x148()
initcall 0xc06c0653<6>Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
: init_acpi_pm_clocksource+0x0/0x148() returned 0.
initcall 0xc06c0653 ran for 28 msecs: init_acpi_pm_clocksource+0x0/0x148()
Calling initcall 0xc06c1763: pcibios_assign_resources+0x0/0x91()
PCI: Bridge: 0000:00:09.0
  IO window: c000-cfff
  MEM window: 0xda000000-0xda0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: b000-bfff
  MEM window: 0xd8000000-0xd9ffffff
  PREFETCH window: 0x00000000d0000000-0x00000000d7ffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
initcall 0xc06c1763: pcibios_assign_resources+0x0/0x91() returned 0.
initcall 0xc06c1763 ran for 72 msecs: pcibios_assign_resources+0x0/0x91()
Calling initcall 0xc06c4ada: inet_init+0x0/0x36e()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xc06c4ada: inet_init+0x0/0x36e() returned 0.
initcall 0xc06c4ada ran for 54 msecs: inet_init+0x0/0x36e()
Calling initcall 0xc06a5747: populate_rootfs+0x0/0xcd()
initcall 0xc06a5747: populate_rootfs+0x0/0xcd() returned 0.
initcall 0xc06a5747 ran for 0 msecs: populate_rootfs+0x0/0xcd()
Calling initcall 0xc06a5b52: vmx_init+0x0/0xec()
kvm: no hardware support
initcall 0xc06a5b52: vmx_init+0x0/0xec() returned -95.
initcall 0xc06a5b52 ran for 2 msecs: vmx_init+0x0/0xec()
initcall at 0xc06a5b52: vmx_init+0x0/0xec(): returned with error code -95
Calling initcall 0xc06a5c3e: svm_init+0x0/0x16()
has_svm: svm not available
kvm: no hardware support
initcall 0xc06a5c3e: svm_init+0x0/0x16() returned -95.
initcall 0xc06a5c3e ran for 4 msecs: svm_init+0x0/0x16()
initcall at 0xc06a5c3e: svm_init+0x0/0x16(): returned with error code -95
Calling initcall 0xc06a70c2: i8259A_init_sysfs+0x0/0x1d()
initcall 0xc06a70c2: i8259A_init_sysfs+0x0/0x1d() returned 0.
initcall 0xc06a70c2 ran for 0 msecs: i8259A_init_sysfs+0x0/0x1d()
Calling initcall 0xc06a72c5: sbf_init+0x0/0xbd()
initcall 0xc06a72c5: sbf_init+0x0/0xbd() returned 0.
initcall 0xc06a72c5 ran for 0 msecs: sbf_init+0x0/0xbd()
Calling initcall 0xc06a8104: i8237A_init_sysfs+0x0/0x1d()
initcall 0xc06a8104: i8237A_init_sysfs+0x0/0x1d() returned 0.
initcall 0xc06a8104 ran for 0 msecs: i8237A_init_sysfs+0x0/0x1d()
Calling initcall 0xc0489429: cache_sysfs_init+0x0/0x4e()
initcall 0xc0489429: cache_sysfs_init+0x0/0x4e() returned 0.
initcall 0xc0489429 ran for 0 msecs: cache_sysfs_init+0x0/0x4e()
Calling initcall 0xc06a8a5c: thermal_throttle_init_device+0x0/0x70()
initcall 0xc06a8a5c: thermal_throttle_init_device+0x0/0x70() returned 0.
initcall 0xc06a8a5c ran for 0 msecs: thermal_throttle_init_device+0x0/0x70()
Calling initcall 0xc06a9785: longrun_init+0x0/0x2d()
initcall 0xc06a9785: longrun_init+0x0/0x2d() returned -19.
initcall 0xc06a9785 ran for 0 msecs: longrun_init+0x0/0x2d()
Calling initcall 0xc06a9a6a: speedstep_init+0x0/0x1e8()
initcall 0xc06a9a6a: speedstep_init+0x0/0x1e8() returned -19.
initcall 0xc06a9a6a ran for 0 msecs: speedstep_init+0x0/0x1e8()
Calling initcall 0xc06a9c52: speedstep_init+0x0/0xf4()
initcall 0xc06a9c52: speedstep_init+0x0/0xf4() returned -19.
initcall 0xc06a9c52 ran for 0 msecs: speedstep_init+0x0/0xf4()
Calling initcall 0xc06ab1aa: apm_init+0x0/0x37a()
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
initcall 0xc06ab1aa: apm_init+0x0/0x37a() returned -19.
initcall 0xc06ab1aa ran for 7 msecs: apm_init+0x0/0x37a()
Calling initcall 0xc06ac3fe: init_lapic_sysfs+0x0/0x28()
initcall 0xc06ac3fe: init_lapic_sysfs+0x0/0x28() returned 0.
initcall 0xc06ac3fe ran for 0 msecs: init_lapic_sysfs+0x0/0x28()
Calling initcall 0xc06ae563: ioapic_init_sysfs+0x0/0xb7()
initcall 0xc06ae563: ioapic_init_sysfs+0x0/0xb7() returned 0.
initcall 0xc06ae563 ran for 0 msecs: ioapic_init_sysfs+0x0/0xb7()
Calling initcall 0xc06af635: add_pcspkr+0x0/0x35()
initcall 0xc06af635: add_pcspkr+0x0/0x35() returned 0.
initcall 0xc06af635 ran for 0 msecs: add_pcspkr+0x0/0x35()
Calling initcall 0xc06b0148: init+0x0/0x90()
mmiotrace: load...
initcall 0xc06b0148: init+0x0/0x90() returned 0.
initcall 0xc06b0148 ran for 1 msecs: init+0x0/0x90()
Calling initcall 0xc06b061d: init_sched_debug_procfs+0x0/0x2a()
initcall 0xc06b061d: init_sched_debug_procfs+0x0/0x2a() returned 0.
initcall 0xc06b061d ran for 0 msecs: init_sched_debug_procfs+0x0/0x2a()
Calling initcall 0xc06b0fb6: create_proc_profile+0x0/0x17b()
initcall 0xc06b0fb6: create_proc_profile+0x0/0x17b() returned 0.
initcall 0xc06b0fb6 ran for 0 msecs: create_proc_profile+0x0/0x17b()
Calling initcall 0xc06b122c: ioresources_init+0x0/0x39()
initcall 0xc06b122c: ioresources_init+0x0/0x39() returned 0.
initcall 0xc06b122c ran for 0 msecs: ioresources_init+0x0/0x39()
Calling initcall 0xc06b13a0: uid_cache_init+0x0/0x5e()
initcall 0xc06b13a0: uid_cache_init+0x0/0x5e() returned 0.
initcall 0xc06b13a0 ran for 0 msecs: uid_cache_init+0x0/0x5e()
Calling initcall 0xc06b17e6: init_posix_timers+0x0/0x7c()
initcall 0xc06b17e6: init_posix_timers+0x0/0x7c() returned 0.
initcall 0xc06b17e6 ran for 0 msecs: init_posix_timers+0x0/0x7c()
Calling initcall 0xc06b1862: init_posix_cpu_timers+0x0/0x90()
initcall 0xc06b1862: init_posix_cpu_timers+0x0/0x90() returned 0.
initcall 0xc06b1862 ran for 0 msecs: init_posix_cpu_timers+0x0/0x90()
Calling initcall 0xc06b1970: nsproxy_cache_init+0x0/0x27()
initcall 0xc06b1970: nsproxy_cache_init+0x0/0x27() returned 0.
initcall 0xc06b1970 ran for 0 msecs: nsproxy_cache_init+0x0/0x27()
Calling initcall 0xc06b1a81: timekeeping_init_device+0x0/0x1d()
initcall 0xc06b1a81: timekeeping_init_device+0x0/0x1d() returned 0.
initcall 0xc06b1a81 ran for 0 msecs: timekeeping_init_device+0x0/0x1d()
Calling initcall 0xc06b1c0c: init_clocksource_sysfs+0x0/0x43()
initcall 0xc06b1c0c: init_clocksource_sysfs+0x0/0x43() returned 0.
initcall 0xc06b1c0c ran for 0 msecs: init_clocksource_sysfs+0x0/0x43()
Calling initcall 0xc06b1cd7: init_timer_list_procfs+0x0/0x2a()
initcall 0xc06b1cd7: init_timer_list_procfs+0x0/0x2a() returned 0.
initcall 0xc06b1cd7 ran for 0 msecs: init_timer_list_procfs+0x0/0x2a()
Calling initcall 0xc06b1d58: init_tstats_procfs+0x0/0x2a()
initcall 0xc06b1d58: init_tstats_procfs+0x0/0x2a() returned 0.
initcall 0xc06b1d58 ran for 0 msecs: init_tstats_procfs+0x0/0x2a()
Calling initcall 0xc06b1e61: lockdep_proc_init+0x0/0x3f()
initcall 0xc06b1e61: lockdep_proc_init+0x0/0x3f() returned 0.
initcall 0xc06b1e61 ran for 0 msecs: lockdep_proc_init+0x0/0x3f()
Calling initcall 0xc06b1ea0: init+0x0/0xb0()
initcall 0xc06b1ea0: init+0x0/0xb0() returned 0.
initcall 0xc06b1ea0 ran for 0 msecs: init+0x0/0xb0()
Calling initcall 0xc015a85c: init_rttest+0x0/0x102()
Initializing RT-Tester: OK
initcall 0xc015a85c: init_rttest+0x0/0x102() returned 0.
initcall 0xc015a85c ran for 3 msecs: init_rttest+0x0/0x102()
Calling initcall 0xc06b1f50: proc_dma_init+0x0/0x20()
initcall 0xc06b1f50: proc_dma_init+0x0/0x20() returned 0.
initcall 0xc06b1f50 ran for 0 msecs: proc_dma_init+0x0/0x20()
Calling initcall 0xc015b9b1: percpu_modinit+0x0/0x64()
initcall 0xc015b9b1: percpu_modinit+0x0/0x64() returned 0.
initcall 0xc015b9b1 ran for 0 msecs: percpu_modinit+0x0/0x64()
Calling initcall 0xc06b1fa7: kallsyms_init+0x0/0x23()
initcall 0xc06b1fa7: kallsyms_init+0x0/0x23() returned 0.
initcall 0xc06b1fa7 ran for 0 msecs: kallsyms_init+0x0/0x23()
Calling initcall 0xc06b202d: crash_save_vmcoreinfo_init+0x0/0x2e0()
initcall 0xc06b202d: crash_save_vmcoreinfo_init+0x0/0x2e0() returned 0.
initcall 0xc06b202d ran for 0 msecs: crash_save_vmcoreinfo_init+0x0/0x2e0()
Calling initcall 0xc06b1ff7: crash_notes_memory_init+0x0/0x36()
initcall 0xc06b1ff7: crash_notes_memory_init+0x0/0x36() returned 0.
initcall 0xc06b1ff7 ran for 0 msecs: crash_notes_memory_init+0x0/0x36()
Calling initcall 0xc06b25a9: audit_init+0x0/0x10d()
audit: initializing netlink socket (disabled)
type=2000 audit(1206112927.154:1): initialized
initcall 0xc06b25a9: audit_init+0x0/0x10d() returned 0.
initcall 0xc06b25a9 ran for 7 msecs: audit_init+0x0/0x10d()
Calling initcall 0xc06b272b: audit_tree_init+0x0/0x3b()
initcall 0xc06b272b: audit_tree_init+0x0/0x3b() returned 0.
initcall 0xc06b272b ran for 0 msecs: audit_tree_init+0x0/0x3b()
Calling initcall 0xc06b2766: init_kprobes+0x0/0x7d()
initcall 0xc06b2766: init_kprobes+0x0/0x7d() returned 0.
initcall 0xc06b2766 ran for 0 msecs: init_kprobes+0x0/0x7d()
Calling initcall 0xc06b2a05: relay_init+0x0/0x11()
initcall 0xc06b2a05: relay_init+0x0/0x11() returned 0.
initcall 0xc06b2a05 ran for 0 msecs: relay_init+0x0/0x11()
Calling initcall 0xc06b2a16: utsname_sysctl_init+0x0/0x11()
initcall 0xc06b2a16: utsname_sysctl_init+0x0/0x11() returned 0.
initcall 0xc06b2a16 ran for 0 msecs: utsname_sysctl_init+0x0/0x11()
Calling initcall 0xc06b3757: init_per_zone_pages_min+0x0/0x3c()
initcall 0xc06b3757: init_per_zone_pages_min+0x0/0x3c() returned 0.
initcall 0xc06b3757 ran for 0 msecs: init_per_zone_pages_min+0x0/0x3c()
Calling initcall 0xc06b41a2: pdflush_init+0x0/0x16()
initcall 0xc06b41a2: pdflush_init+0x0/0x16() returned 0.
initcall 0xc06b41a2 ran for 0 msecs: pdflush_init+0x0/0x16()
Calling initcall 0xc06b41f8: kswapd_init+0x0/0x1d()
initcall 0xc06b41f8: kswapd_init+0x0/0x1d() returned 0.
initcall 0xc06b41f8 ran for 0 msecs: kswapd_init+0x0/0x1d()
Calling initcall 0xc06b4215: setup_vmstat+0x0/0x3e()
initcall 0xc06b4215: setup_vmstat+0x0/0x3e() returned 0.
initcall 0xc06b4215 ran for 0 msecs: setup_vmstat+0x0/0x3e()
Calling initcall 0xc06b4319: init_emergency_pool+0x0/0x57()
highmem bounce pool size: 64 pages
initcall 0xc06b4319: init_emergency_pool+0x0/0x57() returned 0.
initcall 0xc06b4319 ran for 2 msecs: init_emergency_pool+0x0/0x57()
Calling initcall 0xc06b4370: procswaps_init+0x0/0x20()
initcall 0xc06b4370: procswaps_init+0x0/0x20() returned 0.
initcall 0xc06b4370 ran for 0 msecs: procswaps_init+0x0/0x20()
Calling initcall 0xc06b4390: hugetlb_init+0x0/0x72()
Total HugeTLB memory allocated, 0
initcall 0xc06b4390: hugetlb_init+0x0/0x72() returned 0.
initcall 0xc06b4390 ran for 2 msecs: hugetlb_init+0x0/0x72()
Calling initcall 0xc06b4430: init_tmpfs+0x0/0xb9()
initcall 0xc06b4430: init_tmpfs+0x0/0xb9() returned 0.
initcall 0xc06b4430 ran for 0 msecs: init_tmpfs+0x0/0xb9()
Calling initcall 0xc06b452e: cpucache_init+0x0/0x2f()
initcall 0xc06b452e: cpucache_init+0x0/0x2f() returned 0.
initcall 0xc06b452e ran for 0 msecs: cpucache_init+0x0/0x2f()
Calling initcall 0xc06b4a40: fasync_init+0x0/0x24()
initcall 0xc06b4a40: fasync_init+0x0/0x24() returned 0.
initcall 0xc06b4a40 ran for 0 msecs: fasync_init+0x0/0x24()
Calling initcall 0xc06b4f31: aio_setup+0x0/0x64()
initcall 0xc06b4f31: aio_setup+0x0/0x64() returned 0.
initcall 0xc06b4f31 ran for 0 msecs: aio_setup+0x0/0x64()
Calling initcall 0xc06b50ed: inotify_setup+0x0/0x11()
initcall 0xc06b50ed: inotify_setup+0x0/0x11() returned 0.
initcall 0xc06b50ed ran for 0 msecs: inotify_setup+0x0/0x11()
Calling initcall 0xc06b50fe: inotify_user_setup+0x0/0x98()
initcall 0xc06b50fe: inotify_user_setup+0x0/0x98() returned 0.
initcall 0xc06b50fe ran for 0 msecs: inotify_user_setup+0x0/0x98()
Calling initcall 0xc06b5343: init_mbcache+0x0/0x11()
initcall 0xc06b5343: init_mbcache+0x0/0x11() returned 0.
initcall 0xc06b5343 ran for 0 msecs: init_mbcache+0x0/0x11()
Calling initcall 0xc06b5354: dquot_init+0x0/0xc1()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall 0xc06b5354: dquot_init+0x0/0xc1() returned 0.
initcall 0xc06b5354 ran for 7 msecs: dquot_init+0x0/0xc1()
Calling initcall 0xc06b5415: init_v2_quota_format+0x0/0xf()
initcall 0xc06b5415: init_v2_quota_format+0x0/0xf() returned 0.
initcall 0xc06b5415 ran for 0 msecs: init_v2_quota_format+0x0/0xf()
Calling initcall 0xc06b5424: dnotify_init+0x0/0x24()
initcall 0xc06b5424: dnotify_init+0x0/0x24() returned 0.
initcall 0xc06b5424 ran for 0 msecs: dnotify_init+0x0/0x24()
Calling initcall 0xc06b58c4: init_devpts_fs+0x0/0x32()
initcall 0xc06b58c4: init_devpts_fs+0x0/0x32() returned 0.
initcall 0xc06b58c4 ran for 0 msecs: init_devpts_fs+0x0/0x32()
Calling initcall 0xc06b58f6: init_ext3_fs+0x0/0x5f()
initcall 0xc06b58f6: init_ext3_fs+0x0/0x5f() returned 0.
initcall 0xc06b58f6 ran for 0 msecs: init_ext3_fs+0x0/0x5f()
Calling initcall 0xc06b59eb: journal_init+0x0/0x85()
initcall 0xc06b59eb: journal_init+0x0/0x85() returned 0.
initcall 0xc06b59eb ran for 0 msecs: journal_init+0x0/0x85()
Calling initcall 0xc06b5a70: init_ext2_fs+0x0/0x5f()
initcall 0xc06b5a70: init_ext2_fs+0x0/0x5f() returned 0.
initcall 0xc06b5a70 ran for 0 msecs: init_ext2_fs+0x0/0x5f()
Calling initcall 0xc06b5af8: init_ramfs_fs+0x0/0xf()
initcall 0xc06b5af8: init_ramfs_fs+0x0/0xf() returned 0.
initcall 0xc06b5af8 ran for 0 msecs: init_ramfs_fs+0x0/0xf()
Calling initcall 0xc06b5b3a: init_hugetlbfs_fs+0x0/0x84()
initcall 0xc06b5b3a: init_hugetlbfs_fs+0x0/0x84() returned 0.
initcall 0xc06b5b3a ran for 0 msecs: init_hugetlbfs_fs+0x0/0x84()
Calling initcall 0xc06b5bbe: init_iso9660_fs+0x0/0x61()
initcall 0xc06b5bbe: init_iso9660_fs+0x0/0x61() returned 0.
initcall 0xc06b5bbe ran for 0 msecs: init_iso9660_fs+0x0/0x61()
Calling initcall 0xc06b5c3b: init_nls_cp437+0x0/0xf()
initcall 0xc06b5c3b: init_nls_cp437+0x0/0xf() returned 0.
initcall 0xc06b5c3b ran for 0 msecs: init_nls_cp437+0x0/0xf()
Calling initcall 0xc06b5c4a: init_nls_ascii+0x0/0xf()
initcall 0xc06b5c4a: init_nls_ascii+0x0/0xf() returned 0.
initcall 0xc06b5c4a ran for 0 msecs: init_nls_ascii+0x0/0xf()
Calling initcall 0xc06b5c9a: ipc_init+0x0/0x16()
initcall 0xc06b5c9a: ipc_init+0x0/0x16() returned 0.
initcall 0xc06b5c9a ran for 0 msecs: ipc_init+0x0/0x16()
Calling initcall 0xc06b5d8a: ipc_sysctl_init+0x0/0x11()
initcall 0xc06b5d8a: ipc_sysctl_init+0x0/0x11() returned 0.
initcall 0xc06b5d8a ran for 0 msecs: ipc_sysctl_init+0x0/0x11()
Calling initcall 0xc06b5d9b: init_mqueue_fs+0x0/0xb6()
initcall 0xc06b5d9b: init_mqueue_fs+0x0/0xb6() returned 0.
initcall 0xc06b5d9b ran for 0 msecs: init_mqueue_fs+0x0/0xb6()
Calling initcall 0xc06b5f74: key_proc_init+0x0/0x4a()
initcall 0xc06b5f74: key_proc_init+0x0/0x4a() returned 0.
initcall 0xc06b5f74 ran for 0 msecs: key_proc_init+0x0/0x4a()
Calling initcall 0xc06b60fb: selinux_nf_ip_init+0x0/0x68()
initcall 0xc06b60fb: selinux_nf_ip_init+0x0/0x68() returned 0.
initcall 0xc06b60fb ran for 0 msecs: selinux_nf_ip_init+0x0/0x68()
Calling initcall 0xc06b629b: init_sel_fs+0x0/0x5a()
initcall 0xc06b629b: init_sel_fs+0x0/0x5a() returned 0.
initcall 0xc06b629b ran for 0 msecs: init_sel_fs+0x0/0x5a()
Calling initcall 0xc06b62f5: selnl_init+0x0/0x46()
initcall 0xc06b62f5: selnl_init+0x0/0x46() returned 0.
initcall 0xc06b62f5 ran for 0 msecs: selnl_init+0x0/0x46()
Calling initcall 0xc06b633b: sel_netif_init+0x0/0x57()
initcall 0xc06b633b: sel_netif_init+0x0/0x57() returned 0.
initcall 0xc06b633b ran for 0 msecs: sel_netif_init+0x0/0x57()
Calling initcall 0xc06b6392: sel_netnode_init+0x0/0x4d()
initcall 0xc06b6392: sel_netnode_init+0x0/0x4d() returned 0.
initcall 0xc06b6392 ran for 0 msecs: sel_netnode_init+0x0/0x4d()
Calling initcall 0xc06b63df: aurule_init+0x0/0x30()
initcall 0xc06b63df: aurule_init+0x0/0x30() returned 0.
initcall 0xc06b63df ran for 0 msecs: aurule_init+0x0/0x30()
Calling initcall 0xc06b648b: crypto_algapi_init+0x0/0xc()
initcall 0xc06b648b: crypto_algapi_init+0x0/0xc() returned 0.
initcall 0xc06b648b ran for 0 msecs: crypto_algapi_init+0x0/0xc()
Calling initcall 0xc06b64b5: blkcipher_module_init+0x0/0x24()
initcall 0xc06b64b5: blkcipher_module_init+0x0/0x24() returned 0.
initcall 0xc06b64b5 ran for 0 msecs: blkcipher_module_init+0x0/0x24()
Calling initcall 0xc06b64f7: cryptomgr_init+0x0/0xf()
initcall 0xc06b64f7: cryptomgr_init+0x0/0xf() returned 0.
initcall 0xc06b64f7 ran for 0 msecs: cryptomgr_init+0x0/0xf()
Calling initcall 0xc06b6506: hmac_module_init+0x0/0xf()
initcall 0xc06b6506: hmac_module_init+0x0/0xf() returned 0.
initcall 0xc06b6506 ran for 0 msecs: hmac_module_init+0x0/0xf()
Calling initcall 0xc06b6515: crypto_xcbc_module_init+0x0/0xf()
initcall 0xc06b6515: crypto_xcbc_module_init+0x0/0xf() returned 0.
initcall 0xc06b6515 ran for 0 msecs: crypto_xcbc_module_init+0x0/0xf()
Calling initcall 0xc06b6524: init+0x0/0x67()
initcall 0xc06b6524: init+0x0/0x67() returned 0.
initcall 0xc06b6524 ran for 0 msecs: init+0x0/0x67()
Calling initcall 0xc06b658b: init+0x0/0xf()
initcall 0xc06b658b: init+0x0/0xf() returned 0.
initcall 0xc06b658b ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b659a: init+0x0/0xf()
initcall 0xc06b659a: init+0x0/0xf() returned 0.
initcall 0xc06b659a ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b65a9: init+0x0/0xf()
initcall 0xc06b65a9: init+0x0/0xf() returned 0.
initcall 0xc06b65a9 ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b65b8: init+0x0/0x33()
initcall 0xc06b65b8: init+0x0/0x33() returned 0.
initcall 0xc06b65b8 ran for 0 msecs: init+0x0/0x33()
Calling initcall 0xc06b65eb: init+0x0/0x33()
initcall 0xc06b65eb: init+0x0/0x33() returned 0.
initcall 0xc06b65eb ran for 0 msecs: init+0x0/0x33()
Calling initcall 0xc06b661e: init+0x0/0x52()
initcall 0xc06b661e: init+0x0/0x52() returned 0.
initcall 0xc06b661e ran for 0 msecs: init+0x0/0x52()
Calling initcall 0xc06b6670: init+0x0/0x52()
initcall 0xc06b6670: init+0x0/0x52() returned 0.
initcall 0xc06b6670 ran for 0 msecs: init+0x0/0x52()
Calling initcall 0xc06b66c2: crypto_ecb_module_init+0x0/0xf()
initcall 0xc06b66c2: crypto_ecb_module_init+0x0/0xf() returned 0.
initcall 0xc06b66c2 ran for 0 msecs: crypto_ecb_module_init+0x0/0xf()
Calling initcall 0xc06b66d1: crypto_cbc_module_init+0x0/0xf()
initcall 0xc06b66d1: crypto_cbc_module_init+0x0/0xf() returned 0.
initcall 0xc06b66d1 ran for 0 msecs: crypto_cbc_module_init+0x0/0xf()
Calling initcall 0xc06b66e0: crypto_module_init+0x0/0xf()
initcall 0xc06b66e0: crypto_module_init+0x0/0xf() returned 0.
initcall 0xc06b66e0 ran for 0 msecs: crypto_module_init+0x0/0xf()
Calling initcall 0xc06b66ef: init+0x0/0x33()
initcall 0xc06b66ef: init+0x0/0x33() returned 0.
initcall 0xc06b66ef ran for 0 msecs: init+0x0/0x33()
Calling initcall 0xc06b6722: init+0x0/0xf()
initcall 0xc06b6722: init+0x0/0xf() returned 0.
initcall 0xc06b6722 ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6731: init+0x0/0xf()
initcall 0xc06b6731: init+0x0/0xf() returned 0.
initcall 0xc06b6731 ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6740: init+0x0/0x33()
initcall 0xc06b6740: init+0x0/0x33() returned 0.
initcall 0xc06b6740 ran for 0 msecs: init+0x0/0x33()
Calling initcall 0xc06b6773: aes_init+0x0/0x2ac()
initcall 0xc06b6773: aes_init+0x0/0x2ac() returned 0.
initcall 0xc06b6773 ran for 0 msecs: aes_init+0x0/0x2ac()
Calling initcall 0xc06b6a1f: init+0x0/0xf()
initcall 0xc06b6a1f: init+0x0/0xf() returned 0.
initcall 0xc06b6a1f ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6a2e: init+0x0/0xf()
initcall 0xc06b6a2e: init+0x0/0xf() returned 0.
initcall 0xc06b6a2e ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6a3d: arc4_init+0x0/0xf()
initcall 0xc06b6a3d: arc4_init+0x0/0xf() returned 0.
initcall 0xc06b6a3d ran for 0 msecs: arc4_init+0x0/0xf()
Calling initcall 0xc06b6a4c: init+0x0/0x52()
initcall 0xc06b6a4c: init+0x0/0x52() returned 0.
initcall 0xc06b6a4c ran for 0 msecs: init+0x0/0x52()
Calling initcall 0xc06b6a9e: init+0x0/0xf()
initcall 0xc06b6a9e: init+0x0/0xf() returned 0.
initcall 0xc06b6a9e ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6aad: init+0x0/0xf()
initcall 0xc06b6aad: init+0x0/0xf() returned 0.
initcall 0xc06b6aad ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6abc: init+0x0/0xf()
initcall 0xc06b6abc: init+0x0/0xf() returned 0.
initcall 0xc06b6abc ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6acb: michael_mic_init+0x0/0xf()
initcall 0xc06b6acb: michael_mic_init+0x0/0xf() returned 0.
initcall 0xc06b6acb ran for 0 msecs: michael_mic_init+0x0/0xf()
Calling initcall 0xc06b6ada: init+0x0/0xf()
initcall 0xc06b6ada: init+0x0/0xf() returned 0.
initcall 0xc06b6ada ran for 0 msecs: init+0x0/0xf()
Calling initcall 0xc06b6dc8: noop_init+0x0/0x11()
io scheduler noop registered
initcall 0xc06b6dc8: noop_init+0x0/0x11() returned 0.
initcall 0xc06b6dc8 ran for 2 msecs: noop_init+0x0/0x11()
Calling initcall 0xc06b6dd9: as_init+0x0/0x11()
io scheduler anticipatory registered
initcall 0xc06b6dd9: as_init+0x0/0x11() returned 0.
initcall 0xc06b6dd9 ran for 3 msecs: as_init+0x0/0x11()
Calling initcall 0xc06b6dea: deadline_init+0x0/0x11()
io scheduler deadline registered
initcall 0xc06b6dea: deadline_init+0x0/0x11() returned 0.
initcall 0xc06b6dea ran for 2 msecs: deadline_init+0x0/0x11()
Calling initcall 0xc06b6dfb: cfq_init+0x0/0x94()
io scheduler cfq registered (default)
initcall 0xc06b6dfb: cfq_init+0x0/0x94() returned 0.
initcall 0xc06b6dfb ran for 3 msecs: cfq_init+0x0/0x94()
Calling initcall 0xc06b700d: percpu_counter_startup+0x0/0x11()
initcall 0xc06b700d: percpu_counter_startup+0x0/0x11() returned 0.
initcall 0xc06b700d ran for 0 msecs: percpu_counter_startup+0x0/0x11()
Calling initcall 0xc06b701e: audit_classes_init+0x0/0x4f()
initcall 0xc06b701e: audit_classes_init+0x0/0x4f() returned 0.
initcall 0xc06b701e ran for 0 msecs: audit_classes_init+0x0/0x4f()
Calling initcall 0xc0472220: pci_init+0x0/0x2c()
pci 0000:00:0b.0: Linking AER extended capability
pci 0000:00:0c.0: Linking AER extended capability
pci 0000:00:0d.0: Linking AER extended capability
pci 0000:00:0e.0: Linking AER extended capability
pci 0000:01:00.0: Boot video device
initcall 0xc0472220: pci_init+0x0/0x2c() returned 0.
initcall 0xc0472220 ran for 31 msecs: pci_init+0x0/0x2c()
Calling initcall 0xc06b7685: pci_proc_init+0x0/0x5f()
initcall 0xc06b7685: pci_proc_init+0x0/0x5f() returned 0.
initcall 0xc06b7685 ran for 0 msecs: pci_proc_init+0x0/0x5f()
Calling initcall 0xc06b76e4: pcie_portdrv_init+0x0/0x41()
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
initcall 0xc06b76e4: pcie_portdrv_init+0x0/0x41() returned 0.
initcall 0xc06b76e4 ran for 62 msecs: pcie_portdrv_init+0x0/0x41()
Calling initcall 0xc06b7725: aer_service_init+0x0/0x1d()
initcall 0xc06b7725: aer_service_init+0x0/0x1d() returned 0.
initcall 0xc06b7725 ran for 0 msecs: aer_service_init+0x0/0x1d()
Calling initcall 0xc06b7742: pci_hotplug_init+0x0/0x50()
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall 0xc06b7742: pci_hotplug_init+0x0/0x50() returned 0.
initcall 0xc06b7742 ran for 4 msecs: pci_hotplug_init+0x0/0x50()
Calling initcall 0xc06b7dae: acpi_reserve_resources+0x0/0xc8()
initcall 0xc06b7dae: acpi_reserve_resources+0x0/0xc8() returned 0.
initcall 0xc06b7dae ran for 0 msecs: acpi_reserve_resources+0x0/0xc8()
Calling initcall 0xc06b8bf2: acpi_fan_init+0x0/0x51()
ACPI: PNP0C0B:00 is registered as cooling_device0
ACPI: Fan [FAN] (on)
initcall 0xc06b8bf2: acpi_fan_init+0x0/0x51() returned 0.
initcall 0xc06b8bf2 ran for 6 msecs: acpi_fan_init+0x0/0x51()
Calling initcall 0xc06b8d58: irqrouter_init_sysfs+0x0/0x33()
initcall 0xc06b8d58: irqrouter_init_sysfs+0x0/0x33() returned 0.
initcall 0xc06b8d58 ran for 0 msecs: irqrouter_init_sysfs+0x0/0x33()
Calling initcall 0xc06b8eb6: acpi_processor_init+0x0/0xd4()
ACPI: ACPI0007:00 is registered as cooling_device1
ACPI: ACPI0007:01 is registered as cooling_device2
initcall 0xc06b8eb6: acpi_processor_init+0x0/0xd4() returned 0.
initcall 0xc06b8eb6 ran for 8 msecs: acpi_processor_init+0x0/0xd4()
Calling initcall 0xc06b8f8a: acpi_container_init+0x0/0x3d()
initcall 0xc06b8f8a: acpi_container_init+0x0/0x3d() returned 0.
initcall 0xc06b8f8a ran for 4 msecs: acpi_container_init+0x0/0x3d()
Calling initcall 0xc06b8fc7: acpi_thermal_init+0x0/0x76()
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
initcall 0xc06b8fc7: acpi_thermal_init+0x0/0x76() returned 0.
initcall 0xc06b8fc7 ran for 7 msecs: acpi_thermal_init+0x0/0x76()
Calling initcall 0xc06ba736: isapnp_init+0x0/0x3f7()
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
initcall 0xc06ba736: isapnp_init+0x0/0x3f7() returned 0.
initcall 0xc06ba736 ran for 344 msecs: isapnp_init+0x0/0x3f7()
Calling initcall 0xc06bacd6: rand_initialize+0x0/0x25()
initcall 0xc06bacd6: rand_initialize+0x0/0x25() returned 0.
initcall 0xc06bacd6 ran for 0 msecs: rand_initialize+0x0/0x25()
Calling initcall 0xc06bad2c: tty_init+0x0/0x18f()
initcall 0xc06bad2c: tty_init+0x0/0x18f() returned 0.
initcall 0xc06bad2c ran for 5 msecs: tty_init+0x0/0x18f()
Calling initcall 0xc06baee2: pty_init+0x0/0x1ff()
initcall 0xc06baee2: pty_init+0x0/0x1ff() returned 0.
initcall 0xc06baee2 ran for 0 msecs: pty_init+0x0/0x1ff()
Calling initcall 0xc06bb5fb: raw_init+0x0/0xb9()
initcall 0xc06bb5fb: raw_init+0x0/0xb9() returned 0.
initcall 0xc06bb5fb ran for 0 msecs: raw_init+0x0/0xb9()
Calling initcall 0xc06bb6ef: rtc_init+0x0/0x187()
Real Time Clock Driver v1.12ac
initcall 0xc06bb6ef: rtc_init+0x0/0x187() returned 0.
initcall 0xc06bb6ef ran for 2 msecs: rtc_init+0x0/0x187()
Calling initcall 0xc06bb876: hpet_init+0x0/0x59()
initcall 0xc06bb876: hpet_init+0x0/0x59() returned 0.
initcall 0xc06bb876 ran for 0 msecs: hpet_init+0x0/0x59()
Calling initcall 0xc06bb8cf: nvram_init+0x0/0x77()
Non-volatile memory driver v1.2
initcall 0xc06bb8cf: nvram_init+0x0/0x77() returned 0.
initcall 0xc06bb8cf ran for 2 msecs: nvram_init+0x0/0x77()
Calling initcall 0xc06bb990: agp_init+0x0/0x21()
Linux agpgart interface v0.103
initcall 0xc06bb990: agp_init+0x0/0x21() returned 0.
initcall 0xc06bb990 ran for 2 msecs: agp_init+0x0/0x21()
Calling initcall 0xc06bb9b1: agp_ali_init+0x0/0x24()
initcall 0xc06bb9b1: agp_ali_init+0x0/0x24() returned 0.
initcall 0xc06bb9b1 ran for 0 msecs: agp_ali_init+0x0/0x24()
Calling initcall 0xc06bb9d5: agp_ati_init+0x0/0x24()
initcall 0xc06bb9d5: agp_ati_init+0x0/0x24() returned 0.
initcall 0xc06bb9d5 ran for 0 msecs: agp_ati_init+0x0/0x24()
Calling initcall 0xc06bb9f9: agp_amdk7_init+0x0/0x24()
initcall 0xc06bb9f9: agp_amdk7_init+0x0/0x24() returned 0.
initcall 0xc06bb9f9 ran for 0 msecs: agp_amdk7_init+0x0/0x24()
Calling initcall 0xc06bba1d: agp_amd64_init+0x0/0xb1()
initcall 0xc06bba1d: agp_amd64_init+0x0/0xb1() returned 0.
initcall 0xc06bba1d ran for 0 msecs: agp_amd64_init+0x0/0xb1()
Calling initcall 0xc06bbace: agp_efficeon_init+0x0/0x39()
initcall 0xc06bbace: agp_efficeon_init+0x0/0x39() returned 0.
initcall 0xc06bbace ran for 0 msecs: agp_efficeon_init+0x0/0x39()
Calling initcall 0xc06bbb07: agp_intel_init+0x0/0x24()
initcall 0xc06bbb07: agp_intel_init+0x0/0x24() returned 0.
initcall 0xc06bbb07 ran for 0 msecs: agp_intel_init+0x0/0x24()
Calling initcall 0xc06bbb2b: agp_nvidia_init+0x0/0x24()
initcall 0xc06bbb2b: agp_nvidia_init+0x0/0x24() returned 0.
initcall 0xc06bbb2b ran for 0 msecs: agp_nvidia_init+0x0/0x24()
Calling initcall 0xc06bbb4f: agp_sis_init+0x0/0x24()
initcall 0xc06bbb4f: agp_sis_init+0x0/0x24() returned 0.
initcall 0xc06bbb4f ran for 0 msecs: agp_sis_init+0x0/0x24()
Calling initcall 0xc06bbb73: agp_serverworks_init+0x0/0x24()
initcall 0xc06bbb73: agp_serverworks_init+0x0/0x24() returned 0.
initcall 0xc06bbb73 ran for 0 msecs: agp_serverworks_init+0x0/0x24()
Calling initcall 0xc06bbb97: agp_via_init+0x0/0x24()
initcall 0xc06bbb97: agp_via_init+0x0/0x24() returned 0.
initcall 0xc06bbb97 ran for 0 msecs: agp_via_init+0x0/0x24()
Calling initcall 0xc06bbbbb: drm_core_init+0x0/0x110()
[drm] Initialized drm 1.1.0 20060810
initcall 0xc06bbbbb: drm_core_init+0x0/0x110() returned 0.
initcall 0xc06bbbbb ran for 3 msecs: drm_core_init+0x0/0x110()
Calling initcall 0xc06bbccb: i810_init+0x0/0x19()
initcall 0xc06bbccb: i810_init+0x0/0x19() returned 0.
initcall 0xc06bbccb ran for 0 msecs: i810_init+0x0/0x19()
Calling initcall 0xc06bbce4: i915_init+0x0/0x19()
initcall 0xc06bbce4: i915_init+0x0/0x19() returned 0.
initcall 0xc06bbce4 ran for 0 msecs: i915_init+0x0/0x19()
Calling initcall 0xc06bbcfd: cn_proc_init+0x0/0x30()
initcall 0xc06bbcfd: cn_proc_init+0x0/0x30() returned 0.
initcall 0xc06bbcfd ran for 0 msecs: cn_proc_init+0x0/0x30()
Calling initcall 0xc06bbf9e: serial8250_init+0x0/0x10f()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall 0xc06bbf9e: serial8250_init+0x0/0x10f() returned 0.
initcall 0xc06bbf9e ran for 243 msecs: serial8250_init+0x0/0x10f()
Calling initcall 0xc06bc0ad: serial8250_pnp_init+0x0/0xf()
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall 0xc06bc0ad: serial8250_pnp_init+0x0/0xf() returned 0.
initcall 0xc06bc0ad ran for 4 msecs: serial8250_pnp_init+0x0/0xf()
Calling initcall 0xc06bc0bc: serial8250_pci_init+0x0/0x16()
initcall 0xc06bc0bc: serial8250_pci_init+0x0/0x16() returned 0.
initcall 0xc06bc0bc ran for 0 msecs: serial8250_pci_init+0x0/0x16()
Calling initcall 0xc06bc611: isa_bus_init+0x0/0x33()
initcall 0xc06bc611: isa_bus_init+0x0/0x33() returned 0.
initcall 0xc06bc611 ran for 0 msecs: isa_bus_init+0x0/0x33()
Calling initcall 0xc048f170: topology_sysfs_init+0x0/0x3d()
initcall 0xc048f170: topology_sysfs_init+0x0/0x3d() returned 0.
initcall 0xc048f170 ran for 0 msecs: topology_sysfs_init+0x0/0x3d()
Calling initcall 0xc06bc6c2: brd_init+0x0/0x106()
brd: module loaded
initcall 0xc06bc6c2: brd_init+0x0/0x106() returned 0.
initcall 0xc06bc6c2 ran for 3 msecs: brd_init+0x0/0x106()
Calling initcall 0xc06bc7c8: loop_init+0x0/0x125()
loop: module loaded
initcall 0xc06bc7c8: loop_init+0x0/0x125() returned 0.
initcall 0xc06bc7c8 ran for 2 msecs: loop_init+0x0/0x125()
Calling initcall 0xc06bcda4: cpqarray_init+0x0/0x22c()
Compaq SMART2 Driver (v 2.6.0)
initcall 0xc06bcda4: cpqarray_init+0x0/0x22c() returned 0.
initcall 0xc06bcda4 ran for 2 msecs: cpqarray_init+0x0/0x22c()
Calling initcall 0xc06bd29a: e1000_init_module+0x0/0x6e()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
initcall 0xc06bd29a: e1000_init_module+0x0/0x6e() returned 0.
initcall 0xc06bd29a ran for 8 msecs: e1000_init_module+0x0/0x6e()
Calling initcall 0xc06bd308: e100_init_module+0x0/0x4d()
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall 0xc06bd308: e100_init_module+0x0/0x4d() returned 0.
initcall 0xc06bd308 ran for 8 msecs: e100_init_module+0x0/0x4d()
Calling initcall 0xc06bd355: tg3_init+0x0/0x16()
initcall 0xc06bd355: tg3_init+0x0/0x16() returned 0.
initcall 0xc06bd355 ran for 0 msecs: tg3_init+0x0/0x16()
Calling initcall 0xc06bd36b: skge_init_module+0x0/0x16()
initcall 0xc06bd36b: skge_init_module+0x0/0x16() returned 0.
initcall 0xc06bd36b ran for 0 msecs: skge_init_module+0x0/0x16()
Calling initcall 0xc06bd3c4: net_olddevs_init+0x0/0x81()
initcall 0xc06bd3c4: net_olddevs_init+0x0/0x81() returned 0.
initcall 0xc06bd3c4 ran for 0 msecs: net_olddevs_init+0x0/0x81()
Calling initcall 0xc06bd4b7: init_nic+0x0/0x16()
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
initcall 0xc06bd4b7: init_nic+0x0/0x16() returned 0.
initcall 0xc06bd4b7 ran for 522 msecs: init_nic+0x0/0x16()
Calling initcall 0xc06bd4cd: cp_init+0x0/0x16()
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:05:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
8139cp 0000:05:07.0: Try the "8139too" driver instead.
initcall 0xc06bd4cd: cp_init+0x0/0x16() returned 0.
initcall 0xc06bd4cd ran for 16 msecs: cp_init+0x0/0x16()
Calling initcall 0xc06bd4e3: rtl8139_init_module+0x0/0x16()
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 17
eth1:  Identified 8139 chip type 'RTL-8139B'
initcall 0xc06bd4e3: rtl8139_init_module+0x0/0x16() returned 0.
initcall 0xc06bd4e3 ran for 23 msecs: rtl8139_init_module+0x0/0x16()
Calling initcall 0xc06bd514: init_netconsole+0x0/0x15f()
console [netcon0] enabled
netconsole: network logging started
initcall 0xc06bd514: init_netconsole+0x0/0x15f() returned 0.
initcall 0xc06bd514 ran for 5898 msecs: init_netconsole+0x0/0x15f()
Calling initcall 0xc06bd908: spi_transport_init+0x0/0x27()
initcall 0xc06bd908: spi_transport_init+0x0/0x27() returned 0.
initcall 0xc06bd908 ran for 0 msecs: spi_transport_init+0x0/0x27()
Calling initcall 0xc06bd92f: sas_transport_init+0x0/0x9f()
initcall 0xc06bd92f: sas_transport_init+0x0/0x9f() returned 0.
initcall 0xc06bd92f ran for 0 msecs: sas_transport_init+0x0/0x9f()
Calling initcall 0xc06bd9ce: sas_class_init+0x0/0x2c()
initcall 0xc06bd9ce: sas_class_init+0x0/0x2c() returned 0.
initcall 0xc06bd9ce ran for 0 msecs: sas_class_init+0x0/0x2c()
Calling initcall 0xc06bd9fa: ahc_linux_init+0x0/0x5c()
initcall 0xc06bd9fa: ahc_linux_init+0x0/0x5c() returned 0.
initcall 0xc06bd9fa ran for 0 msecs: ahc_linux_init+0x0/0x5c()
Calling initcall 0xc06bda56: ahd_linux_init+0x0/0x6e()
initcall 0xc06bda56: ahd_linux_init+0x0/0x6e() returned 0.
initcall 0xc06bda56 ran for 0 msecs: ahd_linux_init+0x0/0x6e()
Calling initcall 0xc06bdac4: aic94xx_init+0x0/0x117()
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
initcall 0xc06bdac4: aic94xx_init+0x0/0x117() returned 0.
initcall 0xc06bdac4 ran for 5 msecs: aic94xx_init+0x0/0x117()
Calling initcall 0xc06bdbdb: init_sd+0x0/0xcf()
Driver 'sd' needs updating - please use bus_type methods
initcall 0xc06bdbdb: init_sd+0x0/0xcf() returned 0.
initcall 0xc06bdbdb ran for 4 msecs: init_sd+0x0/0xcf()
Calling initcall 0xc06bdcaa: init_sr+0x0/0x3d()
Driver 'sr' needs updating - please use bus_type methods
initcall 0xc06bdcaa: init_sr+0x0/0x3d() returned 0.
initcall 0xc06bdcaa ran for 4 msecs: init_sr+0x0/0x3d()
Calling initcall 0xc06bdce7: init_sg+0x0/0x13f()
initcall 0xc06bdce7: init_sg+0x0/0x13f() returned 0.
initcall 0xc06bdce7 ran for 0 msecs: init_sg+0x0/0x13f()
Calling initcall 0xc06bde26: init_ch_module+0x0/0x87()
SCSI Media Changer driver v0.25 
Driver 'ch' needs updating - please use bus_type methods
initcall 0xc06bde26: init_ch_module+0x0/0x87() returned 0.
initcall 0xc06bde26 ran for 7 msecs: init_ch_module+0x0/0x87()
Calling initcall 0xc06be160: ahci_init+0x0/0x16()
initcall 0xc06be160: ahci_init+0x0/0x16() returned 0.
initcall 0xc06be160 ran for 0 msecs: ahci_init+0x0/0x16()
Calling initcall 0xc06be176: k2_sata_init+0x0/0x16()
initcall 0xc06be176: k2_sata_init+0x0/0x16() returned 0.
initcall 0xc06be176 ran for 0 msecs: k2_sata_init+0x0/0x16()
Calling initcall 0xc06be18c: piix_init+0x0/0x27()
initcall 0xc06be18c: piix_init+0x0/0x27() returned 0.
initcall 0xc06be18c ran for 0 msecs: piix_init+0x0/0x27()
Calling initcall 0xc06be1b3: pdc_ata_init+0x0/0x16()
initcall 0xc06be1b3: pdc_ata_init+0x0/0x16() returned 0.
initcall 0xc06be1b3 ran for 0 msecs: pdc_ata_init+0x0/0x16()
Calling initcall 0xc06be1c9: qs_ata_init+0x0/0x16()
initcall 0xc06be1c9: qs_ata_init+0x0/0x16() returned 0.
initcall 0xc06be1c9 ran for 0 msecs: qs_ata_init+0x0/0x16()
Calling initcall 0xc06be1df: sil_init+0x0/0x16()
initcall 0xc06be1df: sil_init+0x0/0x16() returned 0.
initcall 0xc06be1df ran for 0 msecs: sil_init+0x0/0x16()
Calling initcall 0xc06be1f5: sil24_init+0x0/0x16()
initcall 0xc06be1f5: sil24_init+0x0/0x16() returned 0.
initcall 0xc06be1f5 ran for 0 msecs: sil24_init+0x0/0x16()
Calling initcall 0xc06be20b: svia_init+0x0/0x16()
initcall 0xc06be20b: svia_init+0x0/0x16() returned 0.
initcall 0xc06be20b ran for 0 msecs: svia_init+0x0/0x16()
Calling initcall 0xc06be221: vsc_sata_init+0x0/0x16()
initcall 0xc06be221: vsc_sata_init+0x0/0x16() returned 0.
initcall 0xc06be221 ran for 0 msecs: vsc_sata_init+0x0/0x16()
Calling initcall 0xc06be237: sis_init+0x0/0x16()
initcall 0xc06be237: sis_init+0x0/0x16() returned 0.
initcall 0xc06be237 ran for 0 msecs: sis_init+0x0/0x16()
Calling initcall 0xc06be24d: pdc_sata_init+0x0/0x16()
initcall 0xc06be24d: pdc_sata_init+0x0/0x16() returned 0.
initcall 0xc06be24d ran for 0 msecs: pdc_sata_init+0x0/0x16()
Calling initcall 0xc06be263: nv_init+0x0/0x16()
initcall 0xc06be263: nv_init+0x0/0x16() returned 0.
initcall 0xc06be263 ran for 0 msecs: nv_init+0x0/0x16()
Calling initcall 0xc06be279: uli_init+0x0/0x16()
initcall 0xc06be279: uli_init+0x0/0x16() returned 0.
initcall 0xc06be279 ran for 0 msecs: uli_init+0x0/0x16()
Calling initcall 0xc06be28f: mv_init+0x0/0x3a()
initcall 0xc06be28f: mv_init+0x0/0x3a() returned 0.
initcall 0xc06be28f ran for 0 msecs: mv_init+0x0/0x3a()
Calling initcall 0xc06be2c9: adma_ata_init+0x0/0x16()
initcall 0xc06be2c9: adma_ata_init+0x0/0x16() returned 0.
initcall 0xc06be2c9 ran for 0 msecs: adma_ata_init+0x0/0x16()
Calling initcall 0xc06be2df: ali_init+0x0/0x16()
initcall 0xc06be2df: ali_init+0x0/0x16() returned 0.
initcall 0xc06be2df ran for 0 msecs: ali_init+0x0/0x16()
Calling initcall 0xc06be2f5: amd_init+0x0/0x16()
pata_amd 0000:00:06.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
ata1.00: configured for UDMA/100
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x701f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x701f (600:60:0x1c)
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:1:0: Attached scsi CD-ROM sr0
sr 1:0:1:0: Attached scsi generic sg1 type 5
initcall 0xc06be2f5: amd_init+0x0/0x16() returned 0.
initcall 0xc06be2f5 ran for 845 msecs: amd_init+0x0/0x16()
Calling initcall 0xc06be30b: artop_init+0x0/0x16()
initcall 0xc06be30b: artop_init+0x0/0x16() returned 0.
initcall 0xc06be30b ran for 0 msecs: artop_init+0x0/0x16()
Calling initcall 0xc06be321: atiixp_init+0x0/0x16()
initcall 0xc06be321: atiixp_init+0x0/0x16() returned 0.
initcall 0xc06be321 ran for 0 msecs: atiixp_init+0x0/0x16()
Calling initcall 0xc06be337: cmd64x_init+0x0/0x16()
initcall 0xc06be337: cmd64x_init+0x0/0x16() returned 0.
initcall 0xc06be337 ran for 0 msecs: cmd64x_init+0x0/0x16()
Calling initcall 0xc06be34d: cs5520_init+0x0/0x16()
initcall 0xc06be34d: cs5520_init+0x0/0x16() returned 0.
initcall 0xc06be34d ran for 0 msecs: cs5520_init+0x0/0x16()
Calling initcall 0xc06be363: cs5530_init+0x0/0x16()
initcall 0xc06be363: cs5530_init+0x0/0x16() returned 0.
initcall 0xc06be363 ran for 0 msecs: cs5530_init+0x0/0x16()
Calling initcall 0xc06be379: cs5535_init+0x0/0x16()
initcall 0xc06be379: cs5535_init+0x0/0x16() returned 0.
initcall 0xc06be379 ran for 0 msecs: cs5535_init+0x0/0x16()
Calling initcall 0xc06be38f: cy82c693_init+0x0/0x16()
initcall 0xc06be38f: cy82c693_init+0x0/0x16() returned 0.
initcall 0xc06be38f ran for 0 msecs: cy82c693_init+0x0/0x16()
Calling initcall 0xc06be3a5: efar_init+0x0/0x16()
initcall 0xc06be3a5: efar_init+0x0/0x16() returned 0.
initcall 0xc06be3a5 ran for 0 msecs: efar_init+0x0/0x16()
Calling initcall 0xc06be3bb: hpt36x_init+0x0/0x16()
initcall 0xc06be3bb: hpt36x_init+0x0/0x16() returned 0.
initcall 0xc06be3bb ran for 0 msecs: hpt36x_init+0x0/0x16()
Calling initcall 0xc06be3d1: hpt37x_init+0x0/0x16()
initcall 0xc06be3d1: hpt37x_init+0x0/0x16() returned 0.
initcall 0xc06be3d1 ran for 0 msecs: hpt37x_init+0x0/0x16()
Calling initcall 0xc06be3e7: hpt3x2n_init+0x0/0x16()
initcall 0xc06be3e7: hpt3x2n_init+0x0/0x16() returned 0.
initcall 0xc06be3e7 ran for 0 msecs: hpt3x2n_init+0x0/0x16()
Calling initcall 0xc06be3fd: hpt3x3_init+0x0/0x16()
initcall 0xc06be3fd: hpt3x3_init+0x0/0x16() returned 0.
initcall 0xc06be3fd ran for 0 msecs: hpt3x3_init+0x0/0x16()
Calling initcall 0xc06be413: it821x_init+0x0/0x16()
initcall 0xc06be413: it821x_init+0x0/0x16() returned 0.
initcall 0xc06be413 ran for 0 msecs: it821x_init+0x0/0x16()
Calling initcall 0xc06be429: jmicron_init+0x0/0x16()
initcall 0xc06be429: jmicron_init+0x0/0x16() returned 0.
initcall 0xc06be429 ran for 0 msecs: jmicron_init+0x0/0x16()
Calling initcall 0xc06be43f: netcell_init+0x0/0x16()
initcall 0xc06be43f: netcell_init+0x0/0x16() returned 0.
initcall 0xc06be43f ran for 0 msecs: netcell_init+0x0/0x16()
Calling initcall 0xc06be455: ns87410_init+0x0/0x16()
initcall 0xc06be455: ns87410_init+0x0/0x16() returned 0.
initcall 0xc06be455 ran for 0 msecs: ns87410_init+0x0/0x16()
Calling initcall 0xc06be46b: opti_init+0x0/0x16()
initcall 0xc06be46b: opti_init+0x0/0x16() returned 0.
initcall 0xc06be46b ran for 0 msecs: opti_init+0x0/0x16()
Calling initcall 0xc06be481: optidma_init+0x0/0x16()
initcall 0xc06be481: optidma_init+0x0/0x16() returned 0.
initcall 0xc06be481 ran for 0 msecs: optidma_init+0x0/0x16()
Calling initcall 0xc06be497: marvell_init+0x0/0x16()
initcall 0xc06be497: marvell_init+0x0/0x16() returned 0.
initcall 0xc06be497 ran for 0 msecs: marvell_init+0x0/0x16()
Calling initcall 0xc06be4ad: mpiix_init+0x0/0x16()
initcall 0xc06be4ad: mpiix_init+0x0/0x16() returned 0.
initcall 0xc06be4ad ran for 0 msecs: mpiix_init+0x0/0x16()
Calling initcall 0xc06be4c3: oldpiix_init+0x0/0x16()
initcall 0xc06be4c3: oldpiix_init+0x0/0x16() returned 0.
initcall 0xc06be4c3 ran for 0 msecs: oldpiix_init+0x0/0x16()
Calling initcall 0xc06be4d9: pdc2027x_init+0x0/0x16()
initcall 0xc06be4d9: pdc2027x_init+0x0/0x16() returned 0.
initcall 0xc06be4d9 ran for 0 msecs: pdc2027x_init+0x0/0x16()
Calling initcall 0xc06be4ef: pdc202xx_init+0x0/0x16()
initcall 0xc06be4ef: pdc202xx_init+0x0/0x16() returned 0.
initcall 0xc06be4ef ran for 0 msecs: pdc202xx_init+0x0/0x16()
Calling initcall 0xc06be681: qdi_init+0x0/0x1ca()
initcall 0xc06be681: qdi_init+0x0/0x1ca() returned -19.
initcall 0xc06be681 ran for 0 msecs: qdi_init+0x0/0x1ca()
Calling initcall 0xc06be84b: radisys_init+0x0/0x16()
initcall 0xc06be84b: radisys_init+0x0/0x16() returned 0.
initcall 0xc06be84b ran for 0 msecs: radisys_init+0x0/0x16()
Calling initcall 0xc06be861: rz1000_init+0x0/0x16()
initcall 0xc06be861: rz1000_init+0x0/0x16() returned 0.
initcall 0xc06be861 ran for 0 msecs: rz1000_init+0x0/0x16()
Calling initcall 0xc06be877: sc1200_init+0x0/0x16()
initcall 0xc06be877: sc1200_init+0x0/0x16() returned 0.
initcall 0xc06be877 ran for 0 msecs: sc1200_init+0x0/0x16()
Calling initcall 0xc06be88d: serverworks_init+0x0/0x16()
initcall 0xc06be88d: serverworks_init+0x0/0x16() returned 0.
initcall 0xc06be88d ran for 0 msecs: serverworks_init+0x0/0x16()
Calling initcall 0xc06be8a3: sil680_init+0x0/0x16()
initcall 0xc06be8a3: sil680_init+0x0/0x16() returned 0.
initcall 0xc06be8a3 ran for 0 msecs: sil680_init+0x0/0x16()
Calling initcall 0xc06be8b9: via_init+0x0/0x16()
initcall 0xc06be8b9: via_init+0x0/0x16() returned 0.
initcall 0xc06be8b9 ran for 0 msecs: via_init+0x0/0x16()
Calling initcall 0xc06be8cf: sl82c105_init+0x0/0x16()
initcall 0xc06be8cf: sl82c105_init+0x0/0x16() returned 0.
initcall 0xc06be8cf ran for 0 msecs: sl82c105_init+0x0/0x16()
Calling initcall 0xc06be8e5: winbond_init+0x0/0x287()
initcall 0xc06be8e5: winbond_init+0x0/0x287() returned -19.
initcall 0xc06be8e5 ran for 0 msecs: winbond_init+0x0/0x287()
Calling initcall 0xc06beb6c: sis_init+0x0/0x16()
initcall 0xc06beb6c: sis_init+0x0/0x16() returned 0.
initcall 0xc06beb6c ran for 0 msecs: sis_init+0x0/0x16()
Calling initcall 0xc06beb82: triflex_init+0x0/0x16()
initcall 0xc06beb82: triflex_init+0x0/0x16() returned 0.
initcall 0xc06beb82 ran for 0 msecs: triflex_init+0x0/0x16()
Calling initcall 0xc06beb98: ata_generic_init+0x0/0x16()
initcall 0xc06beb98: ata_generic_init+0x0/0x16() returned 0.
initcall 0xc06beb98 ran for 0 msecs: ata_generic_init+0x0/0x16()
Calling initcall 0xc06bebae: cdrom_init+0x0/0xc()
initcall 0xc06bebae: cdrom_init+0x0/0xc() returned 0.
initcall 0xc06bebae ran for 0 msecs: cdrom_init+0x0/0xc()
Calling initcall 0xc06becbe: nonstatic_sysfs_init+0x0/0xf()
initcall 0xc06becbe: nonstatic_sysfs_init+0x0/0xf() returned 0.
initcall 0xc06becbe ran for 0 msecs: nonstatic_sysfs_init+0x0/0xf()
Calling initcall 0xc06beccd: yenta_socket_init+0x0/0x16()
initcall 0xc06beccd: yenta_socket_init+0x0/0x16() returned 0.
initcall 0xc06beccd ran for 0 msecs: yenta_socket_init+0x0/0x16()
Calling initcall 0xc06bef01: mon_init+0x0/0xee()
initcall 0xc06bef01: mon_init+0x0/0xee() returned 0.
initcall 0xc06bef01 ran for 0 msecs: mon_init+0x0/0xee()
Calling initcall 0xc06bf0be: ehci_hcd_init+0x0/0x16()
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
initcall 0xc06bf0be: ehci_hcd_init+0x0/0x16() returned 0.
initcall 0xc06bf0be ran for 156 msecs: ehci_hcd_init+0x0/0x16()
Calling initcall 0xc06bf0d4: ohci_hcd_mod_init+0x0/0x39()
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 21, io mem 0xda102000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
initcall 0xc06bf0d4: ohci_hcd_mod_init+0x0/0x39() returned 0.
initcall 0xc06bf0d4 ran for 190 msecs: ohci_hcd_mod_init+0x0/0x39()
Calling initcall 0xc06bf10d: uhci_hcd_init+0x0/0x91()
USB Universal Host Controller Interface driver v3.0
initcall 0xc06bf10d: uhci_hcd_init+0x0/0x91() returned 0.
initcall 0xc06bf10d ran for 4 msecs: uhci_hcd_init+0x0/0x91()
Calling initcall 0xc06bf19e: usb_usual_init+0x0/0x4c()
usbcore: registered new interface driver libusual
initcall 0xc06bf19e: usb_usual_init+0x0/0x4c() returned 0.
initcall 0xc06bf19e ran for 4 msecs: usb_usual_init+0x0/0x4c()
Calling initcall 0xc06bf26c: i8042_init+0x0/0x330()
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xc06bf26c: i8042_init+0x0/0x330() returned 0.
initcall 0xc06bf26c ran for 15 msecs: i8042_init+0x0/0x330()
Calling initcall 0xc06bf59c: serport_init+0x0/0x2b()
initcall 0xc06bf59c: serport_init+0x0/0x2b() returned 0.
initcall 0xc06bf59c ran for 0 msecs: serport_init+0x0/0x2b()
Calling initcall 0xc06bf6ba: mousedev_init+0x0/0x51()
mice: PS/2 mouse device common for all mice
initcall 0xc06bf6ba: mousedev_init+0x0/0x51() returned 0.
initcall 0xc06bf6ba ran for 3 msecs: mousedev_init+0x0/0x51()
Calling initcall 0xc06bf70b: evdev_init+0x0/0xf()
initcall 0xc06bf70b: evdev_init+0x0/0xf() returned 0.
initcall 0xc06bf70b ran for 0 msecs: evdev_init+0x0/0xf()
Calling initcall 0xc06bf729: atkbd_init+0x0/0x20()
initcall 0xc06bf729: atkbd_init+0x0/0x20() returned 0.
initcall 0xc06bf729 ran for 0 msecs: atkbd_init+0x0/0x20()
Calling initcall 0xc06bf749: psmouse_init+0x0/0x64()
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xc06bf749: psmouse_init+0x0/0x64() returned 0.
initcall 0xc06bf749 ran for 27 msecs: psmouse_init+0x0/0x64()
Calling initcall 0xc06c00e9: efivars_init+0x0/0x187()
initcall 0xc06c00e9: efivars_init+0x0/0x187() returned -19.
initcall 0xc06c00e9 ran for 0 msecs: efivars_init+0x0/0x187()
Calling initcall 0xc06c079b: hid_init+0x0/0x7()
initcall 0xc06c079b: hid_init+0x0/0x7() returned 0.
initcall 0xc06c079b ran for 0 msecs: hid_init+0x0/0x7()
Calling initcall 0xc06c07a2: usb_mouse_init+0x0/0x33()
usbcore: registered new interface driver usbmouse
drivers/hid/usbhid/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
initcall 0xc06c07a2: usb_mouse_init+0x0/0x33() returned 0.
initcall 0xc06c07a2 ran for 10 msecs: usb_mouse_init+0x0/0x33()
Calling initcall 0xc06c07d5: init_soundcore+0x0/0x50()
initcall 0xc06c07d5: init_soundcore+0x0/0x50() returned 0.
initcall 0xc06c07d5 ran for 0 msecs: init_soundcore+0x0/0x50()
Calling initcall 0xc06c0825: alsa_sound_init+0x0/0x77()
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
initcall 0xc06c0825: alsa_sound_init+0x0/0x77() returned 0.
initcall 0xc06c0825 ran for 7 msecs: alsa_sound_init+0x0/0x77()
Calling initcall 0xc06c0a32: alsa_hwdep_init+0x0/0x46()
initcall 0xc06c0a32: alsa_hwdep_init+0x0/0x46() returned 0.
initcall 0xc06c0a32 ran for 0 msecs: alsa_hwdep_init+0x0/0x46()
Calling initcall 0xc06c0a78: alsa_timer_init+0x0/0x124()
initcall 0xc06c0a78: alsa_timer_init+0x0/0x124() returned 0.
initcall 0xc06c0a78 ran for 0 msecs: alsa_timer_init+0x0/0x124()
Calling initcall 0xc06c0b9c: rtctimer_init+0x0/0xe7()
initcall 0xc06c0b9c: rtctimer_init+0x0/0xe7() returned 0.
initcall 0xc06c0b9c ran for 0 msecs: rtctimer_init+0x0/0xe7()
Calling initcall 0xc06c0c83: alsa_pcm_init+0x0/0x4d()
initcall 0xc06c0c83: alsa_pcm_init+0x0/0x4d() returned 0.
initcall 0xc06c0c83 ran for 0 msecs: alsa_pcm_init+0x0/0x4d()
Calling initcall 0xc06c0cd0: snd_mem_init+0x0/0x28()
initcall 0xc06c0cd0: snd_mem_init+0x0/0x28() returned 0.
initcall 0xc06c0cd0 ran for 0 msecs: snd_mem_init+0x0/0x28()
Calling initcall 0xc06c0cf8: alsa_rawmidi_init+0x0/0x69()
initcall 0xc06c0cf8: alsa_rawmidi_init+0x0/0x69() returned 0.
initcall 0xc06c0cf8 ran for 0 msecs: alsa_rawmidi_init+0x0/0x69()
Calling initcall 0xc06c0d61: alsa_mixer_oss_init+0x0/0x2d()
initcall 0xc06c0d61: alsa_mixer_oss_init+0x0/0x2d() returned 0.
initcall 0xc06c0d61 ran for 0 msecs: alsa_mixer_oss_init+0x0/0x2d()
Calling initcall 0xc06c0d8e: alsa_pcm_oss_init+0x0/0x72()
initcall 0xc06c0d8e: alsa_pcm_oss_init+0x0/0x72() returned 0.
initcall 0xc06c0d8e ran for 0 msecs: alsa_pcm_oss_init+0x0/0x72()
Calling initcall 0xc06c0e00: alsa_seq_oss_init+0x0/0x146()
initcall 0xc06c0e00: alsa_seq_oss_init+0x0/0x146() returned 0.
initcall 0xc06c0e00 ran for 0 msecs: alsa_seq_oss_init+0x0/0x146()
Calling initcall 0xc06c1105: alsa_seq_init+0x0/0x51()
initcall 0xc06c1105: alsa_seq_init+0x0/0x51() returned 0.
initcall 0xc06c1105 ran for 0 msecs: alsa_seq_init+0x0/0x51()
Calling initcall 0xc06c1356: alsa_seq_device_init+0x0/0x4e()
initcall 0xc06c1356: alsa_seq_device_init+0x0/0x4e() returned 0.
initcall 0xc06c1356 ran for 0 msecs: alsa_seq_device_init+0x0/0x4e()
Calling initcall 0xc06c13a4: alsa_seq_midi_event_init+0x0/0x7()
initcall 0xc06c13a4: alsa_seq_midi_event_init+0x0/0x7() returned 0.
initcall 0xc06c13a4 ran for 0 msecs: alsa_seq_midi_event_init+0x0/0x7()
Calling initcall 0xc06c14f1: alsa_seq_dummy_init+0x0/0xa7()
initcall 0xc06c14f1: alsa_seq_dummy_init+0x0/0xa7() returned 0.
initcall 0xc06c14f1 ran for 0 msecs: alsa_seq_dummy_init+0x0/0xa7()
Calling initcall 0xc06c1598: alsa_seq_midi_init+0x0/0x32()
initcall 0xc06c1598: alsa_seq_midi_init+0x0/0x32() returned 0.
initcall 0xc06c1598 ran for 0 msecs: alsa_seq_midi_init+0x0/0x32()
Calling initcall 0xc06c15ca: alsa_seq_midi_emul_init+0x0/0x7()
initcall 0xc06c15ca: alsa_seq_midi_emul_init+0x0/0x7() returned 0.
initcall 0xc06c15ca ran for 0 msecs: alsa_seq_midi_emul_init+0x0/0x7()
Calling initcall 0xc06c15d1: alsa_virmidi_init+0x0/0x7()
initcall 0xc06c15d1: alsa_virmidi_init+0x0/0x7() returned 0.
initcall 0xc06c15d1 ran for 0 msecs: alsa_virmidi_init+0x0/0x7()
Calling initcall 0xc06c15d8: alsa_mpu401_uart_init+0x0/0x7()
initcall 0xc06c15d8: alsa_mpu401_uart_init+0x0/0x7() returned 0.
initcall 0xc06c15d8 ran for 0 msecs: alsa_mpu401_uart_init+0x0/0x7()
Calling initcall 0xc06c15df: alsa_card_mpu401_init+0x0/0x9f()
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
initcall 0xc06c15df: alsa_card_mpu401_init+0x0/0x9f() returned 0.
initcall 0xc06c15df ran for 530 msecs: alsa_card_mpu401_init+0x0/0x9f()
Calling initcall 0xc06c167e: alsa_card_intel8x0_init+0x0/0x16()
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 50212 usecs
intel8x0: clocking to 46799
initcall 0xc06c167e: alsa_card_intel8x0_init+0x0/0x16() returned 0.
initcall 0xc06c167e ran for 322 msecs: alsa_card_intel8x0_init+0x0/0x16()
Calling initcall 0xc06c1694: alsa_ac97_init+0x0/0x7()
initcall 0xc06c1694: alsa_ac97_init+0x0/0x7() returned 0.
initcall 0xc06c1694 ran for 0 msecs: alsa_ac97_init+0x0/0x7()
Calling initcall 0xc06c169b: alsa_card_emu10k1_init+0x0/0x16()
initcall 0xc06c169b: alsa_card_emu10k1_init+0x0/0x16() returned 0.
initcall 0xc06c169b ran for 0 msecs: alsa_card_emu10k1_init+0x0/0x16()
Calling initcall 0xc06c16b1: alsa_emu10k1_synth_init+0x0/0x19()
initcall 0xc06c16b1: alsa_emu10k1_synth_init+0x0/0x19() returned 0.
initcall 0xc06c16b1 ran for 0 msecs: alsa_emu10k1_synth_init+0x0/0x19()
Calling initcall 0xc06c16ca: alsa_card_emu10k1x_init+0x0/0x16()
initcall 0xc06c16ca: alsa_card_emu10k1x_init+0x0/0x16() returned 0.
initcall 0xc06c16ca ran for 0 msecs: alsa_card_emu10k1x_init+0x0/0x16()
Calling initcall 0xc06c16e0: alsa_card_azx_init+0x0/0x16()
initcall 0xc06c16e0: alsa_card_azx_init+0x0/0x16() returned 0.
initcall 0xc06c16e0 ran for 0 msecs: alsa_card_azx_init+0x0/0x16()
Calling initcall 0xc06c16f6: alsa_util_mem_init+0x0/0x7()
initcall 0xc06c16f6: alsa_util_mem_init+0x0/0x7() returned 0.
initcall 0xc06c16f6 ran for 0 msecs: alsa_util_mem_init+0x0/0x7()
Calling initcall 0xc06c16fd: alsa_emux_init+0x0/0x7()
initcall 0xc06c16fd: alsa_emux_init+0x0/0x7() returned 0.
initcall 0xc06c16fd ran for 0 msecs: alsa_emux_init+0x0/0x7()
Calling initcall 0xc06c1713: alsa_sound_last_init+0x0/0x50()
ALSA device list:
  #0: NVidia CK804 with ALC850 at irq 20
  #1: MPU-401 UART at 0x330, irq 10
initcall 0xc06c1713: alsa_sound_last_init+0x0/0x50() returned 0.
initcall 0xc06c1713 ran for 8 msecs: alsa_sound_last_init+0x0/0x50()
Calling initcall 0xc06c32b2: sysctl_core_init+0x0/0xf()
initcall 0xc06c32b2: sysctl_core_init+0x0/0xf() returned 0.
initcall 0xc06c32b2 ran for 0 msecs: sysctl_core_init+0x0/0xf()
Calling initcall 0xc06c37ac: flow_cache_init+0x0/0x154()
initcall 0xc06c37ac: flow_cache_init+0x0/0x154() returned 0.
initcall 0xc06c37ac ran for 0 msecs: flow_cache_init+0x0/0x154()
Calling initcall 0xc06c39d2: llc_init+0x0/0x6d()
initcall 0xc06c39d2: llc_init+0x0/0x6d() returned 0.
initcall 0xc06c39d2 ran for 0 msecs: llc_init+0x0/0x6d()
Calling initcall 0xc06c3a3f: snap_init+0x0/0x2a()
initcall 0xc06c3a3f: snap_init+0x0/0x2a() returned 0.
initcall 0xc06c3a3f ran for 0 msecs: snap_init+0x0/0x2a()
Calling initcall 0xc06c3a69: rif_init+0x0/0x7a()
initcall 0xc06c3a69: rif_init+0x0/0x7a() returned 0.
initcall 0xc06c3a69 ran for 0 msecs: rif_init+0x0/0x7a()
Calling initcall 0xc06c3b8c: blackhole_module_init+0x0/0xf()
initcall 0xc06c3b8c: blackhole_module_init+0x0/0xf() returned 0.
initcall 0xc06c3b8c ran for 0 msecs: blackhole_module_init+0x0/0xf()
Calling initcall 0xc06c3eb5: nfnetlink_init+0x0/0x4f()
Netfilter messages via NETLINK v0.30.
initcall 0xc06c3eb5: nfnetlink_init+0x0/0x4f() returned 0.
initcall 0xc06c3eb5 ran for 3 msecs: nfnetlink_init+0x0/0x4f()
Calling initcall 0xc06c3f04: nfnetlink_queue_init+0x0/0x85()
initcall 0xc06c3f04: nfnetlink_queue_init+0x0/0x85() returned 0.
initcall 0xc06c3f04 ran for 0 msecs: nfnetlink_queue_init+0x0/0x85()
Calling initcall 0xc06c3f89: nfnetlink_log_init+0x0/0x8a()
initcall 0xc06c3f89: nfnetlink_log_init+0x0/0x8a() returned 0.
initcall 0xc06c3f89 ran for 0 msecs: nfnetlink_log_init+0x0/0x8a()
Calling initcall 0xc06c4f91: sysctl_ipv4_init+0x0/0x1c()
initcall 0xc06c4f91: sysctl_ipv4_init+0x0/0x1c() returned 0.
initcall 0xc06c4f91 ran for 0 msecs: sysctl_ipv4_init+0x0/0x1c()
Calling initcall 0xc06c51bc: init_syncookies+0x0/0x16()
initcall 0xc06c51bc: init_syncookies+0x0/0x16() returned 0.
initcall 0xc06c51bc ran for 0 msecs: init_syncookies+0x0/0x16()
Calling initcall 0xc04552bc: ipv4_netfilter_init+0x0/0xf()
initcall 0xc04552bc: ipv4_netfilter_init+0x0/0xf() returned 0.
initcall 0xc04552bc ran for 0 msecs: ipv4_netfilter_init+0x0/0xf()
Calling initcall 0xc06c51d2: bictcp_register+0x0/0xf()
TCP bic registered
initcall 0xc06c51d2: bictcp_register+0x0/0xf() returned 0.
initcall 0xc06c51d2 ran for 1 msecs: bictcp_register+0x0/0xf()
Calling initcall 0xc06c540c: xfrm_user_init+0x0/0x4b()
Initializing XFRM netlink socket
initcall 0xc06c540c: xfrm_user_init+0x0/0x4b() returned 0.
initcall 0xc06c540c ran for 2 msecs: xfrm_user_init+0x0/0x4b()
Calling initcall 0xc06c5457: af_unix_init+0x0/0x47()
NET: Registered protocol family 1
initcall 0xc06c5457: af_unix_init+0x0/0x47() returned 0.
initcall 0xc06c5457 ran for 3 msecs: af_unix_init+0x0/0x47()
Calling initcall 0xc06c549e: packet_init+0x0/0x39()
NET: Registered protocol family 17
initcall 0xc06c549e: packet_init+0x0/0x39() returned 0.
initcall 0xc06c549e ran for 3 msecs: packet_init+0x0/0x39()
Calling initcall 0xc06c54d7: ipsec_pfkey_init+0x0/0x7a()
NET: Registered protocol family 15
initcall 0xc06c54d7: ipsec_pfkey_init+0x0/0x7a() returned 0.
initcall 0xc06c54d7 ran for 2 msecs: ipsec_pfkey_init+0x0/0x7a()
Calling initcall 0xc06a916c: powernow_init+0x0/0xd3()
initcall 0xc06a916c: powernow_init+0x0/0xd3() returned -19.
initcall 0xc06a916c ran for 0 msecs: powernow_init+0x0/0xd3()
Calling initcall 0xc048b662: powernowk8_init+0x0/0x72()
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (2 cpu cores) (version 2.20.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
initcall 0xc048b662: powernowk8_init+0x0/0x72() returned -19.
initcall 0xc048b662 ran for 19 msecs: powernowk8_init+0x0/0x72()
Calling initcall 0xc06a9d46: centrino_init+0x0/0x2a()
initcall 0xc06a9d46: centrino_init+0x0/0x2a() returned -19.
initcall 0xc06a9d46 ran for 0 msecs: centrino_init+0x0/0x2a()
Calling initcall 0xc06a9dc4: hpet_insert_resource+0x0/0x1e()
initcall 0xc06a9dc4: hpet_insert_resource+0x0/0x1e() returned 1.
initcall 0xc06a9dc4 ran for 0 msecs: hpet_insert_resource+0x0/0x1e()
initcall at 0xc06a9dc4: hpet_insert_resource+0x0/0x1e(): returned with error code 1
Calling initcall 0xc06ad026: init_lapic_nmi_sysfs+0x0/0x33()
initcall 0xc06ad026: init_lapic_nmi_sysfs+0x0/0x33() returned 0.
initcall 0xc06ad026 ran for 0 msecs: init_lapic_nmi_sysfs+0x0/0x33()
Calling initcall 0xc06ad248: io_apic_bug_finalize+0x0/0x1c()
initcall 0xc06ad248: io_apic_bug_finalize+0x0/0x1c() returned 0.
initcall 0xc06ad248 ran for 0 msecs: io_apic_bug_finalize+0x0/0x1c()
Calling initcall 0xc06afd59: check_early_ioremap_leak+0x0/0x3d()
initcall 0xc06afd59: check_early_ioremap_leak+0x0/0x3d() returned 0.
initcall 0xc06afd59 ran for 0 msecs: check_early_ioremap_leak+0x0/0x3d()
Calling initcall 0xc06b01e2: print_ipi_mode+0x0/0x26()
Using IPI No-Shortcut mode
initcall 0xc06b01e2: print_ipi_mode+0x0/0x26() returned 0.
initcall 0xc06b01e2 ran for 2 msecs: print_ipi_mode+0x0/0x26()
Calling initcall 0xc013b2e9: init_oops_id+0x0/0x23()
initcall 0xc013b2e9: init_oops_id+0x0/0x23() returned 0.
initcall 0xc013b2e9 ran for 0 msecs: init_oops_id+0x0/0x23()
Calling initcall 0xc06b0cc8: disable_boot_consoles+0x0/0x36()
initcall 0xc06b0cc8: disable_boot_consoles+0x0/0x36() returned 0.
initcall 0xc06b0cc8 ran for 0 msecs: disable_boot_consoles+0x0/0x36()
Calling initcall 0xc06b1a2d: pm_qos_power_init+0x0/0x54()
initcall 0xc06b1a2d: pm_qos_power_init+0x0/0x54() returned 0.
initcall 0xc06b1a2d ran for 0 msecs: pm_qos_power_init+0x0/0x54()
Calling initcall 0xc0493d9c: debugfs_kprobe_init+0x0/0x78()
initcall 0xc0493d9c: debugfs_kprobe_init+0x0/0x78() returned 0.
initcall 0xc0493d9c ran for 0 msecs: debugfs_kprobe_init+0x0/0x78()
Calling initcall 0xc06b2a3b: taskstats_init+0x0/0x7d()
registered taskstats version 1
initcall 0xc06b2a3b: taskstats_init+0x0/0x7d() returned 0.
initcall 0xc06b2a3b ran for 2 msecs: taskstats_init+0x0/0x7d()
Calling initcall 0xc06b34a4: fail_page_alloc_debugfs+0x0/0xc1()
initcall 0xc06b34a4: fail_page_alloc_debugfs+0x0/0xc1() returned 0.
initcall 0xc06b34a4 ran for 0 msecs: fail_page_alloc_debugfs+0x0/0xc1()
Calling initcall 0xc06b456e: failslab_debugfs+0x0/0x58()
initcall 0xc06b456e: failslab_debugfs+0x0/0x58() returned 0.
initcall 0xc06b456e ran for 0 msecs: failslab_debugfs+0x0/0x58()
Calling initcall 0xc06b6b38: fail_make_request_debugfs+0x0/0x14()
initcall 0xc06b6b38: fail_make_request_debugfs+0x0/0x14() returned 0.
initcall 0xc06b6b38 ran for 0 msecs: fail_make_request_debugfs+0x0/0x14()
Calling initcall 0xc06b6f99: random32_reseed+0x0/0x57()
initcall 0xc06b6f99: random32_reseed+0x0/0x57() returned 0.
initcall 0xc06b6f99 ran for 0 msecs: random32_reseed+0x0/0x57()
Calling initcall 0xc06b7641: pci_sysfs_init+0x0/0x44()
initcall 0xc06b7641: pci_sysfs_init+0x0/0x44() returned 0.
initcall 0xc06b7641 ran for 0 msecs: pci_sysfs_init+0x0/0x44()
Calling initcall 0xc06b8436: acpi_wakeup_device_init+0x0/0x9a()
initcall 0xc06b8436: acpi_wakeup_device_init+0x0/0x9a() returned 0.
initcall 0xc06b8436 ran for 0 msecs: acpi_wakeup_device_init+0x0/0x9a()
Calling initcall 0xc06b85bc: acpi_sleep_proc_init+0x0/0x81()
initcall 0xc06b85bc: acpi_sleep_proc_init+0x0/0x81() returned 0.
initcall 0xc06b85bc ran for 0 msecs: acpi_sleep_proc_init+0x0/0x81()
Calling initcall 0xc06bacfb: seqgen_init+0x0/0xe()
initcall 0xc06bacfb: seqgen_init+0x0/0xe() returned 0.
initcall 0xc06bacfb ran for 0 msecs: seqgen_init+0x0/0xe()
Calling initcall 0xc02ecf3a: scsi_complete_async_scans+0x0/0xcd()
initcall 0xc02ecf3a: scsi_complete_async_scans+0x0/0xcd() returned 0.
initcall 0xc02ecf3a ran for 0 msecs: scsi_complete_async_scans+0x0/0xcd()
Calling initcall 0xc06c202c: pci_mmcfg_late_insert_resources+0x0/0x41()
initcall 0xc06c202c: pci_mmcfg_late_insert_resources+0x0/0x41() returned 0.
initcall 0xc06c202c ran for 0 msecs: pci_mmcfg_late_insert_resources+0x0/0x41()
Calling initcall 0xc06c46d0: tcp_congestion_default+0x0/0xf()
initcall 0xc06c46d0: tcp_congestion_default+0x0/0xf() returned 0.
initcall 0xc06c46d0 ran for 0 msecs: tcp_congestion_default+0x0/0xf()
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 312k freed
Write protecting the kernel text: 3672k
Write protecting the kernel read-only data: 1612k
BUG: sleeping function called from invalid context at mm/rmap.c:62
in_atomic():0, irqs_disabled():1
1 lock held by init/642:
 #0:  (&mm->mmap_sem){----}, at: [<c049372c>] do_page_fault+0x1f9/0x5ad
irq event stamp: 8
hardirqs last  enabled at (7): [<c0156713>] trace_hardirqs_on+0xb/0xd
hardirqs last disabled at (8): [<c0236724>] trace_hardirqs_off_thunk+0xc/0x10
softirqs last  enabled at (0): [<c0139919>] copy_process+0x2fe/0x12e8
softirqs last disabled at (0): [<00000000>] 0x0
Pid: 642, comm: init Not tainted 2.6.25-rc6-sched-devel.git-x86-latest.git #321
 [<c013422e>] __might_sleep+0xc2/0xc9
 [<c017ffde>] anon_vma_prepare+0x1d/0xc4
 [<c0179c13>] do_wp_page+0x1ab/0x3d0
 [<c017b70a>] handle_mm_fault+0x538/0x590
 [<c049372c>] ? do_page_fault+0x1f9/0x5ad
 [<c014f040>] ? down_read_trylock+0x37/0x41
 [<c04937e6>] do_page_fault+0x2b3/0x5ad
 [<c0493533>] ? do_page_fault+0x0/0x5ad
 [<c0491e7a>] error_code+0x72/0x78
 =======================
------------[ cut here ]------------
kernel BUG at fs/buffer.c:1274!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in:

Pid: 645, comm: rc.sysinit Not tainted (2.6.25-rc6-sched-devel.git-x86-latest.git #321)
EIP: 0060:[<c01a818d>] EFLAGS: 00010046 CPU: 1
EIP is at __find_get_block+0x17/0x16a
EAX: 00000086 EBX: f7832698 ECX: 00000000 EDX: 00212800
ESI: 00212800 EDI: 00000000 EBP: f7fffba8 ESP: f7fffb6c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process rc.sysinit (pid: 645, ti=f7fff000 task=f76082b0 task.ti=f7fff000)
Stack: f7802340 f7fffc60 f7618000 00000001 00000046 f782dcc0 00212800 00000000 
       00000046 f78221d0 0000027c 0003fc43 f7832698 00000000 f782ddac f7fffc00 
       c01a82fa 00001000 00212800 00000000 f7802340 00000000 00000000 f7f76a40 
Call Trace:
 [<c01a82fa>] ? __getblk+0x1a/0x26b
 [<c01cc282>] ? ext3_getblk+0x4c/0x169
 [<c01cc2d4>] ? ext3_getblk+0x9e/0x169
 [<c01cd03d>] ? ext3_bread+0x14/0x73
 [<c02376ba>] ? random32+0x32/0x4c
 [<c01cf2cd>] ? dx_probe+0x37/0x27e
 [<c015546f>] ? trace_hardirqs_off+0xb/0xd
 [<c01cfd7c>] ? ext3_find_entry+0xd8/0x596
 [<c0491afc>] ? _spin_unlock+0x27/0x3c
 [<c01d0aa3>] ? ext3_lookup+0x25/0xa2
 [<c01926b0>] ? do_lookup+0xa9/0x146
 [<c0194270>] ? __link_path_walk+0x702/0xa8c
 [<c015655c>] ? mark_held_locks+0x4e/0x66
 [<c01566d3>] ? trace_hardirqs_on_caller+0xe0/0x115
 [<c0156713>] ? trace_hardirqs_on+0xb/0xd
 [<c019463b>] ? link_path_walk+0x41/0x95
 [<c0491afc>] ? _spin_unlock+0x27/0x3c
 [<c01946a8>] ? path_walk+0x19/0x1b
 [<c01948cc>] ? do_path_lookup+0x134/0x19a
 [<c01951b6>] ? __path_lookup_intent_open+0x42/0x74
 [<c0195241>] ? path_lookup_open+0x10/0x12
 [<c019530e>] ? open_namei+0x64/0x507
 [<c018a9b2>] ? do_filp_open+0x1f/0x35
 [<c0491afc>] ? _spin_unlock+0x27/0x3c
 [<c018aa08>] ? do_sys_open+0x40/0xb5
 [<c018aaa9>] ? sys_open+0x16/0x18
 [<c0117a16>] ? syscall_call+0x7/0xb
 =======================
Code: 0b 8b 43 10 89 73 0c 83 c0 74 e8 64 99 2e 00 5b 5e 5f 5d c3 55 89 e5 57 89 cf 56 89 d6 53 83 ec 30 89 45 c4 9c 58 f6 c4 02 75 04 <0f> 0b eb fe fa e8 cd d2 fa ff bb 64 a7 6e c0 e8 43 ab 09 00 31 
EIP: [<c01a818d>] __find_get_block+0x17/0x16a SS:ESP 0068:f7fffb6c
---[ end trace 7fc93f2a1fd9073c ]---

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc6
# Fri Mar 21 15:23:56 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
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
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_LSF=y
# CONFIG_BLK_DEV_BSG is not set

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
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_CLASSIC_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_X86_CYCLONE_TIMER=y
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
# CONFIG_MWINCHIP2 is not set
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
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_X86_PAT=y
CONFIG_EFI=y
# CONFIG_IRQBALANCE is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=1999
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
CONFIG_APM_CPU_IDLE=y
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set
# CONFIG_APM_REAL_MODE_POWER_OFF is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
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
CONFIG_PD6729=m
CONFIG_I82092=m
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_COMPAQ=m
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y

#
# Networking
#
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
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
CONFIG_TCP_MD5SIG=y
CONFIG_IP_VS=m
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
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
CONFIG_IPV6_SIT=m
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
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
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
# CONFIG_IP6_NF_MATCH_MH is not set
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_RR is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

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
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
CONFIG_BT_HCIUSB_SCO=y
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_IEEE80211_SOFTMAC=m
CONFIG_IEEE80211_SOFTMAC_DEBUG=y
# CONFIG_RFKILL is not set
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
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
CONFIG_MSI_LAPTOP=m
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
# CONFIG_SCSI_7000FASST is not set
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=1000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=1000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
# CONFIG_SCSI_IN2000 is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_SCSI_OMIT_FLASHPOINT is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_SYM53C416 is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=m
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIL24=y
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
# CONFIG_PATA_CS5536 is not set
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
# CONFIG_PATA_HPT3X3_DMA is not set
# CONFIG_PATA_ISAPNP is not set
CONFIG_PATA_IT821X=y
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
CONFIG_PATA_LEGACY=m
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87410=y
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_OPTIDMA=y
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_QDI=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
CONFIG_PATA_WINBOND_VLB=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_EMC=m
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_MULTIPATH_HP is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_OHCI1394=m

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
# CONFIG_VETH is not set
CONFIG_NET_SB1000=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
# CONFIG_ELPLUS is not set
# CONFIG_EL16 is not set
CONFIG_EL3=m
# CONFIG_3C515 is not set
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_LANCE is not set
CONFIG_NET_VENDOR_SMC=y
# CONFIG_WD80x3 is not set
CONFIG_ULTRA=m
# CONFIG_SMC9194 is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
CONFIG_NET_ISA=y
# CONFIG_E2100 is not set
CONFIG_EWRK3=m
# CONFIG_EEXPRESS is not set
# CONFIG_EEXPRESS_PRO is not set
# CONFIG_HPLAN_PLUS is not set
# CONFIG_HPLAN is not set
# CONFIG_LP486E is not set
# CONFIG_ETH16I is not set
CONFIG_NE2000=m
# CONFIG_ZNET is not set
# CONFIG_SEEQ8005 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_PCNET32_NAPI=y
CONFIG_AMD8111_ETH=m
CONFIG_AMD8111E_NAPI=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_ADAPTEC_STARFIRE_NAPI=y
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_RHINE_NAPI=y
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=y
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_NAPI=y
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
# CONFIG_SK98LIN is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=y
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T1_NAPI=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGBE is not set
CONFIG_IXGB=m
CONFIG_IXGB_NAPI=y
CONFIG_S2IO=m
CONFIG_S2IO_NAPI=y
CONFIG_MYRI10GE=m
CONFIG_NETXEN_NIC=m
# CONFIG_NIU is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
CONFIG_TR=y
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
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_PCMCIA_IBMTR=m
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_NICSTAR=m
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E_MAYBE=m
# CONFIG_ATM_FORE200E_PCA is not set
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=m
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_0 is not set
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
# CONFIG_HISAX_AVM_A1 is not set
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_IX1MICROR2 is not set
CONFIG_HISAX_DIEHLDIVA=y
# CONFIG_HISAX_ASUSCOM is not set
# CONFIG_HISAX_TELEINT is not set
# CONFIG_HISAX_HFCS is not set
CONFIG_HISAX_SEDLBAUER=y
# CONFIG_HISAX_SPORTSTER is not set
# CONFIG_HISAX_MIC is not set
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
# CONFIG_HISAX_ISURF is not set
# CONFIG_HISAX_HSTSAPHIR is not set
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m
CONFIG_HISAX_HDLC=y

#
# Active cards
#
# CONFIG_ISDN_DRV_ICN is not set
# CONFIG_ISDN_DRV_PCBIT is not set
# CONFIG_ISDN_DRV_SC is not set
# CONFIG_ISDN_DRV_ACT2000 is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
# CONFIG_GIGASET_M101 is not set
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_GIGASET_UNDOCREQ is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1ISA is not set
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
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
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_WISTRON_BTNS=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_ESPSERIAL is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
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
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
CONFIG_SERIAL_8250_EXAR_ST16C554=m
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_DTLK=m
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_PROSAVAGE=m
CONFIG_I2C_SAVAGE4=m
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
CONFIG_I2C_VOODOO3=m
CONFIG_I2C_PCA_ISA=m

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
# CONFIG_PCF8575 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_TPS65010 is not set
CONFIG_SENSORS_MAX6875=m
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DVB_CORE=m
# CONFIG_DVB_CORE_ATTACH is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
# CONFIG_DVB_USB_M920X is not set
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_AU6610 is not set
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
# CONFIG_DVB_USB_OPERA1 is not set
# CONFIG_DVB_USB_AF9005 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_DVB_CINERGYT2=m
CONFIG_DVB_CINERGYT2_TUNING=y
CONFIG_DVB_CINERGYT2_STREAM_URB_COUNT=32
CONFIG_DVB_CINERGYT2_STREAM_BUF_SIZE=512
CONFIG_DVB_CINERGYT2_QUERY_INTERVAL=250
CONFIG_DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE=y
CONFIG_DVB_CINERGYT2_RC_QUERY_INTERVAL=100

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_STV0299=m
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_MT312=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_TDA10086=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_S5H1409 is not set

#
# Tuners/PLL support
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TDA827X=m
# CONFIG_DVB_TDA18271 is not set
# CONFIG_DVB_TUNER_QT1010 is not set
CONFIG_DVB_TUNER_MT2060=m
CONFIG_DVB_TUNER_MT2266=m
# CONFIG_DVB_TUNER_MT2131 is not set
CONFIG_DVB_TUNER_DIB0070=m
# CONFIG_DVB_TUNER_XC5000 is not set

#
# Miscellaneous devices
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_TUA6100=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=y
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_IMAC is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
CONFIG_FB_TRIDENT=m
CONFIG_FB_TRIDENT_ACCEL=y
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

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
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DUMMY=m
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=y
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_SB_COMMON=m

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
# CONFIG_SND_OXYGEN is not set
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
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
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
# CONFIG_SND_FM801_TEA575X_BOOL is not set
CONFIG_SND_HDA_INTEL=y
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
# CONFIG_SND_HIFIER is not set
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=m
CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL=y
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL=y
# CONFIG_SND_MIXART is not set
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SIS7019 is not set
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL=y
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_THRUSTMASTER_FF=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_AIRPRIME=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_AUERSWALD=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
# CONFIG_EDAC_I5000 is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# Conflicting RTC option has been selected, check GEN_RTC and RTC
#

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
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_SECURITY=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_NOLOCK=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_CRAMFS=m
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_CODA_FS_OLD_API is not set
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
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_NONPROMISC_DEVMEM=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
# CONFIG_SYSPROF is not set
CONFIG_MMIOTRACE_HOOKS=y
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=y
# CONFIG_CRYPTO_SEQIV is not set
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y

--J2SCkAp4GZ/dPZZf--
