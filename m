Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZBQPX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZBQPX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZBQPXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:23:18 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55894 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBQPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:23:13 -0500
Message-ID: <499AD63B.5040608@in.ibm.com>
Date: Tue, 17 Feb 2009 20:52:35 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Next 17 : warn_slowpath() / powernowk8_cpu_init
References: <20090217203832.d6f2ef79.sfr@canb.auug.org.au>
In-Reply-To: <20090217203832.d6f2ef79.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------060107090106080902000302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060107090106080902000302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While booting next 17 kernel on a x86_64 box noticed the following

powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 2218 processors (4 cpu cores) (version 2.20.00)
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1255 powernowk8_cpu_init+0x493/0xd22()
Hardware name: BladeCenter LS21 -[79716AA]-
[Firmware Bug]: powernow-k8: Your BIOS does not provide ACPI _PSS objects in a way that Linux understands. Please report this to the Linux ACPI maintainers and complain to your BIOS vendor.
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.29-rc5-autotest-next-20090217 #1

Call Trace:
 [<ffffffff80240744>] warn_slowpath+0xd3/0xf2
 [<ffffffff80257ab3>] ? up+0x34/0x39
 [<ffffffff802606a9>] ? mark_held_locks+0x49/0x69
 [<ffffffff80527038>] ? __mutex_unlock_slowpath+0x117/0x123
 [<ffffffff802607fd>] ? trace_hardirqs_on_caller+0x134/0x15f
 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8052704d>] ? mutex_unlock+0x9/0xb
 [<ffffffff803f26f0>] ? acpi_processor_register_performance+0x3a9/0x3da
 [<ffffffff802bffd2>] ? kmem_cache_alloc+0xcc/0xfa
 [<ffffffff802607fd>] ? trace_hardirqs_on_caller+0x134/0x15f
 [<ffffffff8039be94>] ? __bitmap_weight+0x78/0x8d
 [<ffffffff8051eed2>] powernowk8_cpu_init+0x493/0xd22
 [<ffffffff8025f25a>] ? lockdep_init_map+0x9c/0x467
 [<ffffffff8047dadc>] ? lock_policy_rwsem_write+0x46/0xaf
 [<ffffffff8047dec5>] cpufreq_add_dev+0x1c6/0x7af
 [<ffffffff80262e82>] ? __lock_acquire+0x773/0x7de
 [<ffffffff802606a9>] ? mark_held_locks+0x49/0x69
 [<ffffffff8052774f>] ? mutex_lock_nested+0x29b/0x2b4
 [<ffffffff802607fd>] ? trace_hardirqs_on_caller+0x134/0x15f
 [<ffffffff8025e753>] ? debug_mutex_free_waiter+0x53/0x57
 [<ffffffff8052775b>] ? mutex_lock_nested+0x2a7/0x2b4
 [<ffffffff80425df0>] ? sysdev_driver_register+0x75/0x10d
 [<ffffffff80425e2a>] sysdev_driver_register+0xaf/0x10d
 [<ffffffff8047cb95>] cpufreq_register_driver+0xc7/0x1f6
 [<ffffffff8051ea33>] powernowk8_init+0xc5/0xd1
 [<ffffffff8051e96e>] ? powernowk8_init+0x0/0xd1
 [<ffffffff8020905c>] do_one_initcall+0x56/0x130
 [<ffffffff80282dc4>] ? register_irq_proc+0xae/0xca
 [<ffffffff80300000>] ? writenote+0x8b/0xb8
 [<ffffffff808b193a>] kernel_init+0x1a2/0x1f9
 [<ffffffff8020ceda>] child_rip+0xa/0x20
 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30
 [<ffffffff80257a8e>] ? up+0xf/0x39
 [<ffffffff808b1798>] ? kernel_init+0x0/0x1f9
 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

---[ end trace dd3dd2a755e71b32 ]---

Should i be worried ? 

I also see few more traces with __debug_object_init().
Will send a separate mail with details for that problem.

Complete dmesg attached.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------060107090106080902000302
Content-Type: text/plain;
 name="dmesg_x86_64_next17"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_x86_64_next17"

root (hd0,0)

 Filesystem type is ext2fs, partition type 0x83

kernel /boot/vmlinuz-autotest root=/dev/sda1 console=tty0 selinux=0 console=tty

S1,19200 noapic IDENT=1234879013

   [Linux-bzImage, setup=0x2c00, size=0x280e90]

initrd /boot/initrd-autotest

   [Linux-initrd @ 0x37d8b000, 0x264497 bytes]



Initializing cgroup subsys cpuset

Initializing cgroup subsys cpu

Linux version 2.6.29-rc5-autotest-next-20090217 (root@ls21b) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Tue Feb 17 19:24:51 IST 2009

Command line: root=/dev/sda1 console=tty0 selinux=0 console=ttyS1,19200 noapic IDENT=1234879013

KERNEL supported cpus:

  Intel GenuineIntel

  AMD AuthenticAMD

  Centaur CentaurHauls

BIOS-provided physical RAM map:

 BIOS-e820: 0000000000000000 - 000000000009d000 (usable)

 BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)

 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)

 BIOS-e820: 0000000000100000 - 00000000cffa44c0 (usable)

 BIOS-e820: 00000000cffa44c0 - 00000000cffa7400 (ACPI data)

 BIOS-e820: 00000000cffa7400 - 00000000d0000000 (reserved)

 BIOS-e820: 00000000f4000000 - 00000000fc000000 (reserved)

 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)

 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)

DMI 2.3 present.

last_pfn = 0x130000 max_arch_pfn = 0x100000000

last_pfn = 0xcffa4 max_arch_pfn = 0x100000000

init_memory_mapping: 0000000000000000-00000000cffa4000

last_map_addr: cffa4000 end: cffa4000

init_memory_mapping: 0000000100000000-0000000130000000

last_map_addr: 130000000 end: 130000000

RAMDISK: 37d8b000 - 37fef497

ACPI: RSDP 000FDFE0, 0014 (r0 IBM   )

ACPI: RSDT CFFA7380, 0038 (r1 IBM    SERLEWIS     1000 IBM  45444F43)

ACPI: FACP CFFA72C0, 0084 (r2 IBM    SERLEWIS     1000 IBM  45444F43)

FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)

FADT: X_PM1b_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)

ACPI: DSDT CFFA44C0, 2B02 (r1 IBM    SERLEWIS     1000 INTL  2002025)

ACPI: FACS CFFA7040, 0040

