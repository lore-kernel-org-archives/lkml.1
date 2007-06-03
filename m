Return-Path: <linux-kernel-owner+w=401wt.eu-S1751283AbXFCSKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbXFCSKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXFCSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:10:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26903 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXFCSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Wbt0WtBk0WS0RfG/sm0jXKl4s10czh7ZJdiHIOi6QOAYHOhFrCfZ9zFzwQ++W1+6d3fPQ7rwJI1VNWBsOdb1eqsCQ2oscEkPqWblaIV6Mzz7E9d3/mS0BmW5qK4Lf/VEFrZKTmHhbWxWZB0zz2DkPrSAKprbRywCTpBtCd1uhA8=
Message-ID: <2aea82040706031110g7aabf5d8o9de5fe80f4a8e9b7@mail.gmail.com>
Date: Sun, 3 Jun 2007 15:10:19 -0300
From: "Rodrigo Luiz" <troops.of.doom@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [SMP,APIC] Kernel hang on CMOS_READ
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In my notebook, a HP dv9205us, the kernel hang when I read the cmos clock.

To reproduce it, I just call hwclock one or two times. The kernel
don't show any oops. Just hang.

Another way to reproduce it, is 'while [ 1 ]; do cat /proc/driver/rtc;
done'. With some seconds, the kernel hang.

Looking in kernel code, and with some comments, I found that the issue
is in CMOS_READ, when rtc call this macro.

I tried to use many parameters with time related, like 'nohpet', and still hang.

The only parameter to make rtc works is 'noapic'. Or when I compile my
kernel without smp support.

I use a x86_64 box, but I tried with i386 too and I have the same
issue, but with some differences:

 - On i386, the delay to hang is greater that x86_64. I need to call
hwclock more times to hang.
 - Sometimes, on i386, my kernel hang on boot in this line:

   ENABLING IO-APIC IRQs
   ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1

Some suggestions?
And sorry for my english.

Thanks,
Rodrigo Luiz

------------------------

Linux version 2.6.22-rc3 (root@dig) (gcc version 4.1.2) #33 SMP
PREEMPT Sun Jun 3 14:22:23 BRT 2007
Command line: BOOT_IMAGE=linux ro root=801
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003df00000 (usable)
 BIOS-e820: 000000003df00000 - 000000003df17000 (ACPI data)
 BIOS-e820: 000000003df17000 - 000000003df80000 (ACPI NVS)
 BIOS-e820: 000000003df80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 253696) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F8930, 0014 (r0 HP    )
ACPI: RSDT 3DF0DCCE, 0040 (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: FACP 3DF16B9A, 0074 (r1 HP     MCP51M    6040000 PTL_    F4240)
ACPI: DSDT 3DF0DD0E, 8E8C (r1 HP       MCP51M  6040000 MSFT  3000000)
ACPI: FACS 3DF17FC0, 0040
ACPI: SSDT 3DF16C0E, 0182 (r1 HP     POWERNOW  6040000  LTP        1)
ACPI: MCFG 3DF16D90, 003C (r1 HP       MCFG    6040000  LTP        0)
ACPI: HPET 3DF16DCC, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: APIC 3DF16E04, 005E (r1 HP     	 APIC    6040000  LTP        0)
ACPI: BOOT 3DF16E62, 0028 (r1     HP $SBFTBL$  6040000  LTP        1)
ACPI: SLIC 3DF16E8A, 0176 (r1 HPQOEM SLIC-MPC  6040000  LTP        1)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 253696) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      157
    0:      256 ->   253696
On node 0 totalpages: 253597
  DMA zone: 56 pages used for memmap
  DMA zone: 1263 pages reserved
  DMA zone: 2678 pages, LIFO batch:0
  DMA32 zone: 3412 pages used for memmap
  DMA32 zone: 246188 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 33192 bytes of per cpu data
