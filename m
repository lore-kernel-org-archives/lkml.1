Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYF2VdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYF2VdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 17:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYF2Vcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 17:32:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:1511 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYF2Vcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 17:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=InAzKVzSVRASDMic6XkfXdBFJ3mpO6V/bBHpPkf7Wl1RHA/EonM+4q74tPwVmlOeOo
         gmekmh+eeGSehOAApsCrqtRtsEM3JfFITO+8gBhP8j65XacrlfoXk0RgNZVy1DOfPJeA
         PUxI2iXpx/S4wMEU2xLxwhQyf0lwgewz5ctXU=
Message-ID: <7618ba960806291432l20b7b6b5lea4b60bafa68c3bf@mail.gmail.com>
Date: Sun, 29 Jun 2008 16:32:45 -0500
From: "Noah Watkins" <noahwatkins@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG RT] 2.6.25.8-rt7 on 8-way
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       RT <linux-rt-users@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My kernel is very, very noisy with the following bug:

- Full dmesg below
- Please CC me

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12



Initializing cgroup subsys cpuset
Linux version 2.6.25.8-rt7 (nwatkins@kuspsmp.ittc.ku.edu) (gcc version
4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP PREEMPT RT Sun Jun 29
15:42:24 CDT 2008
Command line: ro root=LABEL=/ rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dffa0000 (usable)
 BIOS-e820: 00000000dffae000 - 00000000dffb0000 type 9
 BIOS-e820: 00000000dffb0000 - 00000000dffbe000 (ACPI data)
 BIOS-e820: 00000000dffbe000 - 00000000dfff0000 (ACPI NVS)
 BIOS-e820: 00000000dfff0000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 917408) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2228224) 2 entries of 3200 used