ACPI: APIC CFFA7200, 0090 (r1 IBM    SERLEWIS     1000 IBM  45444F43)

ACPI: SRAT CFFA7100, 00E8 (r1 AMD    HAMMER          1 AMD         1)

ACPI: HPET CFFA70C0, 0038 (r1 IBM    SERLEWIS     1000 IBM  45444F43)

ACPI: MCFG CFFA7080, 003C (r1 IBM    SERLEWIS     1000 IBM  45444F43)

SRAT: PXM 0 -> APIC 0 -> Node 0

SRAT: PXM 0 -> APIC 1 -> Node 0

SRAT: PXM 1 -> APIC 2 -> Node 1

SRAT: PXM 1 -> APIC 3 -> Node 1

SRAT: Node 0 PXM 0 0-a0000

SRAT: Node 0 PXM 0 100000-d0000000

SRAT: Node 0 PXM 0 100000000-130000000

Bootmem setup node 0 0000000000000000-0000000130000000

  NODE_DATA [000000000000a640 - 000000000001063f]

  bootmap [0000000000011000 -  0000000000036fff] pages 26

(8 early reservations) ==> bootmem [0000000000 - 0130000000]

  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]

  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]

  #2 [0000200000 - 000159ac80]    TEXT DATA BSS ==> [0000200000 - 000159ac80]

  #3 [0037d8b000 - 0037fef497]          RAMDISK ==> [0037d8b000 - 0037fef497]

  #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]

  #5 [000159b000 - 0001c1e000]          PGTABLE ==> [000159b000 - 0001c1e000]

  #6 [0001c1e000 - 0001d9f000]          PGTABLE ==> [0001c1e000 - 0001d9f000]

  #7 [0000008000 - 000000a640]       MEMNODEMAP ==> [0000008000 - 000000a640]

found SMP MP-table at [ffff88000009d140] 9d140

Zone PFN ranges:

  DMA      0x00000000 -> 0x00001000

  DMA32    0x00001000 -> 0x00100000

  Normal   0x00100000 -> 0x00130000

Movable zone start PFN for each node

early_node_map[3] active PFN ranges

    0: 0x00000000 -> 0x0000009d

    0: 0x00000100 -> 0x000cffa4

    0: 0x00100000 -> 0x00130000

Detected use of extended apic ids on hypertransport bus

Detected use of extended apic ids on hypertransport bus

ACPI: PM-Timer IO Port: 0x488

ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)

ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)

ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)

ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)

ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])

ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])

ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])

ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])

ACPI: Skipping IOAPIC probe due to 'noapic' option.

Using ACPI for processor (LAPIC) configuration information

ACPI: HPET id: 0x1166a201 base: 0xfed00000

Intel MultiProcessor Specification v1.4

MPTABLE: OEM ID: IBM ENSW

MPTABLE: Product ID: LEWIS  SMP  

MPTABLE: APIC at: 0xFEE00000

I/O APIC #14 Version 17 at 0xFEC00000.

I/O APIC #13 Version 17 at 0xFEC02000.

Processors: 4

SMP: Allowing 4 CPUs, 0 hotplug CPUs

Allocating PCI resources starting at d4000000 (gap: d0000000:24000000)

NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:4 nr_node_ids:1

PERCPU: Allocating 81920 bytes of per cpu data

Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1021527

Policy zone: Normal

Kernel command line: root=/dev/sda1 console=tty0 selinux=0 console=ttyS1,19200 noapic IDENT=1234879013

Initializing CPU#0

Experimental hierarchical RCU implementation.

RCU-based detection of stalled CPUs is enabled.

Experimental hierarchical RCU init done.

NR_IRQS:4352

PID hash table entries: 4096 (order: 12, 32768 bytes)

Fast TSC calibration using PIT

Detected 2200.007 MHz processor.

Console: colour VGA+ 80x25

console [tty0] enabled

console [ttyS1] enabled

Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar

... MAX_LOCKDEP_SUBCLASSES:  8

... MAX_LOCK_DEPTH:          48

... MAX_LOCKDEP_KEYS:        8191

... CLASSHASH_SIZE:          4096

... MAX_LOCKDEP_ENTRIES:     8192

... MAX_LOCKDEP_CHAINS:      16384

... CHAINHASH_SIZE:          8192

 memory used by lock dependency info: 4607 kB

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

allocated 41943040 bytes of page_cgroup

please try cgroup_disable=memory option if you don't want

Checking aperture...

No AGP bridge found

Node 0: aperture @ f4000000 size 64 MB

Node 1: aperture @ f4000000 size 64 MB

Memory: 4028404k/4980736k available (3259k kernel code, 787196k absent, 165136k reserved, 2441k data, 428k init)

ODEBUG: selftest passed

HPET: 3 timers in total, 0 timers will be used for per-cpu timer

Calibrating delay loop (skipped), value calculated using timer frequency.. <7>spurious 8259A interrupt: IRQ7.

4400.01 BogoMIPS (lpj=2200007)

Security Framework initialized

SELinux:  Disabled at boot.

Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)

Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)

Mount-cache hash table entries: 256

Initializing cgroup subsys debug

Initializing cgroup subsys ns

Initializing cgroup subsys cpuacct

Initializing cgroup subsys memory

Initializing cgroup subsys devices

Initializing cgroup subsys freezer

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)

CPU: L2 Cache: 1024K (64 bytes/line)

CPU 0/0x0 -> Node 0

CPU: Physical Processor ID: 0

CPU: Processor Core ID: 0

using C1E aware idle routine

ACPI: Core revision 20090123

ACPI: setting ELCR to 0200 (from 06a0)

Setting APIC routing to flat

CPU0: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02

APIC calibration not consistent with PM-Timer: 805ms instead of 100ms

APIC delta adjusted to PM-Timer: 8523016 (68659200)

lockdep: fixing up alternatives.

Booting processor 1 APIC 0x2 ip 0x6000

Initializing CPU#1

Calibrating delay using timer specific routine.. 30001.05 BogoMIPS (lpj=15000527)

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)

CPU: L2 Cache: 1024K (64 bytes/line)

CPU 1/0x2 -> Node 0

CPU: Physical Processor ID: 1

CPU: Processor Core ID: 0

CPU1: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02

lockdep: fixing up alternatives.

Booting processor 2 APIC 0x1 ip 0x6000

Initializing CPU#2

Calibrating delay using timer specific routine.. 30001.08 BogoMIPS (lpj=15000541)

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)

