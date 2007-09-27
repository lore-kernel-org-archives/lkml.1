Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbXI0SIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbXI0SIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbXI0SI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:08:27 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:55693 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757990AbXI0SIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:08:21 -0400
Message-ID: <46FBF17A.6030009@idlum.be>
Date: Thu, 27 Sep 2007 20:07:54 +0200
From: Pierre-Yves Paulus <py@idlum.be>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       BlueZ development <bluez-devel@lists.sourceforge.net>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm links
 (mm/slab.c)
References: <46F92364.3080603@idlum.be>	<46F952BD.4010009@redhat.com>	<46FA5E2E.3010300@idlum.be> <20070927085658.1c66f1c8@gondolin.boeblingen.de.ibm.com> <46FBC1AE.4020404@idlum.be>
In-Reply-To: <46FBC1AE.4020404@idlum.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Remote: 87.66.147.78 (78.147-66-87.adsl-dyn.isp.belgacom.be)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
>>>> Please use CONFIG_SLUB and turn on SLUB debugging. Something is very 
>>>> wrong
>>>> somewhere...
>>> I did so, on 2.6.23-rc8. I also did include CONFIG_DEBUG_DRIVER and 
>>> CONFIG_DEBUG_KOBJECT, following Cornelia Huck's advice.
>>
>> Did you see any messages (from the driver core) surrounding
>> kobject_move() usage or the kref badness messages? I'm asking because
>> refcounting/lifetime issues may be the reason for your problems...
> 
> I just figured out how to get KERN_DEBUG to the serial console for 
> capture...

Another one below, complete log from power-up to reboot, with some bugs 
and one Oops. I only trimmed the numerous "l2cap_recv_acldata" and "ACL 
packet for unknown connection handle" lines which always fill up the log.


þÀLinux version 2.6.23-rc8 (root@p2a) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #3 Wed Sep 26 09:19:06 UTC 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000000f7b0000 (usable)
  BIOS-e820: 000000000f7b0000 - 000000000f7b3000 (ACPI NVS)
  BIOS-e820: 000000000f7b3000 - 000000000f7c0000 (ACPI data)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
247MB LOWMEM available.
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->    63408
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->    63408
DMI 2.2 present.
ACPI: RSDP 000F63C0, 0014 (r0 AMDGX3)
ACPI: RSDT 0F7B3040, 0028 (r1 AMDGX3 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 0F7B30C0, 0074 (r1 AMDGX3 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 0F7B3180, 35BD (r1 AMDGX3 AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 0F7B0000, 0040
ACPI: PM-Timer IO Port: 0x9c10
Allocating PCI resources starting at 10000000 (gap: 0f7c0000:f0830000)
swsusp: Registered nosave memory region: 000000000009e000 - 000000000009f000
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 62913
Kernel command line: root=UUID=c925de24-972b-437c-860f-8109d900aa4b ro 
panic=60 console=ttyS1,38400 console=tty0 slub_debug
No local APIC present or hardware disabled
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 498.062 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 243152k/253632k available (1704k kernel code, 9908k reserved, 
681k data, 312k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffb3000 - 0xfffff000   ( 304 kB)
     vmalloc : 0xd0000000 - 0xfffb1000   ( 767 MB)
     lowmem  : 0xc0000000 - 0xcf7b0000   ( 247 MB)
       .init : 0xc0358000 - 0xc03a6000   ( 312 kB)
       .data : 0xc02aa395 - 0xc0354aa4   ( 681 kB)
       .text : 0xc0100000 - 0xc02aa395   (1704 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 997.65 BogoMIPS 
(lpj=1995305)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 128K (32 bytes/line)
Compat vDSO mapped to ffffe000.
CPU: AMD Geode(TM) Integrated Processor by AMD PCS stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c00)
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfa740, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 11) *0
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 11) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NET: Registered protocol family 8
NET: Registered protocol family 20
Time: tsc clocksource has been installed.
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs...<6>Switched to high resolution mode on 
CPU 0
  it is
Freeing initrd memory: 4716k freed
audit: initializing netlink socket (disabled)
audit(1190905112.522:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0b: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
00:0c: ttyS3 at I/O 0x2e8 (irq = 5) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 6
EISA: Detected 0 cards.
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 312k freed
SCSI subsystem initialized
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKC] BIOS reported IRQ 0, using IRQ 11
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKC] -> GSI 11 (level, 
low) -> IRQ 11
eth0: RealTek RTL8139 at 0xf200, 00:04:5f:85:78:91, IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LNKB] -> GSI 11 (level, 
low) -> IRQ 11
eth1: RealTek RTL8139 at 0xf600, 00:04:5f:85:78:92, IRQ 11
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
ACPI: PCI Interrupt Link [LNKD] BIOS reported IRQ 0, using IRQ 10
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 10 (level, 
low) -> IRQ 10
sata_via 0000:00:0a.0: routed to hard irq line 11
usbcore: registered new device driver usb
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
scsi0 : sata_via
scsi1 : sata_via
scsi2 : sata_via
ata1: SATA max UDMA/133 cmd 0x0001ff00 ctl 0x0001ff0a bmdma 0x0001fb00 
irq 10
ata2: SATA max UDMA/133 cmd 0x0001fe00 ctl 0x0001fe0a bmdma 0x0001fb08 
irq 10
ata3: PATA max UDMA/133 cmd 0x0001fd00 ctl 0x0001fd0a bmdma 0x0001fb10 
irq 10
ata1: SATA link down (SStatus 0 SControl 310)
ata2: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt 0000:00:0f.4[D] -> Link [LNKD] -> GSI 10 (level, 
low) -> IRQ 10
ohci_hcd 0000:00:0f.4: OHCI Host Controller
ohci_hcd 0000:00:0f.4: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0f.4: irq 10, io mem 0xefffd000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
AMD5536: IDE controller at PCI slot 0000:00:0f.2
AMD5536: chipset revision 1
AMD5536: not 100% native mode: will probe irqs later
AMD5536: 0000:00:0f.2 (rev 01) UDMA100 controller
     ide0: BM-DMA at 0xfa00-0xfa07, BIOS settings: hda:DMA, hdb:pio
