Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbXGERrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbXGERrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbXGERrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:47:40 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:43179 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbXGERrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:47:37 -0400
To: stern@rowland.harvard.edu
CC: paulus@samba.org, miklos@szeredi.hu, rjw@sisk.pl, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.44L0.0707051023520.3728-100000@iolanthe.rowland.org>
	(message from Alan Stern on Thu, 5 Jul 2007 10:25:06 -0400 (EDT))
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
References: <Pine.LNX.4.44L0.0707051023520.3728-100000@iolanthe.rowland.org>
Message-Id: <E1I6VLD-0001Ks-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 19:42:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Alan Stern writes:
> > 
> > > Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> > > wanting to resume devices during a system suspend transition?  This is
> > > exactly what happens when those threads aren't frozen.
> > 
> > So, I wonder why I don't see that error on my powerbook?
> 
> That's a good question.  Miklos, can you please reproduce the suspend 
> error using a kernel built with CONFIG_USB_DEBUG turned on?

Here's the full dmesg.  First there was a successful suspend/resume,
then a couple of unsuccessful ones:

Linux version 2.6.22-rc6 (mszeredi@tucsk) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #19 SMP Thu Jul 5 18:07:34 CEST 2007
Command line: vga=775 root=/dev/sda2
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fed0000 (usable)
 BIOS-e820: 000000003fed0000 - 000000003fedf000 (ACPI data)
 BIOS-e820: 000000003fedf000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 261840) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F67D0, 0024 (r2 LENOVO)
ACPI: XSDT 3FED1308, 008C (r1 LENOVO TP-79        2110  LTP        0)
ACPI: FACP 3FED1400, 00F4 (r3 LENOVO TP-79        2110 LNVO        1)
ACPI Warning (tbfadt-0434): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 3FED175E, D481 (r1 LENOVO TP-79        2110 MSFT  100000E)
ACPI: FACS 3FEF4000, 0040
ACPI: SSDT 3FED15B4, 01AA (r1 LENOVO TP-79        2110 MSFT  100000E)
ACPI: ECDT 3FEDEBDF, 0052 (r1 LENOVO TP-79        2110 LNVO        1)
ACPI: TCPA 3FEDEC31, 0032 (r2 LENOVO TP-79        2110 LNVO        1)
ACPI: APIC 3FEDEC63, 0068 (r1 LENOVO TP-79        2110 LNVO        1)
ACPI: MCFG 3FEDECCB, 003C (r1 LENOVO TP-79        2110 LNVO        1)
ACPI: HPET 3FEDED07, 0038 (r1 LENOVO TP-79        2110 LNVO        1)
ACPI: SLIC 3FEDEE62, 0176 (r1 LENOVO TP-79        2110  LTP        0)
ACPI: BOOT 3FEDEFD8, 0028 (r1 LENOVO TP-79        2110  LTP        1)
ACPI: SSDT 3FEF2655, 025F (r1 LENOVO TP-79        2110 INTL 20050513)
ACPI: SSDT 3FEF28B4, 00A6 (r1 LENOVO TP-79        2110 INTL 20050513)
ACPI: SSDT 3FEF295A, 04F7 (r1 LENOVO TP-79        2110 INTL 20050513)
ACPI: SSDT 3FEF2E51, 01D8 (r1 LENOVO TP-79        2110 INTL 20050513)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 261840) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   261840
On node 0 totalpages: 261743
  DMA zone: 56 pages used for memmap
  DMA zone: 1144 pages reserved
  DMA zone: 2799 pages, LIFO batch:0
  DMA32 zone: 3523 pages used for memmap
  DMA32 zone: 254221 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
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
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000d2000
swsusp: Registered nosave memory region: 00000000000d2000 - 00000000000d4000
swsusp: Registered nosave memory region: 00000000000d4000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 32616 bytes of per cpu data
Built 1 zonelists.  Total pages: 257020
Kernel command line: vga=775 root=/dev/sda2
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1828.744 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
Memory: 1026200k/1047360k available (2316k kernel code, 20600k reserved, 1434k data, 188k init)
Calibrating delay using timer specific routine.. 3661.49 BogoMIPS (lpj=7322983)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 10390586
Detected 10.390 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.60 BogoMIPS (lpj=7315219)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Brought up 2 CPUs
migration_cost=39
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
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
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff has been reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff has been reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff has been reserved
pnp: 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
pnp: 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
pnp: 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
pnp: 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: ee100000-ee1fffff
  PREFETCH window: d8000000-dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: 3000-3fff
  MEM window: ee000000-ee0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 4000-5fff
  MEM window: ec000000-edffffff
  PREFETCH window: e4000000-e40fffff
