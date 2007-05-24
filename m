Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbXEXUBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbXEXUBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXEXUAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:00:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:50899 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750816AbXEXUAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:00:54 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 24 May 2007 22:00:52 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070524200052.234330@gmx.net>
MIME-Version: 1.0
Subject: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
To: akpm@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19lBtVhY0plKtgMx9cuk14/jW+gMVcbaAFOenn/hb
 P0dmNtmsy543zPfP3VpQxrDwLJdPVR8pW9rA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: p5owNuE6ZCEEf2r0Gmwh3P54IGhpZYaK
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

with 2.6.22-rc2-mm1 I do get sound out of my machine using snd-intel8x0 module, BUT:

At least parts of that Alsa sound architecture do seem to be broken:

dmesg looks like this:

31 MSFT 31313031)
ACPI: APIC 1FFEC058, 005A (r1 ASUS   P4PE     42302E31 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 22 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130029
Kernel command line: root=/dev/hda1 ro vga=791
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1818.042 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 517004k/524208k available (1366k kernel code, 6660k reserved, 492k data, 140k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb8000 - 0xfffff000   ( 284 kB)
    vmalloc : 0xe0800000 - 0xfffb6000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
      .init : 0xc02d4000 - 0xc02f7000   ( 140 kB)
      .data : 0xc0255b76 - 0xc02d0d30   ( 492 kB)
      .text : 0xc0100000 - 0xc0255b76   (1366 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3637.50 BogoMIPS (lpj=1818752)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps: 3febfbff 00000000 00000000 0000b080 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) 4 CPU 1.80GHz stepping 04
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf1e60, last bus=2
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround
PCI quirk: region e400-e47f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region ec00-ec3f claimed by ICH4 GPIO
PCI: Enabled i801 SMBus device
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x1fffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:02: ioport range 0xe400-0xe47f has been reserved
pnp: 00:02: ioport range 0xe800-0xe81f has been reserved
pnp: 00:02: ioport range 0xec00-0xec3f has been reserved
pnp: 00:02: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
pnp: 00:02: iomem range 0xffb80000-0xffbfffff has been reserved
pnp: 00:10: ioport range 0x3f0-0x3f1 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: f2000000-f27fffff
  PREFETCH window: f3f00000-f7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: f1000000-f17fffff
  PREFETCH window: f2800000-f3efffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Simple Boot Flag at 0x3a set to 0x80
io scheduler noop registered (default)
Boot video device is 0000:01:00.0
vesafb: framebuffer at 0xf4000000, mapped to 0xe0880000, using 3072k, total 32768k
vesafb: mode is 1024x768x16, linelength=2048, pages=20
vesafb: protected mode interface info at c000:441b
vesafb: pmi: set display start = c00c4489, set palette = c00c44c3
vesafb: pmi: ports = d810 d816 d854 d838 d83c d85c d800 d804 d8b0 d8b2 d8b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: IC35L080AVVA07-0, ATA DISK drive
hda: selected mode 0x45
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-STDVD-ROM GDR8163B, ATAPI CD/DVD-ROM drive
hdd: CD-W54E, ATAPI CD/DVD-ROM drive
hdc: selected mode 0x42
hdd: selected mode 0x22
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
TCP cubic registered
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 140k freed
NET: Registered protocol family 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
snd: Unknown symbol unregister_sound_special
snd: Unknown symbol register_sound_special_device
snd: Unknown symbol sound_class
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
hdc: ATAPI 52X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
hdd: ATAPI 32X CD-ROM CD-R/RW drive, 1280kB Cache, DMA
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 17, io base 0x0000b800
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
Linux video capture interface: v2.00
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc2-mm1 uhci_hcd
snd_seq_device: Unknown symbol snd_info_register
usb usb1: SerialNumber: 0000:00:1d.0
snd_seq_device: Unknown symbol snd_info_create_module_entry
usb usb1: configuration #1 chosen from 1 choice
snd_seq_device: Unknown symbol snd_info_free_entry
hub 1-0:1.0: USB hub found
snd_seq_device: Unknown symbol snd_seq_root
hub 1-0:1.0: 2 ports detected
snd_seq_device: Unknown symbol snd_iprintf
snd_seq_device: Unknown symbol snd_device_new
snd_rawmidi: Unknown symbol snd_info_register
snd_rawmidi: Unknown symbol snd_seq_device_new
snd_rawmidi: Unknown symbol snd_info_free_entry
snd_rawmidi: Unknown symbol snd_unregister_oss_device
snd_rawmidi: Unknown symbol snd_register_oss_device
snd_rawmidi: Unknown symbol snd_ctl_register_ioctl
snd_rawmidi: Unknown symbol snd_card_file_add
snd_rawmidi: Unknown symbol snd_iprintf
snd_rawmidi: Unknown symbol snd_major
snd_rawmidi: Unknown symbol snd_oss_info_register
snd_rawmidi: Unknown symbol snd_unregister_device
snd_rawmidi: Unknown symbol snd_device_new
snd_rawmidi: Unknown symbol snd_ctl_unregister_ioctl
snd_rawmidi: Unknown symbol snd_lookup_oss_minor_data
snd_rawmidi: Unknown symbol snd_lookup_minor_data
snd_rawmidi: Unknown symbol snd_info_create_card_entry
snd_rawmidi: Unknown symbol snd_card_file_remove
snd_rawmidi: Unknown symbol snd_register_device_for_dev
snd_rawmidi: Unknown symbol snd_device_register
PCI: Enabling device 0000:00:1d.7 (0004 -> 0006)
snd_mpu401_uart: Unknown symbol snd_rawmidi_receive
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 18
snd_mpu401_uart: Unknown symbol snd_rawmidi_transmit_ack
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
snd_mpu401_uart: Unknown symbol snd_rawmidi_transmit_peek
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
snd_mpu401_uart: Unknown symbol snd_rawmidi_new
ehci_hcd 0000:00:1d.7: debug port 1
snd_mpu401_uart: Unknown symbol snd_rawmidi_set_ops
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 18, io mem 0xf1800000
snd_mpu401: Unknown symbol snd_mpu401_uart_new
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc2-mm1 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 19
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000b400
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc2-mm1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PCI: Enabling device 0000:00:1f.5 (0004 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
AC'97 0 analog subsections not ready
intel8x0_measure_ac97_clock: measured 50929 usecs
intel8x0: clocking to 48000
bttv: Bt8xx card found (0).
PCI: Enabling device 0000:02:0b.0 (0004 -> 0006)
ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 23 (level, low) -> IRQ 18
bttv0: Bt878 (rev 17) at 0000:02:0b.0, irq: 18, latency: 32, mmio: 0xf3000000
bttv0: detected: Pinnacle PCTV Sat [card=94], PCI subsystem ID is 11bd:001c
bttv0: using: Pinnacle PCTV Sat [card=94,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00df00fc [init]
bttv0: using tuner=-1
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bttv0: add subdevice "dvb0"
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
bt878: AUDIO driver version 0.0.0 loaded
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000b000
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.22-rc2-mm1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
bt878: Bt878 AUDIO function found (0).
PCI: Enabling device 0000:02:0b.1 (0004 -> 0006)
ACPI: PCI Interrupt 0000:02:0b.1[A] -> GSI 23 (level, low) -> IRQ 18
bt878_probe: card id=[0x1c11bd],[ Pinnacle PCTV Sat ] has DVB functions.
bt878(0): Bt878 (rev 17) at 02:0b.1, irq: 18, latency: 32, memory: 0xf2800000
DVB: registering new adapter (bttv0)
DVB: registering frontend 0 (Conexant CX24110 DVB-S)...
Adding 1951856k swap on /dev/hda6.  Priority:-1 extents:1 across:1951856k
EXT3 FS on hda1, internal journal
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Invalid PBLK length [5]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
NET: Registered protocol family 17
mice: PS/2 mouse device common for all mice
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
loop: module loaded
input: AT Translated Set 2 keyboard as /class/input/input2
logips2pp: Detected unknown logitech mouse model 11
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
input: PS/2 Logitech Mouse as /class/input/input3
mtrr: no MTRR for f4000000,2000000 found
Linux agpgart interface v0.102 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 17
[drm] Initialized r128 2.5.0 20030725 on minor 0

Yours sincerely

Uwe

-- 
GMX FreeMail: 1 GB Postfach, 5 E-Mail-Adressen, 10 Free SMS.
Alle Infos und kostenlose Anmeldung: http://www.gmx.net/de/go/freemail
