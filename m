Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYCJLJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYCJLJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYCJLJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:09:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47619 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYCJLI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:08:59 -0400
Date: Mon, 10 Mar 2008 10:40:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Message-ID: <20080310094046.GA9433@elf.ucw.cz>
References: <20080306102927.GA4434@elf.ucw.cz> <20080306131547.GE21359@elte.hu> <86802c440803061127s5ca545bch930310a0df6511fc@mail.gmail.com> <20080306212419.GA13798@elf.ucw.cz> <86802c440803061350g146a0b27xe358658f3315376@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440803061350g146a0b27xe358658f3315376@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  > >  > On amd 8-core system, I get crash on boot... Last messages:
> >  > >  >
> >  > >  > Quad-Core AMD Opteron...
> >  > >  > Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
> >  > >  > BUG: unable to handle kernel paging request at 00...005958
> >  > >  > IP: __alloc_pages+0x38
> >  > >  > ...
> >  > >  > Call trace:
> >  > >  > kmem_getpages
> >  > >  > cache_grow
> >  > >  > ____cache_alloc_node
> >  > >  > cpuup_callback
> >  > >  > kmem_cache_alloc_node
> >  > >  > cpuup_callback
> >  > >  > notifier_call_chain
> >  > >  > _cpu_up
> >  > >
> >  > >  could you try latest x86.git:
> >  > >
> >  > >     http://people.redhat.com/mingo/x86.git/README
> >  > >
> >  > >  does it fix it? Could be one of the numa fixes that are queued up.
> >  >
> >
> > > can we have your config and whole bootlog?
> >
> >  Config is attached.
> >
> >  Bootlog is a bit of problem. I can get you whole bootlog with "nosmp",
> >  or maybe some jpg files of the real problem. Which one do you prefer?
> >  ;-).
> boot log for 2.6.24 could be good, if it can boot with that.

Here it is:

Linux version 2.6.24 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #1 SMP Thu Mar 6 12:54:59 CET 2008
Command line: root=/dev/sda2 vga=6    resume=/dev/sda1 splash=silent no_console_suspend 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
 BIOS-e820: 00000000bfed0000 - 00000000bfee2000 (ACPI data)
 BIOS-e820: 00000000bfee2000 - 00000000bfeee000 (ACPI NVS)
 BIOS-e820: 00000000bfeee000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 786128) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1310720) 2 entries of 3200 used
end_pfn_map = 1310720
DMI present.
ACPI: RSDP 000F8010, 0024 (r2 PTLTD )
ACPI: XSDT BFEDBF8C, 0064 (r1 BRCM   Anaheim   6040000 PTL   2000001)
ACPI: FACP BFEDC064, 00F4 (r3 BRCM   EXPLOSN   6040000 MSFT  2000001)
ACPI Warning (tbfadt-0442): Optional field "Pm2ControlBlock" has zero address or length: 0000000000000000/C [20070126]
ACPI: DSDT BFEDC158, 4777 (r2 AMD    Anaheim   6040000 MSFT  2000002)
ACPI: FACS BFEEDFC0, 0040
ACPI: TCPA BFEE08CF, 0032 (r1 BRCM   Anaheim   6040000 PTL  20000001)
ACPI: SRAT BFEE0901, 0128 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: SSDT BFEE0A29, 143C (r1 AMD    POWERNOW  6040000 AMD         1)
ACPI: HPET BFEE1E65, 0038 (r1 BRCM   Anaheim   6040000 BRCM  2000001)
ACPI: SSDT BFEE1E9D, 0049 (r1 BRCM   PRT0      6040000 BRCM  2000001)
ACPI: SPCR BFEE1EE6, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: APIC BFEE1F36, 00CA (r1 BRCM   Anaheim   6040000 PTL   2000001)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
SRAT: PXM 1 -> APIC 4 -> Node 1
SRAT: PXM 1 -> APIC 5 -> Node 1
SRAT: PXM 1 -> APIC 6 -> Node 1
SRAT: PXM 1 -> APIC 7 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-c0000000
Entering add_active_range(0, 0, 157) 1 entries of 3200 used
Entering add_active_range(0, 256, 786128) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-140000000
Entering add_active_range(0, 0, 157) 2 entries of 3200 used
Entering add_active_range(0, 256, 786128) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1310720) 2 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000140000000
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
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810006600000 on node 0
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810006a00000 on node 0
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810006e00000 on node 0
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810007200000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810007600000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810007a00000 on node 0
 [ffffe20004400000-ffffe200045fffff] PMD ->ffff810007e00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1310720
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      157
    0:      256 ->   786128
    0:  1048576 ->  1310720