CPU: L2 Cache: 1024K (64 bytes/line)

CPU 2/0x1 -> Node 0

CPU: Physical Processor ID: 0

CPU: Processor Core ID: 1

CPU2: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02

lockdep: fixing up alternatives.

Booting processor 3 APIC 0x3 ip 0x6000

Initializing CPU#3

Calibrating delay using timer specific routine.. 30001.02 BogoMIPS (lpj=15000511)

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)

CPU: L2 Cache: 1024K (64 bytes/line)

CPU 3/0x3 -> Node 0

CPU: Physical Processor ID: 1

CPU: Processor Core ID: 1

CPU3: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02

Brought up 4 CPUs

Total of 4 processors activated (94403.17 BogoMIPS).

net_namespace: 1992 bytes

NET: Registered protocol family 16

TOM: 00000000d0000000 aka 3328M

TOM2: 0000000130000000 aka 4864M

ACPI: bus type pci registered

PCI: MCFG configuration 0: base fa000000 segment 0 buses 0 - 8

PCI: MCFG area at fa000000 reserved in E820

PCI: Using MMCONFIG at fa000000 - fa8fffff

PCI: Using configuration type 1 for base access

bio: create slab <bio-0> at 0

ACPI: Interpreter enabled

ACPI: (supports S0 S5)

ACPI: Using PIC for interrupt routing

ACPI: No dock devices found.

ACPI: PCI Root Bridge [PCI0] (0000:00)

pci 0000:00:01.0: Enabling HT MSI Mapping

pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot

pci 0000:00:03.2: PME# disabled

pci 0000:02:04.0: PME# supported from D3hot D3cold

pci 0000:02:04.0: PME# disabled

pci 0000:02:05.0: PME# supported from D3hot D3cold

pci 0000:02:05.0: PME# disabled

ACPI: PCI Interrupt Link [LPAC] (IRQs *9)

ACPI: PCI Interrupt Link [LPUS] (IRQs *5)

ACPI: PCI Interrupt Link [LPID] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LPSA] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LPSM] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP00] (IRQs *10)

ACPI: PCI Interrupt Link [LP01] (IRQs *7)

ACPI: PCI Interrupt Link [LP02] (IRQs *10)

ACPI: PCI Interrupt Link [LP03] (IRQs *9)

ACPI: PCI Interrupt Link [LP04] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP05] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP06] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP07] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP08] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP09] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP0A] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP0B] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP0C] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP0D] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP0E] (IRQs) *0, disabled.

ACPI: PCI Interrupt Link [LP0F] (IRQs) *0, disabled.

usbcore: registered new interface driver usbfs

usbcore: registered new interface driver hub

usbcore: registered new device driver usb

PCI: Using ACPI for IRQ routing

NetLabel: Initializing

NetLabel:  domain hash size = 128

NetLabel:  protocols = UNLABELED CIPSOv4

NetLabel:  unlabeled traffic allowed by default

PCI-DMA: Disabling AGP.

PCI-DMA: aperture base @ f4000000 size 65536 KB

init_memory_mapping: 00000000f4000000-00000000f8000000

last_map_addr: f8000000 end: f8000000

PCI-DMA: using GART IOMMU.

PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture

hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0

hpet0: 3 comparators, 64-bit 14.318180 MHz counter

pnp: PnP ACPI init

ACPI: bus type pnp registered

pnp: PnP ACPI: found 12 devices

ACPI: ACPI bus type pnp unregistered

system 00:01: ioport range 0x510-0x517 has been reserved

system 00:01: ioport range 0x504-0x507 has been reserved

system 00:01: ioport range 0x500-0x503 has been reserved

system 00:01: ioport range 0x520-0x53f has been reserved

system 00:01: ioport range 0x540-0x547 has been reserved

system 00:01: ioport range 0x460-0x461 has been reserved

system 00:0a: ioport range 0x400-0x47f could not be reserved

system 00:0a: ioport range 0x480-0x4cf has been reserved

system 00:0a: ioport range 0x4d0-0x4d1 has been reserved

system 00:0a: ioport range 0x4d6-0x4e0 has been reserved

system 00:0a: ioport range 0x540-0x55f could not be reserved

system 00:0a: ioport range 0x600-0x600 has been reserved

system 00:0a: ioport range 0xc00-0xc01 has been reserved

system 00:0a: ioport range 0xc06-0xca6 has been reserved

system 00:0a: ioport range 0xca8-0xca8 has been reserved

system 00:0a: ioport range 0xcac-0xcac has been reserved

system 00:0a: ioport range 0xcb0-0xcb0 has been reserved

system 00:0a: ioport range 0xcb4-0xcb4 has been reserved

system 00:0a: ioport range 0xcc0-0xcdf has been reserved

system 00:0a: iomem range 0xf4000000-0xfbffffff could not be reserved

system 00:0a: iomem range 0xfec00000-0xffffffff has been reserved

pci 0000:01:0d.0: PCI bridge, secondary bus 0000:02

pci 0000:01:0d.0:   IO window: disabled

pci 0000:01:0d.0:   MEM window: 0xe2000000-0xe6ffffff

pci 0000:01:0d.0:   PREFETCH window: disabled

pci 0000:00:01.0: PCI bridge, secondary bus 0000:01

pci 0000:00:01.0:   IO window: disabled

pci 0000:00:01.0:   MEM window: 0xe2000000-0xe7ffffff

pci 0000:00:01.0:   PREFETCH window: disabled

pci 0000:00:06.0: PCI bridge, secondary bus 0000:03

pci 0000:00:06.0:   IO window: 0x4000-0x4fff

pci 0000:00:06.0:   MEM window: 0xdf000000-0xe00fffff

pci 0000:00:06.0:   PREFETCH window: 0x000000d4000000-0x000000d40fffff

pci 0000:00:07.0: PCI bridge, secondary bus 0000:04

pci 0000:00:07.0:   IO window: disabled

pci 0000:00:07.0:   MEM window: 0xdd000000-0xddffffff

pci 0000:00:07.0:   PREFETCH window: disabled

pci 0000:00:08.0: PCI bridge, secondary bus 0000:05

pci 0000:00:08.0:   IO window: disabled

pci 0000:00:08.0:   MEM window: 0xdc000000-0xdcffffff

pci 0000:00:08.0:   PREFETCH window: disabled

pci 0000:00:09.0: PCI bridge, secondary bus 0000:06

pci 0000:00:09.0:   IO window: disabled

