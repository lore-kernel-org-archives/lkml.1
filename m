Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYGGSlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYGGSlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYGGSlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:41:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12468 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYGGSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:40:57 -0400
Date: Mon, 7 Jul 2008 11:39:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-Id: <20080707113917.6fda3f7d.randy.dunlap@oracle.com>
In-Reply-To: <20080707063218.GC23583@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	<uBi7uNfg81L.A.XLC.s0LcIB@albercik>
	<20080706111750.a6d77e81.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
	<20080707063218.GC23583@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Mon__7_Jul_2008_11_39_17_-0700_z+Wd0I1K3GhxZRN5"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Mon__7_Jul_2008_11_39_17_-0700_z+Wd0I1K3GhxZRN5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 7 Jul 2008 08:32:18 +0200 Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.
> > 
> > Ok, then it wasn't the nr_zones thing.
> > 
> > Since it seems to be repeatable for you, can you bisect it?
> 
> one guess would be:
> 
> | commit e8ee6f0ae5cd860e8e6c02807edfa3c1fa01bcb5
> | Author: Yinghai Lu <yhlu.kernel@gmail.com>
> | Date:   Sun Apr 13 01:41:58 2008 -0700
> |
> |     x86: work around io allocation overlap of HT links
> 
> but ... since CONFIG_NUMA makes it work, i'm not sure about that.
> 
> Randy, could you post the full CONFIG_NUMA bootlog as well, does it show 
> any difference in resource allocations?

Good and bad boot logs are attached.  There are several differences, but I don't
see any that are significant.

I've started bisecting with:

$ git bisect start
$ git bisect bad v2.6.26-rc1
$ git bisect good v2.6.25

That's only about 1.29M lines of changes.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/


--Multipart=_Mon__7_Jul_2008_11_39_17_-0700_z+Wd0I1K3GhxZRN5
Content-Type: text/x-log;
 name="netcon-4556.log"
Content-Disposition: attachment;
 filename="netcon-4556.log"
Content-Transfer-Encoding: quoted-printable

Linux version 2.6.26-rc9 (root@ca-ostest293.us.oracle.com) (gcc version 4.1=
.1 20070105 (Red Hat 4.1.1-52)) #1 SMP Sat Jul 5 17:04:54 PDT 2008
Command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=3D5455=
6@139.185.50.77/eth0,54556@139.185.50.76/00:18:FE:34:1C:3D debug ignore_log=
level 3 kex initcall_debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
Entering add_active_range(0, 1, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 523856) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2621439) 2 entries of 3200 used
max_pfn_mapped =3D 2621439
init_memory_mapping
DMI 2.3 present.
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT 7FE50780, 005C (r1 HP     A08             2   =D2=04     162E)
ACPI: FACP 7FE50800, 00F4 (r3 HP     A08             2   =D2=04     162E)
ACPI: DSDT 7FE50900, 3F75 (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS 7FE50100, 0040
ACPI: SPCR 7FE50140, 0050 (r1 HP     SPCRRBSU        1   =D2=04     162E)
ACPI: MCFG 7FE501C0, 003C (r1 HP     ProLiant        1             0)
ACPI: HPET 7FE50200, 0038 (r1 HP     A08             2   =D2=04     162E)
ACPI: SPMI 7FE50240, 0040 (r5 HP     ProLiant        1   =D2=04     162E)
ACPI: APIC 7FE50280, 00DE (r1 HP     00000083        2             0)
ACPI: SRAT 7FE50380, 0110 (r1 AMD    HAMMER          1 AMD         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 1, 159) 0 entries of 3200 used
SRAT: Node 0 PXM 0 100000-80000000
Entering add_active_range(0, 256, 523856) 1 entries of 3200 used
SRAT: Node 0 PXM 0 100000000-180000000
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
SRAT: Node 1 PXM 1 180000000-280000000
Entering add_active_range(1, 1572864, 2621439) 3 entries of 3200 used
NUMA: Allocated memnodemap from 12000 - 17080
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [0000000000018000 -  0000000000047fff] pages 30
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-84e32f] TEXT DATA BSS
  early res: 3 [7fd05000-7fe4f6aa] RAMDISK
  early res: 4 [9f400-fffff] BIOS reserved
  early res: 5 [8000-11fff] PGTABLE
  early res: 6 [12000-1707f] MEMNODEMAP
Bootmem setup node 1 0000000180000000-000000027ffff000
  NODE_DATA [0000000180000000 - 0000000180003fff]
  bootmap [0000000180004000 -  0000000180023fff] pages 20
 [ffffe20000000000-ffffe200049fffff] PMD -> [ffff810001200000-ffff810003fff=
fff] on node 0
 [ffffe20004a00000-ffffe200053fffff] PMD -> [ffff81000c000000-ffff81000c9ff=
fff] on node 0
 [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff810180200000-ffff8101839ff=
fff] on node 1
Zone PFN ranges:
  DMA             1 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2621439
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        1 ->      159
    0:      256 ->   523856
    0:  1048576 ->  1572864
    1:  1572864 ->  2621439
