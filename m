Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXEFIFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXEFIFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 04:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbXEFIFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 04:05:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35570 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbXEFIFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 04:05:41 -0400
Date: Sun, 6 May 2007 10:03:04 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463D63D8.8010901@interia.pl>
Message-ID: <Pine.LNX.4.61.0705060959200.23047@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
 <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
 <463CE1FB.4050305@interia.pl> <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
 <463D63D8.8010901@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 4.0 points, 6.0 required
	4.0 HOT_NASTY              BODY: Possible porn - Hot, Nasty, Wild, Young
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 6 2007 07:12, Rafał Bilski wrote:

>>> :-/ Weird. Nothing new in datasheet. Longhaul MSR seems to be OK too. 
>>> Would be good to check if PLL really can go downto x4,0. Can You 
>>> limit minimal CPU multiplier to 5,0 and check if is stable? If it 
>>> is check 4,5.
>> 
>> I directly wrote to /sys/devices/system/cpu/cpu0/cpufreq, which
>> worked better than `cpufreq -u xxx -d xxx`.
>> 
>> Lockup after 9 minutes. (Perhaps the longest time so far.)
   [ this was with powersave compiled in and default]

>Can You send me Your entire boot log with performance governor set? 

This is the default kernel with performance gov:

Inspecting /boot/System.map-2.6.21-3-default
Loaded 24898 symbols from /boot/System.map-2.6.21-3-default.
Symbols match kernel version 2.6.21.
No module symbols loaded - kernel modules not enabled.

