Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbXFVVtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbXFVVtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXFVVtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:49:07 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:55636 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332AbXFVVtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:49:02 -0400
Date: Fri, 22 Jun 2007 23:48:59 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA RAID5 speed drop of 100 MB/s
Message-ID: <20070622214859.GC6970@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
	Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4679B2DE.9090903@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The dmesg output of 33480a0ede8dcc7e6483054279008f972bd56fd3 (thus
"before") is:

==================================================================
Linux version 2.6.20-rc1-bisect-33480a0ede8dcc7e6483054279008f972bd56fd3-amd64 (carlo@hikaru) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Fri Jun 22 22:13:01 CEST 2007
Command line: root=/dev/md2 ro agp=off single
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
end_pfn_map = 1572864
DMI 2.4 present.
ACPI: RSDP (v002 ACPIAM                                ) @ 0x00000000000fae40
ACPI: XSDT (v001 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ 0x03000709 MSFT 0x00000097) @ 0x000000007ff90100
ACPI: FADT (v003 MSTEST OEMFACP  0x03000709 MSFT 0x00000097) @ 0x000000007ff90290
ACPI: MADT (v001 MSTEST OEMAPIC  0x03000709 MSFT 0x00000097) @ 0x000000007ff90390
ACPI: MCFG (v001 MSTEST OEMMCFG  0x03000709 MSFT 0x00000097) @ 0x000000007ff90400
ACPI: SLIC (v001 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ 0x03000709 MSFT 0x00000097) @ 0x000000007ff90440
ACPI: OEMB (v001 MSTEST AMI_OEM  0x03000709 MSFT 0x00000097) @ 0x000000007ff9e040
ACPI: HPET (v001 MSTEST OEMHPET  0x03000709 MSFT 0x00000097) @ 0x000000007ff99440
ACPI: DSDT (v001  A0483 A0483035 0x00000035 INTL 0x20060113) @ 0x0000000000000000
No NUMA configuration found
Faking a node at 0000000000000000-0000000180000000
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000180000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1572864
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   524176
    0:  1048576 ->  1572864
On node 0 totalpages: 1048366
  DMA zone: 56 pages used for memmap
  DMA zone: 972 pages reserved
  DMA zone: 2970 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505800 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009e000 - 000000000009f000
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Nosave address range: 000000007ff90000 - 000000007ff9e000
Nosave address range: 000000007ff9e000 - 000000007ffe0000
Nosave address range: 000000007ffe0000 - 0000000080000000
Nosave address range: 0000000080000000 - 00000000fee00000
Nosave address range: 00000000fee00000 - 00000000fee01000
Nosave address range: 00000000fee01000 - 00000000ffb00000
Nosave address range: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36992 bytes of per cpu data
Built 1 zonelists.  Total pages: 1025890
Kernel command line: root=/dev/md2 ro agp=off single
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
Calgary: Unable to locate Rio Grande Table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x1655000 - 0x5655000
Memory: 4024892k/6291456k available (1963k kernel code, 168572k reserved, 915k data, 284k init)
Calibrating delay using timer specific routine.. 5337.74 BogoMIPS (lpj=10675495)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
activating NMI Watchdog ... done.
Using local APIC timer interrupts.
result 16666709
Detected 16.666 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x2
Initializing CPU#1
Calibrating delay using timer specific routine.. 5333.48 BogoMIPS (lpj=10666969)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 5333.45 BogoMIPS (lpj=10666916)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 5333.46 BogoMIPS (lpj=10666938)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
Brought up 4 CPUs
testing NMI watchdog ... OK.
time.c: Using 14.318180 MHz WALL HPET GTOD HPET/TSC timer.
time.c: Detected 2666.674 MHz processor.
migration_cost=3268
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: ACPI device : hid PNP0A08
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0103
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid PNP0F03
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 15 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
PCI-GART: No AMD northbridge found.
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:01' and the driver 'system'
pnp: match found with the PnP device '00:07' and the driver 'system'
pnp: 00:07: ioport range 0x290-0x297 has been reserved
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: match found with the PnP device '00:0a' and the driver 'system'
pnp: match found with the PnP device '00:0d' and the driver 'system'
pnp: match found with the PnP device '00:0e' and the driver 'system'
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: f8800000-fe8fffff
  PREFETCH window: bfe00000-dfdfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.5
  IO window: b000-bfff
  MEM window: fe900000-fe9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: fea00000-feafffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 6214k freed