usb 1-1: new full speed USB device using ohci_hcd and address 2
hda: PQI IDE DiskOnModule, ATA DISK drive
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 7 ports detected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
usb 1-1.4: new full speed USB device using ohci_hcd and address 3
hda: max request size: 128KiB
hda: 4062240 sectors (2079 MB) w/0KiB Cache, CHS=4030/16/63, UDMA(33)
  hda: hda1 hda2 < hda5 hda6 >
usb 1-1.4: configuration #1 chosen from 1 choice
hub 1-1.4:1.0: USB hub found
hub 1-1.4:1.0: 3 ports detected
usb 1-1.5: new full speed USB device using ohci_hcd and address 4
usb 1-1.5: configuration #1 chosen from 1 choice
hub 1-1.5:1.0: USB hub found
hub 1-1.5:1.0: 3 ports detected
usb 1-1.2: new full speed USB device using ohci_hcd and address 5
usb 1-1.2: configuration #1 chosen from 1 choice
usb 1-1.4.2: new full speed USB device using ohci_hcd and address 6
usb 1-1.4.2: configuration #1 chosen from 1 choice
usb 1-1.4.3: new full speed USB device using ohci_hcd and address 7
usb 1-1.4.3: configuration #1 chosen from 1 choice
usb 1-1.5.2: new full speed USB device using ohci_hcd and address 8
usb 1-1.5.2: configuration #1 chosen from 1 choice
usb 1-1.5.3: new full speed USB device using ohci_hcd and address 9
usb 1-1.5.3: configuration #1 chosen from 1 choice
usb 1-1.4.1: new full speed USB device using ohci_hcd and address 10
usb 1-1.4.1: configuration #1 chosen from 1 choice
usb 1-1.5.1: new full speed USB device using ohci_hcd and address 11
usb 1-1.5.1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: HID 0a5c:4502 as /class/input/input0
input: USB HID v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:0f.4-1.4.2
input: HID 0a5c:4503 as /class/input/input1
input: USB HID v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:0f.4-1.4.3
input: HID 0a5c:4502 as /class/input/input2
input: USB HID v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:0f.4-1.5.2
input: HID 0a5c:4503 as /class/input/input3
input: USB HID v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:0f.4-1.5.3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ReiserFS: hda6: found reiserfs format "3.6" with standard journal
ReiserFS: hda6: using ordered data mode
ReiserFS: hda6: journal params: device hda6, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: hda6: checking transaction log (hda6)
ReiserFS: hda6: Using r5 hash to sort names
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:01.2[A] -> Link [LNKA] -> GSI 10 (level, 
low) -> IRQ 10
geode-aes: GEODE AES engine enabled.
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
AMD Geode RNG detected
ACPI: PCI Interrupt 0000:00:0f.3[B] -> Link [LNKB] -> GSI 11 (level, 
low) -> IRQ 11
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ACPI: AC Adapter [AC] (on-line)
Real Time Clock Driver v1.12ac
input: PC Speaker as /class/input/input7
FDC 0 is a post-1991 82077
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Adding 264560k swap on /dev/hda5.  Priority:-1 extents:1 across:264560k
loop: module loaded
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 
sec (nowayout= 0)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
eth0: link down
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
kobject l2cap: registering. parent: <NULL>, set: module
kobject holders: registering. parent: l2cap, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/l2cap'
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
kobject rfcomm: registering. parent: <NULL>, set: module
kobject holders: registering. parent: rfcomm, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/rfcomm'
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEVICE: moving 'rfcomm0' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl0060574FEB37'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'rfcomm1'
kobject rfcomm1: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEVICE: moving 'rfcomm1' to 'acl00E0033364E5'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEV: registering device: ID = 'rfcomm2'
kobject rfcomm2: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEVICE: moving 'rfcomm2' to 'acl0017B066F14B'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'rfcomm3'
kobject rfcomm3: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEVICE: moving 'rfcomm3' to 'acl006057BB4D92'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
hcidump[3694]: segfault at 0809ee89 eip 0805f3c7 esp bff25290 error 4
DEV: registering device: ID = 'rfcomm4'
kobject rfcomm4: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEVICE: moving 'rfcomm4' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
hcidump[3699]: segfault at 080a8c48 eip 0805f3c7 esp bfcef4e0 error 4
DEVICE: moving 'rfcomm3' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEV: Unregistering device. ID = 'rfcomm3'
PM: Removing info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject rfcomm3: cleaning up
device_create_release called for rfcomm3
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEVICE: moving 'rfcomm4' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: Unregistering device. ID = 'rfcomm4'
PM: Removing info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject rfcomm4: cleaning up
device_create_release called for rfcomm4
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm3'
kobject rfcomm3: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEVICE: moving 'rfcomm3' to 'acl006057BB4D92'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEVICE: moving 'rfcomm2' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: Unregistering device. ID = 'rfcomm2'
PM: Removing info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject rfcomm2: cleaning up
device_create_release called for rfcomm2
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
DEV: registering device: ID = 'rfcomm2'
kobject rfcomm2: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEVICE: moving 'rfcomm2' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm4'
kobject rfcomm4: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEVICE: moving 'rfcomm4' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEVICE: moving 'rfcomm1' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEV: Unregistering device. ID = 'rfcomm1'
PM: Removing info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject rfcomm1: cleaning up
device_create_release called for rfcomm1
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEV: Unregistering device. ID = 'rfcomm2'
PM: Removing info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
kobject rfcomm2: cleaning up
device_create_release called for rfcomm2
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
=============================================================================
BUG kmalloc-128: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xc5734f28-0xc5734f40. First byte 0x6a instead of 0x6b
INFO: Allocated in rfcomm_dev_ioctl+0xbd/0x4e6 [rfcomm] age=6110 cpu=0 
pid=3677
INFO: Freed in rfcomm_dev_destruct+0x59/0x65 [rfcomm] age=3157 cpu=0 
pid=3927
INFO: Slab 0xc10ae680 used=21 fp=0xc5734f20 flags=0x400000c2
INFO: Object 0xc5734f20 @offset=3872 fp=0xc57342c0

