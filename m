Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYDNATR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYDNATR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYDNATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:19:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYDNATB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:19:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: x86 git tree broken (bisected)
Date: Mon, 14 Apr 2008 02:19:06 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
References: <200804102159.14563.rjw@sisk.pl> <200804140010.01034.rjw@sisk.pl> <86802c440804131532g4626233br82a425d6a96a6e11@mail.gmail.com>
In-Reply-To: <86802c440804131532g4626233br82a425d6a96a6e11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7LqAIuGKAUzXIX6"
Message-Id: <200804140219.07350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7LqAIuGKAUzXIX6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, 14 of April 2008, Yinghai Lu wrote:
> On Sun, Apr 13, 2008 at 3:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > On Monday, 14 of April 2008, Yinghai Lu wrote:
> >  > On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >  > ...
> >  > >  > can you try to apply the patch i sent to you about agp bridge order
> >  > >  > reading for buggy silicon?
> >  > >  >
> >  > >  > Please boot kernel with "debug"...
> >  > >  >
> >  > >  > I want to verify if you can get
> >  > >  >
> >  > >  > "
> >  > >  > Aperture conflicts with PCI mapping.
> >  > >  > "
> >  > >  >
> >  > >  > in your boot log...
> >  > >
> >  > >  It's not present in there:
> >  > >
> >  > >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
> >  > >  Aperture too small (32 MB)
> >  > >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
> >  > >  Aperture too small (0 MB)
> >  > >  agpgart: Aperture pointing to RAM
> >  > >  agpgart: Aperture from AGP @ de000000 size 4096 MB
> >  > >  agpgart: Aperture too small (0 MB)
> >  > >
> >  > >  Full dmesg output attached.
> >  >
> >  > please check attached debug patch. and check if you can change GART
> >  > size in your BIOS setup to 64M instead of 32M
> >
> >  Hm, what tree am I supposed to apply it too:
> >  (1) current x86 git
> >  (2) current x86 git w/ some of your previous patches (which ones in this case)
> >  (3) failing (old) x86 git
> >  (4) failing (old) x86 git w/ some of your previous patches (which ones in this
> >     case)?
> 
> (1) current x86.git

Attached is dmesg output from current x86.git with debug_gart_checking.patch
applied.

Thanks,
Rafael

--Boundary-00=_7LqAIuGKAUzXIX6
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg.log"

Linux version 2.6.25-rc9-x86-latest.git (rafael@chimera) (gcc version 4.2.1 (SUSE Linux)) #27 SMP Mon Apr 14 02:30:28 CEST 2008
Command line: root=/dev/md1 vga=0x31a resume=/dev/sda2 debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
 BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
 BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 524208) 1 entries of 256 used
max_pfn_mapped = 1048576
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
DMI 2.3 present.
ACPI: RSDP 000F9B60, 0014 (r0 ACPIAM)
ACPI: RSDT 7FFB0000, 0030 (r1 A M I  OEMRSDT   8000526 MSFT       97)
ACPI: FACP 7FFB0200, 0084 (r2 A M I  OEMFACP   8000526 MSFT       97)
ACPI: DSDT 7FFB0400, 45A7 (r1  939M2 939M2120      120 INTL  2002026)
ACPI: FACS 7FFC0000, 0040
ACPI: APIC 7FFB0390, 0068 (r1 A M I  OEMAPIC   8000526 MSFT       97)
ACPI: OEMB 7FFC0040, 0056 (r1 A M I  AMI_OEM   8000526 MSFT       97)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 524208) 1 entries of 256 used
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-b36c6f] TEXT DATA BSS
  early res: 3 [378e2000-37fefd18] RAMDISK
  early res: 4 [9ec00-fffff] BIOS reserved
  early res: 5 [8000-bfff] PGTABLE
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      158
    0:      256 ->   524208
On node 0 totalpages: 524110
  DMA zone: 56 pages used for memmap
  DMA zone: 2464 pages reserved
  DMA zone: 1478 pages, LIFO batch:0
  DMA32 zone: 7110 pages used for memmap
  DMA32 zone: 513002 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 0, address 0xfec10000, GSI 24-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:7f7c0000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 31152 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514480