klogd 1.4.1, log source = ksyslog started.
<5>Linux version 2.6.21-3-default (geeko@buildhost) (gcc version 4.1.3 20070413 (prerelease) (SUSE Linux)) #1 SMP Thu Apr 26 11:49:27 UTC 2007
<6>BIOS-provided physical RAM map:
<4>sanitize start
<4>sanitize end
<4>copy_e820_map() start: 0000000000000000 size: 000000000009f800 end: 000000000009f800 type: 1
<4>copy_e820_map() type is E820_RAM
<4>copy_e820_map() start: 000000000009f800 size: 0000000000000800 end: 00000000000a0000 type: 2
<4>copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
<4>copy_e820_map() start: 0000000000100000 size: 000000000eef0000 end: 000000000eff0000 type: 1
<4>copy_e820_map() type is E820_RAM
<4>copy_e820_map() start: 000000000eff0000 size: 0000000000003000 end: 000000000eff3000 type: 4
<4>copy_e820_map() start: 000000000eff3000 size: 000000000000d000 end: 000000000f000000 type: 3
<4>copy_e820_map() start: 00000000fec00000 size: 0000000001400000 end: 0000000100000000 type: 2
<4> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
<4> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
<4> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<4> BIOS-e820: 0000000000100000 - 000000000eff0000 (usable)
<4> BIOS-e820: 000000000eff0000 - 000000000eff3000 (ACPI NVS)
<4> BIOS-e820: 000000000eff3000 - 000000000f000000 (ACPI data)
<4> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
<5>0MB HIGHMEM available.
<5>239MB LOWMEM available.
<7>Entering add_active_range(0, 0, 61424) 0 entries of 256 used
<4>Zone PFN ranges:
<4>  DMA             0 ->     4096
<4>  Normal       4096 ->    61424
<4>  HighMem     61424 ->    61424
<4>early_node_map[1] active PFN ranges
<4>    0:        0 ->    61424
<7>On node 0 totalpages: 61424
<7>  DMA zone: 32 pages used for memmap
<7>  DMA zone: 0 pages reserved
<7>  DMA zone: 4064 pages, LIFO batch:0
<7>  Normal zone: 447 pages used for memmap
<7>  Normal zone: 56881 pages, LIFO batch:15
<7>  HighMem zone: 0 pages used for memmap
<6>DMI 2.3 present.
<6>Using APIC driver default
<4>ACPI: RSDP 000F7630, 0014 (r0 CM400 )
<4>ACPI: RSDT 0EFF3040, 0028 (r1 CM400  AWRDACPI 42302E31 AWRD        0)
<4>ACPI: FACP 0EFF30C0, 0074 (r1 CM400  AWRDACPI 42302E31 AWRD        0)
<4>ACPI: DSDT 0EFF3180, 5433 (r1 CM400  AWRDACPI     1000 MSFT  100000E)
<4>ACPI: FACS 0EFF0000, 0040
<6>ACPI: PM-Timer IO Port: 0x408
<4>Allocating PCI resources starting at 10000000 (gap: 0f000000:efc00000)
<4>Built 1 zonelists.  Total pages: 60945
<5>Kernel command line: root=/dev/disk/by-id/scsi-SATA_iCreate_CF_Card000000001-part1 rootflags=usrquota,grpquota
<6>No local APIC present or hardware disabled
<7>mapped APIC to ffffd000 (011ea000)
<6>Enabling fast FPU save and restore... done.
<6>Enabling unmasked SIMD FPU exception support... done.
<6>Initializing CPU#0
<4>PID hash table entries: 1024 (order: 10, 4096 bytes)
<4>Detected 733.024 MHz processor.
<4>Console: colour VGA+ 80x25
<4>Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
<4>Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
<6>Memory: 237444k/245696k available (1735k kernel code, 7628k reserved, 721k data, 188k init, 0k highmem)
<4>virtual kernel memory layout:
<4>    fixmap  : 0xffdf5000 - 0xfffff000   (2088 kB)
<4>    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
<4>    vmalloc : 0xcf800000 - 0xff7fe000   ( 767 MB)
<4>    lowmem  : 0xc0000000 - 0xceff0000   ( 239 MB)
<4>      .init : 0xc036e000 - 0xc039d000   ( 188 kB)
<4>      .data : 0xc02b1c67 - 0xc0366374   ( 721 kB)
<4>      .text : 0xc0100000 - 0xc02b1c67   (1735 kB)
<4>Checking if this processor honours the WP bit even in supervisor mode... Ok.
<4>Calibrating delay using timer specific routine.. 1468.17 BogoMIPS (lpj=2936355)
<6>Security Framework v1.0.0 initialized
<4>Mount-cache hash table entries: 512
<7>CPU: After generic identify, caps: 0381b03f 00000000 00000000 00000000 00000000 00000000 00000000
<6>CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
<6>CPU: L2 Cache: 64K (32 bytes/line)
<7>CPU: After all inits, caps: 0381b13f 00000000 00000000 00000000 00000000 000000dd 00000000
<4>Compat vDSO mapped to ffffe000.
<6>Checking 'hlt' instruction... OK.
<6>SMP alternatives: switching to UP code
<6>Freeing SMP alternatives: 12k freed
<6>ACPI: Core revision 20070126
<4>ACPI: setting ELCR to 0200 (from 12a0)
<4>CPU0: Centaur VIA Nehemiah stepping 08
<5>SMP motherboard not detected.
<5>Local APIC not detected. Using dummy APIC emulation.
<6>Brought up 1 CPUs
<6>NET: Registered protocol family 16
<6>ACPI: bus type pci registered
<6>PCI: PCI BIOS revision 2.10 entry at 0xf9f40, last bus=1
<6>PCI: Using configuration type 1
<4>Setting up standard PCI resources
<6>ACPI: Interpreter enabled
<6>ACPI: (supports S0 S1 S4 S5)
<6>ACPI: Using PIC for interrupt routing
<6>ACPI: PCI Root Bridge [PCI0] (0000:00)
<7>PCI: Probing PCI hardware (bus 00)
<6>PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
<6>PCI: MSI-K8T-Neo2Fir, soundcard on
<7>Boot video device is 0000:01:00.0
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<4>ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12)
<4>ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 *12)
<4>ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12)
<4>ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
<4>ACPI: PCI Interrupt Link [ALKA] (IRQs *20), disabled.
<4>ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
<4>ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
<4>ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
<6>Linux Plug and Play Support v0.97 (c) Adam Belay
<6>pnp: PnP ACPI init
<6>pnp: PnP ACPI: found 13 devices
<6>PnPBIOS: Disabled by ACPI PNP
<6>PCI: Using ACPI for IRQ routing
<6>PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
<6>pnp: 00:00: iomem range 0xd0000-0xd3fff has been reserved
<6>pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
<6>pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
<6>Time: tsc clocksource has been installed.
<6>pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
<6>pnp: 00:02: ioport range 0x400-0x47f has been reserved
<6>pnp: 00:02: ioport range 0x500-0x50f has been reserved
<6>PCI: Bridge: 0000:00:01.0
<6>  IO window: disabled.
<6>  MEM window: f4000000-f5ffffff
<6>  PREFETCH window: f0000000-f3ffffff
<7>PCI: Setting latency timer of device 0000:00:01.0 to 64
<6>NET: Registered protocol family 2
<4>IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
<4>TCP established hash table entries: 8192 (order: 4, 98304 bytes)
<4>TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
<6>TCP: Hash tables configured (established 8192 bind 8192)
<6>TCP reno registered
<6>Unpacking initramfs... done
<6>Freeing initrd memory: 2325k freed
<6>audit: initializing netlink socket (disabled)
<5>audit(1178443810.948:1): initialized
<4>Total HugeTLB memory allocated, 0
<5>VFS: Disk quotas dquot_6.5.1
<4>Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
<6>io scheduler noop registered
<6>io scheduler anticipatory registered
<6>io scheduler deadline registered
<6>io scheduler cfq registered (default)
<6>PCI: Bypassing VIA 8237 APIC De-Assert Message
<6>isapnp: Scanning for PnP cards...
<6>isapnp: No Plug & Play device found
<6>Real Time Clock Driver v1.12ac
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
<6>serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
<6>00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>00:0a: ttyS2 at I/O 0x3e8 (irq = 10) is a 16550A
<6>00:0b: ttyS3 at I/O 0x2e8 (irq = 11) is a 16550A
<4>floppy0: no floppy controllers found
<6>input: Macintosh mouse button emulation as /class/input/input0
<6>PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>PNP: PS/2 controller doesn't have AUX irq; using default 12
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>mice: PS/2 mouse device common for all mice
<6>input: PC Speaker as /class/input/input1
<6>NET: Registered protocol family 1
<4>Using IPI No-Shortcut mode
<6>Freeing unused kernel memory: 188k freed
<6>input: AT Translated Set 2 keyboard as /class/input/input2