Bytes b4 0xc5734f10:  05 00 00 00 f8 23 0f 00 5a 5a 5a 5a 5a 5a 5a 5a 
....ø#..ZZZZZZZZ
   Object 0xc5734f20:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkjkkkkkkk
   Object 0xc5734f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc5734f40:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
   Object 0xc5734f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc5734f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc5734f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc5734f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc5734f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 
kkkkkkkkkkkkkkk¥
  Redzone 0xc5734fa0:  bb bb bb bb 
»»»»
  Padding 0xc5734fc8:  5a 5a 5a 5a 5a 5a 5a 5a 
ZZZZZZZZ
  [<c0158fac>] check_bytes_and_report+0x91/0xb2
  [<c0159214>] check_object+0xc5/0x1c0
  [<c0159e51>] __slab_alloc+0x39e/0x3b1
  [<c0159fb2>] kmem_cache_alloc+0x48/0x92
  [<d02f8ac4>] rfcomm_dlc_alloc+0x15/0x5d [rfcomm]
  [<d02f8ac4>] rfcomm_dlc_alloc+0x15/0x5d [rfcomm]
  [<d02fa28d>] rfcomm_sock_alloc+0x4e/0xbb [rfcomm]
  [<d02fa32a>] rfcomm_sock_create+0x30/0x46 [rfcomm]
  [<d02000d4>] bt_sock_create+0x5a/0x7a [bluetooth]
  [<c016c6ba>] new_inode+0x14/0x6d
  [<c0246840>] __sock_create+0x109/0x189
  [<c02468f4>] sock_create+0x18/0x1c
  [<c0246a71>] sys_socket+0x1c/0x3e
  [<c02472dd>] sys_socketcall+0x5d/0x242
  [<c015b4b5>] filp_close+0x51/0x58
  [<c015c54d>] sys_close+0x54/0x83
  [<c0103c72>] syscall_call+0x7/0xb
  =======================
