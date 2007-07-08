Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXGHIID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXGHIID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 04:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXGHIHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 04:07:48 -0400
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1334 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751610AbXGHIHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 04:07:42 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2007 04:07:41 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-RemoteDnsName: port-212-202-34-50.dynamic.qsc.de
Date: Sun, 8 Jul 2007 07:14:52 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: 2.6.22-rc6-mm1-cfs-v19 Unable to handle kernel NULL pointer
	dereference (reproducable)
Message-ID: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just got this oops while I was updating my system:

Unable to handle kernel NULL pointer dereference at 00000000000002a6 RIP:
 [<ffffffff802861b6>] vfs_permission+0x6/0x10
PGD 120f9067 PUD 4f5ec067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Pid: 14067, comm: touch Not tainted 2.6.22-rc6-mm1-cfs-v19 #7
RIP: 0010:[<ffffffff802861b6>]  [<ffffffff802861b6>] vfs_permission+0x6/0x10
RSP: 0018:ffff8100083a7e20  EFLAGS: 00010293
RAX: 0000000000000296 RBX: 0000000000000000 RCX: ffff81001cb6ee00
RDX: ffff8100083a7e28 RSI: 0000000000000002 RDI: ffff8100083a7e28
RBP: 00000000fffffff3 R08: 0000000000000002 R09: 00002b70e16872b8
R10: 0000000000000000 R11: 0000000000000246 R12: ffff81001cb6ee00
R13: ffff81006396e828 R14: ffff81000c35da28 R15: 0000000000000002
FS:  00002b70e23fbd10(0000) GS:ffffffff8061b000(0000) knlGS:00000000f6ca96c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002a6 CR3: 000000001ca29000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process touch (pid: 14067, threadinfo ffff8100083a6000, task ffff81001c589620)
Stack:  ffffffff802a15e0 0000000000000296 ffffffff8021d9c0 00000000000001b6
 ffff81001cb6ee00 ffff81006396e828 0000000000000000 00002b70e1d66850
 0000000000000004 ffff8100083a7f58 ffff81001c589620 0000000000000000
Call Trace:
 [<ffffffff802a15e0>] do_utimes+0x230/0x250
 [<ffffffff8021d9c0>] do_page_fault+0x420/0x8a0
 [<ffffffff8027ca8a>] do_filp_open+0x3a/0x50
 [<ffffffff802a1707>] sys_utimensat+0x37/0xe0
 [<ffffffff8051bb8d>] error_exit+0x0/0x84
 [<ffffffff8020bc5e>] system_call+0x7e/0x83


Code: 48 8b 78 10 e9 d1 fd ff ff 90 53 48 89 fb 48 8d bf b4 00 00
RIP  [<ffffffff802861b6>] vfs_permission+0x6/0x10
 RSP <ffff8100083a7e20>
CR2: 00000000000002a6

I was running the »paludis« package manager: 

