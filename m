Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYFQAIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYFQAIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 20:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYFQAIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 20:08:34 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:37405 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYFQAI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 20:08:27 -0400
Date: Mon, 16 Jun 2008 20:08:10 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-reply-to: <200806161539.05524.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Message-id: <alpine.LFD.1.10.0806161959460.12628@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
 <200806160314.49489.rjw@sisk.pl>
 <Pine.LNX.4.55.0806160343220.11995@cliff.in.clinika.pl>
 <200806161539.05524.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >  Can I have .config used and a full bootstrap log from that system with
> > the patch still applied?

here you go -- linux-next fails on my nx6325 in the same way.
comes up with fan on full speed, even though ACPI reports temperature is 
only 34C.

Also, after booting linux-next, a reboot failed to get through 
POST and I had to hard poweroff the machine.

I'll boot next with the AMD C1E failure reverted -- as it just
resulted in a nastygram sent over to kerneloops.org...

below is dmesg, interrupts, .config

cheers,
-Len

Linux version 2.6.26-rc6-next-20080616 (lenb@d975xbx2) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Mon Jun 16 19:23:56 EDT 2008
Command line: root=/dev/sda3 debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001bfd0000 (usable)
 BIOS-e820: 000000001bfd0000 - 000000001bfe5600 (reserved)
 BIOS-e820: 000000001bfe5600 - 000000001bff8000 (ACPI NVS)
 BIOS-e820: 000000001bff8000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 114640) 1 entries of 3200 used
last_pfn = 114640 max_arch_pfn = 17179869183
init_memory_mapping
DMI 2.4 present.
ACPI: RSDP 000F7D30, 0024 (r2 HP    )
ACPI: XSDT 1BFE57B4, 0054 (r1 HP     0944      6070620 HP          1)
ACPI: FACP 1BFE5684, 00F4 (r4 HP     0944            3 HP          1)
ACPI: DSDT 1BFE58DC, EE7A (r1 HP        SB400    10000 MSFT  100000E)
ACPI: FACS 1BFF7E80, 0040
ACPI: APIC 1BFE5808, 0062 (r1 HP     0944            1 HP          1)
ACPI: MCFG 1BFE586C, 003C (r1 HP     0944            1 HP          1)
ACPI: TCPA 1BFE58A8, 0032 (r2 HP     0944            1 HP          1)
ACPI: SSDT 1BFF4756, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT 1BFF47AF, 0182 (r1 HP     PSSTBLID        1 HP          1)
ACPI: DMI detected: Hewlett-Packard
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000001bfd0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 114640) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000001bfd0000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [000000000000a000 -  000000000000d7ff] pages 4
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-8cd457] TEXT DATA BSS
  early res: 3 [9fc00-fffff] BIOS reserved
  early res: 4 [8000-9fff] PGTABLE
Scan SMP from ffff810000000000 for 1024 bytes.
Scan SMP from ffff81000009fc00 for 1024 bytes.
Scan SMP from ffff8100000f0000 for 65536 bytes.
Scan SMP from ffff81000009fc00 for 1024 bytes.
 [ffffe20000000000-ffffe200007fffff] PMD -> [ffff810001200000-ffff8100019fffff] on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   114640
On node 0 totalpages: 114543
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3943 pages, LIFO batch:0
  DMA32 zone: 1512 pages used for memmap
  DMA32 zone: 109032 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:c0000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 33840 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 112975
