Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYEPMU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYEPMU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYEPMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:20:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:29089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYEPMUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=eyiawZ+2jvoOapFqoDydgyHCAwsyYoRfZeFJy0v6mTsD6RWxwMFQaLcGdD+iNVDMCWFzF8+Wjmwr0uIlQ4Mj1ny2UbxTQ6psJR2xocnIxfvyjshiab1EfAy/4ffhmDOVNMWAB+anCu6WBBs7B7UGi6cmWvdlqMLUN8R1WwDDYts=
Date: Fri, 16 May 2008 15:20:59 +0200
From: Jon Daniel <jopadan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PCI: Failed to allocate mem resource for ENE CB1410
Message-ID: <20080516132054.GA3110@exodus>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

System is a
Gigabyte K8NNXP-940 NFORCE3-150 Opteron 240
3Dfx Voodoo 5 PCI
ENE CB1410 cardbus bridge
orinoco_cs based WLAN PCMCIA card

latest tested kernel was 2.6.26-rc2.

At PCI bus initialization I get the following error:

PCI: Failed to allocate mem resource #9:4000000@f0000000 for 0000:01:08.0 return value -16
PCI: Failed to allocate mem resource #10:4000000@f8000000 for 0000:01:08.0 return value -16

The cause seems to be that find_resource returns -EBUSY=-16 in kernel/resource.c for these memory ranges.
I've added some debug output to the correspondening code for the log.
Later on another error is triggered by this one causing the WLAN PCMCIA card firmware initialization to fail.
somehow the parent bridge and the voodoo card seem to like these memory ranges too. I'll try an AGP graphics
card later. But I noticed these kind of errors seems to be fairly common.

Attached is a dmesg and lspci -v