FIX kmalloc-128: Restoring 0xc5734f28-0xc5734f40=0x6b

FIX kmalloc-128: Marking all objects used
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
DEVICE: moving 'rfcomm0' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEVICE: moving 'rfcomm4' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: Unregistering device. ID = 'rfcomm4'
PM: Removing info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject rfcomm4: cleaning up
device_create_release called for rfcomm4
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
=============================================================================
BUG kmalloc-128: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xc7575168-0xc7575180. First byte 0x6a instead of 0x6b
INFO: Allocated in kobject_uevent_env+0xd9/0x3e2 age=296 cpu=0 pid=5
INFO: Freed in kobject_uevent_env+0x3c6/0x3e2 age=288 cpu=0 pid=5
INFO: Slab 0xc10eaea0 used=5 fp=0xc7575160 flags=0x400000c2
INFO: Object 0xc7575160 @offset=352 fp=0xc7575420

Bytes b4 0xc7575150:  d2 0d 00 00 bf 27 0f 00 5a 5a 5a 5a 5a 5a 5a 5a 
Ò...¿'..ZZZZZZZZ
   Object 0xc7575160:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkjkkkkkkk
   Object 0xc7575170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc7575180:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
   Object 0xc7575190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc75751a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc75751b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc75751c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc75751d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 
kkkkkkkkkkkkkkk¥
  Redzone 0xc75751e0:  bb bb bb bb 
»»»»
  Padding 0xc7575208:  5a 5a 5a 5a 5a 5a 5a 5a 
ZZZZZZZZ
  [<c0158fac>] check_bytes_and_report+0x91/0xb2
  [<c0159214>] check_object+0xc5/0x1c0
  [<c0159e51>] __slab_alloc+0x39e/0x3b1
  [<c0159298>] check_object+0x149/0x1c0
  [<c0159fb2>] kmem_cache_alloc+0x48/0x92
  [<c01c6558>] kobject_uevent_env+0xd9/0x3e2
  [<d0204cf2>] del_conn+0x0/0x8 [bluetooth]
  [<c01c6558>] kobject_uevent_env+0xd9/0x3e2
  [<c019204f>] release_sysfs_dirent+0x53/0x65
  [<d0204cf2>] del_conn+0x0/0x8 [bluetooth]
  [<c0229f83>] device_pm_remove+0x3f/0x6a
  [<d0204cf2>] del_conn+0x0/0x8 [bluetooth]
  [<c022597d>] device_del+0x203/0x22e
  [<d0204cf2>] del_conn+0x0/0x8 [bluetooth]
  [<c0127959>] run_workqueue+0x7d/0x103
  [<c0127fae>] worker_thread+0x0/0xbe
  [<c0128060>] worker_thread+0xb2/0xbe
  [<c012a4dc>] autoremove_wake_function+0x0/0x35
  [<c012a32f>] kthread+0x36/0x5b
  [<c012a2f9>] kthread+0x0/0x5b
  [<c0104e17>] kernel_thread_helper+0x7/0x10
  =======================
FIX kmalloc-128: Restoring 0xc7575168-0xc7575180=0x6b