initramfs begins here.

Creating device nodes with udev
Loading scsi_mod
Loading sd_mod
Loading libata
Loading pata_via
Loading xfs

<5>SCSI subsystem initialized
<7>libata version 2.20 loaded.
<7>pata_via 0000:00:0f.0: version 0.2.1
<4>ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
<7>PCI: setting IRQ 5 as level-triggered
<6>ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
<6>PCI: VIA VLink IRQ fixup for 0000:00:0f.0, from 255 to 5
<6>ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001e000 irq 14
<6>ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001e008 irq 15
<6>scsi0 : pata_via
<6>ata1.00: CFA: iCreate CF Card, g1.01a, max PIO6
<6>ata1.00: 1024128 sectors, multi 0: LBA 
<6>ata1.00: configured for PIO4
<6>scsi1 : pata_via
<4>ATA: abnormal status 0x8 on port 0x00010177
<5>scsi 0:0:0:0: Direct-Access     ATA      iCreate CF Card  g1.0 PQ: 0 ANSI: 5
<5>SCSI device sda: 1024128 512-byte hdwr sectors (524 MB)
<5>sda: Write Protect is off
<7>sda: Mode Sense: 00 3a 00 00
<5>SCSI device sda: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
<5>SCSI device sda: 1024128 512-byte hdwr sectors (524 MB)
<5>sda: Write Protect is off
<7>sda: Mode Sense: 00 3a 00 00
<5>SCSI device sda: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
<6> sda: sda1 sda2
<5>sd 0:0:0:0: Attached scsi removable disk sda
<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
<6>SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
<6>SGI XFS Quota Management subsystem

Waiting for device /dev/disk/by-id/scsi-SATA_iCreate_CF_Card000000001-part1 to appear:  ok
fsck 1.40-WIP (14-Nov-2006)
[/bin/fsck.xfs (1) -- /] fsck.xfs -a /dev/disk/by-id/scsi-SATA_iCreate_CF_Card000000001-part1 
/bin/fsck.xfs: XFS file system.
fsck succeeded. Mounting root device read-write.
Mounting root /dev/disk/by-id/scsi-SATA_iCreate_CF_Card000000001-part1

<5>XFS mounting filesystem sda1
<7>Ending clean XFS mount for filesystem: sda1

/sbin/init begins here.
Starting udevd