Built 1 zonelists.  Total pages: 248866
Kernel command line: BOOT_IMAGE=linux ro root=801
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1607.316 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ 2080000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 993728k/1014784k available (3154k kernel code, 20620k
reserved, 1190k data, 224k init)
Calibrating delay using timer specific routine.. 3218.94 BogoMIPS (lpj=5361519)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 24k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12557103
Detected 12.557 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3216.67 BogoMIPS (lpj=5357879)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-50 stepping 02
Brought up 2 CPUs
migration_cost=107
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - e06fffff
PCI: No mmconfig possible on device 00:18
PCI: No mmconfig possible on device 07:05
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 7) *11
ACPI: PCI Interrupt Link [LNK3] (IRQs 10) *11
ACPI: PCI Interrupt Link [LNK4] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LK3E] (IRQs 18) *11
ACPI: PCI Interrupt Link [LK4E] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs *10)
ACPI: PCI Interrupt Link [LPMU] (IRQs 11) *10
ACPI: PCI Interrupt Link [LUS0] (IRQs 22) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 22) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *10
ACPI: PCI Interrupt Link [LAZA] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 23) *5
ACPI: PCI Interrupt Link [LSI1] (IRQs 20) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
pnp: 00:00: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
pnp: 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:01: iomem range 0xfed00000-0xfed00fff could not be reserved
pnp: 00:03: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:04: ioport range 0x1000-0x107f has been reserved
pnp: 00:04: ioport range 0x1080-0x10ff has been reserved
pnp: 00:04: ioport range 0x1400-0x147f has been reserved
pnp: 00:04: ioport range 0x1480-0x14ff has been reserved
pnp: 00:04: ioport range 0x1800-0x187f has been reserved
pnp: 00:04: ioport range 0x1880-0x18ff has been reserved
pnp: 00:04: ioport range 0x2000-0x203f has been reserved
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 5
ACPI: PCI Interrupt 0000:07:05.0[A] -> Link [LNK1] -> GSI 5 (level,
high) -> IRQ 5
Time: hpet clocksource has been installed.
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[5]
MMIO=[bc000000-bc0007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
PCI: Bridge: 0000:00:02.0
  IO window: 4000-4fff
  MEM window: b4000000-b7ffffff
  PREFETCH window: d0000000-d01fffff
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: b8000000-bbffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:10.0
  IO window: disabled.
  MEM window: bc000000-bc0fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:05.0
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie03]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20000800000, using
3072k, total 32768k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
set_level status: 0
ACPI: Video Device [UVGA] (multi-head: yes  rom: no  post: no)
set_level status: 0
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
ACPI: Thermal Zone [THRM] (60 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
loop: module loaded
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 20 (level,
high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 0103c:30b7 bound to 0000:00:14.0
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP51: IDE controller at PCI slot 0000:00:0d.0
NFORCE-MCP51: chipset revision 241
NFORCE-MCP51: not 100% native mode: will probe irqs later
NFORCE-MCP51: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE-MCP51: 0000:00:0d.0 (rev f1) UDMA133 controller
    ide0: BM-DMA at 0x3080-0x3087, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[009fc000b8cfd800]
hda: HL-DT-ST DVDRAM GSA-4084N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
SCSI Media Changer driver v0.25
sata_nv 0000:00:0e.0: version 3.4
PCI: Enabling device 0000:00:0e.0 (0005 -> 0007)
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LTID] -> GSI 23 (level,
high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x00000000000130c0 ctl 0x00000000000130b6
bmdma 0x0000000000013090 irq 0
ata2: SATA max UDMA/133 cmd 0x00000000000130b8 ctl 0x00000000000130b2
bmdma 0x0000000000013098 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST9120821AS, 7.24, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x00000000000130bf
scsi 0:0:0:0: Direct-Access     ATA      ST9120821AS      7.24 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUS2] -> GSI 22 (level,
high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 22, io mem 0xb0005000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUS0] -> GSI 22 (level,
high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 22, io mem 0xb0004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
Initializing USB Mass Storage driver...
usb 1-4: new high speed USB device using ehci_hcd and address 2
usb 1-4: configuration #1 chosen from 1 choice
usb 2-6: new low speed USB device using ohci_hcd and address 2
usb 2-6: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
input: PC Speaker as /class/input/input5
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input6
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x3040
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x3000
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:07:05.1 [1180:0822] (rev 19)
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 7
ACPI: PCI Interrupt 0000:07:05.1[B] -> Link [LNK2] -> GSI 7 (level,
high) -> IRQ 7
mmc0: SDHCI at 0xbc000800 irq 7 DMA
input: Logitech USB Receiver as /class/input/input7
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:0b.0-6
input: Logitech USB Receiver as /class/input/input8
input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:0b.0-6
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14rc4 (Wed May 16
09:45:46 2007 UTC).
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
powernow-k8: Found 2 AMD Turion(tm) 64 X2 Mobile Technology TL-50
processors (version 2.00.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x12
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 224k freed
Adding 1028152k swap on /dev/sda3.  Priority:-1 extents:1 across:1028152k
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 21 (level,
high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:10.1 to 64
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [LK3E] enabled at IRQ 18
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LK3E] -> GSI 18 (level,
high) -> IRQ 18
PCI: Setting latency timer of device 0000:00:05.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9755  Mon Feb 26
23:16:31 PST 2007
ndiswrapper version 1.45rc3 loaded (smp=yes)
ndiswrapper (link_pe_images:577): fixing KI_USER_SHARED_DATA address
in the driver
ndiswrapper: driver bcmwl5 (Broadcom,10/12/2006, 4.100.15.5) loaded
ACPI: PCI Interrupt Link [LK4E] enabled at IRQ 19
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LK4E] -> GSI 19 (level,
high) -> IRQ 19
PCI: Setting latency timer of device 0000:03:00.0 to 64
ndiswrapper: using IRQ 19
wlan0: ethernet device 00:1a:73:0d:a0:48 using NDIS driver: bcmwl5,
version: 0x4640f05, NDIS version: 0x501, vendor: '', 14E4:4311.5.conf
wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK;
AES/CCMP with WPA, WPA2, WPA2PSK
usbcore: registered new interface driver ndiswrapper


root@dig:~# cat /proc/interrupts
           CPU0       CPU1
  0:       4848    1532204   IO-APIC-edge      timer
  1:         42      13650   IO-APIC-edge      i8042
  5:          0          2   IO-APIC-fasteoi   ohci1394
  7:          0          0   IO-APIC-fasteoi   sdhci:slot0
  8:          0          1   IO-APIC-edge      rtc
  9:          8       2634   IO-APIC-fasteoi   acpi
 12:          3        120   IO-APIC-edge      i8042
 14:          0         32   IO-APIC-edge      ide0
 18:      20897     271742   IO-APIC-fasteoi   nvidia
 19:       1807     153653   IO-APIC-fasteoi   ndiswrapper
 21:        399     187400   IO-APIC-fasteoi   HDA Intel
 22:        191      59613   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2
 23:        331     230027   IO-APIC-fasteoi   sata_nv
NMI:          0          0
LOC:    1537178    1536966
ERR:          0

root@dig:~# lspci -vv
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
                Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC-
TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Link Control 1: CFlE+ CST- CFE- <LkFail- Init+ EOC-
TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
                Link Config 1: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Revision ID: 1.03
                Link Frequency 0: 800MHz
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+
500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                Link Frequency 1: 800MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz+ 300MHz+ 400MHz+
500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE-
CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [e0] HyperTransport: MSI Mapping

00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [44] #00 [00fe]
        Capabilities: [fc] #00 [0000]

00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: b4000000-b7ffffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000d0100000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] #0d [0000]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=0/1 Enable+
                Address: 00000000fee0300c  Data: 4149
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <512ns, L1 <4us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn+ PwrFlt+ MRL- PresDet- CmdCplt- HPIrq+
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Virtual Channel

00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Memory behind bridge: b8000000-bbffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] #0d [0000]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=0/1 Enable+
                Address: 00000000fee0300c  Data: 4151
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <512ns, L1 <4us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn+ PwrFlt+ MRL- PresDet- CmdCplt- HPIrq+
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Virtual Channel