make[1]: Leaving directory `/var/tmp/paludis/sys-libs/gpm-1.20.1-r6/work/gpm-1.20.1/contrib'
>>> Done src_compile
>>> Skipping src_test (SKIP_FUNCTIONS)
>>> Starting builtin_saveenv
>>> Done builtin_saveenv
>>> Completed ebuild phases loadenv unpack compile test saveenv
>>> Running ebuild phases loadenv install saveenv as root:root...
>>> Starting builtin_loadenv
>>> Done builtin_loadenv
>>> Starting src_install
touch src/.depend # to prevent unecessary warnings
make: *** [dep] Killed

Running "touch  /var/tmp/paludis/sys-libs/gpm-1.20.1-r6/work/gpm-1.20.1/src/.depend" 
triggers this oops.

Full dmesg follows:

Linux version 2.6.22-rc6-mm1-cfs-v19 (root@gentoox2.trippelsdorf.de) (gcc version 4.2.0 (Gentoo 4.2.0)) #7 SMP Fri Jul 6 22:08:21 CEST 2007
Command line: root=/dev/sda1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
 BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
 BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524208) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000FA7C0, 0021 (r2 ACPIAM)
ACPI: XSDT 7FFB0100, 003C (r1 A M I  OEMXSDT  11000514 MSFT       97)
ACPI: FACP 7FFB0290, 00F4 (r3 A M I  OEMFACP  11000514 MSFT       97)
ACPI: DSDT 7FFB03F0, 3A3E (r1  A0036 A0036001        1 MSFT  100000D)
ACPI: FACS 7FFC0000, 0040
ACPI: APIC 7FFB0390, 0052 (r1 A M I  OEMAPIC  11000514 MSFT       97)
ACPI: OEMB 7FFC0040, 003F (r1 A M I  OEMBIOS  11000514 MSFT       97)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524208) 1 entries of 256 used
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524208
On node 0 totalpages: 524111
Node 0 memmap at 0xffff810001000000 size 29360128 first pfn 0xffff810001000000
  DMA zone: 56 pages used for memmap
  DMA zone: 1200 pages reserved
  DMA zone: 2743 pages, LIFO batch:0
  DMA32 zone: 7110 pages used for memmap
  DMA32 zone: 513002 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7f780000)
PERCPU: Allocating 22336 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 515745
Kernel command line: root=/dev/sda1
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2400.689 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ e0000000 size 128 MB
Memory: 2059452k/2096832k available (3195k kernel code, 36748k reserved, 1004k data, 220k init)
SLUB: Genslabs=22, HWalign=64, Order=0-3, MinObjects=16, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 4805.13 BogoMIPS (lpj=2402565)
kswapd reclaim order set to 3
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 26k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4800.38 BogoMIPS (lpj=2400193)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 01
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Force enabled HPET at base address 0xfed00000
PCI: enabled onboard AC97/MC97 devices
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  BC, should be BB [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 128M @ 0xe0000000
pnp: 00:05: ioport range 0x680-0x6ff has been reserved
pnp: 00:05: ioport range 0x290-0x297 has been reserved
pnp: 00:07: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: 00:07: iomem range 0xfff80000-0xffffffff could not be reserved
pnp: 00:09: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:09: iomem range 0xc0000-0xdffff has been reserved
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: 00:09: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:09: iomem range 0x100000-0x7ffeffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: fbd00000-fbffffff
  PREFETCH window: e8000000-faffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=240.00 Mhz, System=166.00 MHz
radeonfb: PLL min 20000 max 40000
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 210x65
radeonfb (0000:01:00.0): ATI Radeon Y` 
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /devices/virtual/input/input2
ACPI: Sleep Button (CM) [SLPB]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.27.0 20060524 on minor 0
loop: module loaded
r8169 Gigabit Ethernet driver 2.2LK loaded
ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Disallowing DAC for device 0000:00:0e.0
eth0: RTL8169s/8110s at 0xffffc2000001a000, 00:08:54:36:f2:2f, IRQ 19
sata_via 0000:00:0f.0: version 2.2
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
sata_via 0000:00:0f.0: routed to hard irq line 10
scsi0 : sata_via
scsi1 : sata_via
ata1: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001c402 bmdma 0x000000000001b400 irq 0
ata2: SATA max UDMA/133 cmd 0x000000000001c000 ctl 0x000000000001b802 bmdma 0x000000000001b408 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, max UDMA7
ata1.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD401LJ  ZZ10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
pata_via 0000:00:0f.1: version 0.3.1
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20
scsi2 : pata_via
scsi3 : pata_via
ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001fc00 irq 14
ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001fc08 irq 15
ata4.00: ATAPI: LITE-ON DVDRW SHW-16H5S, LS0R, max UDMA/66
ata4.00: limited to UDMA/33 due to 40-wire cable
ata4.00: configured for UDMA/33
scsi 3:0:0:0: CD-ROM            LITE-ON  DVDRW SHW-16H5S  LS0R PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 21, io mem 0xfbc00000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc6-mm1-cfs-v19 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d000
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc6-mm1-cfs-v19 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d400
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc6-mm1-cfs-v19 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: new device found, idVendor=046a, idProduct=0021
usb 2-1: new device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-1: configuration #1 chosen from 1 choice
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb 3-1: new device found, idVendor=046d, idProduct=c043
usb 3-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: USB-PS/2 Optical Mouse
usb 3-1: Manufacturer: Logitech
usb 3-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
w83627hf: Found W83627THF chip at 0x290
w83627hf w83627hf.656: Reading VID from GPIO5
input: HID 046a:0021 as /devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input3
input: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:10.0-1
input: HID 046a:0021 as /devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.1/input/input4
input: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:10.0-1
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:10.1/usb3/3-1/3-1:1.0/input/input5
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:10.1-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:11.5 to 64
ALSA device list:
  #0: VIA 8237 with ALC850 at 0xd800, irq 22
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
UDF-fs: No VRS found
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 220k freed
XFS mounting filesystem sda4
Ending clean XFS mount for filesystem: sda4
Adding 1959920k swap on /dev/sda2.  Priority:-1 extents:1 across:1959920k
r8169: eth0: link up
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
Unable to handle kernel NULL pointer dereference at 00000000000002a6 RIP: 
 [<ffffffff802861b6>] vfs_permission+0x6/0x10
