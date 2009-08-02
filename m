Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZHBNYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZHBNYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZHBNYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:24:07 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53877 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZHBNYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vL1zde3QU5R7EoJ5/yomJCFeSitJ85LCVP84sOoOc48NdgXU6ACov05yfvtDyULTIm
         soDHIoK5dZE4Z4QzOYX0htBRcs3Y6uOEnsReQxi6PGGByCp991uLsm43mhvsn7cr8DhF
         YvBiKSlAfn8Mm5kBCBY/kumXvpig+S9LctBaI=
MIME-Version: 1.0
In-Reply-To: <20090802115826.0174f292@lxorguk.ukuu.org.uk>
References: <h51hro$p6j$1@ger.gmane.org> <4A748A48.8020702@gmail.com>
	 <cdb43e8a0908011544o69c2203dv39ce5a04840e0869@mail.gmail.com>
	 <20090802115826.0174f292@lxorguk.ukuu.org.uk>
Date: Sun, 2 Aug 2009 08:24:03 -0500
X-Google-Sender-Auth: d22d236e8b23da67
Message-ID: <cdb43e8a0908020624u68c91fc2vbc73eeada01af778@mail.gmail.com>
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
From: Jack Byer <ojbyer@usa.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockrwd@gmail.com>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You should see nearer 200K/sec (PIO 0) but if the device IRQ is being
> lost due to misrouting then the device is being polled off the timer tick
> and that will drastically reduce performance.
>
> So its a firmware/acpi/irq sort of problem not an IDE one. Try running
> with acpi=off and without irqpoll just as a test.
>

Linux version 2.6.31-rc4 (root@lithium) (gcc version 4.3.2 (Gentoo
4.3.2-r3 p1.6, pie-10.1.5) ) #2 PREEMPT Fri Jul 31 23:25:25 CDT 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003bef0000 (usable)
 BIOS-e820: 000000003bef0000 - 000000003beff000 (ACPI data)
 BIOS-e820: 000000003beff000 - 000000003bf00000 (ACPI NVS)
 BIOS-e820: 000000003bf00000 - 000000003c000000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
DMI 2.3 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x3bef0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DAFFF uncachable
  DB000-DBFFF write-protect
  DC000-DFFFF write-back
  E0000-E3FFF uncachable
  E4000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FE0000000 write-back
  1 base 020000000 mask FF0000000 write-back
  2 base 030000000 mask FF8000000 write-back
  3 base 038000000 mask FFC000000 write-back
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009f800 (usable)
 modified: 000000000009f800 - 00000000000a0000 (reserved)
 modified: 00000000000d0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000003bef0000 (usable)
 modified: 000000003bef0000 - 000000003beff000 (ACPI data)
 modified: 000000003beff000 - 000000003bf00000 (ACPI NVS)
 modified: 000000003bf00000 - 000000003c000000 (reserved)
 modified: 00000000fffc0000 - 0000000100000000 (reserved)
initial memory mapped : 0 - 01800000
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 10000-15000
RAMDISK: 37457000 - 37fefed9
Allocated new RAMDISK: 00100000 - 00c98ed9
Move RAMDISK from 0000000037457000 - 0000000037fefed8 to 00100000 - 00c98ed8
70MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
  node 0 low ram: 00000000 - 377fe000
  node 0 bootmap 00011000 - 00017f00
(7 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 00014bd4e0]    TEXT DATA BSS ==> [0001000000 - 00014bd4e0]
  #2 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #3 [00014be000 - 00014c4234]              BRK ==> [00014be000 - 00014c4234]
  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #5 [0000100000 - 0000c98ed9]      NEW RAMDISK ==> [0000100000 - 0000c98ed9]
  #6 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003bef0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003bef0
On node 0 totalpages: 245375
free_area_init_node: node 0, pgdat c134bf80, node_mem_map c14c5200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 142 pages used for memmap
  HighMem zone: 18020 pages, LIFO batch:3
