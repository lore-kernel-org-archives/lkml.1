Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbXIQTZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbXIQTZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbXIQTZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:25:19 -0400
Received: from outbound-mail-78.bluehost.com ([69.89.22.27]:57069 "HELO
	outbound-mail-78.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758046AbXIQTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:25:14 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Snook <csnook@redhat.com>
Subject: Re: Lossy interrupts on x86_64
Date: Mon, 17 Sep 2007 12:24:06 -0700
User-Agent: KMail/1.9.7
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <200709120833.15980.jbarnes@virtuousgeek.org> <46E93DDC.7090207@redhat.com>
In-Reply-To: <46E93DDC.7090207@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XRt7GZ4DPAPCrJA"
Message-Id: <200709171224.07016.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.88.206.99 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_XRt7GZ4DPAPCrJA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, September 13, 2007, Chris Snook wrote:
> Jesse Barnes wrote:
> > I just narrowed down a weird problem where I was losing more than
> > 50% of my vblank interrupts to what seems to be the hires timers
> > patch.  Stock 2.6.23-rc5 works fine, but the latest (171) kernel
> > from rawhide drops most of my interrupts unless I also have another
> > interrupt source running (e.g. if I hold down a key or move the
> > mouse I get the expected number of vblank interrupts, otherwise I
> > get between 3 and 30 instead of the expected 60 per second).
> >
> > Any ideas?  It seems like it might be bad APIC programming, but I
> > haven't gone through those mods to look for suspects...
>
> What happens if you boot with 'noapic' or 'pci=nomsi'?  Please post
> dmesg as well so we can see how the kernel is initializing the
> relevant hardware.

noapic gives me the same behavior as nohz=off and pci=nomsi doesn't seem 
to do anything (still get the same lossy interrupts behavior).

dmesg from stock booth (i.e. lossy problem) attached.

Jesse

--Boundary-00=_XRt7GZ4DPAPCrJA
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.23-0.171.rc5.git1.fc8 (kojibuilder@) (gcc version 4.1.2 20070821 (Red Hat 4.1.2-23)) #1 SMP Mon Sep 10 16:55:15 EDT 2007
Command line: ro root=/dev/VolGroup00/LogVol00 quiet selinux=0 rootflags=data=writeback
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
 BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d6000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007d6b0000 (usable)
 BIOS-e820: 000000007d6b0000 - 000000007d6cd000 (ACPI data)
 BIOS-e820: 000000007d6cd000 - 000000007d700000 (ACPI NVS)
 BIOS-e820: 000000007d700000 - 000000007e000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
Entering add_active_range(0, 256, 513712) 1 entries of 3200 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F68D0, 0024 (r2 LENOVO)
ACPI: XSDT 7D6BCA72, 0094 (r1 LENOVO TP-7L        1090  LTP        0)
ACPI: FACP 7D6BCC00, 00F4 (r3 LENOVO TP-7L        1090 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 7D6BD00C, FBEF (r1 LENOVO TP-7L        1090 MSFT  3000000)
ACPI: FACS 7D6E4000, 0040
ACPI: SSDT 7D6BCDB4, 0258 (r1 LENOVO TP-7L        1090 MSFT  3000000)
ACPI: ECDT 7D6CCBFB, 0052 (r1 LENOVO TP-7L        1090 LNVO        1)
ACPI: TCPA 7D6CCC4D, 0032 (r2 LENOVO TP-7L        1090 LNVO        1)
ACPI: APIC 7D6CCC7F, 0068 (r1 LENOVO TP-7L        1090 LNVO        1)
ACPI: MCFG 7D6CCCE7, 003C (r1 LENOVO TP-7L        1090 LNVO        1)
ACPI: HPET 7D6CCD23, 0038 (r1 LENOVO TP-7L        1090 LNVO        1)
ACPI: SLIC 7D6CCDF0, 0176 (r1 LENOVO TP-7L        1090  LTP        0)
ACPI: BOOT 7D6CCF66, 0028 (r1 LENOVO TP-7L        1090  LTP        1)
ACPI: ASF! 7D6CCF8E, 0072 (r16 LENOVO TP-7L        1090 PTL         1)
ACPI: SSDT 7D6E26D9, 025F (r1 LENOVO TP-7L        1090 INTL 20050513)
ACPI: SSDT 7D6E2938, 00A6 (r1 LENOVO TP-7L        1090 INTL 20050513)
ACPI: SSDT 7D6E29DE, 04F7 (r1 LENOVO TP-7L        1090 INTL 20050513)
ACPI: SSDT 7D6E2ED5, 01D8 (r1 LENOVO TP-7L        1090 INTL 20050513)
No NUMA configuration found
Faking a node at 0000000000000000-000000007d6b0000
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
Entering add_active_range(0, 256, 513712) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007d6b0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      153
    0:      256 ->   513712
On node 0 totalpages: 513609
  DMA zone: 96 pages used for memmap
  DMA zone: 2499 pages reserved
  DMA zone: 1398 pages, LIFO batch:0
  DMA32 zone: 11944 pages used for memmap
  DMA32 zone: 497672 pages, LIFO batch:31
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
swsusp: Registered nosave memory region: 0000000000099000 - 000000000009a000
swsusp: Registered nosave memory region: 000000000009a000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000d6000
swsusp: Registered nosave memory region: 00000000000d6000 - 00000000000d8000
swsusp: Registered nosave memory region: 00000000000d8000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7e000000:72000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 435856 bytes of per cpu data
Built 1 zonelists in Node order.  Total pages: 499070
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00 quiet selinux=0 rootflags=data=writeback
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
hpet clockevent registered
TSC calibrated against HPET
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1994.989 MHz processor.
Console: colour VGA+ 80x25
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
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 1990340k/2054848k available (2498k kernel code, 64096k reserved, 1441k data, 708k init)
SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 3995.68 BogoMIPS (lpj=1997844)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12468675
Detected 12.468 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3989.80 BogoMIPS (lpj=1994902)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
Brought up 2 CPUs
sizeof(vma)=176 bytes
sizeof(page)=96 bytes
sizeof(inode)=1088 bytes
sizeof(dentry)=256 bytes
sizeof(ext3inode)=1488 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=4448 bytes
khelper used greatest stack depth: 6336 bytes left
Time: 19:20:06  Date: 08/17/107
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at f0000000 - f3ffffff
khelper used greatest stack depth: 6256 bytes left
ACPI: EC: EC description table is found, configuring boot EC

ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
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
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff has been reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff has been reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff has been reserved
pnp: 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
pnp: 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
pnp: 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
pnp: 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: d8000000-dbdfffff
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-3fff
  MEM window: dc000000-df3fffff
  PREFETCH window: dfb00000-dfbfffff
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-4fff
  MEM window: fc000000-fdffffff
  PREFETCH window: f8000000-f80fffff
PCI: Bridge: 0000:00:1c.3
  IO window: 5000-5fff
  MEM window: d4000000-d5ffffff
  PREFETCH window: df800000-df8fffff
PCI: Bridge: 0000:00:1c.4
  IO window: 6000-6fff
  MEM window: d0000000-d1ffffff
  PREFETCH window: df500000-df5fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 00007000-000070ff
  IO window: 00007400-000074ff
  PREFETCH window: f4000000-f7ffffff
  MEM window: 80000000-83ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 7000-afff
  MEM window: f8300000-fbffffff
  PREFETCH window: f4000000-f7ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 12, 18874368 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3825k freed
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
audit(1190056805.834:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
ksign: Installing public key data
Loading keyring
- Added public key 23177331C14756CE
- User ID: Red Hat, Inc. (Kernel Module GPG key)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
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
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
Allocate Port Service[0000:00:1c.4:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: SSDT 7D6E1D72, 02C4 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 7D6E20BB, 061E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7D6E1CAA, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 7D6E2036, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (44 C)
ACPI: Thermal Zone [THM1] (44 C)
hpet_resources: 0xfed00000 is busy
Generic RTC Driver v1.07
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:20c6]
Yenta: ISA IRQ mask 0x0cb8, PCI irq 16
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
pcmcia: parent PCI bridge Memory window: 0xf8300000 - 0xfbffffff
pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xf7ffffff
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
  Magic number: 7:582:344
  hash matches device tty61
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 708k freed
Write protecting the kernel read-only data: 1040k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input2
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
insmod used greatest stack depth: 5272 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe226c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfe227000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
insmod used greatest stack depth: 5024 bytes left
SCSI subsystem initialized
libata version 2.21 loaded.
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: nr_ports (3) and implemented port map (0x1) don't match
usb 1-1: USB disconnect, address 2
usb 1-1: new full speed USB device using uhci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
usb 1-2: new full speed USB device using uhci_hcd and address 4
usb 1-2: configuration #1 chosen from 1 choice
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc2000036a100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 2298
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST910021AS, 4.06, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
insmod used greatest stack depth: 3560 bytes left
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input3
sd 0:0:0:0: Attached scsi generic sg0 type 0
thinkpad_acpi: ThinkPad ACPI Extras v0.15
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7LET39WW (1.09 ), EC 7KHT21WW-1.05
thinkpad_acpi: Lenovo ThinkPad T61
thinkpad_acpi: radio switch found; radios are enabled
input: ThinkPad Extra Buttons as /class/input/input4
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:15:58:84:a1:67
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input7
ACPI: Sleep Button (CM) [SLPB]
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
set_level status: 0
usbcore: registered new interface driver hci_usb
input: Video Bus as /class/input/input8
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
set_level status: 0
input: Video Bus as /class/input/input9
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi1 : ata_piix
scsi2 : ata_piix
ata2: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000011c00 irq 14
ata3: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000011c08 irq 15
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 0.1.8kd
iwl4965: Copyright(c) 2003-2007 Intel Corporation
ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U10N, 1.05, max UDMA/33
ata2.00: configured for UDMA/33
ata3: port disabled. ignoring.
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
scsi 1:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 23
ACPI: PCI Interrupt 0000:15:00.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:15:00.1 to 64
firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI version 1.10
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1b.0 to 64
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
wmaster0: Selected rate control algorithm 'iwl-4965-rs'
firewire_core: created new fw device fw0 (0 config rom retries, S400)
ACPI: ACPI Dock Station Driver 
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2031608k
floppy0: no floppy controllers found
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:11:21:82:d4:20
wlan0: RX authentication from 00:11:21:82:d4:20 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:11:21:82:d4:20
wlan0: RX AssocResp from 00:11:21:82:d4:20 (capab=0x421 status=0 aid=252)
wlan0: associated
wlan0: CTS protection enabled (BSSID=00:11:21:82:d4:20)
wlan0: switched to short barker preamble (BSSID=00:11:21:82:d4:20)
wlan0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 burst=0
wlan0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
wlan0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
wlan0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
wlan0: no IPv6 routers present
ADDRCONF(NETDEV_UP): eth0: link is not ready
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:11:21:82:d4:20
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:11:21:7d:5d:50
wlan0: RX authentication from 00:11:21:7d:5d:50 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:11:21:7d:5d:50
wlan0: RX AssocResp from 00:11:21:7d:5d:50 (capab=0x421 status=0 aid=229)
wlan0: associated
wlan0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 burst=0
wlan0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
wlan0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
wlan0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
wlan0: CTS protection disabled (BSSID=00:11:21:7d:5d:50)
wlan0: no IPv6 routers present
wlan0: CTS protection enabled (BSSID=00:11:21:7d:5d:50)
wlan0: CTS protection disabled (BSSID=00:11:21:7d:5d:50)
wlan0: CTS protection enabled (BSSID=00:11:21:7d:5d:50)

--Boundary-00=_XRt7GZ4DPAPCrJA--
