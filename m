Return-Path: <linux-kernel-owner+w=401wt.eu-S965451AbXAXAdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbXAXAdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933157AbXAXAdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:33:35 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:28145 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933149AbXAXAdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:33:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:Subject:Content-Type;
  b=f2X8j5NnrH1B3ithrl5jyigLmEtY4HajrDIDcowdvEd4JUECbVCxineKFaJED26YemVm8sGt+YYbyFOtFfz42DXc64EudueCiDAHCha+IKrC6s/Ko7IKcpBx7N2RhJnerBuOuU6LG4TXLzmdvcInMGA7HCZK1/8++2mrAv3L/Ns=  ;
X-YMail-OSG: 0oMF.7sVM1mtupRS15n7VXroNUmWYN5oZqUUYC8CHkbcL.hfLqDOolBBQmemrl8HjnMgJKto.c1XYrgaULjxIgnE4yUB_TuJVrpBF.kvRwIJxpoW76L9i5FSM.BCwB77EUyhgQ--
Message-ID: <45B6A94A.3010006@yahoo.com.au>
Date: Wed, 24 Jan 2007 11:33:14 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Daniel Drake <dsd@reactivated.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: via irq quirk breakage
Content-Type: multipart/mixed;
 boundary="------------080006030700090004040401"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080006030700090004040401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Recently updated an old box to a new kernel, and the USB mouse stops working.
Well it sort of works, but stutters and is very unresponsive. This happens
now and again when the IRQ routing for my board gets broken.

Attached a dmesg from a bad 2.6.20-rc5, and a quick hack that gets everything
working again, and a diff between good and bad dmesg, and lspci.

I can test patches or send any other info needed.

-- 
SUSE Labs, Novell Inc.

--------------080006030700090004040401
Content-Type: text/plain;
 name="dmesg.bad"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.bad"

Linux version 2.6.20-rc5 (npiggin@didi) (gcc version 4.1.2 20061020 (prerelease) (Debian 4.1.1-17)) #27 SMP PREEMPT Tue Jan 23 17:13:01 EST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000000fef0000 end: 000000000fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000fff0000 size: 0000000000008000 end: 000000000fff8000 type: 3
copy_e820_map() start: 000000000fff8000 size: 0000000000008000 end: 0000000010000000 type: 4
copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff8000 (ACPI data)
 BIOS-e820: 000000000fff8000 - 0000000010000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
255MB LOWMEM available.
found SMP MP-table at 000fb110
Entering add_active_range(0, 0, 65520) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    65520
early_node_map[1] active PFN ranges
    0:        0 ->    65520
On node 0 totalpages: 65520
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 479 pages used for memmap
  Normal zone: 60945 pages, LIFO batch:15