audit: initializing netlink socket (disabled)
audit(1182543644.524:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:06' and the driver 'serial'
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:0b' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0c' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: (supports S0 S1 S3 S4 S5)
Freeing unused kernel memory: 284k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU1PM] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU2PM] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU3PM] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU4PM] [20060707]
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 2.00 loaded.
ieee1394: Initialized config rom entry `ip1394'
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebff400
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
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
usb 4-2: new low speed USB device using uhci_hcd and address 2
ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> <6>ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 21 (level, low) -> IRQ 21
GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[feaff800-feafffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
usb 4-2: new low speed USB device using uhci_hcd and address 3
usb 4-2: configuration #1 chosen from 1 choice
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports ? Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ilck stag led pmp pio 
ata1: SATA max UDMA/133 cmd 0xFFFFC20000048900 ctl 0x0 bmdma 0x0 irq 1276
ata2: SATA max UDMA/133 cmd 0xFFFFC20000048980 ctl 0x0 bmdma 0x0 irq 1276
ata3: SATA max UDMA/133 cmd 0xFFFFC20000048A00 ctl 0x0 bmdma 0x0 irq 1276
ata4: SATA max UDMA/133 cmd 0xFFFFC20000048A80 ctl 0x0 bmdma 0x0 irq 1276
ata5: SATA max UDMA/133 cmd 0xFFFFC20000048B00 ctl 0x0 bmdma 0x0 irq 1276
ata6: SATA max UDMA/133 cmd 0xFFFFC20000048B80 ctl 0x0 bmdma 0x0 irq 1276
scsi0 : ahci
ata1: softreset failed (port busy but CLO unavailable)
ata1: softreset failed, retrying in 5 secs
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800011b7cd2]
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 0
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: softreset failed (port busy but CLO unavailable)
ata2: softreset failed, retrying in 5 secs
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 0
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 0/32)
ata3.00: ata3: dev 0 multi count 0
ata3.00: configured for UDMA/133
scsi3 : ahci
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7, max UDMA/133, 625142448 sectors: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi4 : ahci
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI, max UDMA/100
ata5.00: configured for UDMA/100
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW LH-20A1S   9L02 PQ: 0 ANSI: 5
SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>usbcore: registered new interface driver hiddev
 sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 >
sd 1:0:0:0: Attached scsi disk sdb
SCSI device sdc: 145226112 512-byte hdwr sectors (74356 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 145226112 512-byte hdwr sectors (74356 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4 <<6>input: Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A as /class/input/input1
input: USB HID v1.10 Mouse [Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A] on usb-0000:00:1d.1-2
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
 sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 >
sd 2:0:0:0: Attached scsi disk sdc
SCSI device sdd: 625142448 512-byte hdwr sectors (320073 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdd: 625142448 512-byte hdwr sectors (320073 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: Attached scsi disk sdd
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
sr 4:0:0:0: Attached scsi generic sg4 type 5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
pnp: the driver 'ide' has been registered
Probing IDE interface ide0...
Probing IDE interface ide1...
md: raid1 personality registered for level 1
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  9512.000 MB/sec
raid5: using function: generic_sse (9512.000 MB/sec)
raid6: int64x1   2500 MB/s
raid6: int64x2   3020 MB/s
raid6: int64x4   2878 MB/s
raid6: int64x8   1928 MB/s
raid6: sse2x1    4090 MB/s
raid6: sse2x2    5739 MB/s
raid6: sse2x4    7829 MB/s
raid6: using algorithm sse2x4 (7829 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: md0 stopped.
md: bind<sdb1>
md: bind<sdc1>
md: bind<sda1>
raid1: raid set md0 active with 3 out of 3 mirrors
md: md1 stopped.
md: bind<sdb2>
md: bind<sdc2>
md: bind<sda2>
raid5: device sda2 operational as raid disk 0
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: allocated 3212kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
md: md2 stopped.
md: bind<sdb3>
md: bind<sdc3>
md: bind<sda3>
raid5: device sda3 operational as raid disk 0
raid5: device sdc3 operational as raid disk 2
raid5: device sdb3 operational as raid disk 1
raid5: allocated 3212kB for md2
raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda3
 disk 1, o:1, dev:sdb3
 disk 2, o:1, dev:sdc3
md: md3 stopped.
md: bind<sdb5>
md: bind<sdc5>
md: bind<sda5>
raid5: device sda5 operational as raid disk 0
raid5: device sdc5 operational as raid disk 2
raid5: device sdb5 operational as raid disk 1
raid5: allocated 3212kB for md3
raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda5
 disk 1, o:1, dev:sdb5
 disk 2, o:1, dev:sdc5
md: md4 stopped.
md: bind<sdb6>
md: bind<sdc6>
md: bind<sda6>
raid5: device sda6 operational as raid disk 0
raid5: device sdc6 operational as raid disk 2
raid5: device sdb6 operational as raid disk 1
raid5: allocated 3212kB for md4
raid5: raid level 5 set md4 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda6
 disk 1, o:1, dev:sdb6
 disk 2, o:1, dev:sdc6
md: md5 stopped.
md: bind<sdb7>
md: bind<sdc7>
md: bind<sda7>
raid5: device sda7 operational as raid disk 0
raid5: device sdc7 operational as raid disk 2
raid5: device sdb7 operational as raid disk 1
raid5: allocated 3212kB for md5
raid5: raid level 5 set md5 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda7
 disk 1, o:1, dev:sdb7
 disk 2, o:1, dev:sdc7
md: md6 stopped.
md: bind<sdb8>
md: bind<sdc8>
md: bind<sda8>
raid5: device sda8 operational as raid disk 0
raid5: device sdc8 operational as raid disk 2
raid5: device sdb8 operational as raid disk 1
raid5: allocated 3212kB for md6
raid5: raid level 5 set md6 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda8
 disk 1, o:1, dev:sdb8
 disk 2, o:1, dev:sdc8
md: md7 stopped.
md: bind<sdb9>
md: bind<sdc9>
md: bind<sda9>
raid5: device sda9 operational as raid disk 0
raid5: device sdc9 operational as raid disk 2
raid5: device sdb9 operational as raid disk 1
raid5: allocated 3212kB for md7
raid5: raid level 5 set md7 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda9
 disk 1, o:1, dev:sdb9
 disk 2, o:1, dev:sdc9
md: md8 stopped.
md: bind<sdb10>
md: bind<sdc10>
md: bind<sda10>
raid5: device sda10 operational as raid disk 0
raid5: device sdc10 operational as raid disk 2
raid5: device sdb10 operational as raid disk 1
raid5: allocated 3212kB for md8
raid5: raid level 5 set md8 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda10
 disk 1, o:1, dev:sdb10
 disk 2, o:1, dev:sdc10
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
eth1394: eth0: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 v1.10 addr 0xfe9fc000 irq 17 Yukon-EC Ultra (0xb4) rev 2
sky2 eth1: addr 00:1a:92:3a:4a:c1
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (11-Nov-2006)
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: PC Speaker as /class/input/input2
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
gameport: EMU10K1 is pci0000:04:02.1/gameport0, io 0xcc00, speed 1042kHz
logips2pp: Detected unknown logitech mouse model 1
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 23 (level, low) -> IRQ 23
input: PS/2 Logitech Mouse as /class/input/input3
EXT3 FS on md2, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 15631096k swap on /dev/mapper/cswap.  Priority:1 extents:1 across:15631096k
sky2 eth1: enabling interface
sky2 eth1: ram buffer 0K
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
sky2 eth1: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
eth1: no IPv6 routers present
==================================================================

And the dmesg output of 551c012d7eea3dc5ec063c7ff9c718d39e77634f (thus
"after") is:

==================================================================
Linux version 2.6.20-rc1-bisect-551c012d7eea3dc5ec063c7ff9c718d39e77634f-amd64 (carlo@hikaru) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Fri Jun 22 21:24:33 CEST 2007
Command line: root=/dev/md2 ro agp=off single
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
end_pfn_map = 1572864
DMI 2.4 present.
ACPI: RSDP (v002 ACPIAM                                ) @ 0x00000000000fae40
ACPI: XSDT (v001 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ 0x03000709 MSFT 0x00000097) @ 0x000000007ff90100
ACPI: FADT (v003 MSTEST OEMFACP  0x03000709 MSFT 0x00000097) @ 0x000000007ff90290
ACPI: MADT (v001 MSTEST OEMAPIC  0x03000709 MSFT 0x00000097) @ 0x000000007ff90390
ACPI: MCFG (v001 MSTEST OEMMCFG  0x03000709 MSFT 0x00000097) @ 0x000000007ff90400
ACPI: SLIC (v001 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ 0x03000709 MSFT 0x00000097) @ 0x000000007ff90440
ACPI: OEMB (v001 MSTEST AMI_OEM  0x03000709 MSFT 0x00000097) @ 0x000000007ff9e040
ACPI: HPET (v001 MSTEST OEMHPET  0x03000709 MSFT 0x00000097) @ 0x000000007ff99440
ACPI: DSDT (v001  A0483 A0483035 0x00000035 INTL 0x20060113) @ 0x0000000000000000
No NUMA configuration found
Faking a node at 0000000000000000-0000000180000000
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000180000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1572864
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   524176
    0:  1048576 ->  1572864
On node 0 totalpages: 1048366
  DMA zone: 56 pages used for memmap
  DMA zone: 972 pages reserved
  DMA zone: 2970 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505800 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009e000 - 000000000009f000
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Nosave address range: 000000007ff90000 - 000000007ff9e000
Nosave address range: 000000007ff9e000 - 000000007ffe0000
Nosave address range: 000000007ffe0000 - 0000000080000000
Nosave address range: 0000000080000000 - 00000000fee00000
Nosave address range: 00000000fee00000 - 00000000fee01000
Nosave address range: 00000000fee01000 - 00000000ffb00000
Nosave address range: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36992 bytes of per cpu data
Built 1 zonelists.  Total pages: 1025890
Kernel command line: root=/dev/md2 ro agp=off single
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
Calgary: Unable to locate Rio Grande Table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x1655000 - 0x5655000
Memory: 4024892k/6291456k available (1963k kernel code, 168572k reserved, 915k data, 284k init)
Calibrating delay using timer specific routine.. 5337.76 BogoMIPS (lpj=10675530)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
activating NMI Watchdog ... done.
Using local APIC timer interrupts.
result 16666704
Detected 16.666 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x2
Initializing CPU#1
Calibrating delay using timer specific routine.. 5333.42 BogoMIPS (lpj=10666856)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 5333.49 BogoMIPS (lpj=10666989)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 5333.42 BogoMIPS (lpj=10666849)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
Brought up 4 CPUs
testing NMI watchdog ... OK.
time.c: Using 14.318180 MHz WALL HPET GTOD HPET/TSC timer.
time.c: Detected 2666.673 MHz processor.
migration_cost=3277
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: ACPI device : hid PNP0A08
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0103
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid PNP0F03
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 15 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
PCI-GART: No AMD northbridge found.
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:01' and the driver 'system'
pnp: match found with the PnP device '00:07' and the driver 'system'
pnp: 00:07: ioport range 0x290-0x297 has been reserved
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: match found with the PnP device '00:0a' and the driver 'system'
pnp: match found with the PnP device '00:0d' and the driver 'system'
pnp: match found with the PnP device '00:0e' and the driver 'system'
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: f8800000-fe8fffff
  PREFETCH window: bfe00000-dfdfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.5
  IO window: b000-bfff
  MEM window: fe900000-fe9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: fea00000-feafffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 6215k freed
audit: initializing netlink socket (disabled)
audit(1182543869.524:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:06' and the driver 'serial'
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:0b' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0c' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: (supports S0 S1 S3 S4 S5)
Freeing unused kernel memory: 284k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU1PM] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU2PM] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU3PM] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU4PM] [20060707]
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebff400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
SCSI subsystem initialized
libata version 2.00 loaded.
ieee1394: Initialized config rom entry `ip1394'
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
ata1: SATA max UDMA/133 cmd 0xFFFFC20000040900 ctl 0x0 bmdma 0x0 irq 1276
ata2: SATA max UDMA/133 cmd 0xFFFFC20000040980 ctl 0x0 bmdma 0x0 irq 1276
ata3: SATA max UDMA/133 cmd 0xFFFFC20000040A00 ctl 0x0 bmdma 0x0 irq 1276
ata4: SATA max UDMA/133 cmd 0xFFFFC20000040A80 ctl 0x0 bmdma 0x0 irq 1276
ata5: SATA max UDMA/133 cmd 0xFFFFC20000040B00 ctl 0x0 bmdma 0x0 irq 1276
ata6: SATA max UDMA/133 cmd 0xFFFFC20000040B80 ctl 0x0 bmdma 0x0 irq 1276
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 0
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 31/32)
ata2.00: ata2: dev 0 multi count 0
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 145226112 sectors: LBA48 NCQ (depth 31/32)
ata3.00: ata3: dev 0 multi count 0
ata3.00: configured for UDMA/133
scsi3 : ahci
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7, max UDMA/133, 625142448 sectors: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi4 : ahci
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI, max UDMA/100
ata5.00: configured for UDMA/100
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW LH-20A1S   9L02 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Attached scsi generic sg3 type 0
sr 4:0:0:0: Attached scsi generic sg4 type 5
 sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9<6>ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
 sdb10 >