pci 0000:00:09.0:   MEM window: 0xdb000000-0xdbffffff

pci 0000:00:09.0:   PREFETCH window: disabled

pci 0000:00:0a.0: PCI bridge, secondary bus 0000:07

pci 0000:00:0a.0:   IO window: disabled

pci 0000:00:0a.0:   MEM window: 0xda000000-0xdaffffff

pci 0000:00:0a.0:   PREFETCH window: disabled

pci 0000:00:0b.0: PCI bridge, secondary bus 0000:08

pci 0000:00:0b.0:   IO window: disabled

pci 0000:00:0b.0:   MEM window: 0xd9000000-0xd9ffffff

pci 0000:00:0b.0:   PREFETCH window: disabled

NET: Registered protocol family 2

IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)

TCP established hash table entries: 524288 (order: 11, 8388608 bytes)

TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)

TCP: Hash tables configured (established 524288 bind 65536)

TCP reno registered

NET: Registered protocol family 1

checking if image is initramfs... it is

debug: unmapping init memory ffff880037d8b000..ffff880037ff0000

====[ backtrace testing ]===========

Testing a backtrace from process context.

The following trace is a kernel self test and not a bug!

Pid: 1, comm: swapper Not tainted 2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 [<ffffffff802c3eb8>] ? __percpu_alloc_mask+0xfb/0x137

 [<ffffffff8026e9dd>] backtrace_regression_test+0x38/0xf7

 [<ffffffff808ca152>] ? crash_notes_memory_init+0x0/0x3d

 [<ffffffff8020905c>] do_one_initcall+0x56/0x130

 [<ffffffff80282dc4>] ? register_irq_proc+0xae/0xca

 [<ffffffff80300000>] ? writenote+0x8b/0xb8

 [<ffffffff808b193a>] kernel_init+0x1a2/0x1f9

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80257a8e>] ? up+0xf/0x39

 [<ffffffff808b1798>] ? kernel_init+0x0/0x1f9

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

Testing a backtrace from irq context.

The following trace is a kernel self test and not a bug!

Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 <IRQ>  [<ffffffff802607e3>] ? trace_hardirqs_on_caller+0x11a/0x15f

 [<ffffffff8026e997>] backtrace_test_irq_callback+0x9/0x17

 [<ffffffff80245dcf>] tasklet_action+0x6f/0xce

 [<ffffffff8024595f>] __do_softirq+0x80/0x159

 [<ffffffff8020cfdc>] call_softirq+0x1c/0x34

 <EOI>  [<ffffffff8020e4d3>] do_softirq+0x39/0x8e

 [<ffffffff80245cf5>] ksoftirqd+0x94/0xff

 [<ffffffff80245c61>] ? ksoftirqd+0x0/0xff

 [<ffffffff80254499>] kthread+0x49/0x78

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80239b33>] ? finish_task_switch+0x3b/0xe0

 [<ffffffff80254450>] ? kthread+0x0/0x78

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

Testing a saved backtrace.

The following trace is a kernel self test and not a bug!

 [<ffffffff802168c3>] save_stack_trace+0x2a/0x48

 [<ffffffff8026ea7b>] backtrace_regression_test+0xd6/0xf7

 [<ffffffff8020905c>] do_one_initcall+0x56/0x130

 [<ffffffff808b193a>] kernel_init+0x1a2/0x1f9

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffffffffffff>] 0xffffffffffffffff

====[ end of backtrace testing ]====

audit: initializing netlink socket (disabled)

type=2000 audit(1234879200.554:1): initialized

rcu-torture:--- Start of test: nreaders=8 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1

HugeTLB registered 2 MB page size, pre-allocated 0 pages

VFS: Disk quotas dquot_6.5.2

Dquot-cache hash table entries: 512 (order 0, 4096 bytes)

msgmni has been set to 7867

alg: No test for stdrng (krng)

io scheduler noop registered

io scheduler anticipatory registered

io scheduler deadline registered

io scheduler cfq registered (default)

pci 0000:00:08.0: Found enabled HT MSI Mapping

pci 0000:00:09.0: Found enabled HT MSI Mapping

pci 0000:00:0a.0: Found enabled HT MSI Mapping

pci 0000:00:0b.0: Found enabled HT MSI Mapping

pci_hotplug: PCI Hot Plug PCI Core version: 0.5

processor ACPI_CPU:00: registered as cooling_device0

ACPI: Processor [CPU0] (supports 8 throttling states)

processor ACPI_CPU:01: registered as cooling_device1

ACPI: Processor [CPU1] (supports 8 throttling states)

processor ACPI_CPU:02: registered as cooling_device2

ACPI: Processor [CPU2] (supports 8 throttling states)

processor ACPI_CPU:03: registered as cooling_device3

ACPI: Processor [CPU3] (supports 8 throttling states)

Real Time Clock Driver v1.12b

Non-volatile memory driver v1.3

Linux agpgart interface v0.103

Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled

serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

erial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

brd: module loaded

Uniform Multi-Platform E-IDE driver

ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports

ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

ide1 at 0x170-0x177,0x376 on irq 15

ide-gd driver 1.18

PNP: No PS/2 controller found. Probing ports directly.

serio: i8042 KBD port at 0x60,0x64 irq 1

serio: i8042 AUX port at 0x60,0x64 irq 12

mice: PS/2 mouse device common for all mice

cpuidle: using governor ladder

usbcore: registered new interface driver hiddev

usbcore: registered new interface driver usbhid

usbhid: v2.6:USB HID core driver

TCP bic registered

Initializing XFRM netlink socket

NET: Registered protocol family 17

powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 2218 processors (4 cpu cores) (version 2.20.00)

------------[ cut here ]------------

WARNING: at arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1255 powernowk8_cpu_init+0x493/0xd22()

Hardware name: BladeCenter LS21 -[79716AA]-

