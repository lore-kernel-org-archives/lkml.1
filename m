Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYCCISN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYCCISN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYCCIR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:17:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:17602 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYCCIRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:17:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,436,1199692800"; 
   d="scan'208";a="527676885"
Subject: 2.6.25-rc regression: kernel panic on boot
From: "Zhang, Rui" <rui.zhang@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: kay.sievers@vrfy.org, gregkh@suse.de
Content-Type: multipart/mixed; boundary="=-P0Mv9x6x0Cdozjg/LfYb"
Date: Mon, 03 Mar 2008 07:25:49 +0800
Message-Id: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-P0Mv9x6x0Cdozjg/LfYb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, all,

kernel panic on boot when I try to run 2.6.25-rc1 and later, but 2.6.24-rc8 boots okay.
The result of git-bisect shows that
edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit.

The git-bisect-result and the dmesg log when the kernel panic are attached.
Any help on this please? :)

thanks,
rui



--=-P0Mv9x6x0Cdozjg/LfYb
Content-Disposition: attachment; filename=git-bisect-result
Content-Type: text/plain; name=git-bisect-result; charset=UTF-8
Content-Transfer-Encoding: 7bit

edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit
commit edfaa7c36574f1bf09c65ad602412db9da5f96bf
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Mon May 21 22:08:01 2007 +0200

    Driver core: convert block from raw kobjects to core devices
    
    This moves the block devices to /sys/class/block. It will create a
    flat list of all block devices, with the disks and partitions in one
    directory. For compatibility /sys/block is created and contains symlinks
    to the disks.
    
      /sys/class/block
      |-- sda -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda
      |-- sda1 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1
      |-- sda10 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda10
      |-- sda5 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda5
      |-- sda6 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda6
      |-- sda7 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda7
      |-- sda8 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda8
      |-- sda9 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda9
      `-- sr0 -> ../../devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0
    
      /sys/block/
      |-- sda -> ../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda
      `-- sr0 -> ../devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0
    
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 53a7ec4a5f3ee05f0135957fc7a78bdf916c4c44 f60ed2905abd5deef19294130a3b93a94bfef17e M	block
:040000 040000 cc8ec8ea50163ca4a76b91af4df5047e3747eaaa a3f18d189f18e1213ba3e44df710873c195ab47a M	drivers
:040000 040000 5695733bc4880adf7c7ded94d33ac9a32e7611ce dd53c846318820df976344e7ebaaba252fe537ed M	fs
:040000 040000 d75784c54072a715eff896b73523e66773d98d66 7055e0b911a52bd8ee4afc7f23df00a00870af68 M	include
:040000 040000 e94ba7819ccceacdda2c2f0f72017c543b4b6808 eb7d1e39d32a4ef6b48431f6a519774b9cd4bf57 M	init

--=-P0Mv9x6x0Cdozjg/LfYb
Content-Disposition: attachment; filename=dmesg
Content-Type: text/plain; name=dmesg; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.25-rc1 (root@rzhang-crestline.sh.intel.com) (gcc version 4.1.0 20060304 (Red Hat 4.1.0-3)) #197 SMP PREEMPT Fri Feb 29 16:48:53 CST 2008
Command line: ro root=/dev/VolGroup00/LogVol00 rhgb 3 ignore_loglevel initcall_debug console=ttyS0,9600n8 console=tty0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
 BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f660000 (usable)
 BIOS-e820: 000000007f660000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
debug: ignoring loglevel setting.
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 521824) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F6260, 0014 (r0 PTLTD )
ACPI: RSDT 7F66C64C, 0050 (r1 PTLTD  MATANZAS  6040000  LTP        0)
ACPI: FACP 7F676DF3, 0074 (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: DSDT 7F66DC2E, 91C5 (r1 INTEL  CRESTLNE  6040000 INTL 20061109)
ACPI: FACS 7F679FC0, 0040
ACPI: APIC 7F676E67, 0068 (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: HPET 7F676ECF, 0038 (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: MCFG 7F676F07, 003C (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: ASF! 7F676F9D, 0063 (r16   CETP     CETP  6040000 PTL         1)
ACPI: BOOT 7F676F75, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 7F66D94D, 02DD (r1 SataRe SataAhci     1000 INTL 20061109)
ACPI: SSDT 7F66D8BB, 0092 (r1 BrtRef  DD01BRT     1000 INTL 20061109)
ACPI: SSDT 7F66CC58, 025F (r1  PmRef  Cpu0Tst     3000 INTL 20061109)
ACPI: SSDT 7F66CBB2, 00A6 (r1  PmRef  Cpu1Tst     3000 INTL 20061109)
ACPI: SSDT 7F66C69C, 0516 (r1  PmRef    CpuPm     3000 INTL 20061109)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 521824) 1 entries of 256 used
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-835b7f] TEXT DATA BSS
early res: 3 [37e60000-37feff17] RAMDISK
early res: 4 [9e000-9efff] EBDA
early res: 5 [8000-bfff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      158
    0:      256 ->   521824
On node 0 totalpages: 521726
  DMA zone: 56 pages used for memmap
  DMA zone: 1599 pages reserved
  DMA zone: 2343 pages, LIFO batch:0
  DMA32 zone: 7078 pages used for memmap
  DMA32 zone: 510650 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 32584 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 512993
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb 3 ignore_loglevel initcall_debug console=ttyS0,9600n8 console=tty0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 2194.496 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
Memory: 2045968k/2087296k available (3243k kernel code, 40232k reserved, 2229k data, 252k init)
CPA: page pool initialized 32 of 32 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 4393.60 BogoMIPS (lpj=8787201)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1161 Objects with 99 Devices 299 Methods 39 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 15 Objects with 3 Devices 9 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 3 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0004) - 7 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0005) - 4 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0006) - 13 Objects with 0 Devices 4 Methods 0 Regions
 tbxface-0598 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
APIC timer calibration result 12468725
Detected 12.468 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4388.96 BogoMIPS (lpj=8777921)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring handled by SMI
Genuine Intel(R) CPU                  @ 2.20GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 03
  groups: 01 02
CPU1 attaching sched-domain:
 domain 0: span 03
  groups: 02 01
Calling initcall 0xffffffff8079ac34: init_cpufreq_transition_notifier_list+0x0/0x14()
initcall 0xffffffff8079ac34: init_cpufreq_transition_notifier_list+0x0/0x14() returned 0.
initcall 0xffffffff8079ac34 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x14()
Calling initcall 0xffffffff8079d053: net_ns_init+0x0/0x135()
net_namespace: 888 bytes
initcall 0xffffffff8079d053: net_ns_init+0x0/0x135() returned 0.
initcall 0xffffffff8079d053 ran for 26 msecs: net_ns_init+0x0/0x135()
Calling initcall 0xffffffff807842e9: cpufreq_tsc+0x0/0x16()
initcall 0xffffffff807842e9: cpufreq_tsc+0x0/0x16() returned 0.
initcall 0xffffffff807842e9 ran for 0 msecs: cpufreq_tsc+0x0/0x16()
Calling initcall 0xffffffff805236cc: init_smp_flush+0x0/0x49()
initcall 0xffffffff805236cc: init_smp_flush+0x0/0x49() returned 0.
initcall 0xffffffff805236cc ran for 0 msecs: init_smp_flush+0x0/0x49()
Calling initcall 0xffffffff8078b6ac: sysctl_init+0x0/0x32()
initcall 0xffffffff8078b6ac: sysctl_init+0x0/0x32() returned 0.
initcall 0xffffffff8078b6ac ran for 0 msecs: sysctl_init+0x0/0x32()
Calling initcall 0xffffffff8078be1e: ksysfs_init+0x0/0xb9()
initcall 0xffffffff8078be1e: ksysfs_init+0x0/0xb9() returned 0.
initcall 0xffffffff8078be1e ran for 0 msecs: ksysfs_init+0x0/0xb9()
Calling initcall 0xffffffff8078c103: init_jiffies_clocksource+0x0/0xc()
initcall 0xffffffff8078c103: init_jiffies_clocksource+0x0/0xc() returned 0.
initcall 0xffffffff8078c103 ran for 0 msecs: init_jiffies_clocksource+0x0/0xc()
Calling initcall 0xffffffff8078c25f: pm_init+0x0/0x35()
initcall 0xffffffff8078c25f: pm_init+0x0/0x35() returned 0.
initcall 0xffffffff8078c25f ran for 0 msecs: pm_init+0x0/0x35()
Calling initcall 0xffffffff8078c306: pm_disk_init+0x0/0x13()
initcall 0xffffffff8078c306: pm_disk_init+0x0/0x13() returned 0.
initcall 0xffffffff8078c306 ran for 0 msecs: pm_disk_init+0x0/0x13()
Calling initcall 0xffffffff802523c8: swsusp_header_init+0x0/0x2c()
initcall 0xffffffff802523c8: swsusp_header_init+0x0/0x2c() returned 0.
initcall 0xffffffff802523c8 ran for 0 msecs: swsusp_header_init+0x0/0x2c()
Calling initcall 0xffffffff8078e29c: filelock_init+0x0/0x2f()
initcall 0xffffffff8078e29c: filelock_init+0x0/0x2f() returned 0.
initcall 0xffffffff8078e29c ran for 0 msecs: filelock_init+0x0/0x2f()
Calling initcall 0xffffffff8078ecf3: init_script_binfmt+0x0/0xc()
initcall 0xffffffff8078ecf3: init_script_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8078ecf3 ran for 0 msecs: init_script_binfmt+0x0/0xc()
Calling initcall 0xffffffff8078ecff: init_elf_binfmt+0x0/0xc()
initcall 0xffffffff8078ecff: init_elf_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8078ecff ran for 0 msecs: init_elf_binfmt+0x0/0xc()
Calling initcall 0xffffffff8078ed0b: init_compat_elf_binfmt+0x0/0xc()
initcall 0xffffffff8078ed0b: init_compat_elf_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8078ed0b ran for 0 msecs: init_compat_elf_binfmt+0x0/0xc()
Calling initcall 0xffffffff807904bd: debugfs_init+0x0/0x47()
initcall 0xffffffff807904bd: debugfs_init+0x0/0x47() returned 0.
initcall 0xffffffff807904bd ran for 0 msecs: debugfs_init+0x0/0x47()
Calling initcall 0xffffffff8079072e: calibrate_xor_blocks+0x0/0x9d()
xor: automatically using best checksumming function: generic_sse
   generic_sse:  7691.000 MB/sec