Jon Daniel

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.25-gentoo-r1 (root@exodus) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #13 PREEMPT Fri May 16 14:35:28 CEST 2008
Command line: root=/dev/hda2 vga=ask 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 262128) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F6C00, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP 3FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT 3FFF30C0, 4B22 (r1 NVIDIA AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF7C00, 005A (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 262128) 1 entries of 256 used
early res: 0 [0-fff] BIOS data page
early res: 1 [200000-af5f87] TEXT DATA BSS
early res: 2 [9fc00-a0bff] EBDA
early res: 3 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262128
On node 0 totalpages: 262031
  DMA zone: 56 pages used for memmap
  DMA zone: 2300 pages reserved
  DMA zone: 1643 pages, LIFO batch:0
  DMA32 zone: 3527 pages used for memmap
  DMA32 zone: 254505 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256148
Kernel command line: root=/dev/hda2 vga=ask 
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 1396.395 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 132x60
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
Node 0: aperture @ e0000000 size 128 MB
Memory: 1022040k/1048512k available (5100k kernel code, 25448k reserved, 3075k data, 316k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 2793.75 BogoMIPS (lpj=1396878)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: AMD Opteron(tm) Processor 240 stepping 01
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12467815
Detected 12.467 MHz APIC timer.
net_namespace: 1000 bytes
xor: automatically using best checksumming function: generic_sse
   generic_sse:  4264.000 MB/sec
xor: using function: generic_sse (4264.000 MB/sec)
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs *16)
ACPI: PCI Interrupt Link [APC2] (IRQs *17)
ACPI: PCI Interrupt Link [APC3] (IRQs *18)
ACPI: PCI Interrupt Link [APC4] (IRQs *19), disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
ACPI: Power Resource [ISAV] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:parse DMAR table failure.
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
agpgart: AGP aperture is 128M @ 0xe0000000
ACPI: RTC can wake from S4
system 00:00: ioport range 0x1000-0x107f has been reserved
system 00:00: ioport range 0x1080-0x10ff has been reserved
system 00:00: ioport range 0x1400-0x147f has been reserved
system 00:00: ioport range 0x1480-0x14ff has been reserved
system 00:00: ioport range 0x1800-0x187f has been reserved
system 00:00: ioport range 0x1880-0x18ff has been reserved
system 00:01: iomem range 0xf0000-0xf3fff could not be reserved
system 00:01: iomem range 0xf4000-0xf7fff could not be reserved
system 00:01: iomem range 0xf8000-0xfbfff could not be reserved
system 00:01: iomem range 0xfc000-0xfffff could not be reserved
system 00:01: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:01: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:01: iomem range 0x0-0x9ffff could not be reserved
system 00:01: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:03: ioport range 0x4d0-0x4d1 has been reserved
system 00:03: ioport range 0x800-0x805 has been reserved
PCI: align 0x4000000 size 0x4000000 res->start 0x4000000
PCI: pci_bus_alloc_resource type_mask must match 0x00001300
PCI: pci_bus_alloc_resource type_mask must match 0x00001000
find_resource loop iter
find_resource: 0xe8000000-0xe7ffffff
find_resource loop iter
find_resource: 0xf0000000-0xefffffff
PCI: pci_bus_alloc_resource allocate_resource min=0x50000000 return value -16
PCI: pci_bus_alloc_resource type_mask must match 0x00001200
PCI: pci_bus_alloc_resource exact prefetching match return value: -16
PCI: pci_bus_alloc_resource type_mask must match 0x00000300
find_resource loop iter
find_resource: 0xf0000000-0xefffffff
find_resource loop iter
find_resource: 0xf4000000-0xf4ffffff
find_resource loop iter
find_resource: 0xf8000000-0xf5013fff
find_resource loop iter
find_resource: 0xf8000000-0xf7ffffff
PCI: pci_bus_alloc_resource allocate_resource min=0x50000000 return value -16
find_resource loop iter
find_resource: 0xe8000000-0xe7ffffff
find_resource loop iter
find_resource: 0xf0000000-0xefffffff
PCI: pci_bus_alloc_resource allocate_resource min=0x50000000 return value -16
PCI: pci_bus_alloc_resource type_mask must match 0x00000200
PCI: pci_bus_alloc_resource non-pretching window return value: -16
PCI: Failed to allocate mem resource #9:4000000@f0000000 for 0000:01:08.0 return value -16
PCI: align 0x4000000 size 0x4000000 res->start 0x4000000
PCI: pci_bus_alloc_resource type_mask must match 0x00000300
find_resource loop iter
find_resource: 0xf0000000-0xefffffff
find_resource loop iter
find_resource: 0xf4000000-0xf4ffffff
find_resource loop iter
find_resource: 0xf8000000-0xf5013fff
find_resource loop iter
find_resource: 0xf8000000-0xf7ffffff
PCI: pci_bus_alloc_resource allocate_resource min=0x50000000 return value -16
PCI: pci_bus_alloc_resource type_mask must match 0x00001000
PCI: pci_bus_alloc_resource type_mask must match 0x00000200
PCI: pci_bus_alloc_resource exact prefetching match return value: -16
PCI: Failed to allocate mem resource #10:4000000@f8000000 for 0000:01:08.0 return value -16
PCI: align 0x100 size 0x100 res->start 0x100
find_resource loop iter
find_resource: 0x00009000-0x00008fff
find_resource loop iter
find_resource: 0x00009400-0x0000afff
PCI: pci_bus_alloc_resource allocate_resource min=0x00001000 return value 0
PCI: pci_bus_alloc_resource exact prefetching match return value: 0
PCI: align 0x100 size 0x100 res->start 0x100
find_resource loop iter
find_resource: 0x00009000-0x00008fff
find_resource loop iter
find_resource: 0x00009400-0x000093ff
find_resource loop iter
find_resource: 0x00009800-0x0000afff
PCI: pci_bus_alloc_resource allocate_resource min=0x00001000 return value 0
PCI: pci_bus_alloc_resource exact prefetching match return value: 0
PCI: Bus 2, cardbus bridge: 0000:01:08.0
  IO window: 0x00009400-0x000094ff
  IO window: 0x00009800-0x000098ff
PCI: Bridge: 0000:00:0a.0
  IO window: 9000-afff
  MEM window: 0xf0000000-0xf7ffffff
  PREFETCH window: 0x00000000e8000000-0x00000000efffffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:0a.0 to 64
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
DLM (built May 15 2008 22:41:32) installed
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.9)
BeFS version: 0.9.3
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:06.0: Boot video device
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
ppdev: user-space parallel port driver
Linux agpgart interface v0.103
ipmi message handler version 39.1
ipmi device interface
IPMI System Interface driver.
ipmi_si: Unable to find any System Interface(s)
IPMI Watchdog: driver initialized
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: processor limited to max C-state 1
ACPI: ACPI0007:00 is registered as cooling_device0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
IT8712 SuperIO detected.
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
nbd: registered device at major 43
Fixed MDIO Bus: probed
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE3-150: 0000:00:08.0 (rev a5) UDMA133 controller
NFORCE3-150: IDE controller (0x10de:0x00d5 rev 0xa5) at  PCI slot 0000:00:08.0
NFORCE3-150: not 100% native mode: will probe irqs later
NFORCE3-150: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-150: BIOS didn't set cable bits correctly. Enabling workaround.
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: IBM-DJNA-351520, ATA DISK drive
Switched to high resolution mode on CPU 0
hdb: IBM-DJNA-352500, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hda: UDMA/33 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hdb: UDMA/33 mode selected
Probing IDE interface ide1...
hdc: Maxtor 91366U4, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 30033360 sectors (15377 MB) w/430KiB Cache, CHS=29795/16/63
hda: cache flushes not supported
 hda: hda1 hda2
