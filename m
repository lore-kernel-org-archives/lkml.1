Return-Path: <linux-kernel-owner+w=401wt.eu-S1766969AbXEBR5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766969AbXEBR5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767002AbXEBR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:57:38 -0400
Received: from outbound-mail-61.bluehost.com ([69.89.21.21]:53877 "HELO
	outbound-mail-61.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1766969AbXEBR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:57:34 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 2 May 2007 10:57:30 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705012227.31729.jbarnes@virtuousgeek.org> <4638A17C.40209@shaw.ca>
In-Reply-To: <4638A17C.40209@shaw.ca>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LENOGq6OOvLJNpF"
Message-Id: <200705021057.31393.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LENOGq6OOvLJNpF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday, May 2, 2007 7:34 am Robert Hancock wrote:
> Jesse Barnes wrote:
> > On Tuesday, May 01, 2007, Jesse Barnes wrote:
> >>> I'm testing it now on my 965...
> >>
> >> Bah... nevermind Robert, I see you're doing this already in
> >> pci_mmcfg_reject_broken.  I'm about to reboot & test now.
> >
> > Ok, I've tested a bit on my 965 (after re-adding my old patch to
> > support it) and the new checks are more complete, but my BIOS still
> > appears to be buggy.
> >
> > The extended config space (as defined by the register) is at
> > 0xf0000000 (full value is 0xf0000003 indicating 128M enabled).  The
> > ACPI MCFG table has this space reserved according to Robert's new
> > code, but the machine hangs due to the address space aliasing
> > Olivier mentioned awhile back.  I don't have a PCIe card to test
> > with (or any devices that require extended config space that I know
> > of) so I can't really tell if Windows supports PCIe on this
> > platform, but if it does I don't see how it would w/o having a full
> > bridge driver and sophisticated address space allocation builtin.
>
> Windows XP doesn't use MMCONFIG or any extended configuration space.
> I believe Vista is supposed to, though. Not sure how they are
> handling this issue.

Oh right... Vista will be the first to fully support PCIe & mcfg...

> Can you post what your board has for PNPACPI reserved resources (I
> believe they're in /sys/devices/pnp0/*/resources IIRC, don't have a
> Linux box handy right now). Full dmesg would also be useful, I think
> it dumps out those reservations at boot nowadays..

BIOS update didn't help.  Here's the boot log and a dump of the pnp0 
resources.

Jesse

--Boundary-00=_LENOGq6OOvLJNpF
Content-Type: text/plain;
  charset="iso-8859-1";
  name="pnp.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pnp.out"

state = active
io 0xcf8-0xcff
state = active
mem 0xf0000000-0xf7ffffff
mem 0xfed13000-0xfed13fff
mem 0xfed14000-0xfed17fff
mem 0xfed18000-0xfed18fff
state = active
io 0x0-0xf
io 0x81-0x83
io 0x87-0x87
io 0x89-0x8b
io 0x8f-0x8f
io 0xc0-0xdf
dma 4
state = active
io 0x70-0x71
io 0x74-0x77
irq 8
state = active
io 0xf0-0xf0
irq 13
state = active
io 0x61-0x61
state = active
io 0x500-0x53f
io 0x400-0x47f
io 0x92-0x92
io 0x680-0x6ff
io 0x10-0x1f
io 0x72-0x73
io 0x80-0x80
io 0x84-0x86
state = active
io 0x60-0x60
io 0x64-0x64
state = active
io 0x378-0x37f
io 0x778-0x77f
irq 7
state = active
io 0x3f8-0x3ff
irq 4
state = active
mem 0xfec00000-0xfec000ff
state = active
mem 0xfed00000-0xfed03fff

--Boundary-00=_LENOGq6OOvLJNpF
Content-Type: text/plain;
  charset="iso-8859-1";
  name="boot.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="boot.out"

Linux version 2.6.21-1.3116.fc7 (brewbuilder@hs20-bc2-3.build.redhat.com) (gcc version 4.1.2 20070424 (Red Hat 4.1.2-11)) #1 SMP Thu Apr 26 10:17:55 EDT 2007
Command line: ro root=LABEL=/ rhgb quiet selinux=0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bd643000 (usable)
 BIOS-e820: 00000000bd643000 - 00000000bd6c6000 (ACPI NVS)
 BIOS-e820: 00000000bd6c6000 - 00000000be5fb000 (usable)
 BIOS-e820: 00000000be5fb000 - 00000000be608000 (reserved)
 BIOS-e820: 00000000be608000 - 00000000be6a5000 (usable)
 BIOS-e820: 00000000be6a5000 - 00000000be6aa000 (ACPI data)
 BIOS-e820: 00000000be6aa000 - 00000000be6ab000 (usable)
 BIOS-e820: 00000000be6ab000 - 00000000be6f2000 (ACPI NVS)
 BIOS-e820: 00000000be6f2000 - 00000000be6ff000 (ACPI data)
 BIOS-e820: 00000000be6ff000 - 00000000be700000 (usable)
 BIOS-e820: 00000000be700000 - 00000000bf000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 143) 0 entries of 3200 used
