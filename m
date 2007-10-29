Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbXJ2Puh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbXJ2Puh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbXJ2Pua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:50:30 -0400
Received: from lug-owl.de ([195.71.106.12]:53203 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbXJ2Pu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:50:28 -0400
X-Greylist: delayed 2102 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 11:50:27 EDT
Date: Mon, 29 Oct 2007 16:15:23 +0100
From: Michael Westermann <michael@dvmwest.de>
To: linux-kernel@vger.kernel.org
Subject: interupt problems with ICH4 acpi and 8250_pnp
Message-ID: <20071029151522.GA18613@dvmwest.dvmwest.de>
Mail-Followup-To: Michael Westermann <michael@dvmwest.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've Interupt problems with shared interrupt and ICH4 chipset and a pnpbios

My problem is the follow. I've a box with ICH4 Chipset. The ttyS2 and
ttyS3 are conneted to the irq 10. 
After startup the box and using udev the module 8250.ko and
8250_pnp.ko are loaded.

I've tested with the 2.6.22.1 kernel. 

cat /proc/tty/driver/serial

0: uart:16550A port:000003F8 irq:4 tx:0 rx:0
1: uart:16550A port:000002F8 irq:3 tx:0 rx:0
2: uart:16550A port:000003E8 irq:10 tx:0 rx:0 CTS|DSR
3: uart:16550A port:000002E8 irq:10 tx:0 rx:0 CTS|DSR
4: uart:16550A port:000004F8 irq:10 tx:0 rx:0
5: uart:16550A port:000004E8 irq:10 tx:0 rx:0
6: uart:unknown port:00000000 irq:0
7: uart:unknown port:00000000 irq:0


when I user ttyS2 and ttyS3 seperatly it work's. When I use the ttyS2
and ttyS3 in the same time: ttyS3 generates Interrupts ttyS2 not.

I've tested with the follow sequences:

 ( for i in `seq 1 20` ; do printf "%x 01234567890123456\n" $i; sleep 2; done; ) > /dev/ttyS3

and 

 ( for i in `seq 1 10` ; do printf "%x 01234567890123456\r\n" $i; done;) > /dev/ttyS2

in the same time.

The output-sequence ist first the ttyS3 output then the ttyS2 output with a 2 second stepping.

I've make debug outputs for serial_in and serial_out, and I cann see that ttyS2 generates no
interrupts.

When I cancel the ttyS3 script the output fron ttyS2 are without delay's.
When I reload the 8250_pnp.ko module it works.

When I disable acpi, the serial ports are not found. 

Has anyware the same Problem?

Linux version 2.6.22.1 (root@woody) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 Mon Oct 29 16:04:13 CET 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001dff0000 (usable)
 BIOS-e820: 000000001dff0000 - 000000001dff3000 (ACPI NVS)
 BIOS-e820: 000000001dff3000 - 000000001e000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
479MB LOWMEM available.
Entering add_active_range(0, 0, 122864) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   122864
early_node_map[1] active PFN ranges
    0:        0 ->   122864
On node 0 totalpages: 122864
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 927 pages used for memmap
  Normal zone: 117841 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F6890, 0014 (r0 IntelR)
ACPI: RSDT 1DFF3040, 0028 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 1DFF30C0, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 1DFF3180, 4056 (r1 INTELR AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 1DFF0000, 0040
ACPI: PM-Timer IO Port: 0x408
Allocating PCI resources starting at 20000000 (gap: 1e000000:e0c00000)
Built 1 zonelists.  Total pages: 121905
Kernel command line: root=/dev/hda3 ro 
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 996.784 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 483244k/491456k available (2094k kernel code, 7652k reserved, 708k data, 168k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xde800000 - 0xfffb5000   ( 535 MB)
    lowmem  : 0xc0000000 - 0xddff0000   ( 479 MB)
      .init : 0xc03c0000 - 0xc03ea000   ( 168 kB)
      .data : 0xc030b849 - 0xc03bc8f8   ( 708 kB)
      .text : 0xc0100000 - 0xc030b849   (2094 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1994.89 BogoMIPS (lpj=3989787)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: afe9fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: After all inits, caps: afe9fbff 00000000 00000000 00002040 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Celeron(R) M processor         1.00GHz stepping 08
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 535 Objects with 48 Devices 148 Methods 30 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
ACPI: setting ELCR to 0200 (from 1a60)
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfa990, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 1 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.......................................................................
Initialized 30/30 Regions 9/9 Fields 22/22 Buffers 10/14 Packages (544 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:..
Executed 2 _INI methods requiring 1 _STA executions (examined 52 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0A03:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0501:01
PM: Adding info for acpi:PNP0400:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0501:02
PM: Adding info for acpi:PNP0501:03
PM: Adding info for acpi:PNP0501:04
PM: Adding info for acpi:PNP0501:05
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:INT0800:00
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:thermal:00
PM: Adding info for acpi:PNP0C0B:00
PM: Adding info for acpi:thermal:01
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:00.1
PM: Adding info for pci:0000:00:00.3
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:00:1f.5
PM: Adding info for pci:0000:01:04.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0A03
PM: Adding info for pnp:00:00
pnp: ACPI device : hid PNP0C02
PM: Adding info for pnp:00:01
pnp: ACPI device : hid PNP0200
PM: Adding info for pnp:00:02
pnp: ACPI device : hid PNP0B00
PM: Adding info for pnp:00:03
pnp: ACPI device : hid PNP0800
PM: Adding info for pnp:00:04
pnp: ACPI device : hid PNP0C04
PM: Adding info for pnp:00:05
pnp: ACPI device : hid PNP0501
PM: Adding info for pnp:00:06
pnp: ACPI device : hid PNP0501
PM: Adding info for pnp:00:07
pnp: ACPI device : hid PNP0400
PM: Adding info for pnp:00:08
pnp: ACPI device : hid PNP0303
PM: Adding info for pnp:00:09
pnp: ACPI device : hid PNP0501
PM: Adding info for pnp:00:0a
pnp: ACPI device : hid PNP0501
PM: Adding info for pnp:00:0b
pnp: ACPI device : hid PNP0501
PM: Adding info for pnp:00:0c
pnp: ACPI device : hid PNP0501
PM: Adding info for pnp:00:0d
pnp: ACPI device : hid PNP0C02
PM: Adding info for pnp:00:0e
pnp: ACPI device : hid INT0800
PM: Adding info for pnp:00:0f
pnp: ACPI device : hid PNP0C01
PM: Adding info for pnp:00:10
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:01' and the driver 'system'
pnp: match found with the PnP device '00:0e' and the driver 'system'
pnp: 00:0e: ioport range 0x400-0x4bf could not be reserved
pnp: match found with the PnP device '00:10' and the driver 'system'
pnp: 00:10: iomem range 0xdd400-0xdffff has been reserved
pnp: 00:10: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:10: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:10: iomem range 0xfc000-0xfffff could not be reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: e8000000-e80fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
PM: Adding info for platform:pcspkr
audit: initializing netlink socket (disabled)
audit(1193674149.344:1): initialized
io scheduler noop registered
io scheduler anticipatory registered (default)
Boot video device is 0000:00:02.0
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.2: Performing full reset
PM: Adding info for No Bus:pnp1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
.....
PM: Adding info for No Bus:ttyef
PM: Adding info for No Bus:isa
PM: Adding info for No Bus:lo
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: TOSHIBA THNCF2G04QG, CFA DISK drive
PM: Adding info for No Bus:ide0
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
PM: Adding info for ide:0.0
Probing IDE interface ide1...
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 3985632 sectors (2040 MB) w/2KiB Cache, CHS=3954/16/63
 hda: hda1 hda2 hda3
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:09' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
PM: Adding info for serio:serio0
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
Testing NMI watchdog ... OK.
Using IPI Shortcut mode
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 168k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
NET: Registered protocol family 1
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 855GM Chipset.
agpgart: Detected 32636K stolen memory.
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 128M @ 0xd8000000
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: irq 11, io base 0x0000e000
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22.1 uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
PM: Adding info for usb:usb1
usb usb1: uevent
usb usb1: usb_probe_device
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
PM: Adding info for usb:1-0:1.0
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 6
PCI: setting IRQ 6 as level-triggered
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 6 (level, low) -> IRQ 6
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: irq 6, io base 0x0000e100
usb usb2: default language 0x0409
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22.1 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.1
PM: Adding info for usb:usb2
usb usb2: uevent
usb usb2: usb_probe_device
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
PM: Adding info for usb:2-0:1.0
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
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
hub 1-0:1.0: port 2, status 0301, change 0003, 1.5 Mb/s
ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
intel_rng: FWH not detected
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: irq 9, io base 0x0000e200
usb usb3: default language 0x0409
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22.1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.2
PM: Adding info for usb:usb3
usb usb3: uevent
usb usb3: usb_probe_device
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
PM: Adding info for usb:3-0:1.0
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
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
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNK1] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 5, io mem 0xe8200000
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: default language 0x0409
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: EHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.22.1 ehci_hcd
usb usb4: SerialNumber: 0000:00:1d.7
PM: Adding info for usb:usb4
usb usb4: uevent
usb usb4: usb_probe_device
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
PM: Adding info for usb:4-0:1.0
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: Single TT
hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 4-0:1.0: power on to power good time: 20ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
input: PC Speaker as /class/input/input1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
PM: Adding info for platform:serial8250
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
PM: Adding info for No Bus:ttyS4
PM: Adding info for No Bus:ttyS5
PM: Adding info for No Bus:ttyS6
PM: Adding info for No Bus:ttyS7
usb 1-2: new low speed USB device using uhci_hcd and address 2
usb 1-2: uhci_result_common: failed with status 440000
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:06' and the driver 'serial'
PM: Removing info for No Bus:ttyS0
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
pnp: match found with the PnP device '00:07' and the driver 'serial'
PM: Removing info for No Bus:ttyS1
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PM: Adding info for No Bus:ttyS1
pnp: match found with the PnP device '00:0a' and the driver 'serial'
PM: Removing info for No Bus:ttyS2
00:0a: ttyS2 at I/O 0x3e8 (irq = 10) is a 16550A
PM: Adding info for No Bus:ttyS2
pnp: match found with the PnP device '00:0b' and the driver 'serial'
PM: Removing info for No Bus:ttyS3
usb 1-2: uhci_result_common: failed with status 440000
00:0b: ttyS3 at I/O 0x2e8 (irq = 10) is a 16550A
PM: Adding info for No Bus:ttyS3
pnp: match found with the PnP device '00:0c' and the driver 'serial'
PM: Removing info for No Bus:ttyS4
00:0c: ttyS4 at I/O 0x4f8 (irq = 10) is a 16550A
PM: Adding info for No Bus:ttyS4
pnp: match found with the PnP device '00:0d' and the driver 'serial'
PM: Removing info for No Bus:ttyS5
00:0d: ttyS5 at I/O 0x4e8 (irq = 10) is a 16550A
PM: Adding info for No Bus:ttyS5
usb 1-2: uhci_result_common: failed with status 440000
pnp: the driver 'parport_pc' has been registered
pnp: match found with the PnP device '00:08' and the driver 'parport_pc'
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
hub 2-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
.....


Michael



