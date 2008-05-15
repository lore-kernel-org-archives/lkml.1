Return-Path: <linux-kernel-owner+w=401wt.eu-S1764518AbYEOTNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764518AbYEOTNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYEOTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:13:09 -0400
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:24694 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764283AbYEOTNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:13:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mlz8GdQpH+eyEBbVhPXclyQDIuITXhrTP/OPaIvIgN9fyVHdny7cyPBAPf1XTscxrzjMt9zq9Fv5vDwLXnaMt0tHJiHLx0wKVXLy1XdOje5cPiG/Z0zbcyEnUvtKhRPFbZ6Ma6+EvonTRMC3k4qr/7KPUwUKfcXwPjnYOwraZiE=;
X-YMail-OSG: PfI4_sAVM1mFJF02OiMMkoSxbkKyTOClTwZgQWlnMjEcoAB1t4a05aPTQZ_IKH7f_IjxcRAgg3bGYNEfUrUIb6bW16Ovnguy.KXYdPcaXVcwPDuOuI0jQQtAIw--
Date: Thu, 15 May 2008 20:06:23 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: 2.6.25.3: serial problem (minicom)
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <7723.10156.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have two Linux boxes connected by a null-modem cable between their serial ports; one box exports
a serial console, which the other reads using the minicom program. However, I have noticed that
minicom can no longer use the serial console when it is running on a 2.6.25.3 kernel, although it
works fine running on a 2.6.24.4 kernel.

Specifically, with minicom running on 2.6.25.3, the console does not accept keystrokes although it
does receive the boot log from the remote machine.

The serial console is being exported by a 2.6.25.3 kernel, and appears to be working correctly.

Here is the dmesg log for the kernel hosting minicom, which is using ttyS0:

Linux version 2.6.25.3 (chris@volcano.underworld) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33))
#1 Sat May 10 14:41:58 BST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 0000000000100000 - 0000000004000000 (usable)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
64MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Entering add_active_range(0, 0, 16384) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    16384
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    16384
On node 0 totalpages: 16384
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 96 pages used for memmap
  Normal zone: 12192 pages, LIFO batch:1
  Movable zone: 0 pages used for memmap