On node 0 totalpages: 1048173
  DMA zone: 56 pages used for memmap
  DMA zone: 2336 pages reserved
  DMA zone: 1605 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 767752 pages, LIFO batch:31
  Normal zone: 3584 pages used for memmap
  Normal zone: 258560 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x508
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
Processor #4
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
Processor #5
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 9, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x0a] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 10, address 0xfec02000, GSI 32-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x1166a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009d000 - 000000000009e000
swsusp: Registered nosave memory region: 000000000009e000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000d2000
swsusp: Registered nosave memory region: 00000000000d2000 - 0000000000100000
swsusp: Registered nosave memory region: 00000000bfed0000 - 00000000bfee2000
swsusp: Registered nosave memory region: 00000000bfee2000 - 00000000bfeee000
swsusp: Registered nosave memory region: 00000000bfeee000 - 00000000c0000000
swsusp: Registered nosave memory region: 00000000c0000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fec03000
swsusp: Registered nosave memory region: 00000000fec03000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000fff80000
swsusp: Registered nosave memory region: 00000000fff80000 - 0000000100000000
Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PERCPU: Allocating 35000 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1027917
Policy zone: Normal
Kernel command line: root=/dev/sda2 vga=6    resume=/dev/sda1 splash=silent no_console_suspend 3
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
hpet clockevent registered
TSC calibrated against HPET
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1994.999 MHz processor.
Console: colour VGA+ 80x60
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ c000000
Memory: 4059860k/5242880k available (5528k kernel code, 132832k reserved, 2401k data, 372k init)
Calibrating delay using timer specific routine.. 3993.18 BogoMIPS (lpj=7986378)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 755 Objects with 87 Devices 260 Methods 23 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 40 Objects with 0 Devices 0 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 1 Objects with 0 Devices 1 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
APIC timer calibration result 12468735
Detected 12.468 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/8 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3994.83 BogoMIPS (lpj=7989667)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Quad-Core AMD Opteron(tm) Processor 2350 stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/8 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 3990.18 BogoMIPS (lpj=7980378)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Quad-Core AMD Opteron(tm) Processor 2350 stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/8 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 3990.19 BogoMIPS (lpj=7980386)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Quad-Core AMD Opteron(tm) Processor 2350 stepping 02
SMP alternatives: switching to SMP code
Booting processor 4/8 APIC 0x4
Initializing CPU#4
Calibrating delay using timer specific routine.. 3990.06 BogoMIPS (lpj=7980128)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 4/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Quad-Core AMD Opteron(tm) Processor 2350 stepping 02
SMP alternatives: switching to SMP code
Booting processor 5/8 APIC 0x5
Initializing CPU#5
Calibrating delay using timer specific routine.. 3990.06 BogoMIPS (lpj=7980129)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 5/5 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Quad-Core AMD Opteron(tm) Processor 2350 stepping 02
SMP alternatives: switching to SMP code
Booting processor 6/8 APIC 0x6
Initializing CPU#6
Calibrating delay using timer specific routine.. 3990.05 BogoMIPS (lpj=7980105)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 6/6 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
Quad-Core AMD Opteron(tm) Processor 2350 stepping 02
SMP alternatives: switching to SMP code
Booting processor 7/8 APIC 0x7
Initializing CPU#7
Calibrating delay using timer specific routine.. 3990.08 BogoMIPS (lpj=7980172)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 7/7 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
Quad-Core AMD Opteron(tm) Processor 2350 stepping 02
Brought up 8 CPUs
CPU0 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000001 00000002 00000004 00000008 00000010 00000020 00000040 00000080
  domain 1: span 000000ff
   groups: 000000ff
CPU1 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000002 00000004 00000008 00000010 00000020 00000040 00000080 00000001
  domain 1: span 000000ff
   groups: 000000ff
CPU2 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000004 00000008 00000010 00000020 00000040 00000080 00000001 00000002
  domain 1: span 000000ff
   groups: 000000ff
CPU3 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000008 00000010 00000020 00000040 00000080 00000001 00000002 00000004
  domain 1: span 000000ff
   groups: 000000ff
CPU4 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000010 00000020 00000040 00000080 00000001 00000002 00000004 00000008
  domain 1: span 000000ff
   groups: 000000ff
CPU5 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000020 00000040 00000080 00000001 00000002 00000004 00000008 00000010
  domain 1: span 000000ff
   groups: 000000ff
CPU6 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000040 00000080 00000001 00000002 00000004 00000008 00000010 00000020
  domain 1: span 000000ff
   groups: 000000ff
CPU7 attaching sched-domain:
 domain 0: span 000000ff
  groups: 00000080 00000001 00000002 00000004 00000008 00000010 00000020 00000040
  domain 1: span 000000ff
   groups: 000000ff
