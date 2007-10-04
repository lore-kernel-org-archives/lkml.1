Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbXJDSds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbXJDSds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbXJDSdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:33:41 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:4097 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756871AbXJDSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:33:39 -0400
Message-ID: <4705324E.7030409@romig.demon.co.uk>
Date: Thu, 04 Oct 2007 19:34:54 +0100
From: Neil Romig <neil@romig.demon.co.uk>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hyoshiok@miraclelinux.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: File corruption when using kernels 2.6.18+
References: <46FFC371.9040805@romig.demon.co.uk>	<84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com>	<4702B28F.5050404@romig.demon.co.uk>	<84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>	<4703E287.3070705@romig.demon.co.uk>	<84144f020710031148i346b393bm528fc150fedff00f@mail.gmail.com>	<alpine.LFD.0.999.0710031209450.3579@woody.linux-foundation.org>	<84144f020710031235r29986ceaj3260e8271eee6ddb@mail.gmail.com> <20071003213011.0962c5c5@the-village.bc.nu>
In-Reply-To: <20071003213011.0962c5c5@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------000101010307060304080400"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000101010307060304080400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
> On Wed, 3 Oct 2007 22:35:24 +0300
> "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> 
>> Hi Linus,
>>
>> On 10/3/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> I would bet that the reason the intel-optimized memcpy triggers this is
>>> that the non-temporal stores just means that you go out directly on the
>>> bus, and it probably just shows a weakness in the chipset or bus that
>>> doesn't show with the normal cacheline accesses.
>> But that should show up with memtest too, no?
> 
> Not neccessarily. The old VIA memory copying bug only showed up with
> prefetching and mmx store patterns. That was a hardware flaw that took
> extreme memory utilisation to show up - so it does occur but thats not to
> say it is the cause
> 
> Alan
> 
This is way out of my depth, but I have re-seated my 2x256MB DDR single sided DIMMS and checked my BIOS, though the Phoenix BIOS in 
my rebadged CLEVO D400E doesn't allow any tampering with timings, and recompiled with the USERCOPY enabled but still get the bit 
corruption.
Since I seem to be alone in getting this effect perhaps my machine is dodgy? I've attached my dmesg output if that's of any help.

Neil.



--------------000101010307060304080400
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.22.9 (root@romig) (gcc version 3.4.3) #1 Wed Oct 3 19:14:10 BST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fdf0000 (usable)
 BIOS-e820: 000000001fdf0000 - 000000001fdfb000 (ACPI data)
 BIOS-e820: 000000001fdfb000 - 000000001fe00000 (ACPI NVS)
 BIOS-e820: 000000001fe00000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
509MB LOWMEM available.
Entering add_active_range(0, 0, 130544) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   130544
early_node_map[1] active PFN ranges
    0:        0 ->   130544
On node 0 totalpages: 130544
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 987 pages used for memmap
  Normal zone: 125461 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F72D0, 0014 (r0 PTLTD )