Kernel command line: root=/dev/md1 vga=0x31a resume=/dev/sda2 debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2200.078 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 2688 bytes
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
Node 0: aperture @ de000000 size 32 MB
Memory: 2047076k/2096832k available (2987k kernel code, 48712k reserved, 1657k data, 288k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 4404.14 BogoMIPS (lpj=8808291)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Using local APIC timer interrupts.
APIC timer calibration result 12500446
Detected 12.500 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4400.17 BogoMIPS (lpj=8800349)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Brought up 2 CPUs
Total of 2 processors activated (8804.32 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
khelper used greatest stack depth: 5752 bytes left
net_namespace: 1112 bytes
Time:  0:34:49  Date: 04/14/08
NET: Registered protocol family 16
No dock devices found.
node 0 link 0: io port [1000, ffffff]
TOM: 0000000080000000 aka 2048M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [80000000, ffffffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [1000, ffffff]
bus: 00 index 1 io port: [0, ffff]
bus: 00 index 2 mmio: [80000000, fcffffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [80000000, ffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
Overlap at 0x7ffc0000-0x7ffc1000
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.1: quirk: region 0800-083f claimed by ali7101 ACPI
PCI: Transparent bridge - 0000:00:06.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HTT_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15), disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Overlap at 0x7ffb0000-0x7ffb5000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffc0000-0x7ffc1000
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  6A, should be 5D [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:04.0
DMAR:parse DMAR table failure.
agpgart: Detected AGP bridge 20
Setting up ULi AGP.
agpgart: AGP aperture is 32M @ 0xde000000
system 00:07: ioport range 0x480-0x48f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x800-0x87f could not be reserved
system 00:07: ioport range 0x400-0x40f has been reserved
system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:08: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:08: iomem range 0xe0000000-0xefffffff has been reserved
system 00:08: iomem range 0xfec10000-0xfec10fff has been reserved
system 00:08: iomem range 0xffb80000-0xffffffff could not be reserved
system 00:0c: ioport range 0x290-0x29f has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
system 00:0d: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 9000-bfff
  MEM window: 0xff200000-0xff2fffff
  PREFETCH window: 0x00000000cbf00000-0x00000000dbefffff
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: 0xff300000-0xff3fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: 0xff400000-0xff4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: c000-cfff
  MEM window: 0xff500000-0xff5fffff
  PREFETCH window: 0x0000000088000000-0x00000000880fffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 29 (level, low) -> IRQ 29
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 34 (level, low) -> IRQ 34
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
NET: Registered protocol family 2
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 7223k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1208133289.004:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000080000, using 5120k, total 16384k
vesafb: mode is 1280x1024x16, linelength=2560, pages=5
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
loop: module loaded
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
logips2pp: Detected unknown logitech mouse model 127
input: ImExPS/2 Logitech Explorer Mouse as /class/input/input2
md: multipath personality registered for level -4
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 33
PM: Resume from partition /dev/sda2
PM: Checking hibernation image.
PM: Error -6 checking image file
PM: Resume from disk failed.
  Magic number: 4:65:557
  hash matches device ptya3
  hash matches device PNP0C0F:08
Freeing unused kernel memory: 288k freed
Write protecting the kernel read-only data: 4360k
mount used greatest stack depth: 5592 bytes left
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 19 (level, low) -> IRQ 19
scsi0 : pata_ali
scsi1 : pata_ali
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
ata1.00: ATAPI: TSSTcorpCD/DVDW SH-S182M, SB03, max UDMA/33
ata1.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled
ata1.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
ata1.00: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182M SB03 PQ: 0 ANSI: 5
modprobe used greatest stack depth: 4760 bytes left
sata_uli 0000:00:12.1: version 1.3
ACPI: PCI Interrupt 0000:00:12.1[A] -> GSI 19 (level, low) -> IRQ 19
scsi2 : sata_uli
scsi3 : sata_uli
ata3: SATA max UDMA/133 cmd 0xec00 ctl 0xe080 bmdma 0xd880 irq 19
ata4: SATA max UDMA/133 cmd 0xe000 ctl 0xdc00 bmdma 0xd888 irq 19
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: ATA-7: SAMSUNG HD160JJ, WU100-33, max UDMA7
ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: ATA-7: SAMSUNG SP2004C, VM100-50, max UDMA7
ata4.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD160JJ  WU10 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG SP2004C  VM10 PQ: 0 ANSI: 5
md: raid1 personality registered for level 1
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Driver 'sd' needs updating - please use bus_type methods
sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
ohci_hcd 0000:00:13.0: irq 20, io mem 0xff6fd000
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6<6>usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
 sda7 sda8 sda9 >
sd 2:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5<6>usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-rc9-x86-latest.git ohci_hcd
 sdb6<6>usb usb1: SerialNumber: 0000:00:13.0
ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 21 (level, low) -> IRQ 21
 sdb7<6>ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
 sdb8<6>ohci_hcd 0000:00:13.1: irq 21, io mem 0xff6fc000
 sdb9 sdb10 >
sd 3:0:0:0: [sdb] Attached SCSI disk
modprobe used greatest stack depth: 4408 bytes left
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-rc9-x86-latest.git ohci_hcd
usb usb2: SerialNumber: 0000:00:13.1
ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.2: irq 22, io mem 0xff6fb000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25-rc9-x86-latest.git ohci_hcd
usb usb3: SerialNumber: 0000:00:13.2
ACPI: PCI Interrupt 0000:00:13.3[D] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:13.3: EHCI Host Controller
ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:13.3: debug port 1
ehci_hcd 0000:00:13.3: irq 23, io mem 0xff6fe800
ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 8 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: EHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25-rc9-x86-latest.git ehci_hcd
usb usb4: SerialNumber: 0000:00:13.3
md: raid0 personality registered for level 0
xor: automatically using best checksumming function: generic_sse
   generic_sse:  7022.000 MB/sec
xor: using function: generic_sse (7022.000 MB/sec)
async_tx: api initialized (sync-only)
raid6: int64x1   2162 MB/s
raid6: int64x2   2731 MB/s
raid6: int64x4   2371 MB/s
raid6: int64x8   2186 MB/s
raid6: sse2x1    2362 MB/s
raid6: sse2x2    3363 MB/s
raid6: sse2x4    3777 MB/s
raid6: using algorithm sse2x4 (3777 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: md1 stopped.
md: bind<sda3>
md: bind<sdb3>
raid1: raid set md1 active with 2 out of 2 mirrors
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Basic memory bitmaps freed
PM: Starting manual resume from disk
PM: Resume from partition 8:2
PM: Checking hibernation image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
mount used greatest stack depth: 3712 bytes left
scsi 0:0:0:0: Attached scsi generic sg0 type 5
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 3:0:0:0: Attached scsi generic sg2 type 0
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 17 (level, low) -> IRQ 17
eth0: ULi M5263 at pci0000:00:11.0, 00:13:8f:3a:0b:96, irq 17.
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 21 (level, low) -> IRQ 21
Driver 'sr' needs updating - please use bus_type methods
eth1: RealTek RTL8139 at 0xc800, 00:48:54:4b:5c:38, IRQ 21
eth1:  Identified 8139 chip type 'RTL-8139A'
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
udev: renamed network interface eth1 to eth0
udev: renamed network interface eth0_rename to eth1
ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 18 (level, low) -> IRQ 18
ALSA /home/rafael/src/linux-2.6-x86/sound/pci/ac97/ac97_codec.c:2053: AC'97 1 does not respond - RESET
ALSA /home/rafael/src/linux-2.6-x86/sound/pci/ac97/ac97_codec.c:2062: AC'97 1 access is not valid [0xffffffff], removing mixer.
ALSA /home/rafael/src/linux-2.6-x86/sound/pci/intel8x0.c:2157: Unable to initialize codec #1
intel8x0_measure_ac97_clock: measured 51331 usecs
intel8x0: clocking to 48000
md: md2 stopped.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
md: bind<sda5>
md: bind<sdb5>
raid1: raid set md2 active with 2 out of 2 mirrors
md: md3 stopped.
md: bind<sda6>
md: bind<sdb6>
raid1: raid set md3 active with 2 out of 2 mirrors
md: md4 stopped.
md: bind<sda8>
md: bind<sdb8>
raid1: raid set md4 active with 2 out of 2 mirrors
md: md5 stopped.
md: bind<sda9>
md: bind<sdb9>
raid1: raid set md5 active with 2 out of 2 mirrors
md: md0 stopped.
md: bind<sda1>
md: bind<sdb1>
raid1: raid set md0 active with 2 out of 2 mirrors
fsck.ext3 used greatest stack depth: 3432 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: md4: found reiserfs format "3.6" with standard journal
ReiserFS: md4: using ordered data mode
ReiserFS: md4: journal params: device md4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: md4: checking transaction log (md4)
ReiserFS: md4: Using r5 hash to sort names
ReiserFS: md5: found reiserfs format "3.6" with standard journal
ReiserFS: md5: using ordered data mode
ReiserFS: md5: journal params: device md5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: md5: checking transaction log (md5)
ReiserFS: md5: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2104504k swap on /dev/sda2.  Priority:42 extents:1 across:2104504k
Adding 2104504k swap on /dev/sdb2.  Priority:42 extents:1 across:2104504k
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0xa
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0xa
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffc0000-0x7ffc1000
Overlap at 0x7ffc0000-0x7ffc1000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffb0000-0x7ffb1000
Overlap at 0x7ffc0000-0x7ffc1000
Overlap at 0x7ffc0000-0x7ffc1000
Overlap at 0xd0000000-0xd0500000
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
ip6_tables: (C) 2000-2006 Netfilter Core Team
Overlap at 0xd0000000-0xd8000000
Overlap at 0xff2f0000-0xff300000
ip_tables: (C) 2000-2006 Netfilter Core Team
uli526x: eth1 NIC Link is Up 100 Mbps Full duplex
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
warning: `named' uses 32-bit capabilities (legacy support in use)
Overlap at 0xd0000000-0xd8000000
Overlap at 0xff2f0000-0xff300000
Clocksource tsc unstable (delta = -90815050 ns)
eth1: no IPv6 routers present
Overlap at 0xd0000000-0xd8000000
Overlap at 0xff2f0000-0xff300000
Overlap at 0xd0000000-0xd8000000
Overlap at 0xff2f0000-0xff300000
Overlap at 0xd0000000-0xd8000000
Overlap at 0xff2f0000-0xff300000
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1

--Boundary-00=_7LqAIuGKAUzXIX6--