On node 0 totalpages: 1048046
  DMA zone: 56 pages used for memmap
  DMA zone: 1730 pages reserved
  DMA zone: 2212 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 1 totalpages: 1048575
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034239 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 0, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10228201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36528 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2059051
Policy zone: Normal
Kernel command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=
=3D54556@139.185.50.77/eth0,54556@139.185.50.76/00:18:FE:34:1C:3D debug ign=
ore_loglevel 3 kex initcall_debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1004.624 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Node 0: aperture @ c000000 size 64 MB
Aperture pointing to e820 RAM. Ignoring.
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
PM: Registered nosave memory: 0000000004000000 - 0000000008000000
Memory: 8197816k/10485756k available (3372k kernel code, 188668k reserved, =
1720k data, 344k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D2
hpet clockevent registered
Calibrating delay using timer specific routine.. 2010.80 BogoMIPS (lpj=3D40=
21606)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20080321
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557812
Detected 12.557 MHz APIC timer.
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2009.35 BogoMIPS (lpj=3D40=
18709)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 2009.43 BogoMIPS (lpj=3D40=
18874)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 2009.35 BogoMIPS (lpj=3D40=
18702)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (8038.94 BogoMIPS).
khelper used greatest stack depth: 5976 bytes left
calling  init_cpufreq_transition_notifier_list+0x0/0x1b
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 =
msecs
calling  net_ns_init+0x0/0x15d
net_namespace: 368 bytes
initcall net_ns_init+0x0/0x15d returned 0 after 3 msecs
calling  cpufreq_tsc+0x0/0x16
initcall cpufreq_tsc+0x0/0x16 returned 0 after 0 msecs
calling  init_smp_flush+0x0/0x49
initcall init_smp_flush+0x0/0x49 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x32
initcall sysctl_init+0x0/0x32 returned 0 after 0 msecs
calling  ksysfs_init+0x0/0xbb
initcall ksysfs_init+0x0/0xbb returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x12
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 msecs
calling  pm_init+0x0/0x34
initcall pm_init+0x0/0x34 returned 0 after 0 msecs
calling  pm_disk_init+0x0/0x19
initcall pm_disk_init+0x0/0x19 returned 0 after 0 msecs
calling  swsusp_header_init+0x0/0x2c
initcall swsusp_header_init+0x0/0x2c returned 0 after 0 msecs
calling  filelock_init+0x0/0x2e
initcall filelock_init+0x0/0x2e returned 0 after 0 msecs
calling  init_misc_binfmt+0x0/0x3f
initcall init_misc_binfmt+0x0/0x3f returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x12
initcall init_script_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x12
initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x12
initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x51
initcall debugfs_init+0x0/0x51 returned 0 after 0 msecs
calling  random32_init+0x0/0x58
initcall random32_init+0x0/0x58 returned 0 after 0 msecs
calling  cpufreq_core_init+0x0/0x75
initcall cpufreq_core_init+0x0/0x75 returned 0 after 0 msecs
calling  cpuidle_init+0x0/0x40
initcall cpuidle_init+0x0/0x40 returned 0 after 0 msecs
calling  sock_init+0x0/0x59
initcall sock_init+0x0/0x59 returned 0 after 0 msecs
calling  netpoll_init+0x0/0x31
initcall netpoll_init+0x0/0x31 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x14d
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14d returned 0 after 0 msecs
calling  bdi_class_init+0x0/0x3d
initcall bdi_class_init+0x0/0x3d returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x45
initcall kobject_uevent_init+0x0/0x45 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x12
initcall pcibus_class_init+0x0/0x12 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x12
initcall pci_driver_init+0x0/0x12 returned 0 after 0 msecs
calling  backlight_class_init+0x0/0x49
initcall backlight_class_init+0x0/0x49 returned 0 after 0 msecs
calling  tty_class_init+0x0/0x2a
initcall tty_class_init+0x0/0x2a returned 0 after 0 msecs
calling  vtconsole_class_init+0x0/0xba
initcall vtconsole_class_init+0x0/0xba returned 0 after 0 msecs
calling  register_node_type+0x0/0x6b
initcall register_node_type+0x0/0x6b returned 0 after 0 msecs
calling  early_fill_mp_bus_info+0x0/0x7ed
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: [40,ff] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]
bus: 40 index 2 mmio: [84000000, 8fffffff]
initcall early_fill_mp_bus_info+0x0/0x7ed returned 0 after 3 msecs
calling  arch_kdebugfs_init+0x0/0x8
initcall arch_kdebugfs_init+0x0/0x8 returned 0 after 0 msecs
calling  mtrr_if_init+0x0/0x77
initcall mtrr_if_init+0x0/0x77 returned 0 after 0 msecs
calling  ffh_cstate_init+0x0/0x31
initcall ffh_cstate_init+0x0/0x31 returned -1 after 0 msecs
initcall ffh_cstate_init+0x0/0x31 returned with error code -1=20
calling  acpi_pci_init+0x0/0x4a
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x4a returned 0 after 0 msecs
calling  init_acpi_device_notify+0x0/0x4b
initcall init_acpi_device_notify+0x0/0x4b returned 0 after 0 msecs
calling  dmi_id_init+0x0/0x2e9
initcall dmi_id_init+0x0/0x2e9 returned 0 after 0 msecs
calling  pci_access_init+0x0/0x4e
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
PCI: HP ProLiant BL685c G1 detected, enabling pci=3Dbfsort.
initcall pci_access_init+0x0/0x4e returned 0 after 0 msecs
calling  topology_init+0x0/0x7c
initcall topology_init+0x0/0x7c returned 0 after 0 msecs
calling  mtrr_init_finialize+0x0/0x34
initcall mtrr_init_finialize+0x0/0x34 returned 0 after 0 msecs
calling  param_sysfs_init+0x0/0x1e7
initcall param_sysfs_init+0x0/0x1e7 returned 0 after 3 msecs
calling  pm_sysrq_init+0x0/0x19
initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 msecs
calling  readahead_init+0x0/0x38
initcall readahead_init+0x0/0x38 returned 0 after 0 msecs
calling  init_bio+0x0/0xc5
initcall init_bio+0x0/0xc5 returned 0 after 0 msecs
calling  blk_settings_init+0x0/0x2a
initcall blk_settings_init+0x0/0x2a returned 0 after 0 msecs
calling  blk_ioc_init+0x0/0x2a
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 msecs
calling  genhd_device_init+0x0/0x40
initcall genhd_device_init+0x0/0x40 returned 0 after 0 msecs
calling  fbmem_init+0x0/0x8a
initcall fbmem_init+0x0/0x8a returned 0 after 0 msecs
calling  acpi_init+0x0/0x21d
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 7FE58000, 04F0 (r2 HP     PNOWSSDT        2 HP          1)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: MCFG area at 80000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at 80000000 - 8fffffff
initcall acpi_init+0x0/0x21d returned 0 after 30 msecs
calling  acpi_scan_init+0x0/0x11e
initcall acpi_scan_init+0x0/0x11e returned 0 after 7 msecs
calling  acpi_ec_init+0x0/0x61
initcall acpi_ec_init+0x0/0x61 returned 0 after 0 msecs
calling  acpi_pci_root_init+0x0/0x28
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1.NB01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2.NC1B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE3.NC2B._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2.SASB._PRT]
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 15 msecs
calling  acpi_pci_link_init+0x0/0x48
ACPI: PCI Interrupt Link [LNKW] (IRQs *16)
ACPI: PCI Interrupt Link [LNKX] (IRQs *17)
ACPI: PCI Interrupt Link [LNKY] (IRQs *18)
ACPI: PCI Interrupt Link [LNKZ] (IRQs *19)
ACPI: PCI Interrupt Link [LNU0] (IRQs *22)
ACPI: PCI Interrupt Link [LNU2] (IRQs *23)
ACPI: PCI Interrupt Link [LNKA] (IRQs *54)
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
initcall acpi_pci_link_init+0x0/0x48 returned 0 after 3 msecs
calling  acpi_power_init+0x0/0x77
initcall acpi_power_init+0x0/0x77 returned 0 after 0 msecs
calling  acpi_system_init+0x0/0x260
initcall acpi_system_init+0x0/0x260 returned 0 after 0 msecs
calling  acpi_cm_sbs_init+0x0/0x8
initcall acpi_cm_sbs_init+0x0/0x8 returned 0 after 0 msecs
calling  pnp_init+0x0/0x20
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall pnp_init+0x0/0x20 returned 0 after 0 msecs
calling  pnpacpi_init+0x0/0x8c
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 7 msecs
calling  misc_init+0x0/0x98
initcall misc_init+0x0/0x98 returned 0 after 0 msecs
calling  cn_init+0x0/0xee
initcall cn_init+0x0/0xee returned 0 after 3 msecs
calling  phy_init+0x0/0x31
initcall phy_init+0x0/0x31 returned 0 after 0 msecs
calling  init_scsi+0x0/0x91
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 0 msecs
calling  usb_init+0x0/0x122
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x122 returned 0 after 0 msecs
calling  serio_init+0x0/0x89
initcall serio_init+0x0/0x89 returned 0 after 0 msecs
calling  input_init+0x0/0x107
initcall input_init+0x0/0x107 returned 0 after 0 msecs
calling  rtc_init+0x0/0x70
initcall rtc_init+0x0/0x70 returned 0 after 0 msecs
calling  i2c_init+0x0/0x5f
initcall i2c_init+0x0/0x5f returned 0 after 0 msecs
calling  power_supply_class_init+0x0/0x34
initcall power_supply_class_init+0x0/0x34 returned 0 after 0 msecs
calling  hwmon_init+0x0/0x3b
initcall hwmon_init+0x0/0x3b returned 0 after 0 msecs
calling  thermal_init+0x0/0x51
initcall thermal_init+0x0/0x51 returned 0 after 0 msecs
calling  pci_acpi_init+0x0/0x96
PCI: Using ACPI for IRQ routing
initcall pci_acpi_init+0x0/0x96 returned 0 after 0 msecs
calling  pci_legacy_init+0x0/0x11d
initcall pci_legacy_init+0x0/0x11d returned 0 after 0 msecs
calling  pcibios_irq_init+0x0/0x4b2
initcall pcibios_irq_init+0x0/0x4b2 returned 0 after 0 msecs
calling  pcibios_init+0x0/0x74
initcall pcibios_init+0x0/0x74 returned 0 after 0 msecs
calling  proto_init+0x0/0x2e
initcall proto_init+0x0/0x2e returned 0 after 0 msecs
calling  net_dev_init+0x0/0x153
initcall net_dev_init+0x0/0x153 returned 0 after 0 msecs
calling  neigh_init+0x0/0x71
initcall neigh_init+0x0/0x71 returned 0 after 0 msecs
calling  fib_rules_init+0x0/0xa6
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 msecs
calling  genl_init+0x0/0xd9
initcall genl_init+0x0/0xd9 returned 0 after 15 msecs
calling  sysctl_init+0x0/0x2d
initcall sysctl_init+0x0/0x2d returned 0 after 0 msecs
calling  pci_iommu_init+0x0/0x12
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x12 returned 0 after 3 msecs
calling  hpet_late_init+0x0/0x10d
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
initcall hpet_late_init+0x0/0x10d returned 0 after 0 msecs
calling  clocksource_done_booting+0x0/0x12
initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 msecs
calling  init_pipe_fs+0x0/0x4c
initcall init_pipe_fs+0x0/0x4c returned 0 after 0 msecs
calling  init_mnt_writers+0x0/0x4f
initcall init_mnt_writers+0x0/0x4f returned 0 after 0 msecs
calling  eventpoll_init+0x0/0x85
initcall eventpoll_init+0x0/0x85 returned 0 after 0 msecs
calling  anon_inode_init+0x0/0x115
initcall anon_inode_init+0x0/0x115 returned 0 after 0 msecs
calling  acpi_rtc_init+0x0/0xf4
initcall acpi_rtc_init+0x0/0xf4 returned 0 after 0 msecs
calling  acpi_event_init+0x0/0x80
initcall acpi_event_init+0x0/0x80 returned 0 after 13 msecs
calling  pnp_system_init+0x0/0x12
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x73f has been reserved
system 00:01: ioport range 0x800-0x8fe has been reserved
system 00:01: ioport range 0x900-0x9fe has been reserved
system 00:01: ioport range 0x9ff-0x9ff has been reserved
system 00:01: ioport range 0xa00-0xafe has been reserved
system 00:01: ioport range 0xaff-0xaff has been reserved
system 00:01: ioport range 0xb00-0xbfe has been reserved
system 00:01: ioport range 0xbff-0xbff has been reserved
system 00:01: ioport range 0xc80-0xc83 has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
system 00:01: ioport range 0x3f8-0x3ff has been reserved
system 00:01: iomem range 0x80000000-0x8fffffff could not be reserved
system 00:01: iomem range 0xf7df0000-0xf7df0fff has been reserved
system 00:01: iomem range 0xfdef0000-0xfdef0fff has been reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 3 msecs
calling  chr_dev_init+0x0/0x98
initcall chr_dev_init+0x0/0x98 returned 0 after 0 msecs
calling  firmware_class_init+0x0/0x72
initcall firmware_class_init+0x0/0x72 returned 0 after 0 msecs
calling  loopback_init+0x0/0x12
initcall loopback_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_performance_init+0x0/0x12
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_userspace_init+0x0/0x12
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 msecs
calling  init_acpi_pm_clocksource+0x0/0xa4
initcall init_acpi_pm_clocksource+0x0/0xa4 returned 0 after 0 msecs
calling  ssb_modinit+0x0/0x4a
initcall ssb_modinit+0x0/0x4a returned 0 after 0 msecs
calling  pcibios_assign_resources+0x0/0x87
PCI: Bridge: 0000:00:09.0
  IO window: 1000-2fff
  MEM window: 0xf7e00000-0xf7ffffff
  PREFETCH window: 0x00000000e8000000-0x00000000efffffff
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: 0xf8000000-0xf9ffffff
  PREFETCH window: 0x0000000090000000-0x00000000900fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: 0xf8000000-0xf9ffffff
  PREFETCH window: 0x0000000090000000-0x00000000900fffff
