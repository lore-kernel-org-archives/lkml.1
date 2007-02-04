Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbXBDVBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbXBDVBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXBDVBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:01:40 -0500
Received: from reserv6.univ-lille1.fr ([193.49.225.20]:46113 "EHLO
	reserv6.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbXBDVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:01:38 -0500
Message-ID: <45C64960.3080605@tremplin-utc.net>
Date: Sun, 04 Feb 2007 22:00:16 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Wang Zhenyu <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.20-rc7 regression on intel-agp
References: <45C6010A.9010902@tremplin-utc.net> <20070204171850.GA17171@redhat.com>
In-Reply-To: <20070204171850.GA17171@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000803070300060305050707"
X-Greylist: Sender DNS name whitelisted, not delayed by milter-greylist-2.0.2 (reserv6.univ-lille1.fr [193.49.225.20]); Sun, 04 Feb 2007 22:01:08 +0100 (CET)
X-USTL-MailScanner-Information: Please contact the ISP for more information
X-USTL-MailScanner: Found to be clean
X-USTL-MailScanner-From: eric.piel@tremplin-utc.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000803070300060305050707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

04.02.2007 18:18, Dave Jones wrote/a écrit:
> On Sun, Feb 04, 2007 at 04:51:38PM +0100, Eric Piel wrote:
>  > Hello,
>  > 
>  > I've got a regression in 2.6.20-rc7 (-rc6 was fine) due to commit 
>  > 4b95320fc4d21b0ff2f8604305dd6c851aff6096 ([AGPGART] intel_agp: restore 
>  > graphics device's pci space early in resume).
:
> 
> There's an ugly patch below which does the latter. Give it a try?
Thanks a lot, this made the trick... to some extends at least. I can 
suspend to disk and resume fine. The framebuffer is not garble neither, 
however nothing is displayed after resuming :-S Well, it's probably 
enough to be applied before 2.6.20.

Attached is the new dmesg, just in case you are interested.

See you,
Eric

--------------000803070300060305050707
Content-Type: text/plain;
 name="i810-resume-strange.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i810-resume-strange.dmesg"

Linux version 2.6.20-rc7-eric-usbas (eric@circle) (gcc version 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #12 PREEMPT Sun Feb 4 20:39:10 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f400 end: 000000000009f400 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f400 size: 0000000000000c00 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000cc000 size: 0000000000004000 end: 00000000000d0000 type: 2
copy_e820_map() start: 00000000000e4800 size: 000000000001b800 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fd70000 end: 000000001fe70000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fe70000 size: 000000000000fc00 end: 000000001fe7fc00 type: 3
copy_e820_map() start: 000000001fe7fc00 size: 0000000000000400 end: 000000001fe80000 type: 4
copy_e820_map() start: 000000001fe80000 size: 0000000000180000 end: 0000000020000000 type: 2
copy_e820_map() start: 00000000ff800000 size: 0000000000400000 end: 00000000ffc00000 type: 2
copy_e820_map() start: 00000000fff00000 size: 0000000000100000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e4800 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fe70000 (usable)
 BIOS-e820: 000000001fe70000 - 000000001fe7fc00 (ACPI data)
 BIOS-e820: 000000001fe7fc00 - 000000001fe80000 (ACPI NVS)
 BIOS-e820: 000000001fe80000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
510MB LOWMEM available.
Entering add_active_range(0, 0, 130672) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   130672
early_node_map[1] active PFN ranges
    0:        0 ->   130672
On node 0 totalpages: 130672
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 988 pages used for memmap
  Normal zone: 125588 pages, LIFO batch:31
DMI present.
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f6550
ACPI: RSDT (v001 PTLTD  	 RSDT   0x06040000  LTP 0x00000000) @ 0x1fe7b9f3
ACPI: FADT (v001 Acer   TM610    0x06040000 Acer 0x00000001) @ 0x1fe7fb64
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x1fe7fbd8
ACPI: DSDT (v001  INTEL SolanoM2 0x06040000 MSFT 0x0100000d) @ 0x00000000
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 30000000 (gap: 20000000:df800000)
Detected 698.514 MHz processor.
Built 1 zonelists.  Total pages: 129652
Kernel command line: BOOT_IMAGE=2.6.20-rc7-eric-usbas root=LABEL=racine lapic resume=/dev/sda7 video=i810fb:xres:1024,yres:768,hsync1:32,hsync2:48,vsync1:50,vsync2:70,vram:2,bpp:16,mtrr:1
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c03e1000 soft=c03e0000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 514104k/522688k available (1915k kernel code, 7908k reserved, 833k data, 168k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff7000 - 0xfffff000   (  32 kB)
    vmalloc : 0xe0800000 - 0xffff5000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfe70000   ( 510 MB)
      .init : 0xc03b1000 - 0xc03db000   ( 168 kB)
      .data : 0xc02ded89 - 0xc03af534   ( 833 kB)
      .text : 0xc0100000 - 0xc02ded89   (1915 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1398.93 BogoMIPS (lpj=2329490)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Pentium III (Coppermine) stepping 0a
Checking 'hlt' instruction... OK.
Early unpacking initramfs... done
ACPI: Core revision 20060707
ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
ACPI (tbget-0297): Table [DSDT] replaced by host OS [20060707]
ACPI: setting ELCR to 0200 (from 0c00)
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd790, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
PM: Adding info for acpi:acpi
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
Boot video device is 0000:00:02.0
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Firmware left 0000:01:08.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #02 (-#05) is hidden behind transparent bridge #01 (-#01) (try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
PCI: Bus #06 (-#09) is hidden behind transparent bridge #01 (-#01) (try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
PCI: Bus #0a (-#0d) is hidden behind transparent bridge #01 (-#01) (try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:00:1f.4
PM: Adding info for pci:0000:00:1f.5
PM: Adding info for pci:0000:00:1f.6
PM: Adding info for pci:0000:01:06.0
PM: Adding info for pci:0000:01:08.0
PM: Adding info for pci:0000:01:0f.0
PM: Adding info for pci:0000:01:0f.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 7 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 7 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 7 *10 11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 7 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 7 *10 11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
PM: Adding info for pnp:00:0b
pnp: PnP ACPI: found 12 devices
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
libata version 2.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bus 2, cardbus bridge: 0000:01:06.0
  IO window: 00003400-000034ff
  IO window: 00003800-000038ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 3c000000-3fffffff
PCI: Bus 6, cardbus bridge: 0000:01:0f.0
  IO window: 00003c00-00003cff
  IO window: 00001400-000014ff
  PREFETCH window: 34000000-37ffffff
  MEM window: 40000000-43ffffff
PCI: Bus 10, cardbus bridge: 0000:01:0f.1
  IO window: 00002800-000028ff
  IO window: 00002c00-00002cff
  PREFETCH window: 38000000-3bffffff
  MEM window: 44000000-47ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: f4100000-f41fffff
  PREFETCH window: 30000000-3bffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PCI: Enabling device 0000:01:06.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKF] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:01:0f.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt 0000:01:0f.1[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 258k freed
PM: Adding info for platform:pcspkr
Simple Boot Flag at 0x36 set to 0x1
PM: Adding info for No Bus:snapshot
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:1f.2: uhci_check_and_reset_hc: legsup = 0x1f20
pci 0000:00:1f.2: Performing full reset
pci 0000:00:1f.4: uhci_check_and_reset_hc: cmd = 0x00c1
pci 0000:00:1f.4: Performing full reset
PM: Adding info for No Bus:pnp1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
intel_rng: FWH not detected
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel i815 Chipset.
agpgart: detected 4MB dedicated video ram.
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 64M @ 0xf8000000
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PM: Adding info for No Bus:fb0
PM: Adding info for No Bus:vtcon1
Console: switching to colour frame buffer device 128x48
I810FB: fb0         : Intel(R) 815 (Internal Graphics with AGP) Framebuffer Device v0.9.0
I810FB: Video RAM   : 2048K
I810FB: Monitor     : H: 32-48 KHz V: 50-70 Hz
I810FB: Mode        : 1024x768-16bpp@60Hz
PM: Adding info for No Bus:isa
ata_piix 0000:00:1f.1: version 2.00ac7
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/100 cmd 0x1F0 ctl 0x3F6 bmdma 0x1800 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1808 irq 15
scsi0 : ata_piix
PM: Adding info for No Bus:host0
ata1.00: ATA-5, max UDMA/100, 58605120 sectors: LBA 
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/100
scsi1 : ata_piix
PM: Adding info for No Bus:host1
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      IC25N030ATDA04-0 DA4O PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 > sda3 sda4
sd 0:0:0:0: Attached scsi disk sda
PM: Adding info for No Bus:target1:0:0
scsi 1:0:0:0: CD-ROM            MATSHITA UJDA710          1.00 PQ: 0 ANSI: 5
PM: Adding info for scsi:1:0:0:0
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
PM: Adding info for serio:serio0
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio1
mice: PS/2 mouse device common for all mice
PM: Adding info for serio:serio2
TCP cubic registered
NET: Registered protocol family 1
Testing NMI watchdog ... <7>PM: Adding info for serio:serio3
OK.
Using IPI Shortcut mode
swsusp: Resume From Partition /dev/sda7
PM: Checking swsusp image.
PM: Resume from disk failed.
ACPI: (supports S0 S1 S4 S5)
Time: tsc clocksource has been installed.
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 168k freed
Write protecting the kernel read-only data: 671k
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for serio:serio4
input: AT Translated Set 2 keyboard as /class/input/input0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1f.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: detected 2 ports
uhci_hcd 0000:00:1f.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1f.2: Performing full reset
uhci_hcd 0000:00:1f.2: irq 10, io base 0x00001820
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.20-rc7-eric-usbas uhci_hcd
usb usb1: SerialNumber: 0000:00:1f.2
PM: Adding info for usb:usb1
usb usb1: uevent
usb usb1: usb_probe_device
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
PM: Adding info for usb:1-0:1.0
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
PM: Adding info for No Bus:usbdev1.1_ep81
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1f.4[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1f.4: detected 2 ports
uhci_hcd 0000:00:1f.4: uhci_check_and_reset_hc: legsup = 0x2000
uhci_hcd 0000:00:1f.4: Performing full reset
uhci_hcd 0000:00:1f.4: irq 11, io base 0x00001840
usb usb2: default language 0x0409
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.20-rc7-eric-usbas uhci_hcd
usb usb2: SerialNumber: 0000:00:1f.4
PM: Adding info for usb:usb2
usb usb2: uevent
usb usb2: usb_probe_device
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
PM: Adding info for usb:2-0:1.0
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
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
PM: Adding info for No Bus:usbdev2.1_ep81
drivers/usb/core/inode.c: creating file '001'
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
usb usb1: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
hub 1-0:1.0: hub_suspend
usb usb1: suspend_rh
usb usb1: usb auto-suspend
hub 2-0:1.0: hub_suspend
usb usb2: suspend_rh
usb usb2: usb auto-suspend
wistron_btns: BIOS signature found at c00f64f0, entry point 000FDD30
PM: Adding info for platform:wistron-bios
input: Wistron laptop buttons as /class/input/input1
input: PC Speaker as /class/input/input2
speedstep: frequency transition measured seems out of range (7200 nSec), falling back to a safe one of 500000 nSec.
Time: acpi_pm clocksource has been installed.
Synaptics Touchpad, model: 1, fw: 4.6, id: 0x925ea1, caps: 0x80471b/0x0
Yenta: CardBus bridge found at 0000:01:06.0 [12a3:ab01]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:01:06.0, mfunc 0x01000002, devctl 0x60
input: SynPS/2 Synaptics TouchPad as /class/input/input3
Yenta: ISA IRQ mask 0x0000, PCI irq 10
Socket status: 30000059
Yenta: Raising subordinate bus# of parent bus (#01) from #01 to #05
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
cs: IO port probe 0x3000-0x3fff: clean.
pcmcia: parent PCI bridge Memory window: 0xf4100000 - 0xf41fffff
pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x3bffffff
Yenta: CardBus bridge found at 0000:01:0f.0 [1025:1016]
Yenta O2: res at 0x94/0xD4: e8/00
Yenta O2: enabling read prefetch/write burst
Yenta: ISA IRQ mask 0x00b8, PCI irq 11
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#01) from #05 to #09
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
cs: IO port probe 0x3000-0x3fff: clean.
pcmcia: parent PCI bridge Memory window: 0xf4100000 - 0xf41fffff
pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x3bffffff
Yenta: CardBus bridge found at 0000:01:0f.1 [1025:1016]
Yenta: ISA IRQ mask 0x00b8, PCI irq 11
Socket status: 30000410
Yenta: Raising subordinate bus# of parent bus (#01) from #09 to #0d
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
cs: IO port probe 0x3000-0x3fff: clean.
pcmcia: parent PCI bridge Memory window: 0xf4100000 - 0xf41fffff
pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x3bffffff
cs: IO port probe 0x100-0x3af: excluding 0x158-0x15f 0x278-0x27f 0x2f8-0x2ff 0x360-0x367
cs: IO port probe 0x3e0-0x4ff: excluding 0x3f8-0x3ff 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0xf4100000-0xf41fffff: excluding 0xf4100000-0xf410ffff
pcmcia: registering new device pcmcia0.0
PM: Adding info for pcmcia:0.0
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
cs: IO port probe 0x100-0x3af: excluding 0x158-0x15f 0x278-0x27f 0x2f8-0x2ff 0x360-0x367
cs: IO port probe 0x3e0-0x4ff: excluding 0x3f8-0x3ff 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0x100-0x3af: excluding 0x158-0x15f 0x278-0x27f 0x2f8-0x2ff 0x360-0x367
cs: IO port probe 0x3e0-0x4ff: excluding 0x3f8-0x3ff 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
pcmcia: request for exclusive IRQ could not be fulfilled.
pcmcia: the driver needs updating to supported shared IRQ lines.
eth0: Hardware identity 0005:0002:0001:0002
eth0: Station identity  001f:0001:0008:0048
eth0: Firmware determined as Lucent/Agere 8.72
eth0: Ad-hoc demo mode supported
eth0: IEEE standard IBSS ad-hoc mode supported
eth0: WEP supported, 104-bit key
eth0: MAC address 00:02:2D:25:7E:6C
eth0: Station name "HERMES I"
eth0: ready
eth0: orinoco_cs at 0.0, irq 10, io 0x3040-0x307f
ACPI: AC Adapter [AC] (on-line)
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [LNKE] -> GSI 11 (level, low) -> IRQ 11
e100: eth1: e100_probe: addr 0xf4100000, irq 11, MAC addr 00:00:E2:4F:5B:1F
ACPI: Battery Slot [BATA] (battery present)
ACPI: Battery Slot [BATB] (battery absent)
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [LID]
ACPI: CPU0 (power states: C1[C1] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THRM] (42 C)
ACPI: Video Device [GRFX] (multi-head: yes  rom: no  post: no)
pccard: PCMCIA card inserted into slot 2
cs: memory probe 0xf4100000-0xf41fffff: excluding 0xf4100000-0xf411ffff
pcmcia: registering new device pcmcia2.0
PM: Adding info for pcmcia:2.0
EXT3 FS on sda5, internal journal
Adding 546168k swap on /dev/sda7.  Priority:-1 extents:1 across:546168k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
loop: loaded (max 8 devices)
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
nf_conntrack version 0.5.0 (4083 buckets, 32664 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
nf_conntrack version 0.5.0 (4083 buckets, 32664 max)
NET: Registered protocol family 10
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.lo.base_reachable_time; Use net.ipv6.neigh.lo.base_reachable_time_ms instead.
PM: Adding info for No Bus:timer
PCI: Enabling device 0000:00:1f.5 (0000 -> 0001)
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.5 to 64
NET: Registered protocol family 17
intel8x0_measure_ac97_clock: measured 52539 usecs
intel8x0: clocking to 48000
PM: Adding info for No Bus:card0
PM: Adding info for No Bus:pcmC0D1c
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for ac97:0-0:ALC200,200P
PM: Adding info for No Bus:controlC0
PM: Adding info for No Bus:mixer
PM: Adding info for No Bus:adsp
PM: Adding info for No Bus:dsp
PM: Adding info for No Bus:audio
ADDRCONF(NETDEV_UP): eth0: link is not ready
PM: Adding info for No Bus:seq
PM: Adding info for No Bus:sequencer
PM: Adding info for No Bus:sequencer2
pccard: card ejected from slot 0
PM: Removing info for pcmcia:0.0
pccard: card ejected from slot 2
PM: Removing info for pcmcia:2.0
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized i810 1.4.0 20030605 on minor 0
mtrr: base(0xf8000000) is not aligned on a size(0x180000) boundary
[drm] Using v1.4 init.
Stopping tasks ... done.
Shrinking memory...  -done (0 pages freed)
Freed 0 kbytes in 0.04 seconds (0.00 MB/s)
Suspending console(s)
ac97 0-0:ALC200,200P: freeze
wistron-bios wistron-bios: freeze
 usbdev2.1_ep81: PM: suspend 0->1, parent 2-0:1.0 already 2
hub 2-0:1.0: PM: suspend 2-->1
hub 2-0:1.0: PM: suspend 2->1, parent usb2 already 2
 usbdev2.1_ep00: PM: suspend 0->1, parent usb2 already 2
usb usb2: PM: suspend 2-->1
 usbdev1.1_ep81: PM: suspend 0->1, parent 1-0:1.0 already 2
hub 1-0:1.0: PM: suspend 2-->1
hub 1-0:1.0: PM: suspend 2->1, parent usb1 already 2
 usbdev1.1_ep00: PM: suspend 0->1, parent usb1 already 2
usb usb1: PM: suspend 2-->1
i8042 i8042: freeze
sr 1:0:0:0: freeze
sd 0:0:0:0: freeze
pcspkr pcspkr: freeze
pnp 00:0b: freeze
pnp 00:0a: freeze
pnp 00:09: freeze
i8042 aux 00:08: freeze
i8042 kbd 00:07: freeze
pnp 00:06: freeze
pnp 00:05: freeze
pnp 00:04: freeze
pnp 00:03: freeze
system 00:02: freeze
system 00:01: freeze
pnp 00:00: freeze
yenta_cardbus 0000:01:0f.1: freeze
yenta_cardbus 0000:01:0f.0: freeze
e100 0000:01:08.0: freeze
ACPI: PCI interrupt for device 0000:01:08.0 disabled
yenta_cardbus 0000:01:06.0: freeze
pci 0000:00:1f.6: freeze
Intel ICH 0000:00:1f.5: freeze
ACPI: PCI interrupt for device 0000:00:1f.5 disabled
uhci_hcd 0000:00:1f.4: freeze
uhci_hcd 0000:00:1f.4: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1f.4 disabled
uhci_hcd 0000:00:1f.4: --> PCI D0/legacy
pci 0000:00:1f.3: freeze
uhci_hcd 0000:00:1f.2: freeze
uhci_hcd 0000:00:1f.2: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
uhci_hcd 0000:00:1f.2: --> PCI D0/legacy
ata_piix 0000:00:1f.1: freeze
pci 0000:00:1f.0: freeze
pci 0000:00:1e.0: freeze
i810fb 0000:00:02.0: freeze
agpgart-intel 0000:00:00.0: freeze
acpi acpi: freeze
PM: snapshotting memory.
wistron-bios wistron-bios: LATE freeze
i8042 i8042: LATE freeze
pcspkr pcspkr: LATE freeze
yenta_cardbus 0000:01:0f.1: LATE freeze
yenta_cardbus 0000:01:0f.0: LATE freeze
e100 0000:01:08.0: LATE freeze
yenta_cardbus 0000:01:06.0: LATE freeze
pci 0000:00:1f.6: LATE freeze
Intel ICH 0000:00:1f.5: LATE freeze
pci 0000:00:1f.3: LATE freeze
pci 0000:00:1f.0: LATE freeze
pci 0000:00:1e.0: LATE freeze
agpgart-intel 0000:00:00.0: LATE freeze
swsusp: critical section: 
swsusp: Need to copy 48215 pages
swsusp: Normal pages needed: 48215 + 1024 + 14, available pages: 82455
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
agpgart-intel 0000:00:00.0: EARLY resume
i810fb 0000:00:02.0: EARLY resume
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1f.0: EARLY resume
ata_piix 0000:00:1f.1: EARLY resume
uhci_hcd 0000:00:1f.2: EARLY resume
pci 0000:00:1f.3: EARLY resume
uhci_hcd 0000:00:1f.4: EARLY resume
Intel ICH 0000:00:1f.5: EARLY resume
pci 0000:00:1f.6: EARLY resume
yenta_cardbus 0000:01:06.0: EARLY resume
e100 0000:01:08.0: EARLY resume
yenta_cardbus 0000:01:0f.0: EARLY resume
yenta_cardbus 0000:01:0f.1: EARLY resume
pcspkr pcspkr: EARLY resume
i8042 i8042: EARLY resume
wistron-bios wistron-bios: EARLY resume
PM: Image restored successfully.
acpi acpi: resuming
agpgart-intel 0000:00:00.0: resuming
PM: Writing back config space on device 0000:00:02.0 at offset f (was 10b, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset d (was dc, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset b (was 10161025, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 5 (was f4000000, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 4 (was f8000008, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 2 (was 3000011, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 2b00007, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 0 (was 11328086, writing 0)
agpgart: detected 4MB dedicated video ram.
i810fb 0000:00:02.0: resuming
pci 0000:00:1e.0: resuming
PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 22803030, writing 2803030)
PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 40010100, writing 400d0100)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
pci 0000:00:1f.0: resuming
ata_piix 0000:00:1f.1: resuming
PCI: Setting latency timer of device 0000:00:1f.1 to 64
uhci_hcd 0000:00:1f.2: resuming
uhci_hcd 0000:00:1f.2: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1f.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: uhci_resume
uhci_hcd 0000:00:1f.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1f.2: Performing full reset
usb usb1: root hub lost power or was reset
usb usb1: suspend_rh
pci 0000:00:1f.3: resuming
uhci_hcd 0000:00:1f.4: resuming
uhci_hcd 0000:00:1f.4: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1f.4[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: uhci_resume
uhci_hcd 0000:00:1f.4: uhci_check_and_reset_hc: legsup = 0x2000
uhci_hcd 0000:00:1f.4: Performing full reset
usb usb2: root hub lost power or was reset
usb usb2: suspend_rh
Intel ICH 0000:00:1f.5: resuming
PM: Writing back config space on device 0000:00:1f.5 at offset 1 (was 2800000, writing 2800001)
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.5 to 64
pci 0000:00:1f.6: resuming
yenta_cardbus 0000:01:06.0: resuming
PM: Writing back config space on device 0000:01:06.0 at offset f (was 34001ff, writing 5c001ff)
PM: Writing back config space on device 0000:01:06.0 at offset 3 (was 24000, writing 2a808)
pccard: PCMCIA card inserted into slot 0
pcmcia: registering new device pcmcia0.0
PM: Adding info for pcmcia:0.0
pcmcia: request for exclusive IRQ could not be fulfilled.
pcmcia: the driver needs updating to supported shared IRQ lines.
eth1: Hardware identity 0005:0002:0001:0002
eth1: Station identity  001f:0001:0008:0048
eth1: Firmware determined as Lucent/Agere 8.72
eth1: Ad-hoc demo mode supported
eth1: IEEE standard IBSS ad-hoc mode supported
eth1: WEP supported, 104-bit key
eth1: MAC address 00:02:2D:25:7E:6C
eth1: Station name "HERMES I"
eth1: ready
eth1: orinoco_cs at 0.0, irq 10, io 0x3040-0x307f
e100 0000:01:08.0: resuming
PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900113, writing 2900117)
yenta_cardbus 0000:01:0f.0: resuming
PM: Writing back config space on device 0000:01:0f.0 at offset f (was 180010b, writing 580010b)
PM: Writing back config space on device 0000:01:0f.0 at offset 3 (was 824000, writing 82a800)
Yenta O2: res at 0x94/0xD4: e8/00
Yenta O2: enabling read prefetch/write burst
yenta_cardbus 0000:01:0f.1: resuming
PM: Writing back config space on device 0000:01:0f.1 at offset f (was 180010b, writing 580010b)
PM: Writing back config space on device 0000:01:0f.1 at offset 3 (was 824000, writing 82a800)
pccard: PCMCIA card inserted into slot 2
pcmcia: registering new device pcmcia2.0
PM: Adding info for pcmcia:2.0
pnp 00:00: resuming
system 00:01: resuming
system 00:02: resuming
pnp 00:03: resuming
pnp 00:04: resuming
pnp 00:05: resuming
pnp 00:06: resuming
i8042 kbd 00:07: resuming
pnp: Device 00:07 does not support activation.
i8042 aux 00:08: resuming
pnp: Device 00:08 does not support activation.
pnp 00:09: resuming
pnp 00:0a: resuming
pnp 00:0b: resuming
pcspkr pcspkr: resuming
 fb0: PM: resume from 0, parent 0000:00:02.0 still 1
sd 0:0:0:0: resuming
ata1: soft resetting port
sr 1:0:0:0: resuming
ata2: soft resetting port
i8042 i8042: resuming
atkbd serio0: resuming
serio serio1: resuming
serio serio2: resuming
serio serio3: resuming
psmouse serio4: resuming
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: configured for UDMA/33
ata2: EH complete
usb usb1: resuming
usb usb1: usb resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
usb usb1: wakeup_rh
usb usb2: resuming
usb usb2: usb resume
usb usb2: finish resume
hub 2-0:1.0: hub_resume
usb usb2: wakeup_rh
wistron-bios wistron-bios: resuming
ac97 0-0:ALC200,200P: resuming
Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
done.
ADDRCONF(NETDEV_UP): eth2: link is not ready
usb usb1: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
hub 1-0:1.0: hub_suspend
usb usb1: suspend_rh
usb usb1: usb auto-suspend
hub 2-0:1.0: hub_suspend
usb usb2: suspend_rh
usb usb2: usb auto-suspend
PM: Preparing system for standby sleep
Stopping tasks ... done.
Suspending console(s)
ac97 0-0:ALC200,200P: suspend
wistron-bios wistron-bios: suspend
 usbdev2.1_ep81: PM: suspend 0->2, parent 2-0:1.0 already 2
hub 2-0:1.0: PM: suspend 2-->2
hub 2-0:1.0: PM: suspend 2->2, parent usb2 already 2
 usbdev2.1_ep00: PM: suspend 0->2, parent usb2 already 2
usb usb2: PM: suspend 2-->2
 usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
hub 1-0:1.0: PM: suspend 2-->2
hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
 usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
usb usb1: PM: suspend 2-->2
i8042 i8042: suspend
sr 1:0:0:0: suspend
sd 0:0:0:0: suspend
 fb0: PM: suspend 0->2, parent 0000:00:02.0 already 1
pcspkr pcspkr: suspend
pnp 00:0b: suspend
pnp 00:0a: suspend
pnp 00:09: suspend
i8042 aux 00:08: suspend
i8042 kbd 00:07: suspend
pnp 00:06: suspend
pnp 00:05: suspend
pnp 00:04: suspend
pnp 00:03: suspend
system 00:02: suspend
system 00:01: suspend
pnp 00:00: suspend
pcmcia 2.0: suspend
yenta_cardbus 0000:01:0f.1: suspend
yenta_cardbus 0000:01:0f.0: suspend
e100 0000:01:08.0: suspend
orinoco_cs 0.0: suspend
yenta_cardbus 0000:01:06.0: suspend
pci 0000:00:1f.6: suspend
Intel ICH 0000:00:1f.5: suspend
ACPI: PCI interrupt for device 0000:00:1f.5 disabled
uhci_hcd 0000:00:1f.4: suspend
uhci_hcd 0000:00:1f.4: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1f.4 disabled
uhci_hcd 0000:00:1f.4: --> PCI D0/legacy
pci 0000:00:1f.3: suspend
uhci_hcd 0000:00:1f.2: suspend
uhci_hcd 0000:00:1f.2: uhci_suspend
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
uhci_hcd 0000:00:1f.2: --> PCI D0/legacy
ata_piix 0000:00:1f.1: suspend
pci_set_power_state(): 0000:00:1f.1: state=3, current state=5
pci 0000:00:1f.0: suspend
pci 0000:00:1e.0: suspend
i810fb 0000:00:02.0: PM: suspend 1-->2
agpgart-intel 0000:00:00.0: suspend
acpi acpi: suspend
PM: Entering standby sleep
wistron-bios wistron-bios: LATE suspend
i8042 i8042: LATE suspend
pcspkr pcspkr: LATE suspend
yenta_cardbus 0000:01:0f.1: LATE suspend
yenta_cardbus 0000:01:0f.0: LATE suspend
e100 0000:01:08.0: LATE suspend
yenta_cardbus 0000:01:06.0: LATE suspend
pci 0000:00:1f.6: LATE suspend
Intel ICH 0000:00:1f.5: LATE suspend
pci 0000:00:1f.3: LATE suspend
pci 0000:00:1f.0: LATE suspend
pci 0000:00:1e.0: LATE suspend
agpgart-intel 0000:00:00.0: LATE suspend
Back to C!
agpgart-intel 0000:00:00.0: EARLY resume
i810fb 0000:00:02.0: EARLY resume
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1f.0: EARLY resume
ata_piix 0000:00:1f.1: EARLY resume
uhci_hcd 0000:00:1f.2: EARLY resume
pci 0000:00:1f.3: EARLY resume
uhci_hcd 0000:00:1f.4: EARLY resume
Intel ICH 0000:00:1f.5: EARLY resume
pci 0000:00:1f.6: EARLY resume
yenta_cardbus 0000:01:06.0: EARLY resume
e100 0000:01:08.0: EARLY resume
yenta_cardbus 0000:01:0f.0: EARLY resume
yenta_cardbus 0000:01:0f.1: EARLY resume
pcspkr pcspkr: EARLY resume
i8042 i8042: EARLY resume
wistron-bios wistron-bios: EARLY resume
PM: Finishing wakeup.
acpi acpi: resuming
agpgart-intel 0000:00:00.0: resuming
PM: Writing back config space on device 0000:00:02.0 at offset f (was 100, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset d (was dc, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset b (was 10161025, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 8, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 2 (was 3000011, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 2b00004, writing 0)
PM: Writing back config space on device 0000:00:02.0 at offset 0 (was 11328086, writing 0)
agpgart: detected 4MB dedicated video ram.
pci 0000:00:1e.0: resuming
PCI: Setting latency timer of device 0000:00:1e.0 to 64
pci 0000:00:1f.0: resuming
ata_piix 0000:00:1f.1: resuming
PCI: Setting latency timer of device 0000:00:1f.1 to 64
uhci_hcd 0000:00:1f.2: resuming
uhci_hcd 0000:00:1f.2: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1f.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: uhci_resume
pci 0000:00:1f.3: resuming
uhci_hcd 0000:00:1f.4: resuming
uhci_hcd 0000:00:1f.4: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1f.4[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: uhci_resume
uhci_hcd 0000:00:1f.4: uhci_check_and_reset_hc: legsup = 0x2f00
uhci_hcd 0000:00:1f.4: Performing full reset
usb usb2: root hub lost power or was reset
usb usb2: suspend_rh
Intel ICH 0000:00:1f.5: resuming
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.5 to 64
pci 0000:00:1f.6: resuming
yenta_cardbus 0000:01:06.0: resuming
orinoco_cs 0.0: resuming
e100 0000:01:08.0: resuming
PM: Writing back config space on device 0000:01:08.0 at offset f (was 38080100, writing 3808010b)
PM: Writing back config space on device 0000:01:08.0 at offset 5 (was 1, writing 3001)
PM: Writing back config space on device 0000:01:08.0 at offset 4 (was 0, writing f4100000)
PM: Writing back config space on device 0000:01:08.0 at offset 3 (was 0, writing 4208)
PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900000, writing 2900117)
yenta_cardbus 0000:01:0f.0: resuming
Yenta O2: res at 0x94/0xD4: ea/00
Yenta O2: enabling read prefetch/write burst
yenta_cardbus 0000:01:0f.1: resuming
eth2: New link status: Connected (0001)
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
pcmcia 2.0: resuming
pnp 00:00: resuming
system 00:01: resuming
system 00:02: resuming
pnp 00:03: resuming
pnp 00:04: resuming
pnp 00:05: resuming
pnp 00:06: resuming
i8042 kbd 00:07: resuming
pnp: Device 00:07 does not support activation.
i8042 aux 00:08: resuming
pnp: Device 00:08 does not support activation.
pnp 00:09: resuming
pnp 00:0a: resuming
pnp 00:0b: resuming
pcspkr pcspkr: resuming
 fb0: PM: resume from 0, parent 0000:00:02.0 still 1
sd 0:0:0:0: resuming
ata1: soft resetting port
sr 1:0:0:0: resuming
ata2: soft resetting port
i8042 i8042: resuming
atkbd serio0: resuming
serio serio1: resuming
serio serio2: resuming
serio serio3: resuming
psmouse serio4: resuming
ata2.00: configured for UDMA/33
ata2: EH complete
 usbdev1.1_ep00: PM: resume from 0, parent usb1 still 2
 usbdev1.1_ep81: PM: resume from 0, parent 1-0:1.0 still 2
usb usb2: resuming
usb usb2: usb resume
usb usb2: finish resume
hub 2-0:1.0: hub_resume
usb usb2: wakeup_rh
wistron-bios wistron-bios: resuming
ac97 0-0:ALC200,200P: resuming
Restarting tasks ... <7>hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
done.
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
input: AT Translated Set 2 keyboard as /class/input/input7
Synaptics Touchpad, model: 1, fw: 4.6, id: 0x925ea1, caps: 0x80471b/0x0
usb usb2: suspend_rh (auto-stop)
input: SynPS/2 Synaptics TouchPad as /class/input/input8
hub 2-0:1.0: hub_suspend
usb usb2: suspend_rh
usb usb2: usb auto-suspend
eth2: New link status: AP Out of Range (0004)
eth2: no IPv6 routers present
eth2: New link status: AP In Range (0005)

--------------000803070300060305050707--