Using APIC driver default
Local APIC disabled by BIOS -- you can enable it with "lapic"
APIC: disable apic facility
nr_irqs_gsi: 16
Allocating PCI resources starting at 3c000000 (gap: 3c000000:c3fc0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243457
Kernel command line: acpi=off
PID hash table entries: 4096 (order: 12, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0003bef0)
Memory: 955996k/981952k available (2484k kernel code, 25244k reserved,
922k data, 288k init, 72648k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1356000 - 0xc139e000   ( 288 kB)
      .data : 0xc126d355 - 0xc1353c98   ( 922 kB)
      .text : 0xc1000000 - 0xc126d355   (2484 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:288
Fast TSC calibration using PIT
Detected 1788.896 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Calibrating delay loop (skipped), value calculated using timer
frequency.. 3579.86 BogoMIPS (lpj=5962986)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
mce: CPU supports 4 MCE banks
CPU: mobile AMD Athlon(tm) XP2400+ stepping 00
Checking 'hlt' instruction... OK.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd87b, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xd4000000-0xd7ffffff]
pci 0000:00:00.0: reg 14 32bit mmio: [0xd0500000-0xd0500fff]
pci 0000:00:00.0: reg 18 io port: [0x8090-0x8093]
pci 0000:00:02.0: reg 10 32bit mmio: [0xd0006000-0xd0006fff]
pci 0000:00:02.0: PME# supported from D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:06.0: reg 10 io port: [0x8400-0x84ff]
pci 0000:00:06.0: reg 14 32bit mmio: [0xd0007000-0xd0007fff]
pci 0000:00:06.0: supports D1 D2
pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:08.0: reg 10 32bit mmio: [0xd0008000-0xd0008fff]
pci 0000:00:08.0: reg 14 io port: [0x8800-0x88ff]
pci 0000:00:08.0: PME# supported from D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:09.0: reg 10 32bit mmio: [0xd0004000-0xd0005fff]
pci 0000:00:09.0: supports D1 D2
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: reg 10 32bit mmio: [0x80000000-0x80000fff]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0c.0: reg 10 32bit mmio: [0xd0009000-0xd00097ff]
pci 0000:00:0c.0: reg 14 32bit mmio: [0xd0000000-0xd0003fff]
pci 0000:00:0c.0: supports D1 D2
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:0c.0: PME# disabled
pci 0000:00:10.0: reg 20 io port: [0x8080-0x808f]
pci 0000:00:11.0: quirk: region 8000-803f claimed by ali7101 ACPI
pci 0000:00:11.0: quirk: region 8040-805f claimed by ali7101 SMB
pci 0000:00:12.0: reg 10 io port: [0x8c00-0x8cff]
pci 0000:00:12.0: reg 14 32bit mmio: [0xd000a000-0xd000afff]
pci 0000:00:12.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:00:12.0: supports D1 D2
pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
pci 0000:01:05.0: reg 10 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:01:05.0: reg 14 io port: [0x9000-0x90ff]
pci 0000:01:05.0: reg 18 32bit mmio: [0xd0100000-0xd010ffff]
pci 0000:01:05.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xd0100000-0xd01fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:00:07.0: ALI IRQ router [10b9:1533]
cfg80211: Calling CRDA to update world regulatory domain
pnp: PnP ACPI: disabled
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xd0100000-0xd01fffff
pci 0000:00:01.0:   PREFETCH window: 0xe0000000-0xefffffff
pci 0000:00:0a.0: CardBus bridge, secondary bus 0000:02
pci 0000:00:0a.0:   IO window: 0x001000-0x0010ff
pci 0000:00:0a.0:   IO window: 0x001400-0x0014ff
pci 0000:00:0a.0:   PREFETCH window: 0x3c000000-0x3fffffff
pci 0000:00:0a.0:   MEM window: 0x40000000-0x43ffffff
pci 0000:00:0a.0: IRQ 5 doesn't match PIRQ mask 0x880; try pci=usepirqmask
PCI: setting IRQ 11 as level-triggered
pci 0000:00:0a.0: found PCI INT A -> IRQ 11
pci 0000:00:0a.0: IRQ routing conflict: have IRQ 5, want IRQ 11
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:01: resource 1 mem: [0xd0100000-0xd01fffff]
pci_bus 0000:01: resource 2 pref mem [0xe0000000-0xefffffff]
pci_bus 0000:02: resource 0 io:  [0x1000-0x10ff]
pci_bus 0000:02: resource 1 io:  [0x1400-0x14ff]
pci_bus 0000:02: resource 2 pref mem [0x3c000000-0x3fffffff]
pci_bus 0000:02: resource 3 mem: [0x40000000-0x43ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 11875k freed
platform rtc_cmos: registered platform RTC device (no PNP device found)
Scanning for low memory corruption every 60 seconds
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
msgmni has been set to 1748
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:00.0: ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb
pci 0000:00:07.0: Activating ISA DMA hang workarounds
pci 0000:01:05.0: Boot video device
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Platform driver 'serial8250' needs updating - please use dev_pm_ops
PCI: setting IRQ 3 as level-triggered
serial 0000:00:08.0: found PCI INT A -> IRQ 3
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
116x: driver isp116x-hcd, 03 Nov 2005
Platform driver 'isp116x-hcd' needs updating - please use dev_pm_ops
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: setting IRQ 9 as level-triggered
ohci_hcd 0000:00:02.0: assigned PCI INT A -> IRQ 9
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 9, io mem 0xd0006000
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31-rc4 ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
sl811: driver sl811-hcd, 19 May 2005
Platform driver 'sl811-hcd' needs updating - please use dev_pm_ops
r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
Platform driver 'r8a66597_hcd' needs updating - please use dev_pm_ops
PNP: No PS/2 controller found. Probing ports directly.
Platform driver 'i8042' needs updating - please use dev_pm_ops
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Netfilter messages via NETLINK v0.30.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 288k freed
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
Clocksource tsc unstable (delta = 200000460 ns)
PCI: setting IRQ 10 as level-triggered
b43-pci-bridge 0000:00:09.0: found PCI INT A -> IRQ 10
ssb: Sonics Silicon Backplane found on PCI device 0000:00:09.0
yenta_cardbus 0000:00:0a.0: CardBus bridge found [103c:0024]
yenta_cardbus 0000:00:0a.0: O2: res at 0x94/0xD4: 00/ea
yenta_cardbus 0000:00:0a.0: O2: enabling read prefetch/write burst
libata version 3.00 loaded.
natsemi dp8381x driver, version 2.1, Sept 11, 2006
  originally by Donald Becker <becker@scyld.com>
  2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
b43legacy-phy0: Broadcom 4306 WLAN found
yenta_cardbus 0000:00:0a.0: ISA IRQ mask 0x0c98, PCI irq 5
yenta_cardbus 0000:00:0a.0: Socket status: 30000007
scsi0 : pata_ali
scsi1 : pata_ali
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8080 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8088 irq 15
PCI: setting IRQ 5 as level-triggered
ALI 5451 0000:00:06.0: found PCI INT A -> IRQ 5
ata1.00: ATA-6: ST9100823A, 3.00, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST9100823A       3.00 PQ: 0 ANSI: 5
ata2.00: ATAPI: DW-224E, A.0H, max MWDMA2
ata2.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled
ata2.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
ata2.00: configured for MWDMA2
scsi 1:0:0:0: CD-ROM            TEAC     DW-224E          A.0H PQ: 0 ANSI: 5
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding
0x200-0x207 0x220-0x22f 0x330-0x337 0x378-0x37f 0x388-0x38f
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding
0x408-0x40f 0x480-0x48f 0x4d0-0x4d7
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3c0-0x3d2: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3d4-0x3df: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x1000-0x17ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
phy0: Selected rate control algorithm 'minstrel'
Broadcom 43xx-legacy driver loaded [ Features: PID, Firmware-ID: FW10 ]
Synaptics Touchpad, model: 1, fw: 5.8, id: 0x2348b3, caps: 0x904713/0x10008
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input1
AC'97 1 does not respond - RESET
AC'97 1 access is not valid [0xffffffff], removing mixer.
ali mixer 1 creating error.
natsemi 0000:00:12.0: found PCI INT A -> IRQ 11
natsemi eth0: NatSemi DP8381[56] at 0xd000a000 (0000:00:12.0),
00:0d:9d:81:e8:17, IRQ 11, port TP.
ali15x3_smbus 0000:00:11.0: ALI15X3_smb region uninitialized - upgrade
BIOS or use force_addr=0xaddr
ali15x3_smbus 0000:00:11.0: ALI15X3 not detected, module not inserted.
sd 0:0:0:0: [sda] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda:sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
 unknown partition table
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
REISERFS (device dm-2): found reiserfs format "3.6" with standard journal
REISERFS (device dm-2): using ordered data mode
REISERFS (device dm-2): journal params: device dm-2, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-2): checking transaction log (dm-2)
REISERFS (device dm-2): replayed 15 transactions in 0 seconds
REISERFS (device dm-2): Using r5 hash to sort names
REISERFS (device dm-1): found reiserfs format "3.6" with standard journal
REISERFS (device dm-1): using ordered data mode
REISERFS (device dm-1): journal params: device dm-1, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-1): checking transaction log (dm-1)
REISERFS (device dm-1): replayed 28 transactions in 1 seconds
REISERFS (device dm-1): Using r5 hash to sort names
REISERFS (device dm-3): found reiserfs format "3.6" with standard journal
REISERFS (device dm-3): using ordered data mode
REISERFS (device dm-3): journal params: device dm-3, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-3): checking transaction log (dm-3)
REISERFS (device dm-3): replayed 16 transactions in 0 seconds
REISERFS (device dm-3): Using r5 hash to sort names
REISERFS (device dm-5): found reiserfs format "3.6" with standard journal
REISERFS (device dm-5): using ordered data mode
REISERFS (device dm-5): journal params: device dm-5, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-5): checking transaction log (dm-5)
REISERFS (device dm-5): replayed 19 transactions in 0 seconds
REISERFS (device dm-5): Using r5 hash to sort names
REISERFS (device dm-6): found reiserfs format "3.6" with standard journal
REISERFS (device dm-6): using ordered data mode
REISERFS (device dm-6): journal params: device dm-6, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-6): checking transaction log (dm-6)
REISERFS (device dm-6): replayed 15 transactions in 0 seconds
REISERFS (device dm-6): Using r5 hash to sort names
udev: starting version 141
REISERFS (device dm-4): found reiserfs format "3.6" with standard journal
REISERFS (device dm-4): using ordered data mode
REISERFS (device dm-4): journal params: device dm-4, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-4): checking transaction log (dm-4)
REISERFS (device dm-4): Using r5 hash to sort names
Btrfs loaded
device fsid 8b4e53f399b45375-271c8dccd0168383 devid 1 transid 76
/dev/mapper/rootfs-usr
REISERFS (device dm-8): found reiserfs format "3.6" with standard journal
REISERFS (device dm-8): using ordered data mode
REISERFS (device dm-8): journal params: device dm-8, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit
age 30, max trans age 30
REISERFS (device dm-8): checking transaction log (dm-8)
REISERFS (device dm-8): Using r5 hash to sort names
Adding 4194296k swap on /dev/mapper/rootfs-swap.  Priority:-1
extents:1 across:4194296k
eth0: DSPCFG accepted after 0 usec.
eth0: link up.
eth0: Setting full-duplex based on negotiated link capability.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia 0.0: pcmcia: registering new device pcmcia0.0
irq 3: nobody cared (try booting with the "irqpoll" option)
Pid: 3690, comm: modprobe Not tainted 2.6.31-rc4 #2
Call Trace:
 [<c104e3f4>] ? __report_bad_irq+0x24/0x90
 [<c104e5b7>] ? note_interrupt+0x157/0x1a0
 [<c104d4ed>] ? handle_IRQ_event+0x2d/0xc0
 [<c104edcb>] ? handle_level_irq+0xbb/0x100
 [<c1004ec7>] ? handle_irq+0x17/0x20
 [<c100490a>] ? do_IRQ+0x3a/0xb0
 [<c1004913>] ? do_IRQ+0x43/0xb0
 [<c1021231>] ? scheduler_tick+0xd1/0x100
 [<c1003329>] ? common_interrupt+0x29/0x30
 [<c10284b5>] ? __do_softirq+0x35/0xf0
 [<c104d4ed>] ? handle_IRQ_event+0x2d/0xc0
 [<c102859d>] ? do_softirq+0x2d/0x40
 [<c102874d>] ? irq_exit+0x5d/0x80
 [<c1004913>] ? do_IRQ+0x43/0xb0
 [<c1003329>] ? common_interrupt+0x29/0x30
 [<c104dc0a>] ? __setup_irq+0x17a/0x2c0
 [<f80eb7f0>] ? ata_sff_interrupt+0x0/0xf0 [libata]
 [<c104de11>] ? request_threaded_irq+0xc1/0x100
 [<c104f2c4>] ? devm_request_threaded_irq+0x34/0xa0
 [<f80eb7f0>] ? ata_sff_interrupt+0x0/0xf0 [libata]
 [<c104f2ee>] ? devm_request_threaded_irq+0x5e/0xa0
 [<f80dac3f>] ? ata_host_activate+0x8f/0x110 [libata]
 [<f80eb7f0>] ? ata_sff_interrupt+0x0/0xf0 [libata]
 [<f9932466>] ? pcmcia_init_one+0x2c6/0x340 [pata_pcmcia]
 [<c10c8e81>] ? sysfs_find_dirent+0x21/0x30
 [<f82b6a26>] ? pcmcia_device_probe+0xf6/0x1b0 [pcmcia]
 [<c10c9fa1>] ? sysfs_do_create_link+0xa1/0x140
 [<c1155b24>] ? driver_probe_device+0x74/0x180
 [<f82b70eb>] ? pcmcia_bus_match+0x1bb/0x4a0 [pcmcia]
 [<c1155cb1>] ? __driver_attach+0x81/0x90
 [<f82b67b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
 [<c1155474>] ? bus_for_each_dev+0x54/0x80
 [<f82b67b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
 [<c11559c6>] ? driver_attach+0x16/0x20
 [<c1155c30>] ? __driver_attach+0x0/0x90
 [<c1154d06>] ? bus_add_driver+0xb6/0x250
 [<f82b67b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
 [<c1155f27>] ? driver_register+0x67/0x150
 [<f82b7b51>] ? pcmcia_register_driver+0x91/0x110 [pcmcia]
 [<f9937000>] ? pcmcia_init+0x0/0xa [pata_pcmcia]
 [<c100102a>] ? _stext+0x2a/0x160
 [<c104b3c3>] ? sys_init_module+0xb3/0x1f0
 [<c1081ca1>] ? sys_read+0x41/0x80
 [<c1002cf4>] ? sysenter_do_call+0x12/0x26
handlers:
[<f80eb7f0>] (ata_sff_interrupt+0x0/0xf0 [libata])
Disabling IRQ #3
scsi2 : pata_pcmcia
ata3: PATA max PIO0 cmd 0x100 ctl 0x10e irq 3
ata3.01: both IDENTIFYs aborted, assuming NODEV
ata3.00: CFA: IBM-DMDM-10340, MD2IC501, max PIO1
ata3.00: 700560 sectors, multi 0: LBA
ata3.00: configured for PIO0
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA      IBM-DMDM-10340   MD2I PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 700560 512-byte logical blocks: (358 MB/342 MiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: Attached scsi generic sg2 type 0
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