FIX kmalloc-128: Marking all objects used
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEVICE: moving 'rfcomm3' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: Unregistering device. ID = 'rfcomm3'
PM: Removing info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject rfcomm3: cleaning up
device_create_release called for rfcomm3
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEVICE: moving 'rfcomm0' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
hcid[5554]: segfault at d6e62224 eip b7f65130 esp bfe76f60 error 4
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl0060574FEB37'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'rfcomm1'
kobject rfcomm1: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEVICE: moving 'rfcomm1' to 'acl00E0033364E5'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEV: registering device: ID = 'acl0007E0B37003'
kobject acl0007E0B37003: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0007E0B37003
bus bluetooth: add device acl0007E0B37003
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0007E0B37003'
DEV: registering device: ID = 'rfcomm2'
kobject rfcomm2: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEVICE: moving 'rfcomm2' to 'acl0017B066F14B'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
bus bluetooth: remove device acl0007E0B37003
PM: Removing info for bluetooth:acl0007E0B37003
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0007E0B37003'
kobject acl0007E0B37003: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm3'
kobject rfcomm3: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEVICE: moving 'rfcomm3' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
DEV: registering device: ID = 'rfcomm4'
kobject rfcomm4: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEVICE: moving 'rfcomm4' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEV: registering device: ID = 'rfcomm5'
kobject rfcomm5: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm5
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
DEVICE: moving 'rfcomm5' to 'acl006057BB4D92'
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
hcidump[5701]: segfault at 080a9dc4 eip 0805f3c7 esp bfd11d00 error 4
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
DEVICE: moving 'rfcomm5' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: Unregistering device. ID = 'rfcomm5'
PM: Removing info for No Bus:rfcomm5
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject rfcomm5: cleaning up
device_create_release called for rfcomm5
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
DEVICE: moving 'rfcomm1' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEV: Unregistering device. ID = 'rfcomm1'
PM: Removing info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject rfcomm1: cleaning up
device_create_release called for rfcomm1
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEVICE: moving 'rfcomm3' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: Unregistering device. ID = 'rfcomm3'
PM: Removing info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject rfcomm3: cleaning up
device_create_release called for rfcomm3
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEVICE: moving 'rfcomm2' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: Unregistering device. ID = 'rfcomm2'
PM: Removing info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject rfcomm2: cleaning up
device_create_release called for rfcomm2
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEVICE: moving 'rfcomm0' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl006057BB4D92'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'acl0007E0B37003'
kobject acl0007E0B37003: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0007E0B37003
bus bluetooth: add device acl0007E0B37003
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0007E0B37003'
bus bluetooth: remove device acl0007E0B37003
PM: Removing info for bluetooth:acl0007E0B37003
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0007E0B37003'
kobject acl0007E0B37003: cleaning up
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
BUG: unable to handle kernel paging request at virtual address 6b6b6b77
  printing eip:
