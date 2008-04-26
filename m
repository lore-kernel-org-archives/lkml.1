Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYDZVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYDZVd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYDZVdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:33:50 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:39643 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbYDZVds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:33:48 -0400
From: Bernard Pidoux <bpidoux@free.fr>
To: linux-kernel@vger.kernel.org
Subject: Re: spinlock lockup on CPU#0
Date: Sat, 26 Apr 2008 23:33:39 +0200
User-Agent: KMail/1.9.9
Cc: Bernard Pidoux <bpidoux@free.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_z+5EI2TiLR+rLEG"
Message-Id: <200804262333.39383.bpidoux@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_z+5EI2TiLR+rLEG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I observed about the same message but after the line
Brought up 2 CPUs in dmesg.
However the system keeps running fine. 
I run a Core2 Duo processor.
dmesg dump is attached. 

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2662 check_flags+0x18d/0x190()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.25 #2

Call Trace:
 [<ffffffff8022fbff>] warn_on_slowpath+0x5f/0x80
 [<ffffffff80213a77>] ? native_sched_clock+0x57/0x80
 [<ffffffff8022ac1a>] ? hrtick_set+0x3a/0x120
 [<ffffffff80254da5>] ? __lock_acquire+0x245/0x1070
 [<ffffffff8022ac9d>] ? hrtick_set+0xbd/0x120
 [<ffffffff80213a77>] ? native_sched_clock+0x57/0x80
 [<ffffffff8024b0b0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff8025180d>] check_flags+0x18d/0x190
 [<ffffffff80255c33>] lock_acquire+0x63/0xd0
 [<ffffffff8024b101>] __atomic_notifier_call_chain+0x51/0xa0
 [<ffffffff8020b210>] ? mwait_idle+0x0/0x50
 [<ffffffff8020b0a0>] ? default_idle+0x0/0x80
 [<ffffffff8024b161>] atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020a849>] __exit_idle+0x29/0x30
 [<ffffffff8020b178>] cpu_idle+0x58/0xa0
 [<ffffffff80450b5e>] start_secondary+0x2fe/0x430

---[ end trace ca143223eefdc828 ]---
possible reason: unannotated irqs-on.
irq event stamp: 12


Bernard Pidoux

--Boundary-00=_z+5EI2TiLR+rLEG
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg_swapper_Not_tainted_2.6.25"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_swapper_Not_tainted_2.6.25"


Linux version 2.6.25 (root@f6bvp-7) (gcc version 4.2.3 (4.2.3-6mnb1)) #2 SMP Sat Apr 26 22:26:35 CEST 2008
Command line: BOOT_IMAGE=2.6.25 root=UUID=aaf61075-ffef-44f9-bb0b-9858afcfe990 resume=/dev/hda5 splash=silent vga=788
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
 BIOS-e820: 000000003fee0000 - 000000003fee3000 (ACPI NVS)
 BIOS-e820: 000000003fee3000 - 000000003fef0000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 261856) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F7910, 0014 (r0 P4M890)