PCI: Bridge: 0000:04:00.0
  IO window: disabled.
  MEM window: 0xfa000000-0xfbffffff
  PREFETCH window: 0x0000000090100000-0x00000000901fffff
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: 0xfa000000-0xfbffffff
  PREFETCH window: 0x0000000090100000-0x00000000901fffff
PCI: Bridge: 0000:06:00.0
  IO window: disabled.
  MEM window: 0xfdc00000-0xfdcfffff
  PREFETCH window: 0x0000000090200000-0x00000000902fffff
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: 0xfdc00000-0xfdcfffff
  PREFETCH window: 0x0000000090200000-0x00000000902fffff
PCI: Bridge: 0000:00:0e.0
  IO window: 3000-3fff
  MEM window: 0xfdd00000-0xfddfffff
  PREFETCH window: 0x0000000090300000-0x00000000903fffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:04:00.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:06:00.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:42:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:41:00.0
  IO window: 4000-4fff
  MEM window: 0xfdf00000-0xfdffffff
  PREFETCH window: 0x0000000084000000-0x00000000840fffff
PCI: Bridge: 0000:40:0c.0
  IO window: 4000-4fff
  MEM window: 0xfdf00000-0xfdffffff
  PREFETCH window: 0x0000000084000000-0x00000000840fffff
