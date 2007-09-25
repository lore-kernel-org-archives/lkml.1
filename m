Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXIYHQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXIYHQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXIYHQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:16:50 -0400
Received: from smtp-dmz-232-tuesday.dmz.nerim.net ([195.5.254.232]:65217 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751262AbXIYHQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:16:47 -0400
X-Greylist: delayed 1413 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 03:16:45 EDT
Date: Tue, 25 Sep 2007 08:51:09 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Message-ID: <20070925065109.GA3080@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

After testing rc8, I noticed that I couldn't power off the computer
directly, it only got halted and I had to press the power button
manually. Just before displaying "System halted", the following message
is displayed:

  ACPI : PCI interrupt for device 0000:02:08.0 disabled

I had to first revert 5a50fe709d527f31169263e36601dd83446d5744 then
f216cc3748a3a22c2b99390fddcdafa0583791a2 (handling of Sx states) to
recover previous behaviour.

Attached are the dmesg for rc7, rc8 and rc8 with the two patches
reverted.

-- 
Damien Wyart

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.rc7"

Linux version 2.6.23-rc7-24092007dw (root@brouette) (gcc version 4.2.1 (Debian 4.2.1-5)) #1 SMP Mon Sep 24 07:35:33 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff74000 (usable)
 BIOS-e820: 000000007ff74000 - 000000007ff76000 (ACPI NVS)
 BIOS-e820: 000000007ff76000 - 000000007ff97000 (ACPI data)
 BIOS-e820: 000000007ff97000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fecf0000 - 00000000fecf1000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 524148) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524148
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524148
On node 0 totalpages: 524148
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2302 pages used for memmap
  HighMem zone: 292470 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000FEB90, 0014 (r0 DELL  )
ACPI: RSDT 000FD1CA, 0034 (r1 DELL    8300           8 ASL        61)
ACPI: FACP 000FD1FE, 0074 (r1 DELL    8300           8 ASL        61)
ACPI: DSDT FFFC6E75, 2426 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 7FF74000, 0040
ACPI: SSDT FFFC929B, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FD272, 006C (r1 DELL    8300           8 ASL        61)
ACPI: BOOT 000FD2DE, 0028 (r1 DELL    8300           8 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 520054
Kernel command line: root=/dev/sdb2 ro vga=0x307 selinux=0 elevator=cfq video=vesafb:mtrr:3 
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0425000 soft=c0423000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2992.558 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074780k/2096592k available (2175k kernel code, 20712k reserved, 815k data, 192k init, 1179088k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03f0000 - 0xc0420000   ( 192 kB)
      .data : 0xc031ff34 - 0xc03ebd04   ( 815 kB)
      .text : 0xc0100000 - 0xc031ff34   (2175 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 5987.54 BogoMIPS (lpj=2993774)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b180 0000041d 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0426000 soft=c0424000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5984.18 BogoMIPS (lpj=2992090)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b180 0000041d 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
Total of 2 processors activated (11971.72 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbb30, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0xffffff could not be reserved
pnp: 00:00: iomem range 0x1000000-0x7ff73fff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xfffff could not be reserved
pnp: 00:0b: ioport range 0x800-0x85f has been reserved
pnp: 00:0b: ioport range 0xc00-0xc7f has been reserved
pnp: 00:0b: ioport range 0x860-0x8ff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: fd000000-feafffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: fcf00000-fcffffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag value 0x87 read from CMOS RAM was invalid
Simple Boot Flag at 0x7a set to 0x1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
vesafb: framebuffer at 0xf0000000, mapped to 0xf8880000, using 2560k, total 131072k
vesafb: mode is 1280x1024x8, linelength=1280, pages=1
vesafb: protected mode interface info at c000:f080
vesafb: pmi: set display start = c00cf0b6, set palette = c00cf120
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [VBTN]
Real Time Clock Driver v1.12ac
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 20 (level, low) -> IRQ 16
e100: eth0: e100_probe: addr 0xfcfff000, irq 16, MAC addr 00:0C:F1:B6:BA:54
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata1: port disabled. ignoring.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
ata2.00: ATAPI: SAMSUNG DVD-ROM SD-616T, F310, max UDMA/33
ata2.01: ATAPI: SAMSUNG CD-R/RW SW-252S, R901, max UDMA/33
ata2.00: configured for UDMA/33
ata2.01: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            SAMSUNG  DVD-ROM SD-616T  F310 PQ: 0 ANSI: 5
scsi 1:0:0:0: Attached scsi generic sg0 type 5
scsi 1:0:1:0: CD-ROM            SAMSUNG  CD-R/RW SW-252S  R901 PQ: 0 ANSI: 5
scsi 1:0:1:0: Attached scsi generic sg1 type 5
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0001fe00 ctl 0x0001fe12 bmdma 0x0001fea0 irq 17
ata4: SATA max UDMA/133 cmd 0x0001fe20 ctl 0x0001fe32 bmdma 0x0001fea8 irq 17
ata3.00: ATA-6: WDC WD740GD-75FLA0, 21.08U21, max UDMA/133
ata3.00: 144531250 sectors, multi 8: LBA48 
ata3.00: applying bridge limits
ata3.00: configured for UDMA/100
ata4.00: ATA-6: WDC WD740GD-75FLA0, 21.08U21, max UDMA/133
ata4.00: 144531250 sectors, multi 8: LBA48 
ata4.00: applying bridge limits
ata4.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      WDC WD740GD-75FL 21.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 144531250 512-byte hardware sectors (74000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 144531250 512-byte hardware sectors (74000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 >
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      WDC WD740GD-75FL 21.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 144531250 512-byte hardware sectors (74000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 144531250 512-byte hardware sectors (74000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 >
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 21 (level, low) -> IRQ 18
ALSA device list:
  #0: SB Live [Unknown] (rev.10, serial:0x80671102) at 0xdf20, irq 18
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
logips2pp: Detected unknown logitech mouse model 63
input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 192k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sr0: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 48x/16x writer cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1
input: PC Speaker as /devices/platform/pcspkr/input/input4
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000ff60
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 17, io base 0x0000ff40
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ff20
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
Adding 1212896k swap on /dev/sdb7.  Priority:-1 extents:1 across:1212896k
EXT3 FS on sdb2, internal journal
XFS mounting filesystem sdb5
Ending clean XFS mount for filesystem: sdb5
XFS mounting filesystem sdb6
Ending clean XFS mount for filesystem: sdb6
XFS mounting filesystem sdb8
Ending clean XFS mount for filesystem: sdb8
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
lp0: using parport0 (interrupt-driven).

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.rc8"

Linux version 2.6.23-rc8-25092007dw (root@brouette) (gcc version 4.2.1 (Debian 4.2.1-5)) #1 SMP Tue Sep 25 07:27:10 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff74000 (usable)
 BIOS-e820: 000000007ff74000 - 000000007ff76000 (ACPI NVS)
 BIOS-e820: 000000007ff76000 - 000000007ff97000 (ACPI data)
 BIOS-e820: 000000007ff97000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fecf0000 - 00000000fecf1000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 524148) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524148
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524148
On node 0 totalpages: 524148
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2302 pages used for memmap
  HighMem zone: 292470 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000FEB90, 0014 (r0 DELL  )
ACPI: RSDT 000FD1CA, 0034 (r1 DELL    8300           8 ASL        61)
ACPI: FACP 000FD1FE, 0074 (r1 DELL    8300           8 ASL        61)
ACPI: DSDT FFFC6E75, 2426 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 7FF74000, 0040
ACPI: SSDT FFFC929B, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FD272, 006C (r1 DELL    8300           8 ASL        61)
ACPI: BOOT 000FD2DE, 0028 (r1 DELL    8300           8 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 520054
Kernel command line: root=/dev/sdb2 ro vga=0x307 selinux=0 elevator=cfq video=vesafb:mtrr:3 
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0425000 soft=c0423000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2992.681 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074780k/2096592k available (2175k kernel code, 20712k reserved, 816k data, 192k init, 1179088k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03f0000 - 0xc0420000   ( 192 kB)
      .data : 0xc031fcd4 - 0xc03ebd04   ( 816 kB)
      .text : 0xc0100000 - 0xc031fcd4   (2175 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 5987.60 BogoMIPS (lpj=2993802)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b180 0000041d 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0426000 soft=c0424000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5984.16 BogoMIPS (lpj=2992084)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b180 0000041d 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
Total of 2 processors activated (11971.77 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbb30, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0xffffff could not be reserved
pnp: 00:00: iomem range 0x1000000-0x7ff73fff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xfffff could not be reserved
pnp: 00:0b: ioport range 0x800-0x85f has been reserved
pnp: 00:0b: ioport range 0xc00-0xc7f has been reserved
pnp: 00:0b: ioport range 0x860-0x8ff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: fd000000-feafffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: fcf00000-fcffffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag value 0x87 read from CMOS RAM was invalid
Simple Boot Flag at 0x7a set to 0x1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
vesafb: framebuffer at 0xf0000000, mapped to 0xf8880000, using 2560k, total 131072k
vesafb: mode is 1280x1024x8, linelength=1280, pages=1
vesafb: protected mode interface info at c000:f080
vesafb: pmi: set display start = c00cf0b6, set palette = c00cf120
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [VBTN]
Real Time Clock Driver v1.12ac
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 20 (level, low) -> IRQ 16
e100: eth0: e100_probe: addr 0xfcfff000, irq 16, MAC addr 00:0C:F1:B6:BA:54
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata1: port disabled. ignoring.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
ata2.00: ATAPI: SAMSUNG DVD-ROM SD-616T, F310, max UDMA/33
ata2.01: ATAPI: SAMSUNG CD-R/RW SW-252S, R901, max UDMA/33
ata2.00: configured for UDMA/33
ata2.01: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            SAMSUNG  DVD-ROM SD-616T  F310 PQ: 0 ANSI: 5
scsi 1:0:0:0: Attached scsi generic sg0 type 5
scsi 1:0:1:0: CD-ROM            SAMSUNG  CD-R/RW SW-252S  R901 PQ: 0 ANSI: 5
scsi 1:0:1:0: Attached scsi generic sg1 type 5
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0001fe00 ctl 0x0001fe12 bmdma 0x0001fea0 irq 17
ata4: SATA max UDMA/133 cmd 0x0001fe20 ctl 0x0001fe32 bmdma 0x0001fea8 irq 17
ata3.00: ATA-6: WDC WD740GD-75FLA0, 21.08U21, max UDMA/133
ata3.00: 144531250 sectors, multi 8: LBA48 
ata3.00: applying bridge limits
ata3.00: configured for UDMA/100
ata4.00: ATA-6: WDC WD740GD-75FLA0, 21.08U21, max UDMA/133
ata4.00: 144531250 sectors, multi 8: LBA48 
ata4.00: applying bridge limits
ata4.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      WDC WD740GD-75FL 21.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 144531250 512-byte hardware sectors (74000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 144531250 512-byte hardware sectors (74000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 >
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      WDC WD740GD-75FL 21.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 144531250 512-byte hardware sectors (74000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 144531250 512-byte hardware sectors (74000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 >
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 21 (level, low) -> IRQ 18
ALSA device list:
  #0: SB Live [Unknown] (rev.10, serial:0x80671102) at 0xdf20, irq 18
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
logips2pp: Detected unknown logitech mouse model 63
input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 192k freed
input: PC Speaker as /devices/platform/pcspkr/input/input4
sr0: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 48x/16x writer cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffa80800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000ff60
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 17, io base 0x0000ff40
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ff20
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
Adding 1212896k swap on /dev/sdb7.  Priority:-1 extents:1 across:1212896k
EXT3 FS on sdb2, internal journal
XFS mounting filesystem sdb5
Ending clean XFS mount for filesystem: sdb5
XFS mounting filesystem sdb6
Ending clean XFS mount for filesystem: sdb6
XFS mounting filesystem sdb8
Ending clean XFS mount for filesystem: sdb8
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
lp0: using parport0 (interrupt-driven).

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.rc8_revert"

Linux version 2.6.23-rc8-25092007dw (root@brouette) (gcc version 4.2.1 (Debian 4.2.1-5)) #2 SMP Tue Sep 25 08:31:09 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff74000 (usable)
 BIOS-e820: 000000007ff74000 - 000000007ff76000 (ACPI NVS)
 BIOS-e820: 000000007ff76000 - 000000007ff97000 (ACPI data)
 BIOS-e820: 000000007ff97000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fecf0000 - 00000000fecf1000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 524148) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524148
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524148
On node 0 totalpages: 524148
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2302 pages used for memmap
  HighMem zone: 292470 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000FEB90, 0014 (r0 DELL  )
ACPI: RSDT 000FD1CA, 0034 (r1 DELL    8300           8 ASL        61)
ACPI: FACP 000FD1FE, 0074 (r1 DELL    8300           8 ASL        61)
ACPI: DSDT FFFC6E75, 2426 (r1   DELL    dt_ex     1000 MSFT  100000D)
ACPI: FACS 7FF74000, 0040
ACPI: SSDT FFFC929B, 00A7 (r1   DELL    st_ex     1000 MSFT  100000D)
ACPI: APIC 000FD272, 006C (r1 DELL    8300           8 ASL        61)
ACPI: BOOT 000FD2DE, 0028 (r1 DELL    8300           8 ASL        61)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 520054
Kernel command line: root=/dev/sdb2 ro vga=0x307 selinux=0 elevator=cfq video=vesafb:mtrr:3 
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0425000 soft=c0423000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2992.681 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074780k/2096592k available (2175k kernel code, 20712k reserved, 815k data, 192k init, 1179088k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03f0000 - 0xc0420000   ( 192 kB)
      .data : 0xc031fd5c - 0xc03ebd04   ( 815 kB)
      .text : 0xc0100000 - 0xc031fd5c   (2175 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 5987.66 BogoMIPS (lpj=2993833)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b180 0000041d 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0426000 soft=c0424000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5984.18 BogoMIPS (lpj=2992093)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b180 0000041d 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
Total of 2 processors activated (11971.85 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbb30, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0x100000-0xffffff could not be reserved
pnp: 00:00: iomem range 0x1000000-0x7ff73fff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xfffff could not be reserved
pnp: 00:0b: ioport range 0x800-0x85f has been reserved
pnp: 00:0b: ioport range 0xc00-0xc7f has been reserved
pnp: 00:0b: ioport range 0x860-0x8ff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: fd000000-feafffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: fcf00000-fcffffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag value 0x87 read from CMOS RAM was invalid
Simple Boot Flag at 0x7a set to 0x1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
vesafb: framebuffer at 0xf0000000, mapped to 0xf8880000, using 2560k, total 131072k
vesafb: mode is 1280x1024x8, linelength=1280, pages=1
vesafb: protected mode interface info at c000:f080
vesafb: pmi: set display start = c00cf0b6, set palette = c00cf120
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [VBTN]
Real Time Clock Driver v1.12ac
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 20 (level, low) -> IRQ 16
e100: eth0: e100_probe: addr 0xfcfff000, irq 16, MAC addr 00:0C:F1:B6:BA:54
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata1: port disabled. ignoring.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
ata2.00: ATAPI: SAMSUNG DVD-ROM SD-616T, F310, max UDMA/33
ata2.01: ATAPI: SAMSUNG CD-R/RW SW-252S, R901, max UDMA/33
ata2.00: configured for UDMA/33
ata2.01: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            SAMSUNG  DVD-ROM SD-616T  F310 PQ: 0 ANSI: 5
scsi 1:0:0:0: Attached scsi generic sg0 type 5
scsi 1:0:1:0: CD-ROM            SAMSUNG  CD-R/RW SW-252S  R901 PQ: 0 ANSI: 5
scsi 1:0:1:0: Attached scsi generic sg1 type 5
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0001fe00 ctl 0x0001fe12 bmdma 0x0001fea0 irq 17
ata4: SATA max UDMA/133 cmd 0x0001fe20 ctl 0x0001fe32 bmdma 0x0001fea8 irq 17
ata3.00: ATA-6: WDC WD740GD-75FLA0, 21.08U21, max UDMA/133
ata3.00: 144531250 sectors, multi 8: LBA48 
ata3.00: applying bridge limits
ata3.00: configured for UDMA/100
ata4.00: ATA-6: WDC WD740GD-75FLA0, 21.08U21, max UDMA/133
ata4.00: 144531250 sectors, multi 8: LBA48 
ata4.00: applying bridge limits
ata4.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      WDC WD740GD-75FL 21.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 144531250 512-byte hardware sectors (74000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 144531250 512-byte hardware sectors (74000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 >
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      WDC WD740GD-75FL 21.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 144531250 512-byte hardware sectors (74000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 144531250 512-byte hardware sectors (74000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 >
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 21 (level, low) -> IRQ 18
ALSA device list:
  #0: SB Live [Unknown] (rev.10, serial:0x80671102) at 0xdf20, irq 18
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
logips2pp: Detected unknown logitech mouse model 63
input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 192k freed
sr0: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 48x/16x writer cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
input: PC Speaker as /devices/platform/pcspkr/input/input4
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000ff60
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 17, io base 0x0000ff40
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ff20
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: can't set config #1, error -71
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
usb 1-1: USB disconnect, address 2
usb 1-1: new full speed USB device using uhci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
Adding 1212896k swap on /dev/sdb7.  Priority:-1 extents:1 across:1212896k
EXT3 FS on sdb2, internal journal
XFS mounting filesystem sdb5
Ending clean XFS mount for filesystem: sdb5
XFS mounting filesystem sdb6
Ending clean XFS mount for filesystem: sdb6
XFS mounting filesystem sdb8
Ending clean XFS mount for filesystem: sdb8
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
lp0: using parport0 (interrupt-driven).

--mP3DRpeJDSE+ciuQ--
