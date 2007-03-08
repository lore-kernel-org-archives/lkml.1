Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbXCHB0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbXCHB0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXCHB0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:26:36 -0500
Received: from web52915.mail.yahoo.com ([206.190.49.25]:46905 "HELO
	web52915.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752146AbXCHB0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:26:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=owRCSJDRYcMMOf9t4yxyIB2F8BSIM4c0qbA4IdPUry4IAiR8h5oqYsae1XClZk00lBT+XYphaVciyvuBvem+lWc/iTWXQokclRfSN0v/cZI3G9Qtvpfqkt9pgMr2iQIqW2Ydf41mHMsZrmT115OzdvIJY86tHzRWEbP7bmKSdbA=;
X-YMail-OSG: EPLfCioVM1nPxLwXwiAjbxWXLgbwO06gfy2yM65J67qoAXhAQi_GTPJNDydb017bQvxh01gwwFfkbJulagDFiwnf146NGxyQPE.njUez9lpT726N4qGlLOpZSs529UAqOIOqafnTMfhX1mtJVdJFUnTn7w--
Date: Thu, 8 Mar 2007 01:26:32 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703011330330.29829@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <377495.79193.qm@web52915.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> It should give us a better clue which sysfs file is causing the oops.

This BUG happened during boot-up! The only USB device I have is a pwc webcam:

$ /sbin/lsusb
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 003: ID 046d:08b4 Logitech, Inc. QuickCam Zoom
Bus 001 Device 001: ID 0000:0000

Linux version 2.6.20.1 (chris@volcano.underworld) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51))
#3 SMP PREEMPT Thu Mar 1 12:06:59 GMT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000007fe75000 end: 000000007ff75000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007ff75000 size: 0000000000002000 end: 000000007ff77000 type: 4
copy_e820_map() start: 000000007ff77000 size: 0000000000021000 end: 000000007ff98000 type: 3
copy_e820_map() start: 000000007ff98000 size: 0000000000068000 end: 0000000080000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000090000 end: 00000000fec90000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 00000000fee10000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff75000 (usable)
 BIOS-e820: 000000007ff75000 - 000000007ff77000 (ACPI NVS)
 BIOS-e820: 000000007ff77000 - 000000007ff98000 (ACPI data)
 BIOS-e820: 000000007ff98000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 524149) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524149
early_node_map[1] active PFN ranges
    0:        0 ->   524149
On node 0 totalpages: 524149
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2302 pages used for memmap
  HighMem zone: 292471 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 DELL                                  ) @ 0x000febc0
