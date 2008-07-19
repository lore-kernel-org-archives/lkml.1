Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYGSD27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYGSD27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 23:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYGSD2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 23:28:51 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:39479 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750704AbYGSD2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 23:28:48 -0400
Date: Fri, 18 Jul 2008 23:28:45 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080719032845.GA9662@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080718202118.GC24122@elte.hu> <86802c440807181326l489b7763sdb040f5b6e575d8c@mail.gmail.com> <20080719005849.GA9055@bromo.msbb.uc.edu> <86802c440807181822l5138ff85k7d8c2e2702a11025@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807181822l5138ff85k7d8c2e2702a11025@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   The mmconf_end_bus_num_detect.patch and mmconf_end_bus_num_detect_fix.patch both applied
cleanly to the current linus kernel git and solve my problems with MMCONFIG not starting.
I am attaching a dmesg log below of a boot with 'debug apic=verbose initcall_debug pci=routeirq'.
If you look at the section immediately before the line...

pci 0000:00:1e.0: transparent bridge

you will see that it is radically different from what I posted for the freeze under PCIEASPM
with MMCONFIG (using your original mmconfig patch)...

PCI: 0000:00:1f.1 reg 10 io port: [ 40d8, 40df]
PCI: 0000:00:1f.1 reg 14 io port: [ 40ec, 40ef]
PCI: 0000:00:1f.1 reg 18 io port: [ 40d0, 40d7]
PCI: 0000:00:1f.1 reg 1c io port: [ 40e8, 40eb]
PCI: 0000:00:1f.1 reg 20 io port: [ 40b0, 40bf]
pci 0000:00.1f.1: calling pci_fixup_transparent_bridge+0x0/0x2a
PCI: Found 0000:00:1f.2 [8086/27c4] 000101 00
PCI: 0000:00:1f.2 reg 10 io port: [ 40c8, 40cf]
PCI: 0000:00:1f.2 reg 14 io port: [ 40e4, 40e7]
PCI: 0000:00:1f.2 reg 18 io port: [ 40c0, 40c7]
PCI: 0000:00:1f.2 reg 1c io port: [ 40e0, 40e3]
PCI: 0000:00:1f.2 reg 20 io port: [ 40a0, 40af]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [d8405000, d84053ff]
pci: 0000:00:1f.2 calling pci_fixup_transparent_bridge+0x0/0x2a
PCI: Found 0000:00:1f.3 [8086/27da] 000c05 00
PCI: 0000:00:1f.3 reg 20 io port: [ efa0, efbf]
PCI: 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
PCI: Fixups for bus 0000:00
PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0
PCI: Scanning bus 0000:01
PCI: Found 0000:01:00.0 [1002/71c5] 000300 00
PCI: 0000:00:01:00.0 reg 10 32bit mmio: [c0000000, cfffffff]
PCI: 0000:00:01:00.0 reg 14 io port: [ 3000, 30ff]
PCI: 0000:00:01:00.0 reg 18 32bit mmio: [d8300000, d830ffff]

Perhaps one of the PCIEASPM experts can explain why there are so
many calls to pci_fixup_transparent_bridge and a scan behind the bridge.
Nothing like that appears in the dmesg from your latest patch without
PCIEASPM.
                          Jack

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27-0.156.rc0.git4.fc9.x86_64 (howarth@localhost.localdomain) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Fri Jul 18 22:02:40 EDT 2008
Command line: ro root=UUID=81966632-17b2-4377-929d-dc1e867e4d6d rhgb debug apic=verbose initcall_debug pci=routeirq
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf0e9000 (usable)
 BIOS-e820: 00000000bf0e9000 - 00000000bf2ea000 (ACPI NVS)
 BIOS-e820: 00000000bf2ea000 - 00000000bfebe000 (ACPI data)
 BIOS-e820: 00000000bfebe000 - 00000000bfeef000 (ACPI NVS)
 BIOS-e820: 00000000bfeef000 - 00000000bff00000 (ACPI data)
 BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
last_pfn = 0xbf0e9 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 00bf000000 page 2M
 00bf000000 - 00bf0e9000 page 4k
kernel direct mapping tables up to bf0e9000 @ 8000-d000
last_map_addr: bf0e9000 end: bf0e9000
RAMDISK: 37d35000 - 37fef5d1
DMI 2.4 present.
ACPI: RSDP 000FE020, 0024 (r2 APPLE )
ACPI: XSDT BFEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
ACPI: FACP BFEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
ACPI: DSDT BFEF0000, 48BD (r1 APPLE  MacBookP    20001 INTL 20050309)
ACPI: FACS BFEC0000, 0040
ACPI: HPET BFEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: APIC BFEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: MCFG BFEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ASF! BFEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
ACPI: SBST BFEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ECDT BFEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: SSDT BFEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
ACPI: SSDT BFEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
ACPI: SSDT BFEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
ACPI: DMI detected: Apple
No NUMA configuration found
Faking a node at 0000000000000000-00000000bf0e9000
Entering add_active_range(0, 0x0, 0x9f) 0 entries of 25600 used
Entering add_active_range(0, 0x100, 0xbf0e9) 1 entries of 25600 used
Bootmem setup node 0 0000000000000000-00000000bf0e9000
  NODE_DATA [000000000000b000 - 000000000001ffff]
  bootmap [0000000000020000 -  0000000000037e1f] pages 18