ACPI: RSDT 3FEE3040, 0038 (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FEE30C0, 0074 (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FEE3180, 6A65 (r1 P4M890 AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FEE0000, 0040
ACPI: MCFG 3FEE9D40, 003C (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FEE9C40, 0090 (r1 P4M890 AWRDACPI 42302E31 AWRD        0)
ACPI: SSDT 3FEE9DC0, 019E (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
ACPI: SSDT 3FEEA250, 02F1 (r1  PmRef    CpuPm     3000 INTL 20041203)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 261856) 1 entries of 256 used
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-a56297] TEXT DATA BSS
early res: 3 [37d60000-37fefbf6] RAMDISK
early res: 4 [9f000-aefff] EBDA
early res: 5 [8000-afff] PGTABLE
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   261856
On node 0 totalpages: 261759
  DMA zone: 56 pages used for memmap
  DMA zone: 2158 pages reserved
  DMA zone: 1785 pages, LIFO batch:0
  DMA32 zone: 3524 pages used for memmap
  DMA32 zone: 254236 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 40000000 (gap: 3fef0000:a0110000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 423648 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256021
Kernel command line: BOOT_IMAGE=2.6.25 root=UUID=aaf61075-ffef-44f9-bb0b-9858afcfe990 resume=/dev/hda5 splash=silent vga=788
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 2194.494 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1712 kB
 per task-struct memory footprint: 3456 bytes
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
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
Memory: 1018620k/1047424k available (2398k kernel code, 28032k reserved, 1193k data, 628k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 4397.01 BogoMIPS (lpj=8794033)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12468711
Detected 12.468 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4388.98 BogoMIPS (lpj=8777966)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     E4500  @ 2.20GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2662 check_flags+0x18d/0x190()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.25 #2

Call Trace:
 [<ffffffff8022fbff>] warn_on_slowpath+0x5f/0x80
 [<ffffffff80213a77>] ? native_sched_clock+0x57/0x80
 [<ffffffff8022ac1a>] ? hrtick_set+0x3a/0x120
 [<ffffffff80254da5>] ? __lock_acquire+0x245/0x1070
 [<ffffffff8022ac9d>] ? hrtick_set+0xbd/0x120
 [<ffffffff80213a77>] ? native_sched_clock+0x57/0x80
 [<ffffffff8024b0b0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff8025180d>] check_flags+0x18d/0x190
 [<ffffffff80255c33>] lock_acquire+0x63/0xd0
 [<ffffffff8024b101>] __atomic_notifier_call_chain+0x51/0xa0
 [<ffffffff8020b210>] ? mwait_idle+0x0/0x50
 [<ffffffff8020b0a0>] ? default_idle+0x0/0x80
 [<ffffffff8024b161>] atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020a849>] __exit_idle+0x29/0x30
 [<ffffffff8020b178>] cpu_idle+0x58/0xa0
 [<ffffffff80450b5e>] start_secondary+0x2fe/0x430

---[ end trace ca143223eefdc828 ]---
possible reason: unannotated irqs-on.
irq event stamp: 12
hardirqs last  enabled at (11): [<ffffffff804568c5>] _spin_unlock_irqrestore+0x55/0x60
hardirqs last disabled at (12): [<ffffffff8020b16c>] cpu_idle+0x4c/0xa0
softirqs last  enabled at (0): [<ffffffff8022da82>] copy_process+0x2d2/0x16a0
softirqs last disabled at (0): [<0000000000000000>] 0x0
khelper used greatest stack depth: 5920 bytes left
net_namespace: 1144 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEXG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *5
ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
system 00:01: ioport range 0x400-0x47f has been reserved
system 00:01: ioport range 0x500-0x50f has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:02: ioport range 0x880-0x88f has been reserved
system 00:0d: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0e: iomem range 0xcec00-0xcffff has been reserved
system 00:0e: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0e: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0e: iomem range 0xfc000-0xfffff could not be reserved
system 00:0e: iomem range 0x3fee0000-0x3fefffff could not be reserved
system 00:0e: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0x100000-0x3fedffff could not be reserved
system 00:0e: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0e: iomem range 0xfff80000-0xfffeffff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: 0xdfc00000-0xdfcfffff
  PREFETCH window: 0x00000000dfb00000-0x00000000dfbfffff
PCI: Bridge: 0000:00:02.0
  IO window: b000-bfff
  MEM window: 0xdc000000-0xdeffffff
  PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
PCI: Bridge: 0000:00:03.0
  IO window: a000-afff
  MEM window: 0xdfe00000-0xdfefffff
  PREFETCH window: 0x00000000dfd00000-0x00000000dfdfffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 27
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 31
PCI: Setting latency timer of device 0000:00:03.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2622k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1209242386.680:1): initialized
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
pci 0000:00:10.4: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:00:11.0: Bypassing VIA 8237 APIC De-Assert Message
pci 0000:02:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
Allocate Port Service[0000:00:02.0:pcie02]
Allocate Port Service[0000:00:02.0:pcie03]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie01]
Allocate Port Service[0000:00:03.0:pcie02]
Allocate Port Service[0000:00:03.0:pcie03]
AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:03.0:pcie01 - no _OSC support
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 1875k, total 262144k
vesafb: mode is 800x600x16, linelength=1600, pages=2
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
TCP cubic registered
NET: Registered protocol family 1
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Freeing unused kernel memory: 628k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 21, io mem 0xdfffe000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
input: PS/2 Logitech Mouse as /devices/platform/i8042/serio1/input/input1
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
modprobe used greatest stack depth: 4688 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000dc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000d400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 21, io base 0x0000d000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb5: SerialNumber: 0000:00:10.3
modprobe used greatest stack depth: 4672 bytes left
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:0f.1
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
    ide0: BM-DMA at 0xe000-0xe007, BIOS settings: hda:DMA, hdb:PIO
    ide1: BM-DMA at 0xe008-0xe00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: ST340016A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: PIONEER DVD-RW DVR-112D, ATAPI CD/DVD-ROM drive
hdd: Maxtor 6L080P0, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdc: UDMA/33 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdd: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes not supported
 hda: hda1 hda2 < hda5 hda6 hda7 hda8 >
hdd: max request size: 128KiB
hdd: 160086528 sectors (81964 MB) w/8192KiB Cache, CHS=65535/16/63
hdd: cache flushes supported
 hdd: hdd1 hdd2 < hdd5 >
modprobe used greatest stack depth: 3688 bytes left
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
awk used greatest stack depth: 3672 bytes left
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 21 (level, low) -> IRQ 21
eth0: RealTek RTL8139 at 0xffffc20000018000, 00:16:17:b3:e9:69, IRQ 21
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
agpgart: Detected VIA P4M890 chipset
agpgart: AGP aperture is 128M @ 0xd0000000
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP]
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache
Uniform CD-ROM driver Revision: 3.20
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
ACPI: Sleep Button (CM) [SLPB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: SSDT 3FEEA1C0, 0087 (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:11.5 to 64
FDC 0 is a post-1991 82077
No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
sata_via 0000:00:0f.0: version 2.3
ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
sata_via 0000:00:0f.0: routed to hard irq line 11
scsi0 : sata_via
scsi1 : sata_via
ata1: SATA max UDMA/133 cmd 0xf800 ctl 0xf400 bmdma 0xe800 irq 20
ata2: SATA max UDMA/133 cmd 0xf000 ctl 0xec00 bmdma 0xe808 irq 20
ata1: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
EXT3 FS on hda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdd1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdd5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
loop: module loaded
Adding 2747072k swap on /dev/hda5.  Priority:-1 extents:1 across:2747072k
rc.sysinit used greatest stack depth: 3416 bytes left
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
fuse init (API version 7.9)
warning: `proftpd' uses 32-bit capabilities (legacy support in use)
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
eth0: no IPv6 routers present
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
netconsole: local port 4444
netconsole: local IP 192.168.0.103
netconsole: interface eth0
netconsole: remote port 5555
netconsole: remote IP 192.168.0.66
netconsole: remote ethernet address 00:00:1c:08:d9:76
console [netcon0] enabled
netconsole: network logging started

--Boundary-00=_z+5EI2TiLR+rLEG--