end_pfn_map = 2228224
DMI present.
ACPI: RSDP 000F9860, 0024 (r2 ACPIAM)
ACPI: XSDT DFFB0100, 007C (r1 042908 XSDT1053 20080429 MSFT       97)
ACPI: FACP DFFB0290, 00F4 (r3 042908 FACP1053 20080429 MSFT       97)
ACPI: DSDT DFFB04D0, 5414 (r1  CLSea CLSea007        7 INTL 20051117)
ACPI: FACS DFFBE000, 0040
ACPI: APIC DFFB0390, 00AA (r1 042908 APIC1053 20080429 MSFT       97)
ACPI: MCFG DFFB0490, 003C (r1 042908 OEMMCFG  20080429 MSFT       97)
ACPI: OEMB DFFBE040, 0071 (r1 042908 OEMB1053 20080429 MSFT       97)
ACPI: HPET DFFB58F0, 0038 (r1 042908 OEMHPET  20080429 MSFT       97)
ACPI: ASF! DFFB5928, 0083 (r32 AMIASF E7230ASF        1 INTL 20051117)
ACPI: SSDT DFFC0540, 1238 (r1 DpgPmm    CpuPm       12 INTL 20051117)
ACPI: EINJ DFFB59B0, 0130 (r1  AMIER AMI_EINJ 20080429 MSFT       97)
ACPI: BERT DFFB5B40, 0030 (r1  AMIER AMI_BERT 20080429 MSFT       97)
ACPI: ERST DFFB5B70, 01B0 (r1  AMIER AMI_ERST 20080429 MSFT       97)
ACPI: HEST DFFB5D20, 00A8 (r1  AMIER AMI_HEST 20080429 MSFT       97)
No NUMA configuration found
Faking a node at 0000000000000000-0000000220000000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 917408) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2228224) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000220000000
  NODE_DATA [0000000000012000 - 0000000000019fff]
  bootmap [000000000001a000 -  000000000005dfff] pages 44
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-7c17ff] TEXT DATA BSS
early res: 3 [37cc2000-37fef529] RAMDISK
early res: 4 [9ec00-a0bff] EBDA
early res: 5 [8000-11fff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002200000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002800000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810002c00000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003000000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810003c00000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004000000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004400000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810004600000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810004a00000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810004e00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005000000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810005400000 on node 0
 [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810005800000 on node 0
 [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810005a00000 on node 0
 [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810005e00000 on node 0
 [ffffe20003000000-ffffe200031fffff] PMD ->ffff810006200000 on node 0
 [ffffe20003200000-ffffe200033fffff] PMD ->ffff810006400000 on node 0
 [ffffe20003400000-ffffe200035fffff] PMD ->ffff810006800000 on node 0
 [ffffe20003600000-ffffe200037fffff] PMD ->ffff810006c00000 on node 0
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810006e00000 on node 0
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810007200000 on node 0
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810007600000 on node 0
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810007800000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810007c00000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810008000000 on node 0
 [ffffe20004400000-ffffe200045fffff] PMD ->ffff810008200000 on node 0
 [ffffe20004600000-ffffe200047fffff] PMD ->ffff810008600000 on node 0
 [ffffe20004800000-ffffe200049fffff] PMD ->ffff810008a00000 on node 0
 [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff810008c00000 on node 0
 [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff810009000000 on node 0
 [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff810009400000 on node 0
 [ffffe20005000000-ffffe200051fffff] PMD ->ffff810009600000 on node 0
 [ffffe20005200000-ffffe200053fffff] PMD ->ffff810009a00000 on node 0
 [ffffe20006000000-ffffe200061fffff] PMD ->ffff810009e00000 on node 0
 [ffffe20006200000-ffffe200063fffff] PMD ->ffff81000a000000 on node 0
 [ffffe20006400000-ffffe200065fffff] PMD ->ffff81000a400000 on node 0
 [ffffe20006600000-ffffe200067fffff] PMD ->ffff81000a800000 on node 0
 [ffffe20006800000-ffffe200069fffff] PMD ->ffff81000aa00000 on node 0
 [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff81000ae00000 on node 0
 [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff81000b200000 on node 0
 [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff81000b400000 on node 0
 [ffffe20007000000-ffffe200071fffff] PMD ->ffff81000b800000 on node 0
 [ffffe20007200000-ffffe200073fffff] PMD ->ffff81000bc00000 on node 0
 [ffffe20007400000-ffffe200075fffff] PMD ->ffff81000be00000 on node 0
 [ffffe20007600000-ffffe200077fffff] PMD ->ffff81000c200000 on node 0
 [ffffe20007800000-ffffe200079fffff] PMD ->ffff81000c600000 on node 0
 [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff81000c800000 on node 0
 [ffffe20007c00000-ffffe20007dfffff] PMD ->ffff81000cc00000 on node 0
 [ffffe20007e00000-ffffe20007ffffff] PMD ->ffff81000d000000 on node 0
 [ffffe20008000000-ffffe200081fffff] PMD ->ffff81000d200000 on node 0
 [ffffe20008200000-ffffe200083fffff] PMD ->ffff81000d600000 on node 0
 [ffffe20008400000-ffffe200085fffff] PMD ->ffff81000da00000 on node 0
 [ffffe20008600000-ffffe200087fffff] PMD ->ffff81000dc00000 on node 0
 [ffffe20008800000-ffffe200089fffff] PMD ->ffff81000e000000 on node 0
 [ffffe20008a00000-ffffe20008bfffff] PMD ->ffff81000e400000 on node 0
 [ffffe20008c00000-ffffe20008dfffff] PMD ->ffff81000e600000 on node 0
 [ffffe20008e00000-ffffe20008ffffff] PMD ->ffff81000ea00000 on node 0
 [ffffe20009000000-ffffe200091fffff] PMD ->ffff81000ee00000 on node 0
 [ffffe20009200000-ffffe200093fffff] PMD ->ffff81000f000000 on node 0
 [ffffe20009400000-ffffe200095fffff] PMD ->ffff81000f400000 on node 0
 [ffffe20009600000-ffffe200097fffff] PMD ->ffff81000f800000 on node 0
 [ffffe20009800000-ffffe200099fffff] PMD ->ffff81000fa00000 on node 0
 [ffffe20009a00000-ffffe20009bfffff] PMD ->ffff81000fe00000 on node 0
 [ffffe20009c00000-ffffe20009dfffff] PMD ->ffff810010200000 on node 0
 [ffffe20009e00000-ffffe20009ffffff] PMD ->ffff810010400000 on node 0
 [ffffe2000a000000-ffffe2000a1fffff] PMD ->ffff810010800000 on node 0
 [ffffe2000a200000-ffffe2000a3fffff] PMD ->ffff810010c00000 on node 0
 [ffffe2000a400000-ffffe2000a5fffff] PMD ->ffff810010e00000 on node 0
 [ffffe2000a600000-ffffe2000a7fffff] PMD ->ffff810011200000 on node 0
 [ffffe2000a800000-ffffe2000a9fffff] PMD ->ffff810011600000 on node 0
 [ffffe2000aa00000-ffffe2000abfffff] PMD ->ffff810011800000 on node 0
 [ffffe2000ac00000-ffffe2000adfffff] PMD ->ffff810011c00000 on node 0
 [ffffe2000ae00000-ffffe2000affffff] PMD ->ffff810012000000 on node 0
 [ffffe2000b000000-ffffe2000b1fffff] PMD ->ffff810012200000 on node 0
 [ffffe2000b200000-ffffe2000b3fffff] PMD ->ffff810012600000 on node 0
 [ffffe2000b400000-ffffe2000b5fffff] PMD ->ffff810012a00000 on node 0
 [ffffe2000b600000-ffffe2000b7fffff] PMD ->ffff810012c00000 on node 0
 [ffffe2000b800000-ffffe2000b9fffff] PMD ->ffff810013000000 on node 0
 [ffffe2000ba00000-ffffe2000bbfffff] PMD ->ffff810013400000 on node 0
 [ffffe2000bc00000-ffffe2000bdfffff] PMD ->ffff810013600000 on node 0
 [ffffe2000be00000-ffffe2000bffffff] PMD ->ffff810013a00000 on node 0
 [ffffe2000c000000-ffffe2000c1fffff] PMD ->ffff810013e00000 on node 0
 [ffffe2000c200000-ffffe2000c3fffff] PMD ->ffff810014000000 on node 0
 [ffffe2000c400000-ffffe2000c5fffff] PMD ->ffff810014400000 on node 0
 [ffffe2000c600000-ffffe2000c7fffff] PMD ->ffff810014800000 on node 0
 [ffffe2000c800000-ffffe2000c9fffff] PMD ->ffff810014a00000 on node 0
 [ffffe2000ca00000-ffffe2000cbfffff] PMD ->ffff810014e00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2228224
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   917408
    0:  1048576 ->  2228224
On node 0 totalpages: 2096959
  DMA zone: 96 pages used for memmap
  DMA zone: 1490 pages reserved
  DMA zone: 2413 pages, LIFO batch:0
  DMA32 zone: 24480 pages used for memmap
  DMA32 zone: 888832 pages, LIFO batch:31
  Normal zone: 27648 pages used for memmap
  Normal zone: 1152000 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
Processor #4
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
Processor #5
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
IOAPIC[1]: apic_id 9, address 0xfec88000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
IOAPIC[2]: apic_id 10, address 0xfec89000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
PM: Registered nosave memory: 00000000dffa0000 - 00000000dffae000
PM: Registered nosave memory: 00000000dffae000 - 00000000dffb0000
PM: Registered nosave memory: 00000000dffb0000 - 00000000dffbe000
PM: Registered nosave memory: 00000000dffbe000 - 00000000dfff0000
PM: Registered nosave memory: 00000000dfff0000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at f1000000 (gap: f0000000:ee00000)
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PERCPU: Allocating 44292 bytes of per cpu data
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2043245
Policy zone: Normal
Kernel command line: ro root=LABEL=/ rhgb quiet
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 2327.489 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x15093000 - 0x19093000
Memory: 8114712k/8912896k available (2575k kernel code, 273124k
reserved, 1438k data, 376k init)
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 4724.40 BogoMIPS (lpj=2362200)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 20781154
Detected 20.781 MHz APIC timer.
Booting processor 1/8 APIC 0x4
Initializing CPU#1
Calibrating delay using timer specific routine.. 4655.03 BogoMIPS (lpj=2327519)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/8 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 4655.02 BogoMIPS (lpj=2327514)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/8 APIC 0x2
Initializing CPU#3
Calibrating delay using timer specific routine.. 4655.01 BogoMIPS (lpj=2327507)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 3/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Booting processor 4/8 APIC 0x3
Initializing CPU#4
Calibrating delay using timer specific routine.. 4655.01 BogoMIPS (lpj=2327505)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 4/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU4: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
Booting processor 5/8 APIC 0x5
Initializing CPU#5
Calibrating delay using timer specific routine.. 4578.90 BogoMIPS (lpj=2289453)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 5/5 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU5: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
Booting processor 6/8 APIC 0x6
Initializing CPU#6
Calibrating delay using timer specific routine.. 4654.59 BogoMIPS (lpj=2327298)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 6/6 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU6: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
Booting processor 7/8 APIC 0x7
Initializing CPU#7
Calibrating delay using timer specific routine.. 4655.03 BogoMIPS (lpj=2327515)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 7/7 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU7: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000005
  groups: 00000000,00000001 00000000,00000004
  domain 1: span 00000000,000000ff
   groups: 00000000,00000005 00000000,00000022 00000000,00000018
00000000,000000c0
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000022
  groups: 00000000,00000002 00000000,00000020
  domain 1: span 00000000,000000ff
   groups: 00000000,00000022 00000000,00000018 00000000,000000c0
00000000,00000005
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU2 attaching sched-domain:
 domain 0: span 00000000,00000005
  groups: 00000000,00000004 00000000,00000001
  domain 1: span 00000000,000000ff
   groups: 00000000,00000005 00000000,00000022 00000000,00000018
00000000,000000c0
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU3 attaching sched-domain:
 domain 0: span 00000000,00000018
  groups: 00000000,00000008 00000000,00000010
  domain 1: span 00000000,000000ff
   groups: 00000000,00000018 00000000,000000c0 00000000,00000005
00000000,00000022
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU4 attaching sched-domain:
 domain 0: span 00000000,00000018
  groups: 00000000,00000010 00000000,00000008
  domain 1: span 00000000,000000ff
   groups: 00000000,00000018 00000000,000000c0 00000000,00000005
00000000,00000022
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU5 attaching sched-domain:
 domain 0: span 00000000,00000022
  groups: 00000000,00000020 00000000,00000002
  domain 1: span 00000000,000000ff
   groups: 00000000,00000022 00000000,00000018 00000000,000000c0
00000000,00000005
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU6 attaching sched-domain:
 domain 0: span 00000000,000000c0
  groups: 00000000,00000040 00000000,00000080
  domain 1: span 00000000,000000ff
   groups: 00000000,000000c0 00000000,00000005 00000000,00000022
00000000,00000018
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU7 attaching sched-domain:
 domain 0: span 00000000,000000c0
  groups: 00000000,00000080 00000000,00000040
  domain 1: span 00000000,000000ff
   groups: 00000000,000000c0 00000000,00000005 00000000,00000022
00000000,00000018
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
net_namespace: 1176 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPES._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPES.SPE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPES.SPE4.SPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPES.SPE4.P8PC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPES.BMPX._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 *6 7 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  39,
should be 36 [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
 00:01: mem resource (0xfe000000-0xfebfffff) overlaps 0000:00:09.0 BAR
8 (0xfde00000-0xfebfffff), disabling
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
system 00:08: ioport range 0xa00-0xa0f has been reserved
system 00:08: ioport range 0xa10-0xa1f has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x800-0x87f has been reserved
system 00:09: ioport range 0x480-0x4bf has been reserved
system 00:09: iomem range 0xfed04000-0xfed1bfff has been reserved
system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:09: iomem range 0xfed20000-0xfed44fff has been reserved
system 00:09: iomem range 0xfed45000-0xfed9ffff has been reserved
system 00:09: iomem range 0xfeda0000-0xfedbffff has been reserved
system 00:09: iomem range 0xfec01000-0xfec7ffff has been reserved
system 00:09: iomem range 0xfec80000-0xfec85fff has been reserved
system 00:09: iomem range 0xfec86000-0xfec8ffff has been reserved
system 00:09: iomem range 0xff000000-0xff3fffff has been reserved
system 00:09: iomem range 0xff400000-0xff7fffff has been reserved
system 00:09: iomem range 0xff800000-0xffbfffff could not be reserved
system 00:09: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0xc0000-0xcffff has been reserved
system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
system 00:0f: iomem range 0x100000-0xdfffffff could not be reserved
system 00:0f: iomem range 0xfec00000-0xffffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:07:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:07:02.0
  IO window: e000-efff
  MEM window: 0xfdf00000-0xfdffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.0
  IO window: e000-efff
  MEM window: 0xfdf00000-0xfebfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:09.0
  IO window: e000-efff
  MEM window: 0xfde00000-0xfebfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: d000-dfff
  MEM window: 0xfdd00000-0xfddfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: c000-cfff
  MEM window: 0xfdc00000-0xfdcfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: 0xfdb00000-0xfdbfffff
  PREFETCH window: 0x00000000f8000000-0x00000000fbffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 48 (level, low) -> IRQ 48
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 52 (level, low) -> IRQ 52
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 56 (level, low) -> IRQ 56
PCI: Setting latency timer of device 0000:00:09.0 to 64
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:05:00.0 to 64
PCI: Setting latency timer of device 0000:07:00.0 to 64
PCI: Setting latency timer of device 0000:07:02.0 to 64
PCI: Setting latency timer of device 0000:05:00.3 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3253k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1214756782.001:1): initialized
krcupreemptd setsched 0
  prio = 98
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:02.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie01]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
PCI: Setting latency timer of device 0000:00:09.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:09.0:pcie00]
Allocate Port Service[0000:00:09.0:pcie01]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
PCI: Setting latency timer of device 0000:05:00.0 to 64
Allocate Port Service[0000:05:00.0:pcie11]
PCI: Setting latency timer of device 0000:07:00.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:07:00.0:pcie21]
PCI: Setting latency timer of device 0000:07:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:07:02.0:pcie21]
AER service couldn't init device 0000:00:01.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:09.0:pcie01 - no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: SSDT DFFBE0C0, 01F3 (r1 DpgPmm  P001Ist       11 INTL 20051117)
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [P001] (supports 8 throttling states)
ACPI: SSDT DFFBE550, 01F3 (r1 DpgPmm  P002Ist       12 INTL 20051117)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: SSDT DFFBE9E0, 01F3 (r1 DpgPmm  P003Ist       12 INTL 20051117)
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: SSDT DFFBEE70, 01F3 (r1 DpgPmm  P004Ist       12 INTL 20051117)
ACPI: ACPI0007:03 is registered as cooling_device3
ACPI: SSDT DFFBF300, 01F3 (r1 DpgPmm  P005Ist       12 INTL 20051117)
ACPI: ACPI0007:04 is registered as cooling_device4
ACPI: SSDT DFFBF790, 01F3 (r1 DpgPmm  P006Ist       12 INTL 20051117)
ACPI: ACPI0007:05 is registered as cooling_device5
ACPI: SSDT DFFBFC20, 01F3 (r1 DpgPmm  P007Ist       12 INTL 20051117)
ACPI: ACPI0007:06 is registered as cooling_device6
ACPI: SSDT DFFC00B0, 01F3 (r1 DpgPmm  P008Ist       12 INTL 20051117)
ACPI: ACPI0007:07 is registered as cooling_device7
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
/home/nwatkins/linux-2.6.25.8/drivers/hid/usbhid/hid-core.c: v2.6:USB
HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 376k freed
Write protecting the kernel read-only data: 1152k
BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: swapper:1 task might have lost a preemption check!
BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff812803c0>] __atomic_notifier_call_chain+0x3c/0x48
 [<ffffffff811891c0>] notify_write+0x20/0x25
 [<ffffffff8118d684>] vt_console_print+0x1e3/0x293
 [<ffffffff8103423c>] __call_console_drivers+0xa8/0xcd
 [<ffffffff81034512>] release_console_sem+0x11f/0x1b6
 [<ffffffff81034bc5>] vprintk+0x327/0x364
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff81034c50>] printk+0x4e/0x56
 [<ffffffff8100d293>] dump_trace+0x25f/0x2ae
 [<ffffffff8100d335>] show_trace+0x53/0x61
 [<ffffffff8100da29>] dump_stack+0x69/0x6f
 [<ffffffff81034cc5>] __printk_ratelimit+0x6d/0xa6
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

Pid: 1, comm: swapper Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8102ec89>] preempt_enable_no_resched+0x57/0x5f
 [<ffffffff8112e45e>] debug_smp_processor_id+0xb2/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810fe778>] avc_has_perm_noaudit+0x39d/0x455
 [<ffffffff81052ee9>] do_try_to_take_rt_mutex+0x165/0x193
 [<ffffffff810ff3c4>] avc_has_perm+0x2b/0x5b
 [<ffffffff811000c5>] inode_has_perm+0x65/0x72
 [<ffffffff810a9940>] __link_path_walk+0x146/0xdb8
 [<ffffffff81083066>] __inc_zone_state+0x6a/0x88
 [<ffffffff8127d62a>] __rt_spin_lock+0x27/0x66
 [<ffffffff810aa60f>] path_walk+0x5d/0xb8
 [<ffffffff810aa90d>] do_path_lookup+0x17e/0x1f5
 [<ffffffff810ab317>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8101bab0>] __smp_call_function_mask+0x86/0xbb
 [<ffffffff810227a1>] __cpa_flush_range+0x0/0x14
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100904f>] init_post+0x35/0xfa
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8102e86b>] finish_task_switch+0x32/0xe4
 [<ffffffff8100cc48>] child_rip+0xa/0x12
 [<ffffffff8100cc3e>] child_rip+0x0/0x12

ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdaff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a080
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfdaffc00 port 0xfdaffd00 irq 19
ata2: SATA max UDMA/133 abar m1024@0xfdaffc00 port 0xfdaffd80 irq 19
ata3: SATA max UDMA/133 abar m1024@0xfdaffc00 port 0xfdaffe00 irq 19
ata4: SATA max UDMA/133 abar m1024@0xfdaffc00 port 0xfdaffe80 irq 19
ata5: SATA max UDMA/133 abar m1024@0xfdaffc00 port 0xfdafff00 irq 19
ata6: SATA max UDMA/133 abar m1024@0xfdaffc00 port 0xfdafff80 irq 19
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD800JD-00MSA1, 10.01E01, max UDMA/133
ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: Optiarc DVD RW AD-7190S, 1.01, max UDMA/100
ata2.00: configured for UDMA/100
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
ata4.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
printk: 6969 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: insmod/676
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 676, comm: insmod Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff811216bb>] cfq_cic_lookup+0x4d/0xe3
 [<ffffffff81122817>] cfq_set_request+0x7b/0x31c
 [<ffffffff811181d6>] get_request+0x1a3/0x2d0
 [<ffffffff8111832b>] get_request_wait+0x28/0x16e
 [<ffffffff8109b488>] kmem_cache_alloc_node+0x129/0x152
 [<ffffffff8805736c>] :scsi_mod:scsi_execute+0x34/0xe6
 [<ffffffff880574d7>] :scsi_mod:scsi_execute_req+0xb9/0xde
 [<ffffffff88058541>] :scsi_mod:scsi_probe_and_add_lun+0x241/0xa9d
 [<ffffffff8126c3e9>] klist_add_tail+0x35/0x41
 [<ffffffff8112595b>] kobject_get+0x12/0x17
 [<ffffffff88059132>] :scsi_mod:scsi_alloc_target+0x255/0x335
 [<ffffffff88059c58>] :scsi_mod:__scsi_add_device+0xab/0xe3
 [<ffffffff8808a103>] :libata:ata_scsi_scan_host+0xa8/0x272
 [<ffffffff880870eb>] :libata:ata_host_register+0x23f/0x265
 [<ffffffff880871c6>] :libata:ata_host_activate+0xb5/0xd8
 [<ffffffff880a792e>] :ahci:ahci_init_one+0x989/0x9c0
 [<ffffffff81135f4b>] pci_device_probe+0xb3/0xfd
 [<ffffffff811a1683>] driver_probe_device+0xd9/0x156
 [<ffffffff811a1746>] __driver_attach+0x46/0x6d
 [<ffffffff811a1700>] __driver_attach+0x0/0x6d
 [<ffffffff811a0aa9>] bus_for_each_dev+0x47/0x72
 [<ffffffff8109bf57>] kmem_cache_alloc+0x100/0x127
 [<ffffffff811a1187>] bus_add_driver+0xb7/0x208
 [<ffffffff811a18bd>] driver_register+0x59/0xcd
 [<ffffffff811361c0>] __pci_register_driver+0x57/0x8b
 [<ffffffff81057ea6>] sys_init_module+0x9b/0x196
 [<ffffffff8100bdeb>] system_call_after_swapgs+0x7b/0x80

scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JD-00MS 10.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7190S  1.01 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 3:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 3:0:0:0: [sdb] Attached SCSI disk
printk: 465 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: init/1
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1, comm: init Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810a1ac5>] __fput+0x122/0x18e
 [<ffffffff8109f169>] filp_close+0x5d/0x65
 [<ffffffff810a033f>] sys_close+0x89/0xcb
 [<ffffffff8100bdeb>] system_call_after_swapgs+0x7b/0x80

ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi6 : ata_piix
scsi7 : ata_piix
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
printk: 22393 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: rhgb-client/765
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 765, comm: rhgb-client Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff81076242>] find_get_page+0x172/0x182
 [<ffffffff8107649f>] __lock_page+0xc1/0xc6
 [<ffffffff81076688>] find_lock_page+0x15/0x61
 [<ffffffff810786dc>] filemap_fault+0x75/0x3a2
 [<ffffffff810843c2>] __do_fault+0x63/0x3f6
 [<ffffffff81087172>] handle_mm_fault+0x37c/0x797
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8127fe75>] do_page_fault+0x3f7/0x7b2
 [<ffffffff8127dd99>] error_exit+0x0/0x51

sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
sd 3:0:0:0: Attached scsi generic sg2 type 0
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
input: PC Speaker as /class/input/input3
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
intel_rng: FWH not detected
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:08:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:08:00.0 to 64
eth0: (PCI Express:2.5GB/s:Width x4) 00:1f:c6:e3:40:52
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 3, PHY: 5, PBA No: ffffff-0ff
ACPI: PCI Interrupt 0000:08:00.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:08:00.1 to 64
eth1: (PCI Express:2.5GB/s:Width x4) 00:1f:c6:e3:40:53
eth1: Intel(R) PRO/1000 Network Connection
eth1: MAC: 3, PHY: 5, PBA No: ffffff-0ff
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:03:00.0 to 64
eth2: (PCI Express:2.5GB/s:Width x1) 00:1f:c6:e3:41:4c
eth2: Intel(R) PRO/1000 Network Connection
eth2: MAC: 2, PHY: 2, PBA No: ffffff-0ff
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth3: (PCI Express:2.5GB/s:Width x1) 00:1f:c6:e3:40:f5
eth3: Intel(R) PRO/1000 Network Connection
eth3: MAC: 2, PHY: 2, PBA No: ffffff-0ff
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
printk: 258804 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: fsck/1699
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 1699, comm: fsck Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff81076242>] find_get_page+0x172/0x182
 [<ffffffff81075d3b>] file_read_actor+0x56/0x12e
 [<ffffffff81075d90>] file_read_actor+0xab/0x12e
 [<ffffffff8107830d>] generic_file_aio_read+0x1b0/0x4cf
 [<ffffffff810a0a1f>] do_sync_read+0xc9/0x10c
 [<ffffffff8107c27d>] __alloc_pages+0x84/0x31a
 [<ffffffff81046dfe>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff810a1216>] vfs_read+0xaa/0x152
 [<ffffffff810a161b>] sys_read+0x48/0x74
 [<ffffffff8100bdeb>] system_call_after_swapgs+0x7b/0x80