sd 1:0:0:0: Attached scsi disk sdb
SCSI device sdc: 145226112 512-byte hdwr sectors (74356 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 145226112 512-byte hdwr sectors (74356 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 >
sd 2:0:0:0: Attached scsi disk sdc
SCSI device sdd: 625142448 512-byte hdwr sectors (320073 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdd: 625142448 512-byte hdwr sectors (320073 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: Attached scsi disk sdd
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 21 (level, low) -> IRQ 21
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[feaff800-feafffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
usb 6-2: new low speed USB device using uhci_hcd and address 2
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
pnp: the driver 'ide' has been registered
Probing IDE interface ide0...
usb 6-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A as /class/input/input1
input: USB HID v1.10 Mouse [Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A] on usb-0000:00:1d.1-2
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Probing IDE interface ide1...
md: raid1 personality registered for level 1
raid5: automatically using best checksumming function: generic_sse
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800011b7cd2]
   generic_sse:  9534.000 MB/sec
raid5: using function: generic_sse (9534.000 MB/sec)
raid6: int64x1   2495 MB/s
raid6: int64x2   3017 MB/s
raid6: int64x4   2870 MB/s
raid6: int64x8   1921 MB/s
raid6: sse2x1    4083 MB/s
raid6: sse2x2    5273 MB/s
raid6: sse2x4    7806 MB/s
raid6: using algorithm sse2x4 (7806 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: md0 stopped.
md: bind<sdb1>
md: bind<sdc1>
md: bind<sda1>
raid1: raid set md0 active with 3 out of 3 mirrors
md: md1 stopped.
md: bind<sdb2>
md: bind<sdc2>
md: bind<sda2>
raid5: device sda2 operational as raid disk 0
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: allocated 3212kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
md: md2 stopped.
md: bind<sdb3>
md: bind<sdc3>
md: bind<sda3>
raid5: device sda3 operational as raid disk 0
raid5: device sdc3 operational as raid disk 2
raid5: device sdb3 operational as raid disk 1
raid5: allocated 3212kB for md2
raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda3
 disk 1, o:1, dev:sdb3
 disk 2, o:1, dev:sdc3
md: md3 stopped.
md: bind<sdb5>
md: bind<sdc5>
md: bind<sda5>
raid5: device sda5 operational as raid disk 0
raid5: device sdc5 operational as raid disk 2
raid5: device sdb5 operational as raid disk 1
raid5: allocated 3212kB for md3
raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda5
 disk 1, o:1, dev:sdb5
 disk 2, o:1, dev:sdc5
md: md4 stopped.
md: bind<sdb6>
md: bind<sdc6>
md: bind<sda6>
raid5: device sda6 operational as raid disk 0
raid5: device sdc6 operational as raid disk 2
raid5: device sdb6 operational as raid disk 1
raid5: allocated 3212kB for md4
raid5: raid level 5 set md4 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda6
 disk 1, o:1, dev:sdb6
 disk 2, o:1, dev:sdc6
md: md5 stopped.
md: bind<sdb7>
md: bind<sdc7>
md: bind<sda7>
raid5: device sda7 operational as raid disk 0
raid5: device sdc7 operational as raid disk 2
raid5: device sdb7 operational as raid disk 1
raid5: allocated 3212kB for md5
raid5: raid level 5 set md5 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda7
 disk 1, o:1, dev:sdb7
 disk 2, o:1, dev:sdc7
md: md6 stopped.
md: bind<sdb8>
md: bind<sdc8>
md: bind<sda8>
raid5: device sda8 operational as raid disk 0
raid5: device sdc8 operational as raid disk 2
raid5: device sdb8 operational as raid disk 1
raid5: allocated 3212kB for md6
raid5: raid level 5 set md6 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda8
 disk 1, o:1, dev:sdb8
 disk 2, o:1, dev:sdc8
md: md7 stopped.
md: bind<sdb9>
md: bind<sdc9>
md: bind<sda9>
raid5: device sda9 operational as raid disk 0
raid5: device sdc9 operational as raid disk 2
raid5: device sdb9 operational as raid disk 1
raid5: allocated 3212kB for md7
raid5: raid level 5 set md7 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda9
 disk 1, o:1, dev:sdb9
 disk 2, o:1, dev:sdc9
md: md8 stopped.
md: bind<sdb10>
md: bind<sdc10>
md: bind<sda10>
raid5: device sda10 operational as raid disk 0
raid5: device sdc10 operational as raid disk 2
raid5: device sdb10 operational as raid disk 1
raid5: allocated 3212kB for md8
raid5: raid level 5 set md8 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda10
 disk 1, o:1, dev:sdb10
 disk 2, o:1, dev:sdc10
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
eth1394: eth0: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
input: PC Speaker as /class/input/input2
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 v1.10 addr 0xfe9fc000 irq 17 Yukon-EC Ultra (0xb4) rev 2
sky2 eth1: addr 00:1a:92:3a:4a:c1
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (11-Nov-2006)
gameport: EMU10K1 is pci0000:04:02.1/gameport0, io 0xcc00, speed 1042kHz
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 23 (level, low) -> IRQ 23
logips2pp: Detected unknown logitech mouse model 1
input: PS/2 Logitech Mouse as /class/input/input3
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
EXT3 FS on md2, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 15631096k swap on /dev/mapper/cswap.  Priority:1 extents:1 across:15631096k
sky2 eth1: enabling interface
sky2 eth1: ram buffer 0K
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
sky2 eth1: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
eth1: no IPv6 routers present
==================================================================

-- 
Carlo Wood <carlo@alinoe.com>