Policy zone: DMA32
Kernel command line: root=/dev/sda3 debug
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1596.000 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Node 0: aperture @ 1494000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 442552k/458560k available (3545k kernel code, 15620k reserved, 2021k data, 468k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 3194.16 BogoMIPS (lpj=1597080)
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080609
Parsing all Control Methods:
Table [DSDT](id 0001) - 1153 Objects with 113 Devices 337 Methods 33 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 2 Objects with 0 Devices 2 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 8 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
..MP-BIOS bug: 8254 timer not connected to IO-APIC
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12468754
Detected 12.468 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3191.90 BogoMIPS (lpj=1595950)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
System has C1E enabled
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (6386.06 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
net_namespace: 360 bytes
------------[ cut here ]------------
WARNING: at kernel/smp.c:215 smp_call_function_single+0x3d/0xa2()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.26-rc6-next-20080616 #1

Call Trace:
 [<ffffffff80231adf>] warn_on_slowpath+0x58/0x94
 [<ffffffff80231dd3>] ? __call_console_drivers+0x65/0x76
 [<ffffffff802478fe>] ? up+0x34/0x39
 [<ffffffff802322a8>] ? release_console_sem+0x190/0x19d
 [<ffffffff802508b0>] smp_call_function_single+0x3d/0xa2
 [<ffffffff8024c64a>] tick_broadcast_on_off+0x46/0x48
 [<ffffffff8024bcb1>] tick_notify+0x1db/0x33b
 [<ffffffff805727ab>] notifier_call_chain+0x33/0x5b
 [<ffffffff80247aa4>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff8024b7cc>] clockevents_notify+0x2b/0x80
 [<ffffffff80211621>] c1e_idle+0x91/0xd5
 [<ffffffff805727f5>] ? atomic_notifier_call_chain+0x13/0x15
 [<ffffffff8020a3f3>] cpu_idle+0x64/0xa8
 [<ffffffff8056a33e>] start_secondary+0x15d/0x161

---[ end trace 4eaa2a86a8e2da22 ]---
Switch to broadcast mode on CPU1
NET: Registered protocol family 16
No dock devices found.
------------[ cut here ]------------
WARNING: at kernel/smp.c:215 smp_call_function_single+0x3d/0xa2()
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W 2.6.26-rc6-next-20080616 #1

Call Trace:
 [<ffffffff80231adf>] warn_on_slowpath+0x58/0x94
 [<ffffffff80288c0a>] ? kmem_cache_alloc+0x12f/0x15d
 [<ffffffff80241c50>] ? alloc_pid+0x25b/0x377
 [<ffffffff8022b17d>] ? enqueue_task_fair+0x1e4/0x1f0
 [<ffffffff802508b0>] smp_call_function_single+0x3d/0xa2
 [<ffffffff8024c64a>] tick_broadcast_on_off+0x46/0x48
 [<ffffffff8024bcb1>] tick_notify+0x1db/0x33b
 [<ffffffff805727ab>] notifier_call_chain+0x33/0x5b
 [<ffffffff80247aa4>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff8024b7cc>] clockevents_notify+0x2b/0x80
 [<ffffffff80211621>] c1e_idle+0x91/0xd5
 [<ffffffff805727f5>] ? atomic_notifier_call_chain+0x13/0x15
 [<ffffffff8020a3f3>] cpu_idle+0x64/0xa8
 [<ffffffff80551c2d>] rest_init+0x61/0x63
 [<ffffffff80789d68>] start_kernel+0x2f0/0x2fb
 [<ffffffff80789376>] x86_64_start_kernel+0x185/0x18c

---[ end trace 4eaa2a86a8e2da22 ]---
Switch to broadcast mode on CPU0
node 0 link 0: io port [1000, fffff]
TOM: 0000000020000000 aka 512M
node 0 link 0: mmio [f0000000, ffffffff]
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [c4000000, dfffffff]
node 0 link 0: mmio [c0000000, c3ffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [20000000, bfffffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [20000000, fcffffffff]
bus: 00 index 2 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
evgpeblk-0952 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x15
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
Completing Region/Field/Buffer/Package initialization:.........................................................................................................................................................................
Initialized 29/33 Regions 0/0 Fields 63/64 Buffers 77/78 Packages (1172 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.......
Executed 7 _INI methods requiring 2 _STA executions (examined 120 objects)
evgpeblk-1049 [00] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 11 Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [C074] (0000:00)
HPET not enabled in BIOS. You might try hpet=force boot option
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.C074._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C075._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C0DF._PRT]
ACPI: PCI Interrupt Link [C125] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C126] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C127] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C128] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C129] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
ACPI: Power Resource [C223] (off)
ACPI: Power Resource [C1FE] (off)
ACPI: Power Resource [C217] (on)
ACPI: Power Resource [C34B] (off)
ACPI: Power Resource [C34C] (off)
ACPI: Power Resource [C34D] (off)
ACPI: Power Resource [C34E] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Cannot allocate resource region 0 of device 0000:00:14.2
DMAR:parse DMAR table failure.
tracer: 1286 pages allocated for 65536<6> entries of 80 bytes
   actual entries 65586
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x1bffffff could not be reserved
system 00:0a: ioport range 0x40b-0x40b has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
system 00:0a: ioport range 0x500-0x51f has been reserved
system 00:0a: ioport range 0xc00-0xc01 has been reserved
system 00:0a: ioport range 0xc14-0xc14 has been reserved
system 00:0a: ioport range 0xc50-0xc51 has been reserved
system 00:0a: ioport range 0xc52-0xc52 has been reserved
system 00:0a: ioport range 0xc6c-0xc6c has been reserved
system 00:0a: ioport range 0xc6f-0xc6f has been reserved
system 00:0a: ioport range 0xcd4-0xcdf has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0b: ioport range 0x8000-0x802f has been reserved
system 00:0b: ioport range 0x8100-0x811f has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0c: iomem range 0xcf000-0xcffff has been reserved
system 00:0c: iomem range 0x1c000000-0x1fffffff could not be reserved
system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
PCI: region 0000:02:04.0/9 too large: 0x0000000000000000-0x0000000003ffffff
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: 0xd0300000-0xd03fffff
  PREFETCH window: 0x00000000c0000000-0x00000000c3ffffff