PGD 120f9067 PUD 4f5ec067 PMD 0 
Oops: 0000 [1] SMP 
CPU 0 
Pid: 14067, comm: touch Not tainted 2.6.22-rc6-mm1-cfs-v19 #7
RIP: 0010:[<ffffffff802861b6>]  [<ffffffff802861b6>] vfs_permission+0x6/0x10
RSP: 0018:ffff8100083a7e20  EFLAGS: 00010293
RAX: 0000000000000296 RBX: 0000000000000000 RCX: ffff81001cb6ee00
RDX: ffff8100083a7e28 RSI: 0000000000000002 RDI: ffff8100083a7e28
RBP: 00000000fffffff3 R08: 0000000000000002 R09: 00002b70e16872b8
R10: 0000000000000000 R11: 0000000000000246 R12: ffff81001cb6ee00
R13: ffff81006396e828 R14: ffff81000c35da28 R15: 0000000000000002
FS:  00002b70e23fbd10(0000) GS:ffffffff8061b000(0000) knlGS:00000000f6ca96c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002a6 CR3: 000000001ca29000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process touch (pid: 14067, threadinfo ffff8100083a6000, task ffff81001c589620)
Stack:  ffffffff802a15e0 0000000000000296 ffffffff8021d9c0 00000000000001b6
 ffff81001cb6ee00 ffff81006396e828 0000000000000000 00002b70e1d66850
 0000000000000004 ffff8100083a7f58 ffff81001c589620 0000000000000000
Call Trace:
 [<ffffffff802a15e0>] do_utimes+0x230/0x250
 [<ffffffff8021d9c0>] do_page_fault+0x420/0x8a0
 [<ffffffff8027ca8a>] do_filp_open+0x3a/0x50
 [<ffffffff802a1707>] sys_utimensat+0x37/0xe0
 [<ffffffff8051bb8d>] error_exit+0x0/0x84
 [<ffffffff8020bc5e>] system_call+0x7e/0x83


Code: 48 8b 78 10 e9 d1 fd ff ff 90 53 48 89 fb 48 8d bf b4 00 00 
RIP  [<ffffffff802861b6>] vfs_permission+0x6/0x10
 RSP <ffff8100083a7e20>
CR2: 00000000000002a6
Unable to handle kernel NULL pointer dereference at 00000000000002a6 RIP: 
 [<ffffffff802861b6>] vfs_permission+0x6/0x10