ACPI: RSDT (v001 DELL    WS 650  0x00000009 ASL  0x00000061) @ 0x000fd4f1
ACPI: FADT (v001 DELL    WS 650  0x00000009 ASL  0x00000061) @ 0x000fd529
ACPI: SSDT (v001   DELL    st_ex 0x00001000 MSFT 0x0100000d) @ 0xfffefafa
ACPI: MADT (v001 DELL    WS 650  0x00000009 ASL  0x00000061) @ 0x000fd59d
ACPI: BOOT (v001 DELL    WS 650  0x00000009 ASL  0x00000061) @ 0x000fd621
ACPI: ASF! (v016 DELL    WS 650  0x00000009 ASL  0x00000061) @ 0x000fd649
ACPI: DSDT (v001   DELL    dt_ex 0x00001000 MSFT 0x0100000d) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec80800] gsi_base[48])
IOAPIC[2]: apic_id 10, version 32, address 0xfec80800, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Detected 2658.187 MHz processor.
Built 1 zonelists.  Total pages: 520055
Kernel command line: ro root=LABEL=/ nmi_watchdog=1 elevator=cfq console=ttyS0,115200n8
console=tty0 acpi_pm_good
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec80800)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0345000 soft=c033d000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074476k/2096596k available (1483k kernel code, 20844k reserved, 579k data, 192k init,
1179092k highmem)
virtual kernel memory layout:
    fixmap  : 0xffedf000 - 0xfffff000   (1152 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0308000 - 0xc0338000   ( 192 kB)
      .data : 0xc0272f5b - 0xc0303c54   ( 579 kB)
      .text : 0xc0100000 - 0xc0272f5b   (1483 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5320.40 BogoMIPS (lpj=10640815)Mount-cache hash
table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 10k freed
ACPI: Core revision 20060707
CPU0: Intel(R) Xeon(TM) CPU 2.66GHz stepping 09
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0346000 soft=c033e000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5316.59 BogoMIPS (lpj=10633189)CPU: After generic
identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.66GHz stepping 09
Booting processor 2/6 eip 2000
CPU 2 irqstacks, hard=c0347000 soft=c033f000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5316.61 BogoMIPS (lpj=10633234)CPU: After generic
identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.66GHz stepping 09
Booting processor 3/7 eip 2000
CPU 3 irqstacks, hard=c0348000 soft=c0340000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5316.63 BogoMIPS (lpj=10633277)CPU: After generic
identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.66GHz stepping 09
Total of 4 processors activated (21270.25 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
migration_cost=108,620
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbdf2, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11 12 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:0c: ioport range 0x800-0x85f could not be reserved
pnp: 00:0c: ioport range 0xc00-0xc7f has been reserved
pnp: 00:0c: ioport range 0x860-0x8ff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: ff800000-ff9fffff
  PREFETCH window: e8000000-f7ffffff
PCI: Bridge: 0000:02:1d.0
  IO window: d000-dfff
  MEM window: ff600000-ff7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:1f.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: d000-dfff
  MEM window: ff400000-ff7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: ff200000-ff3fffff
  PREFETCH window: 88000000-880fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 897k freed
Simple Boot Flag value 0x87 read from CMOS RAM was invalid
Simple Boot Flag at 0x7a set to 0x1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler cfq registered (default)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
ICH4: chipset revision 1
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: IC35L090AVV207-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-STDVD-ROM GDR8162B, ATAPI CD/DVD-ROM drive
hdd: SONY CD-RW CRX216E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 156250000 sectors (80000 MB) w/1821KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.cominput: AT
Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
NET: Registered protocol family 1
Testing NMI watchdog ... OK.
Starting balanced_irq
Using IPI Shortcut mode
Freeing unused kernel memory: 192k freed
Time: tsc clocksource has been installed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel E7505 Chipset.
agpgart: AGP aperture is 128M @ 0xe0000000
input: PC Speaker as /class/input/input1
SCSI subsystem initialized
EDAC MC: Ver: 2.0.1 Mar  1 2007
Intel(R) PRO/1000 Network Driver - version 7.3.15-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 24 (level, low) -> IRQ 17
hdc: ATAPI 48X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 48X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
e1000: 0000:03:0e.0: e1000_probe: (PCI-X:100MHz:64-bit) 00:0d:56:0d:e7:3f
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 18
libata version 2.00 loaded.
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
sata_sil 0000:05:0e.0: version 2.0
ACPI: PCI Interrupt 0000:05:0e.0[A] -> GSI 22 (level, low) -> IRQ 19
ata1: SATA max UDMA/100 cmd 0xF882EC80 ctl 0xF882EC8A bmdma 0xF882EC00 irq 19
ata2: SATA max UDMA/100 cmd 0xF882ECC0 ctl 0xF882ECCA bmdma 0xF882EC08 irq 19
scsi0 : sata_sil
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000ff80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000ff60
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ieee1394: Initialized config rom entry `ip1394'
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000ff40
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ata1: SATA link down (SStatus 0 SControl 310)
scsi1 : sata_sil
usb 1-2: new full speed USB device using uhci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
pwc: Philips webcam module version 10.0.12 loaded.
pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
ata2.00: configured for UDMA/100
scsi 1:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:05:0d.0[A] -> GSI 21 (level, low) -> IRQ 22
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffa20000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
Installing spdif_bug patch: Audigy 2 ZS [SB0353]
pwc: Logitech QuickCam Zoom (new model) USB webcam detected.
pwc: Registered as /dev/video0.
usbcore: registered new interface driver Philips webcam
usbcore: registered new interface driver snd-usb-audio
usb 1-2: USB disconnect, address 2
ACPI: PCI Interrupt 0000:05:0c.0[A] -> GSI 20 (level, low) -> IRQ 24
scsi 1:0:0:0: Attached scsi generic sg0 type 0
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[24]  MMIO=[ff2ff800-ff2fffff]  Max Packet=[2048] 
IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:05:0d.2[B] -> GSI 22 (level, low) -> IRQ 19
ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[ff2ff000-ff2ff7ff]  Max Packet=[2048] 
IR/IT contexts=[4/8]
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 1:0:0:0: Attached scsi disk sda
Non-volatile memory driver v1.2
usb 1-2: new full speed USB device using uhci_hcd and address 3
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
lp0: using parport0 (interrupt-driven).
usb 1-2: configuration #1 chosen from 1 choice
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [VBTN]
pwc: Logitech QuickCam Zoom (new model) USB webcam detected.
pwc: Registered as /dev/video0.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[87ffffffffffff00]
eth1394: eth1: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
eth1394: eth2: IEEE-1394 IPv4 over 1394 Ethernet (fw-host1)
ieee1394: The root node is not cycle master capable; selecting a new root node and resetting...
BUG: unable to handle kernel paging request at virtual address 6b6b6e6b
 printing eip:
c0130113
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
last sysfs file: /class/usb_endpoint/usbdev1.3_ep82/dev
Modules linked in: eth1394 video thermal processor fan button ac lp parport_pc parport nvram
sd_mod snd_emu10k1_synth sg snd_emux_synth snd_seq_virmidi snd_seq_midi_emul pwc compat_ioctl32
videodev v4l2_common v4l1_compat snd_usb_audio snd_usb_lib snd_emu10k1 snd_rawmidi snd_ac97_codec
ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ohci1394 ieee1394 snd_pcm_oss
snd_mixer_oss ehci_hcd uhci_hcd sata_sil snd_pcm libata snd_seq_device snd_timer serio_raw
snd_page_alloc snd_util_mem ide_cd psmouse i2c_i801 e7xxx_edac snd_hwdep e1000 edac_mc snd
soundcore scsi_mod pcspkr i2c_core intel_agp cdrom agpgart usbcore ext3 jbd
CPU:    3
EIP:    0060:[<c0130113>]    Not tainted VLI
EFLAGS: 00010202   (2.6.20.1 #3)
EIP is at module_put+0x20/0x52
eax: 6b6b6e6b   ebx: 6b6b6b6b   ecx: 00000001   edx: f7f94000
esi: f79e79bc   edi: 6b6b6b6b   ebp: f7a4e8fc   esp: f7f94f58
ds: 007b   es: 007b   ss: 0068
Process udevd (pid: 1908, ti=f7f94000 task=f7fd5560 task.ti=f7f94000)
Stack: c21bfcc8 c0183a5b 00000010 f7fa9120 f7a47048 c0151253 00000000 00000000
       f7ff2208 f7fa9120 f7fdc048 00000000 f7fa9120 c014ed90 00000003 00000003
       f7fdc048 f7fdc0c8 c014fd89 00000003 00000006 00000003 f7f94000 c0102bce
Call Trace:
 [<c0183a5b>] sysfs_release+0x2d/0x4c
 [<c0151253>] __fput+0x96/0x13c
 [<c014ed90>] filp_close+0x51/0x58
 [<c014fd89>] sys_close+0x70/0xa7
 [<c0102bce>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x6b3/0x965
 =======================
Code: 00 89 f0 83 c4 0c 5b 5e 5f 5d c3 53 89 c3 85 c0 74 49 b8 01 00 00 00 e8 5f 49 fe ff e8 3b 5b
07 00 c1 e0 07 8d 84 18 80 01 00 00 <ff> 08 83 3b 02 75 0b 8b 83 88 05 00 00 e8 a9 45 fe ff b8 01
00
EIP: [<c0130113>] module_put+0x20/0x52 SS:ESP 0068:f7f94f58
 <6>note: udevd[1908] exited with preempt_count 1
BUG: scheduling while atomic: udevd/0x10000001/1908
 [<c026f9d6>] __sched_text_start+0x56/0x965
 [<c011cc72>] irq_exit+0x37/0x42
 [<c010d1d7>] smp_apic_timer_interrupt+0x70/0x79
 [<c010369c>] apic_timer_interrupt+0x28/0x30
 [<c0114b01>] __cond_resched+0x12/0x2c
 [<c02708e9>] cond_resched+0x26/0x31
 [<c01404d2>] unmap_vmas+0x3d3/0x4df
 [<c0142cf5>] exit_mmap+0x7e/0x10a
 [<c0116bd7>] mmput+0x1d/0x78
 [<c011b322>] do_exit+0x1b2/0x6d8
 [<c011007b>] sys_vm86+0x99/0x21d
 [<c01040fc>] die+0x1f7/0x21c
 [<c011180e>] do_page_fault+0x442/0x510
 [<c01113cc>] do_page_fault+0x0/0x510
 [<c027230c>] error_code+0x7c/0x84
 [<c0130113>] module_put+0x20/0x52
 [<c0183a5b>] sysfs_release+0x2d/0x4c
 [<c0151253>] __fput+0x96/0x13c
 [<c014ed90>] filp_close+0x51/0x58
 [<c014fd89>] sys_close+0x70/0xa7
 [<c0102bce>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x6b3/0x965
 =======================
ieee1394: Node added: ID:BUS[1-00:1023]  GUID[0050c500001076df]
ieee1394: Host added: ID:BUS[1-01:1023]  GUID[00023c00a1037111]
ieee1394: raw1394: /dev/raw1394 device initialized
video1394: Installed video1394 module
EXT3 FS on hda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2040212k swap on /dev/hda7.  Priority:-1 extents:1 across:2040212k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
NET: Registered protocol family 17
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
Time: acpi_pm clocksource has been installed.
usbcore: deregistering interface driver Philips webcam
pwc: Philips webcam module removed.
pwc: Philips webcam module version 10.0.12 loaded.
pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
pwc: Logitech QuickCam Zoom (new model) USB webcam detected.
pwc: Registered as /dev/video0.
usbcore: registered new interface driver Philips webcam
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 20
[drm] Initialized radeon 1.25.0 20060524 on minor 0
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs

Cheers,
Chris



		
___________________________________________________________ 
The all-new Yahoo! Mail goes wherever you go - free your email address from your Internet provider. http://uk.docs.yahoo.com/nowyoucan.html