Switched to high resolution mode on CPU 0
PCI: Bridge: 0000:00:04.0
  IO window: 4000-5fff
  MEM window: 0xcc000000-0xcfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: 2000-3fff
  MEM window: 0xc8000000-0xcbffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: 0xc4000000-0xc40fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 0x00001000-0x000010ff
  IO window: 0x00001400-0x000014ff
  MEM window: 0x34000000-0x37ffffff
PCI: Bridge: 0000:00:14.4
  IO window: 1000-1fff
  MEM window: 0xd0000000-0xd02fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
Int: type 0, pol 3, trig 3, bus 02, IRQ 10, APIC ID 2, APIC INT 14
NET: Registered protocol family 2
Switched to high resolution mode on CPU 1
IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 864
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: MSI quirk detected; MSI disabled
pci 0000:01:05.0: Boot video device
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
Allocate Port Service[0000:00:04.0:pcie03]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
Allocate Port Service[0000:00:05.0:pcie03]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
Allocate Port Service[0000:00:06.0:pcie03]
AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:06.0:pcie01 - no _OSC support
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [C25A]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [C25B]
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [C000] (supports 8 throttling states)
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [C001] (supports 8 throttling states)
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
tg3.c:v3.93 (May 22, 2008)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
Int: type 0, pol 3, trig 3, bus 02, IRQ 04, APIC ID 2, APIC INT 17
eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:17:08:30:e4:ee
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 50, APIC ID 2, APIC INT 10
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x7040-0x7047
ATIIXP: simplex device: DMA disabled
ide1: DMA disabled
Probing IDE interface ide0...
hda: TSSTcorpCDW/DVD TS-L462C, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 1536kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_sil 0000:00:12.0: version 2.3
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 48, APIC ID 2, APIC INT 10
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xd0409000 tf 0xd0409080 irq 16
ata2: SATA max UDMA/100 mmio m512@0xd0409000 tf 0xd04090c0 irq 16
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHT2040BH, 0000104A, max UDMA/100
ata1.00: 78140160 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2040B 0000 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:02:04.1[A] -> GSI 20 (level, low) -> IRQ 20
Int: type 0, pol 3, trig 3, bus 02, IRQ 10, APIC ID 2, APIC INT 14
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d0011000-d00117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 2, APIC INT 13
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0403000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26-rc6-next-20080616 ehci_hcd
usb usb1: SerialNumber: 0000:00:13.2
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 2, APIC INT 13
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0401000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26-rc6-next-20080616 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.0
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 4c, APIC ID 2, APIC INT 13
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0402000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26-rc6-next-20080616 ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usb 3-1: new full speed USB device using ohci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: New USB device found, idVendor=08ff, idProduct=2580
usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-1: Product: Fingerprint Sensor
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:C214,PNP0f13:C215] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.17rc1.
ALSA device list:
  No soundcards found.
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 468k freed
thermal LNXTHERM:01: registered as thermal_zone0
power_supply C1BD: uevent
power_supply C1BD: No power supply yet
power_supply C1BD: power_supply_changed
power_supply C1BD: power_supply_changed_work
power_supply C1BD: power_supply_update_gen_leds 1
power_supply C1BD: uevent
power_supply C1BD: POWER_SUPPLY_NAME=C1BD
power_supply C1BD: Static prop TYPE=Mains
power_supply C1BD: 1 dynamic props
power_supply C1BD: prop ONLINE=1
ACPI: AC Adapter [C1BD] (on-line)
ACPI: Thermal Zone [TZ1] (55 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZ2] (47 C)
input: Video Bus as /class/input/input5
thermal LNXTHERM:03: registered as thermal_zone2
ACPI: Video Device [C076] (multi-head: yes  rom: no  post: no)
ACPI: Thermal Zone [TZ3] (28 C)
fan PNP0C0B:00: registered as cooling_device2
ACPI: Fan [C34F] (on)
fan PNP0C0B:01: registered as cooling_device3
ACPI: Fan [C350] (on)
fan PNP0C0B:02: registered as cooling_device4
ACPI: Fan [C351] (on)
fan PNP0C0B:03: registered as cooling_device5
ACPI: Fan [C352] (on)
power_supply C1BF: uevent
power_supply C1BF: No power supply yet
power_supply C1BF: power_supply_changed
power_supply C1BF: power_supply_changed_work
power_supply C1BF: power_supply_update_bat_leds 4
ACPI: Battery Slot [C1BF] (battery present)
power_supply C1BF: uevent
power_supply C1BF: POWER_SUPPLY_NAME=C1BF
power_supply C1BF: Static prop TYPE=Battery
power_supply C1BF: 12 dynamic props
power_supply C1BF: prop STATUS=Full
power_supply C1BF: prop PRESENT=1
power_supply C1BF: prop TECHNOLOGY=Li-ion
power_supply C1BF: prop VOLTAGE_MIN_DESIGN=10800000
power_supply C1BF: prop VOLTAGE_NOW=12176000
power_supply C1BF: prop CURRENT_NOW=0
power_supply C1BF: prop CHARGE_FULL_DESIGN=4679000
power_supply C1BF: prop CHARGE_FULL=4679000
power_supply C1BF: prop CHARGE_NOW=4608000
power_supply C1BF: prop MODEL_NAME=Primary
power_supply C1BF: prop MANUFACTURER=Hewlett-Packard
power_supply C1BF: prop SERIAL_NUMBER=39279 2006/08/07
ACPI: Battery Slot [C1BE] (battery absent)
ACPI: WMI: Mapper loaded
Yenta: CardBus bridge found at 0000:02:04.0 [103c:30b0]
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 0x00001000-0x000010ff
  IO window: 0x00001400-0x000014ff
  PREFETCH window: 0x30400000-0x307fffff
  MEM window: 0x34000000-0x37ffffff
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.0, mfunc 0x01a11002, devctl 0x64
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 50, APIC ID 2, APIC INT 10
Yenta: ISA IRQ mask 0x0ef8, PCI irq 20
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge I/O window: 0x1000 - 0x1fff
pcmcia: parent PCI bridge Memory window: 0xd0000000 - 0xd02fffff
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 4192956k swap on /dev/sda2.  Priority:-1 extents:1 across:4192956k
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-50 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x13
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
powernow-k8: ph2 null fid transition 0x8
Clocksource tsc unstable (delta = -243799907 ns)
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.



           CPU0       CPU1       
  0:        227      11385   IO-APIC-edge      timer
  1:          1          7   IO-APIC-edge      i8042
 12:          1        147   IO-APIC-edge      i8042
 14:          0         55   IO-APIC-edge      ide0
 15:          0          0   IO-APIC-edge      ide1
 16:         29       2314   IO-APIC-fasteoi   sata_sil, HDA Intel
 19:          1         24   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20:          0          2   IO-APIC-fasteoi   ohci1394, yenta
 21:          0        143   IO-APIC-fasteoi   acpi