PCI: Bridge: 0000:40:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:40:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:40:0c.0 to 64
PCI: Setting latency timer of device 0000:41:00.0 to 64
PCI: Setting latency timer of device 0000:40:0d.0 to 64
PCI: Setting latency timer of device 0000:40:0e.0 to 64
initcall pcibios_assign_resources+0x0/0x87 returned 0 after 11 msecs
calling  inet_init+0x0/0x350
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x350 returned 0 after 64 msecs
calling  af_unix_init+0x0/0x55
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 4 msecs
calling  populate_rootfs+0x0/0xea
checking if image is initramfs... it is
Freeing initrd memory: 1321k freed
initcall populate_rootfs+0x0/0xea returned 0 after 162 msecs
calling  i8259A_init_sysfs+0x0/0x22
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 0 msecs
calling  vsyscall_init+0x0/0x6e
initcall vsyscall_init+0x0/0x6e returned 0 after 0 msecs
calling  sbf_init+0x0/0xd7
initcall sbf_init+0x0/0xd7 returned 0 after 0 msecs
calling  i8237A_init_sysfs+0x0/0x22
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 0 msecs
calling  add_rtc_cmos+0x0/0x1d
initcall add_rtc_cmos+0x0/0x1d returned 0 after 0 msecs
calling  cache_sysfs_init+0x0/0x5d
initcall cache_sysfs_init+0x0/0x5d returned 0 after 1 msecs
calling  mce_init_device+0x0/0x85
initcall mce_init_device+0x0/0x85 returned 0 after 0 msecs
calling  periodic_mcheck_init+0x0/0x3f
initcall periodic_mcheck_init+0x0/0x3f returned 0 after 0 msecs
calling  thermal_throttle_init_device+0x0/0x83
initcall thermal_throttle_init_device+0x0/0x83 returned 0 after 0 msecs
calling  threshold_init_device+0x0/0x49
initcall threshold_init_device+0x0/0x49 returned 0 after 0 msecs
calling  msr_init+0x0/0xf2
initcall msr_init+0x0/0xf2 returned 0 after 0 msecs
calling  cpuid_init+0x0/0xf2
initcall cpuid_init+0x0/0xf2 returned 0 after 0 msecs
calling  microcode_init+0x0/0xbf
microcode: CPU0 not a capable Intel processor
microcode: CPU1 not a capable Intel processor
microcode: CPU2 not a capable Intel processor
microcode: CPU3 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
initcall microcode_init+0x0/0xbf returned 0 after 1 msecs
calling  init_lapic_sysfs+0x0/0x2d
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 msecs
calling  ioapic_init_sysfs+0x0/0x99
initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 0 msecs
calling  add_pcspkr+0x0/0x43
initcall add_pcspkr+0x0/0x43 returned 0 after 0 msecs
calling  audit_classes_init+0x0/0xaf
initcall audit_classes_init+0x0/0xaf returned 0 after 0 msecs
calling  init_vdso_vars+0x0/0x1e7
initcall init_vdso_vars+0x0/0x1e7 returned 0 after 0 msecs
calling  ia32_binfmt_init+0x0/0x14
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 msecs
calling  sysenter_setup+0x0/0x29f
initcall sysenter_setup+0x0/0x29f returned 0 after 0 msecs
calling  init_aout_binfmt+0x0/0x12
initcall init_aout_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  create_proc_profile+0x0/0x307
initcall create_proc_profile+0x0/0x307 returned 0 after 0 msecs
calling  ioresources_init+0x0/0x3c
initcall ioresources_init+0x0/0x3c returned 0 after 0 msecs
calling  uid_cache_init+0x0/0x69
initcall uid_cache_init+0x0/0x69 returned 0 after 0 msecs
calling  init_posix_timers+0x0/0xb6
initcall init_posix_timers+0x0/0xb6 returned 0 after 0 msecs
calling  init_posix_cpu_timers+0x0/0xd4
initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 msecs
calling  nsproxy_cache_init+0x0/0x2d
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 msecs
calling  timekeeping_init_device+0x0/0x22
initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 msecs
calling  init_clocksource_sysfs+0x0/0x50
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 msecs
calling  init_timer_list_procfs+0x0/0x2c
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 msecs
calling  init_tstats_procfs+0x0/0x2c
initcall init_tstats_procfs+0x0/0x2c returned 0 after 0 msecs
calling  futex_init+0x0/0x63
initcall futex_init+0x0/0x63 returned 0 after 0 msecs
calling  proc_dma_init+0x0/0x22
initcall proc_dma_init+0x0/0x22 returned 0 after 0 msecs
calling  percpu_modinit+0x0/0x6f
initcall percpu_modinit+0x0/0x6f returned 0 after 0 msecs
calling  kallsyms_init+0x0/0x25
initcall kallsyms_init+0x0/0x25 returned 0 after 0 msecs
calling  snapshot_device_init+0x0/0x12
initcall snapshot_device_init+0x0/0x12 returned 0 after 0 msecs
calling  crash_save_vmcoreinfo_init+0x0/0x42b
initcall crash_save_vmcoreinfo_init+0x0/0x42b returned 0 after 0 msecs
calling  crash_notes_memory_init+0x0/0x3d
initcall crash_notes_memory_init+0x0/0x3d returned 0 after 0 msecs
calling  ikconfig_init+0x0/0x39
initcall ikconfig_init+0x0/0x39 returned 0 after 0 msecs
calling  audit_init+0x0/0x14d
audit: initializing netlink socket (disabled)
type=3D2000 audit(1215277563.875:1): initialized
initcall audit_init+0x0/0x14d returned 0 after 0 msecs
calling  audit_tree_init+0x0/0x49
initcall audit_tree_init+0x0/0x49 returned 0 after 0 msecs
calling  init_kprobes+0x0/0x103
initcall init_kprobes+0x0/0x103 returned 0 after 5 msecs
calling  relay_init+0x0/0x14
initcall relay_init+0x0/0x14 returned 0 after 0 msecs
calling  utsname_sysctl_init+0x0/0x14
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 msecs
calling  init_per_zone_pages_min+0x0/0x53
initcall init_per_zone_pages_min+0x0/0x53 returned 0 after 0 msecs
calling  pdflush_init+0x0/0x1d
initcall pdflush_init+0x0/0x1d returned 0 after 0 msecs
calling  kswapd_init+0x0/0x63
initcall kswapd_init+0x0/0x63 returned 0 after 0 msecs
calling  setup_vmstat+0x0/0x4a
initcall setup_vmstat+0x0/0x4a returned 0 after 0 msecs
calling  procswaps_init+0x0/0x22
initcall procswaps_init+0x0/0x22 returned 0 after 0 msecs
calling  hugetlb_init+0x0/0x98
Total HugeTLB memory allocated, 0
initcall hugetlb_init+0x0/0x98 returned 0 after 0 msecs
calling  init_tmpfs+0x0/0xda
initcall init_tmpfs+0x0/0xda returned 0 after 0 msecs
calling  slab_sysfs_init+0x0/0xf0
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 5 msecs
calling  fasync_init+0x0/0x2a
initcall fasync_init+0x0/0x2a returned 0 after 0 msecs
calling  aio_setup+0x0/0x6e
initcall aio_setup+0x0/0x6e returned 0 after 0 msecs
calling  inotify_setup+0x0/0x12
initcall inotify_setup+0x0/0x12 returned 0 after 0 msecs
calling  inotify_user_setup+0x0/0xb8
initcall inotify_user_setup+0x0/0xb8 returned 0 after 0 msecs
calling  init_sys32_ioctl+0x0/0x85
initcall init_sys32_ioctl+0x0/0x85 returned 0 after 0 msecs
calling  init_mbcache+0x0/0x14
initcall init_mbcache+0x0/0x14 returned 0 after 0 msecs
calling  dnotify_init+0x0/0x2a
initcall dnotify_init+0x0/0x2a returned 0 after 0 msecs
calling  vmcore_init+0x0/0x894
initcall vmcore_init+0x0/0x894 returned 0 after 0 msecs
calling  configfs_init+0x0/0xb3
initcall configfs_init+0x0/0xb3 returned 0 after 0 msecs
calling  init_devpts_fs+0x0/0x3f
initcall init_devpts_fs+0x0/0x3f returned 0 after 0 msecs
calling  init_ext3_fs+0x0/0x6a
initcall init_ext3_fs+0x0/0x6a returned 0 after 0 msecs
calling  journal_init+0x0/0x99
initcall journal_init+0x0/0x99 returned 0 after 0 msecs
calling  init_ext2_fs+0x0/0x6a
initcall init_ext2_fs+0x0/0x6a returned 0 after 0 msecs
calling  init_ramfs_fs+0x0/0x12
initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_hugetlbfs_fs+0x0/0x98
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 0 msecs
calling  init_fat_fs+0x0/0x4f
initcall init_fat_fs+0x0/0x4f returned 0 after 0 msecs
calling  init_msdos_fs+0x0/0x12
initcall init_msdos_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_vfat_fs+0x0/0x12
initcall init_vfat_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_iso9660_fs+0x0/0x6c
initcall init_iso9660_fs+0x0/0x6c returned 0 after 0 msecs
calling  init_nfs_fs+0x0/0x10e
initcall init_nfs_fs+0x0/0x10e returned 0 after 0 msecs
calling  init_nfsd+0x0/0xbb
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0xbb returned 0 after 0 msecs
calling  init_nlm+0x0/0x22
initcall init_nlm+0x0/0x22 returned 0 after 0 msecs
calling  init_nls_cp437+0x0/0x12
initcall init_nls_cp437+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp850+0x0/0x12
initcall init_nls_cp850+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_ascii+0x0/0x12
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_1+0x0/0x12
initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_15+0x0/0x12
initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_utf8+0x0/0x25
initcall init_nls_utf8+0x0/0x25 returned 0 after 0 msecs
calling  ipc_init+0x0/0x23
msgmni has been set to 16013
initcall ipc_init+0x0/0x23 returned 0 after 0 msecs
calling  ipc_sysctl_init+0x0/0x14
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 0 msecs
calling  init_mqueue_fs+0x0/0xc6
initcall init_mqueue_fs+0x0/0xc6 returned 0 after 0 msecs
calling  crypto_algapi_init+0x0/0xd
initcall crypto_algapi_init+0x0/0xd returned 0 after 0 msecs
calling  blkcipher_module_init+0x0/0x2a
initcall blkcipher_module_init+0x0/0x2a returned 0 after 0 msecs
calling  cryptomgr_init+0x0/0x12
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 msecs
calling  hmac_module_init+0x0/0x12
initcall hmac_module_init+0x0/0x12 returned 0 after 0 msecs
calling  md5_mod_init+0x0/0x12
initcall md5_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  sha1_generic_mod_init+0x0/0x12
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crypto_cbc_module_init+0x0/0x12
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  des_generic_mod_init+0x0/0x3f
initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  cast5_mod_init+0x0/0x12
initcall cast5_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  deflate_mod_init+0x0/0x12
initcall deflate_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crc32c_mod_init+0x0/0x12
initcall crc32c_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crypto_authenc_module_init+0x0/0x12
initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  bsg_init+0x0/0x11f
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
initcall bsg_init+0x0/0x11f returned 0 after 0 msecs
calling  noop_init+0x0/0x14
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 0 msecs
calling  as_init+0x0/0x14
io scheduler anticipatory registered
initcall as_init+0x0/0x14 returned 0 after 0 msecs
calling  deadline_init+0x0/0x14
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 0 msecs
calling  cfq_init+0x0/0x9d
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x9d returned 0 after 0 msecs
calling  percpu_counter_startup+0x0/0x14
initcall percpu_counter_startup+0x0/0x14 returned 0 after 0 msecs
calling  pci_init+0x0/0x35
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:00.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Enabling HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Enabling HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
initcall pci_init+0x0/0x35 returned 0 after 3 msecs
calling  pci_proc_init+0x0/0x6a
initcall pci_proc_init+0x0/0x6a returned 0 after 0 msecs
calling  pcie_portdrv_init+0x0/0x4d
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie01]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie01]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie01]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie01]
Allocate Port Service[0000:00:0e.0:pcie03]
PCI: Setting latency timer of device 0000:40:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0c.0:pcie00]
Allocate Port Service[0000:40:0c.0:pcie01]
Allocate Port Service[0000:40:0c.0:pcie03]
PCI: Setting latency timer of device 0000:40:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0d.0:pcie00]
Allocate Port Service[0000:40:0d.0:pcie01]
Allocate Port Service[0000:40:0d.0:pcie03]
PCI: Setting latency timer of device 0000:40:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0e.0:pcie00]
Allocate Port Service[0000:40:0e.0:pcie01]
Allocate Port Service[0000:40:0e.0:pcie03]
initcall pcie_portdrv_init+0x0/0x4d returned 0 after 9 msecs
calling  fb_console_init+0x0/0x129
initcall fb_console_init+0x0/0x129 returned 0 after 0 msecs
calling  rivafb_init+0x0/0x1a5
initcall rivafb_init+0x0/0x1a5 returned 0 after 0 msecs
calling  nvidiafb_init+0x0/0x2b6
initcall nvidiafb_init+0x0/0x2b6 returned 0 after 0 msecs
calling  vt8623fb_init+0x0/0x5f
initcall vt8623fb_init+0x0/0x5f returned 0 after 0 msecs
calling  vesafb_init+0x0/0x235
initcall vesafb_init+0x0/0x235 returned 0 after 0 msecs
calling  acpi_reserve_resources+0x0/0xeb
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 msecs
calling  acpi_ac_init+0x0/0x45
initcall acpi_ac_init+0x0/0x45 returned 0 after 0 msecs
calling  acpi_button_init+0x0/0x5e
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
initcall acpi_button_init+0x0/0x5e returned 0 after 0 msecs
calling  acpi_fan_init+0x0/0x5e
initcall acpi_fan_init+0x0/0x5e returned 0 after 0 msecs
calling  irqrouter_init_sysfs+0x0/0x38
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  acpi_processor_init+0x0/0x113
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: ACPI0007:03 is registered as cooling_device3
initcall acpi_processor_init+0x0/0x113 returned 0 after 1 msecs
calling  acpi_container_init+0x0/0x42
initcall acpi_container_init+0x0/0x42 returned 0 after 1 msecs
calling  acpi_thermal_init+0x0/0x83
initcall acpi_thermal_init+0x0/0x83 returned 0 after 0 msecs
calling  rand_initialize+0x0/0x2c
initcall rand_initialize+0x0/0x2c returned 0 after 0 msecs
calling  tty_init+0x0/0x1c5
initcall tty_init+0x0/0x1c5 returned 0 after 23 msecs
calling  pty_init+0x0/0x275
initcall pty_init+0x0/0x275 returned 0 after 0 msecs
calling  raw_init+0x0/0xd4
initcall raw_init+0x0/0xd4 returned 0 after 0 msecs
calling  hpet_init+0x0/0x6a
hpet_resources: 0xfed00000 is busy
initcall hpet_init+0x0/0x6a returned 0 after 0 msecs
calling  nvram_init+0x0/0x8a
Non-volatile memory driver v1.2
initcall nvram_init+0x0/0x8a returned 0 after 0 msecs
calling  mod_init+0x0/0x1fb
initcall mod_init+0x0/0x1fb returned -19 after 0 msecs
calling  mod_init+0x0/0xba
initcall mod_init+0x0/0xba returned -19 after 0 msecs
calling  agp_init+0x0/0x26
Linux agpgart interface v0.103
initcall agp_init+0x0/0x26 returned 0 after 0 msecs
calling  agp_intel_init+0x0/0x29
initcall agp_intel_init+0x0/0x29 returned 0 after 0 msecs
calling  agp_via_init+0x0/0x29
initcall agp_via_init+0x0/0x29 returned 0 after 0 msecs
calling  drm_core_init+0x0/0xf9
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0xf9 returned 0 after 0 msecs
calling  r128_init+0x0/0x1e
initcall r128_init+0x0/0x1e returned 0 after 0 msecs
calling  radeon_init+0x0/0x1e
ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 18
ACPI: PCI Interrupt 0000:01:03.0[A] -> Link [LNKY] -> GSI 18 (level, high) =
-> IRQ 18
[drm] Initialized radeon 1.29.0 20080528 on minor 0
initcall radeon_init+0x0/0x1e returned 0 after 2 msecs
calling  via_init+0x0/0x23
initcall via_init+0x0/0x23 returned 0 after 0 msecs
calling  ipmi_init_msghandler_mod+0x0/0xd
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 0 msecs
calling  init_ipmi_devintf+0x0/0xfa
ipmi device interface
initcall init_ipmi_devintf+0x0/0xfa returned 0 after 0 msecs
calling  init_ipmi_si+0x0/0x78e
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x20, irq 0
Clocksource tsc unstable (delta =3D 55276278528 ns)
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slav=
e address 0x0, irq 0
ipmi_si: duplicate interface
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:04.6[A] -> Link [LNKW] -> GSI 16 (level, high) =
-> IRQ 16
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7ef0000, =
slave address 0x0, irq 16
  Using irq 16
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: =
0x11)
IPMI kcs interface initialized
initcall init_ipmi_si+0x0/0x78e returned 0 after 191 msecs
calling  ipmi_wdog_init+0x0/0x12e
IPMI Watchdog: driver initialized
initcall ipmi_wdog_init+0x0/0x12e returned 0 after 6 msecs
calling  ipmi_poweroff_init+0x0/0x8d
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
initcall ipmi_poweroff_init+0x0/0x8d returned 0 after 44 msecs
calling  hangcheck_init+0x0/0x8a
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 6=
0 seconds).
Hangcheck: Using get_cycles().
initcall hangcheck_init+0x0/0x8a returned 0 after 0 msecs
calling  cn_proc_init+0x0/0x3d
initcall cn_proc_init+0x0/0x3d returned 0 after 0 msecs
calling  serial8250_init+0x0/0x131
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_init+0x0/0x131 returned 0 after 1 msecs
calling  serial8250_pnp_init+0x0/0x12
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 0 msecs
calling  serial8250_pci_init+0x0/0x1b
initcall serial8250_pci_init+0x0/0x1b returned 0 after 0 msecs
calling  topology_sysfs_init+0x0/0x49
initcall topology_sysfs_init+0x0/0x49 returned 0 after 0 msecs
calling  floppy_init+0x0/0xf0f
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
initcall floppy_init+0x0/0xf0f returned -19 after 2874 msecs
calling  brd_init+0x0/0x167
brd: module loaded
initcall brd_init+0x0/0x167 returned 0 after 3 msecs
calling  bnx2_init+0x0/0x1b
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.5 (April 29, 2008)
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNKX] -> GSI 17 (level, high) =
-> IRQ 17
eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem f8000000, IRQ 17, node addr 00:18:fe:35:26:f6
ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [LNKW] -> GSI 16 (level, high) =
-> IRQ 16
eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem fa000000, IRQ 16, node addr 00:18:fe:35:26:f4
initcall bnx2_init+0x0/0x1b returned 0 after 48 msecs
calling  net_olddevs_init+0x0/0xa0
initcall net_olddevs_init+0x0/0xa0 returned 0 after 0 msecs
calling  b44_init+0x0/0x63
initcall b44_init+0x0/0x63 returned 0 after 0 msecs
calling  tun_init+0x0/0xa0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall tun_init+0x0/0xa0 returned 0 after 0 msecs
calling  init_netconsole+0x0/0x1b5
netconsole: local port 54556
netconsole: local IP 139.185.50.77
netconsole: interface eth0
netconsole: remote port 54556
netconsole: remote IP 139.185.50.76
netconsole: remote ethernet address 00:18:fe:34:1c:3d
netconsole: device eth0 not up yet, forcing it
bnx2: eth0: using MSI
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
bnx2: eth0 NIC SerDes Link is Up, 1000 Mbps full duplex
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1b5 returned 0 after 4150 msecs
calling  scsi_tgt_init+0x0/0x7f
initcall scsi_tgt_init+0x0/0x7f returned 0 after 0 msecs
calling  raid_init+0x0/0x12
initcall raid_init+0x0/0x12 returned 0 after 0 msecs
calling  spi_transport_init+0x0/0x2e
initcall spi_transport_init+0x0/0x2e returned 0 after 0 msecs
calling  fc_transport_init+0x0/0x4c
initcall fc_transport_init+0x0/0x4c returned 0 after 0 msecs
calling  iscsi_transport_init+0x0/0x118
Loading iSCSI transport class v2.0-869.
initcall iscsi_transport_init+0x0/0x118 returned 0 after 0 msecs
calling  sas_transport_init+0x0/0xbb
initcall sas_transport_init+0x0/0xbb returned 0 after 0 msecs
calling  sas_class_init+0x0/0x31
initcall sas_class_init+0x0/0x31 returned 0 after 0 msecs
calling  init_sd+0x0/0xff
Driver 'sd' needs updating - please use bus_type methods
initcall init_sd+0x0/0xff returned 0 after 0 msecs
calling  init_sg+0x0/0x153
initcall init_sg+0x0/0x153 returned 0 after 0 msecs
calling  mon_init+0x0/0x103
initcall mon_init+0x0/0x103 returned 0 after 0 msecs
calling  i8042_init+0x0/0x39f
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x39f returned 0 after 2 msecs
calling  serport_init+0x0/0x34
initcall serport_init+0x0/0x34 returned 0 after 0 msecs
calling  serio_raw_init+0x0/0x1b
initcall serio_raw_init+0x0/0x1b returned 0 after 0 msecs
calling  mousedev_init+0x0/0x61
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x61 returned 0 after 0 msecs
calling  evdev_init+0x0/0x12
initcall evdev_init+0x0/0x12 returned 0 after 17 msecs
calling  atkbd_init+0x0/0x27
initcall atkbd_init+0x0/0x27 returned 0 after 0 msecs
calling  psmouse_init+0x0/0x6d
initcall psmouse_init+0x0/0x6d returned 0 after 57 msecs
calling  pcspkr_init+0x0/0x12
input: PC Speaker as /class/input/input1
initcall pcspkr_init+0x0/0x12 returned 0 after 32 msecs
calling  uinput_init+0x0/0x12
initcall uinput_init+0x0/0x12 returned 0 after 0 msecs
calling  cmos_init+0x0/0x30
initcall cmos_init+0x0/0x30 returned 0 after 0 msecs
calling  i2c_dev_init+0x0/0x9f
i2c /dev entries driver
initcall i2c_dev_init+0x0/0x9f returned 0 after 0 msecs
calling  amd756_init+0x0/0x1b
initcall amd756_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_amd8111_init+0x0/0x1b
initcall i2c_amd8111_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_i801_init+0x0/0x1b
initcall i2c_i801_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_i810_init+0x0/0x1b
initcall i2c_i810_init+0x0/0x1b returned 0 after 0 msecs
calling  nforce2_init+0x0/0x1b
initcall nforce2_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_piix4_init+0x0/0x1b
initcall i2c_piix4_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_vt586b_init+0x0/0x1b
initcall i2c_vt586b_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_vt596_init+0x0/0x1b
initcall i2c_vt596_init+0x0/0x1b returned 0 after 0 msecs
calling  coretemp_init+0x0/0x158
initcall coretemp_init+0x0/0x158 returned -19 after 0 msecs
calling  k8temp_init+0x0/0x1b
initcall k8temp_init+0x0/0x1b returned 0 after 0 msecs
calling  sm_via686a_init+0x0/0x1b
initcall sm_via686a_init+0x0/0x1b returned 0 after 0 msecs
calling  vt1211_init+0x0/0x14e
initcall vt1211_init+0x0/0x14e returned -19 after 0 msecs
calling  sm_vt8231_init+0x0/0x1b
initcall sm_vt8231_init+0x0/0x1b returned 0 after 0 msecs
calling  watchdog_init+0x0/0xb4
SoftDog: cannot register miscdev on minor=3D130 (err=3D-16)
initcall watchdog_init+0x0/0xb4 returned -16 after 0 msecs
initcall watchdog_init+0x0/0xb4 returned with error code -16=20
calling  edac_init+0x0/0x9d
EDAC MC: Ver: 2.1.0 Jul  5 2008
initcall edac_init+0x0/0x9d returned 0 after 0 msecs
calling  i5000_init+0x0/0x41
initcall i5000_init+0x0/0x41 returned 0 after 0 msecs
calling  e752x_init+0x0/0x42
initcall e752x_init+0x0/0x42 returned 0 after 0 msecs
calling  i82975x_init+0x0/0xa0
initcall i82975x_init+0x0/0xa0 returned -19 after 0 msecs
calling  cpufreq_stats_init+0x0/0x8f
initcall cpufreq_stats_init+0x0/0x8f returned 0 after 0 msecs
calling  cpufreq_gov_powersave_init+0x0/0x12
initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_dbs_init+0x0/0x46
initcall cpufreq_gov_dbs_init+0x0/0x46 returned 0 after 0 msecs
calling  cpufreq_gov_dbs_init+0x0/0x12
initcall cpufreq_gov_dbs_init+0x0/0x12 returned 0 after 0 msecs
calling  init_ladder+0x0/0x12
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 0 msecs
calling  hid_init+0x0/0x8
initcall hid_init+0x0/0x8 returned 0 after 0 msecs
calling  hid_init+0x0/0x61
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
initcall hid_init+0x0/0x61 returned 0 after 0 msecs
calling  sysctl_core_init+0x0/0x12
initcall sysctl_core_init+0x0/0x12 returned 0 after 0 msecs
calling  flow_cache_init+0x0/0x1a7
initcall flow_cache_init+0x0/0x1a7 returned 0 after 0 msecs
calling  sysctl_ipv4_init+0x0/0x4e
initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 0 msecs
calling  ipip_init+0x0/0x71
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x71 returned 0 after 0 msecs
calling  ipgre_init+0x0/0x71
GRE over IPv4 tunneling driver
initcall ipgre_init+0x0/0x71 returned 0 after 0 msecs
calling  init_syncookies+0x0/0x19
initcall init_syncookies+0x0/0x19 returned 0 after 0 msecs
calling  ah4_init+0x0/0x68
initcall ah4_init+0x0/0x68 returned 0 after 0 msecs
calling  esp4_init+0x0/0x68
initcall esp4_init+0x0/0x68 returned 0 after 0 msecs
calling  ipcomp4_init+0x0/0x68
initcall ipcomp4_init+0x0/0x68 returned 0 after 0 msecs
calling  ipip_init+0x0/0x68
initcall ipip_init+0x0/0x68 returned 0 after 0 msecs
calling  xfrm4_beet_init+0x0/0x17
initcall xfrm4_beet_init+0x0/0x17 returned 0 after 0 msecs
calling  tunnel4_init+0x0/0x32
initcall tunnel4_init+0x0/0x32 returned 0 after 0 msecs
calling  xfrm4_transport_init+0x0/0x17
initcall xfrm4_transport_init+0x0/0x17 returned 0 after 0 msecs
calling  xfrm4_mode_tunnel_init+0x0/0x17
initcall xfrm4_mode_tunnel_init+0x0/0x17 returned 0 after 0 msecs
calling  inet_diag_init+0x0/0x69
initcall inet_diag_init+0x0/0x69 returned 0 after 0 msecs
calling  tcp_diag_init+0x0/0x12
initcall tcp_diag_init+0x0/0x12 returned 0 after 0 msecs
calling  bictcp_register+0x0/0x12
TCP bic registered
initcall bictcp_register+0x0/0x12 returned 0 after 0 msecs
calling  xfrm_user_init+0x0/0x58
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x58 returned 0 after 0 msecs
calling  packet_init+0x0/0x47
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 0 msecs
calling  ipsec_pfkey_init+0x0/0x8c
NET: Registered protocol family 15
initcall ipsec_pfkey_init+0x0/0x8c returned 0 after 0 msecs
calling  init_sunrpc+0x0/0x5d
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
initcall init_sunrpc+0x0/0x5d returned 0 after 0 msecs
calling  init_rpcsec_gss+0x0/0x38
initcall init_rpcsec_gss+0x0/0x38 returned 0 after 0 msecs
calling  init_kerberos_module+0x0/0x2f
initcall init_kerberos_module+0x0/0x2f returned 0 after 0 msecs
calling  init_spkm3_module+0x0/0x2f
initcall init_spkm3_module+0x0/0x2f returned 0 after 0 msecs
calling  powernowk8_init+0x0/0x8f
powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 8218 processors (4=
 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
initcall powernowk8_init+0x0/0x8f returned 0 after 8 msecs
calling  acpi_cpufreq_init+0x0/0x8f
initcall acpi_cpufreq_init+0x0/0x8f returned -16 after 0 msecs
initcall acpi_cpufreq_init+0x0/0x8f returned with error code -16=20
calling  centrino_init+0x0/0x33
initcall centrino_init+0x0/0x33 returned -19 after 0 msecs
calling  cpufreq_p4_init+0x0/0x60
initcall cpufreq_p4_init+0x0/0x60 returned -19 after 0 msecs
calling  hpet_insert_resource+0x0/0x23
initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x40
initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x38
initcall init_lapic_nmi_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x4f
initcall ioapic_insert_resources+0x0/0x4f returned 0 after 0 msecs
calling  init_oops_id+0x0/0x23
initcall init_oops_id+0x0/0x23 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x3a
initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0x61
initcall pm_qos_power_init+0x0/0x61 returned 0 after 0 msecs
calling  software_resume+0x0/0x13f
initcall software_resume+0x0/0x13f returned -2 after 0 msecs
initcall software_resume+0x0/0x13f returned with error code -2=20
calling  debugfs_kprobe_init+0x0/0x89
initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 0 msecs
calling  taskstats_init+0x0/0x95
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 0 msecs
calling  random32_reseed+0x0/0x69
initcall random32_reseed+0x0/0x69 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x4c
initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xa5
initcall acpi_wakeup_device_init+0x0/0xa5 returned 0 after 0 msecs
calling  acpi_sleep_proc_init+0x0/0x55
initcall acpi_sleep_proc_init+0x0/0x55 returned 0 after 0 msecs
calling  seqgen_init+0x0/0xf
initcall seqgen_init+0x0/0xf returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0xe5
initcall scsi_complete_async_scans+0x0/0xe5 returned 0 after 0 msecs
calling  rtc_hctosys+0x0/0x17b
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
initcall rtc_hctosys+0x0/0x17b returned -19 after 0 msecs
calling  edd_init+0x0/0x2f1
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
initcall edd_init+0x0/0x2f1 returned -19 after 0 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x43
initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x12
initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 msecs
Freeing unused kernel memory: 344k freed
Write protecting the kernel read-only data: 4568k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:01:04.4[B] -> Link [LNKX] -> GSI 17 (level, high) =
-> IRQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 1
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
insmod used greatest stack depth: 5360 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNU0] -> GSI 22 (level, high) =
-> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7de0000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
insmod used greatest stack depth: 5336 bytes left
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNU2] -> GSI 23 (level, high) =
-> IRQ 23
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7dd0000
usb 1-1: new full speed USB device using uhci_hcd and address 2
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 10 ports detected
HP CISS Driver (v 3.6.20)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
ACPI: PCI Interrupt 0000:42:08.0[A] -> Link [LNKA] -> GSI 54 (level, high) =
-> IRQ 54
usb 1-1: configuration #1 chosen from 1 choice
input: HP Virtual Keyboard as /class/input/input2
cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 503 using DAC
input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
input: HP Virtual Keyboard as /class/input/input3
input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
usb 1-2: new full speed USB device using uhci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 7 ports detected
      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

 cciss/c0d0: p1 p2 p3 p4
      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

 cciss/c0d1: p1 p2