DMI 2.3 present.
ACPI: RSDP (v000 AMI                                   ) @ 0x000fc590
ACPI: RSDT (v001 AMIINT          0x00000010 MSFT 0x00000099) @ 0x0fff0000
ACPI: FADT (v001 AMIINT          0x00000011 MSFT 0x00000099) @ 0x0fff0030
ACPI: MADT (v001 AMIINT          0x00000009 MSFT 0x00000099) @ 0x0fff00b0
ACPI: DSDT (v001    VIA APOLLO-P 0x00001000 MSFT 0x0100000b) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 17
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:8 APIC version 17
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 20000000 (gap: 10000000:eec00000)
Detected 996.609 MHz processor.
Built 1 zonelists.  Total pages: 65009
Kernel command line: BOOT_IMAGE=linuxtest2 ro root=305 nmi_watchdog=1
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0410000 soft=c040e000
PID hash table entries: 1024 (order: 10, 4096 bytes)
Console: colour VGA+ 132x60
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 255836k/262080k available (2206k kernel code, 5696k reserved, 678k data, 200k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xd0800000 - 0xfffb5000   ( 759 MB)
    lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
      .init : 0xc03d7000 - 0xc0409000   ( 200 kB)
      .data : 0xc0327a4f - 0xc03d128c   ( 678 kB)
      .text : 0xc0100000 - 0xc0327a4f   (2206 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1994.39 BogoMIPS (lpj=997195)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 12k freed
ACPI: Core revision 20060707
CPU0: Intel Pentium III (Coppermine) stepping 0a
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0411000 soft=c040f000
Initializing CPU#1
Calibrating delay using timer specific routine.. 1992.80 BogoMIPS (lpj=996402)
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Coppermine) stepping 0a
Total of 2 processors activated (3987.19 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=691
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0c00-0c7f claimed by vt82c686 HW-mon
PCI quirk: region 0400-040f claimed by vt82c686 SMB
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 10 devices
Generic PHY: Registered new driver
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: dde00000-dfefffff
  PREFETCH window: d9c00000-ddcfffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 98304 bytes)
TCP bind hash table entries: 4096 (order: 3, 49152 bytes)
TCP: Hash tables configured (established 8192 bind 4096)
TCP reno registered
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: Enabling Via external APIC routing
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: Thermal Zone [THRM] (30 C)
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA Apollo Pro 133 chipset
agpgart: AGP aperture is 256M @ 0xe0000000
natsemi dp8381x driver, version 2.1, Sept 11, 2006
  originally by Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/natsemi.html
  2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 16
natsemi eth0: NatSemi DP8381[56] at 0xdfffd000 (0000:00:0a.0), 00:09:5b:08:e3:4d, IRQ 16, port TP.
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 17
skge 1.9 addr 0xdfff8000 irq 17 chip Yukon rev 1
skge eth1: addr 00:0d:88:6c:c0:73
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: ST320410A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: RICOH CD-R/RW MP7060A, ATAPI CD/DVD-ROM drive
hdd: ATAPI CD-ROM DRIVE 24X MAXIMUM, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 39102336 sectors (20020 MB) w/2048KiB Cache, CHS=38792/16/63, UDMA(100)
hda: cache flushes not supported
 hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 > hda3 hda4
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
input: AT Translated Set 2 keyboard as /class/input/input4
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Testing NMI watchdog ... OK.
Starting balanced_irq
Using IPI Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Time: tsc clocksource has been installed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 200k freed
Real Time Clock Driver v1.12ac
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
hdc: ATAPI 24X CD-ROM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 20X CD-ROM drive, 120kB Cache, DMA
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x0000cc00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 11, io base 0x0000d000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 1-1: new low speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:07.5 to 64
Adding 254984k swap on /dev/hda9.  Priority:-1 extents:1 across:254984k
EXT3 FS on hda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
usb 1-1: configuration #1 chosen from 1 choice
skge eth1: enabling interface
usbcore: registered new interface driver hiddev
input: A4Tech USB Wheel Mouse as /class/input/input5
input: USB HID v1.10 Mouse [A4Tech USB Wheel Mouse] on usb-0000:00:07.2-1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
skge eth1: Link is up at 100 Mbps, full duplex, flow control both
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period

--------------080006030700090004040401
Content-Type: text/plain;
 name="dmesg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.diff"

--- dmesg.bad	2007-01-24 10:06:46.000000000 +1100
+++ dmesg.good2	2007-01-24 10:05:37.000000000 +1100
@@ -1,4 +1,4 @@
-Linux version 2.6.20-rc5 (npiggin@didi) (gcc version 4.1.2 20061020 (prerelease) (Debian 4.1.1-17)) #27 SMP PREEMPT Tue Jan 23 17:13:01 EST 2007
+Linux version 2.6.20-rc5 (npiggin@didi) (gcc version 4.1.2 20061020 (prerelease) (Debian 4.1.1-17)) #3 SMP PREEMPT Tue Jan 23 22:41:31 EST 2007
 BIOS-provided physical RAM map:
 sanitize start
 sanitize end
@@ -58,7 +58,7 @@
 Enabling APIC mode:  Flat.  Using 1 I/O APICs
 Using ACPI (MADT) for SMP configuration information
 Allocating PCI resources starting at 20000000 (gap: 10000000:eec00000)
-Detected 996.609 MHz processor.
+Detected 996.633 MHz processor.
 Built 1 zonelists.  Total pages: 65009
 Kernel command line: BOOT_IMAGE=linuxtest2 ro root=305 nmi_watchdog=1
 mapped APIC to ffffd000 (fee00000)
@@ -80,7 +80,7 @@
       .data : 0xc0327a4f - 0xc03d128c   ( 678 kB)
       .text : 0xc0100000 - 0xc0327a4f   (2206 kB)
 Checking if this processor honours the WP bit even in supervisor mode... Ok.
-Calibrating delay using timer specific routine.. 1994.39 BogoMIPS (lpj=997195)
+Calibrating delay using timer specific routine.. 1994.41 BogoMIPS (lpj=997207)
 Mount-cache hash table entries: 512
 CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
 CPU: L1 I cache: 16K, L1 D cache: 16K
@@ -95,7 +95,7 @@
 Booting processor 1/1 eip 2000
 CPU 1 irqstacks, hard=c0411000 soft=c040f000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 1992.80 BogoMIPS (lpj=996402)
+Calibrating delay using timer specific routine.. 1992.83 BogoMIPS (lpj=996416)
 CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
 CPU: L1 I cache: 16K, L1 D cache: 16K
 CPU: L2 cache: 256K
@@ -103,12 +103,12 @@
 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#1.
 CPU1: Intel Pentium III (Coppermine) stepping 0a
-Total of 2 processors activated (3987.19 BogoMIPS).
+Total of 2 processors activated (3987.24 BogoMIPS).
 ENABLING IO-APIC IRQs
 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 checking TSC synchronization across 2 CPUs: passed.
 Brought up 2 CPUs
-migration_cost=691
+migration_cost=689
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
@@ -143,6 +143,8 @@
   IO window: 9000-9fff
   MEM window: dde00000-dfefffff
   PREFETCH window: d9c00000-ddcfffff
+quirk_via_vlink 1
+quirk_via_vlink 2
 PCI: Setting latency timer of device 0000:00:01.0 to 64
 NET: Registered protocol family 2
 IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
@@ -178,6 +180,9 @@
 Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
 VP_IDE: IDE controller at PCI slot 0000:00:07.1
+quirk_via_vlink 1
+quirk_via_vlink 2
+quirk_via_vlink 3
 VP_IDE: chipset revision 6
 VP_IDE: not 100% native mode: will probe irqs later
 VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
@@ -206,24 +211,30 @@
 Testing NMI watchdog ... OK.
 Starting balanced_irq
 Using IPI Shortcut mode
-BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
 Time: tsc clocksource has been installed.
+BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs: mounted filesystem with ordered data mode.
 VFS: Mounted root (ext3 filesystem) readonly.
 Freeing unused kernel memory: 200k freed
 Real Time Clock Driver v1.12ac
+hdc: ATAPI 24X CD-ROM CD-R/RW drive, 2048kB Cache, DMA
+Uniform CD-ROM driver Revision: 3.20
+hdd: ATAPI 20X CD-ROM drive, 120kB Cache, DMA
 Floppy drive(s): fd0 is 1.44M
 FDC 0 is a post-1991 82077
 usbcore: registered new interface driver usbfs
 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
-hdc: ATAPI 24X CD-ROM CD-R/RW drive, 2048kB Cache, DMA
-Uniform CD-ROM driver Revision: 3.20
-hdd: ATAPI 20X CD-ROM drive, 120kB Cache, DMA
 USB Universal Host Controller Interface driver v3.0
 ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
 ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
+quirk_via_vlink 1
+quirk_via_vlink 2
+quirk_via_vlink 3
+quirk_via_vlink 4
+quirk_via_vlink 5
+PCI: VIA VLink IRQ fixup for 0000:00:07.2, from 12 to 11
 uhci_hcd 0000:00:07.2: UHCI Host Controller
 uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
 uhci_hcd 0000:00:07.2: irq 11, io base 0x0000cc00
@@ -231,16 +242,33 @@
 hub 1-0:1.0: USB hub found
 hub 1-0:1.0: 2 ports detected
 ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
+quirk_via_vlink 1
+quirk_via_vlink 2
+quirk_via_vlink 3
+quirk_via_vlink 4
+quirk_via_vlink 5
+PCI: VIA VLink IRQ fixup for 0000:00:07.3, from 12 to 11
 uhci_hcd 0000:00:07.3: UHCI Host Controller
 uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
 uhci_hcd 0000:00:07.3: irq 11, io base 0x0000d000
 usb usb2: configuration #1 chosen from 1 choice
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 2 ports detected
-usb 1-1: new low speed USB device using uhci_hcd and address 2
 ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
 ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
+quirk_via_vlink 1
+quirk_via_vlink 2
+quirk_via_vlink 3
+quirk_via_vlink 4
+quirk_via_vlink 5
 PCI: Setting latency timer of device 0000:00:07.5 to 64
+usb 1-1: new low speed USB device using uhci_hcd and address 2
+usb 1-1: configuration #1 chosen from 1 choice
+usbcore: registered new interface driver hiddev
+input: A4Tech USB Wheel Mouse as /class/input/input5
+input: USB HID v1.10 Mouse [A4Tech USB Wheel Mouse] on usb-0000:00:07.2-1
+usbcore: registered new interface driver usbhid
+drivers/usb/input/hid-core.c: v2.6:USB HID core driver
 Adding 254984k swap on /dev/hda9.  Priority:-1 extents:1 across:254984k
 EXT3 FS on hda5, internal journal
 kjournald starting.  Commit interval 5 seconds
@@ -251,13 +279,7 @@
 kjournald starting.  Commit interval 5 seconds
 EXT3 FS on hda8, internal journal
 EXT3-fs: mounted filesystem with ordered data mode.
-usb 1-1: configuration #1 chosen from 1 choice
 skge eth1: enabling interface
-usbcore: registered new interface driver hiddev
-input: A4Tech USB Wheel Mouse as /class/input/input5
-input: USB HID v1.10 Mouse [A4Tech USB Wheel Mouse] on usb-0000:00:07.2-1
-usbcore: registered new interface driver usbhid
-drivers/usb/input/hid-core.c: v2.6:USB HID core driver
 skge eth1: Link is up at 100 Mbps, full duplex, flow control both
 IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
 NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory

--------------080006030700090004040401
Content-Type: text/plain;
 name="via-diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="via-diff"

--- drivers/pci/quirks.c	2007-01-24 01:20:26.000000000 +1100
+++ drivers/pci/quirks.c.new	2007-01-23 22:40:46.000000000 +1100
@@ -685,13 +685,18 @@ static void quirk_via_vlink(struct pci_d
 	u8 irq, new_irq;
 
 	/* Check if we have VLink and cache the result */
+	printk("quirk_via_vlink 1\n");
 
+#if 0
 	/* Checked already - no */
 	if (dev_lo == -2)
 		return;
+#endif
 
 	/* Not checked - see what bridge we have and find the device
 	   ranges */
+
+	printk("quirk_via_vlink 2\n");
 	if (dev_lo == -1) {
 		via_vlink_fixup = pci_find_present(via_vlink_fixup_tbl);
 		if (via_vlink_fixup == NULL) {
@@ -705,15 +710,20 @@ static void quirk_via_vlink(struct pci_d
 	}
 	new_irq = dev->irq;
 
+	printk("quirk_via_vlink 3\n");
 	/* Don't quirk interrupts outside the legacy IRQ range */
 	if (!new_irq || new_irq > 15)
 		return;
 
+	printk("quirk_via_vlink 4\n");
+#if 0
 	/* Internal device ? */
 	if (dev->bus->number != 0 || PCI_SLOT(dev->devfn) > dev_hi ||
 		PCI_SLOT(dev->devfn) < dev_lo)
 		return;
+#endif
 
+	printk("quirk_via_vlink 5\n");
 	/* This is an internal VLink device on a PIC interrupt. The BIOS
 	   ought to have set this but may not have, so we redo it */
 

--------------080006030700090004040401
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:00.0 Host bridge: VIA Technologies, Inc. VT82C693A/694x [Apollo PRO133x] (rev c4)
00:01.0 PCI bridge: VIA Technologies, Inc. VT82C598/694x [Apollo MVP3/Pro133x AGP]
00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 40)
00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1a)
00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1a)
00:07.4 SMBus: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
00:07.5 Multimedia audio controller: VIA Technologies, Inc. VT82C686 AC97 Audio Controller (rev 50)
00:0a.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
00:0b.0 Ethernet controller: D-Link System Inc Gigabit Ethernet Adapter (rev 11)
01:00.0 VGA compatible controller: nVidia Corporation NV5M64 [RIVA TNT2 Model 64/Model 64 Pro] (rev 15)

--------------080006030700090004040401--
Send instant messages to your online friends http://au.messenger.yahoo.com 
