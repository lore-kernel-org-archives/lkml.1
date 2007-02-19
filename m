Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbXBSPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbXBSPKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbXBSPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:10:00 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1230 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbXBSPJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:09:58 -0500
Message-ID: <45D9BDBF.8040405@xs4all.nl>
Date: Mon, 19 Feb 2007 16:09:51 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca>
In-Reply-To: <20070218193901.GN7582@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
>> So IRQ 16 and 20. But when using the stock 2.6.20 kernel there is no
>> communication with the DVB-T card (the frontend), so there is no
>> /dev/dvb/* entry. This points to an IRQ problem.
> 
> Any documentation on that riser card?
> 
> I guess it is possible the card does something weird and the IRQs for
> both cards have to actually be the same.  If that is the case you could
> make the kernel change the IRQ assigned to the second card before
> loading the driver.  Or you could do it from the boot loader or
> something (The system I work with has a stupid bios that doesn't have a
> clue about bridges, so we added IRQ fixup code to grub to deal with all
> PCI bridges before booting the system).

Example patches or other ways to handle such situations are welcome.
I hope there is a 'standard' way to deal with this.
I asked TranquilPC about the card. I am waiting for an answer.

Can I do some tests to find out the real irq's myself?

>> If it is different from what Linux thinks: how do I tell Linux?
> 
> Linux doesn't think anything.  It goes by the IRQ assigned to the
> device, which is in one of the PCI registers on each device.  You can
> change those registers though, and then it should use the new value
> (although you may have to change it from the kernel before it enumerates
> the pci devices).

I.e.: patching.

>> I set the BIOS for 'PnP OS installed'. Should I change that?
> 
> I would NEVER do that.  That actually disables the BIOS from doing

Changing teh setting did not change the irq assignment:

# cat /proc/interrupts
           CPU0
  0:      97145   IO-APIC-edge      timer
  1:          8   IO-APIC-edge      i8042
  8:          1   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:        105   IO-APIC-edge      i8042
 14:       3063   IO-APIC-edge      ide0
 16:          0   IO-APIC-fasteoi   saa7146 (0)
 17:       1337   IO-APIC-fasteoi   eth0
 18:       9993   IO-APIC-fasteoi   libata
 19:          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2,
uhci_hcd:usb3, ehci_hcd:usb4
 20:          2   IO-APIC-fasteoi   ohci1394, saa7146 (1)
 21:          0   IO-APIC-fasteoi   VIA8237
NMI:          0
LOC:      97086
ERR:          0
MIS:          0

At the bottom I added a dmesg output of the kernel after boot.
I more or less know that irq 20 for the DVB-S card (saa7146 (1)) is
'working'. I know that irq 16 for saa7146 (0) (DVB-T) is not working for
i2c although the card does work perfectly for DVB-T reception (picture,
low CPU load, etc) with only reception as the bottleneck.

How can I proceed to test for the right irq for card saa7146 (0)?

Any ideas?


Kind regards,
Udo



Linux version 2.6.20i2c (root@recorder) (gcc version 4.1.1 20070105 (Red
Hat 4.1.1-51)) #1 PREEMPT Fri Feb 16 17:39:51 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f800 end:
000000000009f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f800 size: 0000000000000800 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003bef0000 end:
000000003bff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003bff0000 size: 0000000000003000 end:
000000003bff3000 type: 4
copy_e820_map() start: 000000003bff3000 size: 000000000000d000 end:
000000003c000000 type: 3
copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end:
00000000fec01000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end:
00000000fee01000 type: 2
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end:
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003bff0000 (usable)
 BIOS-e820: 000000003bff0000 - 000000003bff3000 (ACPI NVS)
 BIOS-e820: 000000003bff3000 - 000000003c000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
found SMP MP-table at 000f3800
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
early_node_map[1] active PFN ranges
    0:        0 ->   229376
On node 0 totalpages: 229376
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 P4M80P                                ) @ 0x000f7970
ACPI: RSDT (v001 P4M80P AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x3bff3040
ACPI: FADT (v001 P4M80P AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x3bff30c0
ACPI: MADT (v001 P4M80P AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x3bff7cc0
ACPI: DSDT (v001 P4M80P AWRDACPI 0x00001000 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:10 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 40000000 (gap: 3c000000:c2c00000)
Detected 1197.000 MHz processor.
Built 1 zonelists.  Total pages: 227584
Kernel command line: ro root=LABEL=/ rhgb quiet
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 904600k/917504k available (1961k kernel code, 12340k reserved,
724k data, 160k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xf8800000 - 0xfffb5000   ( 119 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03a2000 - 0xc03ca000   ( 160 kB)
      .data : 0xc02ea7a3 - 0xc039f934   ( 724 kB)
      .text : 0xc0100000 - 0xc02ea7a3   (1961 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 2396.88 BogoMIPS
(lpj=4793772)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: a7c9bbff 00000000 00000000 00000000
00000181 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 128K (64 bytes/line)
CPU: After all inits, caps: 27c9bbff 00000000 00000000 00000000 00000181
00003fcc 00000000
CPU: Centaur VIA Esther processor 1200MHz stepping 09
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf93b0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *5
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
SCSI subsystem initialized
libata version 2.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
PCI: Bridge: 0000:00:01.0
  IO window: b000-bfff
  MEM window: fb000000-fcffffff
  PREFETCH window: f4000000-f7ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1254k freed
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
JFS: nTxBlock = 7078, nTxLock = 56627
io scheduler noop registered
io scheduler cfq registered (default)
PCI: Bypassing VIA 8237 APIC De-Assert Message
Real Time Clock Driver v1.12ac
VIA RNG detected
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA VT3314 chipset
agpgart: AGP aperture is 128M @ 0xe8000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized via 2.10.0 20060529 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
loop: loaded (max 8 devices)
VIA Networking Velocity Family Gigabit Ethernet Adapter Driver Ver. 1.14
Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.
Copyright (c) 2004 Red Hat Inc.
ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 18 (level, low) -> IRQ 17
eth0: VIA Networking Velocity Family Gigabit Ethernet Adapter
eth0: Ethernet Address: 00:40:63:E6:D5:FA
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:0f.1
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level,
low) -> IRQ 18
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
    ide0: BM-DMA at 0xdc00-0xdc07, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
hda: MATSHITACD-RW CW-8124, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
sata_via 0000:00:0f.0: version 2.0
ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level,
low) -> IRQ 18
sata_via 0000:00:0f.0: routed to hard irq line 11
ata1: SATA max UDMA/133 cmd 0xF400 ctl 0xF002 bmdma 0xE400 irq 18
ata2: SATA max UDMA/133 cmd 0xEC00 ctl 0xE802 bmdma 0xE408 irq 18
scsi0 : sata_via
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0xF407
ATA: abnormal status 0x7F on port 0xF407
ata1.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : sata_via
ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xEC07
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000YS-01M 09.0 PQ: 0 ANSI: 5
SCSI device sda: 976773168 512-byte hdwr sectors (500108 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 976773168 512-byte hdwr sectors (500108 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: Attached scsi disk sda
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
logips2pp: Detected unknown logitech mouse model 1
input: PS/2 Logitech Mouse as /class/input/input2
padlock: No VIA PadLock drivers have been loaded.
padlock: Using VIA PadLock ACE for AES algorithm.
padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
ACPI: (supports S0 S1 S4 S5)
Freeing unused kernel memory: 160k freed
Time: tsc clocksource has been installed.
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level,
low) -> IRQ 19
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 19, io base 0x0000d800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level,
low) -> IRQ 19
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 19, io base 0x0000d400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level,
low) -> IRQ 19
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 19, io base 0x0000d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level,
low) -> IRQ 19
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:10.4: irq 19, io mem 0xfdffd000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level, low) -> IRQ 20
saa7146: register extension 'budget_av'.
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]
MMIO=[fdfff000-fdfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
saa7146: found saa7146 @ mem f8ce4000 (revision 1, irq 16) (0x153b,0x1157).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (Terratec Cinergy 1200 DVB-T).
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-0: MAC addr = 00:0a:ac:01:d6:87
sd 0:0:0:0: Attached scsi generic sg0 type 0
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
budget-av: ci interface initialised.
ACPI: PCI Interrupt 0000:00:14.0[A] -> GSI 17 (level, low) -> IRQ 20
saa7146: found saa7146 @ mem f8e78000 (revision 1, irq 20) (0x153b,0x1155).
saa7146 (1): dma buffer size 192512
DVB: registering new adapter (TerraTec Cinergy 1200 DVB-S).
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-1: MAC addr = 00:0a:ac:12:93:8d
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[004063500007b5e1]
DVB: registering frontend 1 (ST STV0299 DVB-S)...
budget-av: ci interface initialised.
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level,
low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:11.5 to 64
Non-volatile memory driver v1.2
lp: driver loaded but no devices found
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
ACPI: Fan [FAN] (on)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 2 throttling states)
ACPI: Thermal Zone [THRM] (25 C)
Time: acpi_pm clocksource has been installed.
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 859436k swap on /dev/sda9.  Priority:-1 extents:1 across:859436k
Velocity is AUTO mode
eth0: Link autonegation speed 100M bps full duplex
hwmon-vid: Unknown VRM version of your x86 CPU
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 20 -- ok