NMI:          0          0   Non-maskable interrupts
LOC:      11098       7456   Local timer interrupts
RES:       3796       2519   Rescheduling interrupts
CAL:         63         65   function call interrupts
TLB:        323        178   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26-rc6
# Mon Jun 16 19:22:07 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
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
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
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
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
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
CONFIG_OPROFILE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
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
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xffffc10000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_EC=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
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
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m

#
# QoS/HT support disabled
#

#
# QoS/HT support needs CONFIG_NET_SCHED
#

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
# CONFIG_IEEE80211_CRYPT_TKIP is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_BUILTIN_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ACER_WMI=m
CONFIG_ASUS_LAPTOP=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_MSI_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_INTEL_MENLOW=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_BLK_DEV_HD_ONLY is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=4000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=m
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=y

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
CONFIG_IEEE1394_RAWIO=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_E100_FIRMWARE is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000_NAPI is not set
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
CONFIG_E1000E=m
CONFIG_E1000E_ENABLED=y
# CONFIG_IP1000 is not set
CONFIG_IGB=m
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_IXGBE=m
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_SFC is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_IPW2100=m
# CONFIG_IPW2100_MONITOR is not set
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
# CONFIG_IPW2200_MONITOR is not set
# CONFIG_IPW2200_QOS is not set
# CONFIG_IPW2200_DEBUG is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
CONFIG_PRISM54=m
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLWIFI_RFKILL is not set
CONFIG_IWL4965=m
# CONFIG_IWL4965_LEDS is not set
# CONFIG_IWL4965_SPECTRUM_MEASUREMENT is not set
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWL5000 is not set
CONFIG_IWL3945=m
# CONFIG_IWL3945_SPECTRUM_MEASUREMENT is not set
# CONFIG_IWL3945_LEDS is not set
# CONFIG_IWL3945_DEBUG is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

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
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

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
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_PCA_PLATFORM is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ATIIXP=m
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
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
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
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
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=5
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
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
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_WUSB is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_GOTEMP is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
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
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_SUNRPC_BIND34 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACING=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_KERNEL_TESTS is not set
# CONFIG_NONPROMISC_DEVMEM is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_X86_MPPARSE=y
# CONFIG_IOMMU_DEBUG is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=m

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_MANAGER=m
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