c0249964
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror 
dm_mod softdog loop parport_pc parport psmouse serio_raw floppy pcspkr 
rtc ac button snd_cs5535audio snd_ac97_codec ac97_bus snd_pcm snd_timer 
snd soundcore snd_page_alloc geode_rng hci_usb cs5535_gpio bluetooth 
geode_aes blkcipher tsdev evdev reiserfs usbhid hid ide_disk generic 
amd74xx ohci_hcd ide_core sata_via ata_generic 8139cp libata usbcore 
8139too mii scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<c0249964>]    Not tainted VLI
EFLAGS: 00010016   (2.6.23-rc8 #3)
EIP is at skb_dequeue+0x19/0x4a
eax: 00000216   ebx: 00000216   ecx: 00000000   edx: 6b6b6b77
esi: c7ff0dd8   edi: c7ff0c90   ebp: c7ff0c9c   esp: c1251f60
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process events/0 (pid: 5, ti=c1250000 task=c12455c0 task.ti=c1250000)
Stack: 6b6b6b77 c024abe6 c7ff0c90 d02fb05d c7ff0df0 c020e754 c75152d8 
00000000
        00000000 00000000 cf7a2630 c7ff0dd8 c020e68b 00000000 c0127959 
c1251fb4
        00000046 c12455c0 cf7a2630 cf7a2630 c0127fae c1251fd0 c0128060 
00000000
Call Trace:
  [<c024abe6>] skb_queue_purge+0x11/0x17
  [<d02fb05d>] rfcomm_tty_flush_buffer+0x1c/0x33 [rfcomm]
  [<c020e754>] do_tty_hangup+0xc9/0x2d0
  [<c020e68b>] do_tty_hangup+0x0/0x2d0
  [<c0127959>] run_workqueue+0x7d/0x103
  [<c0127fae>] worker_thread+0x0/0xbe
  [<c0128060>] worker_thread+0xb2/0xbe
  [<c012a4dc>] autoremove_wake_function+0x0/0x35
  [<c012a32f>] kthread+0x36/0x5b
  [<c012a2f9>] kthread+0x0/0x5b
  [<c0104e17>] kernel_thread_helper+0x7/0x10
  =======================
Code: 93 a0 00 00 00 66 8b 40 0a 66 89 42 0a 5b 5e 5f 5d c3 53 89 c2 9c 
58 90 8d b4 26 00 00 00 00 89 c3 fa 90 8d b4 26 00 00 00 00 90 <8b> 0a 
39 d1 75 04 31 c9 eb 17 8b 01 ff 4a 08 89 02 89 50 04 c7
EIP: [<c0249964>] skb_dequeue+0x19/0x4a SS:ESP 0068:c1251f60
=============================================================================
BUG kmalloc-128: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xc04d0c68-0xc04d0c80. First byte 0x6a instead of 0x6b
INFO: Allocated in kobject_uevent_env+0xd9/0x3e2 age=1432 cpu=0 pid=5
INFO: Freed in kobject_uevent_env+0x3c6/0x3e2 age=1424 cpu=0 pid=5
INFO: Slab 0xc1009a00 used=21 fp=0xc04d0c60 flags=0x00c2
INFO: Object 0xc04d0c60 @offset=3168 fp=0xc04d0b00

Bytes b4 0xc04d0c50:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a 
........ZZZZZZZZ
   Object 0xc04d0c60:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkjkkkkkkk
   Object 0xc04d0c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0c80:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
   Object 0xc04d0c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 
kkkkkkkkkkkkkkk¥
  Redzone 0xc04d0ce0:  bb bb bb bb 
»»»»
  Padding 0xc04d0d08:  5a 5a 5a 5a 5a 5a 5a 5a 
ZZZZZZZZ
  [<c0158fac>] check_bytes_and_report+0x91/0xb2
  [<c0159214>] check_object+0xc5/0x1c0
  [<c0159e51>] __slab_alloc+0x39e/0x3b1
  [<c0159fb2>] kmem_cache_alloc+0x48/0x92
  [<d01568d2>] alloc_journal_list+0x13/0x66 [reiserfs]
  [<d01568d2>] alloc_journal_list+0x13/0x66 [reiserfs]
  [<d015819e>] do_journal_end+0x7e7/0xb5b [reiserfs]
  [<d0158572>] journal_end_sync+0x60/0x65 [reiserfs]
  [<d014a25d>] reiserfs_sync_fs+0x2d/0x44 [reiserfs]
  [<c015e565>] sync_supers+0x3e/0x6a
  [<c0147a1e>] pdflush+0x0/0x194
  [<c01476f6>] wb_kupdate+0x23/0xd2
  [<c0147a1e>] pdflush+0x0/0x194
  [<c0147b1c>] pdflush+0xfe/0x194
  [<c02a8266>] __sched_text_start+0x1d6/0x245
  [<c01476d3>] wb_kupdate+0x0/0xd2
  [<c012a32f>] kthread+0x36/0x5b
  [<c012a2f9>] kthread+0x0/0x5b
  [<c0104e17>] kernel_thread_helper+0x7/0x10
  =======================
FIX kmalloc-128: Restoring 0xc04d0c68-0xc04d0c80=0x6b

FIX kmalloc-128: Marking all objects used
DEV: Unregistering device. ID = 'rfcomm4'
PM: Removing info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject rfcomm4: cleaning up
device_create_release called for rfcomm4
=============================================================================
BUG kmalloc-128: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xc04d02c8-0xc04d02e0. First byte 0x6a instead of 0x6b
INFO: Allocated in rfcomm_dev_ioctl+0xbd/0x4e6 [rfcomm] age=31493 cpu=0 
pid=5679
INFO: Freed in rfcomm_dev_destruct+0x59/0x65 [rfcomm] age=9707 cpu=0 
pid=5679
INFO: Slab 0xc1009a00 used=21 fp=0xc04d02c0 flags=0x00c2
INFO: Object 0xc04d02c0 @offset=704 fp=0xc04d0160

Bytes b4 0xc04d02b0:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a 
........ZZZZZZZZ
   Object 0xc04d02c0:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkjkkkkkkk
   Object 0xc04d02d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d02e0:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
   Object 0xc04d02f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
   Object 0xc04d0330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 
kkkkkkkkkkkkkkk¥
  Redzone 0xc04d0340:  bb bb bb bb 
»»»»
  Padding 0xc04d0368:  5a 5a 5a 5a 5a 5a 5a 5a 
ZZZZZZZZ
  [<c0158fac>] check_bytes_and_report+0x91/0xb2
  [<c0159214>] check_object+0xc5/0x1c0
  [<c0159e51>] __slab_alloc+0x39e/0x3b1
  [<c0159fb2>] kmem_cache_alloc+0x48/0x92
  [<d01568d2>] alloc_journal_list+0x13/0x66 [reiserfs]
  [<d01568d2>] alloc_journal_list+0x13/0x66 [reiserfs]
  [<d015819e>] do_journal_end+0x7e7/0xb5b [reiserfs]
  [<c011706e>] update_curr_load+0x6e/0x83
  [<d0158572>] journal_end_sync+0x60/0x65 [reiserfs]
  [<d014a25d>] reiserfs_sync_fs+0x2d/0x44 [reiserfs]
  [<c015e565>] sync_supers+0x3e/0x6a
  [<c0147a1e>] pdflush+0x0/0x194
  [<c01476f6>] wb_kupdate+0x23/0xd2
  [<c0147a1e>] pdflush+0x0/0x194
  [<c0147b1c>] pdflush+0xfe/0x194
  [<c02a8266>] __sched_text_start+0x1d6/0x245
  [<c01476d3>] wb_kupdate+0x0/0xd2
  [<c012a32f>] kthread+0x36/0x5b
  [<c012a2f9>] kthread+0x0/0x5b
  [<c0104e17>] kernel_thread_helper+0x7/0x10
  =======================
FIX kmalloc-128: Restoring 0xc04d02c8-0xc04d02e0=0x6b

FIX kmalloc-128: Marking all objects used
DEV: Unregistering device. ID = 'vcs1'
PM: Removing info for No Bus:vcs1
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs1'
kobject vcs1: cleaning up
device_create_release called for vcs1
DEV: Unregistering device. ID = 'vcsa1'
PM: Removing info for No Bus:vcsa1
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa1'
kobject vcsa1: cleaning up
device_create_release called for vcsa1
DEV: Unregistering device. ID = 'vcs2'
PM: Removing info for No Bus:vcs2
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs2'
kobject vcs2: cleaning up
device_create_release called for vcs2
DEV: Unregistering device. ID = 'vcsa2'
PM: Removing info for No Bus:vcsa2
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa2'
kobject vcsa2: cleaning up
device_create_release called for vcsa2
DEV: Unregistering device. ID = 'vcs4'
PM: Removing info for No Bus:vcs4
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs4'
kobject vcs4: cleaning up
device_create_release called for vcs4
DEV: Unregistering device. ID = 'vcsa4'
PM: Removing info for No Bus:vcsa4
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa4'
kobject vcsa4: cleaning up
device_create_release called for vcsa4
DEV: Unregistering device. ID = 'vcs5'
PM: Removing info for No Bus:vcs5
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs5'
kobject vcs5: cleaning up
device_create_release called for vcs5
DEV: Unregistering device. ID = 'vcsa5'
PM: Removing info for No Bus:vcsa5
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa5'
kobject vcsa5: cleaning up
device_create_release called for vcsa5
DEV: Unregistering device. ID = 'vcs3'
PM: Removing info for No Bus:vcs3
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs3'
kobject vcs3: cleaning up
device_create_release called for vcs3
DEV: Unregistering device. ID = 'vcsa3'
PM: Removing info for No Bus:vcsa3
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa3'
kobject vcsa3: cleaning up
device_create_release called for vcsa3
DEV: Unregistering device. ID = 'vcs6'
PM: Removing info for No Bus:vcs6
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs6'
kobject vcs6: cleaning up
device_create_release called for vcs6
DEV: Unregistering device. ID = 'vcsa6'
PM: Removing info for No Bus:vcsa6
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa6'
kobject vcsa6: cleaning up
device_create_release called for vcsa6
Restarting system.