PGD 7942067 PUD 103d6067 PMD 0 
Oops: 0000 [2] SMP 
CPU 0 
Pid: 15996, comm: touch Tainted: G      D 2.6.22-rc6-mm1-cfs-v19 #7
RIP: 0010:[<ffffffff802861b6>]  [<ffffffff802861b6>] vfs_permission+0x6/0x10
RSP: 0018:ffff8100121ffe20  EFLAGS: 00010293
RAX: 0000000000000296 RBX: 0000000000000000 RCX: ffff8100079b1c00
RDX: ffff8100121ffe28 RSI: 0000000000000002 RDI: ffff8100121ffe28
RBP: 00000000fffffff3 R08: 0000000000000002 R09: 00002b1da7ce32b8
R10: 0000000000000000 R11: 0000000000000246 R12: ffff8100079b1c00
R13: ffff81000e1ba0a8 R14: ffff810012a477d0 R15: 0000000000000002
FS:  00002b1da8a57d10(0000) GS:ffffffff8061b000(0000) knlGS:00000000f6ca96c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002a6 CR3: 000000001c43c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process touch (pid: 15996, threadinfo ffff8100121fe000, task ffff8100068fac40)
Stack:  ffffffff802a15e0 0000000000000296 ffffffff8021d9c0 00000000000001b6
 ffff8100079b1c00 ffff81000e1ba0a8 0000000000000000 00002b1da83c2850
 0000000000000004 ffff8100121fff58 ffff8100068fac40 0000000000000000
Call Trace:
 [<ffffffff802a15e0>] do_utimes+0x230/0x250
 [<ffffffff8021d9c0>] do_page_fault+0x420/0x8a0
 [<ffffffff8027ca8a>] do_filp_open+0x3a/0x50
 [<ffffffff802a1707>] sys_utimensat+0x37/0xe0
 [<ffffffff8051bb8d>] error_exit+0x0/0x84
 [<ffffffff8020bc5e>] system_call+0x7e/0x83


Code: 48 8b 78 10 e9 d1 fd ff ff 90 53 48 89 fb 48 8d bf b4 00 00 
RIP  [<ffffffff802861b6>] vfs_permission+0x6/0x10
 RSP <ffff8100121ffe20>
CR2: 00000000000002a6
Unable to handle kernel NULL pointer dereference at 00000000000002a6 RIP: 
 [<ffffffff802861b6>] vfs_permission+0x6/0x10
PGD 7b5f067 PUD 1a707067 PMD 0 
Oops: 0000 [3] SMP 
CPU 0 
Pid: 16002, comm: touch Tainted: G      D 2.6.22-rc6-mm1-cfs-v19 #7
RIP: 0010:[<ffffffff802861b6>]  [<ffffffff802861b6>] vfs_permission+0x6/0x10
RSP: 0018:ffff8100588ade20  EFLAGS: 00010293
RAX: 0000000000000296 RBX: 0000000000000000 RCX: ffff810019a51f00
RDX: ffff8100588ade28 RSI: 0000000000000002 RDI: ffff8100588ade28
RBP: 00000000fffffff3 R08: 0000000000000002 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000246 R12: ffff810019a51f00
R13: ffff81000e1ba0a8 R14: ffff810012a477d0 R15: 0000000000000002
FS:  00002adda3d7d060(0000) GS:ffffffff8061b000(0000) knlGS:00000000f6ca96c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002a6 CR3: 0000000004b7b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process touch (pid: 16002, threadinfo ffff8100588ac000, task ffff81001c58eea0)
Stack:  ffffffff802a15e0 0000000000000296 ffffffff8021d9c0 00000000000001b6
 ffff810019a51f00 ffff81000e1ba0a8 0000000000000000 00002adda38ec850
 0000000000000004 ffff8100588adf58 ffff81001c58eea0 0000000000000000
Call Trace:
 [<ffffffff802a15e0>] do_utimes+0x230/0x250
 [<ffffffff8021d9c0>] do_page_fault+0x420/0x8a0
 [<ffffffff8027ca8a>] do_filp_open+0x3a/0x50
 [<ffffffff802a1707>] sys_utimensat+0x37/0xe0
 [<ffffffff8051bb8d>] error_exit+0x0/0x84
 [<ffffffff8020bc5e>] system_call+0x7e/0x83


Code: 48 8b 78 10 e9 d1 fd ff ff 90 53 48 89 fb 48 8d bf b4 00 00 
RIP  [<ffffffff802861b6>] vfs_permission+0x6/0x10
 RSP <ffff8100588ade20>
CR2: 00000000000002a6
-- 
Markus