(6 early reservations) ==> bootmem
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000e5fe68]    TEXT DATA BSS ==> [0000200000 - 0000e5fe68]
  #3 [0037d35000 - 0037fef5d1]          RAMDISK ==> [0037d35000 - 0037fef5d1]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
 [ffffe20000000000-ffffe200047fffff] PMD -> [ffff880001200000-ffff8800059fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000bf0e9
On node 0 totalpages: 782472
  DMA zone: 96 pages used for memmap
  DMA zone: 3269 pages reserved
  DMA zone: 634 pages, LIFO batch:0
  DMA32 zone: 18246 pages used for memmap
  DMA32 zone: 760227 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffffffff5fc000 (        fee00000)
mapped IOAPIC to ffffffffff5fb000 (00000000fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
PERCPU: Allocating 442304 bytes of per cpu data
NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 760861
Policy zone: DMA32
Kernel command line: ro root=UUID=81966632-17b2-4377-929d-dc1e867e4d6d rhgb debug apic=verbose initcall_debug pci=routeirq
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 2327.490 MHz processor.
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
 memory used by lock dependency info: 1840 kB
 per task-struct memory footprint: 3456 bytes
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 3039268k/3130276k available (3099k kernel code, 90620k reserved, 1746k data, 1544k init)
CPA: page pool initialized 48 of 48 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. <6>4654.98 BogoMIPS (lpj=2327490)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080609
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 1-0 not connected.
IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 1-16, 1-17, 1-18, 1-19, 1-20, 1-21, 1-22, 1-23 not connected.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
Using local APIC timer interrupts.
APIC timer calibration result 10390580
Detected 10.390 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. <6>4654.79 BogoMIPS (lpj=2327398)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (9309.77 BogoMIPS).
sizeof(vma)=176 bytes
sizeof(page)=96 bytes
sizeof(inode)=1088 bytes
sizeof(dentry)=256 bytes
sizeof(ext3inode)=1488 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=9528 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
khelper used greatest stack depth: 5648 bytes left
calling  init_cpufreq_transition_notifier_list+0x0/0x20
initcall init_cpufreq_transition_notifier_list+0x0/0x20 returned 0 after 0 msecs
calling  net_ns_init+0x0/0x134
net_namespace: 1352 bytes
initcall net_ns_init+0x0/0x134 returned 0 after 0 msecs
calling  cpufreq_tsc+0x0/0x16
initcall cpufreq_tsc+0x0/0x16 returned 0 after 0 msecs
calling  init_smp_flush+0x0/0x6b
initcall init_smp_flush+0x0/0x6b returned 0 after 0 msecs
calling  print_banner+0x0/0x13
Booting paravirtualized kernel on bare hardware
initcall print_banner+0x0/0x13 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x37
initcall sysctl_init+0x0/0x37 returned 0 after 0 msecs
calling  ksysfs_init+0x0/0xc0
initcall ksysfs_init+0x0/0xc0 returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x17
initcall init_jiffies_clocksource+0x0/0x17 returned 0 after 0 msecs
calling  pm_init+0x0/0x39
initcall pm_init+0x0/0x39 returned 0 after 0 msecs
calling  pm_disk_init+0x0/0x1e
initcall pm_disk_init+0x0/0x1e returned 0 after 0 msecs
calling  swsusp_header_init+0x0/0x31
initcall swsusp_header_init+0x0/0x31 returned 0 after 0 msecs
calling  ftrace_dynamic_init+0x0/0xd7
initcall ftrace_dynamic_init+0x0/0xd7 returned 0 after 0 msecs
calling  filelock_init+0x0/0x33
initcall filelock_init+0x0/0x33 returned 0 after 0 msecs
calling  init_misc_binfmt+0x0/0x44
initcall init_misc_binfmt+0x0/0x44 returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x17
initcall init_script_binfmt+0x0/0x17 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x17
initcall init_elf_binfmt+0x0/0x17 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x17
initcall init_compat_elf_binfmt+0x0/0x17 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x56
initcall debugfs_init+0x0/0x56 returned 0 after 0 msecs
calling  securityfs_init+0x0/0x56
initcall securityfs_init+0x0/0x56 returned 0 after 0 msecs
calling  random32_init+0x0/0x5f
initcall random32_init+0x0/0x5f returned 0 after 0 msecs
calling  early_resume_init+0x0/0x1d4
Time:  3:06:17  Date: 07/19/08
initcall early_resume_init+0x0/0x1d4 returned 0 after 0 msecs
calling  cpufreq_core_init+0x0/0x8f
initcall cpufreq_core_init+0x0/0x8f returned 0 after 0 msecs
calling  cpuidle_init+0x0/0x45
initcall cpuidle_init+0x0/0x45 returned 0 after 0 msecs
calling  sock_init+0x0/0x63
initcall sock_init+0x0/0x63 returned 0 after 0 msecs
calling  netpoll_init+0x0/0x46
initcall netpoll_init+0x0/0x46 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x150
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x150 returned 0 after 0 msecs
calling  bdi_class_init+0x0/0x42
initcall bdi_class_init+0x0/0x42 returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x47
initcall kobject_uevent_init+0x0/0x47 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x17
initcall pcibus_class_init+0x0/0x17 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x17
initcall pci_driver_init+0x0/0x17 returned 0 after 0 msecs
calling  backlight_class_init+0x0/0x4e
initcall backlight_class_init+0x0/0x4e returned 0 after 0 msecs
calling  dock_init+0x0/0x5f
No dock devices found.
initcall dock_init+0x0/0x5f returned 0 after 0 msecs
calling  tty_class_init+0x0/0x2f
initcall tty_class_init+0x0/0x2f returned 0 after 0 msecs
calling  vtconsole_class_init+0x0/0xbf
khelper used greatest stack depth: 4904 bytes left
initcall vtconsole_class_init+0x0/0xbf returned 0 after 0 msecs
calling  register_node_type+0x0/0x83
initcall register_node_type+0x0/0x83 returned 0 after 0 msecs
calling  enable_pci_io_ecs+0x0/0x33
initcall enable_pci_io_ecs+0x0/0x33 returned 0 after 0 msecs
calling  early_fill_mp_bus_info+0x0/0x80c
initcall early_fill_mp_bus_info+0x0/0x80c returned 0 after 0 msecs
calling  arch_kdebugfs_init+0x0/0x1e0
initcall arch_kdebugfs_init+0x0/0x1e0 returned 0 after 0 msecs
calling  mtrr_if_init+0x0/0x7e
initcall mtrr_if_init+0x0/0x7e returned 0 after 0 msecs
calling  ffh_cstate_init+0x0/0x36
initcall ffh_cstate_init+0x0/0x36 returned 0 after 0 msecs
calling  acpi_pci_init+0x0/0x45
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x45 returned 0 after 0 msecs
calling  init_acpi_device_notify+0x0/0x50
initcall init_acpi_device_notify+0x0/0x50 returned 0 after 0 msecs
calling  dmi_id_init+0x0/0x2f1
initcall dmi_id_init+0x0/0x2f1 returned 0 after 0 msecs
calling  pci_arch_init+0x0/0x53
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in E820
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x53 returned 0 after 14 msecs
calling  topology_init+0x0/0x96
initcall topology_init+0x0/0x96 returned 0 after 0 msecs
calling  mtrr_init_finialize+0x0/0x42
initcall mtrr_init_finialize+0x0/0x42 returned 0 after 0 msecs
calling  param_sysfs_init+0x0/0x1f3
initcall param_sysfs_init+0x0/0x1f3 returned 0 after 9 msecs
calling  pm_sysrq_init+0x0/0x1e
initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 msecs
calling  readahead_init+0x0/0x3d
initcall readahead_init+0x0/0x3d returned 0 after 0 msecs
calling  init_bio+0x0/0xca
initcall init_bio+0x0/0xca returned 0 after 0 msecs
calling  integrity_init+0x0/0x3f
initcall integrity_init+0x0/0x3f returned 0 after 0 msecs
calling  blk_settings_init+0x0/0x2f
initcall blk_settings_init+0x0/0x2f returned 0 after 0 msecs
calling  blk_ioc_init+0x0/0x2f
initcall blk_ioc_init+0x0/0x2f returned 0 after 0 msecs
calling  genhd_device_init+0x0/0x5a
initcall genhd_device_init+0x0/0x5a returned 0 after 0 msecs
calling  blk_dev_integrity_init+0x0/0x2f
initcall blk_dev_integrity_init+0x0/0x2f returned 0 after 0 msecs
calling  pci_slot_init+0x0/0x4c
initcall pci_slot_init+0x0/0x4c returned 0 after 0 msecs
calling  fbmem_init+0x0/0x8f
initcall fbmem_init+0x0/0x8f returned 0 after 0 msecs
calling  acpi_init+0x0/0x226
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
initcall acpi_init+0x0/0x226 returned 0 after 25 msecs
calling  acpi_scan_init+0x0/0x10f
initcall acpi_scan_init+0x0/0x10f returned 0 after 52 msecs
calling  acpi_ec_init+0x0/0x66
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
initcall acpi_ec_init+0x0/0x66 returned 0 after 0 msecs
calling  acpi_pci_root_init+0x0/0x2d
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
PCI: 0000:00:07.0 reg 10 32bit mmio: [d8404000, d8404fff]
PCI: 0000:00:1b.0 reg 10 64bit mmio: [d8400000, d8403fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [4080, 409f]
PCI: 0000:00:1d.1 reg 20 io port: [4060, 407f]
PCI: 0000:00:1d.2 reg 20 io port: [4040, 405f]
PCI: 0000:00:1d.3 reg 20 io port: [4020, 403f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [d8405400, d84057ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: 0000:00:1f.1 reg 10 io port: [40d8, 40df]
PCI: 0000:00:1f.1 reg 14 io port: [40ec, 40ef]
PCI: 0000:00:1f.1 reg 18 io port: [40d0, 40d7]
PCI: 0000:00:1f.1 reg 1c io port: [40e8, 40eb]
PCI: 0000:00:1f.1 reg 20 io port: [40b0, 40bf]
PCI: 0000:00:1f.2 reg 10 io port: [40c8, 40cf]
PCI: 0000:00:1f.2 reg 14 io port: [40e4, 40e7]
PCI: 0000:00:1f.2 reg 18 io port: [40c0, 40c7]
PCI: 0000:00:1f.2 reg 1c io port: [40e0, 40e3]
PCI: 0000:00:1f.2 reg 20 io port: [40a0, 40af]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [d8405000, d84053ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 20 io port: [efa0, efbf]
PCI: 0000:01:00.0 reg 10 32bit mmio: [c0000000, cfffffff]
PCI: 0000:01:00.0 reg 14 io port: [3000, 30ff]
PCI: 0000:01:00.0 reg 18 32bit mmio: [d8300000, d830ffff]
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
PCI: bridge 0000:00:01.0 32bit mmio: [d8300000, d83fffff]
PCI: bridge 0000:00:01.0 64bit mmio pref: [c0000000, cfffffff]
PCI: 0000:02:00.0 reg 10 64bit mmio: [d8200000, d8203fff]
PCI: 0000:02:00.0 reg 18 io port: [2000, 20ff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
PCI: bridge 0000:00:1c.0 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.0 32bit mmio: [d8200000, d82fffff]
PCI: 0000:03:00.0 reg 10 64bit mmio: [d8100000, d810ffff]
pci 0000:03:00.0: supports D1
pci 0000:03:00.0: PME# supported from D0 D1 D3hot
pci 0000:03:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 32bit mmio: [d8100000, d81fffff]
PCI: bridge 0000:00:1c.2 io port: [1000, 1fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [d4100000, d80fffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [d0000000, d3ffffff]
PCI: 0000:0c:03.0 reg 10 32bit mmio: [d4004000, d40047ff]
PCI: 0000:0c:03.0 reg 14 32bit mmio: [d4000000, d4003fff]
pci 0000:0c:03.0: supports D1
pci 0000:0c:03.0: supports D2
pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:0c:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 32bit mmio: [d4000000, d40fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
initcall acpi_pci_root_init+0x0/0x2d returned 0 after 78 msecs
calling  acpi_pci_link_init+0x0/0x4d
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
initcall acpi_pci_link_init+0x0/0x4d returned 0 after 14 msecs
calling  acpi_power_init+0x0/0x7c
initcall acpi_power_init+0x0/0x7c returned 0 after 0 msecs
calling  acpi_system_init+0x0/0x265
initcall acpi_system_init+0x0/0x265 returned 0 after 0 msecs
calling  acpi_cm_sbs_init+0x0/0xd
initcall acpi_cm_sbs_init+0x0/0xd returned 0 after 0 msecs
calling  pnp_init+0x0/0x25
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall pnp_init+0x0/0x25 returned 0 after 0 msecs
calling  pnpacpi_init+0x0/0x91
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x91 returned 0 after 20 msecs
calling  misc_init+0x0/0x9d
initcall misc_init+0x0/0x9d returned 0 after 0 msecs
calling  cn_init+0x0/0xf3
initcall cn_init+0x0/0xf3 returned 0 after 0 msecs
calling  init_scsi+0x0/0x96
SCSI subsystem initialized
initcall init_scsi+0x0/0x96 returned 0 after 1 msecs
calling  ata_init+0x0/0x368
libata version 3.00 loaded.
initcall ata_init+0x0/0x368 returned 0 after 0 msecs
calling  init_pcmcia_cs+0x0/0x2d
initcall init_pcmcia_cs+0x0/0x2d returned 0 after 0 msecs
calling  usb_init+0x0/0x131
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x131 returned 0 after 1 msecs
calling  serio_init+0x0/0x8e
initcall serio_init+0x0/0x8e returned 0 after 0 msecs
calling  input_init+0x0/0x10c
initcall input_init+0x0/0x10c returned 0 after 0 msecs
calling  rtc_init+0x0/0x75
initcall rtc_init+0x0/0x75 returned 0 after 0 msecs
calling  power_supply_class_init+0x0/0x39
initcall power_supply_class_init+0x0/0x39 returned 0 after 0 msecs
calling  thermal_init+0x0/0x56
initcall thermal_init+0x0/0x56 returned 0 after 0 msecs
calling  md_init+0x0/0xd5
initcall md_init+0x0/0xd5 returned 0 after 0 msecs
calling  leds_init+0x0/0x2f
initcall leds_init+0x0/0x2f returned 0 after 0 msecs
calling  dma_bus_init+0x0/0x31
initcall dma_bus_init+0x0/0x31 returned 0 after 0 msecs
calling  pci_subsys_init+0x0/0x126
PCI: Using ACPI for IRQ routing
PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
IOAPIC[0]: Set routing entry (1-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
IOAPIC[0]: Set routing entry (1-22 -> 0x51 -> IRQ 22 Mode:1 Active:1)
pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
IOAPIC[0]: Set routing entry (1-17 -> 0x59 -> IRQ 17 Mode:1 Active:1)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
IOAPIC[0]: Set routing entry (1-18 -> 0x61 -> IRQ 18 Mode:1 Active:1)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
IOAPIC[0]: Set routing entry (1-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
IOAPIC[0]: Set routing entry (1-19 -> 0x71 -> IRQ 19 Mode:1 Active:1)
pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
number of MP IRQ sources: 15.
number of IO-APIC #1 registers: 24.
testing the IO APIC.......................

IO APIC #1......
.... register #00: 00000000
.......    : physical APIC id: 00
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
.... register #02: 00170020
.......     : arbitration: 00
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
 10 003 1    1    0   1   0    1    1    49
 11 003 1    1    0   1   0    1    1    59
 12 003 1    1    0   1   0    1    1    61
 13 003 1    1    0   1   0    1    1    71
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 003 1    1    0   1   0    1    1    51
 17 003 1    1    0   1   0    1    1    69
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
IRQ16 -> 0:16
IRQ17 -> 0:17
IRQ18 -> 0:18
IRQ19 -> 0:19
IRQ22 -> 0:22
IRQ23 -> 0:23
.................................... done.
initcall pci_subsys_init+0x0/0x126 returned 0 after 21 msecs
calling  proto_init+0x0/0x33
initcall proto_init+0x0/0x33 returned 0 after 0 msecs
calling  net_dev_init+0x0/0x1f3
initcall net_dev_init+0x0/0x1f3 returned 0 after 0 msecs
calling  neigh_init+0x0/0x76
initcall neigh_init+0x0/0x76 returned 0 after 0 msecs
calling  fib_rules_init+0x0/0xab
initcall fib_rules_init+0x0/0xab returned 0 after 0 msecs
calling  pktsched_init+0x0/0xc9
initcall pktsched_init+0x0/0xc9 returned 0 after 0 msecs
calling  tc_filter_init+0x0/0x51
initcall tc_filter_init+0x0/0x51 returned 0 after 0 msecs
calling  tc_action_init+0x0/0x51
initcall tc_action_init+0x0/0x51 returned 0 after 0 msecs
calling  genl_init+0x0/0xdd
initcall genl_init+0x0/0xdd returned 0 after 3 msecs
calling  cipso_v4_init+0x0/0x8d
initcall cipso_v4_init+0x0/0x8d returned 0 after 0 msecs
calling  wireless_nlevent_init+0x0/0x46
initcall wireless_nlevent_init+0x0/0x46 returned 0 after 0 msecs
calling  netlbl_init+0x0/0x86
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x86 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x32
initcall sysctl_init+0x0/0x32 returned 0 after 0 msecs
calling  pci_iommu_init+0x0/0x21
PCI-GART: No AMD northbridge found.
initcall pci_iommu_init+0x0/0x21 returned 0 after 0 msecs
calling  hpet_late_init+0x0/0x107
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
initcall hpet_late_init+0x0/0x107 returned 0 after 1 msecs
calling  clocksource_done_booting+0x0/0x17
initcall clocksource_done_booting+0x0/0x17 returned 0 after 0 msecs
calling  ftrace_init_debugfs+0x0/0xfd
initcall ftrace_init_debugfs+0x0/0xfd returned 0 after 0 msecs
calling  tracer_alloc_buffers+0x0/0x5a1
tracer: 1286 pages allocated for 65536 entries of 80 bytes
   actual entries 65586
initcall tracer_alloc_buffers+0x0/0x5a1 returned 0 after 19 msecs
calling  init_pipe_fs+0x0/0x51
initcall init_pipe_fs+0x0/0x51 returned 0 after 0 msecs
calling  init_mnt_writers+0x0/0x95
initcall init_mnt_writers+0x0/0x95 returned 0 after 0 msecs
calling  eventpoll_init+0x0/0x9a
initcall eventpoll_init+0x0/0x9a returned 0 after 0 msecs
calling  anon_inode_init+0x0/0x11c
initcall anon_inode_init+0x0/0x11c returned 0 after 0 msecs
calling  acpi_rtc_init+0x0/0xf9
ACPI: RTC can wake from S4
initcall acpi_rtc_init+0x0/0xf9 returned 0 after 0 msecs
calling  acpi_event_init+0x0/0x85
initcall acpi_event_init+0x0/0x85 returned 0 after 2 msecs
calling  pnp_system_init+0x0/0x17
system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:07: ioport range 0x680-0x6ef has been reserved
system 00:07: ioport range 0x800-0x80f has been reserved
system 00:07: ioport range 0x810-0x817 has been reserved
system 00:07: ioport range 0x400-0x47f has been reserved
system 00:07: ioport range 0x500-0x53f has been reserved
system 00:07: ioport range 0x1640-0x164f has been reserved
initcall pnp_system_init+0x0/0x17 returned 0 after 2 msecs
calling  chr_dev_init+0x0/0x9d
initcall chr_dev_init+0x0/0x9d returned 0 after 2 msecs
calling  firmware_class_init+0x0/0x77
initcall firmware_class_init+0x0/0x77 returned 0 after 0 msecs
calling  loopback_init+0x0/0x17
initcall loopback_init+0x0/0x17 returned 0 after 1 msecs
calling  init_pcmcia_bus+0x0/0x89
initcall init_pcmcia_bus+0x0/0x89 returned 0 after 0 msecs
calling  cpufreq_gov_performance_init+0x0/0x17
initcall cpufreq_gov_performance_init+0x0/0x17 returned 0 after 0 msecs
calling  cpufreq_gov_userspace_init+0x0/0x17
initcall cpufreq_gov_userspace_init+0x0/0x17 returned 0 after 0 msecs
calling  init_acpi_pm_clocksource+0x0/0xae
initcall init_acpi_pm_clocksource+0x0/0xae returned 0 after 0 msecs
calling  pcibios_assign_resources+0x0/0x8d
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x3000-0x3fff
pci 0000:00:01.0:   MEM window: 0xd8300000-0xd83fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xd8200000-0xd82fffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000d8500000-0x000000d85fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xd8100000-0xd81fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
pci 0000:00:1c.2:   MEM window: 0xd4100000-0xd80fffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000d0000000-0x000000d3ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xd4000000-0xd40fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
PCI: Setting latency timer of device 0000:00:1e.0 to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 io port: [3000, 3fff]
bus: 01 index 1 mmio: [d8300000, d83fffff]
bus: 01 index 2 mmio: [c0000000, cfffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [2000, 2fff]
bus: 02 index 1 mmio: [d8200000, d82fffff]
bus: 02 index 2 mmio: [d8500000, d85fffff]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [d8100000, d81fffff]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 io port: [1000, 1fff]
bus: 04 index 1 mmio: [d4100000, d80fffff]
bus: 04 index 2 mmio: [d0000000, d3ffffff]
bus: 04 index 3 mmio: [0, 0]
bus: 0c index 0 mmio: [0, 0]
bus: 0c index 1 mmio: [d4000000, d40fffff]
bus: 0c index 2 mmio: [0, 0]
bus: 0c index 3 io port: [0, ffff]
bus: 0c index 4 mmio: [0, ffffffffffffffff]
initcall pcibios_assign_resources+0x0/0x8d returned 0 after 10 msecs
calling  inet_init+0x0/0x354
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x354 returned 0 after 39 msecs
calling  af_unix_init+0x0/0x5a
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x5a returned 0 after 0 msecs
calling  populate_rootfs+0x0/0xf3
checking if image is initramfs... it is
debug: unmapping init memory ffff880037d35000..ffff880037ff0000
initcall populate_rootfs+0x0/0xf3 returned 0 after 262 msecs
calling  calgary_fixup_tce_spaces+0x0/0xfe
initcall calgary_fixup_tce_spaces+0x0/0xfe returned -19 after 0 msecs
calling  i8259A_init_sysfs+0x0/0x27
initcall i8259A_init_sysfs+0x0/0x27 returned 0 after 0 msecs
calling  vsyscall_init+0x0/0x71
initcall vsyscall_init+0x0/0x71 returned 0 after 0 msecs
calling  sbf_init+0x0/0xf4
initcall sbf_init+0x0/0xf4 returned 0 after 0 msecs
calling  i8237A_init_sysfs+0x0/0x27
initcall i8237A_init_sysfs+0x0/0x27 returned 0 after 0 msecs
calling  add_rtc_cmos+0x0/0x1d
initcall add_rtc_cmos+0x0/0x1d returned 0 after 0 msecs
calling  cache_sysfs_init+0x0/0x62
initcall cache_sysfs_init+0x0/0x62 returned 0 after 2 msecs
calling  mce_init_device+0x0/0x8a
initcall mce_init_device+0x0/0x8a returned 0 after 1 msecs
calling  periodic_mcheck_init+0x0/0x44
initcall periodic_mcheck_init+0x0/0x44 returned 0 after 0 msecs
calling  thermal_throttle_init_device+0x0/0x92
initcall thermal_throttle_init_device+0x0/0x92 returned 0 after 0 msecs
calling  threshold_init_device+0x0/0x4e
initcall threshold_init_device+0x0/0x4e returned 0 after 0 msecs
calling  msr_init+0x0/0x124
initcall msr_init+0x0/0x124 returned 0 after 0 msecs
calling  cpuid_init+0x0/0x124
initcall cpuid_init+0x0/0x124 returned 0 after 0 msecs
calling  init_lapic_sysfs+0x0/0x32
initcall init_lapic_sysfs+0x0/0x32 returned 0 after 0 msecs
calling  ioapic_init_sysfs+0x0/0xac
initcall ioapic_init_sysfs+0x0/0xac returned 0 after 0 msecs
calling  add_pcspkr+0x0/0x45
initcall add_pcspkr+0x0/0x45 returned 0 after 0 msecs
calling  uv_ptc_init+0x0/0x7a
initcall uv_ptc_init+0x0/0x7a returned 0 after 0 msecs
calling  uv_bau_init+0x0/0x604
initcall uv_bau_init+0x0/0x604 returned 0 after 0 msecs
calling  audit_classes_init+0x0/0xb4
initcall audit_classes_init+0x0/0xb4 returned 0 after 0 msecs
calling  debug_pagealloc_proc_init+0x0/0x30
initcall debug_pagealloc_proc_init+0x0/0x30 returned 0 after 0 msecs
calling  pt_dump_init+0x0/0x30
initcall pt_dump_init+0x0/0x30 returned 0 after 0 msecs
calling  init_vdso_vars+0x0/0x219
initcall init_vdso_vars+0x0/0x219 returned 0 after 0 msecs
calling  ia32_binfmt_init+0x0/0x19
initcall ia32_binfmt_init+0x0/0x19 returned 0 after 0 msecs
calling  sysenter_setup+0x0/0x2ad
initcall sysenter_setup+0x0/0x2ad returned 0 after 0 msecs
calling  init_sched_debug_procfs+0x0/0x2c
initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 0 msecs
calling  create_proc_profile+0x0/0x2cf
initcall create_proc_profile+0x0/0x2cf returned 0 after 0 msecs
calling  ioresources_init+0x0/0x41
initcall ioresources_init+0x0/0x41 returned 0 after 0 msecs
calling  uid_cache_init+0x0/0x92
initcall uid_cache_init+0x0/0x92 returned 0 after 0 msecs
calling  init_posix_timers+0x0/0xa0
initcall init_posix_timers+0x0/0xa0 returned 0 after 0 msecs
calling  init_posix_cpu_timers+0x0/0xb5
initcall init_posix_cpu_timers+0x0/0xb5 returned 0 after 0 msecs
calling  nsproxy_cache_init+0x0/0x32
initcall nsproxy_cache_init+0x0/0x32 returned 0 after 0 msecs
calling  timekeeping_init_device+0x0/0x27
initcall timekeeping_init_device+0x0/0x27 returned 0 after 0 msecs
calling  init_clocksource_sysfs+0x0/0x55
initcall init_clocksource_sysfs+0x0/0x55 returned 0 after 0 msecs
calling  init_timer_list_procfs+0x0/0x31
initcall init_timer_list_procfs+0x0/0x31 returned 0 after 0 msecs
calling  init_tstats_procfs+0x0/0x31
initcall init_tstats_procfs+0x0/0x31 returned 0 after 0 msecs
calling  lockdep_proc_init+0x0/0x7c
initcall lockdep_proc_init+0x0/0x7c returned 0 after 0 msecs
calling  futex_init+0x0/0xcc
initcall futex_init+0x0/0xcc returned 0 after 0 msecs
calling  proc_dma_init+0x0/0x27
initcall proc_dma_init+0x0/0x27 returned 0 after 0 msecs
calling  percpu_modinit+0x0/0x79
initcall percpu_modinit+0x0/0x79 returned 0 after 0 msecs
calling  kallsyms_init+0x0/0x2a
initcall kallsyms_init+0x0/0x2a returned 0 after 0 msecs
calling  snapshot_device_init+0x0/0x17
initcall snapshot_device_init+0x0/0x17 returned 0 after 0 msecs
calling  crash_save_vmcoreinfo_init+0x0/0x430
initcall crash_save_vmcoreinfo_init+0x0/0x430 returned 0 after 0 msecs
calling  crash_notes_memory_init+0x0/0x44
initcall crash_notes_memory_init+0x0/0x44 returned 0 after 0 msecs
calling  pid_namespaces_init+0x0/0x32
initcall pid_namespaces_init+0x0/0x32 returned 0 after 0 msecs
calling  audit_init+0x0/0x172
audit: initializing netlink socket (disabled)
type=2000 audit(1216436777.860:1): initialized
initcall audit_init+0x0/0x172 returned 0 after 0 msecs
calling  audit_tree_init+0x0/0x4e
initcall audit_tree_init+0x0/0x4e returned 0 after 0 msecs
calling  init_kprobes+0x0/0x124
initcall init_kprobes+0x0/0x124 returned 0 after 4 msecs
calling  relay_init+0x0/0x19
initcall relay_init+0x0/0x19 returned 0 after 0 msecs
calling  utsname_sysctl_init+0x0/0x19
initcall utsname_sysctl_init+0x0/0x19 returned 0 after 0 msecs
calling  init_lstats_procfs+0x0/0x2a
initcall init_lstats_procfs+0x0/0x2a returned 0 after 0 msecs
calling  init_sched_switch_trace+0x0/0x41
initcall init_sched_switch_trace+0x0/0x41 returned 0 after 0 msecs
calling  init_stack_trace+0x0/0x12
initcall init_stack_trace+0x0/0x12 returned 0 after 0 msecs
calling  init_function_trace+0x0/0x12
initcall init_function_trace+0x0/0x12 returned 0 after 0 msecs
calling  init_irqsoff_tracer+0x0/0x14
initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 0 msecs
calling  init_wakeup_tracer+0x0/0x12
initcall init_wakeup_tracer+0x0/0x12 returned 0 after 0 msecs
calling  init_per_zone_pages_min+0x0/0x46
initcall init_per_zone_pages_min+0x0/0x46 returned 0 after 0 msecs
calling  pdflush_init+0x0/0x17
initcall pdflush_init+0x0/0x17 returned 0 after 0 msecs
calling  kswapd_init+0x0/0x7d
initcall kswapd_init+0x0/0x7d returned 0 after 0 msecs
calling  setup_vmstat+0x0/0x4f
initcall setup_vmstat+0x0/0x4f returned 0 after 0 msecs
calling  procswaps_init+0x0/0x27
initcall procswaps_init+0x0/0x27 returned 0 after 0 msecs
calling  hugetlb_init+0x0/0xa0
Total HugeTLB memory allocated, 0
initcall hugetlb_init+0x0/0xa0 returned 0 after 0 msecs
calling  init_tmpfs+0x0/0xdf
initcall init_tmpfs+0x0/0xdf returned 0 after 0 msecs
calling  slab_sysfs_init+0x0/0xf5
initcall slab_sysfs_init+0x0/0xf5 returned 0 after 30 msecs
calling  fasync_init+0x0/0x2f
initcall fasync_init+0x0/0x2f returned 0 after 0 msecs
calling  aio_setup+0x0/0x78
initcall aio_setup+0x0/0x78 returned 0 after 0 msecs
calling  inotify_setup+0x0/0x17
initcall inotify_setup+0x0/0x17 returned 0 after 0 msecs
calling  inotify_user_setup+0x0/0xbd
initcall inotify_user_setup+0x0/0xbd returned 0 after 0 msecs
calling  init_sys32_ioctl+0x0/0x8a
initcall init_sys32_ioctl+0x0/0x8a returned 0 after 0 msecs
calling  dquot_init+0x0/0x108
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x108 returned 0 after 0 msecs
calling  init_v2_quota_format+0x0/0x17
initcall init_v2_quota_format+0x0/0x17 returned 0 after 0 msecs
calling  dnotify_init+0x0/0x2f
initcall dnotify_init+0x0/0x2f returned 0 after 0 msecs
calling  vmcore_init+0x0/0x860
initcall vmcore_init+0x0/0x860 returned 0 after 0 msecs
calling  init_devpts_fs+0x0/0x44
initcall init_devpts_fs+0x0/0x44 returned 0 after 0 msecs
calling  init_ramfs_fs+0x0/0x17
initcall init_ramfs_fs+0x0/0x17 returned 0 after 0 msecs
calling  init_hugetlbfs_fs+0x0/0x9d
initcall init_hugetlbfs_fs+0x0/0x9d returned 0 after 0 msecs
calling  init_iso9660_fs+0x0/0x76
initcall init_iso9660_fs+0x0/0x76 returned 0 after 0 msecs
calling  init_nls_cp437+0x0/0x17
initcall init_nls_cp437+0x0/0x17 returned 0 after 0 msecs
calling  init_nls_ascii+0x0/0x17
initcall init_nls_ascii+0x0/0x17 returned 0 after 0 msecs
calling  ipc_init+0x0/0x28
msgmni has been set to 5936
initcall ipc_init+0x0/0x28 returned 0 after 0 msecs
calling  ipc_sysctl_init+0x0/0x19
initcall ipc_sysctl_init+0x0/0x19 returned 0 after 0 msecs
calling  init_mqueue_fs+0x0/0xdb
initcall init_mqueue_fs+0x0/0xdb returned 0 after 0 msecs
calling  key_proc_init+0x0/0x5e
initcall key_proc_init+0x0/0x5e returned 0 after 0 msecs
calling  selinux_nf_ip_init+0x0/0x7f
SELinux:  Registering netfilter hooks
initcall selinux_nf_ip_init+0x0/0x7f returned 0 after 0 msecs
calling  init_sel_fs+0x0/0x6d
initcall init_sel_fs+0x0/0x6d returned 0 after 1 msecs
calling  selnl_init+0x0/0x52
initcall selnl_init+0x0/0x52 returned 0 after 0 msecs
calling  sel_netif_init+0x0/0x6b
initcall sel_netif_init+0x0/0x6b returned 0 after 0 msecs
calling  sel_netnode_init+0x0/0x78
initcall sel_netnode_init+0x0/0x78 returned 0 after 0 msecs
calling  sel_netport_init+0x0/0x78
initcall sel_netport_init+0x0/0x78 returned 0 after 0 msecs
calling  aurule_init+0x0/0x3c
initcall aurule_init+0x0/0x3c returned 0 after 0 msecs
calling  crypto_algapi_init+0x0/0x12
initcall crypto_algapi_init+0x0/0x12 returned 0 after 0 msecs
calling  cryptomgr_init+0x0/0x17
initcall cryptomgr_init+0x0/0x17 returned 0 after 0 msecs
calling  hmac_module_init+0x0/0x17
initcall hmac_module_init+0x0/0x17 returned 0 after 0 msecs
calling  md5_mod_init+0x0/0x17
initcall md5_mod_init+0x0/0x17 returned 0 after 0 msecs
calling  sha1_generic_mod_init+0x0/0x17
initcall sha1_generic_mod_init+0x0/0x17 returned 0 after 0 msecs
calling  bsg_init+0x0/0x128
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
initcall bsg_init+0x0/0x128 returned 0 after 0 msecs
calling  noop_init+0x0/0x19
io scheduler noop registered
initcall noop_init+0x0/0x19 returned 0 after 0 msecs
calling  as_init+0x0/0x19
io scheduler anticipatory registered
initcall as_init+0x0/0x19 returned 0 after 0 msecs
calling  deadline_init+0x0/0x19
io scheduler deadline registered
initcall deadline_init+0x0/0x19 returned 0 after 0 msecs
calling  cfq_init+0x0/0x99
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x99 returned 0 after 0 msecs
calling  debug_objects_init_debugfs+0x0/0x64
initcall debug_objects_init_debugfs+0x0/0x64 returned 0 after 0 msecs
calling  percpu_counter_startup+0x0/0x14
initcall percpu_counter_startup+0x0/0x14 returned 0 after 0 msecs
calling  pci_init+0x0/0x3a
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x1010
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.3: Performing full reset
pci 0000:01:00.0: Boot video device
initcall pci_init+0x0/0x3a returned 0 after 1 msecs
calling  pci_proc_init+0x0/0x70
initcall pci_proc_init+0x0/0x70 returned 0 after 0 msecs
calling  pcie_portdrv_init+0x0/0x52
PCI: Setting latency timer of device 0000:00:01.0 to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
PCI: Setting latency timer of device 0000:00:1c.2 to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
initcall pcie_portdrv_init+0x0/0x52 returned 0 after 7 msecs
calling  aer_service_init+0x0/0x25
initcall aer_service_init+0x0/0x25 returned 0 after 0 msecs
calling  pci_hotplug_init+0x0/0x22
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x22 returned 0 after 0 msecs
calling  fb_console_init+0x0/0x12b
initcall fb_console_init+0x0/0x12b returned 0 after 0 msecs
calling  vesafb_init+0x0/0x23f
initcall vesafb_init+0x0/0x23f returned 0 after 0 msecs
calling  efifb_init+0x0/0x1f2
initcall efifb_init+0x0/0x1f2 returned -19 after 0 msecs
calling  acpi_reserve_resources+0x0/0xf0
initcall acpi_reserve_resources+0x0/0xf0 returned 0 after 0 msecs
calling  acpi_button_init+0x0/0x63
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
ACPI: Sleep Button (CM) [SLPB]
initcall acpi_button_init+0x0/0x63 returned 0 after 4 msecs
calling  acpi_fan_init+0x0/0x63
initcall acpi_fan_init+0x0/0x63 returned 0 after 0 msecs
calling  irqrouter_init_sysfs+0x0/0x3d
initcall irqrouter_init_sysfs+0x0/0x3d returned 0 after 0 msecs
calling  acpi_processor_init+0x0/0x10f
ACPI: SSDT BFEB8A90, 02F0 (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
ACPI: SSDT BFEB6C10, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BFEB7F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
ACPI: SSDT BFEB6F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
initcall acpi_processor_init+0x0/0x10f returned 0 after 22 msecs
calling  acpi_container_init+0x0/0x47
initcall acpi_container_init+0x0/0x47 returned 0 after 17 msecs
calling  acpi_thermal_init+0x0/0x88
initcall acpi_thermal_init+0x0/0x88 returned 0 after 0 msecs
calling  rand_initialize+0x0/0x31
initcall rand_initialize+0x0/0x31 returned 0 after 0 msecs
calling  tty_init+0x0/0x1ca
initcall tty_init+0x0/0x1ca returned 0 after 29 msecs
calling  pty_init+0x0/0x278
initcall pty_init+0x0/0x278 returned 0 after 0 msecs
calling  hpet_init+0x0/0x6f
hpet_resources: 0xfed00000 is busy
initcall hpet_init+0x0/0x6f returned 0 after 1 msecs
calling  nvram_init+0x0/0x8f
Non-volatile memory driver v1.2
initcall nvram_init+0x0/0x8f returned 0 after 0 msecs
calling  agp_init+0x0/0x2b
Linux agpgart interface v0.103
initcall agp_init+0x0/0x2b returned 0 after 0 msecs
calling  agp_intel_init+0x0/0x2e
initcall agp_intel_init+0x0/0x2e returned 0 after 0 msecs
calling  agp_sis_init+0x0/0x2e
initcall agp_sis_init+0x0/0x2e returned 0 after 0 msecs
calling  agp_via_init+0x0/0x2e
initcall agp_via_init+0x0/0x2e returned 0 after 0 msecs
calling  cn_proc_init+0x0/0x42
initcall cn_proc_init+0x0/0x42 returned 0 after 0 msecs
calling  serial8250_init+0x0/0x148
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
initcall serial8250_init+0x0/0x148 returned 0 after 2 msecs
calling  serial8250_pnp_init+0x0/0x17
initcall serial8250_pnp_init+0x0/0x17 returned 0 after 0 msecs
calling  serial8250_pci_init+0x0/0x20
initcall serial8250_pci_init+0x0/0x20 returned 0 after 0 msecs
calling  init_kgdboc+0x0/0x1b
initcall init_kgdboc+0x0/0x1b returned 0 after 0 msecs
calling  topology_sysfs_init+0x0/0x5e
initcall topology_sysfs_init+0x0/0x5e returned 0 after 0 msecs
calling  brd_init+0x0/0x172
brd: module loaded
initcall brd_init+0x0/0x172 returned 0 after 11 msecs
calling  init_kgdbts+0x0/0x1b
initcall init_kgdbts+0x0/0x1b returned 0 after 0 msecs
calling  net_olddevs_init+0x0/0xa3
initcall net_olddevs_init+0x0/0xa3 returned 0 after 0 msecs
calling  mac_hid_init+0x0/0xd7
input: Macintosh mouse button emulation as /devices/virtual/input/input4
initcall mac_hid_init+0x0/0xd7 returned 0 after 0 msecs
calling  init_sd+0x0/0xfd
Driver 'sd' needs updating - please use bus_type methods
initcall init_sd+0x0/0xfd returned 0 after 0 msecs
calling  init_sg+0x0/0x145
initcall init_sg+0x0/0x145 returned 0 after 0 msecs
calling  nonstatic_sysfs_init+0x0/0x17
initcall nonstatic_sysfs_init+0x0/0x17 returned 0 after 0 msecs
calling  yenta_socket_init+0x0/0x20
initcall yenta_socket_init+0x0/0x20 returned 0 after 0 msecs
calling  mon_init+0x0/0x11c
initcall mon_init+0x0/0x11c returned 0 after 0 msecs
calling  i8042_init+0x0/0x371
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
initcall i8042_init+0x0/0x371 returned -19 after 2 msecs
calling  serport_init+0x0/0x39
initcall serport_init+0x0/0x39 returned 0 after 0 msecs
calling  mousedev_init+0x0/0x67
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x67 returned 0 after 4 msecs
calling  evdev_init+0x0/0x17
initcall evdev_init+0x0/0x17 returned 0 after 21 msecs
calling  atkbd_init+0x0/0x2c
initcall atkbd_init+0x0/0x2c returned 0 after 0 msecs
calling  psmouse_init+0x0/0x78
initcall psmouse_init+0x0/0x78 returned 0 after 0 msecs
calling  cmos_init+0x0/0x35
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
initcall cmos_init+0x0/0x35 returned 0 after 1 msecs
calling  init_ladder+0x0/0x17
cpuidle: using governor ladder
initcall init_ladder+0x0/0x17 returned 0 after 2 msecs
calling  init_menu+0x0/0x17
cpuidle: using governor menu
initcall init_menu+0x0/0x17 returned 0 after 4 msecs
calling  efivars_init+0x0/0x1f5
initcall efivars_init+0x0/0x1f5 returned -19 after 0 msecs
calling  hid_init+0x0/0x10
initcall hid_init+0x0/0x10 returned 0 after 0 msecs
calling  hid_init+0x0/0x67
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
initcall hid_init+0x0/0x67 returned 0 after 1 msecs
calling  sysctl_core_init+0x0/0x17
initcall sysctl_core_init+0x0/0x17 returned 0 after 0 msecs
calling  flow_cache_init+0x0/0x1ca
initcall flow_cache_init+0x0/0x1ca returned 0 after 0 msecs
calling  llc_init+0x0/0x25
initcall llc_init+0x0/0x25 returned 0 after 0 msecs
calling  snap_init+0x0/0x36
initcall snap_init+0x0/0x36 returned 0 after 0 msecs
calling  rif_init+0x0/0x9a
initcall rif_init+0x0/0x9a returned 0 after 0 msecs
calling  blackhole_module_init+0x0/0x17
initcall blackhole_module_init+0x0/0x17 returned 0 after 0 msecs
calling  sysctl_ipv4_init+0x0/0x53
initcall sysctl_ipv4_init+0x0/0x53 returned 0 after 1 msecs
calling  init_syncookies+0x0/0x1e
initcall init_syncookies+0x0/0x1e returned 0 after 0 msecs
calling  ipv4_netfilter_init+0x0/0x17
initcall ipv4_netfilter_init+0x0/0x17 returned 0 after 0 msecs
calling  cubictcp_register+0x0/0x6a
TCP cubic registered
initcall cubictcp_register+0x0/0x6a returned 0 after 0 msecs
calling  xfrm_user_init+0x0/0x5e
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x5e returned 0 after 0 msecs
calling  packet_init+0x0/0x4c
NET: Registered protocol family 17
initcall packet_init+0x0/0x4c returned 0 after 0 msecs
calling  hpet_insert_resource+0x0/0x28
initcall hpet_insert_resource+0x0/0x28 returned 0 after 0 msecs
calling  update_mp_table+0x0/0x61b
initcall update_mp_table+0x0/0x61b returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x45
initcall lapic_insert_resource+0x0/0x45 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x3d
initcall init_lapic_nmi_sysfs+0x0/0x3d returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x54
initcall ioapic_insert_resources+0x0/0x54 returned 0 after 0 msecs
calling  check_early_ioremap_leak+0x0/0x49
initcall check_early_ioremap_leak+0x0/0x49 returned 0 after 0 msecs
calling  sched_init_debug+0x0/0x24
initcall sched_init_debug+0x0/0x24 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x28
initcall init_oops_id+0x0/0x28 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x3f
initcall disable_boot_consoles+0x0/0x3f returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xcf
initcall pm_qos_power_init+0x0/0xcf returned 0 after 0 msecs
calling  software_resume+0x0/0x1ba
initcall software_resume+0x0/0x1ba returned -2 after 0 msecs
initcall software_resume+0x0/0x1ba returned with error code -2 
calling  debugfs_kprobe_init+0x0/0x8e
initcall debugfs_kprobe_init+0x0/0x8e returned 0 after 0 msecs
calling  taskstats_init+0x0/0x9a
registered taskstats version 1
initcall taskstats_init+0x0/0x9a returned 0 after 0 msecs
calling  fail_page_alloc_debugfs+0x0/0xe9
initcall fail_page_alloc_debugfs+0x0/0xe9 returned 0 after 0 msecs
calling  fail_make_request_debugfs+0x0/0x1e
initcall fail_make_request_debugfs+0x0/0x1e returned 0 after 0 msecs
calling  random32_reseed+0x0/0x7e
initcall random32_reseed+0x0/0x7e returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x51
initcall pci_sysfs_init+0x0/0x51 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  acpi_sleep_proc_init+0x0/0x5a
initcall acpi_sleep_proc_init+0x0/0x5a returned 0 after 0 msecs
calling  seqgen_init+0x0/0x14
initcall seqgen_init+0x0/0x14 returned 0 after 0 msecs
calling  late_resume_init+0x0/0x112
  Magic number: 0:812:108
initcall late_resume_init+0x0/0x112 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0xf4
initcall scsi_complete_async_scans+0x0/0xf4 returned 0 after 0 msecs
calling  memmap_init+0x0/0x9d
initcall memmap_init+0x0/0x9d returned 0 after 0 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x48
initcall pci_mmcfg_late_insert_resources+0x0/0x48 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x17
initcall tcp_congestion_default+0x0/0x17 returned 0 after 0 msecs
debug: unmapping init memory ffffffff814eb000..ffffffff8166d000
Write protecting the kernel read-only data: 1368k
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd8405400
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
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
Clocksource tsc unstable (delta = -305979950 ns)
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-0.156.rc0.git4.fc9.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
modprobe used greatest stack depth: 3792 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
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
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-0.156.rc0.git4.fc9.x86_64 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
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
ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-0.156.rc0.git4.fc9.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
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
hub 1-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-0.156.rc0.git4.fc9.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: supports USB remote wakeup
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
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
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 1-4: new high speed USB device using ehci_hcd and address 3
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-0.156.rc0.git4.fc9.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
modprobe used greatest stack depth: 3744 bytes left
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
usb 1-4: uevent
usb 1-4: usb_probe_device
usb 1-4: configuration #1 chosen from 1 choice
usb 1-4: adding 1-4:1.0 (config #1, interface 0)
usb 1-4:1.0: uevent
drivers/usb/core/inode.c: creating file '003'
usb 1-4: New USB device found, idVendor=05ac, idProduct=8300
usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
ata1.00: ATAPI: MATSHITADVD-R   UJ-85J, FAV1, max UDMA/66
ata1.00: configured for UDMA/66
hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 6 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 7, status 0501, change 0001, 480 Mb/s
isa bounce pool size: 16 pages
scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-85J   FAV1 PQ: 0 ANSI: 5
scsi 0:0:0:0: Attached scsi generic sg0 type 5
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 7 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 009b,00
hub 2-0:1.0: port 2, status 0101, change 0003, 12 Mb/s
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ata3.01: ATA-7: TOSHIBA MK2035GSS, DK021B, max UDMA/100
ata3.01: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/4)
ata3.01: configured for UDMA/100
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: ep0 maxpacket = 8
usb 2-2: USB quirks for this device: 2
scsi 2:0:1:0: Direct-Access     ATA      TOSHIBA MK2035GS DK02 PQ: 0 ANSI: 5
sd 2:0:1:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:1:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<7>usb 2-2: skipped 1 descriptor after interface
usb 2-2: skipped 1 descriptor after interface
usb 2-2: skipped 1 descriptor after interface
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usbhid 2-2:1.0: usb_probe_interface
usbhid 2-2:1.0: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input5
uhci_hcd 0000:00:1d.0: reserve dev 2 ep83-INT, period 8, phase 4, 17 us
input,hidraw0: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
usbhid 2-2:1.1: usb_probe_interface
usbhid 2-2:1.1: usb_probe_interface - got id
usb 2-2: adding 2-2:1.2 (config #1, interface 2)
usb 2-2:1.2: uevent
usbhid 2-2:1.2: usb_probe_interface
usbhid 2-2:1.2: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input6
uhci_hcd 0000:00:1d.0: reserve dev 2 ep84-INT, period 8, phase 4, 12 us
 sda1 sda2 sda3 sda4 sda5
input,hidraw1: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
sd 2:0:1:0: [sda] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg1 type 0
modprobe used greatest stack depth: 2304 bytes left
drivers/usb/core/inode.c: creating file '002'
usb 2-2: New USB device found, idVendor=05ac, idProduct=021a
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: Apple Internal Keyboard / Trackpad
usb 2-2: Manufacturer: Apple Computer
hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.1: port 2 portsc 008a,00
hub 3-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.2: port 2 portsc 009b,00
hub 4-0:1.0: port 2, status 0101, change 0003, 12 Mb/s
hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: ep0 maxpacket = 8
usb 4-2: skipped 1 descriptor after interface
usb 4-2: default language 0x0409
usb 4-2: uevent
usb 4-2: usb_probe_device
usb 4-2: configuration #1 chosen from 1 choice
usb 4-2: adding 4-2:1.0 (config #1, interface 0)
usb 4-2:1.0: uevent
usbhid 4-2:1.0: usb_probe_interface
usbhid 4-2:1.0: usb_probe_interface - got id
drivers/usb/core/file.c: looking for a minor, starting at 96
hiddev96hidraw2: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2
drivers/usb/core/inode.c: creating file '002'
usb 4-2: New USB device found, idVendor=05ac, idProduct=8240
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: IR Receiver
usb 4-2: Manufacturer: Apple Computer, Inc.
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.3: port 1 portsc 009b,00
hub 5-0:1.0: port 1, status 0101, change 0003, 12 Mb/s
hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: skipped 1 descriptor after interface
usb 5-1: skipped 1 descriptor after interface
usb 5-1: uevent
usb 5-1: usb_probe_device
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: adding 5-1:1.0 (config #1, interface 0)
usb 5-1:1.0: uevent
usbhid 5-1:1.0: usb_probe_interface
usbhid 5-1:1.0: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input7
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
input,hidraw3: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
usb 5-1: adding 5-1:1.1 (config #1, interface 1)
usb 5-1:1.1: uevent
usbhid 5-1:1.1: usb_probe_interface
usbhid 5-1:1.1: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input8
input,hidraw4: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
drivers/usb/core/inode.c: creating file '002'
usb 5-1: New USB device found, idVendor=05ac, idProduct=1000
usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
usb usb3: suspend_rh (auto-stop)
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
type=1404 audit(1216436785.373:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 8192 avtab hash slots, 171021 rules.
SELinux: 8192 avtab hash slots, 171021 rules.
SELinux:  8 users, 12 roles, 2347 types, 115 bools, 1 sens, 1024 cats
SELinux:  72 classes, 171021 rules
SELinux:  permission open in class dir not defined in policy
SELinux:  permission open in class file not defined in policy
SELinux:  permission open in class chr_file not defined in policy
SELinux:  permission open in class blk_file not defined in policy
SELinux:  permission open in class fifo_file not defined in policy
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda5, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1216436786.249:3): policy loaded auid=4294967295 ses=4294967295
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-2: uevent
usb 2-2:1.0: uevent
usb 2-2:1.1: uevent
usb 2-2:1.2: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb 4-2: uevent
usb 4-2:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb 5-1: uevent
usb 5-1:1.0: uevent
usb 5-1:1.1: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-4: uevent
usb 1-4:1.0: uevent
appletouch 2-2:1.1: usb_probe_interface
appletouch 2-2:1.1: usb_probe_interface - got id
appletouch: Geyser mode initialized.
input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input9
usbcore: registered new interface driver appletouch
intel_rng: FWH not detected
iTCO_vendor_support: vendor-support=0
ath5k_pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
ath5k_pci 0000:03:00.0: registered as 'phy0'
ath5k phy0: Device not yet supported.
ath5k_pci 0000:03:00.0: PCI INT A disabled
ACPI: AC Adapter [ADP1] (on-line)
ath_hal: module license 'Proprietary' taints kernel.
AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133)
ACPI: Battery Slot [BAT0] (battery present)
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
input: PC Speaker as /devices/platform/pcspkr/input/input10
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts with ACPI region SMBI [0xefa0-0xefaf]
ACPI: Device needs an ACPI driver
isight_firmware 1-4:1.0: usb_probe_interface
isight_firmware 1-4:1.0: usb_probe_interface - got id
firmware: requesting isight.fw
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input11
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.21 addr 0xd8200000 irq 16 Yukon-EC (0xb6) rev 2
sky2 eth0: addr 00:17:f2:d1:e0:6f
Unable to load isight firmware
usbcore: registered new interface driver isight_firmware
firewire_ohci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:0c:03.0, OHCI version 1.10
firewire_core: created device fw0: GUID 0019e3fffe6e4c54, S800
ath_pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
MadWifi: ath_attach: Switching rfkill capability off.
wifi0: Atheros AR5418 chip found (MAC 12.10, PHY SChip 8.1, Radio 12.0)
ath_pci: wifi0: Atheros 5418: mem=0xd8100000, irq=17
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
[drm] Initialized radeon 1.29.0 20080528 on minor 0
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
appletouch: incomplete data package (first byte: 2, length: 4).
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda3, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 2047992k swap on /dev/sda4.  Priority:-1 extents:1 across:2047992k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
firmware: requesting intel-ucode/06-0f-06
firmware: requesting intel-ucode/06-0f-06
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.
fuse init (API version 7.9)
SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
usb usb3: usb auto-resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_resume
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: suspend_rh (auto-stop)
uhci_hcd 0000:00:1d.2: reserve dev 2 ep83-INT, period 8, phase 4, 61 us
uhci_hcd 0000:00:1d.2: release dev 2 ep83-INT, period 8, phase 4, 61 us
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
[drm] Num pipes: 1
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
ath0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us






On Fri, Jul 18, 2008 at 06:22:08PM -0700, Yinghai Lu wrote:
> On Fri, Jul 18, 2008 at 5:58 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> > YH,
> >   The patch you posted did not apply cleanly to tonight's or last night's linus kernel git.
> > I had to correct it by hand and this is what I applied...
> 
> it should apply cleanly to linus tree too.
> 
> please check the patch i sent out before and addon fix patch
> 
> YH

> [PATCH] x86,pci: detect end_bus_number according to acpi/e820 reserved
> 
> for MacBookPro2
> 
> change the mconf bus range from [0,0xff] to to [0, 0x3f]
> to match range [0xf0000000, 0xf4000000) in e820 tables.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/pci/mmconfig-shared.c |   64 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 47 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> @@ -293,7 +293,7 @@ static acpi_status __init find_mboard_re
>  	return AE_OK;
>  }
>  
> -static int __init is_acpi_reserved(unsigned long start, unsigned long end)
> +static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
>  {
>  	struct resource mcfg_res;
>  
> @@ -310,6 +310,41 @@ static int __init is_acpi_reserved(unsig
>  	return mcfg_res.flags;
>  }
>  
> +typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
> +
> +static int __init is_mmconf_reserved(check_reserved_t is_reserved,
> +		u64 addr, u64 size, int i,
> +	        typeof(pci_mmcfg_config[0]) *cfg, int with_e820)
> +{
> +	u64 old_size = size;
> +	int valid = 0;
> +
> +	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
> +		size >>= 1;
> +		if (size < (16UL<<20))
> +			break;
> +	}
> +
> +	if (size >= (16UL<<20) || size == old_size) {
> +		printk(KERN_NOTICE
> +		       "PCI: MCFG area at %Lx reserved in %s\n",
> +			addr, with_e820?"E820":"ACPI motherboard resources");
> +		valid = 1;
> +
> +		if (old_size != size) {
> +			/* update end_bus_number */
> +			cfg->end_bus_number = cfg->start_bus_number + ((size>>20) - 1);
> +			printk(KERN_NOTICE "PCI: updated MCFG configuration %d: base %lx "
> +			       "segment %hu buses %u - %u\n",
> +			       i, (unsigned long)cfg->address, cfg->pci_segment,
> +			       (unsigned int)cfg->start_bus_number,
> +			       (unsigned int)cfg->end_bus_number);
> +		}
> +	}
> +
> +	return valid;
> +}
> +
>  static void __init pci_mmcfg_reject_broken(int early)
>  {
>  	typeof(pci_mmcfg_config[0]) *cfg;
> @@ -324,21 +359,21 @@ static void __init pci_mmcfg_reject_brok
>  
>  	for (i = 0; i < pci_mmcfg_config_num; i++) {
>  		int valid = 0;
> -		u32 size = (cfg->end_bus_number + 1) << 20;
> +		u64 addr, size;
> +
>  		cfg = &pci_mmcfg_config[i];
> +		addr = cfg->start_bus_number;
> +		addr <<= 20;
> +		size = cfg->end_bus_number + 1 - cfg->start_bus_number;
> +		size <<= 20;
>  		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
>  		       "segment %hu buses %u - %u\n",
>  		       i, (unsigned long)cfg->address, cfg->pci_segment,
>  		       (unsigned int)cfg->start_bus_number,
>  		       (unsigned int)cfg->end_bus_number);
>  
> -		if (!early &&
> -		    is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
> -			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
> -			       "in ACPI motherboard resources\n",
> -			       cfg->address);
> -			valid = 1;
> -		}
> +		if (!early)
> +			valid = is_mmconf_reserved(is_acpi_reserved, addr, size, i, cfg, 0);
>  
>  		if (valid)
>  			continue;
> @@ -347,16 +382,11 @@ static void __init pci_mmcfg_reject_brok
>  			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
>  			       " reserved in ACPI motherboard resources\n",
>  			       cfg->address);
> +
>  		/* Don't try to do this check unless configuration
>  		   type 1 is available. how about type 2 ?*/
> -		if (raw_pci_ops && e820_all_mapped(cfg->address,
> -						  cfg->address + size - 1,
> -						  E820_RESERVED)) {
> -			printk(KERN_NOTICE
> -			       "PCI: MCFG area at %Lx reserved in E820\n",
> -			       cfg->address);
> -			valid = 1;
> -		}
> +		if (raw_pci_ops)
> +			valid = is_mmconf_reserved(e820_all_mapped, addr, size, i, cfg, 1);
>  
>  		if (!valid)
>  			goto reject;

> [PATCH] x86,pci: detect end_bus_number according to acpi/e820 reserved
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 9297882..429c701 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -364,6 +364,7 @@ static void __init pci_mmcfg_reject_broken(int early)
>  		cfg = &pci_mmcfg_config[i];
>  		addr = cfg->start_bus_number;
>  		addr <<= 20;
> +		addr += cfg->address;
>  		size = cfg->end_bus_number + 1 - cfg->start_bus_number;
>  		size <<= 20;
>  		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "

