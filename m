Return-Path: <linux-kernel-owner+w=401wt.eu-S936201AbXLQMTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936201AbXLQMTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935792AbXLQMSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:18:36 -0500
Received: from wombat.diezmil.com ([209.190.27.106]:35225 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935658AbXLQMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:18:30 -0500
X-Greylist: delayed 2037 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 07:18:30 EST
Date: Mon, 17 Dec 2007 06:47:55 -0500
Message-ID: <6848169.1197892075666.JavaMail.root@wombat.diezmil.com>
From: shyam_iyer@dell.com
Reply-To: shyam_iyer@dell.com
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
In-Reply-To: <47463534.9010100@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am seeing that this doesn't fix a Dell PowerEdge T105 which has the CK804 chipset.

This system has a "HL-DT-ST" DVD-ROM (See dmesg with this posting) attached to the sata ports and has 8Gb physical memory.

The SATA DVD rom gets detected but any I/O like dd or mount is not successful.

If I reduce the memory with mem=<4Gb or disable the adma mode by passing adma=0, I am able to mount the media or do I/O.

Dmesg output -

Linux version 2.6.24-rc5-default (root@Pandora) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #2 SMP Thu Dec 13 15:38:25 IST 2007
Command line: root=/dev/disk/by-id/scsi-3600508e0000000003ad8e2c732a09d08-part3 vga=0x31a resume=/dev/sda2 splash=verbose showopts
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 0000000080000000 - 00000000cff00000 (usable)
 BIOS-e820: 00000000cff00000 - 00000000cff0a000 (ACPI data)
 BIOS-e820: 00000000cff0a000 - 00000000cff80000 (ACPI NVS)
 BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
Entering add_active_range(0, 524288, 851712) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 2293760) 3 entries of 3200 used
end_pfn_map = 2293760
DMI present.
ACPI: RSDP 000F7AE0, 0014 (r0 PTLTD )
ACPI: RSDT CFF064D5, 004C (r1 DELL   PE_SC3    6040000 DELL        0)
ACPI: FACP CFF09906, 0074 (r1 DELL   PE_SC3    6040000 DELL    F4240)
ACPI: DSDT CFF06521, 33E5 (r1 DELL   PE_SC3    6040000 MSFT  100000E)
ACPI: FACS CFF0AFC0, 0040
ACPI: TCPA CFF0997A, 0032 (r1 Phoeni  x        6040000  TL         0)
ACPI: SLIC CFF099AC, 0176 (r1 DELL   PE_SC3    6040000 PTL         1)
ACPI: SPCR CFF09B22, 0050 (r1 DELL   PE_SC3    6040000 PTL         1)
ACPI: SRAT CFF09B72, 00C8 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: SSDT CFF09C3A, 02CC (r1 AMD    POWERNOW  6040000 AMD         1)
ACPI: MCFG CFF09F06, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
ACPI: HPET CFF09F42, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: APIC CFF09F7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT CFF09FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 156) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-d0000000
Entering add_active_range(0, 0, 156) 1 entries of 3200 used
Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
Entering add_active_range(0, 524288, 851712) 2 entries of 3200 used
SRAT: Node 0 PXM 0 0-230000000
Entering add_active_range(0, 0, 156) 3 entries of 3200 used
Entering add_active_range(0, 256, 524272) 3 entries of 3200 used
Entering add_active_range(0, 524288, 851712) 3 entries of 3200 used
Entering add_active_range(0, 1048576, 2293760) 3 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000230000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2293760
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      156
    0:      256 ->   524272
    0:   524288 ->   851712
    0:  1048576 ->  2293760
On node 0 totalpages: 2096780
  DMA zone: 96 pages used for memmap
  DMA zone: 2540 pages reserved
  DMA zone: 1360 pages, LIFO batch:0
  DMA32 zone: 24480 pages used for memmap
  DMA32 zone: 823120 pages, LIFO batch:31
  Normal zone: 29184 pages used for memmap
  Normal zone: 1216000 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009c000 - 000000000009d000
swsusp: Registered nosave memory region: 000000000009d000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000cc000
swsusp: Registered nosave memory region: 00000000000cc000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007fff0000 - 0000000080000000
swsusp: Registered nosave memory region: 00000000cff00000 - 00000000cff0a000
swsusp: Registered nosave memory region: 00000000cff0a000 - 00000000cff80000
swsusp: Registered nosave memory region: 00000000cff80000 - 00000000d0000000
swsusp: Registered nosave memory region: 00000000d0000000 - 00000000e0000000
swsusp: Registered nosave memory region: 00000000e0000000 - 00000000f0000000
swsusp: Registered nosave memory region: 00000000f0000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fec10000
swsusp: Registered nosave memory region: 00000000fec10000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000fff80000
swsusp: Registered nosave memory region: 00000000fff80000 - 0000000100000000
Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 441112 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2040480
Policy zone: Normal
Kernel command line: root=/dev/disk/by-id/scsi-3600508e0000000003ad8e2c732a09d08-part3 vga=0x31a resume=/dev/sda2 splash=verbose showopts
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
hpet clockevent registered
TSC calibrated against HPET
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2812.958 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1712 kB
 per task-struct memory footprint: 2160 bytes
Checking aperture...
CPU 0: aperture @ 4000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 8091848k/9175040k available (2232k kernel code, 295272k reserved, 1390k data, 720k init)
Calibrating delay using timer specific routine.. 5629.62 BogoMIPS (lpj=11259258)
Security Framework initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 513 Objects with 62 Devices 170 Methods 25 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 8 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
APIC timer calibration result 12557856
Detected 12.557 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5625.95 BogoMIPS (lpj=11251909)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 1220 stepping 03
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000002
  domain 1: span 00000000,00000000,00000000,00000003
   groups: 00000000,00000000,00000000,00000003
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,00000001
  domain 1: span 00000000,00000000,00000000,00000003
   groups: 00000000,00000000,00000000,00000003
net_namespace: 152 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - e04fffff
PCI: No mmconfig possible on device 00:18
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 2 Wake, Enabled 2 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:................................................................
Initialized 20/25 Regions 2/2 Fields 26/26 Buffers 16/19 Packages (530 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 80 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
DMAR:No DMAR devices found
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:00: iomem range 0xfed00000-0xfed00fff has been reserved
system 00:02: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:03: ioport range 0x8000-0x807f has been reserved
system 00:03: ioport range 0x8080-0x80ff has been reserved
system 00:03: ioport range 0x8400-0x847f has been reserved
system 00:03: ioport range 0x8480-0x84ff has been reserved
system 00:03: ioport range 0x8800-0x887f has been reserved
system 00:03: ioport range 0x8880-0x88ff has been reserved
system 00:03: ioport range 0x1440-0x147f has been reserved
system 00:03: ioport range 0x1400-0x143f has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0xc00-0xc7f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: 2000-2fff
  MEM window: d0100000-d01fffff
  PREFETCH window: d8000000-dfffffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: d0200000-d02fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Failed to allocate mem resource #6:100000@d0400000 for 0000:04:00.0
PCI: Bridge: 0000:00:0d.0
  IO window: 3000-3fff
  MEM window: d0300000-d03fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 3019k freed
Simple Boot Flag at 0x62 set to 0x1
audit: initializing netlink socket (disabled)
audit(1197902862.548:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:01:08.0
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
AER service couldn't init device 0000:00:0b.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0c.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0d.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0e.0:pcie01 - no _OSC support
vesafb: framebuffer at 0xd8000000, mapped to 0xffffc20002000000, using 5120k, total 32768k
vesafb: mode is 1280x1024x16, linelength=2560, pages=11
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 1.1.18
ixgbe: Copyright (c) 1999-2007 Intel Corporation.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
Driver for 1-wire Dallas network protocol.
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
cpuidle: using governor ladder
cpuidle: using governor menu
NET: Registered protocol family 1
registered taskstats version 1
Freeing unused kernel memory: 720k freed
SCSI subsystem initialized
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SAS Host driver 3.04.06
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNK4] -> GSI 19 (level, low) -> IRQ 19
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1068E B2: Capabilities={Initiator}
PCI: Setting latency timer of device 0000:04:00.0 to 64
scsi0 : ioc0: LSISAS1068E B2, FwRev=00142d00h, Ports=1, MaxQ=511, IRQ=19
scsi 0:0:0:0: Direct-Access     SEAGATE  ST3300555SS      T107 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     SEAGATE  ST3300555SS      T107 PQ: 0 ANSI: 5
scsi 0:1:0:0: Direct-Access     Dell     VIRTUAL DISK     1028 PQ: 0 ANSI: 5
sd 0:1:0:0: [sda] 583983104 512-byte hardware sectors (298999 MB)
sd 0:1:0:0: [sda] Write Protect is off
sd 0:1:0:0: [sda] Mode Sense: 03 00 00 08
sd 0:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
scsi 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:1:0:0: [sda] 583983104 512-byte hardware sectors (298999 MB)
sd 0:1:0:0: [sda] Write Protect is off
sd 0:1:0:0: [sda] Mode Sense: 03 00 00 08
sd 0:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
scsi 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:1:0:0: [sda] Attached SCSI disk
sd 0:1:0:0: Attached scsi generic sg2 type 0
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: Using r5 hash to sort names
Adding 2104504k swap on /dev/disk/by-id/scsi-3600508e0000000003ad8e2c732a09d08-part2.  Priority:-1 extents:1 across:2104504k
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1440
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1400
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
Floppy drive(s): fd0 is 1.44M<6>ehci_hcd 0000:00:02.1: irq 23, io mem 0xd0001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected

tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNK2] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:02:00.0 to 64
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ffb00000-0x00000000ffffffff - kernel bug?
eth0: Tigon3 [partno(BCM95722) rev a200 PHY(5722/5756)] (PCI Express) 10/100/1000Base-T Ethernet 00:1d:09:02:ca:01
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
rtc_cmos: probe of 00:08 failed with error -16
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xd0000000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
Found: SST 49LF080A
ck804xrom @fff00000: Found 1 x8 devices at 0x0 in 8-bit bank
number of JEDEC chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
usb 2-6: new low speed USB device using ohci_hcd and address 2
usb 2-6: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Avocent USB_AMIQ as /devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.0/input/input1
input,hidraw0: USB HID v1.10 Keyboard [Avocent USB_AMIQ] on usb-0000:00:02.0-6
input: Avocent USB_AMIQ as /devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.1/input/input2
input,hidraw1: USB HID v1.10 Mouse [Avocent USB_AMIQ] on usb-0000:00:02.0-6
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
floppy0: no floppy controllers found
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
loop: module loaded
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
Floppy drive(s): fd0 is 1.44M
input: Power Button (FF) as /devices/virtual/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input4
floppy0: no floppy controllers found
ACPI: Power Button (CM) [PWRB]
audit(1197883126.367:2): audit_pid=3174 old=0 by auid=4294967295
powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 1220 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
Clocksource tsc unstable (delta = -70875418 ns)
libata: disagrees about version of symbol struct_module
libata version 3.00 loaded.
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi1 : sata_nv
scsi2 : sata_nv
ata1: SATA max UDMA/133 cmd 0x14f0 ctl 0x14e0 bmdma 0x14b0 irq 21
ata2: SATA max UDMA/133 cmd 0x14d0 ctl 0x14c0 bmdma 0x14b8 irq 21
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATAPI: HL-DT-STDVD-ROM GDRH10N, 0D04, max UDMA/100
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDRH10N  0D04 PQ: 0 ANSI: 5
ata1: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
sr0: scsi3-mmc drive: 0x/0x caddy
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg3 type 5
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 20 (level, low) -> IRQ 20
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi3 : sata_nv
scsi4 : sata_nv
ata3: SATA max UDMA/133 cmd 0x1840 ctl 0x1830 bmdma 0x1800 irq 20
ata4: SATA max UDMA/133 cmd 0x1820 ctl 0x1810 bmdma 0x1808 irq 20
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
Buffer I/O error on device sr0, logical block 154416
end_request: I/O error, dev sr0, sector 1235328
end_request: I/O error, dev sr0, sector 1235328
FAT: bogus number of reserved sectors
VFS: Can't find a valid FAT filesystem on dev sr0.
hfs: can't find a HFS filesystem on dev sr0.
MINIX-fs: blocksize too small for device
ReiserFS: sr0: warning: sh-2021: reiserfs_fill_super: can not find reiserfs on sr0
ISOFS: Unable to identify CD-ROM format.




--
This message was sent on behalf of shyam_iyer@dell.com at openSubscriber.com
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/8048235.html