[Firmware Bug]: powernow-k8: Your BIOS does not provide ACPI _PSS objects in a way that Linux understands. Please report this to the Linux ACPI maintainers and complain to your BIOS vendor.

Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 [<ffffffff80240744>] warn_slowpath+0xd3/0xf2

 [<ffffffff80257ab3>] ? up+0x34/0x39

 [<ffffffff802606a9>] ? mark_held_locks+0x49/0x69

 [<ffffffff80527038>] ? __mutex_unlock_slowpath+0x117/0x123

 [<ffffffff802607fd>] ? trace_hardirqs_on_caller+0x134/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff8052704d>] ? mutex_unlock+0x9/0xb

 [<ffffffff803f26f0>] ? acpi_processor_register_performance+0x3a9/0x3da

 [<ffffffff802bffd2>] ? kmem_cache_alloc+0xcc/0xfa

 [<ffffffff802607fd>] ? trace_hardirqs_on_caller+0x134/0x15f

 [<ffffffff8039be94>] ? __bitmap_weight+0x78/0x8d

 [<ffffffff8051eed2>] powernowk8_cpu_init+0x493/0xd22

 [<ffffffff8025f25a>] ? lockdep_init_map+0x9c/0x467

 [<ffffffff8047dadc>] ? lock_policy_rwsem_write+0x46/0xaf

 [<ffffffff8047dec5>] cpufreq_add_dev+0x1c6/0x7af

 [<ffffffff80262e82>] ? __lock_acquire+0x773/0x7de

 [<ffffffff802606a9>] ? mark_held_locks+0x49/0x69

 [<ffffffff8052774f>] ? mutex_lock_nested+0x29b/0x2b4

 [<ffffffff802607fd>] ? trace_hardirqs_on_caller+0x134/0x15f

 [<ffffffff8025e753>] ? debug_mutex_free_waiter+0x53/0x57

 [<ffffffff8052775b>] ? mutex_lock_nested+0x2a7/0x2b4

 [<ffffffff80425df0>] ? sysdev_driver_register+0x75/0x10d

 [<ffffffff80425e2a>] sysdev_driver_register+0xaf/0x10d

 [<ffffffff8047cb95>] cpufreq_register_driver+0xc7/0x1f6

 [<ffffffff8051ea33>] powernowk8_init+0xc5/0xd1

 [<ffffffff8051e96e>] ? powernowk8_init+0x0/0xd1

 [<ffffffff8020905c>] do_one_initcall+0x56/0x130

 [<ffffffff80282dc4>] ? register_irq_proc+0xae/0xca

 [<ffffffff80300000>] ? writenote+0x8b/0xb8

 [<ffffffff808b193a>] kernel_init+0x1a2/0x1f9

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80257a8e>] ? up+0xf/0x39

 [<ffffffff808b1798>] ? kernel_init+0x0/0x1f9

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

---[ end trace dd3dd2a755e71b32 ]---

registered taskstats version 1

debug: unmapping init memory ffffffff808b1000..ffffffff8091c000

Write protecting the kernel read-only data: 4820k

Testing CPA: undo ffffffff80209000-ffffffff806be000

Testing CPA: again

Red Hat nash version 5.1.19.6 starting

Mounting proc filesystem

Mounting sysfs filesystem

Creating /dev

Creating initial device nodes

Setting up hotplug.

Creating block device nodes.

Louhci_hcd: USB Universal Host Controller Interface driver

ading uhci-hcd.kohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver

o module

LoadinACPI: PCI Interrupt Link [LPUS] enabled at IRQ 5

g ohci-hcd.ko moohci_hcd 0000:00:03.0: PCI INT A -> Link[LPUS] -> GSI 5 (level, low) -> IRQ 5

dule

ohci_hcd 0000:00:03.0: OHCI Host Controller

ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1

ohci_hcd 0000:00:03.0: irq 5, io mem 0xf3fff000

usb usb1: configuration #1 chosen from 1 choice

hub 1-0:1.0: USB hub found

hub 1-0:1.0: 2 ports detected

ohci_hcd 0000:00:03.1: PCI INT A -> Link[LPUS] -> GSI 5 (level, low) -> IRQ 5

ohci_hcd 0000:00:03.1: OHCI Host Controller

ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2

ohci_hcd 0000:00:03.1: irq 5, io mem 0xf3ffe000

usb usb2: configuration #1 chosen from 1 choice

hub 2-0:1.0: USB hub found

hub 2-0:1.0: 2 ports detected

Loading ehci-hcdehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver

.ko module

Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after

ehci_hcd 0000:00:03.2: PCI INT A -> Link[LPUS] -> GSI 5 (level, low) -> IRQ 5

ehci_hcd 0000:00:03.2: EHCI Host Controller

ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 3

ehci_hcd 0000:00:03.2: irq 5, io mem 0xf3ffd000

ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00

usb usb3: configuration #1 chosen from 1 choice

hub 3-0:1.0: USB hub found

hub 3-0:1.0: 4 ports detected

Loading jbd.ko module

Loading ext3.ko module

Loading scsi_mod.ko module

SCSI subsystem initialized

Loading sd_mod.ko module

Driver 'sd' needs updating - please use bus_type methods

Loading scsi_transport_sas.ko module

Loading mptbase.ko module

Fusion MPT base driver 3.04.07

Copyright (c) 1999-2008 LSI Corporation

Loading mptscsih.ko module

Loading mptsas.ko module

Fusion MPT SAS Host driver 3.04.07

ACPI: PCI Interrupt Link [LP03] enabled at IRQ 9

mptsas 0000:03:04.0: PCI INT A -> Link[LP03] -> GSI 9 (level, low) -> IRQ 9

mptbase: ioc0: Initiating bringup

ioc0: LSISAS1064 A3: Capabilities={Initiator}

usb 3-4: new high speed USB device using ehci_hcd and address 2

usb 3-4: configuration #1 chosen from 1 choice

hub 3-4:1.0: USB hub found

hub 3-4:1.0: 2 ports detected

ODEBUG: object is on stack, but not annotated

------------[ cut here ]------------

WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2bb/0x34d()

Hardware name: BladeCenter LS21 -[79716AA]-

Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd

Pid: 20, comm: work_on_cpu/0 Tainted: G        W  2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 [<ffffffff80240744>] warn_slowpath+0xd3/0xf2

 [<ffffffff8039864e>] ? number+0x115/0x21f

 [<ffffffff80529000>] ? _read_lock_irq+0x35/0x41

 [<ffffffff80529100>] ? _read_lock_irqsave+0x47/0x4d

 [<ffffffff80353336>] ? zisofs_readpage+0x178/0x92e

 [<ffffffff8024154f>] ? printk+0x67/0x69

 [<ffffffff803a984d>] ? __debug_object_init+0xd8/0x34d

 [<ffffffff803a9a30>] __debug_object_init+0x2bb/0x34d

 [<ffffffff803a9aef>] debug_object_init+0x14/0x19

 [<ffffffff8024a1bf>] init_timer_key+0x22/0x38

 [<ffffffffa009d9e3>] mpt_config+0x160/0x289 [mptbase]

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffffa009e421>] mpt_findImVolumes+0x88/0x76a [mptbase]

 [<ffffffff80249813>] ? destroy_timer_on_stack+0x10/0x12

 [<ffffffff80526cbd>] ? schedule_timeout+0xb1/0xcd

 [<ffffffff80249deb>] ? process_timeout+0x0/0xb

 [<ffffffff80526cf2>] ? schedule_timeout_uninterruptible+0x19/0x1b

 [<ffffffff8024a23c>] ? msleep+0x14/0x1e

 [<ffffffffa009b237>] ? WaitForDoorbellInt+0x3f/0x91 [mptbase]

 [<ffffffff8052918e>] ? _spin_unlock_irqrestore+0x3f/0x47

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff8025e6c7>] ? debug_mutex_init+0x31/0x3d

 [<ffffffffa009f1f4>] mpt_do_ioc_recovery+0x6f1/0x16ab [mptbase]

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529037>] ? _spin_unlock_irq+0x2b/0x31

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80529037>] ? _spin_unlock_irq+0x2b/0x31

 [<ffffffff80526a67>] ? wait_for_common+0xd1/0x11e

 [<ffffffff80526aa2>] ? wait_for_common+0x10c/0x11e

 [<ffffffff80236f84>] ? default_wake_function+0x0/0xf

 [<ffffffff8025443d>] ? kthread_create+0x104/0x117

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff8025f723>] ? trace_hardirqs_off+0xd/0xf

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529187>] ? _spin_unlock_irqrestore+0x38/0x47

 [<ffffffff8052918e>] ? _spin_unlock_irqrestore+0x3f/0x47

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff803977e3>] ? __up_read+0x7a/0x83

 [<ffffffff80257434>] ? up_read+0x26/0x2b

 [<ffffffff803b3af6>] ? pci_get_slot+0x4b/0x90

 [<ffffffffa00a1ea9>] mpt_attach+0x994/0xb07 [mptbase]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffffa00bb941>] mptsas_probe+0x1a/0x439 [mptsas]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffff803b2c3e>] local_pci_probe+0x12/0x16

 [<ffffffff802506ca>] do_work_for_cpu+0x13/0x1b

 [<ffffffff80250911>] run_workqueue+0x12c/0x236

 [<ffffffff802508ba>] ? run_workqueue+0xd5/0x236

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff802516d4>] worker_thread+0xdb/0xe8

 [<ffffffff802545bc>] ? autoremove_wake_function+0x0/0x38

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff80254499>] kthread+0x49/0x78

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80239b33>] ? finish_task_switch+0x3b/0xe0

 [<ffffffff80254450>] ? kthread+0x0/0x78

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

---[ end trace dd3dd2a755e71b34 ]---

ODEBUG: object is on stack, but not annotated

------------[ cut here ]------------

WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2bb/0x34d()

Hardware name: BladeCenter LS21 -[79716AA]-

Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd

Pid: 20, comm: work_on_cpu/0 Tainted: G        W  2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 [<ffffffff80240744>] warn_slowpath+0xd3/0xf2

 [<ffffffff8039864e>] ? number+0x115/0x21f

 [<ffffffff80529000>] ? _read_lock_irq+0x35/0x41

 [<ffffffff80529100>] ? _read_lock_irqsave+0x47/0x4d

 [<ffffffff8024154f>] ? printk+0x67/0x69

 [<ffffffff803a984d>] ? __debug_object_init+0xd8/0x34d

 [<ffffffff803a9a30>] __debug_object_init+0x2bb/0x34d

 [<ffffffff803a9aef>] debug_object_init+0x14/0x19

 [<ffffffff8024a1bf>] init_timer_key+0x22/0x38

 [<ffffffffa009d9e3>] mpt_config+0x160/0x289 [mptbase]

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffffa009e5c6>] mpt_findImVolumes+0x22d/0x76a [mptbase]

 [<ffffffff80249813>] ? destroy_timer_on_stack+0x10/0x12

 [<ffffffff80526cbd>] ? schedule_timeout+0xb1/0xcd

 [<ffffffff80249deb>] ? process_timeout+0x0/0xb

 [<ffffffff80526cf2>] ? schedule_timeout_uninterruptible+0x19/0x1b

 [<ffffffff8024a23c>] ? msleep+0x14/0x1e

 [<ffffffffa009b237>] ? WaitForDoorbellInt+0x3f/0x91 [mptbase]

 [<ffffffffa00a02f3>] ? mpt_timer_expired+0x0/0x2d [mptbase]

 [<ffffffffa009f1f4>] mpt_do_ioc_recovery+0x6f1/0x16ab [mptbase]

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529037>] ? _spin_unlock_irq+0x2b/0x31

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80529037>] ? _spin_unlock_irq+0x2b/0x31

 [<ffffffff80526a67>] ? wait_for_common+0xd1/0x11e

 [<ffffffff80526aa2>] ? wait_for_common+0x10c/0x11e

 [<ffffffff80236f84>] ? default_wake_function+0x0/0xf

 [<ffffffff8025443d>] ? kthread_create+0x104/0x117

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff8025f723>] ? trace_hardirqs_off+0xd/0xf

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529187>] ? _spin_unlock_irqrestore+0x38/0x47

 [<ffffffff8052918e>] ? _spin_unlock_irqrestore+0x3f/0x47

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff803977e3>] ? __up_read+0x7a/0x83

 [<ffffffff80257434>] ? up_read+0x26/0x2b

 [<ffffffff803b3af6>] ? pci_get_slot+0x4b/0x90

 [<ffffffffa00a1ea9>] mpt_attach+0x994/0xb07 [mptbase]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffffa00bb941>] mptsas_probe+0x1a/0x439 [mptsas]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffff803b2c3e>] local_pci_probe+0x12/0x16

 [<ffffffff802506ca>] do_work_for_cpu+0x13/0x1b

 [<ffffffff80250911>] run_workqueue+0x12c/0x236

 [<ffffffff802508ba>] ? run_workqueue+0xd5/0x236

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff802516d4>] worker_thread+0xdb/0xe8

 [<ffffffff802545bc>] ? autoremove_wake_function+0x0/0x38

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff80254499>] kthread+0x49/0x78

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80239b33>] ? finish_task_switch+0x3b/0xe0

 [<ffffffff80254450>] ? kthread+0x0/0x78

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

---[ end trace dd3dd2a755e71b35 ]---

ODEBUG: object is on stack, but not annotated