DMI 2.0 present.
Allocating PCI resources starting at 10000000 (gap: 04000000:fbfc0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: BOOT_IMAGE=2.6.25.3 ro root=302 mce video=matroxfb:vesa:0x11A
No local APIC present or hardware disabled
mapped APIC to ffffb000 (01081000)
Initializing CPU#0
CPU 0 irqstacks, hard=c0318000 soft=c0317000
PID hash table entries: 256 (order: 8, 1024 bytes)
Detected 199.433 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 62272k/65536k available (1376k kernel code, 2852k reserved, 590k data, 156k init, 0k
highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
    vmalloc : 0xc4800000 - 0xfffb7000   ( 951 MB)
    lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
      .init : 0xc02ed000 - 0xc0314000   ( 156 kB)
      .data : 0xc0258156 - 0xc02ebc00   ( 590 kB)
      .text : 0xc0100000 - 0xc0258156   (1376 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 399.42 BogoMIPS (lpj=1997102)
Mount-cache hash table entries: 512
Intel Pentium with F0 0F bug - workaround enabled.

Intel old style machine check architecture supported.
Intel old style machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium MMX stepping 03
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
net_namespace: 536 bytes
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd2c1, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
Linux Plug and Play Support v0.97 (c) Adam Belay
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00f9f60
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xa060, dseg 0x400
PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
system 00:08: iomem range 0xe8000-0xfffff could not be reserved
system 00:08: iomem range 0x0-0x9ffff could not be reserved
system 00:08: iomem range 0x100000-0x3ffffff could not be reserved
system 00:08: iomem range 0xfffc0000-0xffffffff could not be reserved
system 00:08: iomem range 0x0-0x0 could not be reserved
system 00:08: iomem range 0x0-0x0 could not be reserved
system 00:08: iomem range 0x0-0x0 could not be reserved
system 00:08: iomem range 0x0-0x0 could not be reserved
system 00:08: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:0e.0
  IO window: f000-ffff
  MEM window: 0xff100000-0xff9fffff
  PREFETCH window: 0x00000000ff000000-0x00000000ff0fffff
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler deadline registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:07.0: Activating ISA DMA hang workarounds
pci 0000:00:0d.0: Boot video device
pci 0000:01:05.0: Firmware left e100 interrupts enabled; disabling
pci 0000:01:04.0: Firmware left e100 interrupts enabled; disabling
pci 0000:00:0f.0: Firmware left e100 interrupts enabled; disabling
matroxfb: Matrox Millennium II (PCI) detected
PInS memtype = 0
matroxfb: 1280x1024x16bpp (virtual: 1280x1638)
matroxfb: framebuffer at 0xFB000000, mapped to 0xc4880000, size 4194304
Console: switching to colour frame buffer device 160x64
fb0: MATROX frame buffer device
isapnp: Scanning for PnP cards...
pnp: SB audio device quirk - increasing port range
isapnp: Card 'Creative ViBRA16C PnP'
isapnp: Card 'U.S. Robotics 56K Voice INT'
isapnp: 2 Plug & Play cards detected total
Generic RTC Driver v1.07
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial: probe of 00:0d failed with error -16
serial 01:02.00: activated
01:02.00: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX3: IDE controller (0x8086:0x7010 rev 0x00) at  PCI slot 0000:00:07.1
PIIX3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xefa0-0xefa7, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0xefa8-0xefaf, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
hda: WDC AC33200L, ATA DISK drive
hdb: WDC AC35100L, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: MWDMA2 mode selected
Probing IDE interface ide1...
hdc: TOSHIBA CD-ROM XM-6002B, ATAPI CD/DVD-ROM drive
hdc: applying conservative PIO "downgrade"
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO2
hdc: MWDMA1 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 6346368 sectors (3249 MB) w/256KiB Cache, CHS=6296/16/63
 hda: hda1 hda2 hda3
hdb: max request size: 128KiB
hdb: 10085040 sectors (5163 MB) w/256KiB Cache, CHS=10672/15/63
hdb: cache flushes not supported
 hdb: hdb1 hdb2 hdb3 hdb4
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
TCP cubic registered
NET: Registered protocol family 1
Using IPI Shortcut mode
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 156k freed
Write protecting the kernel text: 1380k
Write protecting the kernel read-only data: 452k
EXT3 FS on hda2, internal journal
Adding 105832k swap on /dev/hdb3.  Priority:1 extents:1 across:105832k
Adding 105832k swap on /dev/hdb4.  Priority:1 extents:1 across:105832k
Adding 48376k swap on /dev/hda3.  Priority:1 extents:1 across:48376k
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x0000ef80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100: eth0: e100_probe: addr 0xffbeb000, irq 10, MAC addr 00:90:27:76:d0:ec
e100: eth1: e100_probe: addr 0xff0fe000, irq 11, MAC addr 00:03:47:3b:29:5c
e100: eth2: e100_probe: addr 0xff0ff000, irq 10, MAC addr 00:03:47:3b:29:5d
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
e100: eth2: e100_watchdog: link up, 100Mbps, full-duplex
Bridge firewalling registered
br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
device eth1 entered promiscuous mode
device eth2 entered promiscuous mode
br0: port 2(eth2) entering learning state
br0: topology change detected, propagating
br0: port 2(eth2) entering forwarding state
parport_pc 00:0b: reported by Plug and Play BIOS
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
sb16 01:01.00: activated
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
ip6_tables: (C) 2000-2006 Netfilter Core Team
prism2usb_init: prism2_usb.o: 0.2.9 Loaded
prism2usb_init: dev_info is: prism2_usb
usbcore: registered new interface driver prism2_usb
process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
warning: `named' uses 32-bit capabilities (legacy support in use)
process `named' is using obsolete setsockopt SO_BSDCOMPAT
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
hdc: ATAPI 16X CD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
input: PC Speaker as /devices/platform/pcspkr/input/input2

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