xor: using function: generic_sse (7691.000 MB/sec)
initcall 0xffffffff8079072e: calibrate_xor_blocks+0x0/0x9d() returned 0.
initcall 0xffffffff8079072e ran for 167 msecs: calibrate_xor_blocks+0x0/0x9d()
Calling initcall 0xffffffff80790d11: random32_init+0x0/0x4e()
initcall 0xffffffff80790d11: random32_init+0x0/0x4e() returned 0.
initcall 0xffffffff80790d11 ran for 0 msecs: random32_init+0x0/0x4e()
Calling initcall 0xffffffff8079abc9: cpufreq_core_init+0x0/0x6b()
initcall 0xffffffff8079abc9: cpufreq_core_init+0x0/0x6b() returned 0.
initcall 0xffffffff8079abc9 ran for 0 msecs: cpufreq_core_init+0x0/0x6b()
Calling initcall 0xffffffff8079cf28: sock_init+0x0/0x5e()
initcall 0xffffffff8079cf28: sock_init+0x0/0x5e() returned 0.
initcall 0xffffffff8079cf28 ran for 0 msecs: sock_init+0x0/0x5e()
Calling initcall 0xffffffff8079d888: netpoll_init+0x0/0x2c()
initcall 0xffffffff8079d888: netpoll_init+0x0/0x2c() returned 0.
initcall 0xffffffff8079d888 ran for 0 msecs: netpoll_init+0x0/0x2c()
Calling initcall 0xffffffff8079d974: netlink_proto_init+0x0/0x13a()
NET: Registered protocol family 16
initcall 0xffffffff8079d974: netlink_proto_init+0x0/0x13a() returned 0.
initcall 0xffffffff8079d974 ran for 38 msecs: netlink_proto_init+0x0/0x13a()
Calling initcall 0xffffffff80790bc3: kobject_uevent_init+0x0/0x45()
initcall 0xffffffff80790bc3: kobject_uevent_init+0x0/0x45() returned 0.
initcall 0xffffffff80790bc3 ran for 0 msecs: kobject_uevent_init+0x0/0x45()
Calling initcall 0xffffffff80790f6a: pcibus_class_init+0x0/0xc()
initcall 0xffffffff80790f6a: pcibus_class_init+0x0/0xc() returned 0.
initcall 0xffffffff80790f6a ran for 0 msecs: pcibus_class_init+0x0/0xc()
Calling initcall 0xffffffff807914df: pci_driver_init+0x0/0xc()
initcall 0xffffffff807914df: pci_driver_init+0x0/0xc() returned 0.
initcall 0xffffffff807914df ran for 0 msecs: pci_driver_init+0x0/0xc()
Calling initcall 0xffffffff8079516a: tty_class_init+0x0/0x2a()
initcall 0xffffffff8079516a: tty_class_init+0x0/0x2a() returned 0.
initcall 0xffffffff8079516a ran for 0 msecs: tty_class_init+0x0/0x2a()
Calling initcall 0xffffffff80795b5a: vtconsole_class_init+0x0/0xaf()
initcall 0xffffffff80795b5a: vtconsole_class_init+0x0/0xaf() returned 0.
initcall 0xffffffff80795b5a ran for 0 msecs: vtconsole_class_init+0x0/0xaf()
Calling initcall 0xffffffff807840d6: arch_kdebugfs_init+0x0/0x3()
initcall 0xffffffff807840d6: arch_kdebugfs_init+0x0/0x3() returned 0.
initcall 0xffffffff807840d6 ran for 0 msecs: arch_kdebugfs_init+0x0/0x3()
Calling initcall 0xffffffff80784b62: mtrr_if_init+0x0/0x7a()
initcall 0xffffffff80784b62: mtrr_if_init+0x0/0x7a() returned 0.
initcall 0xffffffff80784b62 ran for 0 msecs: mtrr_if_init+0x0/0x7a()
Calling initcall 0xffffffff80785a48: ffh_cstate_init+0x0/0x31()
initcall 0xffffffff80785a48: ffh_cstate_init+0x0/0x31() returned 0.
initcall 0xffffffff80785a48 ran for 0 msecs: ffh_cstate_init+0x0/0x31()
Calling initcall 0xffffffff807927ac: acpi_pci_init+0x0/0x4a()
ACPI: bus type pci registered
initcall 0xffffffff807927ac: acpi_pci_init+0x0/0x4a() returned 0.
initcall 0xffffffff807927ac ran for 30 msecs: acpi_pci_init+0x0/0x4a()
Calling initcall 0xffffffff80793bb8: init_acpi_device_notify+0x0/0x4b()
initcall 0xffffffff80793bb8: init_acpi_device_notify+0x0/0x4b() returned 0.
initcall 0xffffffff80793bb8 ran for 0 msecs: init_acpi_device_notify+0x0/0x4b()
Calling initcall 0xffffffff8079b593: dmi_id_init+0x0/0x2df()
initcall 0xffffffff8079b593: dmi_id_init+0x0/0x2df() returned 0.
initcall 0xffffffff8079b593 ran for 0 msecs: dmi_id_init+0x0/0x2df()
Calling initcall 0xffffffff8079be5f: pci_access_init+0x0/0x3c()
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1
initcall 0xffffffff8079be5f: pci_access_init+0x0/0x3c() returned 0.
initcall 0xffffffff8079be5f ran for 83 msecs: pci_access_init+0x0/0x3c()
Calling initcall 0xffffffff807840a7: topology_init+0x0/0x2f()
initcall 0xffffffff807840a7: topology_init+0x0/0x2f() returned 0.
initcall 0xffffffff807840a7 ran for 0 msecs: topology_init+0x0/0x2f()
Calling initcall 0xffffffff80784898: mtrr_init_finialize+0x0/0x34()
initcall 0xffffffff80784898: mtrr_init_finialize+0x0/0x34() returned 0.
initcall 0xffffffff80784898 ran for 0 msecs: mtrr_init_finialize+0x0/0x34()
Calling initcall 0xffffffff8078ba99: param_sysfs_init+0x0/0x1c3()
initcall 0xffffffff8078ba99: param_sysfs_init+0x0/0x1c3() returned 0.
initcall 0xffffffff8078ba99 ran for 0 msecs: param_sysfs_init+0x0/0x1c3()
Calling initcall 0xffffffff802536c0: pm_sysrq_init+0x0/0x19()
initcall 0xffffffff802536c0: pm_sysrq_init+0x0/0x19() returned 0.
initcall 0xffffffff802536c0 ran for 0 msecs: pm_sysrq_init+0x0/0x19()
Calling initcall 0xffffffff8078d83b: readahead_init+0x0/0xc()
initcall 0xffffffff8078d83b: readahead_init+0x0/0xc() returned 0.
initcall 0xffffffff8078d83b ran for 0 msecs: readahead_init+0x0/0xc()
Calling initcall 0xffffffff8078e8e7: init_bio+0x0/0xbb()
initcall 0xffffffff8078e8e7: init_bio+0x0/0xbb() returned 0.
initcall 0xffffffff8078e8e7 ran for 0 msecs: init_bio+0x0/0xbb()
Calling initcall 0xffffffff80790903: blk_settings_init+0x0/0x25()
initcall 0xffffffff80790903: blk_settings_init+0x0/0x25() returned 0.
initcall 0xffffffff80790903 ran for 0 msecs: blk_settings_init+0x0/0x25()
Calling initcall 0xffffffff80790928: blk_ioc_init+0x0/0x2a()
initcall 0xffffffff80790928: blk_ioc_init+0x0/0x2a() returned 0.
initcall 0xffffffff80790928 ran for 0 msecs: blk_ioc_init+0x0/0x2a()
Calling initcall 0xffffffff80790952: genhd_device_init+0x0/0x49()
initcall 0xffffffff80790952: genhd_device_init+0x0/0x49() returned 0.
initcall 0xffffffff80790952 ran for 0 msecs: genhd_device_init+0x0/0x49()
Calling initcall 0xffffffff8079286f: fbmem_init+0x0/0x96()
initcall 0xffffffff8079286f: fbmem_init+0x0/0x96() returned 0.
initcall 0xffffffff8079286f ran for 0 msecs: fbmem_init+0x0/0x96()
Calling initcall 0xffffffff807939a6: acpi_init+0x0/0x212()
evgpeblk-0956 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [03] ev_initialize_gpe_bloc: Found 10 Wake, Enabled 4 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:...............................................................................
Initialized 36/39 Regions 0/0 Fields 28/28 Buffers 15/36 Packages (1212 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:<5>ACPI: BIOS _OSI(Linux) query ignored
ACPI: DMI System Vendor: Intel Corporation
ACPI: DMI Product Name: Crestline & ICH8M Chipset
ACPI: DMI Product Version: Not Applicable
ACPI: DMI Board Name: SANTA ROSA CRB
ACPI: DMI BIOS Vendor: Phoenix Technologies LTD
ACPI: DMI BIOS Date: 01/25/08
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
.
Executed 1 _INI methods requiring 0 _STA executions (examined 108 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
initcall 0xffffffff807939a6: acpi_init+0x0/0x212() returned 0.
initcall 0xffffffff807939a6 ran for 1113 msecs: acpi_init+0x0/0x212()
Calling initcall 0xffffffff80793c03: acpi_scan_init+0x0/0x12a()
initcall 0xffffffff80793c03: acpi_scan_init+0x0/0x12a() returned 0.
initcall 0xffffffff80793c03 ran for 15 msecs: acpi_scan_init+0x0/0x12a()
Calling initcall 0xffffffff80793d2d: acpi_ec_init+0x0/0x61()
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
initcall 0xffffffff80793d2d<6>ACPI: EC: non-query interrupt received, switching to interrupt mode
: acpi_ec_init+0x0/0x61() returned 0.
initcall 0xffffffff80793d2d ran for 99 msecs: acpi_ec_init+0x0/0x61()
Calling initcall 0xffffffff80793ede: acpi_pci_root_init+0x0/0x28()
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
initcall 0xffffffff80793ede: acpi_pci_root_init+0x0/0x28() returned 0.
initcall 0xffffffff80793ede ran for 343 msecs: acpi_pci_root_init+0x0/0x28()
Calling initcall 0xffffffff80793f26: acpi_pci_link_init+0x0/0x48()
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
initcall 0xffffffff80793f26: acpi_pci_link_init+0x0/0x48() returned 0.
initcall 0xffffffff80793f26 ran for 564 msecs: acpi_pci_link_init+0x0/0x48()
Calling initcall 0xffffffff807940ac: acpi_power_init+0x0/0x77()
ACPI: Power Resource [FN00] (off)
ACPI: Power Resource [FN01] (off)
initcall 0xffffffff807940ac: acpi_power_init+0x0/0x77() returned 0.
initcall 0xffffffff807940ac ran for 68 msecs: acpi_power_init+0x0/0x77()
Calling initcall 0xffffffff80794123: acpi_system_init+0x0/0x255()
initcall 0xffffffff80794123: acpi_system_init+0x0/0x255() returned 0.
initcall 0xffffffff80794123 ran for 0 msecs: acpi_system_init+0x0/0x255()
Calling initcall 0xffffffff807943f8: acpi_debug_init+0x0/0xaf()
initcall 0xffffffff807943f8: acpi_debug_init+0x0/0xaf() returned 0.
initcall 0xffffffff807943f8 ran for 0 msecs: acpi_debug_init+0x0/0xaf()
Calling initcall 0xffffffff807944a7: acpi_cm_sbs_init+0x0/0x3()
initcall 0xffffffff807944a7: acpi_cm_sbs_init+0x0/0x3() returned 0.
initcall 0xffffffff807944a7 ran for 0 msecs: acpi_cm_sbs_init+0x0/0x3()
Calling initcall 0xffffffff807944aa: pnp_init+0x0/0x1f()
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall 0xffffffff807944aa: pnp_init+0x0/0x1f() returned 0.
initcall 0xffffffff807944aa ran for 49 msecs: pnp_init+0x0/0x1f()
Calling initcall 0xffffffff807946b0: pnpacpi_init+0x0/0x8c()
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
 00:01: calling quirk 0xffffffff803b92f6: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
 00:04: calling quirk 0xffffffff803b92f6: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
 00:06: calling quirk 0xffffffff803b92f6: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:07: calling quirk 0xffffffff803b92f6: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:0b: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
initcall 0xffffffff807946b0: pnpacpi_init+0x0/0x8c() returned 0.
initcall 0xffffffff807946b0 ran for 1190 msecs: pnpacpi_init+0x0/0x8c()
Calling initcall 0xffffffff80795628: misc_init+0x0/0x86()
initcall 0xffffffff80795628: misc_init+0x0/0x86() returned 0.
initcall 0xffffffff80795628 ran for 0 msecs: misc_init+0x0/0x86()
Calling initcall 0xffffffff80796d94: init_scsi+0x0/0x77()
SCSI subsystem initialized
initcall 0xffffffff80796d94: init_scsi+0x0/0x77() returned 0.
initcall 0xffffffff80796d94 ran for 26 msecs: init_scsi+0x0/0x77()
Calling initcall 0xffffffff807972d9: ata_init+0x0/0x85()
libata version 3.00 loaded.
initcall 0xffffffff807972d9: ata_init+0x0/0x85() returned 0.
initcall 0xffffffff807972d9 ran for 30 msecs: ata_init+0x0/0x85()
Calling initcall 0xffffffff807973ad: usb_init+0x0/0x115()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xffffffff807973ad: usb_init+0x0/0x115() returned 0.
initcall 0xffffffff807973ad ran for 133 msecs: usb_init+0x0/0x115()
Calling initcall 0xffffffff80797a09: serio_init+0x0/0x84()
initcall 0xffffffff80797a09: serio_init+0x0/0x84() returned 0.
initcall 0xffffffff80797a09 ran for 0 msecs: serio_init+0x0/0x84()
Calling initcall 0xffffffff80797e2d: input_init+0x0/0x116()
initcall 0xffffffff80797e2d: input_init+0x0/0x116() returned 0.
initcall 0xffffffff80797e2d ran for 0 msecs: input_init+0x0/0x116()
Calling initcall 0xffffffff807981da: rtc_init+0x0/0x70()
initcall 0xffffffff807981da: rtc_init+0x0/0x70() returned 0.
initcall 0xffffffff807981da ran for 0 msecs: rtc_init+0x0/0x70()
Calling initcall 0xffffffff8079832d: i2c_init+0x0/0x55()
initcall 0xffffffff8079832d: i2c_init+0x0/0x55() returned 0.
initcall 0xffffffff8079832d ran for 0 msecs: i2c_init+0x0/0x55()
Calling initcall 0xffffffff8079842b: power_supply_class_init+0x0/0x34()
initcall 0xffffffff8079842b: power_supply_class_init+0x0/0x34() returned 0.
initcall 0xffffffff8079842b ran for 0 msecs: power_supply_class_init+0x0/0x34()
Calling initcall 0xffffffff8079845f: hwmon_init+0x0/0x3b()
initcall 0xffffffff8079845f: hwmon_init+0x0/0x3b() returned 0.
initcall 0xffffffff8079845f ran for 0 msecs: hwmon_init+0x0/0x3b()
Calling initcall 0xffffffff8079a683: thermal_init+0x0/0x2f()
initcall 0xffffffff8079a683: thermal_init+0x0/0x2f() returned 0.
initcall 0xffffffff8079a683 ran for 0 msecs: thermal_init+0x0/0x2f()
Calling initcall 0xffffffff8079a8f8: md_init+0x0/0xd7()
initcall 0xffffffff8079a8f8: md_init+0x0/0xd7() returned 0.
initcall 0xffffffff8079a8f8 ran for 0 msecs: md_init+0x0/0xd7()
Calling initcall 0xffffffff8079be9b: pci_acpi_init+0x0/0xa4()
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
initcall 0xffffffff8079be9b: pci_acpi_init+0x0/0xa4() returned 0.
initcall 0xffffffff8079be9b ran for 114 msecs: pci_acpi_init+0x0/0xa4()
Calling initcall 0xffffffff8079bf3f: pci_legacy_init+0x0/0xf9()
initcall 0xffffffff8079bf3f: pci_legacy_init+0x0/0xf9() returned 0.
initcall 0xffffffff8079bf3f ran for 0 msecs: pci_legacy_init+0x0/0xf9()
Calling initcall 0xffffffff8079c42d: pcibios_irq_init+0x0/0x483()
initcall 0xffffffff8079c42d: pcibios_irq_init+0x0/0x483() returned 0.
initcall 0xffffffff8079c42d ran for 0 msecs: pcibios_irq_init+0x0/0x483()
Calling initcall 0xffffffff8079c8b0: pcibios_init+0x0/0x74()
initcall 0xffffffff8079c8b0: pcibios_init+0x0/0x74() returned 0.
initcall 0xffffffff8079c8b0 ran for 0 msecs: pcibios_init+0x0/0x74()
Calling initcall 0xffffffff8079cfdb: proto_init+0x0/0x2e()
initcall 0xffffffff8079cfdb: proto_init+0x0/0x2e() returned 0.
initcall 0xffffffff8079cfdb ran for 0 msecs: proto_init+0x0/0x2e()
Calling initcall 0xffffffff8079d3e3: net_dev_init+0x0/0x153()
initcall 0xffffffff8079d3e3: net_dev_init+0x0/0x153() returned 0.
initcall 0xffffffff8079d3e3 ran for 0 msecs: net_dev_init+0x0/0x153()
Calling initcall 0xffffffff8079d572: neigh_init+0x0/0x71()
initcall 0xffffffff8079d572: neigh_init+0x0/0x71() returned 0.
initcall 0xffffffff8079d572 ran for 0 msecs: neigh_init+0x0/0x71()
Calling initcall 0xffffffff8079d8b4: fib_rules_init+0x0/0x9c()
initcall 0xffffffff8079d8b4: fib_rules_init+0x0/0x9c() returned 0.
initcall 0xffffffff8079d8b4 ran for 0 msecs: fib_rules_init+0x0/0x9c()
Calling initcall 0xffffffff8079daae: genl_init+0x0/0xca()
initcall 0xffffffff8079daae: genl_init+0x0/0xca() returned 0.
initcall 0xffffffff8079daae ran for 11 msecs: genl_init+0x0/0xca()
Calling initcall 0xffffffff807a0e66: atm_init+0x0/0xaa()
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall 0xffffffff807a0e66: atm_init+0x0/0xaa() returned 0.
initcall 0xffffffff807a0e66 ran for 72 msecs: atm_init+0x0/0xaa()
Calling initcall 0xffffffff807a0fb8: sysctl_init+0x0/0x23()
initcall 0xffffffff807a0fb8: sysctl_init+0x0/0x23() returned 0.
initcall 0xffffffff807a0fb8 ran for 0 msecs: sysctl_init+0x0/0x23()
Calling initcall 0xffffffff807830ea: pci_iommu_init+0x0/0x17()
DMAR:parse DMAR table failure.
PCI-GART: No AMD northbridge found.
initcall 0xffffffff807830ea: pci_iommu_init+0x0/0x17() returned 0.
initcall 0xffffffff807830ea ran for 68 msecs: pci_iommu_init+0x0/0x17()
Calling initcall 0xffffffff80788df3: hpet_late_init+0x0/0xf6()
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
hpet0: 3 64-bit timers, 14318180 Hz
initcall 0xffffffff80788df3: hpet_late_init+0x0/0xf6() returned 0.
initcall 0xffffffff80788df3 ran for 80 msecs: hpet_late_init+0x0/0xf6()
Calling initcall 0xffffffff8078c01b: clocksource_done_booting+0x0/0xd()
initcall 0xffffffff8078c01b<6>Time: tsc clocksource has been installed.
: clocksource_done_booting+0x0/0xd() returned 0.
initcall 0xffffffff8078c01b ran for 0 msecs: clocksource_done_booting+0x0/0xd()
Calling initcall 0xffffffff8078e230: init_pipe_fs+0x0/0x42()
initcall 0xffffffff8078e230: init_pipe_fs+0x0/0x42() returned 0.
initcall 0xffffffff8078e230 ran for 0 msecs: init_pipe_fs+0x0/0x42()
Calling initcall 0xffffffff8078eae0: eventpoll_init+0x0/0x85()
initcall 0xffffffff8078eae0: eventpoll_init+0x0/0x85() returned 0.
initcall 0xffffffff8078eae0 ran for 0 msecs: eventpoll_init+0x0/0x85()
Calling initcall 0xffffffff8078eb65: anon_inode_init+0x0/0x10b()
initcall 0xffffffff8078eb65: anon_inode_init+0x0/0x10b() returned 0.
initcall 0xffffffff8078eb65 ran for 0 msecs: anon_inode_init+0x0/0x10b()
Calling initcall 0xffffffff80794378: acpi_event_init+0x0/0x80()
initcall 0xffffffff80794378: acpi_event_init+0x0/0x80() returned 0.
initcall 0xffffffff80794378 ran for 11 msecs: acpi_event_init+0x0/0x80()
Calling initcall 0xffffffff807945b1: pnp_system_init+0x0/0xc()
pnp: the driver 'system' has been registered
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed40000-0xfed44fff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:01: driver attached
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
system 00:04: driver attached
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0x1640-0x164f has been reserved
system 00:06: ioport range 0xfe00-0xfe00 has been reserved
system 00:06: ioport range 0x8ff0-0x8ff0 has been reserved
system 00:06: driver attached
system 00:07: ioport range 0x6a0-0x6af has been reserved
system 00:07: ioport range 0x6b0-0x6ff has been reserved
system 00:07: driver attached
initcall 0xffffffff807945b1: pnp_system_init+0x0/0xc() returned 0.
initcall 0xffffffff807945b1 ran for 1330 msecs: pnp_system_init+0x0/0xc()
Calling initcall 0xffffffff80794ead: chr_dev_init+0x0/0x94()
initcall 0xffffffff80794ead: chr_dev_init+0x0/0x94() returned 0.
initcall 0xffffffff80794ead ran for 0 msecs: chr_dev_init+0x0/0x94()
Calling initcall 0xffffffff80796b61: firmware_class_init+0x0/0x68()
initcall 0xffffffff80796b61: firmware_class_init+0x0/0x68() returned 0.
initcall 0xffffffff80796b61 ran for 0 msecs: firmware_class_init+0x0/0x68()
Calling initcall 0xffffffff80796ca4: loopback_init+0x0/0xc()
initcall 0xffffffff80796ca4: loopback_init+0x0/0xc() returned 0.
initcall 0xffffffff80796ca4 ran for 0 msecs: loopback_init+0x0/0xc()
Calling initcall 0xffffffff8079acd2: cpufreq_gov_performance_init+0x0/0xc()
initcall 0xffffffff8079acd2: cpufreq_gov_performance_init+0x0/0xc() returned 0.
initcall 0xffffffff8079acd2 ran for 0 msecs: cpufreq_gov_performance_init+0x0/0xc()
Calling initcall 0xffffffff8079b882: init_acpi_pm_clocksource+0x0/0xa5()
initcall 0xffffffff8079b882: init_acpi_pm_clocksource+0x0/0xa5() returned 0.
initcall 0xffffffff8079b882 ran for 0 msecs: init_acpi_pm_clocksource+0x0/0xa5()
Calling initcall 0xffffffff8079b978: pcibios_assign_resources+0x0/0x80()
PCI: Bridge: 0000:00:1e.0
  IO window: 2000-2fff
  MEM window: 0xf0200000-0xf02fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
initcall 0xffffffff8079b978: pcibios_assign_resources+0x0/0x80() returned 0.
initcall 0xffffffff8079b978 ran for 173 msecs: pcibios_assign_resources+0x0/0x80()
Calling initcall 0xffffffff8079e8f8: inet_init+0x0/0x3e6()
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
initcall 0xffffffff8079e8f8: inet_init+0x0/0x3e6() returned 0.
initcall 0xffffffff8079e8f8 ran for 362 msecs: inet_init+0x0/0x3e6()
Calling initcall 0xffffffff80781a16: populate_rootfs+0x0/0xa6()
Unpacking initramfs... done
Freeing initrd memory: 1599k freed
initcall 0xffffffff80781a16: populate_rootfs+0x0/0xa6() returned 0.
initcall 0xffffffff80781a16 ran for 116 msecs: populate_rootfs+0x0/0xa6()
Calling initcall 0xffffffff8078282c: i8259A_init_sysfs+0x0/0x23()
initcall 0xffffffff8078282c: i8259A_init_sysfs+0x0/0x23() returned 0.
initcall 0xffffffff8078282c ran for 0 msecs: i8259A_init_sysfs+0x0/0x23()
Calling initcall 0xffffffff80782e40: vsyscall_init+0x0/0x6e()
initcall 0xffffffff80782e40: vsyscall_init+0x0/0x6e() returned 0.
initcall 0xffffffff80782e40 ran for 0 msecs: vsyscall_init+0x0/0x6e()
Calling initcall 0xffffffff8078336b: sbf_init+0x0/0xd7()
Simple Boot Flag at 0x36 set to 0x80
initcall 0xffffffff8078336b: sbf_init+0x0/0xd7() returned 0.
initcall 0xffffffff8078336b ran for 37 msecs: sbf_init+0x0/0xd7()
Calling initcall 0xffffffff80784084: i8237A_init_sysfs+0x0/0x23()
initcall 0xffffffff80784084: i8237A_init_sysfs+0x0/0x23() returned 0.
initcall 0xffffffff80784084 ran for 0 msecs: i8237A_init_sysfs+0x0/0x23()
Calling initcall 0xffffffff80522ca3: cache_sysfs_init+0x0/0x53()
initcall 0xffffffff80522ca3: cache_sysfs_init+0x0/0x53() returned 0.
initcall 0xffffffff80522ca3 ran for 0 msecs: cache_sysfs_init+0x0/0x53()
Calling initcall 0xffffffff807847d2: periodic_mcheck_init+0x0/0x40()
initcall 0xffffffff807847d2: periodic_mcheck_init+0x0/0x40() returned 0.
initcall 0xffffffff807847d2 ran for 0 msecs: periodic_mcheck_init+0x0/0x40()
Calling initcall 0xffffffff807846ba: mce_init_device+0x0/0x7f()
initcall 0xffffffff807846ba: mce_init_device+0x0/0x7f() returned 0.
initcall 0xffffffff807846ba ran for 0 msecs: mce_init_device+0x0/0x7f()
Calling initcall 0xffffffff80784812: thermal_throttle_init_device+0x0/0x79()
initcall 0xffffffff80784812: thermal_throttle_init_device+0x0/0x79() returned 0.
initcall 0xffffffff80784812 ran for 0 msecs: thermal_throttle_init_device+0x0/0x79()
Calling initcall 0xffffffff80785ae8: msr_init+0x0/0xeb()
initcall 0xffffffff80785ae8: msr_init+0x0/0xeb() returned 0.
initcall 0xffffffff80785ae8 ran for 0 msecs: msr_init+0x0/0xeb()
Calling initcall 0xffffffff807872c8: init_lapic_sysfs+0x0/0x2e()
initcall 0xffffffff807872c8: init_lapic_sysfs+0x0/0x2e() returned 0.
initcall 0xffffffff807872c8 ran for 0 msecs: init_lapic_sysfs+0x0/0x2e()
Calling initcall 0xffffffff80787cd6: ioapic_init_sysfs+0x0/0x95()
initcall 0xffffffff80787cd6: ioapic_init_sysfs+0x0/0x95() returned 0.
initcall 0xffffffff80787cd6 ran for 0 msecs: ioapic_init_sysfs+0x0/0x95()
Calling initcall 0xffffffff8078a38a: init_vdso_vars+0x0/0x1ec()
initcall 0xffffffff8078a38a: init_vdso_vars+0x0/0x1ec() returned 0.
initcall 0xffffffff8078a38a ran for 0 msecs: init_vdso_vars+0x0/0x1ec()
Calling initcall 0xffffffff8078a5a4: sysenter_setup+0x0/0x286()
initcall 0xffffffff8078a5a4: sysenter_setup+0x0/0x286() returned 0.
initcall 0xffffffff8078a5a4 ran for 0 msecs: sysenter_setup+0x0/0x286()
Calling initcall 0xffffffff8078a576: ia32_binfmt_init+0x0/0x14()
initcall 0xffffffff8078a576: ia32_binfmt_init+0x0/0x14() returned 0.
initcall 0xffffffff8078a576 ran for 0 msecs: ia32_binfmt_init+0x0/0x14()
Calling initcall 0xffffffff8078a82a: init_aout_binfmt+0x0/0xc()
initcall 0xffffffff8078a82a: init_aout_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8078a82a ran for 0 msecs: init_aout_binfmt+0x0/0xc()
Calling initcall 0xffffffff8078a836: init_sched_debug_procfs+0x0/0x2f()
initcall 0xffffffff8078a836: init_sched_debug_procfs+0x0/0x2f() returned 0.
initcall 0xffffffff8078a836 ran for 0 msecs: init_sched_debug_procfs+0x0/0x2f()
Calling initcall 0xffffffff8078b0e1: create_proc_profile+0x0/0x23e()
initcall 0xffffffff8078b0e1: create_proc_profile+0x0/0x23e() returned 0.
initcall 0xffffffff8078b0e1 ran for 0 msecs: create_proc_profile+0x0/0x23e()
Calling initcall 0xffffffff8078b596: ioresources_init+0x0/0x42()
initcall 0xffffffff8078b596: ioresources_init+0x0/0x42() returned 0.
initcall 0xffffffff8078b596 ran for 0 msecs: ioresources_init+0x0/0x42()
Calling initcall 0xffffffff8078b726: uid_cache_init+0x0/0x6e()
initcall 0xffffffff8078b726: uid_cache_init+0x0/0x6e() returned 0.
initcall 0xffffffff8078b726 ran for 0 msecs: uid_cache_init+0x0/0x6e()
Calling initcall 0xffffffff8078bc5c: init_posix_timers+0x0/0xa6()
initcall 0xffffffff8078bc5c: init_posix_timers+0x0/0xa6() returned 0.
initcall 0xffffffff8078bc5c ran for 0 msecs: init_posix_timers+0x0/0xa6()
Calling initcall 0xffffffff8078bd02: init_posix_cpu_timers+0x0/0xc6()
initcall 0xffffffff8078bd02: init_posix_cpu_timers+0x0/0xc6() returned 0.
initcall 0xffffffff8078bd02 ran for 0 msecs: init_posix_cpu_timers+0x0/0xc6()
Calling initcall 0xffffffff8078bdf1: nsproxy_cache_init+0x0/0x2d()
initcall 0xffffffff8078bdf1: nsproxy_cache_init+0x0/0x2d() returned 0.
initcall 0xffffffff8078bdf1 ran for 0 msecs: nsproxy_cache_init+0x0/0x2d()
Calling initcall 0xffffffff8078bf2e: timekeeping_init_device+0x0/0x23()
initcall 0xffffffff8078bf2e: timekeeping_init_device+0x0/0x23() returned 0.
initcall 0xffffffff8078bf2e ran for 0 msecs: timekeeping_init_device+0x0/0x23()
Calling initcall 0xffffffff8078c0b1: init_clocksource_sysfs+0x0/0x52()
initcall 0xffffffff8078c0b1: init_clocksource_sysfs+0x0/0x52() returned 0.
initcall 0xffffffff8078c0b1 ran for 0 msecs: init_clocksource_sysfs+0x0/0x52()
Calling initcall 0xffffffff8078c10f: init_timer_list_procfs+0x0/0x2f()
initcall 0xffffffff8078c10f: init_timer_list_procfs+0x0/0x2f() returned 0.
initcall 0xffffffff8078c10f ran for 0 msecs: init_timer_list_procfs+0x0/0x2f()
Calling initcall 0xffffffff8078c14a: init+0x0/0x87()
initcall 0xffffffff8078c14a: init+0x0/0x87() returned 0.
initcall 0xffffffff8078c14a ran for 0 msecs: init+0x0/0x87()
Calling initcall 0xffffffff8078c1d1: proc_dma_init+0x0/0x25()
initcall 0xffffffff8078c1d1: proc_dma_init+0x0/0x25() returned 0.
initcall 0xffffffff8078c1d1 ran for 0 msecs: proc_dma_init+0x0/0x25()
Calling initcall 0xffffffff8024babb: percpu_modinit+0x0/0x6f()
initcall 0xffffffff8024babb: percpu_modinit+0x0/0x6f() returned 0.
initcall 0xffffffff8024babb ran for 0 msecs: percpu_modinit+0x0/0x6f()
Calling initcall 0xffffffff8078c237: kallsyms_init+0x0/0x28()
initcall 0xffffffff8078c237: kallsyms_init+0x0/0x28() returned 0.
initcall 0xffffffff8078c237 ran for 0 msecs: kallsyms_init+0x0/0x28()
Calling initcall 0xffffffff8078c3ca: snapshot_device_init+0x0/0xc()
initcall 0xffffffff8078c3ca: snapshot_device_init+0x0/0xc() returned 0.
initcall 0xffffffff8078c3ca ran for 0 msecs: snapshot_device_init+0x0/0xc()
Calling initcall 0xffffffff8078c3d6: ikconfig_init+0x0/0x3c()
initcall 0xffffffff8078c3d6: ikconfig_init+0x0/0x3c() returned 0.
initcall 0xffffffff8078c3d6 ran for 0 msecs: ikconfig_init+0x0/0x3c()
Calling initcall 0xffffffff8078c59f: utsname_sysctl_init+0x0/0x14()
initcall 0xffffffff8078c59f: utsname_sysctl_init+0x0/0x14() returned 0.
initcall 0xffffffff8078c59f ran for 0 msecs: utsname_sysctl_init+0x0/0x14()
Calling initcall 0xffffffff8078d041: init_per_zone_pages_min+0x0/0x53()
initcall 0xffffffff8078d041: init_per_zone_pages_min+0x0/0x53() returned 0.
initcall 0xffffffff8078d041 ran for 0 msecs: init_per_zone_pages_min+0x0/0x53()
Calling initcall 0xffffffff8078d828: pdflush_init+0x0/0x13()
initcall 0xffffffff8078d828: pdflush_init+0x0/0x13() returned 0.
initcall 0xffffffff8078d828 ran for 0 msecs: pdflush_init+0x0/0x13()
Calling initcall 0xffffffff8078d87b: kswapd_init+0x0/0x20()
initcall 0xffffffff8078d87b: kswapd_init+0x0/0x20() returned 0.
initcall 0xffffffff8078d87b ran for 0 msecs: kswapd_init+0x0/0x20()
Calling initcall 0xffffffff8078d89b: setup_vmstat+0x0/0x40()
initcall 0xffffffff8078d89b: setup_vmstat+0x0/0x40() returned 0.
initcall 0xffffffff8078d89b ran for 0 msecs: setup_vmstat+0x0/0x40()
Calling initcall 0xffffffff8078d918: procswaps_init+0x0/0x25()
initcall 0xffffffff8078d918: procswaps_init+0x0/0x25() returned 0.
initcall 0xffffffff8078d918 ran for 0 msecs: procswaps_init+0x0/0x25()
Calling initcall 0xffffffff8078d970: hugetlb_init+0x0/0x8d()
Total HugeTLB memory allocated, 0
initcall 0xffffffff8078d970: hugetlb_init+0x0/0x8d() returned 0.
initcall 0xffffffff8078d970 ran for 34 msecs: hugetlb_init+0x0/0x8d()
Calling initcall 0xffffffff8078dc84: init_tmpfs+0x0/0xd4()
initcall 0xffffffff8078dc84: init_tmpfs+0x0/0xd4() returned 0.
initcall 0xffffffff8078dc84 ran for 0 msecs: init_tmpfs+0x0/0xd4()
Calling initcall 0xffffffff8078ddaf: cpucache_init+0x0/0x2f()
initcall 0xffffffff8078ddaf: cpucache_init+0x0/0x2f() returned 0.
initcall 0xffffffff8078ddaf ran for 0 msecs: cpucache_init+0x0/0x2f()
Calling initcall 0xffffffff8078e272: fasync_init+0x0/0x2a()
initcall 0xffffffff8078e272: fasync_init+0x0/0x2a() returned 0.
initcall 0xffffffff8078e272 ran for 0 msecs: fasync_init+0x0/0x2a()
Calling initcall 0xffffffff8078e823: aio_setup+0x0/0x6e()
initcall 0xffffffff8078e823: aio_setup+0x0/0x6e() returned 0.
initcall 0xffffffff8078e823 ran for 0 msecs: aio_setup+0x0/0x6e()
Calling initcall 0xffffffff8078ea1b: inotify_setup+0x0/0xd()
initcall 0xffffffff8078ea1b: inotify_setup+0x0/0xd() returned 0.
initcall 0xffffffff8078ea1b ran for 0 msecs: inotify_setup+0x0/0xd()
Calling initcall 0xffffffff8078ea28: inotify_user_setup+0x0/0xb8()
initcall 0xffffffff8078ea28: inotify_user_setup+0x0/0xb8() returned 0.
initcall 0xffffffff8078ea28 ran for 0 msecs: inotify_user_setup+0x0/0xb8()
Calling initcall 0xffffffff8078ec70: init_sys32_ioctl+0x0/0x83()
initcall 0xffffffff8078ec70: init_sys32_ioctl+0x0/0x83() returned 0.
initcall 0xffffffff8078ec70 ran for 0 msecs: init_sys32_ioctl+0x0/0x83()
Calling initcall 0xffffffff8078ed17: init_mbcache+0x0/0x14()
initcall 0xffffffff8078ed17: init_mbcache+0x0/0x14() returned 0.
initcall 0xffffffff8078ed17 ran for 0 msecs: init_mbcache+0x0/0x14()
Calling initcall 0xffffffff8078ed2b: dquot_init+0x0/0xe0()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall 0xffffffff8078ed2b: dquot_init+0x0/0xe0() returned 0.
initcall 0xffffffff8078ed2b ran for 88 msecs: dquot_init+0x0/0xe0()
Calling initcall 0xffffffff8078ee0b: dnotify_init+0x0/0x2a()
initcall 0xffffffff8078ee0b: dnotify_init+0x0/0x2a() returned 0.
initcall 0xffffffff8078ee0b ran for 0 msecs: dnotify_init+0x0/0x2a()
Calling initcall 0xffffffff8078f35c: init_devpts_fs+0x0/0x35()
initcall 0xffffffff8078f35c: init_devpts_fs+0x0/0x35() returned 0.
initcall 0xffffffff8078f35c ran for 0 msecs: init_devpts_fs+0x0/0x35()
Calling initcall 0xffffffff8078f391: init_reiserfs_fs+0x0/0x8b()
initcall 0xffffffff8078f391: init_reiserfs_fs+0x0/0x8b() returned 0.
initcall 0xffffffff8078f391 ran for 0 msecs: init_reiserfs_fs+0x0/0x8b()
Calling initcall 0xffffffff8078f51e: init_ext3_fs+0x0/0x60()
initcall 0xffffffff8078f51e: init_ext3_fs+0x0/0x60() returned 0.
initcall 0xffffffff8078f51e ran for 0 msecs: init_ext3_fs+0x0/0x60()
Calling initcall 0xffffffff8078f5b2: init_ext4_fs+0x0/0x70()
initcall 0xffffffff8078f5b2: init_ext4_fs+0x0/0x70() returned 0.
initcall 0xffffffff8078f5b2 ran for 0 msecs: init_ext4_fs+0x0/0x70()
Calling initcall 0xffffffff8078f774: journal_init+0x0/0x8f()
initcall 0xffffffff8078f774: journal_init+0x0/0x8f() returned 0.
initcall 0xffffffff8078f774 ran for 0 msecs: journal_init+0x0/0x8f()
Calling initcall 0xffffffff8078f87c: journal_init+0x0/0xa4()
initcall 0xffffffff8078f87c: journal_init+0x0/0xa4() returned 0.
initcall 0xffffffff8078f87c ran for 0 msecs: journal_init+0x0/0xa4()
Calling initcall 0xffffffff8078f920: init_ramfs_fs+0x0/0xc()
initcall 0xffffffff8078f920: init_ramfs_fs+0x0/0xc() returned 0.
initcall 0xffffffff8078f920 ran for 0 msecs: init_ramfs_fs+0x0/0xc()
Calling initcall 0xffffffff8078f961: init_hugetlbfs_fs+0x0/0x8e()
initcall 0xffffffff8078f961: init_hugetlbfs_fs+0x0/0x8e() returned 0.
initcall 0xffffffff8078f961 ran for 0 msecs: init_hugetlbfs_fs+0x0/0x8e()
Calling initcall 0xffffffff8078f9ef: init_iso9660_fs+0x0/0x50()
initcall 0xffffffff8078f9ef: init_iso9660_fs+0x0/0x50() returned 0.
initcall 0xffffffff8078f9ef ran for 0 msecs: init_iso9660_fs+0x0/0x50()
Calling initcall 0xffffffff8078fafc: init_nfs_fs+0x0/0xa7()
initcall 0xffffffff8078fafc: init_nfs_fs+0x0/0xa7() returned 0.
initcall 0xffffffff8078fafc ran for 0 msecs: init_nfs_fs+0x0/0xa7()
Calling initcall 0xffffffff80790376: init_nfsd+0x0/0xb2()
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall 0xffffffff80790376: init_nfsd+0x0/0xb2() returned 0.
initcall 0xffffffff80790376 ran for 57 msecs: init_nfsd+0x0/0xb2()
Calling initcall 0xffffffff80790428: init_nlm+0x0/0x22()
initcall 0xffffffff80790428: init_nlm+0x0/0x22() returned 0.
initcall 0xffffffff80790428 ran for 0 msecs: init_nlm+0x0/0x22()
Calling initcall 0xffffffff8079044a: init_nls_cp437+0x0/0xc()
initcall 0xffffffff8079044a: init_nls_cp437+0x0/0xc() returned 0.
initcall 0xffffffff8079044a ran for 0 msecs: init_nls_cp437+0x0/0xc()
Calling initcall 0xffffffff80790456: init_nls_cp936+0x0/0xc()
initcall 0xffffffff80790456: init_nls_cp936+0x0/0xc() returned 0.
initcall 0xffffffff80790456 ran for 0 msecs: init_nls_cp936+0x0/0xc()
Calling initcall 0xffffffff80790462: init_nls_cp950+0x0/0xc()
initcall 0xffffffff80790462: init_nls_cp950+0x0/0xc() returned 0.
initcall 0xffffffff80790462 ran for 0 msecs: init_nls_cp950+0x0/0xc()
Calling initcall 0xffffffff8079046e: init_nls_ascii+0x0/0xc()
initcall 0xffffffff8079046e: init_nls_ascii+0x0/0xc() returned 0.
initcall 0xffffffff8079046e ran for 0 msecs: init_nls_ascii+0x0/0xc()
Calling initcall 0xffffffff8079047a: init_nls_iso8859_1+0x0/0xc()
initcall 0xffffffff8079047a: init_nls_iso8859_1+0x0/0xc() returned 0.
initcall 0xffffffff8079047a ran for 0 msecs: init_nls_iso8859_1+0x0/0xc()
Calling initcall 0xffffffff80790486: init_nls_iso8859_15+0x0/0xc()
initcall 0xffffffff80790486: init_nls_iso8859_15+0x0/0xc() returned 0.
initcall 0xffffffff80790486 ran for 0 msecs: init_nls_iso8859_15+0x0/0xc()
Calling initcall 0xffffffff80790492: init_nls_utf8+0x0/0x1f()
initcall 0xffffffff80790492: init_nls_utf8+0x0/0x1f() returned 0.
initcall 0xffffffff80790492 ran for 0 msecs: init_nls_utf8+0x0/0x1f()
Calling initcall 0xffffffff807904b1: init_autofs4_fs+0x0/0xc()
initcall 0xffffffff807904b1: init_autofs4_fs+0x0/0xc() returned 0.
initcall 0xffffffff807904b1 ran for 0 msecs: init_autofs4_fs+0x0/0xc()
Calling initcall 0xffffffff80790504: ipc_init+0x0/0x17()
initcall 0xffffffff80790504: ipc_init+0x0/0x17() returned 0.
initcall 0xffffffff80790504 ran for 0 msecs: ipc_init+0x0/0x17()
Calling initcall 0xffffffff80790622: ipc_sysctl_init+0x0/0x14()
initcall 0xffffffff80790622: ipc_sysctl_init+0x0/0x14() returned 0.
initcall 0xffffffff80790622 ran for 0 msecs: ipc_sysctl_init+0x0/0x14()
Calling initcall 0xffffffff80790636: init_mqueue_fs+0x0/0xbc()
initcall 0xffffffff80790636: init_mqueue_fs+0x0/0xbc() returned 0.
initcall 0xffffffff80790636 ran for 0 msecs: init_mqueue_fs+0x0/0xbc()
Calling initcall 0xffffffff807906f2: crypto_algapi_init+0x0/0xd()
initcall 0xffffffff807906f2: crypto_algapi_init+0x0/0xd() returned 0.
initcall 0xffffffff807906f2 ran for 0 msecs: crypto_algapi_init+0x0/0xd()
Calling initcall 0xffffffff80790722: init+0x0/0xc()
initcall 0xffffffff80790722: init+0x0/0xc() returned 0.
initcall 0xffffffff80790722 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff807907cb: async_tx_init+0x0/0x16()
async_tx: api initialized (sync-only)
initcall 0xffffffff807907cb: async_tx_init+0x0/0x16() returned 0.
initcall 0xffffffff807907cb ran for 38 msecs: async_tx_init+0x0/0x16()
Calling initcall 0xffffffff807907e1: async_memcpy_init+0x0/0x3()
initcall 0xffffffff807907e1: async_memcpy_init+0x0/0x3() returned 0.
initcall 0xffffffff807907e1 ran for 0 msecs: async_memcpy_init+0x0/0x3()
Calling initcall 0xffffffff807907e4: async_xor_init+0x0/0x3()
initcall 0xffffffff807907e4: async_xor_init+0x0/0x3() returned 0.
initcall 0xffffffff807907e4 ran for 0 msecs: async_xor_init+0x0/0x3()
Calling initcall 0xffffffff80790afb: noop_init+0x0/0x14()
io scheduler noop registered
initcall 0xffffffff80790afb: noop_init+0x0/0x14() returned 0.
initcall 0xffffffff80790afb ran for 29 msecs: noop_init+0x0/0x14()
Calling initcall 0xffffffff80790b0f: deadline_init+0x0/0x14()
io scheduler deadline registered
initcall 0xffffffff80790b0f: deadline_init+0x0/0x14() returned 0.
initcall 0xffffffff80790b0f ran for 33 msecs: deadline_init+0x0/0x14()
Calling initcall 0xffffffff80790b23: cfq_init+0x0/0xa0()
io scheduler cfq registered (default)
initcall 0xffffffff80790b23: cfq_init+0x0/0xa0() returned 0.
initcall 0xffffffff80790b23 ran for 38 msecs: cfq_init+0x0/0xa0()
Calling initcall 0xffffffff80790d5f: percpu_counter_startup+0x0/0x14()
initcall 0xffffffff80790d5f: percpu_counter_startup+0x0/0x14() returned 0.
initcall 0xffffffff80790d5f ran for 0 msecs: percpu_counter_startup+0x0/0x14()
Calling initcall 0xffffffff805182f7: pci_init+0x0/0x2b()
pci 0000:00:02.0: Boot video device
initcall 0xffffffff805182f7: pci_init+0x0/0x2b() returned 0.
initcall 0xffffffff805182f7 ran for 36 msecs: pci_init+0x0/0x2b()
Calling initcall 0xffffffff80791534: pci_proc_init+0x0/0x68()
initcall 0xffffffff80791534: pci_proc_init+0x0/0x68() returned 0.
initcall 0xffffffff80791534 ran for 0 msecs: pci_proc_init+0x0/0x68()
Calling initcall 0xffffffff8079159c: pcie_portdrv_init+0x0/0x42()
initcall 0xffffffff8079159c: pcie_portdrv_init+0x0/0x42() returned 0.
initcall 0xffffffff8079159c ran for 0 msecs: pcie_portdrv_init+0x0/0x42()
Calling initcall 0xffffffff807915de: aer_service_init+0x0/0x1b()
initcall 0xffffffff807915de: aer_service_init+0x0/0x1b() returned 0.
initcall 0xffffffff807915de ran for 0 msecs: aer_service_init+0x0/0x1b()
Calling initcall 0xffffffff807915f9: pci_hotplug_init+0x0/0x61()
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall 0xffffffff807915f9: pci_hotplug_init+0x0/0x61() returned 0.
initcall 0xffffffff807915f9 ran for 48 msecs: pci_hotplug_init+0x0/0x61()
Calling initcall 0xffffffff80792f4d: acpi_reserve_resources+0x0/0xeb()
initcall 0xffffffff80792f4d: acpi_reserve_resources+0x0/0xeb() returned 0.
initcall 0xffffffff80792f4d ran for 0 msecs: acpi_reserve_resources+0x0/0xeb()
Calling initcall 0xffffffff80793f6e: irqrouter_init_sysfs+0x0/0x38()
initcall 0xffffffff80793f6e: irqrouter_init_sysfs+0x0/0x38() returned 0.
initcall 0xffffffff80793f6e ran for 0 msecs: irqrouter_init_sysfs+0x0/0x38()
Calling initcall 0xffffffff80794f50: rand_initialize+0x0/0x2c()
initcall 0xffffffff80794f50: rand_initialize+0x0/0x2c() returned 0.
initcall 0xffffffff80794f50 ran for 0 msecs: rand_initialize+0x0/0x2c()
Calling initcall 0xffffffff80794f7c: tty_init+0x0/0x1c5()
initcall 0xffffffff80794f7c: tty_init+0x0/0x1c5() returned 0.
initcall 0xffffffff80794f7c ran for 1 msecs: tty_init+0x0/0x1c5()
Calling initcall 0xffffffff80795194: pty_init+0x0/0x494()
initcall 0xffffffff80795194: pty_init+0x0/0x494() returned 0.
initcall 0xffffffff80795194 ran for 18 msecs: pty_init+0x0/0x494()
Calling initcall 0xffffffff80795c2c: raw_init+0x0/0xca()
initcall 0xffffffff80795c2c: raw_init+0x0/0xca() returned 0.
initcall 0xffffffff80795c2c ran for 0 msecs: raw_init+0x0/0xca()
Calling initcall 0xffffffff80795d2c: rtc_init+0x0/0x1af()
Real Time Clock Driver v1.12ac
initcall 0xffffffff80795d2c: rtc_init+0x0/0x1af() returned 0.
initcall 0xffffffff80795d2c ran for 31 msecs: rtc_init+0x0/0x1af()
Calling initcall 0xffffffff80795edb: hpet_init+0x0/0x62()
hpet_resources: 0xfed00000 is busy
initcall 0xffffffff80795edb: hpet_init+0x0/0x62() returned 0.
initcall 0xffffffff80795edb ran for 36 msecs: hpet_init+0x0/0x62()
Calling initcall 0xffffffff80795f3d: agp_init+0x0/0x26()
Linux agpgart interface v0.103
initcall 0xffffffff80795f3d: agp_init+0x0/0x26() returned 0.
initcall 0xffffffff80795f3d ran for 31 msecs: agp_init+0x0/0x26()
Calling initcall 0xffffffff80796428: serial8250_init+0x0/0x122()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall 0xffffffff80796428: serial8250_init+0x0/0x122() returned 0.
initcall 0xffffffff80796428 ran for 128 msecs: serial8250_init+0x0/0x122()
Calling initcall 0xffffffff80796564: serial8250_pnp_init+0x0/0xc()
pnp: the driver 'serial' has been registered
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:09: driver attached
initcall 0xffffffff80796564: serial8250_pnp_init+0x0/0xc() returned 0.
initcall 0xffffffff80796564 ran for 125 msecs: serial8250_pnp_init+0x0/0xc()
Calling initcall 0xffffffff80796570: serial8250_pci_init+0x0/0x15()
initcall 0xffffffff80796570: serial8250_pci_init+0x0/0x15() returned 0.
initcall 0xffffffff80796570 ran for 0 msecs: serial8250_pci_init+0x0/0x15()
Calling initcall 0xffffffff80526043: topology_sysfs_init+0x0/0x3f()
initcall 0xffffffff80526043: topology_sysfs_init+0x0/0x3f() returned 0.
initcall 0xffffffff80526043 ran for 0 msecs: topology_sysfs_init+0x0/0x3f()
Calling initcall 0xffffffff80796c0f: net_olddevs_init+0x0/0x95()
initcall 0xffffffff80796c0f: net_olddevs_init+0x0/0x95() returned 0.
initcall 0xffffffff80796c0f ran for 0 msecs: net_olddevs_init+0x0/0x95()
Calling initcall 0xffffffff80796d25: tun_init+0x0/0x5b()
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall 0xffffffff80796d25: tun_init+0x0/0x5b() returned 0.
initcall 0xffffffff80796d25 ran for 98 msecs: tun_init+0x0/0x5b()
Calling initcall 0xffffffff80796d80: atmtcp_init+0x0/0x14()
initcall 0xffffffff80796d80: atmtcp_init+0x0/0x14() returned 0.
initcall 0xffffffff80796d80 ran for 0 msecs: atmtcp_init+0x0/0x14()
Calling initcall 0xffffffff8079709a: spi_transport_init+0x0/0x2f()
initcall 0xffffffff8079709a: spi_transport_init+0x0/0x2f() returned 0.
initcall 0xffffffff8079709a ran for 0 msecs: spi_transport_init+0x0/0x2f()
Calling initcall 0xffffffff807970c9: fc_transport_init+0x0/0x4d()
initcall 0xffffffff807970c9: fc_transport_init+0x0/0x4d() returned 0.
initcall 0xffffffff807970c9 ran for 0 msecs: fc_transport_init+0x0/0x4d()
Calling initcall 0xffffffff80797116: init_sd+0x0/0xcf()
Driver 'sd' needs updating - please use bus_type methods
initcall 0xffffffff80797116: init_sd+0x0/0xcf() returned 0.
initcall 0xffffffff80797116 ran for 57 msecs: init_sd+0x0/0xcf()
Calling initcall 0xffffffff807971e5: init_sr+0x0/0x3f()
Driver 'sr' needs updating - please use bus_type methods
initcall 0xffffffff807971e5: init_sr+0x0/0x3f() returned 0.
initcall 0xffffffff807971e5 ran for 57 msecs: init_sr+0x0/0x3f()
Calling initcall 0xffffffff80797224: init_sg+0x0/0xb5()
initcall 0xffffffff80797224: init_sg+0x0/0xb5() returned 0.
initcall 0xffffffff80797224 ran for 0 msecs: init_sg+0x0/0xb5()
Calling initcall 0xffffffff8079735e: ahci_init+0x0/0x15()
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf0500000 port 0xf0500100 irq 511
ata2: SATA max UDMA/133 abar m2048@0xf0500000 port 0xf0500180 irq 511
ata3: SATA max UDMA/133 abar m2048@0xf0500000 port 0xf0500200 irq 511
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: HTS721080G9SA00, MC4OC10V, max UDMA/100
ata2.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/100
ata3: SATA link down (SStatus 0 SControl 300)
scsi 1:0:0:0: Direct-Access     ATA      HTS721080G9SA00  MC4O PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
initcall 0xffffffff8079735e: ahci_init+0x0/0x15() returned 0.
initcall 0xffffffff8079735e ran for 3825 msecs: ahci_init+0x0/0x15()
Calling initcall 0xffffffff80797373: piix_init+0x0/0x2d()
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata4.00: ATAPI: DV-W28EA, 1.0A, max UDMA/33
ata4.00: configured for UDMA/33
scsi 3:0:0:0: CD-ROM            TEAC     DV-W28EA         1.0A PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg1 type 5
initcall 0xffffffff80797373: piix_init+0x0/0x2d() returned 0.
initcall 0xffffffff80797373 ran for 1337 msecs: piix_init+0x0/0x2d()
Calling initcall 0xffffffff807973a0: cdrom_init+0x0/0xd()
initcall 0xffffffff807973a0: cdrom_init+0x0/0xd() returned 0.
initcall 0xffffffff807973a0 ran for 0 msecs: cdrom_init+0x0/0xd()
Calling initcall 0xffffffff8079758f: mon_init+0x0/0xfd()
initcall 0xffffffff8079758f: mon_init+0x0/0xfd() returned 0.
initcall 0xffffffff8079758f ran for 0 msecs: mon_init+0x0/0xfd()
Calling initcall 0xffffffff80797773: r8a66597_init+0x0/0x43()
drivers/usb/host/r8a66597-hcd.c: driver r8a66597_hcd, 29 May 2007
initcall 0xffffffff80797773: r8a66597_init+0x0/0x43() returned 0.
initcall 0xffffffff80797773 ran for 66 msecs: r8a66597_init+0x0/0x43()
Calling initcall 0xffffffff807979cd: usb_stor_init+0x0/0x3c()
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall 0xffffffff807979cd: usb_stor_init+0x0/0x3c() returned 0.
initcall 0xffffffff807979cd ran for 132 msecs: usb_stor_init+0x0/0x3c()
Calling initcall 0xffffffff80797a8d: i8042_init+0x0/0x3a0()
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:0a: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:0b: driver attached
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xffffffff80797a8d: i8042_init+0x0/0x3a0() returned 0.
initcall 0xffffffff80797a8d ran for 324 msecs: i8042_init+0x0/0x3a0()
Calling initcall 0xffffffff80797f43: mousedev_init+0x0/0x83()
mice: PS/2 mouse device common for all mice
initcall 0xffffffff80797f43: mousedev_init+0x0/0x83() returned 0.
initcall 0xffffffff80797f43 ran for 44 msecs: mousedev_init+0x0/0x83()
Calling initcall 0xffffffff80797fd4: atkbd_init+0x0/0x26()
initcall 0xffffffff80797fd4: atkbd_init+0x0/0x26()<6>input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
 returned 0.
initcall 0xffffffff80797fd4 ran for 0 msecs: atkbd_init+0x0/0x26()
Calling initcall 0xffffffff80797ffa: psmouse_init+0x0/0x63()
initcall 0xffffffff80797ffa: psmouse_init+0x0/0x63() returned 0.
initcall 0xffffffff80797ffa ran for 13 msecs: psmouse_init+0x0/0x63()
Calling initcall 0xffffffff80798382: i2c_dev_init+0x0/0x94()
i2c /dev entries driver
initcall 0xffffffff80798382: i2c_dev_init+0x0/0x94() returned 0.
initcall 0xffffffff80798382 ran for 24 msecs: i2c_dev_init+0x0/0x94()
Calling initcall 0xffffffff80798416: i2c_i801_init+0x0/0x15()
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 19 (level, low) -> IRQ 19
initcall 0xffffffff80798416: i2c_i801_init+0x0/0x15() returned 0.
initcall 0xffffffff80798416 ran for 69 msecs: i2c_i801_init+0x0/0x15()
Calling initcall 0xffffffff8079849a: asb100_init+0x0/0xe()
initcall 0xffffffff8079849a: asb100_init+0x0/0xe() returned 0.
initcall 0xffffffff8079849a ran for 8 msecs: asb100_init+0x0/0xe()
Calling initcall 0xffffffff80798645<6>input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input1
: sensors_w83627hf_init+0x0/0x166()
initcall 0xffffffff80798645: sensors_w83627hf_init+0x0/0x166() returned -19.
initcall 0xffffffff80798645 ran for 0 msecs: sensors_w83627hf_init+0x0/0x166()
Calling initcall 0xffffffff807987ab: sensors_w83792d_init+0x0/0xe()
initcall 0xffffffff807987ab: sensors_w83792d_init+0x0/0xe() returned 0.
initcall 0xffffffff807987ab ran for 29 msecs: sensors_w83792d_init+0x0/0xe()
Calling initcall 0xffffffff807987b9: sensors_w83793_init+0x0/0xe()
initcall 0xffffffff807987b9: sensors_w83793_init+0x0/0xe() returned 0.
initcall 0xffffffff807987b9 ran for 30 msecs: sensors_w83793_init+0x0/0xe()
Calling initcall 0xffffffff807987c7: sensors_w83781d_init+0x0/0x389()
initcall 0xffffffff807987c7: sensors_w83781d_init+0x0/0x389() returned 0.
initcall 0xffffffff807987c7 ran for 60 msecs: sensors_w83781d_init+0x0/0x389()
Calling initcall 0xffffffff80798b50: sensors_w83791d_init+0x0/0xe()
initcall 0xffffffff80798b50: sensors_w83791d_init+0x0/0xe() returned 0.
initcall 0xffffffff80798b50 ran for 29 msecs: sensors_w83791d_init+0x0/0xe()
Calling initcall 0xffffffff80798b5e: abituguru_init+0x0/0x180()
initcall 0xffffffff80798b5e: abituguru_init+0x0/0x180() returned -19.
initcall 0xffffffff80798b5e ran for 0 msecs: abituguru_init+0x0/0x180()
Calling initcall 0xffffffff80798cde: sensors_adm1021_init+0x0/0xe()
initcall 0xffffffff80798cde: sensors_adm1021_init+0x0/0xe() returned 0.
initcall 0xffffffff80798cde ran for 130 msecs: sensors_adm1021_init+0x0/0xe()
Calling initcall 0xffffffff80798cec: sensors_adm1025_init+0x0/0xe()
initcall 0xffffffff80798cec: sensors_adm1025_init+0x0/0xe() returned 0.
initcall 0xffffffff80798cec ran for 24 msecs: sensors_adm1025_init+0x0/0xe()
Calling initcall 0xffffffff80798cfa: sm_adm1026_init+0x0/0xe()
initcall 0xffffffff80798cfa: sm_adm1026_init+0x0/0xe() returned 0.
initcall 0xffffffff80798cfa ran for 23 msecs: sm_adm1026_init+0x0/0xe()
Calling initcall 0xffffffff80798d08: sensors_adm1029_init+0x0/0xe()
initcall 0xffffffff80798d08: sensors_adm1029_init+0x0/0xe() returned 0.
initcall 0xffffffff80798d08 ran for 62 msecs: sensors_adm1029_init+0x0/0xe()
Calling initcall 0xffffffff80798d16: sensors_adm1031_init+0x0/0xe()
initcall 0xffffffff80798d16: sensors_adm1031_init+0x0/0xe() returned 0.
initcall 0xffffffff80798d16 ran for 21 msecs: sensors_adm1031_init+0x0/0xe()
Calling initcall 0xffffffff80798d24: sensors_adm9240_init+0x0/0xe()
initcall 0xffffffff80798d24: sensors_adm9240_init+0x0/0xe() returned 0.
initcall 0xffffffff80798d24 ran for 29 msecs: sensors_adm9240_init+0x0/0xe()
Calling initcall 0xffffffff80798d32: atxp1_init+0x0/0xe()
initcall 0xffffffff80798d32: atxp1_init+0x0/0xe() returned 0.
initcall 0xffffffff80798d32 ran for 16 msecs: atxp1_init+0x0/0xe()
Calling initcall 0xffffffff80798d40: ds1621_init+0x0/0xe()
initcall 0xffffffff80798d40: ds1621_init+0x0/0xe() returned 0.
initcall 0xffffffff80798d40 ran for 54 msecs: ds1621_init+0x0/0xe()
Calling initcall 0xffffffff80798e5d: f71805f_init+0x0/0x168()
initcall 0xffffffff80798e5d: f71805f_init+0x0/0x168() returned -19.
initcall 0xffffffff80798e5d ran for 0 msecs: f71805f_init+0x0/0x168()
Calling initcall 0xffffffff80798fc5: sensors_fscher_init+0x0/0xe()
initcall 0xffffffff80798fc5: sensors_fscher_init+0x0/0xe() returned 0.
initcall 0xffffffff80798fc5 ran for 6 msecs: sensors_fscher_init+0x0/0xe()
Calling initcall 0xffffffff80798fd3: sm_fscpos_init+0x0/0xe()
initcall 0xffffffff80798fd3: sm_fscpos_init+0x0/0xe() returned 0.
initcall 0xffffffff80798fd3 ran for 7 msecs: sm_fscpos_init+0x0/0xe()
Calling initcall 0xffffffff80798fe1: sensors_gl518sm_init+0x0/0xe()
initcall 0xffffffff80798fe1: sensors_gl518sm_init+0x0/0xe() returned 0.
initcall 0xffffffff80798fe1 ran for 15 msecs: sensors_gl518sm_init+0x0/0xe()
Calling initcall 0xffffffff80798fef: sensors_gl520sm_init+0x0/0xe()
initcall 0xffffffff80798fef: sensors_gl520sm_init+0x0/0xe() returned 0.
initcall 0xffffffff80798fef ran for 14 msecs: sensors_gl520sm_init+0x0/0xe()
Calling initcall 0xffffffff8079903c: hdaps_init+0x0/0x1e5()
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
initcall 0xffffffff8079903c: hdaps_init+0x0/0x1e5() returned -19.
initcall 0xffffffff8079903c ran for 73 msecs: hdaps_init+0x0/0x1e5()
Calling initcall 0xffffffff80799221: sm_it87_init+0x0/0x275()
initcall 0xffffffff80799221: sm_it87_init+0x0/0x275() returned -19.
initcall 0xffffffff80799221 ran for 0 msecs: sm_it87_init+0x0/0x275()
Calling initcall 0xffffffff80799496: k8temp_init+0x0/0x15()
initcall 0xffffffff80799496: k8temp_init+0x0/0x15() returned 0.
initcall 0xffffffff80799496 ran for 0 msecs: k8temp_init+0x0/0x15()
Calling initcall 0xffffffff807994ab: sensors_lm63_init+0x0/0xe()
initcall 0xffffffff807994ab: sensors_lm63_init+0x0/0xe() returned 0.
initcall 0xffffffff807994ab ran for 0 msecs: sensors_lm63_init+0x0/0xe()
Calling initcall 0xffffffff807994b9: sensors_lm75_init+0x0/0xe()
initcall 0xffffffff807994b9: sensors_lm75_init+0x0/0xe() returned 0.
initcall 0xffffffff807994b9 ran for 54 msecs: sensors_lm75_init+0x0/0xe()
Calling initcall 0xffffffff807994c7: sensors_lm77_init+0x0/0xe()
initcall 0xffffffff807994c7: sensors_lm77_init+0x0/0xe() returned 0.
initcall 0xffffffff807994c7 ran for 30 msecs: sensors_lm77_init+0x0/0xe()
Calling initcall 0xffffffff807994d5: sm_lm78_init+0x0/0x36f()
initcall 0xffffffff807994d5: sm_lm78_init+0x0/0x36f() returned 0.
initcall 0xffffffff807994d5 ran for 60 msecs: sm_lm78_init+0x0/0x36f()
Calling initcall 0xffffffff80799844: sensors_lm80_init+0x0/0xe()
initcall 0xffffffff80799844: sensors_lm80_init+0x0/0xe() returned 0.
initcall 0xffffffff80799844 ran for 59 msecs: sensors_lm80_init+0x0/0xe()
Calling initcall 0xffffffff80799852: sensors_lm83_init+0x0/0xe()
initcall 0xffffffff80799852: sensors_lm83_init+0x0/0xe() returned 0.
initcall 0xffffffff80799852 ran for 61 msecs: sensors_lm83_init+0x0/0xe()
Calling initcall 0xffffffff80799860: sm_lm85_init+0x0/0xe()
initcall 0xffffffff80799860: sm_lm85_init+0x0/0xe() returned 0.
initcall 0xffffffff80799860 ran for 24 msecs: sm_lm85_init+0x0/0xe()
Calling initcall 0xffffffff8079986e: sensors_lm87_init+0x0/0xe()
initcall 0xffffffff8079986e: sensors_lm87_init+0x0/0xe() returned 0.
initcall 0xffffffff8079986e ran for 21 msecs: sensors_lm87_init+0x0/0xe()
Calling initcall 0xffffffff8079987c: sensors_lm90_init+0x0/0xe()
initcall 0xffffffff8079987c: sensors_lm90_init+0x0/0xe() returned 0.
initcall 0xffffffff8079987c ran for 61 msecs: sensors_lm90_init+0x0/0xe()
Calling initcall 0xffffffff8079988a: sensors_lm92_init+0x0/0xe()
initcall 0xffffffff8079988a: sensors_lm92_init+0x0/0xe() returned 0.
initcall 0xffffffff8079988a ran for 30 msecs: sensors_lm92_init+0x0/0xe()
Calling initcall 0xffffffff80799898: sensors_max1619_init+0x0/0xe()
initcall 0xffffffff80799898: sensors_max1619_init+0x0/0xe() returned 0.
initcall 0xffffffff80799898 ran for 62 msecs: sensors_max1619_init+0x0/0xe()
Calling initcall 0xffffffff80799a40: pc87360_init+0x0/0x180()
pc87360: PC8736x not detected, module not inserted.
initcall 0xffffffff80799a40: pc87360_init+0x0/0x180() returned -19.
initcall 0xffffffff80799a40 ran for 52 msecs: pc87360_init+0x0/0x180()
Calling initcall 0xffffffff80799ca9: pc87427_init+0x0/0x138()
initcall 0xffffffff80799ca9: pc87427_init+0x0/0x138() returned -19.
initcall 0xffffffff80799ca9 ran for 0 msecs: pc87427_init+0x0/0x138()
Calling initcall 0xffffffff80799de1: sm_sis5595_init+0x0/0x15()
initcall 0xffffffff80799de1: sm_sis5595_init+0x0/0x15() returned 0.
initcall 0xffffffff80799de1 ran for 0 msecs: sm_sis5595_init+0x0/0x15()
Calling initcall 0xffffffff80799df6: smsc47b397_init+0x0/0x190()
initcall 0xffffffff80799df6: smsc47b397_init+0x0/0x190() returned -19.
initcall 0xffffffff80799df6 ran for 0 msecs: smsc47b397_init+0x0/0x190()
Calling initcall 0xffffffff80799f86: sm_smsc47m1_init+0x0/0x1fd()
initcall 0xffffffff80799f86: sm_smsc47m1_init+0x0/0x1fd() returned -19.
initcall 0xffffffff80799f86 ran for 0 msecs: sm_smsc47m1_init+0x0/0x1fd()
Calling initcall 0xffffffff8079a183: smsc47m192_init+0x0/0xe()
initcall 0xffffffff8079a183: smsc47m192_init+0x0/0xe() returned 0.
initcall 0xffffffff8079a183 ran for 16 msecs: smsc47m192_init+0x0/0xe()
Calling initcall 0xffffffff8079a191: sm_via686a_init+0x0/0x15()
initcall 0xffffffff8079a191: sm_via686a_init+0x0/0x15() returned 0.
initcall 0xffffffff8079a191 ran for 0 msecs: sm_via686a_init+0x0/0x15()
Calling initcall 0xffffffff8079a25a: vt1211_init+0x0/0x15e()
initcall 0xffffffff8079a25a: vt1211_init+0x0/0x15e() returned -19.
initcall 0xffffffff8079a25a ran for 0 msecs: vt1211_init+0x0/0x15e()
Calling initcall 0xffffffff8079a3b8: sm_vt8231_init+0x0/0x15()
initcall 0xffffffff8079a3b8: sm_vt8231_init+0x0/0x15() returned 0.
initcall 0xffffffff8079a3b8 ran for 0 msecs: sm_vt8231_init+0x0/0x15()
Calling initcall 0xffffffff8079a52a: sensors_w83627ehf_init+0x0/0x14b()
initcall 0xffffffff8079a52a: sensors_w83627ehf_init+0x0/0x14b() returned -19.
initcall 0xffffffff8079a52a ran for 0 msecs: sensors_w83627ehf_init+0x0/0x14b()
Calling initcall 0xffffffff8079a675: sensors_w83l785ts_init+0x0/0xe()
initcall 0xffffffff8079a675: sensors_w83l785ts_init+0x0/0xe() returned 0.
initcall 0xffffffff8079a675 ran for 7 msecs: sensors_w83l785ts_init+0x0/0xe()
Calling initcall 0xffffffff8079a6b2: linear_init+0x0/0xc()
md: linear personality registered for level -1
initcall 0xffffffff8079a6b2: linear_init+0x0/0xc() returned 0.
initcall 0xffffffff8079a6b2 ran for 47 msecs: linear_init+0x0/0xc()
Calling initcall 0xffffffff8079a6be: raid0_init+0x0/0xc()
md: raid0 personality registered for level 0
initcall 0xffffffff8079a6be: raid0_init+0x0/0xc() returned 0.
initcall 0xffffffff8079a6be ran for 45 msecs: raid0_init+0x0/0xc()
Calling initcall 0xffffffff8079a6ca: raid_init+0x0/0xc()
md: raid1 personality registered for level 1
initcall 0xffffffff8079a6ca: raid_init+0x0/0xc() returned 0.
initcall 0xffffffff8079a6ca ran for 45 msecs: raid_init+0x0/0xc()
Calling initcall 0xffffffff8079a6d6: raid_init+0x0/0xc()
md: raid10 personality registered for level 10
initcall 0xffffffff8079a6d6: raid_init+0x0/0xc() returned 0.
initcall 0xffffffff8079a6d6 ran for 47 msecs: raid_init+0x0/0xc()
Calling initcall 0xffffffff8079a6e2: raid5_init+0x0/0x34()
raid6: int64x1   1983 MB/s
raid6: int64x2   2434 MB/s
raid6: int64x4   2288 MB/s
raid6: int64x8   1576 MB/s
raid6: sse2x1    3447 MB/s
raid6: sse2x2    3416 MB/s
raid6: sse2x4    6474 MB/s
raid6: using algorithm sse2x4 (6474 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
initcall 0xffffffff8079a6e2: raid5_init+0x0/0x34() returned 0.
initcall 0xffffffff8079a6e2 ran for 818 msecs: raid5_init+0x0/0x34()
Calling initcall 0xffffffff8079a9cf: dm_init+0x0/0x54()
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
initcall 0xffffffff8079a9cf: dm_init+0x0/0x54() returned 0.
initcall 0xffffffff8079a9cf ran for 81 msecs: dm_init+0x0/0x54()
Calling initcall 0xffffffff8079ac48: cpufreq_stats_init+0x0/0x8a()
initcall 0xffffffff8079ac48: cpufreq_stats_init+0x0/0x8a() returned 0.
initcall 0xffffffff8079ac48 ran for 0 msecs: cpufreq_stats_init+0x0/0x8a()
Calling initcall 0xffffffff8079acde: cpufreq_gov_powersave_init+0x0/0xc()
initcall 0xffffffff8079acde: cpufreq_gov_powersave_init+0x0/0xc() returned 0.
initcall 0xffffffff8079acde ran for 0 msecs: cpufreq_gov_powersave_init+0x0/0xc()
Calling initcall 0xffffffff8079acea: cpufreq_gov_userspace_init+0x0/0xc()
initcall 0xffffffff8079acea: cpufreq_gov_userspace_init+0x0/0xc() returned 0.
initcall 0xffffffff8079acea ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0xc()
Calling initcall 0xffffffff8079acf6: cpufreq_gov_dbs_init+0x0/0x47()
initcall 0xffffffff8079acf6: cpufreq_gov_dbs_init+0x0/0x47() returned 0.
initcall 0xffffffff8079acf6 ran for 0 msecs: cpufreq_gov_dbs_init+0x0/0x47()
Calling initcall 0xffffffff8079b927: hid_init+0x0/0x3()
initcall 0xffffffff8079b927: hid_init+0x0/0x3() returned 0.
initcall 0xffffffff8079b927 ran for 0 msecs: hid_init+0x0/0x3()
Calling initcall 0xffffffff8079b92a: hid_init+0x0/0x4e()
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
initcall 0xffffffff8079b92a: hid_init+0x0/0x4e() returned 0.
initcall 0xffffffff8079b92a ran for 105 msecs: hid_init+0x0/0x4e()
Calling initcall 0xffffffff8079d188: sysctl_core_init+0x0/0xc()
initcall 0xffffffff8079d188: sysctl_core_init+0x0/0xc() returned 0.
initcall 0xffffffff8079d188 ran for 0 msecs: sysctl_core_init+0x0/0xc()
Calling initcall 0xffffffff8079d6ef: flow_cache_init+0x0/0x199()
initcall 0xffffffff8079d6ef: flow_cache_init+0x0/0x199() returned 0.
initcall 0xffffffff8079d6ef ran for 0 msecs: flow_cache_init+0x0/0x199()
Calling initcall 0xffffffff8079dc60: nfnetlink_init+0x0/0x5d()
Netfilter messages via NETLINK v0.30.
initcall 0xffffffff8079dc60: nfnetlink_init+0x0/0x5d() returned 0.
initcall 0xffffffff8079dc60 ran for 38 msecs: nfnetlink_init+0x0/0x5d()
Calling initcall 0xffffffff8079dcbd: nfnetlink_log_init+0x0/0x9a()
initcall 0xffffffff8079dcbd: nfnetlink_log_init+0x0/0x9a() returned 0.
initcall 0xffffffff8079dcbd ran for 0 msecs: nfnetlink_log_init+0x0/0x9a()
Calling initcall 0xffffffff8079ee50: sysctl_ipv4_init+0x0/0x22()
initcall 0xffffffff8079ee50: sysctl_ipv4_init+0x0/0x22() returned 0.
initcall 0xffffffff8079ee50 ran for 0 msecs: sysctl_ipv4_init+0x0/0x22()
Calling initcall 0xffffffff8079f0d1: init_syncookies+0x0/0x19()
initcall 0xffffffff8079f0d1: init_syncookies+0x0/0x19() returned 0.
initcall 0xffffffff8079f0d1 ran for 0 msecs: init_syncookies+0x0/0x19()
Calling initcall 0xffffffff804eac2a: ipv4_netfilter_init+0x0/0xc()
initcall 0xffffffff804eac2a: ipv4_netfilter_init+0x0/0xc() returned 0.
initcall 0xffffffff804eac2a ran for 0 msecs: ipv4_netfilter_init+0x0/0xc()
Calling initcall 0xffffffff807a0ab2: cubictcp_register+0x0/0x6f()
TCP cubic registered
initcall 0xffffffff807a0ab2: cubictcp_register+0x0/0x6f() returned 0.
initcall 0xffffffff807a0ab2 ran for 21 msecs: cubictcp_register+0x0/0x6f()
Calling initcall 0xffffffff807a0cd3: af_unix_init+0x0/0x4b()
NET: Registered protocol family 1
initcall 0xffffffff807a0cd3: af_unix_init+0x0/0x4b() returned 0.
initcall 0xffffffff807a0cd3 ran for 34 msecs: af_unix_init+0x0/0x4b()
Calling initcall 0xffffffff807a0d1e: packet_init+0x0/0x3d()
NET: Registered protocol family 17
initcall 0xffffffff807a0d1e: packet_init+0x0/0x3d() returned 0.
initcall 0xffffffff807a0d1e ran for 35 msecs: packet_init+0x0/0x3d()
Calling initcall 0xffffffff807a0d5b: ipsec_pfkey_init+0x0/0x7f()
NET: Registered protocol family 15
initcall 0xffffffff807a0d5b: ipsec_pfkey_init+0x0/0x7f() returned 0.
initcall 0xffffffff807a0d5b ran for 35 msecs: ipsec_pfkey_init+0x0/0x7f()
Calling initcall 0xffffffff807a0dfb: init_sunrpc+0x0/0x53()
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
initcall 0xffffffff807a0dfb: init_sunrpc+0x0/0x53() returned 0.
initcall 0xffffffff807a0dfb ran for 77 msecs: init_sunrpc+0x0/0x53()
Calling initcall 0xffffffff80784fca: hpet_insert_resource+0x0/0x1e()
initcall 0xffffffff80784fca: hpet_insert_resource+0x0/0x1e() returned 0.
initcall 0xffffffff80784fca ran for 0 msecs: hpet_insert_resource+0x0/0x1e()
Calling initcall 0xffffffff80787587: init_lapic_nmi_sysfs+0x0/0x37()
initcall 0xffffffff80787587: init_lapic_nmi_sysfs+0x0/0x37() returned 0.
initcall 0xffffffff80787587 ran for 0 msecs: init_lapic_nmi_sysfs+0x0/0x37()
Calling initcall 0xffffffff80787827: ioapic_insert_resources+0x0/0x4a()
initcall 0xffffffff80787827: ioapic_insert_resources+0x0/0x4a() returned 0.
initcall 0xffffffff80787827 ran for 0 msecs: ioapic_insert_resources+0x0/0x4a()
Calling initcall 0xffffffff8022fd5d: init_oops_id+0x0/0x23()
initcall 0xffffffff8022fd5d: init_oops_id+0x0/0x23() returned 0.
initcall 0xffffffff8022fd5d ran for 0 msecs: init_oops_id+0x0/0x23()
Calling initcall 0xffffffff8078af63: disable_boot_consoles+0x0/0x3a()
initcall 0xffffffff8078af63: disable_boot_consoles+0x0/0x3a() returned 0.
initcall 0xffffffff8078af63 ran for 0 msecs: disable_boot_consoles+0x0/0x3a()
Calling initcall 0xffffffff8078bed7: pm_qos_power_init+0x0/0x57()
initcall 0xffffffff8078bed7: pm_qos_power_init+0x0/0x57() returned 0.
initcall 0xffffffff8078bed7 ran for 0 msecs: pm_qos_power_init+0x0/0x57()
Calling initcall 0xffffffff80250585: software_resume+0x0/0x1a6()
initcall 0xffffffff80250585: software_resume+0x0/0x1a6() returned -2.
initcall 0xffffffff80250585 ran for 0 msecs: software_resume+0x0/0x1a6()
initcall at 0xffffffff80250585: software_resume+0x0/0x1a6(): returned with error code -2
Calling initcall 0xffffffff80790cad: random32_reseed+0x0/0x64()
initcall 0xffffffff80790cad: random32_reseed+0x0/0x64() returned 0.
initcall 0xffffffff80790cad ran for 0 msecs: random32_reseed+0x0/0x64()
Calling initcall 0xffffffff807914eb: pci_sysfs_init+0x0/0x49()
initcall 0xffffffff807914eb: pci_sysfs_init+0x0/0x49() returned 0.
initcall 0xffffffff807914eb ran for 0 msecs: pci_sysfs_init+0x0/0x49()
Calling initcall 0xffffffff80793619: acpi_wakeup_device_init+0x0/0xaf()
initcall 0xffffffff80793619: acpi_wakeup_device_init+0x0/0xaf() returned 0.
initcall 0xffffffff80793619 ran for 0 msecs: acpi_wakeup_device_init+0x0/0xaf()
Calling initcall 0xffffffff8079380b: acpi_sleep_proc_init+0x0/0x97()
initcall 0xffffffff8079380b: acpi_sleep_proc_init+0x0/0x97() returned 0.
initcall 0xffffffff8079380b ran for 0 msecs: acpi_sleep_proc_init+0x0/0x97()
Calling initcall 0xffffffff80794f41: seqgen_init+0x0/0xf()
initcall 0xffffffff80794f41: seqgen_init+0x0/0xf() returned 0.
initcall 0xffffffff80794f41 ran for 0 msecs: seqgen_init+0x0/0xf()
Calling initcall 0xffffffff803e85ed: scsi_complete_async_scans+0x0/0x10a()
initcall 0xffffffff803e85ed: scsi_complete_async_scans+0x0/0x10a() returned 0.
initcall 0xffffffff803e85ed ran for 0 msecs: scsi_complete_async_scans+0x0/0x10a()
Calling initcall 0xffffffff8079805d: rtc_hctosys+0x0/0x17d()
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
initcall 0xffffffff8079805d: rtc_hctosys+0x0/0x17d() returned -19.
initcall 0xffffffff8079805d ran for 56 msecs: rtc_hctosys+0x0/0x17d()
Calling initcall 0xffffffff8079cb41: pci_mmcfg_late_insert_resources+0x0/0x43()
initcall 0xffffffff8079cb41: pci_mmcfg_late_insert_resources+0x0/0x43() returned 0.
initcall 0xffffffff8079cb41 ran for 0 msecs: pci_mmcfg_late_insert_resources+0x0/0x43()
Calling initcall 0xffffffff8079e47c: tcp_congestion_default+0x0/0xc()
initcall 0xffffffff8079e47c: tcp_congestion_default+0x0/0xc() returned 0.
initcall 0xffffffff8079e47c ran for 0 msecs: tcp_congestion_default+0x0/0xc()
Calling initcall 0xffffffff8079f542: ip_auto_config+0x0/0xe77()
initcall 0xffffffff8079f542: ip_auto_config+0x0/0xe77() returned 0.
initcall 0xffffffff8079f542 ran for 0 msecs: ip_auto_config+0x0/0xe77()
Freeing unused kernel memory: 252k freed
Kernel panic - not syncing: Attempted to kill init!

--=-P0Mv9x6x0Cdozjg/LfYb--