<6>Linux agpgart interface v0.102 (c) Dave Jones
<6>agpgart: Detected VIA PM800/PN800/PM880/PN880 chipset
<6>agpgart: AGP aperture is 128M @ 0xe8000000
<6>8139too Fast Ethernet driver 0.9.28
<6>ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
<6>eth0: RealTek RTL8139 at 0xcf820000, 00:14:0b:20:06:9d, IRQ 5
<7>eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
<4>ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 12
<7>PCI: setting IRQ 12 as level-triggered
<6>ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LNKB] -> GSI 12 (level, low) -> IRQ 12
<6>eth1: RealTek RTL8139 at 0xcf838000, 00:14:0b:20:06:9c, IRQ 12
<7>eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<6>usbcore: registered new device driver usb
<6>USB Universal Host Controller Interface driver v3.0
<6>ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
<6>uhci_hcd 0000:00:10.0: UHCI Host Controller
<6>uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
<6>uhci_hcd 0000:00:10.0: irq 5, io base 0x0000dc00
<6>usb usb1: new device found, idVendor=0000, idProduct=0000
<6>usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb1: Product: UHCI Host Controller
<6>usb usb1: Manufacturer: Linux 2.6.21-3-default uhci_hcd
<6>usb usb1: SerialNumber: 0000:00:10.0
<6>usb usb1: configuration #1 chosen from 1 choice
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 2 ports detected
<6>ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
<6>uhci_hcd 0000:00:10.1: UHCI Host Controller
<6>uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
<6>uhci_hcd 0000:00:10.1: irq 5, io base 0x0000dd00
<6>usb usb2: new device found, idVendor=0000, idProduct=0000
<6>usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb2: Product: UHCI Host Controller
<6>usb usb2: Manufacturer: Linux 2.6.21-3-default uhci_hcd
<6>usb usb2: SerialNumber: 0000:00:10.1
<6>usb usb2: configuration #1 chosen from 1 choice
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 2 ports detected
<6>ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [LNKB] -> GSI 12 (level, low) -> IRQ 12
<6>uhci_hcd 0000:00:10.2: UHCI Host Controller
<6>uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
<6>uhci_hcd 0000:00:10.2: irq 12, io base 0x0000de00
<6>usb usb3: new device found, idVendor=0000, idProduct=0000
<6>usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb3: Product: UHCI Host Controller
<6>usb usb3: Manufacturer: Linux 2.6.21-3-default uhci_hcd
<6>usb usb3: SerialNumber: 0000:00:10.2
<6>usb usb3: configuration #1 chosen from 1 choice
<6>hub 3-0:1.0: USB hub found
<6>hub 3-0:1.0: 2 ports detected
<6>ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [LNKB] -> GSI 12 (level, low) -> IRQ 12
<6>uhci_hcd 0000:00:10.3: UHCI Host Controller
<6>uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
<6>uhci_hcd 0000:00:10.3: irq 12, io base 0x0000df00
<6>usb usb4: new device found, idVendor=0000, idProduct=0000
<6>usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb4: Product: UHCI Host Controller
<6>usb usb4: Manufacturer: Linux 2.6.21-3-default uhci_hcd
<6>usb usb4: SerialNumber: 0000:00:10.3
<6>usb usb4: configuration #1 chosen from 1 choice
<6>hub 4-0:1.0: USB hub found
<6>hub 4-0:1.0: 2 ports detected
<4>ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 7
<7>PCI: setting IRQ 7 as level-triggered
<6>ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [LNKC] -> GSI 7 (level, low) -> IRQ 7
<6>ehci_hcd 0000:00:10.4: EHCI Host Controller
<6>ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
<6>ehci_hcd 0000:00:10.4: irq 7, io mem 0xf6002000
<6>ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
<6>usb usb5: new device found, idVendor=0000, idProduct=0000
<6>usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb5: Product: EHCI Host Controller
<6>usb usb5: Manufacturer: Linux 2.6.21-3-default ehci_hcd
<6>usb usb5: SerialNumber: 0000:00:10.4
<6>usb usb5: configuration #1 chosen from 1 choice
<6>hub 5-0:1.0: USB hub found
<6>hub 5-0:1.0: 8 ports detected
<6>rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
<4>rtc_cmos: probe of 00:05 failed with error -16
<6>Adding 1016k swap on /dev/disk/by-id/scsi-SATA_iCreate_CF_Card000000001-part2.  Priority:-1 extents:1 across:1016k
<6>loop: loaded (max 8 devices)
etc.

longhaul is not loaded by default. Loading it gives

longhaul: VIA C3 'Nehemiah C' [C5P] CPU detected.  Powersaver supported.
longhaul: Using northbridge support.