------------[ cut here ]------------

WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2bb/0x34d()

Hardware name: BladeCenter LS21 -[79716AA]-

Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd

Pid: 20, comm: work_on_cpu/0 Tainted: G        W  2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 [<ffffffff80240744>] warn_slowpath+0xd3/0xf2

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff8029ada6>] ? free_hot_page+0xb/0xd

 [<ffffffff8029b15c>] ? __free_pages+0x23/0x2c

 [<ffffffff8029b1aa>] ? free_pages+0x45/0x4a

 [<ffffffff80224fb4>] ? gart_free_coherent+0x37/0x3c

 [<ffffffff8024154f>] ? printk+0x67/0x69

 [<ffffffff803a984d>] ? __debug_object_init+0xd8/0x34d

 [<ffffffff803a9a30>] __debug_object_init+0x2bb/0x34d

 [<ffffffff803a9aef>] debug_object_init+0x14/0x19

 [<ffffffff8024a1bf>] init_timer_key+0x22/0x38

 [<ffffffffa009d9e3>] mpt_config+0x160/0x289 [mptbase]

 [<ffffffffa009fc88>] mpt_do_ioc_recovery+0x1185/0x16ab [mptbase]

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529037>] ? _spin_unlock_irq+0x2b/0x31

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80529037>] ? _spin_unlock_irq+0x2b/0x31

 [<ffffffff80526a67>] ? wait_for_common+0xd1/0x11e

 [<ffffffff80526aa2>] ? wait_for_common+0x10c/0x11e

 [<ffffffff80236f84>] ? default_wake_function+0x0/0xf

 [<ffffffff8025443d>] ? kthread_create+0x104/0x117

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff8025f723>] ? trace_hardirqs_off+0xd/0xf

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529187>] ? _spin_unlock_irqrestore+0x38/0x47

 [<ffffffff8052918e>] ? _spin_unlock_irqrestore+0x3f/0x47

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff803977e3>] ? __up_read+0x7a/0x83

 [<ffffffff80257434>] ? up_read+0x26/0x2b

 [<ffffffff803b3af6>] ? pci_get_slot+0x4b/0x90

 [<ffffffffa00a1ea9>] mpt_attach+0x994/0xb07 [mptbase]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffffa00bb941>] mptsas_probe+0x1a/0x439 [mptsas]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffff803b2c3e>] local_pci_probe+0x12/0x16

 [<ffffffff802506ca>] do_work_for_cpu+0x13/0x1b

 [<ffffffff80250911>] run_workqueue+0x12c/0x236

 [<ffffffff802508ba>] ? run_workqueue+0xd5/0x236

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff802516d4>] worker_thread+0xdb/0xe8

 [<ffffffff802545bc>] ? autoremove_wake_function+0x0/0x38

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff80254499>] kthread+0x49/0x78

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80239b33>] ? finish_task_switch+0x3b/0xe0

 [<ffffffff80254450>] ? kthread+0x0/0x78

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

---[ end trace dd3dd2a755e71b36 ]---

ODEBUG: object is on stack, but not annotated

------------[ cut here ]------------

WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2bb/0x34d()

Hardware name: BladeCenter LS21 -[79716AA]-

Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd

Pid: 20, comm: work_on_cpu/0 Tainted: G        W  2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 [<ffffffff80240744>] warn_slowpath+0xd3/0xf2

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff8029ada6>] ? free_hot_page+0xb/0xd

 [<ffffffff8029b15c>] ? __free_pages+0x23/0x2c

 [<ffffffff8024154f>] ? printk+0x67/0x69

 [<ffffffff803a984d>] ? __debug_object_init+0xd8/0x34d

 [<ffffffff803a9a30>] __debug_object_init+0x2bb/0x34d

 [<ffffffff803a9aef>] debug_object_init+0x14/0x19

 [<ffffffff8024a1bf>] init_timer_key+0x22/0x38

 [<ffffffffa009d9e3>] mpt_config+0x160/0x289 [mptbase]

 [<ffffffff8029ada6>] ? free_hot_page+0xb/0xd

 [<ffffffff8029b15c>] ? __free_pages+0x23/0x2c

 [<ffffffff8029b1aa>] ? free_pages+0x45/0x4a

 [<ffffffffa009fe59>] mpt_do_ioc_recovery+0x1356/0x16ab [mptbase]

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529037>] ? _spin_unlock_irq+0x2b/0x31

 [<ffffffffa00a02f3>] ? mpt_timer_expired+0x0/0x2d [mptbase]

 [<ffffffff8025443d>] ? kthread_create+0x104/0x117

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff8025f723>] ? trace_hardirqs_off+0xd/0xf

 [<ffffffff80223c0f>] ? flat_send_IPI_mask+0x78/0x8a

 [<ffffffff80529187>] ? _spin_unlock_irqrestore+0x38/0x47

 [<ffffffff8052918e>] ? _spin_unlock_irqrestore+0x3f/0x47

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff803977e3>] ? __up_read+0x7a/0x83

 [<ffffffff80257434>] ? up_read+0x26/0x2b

 [<ffffffff803b3af6>] ? pci_get_slot+0x4b/0x90

 [<ffffffffa00a1ea9>] mpt_attach+0x994/0xb07 [mptbase]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffffa00bb941>] mptsas_probe+0x1a/0x439 [mptsas]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffff803b2c3e>] local_pci_probe+0x12/0x16

 [<ffffffff802506ca>] do_work_for_cpu+0x13/0x1b

 [<ffffffff80250911>] run_workqueue+0x12c/0x236

 [<ffffffff802508ba>] ? run_workqueue+0xd5/0x236

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff802516d4>] worker_thread+0xdb/0xe8

 [<ffffffff802545bc>] ? autoremove_wake_function+0x0/0x38

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff80254499>] kthread+0x49/0x78

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80239b33>] ? finish_task_switch+0x3b/0xe0

 [<ffffffff80254450>] ? kthread+0x0/0x78

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

---[ end trace dd3dd2a755e71b37 ]---

scsi0 : ioc0: LSISAS1064 A3, FwRev=000a0f00h, Ports=1, MaxQ=511, IRQ=9

ODEBUG: object is on stack, but not annotated

------------[ cut here ]------------

WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2bb/0x34d()

Hardware name: BladeCenter LS21 -[79716AA]-

Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd

Pid: 20, comm: work_on_cpu/0 Tainted: G        W  2.6.29-rc5-autotest-next-20090217 #1