PCI: Bridge: 0000:00:1c.2
  IO window: 6000-7fff
  MEM window: e8000000-e9ffffff
  PREFETCH window: e4100000-e41fffff
PCI: Bridge: 0000:00:1c.3
  IO window: 8000-9fff
  MEM window: ea000000-ebffffff
  PREFETCH window: e4200000-e42fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 0000a000-0000a0ff
  IO window: 0000a400-0000a4ff
  PREFETCH window: e0000000-e3ffffff
  MEM window: 50000000-53ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: a000-dfff
  MEM window: e4300000-e7ffffff
  PREFETCH window: e0000000-e3ffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
Time: hpet clocksource has been installed.
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x35 set to 0x1
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.3: Performing full reset
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
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
vesafb: framebuffer at 0xd8000000, mapped to 0xffffc20000080000, using 2560k, total 16384k
vesafb: mode is 1280x1024x8, linelength=1280, pages=11
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery absent)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 3FEF1D36, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 3FEF1FFB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3FEF1C6E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 3FEF1F76, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (40 C)
ACPI: Thermal Zone [THM1] (41 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
loop: module loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.14
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad EC firmware 79HT50WW-1.07
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH7: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
ICH7: chipset revision 2
ICH7: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1880-0x1887, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
hda: MATSHITADVD-RAM UJ-842, ATAPI CD/DVD-ROM drive
hda: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ahci 0000:00:1f.2: version 2.2
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc2000003a500 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata2: SATA max UDMA/133 cmd 0xffffc2000003a580 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata3: SATA max UDMA/133 cmd 0xffffc2000003a600 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata4: SATA max UDMA/133 cmd 0xffffc2000003a680 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: ATA-7: HTS541080G9SA00, MB4IC60R, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      HTS541080G9SA00  MB4I PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
usbmon: debugfs is not available
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee404000
ehci_hcd 0000:00:1d.7: reset command 080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc6 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
USB Universal Host Controller Interface driver v3.0
hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
usb usb2: default language 0x0409
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc6 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
usb usb3: default language 0x0409
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc6 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 8, status 0501, change 0001, 480 Mb/s
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
usb usb4: default language 0x0409
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.22-rc6 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 1-0:1.0: debounce: port 8: total 100ms stable 100ms status 0x501
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 8 not reset yet, waiting 50ms
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.0: port 1 portsc 01ab,00
hub 2-0:1.0: port 1, status 0301, change 0003, 1.5 Mb/s
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
usb usb5: default language 0x0409
usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.22-rc6 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: skipped 1 descriptor after interface
usb 2-1: default language 0x0409
usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: Basic Optical Mouse
usb 2-1: Manufacturer: Microsoft
usb 2-1: uevent
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
usb 2-1:1.0: uevent
usb 2-1:1.0: uevent
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.3: port 2 portsc 009b,00
hub 5-0:1.0: port 2, status 0101, change 0003, 12 Mb/s
hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 5-2: new full speed USB device using uhci_hcd and address 2
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
usb 5-2: ep0 maxpacket = 8
input: SynPS/2 Synaptics TouchPad as /class/input/input4
usb 5-2: default language 0x0409
usb 5-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
usb usb3: suspend_rh (auto-stop)
usb 5-2: uevent
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
usb 5-2:1.0: uevent
usb 5-2:1.0: uevent
usbhid 2-1:1.0: usb_probe_interface
usbhid 2-1:1.0: usb_probe_interface - got id
input: Microsoft Basic Optical Mouse as /class/input/input5
input: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1d.0-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1b.0 to 64
usb usb4: suspend_rh (auto-stop)
ALSA device list:
  #0: HDA Intel at 0xee400000 irq 17
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4091 buckets, 32728 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input6
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 188k freed
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
usb 2-1: uevent
usb 2-1:1.0: uevent
usb 2-1:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb 5-0:1.0: uevent
usb 5-2: uevent
usb 5-2:1.0: uevent
usb 5-2:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
e1000: 0000:02:00.0: e1000_validate_option: Receive Interrupt Delay set to 32
e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:41:e3:2c:76
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Adding 1542196k swap on /dev/sda1.  Priority:-1 extents:1 across:1542196k
EXT3 FS on sda2, internal journal
fuse init (API version 7.8)
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 8, phase 4, 93 us
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 8, phase 4, 93 us
Suspending console(s)
hub 5-0:1.0: hub_suspend
usb usb5: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: suspend_rh
hub 2-0:1.0: hub_suspend
usb usb2: suspend_rh
hub 1-0:1.0: hub_suspend
ehci_hcd 0000:00:1d.7: suspend root hub
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI: PCI interrupt for device 0000:02:00.0 disabled
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ehci_hcd 0000:00:1d.7: --> PCI D3/wakeup
uhci_hcd 0000:00:1d.3: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
uhci_hcd 0000:00:1d.3: --> PCI D0/legacy
uhci_hcd 0000:00:1d.2: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
uhci_hcd 0000:00:1d.2: --> PCI D0/legacy
uhci_hcd 0000:00:1d.1: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
uhci_hcd 0000:00:1d.1: --> PCI D0/legacy
uhci_hcd 0000:00:1d.0: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
uhci_hcd 0000:00:1d.0: --> PCI D0/legacy
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
Extended CMOS year: 2000
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.62 BogoMIPS (lpj=7315250)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
CPU1 is up
PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 20002020, writing 2020)
PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
PCI: Setting latency timer of device 0000:00:01.0 to 64
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 180107, writing 100507)
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PM: Writing back config space on device 0000:00:1c.2 at offset 7 (was 20007060, writing 7060)
PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PM: Writing back config space on device 0000:00:1c.3 at offset f (was 40400, writing 4040b)
PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001, writing e421e421)
PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, writing ebf0ea00)
PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 20000000, writing 9080)
PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 810000, writing 810010)
PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100000, writing 100507)
PCI: Setting latency timer of device 0000:00:1c.3 to 64
uhci_hcd 0000:00:1d.0: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: uhci_resume
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f00
uhci_hcd 0000:00:1d.0: Performing full reset
usb usb2: root hub lost power or was reset
usb usb2: suspend_rh
hub 2-0:1.0: hub_resume
usb usb2: wakeup_rh
uhci_hcd 0000:00:1d.1: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: uhci_resume
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
uhci_hcd 0000:00:1d.1: Performing full reset
usb usb3: root hub lost power or was reset
usb usb3: suspend_rh
uhci_hcd 0000:00:1d.2: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: uhci_resume
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
uhci_hcd 0000:00:1d.2: Performing full reset
usb usb4: root hub lost power or was reset
usb usb4: suspend_rh
uhci_hcd 0000:00:1d.3: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: uhci_resume
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
uhci_hcd 0000:00:1d.3: Performing full reset
usb usb5: root hub lost power or was reset
usb usb5: suspend_rh
ehci_hcd 0000:00:1d.7: PCI D0, from previous PCI D3
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
PCI: Setting latency timer of device 0000:00:1f.2 to 64
hub 5-0:1.0: hub_resume
usb usb5: wakeup_rh
hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
uhci_hcd 0000:00:1d.0: port 1 portsc 008a,00
hub 2-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
usb 2-1: USB disconnect, address 2
usb 2-1: unregistering device
usb 2-1: usb_disable_device nuking all URBs
usb 2-1: unregistering interface 2-1:1.0
usb_endpoint usbdev2.2_ep81: ep_device_release called for usbdev2.2_ep81
usb 2-1:1.0: uevent
usb 2-1:1.0: uevent
usb_endpoint usbdev2.2_ep00: ep_device_release called for usbdev2.2_ep00
usb 2-1: uevent
hub 1-0:1.0: hub_resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0004
uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
hub 5-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
usb 5-2: USB disconnect, address 2
usb 5-2: unregistering device
usb 5-2: usb_disable_device nuking all URBs
usb 5-2: unregistering interface 5-2:1.0
usb_endpoint usbdev5.2_ep81: ep_device_release called for usbdev5.2_ep81
usb_endpoint usbdev5.2_ep02: ep_device_release called for usbdev5.2_ep02
usb_endpoint usbdev5.2_ep83: ep_device_release called for usbdev5.2_ep83
usb 5-2:1.0: uevent
usb 5-2:1.0: uevent
usb_endpoint usbdev5.2_ep00: ep_device_release called for usbdev5.2_ep00
usb 5-2: uevent
hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0102
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 8, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 8: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 8 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
hub 2-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb 2-1: new low speed USB device using uhci_hcd and address 3
PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100107, writing 100507)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
PM: Writing back config space on device 0000:15:00.0 at offset f (was 34001ff, writing 3c0010b)
PM: Writing back config space on device 0000:15:00.0 at offset e (was 0, writing a4fc)
PM: Writing back config space on device 0000:15:00.0 at offset d (was 0, writing a400)
PM: Writing back config space on device 0000:15:00.0 at offset c (was 0, writing a0fc)
PM: Writing back config space on device 0000:15:00.0 at offset b (was 0, writing a000)
PM: Writing back config space on device 0000:15:00.0 at offset a (was 0, writing 53fff000)
PM: Writing back config space on device 0000:15:00.0 at offset 9 (was 0, writing 50000000)
PM: Writing back config space on device 0000:15:00.0 at offset 8 (was 0, writing e3fff000)
PM: Writing back config space on device 0000:15:00.0 at offset 7 (was 0, writing e0000000)
PM: Writing back config space on device 0000:15:00.0 at offset 6 (was 0, writing b0171615)
PM: Writing back config space on device 0000:15:00.0 at offset 4 (was 0, writing e4300000)
PM: Writing back config space on device 0000:15:00.0 at offset 3 (was 20000, writing 2a808)
PM: Writing back config space on device 0000:15:00.0 at offset 1 (was 2100000, writing 2100007)
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 16
usb 2-1: skipped 1 descriptor after interface
hda: selected mode 0x42
usb 2-1: default language 0x0409
sd 0:0:0:0: [sda] Starting disk
usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: Basic Optical Mouse
usb 2-1: Manufacturer: Microsoft
usb 2-1: uevent
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
usb 2-1:1.0: uevent
usb 2-1:1.0: uevent
usbhid 2-1:1.0: usb_probe_interface
usbhid 2-1:1.0: usb_probe_interface - got id
input: Microsoft Basic Optical Mouse as /class/input/input7
input: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1d.0-1
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
usb 5-2: new full speed USB device using uhci_hcd and address 3
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
usb 5-2: ep0 maxpacket = 8
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: configured for UDMA/100
usb 5-2: default language 0x0409
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
hub 3-0:1.0: hub_resume
usb usb3: wakeup_rh
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
usb 5-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
usb 5-2: uevent
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
usb 5-2:1.0: uevent
usb 5-2:1.0: uevent
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: hub_resume
usb usb4: wakeup_rh
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
ata4: soft resetting port
ata4: SATA link down (SStatus 0 SControl 0)
ata4: EH complete
ata3: soft resetting port
ata3: SATA link down (SStatus 0 SControl 0)
ata3: EH complete
ata2: soft resetting port
ata2: SATA link down (SStatus 0 SControl 0)
ata2: EH complete
Uhhuh. NMI received for unknown reason a0.
You have some hardware problem, likely on the PCI bus.
Dazed and confused, but trying to continue
uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
Suspending console(s)
hub 5-0:1.0: port 2 nyet suspended
hub 5-0:1.0: suspend error -16
suspend_device(): usb_suspend+0x0/0x1c() returns -16
Could not suspend device usb5: error -16
Some devices failed to suspend
ata4: soft resetting port
ata4: SATA link down (SStatus 0 SControl 0)
ata4: EH complete
ata3: soft resetting port
ata3: SATA link down (SStatus 0 SControl 0)
ata3: EH complete
ata2: soft resetting port
ata2: SATA link down (SStatus 0 SControl 0)
ata2: EH complete
uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
Suspending console(s)
hub 5-0:1.0: port 2 nyet suspended
hub 5-0:1.0: suspend error -16
suspend_device(): usb_suspend+0x0/0x1c() returns -16
Could not suspend device usb5: error -16
Some devices failed to suspend
ata4: soft resetting port
ata4: SATA link down (SStatus 0 SControl 0)
ata4: EH complete
ata3: soft resetting port
ata3: SATA link down (SStatus 0 SControl 0)
ata3: EH complete
ata2: soft resetting port
ata2: SATA link down (SStatus 0 SControl 0)
ata2: EH complete
uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