net_namespace: 120 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 20 to 3F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 6 Wake, Enabled 0 Runtime GPEs in this block
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 0 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:......................................................................................................
Initialized 20/23 Regions 0/0 Fields 21/21 Buffers 61/69 Packages (805 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 97 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXB_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXB_.PPBX._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB4._PRT]
ACPI: PCI Interrupt Link [LNKU] (IRQs *10 11)
ACPI: PCI Interrupt Link [LNKW] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKS] (IRQs 5 *7 11)
ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN01] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN02] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN03] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN04] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN05] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN06] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN07] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN08] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN09] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN0A] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN0B] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN0C] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN0D] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN0E] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN0F] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN10] (IRQs 3 4 5 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LN11] (IRQs 3 4 *5 7 11 12 14 15)
ACPI: PCI Interrupt Link [LN12] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN13] (IRQs 3 4 *5 7 11 12 14 15)
ACPI: PCI Interrupt Link [LN14] (IRQs 3 4 5 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LN15] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN16] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN17] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN18] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN19] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1A] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1B] (IRQs 3 4 *5 7 11 12 14 15)
ACPI: PCI Interrupt Link [LN1C] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1D] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1E] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1F] (IRQs 3 4 5 7 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
irda_init()
NET: Registered protocol family 23
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ c000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
system 00:00: iomem range 0xfed08000-0xfed08007 has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0b: ioport range 0x40b-0x40b has been reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x4d6-0x4d6 has been reserved
system 00:0b: ioport range 0x500-0x560 has been reserved
system 00:0b: ioport range 0x558-0x55b has been reserved
system 00:0b: ioport range 0x580-0x58f has been reserved
system 00:0b: ioport range 0x590-0x593 has been reserved
system 00:0b: ioport range 0x600-0x61f has been reserved
system 00:0b: ioport range 0x620-0x623 has been reserved
system 00:0b: ioport range 0x700-0x703 has been reserved
system 00:0b: ioport range 0xc00-0xc01 has been reserved
system 00:0b: ioport range 0xc06-0xc08 has been reserved
system 00:0b: ioport range 0xc14-0xc14 has been reserved
system 00:0b: ioport range 0xc49-0xc4a has been reserved
system 00:0b: ioport range 0xc50-0xc53 has been reserved
system 00:0b: ioport range 0xc6c-0xc6c has been reserved
system 00:0b: ioport range 0xc6f-0xc6f has been reserved
system 00:0b: ioport range 0xcd6-0xcd7 has been reserved
system 00:0b: ioport range 0xcf9-0xcf9 could not be reserved
system 00:0b: ioport range 0xf50-0xf58 has been reserved
PCI: Bridge: 0000:01:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: da300000-da3fffff
  PREFETCH window: da000000-da0fffff
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Failed to allocate mem resource #6:20000@d0000000 for 0000:04:00.0
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: d8000000-d9ffffff
  PREFETCH window: c0000000-cfffffff
PCI: Bridge: 0000:00:08.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:09.0
  IO window: 7000-7fff
  MEM window: da200000-da2fffff
  PREFETCH window: da100000-da1fffff
PCI: Bridge: 0000:07:00.0
  IO window: disabled.
  MEM window: da400000-da4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: disabled.
  MEM window: da400000-da4fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 32 (level, low) -> IRQ 32
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 32 (level, low) -> IRQ 32
PCI: Setting latency timer of device 0000:00:07.0 to 64
ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 32 (level, low) -> IRQ 32
PCI: Setting latency timer of device 0000:00:08.0 to 64
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 32 (level, low) -> IRQ 32
PCI: Setting latency timer of device 0000:00:09.0 to 64
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 32 (level, low) -> IRQ 32
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:07:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NTFS driver 2.1.29 [Flags: R/O DEBUG].
JFFS2 version 2.2. (NAND) ÂŠ 2001-2006 Red Hat, Inc.
fuse init (API version 7.9)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:04:00.0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information
acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
PCI: Enabling device 0000:00:04.0 (0084 -> 0087)
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 43 (level, low) -> IRQ 43
radeonfb (0000:00:04.0): cannot map FB
radeonfb: probe of 0000:00:04.0 failed with error -5
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input1
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
lp: driver loaded but no devices found
Generic RTC Driver v1.07
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.28.0 20060524 on minor 0
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
intelfb: Version 0.9.4
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:08:04.0[A] -> GSI 36 (level, low) -> IRQ 36
eth0: Tigon3 [partno(BCM95715) rev 9001 PHY(5714)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:80:cc:88
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76148000] dma_mask[40-bit]
ACPI: PCI Interrupt 0000:08:04.1[B] -> GSI 36 (level, low) -> IRQ 36
eth1: Tigon3 [partno(BCM95715) rev 9001 PHY(5714)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:80:cc:89
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76148000] dma_mask[40-bit]
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
usbcore: registered new interface driver catc
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
usbcore: registered new interface driver zd1211rw
usbcore: registered new interface driver zd1201
Linux video capture interface: v2.00
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_svw 0000:01:0e.0: version 2.3
ACPI: PCI Interrupt Link [LNKS] enabled at IRQ 11
ACPI: PCI Interrupt 0000:01:0e.0[A] -> Link [LNKS] -> GSI 11 (level, low) -> IRQ 11
scsi0 : sata_svw
scsi1 : sata_svw
scsi2 : sata_svw
scsi3 : sata_svw
ata1: SATA max UDMA/133 mmio m8192@0xda300000 port 0xda300000 irq 11
ata2: SATA max UDMA/133 mmio m8192@0xda300000 port 0xda300100 irq 11
ata3: SATA max UDMA/133 mmio m8192@0xda300000 port 0xda300200 irq 11
ata4: SATA max UDMA/133 mmio m8192@0xda300000 port 0xda300300 irq 11
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3160815AS, 3.AAC, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 4 SControl 300)
ata3: SATA link down (SStatus 4 SControl 300)
ata4: SATA link down (SStatus 4 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3160815AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:01:0e.1[A] -> Link [LNKS] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:01:0e.1 disabled
scsi4 : pata_serverworks
scsi5 : pata_serverworks
ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0x4800 irq 14
ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0x4808 irq 15
ata5.00: ATAPI: TEAC DV-516G, F4S7, max UDMA/33
ata5.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            TEAC     DV-516G          F4S7 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:01:0e.1[A] -> Link [LNKS] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:01:0e.1 disabled
ACPI: PCI Interrupt Link [LNKU] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:03.2[A] -> Link [LNKU] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:03.2: EHCI Host Controller
ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.2: irq 10, io mem 0xda512000
ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKU] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 10, io mem 0xda510000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKU] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 10, io mem 0xda511000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
usb 2-1: new low speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 2-2: new low speed USB device using ohci_hcd and address 3
usb 2-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver cdc_acm
drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
input: PC Speaker as /class/input/input4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
EDAC MC: Ver: 2.1.0 Mar  6 2008
cpuidle: using governor ladder
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
input: Microsoft NaturalŽ Ergonomic Keyboard 4000 as /class/input/input5
input,hidraw0: USB HID v1.11 Keyboard [Microsoft NaturalŽ Ergonomic Keyboard 4000] on usb-0000:00:03.0-1
input: Microsoft NaturalŽ Ergonomic Keyboard 4000 as /class/input/input6
input,hidraw1: USB HID v1.11 Device [Microsoft NaturalŽ Ergonomic Keyboard 4000] on usb-0000:00:03.0-1
input: Genius NetScroll + Traveler as /class/input/input7
input,hidraw2: USB HID v1.10 Mouse [Genius NetScroll + Traveler] on usb-0000:00:03.0-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 2007 UTC).
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  No soundcards found.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
IrCOMM protocol (Dag Brattli)
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
Installing 9P2000 support
powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 2350 processors (8 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x0 did 0x0 (2000 MHz)
powernow-k8:    1 : fid 0x0 did 0x0 (1700 MHz)
powernow-k8:    2 : fid 0x0 did 0x0 (1400 MHz)
powernow-k8:    3 : fid 0x0 did 0x0 (1200 MHz)
powernow-k8:    4 : fid 0x0 did 0x0 (1000 MHz)
powernow-k8:    0 : fid 0x0 did 0x0 (2000 MHz)
powernow-k8:    1 : fid 0x0 did 0x0 (1700 MHz)
powernow-k8:    2 : fid 0x0 did 0x0 (1400 MHz)
powernow-k8:    3 : fid 0x0 did 0x0 (1200 MHz)
powernow-k8:    4 : fid 0x0 did 0x0 (1000 MHz)
swsusp: Resume From Partition /dev/sda1
PM: Checking swsusp image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 372k freed
ioctl32(showconsole:1399): Unknown cmd fd(0) cmd(80045432){t:'T';sz:4} arg(fff914b8) on /dev/console
Adding 2104472k swap on /dev/sda1.  Priority:-1 extents:1 across:2104472k
ioctl32(showconsole:2654): Unknown cmd fd(0) cmd(80045432){t:'T';sz:4} arg(ff8344f8) on /dev/console
EXT3 (no)acl options not supported
EXT3 (no)acl options not supported
EXT3 FS on sda2, internal journal
ioctl32(showconsole:2682): Unknown cmd fd(0) cmd(80045432){t:'T';sz:4} arg(ff89d568) on /dev/console
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ioctl32(showconsole:2768): Unknown cmd fd(0) cmd(80045432){t:'T';sz:4} arg(fff62c38) on /dev/console
ioctl32(showconsole:2900): Unknown cmd fd(0) cmd(80045432){t:'T';sz:4} arg(ffd39248) on /dev/console
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