Entering add_active_range(0, 256, 775747) 1 entries of 3200 used
Entering add_active_range(0, 775878, 779771) 2 entries of 3200 used
Entering add_active_range(0, 779784, 779941) 3 entries of 3200 used
Entering add_active_range(0, 779946, 779947) 4 entries of 3200 used
Entering add_active_range(0, 780031, 780032) 5 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT BE6FD038, 0050 (r1 INTEL  DG965OT       68C       1000013)
ACPI: FACP BE6FC000, 00F4 (r2 INTEL  DG965OT       68C MSFT  1000013)
ACPI: DSDT BE6F7000, 40E9 (r1 INTEL  DG965OT       68C MSFT  1000013)
ACPI: FACS BE6AB000, 0040
ACPI: APIC BE6F6000, 0078 (r1 INTEL  DG965OT       68C MSFT  1000013)
ACPI: WDDT BE6F5000, 0040 (r1 INTEL  DG965OT       68C MSFT  1000013)
ACPI: MCFG BE6F4000, 003C (r1 INTEL  DG965OT       68C MSFT  1000013)
ACPI: ASF! BE6F3000, 00A6 (r32 INTEL  DG965OT       68C MSFT  1000013)
ACPI: HPET BE6F2000, 0038 (r1 INTEL  DG965OT       68C MSFT  1000013)
ACPI: SSDT BE6A9000, 01BC (r1 INTEL     CpuPm      68C MSFT  1000013)
ACPI: SSDT BE6A8000, 0175 (r1 INTEL   Cpu0Ist      68C MSFT  1000013)
ACPI: SSDT BE6A7000, 0175 (r1 INTEL   Cpu1Ist      68C MSFT  1000013)
ACPI: SSDT BE6A6000, 0175 (r1 INTEL   Cpu2Ist      68C MSFT  1000013)
ACPI: SSDT BE6A5000, 0175 (r1 INTEL   Cpu3Ist      68C MSFT  1000013)
No NUMA configuration found
Faking a node at 0000000000000000-00000000be700000
Entering add_active_range(0, 0, 143) 0 entries of 3200 used
Entering add_active_range(0, 256, 775747) 1 entries of 3200 used
Entering add_active_range(0, 775878, 779771) 2 entries of 3200 used
Entering add_active_range(0, 779784, 779941) 3 entries of 3200 used
Entering add_active_range(0, 779946, 779947) 4 entries of 3200 used
Entering add_active_range(0, 780031, 780032) 5 entries of 3200 used
Bootmem setup node 0 0000000000000000-00000000be700000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[6] active PFN ranges
    0:        0 ->      143
    0:      256 ->   775747
    0:   775878 ->   779771
    0:   779784 ->   779941
    0:   779946 ->   779947
    0:   780031 ->   780032
On node 0 totalpages: 779686
  DMA zone: 88 pages used for memmap
  DMA zone: 2367 pages reserved
  DMA zone: 1528 pages, LIFO batch:0
  DMA32 zone: 16670 pages used for memmap
  DMA32 zone: 759033 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000008f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Nosave address range: 00000000bd643000 - 00000000bd6c6000