insmod used greatest stack depth: 4384 bytes left
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
modprobe used greatest stack depth: 3584 bytes left
Emulex LightPulse Fibre Channel SCSI driver 8.2.6
Copyright(c) 2004-2008 Emulex.  All rights reserved.
ACPI: PCI Interrupt 0000:08:00.0[A] -> Link [LNKY] -> GSI 18 (level, high) =
-> IRQ 18
PCI: Setting latency timer of device 0000:08:00.0 to 64
scsi0 :  on PCI bus 08 device 00 irq 18
lpfc 0000:08:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x4 x2
scsi 0:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:0:0: Attached scsi generic sg0 type 12
scsi 0:0:1:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 0:0:1:0: Attached scsi generic sg1 type 12
scsi 0:0:1:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 0:0:1:8: [sda] 2187605616 512-byte hardware sectors (1120054 MB)
sd 0:0:1:8: [sda] Write Protect is off
sd 0:0:1:8: [sda] Mode Sense: 83 00 00 08
sd 0:0:1:8: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:1:8: [sda] 2187605616 512-byte hardware sectors (1120054 MB)
sd 0:0:1:8: [sda] Write Protect is off
sd 0:0:1:8: [sda] Mode Sense: 83 00 00 08
sd 0:0:1:8: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1
sd 0:0:1:8: [sda] Attached SCSI disk
sd 0:0:1:8: Attached scsi generic sg2 type 0
tg3.c:v3.92.1 (June 9, 2008)
ACPI: PCI Interrupt Link [LNKZ] enabled at IRQ 19
ACPI: PCI Interrupt 0000:07:04.0[A] -> <6>ACPI: PCI Interrupt 0000:08:00.1[=
B] -> Link [LNKZ] -> GSI 19 (level, high) -> IRQ 19
PCI: Setting latency timer of device 0000:08:00.1 to 64
Link [LNKZ] -> GSI 19 (level, high) -> IRQ 19
scsi1 :  on PCI bus 08 device 01 irq 19
eth2: Tigon3 [partno(011276-001) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 1=
000Base-SX Ethernet 00:18:fe:34:1c:2f
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth2: dma_rwctrl[76148000] dma_mask[40-bit]
ACPI: PCI Interrupt 0000:07:04.1[B] -> Link [LNKW] -> GSI 16 (level, high) =
-> IRQ 16
eth3: Tigon3 [partno(011276-001) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 1=
000Base-SX Ethernet 00:18:fe:34:1c:30
eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth3: dma_rwctrl[76148000] dma_mask[40-bit]
lpfc 0000:08:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x4 x2
scsi 1:0:0:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:0:0: Attached scsi generic sg3 type 12
scsi 1:0:1:0: RAID              COMPAQ   MSA1000          5.20 PQ: 0 ANSI: 4
scsi 1:0:1:0: Attached scsi generic sg4 type 12
scsi 1:0:1:8: Direct-Access     COMPAQ   MSA1000 VOLUME   5.20 PQ: 0 ANSI: 4
sd 1:0:1:8: [sdb] 2187605616 512-byte hardware sectors (1120054 MB)
sd 1:0:1:8: [sdb] Write Protect is off
sd 1:0:1:8: [sdb] Mode Sense: 83 00 00 08
sd 1:0:1:8: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 1:0:1:8: [sdb] 2187605616 512-byte hardware sectors (1120054 MB)
sd 1:0:1:8: [sdb] Write Protect is off
sd 1:0:1:8: [sdb] Mode Sense: 83 00 00 08
sd 1:0:1:8: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sdb: sdb1
sd 1:0:1:8: [sdb] Attached SCSI disk
sd 1:0:1:8: Attached scsi generic sg5 type 0
lp: driver loaded but no devices found
EXT3 FS on cciss/c0d0p3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on cciss/c0d1p1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on cciss/c0d1p2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
Adding 8385920k swap on /dev/cciss/c0d0p2.  Priority:-1 extents:1 across:83=
85920k
rc.sysinit used greatest stack depth: 3568 bytes left
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
 rport-0:0-5: blocked FC remote port time out: removing rport
 rport-1:0-6: blocked FC remote port time out: removing rport
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
6-1.test[16307]: segfault at 2713 ip 338ac04c36 sp 7fffcf628020 error 4 in =
librt-2.5.so[338ac00000+7000]
12-1.test[16435]: segfault at 2713 ip 338ac04c84 sp 7fffeb5ddfd0 error 4 in=
 librt-2.5.so[338ac00000+7000]
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
5-1.test[21266]: segfault at 601000 ip 338b00acd2 sp 7fff5ba23428 error 6 i=
n libpthread-2.5.so[338b000000+15000]
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
6-2.test[22932]: segfault at 2b7629778000 ip 400b1c sp 7fff81332c60 error 4=
 in 6-2.test[400000+1000]
6-1.test[22961]: segfault at 2ad6621fe000 ip 400a87 sp 7fff488ab1e0 error 6=
 in 6-1.test[400000+1000]
6-3.test[23086]: segfault at 2ac1be77c000 ip 400ace sp 7fffec32cc60 error 6=
 in 6-3.test[400000+1000]
5-1.test[23750]: segfault at 186a3 ip 338ac04b59 sp 7fff3b3bcdd0 error 4 in=
 librt-2.5.so[338ac00000+7000]
2-2.test[26264]: segfault at 3a00000000 ip 3a00000000 sp 7fffb7ae4520 error=
 14 in ld-2.5.so[3a93400000+1a000]
2-3.test[27100]: segfault at 3a00000000 ip 3a00000000 sp 7ffff4aae4f0 error=
 14 in ld-2.5.so[3a93400000+1a000]
3-2.test[28610]: segfault at 412e3fe8 ip 3a938961e0 sp 412e4008 error 6 in =
libc-2.5.so[3a93800000+144000]
3-2.test[28612]: segfault at 4044ffe8 ip 3a938961e0 sp 40450008 error 6 in =
libc-2.5.so[3a93800000+144000]
3-2.test[28614]: segfault at 40b73fe8 ip 3a938961e0 sp 40b74008 error 6 in =
libc-2.5.so[3a93800000+144000]
3-2.test[28616]: segfault at 4053afe8 ip 3a938961e0 sp 4053b008 error 6 in =
libc-2.5.so[3a93800000+144000]
3-2.test[28618]: segfault at 40303fe8 ip 3a938961e0 sp 40304008 error 6 in =
libc-2.5.so[3a93800000+144000]
1-5.test[28729]: segfault at 40c5afe8 ip 3a938961e0 sp 40c5b008 error 6 in =
libc-2.5.so[3a93800000+144000]
1-5.test[28734]: segfault at 4146bfe8 ip 3a938961e0 sp 4146c008 error 6 in =
libc-2.5.so[3a93800000+144000]
6-1.test[20079]: segfault at 2713 ip 338ac04be6 sp 7fff1d656060 error 4 in =
librt-2.5.so[338ac00000+7000]
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
Hangcheck: hangcheck value past margin!
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
warning: process `scrashme' used the deprecated sysctl system call with=20
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
Hangcheck: hangcheck value past margin!
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
fsx-linux used greatest stack depth: 3440 bytes left
SGI XFS with security attributes, large block/inode numbers, no debug enabl=
ed
Filesystem "cciss/c0d0p4": Disabling barriers, not supported by the underly=
ing device
XFS mounting filesystem cciss/c0d0p4
Ending clean XFS mount for filesystem: cciss/c0d0p4
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
fsx-linux used greatest stack depth: 2736 bytes left
SGI XFS with security attributes, large block/inode numbers, no debug enabl=
ed
Filesystem "cciss/c0d0p4": Disabling barriers, not supported by the underly=
ing device
XFS mounting filesystem cciss/c0d0p4
Ending clean XFS mount for filesystem: cciss/c0d0p4
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
Hangcheck: hangcheck value past margin!
fsx-linux used greatest stack depth: 2704 bytes left
Hangcheck: hangcheck value past margin!
SGI XFS with security attributes, large block/inode numbers, no debug enabl=
ed
Filesystem "cciss/c0d0p4": Disabling barriers, not supported by the underly=
ing device
XFS mounting filesystem cciss/c0d0p4
Ending clean XFS mount for filesystem: cciss/c0d0p4
Hangcheck: hangcheck value past margin!
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
Hangcheck: hangcheck value past margin!
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using ordered data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8125, jou=
rnal first block 66, max trans len 256, max batch 225, max commit age 30, m=
ax trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
Hangcheck: hangcheck value past margin!
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using journaled data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8125, jou=
rnal first block 66, max trans len 256, max batch 225, max commit age 30, m=
ax trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using writeback data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8125, jou=
rnal first block 66, max trans len 256, max batch 225, max commit age 30, m=
ax trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
Hangcheck: hangcheck value past margin!
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using ordered data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8192, jou=
rnal first block 34, max trans len 512, max batch 450, max commit age 30, m=
ax trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using journaled data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8192, jou=
rnal first block 34, max trans len 512, max batch 450, max commit age 30, m=
ax trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using writeback data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8192, jou=
rnal first block 34, max trans len 512, max batch 450, max commit age 30, m=
ax trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using ordered data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8192, jou=
rnal first block 18, max trans len 1024, max batch 900, max commit age 30, =
max trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
Hangcheck: hangcheck value past margin!
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using journaled data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8192, jou=
rnal first block 18, max trans len 1024, max batch 900, max commit age 30, =
max trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using writeback data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8192, jou=
rnal first block 18, max trans len 1024, max batch 900, max commit age 30, =
max trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
Hangcheck: hangcheck value past margin!
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Hangcheck: hangcheck value past margin!
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Hangcheck: hangcheck value past margin!
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
Hangcheck: hangcheck value past margin!
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Hangcheck: hangcheck value past margin!
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Hangcheck: hangcheck value past margin!
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Hangcheck: hangcheck value past margin!
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
tg3: eth3: Link is up at 1000 Mbps, full duplex.
tg3: eth3: Flow control is off for TX and off for RX.
OCFS2 Node Manager 1.5.0
OCFS2 1.5.0
JBD: Ignoring recovery information on journal
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (104,4) on (node local, slot 0) with ordered data mo=
de.
Hangcheck: hangcheck value past margin!
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
Hangcheck: hangcheck value past margin!
ocfs2: Unmounting device (104,4) on (node local)
OCFS2 1.5.0
JBD: Ignoring recovery information on journal
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (104,4) on (node local, slot 0) with ordered data mo=
de.
Hangcheck: hangcheck value past margin!
ocfs2: Unmounting device (104,4) on (node local)
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is off for TX and off for RX.
OCFS2 1.5.0
JBD: Ignoring recovery information on journal
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (104,4) on (node local, slot 0) with ordered data mo=
de.
Hangcheck: hangcheck value past margin!
fsx-linux[22097]: segfault at 3c375a0 ip 3a93875350 sp 7fffc6270bf8 error 4=
 in libc-2.5.so[3a93800000+144000]
bnx2: eth1: using MSI
bnx2: eth1 NIC SerDes Link is Up, 1000 Mbps full duplex
ocfs2: Unmounting device (104,4) on (node local)
Hangcheck: hangcheck value past margin!
audit(1215290021.399:1411): audit_pid=3D0 old=3D3709 auid=3D4294967295 ses=
=3D4294967295 res=3D1


--Multipart=_Mon__7_Jul_2008_11_39_17_-0700_z+Wd0I1K3GhxZRN5
Content-Type: text/x-log;
 name="netcon-4557.log"
Content-Disposition: attachment;
 filename="netcon-4557.log"
Content-Transfer-Encoding: quoted-printable

Linux version 2.6.26-rc9 (root@ca-ostest293.us.oracle.com) (gcc version 4.1=
.1 20070105 (Red Hat 4.1.1-52)) #1 SMP Sun Jul 6 10:20:40 PDT 2008
Command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=3D5455=
7@139.185.50.77/eth0,54557@139.185.50.76/00:18:FE:34:1C:3D debug ignore_log=
level 3 kex initcall_debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
Entering add_active_range(0, 1, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 523856) 1 entries of 256 used
Entering add_active_range(0, 1048576, 2621439) 2 entries of 256 used
max_pfn_mapped =3D 2621439
init_memory_mapping
DMI 2.3 present.
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT 7FE50780, 005C (r1 HP     A08             2   =D2=04     162E)
ACPI: FACP 7FE50800, 00F4 (r3 HP     A08             2   =D2=04     162E)
ACPI: DSDT 7FE50900, 3F75 (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS 7FE50100, 0040
ACPI: SPCR 7FE50140, 0050 (r1 HP     SPCRRBSU        1   =D2=04     162E)
ACPI: MCFG 7FE501C0, 003C (r1 HP     ProLiant        1             0)
ACPI: HPET 7FE50200, 0038 (r1 HP     A08             2   =D2=04     162E)
ACPI: SPMI 7FE50240, 0040 (r5 HP     ProLiant        1   =D2=04     162E)
ACPI: APIC 7FE50280, 00DE (r1 HP     00000083        2             0)
ACPI: SRAT 7FE50380, 0110 (r1 AMD    HAMMER          1 AMD         1)
Entering add_active_range(0, 1, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 523856) 1 entries of 256 used
Entering add_active_range(0, 1048576, 2621439) 2 entries of 256 used
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-81a62f] TEXT DATA BSS
  early res: 3 [7fd05000-7fe4f6a6] RAMDISK
  early res: 4 [9f400-fffff] BIOS reserved
  early res: 5 [8000-11fff] PGTABLE
 [ffffe20000000000-ffffe20002dfffff] PMD -> [ffff810001200000-ffff810003fff=
fff] on node 0
 [ffffe20002e00000-ffffe20008bfffff] PMD -> [ffff81000c000000-ffff810011dff=
fff] on node 0
Zone PFN ranges:
  DMA             1 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2621439
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        1 ->      159
    0:      256 ->   523856
    0:  1048576 ->  2621439
On node 0 totalpages: 2096621
  DMA zone: 56 pages used for memmap
  DMA zone: 1673 pages reserved
  DMA zone: 2269 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 21504 pages used for memmap
  Normal zone: 1551359 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 0, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10228201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36016 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2059108
Kernel command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=
=3D54557@139.185.50.77/eth0,54557@139.185.50.76/00:18:FE:34:1C:3D debug ign=
ore_loglevel 3 kex initcall_debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1004.624 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
Node 0: aperture @ c000000 size 64 MB
Aperture pointing to e820 RAM. Ignoring.
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
PM: Registered nosave memory: 0000000004000000 - 0000000008000000
Memory: 8156604k/10485756k available (3339k kernel code, 229320k reserved, =
1654k data, 264k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
hpet clockevent registered
Calibrating delay using timer specific routine.. 2010.73 BogoMIPS (lpj=3D40=
21461)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20080321
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557812
Detected 12.557 MHz APIC timer.
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2009.34 BogoMIPS (lpj=3D40=
18691)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 2009.42 BogoMIPS (lpj=3D40=
18849)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 2009.37 BogoMIPS (lpj=3D40=
18744)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (8038.87 BogoMIPS).
khelper used greatest stack depth: 6136 bytes left
calling  init_cpufreq_transition_notifier_list+0x0/0x1b
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 =
msecs
calling  net_ns_init+0x0/0x15d
net_namespace: 368 bytes
initcall net_ns_init+0x0/0x15d returned 0 after 0 msecs
calling  cpufreq_tsc+0x0/0x16
initcall cpufreq_tsc+0x0/0x16 returned 0 after 0 msecs
calling  init_smp_flush+0x0/0x49
initcall init_smp_flush+0x0/0x49 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x32
initcall sysctl_init+0x0/0x32 returned 0 after 0 msecs
calling  ksysfs_init+0x0/0xbb
initcall ksysfs_init+0x0/0xbb returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x12
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 msecs
calling  pm_init+0x0/0x34
initcall pm_init+0x0/0x34 returned 0 after 0 msecs
calling  pm_disk_init+0x0/0x19
initcall pm_disk_init+0x0/0x19 returned 0 after 0 msecs
calling  swsusp_header_init+0x0/0x2c
initcall swsusp_header_init+0x0/0x2c returned 0 after 0 msecs
calling  filelock_init+0x0/0x2e
initcall filelock_init+0x0/0x2e returned 0 after 0 msecs
calling  init_misc_binfmt+0x0/0x3f
initcall init_misc_binfmt+0x0/0x3f returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x12
initcall init_script_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x12
initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x12
initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x51
initcall debugfs_init+0x0/0x51 returned 0 after 0 msecs
calling  random32_init+0x0/0x58
initcall random32_init+0x0/0x58 returned 0 after 0 msecs
calling  cpufreq_core_init+0x0/0x75
initcall cpufreq_core_init+0x0/0x75 returned 0 after 0 msecs
calling  cpuidle_init+0x0/0x40
initcall cpuidle_init+0x0/0x40 returned 0 after 0 msecs
calling  sock_init+0x0/0x59
initcall sock_init+0x0/0x59 returned 0 after 0 msecs
calling  netpoll_init+0x0/0x31
initcall netpoll_init+0x0/0x31 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x14d
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14d returned 0 after 0 msecs
calling  bdi_class_init+0x0/0x3d
initcall bdi_class_init+0x0/0x3d returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x45
initcall kobject_uevent_init+0x0/0x45 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x12
initcall pcibus_class_init+0x0/0x12 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x12
initcall pci_driver_init+0x0/0x12 returned 0 after 0 msecs
calling  backlight_class_init+0x0/0x49
initcall backlight_class_init+0x0/0x49 returned 0 after 0 msecs
calling  tty_class_init+0x0/0x2a
initcall tty_class_init+0x0/0x2a returned 0 after 0 msecs
calling  vtconsole_class_init+0x0/0xba
initcall vtconsole_class_init+0x0/0xba returned 0 after 0 msecs
calling  early_fill_mp_bus_info+0x0/0x7b2
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: [40,ff] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]


--Multipart=_Mon__7_Jul_2008_11_39_17_-0700_z+Wd0I1K3GhxZRN5--