ACPI: RSDT 1FDF79CA, 0028 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 1FDFAF8C, 0074 (r1 SiS    M650      6040000 PTL     F4240)
ACPI: DSDT 1FDF79F2, 359A (r1 Clevo      650M  6040000 MSFT  100000D)
ACPI: FACS 1FDFBFC0, 0040
ACPI: PM-Timer IO Port: 0x8008
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists.  Total pages: 129525
Kernel command line: root=/dev/sda6 vga=778
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 2666.381 MHz processor.
Console: colour VGA+ 132x43
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 514160k/522176k available (1982k kernel code, 7464k reserved, 710k data, 136k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
    vmalloc : 0xe0800000 - 0xffff6000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfdf0000   ( 509 MB)
      .init : 0xc03a4000 - 0xc03c6000   ( 136 kB)
      .data : 0xc02efab4 - 0xc03a168c   ( 710 kB)
      .text : 0xc0100000 - 0xc02efab4   (1982 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5334.34 BogoMIPS (lpj=2667171)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebf9ff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps: bfebf9ff 00000000 00000000 0000b080 00004400 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel Genuine Intel(R) CPU 2.66GHz stepping 09
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0800 (from 0a20)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9c8, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Enabling SiS 96x SMBus.
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs *9)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs *9)
ACPI: PCI Interrupt Link [LNKG] (IRQs *9)
ACPI: PCI Interrupt Link [LNKH] (IRQs 9) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:04: ioport range 0x8000-0x808f has been reserved
pnp: 00:04: ioport range 0x8090-0x80ff has been reserved
pnp: 00:04: ioport range 0x8100-0x811f has been reserved
pnp: 00:04: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:04: ioport range 0xfe00-0xfe00 has been reserved
Time: tsc clocksource has been installed.
pnp: 00:04: iomem range 0xd0000-0xd3fff could not be reserved
pnp: 00:04: iomem range 0xd8000-0xdbfff has been reserved
pnp: 00:04: iomem range 0xfec00000-0xfecfffff could not be reserved
pnp: 00:04: iomem range 0xfee00000-0xfeefffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: ec100000-ec1fffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bus 2, cardbus bridge: 0000:00:0c.0
  IO window: 00001c00-00001cff
  IO window: 00002000-000020ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 34000000-37ffffff
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NTFS driver 2.1.28 [Flags: R/O].
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
ACPI: AC Adapter [ADP0] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (60 C)
Non-volatile memory driver v1.2
8139too Fast Ethernet driver 0.9.28
PCI: Enabling device 0000:00:0a.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
eth0: RealTek RTL8139 at 0xe080a000, 00:90:f5:24:ff:0b, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
pata_sis 0000:00:02.5: version 0.5.1
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.5[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
scsi0 : pata_sis
scsi1 : pata_sis
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011000 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011008 irq 15
ata1.00: ATA-6: FUJITSU MHT2060AT, 009A, max UDMA/100
ata1.00: 117210240 sectors, multi 16: LBA 
ata1.00: configured for UDMA/100
ata2.00: ATAPI: SONY CD-RW/DVD-ROM CRX830E, JYK1, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2060A 009A PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            SONY     CD-RW  CRX830E   JYK1 PQ: 0 ANSI: 5
scsi 1:0:0:0: Attached scsi generic sg1 type 5
PCI: Enabling device 0000:00:03.3 (0000 -> 0002)
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:03.3[D] -> Link [LNKH] -> GSI 9 (level, low) -> IRQ 9
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
PCI: cache line size of 128 is not supported by device 0000:00:03.3
ehci_hcd 0000:00:03.3: irq 9, io mem 0xec004000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKE] -> GSI 11 (level, low) -> IRQ 11
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 11, io mem 0xec001000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:03.1[B] -> Link [LNKF] -> GSI 9 (level, low) -> IRQ 9
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 9, io mem 0xec002000
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:03.2[C] -> Link [LNKG] -> GSI 9 (level, low) -> IRQ 9
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:03.2: irq 9, io mem 0xec003000
usb 1-2: configuration #1 chosen from 1 choice
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usb 2-2: new full speed USB device using ohci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
PCI: Enabling device 0000:00:02.7 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:02.7[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
input: PS/2 Mouse as /class/input/input5
input: AlpsPS/2 ALPS GlidePoint as /class/input/input6
intel8x0_measure_ac97_clock: measured 50494 usecs
intel8x0: clocking to 48000
ALSA device list:
  #0: SiS SI7012 with ALC200,200P at irq 5
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
Using IPI Shortcut mode
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 136k freed
usb 1-2: reset high speed USB device using ehci_hcd and address 2
zd1211rw 1-2:1.0: firmware version 4725
zd1211rw 1-2:1.0: zd1211b chip 0586:3410 v4810 high 00-13-49 AL2230_RF pa0 g---S
zd1211rw 1-2:1.0: eth1
usbcore: registered new interface driver zd1211rw
Adding 497972k swap on /dev/sda8.  Priority:1 extents:1 across:497972k
NTFS volume version 3.1.
SoftMAC: Open Authentication completed with 00:13:49:a0:1e:f9

--------------000101010307060304080400--