00:05.0 VGA compatible controller: nVidia Corporation C51 PCI Express
Bridge (rev a2) (prog-if 00 [VGA])
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at b2000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Region 3: Memory at b1000000 (64-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at 50000000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=9 UnitCnt=15 MastHost- DefDir- DUL-
                Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC-
TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
                Link Config 0: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut-
LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+
TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut-
LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Revision ID: 1.03
                Link Frequency 0: 800MHz
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+
500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz-
500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE-
CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [e0] HyperTransport: MSI Mapping

00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: I/O ports at 1d00 [size=128]

00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 4: I/O ports at 3040 [size=64]
        Region 5: I/O ports at 3000 [size=64]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.3 Co-processor: nVidia Corporation MCP51 PMU (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin B routed to IRQ 10
        Region 0: Memory at b0040000 (32-bit, non-prefetchable) [size=256K]

00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev
a3) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at b0004000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev
a3) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin B routed to IRQ 22
        Region 0: Memory at b0005000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [44] Debug port
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev f1) (prog-if
8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at 3080 [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
(rev f1) (prog-if 85 [Master SecO PriO])
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 23
        Region 0: I/O ports at 30c0 [size=8]
        Region 1: I/O ports at 30b4 [size=4]
        Region 2: I/O ports at 30b8 [size=8]
        Region 3: I/O ports at 30b0 [size=4]
        Region 4: I/O ports at 3090 [size=16]
        Region 5: Memory at b0006000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] Message Signalled Interrupts: 64bit+
Queue=0/2 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [cc] HyperTransport: MSI Mapping

00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=64
        Memory behind bridge: bc000000-bc0fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [b8] #0d [0000]
        Capabilities: [8c] HyperTransport: MSI Mapping

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (500ns min, 1250ns max)
        Interrupt: pin B routed to IRQ 21
        Region 0: Memory at b0000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [6c] HyperTransport: MSI Mapping

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at b0008000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 30e0 [size=8]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: [80] HyperTransport: Host or Secondary Interface
                !!! Possibly incomplete decoding
                Command: WarmRst+ DblEnd-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=8
                Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
                Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: [f0] #0f [0010]

03:00.0 Network controller: Broadcom Corporation Dell Wireless 1390
WLAN Mini-PCI Card (rev 01)
        Subsystem: Hewlett-Packard Company Unknown device 1363
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at b8000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s <4us, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s <4us, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel

07:05.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832
(prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 1000ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at bc000000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME+

07:05.1 Class 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host
Adapter (rev 19)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin B routed to IRQ 7
        Region 0: Memory at bc000800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

07:05.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at bc000c00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

07:05.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host
Adapter (rev 0a)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at bc001000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

07:05.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
        Subsystem: Hewlett-Packard Company Unknown device 30b7
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at bc001400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