hdb: max request size: 128KiB
hdb: 49981680 sectors (25590 MB) w/1966KiB Cache, CHS=49585/16/63
hdb: cache flushes not supported
 hdb: hdb1
hdc: max request size: 128KiB
hdc: 26684784 sectors (13662 MB) w/2048KiB Cache, CHS=26473/16/63
hdc: cache flushes not supported
 hdc: hdc1 hdc2 hdc3
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
Yenta: CardBus bridge found at 0000:01:08.0 [1524:1410]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:01:08.0, mfunc 0x00001002, devctl 0x44
Yenta: ISA IRQ mask 0x0000, PCI irq 16
Socket status: 30000010
Yenta: Upper limit for fixing this bridge's parent bridge: #02
pcmcia: parent PCI bridge I/O window: 0x9000 - 0xafff
pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf7ffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
input: PC Speaker as /class/input/input3
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
cs: memory probe 0xf0000000-0xf7ffffff: excluding 0xf0000000-0xf3ffffff 0xf5000000-0xf57fffff
PCI: pci_bus_alloc_resource type_mask must match 0x00000300
find_resource loop iter
find_resource: 0xf4000000-0xefffffff
find_resource loop iter
find_resource: 0xf4000000-0xf4ffffff
PCI: pci_bus_alloc_resource allocate_resource min=0x00100000 return value 0
pcmcia: registering new device pcmcia0.0
input: ImPS/2 Logitech Wheel Mouse as /class/input/input4
rtc_cmos: probe of 00:05 failed with error -16
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int64x1   1312 MB/s
raid6: int64x2   1726 MB/s
raid6: int64x4   1746 MB/s
raid6: int64x8   1460 MB/s
raid6: sse2x1    1777 MB/s
raid6: sse2x2    2398 MB/s
raid6: sse2x4    2585 MB/s
raid6: using algorithm sse2x4 (2585 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: faulty personality registered for level -5
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: multipath emc: version 0.0.3 loaded
device-mapper: multipath rdac: rdac: version 0.4 loaded
EDAC MC: Ver: 2.1.0 May 15 2008
NET: Registered protocol family 26
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.2
u32 classifier
    Performance counters on
    input device check on 
    Actions configured 
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
ctnetlink v0.93: registering with nfnetlink.
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
ClusterIP Version 0.8 loaded successfully
arp_tables: (C) 2002 David S. Miller
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP veno registered
TCP scalable registered
TCP lp registered
TCP yeah registered
TCP illinois registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
Mobile IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
ip6tnl0: Disabled Privacy Extensions
NET: Registered protocol family 17
NET: Registered protocol family 15
Bridge firewalling registered
Ebtables v2.0 registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
CCID: Registered CCID 3 (TCP-Friendly Rate Control)
CCID: Registered CCID 2 (TCP-like)
SCTP: Hash tables configured (established 65536 bind 65536)
TIPC: Activated (version 1.6.2 compiled May 15 2008 22:54:18)
NET: Registered protocol family 30
TIPC: Started in single node mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 316k freed
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2000
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
find_resource loop iter
find_resource: 0x00009000-0x00008fff
find_resource loop iter
find_resource: 0x00009100-0x000093ff
PCI: pci_bus_alloc_resource allocate_resource min=0x00000000 return value 0
pcmcia: request for exclusive IRQ could not be fulfilled.
pcmcia: the driver needs updating to supported shared IRQ lines.
eth0: failed to initialize firmware (err = -19)
orinoco_cs: register_netdev() failed
ath_hal: module license 'Proprietary' taints kernel.
ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
wlan: 0.9.4
ath_pci: no version for "ieee80211_encap" found: kernel tainted.
ath_pci: 0.9.4
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
ath_rate_sample: 1.2 (0.9.4)
wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: H/W encryption support: WEP AES AES_CCM TKIP
wifi0: mac 7.9 phy 4.5 radio 5.6
wifi0: Use hw queue 1 for WME_AC_BE traffic
wifi0: Use hw queue 0 for WME_AC_BK traffic
wifi0: Use hw queue 2 for WME_AC_VI traffic
wifi0: Use hw queue 3 for WME_AC_VO traffic
wifi0: Use hw queue 8 for CAB traffic
wifi0: Use hw queue 9 for beacons
wifi0: Atheros 5212: mem=0xf5000000, irq=17
EXT3 FS on hda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
pcmcia: Detected deprecated PCMCIA ioctl usage from process: cardmgr.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
find_resource loop iter
find_resource: 0x00009000-0x00008fff
find_resource loop iter
find_resource: 0x00009100-0x000093ff
PCI: pci_bus_alloc_resource allocate_resource min=0x00000000 return value 0
pcmcia: request for exclusive IRQ could not be fulfilled.
pcmcia: the driver needs updating to supported shared IRQ lines.
eth0: failed to initialize firmware (err = -19)
orinoco_cs: register_netdev() failed
Adding 996020k swap on /dev/hdc3.  Priority:-1 extents:1 across:996020k
ath0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:01:06.0 to 64
[drm] Initialized tdfx 1.0.0 20010216 on minor 0

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: nVidia Corporation nForce3 Host Bridge (rev a4)
	Flags: bus master, 66MHz, fast devsel, latency 0
	Memory at <ignored> (32-bit, prefetchable)
	Capabilities: [44] HyperTransport: Slave or Primary Interface
	Capabilities: [c0] AGP version 2.0
	Kernel driver in use: agpgart-amd64

00:01.0 ISA bridge: nVidia Corporation nForce3 LPC Bridge (rev a6)
	Subsystem: Giga-byte Technology Device 0c11
	Flags: bus master, 66MHz, fast devsel, latency 0

00:01.1 SMBus: nVidia Corporation nForce3 SMBus (rev a4)
	Subsystem: Giga-byte Technology Device 0c11
	Flags: 66MHz, fast devsel, IRQ 3
	I/O ports at 1c00 [size=64]
	I/O ports at 2000 [size=64]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:02.0 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 7
	Memory at f8003000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2

00:02.1 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 7
	Memory at f8004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2

00:02.2 USB Controller: nVidia Corporation nForce3 USB 2.0 (rev a2) (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 7
	Memory at f8000000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0080
	Capabilities: [80] Power Management version 2

00:08.0 IDE interface: nVidia Corporation nForce3 IDE (rev a5) (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device 5002
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: AMD_IDE

00:0a.0 PCI bridge: nVidia Corporation nForce3 PCI Bridge (rev a2) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=128
	I/O behind bridge: 00009000-0000afff
	Memory behind bridge: f0000000-f7ffffff
	Prefetchable memory behind bridge: e8000000-efffffff

00:0b.0 PCI bridge: nVidia Corporation nForce3 AGP Bridge (rev a4) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 16
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=10

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
	Capabilities: [c0] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel
	Kernel modules: k8temp

01:06.0 VGA compatible controller: 3Dfx Interactive, Inc. Voodoo 4 / Voodoo 5 (rev 01) (prog-if 00 [VGA controller])
	Subsystem: 3Dfx Interactive, Inc. Voodoo5 PCI 5500
	Flags: 66MHz, fast devsel, IRQ 18
	Memory at f0000000 (32-bit, non-prefetchable) [size=64M]
	Memory at e8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at 9000 [size=256]
	Capabilities: [60] Power Management version 2

01:08.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 01)
	Subsystem: ENE Technology Inc CB1410 Cardbus Controller
	Flags: bus master, medium devsel, latency 168, IRQ 16
	Memory at f5014000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: f5010000-f5011000 (prefetchable)
	Memory window 1: f5012000-f5013000
	I/O window 0: 00009400-000094ff
	I/O window 1: 00009800-000098ff
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

01:09.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
	Subsystem: Netgear Device 5a00
	Flags: bus master, medium devsel, latency 168, IRQ 17
	Memory at f5000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: ath_pci
	Kernel modules: ath5k, ath_pci


--xHFwDpU9dbj6ez1V--