Nosave address range: 00000000be5fb000 - 00000000be608000
Nosave address range: 00000000be6a5000 - 00000000be6aa000
Nosave address range: 00000000be6ab000 - 00000000be6f2000
Nosave address range: 00000000be6f2000 - 00000000be6ff000
Allocating PCI resources starting at c0000000 (gap: bf000000:40f00000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 44672 bytes of per cpu data
Built 1 zonelists.  Total pages: 760561
Kernel command line: ro root=LABEL=/ rhgb quiet selinux=0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2397.602 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 3031908k/3120128k available (2465k kernel code, 86836k reserved, 1445k data, 332k init)
Calibrating delay using timer specific routine.. 4798.40 BogoMIPS (lpj=2399204)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
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
result 16649994
Detected 16.649 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4795.18 BogoMIPS (lpj=2397591)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
sizeof(vma)=176 bytes
sizeof(page)=88 bytes
sizeof(inode)=1008 bytes
sizeof(dentry)=248 bytes
sizeof(ext3inode)=1376 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=248 bytes
sizeof(task_struct)=3776 bytes
migration_cost=15
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:02.0
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
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
pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
pnp: 00:06: ioport range 0x500-0x53f has been reserved
pnp: 00:06: ioport range 0x400-0x47f has been reserved
pnp: 00:06: ioport range 0x680-0x6ff has been reserved
Time: tsc clocksource has been installed.
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: d0500000-d05fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 2000-2fff
  MEM window: d0100000-d01fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: d0600000-d06fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: d0700000-d07fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: d0800000-d08fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 1000-1fff
  MEM window: d0000000-d00fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3078k freed
audit: initializing netlink socket (disabled)
audit(1178092655.600:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
ksign: Installing public key data
Loading keyring
- Added public key A777C0AD109752E5
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 965G Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xc0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 332k freed
Write protecting the kernel read-only data: 1058k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030c0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000030a0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 3-2: new full speed USB device using uhci_hcd and address 2
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xd0421c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd0421800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
usb 3-2: device descriptor read/all, error -71
SCSI subsystem initialized
libata version 2.20 loaded.
ahci 0000:00:1f.2: version 2.1
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
usb 7-2: new high speed USB device using ehci_hcd and address 2
usb 7-2: configuration #1 chosen from 1 choice
hub 7-2:1.0: USB hub found
hub 7-2:1.0: 2 ports detected
usb 7-2.1: new high speed USB device using ehci_hcd and address 3
usb 7-2.1: configuration #1 chosen from 1 choice
hub 7-2.1:1.0: USB hub found
hub 7-2.1:1.0: 4 ports detected
usb 7-2.2: new low speed USB device using ehci_hcd and address 4
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xffffc2000002c100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata2: SATA max UDMA/133 cmd 0xffffc2000002c180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata3: SATA max UDMA/133 cmd 0xffffc2000002c200 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata4: SATA max UDMA/133 cmd 0xffffc2000002c280 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata5: SATA max UDMA/133 cmd 0xffffc2000002c300 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata6: SATA max UDMA/133 cmd 0xffffc2000002c380 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
scsi0 : ahci
usb 7-2.2: configuration #1 chosen from 1 choice
input: THRUSTMASTER FireStorm Dual Power as /class/input/input1
input: USB HID v1.10 Gamepad [THRUSTMASTER FireStorm Dual Power] on usb-0000:00:1d.7-2.2
usb 7-2.1.1: new high speed USB device using ehci_hcd and address 5
usb 7-2.1.1: configuration #1 chosen from 1 choice
libusual: modprobe for usb-storage succeeded, but module is not present
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD160JJ, WU100-33, max UDMA/100
ata1.00: 312581808 sectors, multi 0: LBA48 
ata1.00: configured for UDMA/100
scsi1 : ahci
usb 7-2.1.2: new low speed USB device using ehci_hcd and address 6
usb 7-2.1.2: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.7-2.1.2
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.7-2.1.2
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: SAMSUNG HD160JJ, WU100-33, max UDMA/100
ata2.00: 312581808 sectors, multi 0: LBA48 
ata2.00: configured for UDMA/100
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD160JJ  WU10 PQ: 0 ANSI: 5
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD160JJ  WU10 PQ: 0 ANSI: 5
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: Attached scsi disk sdb
Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     Generic  Flash HS-CF      4.44 PQ: 0 ANSI: 0
scsi 6:0:0:1: Direct-Access     Generic  Flash HS-COMBO   4.44 PQ: 0 ANSI: 0
sd 6:0:0:0: Attached scsi removable disk sdc
sd 6:0:0:1: Attached scsi removable disk sdd
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:1: Attached scsi generic sg3 type 0
iTCO_vendor_support: vendor-support=0
input: PC Speaker as /class/input/input4
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH8DH TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:76:c9:22:af
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 21 (level, low) -> IRQ 21
ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19
fw_ohci: Added fw-ohci device 0000:06:03.0, OHCI version 1.10
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:03 failed with error -16
gameport: EMU10K1 is pci0000:06:00.1/gameport0, io 0x1020, speed 1036kHz
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.0 to 64
ata7: PATA max UDMA/100 cmd 0x0000000000012018 ctl 0x0000000000012026 bmdma 0x0000000000012000 irq 17
scsi7 : pata_marvell
BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
ata7.00: ATAPI, max UDMA/33
fw_core: created new fw device fw0 (0 config rom retries)
ata7.00: configured for UDMA/33
scsi 7:0:0:0: CD-ROM            _NEC     DVD_RW ND-3550A  1.05 PQ: 0 ANSI: 5
scsi 7:0:0:0: Attached scsi generic sg4 type 5
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 7:0:0:0: Attached scsi CD-ROM sr0
floppy0: no floppy controllers found
lp0: using parport0 (interrupt-driven).
lp0: console ready
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
No dock devices found.
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ibm_acpi: ec object not found
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EXT3 FS on sdb1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.8)
Adding 2096472k swap on /dev/sdb2.  Priority:-1 extents:1 across:2096472k
e1000: eth0: e1000_request_irq: Unable to allocate MSI interrupt Error: -22
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
eth0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized i915 1.6.0 20060119 on minor 0

--Boundary-00=_LENOGq6OOvLJNpF--