Call Trace:

 [<ffffffff80240744>] warn_slowpath+0xd3/0xf2

 [<ffffffff80353634>] ? zisofs_readpage+0x476/0x92e

 [<ffffffff80398e8c>] ? string+0x3d/0xa2

 [<ffffffff80398e8c>] ? string+0x3d/0xa2

 [<ffffffff8024154f>] ? printk+0x67/0x69

 [<ffffffff803a984d>] ? __debug_object_init+0xd8/0x34d

 [<ffffffff803a9a30>] __debug_object_init+0x2bb/0x34d

 [<ffffffff803a9aef>] debug_object_init+0x14/0x19

 [<ffffffff8024a1bf>] init_timer_key+0x22/0x38

 [<ffffffffa009d9e3>] mpt_config+0x160/0x289 [mptbase]

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffffa00ba388>] mptsas_probe_hba_phys+0x8e/0x8b3 [mptsas]

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff8030ed27>] ? proc_register+0xb9/0x11a

 [<ffffffff8025f723>] ? trace_hardirqs_off+0xd/0xf

 [<ffffffff8052774f>] ? mutex_lock_nested+0x29b/0x2b4

 [<ffffffff802606e8>] ? trace_hardirqs_on_caller+0x1f/0x15f

 [<ffffffff8052775b>] ? mutex_lock_nested+0x2a7/0x2b4

 [<ffffffffa00bbcbf>] ? mptsas_probe+0x398/0x439 [mptsas]

 [<ffffffffa00bbcc7>] mptsas_probe+0x3a0/0x439 [mptsas]

 [<ffffffff802506b7>] ? do_work_for_cpu+0x0/0x1b

 [<ffffffff803b2c3e>] local_pci_probe+0x12/0x16

 [<ffffffff802506ca>] do_work_for_cpu+0x13/0x1b

 [<ffffffff80250911>] run_workqueue+0x12c/0x236

 [<ffffffff802508ba>] ? run_workqueue+0xd5/0x236

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff80260835>] ? trace_hardirqs_on+0xd/0xf

 [<ffffffff802516d4>] worker_thread+0xdb/0xe8

 [<ffffffff802545bc>] ? autoremove_wake_function+0x0/0x38

 [<ffffffff802515f9>] ? worker_thread+0x0/0xe8

 [<ffffffff80254499>] kthread+0x49/0x78

 [<ffffffff8020ceda>] child_rip+0xa/0x20

 [<ffffffff8020c8fc>] ? restore_args+0x0/0x30

 [<ffffffff80239b33>] ? finish_task_switch+0x3b/0xe0

 [<ffffffff80254450>] ? kthread+0x0/0x78

 [<ffffffff8020ced0>] ? child_rip+0x0/0x20

---[ end trace dd3dd2a755e71b38 ]---

scsi 0:0:0:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5

sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors: (73.4 GB/68.3 GiB)

sd 0:0:0:0: [sda] Write Protect is off

sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors: (73.4 GB/68.3 GiB)

sd 0:0:0:0: [sda] Write Protect is off

sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >

sd 0:0:0:0: [sda] Attached SCSI disk

Loading usb-storInitializing USB Mass Storage driver...

age.ko module

usbcore: registered new interface driver usb-storage

USB Mass Storage support registered.

Waiting for driver initialization.

Waiting for driver initialization.

Scanning and configuring dmraid supported devices

Creating root device.

Mounting root filesystem.

kjournald starting.  Commit interval 5 seconds

EXT3-fs: mounted filesystem with ordered data mode.

Setting up other filesystems.

Setting up new root fs

no fstab.sys, mounting internal defaults

Switching to new root and running init.

unmounting old /dev

unmounting old /proc

unmounting old /sys


INIT: version 2.86 booting


                Welcome to Red Hat Enterprise Linux Server

                Press 'I' to enter interactive startup.

Setting clock  (utc): Tue Feb 17 19:31:00 IST 2009 [  OK  ]


Starting udev: [  OK  ]


Loading default keymap (us): [  OK  ]


Setting hostname ls21b:  [  OK  ]


No devices found

Setting up Logical Volume Management:   No volume groups found

[  OK  ]


Checking filesystems

Checking all file systems.

[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda1 

/1: clean, 599737/10246368 files, 6014197/10239421 blocks

[  OK  ]


Remounting root filesystem in read-write mode:  [  OK  ]


Mounting local filesystems:  [  OK  ]


Enabling local filesystem quotas:  [  OK  ]


Enabling /etc/fstab swaps:  [  OK  ]


INIT: Entering runlevel: 3


Entering non-interactive startup

Starting background readahead: [  OK  ]


Applying ip6tables firewall rules: [  OK  ]


Bringing up loopback interface:  [  OK  ]


Bringing up interface eth1:  [  OK  ]


Starting auditd: [  OK  ]


Starting system logger: [  OK  ]


Starting kernel logger: [  OK  ]


Starting irqbalance: [  OK  ]


Starting portmap: [  OK  ]


Starting NFS statd: [  OK  ]


Starting RPC idmapd: FATAL: Module sunrpc not found.

FATAL: Error running install command for sunrpc

Error: RPC MTAB does not exist.

Starting system message bus: [  OK  ]


Starting Bluetooth services:[  OK  ]
[  OK  ]


Mounting other filesystems:  [  OK  ]


Starting PC/SC smart card daemon (pcscd): [  OK  ]


Starting hidd: [  OK  ]


Starting autofs:  Loading autofs4: [  OK  ]


Starting automount: [  OK  ]


[  OK  ]


Starting acpi daemon: [  OK  ]


Starting sshd: [  OK  ]


Starting cups: [  OK  ]


Starting xinetd: [  OK  ]


Starting sendmail: [  OK  ]


Starting sm-client: [  OK  ]


Starting console mouse services: [  OK  ]


Starting crond: [  OK  ]


Starting xfs: [  OK  ]


Starting anacron: [  OK  ]


Starting atd: [  OK  ]


Starting yum-updatesd: [  OK  ]


Starting Avahi daemon... [  OK  ]


Starting HAL daemon: [  OK  ]


Starting smartd: [  OK  ]




Red Hat Enterprise Linux Server release 5.1 (Tikanga)

Kernel 2.6.29-rc5-autotest-next-20090217 on an x86_64



ls21b login: -- 0:conmux-control -- time-stamp -- Feb/17/09  6:02:53 --


--------------060107090106080902000302--