EXT3 FS on sdb2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 522104k swap on /dev/sdb3.  Priority:-1 extents:1 across:522104k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
printk: 135272 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: usleep/2171
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 2171, comm: usleep Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff81076242>] find_get_page+0x172/0x182
 [<ffffffff81076688>] find_lock_page+0x15/0x61
 [<ffffffff810786dc>] filemap_fault+0x75/0x3a2
 [<ffffffff810843c2>] __do_fault+0x63/0x3f6
 [<ffffffff81049a06>] lock_hrtimer_base+0x1b/0x3c
 [<ffffffff81087172>] handle_mm_fault+0x37c/0x797
 [<ffffffff8127db26>] __spin_unlock+0x10/0x2b
 [<ffffffff8127fe75>] do_page_fault+0x3f7/0x7b2
 [<ffffffff8127bf97>] do_nanosleep+0x41/0x9c
 [<ffffffff8127dd99>] error_exit+0x0/0x51

eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
fuse init (API version 7.9)
printk: 165330 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: rsyslogd/2593
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 2593, comm: rsyslogd Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810a1dca>] fget_light+0x94/0x9c
 [<ffffffff810a1668>] sys_write+0x21/0x74
 [<ffffffff8100bf00>] tracesys+0x71/0xe1
 [<ffffffff8100bf6b>] tracesys+0xdc/0xe1

warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
printk: 115847 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: yum-updatesd/2886
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 2886, comm: yum-updatesd Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff81076242>] find_get_page+0x172/0x182
 [<ffffffff810763d9>] __lock_page_killable+0xc1/0xc6
 [<ffffffff81075d90>] file_read_actor+0xab/0x12e
 [<ffffffff8107830d>] generic_file_aio_read+0x1b0/0x4cf
 [<ffffffff810a0a1f>] do_sync_read+0xc9/0x10c
 [<ffffffff81046dfe>] autoremove_wake_function+0x0/0x2e
 [<ffffffff810a1216>] vfs_read+0xaa/0x152
 [<ffffffff810a161b>] sys_read+0x48/0x74
 [<ffffffff8100bf6b>] tracesys+0xdc/0xe1

eth0: no IPv6 routers present
printk: 113284 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: gam_server/2959
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 2959, comm: gam_server Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810a196b>] put_filp+0x1c/0x44
 [<ffffffff810ab348>] __path_lookup_intent_open+0x87/0x97
 [<ffffffff810ab667>] open_namei+0x7d/0x681
 [<ffffffff8109f4e8>] do_filp_open+0x1c/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100bf6b>] tracesys+0xdc/0xe1

printk: 72709 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: pwunconv/3081
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 3081, comm: pwunconv Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810a18c5>] file_move+0x1c/0xa6
 [<ffffffff8109f390>] __dentry_open+0xf9/0x204
 [<ffffffff8109f4f6>] do_filp_open+0x2a/0x38
 [<ffffffff8109f282>] get_unused_fd_flags+0x111/0x11f
 [<ffffffff8109f54a>] do_sys_open+0x46/0xc3
 [<ffffffff8100bf6b>] tracesys+0xdc/0xe1

printk: 37677 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000000] code: sshd/3097
caller is __rcu_preempt_unboost+0x1f/0xee
Pid: 3097, comm: sshd Not tainted 2.6.25.8-rt7 #1

Call Trace:
 [<ffffffff8112e459>] debug_smp_processor_id+0xad/0xb8
 [<ffffffff81072931>] __rcu_preempt_unboost+0x1f/0xee
 [<ffffffff810ad97e>] core_sys_select+0x56/0x270
 [<ffffffff810a0a1f>] do_sync_read+0xc9/0x10c
 [<ffffffff81046dfe>] autoremove_wake_function+0x0/0x2e
 [<ffffffff810386d3>] current_fs_time+0x1e/0x24
 [<ffffffff810adf54>] sys_select+0xba/0x182
 [<ffffffff8100bf6b>] tracesys+0xdc/0xe1
