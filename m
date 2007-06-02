Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXFBUcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXFBUcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 16:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbXFBUc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 16:32:28 -0400
Received: from n8.bullet.re3.yahoo.com ([68.142.237.93]:47443 "HELO
	n8.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754760AbXFBUcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 16:32:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 334767.62016.bm@rrr2.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=X4+FQdwqPIzRKPntFeSSEUjAAnREzL2tOkH7eSadLTFEgYKq26r4aYeJiYnur/ybPIGimhWXXjmNbKRPtAf/lk2KjWNaovgssiVTvQEJZvtB68tL67vEpdbEFXbEasjVIlwWhFleGdnqxt4ktqYVTBO6JlOdzvGu0buZo0Ux+Ow=;
X-YMail-OSG: MGEdhSoVM1lsnMmUnNUUnUsatBzt1HIwhoKUVeL0uZcx5xSvxV3.uPkR.oVLFCjMeKWTsm9A7TjNrj8o.T24dicrpw--
Date: Sat, 2 Jun 2007 13:32:23 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0706020938490.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-338340010-1180816343=:2990"
Content-Transfer-Encoding: 8bit
Message-ID: <105227.2990.qm@web63604.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-338340010-1180816343=:2990
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline


--- Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 2 Jun 2007, Tear wrote:
> > 
> > I own a Dell OptiPlex GX240 which, when ACPI is disabled
> > but IO-APIC is enabled, shows very slow USB performance.
> > I thought that this could be related to IO-APIC and
> > tried to boot with "noapic" appended to the kernel
> > command line. This way the USB transfer speed returned
> > to normal values.
> 
> Well, it's almost certainly not the IO-APIC per se.
> 
> It's more likely to be some irq routing issue, where ACPI fixes up 
> something.  Do you have diffs of 'dmesg' with and without ACPI?
> 
> 		Linus

Mr. Torvalds,

I have tested my system with different kernel command lines
and have ruled out all of the four possibilities. Here's a
matrix which summarizes the situtation. My USB-enabled
digital camera's data transfer rate is as follows:

           | acpi=ht   | acpi=force
~~~~~~~~~~~+~~~~~~~~~~~+~~~~~~~~~~~~
 apic      | very slow | normal
~~~~~~~~~~~+~~~~~~~~~~~+~~~~~~~~~~~~
 noapic    | normal    | normal

"apic" means that an apic related option was NOT
appended to the kernel command line whereas "noapic"
means that "noapic" was appended to the kernel
command line. acpi=ht is the default since Dell
OptiPlex GX240 is in the ACPI blacklist.

By testing carefully, I have concluded that it is IO-APIC
which causes problems when acpi is =ht or =off. This is
why I wrote the IO-APIC blacklist patch.

I am attaching the dmesg output of all of the four cases.
If you would like a diff between any of the four cases,
I would be glad to send one. (The kernel command line
printed by the kernel should help in determining which
dmesg output is which - in addition to the names of
the attachments.)

Thank you for your attention.

Regards,
- Tear




      ____________________________________________________________________________________
Park yourself in front of a world of choices in alternative vehicles. Visit the Yahoo! Auto Green Center.
http://autos.yahoo.com/green_center/ 
--0-338340010-1180816343=:2990
Content-Type: text/plain; name="dmesg-acpi=force-apic.txt"
Content-Description: 301108161-dmesg-acpi=force-apic.txt
Content-Disposition: inline; filename="dmesg-acpi=force-apic.txt"

Linux version 2.6.21.3-smp (root@root) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #20 SMP Sat Jun 2 22:15:56 EEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fe77000 end: 000000003ff77000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003ff77000 size: 0000000000002000 end: 000000003ff79000 type: 4
copy_e820_map() start: 000000003ff79000 size: 0000000000087000 end: 0000000040000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 00000000fee10000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff77000 (usable)
 BIOS-e820: 000000003ff77000 - 000000003ff79000 (ACPI NVS)
 BIOS-e820: 000000003ff79000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 262007) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262007
early_node_map[1] active PFN ranges
    0:        0 ->   262007
On node 0 totalpages: 262007
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32377 pages, LIFO batch:7
DMI 2.3 present.
Warning: acpi=force overrules DMI blacklist: acpi=ht
ACPI: RSDP 000FD560, 0014 (r0 DELL  )
ACPI: RSDT 000FD574, 0034 (r1 DELL    GX240          8 ASL        61)
ACPI: FACP 000FD5A8, 0074 (r1 DELL    GX240          8 ASL        61)
ACPI: DSDT FFFE3C22, 2393 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 3FF77000, 0040
ACPI: SSDT FFFE5FB5, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FD61C, 005C (r1 DELL    GX240          8 ASL        61)
ACPI: BOOT 000FD678, 0028 (r1 DELL    GX240          8 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:0 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists.  Total pages: 259961
Kernel command line: root=/dev/hda8 ro acpi=force
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1694.589 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1029056k/1048028k available (2028k kernel code, 18228k reserved, 921k data, 324k init, 130524k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03e8000 - 0xc0439000   ( 324 kB)
      .data : 0xc02fb289 - 0xc03e1774   ( 921 kB)
      .text : 0xc0100000 - 0xc02fb289   (2028 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3392.50 BogoMIPS (lpj=6785013)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 256K
CPU: Hyper-Threading is disabled
CPU: After all inits, caps: 3febfbff 00000000 00000000 00003080 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 1700MHz stepping 0a
Total of 1 processors activated (3392.50 BogoMIPS).
ENABLING IO-APIC IRQs
...TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbe2e, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0xffffff could not be reserved
pnp: 00:00: iomem range 0x1000000-0x3ff76fff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:0c: ioport range 0x800-0x85f has been reserved
pnp: 00:0c: ioport range 0xc00-0xc7f has been reserved
pnp: 00:0c: ioport range 0x860-0x8ff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: ff800000-ff9fffff
  PREFETCH window: f8000000-fbffffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: ff600000-ff7fffff
  PREFETCH window: 50000000-500fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 5477k freed
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
audit(1180823701.212:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
EISA: Detected 0 cards.
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 324k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ICH2: IDE controller at PCI slot 0000:00:1f.1
ICH2: chipset revision 18
ICH2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: SAMSUNG SP0802N, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 2.20 loaded.
ACPI: PCI Interrupt 0000:02:0c.0[A] -> GSI 18 (level, low) -> IRQ 16
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:02:0c.0: 3Com PCI 3c905C Tornado at f881ac00.
hda: max request size: 512KiB
hda: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 17, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 <<6>ACPI: PCI Interrupt 0000:00:1f.4[C] -> GSI 23 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: UHCI Host Controller
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1f.4: irq 18, io base 0x0000ff60
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
 hda5 hda6 hda7 hda8 hda9 hda10 hda11 >
hdc: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Linux agpgart interface v0.102 (c) Dave Jones
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH2 TCO device (Version=1, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
agpgart: Detected an Intel i845 Chipset.
agpgart: AGP aperture is 64M @ 0xf4000000
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 19
input: PC Speaker as /class/input/input1
Floppy drive(s): fd0 is 1.44M
logips2pp: Detected unknown logitech mouse model 1
FDC 0 is a post-1991 82077
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
input: PS/2 Logitech Mouse as /class/input/input2
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0917
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 52048 usecs
intel8x0: clocking to 41153
EXT3 FS on hda8, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Adding 1052216k swap on /dev/mapper/cryptoswap.  Priority:-1 extents:1 across:1052216k
eth0:  setting full-duplex.
NET: Registered protocol family 17
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
tsdev (compaq touchscreen emulation) is scheduled for removal.
See Documentation/feature-removal-schedule.txt for details.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8187 buckets, 65496 max)
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 20
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
eth0: no IPv6 routers present

--0-338340010-1180816343=:2990
Content-Type: text/plain; name="dmesg-acpi=force-noapic.txt"
Content-Description: 1919115955-dmesg-acpi=force-noapic.txt
Content-Disposition: inline; filename="dmesg-acpi=force-noapic.txt"

Linux version 2.6.21.3-smp (root@root) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #20 SMP Sat Jun 2 22:15:56 EEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fe77000 end: 000000003ff77000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003ff77000 size: 0000000000002000 end: 000000003ff79000 type: 4
copy_e820_map() start: 000000003ff79000 size: 0000000000087000 end: 0000000040000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 00000000fee10000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff77000 (usable)
 BIOS-e820: 000000003ff77000 - 000000003ff79000 (ACPI NVS)
 BIOS-e820: 000000003ff79000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 262007) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262007
early_node_map[1] active PFN ranges
    0:        0 ->   262007
On node 0 totalpages: 262007
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32377 pages, LIFO batch:7
DMI 2.3 present.
Warning: acpi=force overrules DMI blacklist: acpi=ht
ACPI: RSDP 000FD560, 0014 (r0 DELL  )
ACPI: RSDT 000FD574, 0034 (r1 DELL    GX240          8 ASL        61)
ACPI: FACP 000FD5A8, 0074 (r1 DELL    GX240          8 ASL        61)
ACPI: DSDT FFFE3C22, 2393 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 3FF77000, 0040
ACPI: SSDT FFFE5FB5, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FD61C, 005C (r1 DELL    GX240          8 ASL        61)
ACPI: BOOT 000FD678, 0028 (r1 DELL    GX240          8 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:0 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
ACPI: Skipping IOAPIC probe due to 'noapic' option.
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: DELL     Product ID: Opti GX240   APIC at: 0xFEE00000
I/O APIC #1 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists.  Total pages: 259961
Kernel command line: root=/dev/hda8 ro acpi=force noapic
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1694.608 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1029056k/1048028k available (2028k kernel code, 18228k reserved, 921k data, 324k init, 130524k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03e8000 - 0xc0439000   ( 324 kB)
      .data : 0xc02fb289 - 0xc03e1774   ( 921 kB)
      .text : 0xc0100000 - 0xc02fb289   (2028 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3392.49 BogoMIPS (lpj=6784998)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 256K
CPU: Hyper-Threading is disabled
CPU: After all inits, caps: 3febfbff 00000000 00000000 00003080 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0620)
CPU0: Intel(R) Pentium(R) 4 CPU 1700MHz stepping 0a
Total of 1 processors activated (3392.49 BogoMIPS).
Brought up 1 CPUs
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbe2e, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0xffffff could not be reserved
pnp: 00:00: iomem range 0x1000000-0x3ff76fff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:0c: ioport range 0x800-0x85f has been reserved
pnp: 00:0c: ioport range 0xc00-0xc7f has been reserved
pnp: 00:0c: ioport range 0x860-0x8ff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: ff800000-ff9fffff
  PREFETCH window: f8000000-fbffffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: ff600000-ff7fffff
  PREFETCH window: 50000000-500fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 5477k freed
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
audit(1180824002.168:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
EISA: Detected 0 cards.
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 324k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ICH2: IDE controller at PCI slot 0000:00:1f.1
ICH2: chipset revision 18
ICH2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: SAMSUNG SP0802N, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 2.20 loaded.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:02:0c.0[A] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:02:0c.0: 3Com PCI 3c905C Tornado at f881ac00.
hda: max request size: 512KiB
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:1f.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 9, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hda: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 <ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:1f.4[C] -> Link [LNKH] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: UHCI Host Controller
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1f.4: irq 9, io base 0x0000ff60
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
 hda5 hda6 hda7 hda8 hda9 hda10 hda11 >
hdc: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH2 TCO device (Version=1, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel i845 Chipset.
agpgart: AGP aperture is 64M @ 0xf4000000
input: PC Speaker as /class/input/input1
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Floppy drive(s): fd0 is 1.44M
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
FDC 0 is a post-1991 82077
logips2pp: Detected unknown logitech mouse model 1
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0917
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.5 to 64
input: PS/2 Logitech Mouse as /class/input/input2
intel8x0_measure_ac97_clock: measured 52043 usecs
intel8x0: clocking to 41148
EXT3 FS on hda8, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Adding 1052216k swap on /dev/mapper/cryptoswap.  Priority:-1 extents:1 across:1052216k
eth0:  setting full-duplex.
NET: Registered protocol family 17
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
tsdev (compaq touchscreen emulation) is scheduled for removal.
See Documentation/feature-removal-schedule.txt for details.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8187 buckets, 65496 max)
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
eth0: no IPv6 routers present

--0-338340010-1180816343=:2990
Content-Type: text/plain; name="dmesg-acpi=ht-apic.txt"
Content-Description: 1065317838-dmesg-acpi=ht-apic.txt
Content-Disposition: inline; filename="dmesg-acpi=ht-apic.txt"

Linux version 2.6.21.3-smp (root@root) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #20 SMP Sat Jun 2 22:15:56 EEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fe77000 end: 000000003ff77000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003ff77000 size: 0000000000002000 end: 000000003ff79000 type: 4
copy_e820_map() start: 000000003ff79000 size: 0000000000087000 end: 0000000040000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 00000000fee10000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff77000 (usable)
 BIOS-e820: 000000003ff77000 - 000000003ff79000 (ACPI NVS)
 BIOS-e820: 000000003ff79000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 262007) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262007
early_node_map[1] active PFN ranges
    0:        0 ->   262007
On node 0 totalpages: 262007
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32377 pages, LIFO batch:7
DMI 2.3 present.
DELL GX240 detected: force use of acpi=ht
ACPI: RSDP 000FD560, 0014 (r0 DELL  )
ACPI: RSDT 000FD574, 0034 (r1 DELL    GX240          8 ASL        61)
ACPI: FACP 000FD5A8, 0074 (r1 DELL    GX240          8 ASL        61)
ACPI: DSDT FFFE3C22, 2393 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 3FF77000, 0040
ACPI: SSDT FFFE5FB5, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FD61C, 005C (r1 DELL    GX240          8 ASL        61)
ACPI: BOOT 000FD678, 0028 (r1 DELL    GX240          8 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:0 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: DELL     Product ID: Opti GX240   APIC at: 0xFEE00000
I/O APIC #1 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists.  Total pages: 259961
Kernel command line: root=/dev/hda8 ro 
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1694.617 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1029056k/1048028k available (2028k kernel code, 18228k reserved, 921k data, 324k init, 130524k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03e8000 - 0xc0439000   ( 324 kB)
      .data : 0xc02fb289 - 0xc03e1774   ( 921 kB)
      .text : 0xc0100000 - 0xc02fb289   (2028 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3392.48 BogoMIPS (lpj=6784970)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 256K
CPU: Hyper-Threading is disabled
CPU: After all inits, caps: 3febfbff 00000000 00000000 00003080 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
CPU0: Intel(R) Pentium(R) 4 CPU 1700MHz stepping 0a
Total of 1 processors activated (3392.48 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
...TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
Brought up 1 CPUs
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 2.10 entry at 0xfbe2e, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fe2d0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xe2f4, dseg 0x40
PnPBIOS: 17 nodes reported by PnP BIOS; 17 recorded by driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2440] at 0000:00:1f.0
PCI->APIC IRQ transform: 0000:00:1f.2[D] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1f.3[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:1f.4[C] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:1f.5[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:02:08.0[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:02:0c.0[A] -> IRQ 18
NET: Registered protocol family 8
NET: Registered protocol family 20
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:00: ioport range 0x800-0x8df could not be reserved
pnp: 00:00: ioport range 0xc00-0xc7f has been reserved
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x3ff76fff could not be reserved
pnp: 00:00: iomem range 0xffb00000-0xffffffff could not be reserved
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:0f: iomem range 0x3ff77000-0x3fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: ff800000-ff9fffff
  PREFETCH window: f8000000-fbffffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: ff600000-ff7fffff
  PREFETCH window: 50000000-500fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 5477k freed
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
audit(1180823164.068:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:01: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:02: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
EISA: Detected 0 cards.
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 324k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ICH2: IDE controller at PCI slot 0000:00:1f.1
ICH2: chipset revision 18
ICH2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: SAMSUNG SP0802N, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 2.20 loaded.
thermal: Unknown symbol acpi_processor_set_thermal_limit
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 19, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: UHCI Host Controller
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1f.4: irq 18, io base 0x0000ff60
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hda: max request size: 512KiB
hda: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda:3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:02:0c.0: 3Com PCI 3c905C Tornado at f880cc00.
 hda1 hda2 hda3 hda4 <<6>usb 1-1: new full speed USB device using uhci_hcd and address 2
 hda5 hda6 hda7 hda8 hda9<6>usb 1-1: configuration #1 chosen from 1 choice
 hda10 hda11 >
hdc: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH2 TCO device (Version=1, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel i845 Chipset.
agpgart: AGP aperture is 64M @ 0xf4000000
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input1
logips2pp: Detected unknown logitech mouse model 1
Floppy drive(s): fd0 is 1.44M
input: PS/2 Logitech Mouse as /class/input/input2
FDC 0 is a post-1991 82077
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0917
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 52045 usecs
intel8x0: clocking to 41150
EXT3 FS on hda8, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Adding 1052216k swap on /dev/mapper/cryptoswap.  Priority:-1 extents:1 across:1052216k
eth0:  setting full-duplex.
NET: Registered protocol family 17
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
tsdev (compaq touchscreen emulation) is scheduled for removal.
See Documentation/feature-removal-schedule.txt for details.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
ip_tables: (C) 2000-2006 Netfilter Core Team
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8187 buckets, 65496 max)
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
eth0: no IPv6 routers present

--0-338340010-1180816343=:2990
Content-Type: text/plain; name="dmesg-acpi=ht-noapic.txt"
Content-Description: 331973418-dmesg-acpi=ht-noapic.txt
Content-Disposition: inline; filename="dmesg-acpi=ht-noapic.txt"

Linux version 2.6.21.3-smp (root@root) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #20 SMP Sat Jun 2 22:15:56 EEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fe77000 end: 000000003ff77000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003ff77000 size: 0000000000002000 end: 000000003ff79000 type: 4
copy_e820_map() start: 000000003ff79000 size: 0000000000087000 end: 0000000040000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 00000000fee10000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff77000 (usable)
 BIOS-e820: 000000003ff77000 - 000000003ff79000 (ACPI NVS)
 BIOS-e820: 000000003ff79000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 262007) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262007
early_node_map[1] active PFN ranges
    0:        0 ->   262007
On node 0 totalpages: 262007
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32377 pages, LIFO batch:7
DMI 2.3 present.
DELL GX240 detected: force use of acpi=ht
ACPI: RSDP 000FD560, 0014 (r0 DELL  )
ACPI: RSDT 000FD574, 0034 (r1 DELL    GX240          8 ASL        61)
ACPI: FACP 000FD5A8, 0074 (r1 DELL    GX240          8 ASL        61)
ACPI: DSDT FFFE3C22, 2393 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 3FF77000, 0040
ACPI: SSDT FFFE5FB5, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FD61C, 005C (r1 DELL    GX240          8 ASL        61)
ACPI: BOOT 000FD678, 0028 (r1 DELL    GX240          8 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:0 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: DELL     Product ID: Opti GX240   APIC at: 0xFEE00000
I/O APIC #1 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists.  Total pages: 259961
Kernel command line: root=/dev/hda8 ro noapic
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1694.601 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1029056k/1048028k available (2028k kernel code, 18228k reserved, 921k data, 324k init, 130524k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03e8000 - 0xc0439000   ( 324 kB)
      .data : 0xc02fb289 - 0xc03e1774   ( 921 kB)
      .text : 0xc0100000 - 0xc02fb289   (2028 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3392.49 BogoMIPS (lpj=6784989)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 256K
CPU: Hyper-Threading is disabled
CPU: After all inits, caps: 3febfbff 00000000 00000000 00003080 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
CPU0: Intel(R) Pentium(R) 4 CPU 1700MHz stepping 0a
Total of 1 processors activated (3392.49 BogoMIPS).
Brought up 1 CPUs
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 2.10 entry at 0xfbe2e, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fe2d0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xe2f4, dseg 0x40
PnPBIOS: 17 nodes reported by PnP BIOS; 17 recorded by driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2440] at 0000:00:1f.0
NET: Registered protocol family 8
NET: Registered protocol family 20
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:00: ioport range 0x800-0x8df could not be reserved
pnp: 00:00: ioport range 0xc00-0xc7f has been reserved
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x3ff76fff could not be reserved
pnp: 00:00: iomem range 0xffb00000-0xffffffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:0f: iomem range 0x3ff77000-0x3fffffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: ff800000-ff9fffff
  PREFETCH window: f8000000-fbffffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: ff600000-ff7fffff
  PREFETCH window: 50000000-500fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 5477k freed
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
audit(1180823484.028:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:01: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:02: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
EISA: Detected 0 cards.
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 324k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ICH2: IDE controller at PCI slot 0000:00:1f.1
ICH2: chipset revision 18
ICH2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: SAMSUNG SP0802N, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 2.20 loaded.
thermal: Unknown symbol acpi_processor_set_thermal_limit
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
PCI: setting IRQ 9 as level-triggered
PCI: Found IRQ 9 for device 0000:00:1f.2
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 9, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hda: max request size: 512KiB
PCI: Found IRQ 9 for device 0000:00:1f.4
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: UHCI Host Controller
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1f.4: irq 9, io base 0x0000ff60
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hda: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda:<6>PCI: Found IRQ 9 for device 0000:02:0c.0
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:02:0c.0: 3Com PCI 3c905C Tornado at f880cc00.
 hda1 hda2 hda3 hda4 <<6>usb 1-1: new full speed USB device using uhci_hcd and address 2
 hda5 hda6 hda7 hda8<6>usb 1-1: configuration #1 chosen from 1 choice
 hda9 hda10 hda11 >
hdc: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel i845 Chipset.
agpgart: AGP aperture is 64M @ 0xf4000000
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:02:08.0
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH2 TCO device (Version=1, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Floppy drive(s): fd0 is 1.44M
input: PC Speaker as /class/input/input1
FDC 0 is a post-1991 82077
intel_rng: FWH not detected
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0917
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
logips2pp: Detected unknown logitech mouse model 1
input: PS/2 Logitech Mouse as /class/input/input2
PCI: Found IRQ 10 for device 0000:00:1f.5
PCI: Sharing IRQ 10 with 0000:00:1f.3
PCI: Sharing IRQ 10 with 0000:02:08.0
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 52021 usecs
intel8x0: clocking to 41159
EXT3 FS on hda8, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Adding 1052216k swap on /dev/mapper/cryptoswap.  Priority:-1 extents:1 across:1052216k
eth0:  setting full-duplex.
NET: Registered protocol family 17
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
tsdev (compaq touchscreen emulation) is scheduled for removal.
See Documentation/feature-removal-schedule.txt for details.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8187 buckets, 65496 max)
[drm] Initialized drm 1.1.0 20060810
PCI: setting IRQ 5 as level-triggered
PCI: Found IRQ 5 for device 0000:01:00.0
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
eth0: no IPv6 routers present

--0-338340010-1180816343=:2990--

