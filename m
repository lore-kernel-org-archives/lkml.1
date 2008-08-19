Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYHSJ6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYHSJ6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYHSJ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:57:36 -0400
Received: from esbens.latnet.lv ([92.240.66.74]:39697 "EHLO esbens.latnet.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbYHSJ5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:57:24 -0400
From: Aivils Stoss <aivils@latnet.lv>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
Date: Tue, 19 Aug 2008 15:27:06 +0530
User-Agent: KMail/1.9.7
Cc: lud <linux-usb@vger.kernel.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-input@vger.kernel.org, jkosina@suse.cz,
       linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
References: <200808080702.24969.aivils@latnet.lv> <200808181642.49489.aivils@latnet.lv> <20080818081432.782d9632.rdunlap@xenotime.net>
In-Reply-To: <20080818081432.782d9632.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yjpqI1i811/jqjI"
Message-Id: <200808191527.06945.aivils@latnet.lv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_yjpqI1i811/jqjI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 August 2008 8:44:32 pm Randy Dunlap wrote:
> On Mon, 18 Aug 2008 16:42:49 +0530 Aivils Stoss wrote:
> > On Friday 15 August 2008 7:19:48 am Randy Dunlap wrote:
> > > On Sun, 10 Aug 2008 04:08:37 +0100 Aivils Stoss wrote:
> > > > On Saturday 09 August 2008 11:42:26 am Samuel Thibault wrote:
> > > > > Aivils Stoss, le Fri 08 Aug 2008 07:02:24 +0100, a =E9crit :
> > > > > > I suppose this is Linux kernel bug because i test keyboards und=
er
> > > > > > Windows, which support any schema of cascading of usb hubs.
> > > > >
> > > > > On the very same machine and hubs?
> > > >
> > > > Yes, on same machine. Under Windows i don't have evdev interface,
> > > > checked only how keypress go to console.
> > > > Of course to repeat a try You must have at least 5 keyboards and
> > > > 1 7-port or 2 4-port hubs and kernel 2.6.22 and above. I allways
> > > > got result - 5th, 6th, 7th keyboard does not send events to console
> > > > or evdev.
> > >
> > > [adding linux-usb mailing list]
> > >
> > > Hi,
> > >
> > > I finally got 5 USB keyboards together along with 2 hubs.
> > > I daisy-chained the hubs and connected 1 keyboard to the hub that is
> > > on the notebook computer USB port, then I connected 4 keyboards to the
> > > second hub.  They all worked for me, meaning that I can type on all of
> > > them and have their characters show up on my console.
> > >
> > > I'm testing with 2.6.7-rc2.
> > > 'usbtree' output of the USB subsystem is attached.
> >
> > Yeah! 2.6.7 is a bit obsolete. At my end 2.6.15 support more than 4
> > keyboards per PC port , but mess up input when is plugged more than
> > 9 keyboards. 10th is capable to send keypress events, but last pressed
> > key will be repeated until ctrl-c . 10th keyboard disturb an auto repeat
> > of all keyboards.
>
> Sorry, my keyboard made a typo.  I'm testing with 2.6.27-rc2.
>
> So the problem is now different from your original report, right?

No problem is same. Older kernels have another troubles.
2.6.22-1-mepis-smp
Quite stable. Have oops sometime inside evdev. Support up to 16=20
USB keyboards, where 4 hubs are plugged into PC and 4 keyboards on
each hub. Any hub cascade support only 4 keyboards, where 5th or more
is registered but don't send input events. Oops inside evdev , when
USB keyboard unplugged. No slow down even all USB keyboards does
not work properly. My be this one support more than 16 keyboards, but
i don't have PC USB ports enough.

2.6.24-7
4 keyboards per port. If plug in 5th tend to total slow down with this one:
usb 2-1.1.1: reset low speed USB device using=20
uhci_hcd and address 17
5th - means 5th keyboard in USB hub's cascade, which is plugged into
single PC USB port.

2.6.26
4 keyboards per port. If plug in 5th tend to total slow down.

2.6.27-rc3
Sorry Randy i cannot repeat Your achievement. This worse of all tested
kernels. I got working 3 USB keyboards, when i plug in 4th, all keyboards,
include PS/2 stop working. Kernel does not hung up. I can reach box
via net. dmesg , /proc/bus/input/devices attached. lsusb hung up.

Please notify me , if i should use 2.6.27-rc2 !

Aivils

>
>
> What speed is the host port that the keyboards are connected to?
> Could it be a USB bus bandwidth limitation?  (not that any code
> checks for that)
>
> I barely found 5 USB keyboards, so I surely can't test 10 or more.  ;)
> I suppose that it will take some USB debug messages to attempt to see
> what is going on...
>
>
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/



--Boundary-00=_yjpqI1i811/jqjI
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg-2.6.27-rc3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-2.6.27-rc3"

stem 00:12: iomem range 0xe0000-0xfffff could not be reserved
system 00:12: iomem range 0x100000-0x3f7fffff could not be reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.0:   IO window: 0xe000-0xefff
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.1:   IO window: 0xd000-0xdfff
pci 0000:00:1c.1:   MEM window: 0xdff00000-0xdfffffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xdfe00000-0xdfefffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
audit: initializing netlink socket (disabled)
type=2000 audit(1219146320.240:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/W].
msgmni has been set to 1765
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
pci 0000:00:1d.3: Performing full reset
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0e: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /class/input/input0
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata1.00: ATA-7: ST3160215A, 3.AAD, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST3160215A       3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < > sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata_piix 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 23
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xb800 ctl 0xb400 bmdma 0xa400 irq 23
ata4: SATA max UDMA/133 cmd 0xb000 ctl 0xa800 bmdma 0xa408 irq 23
ata3.01: NODEV after polling detection
ata3.00: ATAPI: TSSTcorp CDDVDW SH-S203D, SB00, max UDMA/100
ata3.00: configured for UDMA/100
scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203D  SB00 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg1 type 5
ieee1394: raw1394: /dev/raw1394 device initialized
usbmon: debugfs is not available
ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdfdffc00
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-rc3 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver appletouch
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input1
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 252k freed
kjournald starting.  Commit interval 5 seconds
usb usb1: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
ACPI: SSDT 3F7AE0C0, 0214 (r1    AMI   CPU1PM        1 INTL 20060113)
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: SSDT 3F7AE2E0, 0143 (r1    AMI   CPU2PM        1 INTL 20060113)
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU2] (supports 8 throttling states)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
Linux agpgart interface v0.103
Atheros(R) L2 Ethernet Driver - version 2.0.4
Copyright (c) 2007 Atheros Corporation.
atl2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
atl2 0000:02:00.0: setting latency timer to 64
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00009000
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
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
Floppy drive(s): fd0 is 1.44M
logips2pp: Detected unknown logitech mouse model 106
FDC 0 is a post-1991 82077
input: PC Speaker as /class/input/input4
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-rc3 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00009400
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
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
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-rc3 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
agpgart-intel 0000:00:00.0: Intel 945G Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009800
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-rc3 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: supports USB remote wakeup
uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000a000
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
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
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-rc3 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
ath5k_pci 0000:01:01.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ath5k_pci 0000:01:01.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
udev: renamed network interface wlan0 to ath0
input: ImExPS/2 Logitech Explorer Mouse as /class/input/input5
EMU10K1X 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Model 1001 Rev 00000000 Serial 10011102
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
usb usb5: suspend_rh (auto-stop)
splashy[1466]: segfault at c ip b7fb73ce sp bfee7bd0 error 4 in libsplashy.so.1.0.0[b7fb5000+5000]
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
Adding 1959920k swap on /dev/sda3.  Priority:1 extents:1 across:1959920k
EXT3 FS on sda4, internal journal
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Uniform Multi-Platform E-IDE driver
atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
eth0: no IPv6 routers present
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
Bluetooth: Core ver 2.12
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.10
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
usb usb5: usb auto-resume
usb usb5: wakeup_rh
hub 5-0:1.0: hub_resume
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: usb auto-resume
usb usb4: wakeup_rh
hub 4-0:1.0: hub_resume
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb2: usb auto-resume
usb usb2: wakeup_rh
hub 2-0:1.0: hub_resume
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: usb auto-resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_resume
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb1: usb auto-resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 1-0:1.0: hub_resume
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
powernow: This module only works with AMD K7 CPUs
usb usb5: suspend_rh (auto-stop)
ADDRCONF(NETDEV_UP): ath0: link is not ready
usb usb4: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
usb usb1: usb resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 1-0:1.0: hub_resume
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 4: status 0501 change 0001
hub 1-0:1.0: state 7 ports 8 chg 0010 evt 0000
hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 4 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 4 not reset yet, waiting 50ms
usb usb3: usb resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_resume
uhci_hcd 0000:00:1d.1: port 2 portsc 0093,00
hub 3-0:1.0: port 2: status 0101 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0010
hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
usb 3-2: new full speed USB device using uhci_hcd and address 2
usb 3-2: ep0 maxpacket = 8
usb 3-2: default language 0x0409
usb 3-2: uevent
usb 3-2: usb_probe_device
usb 3-2: configuration #1 chosen from 1 choice
usb 3-2: adding 3-2:1.0 (config #1, interface 0)
usb 3-2:1.0: uevent
hub 3-2:1.0: usb_probe_interface
hub 3-2:1.0: usb_probe_interface - got id
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 4 ports detected
hub 3-2:1.0: standalone hub
hub 3-2:1.0: ganged power switching
hub 3-2:1.0: global over-current protection
hub 3-2:1.0: power on to power good time: 44ms
hub 3-2:1.0: local power source is good
hub 3-2:1.0: no over-current condition exists
hub 3-2:1.0: enabling power on all ports
hub 3-2:1.0: port 2: status 0101 change 0001
uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
drivers/usb/core/inode.c: creating file '002'
usb 3-2: New USB device found, idVendor=058f, idProduct=9254
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: Generic USB Hub
usb 3-2: Manufacturer: ALCOR
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
hub 3-2:1.0: state 7 ports 4 chg 0004 evt 0000
hub 3-2:1.0: port 2, status 0101, change 0000, 12 Mb/s
usb 3-2.2: new full speed USB device using uhci_hcd and address 3
usb 3-2.2: ep0 maxpacket = 8
usb 3-2.2: default language 0x0409
usb 3-2.2: uevent
usb 3-2.2: usb_probe_device
usb 3-2.2: configuration #1 chosen from 1 choice
usb 3-2.2: adding 3-2.2:1.0 (config #1, interface 0)
usb 3-2.2:1.0: uevent
hub 3-2.2:1.0: usb_probe_interface
hub 3-2.2:1.0: usb_probe_interface - got id
hub 3-2.2:1.0: USB hub found
hub 3-2.2:1.0: 4 ports detected
hub 3-2.2:1.0: standalone hub
hub 3-2.2:1.0: individual port power switching
hub 3-2.2:1.0: individual port over-current protection
hub 3-2.2:1.0: power on to power good time: 44ms
hub 3-2.2:1.0: local power source is good
hub 3-2.2:1.0: enabling power on all ports
hub 3-2.2:1.0: port 1: status 0301 change 0001
hub 3-2.2:1.0: port 2: status 0301 change 0001
hub 3-2.2:1.0: port 3: status 0301 change 0001
hub 3-2.2:1.0: port 4: status 0301 change 0001
uhci_hcd 0000:00:1d.1: reserve dev 3 ep81-INT, period 128, phase 0, 12 us
drivers/usb/core/inode.c: creating file '003'
usb 3-2.2: New USB device found, idVendor=058f, idProduct=9254
usb 3-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2.2: Product: Generic USB Hub
usb 3-2.2: Manufacturer: ALCOR
hub 3-2:1.0: state 7 ports 4 chg 0000 evt 0004
hub 3-2.2:1.0: state 7 ports 4 chg 001e evt 0000
hub 3-2.2:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
usb 3-2.2.1: new low speed USB device using uhci_hcd and address 4
usb 3-2.2.1: skipped 1 descriptor after interface
usb 3-2.2.1: skipped 1 descriptor after interface
usb 3-2.2.1: default language 0x0409
usb 3-2.2.1: uevent
usb 3-2.2.1: usb_probe_device
usb 3-2.2.1: configuration #1 chosen from 1 choice
usb 3-2.2.1: adding 3-2.2.1:1.0 (config #1, interface 0)
usb 3-2.2.1:1.0: uevent
usb 3-2.2.1: adding 3-2.2.1:1.1 (config #1, interface 1)
usb 3-2.2.1:1.1: uevent
drivers/usb/core/inode.c: creating file '004'
usb 3-2.2.1: New USB device found, idVendor=0a81, idProduct=0101
usb 3-2.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2.2.1: Product: USB Keyboard
usb 3-2.2.1: Manufacturer: CHESEN
hub 3-2.2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
usb 3-2.2.2: new low speed USB device using uhci_hcd and address 5
usb 3-2.2.2: skipped 1 descriptor after interface
usb 3-2.2.2: skipped 1 descriptor after interface
usb 3-2.2.2: default language 0x0409
usb 3-2.2.2: uevent
usb 3-2.2.2: usb_probe_device
usb 3-2.2.2: configuration #1 chosen from 1 choice
usb 3-2.2.2: adding 3-2.2.2:1.0 (config #1, interface 0)
usb 3-2.2.2:1.0: uevent
usb 3-2.2.2: adding 3-2.2.2:1.1 (config #1, interface 1)
usb 3-2.2.2:1.1: uevent
drivers/usb/core/inode.c: creating file '005'
usb 3-2.2.2: New USB device found, idVendor=0a81, idProduct=0101
usb 3-2.2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2.2.2: Product: USB Keyboard
usb 3-2.2.2: Manufacturer: CHESEN
hub 3-2.2:1.0: port 3, status 0301, change 0000, 1.5 Mb/s
usb 3-2.2.3: new low speed USB device using uhci_hcd and address 6
usb 3-2.2.3: skipped 1 descriptor after interface
usb 3-2.2.3: skipped 1 descriptor after interface
usb 3-2.2.3: default language 0x0409
usb 3-2.2.3: uevent
usb 3-2.2.3: usb_probe_device
usb 3-2.2.3: configuration #1 chosen from 1 choice
usb 3-2.2.3: adding 3-2.2.3:1.0 (config #1, interface 0)
usb 3-2.2.3:1.0: uevent
usb 3-2.2.3: adding 3-2.2.3:1.1 (config #1, interface 1)
usb 3-2.2.3:1.1: uevent
drivers/usb/core/inode.c: creating file '006'
usb 3-2.2.3: New USB device found, idVendor=0a81, idProduct=0101
usb 3-2.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2.2.3: Product: USB Keyboard
usb 3-2.2.3: Manufacturer: CHESEN
hub 3-2.2:1.0: port 4, status 0301, change 0000, 1.5 Mb/s
usb 3-2.2.4: new low speed USB device using uhci_hcd and address 7
usb 3-2.2.4: skipped 1 descriptor after interface
usb 3-2.2.4: skipped 1 descriptor after interface
usb 3-2.2.4: default language 0x0409
usb 3-2.2.4: uevent
usb 3-2.2.4: usb_probe_device
usb 3-2.2.4: configuration #1 chosen from 1 choice
usb 3-2.2.4: adding 3-2.2.4:1.0 (config #1, interface 0)
usb 3-2.2.4:1.0: uevent
usb 3-2.2.4: adding 3-2.2.4:1.1 (config #1, interface 1)
usb 3-2.2.4:1.1: uevent
drivers/usb/core/inode.c: creating file '007'
usb 3-2.2.4: New USB device found, idVendor=0a81, idProduct=0101
usb 3-2.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2.2.4: Product: USB Keyboard
usb 3-2.2.4: Manufacturer: CHESEN
usbcore: registered new interface driver hiddev
usbhid 3-2.2.1:1.0: usb_probe_interface
usbhid 3-2.2.1:1.0: usb_probe_interface - got id
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0008
input: CHESEN USB Keyboard as /class/input/input6
uhci_hcd 0000:00:1d.1: reserve dev 4 ep81-INT, period 8, phase 4, 118 us
input: USB HID v1.10 Keyboard [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.1
usbhid 3-2.2.1:1.1: usb_probe_interface
usbhid 3-2.2.1:1.1: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input7
uhci_hcd 0000:00:1d.1: reserve dev 4 ep82-INT, period 8, phase 4, 118 us
input: USB HID v1.10 Device [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.1
usbhid 3-2.2.2:1.0: usb_probe_interface
usbhid 3-2.2.2:1.0: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input8
uhci_hcd 0000:00:1d.1: reserve dev 5 ep81-INT, period 8, phase 4, 118 us
input: USB HID v1.10 Keyboard [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.2
usbhid 3-2.2.2:1.1: usb_probe_interface
usbhid 3-2.2.2:1.1: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input9
uhci_hcd 0000:00:1d.1: reserve dev 5 ep82-INT, period 8, phase 4, 118 us
input: USB HID v1.10 Device [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.2
usbhid 3-2.2.3:1.0: usb_probe_interface
usbhid 3-2.2.3:1.0: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input10
uhci_hcd 0000:00:1d.1: reserve dev 6 ep81-INT, period 8, phase 4, 118 us
input: USB HID v1.10 Keyboard [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.3
usbhid 3-2.2.3:1.1: usb_probe_interface
usbhid 3-2.2.3:1.1: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input11
uhci_hcd 0000:00:1d.1: reserve dev 6 ep82-INT, period 8, phase 4, 118 us
input: USB HID v1.10 Device [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.3
usbhid 3-2.2.4:1.0: usb_probe_interface
usbhid 3-2.2.4:1.0: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input12
uhci_hcd 0000:00:1d.1: reserve dev 7 ep81-INT, period 8, phase 4, 118 us
input: USB HID v1.10 Keyboard [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.4
usbhid 3-2.2.4:1.1: usb_probe_interface
usbhid 3-2.2.4:1.1: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input13
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
input: USB HID v1.10 Device [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.4
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: release dev 7 ep81-INT, period 8, phase 4, 118 us
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0010
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0010
usb 3-2.2.4: reset low speed USB device using uhci_hcd and address 7
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0010
uhci_hcd 0000:00:1d.1: reserve dev 7 ep82-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
usbhid 3-2.2.4:1.0: forced unbind
usbhid 3-2.2.4:1.0: usb_probe_interface
usbhid 3-2.2.4:1.0: usb_probe_interface - got id
input: CHESEN USB Keyboard as /class/input/input14
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
input: USB HID v1.10 Keyboard [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.4
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: release dev 7 ep82-INT, period 8, phase 4, 118 us
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0010
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0010
usb 3-2.2.4: reset low speed USB device using uhci_hcd and address 7
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0010
hub 3-2.2:1.0: state 7 ports 4 chg 0000 evt 0010
uhci_hcd 0000:00:1d.1: reserve dev 7 ep82-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
usbhid 3-2.2.4:1.0: forced unbind

--Boundary-00=_yjpqI1i811/jqjI
Content-Type: text/plain;
  charset="iso-8859-1";
  name="input-devices.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="input-devices.txt"

I: Bus=0017 Vendor=0001 Product=0001 Version=0100
N: Name="Macintosh mouse button emulation"
P: Phys=
S: Sysfs=/class/input/input0
U: Uniq=
H: Handlers=mouse0 event0 
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/class/input/input1
U: Uniq=
H: Handlers=kbd event1 
B: EV=120013
B: KEY=4 2000000 3803078 f800d001 feffffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

I: Bus=0019 Vendor=0000 Product=0002 Version=0000
N: Name="Power Button (FF)"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/class/input/input2
U: Uniq=
H: Handlers=kbd event2 
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button (CM)"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/class/input/input3
U: Uniq=
H: Handlers=kbd event3 
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=kbd event4 
B: EV=40001
B: SND=6

I: Bus=0011 Vendor=0002 Product=0006 Version=006a
N: Name="ImExPS/2 Logitech Explorer Mouse"
P: Phys=isa0060/serio1/input0
S: Sysfs=/class/input/input5
U: Uniq=
H: Handlers=mouse1 event5 
B: EV=7
B: KEY=1f0000 0 0 0 0 0 0 0 0
B: REL=143

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.1/input0
S: Sysfs=/class/input/input10
U: Uniq=
H: Handlers=kbd event6 
B: EV=120013
B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=1f

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.1/input1
S: Sysfs=/class/input/input11
U: Uniq=
H: Handlers=kbd event7 
B: EV=13
B: KEY=2020000 3878 d801d001 1e0000 0 0 0
B: MSC=10

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.2/input0
S: Sysfs=/class/input/input12
U: Uniq=
H: Handlers=kbd event8 
B: EV=120013
B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=1f

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.2/input1
S: Sysfs=/class/input/input13
U: Uniq=
H: Handlers=kbd event9 
B: EV=13
B: KEY=2020000 3878 d801d001 1e0000 0 0 0
B: MSC=10

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.3/input0
S: Sysfs=/class/input/input14
U: Uniq=
H: Handlers=kbd event10 
B: EV=120013
B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=1f

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.3/input1
S: Sysfs=/class/input/input15
U: Uniq=
H: Handlers=kbd event11 
B: EV=13
B: KEY=2020000 3878 d801d001 1e0000 0 0 0
B: MSC=10

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.4/input1
S: Sysfs=/class/input/input17
U: Uniq=
H: Handlers=kbd event13 
B: EV=13
B: KEY=2020000 3878 d801d001 1e0000 0 0 0
B: MSC=10

I: Bus=0003 Vendor=0a81 Product=0101 Version=0110
N: Name="CHESEN USB Keyboard"
P: Phys=usb-0000:00:1d.3-2.4.4/input0
S: Sysfs=/class/input/input18
U: Uniq=
H: Handlers=kbd event12 
B: EV=120013
B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=1f


--Boundary-00=_yjpqI1i811/jqjI
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lsusb_-v_2.6.22-mepis-smp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsusb_-v_2.6.22-mepis-smp"


Bus 003 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-1-mepis-smp uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 005 Device 007: ID 0a81:0101 Chesen Electronics Corp. Keyboard
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0a81 Chesen Electronics Corp.
  idProduct          0x0101 Keyboard
  bcdDevice            1.10
  iManufacturer           1 CHESEN
  iProduct                2 USB Keyboard
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     102
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 005 Device 006: ID 0a81:0101 Chesen Electronics Corp. Keyboard
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0a81 Chesen Electronics Corp.
  idProduct          0x0101 Keyboard
  bcdDevice            1.10
  iManufacturer           1 CHESEN
  iProduct                2 USB Keyboard
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     102
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 005 Device 005: ID 0a81:0101 Chesen Electronics Corp. Keyboard
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0a81 Chesen Electronics Corp.
  idProduct          0x0101 Keyboard
  bcdDevice            1.10
  iManufacturer           1 CHESEN
  iProduct                2 USB Keyboard
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     102
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 005 Device 004: ID 0a81:0101 Chesen Electronics Corp. Keyboard
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0a81 Chesen Electronics Corp.
  idProduct          0x0101 Keyboard
  bcdDevice            1.10
  iManufacturer           1 CHESEN
  iProduct                2 USB Keyboard
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     102
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 005 Device 003: ID 058f:9254 Alcor Micro Corp. Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0         8
  idVendor           0x058f Alcor Micro Corp.
  idProduct          0x9254 Hub
  bcdDevice            3.12
  iManufacturer           1 ALCOR
  iProduct                2 Generic USB Hub
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x0009
    Per-port power switching
    Per-port overcurrent protection
  bPwrOn2PwrGood       22 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0303 lowspeed power enable connect
   Port 2: 0000.0303 lowspeed power enable connect
   Port 3: 0000.0303 lowspeed power enable connect
   Port 4: 0000.0303 lowspeed power enable connect
Device Status:     0x0001
  Self Powered

Bus 005 Device 002: ID 058f:9254 Alcor Micro Corp. Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0         8
  idVendor           0x058f Alcor Micro Corp.
  idProduct          0x9254 Hub
  bcdDevice            3.12
  iManufacturer           1 ALCOR
  iProduct                2 Generic USB Hub
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x0009
    Per-port power switching
    Per-port overcurrent protection
  bPwrOn2PwrGood       22 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0103 power enable connect
Device Status:     0x0001
  Self Powered

Bus 005 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-1-mepis-smp uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0103 power enable connect
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 004 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-1-mepis-smp uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 002 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-1-mepis-smp uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-1-mepis-smp ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength              11
  bDescriptorType      41
  nNbrPorts             8
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00 0x00
  PortPwrCtrlMask    0xff 0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
   Port 7: 0000.0100 power
   Port 8: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

--Boundary-00=_yjpqI1i811/jqjI--
